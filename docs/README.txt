=============
AdDictEd - Admin Dictionary Editor
=============
Release: 2.0
Created: <2009/08> pike@labforculture.org
Commissioned by LabforCulture

This admin extension that allows you to edit dict files 
of multilingual sites using the ezPublish admin interface.
The ini file allows you to set which dictionaries
are available for editing. 

You still need to create your own dictionaries
using ezlupdate (or anything else). Once they are 
created, you can add/edit/delete messages inside
existing contexts. In this sence, it replaces part 
of the  functionality of Linguist. You can still use 
Linguist alongside this extension. 

For more info on how to set up dictionaries, read
http://ez.no/ezpublish/documentation/configuration/configuration/language_and_charset/creating_a_new_translation

For more info on ezlupdate, see
http://ez.no/de/download/translations/ezlupdate_and_linguist

The main interface leads you down a path to select
a file, select a context in a file, view an overview
of messages (phrases) in a file, edit / delete and add 
messages inside that context. Currently, you can't 
add contexts. 

When manipulating a message, both the source and the
translation text are used for locating the message. This
prevents multiple people rewriting eachothers changes.

The docs/xslt folder contains some extra goodies to
manipulate dictionary files using xslt.

------------
Dependencies: 

- this module links the PHPXPath PHP library (http://sourceforge.net/projects/phpxpath/)
- your phpserver needs XSL support.
- has no ezPublish dependencies; it builds on PHPXPath and the <TS> dtd 

------------
Known issues: 
 - This software is in beta. Make backups of important files
   yourself. I am not responsible for anything :-)
 - dont use this on files which are under SVN control. Your SVN
   client will be heavily confused.
 - your dictionary files should be writable for the webserver
 - Context names may not contain quotes 

 - When translations end in newlines, problems may arise updating them.
   Looking into that.
 - Confusing: when for some reason one message is not updated,
   addicted shows a red messagebox; the other messages that are OK
   are printed with "OK"; but because of the single failure,
   this dict file is not saved.



-------------
Status:  

 - beta. tested on my own files, which are ~900k each. slow, but works.
 - tested on 4.0.1





