<style type="text/css">
	{literal}input.full {width:100%;}{/literal}
</style>
<script language="javascript">{literal}

	function selectsolo(checkbox) {
		var checkboxes = checkbox.form['messages[]'];
		for (var cc=0;cc<checkboxes.length;cc++) {
			checkboxes[cc].checked=false;
		}
		checkbox.checked=true;
	}
	function selectinv(form) {
		var checkboxes = form['messages[]'];
		for (var cc=0;cc<checkboxes.length;cc++) {
			checkboxes[cc].checked=!checkboxes[cc].checked;
		}
	}

{/literal}</script>

{if $params.error}
	<div class="message-error">
		<h2>{$params.feedback|wash()}</h2>
	</div>
{elseif ne($params.feedback,'')}
	<div class="message-feedback">
		<h2>{$params.feedback|wash()}</h2>
	</div>
{/if}
	
	
<form id="messagesform" enctype="multipart/form-data" action="messages" method="post">


	<input type="hidden" name="dictionary" value="{$params.dictionary['file']|wash()}" />
	<input type="hidden" name="context" value="{$params.context['name']|wash()}" />
	
	<div class="context-block">
			
	
		<div class="box-header">
			<div class="box-tc">
				<div class="box-ml">
					<div class="box-mr">
						<div class="box-tl">
							<div class="box-tr">
	
								<h2 class="context-title">
									<img src="{$params.dictionary['locale']|flag_icon}" alt="{$params.dictionary['locale']}" />
									{'edit messages'|i18n('extension/addicted/messages')}
								</h2>
								<div class="header-subline"></div>
	
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
										{$params.context['name']|wash()} -
									</p></div>
								-->
								
								<table class="list messages" cellspacing="0">
									
									<tr>
									<th>
										<a href="#" onclick="selectinv(document.getElementById('messagesform'))" 
										/>{'s'|i18n( 'extension/addicted/messages')}</a
										>{'%sep-%sepv%sepx'|i18n( 'extension/addicted/messages','',hash('%sep','&nbsp;&nbsp;|&nbsp;&nbsp;'))}
									</th>
									<th>
										{'source'|i18n( 'extension/addicted/messages' )}
									</th>
									<th>
										{'translation'|i18n( 'extension/addicted/messages' )}
									</th>
									<th>
										{'?'|i18n( 'extension/addicted/messages' )}
									</th>
									
						
									</tr>
									
									{foreach $params.messages as $index=>$message sequence array( 'bglight', 'bgdark' ) as $bgcolor} 
										<tr class="{$bgcolor}">
											{* del. *} 
											<td>
												<input type="checkbox" name="messages[]" value="{$index}" checked="true" 
													ondoubleclick="selectsolo(this)" />
												<input type="hidden" name="msg{$index}-orgstatus" value="{$message['status']}" />
												<input type="radio" name="msg{$index}-newstatus" value="unfinished"
													{if eq($message['status'],'unfinished')}checked="true"{/if} />
												<input type="radio" name="msg{$index}-newstatus" value=""
													{if eq($message['status'],'')}checked="true"{/if} />
												<input type="radio" name="msg{$index}-newstatus" value="obsolete"
													{if eq($message['status'],'obsolete')}checked="true"{/if}  />
													
											</td>
											{* source. dont wash() *} 
											<td>
												<input type="hidden" name="msg{$index}-orgsource" value="{$message['source']}" />
												<input type="text" class="full" name="msg{$index}-newsource" value="{$message['source']}" />
											</td>
											{* translation. dont wash()  *} 
											<td>
												<input type="hidden" name="msg{$index}-orgtranslation" value="{$message['translation']}" />
												<input type="text" class="full" name="msg{$index}-newtranslation" value="{$message['translation']}" />
	
											</td>
											{* comment. *} 
											<td>
												{if ne($message['comment'],'')}
													{$message['comment']|wash()}
												{/if}
	
											</td>
										</tr>
									{/foreach} 
									
								</table>
								
			
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	
		<div class="controlbar">
			<div class="box-bc">
				<div class="box-ml">
					<div class="box-mr">
						<div class="box-tc">
							<div class="box-bl">
								<div class="box-br">
									<div class="block">
										<input type="submit" class="button" name="action-delete" value="delete selected messages"/>
										<input type="submit" class="button" name="action-update" value="update selected messages"/>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	
	
	
			
	</div>

</form>



<form  enctype="multipart/form-data" action="messages" method="post">

	<input type="hidden" name="dictionary" value="{$params.dictionary['file']}" />
	<input type="hidden" name="context" value="{$params.context['name']}" />
	
	<div class="context-block">
			
	
		<div class="box-header">
			<div class="box-tc">
				<div class="box-ml">
					<div class="box-mr">
						<div class="box-tl">
							<div class="box-tr">
	
								<h2 class="context-title">
									<img src="{$params.dictionary['locale']|flag_icon}" alt="{$params.dictionary['locale']}" />
									{'insert new message'|i18n( 'extension/addicted/messages' )}
								</h2>
								<div class="header-subline"></div>
	
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
	
								
								<table class="list messages" cellspacing="0">
									
									<tr>
									<th>
										{'s%sep-%sepv%sepx'|i18n( 'extension/addicted/messages','',hash('%sep','&nbsp;&nbsp;|&nbsp;&nbsp;') )}
									</th>
									<th>
										{'source'|i18n( 'extension/addicted/messages' )}
									</th>
									<th>
										{'translation'|i18n( 'extension/addicted/messages' )}
									</th>
									<th>
										{'action'|i18n( 'extension/addicted/messages' )}
									</th>
	
									
						
									</tr>
									
									<tr class="{$bgcolor}">
										
										{* status. *} 
										<td>
											<input type="checkbox" disabled="true"  />
											<input type="radio" name="msg-status" value="unfinished" />
											<input type="radio" name="msg-status" value="" checked="true" />
											<input type="radio" name="msg-status" value="obsolete" />
												
										</td>
										{* source. *} 
										<td>
											<input type="text" class="full" name="msg-source" value=""  />
										</td>
										{* translation. *} 
										<td>
											<input type="text" class="full" name="msg-translation" value="" />
										</td>
										{* action. *} 
										<td>	
											<input type="submit" class="button" name="action-insert" value="insert"/>
										</td>
									</tr>
									
								</table>
								
			
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		
		
	</div>				

</form>


<div class="break"></div>
<div class="break"></div>
	


