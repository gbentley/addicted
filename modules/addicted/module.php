<?php

// Created on: 2006/11*pike@labforculture.org
// Commissioned by: LabforCulture

// Copyright (C) 2006 Pike. All rights reserved.
//
// This file may be distributed and/or modified under the terms of the
// "GNU General Public License" version 2 as published by the Free
// Software Foundation and appearing in the file LICENSE included in
// the packaging of this file.
//
// This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING
// THE WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE.
//
//
// The "GNU General Public License" (GPL) is available at
// http://www.gnu.org/copyleft/gpl.html.

// this file also describes the inputs and outputs of each
// view and associated template.

// the sequence is
// select dictionary (identified by file)
// select context (identified by name)
// select message (identified by source<status>translation)

// note how I treat source<status>translation like a rdf triplet ..
// the dicts would have been perfect rdf. comment -in my view-
// is a reification on the triplet.
// by using the whole triplet as a id for the message, i avoid
// concurrent changes 


$Module = array( 'name' => 'addicted' );

$ViewList = array();

//---------------------------------
// addicted/menu
$ViewList['menu'] 			= array('script' => 'menu.php' );

//---------------------------------
$ViewList['dictionaries'] 	= array('script' => 'dictionaries.php' );
//
// http input
// ../addicted/dictionaries
//
// template vars
// $params["dictionaries"] 	array of hashes("file","locale","name","country")
// $params["error"],$params["feedback"]

//---------------------------------
$ViewList['contexts'] 		= array('script' => 'contexts.php' );
//
// http input
// ../addicted/contexts
//		?dictionary=share/translations/fre-FR/dictionary.ts
//
// template vars
// $params["dictionary"]	hash ("file","locale","name","country")
// $params["contexts"] 		array of hashes("name","summary")
// $params["error"],$params["feedback"]

//---------------------------------
$ViewList['messages'] 		= array('script' => 'messages.php' );
//
// http input
// ../addicted/messages
//		?dictionary=share/translations/fre-FR/dictionary.ts
//		&context=/content/attributes
//
// template vars
// $params["dictionary"]	hash ("file","locale","name","country")
// $params["context"]		hash("name","summary")
// $params["messages"]  	array of hashes ("source","status","translation","comment")
// $params["action"]
// $params["error"],$params["feedback"]

// in messages.php,
// actions are received like

// action=insert
// msg-source=perhaps
// msg-status=finished
// msg-translation=mischien

// or

// action=update
// messages[]=0,1,2,..
//..
// msg2-orgsource=perhaps
// msg2-orgstatus=unfinished
// msg2-orgtranslation=mischien
// msg2-newsource=perhaps
// msg2-newstatus=finished
// msg2-newtranslation=misschien
//..

// or

// action=delete
// messages[]=0,1,2,..
// todelete[]=2,3,..

// msg2-orgsource=perhaps
// msg2-orgstatus=unfinished
// msg2-orgtranslation=mischien
//..




?>