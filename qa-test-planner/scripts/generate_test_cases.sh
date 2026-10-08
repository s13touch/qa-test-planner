#!/bin/bash

# Генератор тест-кейсов в табличном формате qa-test-planner.
# Единственный формат вывода — таблица:
# | № требования | Номер кейса | Приоритет | Описание тест-кейса |

set -e

echo "╔══════════════════════════════════════════════════╗"
echo "║     Генератор тест-кейсов (таблица)              ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

read -r -p "Название раздела: " SECTION
[ -z "$SECTION" ] && SECTION="Без раздела"

read -r -p "№ требования (можно оставить пустым): " REQ
[ -z "$REQ" ] && REQ="—"

read -r -p "Файл для вывода (по умолчанию test-cases.md): " OUTFILE
[ -z "$OUTFILE" ] && OUTFILE="test-cases.md"

{
  echo "*${SECTION}*"
  echo ""
  echo "| № требования | Номер кейса | Приоритет | Описание тест-кейса |"
  echo "| --- | --- | --- | --- |"
} > "$OUTFILE"

N=0
echo ""
echo "Добавляйте кейсы. Пустой приоритет — завершить."
while true; do
  echo ""
  read -r -p "Приоритет (P0-P3, Enter — завершить): " PRIO
  [ -z "$PRIO" ] && break

  case "$PRIO" in
    P0|P1|P2|P3) ;;
    *) PRIO="P2" ;;
  esac

  read -r -p "Описание тест-кейса: " DESC
  [ -z "$DESC" ] && continue

  N=$((N + 1))
  TC=$(printf "TC-%02d" "$N")
  echo "| ${REQ} | ${TC} | ${PRIO} | ${DESC} |" >> "$OUTFILE"
done

echo ""
echo "✅ Готово: ${OUTFILE} (кейсов: ${N})"
