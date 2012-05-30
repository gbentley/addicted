<?php
//
// Created on: <20-09-2006> pike@labforculture.org
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

// this script does not use a template.
// it simply lists all available views from the current 
// module in admin style



//include_once( 'kernel/common/template.php' );
//$tpl = templateInit();
//$tpl->setVariable( 'view_parameters', array( 'test' => true ) );


$Module = $Params['Module'];
$modulename = $Module->Name;

$Result = array();


ob_start();

print <<<END
	<div class="context-block">
	
		<div class="box-header">
			<div class="box-tc">
				<div class="box-ml">
					<div class="box-mr">
						<div class="box-tl">
							<div class="box-tr">
								<h1 class="context-title">$modulename</h1>
								<div class="header-mainline"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	
		<div class="box-bc">
			<div class="box-ml">
				<div class="box-mr">
					<div class="box-bl">
						<div class="box-br">
							<div class="box-content">
								<!--
									<div class="context-information"><p>
										<b>message</b>
									</p></div>
								-->	
								<table class="list tools" cellspacing="0">
									<tr><th>Available views</th></tr>
												
												
END;
//----------

foreach ($Module->Functions as $name=>$stuff) {
	$ord = ($ord=='bgdark') ? 'bglight' : 'bgdark' ;
	print "<tr class='$ord'><td><a href='$name'>$name</a></td></tr>\n";
}

print <<<END
								</table>
									
				
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--
			<div class="controlbar">
				<div class="box-bc">
					<div class="box-ml">
						<div class="box-mr">
							<div class="box-tc">
								<div class="box-bl">
									<div class="box-br">
										<div class="block">
											<b>controlbar</b>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		-->			
	</div>

END;
//----------



$Result['content'] 	= ob_get_contents();
ob_end_clean();

$Result['path'] = array(
					array( 'url' => $Module->Functions["menu"]["uri"],	'text' => $Module->Name )
				);
?>
