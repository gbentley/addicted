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
	
	
	function xmlentities($string) {
		return str_replace ( array ( '&', '"', "'", '<', '>', '' ), array ( '&amp;' , '&quot;', '&apos;' , '&lt;' , '&gt;', '&apos;' ), $string );
	}
 
	function numentities($string, $quote_style=ENT_QUOTES)  {
		 static $trans;
		 if (!isset($trans)) {
			$trans = get_html_translation_table(HTML_ENTITIES, $quote_style);
			foreach ($trans as $key => $value)
				$trans[$key] = '&#'.ord($key).';';
			// dont translate the '&' in case it is part of &xxx;
			$trans[chr(38)] = '&';
		 }
		  // after the initial translation, _do_ map standalone '&' into '&#38;'
		  return preg_replace("/&(?![A-Za-z]{0,4}\w{2,3};|#[0-9]{2,3};)/","&#38;" , strtr($string, $trans));
	}
	 
	function read_dictionaries(&$inifile) {
		// read ini
		$dictionaries = array();
		
		$files		= $inifile->variable( 'AddictedSettings', 'DictFiles' );
		$locales	= $inifile->variable( 'AddictedSettings', 'DictLocales' );
		$names		= $inifile->variable( 'AddictedSettings', 'DictNames' );
		$countries	= $inifile->variable( 'AddictedSettings', 'DictCountries' );
	
		if (count($files) && count($files)==count($locales)) {
			for ($fc=0;$fc<count($files);$fc++) {
				$dictionaries[] = array(
					'file' 		=> $files[$fc],	
					'locale' 	=> $locales[$fc],	
					'name' 		=> $names[$fc],	
					'country' 	=> $countries[$fc],	
					
				);
			}
			return $dictionaries;
		} else {
			eZDebug::writeDebug( "Number of files and locales in addicted.ini do not match", 'Addicted' );
			return false;
		}
	}	
	
	function read_contexts(&$xPath) {
		$cname = ""; $summary = "";
		$contexts = array();
		$ctxpaths = $xPath->match("/TS/context");
		if (count($ctxpaths)) {
			foreach ($ctxpaths as $ctxpath) {
				$cname = $xPath->wholeText("$ctxpath/name[1]");
				//$nummsg = count($xPath->match("message",$ctxpath));
				// performance hit ..
				//$numobs = count($xPath->match("message/translation[@type='obsolete']",$ctxpath));
				//$numunf = count($xPath->match("message/translation[@type='unfinished']",$ctxpath));
				//$numok = $nummsg - $numobs - $numunf;
				//$summary = "$nummsg messages ($numok/$numunf/$numobs)";
				//$summary = "$nummsg messages";
				$contexts[] = array("name"=>$cname,"summary"=>$summary);
			}
		} else {
			eZDebug::writeDebug( "No contexts found", 'Addicted' );
		}
		return $contexts;
	}
	
	function read_context(&$xPath,$cname) {
		$ctxpath = $xPath->match("/TS/context[name=$cname]");
		$nummsg = count($xPath->match("$ctxpath/message"));
		$numobs = count($xPath->match("$ctxpath/message/translation[@type='obsolete']"));
		$numunf = count($xPath->match("$ctxpath/message/translation[@type='unfinished']"));
		$numok = $nummsg - $numobs - $numunf;
		$summary = "$nummsg messages ($numok/$numunf/$numobs)";
		$context = array("name"=>$cname,"summary"=>$summary);
		return $context;
	}
	
	function read_messages(&$xPath,$cname) {
		//$ctxpath = $xPath->match("/TS/context[name=$cname]");
		$messages = array();
		$msgpaths = $xPath->match("/TS/context[name='$cname']/message");
		if (count($msgpaths)) {
			foreach ($msgpaths as $msgpath) {
				//print $msgpath;
				$source 	= ($xPath->match("$msgpath/source[1]"))?$xPath->wholeText("$msgpath/source[1]"):"";
				
				$translation = ($xPath->match("$msgpath/translation[1]"))?$xPath->wholeText("$msgpath/translation[1]"):"";
				if ($translation) {
					$status = ($xPath->match("$msgpath/translation[1]/@type"))?$xPath->wholeText("$msgpath/translation[1]/@type"):"";
				} else {
					$status = "";
				}
				$comment 	= ($xPath->match("$msgpath/comment[1]"))?$xPath->wholeText("$msgpath/comment[1]"):"";
				$messages[] = array("source"=>$source,"status"=>$status,"translation"=>$translation,"comment"=>$comment);
			}
		} else {
			print "No messages in context $cname";
		}
		return $messages;
	}
	
	function insert_message(&$xPath,$cname,$source,$status,$translation) {
	
		$curpaths = $xPath->match("/TS/context[name='$cname']/message[source='".xmlentities($source)."']");
		if (count($curpaths)) {
			print "A message with source '$source' already exists in this context, either delete it or update it";
			return false;
		}
		
		$newnode = "<message>\n";
		$newnode .= "	<source>".xmlentities($source)."</source>\n";
		$newnode .= "	<translation ".(($status)?"type=\"$status\"":"").">";
		$newnode .= xmlentities($translation)."</translation>\n";
		$newnode .= "</message>";
		
		$success = false;
		$ctxpaths = $xPath->match("/TS/context[name='$cname']");
		if (count($ctxpaths)) {
			$msgpaths = $xPath->match("$ctxpaths[0]/message");
			if (count($msgpaths)) {
				print "Inserting message before $msgpaths[0] ..";
				$success = $xPath->insertBefore($msgpaths[0], $newnode);
				print ".. done";
			} else {
				print "Appending message at $ctxpaths[0] ..";
				$success = $xPath->appendChild($ctxpaths[0], $newnode);
				if ($success) print ".. done";
			}
		} else {
			print "No such context: $cname";
		}
		
		return $success;
	}
	
	
	function update_message(&$xPath,$cname,$orgsource,$orgstatus,$orgtranslation,$source,$status,$translation) {
		$success = false;
		
		if ($orgsource===$source && $orgstatus===$status && $orgtranslation===$translation) {
			return true;
		}
		
		$msgpaths = $xPath->match("/TS/context[name='$cname']/message[source='".xmlentities($orgsource)."']");
		if (count($msgpaths)) {
			// check status and translation
			$msgpath = $msgpaths[0];
			$transpaths = $xPath->match("$msgpath/translation[text()='".xmlentities($orgtranslation)."']");
			if (count($transpaths)) {
				$transpath = $transpaths[0];
				if ($orgstatus) $statpaths = $xPath->match("$transpath"."[@type='$orgstatus']");
				if (!$orgstatus || count($statpaths)) {
					
					$newnode = "<message>\n";
					$newnode .= "	<source>".xmlentities($source)."</source>\n";
					$newnode .= "	<translation ".(($status)?"type=\"$status\"":"").">";
					$newnode .= xmlentities($translation)."</translation>\n";
					$newnode .= "</message>";
		
					print "Replacing message at $msgpath ..";
					$success = $xPath->replaceChild($msgpath, $newnode);
					if ($success) print ".. done";
					
				} else {
					print "Won't replace '$msgpath': status '$status' does not match  current value";
					$success = false;
				}
			} else {
				print "Won't replace '$msgpath': translation '$orgtranslation' does not match current value";
				$success = false;
			}
		} else {
			print "No message with source '$orgsource' exists in this context";
			$success = false;
		}

		return $success;
	}
	
	function delete_message(&$xPath,$cname,$source,$status,$translation) {
		$success = false;
		
		$msgpaths = $xPath->match("/TS/context[name='$cname']/message[source='".xmlentities($source)."']");
		if (count($msgpaths)) {
			// check status and translation
			$msgpath = $msgpaths[0];
			$transpaths = $xPath->match("$msgpath/translation[text()='".xmlentities($translation)."']");
			if (count($transpaths)) {
				$transpath = $transpaths[0];
				if ($status) $statpaths = $xPath->match("$transpath"."[@type='$status']");
				if (!$status || count($statpaths)) {
					print "Deleting $msgpath ..";
					$success = $xPath->removeChild($msgpath);
					if ($success) print ".. done";
				} else {
					print "Won't delete '$msgpath': status '$status' does not match  current value";
					$success = false;
				}
			} else {
				print "Won't delete '$msgpath': translation '$translation' does not match current value";
				$success = false;
			}
		} else {
			print "No message with source '$source' exists in this context";
			$success = false;
		}

		return $success;
	}
	
					
?>