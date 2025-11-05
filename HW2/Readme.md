Домашнее задание: работа с mdadm

Задание:
• Добавить в виртуальную машину несколько дисков
• Собрать RAID-0/1/5/10 на выбор
• Сломать и починить RAID
• Создать GPT таблицу, пять разделов и смонтировать их в системе.

На проверку отправьте:
● скрипт для создания рейда
● отчет по командам для починки RAID и созданию разделов


===================СОЗДАНИЕ RAID===========================

chmod +x create_raid.sh
sudo ./create_raid.sh -l 5 -d "/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf" -y

cat /proc/mdstat  # проверка состояния массива


===================ПОЧИНКА RAID===========================

cat /proc/mdstat  # вывод информации о состоянии raid-массива
mdadm /dev/md0 --remove /dev/sde  # "горячее" удаление диска из массива 
mdadm /dev/md0 --add /dev/sde     # добавление другого диска в raid 

!!!!!!!!! Диск должен пройти стадию rebuilding. 
Например, если это был RAID-1 (зеркало), то данные должны скопироваться на новый диск. !!!!!!!!!

Процесс пересборки можно увидеть с помощью уже известной команды:
cat /proc/mdstat


===================СОЗДАНИЕ РАЗДЕЛОВ======================

parted -s /dev/md0 mklabel gpt  # создание раздела GPT на рейде
parted -s /dev/md0 mkpart primary ext4 0% 20%
parted -s /dev/md0 mkpart primary ext4 20% 40%
parted -s /dev/md0 mkpart primary ext4 40% 60%
parted -s /dev/md0 mkpart primary ext4 60% 80%
parted -s /dev/md0 mkpart primary ext4 80% 100%

for i in $(seq 1 5); do
  mkfs.ext4 /dev/md0p$i
  mkdir -p /mnt/raid/part$i
  mount /dev/md0p$i /mnt/raid/part$i
done

lsblk
df -hT | grep md0


===================ПРОВЕРКА===============================

cat /proc/mdstat
mdadm --detail /dev/md0
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT


===================ИТОГ==================================

RAID успешно создан и проверен  
Выполнена поломка и починка массива  
Создана GPT-разметка с 5 разделами  
Все разделы смонтированы в систему
