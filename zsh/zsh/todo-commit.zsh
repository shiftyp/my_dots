todopath=~/code/todos

printQuoted() {
	printf %s "$(LC_ALL=C sed 's/["]/\\"/g' <<< "$*")"
}

todoPush() {
	git push origin master 2> /dev/null
	if [ "$?" -eq "0" ]; then
		echo "Changes Pushed"
	else
		echo "Push Failed"
	fi
	cd - >> /dev/null
}

todoCommit() {
	git add .
	git commit -m "$1" 2> /dev/null
	if [ "$?" -eq "0" ]; then
		echo "Changes Committed"
	else
		echo "Commit Failed"
	fi
}

todo.sh $@;

cd $todopath >> /dev/null

if git diff-index --quiet HEAD --; then
	echo "No changes to commit"
else
	todoCommit "`printQuoted $@`"
	todoPush
fi

cd - >> /dev/null

