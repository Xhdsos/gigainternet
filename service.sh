#!/system/bin/sh

LOG_FILE="/data/local/tmp/gigalog.txt"
printf "\n" >> $LOG_FILE
date | tee -a $LOG_FILE

#################
# Проверяем доступные агрегации LTE
available_aggregations=$(settings get global aggregated_lte_ca_config)
settings put global aggregated_lte_ca_config "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100"
echo "Новые агрегационные типажы были успешно добавлены"
echo "Текущее количество агрегаций LTE: $(echo $available_aggregations | awk -F',' '{print NF}')"
#################

################
# Установка параметров регистрации GPRS
settings put global gprs_registration_refresh_rate 30 | tee -a $LOG_FILE
settings put global gprs_service_refresh_rate 30 | tee -a $LOG_FILE
################

#################
# Функция для изменения TTL
function check_sdk_version() {
  SDK_VERSION=$(getprop ro.build.version.sdk)
  if [[ -z "$SDK_VERSION" ]]; then
    echo "Не удалось получить версию SDK"
    return 1
  fi
  if [[ "$SDK_VERSION" -ge 29 && "$SDK_VERSION" -le 32 ]]; then
    change_ttl_sdk_down
  elif [[ "$SDK_VERSION" -gt 32 ]]; then
    change_ttl_sdk_up
  else
    echo "Неизвестная версия SDK: $SDK_VERSION"
    return 1
  fi
}
function change_ttl_sdk_down() {
  NEW_TTL=$(shuf -i 65-75 -n 1)
  echo $NEW_TTL | tee /proc/sys/net/ipv4/ip_default_ttl > /dev/null
  echo "TTL изменен на $NEW_TTL для устройства с SDK версии от 29 до 32"
}
function change_ttl_sdk_up() {
  NEW_TTL=$(shuf -i 65-95 -n 1)
  echo $NEW_TTL | tee /proc/sys/net/ipv4/ip_default_ttl > /dev/null
  echo "TTL изменен на $NEW_TTL для устройства с SDK версии выше 32"
}
check_sdk_version
#################

#################
# Увеличение HeapSize
function determine_brand() {
  BRAND=$(getprop ro.product.brand)
  lowercase_brand=$(echo "$BRAND" | tr '[:upper:]' '[:lower:]')
  if [ "$lowercase_brand" == "xiaomi" ] || [ "$lowercase_brand" == "oppo" ] || [ "$lowercase_brand" == "realme" ] || [ "$lowercase_brand" == "poco" ] || [ "$lowercase_brand" == "honor" ] || [ "$lowercase_brand" == "motorola" ] || [ "$lowercase_brand" == "huawei" ] || [ "$lowercase_brand" == "doogee" ] || [ "$lowercase_brand" == "ulefone" ] || [ "$lowercase_brand" == "infinix" ] || [ "$lowercase_brand" == "tcl" ] || [ "$lowercase_brand" == "tecno" ]; then
    decrease_heapsize_crystall
  elif [ "$lowercase_brand" == "samsung" ] || [ "$lowercase_brand" == "redmi" ] || [ "$lowercase_brand" == "sony" ] || [ "$lowercase_brand" == "zte" ] || [ "$lowercase_brand" == "asus" ] || [ "$lowercase_brand" == "google" ] || [ "$lowercase_brand" == "oneplus" ]; then
    decrease_heapsize_crystalls
  else
    echo "Неизвестный бренд устройства: $BRAND"
  fi
}

function decrease_heapsize_crystall() {
  TOTAL_RAM=$(grep "MemTotal" /proc/meminfo | awk '{print $2}')
  if [ $TOTAL_RAM -lt 2097152 ]; then
    HEAP_SIZE="64m"
  elif [ $TOTAL_RAM -lt 4194304 ]; then
    HEAP_SIZE="128m"
  elif [ $TOTAL_RAM -lt 6291456 ]; then
    HEAP_SIZE="256m"
  elif [ $TOTAL_RAM -lt 8388608 ]; then
    HEAP_SIZE="512m"
  elif [ $TOTAL_RAM -lt 10485760 ]; then
    HEAP_SIZE="512m"
  elif [ $TOTAL_RAM -lt 12582912 ]; then
    HEAP_SIZE="512m"
  elif [ $TOTAL_RAM -lt 14680064 ]; then
    HEAP_SIZE="1024m"
  elif [ $TOTAL_RAM -lt 16777216 ]; then
    HEAP_SIZE="1024m"
  else
    HEAP_SIZE="1024m"
  fi
  echo "Установлено значение dalvik.vm.heapsize в $HEAP_SIZE"
  echo "dalvik.vm.heapsize=$HEAP_SIZE" >> $LOG_FILE
  setprop dalvik.vm.heapsize "$HEAP_SIZE" 
}

function decrease_heapsize_crystalls() {
  TOTAL_RAM=$(grep "MemTotal" /proc/meminfo | awk '{print $2}')
  if [ $TOTAL_RAM -lt 2097152 ]; then
    HEAP_SIZE="128m"
  elif [ $TOTAL_RAM -lt 4194304 ]; then
    HEAP_SIZE="256m"
  elif [ $TOTAL_RAM -lt 6291456 ]; then
    HEAP_SIZE="512m"
  elif [ $TOTAL_RAM -lt 8388608 ]; then
    HEAP_SIZE="512m"
  elif [ $TOTAL_RAM -lt 10485760 ]; then
    HEAP_SIZE="512m"
  elif [ $TOTAL_RAM -lt 12582912 ]; then
    HEAP_SIZE="512m"
  elif [ $TOTAL_RAM -lt 14680064 ]; then
    HEAP_SIZE="1024m"
  elif [ $TOTAL_RAM -lt 16777216 ]; then
    HEAP_SIZE="1024m"
  else
    HEAP_SIZE="1024m"
  fi
  echo "Установлено значение dalvik.vm.heapsize в $HEAP_SIZE"
  echo "dalvik.vm.heapsize=$HEAP_SIZE" >> $LOG_FILE
  setprop dalvik.vm.heapsize "$HEAP_SIZE" 
}

determine_brand
################

################
# Оптимизация TCP/IP
sysctl -w net.ipv4.tcp_tw_reuse=1
sysctl -w net.ipv4.tcp_window_scaling=1
sysctl -w net.ipv4.tcp_sack=1
sysctl -w net.ipv4.tcp_timestamps=1
sysctl -w net.ipv4.tcp_fin_timeout=15
sysctl -w net.ipv4.tcp_mtu_probing=2
sysctl -w net.ipv4.tcp_max_syn_backlog=8192
sysctl -w net.core.rmem_default=50331648
sysctl -w net.core.rmem_max=67108864
sysctl -w net.core.wmem_default=50331648
sysctl -w net.core.wmem_max=67108864
sysctl -w net.core.netdev_max_backlog=300
sysctl -w fs.file-max=65535
sysctl -w net.ipv4.tcp_fastopen=3
sysctl -w net.core.somaxconn=16384
sysctl -w net.ipv4.tcp_slow_start_after_idle=0
sysctl -w net.ipv4.tcp_rmem="8192 174760 349520"
sysctl -w net.ipv4.tcp_wmem="8192 131072 262144"
sysctl -w kernel.panic_on_oops=1
################

################
# Включение 4x MSAA
# setprop debug.egl.hw.msaa 1
################

date | tee -a $LOG_FILE

################
# GODMODE для скрипта
chmod +x /data/adb/modules/gigainternet/service.sh