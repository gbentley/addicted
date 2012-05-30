<?php
	//
	
	
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
	//
	
	define( "MODULE_INI_FILE", "module.ini" );
	include("lib.php");
	include_once( "lib/ezutils/classes/ezhttptool.php" );
	include_once( 'extension/addicted/classes/XPath.class.php' );
	

	// main vars
	$module 		= $Params['Module'];
	$dictionaries 	= array();
	$dictionary 	= null;
	$contexts 		= array();
	$file			= "";
	$path			= "";
	$viewparams 	= array();
	$error 			= false; 
	$feedback 		= "";

	
	// main players
	$sys 		= eZSys::instance();
	$http		= eZHTTPTool::instance();
	$xPath 		= new XPath();
	$xPath->setXmlOption(XML_OPTION_SKIP_WHITE, 0);
	$inifile = eZINI::instance( MODULE_INI_FILE,"extension/addicted/settings" );
	
	// read ini
	$dictionaries = read_dictionaries($inifile);
	if ($dictionaries === false) {
		$error = true;
		$feedback = "Can not interpret the ini file ... ";
	}	
	
	// get vars from http
	$file 	= $http->variable('dictionary');
	
	//select dict
	foreach ($dictionaries as $dictionary) {
		if ($dictionary["file"]==$file) break;
	}
	$path = $sys->rootDir().$file;
	
	// read contexts
	$contexts = array();
	if (is_file($path) AND is_readable($path)) {
		if (!is_writable($path)) {
			$error = true;
			$feedback = "Can not write to file ($path)";
		}
		$xPath->importFromFile($path);
		$contexts = read_contexts($xPath);
		if ($contexts === false) {
			$error 		= true;
			$feedback 	= "Can not read contexts from file ($path) ... ";
		}	
		
	} else {
		$error = true;
		$feedback = "No such file ($path)";
	}
	
	$viewparams = array(
		"dictionary"	=> $dictionary,
		"contexts"		=> $contexts,
		"error"			=> $error,
		"feedback"		=> $feedback
	);
	
	include_once( 'kernel/common/template.php' );
	$tpl = templateInit();
	$tpl->setVariable( 'params', $viewparams);
	
	$Result = array();
	$Result['content'] = $tpl->fetch( 'design:addicted/contexts.tpl' );
	$Result['path'] = array( 
						array( 'url' => $module->Functions["menu"]["uri"],	'text' => $module->Name ),
						array( 'url' => $module->Functions["dictionaries"]["uri"],	'text' => $dictionary["name"] ),
						array( 'url' => $module->Functions["contexts"]["uri"],	'text' => 'select context' )
					);
					
					
?>
