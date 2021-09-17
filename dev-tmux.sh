#!/bin/bash

clear
printf "Приветствую! Какой проект ты хочешь сегодня открыть? \n"
cd /home/gurov/documents/development/poetry_github/
b_pwd=`pwd` #Эта переменная всегда будет показывать одно и то же
printf "Мы находимся сейчас в катлоге разработок: $b_pwd \n"
printf "Посмотри на список проектов и выбери себе один из них \n"
printf "\t `ls` \n"
echo -n "Напишите название проекта, который вы хотите открыть и нажмите ввод: "
read project_name

#Необходимо проверить, существует ли этот катклог. Если нет, вернуться на этап выбора.

function re-enter {
	printf "Попробуй еще раз, только без ошибок! \n"
	cd /home/gurov/documents/development/poetry_github/
	b_pwd=`pwd` #Эта переменная всегда будет показывать одно и то же
	printf "Мы находимся сейчас в катлоге разработок: $b_pwd \n"
	printf "Еще раз посмотри на список проектов и выбери себе один из них \n"
	printf "\t `ls` \n"
	echo -n "Напишите БЕЗ ОШИБОК название проекта, который вы хотите открыть и нажмите ввод: "
	read project_name
	control_name_1
}

function control_name_1 {
	if [[ -d "$project_name" ]]; then
		printf "Каталог $project_name существует \n"
		printf "Все ок, можно продолжать \n"

	else
		printf "Каталог $project_name НЕ существует \n"
		printf "Дело дрянь... Но мы попробуем разобраться \n"
		re-enter
	fi
}

control_name_1

printf "Переходим в каталог с проектом $project_name. \n"
cd /home/gurov/documents/development/poetry_github/$project_name
printf "Теперь мы здесь: `pwd` \n"
printf "Активируем рабочее пространство tmux, включаем виртуальное окружение poetry, запускам интерпритатор python3 проекта из виртуального окружения и включаем эмулятор терминалa.\n"


echo -n "Для продолжения нажмите ввод"
read nothing

function create_sess {
	tmux kill-server
	tmux new -s $project_name -d #Создаем tmux-сессию с названием нашего выбранного проекта и сразу от нее отключаемся, оставляя ее работать как сервер
	tmux split-window -v -t $project_name:0.0 #Разбивам окно вертикально. 0окно 0панель
	tmux send-keys -t $project_name:0.0 'htop' Enter #В верхней панели запускаем htop
	tmux attach-session -t $project_name	
}

function auth_sess {
	tmux attach-session -t $project_name	
}

hases="$(tmux has-session -t=$project_name 2> ~/tmp/ba.txt)" #Эта штука создает файл, записывает в файл ошибку нахождения сессии или не записывает
if [[ -s ~/tmp/ba.txt ]]; then
	#printf "NO_EMPTY \n" # Вывести если ошибка записана и файл не пуст	
	printf "Сессия еще не существует, значит мы ее создаем \n"
	echo -n "Для продолжения нажмите ввод"
	read nothing
	create_sess
else
	#printf "EMPTY \n" # Вывести если ошибка незаписана и файл пуст
	printf "Сессия уже существует, значит мы к ней подключаемся \n"
	echo -n "Для продолжения нажмите ввод"
	read nothing
	auth_sess
fi
