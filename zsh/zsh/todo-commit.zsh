todopath=~/code/todos

alias todo="todo.sh $@"

printQuoted() {
	printf %s "$(LC_ALL=C sed 's/["]/\\"/g' <<< "$*")"
}

pull() {
	git pull origin master > /dev/null 2>&1
	if [ "$?" -eq "0" ]; then
		out="$out 📭 "
	else
		out="$out ❌ "
	fi
}

push() {
	git push origin master > /dev/null 2>&1
	if [ "$?" -eq "0" ]; then
		out="$out 📫 "
	else
		out="$out ❌ "
	fi
}

commit() {
	git add .
	git commit -m "$1" > /dev/null 2>&1
	if [ "$?" -eq "0" ]; then
		out="$out 📬 "
	else
		out="$out ❌ "
	fi
}

cd $todopath >> /dev/null

pull

todo

if git diff-index --quiet HEAD --; then
	 out="$out 🙆 "
else
	commit "$(printQuoted $@)"
	push
fi

echo "GIT$out"

cd - >> /dev/null

