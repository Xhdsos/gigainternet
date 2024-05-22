#!/system/bin/sh

LOG_FILE="/data/local/tmp/gigalog.txt"
printf "\n" >> $LOG_FILE
date | tee -a $LOG_FILE

echo "Запрос на установку модуля получен" | tee -a $LOG_FILE

# Чистка кэшей WiFi
clean_wifi_logs() {
    # Проверяем наличие устройства
    if [ -e /system/bin/su ]; then
        # Очищаем логи WiFi
        /system/bin/su -c "logcat -c -b all"
        echo "Логи WiFi очищены" | tee -a $LOG_FILE
    else
        echo "Ошибка: 01x01" | tee -a $LOG_FILE
    fi
}
clean_wifi_logs

# New: 14.0 Stable
reduce_mobile_network_latency() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Ошибка: Необходимы root-права для выполнения этой функции." | tee -a $LOG_FILE
        return 1
    fi
    echo "1" > /proc/sys/net/ipv4/tcp_low_latency | tee -a $LOG_FILE
    
    # Уменьшение задержки для 2G сети
    # echo "50" > /sys/module/something/something/something
    # Уменьшение задержки для 3G сети
    # echo "100" > /sys/module/something/something/something
    return 0
}
reduce_mobile_network_latency && echo "УЗСС: True" || echo "УЗСС: False" | tee -a $LOG_FILE

# New: 14.0 Stable
# Установка параметров регистрации GPRS
settings put global gprs_registration_refresh_rate 10 | tee -a $LOG_FILE
settings put global gprs_service_refresh_rate 10 | tee -a $LOG_FILE

# Оптимизация TCP/IP
sysctl -w net.ipv4.tcp_window_scaling=1
sysctl -w net.ipv4.tcp_sack=1
sysctl -w net.ipv4.tcp_timestamps=1
sysctl -w net.ipv4.tcp_fin_timeout=15
sysctl -w net.ipv4.tcp_congestion_control=bbr
sysctl -w net.ipv4.tcp_mtu_probing=2
sysctl -w net.ipv4.tcp_max_syn_backlog=8192
sysctl -w net.core.rmem_default=50331648
sysctl -w net.core.rmem_max=67108864
sysctl -w net.core.wmem_default=50331648
sysctl -w net.core.wmem_max=67108864
sysctl -w net.core.netdev_max_backlog=300
    # New: 12.0 Stable
sysctl -w fs.file-max=65535
sysctl -w net.ipv4.tcp_fastopen=3
    # New: 13.0 Stable
sysctl -w net.core.somaxconn=16384
sysctl -w net.ipv4.tcp_slow_start_after_idle=0
sysctl -w net.ipv4.tcp_rmem="8192 174760 349520"
sysctl -w net.ipv4.tcp_wmem="8192 131072 262144"

# Увеличение HeapSize
# New: 12.0 Stable > Update 14.0 Stable
TOTAL_RAM=$(grep "MemTotal" /proc/meminfo | awk '{print $2}')
if [ $TOTAL_RAM -lt 2097152 ]; then
  HEAP_SIZE="256m" | tee -a $LOG_FILE
elif [ $TOTAL_RAM -ge 4194304 ]; then
  HEAP_SIZE="512m" | tee -a $LOG_FILE
else
  HEAP_SIZE="1024m" | tee -a $LOG_FILE
fi
setprop dalvik.vm.heapsize "$HEAP_SIZE" | tee -a $LOG_FILE

# Устанавливаем параметры iptables для минимизации задержки Wi-Fi
iptables -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -t mangle -I POSTROUTING -o wlan+ -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

# Применяем настройки
iptables -t mangle -P POSTROUTING ACCEPT

# Проверка наличия модуля ядра CONNMARK
check_connmark_module() {
  if lsmod | grep -q "CONNMARK"; then
    echo "Модуль CONNMARK установлен, выполняем установку скрипта"
    # Добавьте сюда код для выполнения установки скрипта, если модуль установлен
    
create_mark_chain() {
    if ! iptables -t mangle -L | grep -q mark; then
        if ! iptables -t mangle -N mark; then
            echo "Ошибка при создании цепочки mark" >&2
            exit 1
        fi
    fi
}
create_mark_chain

    # Проверяем существование правила для wlan+
    if ! iptables -t mangle -C POSTROUTING -o wlan+ -p tcp --sport 443 -j MARK --set-mark 0x1 2>/dev/null; then
      iptables -t mangle -A POSTROUTING -o wlan+ -p tcp --sport 443 -j MARK --set-mark 0x1
    fi

    # Проверяем существование правила для rmnet_data0
    if ! iptables -t mangle -C POSTROUTING -o rmnet_data[0-5] -p tcp --sport 80 -j MARK --set-mark 0x2 2>/dev/null; then
      iptables -t mangle -A POSTROUTING -o rmnet_data[0-5] -p tcp --sport 80 -j MARK --set-mark 0x2
    fi
  else
    echo "Модуль CONNMARK не установлен, не выполняем установку скрипта"
    # Добавьте сюда код для выполнения действий, если модуль не установлен
  fi
}
check_connmark_module

# Добавление правил iptables при загрузке
if [ -f /data/iptables.rules ]; then
iptables-restore < /data/iptables.rules
fi

date | tee -a $LOG_FILE