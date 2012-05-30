#!/bin/sh

# this packages all dict files in share
# and all your translated extensions
# per locale in a folder, to send off
# to your translators.

# but, you should configure alldicts.cfg
# to suite your environment first.


if [ "" == "$EZPDIR" ]; then
	source alldicts.cfg
fi

if [ "" == "$PACKAGE_DIR" ]; then
	echo package dir not given - exiting
	exit 0
fi
if [ "" == "$PACKAGE_PREFIX" ]; then
	PACKAGE_PREFIX=Package
fi

	
for LOCALE in $LOCALES; do
	if [ ! -d "$PACKAGE_DIR/$LOCALE" ]; then
		mkdir "$PACKAGE_DIR/$LOCALE"
	else
		echo -n "Empty existing package dir for $LOCALE first (y|n) ?"
		read ok
		if [ "y" == "$ok" ]; then
			rm "$PACKAGE_DIR/$LOCALE/"*
		fi
	fi
	
	CSVFILE=$PACKAGE_DIR/$LOCALE/$PACKAGE_PREFIX-$LOCALE.csv
	echo "Context",	"Source",	"Comment",	"Translation" > $CSVFILE
	echo >> $CSVFILE

	echo -n packaging files for locale $LOCALE ..
	cp $EZPDIR/share/translations/$LOCALE/translation.ts \
		$PACKAGE_DIR/$LOCALE/$PACKAGE_PREFIX-share-$LOCALE.ts
	for EXTENSION in $EXTENSIONS; do
		cp $EZPDIR/extension/$EXTENSION/translations/$LOCALE/translation.ts \
			$PACKAGE_DIR/$LOCALE/$PACKAGE_PREFIX-$EXTENSION-$LOCALE.ts
		if [ "" != $PACKAGE_CSV ]; then
			xsltproc --novalid alldicts-package.xslt \
				$PACKAGE_DIR/$LOCALE/$PACKAGE_PREFIX-$EXTENSION-$LOCALE.ts >> \
				$CSVFILE
		fi
	done
	
	if [ "" != $PACKAGE_REPORT ]; then
		REPORTFILE=$PACKAGE_DIR/$LOCALE/$PACKAGE_PREFIX-$LOCALE.txt
		echo -n writing overall report ..
		echo "Translation report for $LOCALE, dd $DATE " > $REPORTFILE
		echo >> $REPORTFILE
		for DICTFILE in `ls "$PACKAGE_DIR/$LOCALE/"$PACKAGE_PREFIX*ts`; do
			echo `basename "$DICTFILE"`:	>> $REPORTFILE
			echo "	- obsolete		"`grep -c "\"obsolete\"" $DICTFILE` >> $REPORTFILE
			echo "	- finished 		"`grep -c "<translation>" $DICTFILE` >> $REPORTFILE
			echo "	- unfinished	"`grep -c "\"unfinished\"" $DICTFILE` >> $REPORTFILE
			echo >> $REPORTFILE
		done
	fi
	echo ..done. 
	echo see $PACKAGE_DIR/$LOCALE
done

