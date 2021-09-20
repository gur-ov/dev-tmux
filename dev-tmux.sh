#!/bin/bash

clear
cd /home/gurov/documents/development/poetry_github/ # Enter your path here where your project directories are stored 
b_pwd=`pwd` # Эта переменная всегда будет показывать одно и то же
printf "\n"
printf "╔══════════════════════════════════════════════════════════════════════════════════════════════╗\n"
printf "║Welcome to gur-ov/dev-tmux | www.gurov.sk/dev                                         	       ║\n"
printf "║License: Creative Commons CC0                                         		               ║\n"
printf "║Your projects should include: git, poetry, python3                                            ║\n"
printf "╚══════════════════════════════════════════════════════════════════════════════════════════════╝\n"
printf "\n"
printf "╔══════════════════════════════════════════════════════════════════════════════════════════════╗\n"
printf "║What will we open?			                                                       ║\n"
printf "║We are here: $b_pwd \n"
printf "║Look at the list of projects and choose one                                   		       ║\n"
printf "╚══════════════════════════════════════════════════════════════════════════════════════════════╝\n"
printf "\n"

# Вывод списка доступных проектов
ls > /tmp/dev-tmux_ls # Вывод содержимого текущего каталога в файл 
cat -b /tmp/dev-tmux_ls # Вывод нумерованного списка из файла

printf "\n"
echo -n "Write the name of the project and hit enter: "
read project_name
printf "\n"

# Необходимо проверить, существует ли этот каталог. Если нет, вернуться на этап выбора.

function re-enter {
	cd /home/gurov/documents/development/poetry_github/
	b_pwd=`pwd` # Эта переменная всегда будет показывать одно и то же
	printf "\n"
	printf "╔══════════════════════════════════════════════════════════════════════════════════════════════╗\n"
	printf "║Error. Try again 									       ║\n"
	printf "║We are here: $b_pwd \n"
	printf "║Take another look at the list of projects and choose one 				       ║\n"
	printf "╚══════════════════════════════════════════════════════════════════════════════════════════════╝\n"
	printf "\n"

	# Вывод списка доступных проектов
	ls > /tmp/dev-tmux_ls # Вывод содержимого текущего каталога в файл 
	cat -b /tmp/dev-tmux_ls # Вывод нумерованного списка из файла

	printf "\n"
	echo -n "Write the name of the project and hit enter: "
	read project_name
	control_name_1
}

function control_name_1 {
	if [[ -d "$project_name" ]]; then
		printf "\n"
		printf "╔═════════════════════════════════════════════════════╗\n"
		printf "║Directory $project_name exists \n"
		printf "║Everything is ok, you can continue                   ║\n"
		printf "╚═════════════════════════════════════════════════════╝\n"
		printf "\n"

	else
		printf "\n"
		printf "╔══════════════════════════════════════════════════════╗\n"
		printf "║Directory $project_name does not exist \n"
		printf "║Trying to solve the problem \n"
		printf "╚══════════════════════════════════════════════════════╝\n"
		printf "\n"
		re-enter
	fi
}

control_name_1

cd /home/gurov/documents/development/poetry_github/$project_name
printf "\n"
printf "╔══════════════════════════════════════════════════════════════════════════════════════════════╗\n"
printf "║Go to the directory with the project $project_name \n"
printf "║Now we are here: `pwd`\n"
printf "║Launch: tmux, poetry: python3, terminal 	    					       ║\n"
printf "╚══════════════════════════════════════════════════════════════════════════════════════════════╝\n"
printf "\n"

function create_sess {
	# Это функция создания новой сессии tmux. 
	# Она разбита на 2 функции, разделенные паузой из-за невозможности одновременно запустить poetry shell и последующей любой команды. 
	function session_tmux_new_1 {
	tmux kill-session -t $project_name # На всякий случай убьем сессию, если она существует
	tmux new -s $project_name -n vim -d # Создаем tmux-сессию с названием нашего выбранного проекта, называем первое окно vim и сразу отключаемся от проекта оставляя его работать как сервер
	# Создаем новое окно 2 рабочего стола - 2:1 и называем его develop
	tmux new-window -n develop -t $project_name 
	# Делим окна 
	# Для рабочего стола 1
	tmux send-keys -t $project_name:1.1 'poetry shell' Enter #Подключаем poetry
	# Для рабочего стола 2
	tmux split-window -h -t $project_name:2.1 #Разбивам окно 2 рабочего окна
	tmux split-window -v -t $project_name:2.2 #Разбивам окно 2 рабочего окна
	# Записываем, что хотим открыть в этих окнах	
	# Первый рабочий стол
	# Второй рабочий стол
	tmux send-keys -t $project_name:2.1 'poetry shell' Enter # Здесь будет эмулятор терминала c включенным poetry окружением
	tmux send-keys -t $project_name:2.2 'poetry shell' Enter # Запускаем poetry среду и включаем ее python
	tmux send-keys -t $project_name:2.3 'htop' Enter # В верхней панели запускаем htop

	tmux select-window -t $project_name:1.1 # Переводим курсор на окно 1
	}
	function session_tmux_new_2 { # Здесь перечисленны запуски того, что выключается после poetry shell
	tmux send-keys -t $project_name:1.1 'vim' Enter # На всю панель включаем vim (потом сделать программу выбора сессий)
	tmux send-keys -t $project_name:2.2 'python3' Enter # Запускаем poetry среду и включаем ее python
	}
	session_tmux_new_1
	sleep 3
	session_tmux_new_2
	sleep 1
	tmux attach-session -t $project_name # Подключаемся к сессии, после завершения всех настроек
	clear # Очистим терминал 
}

function auth_sess {
	tmux attach-session -t $project_name	
	clear # Очистим терминал 
}

hases="$(tmux has-session -t=$project_name 2> ~/tmp/ba.txt)" # Эта штука создает файл, записывает в файл ошибку нахождения сессии или не записывает
if [[ -s ~/tmp/ba.txt ]]; then
	printf "\n"
	printf "╔══════════════════════════════════════════════════════╗\n"
	printf "║The session does not exist, we will create it         ║\n"
	printf "╚══════════════════════════════════════════════════════╝\n"
	printf "\n"
	echo -n "Press enter to continue: "
	read nothing
	create_sess
else
	printf "\n"
	printf "╔══════════════════════════════════════════════════════╗\n"
	printf "║Session already exists                                ║\n"
	printf "╚══════════════════════════════════════════════════════╝\n"
	printf "\n"
	echo -n "Continue with the old session? y/n: "
	read authorization_decision

	printf "\n"
	printf "╔══════════════════════════════════════════════════════╗\n"
	printf "║Wait 5 seconds, turn on...                            ║\n"
	printf "╚══════════════════════════════════════════════════════╝\n"
	printf "\n"

	# Блок анализа выбора открыть старую сессию или начать новую?
	authorization_decision_yes="y"
	if [[ "$authorization_decision" = "$authorization_decision_yes" ]]; then
		auth_sess
	else
		create_sess
	fi

fi
