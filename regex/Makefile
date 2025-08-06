.PHONY:
	regex

regex:
	grep --color -n -e 'Anna' database.csv

class_01-10:
	cat database.csv | grep --color -n -e '[[:digit:]]'

liveserver:
	nvm use stable
	npm install -g liveserver
	cd alura_course_repos/formulario_regex/
	live-server .
	cd ../../
