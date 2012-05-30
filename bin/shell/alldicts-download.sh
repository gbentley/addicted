#!/bin/sh

# this will download dictionary files from a 'remote'
# server, and store them on a 'local' server, overwriting
# the existing local dicts.

# but, you should configure alldicts.cfg
# to suite your environment first.

if [ "" == "$EZPDIR" ]; then
	source alldicts.cfg
fi

# to set up ssh-autologin to prevent having to
# type your password 100 times: read
# http://online-linux.blogspot.com/2009/03/enable-passwordless-authentication-with.html

# this is only usefull if your 'remote' dicts are 
# more recent or correct then the local ones.


for LOCALE in $LOCALES; do
	echo downloading share/translations/$LOCALE/translation.ts .. 
	# backup share/translations/locale
	if [ ! -d $EZPDIR/share/translations/$LOCALE ]; then
		echo creating share/translations/$LOCALE ..
		mkdir $EZPDIR/share/translations/$LOCALE
	fi
	if [ -f $EZPDIR/share/translations/$LOCALE/translation.ts ]; then
		cp $EZPDIR/share/translations/$LOCALE/translation.ts \
			$EZPDIR/share/translations/$LOCALE/translation-$DATE.ts
	fi
	# download share/translations/locale
	scp $REMOTE_EZPURL/share/translations/$LOCALE/translation.ts \
		$EZPDIR/share/translations/$LOCALE/translation.ts
	echo ..done
	for EXTENSION in $EXTENSIONS; do
		echo extension/$EXTENSION/translations/$LOCALE/translation.ts ..
		# backup extension/translations/locale
		if [ ! -d $EZPDIR/extension/$EXTENSION/translations/$LOCALE ]; then
			echo creating extension/$EXTENSION/translations/$LOCALE ..
			mkdir $EZPDIR/extension/$EXTENSION/translations/$LOCALE
		fi
		if [ -f extension/$EXTENSION/translations/$LOCALE/translation.ts ]; then
			cp extension/$EXTENSION/translations/$LOCALE/translation.ts \
				extension/$EXTENSION/translations/$LOCALE/translation-$DATE.ts
		fi
		# download extension/translations/locale
		scp $REMOTE_EZPURL/extension/$EXTENSION/translations/$LOCALE/translation.ts \
			$EZPDIR/extension/$EXTENSION/translations/$LOCALE/translation.ts
		echo .. done
	done
done
echo .. all dictionaries downloaded.
echo

#scp live.labforculture.org:/var/www/portal/share/translations/eng-GB/translation.ts share/translations/eng-GB/translation.ts
#scp live.labforculture.org:/var/www/portal/share/translations/fre-FR/translation.ts share/translations/fre-FR/translation.ts