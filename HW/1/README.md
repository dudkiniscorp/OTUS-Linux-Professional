# OTUS. Домашнее задание №1 — Обновление ядра системы

## Цель
Запустить ВМ с Ubuntu, обновить ядро ОС до новейшей стабильной версии из mainline-репозитория и зафиксировать результат.

---

## Описание процесса

Работа выполнялась в среде **Windows Subsystem for Linux (WSL2)** на базе Ubuntu 22.04.

---

### 1. Подготовка системы и установка скрипта

Сначала обновляем пакеты и устанавливаем утилиты для загрузки скрипта:

```bash
sudo apt update
sudo apt install -y wget curl ca-certificates
cd /usr/local/bin
```
## Затем скачиваем и устанавливаем скрипт ubuntu-mainline-kernel.sh, который позволяет автоматически скачивать и устанавливать ядра из mainline-репозитория Ubuntu
```bash
sudo wget -O ubuntu-mainline-kernel.sh https://raw.githubusercontent.com/pimlie/ubuntu-mainline-kernel.sh/master/ubuntu-mainline-kernel.sh
sudo chmod +x ubuntu-mainline-kernel.sh
```
### 2. Проверка последней версии и установка нового ядра
Проверяем, какая версия доступна, и выполняем установку:
```bash
sudo ./ubuntu-mainline-kernel.sh -r
sudo ./ubuntu-mainline-kernel.sh -i
```
Во время выполнения команда загрузила и установила пакеты ядра 6.17.7-061707-generic
```bash
Downloading amd64/linux-headers-6.17.7-061707-generic_6.17.7-061707.202511021342_amd64.deb: 100%
Downloading amd64/linux-headers-6.17.7-061707_6.17.7-061707.202511021342_all.deb: 100%
Downloading amd64/linux-image-unsigned-6.17.7-061707-generic_6.17.7-061707.202511021342_amd64.deb: 100%
Downloading amd64/linux-modules-6.17.7-061707-generic_6.17.7-061707.202511021342_amd64.deb: 100%
Importing kernel-ppa gpg key ok
Signature of checksum file has been successfully verified
Checksums of deb files have been successfully verified with sha256sum
Installing 4 packages
Cleaning up work folder
```

### 3. Проверка версии активного ядра
После установки ядра проверяем активное ядро:
```bash
uname -r
5.10.16.3-microsoft-standard-WSL2
```

Примечание (WSL2)
⚠️ Среда WSL2 использует встроенное ядро Microsoft (microsoft-standard-WSL2),
которое поставляется вместе с Windows и не обновляется изнутри подсистемы.
Поэтому, хотя установка нового ядра прошла успешно, фактическая загрузка в него невозможна.

```bash
root@BRV-WN-000483:/usr/local/bin# ls -al /boot
total 28008
drwxr-xr-x  2 root root     4096 Nov  5 06:19 .
drwxr-xr-x 19 root root     4096 Nov  5 06:15 ..
-rw-------  1 root root 11301148 Nov  2 16:43 System.map-6.17.7-061707-generic
-rw-r--r--  1 root root   302491 Nov  2 16:43 config-6.17.7-061707-generic
-rw-------  1 root root 17060031 Nov  2 16:43 vmlinuz-6.17.7-061707-generic
```
