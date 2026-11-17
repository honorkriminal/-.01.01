# Учёт расходов в поездке

Программа считает общую и среднюю сумму расходов и выводит отчёт с заголовком Rich.

## Запуск

Команды выполняются из папки `lesson_02/trip`.

Windows (PowerShell):
```powershell
py -m venv .venv
.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python trip.py
```

Linux / macOS:
```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
python trip.py
```

## Файлы

| Файл | Назначение |
|---|---|
| trip.py | Данные поездки, оформление и вывод отчёта |
| calculator.py | Расчёт общей и средней суммы |
| requirements.txt | Зафиксированные зависимости |
| .gitignore | Исключение окружения и кеша из Git |

## Результат

Заголовок выводится зелёным жирным шрифтом в терминале с поддержкой цвета.

```text
ОТЧЁТ ПО ПОЕЗДКЕ
--------------------------------
записей: 10
всего потрачено: 7900 ₽
средняя трата: 790.00 ₽
```

`.venv` создаётся локально и не добавляется в репозиторий.
