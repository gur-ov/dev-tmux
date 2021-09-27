  # gur-ov/dev-tmux

Script for open develop tmux session. This is a tutorial project, although I'm using it for its intended purpose. 

  ## Version
 
2.1.0

### Latest updates

The program received all the necessary working functionality, including control of user input. For the transition to version 2.1.0, documentation will be written for more convenient use of the program by other users. 

  ## License

License: Creative Commons CC0.
www.gurov.sk/gu-ov/dev-tmux

  ## Description

This script is made to quickly enable the development environment for python3.
The script assumes that the "poetry" program is used as the environment.
In order for the script to select the correct directory where projects are stored (in the form of directories), it must be specified manually at the beginning of the script.

  ## Plans for the future

It is planned to add a session opening script to the vim tab, which will be individual for each project. 

  ## How use
  
In order to use the program, your projects must be in a specific directory. For example: 

> Documents/develop

Further, your projects should be divided according to the technologies that you use. The division should be by directories. For example: 

> git_virtualenv
> git_virtualenv_pelican
> git_poetry

Accordingly, the program will then understand which environment needs to be included for which type of development project. For example, you may have several projects in the "git_virtualenv" that use git and virtualanv technologies. The names of these projects are given below for clarity. 

> git_virtualenv
>   ├── Project_1
>     ├── source_code.py
>     ├── .git 
>   ├── Project_2
>     ├── source_code.py
>     ├── .git
> git_virtualenv_pelican
> git_poetry

How does the program understand how to open tmax? They open it individually for each project, if the session is saved. The first time a session is created, it opens the main development environment for a specific type of project, be it git_virtualenv or git_poetry, or something else. 

To configure how exactly tmax will be opened for each of the projects, you need to do it manually in file *types_of_session*. If you want to add a new project type, you have to do it manually in file *function_type-env*. 
