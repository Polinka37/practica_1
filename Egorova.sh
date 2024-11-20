#!/bin/bash

show(){
echo "Использование: $0 [опции]"
echo "Опции:"
echo " -u, --users выводит перечень пользователей и их домашних директорий"
echo " -p, --processes выводит перечень запущенных процессов"
echo " -h --help выводит справку"
echo " -l PATH, --log PATH выводит информацию в файл по заданному пути"
echo " -e PATH, --errors PATH выводит ошибки в файл по заданному пути"
exit 0
}
spisok_users(){
if [-n "$LOG_FILE" ]; then
exec >> "$LOG_FILE" 2>&1
fi
awk -F: '{print $1 ":" $6}' /etc/passwd | sort
}

spisok_procesov(){
if [ -n "$LOG_FILE" ]; then
exec >> "$LOG_FILE" 2>&1
fi
ps -eo pid,cmd --sort pid
}
LOG_FILE=""
ERROR_FILE=""

while getopts ":upl:eh:" opt; do
case ${opt} in
u)
spisok_users
exit 0
;;
p)
spisok_procesov
exit 0
;;
l)
LOG_FILE="$OPTARG"
;;
e)
ERROR_FILE="$OPTARG"
exec 2>> "ERROR_FILE"
;;
h)
show
;;
\?)
echo "Неверный аргумент: -$OPTARG" >&2
show
;;
:)
echo "Аргумент для -$OPTARG отсутствует." >&2
show
;;
esac
done

if [ $OPTIND -eq 1 ]; then
show
fi
