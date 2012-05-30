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
	
	include("lib.php");
	include_once( "lib/ezutils/classes/ezhttptool.php" );
	include_once( 'extension/addicted/classes/XPath.class.php' );
	

	// main vars
	$module 		= $Params['Module'];
	$dictionaries 	= array();
	$dictionary 	= null;
	$contexts 		= array();
	$context 		= null;
	$messages 		= array();
	$file			= "";
	$path			= "";
	$action			= "";
	
	$viewparams 	= array();
	$error 			= false; 
	$feedback 		= "";

	
	// main players
	$sys 		= eZSys::instance();
	$http		= eZHTTPTool::instance();
	$xPath 		= new XPath();
	$xPath->setXmlOption(XML_OPTION_SKIP_WHITE, 0);
	$inifile = eZINI::instance( "addicted.ini" );
	
	// read ini
	$dictionaries = read_dictionaries($inifile);
	if ($dictionaries === false) {
		$error = true;
		$feedback = "Can not interpret the ini file ... ";
	}	
	
	// get dict, context & action from http
	$file 	= $http->variable('dictionary');
	$cname 	= $http->variable('context');
	$action = "";
	$action = ($http->hasVariable('action-delete'))?"delete":$action;
	$action = ($http->hasVariable('action-update'))?"update":$action;
	$action = ($http->hasVariable('action-insert'))?"insert":$action;
				
	//select dict
	foreach ($dictionaries as $dictionary) {
		if ($dictionary["file"]==$file) break;
	}
	$path = $sys->rootDir().$file;
	
	if (is_file($path) && is_readable($path)) {
		
			
		$xPath->importFromFile($path);
		$context = read_context($xPath,$cname);
		if ($context !== false) {

			// perform action


			
			if ($action) {
			
				if (is_writable($path)) {
					
					if ($action=="insert") {
					
						$msgsource 			= $http->variable('msg-source');
						$msgstatus 			= $http->variable('msg-status');
						$msgtranslation 	= $http->variable('msg-translation');
						if ($action == "insert") {
							
							ob_start();
							$success = insert_message($xPath,$context["name"],$msgsource,$msgstatus,$msgtranslation);
							$result = ob_get_contents();
							ob_end_clean();
							if ($result) $feedback .= $result.";\n";
							if (!$success) {
								$error 		= true;
								$feedback 	.= "; Error inserting '$msgsource [".$msgstatus."] $msgtranslation';\n";
							}	
							
							
							//print $xPath->exportAsXml();
						
						}
					
						
					} else {
			
						// update or delete
						$msgids 			= $http->variable('messages'); // array
						foreach ($msgids as $msgid) {
							$orgsource 		= $http->variable('msg'.$msgid.'-orgsource');
							$orgstatus 		= $http->variable('msg'.$msgid.'-orgstatus');
							$orgtranslation = $http->variable('msg'.$msgid.'-orgtranslation');
							$newsource 		= $http->variable('msg'.$msgid.'-newsource');
							$newstatus 		= $http->variable('msg'.$msgid.'-newstatus');
							$newtranslation 	= $http->variable('msg'.$msgid.'-newtranslation');
							
							if ($action == "update") {
								
								ob_start();
								$success 		= update_message($xPath,$context["name"],$orgsource,$orgstatus,$orgtranslation,$newsource,$newstatus,$newtranslation);
								$result = ob_get_contents();
								ob_end_clean();
								if ($result) $feedback .= $result.";\n";
								
								if (!$success) {
									$error 		= true;
									$feedback 	.= "Error updating '$orgsource'; \n";
								} 
								
							} else if ($action == "delete") {
								
								ob_start();
								$success = delete_message($xPath,$context["name"],$orgsource,$orgstatus,$orgtranslation);
								$result = ob_get_contents();
								ob_end_clean();
								if ($result) $feedback .= $result.";\n";
								
								if (!$success) {
									$error 		= true;
									$feedback 	.= "Error deleting '$orgsource'; \n";
								}	
							
							} else {
								$error 		= true;
								$feedback 	= "Unknown action ($action)";
								break;
							
							}
						}
						
					}
					
					if (!$error) {
					
						//$error 		= true;
						//$feedback 	.= "Export disabled ($action,$path);\n";
						
						if (!$xPath->exportToFile($path)) {
							$error 		= true;
							$feedback 	= "Can not save modified xml ($action,$path)";
						} 
					}
					
				} else {
	
					$error = true;
					$feedback = "Can not write to file ($path)";
				}
			}
			
			ob_start();
			$messages = read_messages($xPath,$cname);
			$result = ob_get_contents();
			ob_end_clean();
			if ($result) $feedback .= $result.";\n";
			
		} else {
		
			$error 		= true;
			$feedback 	= "Can not read context ($cname) from file ($file) ... ";
		}	
		
	
		
	} else {
		$error = true;
		$feedback = "No such file ($path) ?";
	}
	
	
	$viewparams = array(
		"dictionary"	=> $dictionary,
		"context"		=> $context,
		"messages"		=> $messages,
		"action"		=> $action,
		"error"			=> $error,
		"feedback"		=> $feedback
	);
	
	include_once( 'kernel/common/template.php' );
	$tpl = templateInit();
	$tpl->setVariable( 'params', $viewparams);
	
	$Result = array();
	$Result['content'] = $tpl->fetch( 'design:addicted/messages.tpl' );
	$Result['path'] = array( 
						array( 'url' => $module->Functions["menu"]["uri"],	'text' => $module->Name ),
						array( 'url' => $module->Functions["dictionaries"]["uri"],	'text' => $dictionary["name"] ),
						array( 'url' => $module->Functions["contexts"]["uri"].'?dictionary='.$dictionary['file'],	'text' => $context["name"] ),
						array( 'url' => false,	'text' => ($action)?"$action messages":"view messages" ),
					);
					
					
?>
