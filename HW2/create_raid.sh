#!/bin/bash
set -euo pipefail

usage() {
  cat <<EOF
Использование: $0 [опции]

Опции:
  -l, --level <N>      Уровень RAID (по умолчанию 6)
  -n, --parts <N>      Число устройств (если не указано — определяется автоматически)
  -d, --devices <list> Список устройств (по умолчанию: /dev/sd{b..f})
  -y, --yes            Не спрашивать подтверждение
  -h, --help           Показать это сообщение
EOF
}

RAID_LEVEL=6
DEVICES_DEFAULT=(/dev/sd{b..f})
DEVICES=("${DEVICES_DEFAULT[@]}")
NUM_PARTS=""
ASK_CONFIRM=1
MD_DEV=/dev/md0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -l|--level) RAID_LEVEL="$2"; shift 2;;
    -n|--parts) NUM_PARTS="$2"; shift 2;;
    -d|--devices) read -r -a DEVICES <<< "$2"; shift 2;;
    -y|--yes) ASK_CONFIRM=0; shift;;
    -h|--help) usage; exit 0;;
    *) echo "Неизвестная опция: $1"; usage; exit 2;;
  esac
done

[[ $EUID -eq 0 ]] || { echo "Нужно запускать от root."; exit 1; }
command -v mdadm >/dev/null 2>&1 || { echo "mdadm не найден. Установите: apt install -y mdadm"; exit 1; }

if [[ -z "${NUM_PARTS}" ]]; then
  NUM_PARTS=${#DEVICES[@]}
fi

echo "== Создание RAID =="
echo "Уровень: $RAID_LEVEL"
echo "Устройства: ${DEVICES[*]}"
echo "Количество: $NUM_PARTS"
echo

if (( ASK_CONFIRM )); then
  read -r -p "Продолжить? [y/N] " ans
  [[ "${ans:-N}" =~ ^[Yy]$ ]] || { echo "Отменено."; exit 0; }
fi

for d in "${DEVICES[@]}"; do
  [[ -b "$d" ]] && mdadm --zero-superblock --force "$d" || echo "Пропуск $d"
done

mdadm --create --verbose "$MD_DEV" --level="$RAID_LEVEL" --raid-devices="$NUM_PARTS" "${DEVICES[@]:0:NUM_PARTS}"
sleep 5
cat /proc/mdstat
mdadm --detail "$MD_DEV" || true
