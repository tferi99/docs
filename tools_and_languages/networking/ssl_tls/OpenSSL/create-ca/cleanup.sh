DO=1
if [ -f $CERT_OUT ]
then
	echo "Do you want delete artifacts (y/n)?"
	read a
	if [ "$a" != "y" ]
	then
		DO=0
	fi
fi	 

echo
echo "Removing artifacts..."
echo

rm -rf root
rm -rf intermediate
rm -f *.conf

