#!/bin/sh

# this will run ezlupdate on your design folders
# and all of your translated extensions.

# but, you should configure alldicts.cfg
# to suite your environment first.

if [ "" == "$EZPDIR" ]; then
	source alldicts.cfg
fi

cd $EZPDIR

for LOCALE in $LOCALES; do
	echo ezlupdating share/translations/$LOCALE/translation.ts
	cp share/translations/$LOCALE/translation.ts share/translations/$LOCALE/translation-$DATE.ts
	if [ "" != "$DESIGNS" ]; then
		for DESIGN in $DESIGNS; do
			# this is a bit of a hack. it calls ezlupdate
			# in extension mode, with an 'extension' called 'share'
			# and the design folder as your directory. it works.
			echo ezlupdating design $DESIGN ..
			$EZLUPDATE_CMD -e share $LOCALE -d design/$DESIGN
			echo ..done.
		done
	else
		echo ezlupdating design folder ..
		$EZLUPDATE_CMD $LOCALE
		echo ..done.
	fi
	echo .. done.
	for EXTENSION in $EXTENSIONS; do
		echo ezlupdating extension/$EXTENSION/translations/$LOCALE/translation.ts
		cp extension/$EXTENSION/translations/$LOCALE/translation.ts extension/$EXTENSION/translations/$LOCALE/translation-$DATE.ts
		$EZLUPDATE_CMD -e extension/$EXTENSION $LOCALE
		echo .. done.
	done
done
echo .. all dictionaries ezlupdated.
echo

cd -

