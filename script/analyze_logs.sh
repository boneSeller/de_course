#!/bin/bash

# Файл с логами
LOG_FILE="access.log"
REPORT_FILE="report.txt"

# Генерация access.log, если его нет
if [ ! -f "$LOG_FILE" ]; then
    cat <<EOL > "$LOG_FILE"
192.168.1.1 - - [28/Jul/2024:12:34:56 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.2 - - [28/Jul/2024:12:35:56 +0000] "POST /login HTTP/1.1" 200 567
192.168.1.3 - - [28/Jul/2024:12:36:56 +0000] "GET /home HTTP/1.1" 404 890
192.168.1.1 - - [28/Jul/2024:12:37:56 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.4 - - [28/Jul/2024:12:38:56 +0000] "GET /about HTTP/1.1" 200 432
192.168.1.2 - - [28/Jul/2024:12:39:56 +0000] "GET /index.html HTTP/1.1" 200 1234
EOL
    echo "Создан файл $LOG_FILE"
fi

# Очищаем или создаем файл отчета
> "$REPORT_FILE"


echo "Отчет о логе веб сервера" >> "$REPORT_FILE"
echo "========================" >> "$REPORT_FILE"

# 1. Общее количество запросов
echo "Общее количество запросов:" >> "$REPORT_FILE"
wc -l < "$LOG_FILE" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 2. Количество уникальных IP-адресов
echo "Количество уникальных IP-адресов:" >> "$REPORT_FILE"
awk '{ip[$1] = 1} END {print length(ip)}' "$LOG_FILE" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 3. Количество запросов по методам (GET, POST и т.д.)
echo "Количество запросов по методам:" >> "$REPORT_FILE"
awk '{
    n = split($6, parts, " ")
    method = parts[1]
    gsub(/"/, "", method)
    count[method]++
}
END {
    for (m in count) {
        print count[m] " " m
    }
}' "$LOG_FILE" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 4. Самый популярный URL
echo "Самый популярный URL:" >> "$REPORT_FILE"
awk '{
    # Извлекаем URL и версию HTTP
    match($0, /"([^"]+)"/)
    request = substr($0, RSTART+1, RLENGTH-2)  # Убираем внешние кавычки

    # Разделяем на метод и остальную часть
    split(request, parts, " ")
    url_with_http = parts[2] " " parts[3]

    # Используем url_with_http как ключ массива
    count[url_with_http]++
}
END {
    max = 0
    popular = ""
    for (r in count) {
        if (count[r] > max) {
            max = count[r]
            popular = r
        }
    }
    print max " " popular
}' "$LOG_FILE" >> "$REPORT_FILE"

# Выводим отчет на экран
echo "Отчет сохранен в файл $REPORT_FILE"
