echo "ll"
while getopts 'aA:yes:nN' c;do
	case $c in
		a)
			echo uuu
			;;
		*)
			echo $c
			;;
	esac
done
echo "pp"
