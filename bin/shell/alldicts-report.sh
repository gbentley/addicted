#!/bin/sh

# this parse all dict files in share
# and all your translated extensions
# and prints report for every language.

# note that packaging also writes a report,
# so you dont need this when packaging.

# but, you should configure alldicts.cfg
# to suite your environment first.


if [ "" == "$EZPDIR" ]; then
	source alldicts.cfg
fi

cd $EZPDIR

if [ "" == "$REPORT_DIR" ]; then
	echo report dir not given - exiting
	exit 0
fi
if [ ! -d "$REPORT_DIR" ]; then
	echo reportdir $REPORT_DIR does not exist - creating
	mkdir "$REPORT_DIR"
fi
if [ "" == "$REPORT_PREFIX" ]; then
	REPORT_PREFIX=Report
fi

for LOCALE in $LOCALES; do
	if [ ! -d "$REPORT_DIR/$LOCALE" ]; then
		mkdir "$REPORT_DIR/$LOCALE"
	fi
	REPORTFILE=$REPORT_DIR/$REPORT_PREFIX-$LOCALE.txt
	
	echo -n writing report for locale $LOCALE ..
	echo "Translation report for $LOCALE, dd $DATE " >> $REPORTFILE
	echo >> $REPORTFILE
	echo share:		obsolete `grep -c "\"obsolete\"" share/translations/$LOCALE/translation.ts` >> $REPORTFILE
	echo share:		finished `grep -c "<translation>" share/translations/$LOCALE/translation.ts` >> $REPORTFILE
	echo share:		unfinished `grep -c "\"unfinished\"" share/translations/$LOCALE/translation.ts` >> $REPORTFILE
	echo >> $REPORTFILE
	for EXTENSION in $EXTENSIONS; do
		echo $EXTENSION:	obsolete `grep -c "\"obsolete\"" extension/$EXTENSION/translations/$LOCALE/translation.ts` >> $REPORTFILE
		echo $EXTENSION:	finished `grep -c "<translation>" extension/$EXTENSION/translations/$LOCALE/translation.ts` >> $REPORTFILE
		echo $EXTENSION:	unfinished `grep -c "\"unfinished\"" extension/$EXTENSION/translations/$LOCALE/translation.ts` >> $REPORTFILE
		echo >> $REPORTFILE
	done
	echo ..done. 
	echo see $REPORTFILE
done

cd -