MODNAME="GigaInternet - v7"
DEVNAME="Magellan, Flipper, Гоша"
MODREQ="BusyBox and Magisk 23+"
MODAND="11"
DEVLINK="@Magellan715"

echo ""

rm -rf /data/local/tmp/gigalog.txt
# printf "\n" >> $LOG_FILE
LOG_FILE="/data/local/tmp/gigalog.txt"

# Преобразование версии в числовое значение для сравнения
current_version=$(getprop ro.build.version.release)
MODAND_NUM=$(echo "$MODAND" | awk -F'.' '{ printf("%d%02d", $1, $2); }')
current_version_NUM=$(echo "$current_version" | awk -F'.' '{ printf("%d%02d", $1, $2); }')

sleep 2
echo " • Запускаю проверку" | tee -a $LOG_FILE
# Проверка версии Android
echo " • Проверка версии Android" | tee -a $LOG_FILE
if [ "$current_version_NUM" -lt "$MODAND_NUM" ]; then
  echo " • Ошибка: Версия Android не подходит" | tee -a $LOG_FILE
  exit 1
fi

sleep 2
# Определение объема ОЗУ в гигабайтах
total_ram_kb=$(cat /proc/meminfo | grep "MemTotal" | tr -s ' ' | cut -d ' ' -f 2)
total_ram_gb=$(echo "scale=2; ${total_ram_kb} / (1024 * 1024)" | bc)
echo " • Определяю объём ОЗУ: ${total_ram_gb} Gb" | tee -a $LOG_FILE
  
sleep 2
# Проверка наличия утилиты BusyBox
echo " • Проверка наличия BusyBox" | tee -a $LOG_FILE
if [ "$(id -u)" -eq "0" ]; then
  if ! which busybox > /dev/null; then
    echo " • Ошибка: Не найден BusyBox" | tee -a $LOG_FILE
    exit 1
  fi
fi

sleep 2
# Проверка наличия модуля ядра CONNMARK
echo " • Поиск модуля CONNMARK"
if lsmod | grep -q "CONNMARK"; then
echo " • Модуль CONNMARK найден" | tee -a $LOG_FILE
else
echo " • Модуль CONNMARK не найден" | tee -a $LOG_FILE
fi

sleep 2
# Функция для поиска и проверки аргументов в строке ro.soc.manufacturer
#echo " • Проверка на Google Tensor" | tee -a $LOG_FILE
#prop_file="/vendor/build.prop"
#if grep -q "ro.soc.manufacturer=Google" "$prop_file"; then
#  echo "Ошибка: Установка основных компонентов невозможна, у вас Tensor Processor" | tee -a $LOG_FILE
#  exit 1  # Запрет установки модуля
#fi
TENSORCHECK="Tensor\|Tensor G2\|Tensor G3\|Tensor G4\|GS201"
echo " • Проверка на Google Tensor"
if grep -Eq "ro.soc.model=($TENSORCHECK)" /vendor/build.prop && grep -Eq "ro.soc.model=($TENSORCHECK)" /system/build.prop; then
  echo " • Ошибка: Обнаружен Tensor, обнуляю установку модуля"
  exit 1  # Запрет установки модуля
fi

sleep 2
echo " • Все проверки пройдены, начинаю установку" | tee -a $LOG_FILE

sleep 2
echo ""
echo " • Устройство      : $(getprop ro.product.name) | $(getprop ro.product.system.model) | $(getprop ro.product.system.brand) "
echo " • Версия SoC      : $(getprop ro.product.board) "
echo " • Версия Android  : $(getprop ro.build.version.release) | SDK: $(getprop ro.build.version.sdk)"
echo " • Версия ABI      : $(getprop ro.product.cpu.abi) "
echo " • Процессор       : $(getprop ro.soc.model) "
echo " • ПЗУ             : $(getprop ro.build.display.id) "
echo " • Ядро            : $(uname -r) "
echo ""

sleep 2
echo " • Оптимизация TCP/IP"
echo " • Калибровка трафика"
echo " • Оптимизация Wi-Fi"
echo " • Корректировка IPTables"
echo " • Оптимизация RSRP, RSRQ, SINR и RSSI"
echo " • Включение DTL, EONS и AMR"
echo " • Оптимизация сетевого стека"
echo " • Изменение управления размером приёмного и передающего буфера TCP"
echo " • Переопределение HeapSize под ОЗУ"
echo " • Активация TCP Fast Open"
echo " • Активация и переопределение default настроек для RMEM и WMEM"
echo " • Увеличение максимального количества открытых файловых дескрипторов"
echo " • Принудительная активация LTE-A, AGPS"
echo " • Отключение EAP-SIM патча"
echo " • Скрипт успешно выполнил свою работу"
echo " • Завершение установки"

sleep 5
echo ""
echo ""
echo ""
echo " | Информационный блок"
echo " |"
echo " | Этот модуль старается улучшить"
echo " | подключение к сети и увеличивает"
echo " | скорость интернета на вашем телефоне"
echo " |"
echo " | Чтобы избежать проблем при"
echo " | загрузке операционной системы, "
echo " | установите модуль Bootloop Protector"
echo ""
echo " | • Разработчики:      $DEVNAME"
echo " | • Требования:        $MODREQ"
echo " | • Telegram:          $DEVLINK"
echo ""
echo " | Отдельная благодарность за помощь в разработке и тестировании"
echo " | @zerxfox, @notxhdsos, @lowriddr, @OlegVapnik, @venlys"
echo ""
echo ""
echo ""