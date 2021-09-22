#!/bin/bash

clear
source types_of_sessions 
source function_type-env # Это файл,который содержит сессии. Надо будет по моимо poetry и virtualenv сделать 3 вощможность - ручной выбор

cd /home/gurov/documents/development/ # Enter your path here where your project directories are stored 
info='cat info/git_pass.md'
b_pwd=`pwd` # Эта переменная всегда будет показывать одно и то же
printf "\n"
printf "╔══════════════════════════════════════════════════════════════════════════════════════════════╗\n"
printf "║Welcome to gur-ov/dev-tmux | www.gurov.sk/dev                                         	       ║\n"
printf "║license: creative commons cc0                                         		               ║\n"
printf "╚══════════════════════════════════════════════════════════════════════════════════════════════╝\n"

environment_type_selection_function # Функция из дополнительного файла для выбора типа рабочего окружения

printf "\n"
printf "╔══════════════════════════════════════════════════════════════════════════════════════════════╗\n"
printf "║It's OK. And what will we open?			                                       ║\n"
printf "║We are here: `pwd` \n"
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
	b_pwd=`pwd` # Эта переменная всегда будет показывать одно и то же
	printf "\n"
	printf "╔══════════════════════════════════════════════════════════════════════════════════════════════╗\n"
	printf "║Error. Try again 									       ║\n"
	printf "║We are here: `pwd` \n"
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
		cd $project_name

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

printf "\n"
printf "╔══════════════════════════════════════════════════════════════════════════════════════════════╗\n"
printf "║Go to the directory with the project $project_name \n"
printf "║Now we are here: `pwd`\n"
printf "║Launch what do you need   		 	    					       ║\n"
printf "╚══════════════════════════════════════════════════════════════════════════════════════════════╝\n"
printf "\n"

function create_sess {
	# Здесь должен начаться выбор типа сессии, хотя лучше автоматически,исходя из хначения переменной
	# Данная функция отвечает за выбор типа сессии, который мы собираемся создать
	# Сначала программа должна показать список доступных сессий и предоставить выбор. Пока сессий две, оставлю это автоматически
	# НЕОБХОДИМО СДЕЛАТЬ 3 ВОЗМОЖНОСТЬ - выбор сессии в ручную из представленных. И это должно быть реализовано сперва с тем, что прогамма выводит список всех доступных функций из файла с функциями запуска сессий. А потом в зависимости от выбра включает актиацию нужной функции. Там же не плохо бы иметь возможность сперва сменить каталог работы
	
	if [[  "$project_environment_type" -eq 1 ]]; then # Если переменная типа окружения Poetry, то открой тип сессии poetry
		$(create_sess_poetry)
		clear
	elif [[  "$project_environment_type" -eq 2 ]]; then # Если переменная типа окружения Virtualenv, то открой тип сессии virtualenv
		$(create_sess_virtualenv)
		clear
	elif [[  "$project_environment_type" -eq 3 ]]; then # Если переменная типа окружения Virtualenv+pelican, то открой тип сессии virtualenv+pelican
		$(create_sess_virtualenv_pelican)
		clear
	else
		echo "ERROR!"
	fi
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
	create_sess # Запуск выбора типа сесии, а не просто создание сессии
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
		create_sess # Запуск выбора типа сесии, а не просто создание сессии
	fi

fi
