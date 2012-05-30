#!/bin/sh

# this script will download / update / translate 
# / fix / report  and package all the dictionaries in 
# share/translations and in extensions in all languages
# all in one big swoop. 

# but, you should configure alldicts.cfg
# to suite your environment first.

source alldicts.cfg


# write out a report sofar
cat<<EOF

---
dicts-build.sh 		
backupsuffix		: $DATE
local path			: $EZPDIR
ezlupdate			: $EZLUPDATE_CMD
remote url 			: $REMOTE_EZPURL
designs				: $DESIGNS
autofill on			: $AUTOFILL_LOCALE
reports in			: $REPORT_DIR/$REPORT_PREFIX-(locale).txt
packages in			: $PACKAGE_DIR/(locale)/*
---
locales used:			
$LOCALES
---
translated extensions:			
$EXTENSIONS
---

EOF

echo please doublecheck the above.
echo -n "Can we continue (y|n) ? "
read ok
if [ "y" != "$ok" ]; then
	exit 1
fi


# -------------------
# download remote files; optional
# this will download dictionary files from a 'remote'
# server, and store them on the 'local' machine, overwriting
# the existing local dicts. this is usefull if your 
# remote dicts are more correct; eg if they are
# maintained/updated on a 'live' server.

if [ "" != "$REMOTE_EZPURL" ]; then
	echo -n "Download remote files first (y|n) ? "
	read ok
	if [ "y" == "$ok" ]; then
		`dirname $0`/alldicts-download.sh
	fi;
fi

# -------------------
# ezlupdate all local files
#
if [ "" != "$EZLUPDATE_CMD" ]; then
	echo -n "Run ezlupdate on local files (y|n) ?"
	read ok
	if [ "y" == "$ok" ]; then
		`dirname $0`/alldicts-ezlupdate.sh
	fi;
fi



# -------------------
# autofill comments field value in default translation
# see some explanation in the xslt file.

if [ "" != "$AUTOFILL_LOCALE" ]; then
	echo -n "Run autofill comments on dicts in locale $AUTOFILL_LOCALE (y|n) ?"
	read ok
	if [ "y" == "$ok" ]; then
		`dirname $0`/alldicts-autofill.sh
	fi;
fi

# -------------------
# write a report about all files
#
if [ "" != "$REPORT_DIR" ]; then
	echo -n "Write reports about all languages (y|n) ?"
	read ok
	if [ "y" == "$ok" ]; then
		`dirname $0`/alldicts-report.sh
	fi;
fi

# -------------------
# package all the files neatly in dirs 
# to send to your translators
if [ "" != "$PACKAGE_DIR" ]; then
	echo -n "Create package dir for your translators (y|n) ?"
	read ok
	if [ "y" == "$ok" ]; then
		`dirname $0`/alldicts-package.sh
	fi;
fi

echo
echo
echo "Very, very, finally, done. Thank you."

# success
exit 0