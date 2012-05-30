#!/bin/sh

# this will run autofill.xslt on all dictionaries
# in the locale $AUTOFILL_LOCALE. autofill fills
# out the value of the comment field in all 
# empty translations fields. Think twice.

# but, you should configure alldicts.cfg
# to suite your environment first.

if [ "" == "$EZPDIR" ]; then
	source alldicts.cfg
fi


if [ "" == "$AUTOFILL_LOCALE" ]; then
	echo autofill locale not set; exiting
	exit 0
fi


echo autofilling share/translations/$AUTOFILL_LOCALE/translation.ts
if [ -f $EZPDIR/share/translations/$AUTOFILL_LOCALE/translation.ts ]; then
	cp $EZPDIR/share/translations/$AUTOFILL_LOCALE/translation.ts \
		$EZPDIR/share/translations/$AUTOFILL_LOCALE/translation-$DATE.ts
	xsltproc --novalid `dirname $0`/alldicts-autofill.xslt \
		$EZPDIR/share/translations/$AUTOFILL_LOCALE/translation-$DATE.ts > \
		$EZPDIR/share/translations/$AUTOFILL_LOCALE/translation.ts
	echo .. done.
else
	echo .. no such file ?
fi


for EXTENSION in $EXTENSIONS; do
	echo autofilling extension/$EXTENSION/translations/$AUTOFILL_LOCALE/translation.ts
	if	[ -f $EZPDIR/extension/$EXTENSION/translations/$AUTOFILL_LOCALE/translation.ts ]; then
		cp $EZPDIR/extension/$EXTENSION/translations/$AUTOFILL_LOCALE/translation.ts \
			$EZPDIR/extension/$EXTENSION/translations/$AUTOFILL_LOCALE/translation-$DATE.ts
		xsltproc --novalid `dirname $0`/alldicts-autofill.xslt \
			$EZPDIR/extension/$EXTENSION/translations/$AUTOFILL_LOCALE/translation-$DATE.ts > \
			$EZPDIR/extension/$EXTENSION/translations/$AUTOFILL_LOCALE/translation.ts
		echo .. done.
	else
		echo .. no such file ?
	fi
done

echo .. all found dictionaries for locale $AUTOFILL_LOCALE autofilled.
echo now I need to ezlupdate them again. ezp is like that.

`dirname $0`/alldicts-ezlupdate.sh



