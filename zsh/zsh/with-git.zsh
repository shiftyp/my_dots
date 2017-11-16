dir=$1
com=$2

printQuoted() {
	printf %s "$(LC_ALL=C sed 's/["]/\\"/g' <<< "$*")"
}

shift 2

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

add() {
	git add .
}

commit() {
	git commit -m "$1" > /dev/null 2>&1
	if [ "$?" -eq "0" ]; then
		out="$out 📬 "
	else
		out="$out ❌ "
	fi
}

cd $dir >> /dev/null

pull

eval $com $@

add

if git diff-index --quiet HEAD --; then
	 out="$out 🙆 "
else
	commit "$(printQuoted $@)"
	push
fi

echo "GIT:$out"

cd - >> /dev/null

