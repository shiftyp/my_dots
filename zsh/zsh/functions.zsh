# print numerical permissions before each item in ls
function ls() {
  command ls -lh --time-style '+%m/%d/%y %I:%M %p' --color=always $@ |\
    awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)\
         *2^(8-i));if(k)printf("%0o ",k);print}'
}

# move back arbitrary number of directories
# $ cd b...
# $ cd ../../../
function cd() {
  emulate -LR zsh

  if [[ $1 == 'b.'* ]]; then
    builtin cd ${${1/"b"}//"."/"../"}
  else
    builtin cd $*
  fi
}
