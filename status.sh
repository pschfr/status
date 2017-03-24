#!/bin/bash
# Initiate variables
REPOS=0
UPDATED=0
MODIFIED=0
VERBOSE=true
DEFAULT=false

# Loop through flags, looking for default flag
while getopts 'dhm' FLAGS; do
	case "${FLAGS}" in
		d) ROOT_DIR=$HOME/Dropbox/Work; cd "$ROOT_DIR"; echo -e '\n'; DEFAULT=true ;;
		h) echo -e '\nEnter absolute location of a directory that contains multiple Git repositories.\nI will magically do the rest! :)\n\nYou can use `-d` for the default location, `-h` for this screen, or `-m` for a minimal output.\n'; exit 0 ;;
		m) VERBOSE=false ;;
		*) exit 1 ;;
	esac
done

# Introduce yourself
if [ ${VERBOSE} = true ]; then
	echo -e "\e[34m\e[1mPaul's Git Status Script v1.2.0\e[0m"
fi

# If no flags, ask for directory giving optional default again
if [ ${DEFAULT} = false ]; then
	echo "Enter an absolute directory location, starting with /"
	echo "Press enter (or -d) for default ($HOME/Dropbox/Work):"
	read -e ROOT_DIR # absolute location of directory containing multiple git repos

	if [ -z "$ROOT_DIR" ]; then # if input is empty, use default
		cd $HOME/Dropbox/Work
	else
		cd "$ROOT_DIR"
	fi
fi

for DIR in */; do # loops through each directory
	cd "$DIR"
	if [ -d ".git" ]; then # if .git folder exists, check status
		COMMITS=`git rev-list --all --count` # returns number of commits
		if [ ${VERBOSE} = true ]; then
			echo -e "\e[34m\e[1m${DIR%?} \e[1;30m${COMMITS} commits\e[0m"
		fi

		if git status -s | read status; then # if modified, print status, otherwise up to date
			if [ ${VERBOSE} = true ]; then
				git status -s
			fi
			MODIFIED=$((MODIFIED + 1))
		else
			if [ ${VERBOSE} = true ]; then
				echo 'Up to date'
			fi
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
