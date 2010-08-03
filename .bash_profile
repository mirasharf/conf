. $HOME/.bashrc

# flexible approach to user-specific paths
if [ -f "$HOME/.mypaths" ]; then
	export PATH=`grep -v '^#' "$HOME/.mypaths" |
	while read line; do
		echo -n "$line:" 
	done`"$PATH"
fi
