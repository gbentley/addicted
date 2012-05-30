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
	
	// main vars
	$module 		= $Params['Module'];
	$dictionaries 	= array();
	$viewparams 	= array();
	$error 			= false; 
	$feedback 		= "";
	
	// main players
	$inifile = eZINI::instance( MODULE_INI_FILE,"extension/addicted/settings" );
	

	// read ini
	$dictionaries = read_dictionaries($inifile);
	if ($dictionaries === false) {
		$error = true;
		$feedback = "Can not interpret the ini file ... ";
	}	
	
	$viewparams = array(
		"dictionaries"	=> $dictionaries,
		"error"			=> $error,
		"feedback"		=> $feedback
	);
	
	include_once( 'kernel/common/template.php' );
	$tpl = templateInit();
	$tpl->setVariable( 'params', $viewparams);
	
	$Result = array();
	$Result['content'] = $tpl->fetch( 'design:addicted/dictionaries.tpl' );
	$Result['path'] = array( 
						array( 'url' => $module->Functions["menu"]["uri"],	'text' => $module->Name ),
						array( 'url' => $module->Functions["dictionaries"]["uri"],	'text' => 'select dictionary' )
					);
					
					
?>
