#!/bin/bash

# Генератор баг-репорта в формате qa-test-planner.
# Формат: заголовок «что + где + при каких условиях»,
# таблица «Шаги | Фактический результат | Ожидаемый результат».

set -e

echo "╔══════════════════════════════════════════════════╗"
echo "║            Генератор баг-репорта                  ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

read -r -p "ID бага (например, BUG-101): " BUG_ID
read -r -p "Заголовок (что произошло + где + при каких условиях): " TITLE
read -r -p "Серьёзность (Critical|High|Medium|Low): " SEVERITY
read -r -p "Приоритет (P0-P3): " PRIORITY
read -r -p "Тип (Functional|UI|Performance|Security): " TYPE

echo ""
echo "--- Окружение ---"
read -r -p "ОС: " OS
read -r -p "Браузер: " BROWSER
read -r -p "Устройство: " DEVICE
read -r -p "Сборка/версия: " BUILD
read -r -p "URL: " URL

echo ""
read -r -p "Краткое описание проблемы: " DESCRIPTION

echo ""
echo "Шаги воспроизведения в одну строку, разделитель — '; '"
read -r -p "Шаги: " STEPS
STEPS_HTML="${STEPS//; /<br>}"

read -r -p "Фактический результат: " ACTUAL
read -r -p "Ожидаемый результат: " EXPECTED

echo ""
read -r -p "Связано с (фича/тикет): " RELATED
read -r -p "Регресс (Да/Нет): " REGRESSION
read -r -p "Макет Figma (если UI-баг): " FIGMA

read -r -p "Файл для вывода (по умолчанию bug-report.md): " OUTFILE
[ -z "$OUTFILE" ] && OUTFILE="bug-report.md"

[ -z "$REGRESSION" ] && REGRESSION="Нет"
[ -z "$FIGMA" ] && FIGMA="—"
[ -z "$RELATED" ] && RELATED="—"

cat > "$OUTFILE" << EOF
# ${BUG_ID}: ${TITLE}

**Серьёзность:** ${SEVERITY:-Medium}
**Приоритет:** ${PRIORITY:-P2}
**Тип:** ${TYPE:-Functional}
**Статус:** Open

## Окружение
- **ОС:** ${OS}
- **Браузер:** ${BROWSER}
- **Устройство:** ${DEVICE:-Десктоп}
- **Сборка:** ${BUILD}
- **URL:** ${URL}

## Описание
${DESCRIPTION}

## Шаги и результаты

| Шаги воспроизведения | Фактический результат | Ожидаемый результат |
| --- | --- | --- |
| ${STEPS_HTML} | ${ACTUAL} | ${EXPECTED} |

## Визуальные доказательства
- Скриншот: [приложен]
- Видео: [ссылка, если есть]
- Ошибки консоли: [вставить ошибки]

## Дополнительный контекст
- Связано с: ${RELATED}
- Регресс: ${REGRESSION}
- Макет Figma: ${FIGMA}
EOF

echo ""
echo "✅ Готово: ${OUTFILE}"
echo "Не забудьте приложить скриншоты/видео и ошибки консоли."
