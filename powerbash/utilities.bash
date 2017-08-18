#####################################################
### This is the OPTIONAL Bash powerbash utlity script.
#####################################################


bind 'set completion-ignore-case on'        # Make completion case insensitive.


# Enhanced directory stack access & cooperation with "cd".
# Inspired by: http://aijazansari.com/2010/02/20/navigating-the-directory-stack-in-bash/index.html

stack_cd() {
  if [ $1 ]; then
    pushd "$1" > /dev/null
  else
    pushd "$HOME" > /dev/null
  fi
}


alias cd=stack_cd  

swap() {
  pushd > /dev/null
}

alias s=swap  

pop_stack() {
  popd > /dev/null
}

alias p=pop_stack  

display_stack() {
  dirs -v
  echo -n "#: "
  read dir
  
  if [[ "$dir" = 'p' ]]; then
    pushd > /dev/null
  elif [[ "$dir" != 'q' ]]; then
    d=$(dirs -l +$dir);
    popd +$dir > /dev/null
    pushd "$d" > /dev/null
  fi
}
alias d=display_stack