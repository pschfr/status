#!/bin/bash
echo -e "\e[34m\e[1mPaul's Git Status Script v1.1\e[0m"
echo "Enter an absolute directory location, starting with /"
echo "Press enter for default ($HOME/Dropbox/Work):"
read -e ROOT_DIR # absolute location of directory containing multiple git repos

if [ -z "$ROOT_DIR" ]; then # if input is empty, use default
	cd $HOME/Dropbox/Work
else
	cd "$ROOT_DIR"
fi

REPOS=0 # init counters
UPDATED=0
MODIFIED=0

for DIR in */ # loops through each directory
do 
	cd "$DIR"
	if [ -d ".git" ]; then # if .git folder exists, check status
		COMMITS=`git rev-list --all --count` # returns number of commits
		echo -e "\e[34m\e[1m${DIR%?} \e[1;30m${COMMITS} commits\e[0m"

		if git status -s | read status; then # if modified, print status, otherwise up to date
			git status -s
			MODIFIED=$((MODIFIED + 1))
		else
			echo 'Up to date'
			UPDATED=$((UPDATED + 1))
		fi

		REPOS=$((REPOS + 1))
	fi

	if [ -z "$ROOT_DIR" ]; then
		cd $HOME/Dropbox/Work
	else
		cd "$ROOT_DIR"
	fi
done

echo -e "\n\e[34m\e[1m${REPOS}\e[0m repositories, \e[32m\e[1m${UPDATED}\e[0m up to date, and \e[31m\e[1m${MODIFIED}\e[0m with changes."
