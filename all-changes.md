Version: 10.0 Stable (v1)
- Инициализация скрипта на уровне системы

Version: 11.0 Stable (v2)
- Увеличение HeapSize
- Принудительная активация LTE-A, AGPS
- Определение частот для LTE и установка типа сети по умолчанию
- Улучшение качества приёма  2G и 3G
- Переопределение TCP/IP = 64MB/3000/3000
- Отключение EAP-SIM патча

Version: 12.0 Stable (v3)
- Переопределение HeapSize под ОЗУ
- Включение проверки ОЗУ
- Активация TCP Fast Open
- Увеличение максимального количества открытых файловых дескрипторов
- Активация и переопределение default настроек для RMEM и WMEM

Version: 13.0 Stable (v4)
- Улучшение ситуации с RSRP, RSRQ, SINR и RSSI
- Оптимизация и исправление band's для сотовых операторов
- Активирован DTM (Dual Transfer Mode)
- Активирован расширенный список сетей (EONS)
- Активирована широкополосная полоса (AMR)
- Увеличен размер памяти, выделяемой на хранение сетевых соединений
- Оптимизирован сетевой стек за счёт перенастройки алгоритма контроля перегрузки TCP и другого типа управления начальной скоростью передачи после простоя
- Улучшено управление размером приёмного и передающего буфера TCP
- Добавлена буферизация на стороне ядра

Version: 14.0 Stable (v5)
- Изменён метод внесения параметров build.prop
- Исправлена работа HeapSize - теперь более гибкая настройка
- Добавлена функция для уменьшения задержки сети
- Установлены новые параметры регистрации GPRS
- Новые параметры буферов сети
- Изменена сетка параметров для IPtables - теперь всё в одной функции для облегчения процесса и его ускорения
- Добавлен обработчик ошибок уровня 01x(xx)
- Добавлен фикс ошибки для владельцев устройств Pixel с процессорами Tensor, теперь не должно кидать в Bootloop. Требуются тесты:)

Version: 101.0 DevFixTest (v6)
- Оптимизирован код
- Исправлены некоторые ошибки, приводящие к бесконечному запуску Magisk, App Manager, а также вылета YouTube.

Version: 101.1 DevFixTest (v6.1)
- Изменён алгоритм выявления Tensor
- Мелкие доработки

Version: 17.0 Stable (v7)
- Полностью изменён алгоритм выявления Tensor
- Мелкие доработки
- Улучшен метод внесения изменений в IPTables
- Добавлены экраны типажа "защита от дурака"
- Включена чистка кэша Wi-Fi

Version: 102.1 DevFixTest (8.0)
- Изменён сетевой MTU (Maximum Transmission Unit) на продвинутое обнаружение
- Изменено управление таймаутом (в секундах) для закрытия соединения в состоянии FIN-WAIT-2
- Закрыты дыры в безопасности использования функции Check CONNMARK
- Цепочка MARK выбита переписана под использование функции

Version: 102.2 DevFixTest (8.1)
- Переработка активации LTE-A, A-GPS
- Активирован строгий режим LTE
- Активированы LTE Advanced команды для модема

Version: 102.3 DevFixTest (8.2)
- По просьбе нескольких людей включено использование MSAA по умолчанию
- Включён AKF (Automatic Kernel Fix) для автоматической перезагрузки устройства в случае возникновения критических ошибок ядра
- Добавлена функция для изменения TTL на рандомное значение 

Version: 18.0 Stable (v8.1)
- Изменён сетевой MTU (Maximum Transmission Unit) на продвинутое обнаружение
- Изменено управление таймаутом (в секундах) для закрытия соединения в состоянии FIN-WAIT-2
- Закрыты дыры в безопасности использования функции Check CONNMARK
- Цепочка MARK переписана под использование функции
- Переработка активации LTE-A, A-GPS
- Пересобран строгий режим LTE
- Активированы LTE Advanced команды для модема
- По просьбе нескольких людей включено использование MSAA по умолчанию
- Включён AKF (Automatic Kernel Fix) для автоматической перезагрузки устройства в случае возникновения критических ошибок ядра
- Добавлена функция для изменения TTL на рандомное значение

Version: 19.0 Stable (v9)
- LAA (Licensed Assisted Access): Включено использование нелицензированного спектра для улучшения своей производительности.
- CA (Carrier Aggregation): Активированы агрегации нескольких носителей.
- MIMO (Multiple-Input Multiple-Output): Включено использование четырёх антенн для передачи и приема данных, что позволяет повысить производительность и улучшить качество связи в сетях LTE
- RxDiv (Receiver Diversity): Включено управление разделением сигнала приемника для улучшения приема сигнала в мобильной среде.
- MACAR (MAC Address Random): Изменение MAC адреса устройства на рандомное каждые 10 минут
- TTLRV (TTL Random Value): Изменение TTL устройства на рандомное каждые 10 минут
- LTEAA (Aggregation Added): Добавлена функция для определения максимального значения агрегаций и их добавления
- Удалены не работающие на большинстве устройствах CONNMARK цепи
- Удалены не используемые цепи MARK / 1x0B2
- Упростён код для функции чистки кэша WiFi
- Добавлена чистка кэша Bluetooth и объединена с функцией чистки кэша WiFi (на некоторых устройствах по неведомой мне причине кэш Bluetooth мешал нормальной работе чистильщику WiFi

Version: 20.0 Stable (v10)
- По причине конфликта сетевых интерфейсов с некоторыми приложениями включая Magisk, NetCam, YouTube и т.д. удалена функция MACAR
- Изучив более тщательно некоторые сетевые особенности андроид функция изменения TTL была пересобрана под работу с определёнными SDK начиная с SDK 29 и выше
- Heapsize отныне подстраивается не только под объём ОЗУ. Теперь функция стала более умной и определяет бренд устройства без учёта регистра и подстраивает после этого определённый размер Heapsize под конкретного производителя с объёмом ОЗУ


Version: 20.1 Stable (v10.1 Fix)
- Выпилены алгоритмы исчезновения DDTR
- Обновлены логические параметры Heapsize
- Обновлены логические параметры TTL
- Обновлены логические параметры под BusyBox
- Обновлён prop файл
- Пересобрана логическая составляющая Heapsize
- Пересобрана логическая составляющая TTL
- Возвращена функция MACAR с обновлённой логической структурой рандомизации

Version: 21.0 Stable Final (v11)
- Правка адресов и маршрутов
- Починка известных багов: пропадание WiFi, OnePlus'овские и Oppo/Vivo/Samsung'овские фокусы с Magisk/Kernel SU/Kitsune Magisk/APatch
- Выпилен BusyBox и функции под него в пользу универсальности