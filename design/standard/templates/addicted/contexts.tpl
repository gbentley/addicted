{if $params.error}
	<div class="message-error">
		<h2>{$params.feedback|wash()}</h2>
	</div>
{elseif ne($params.feedback,'')}
	<div class="message-feedback">
		<h2>{$params.feedback|wash()}</h2>
	</div>
{/if}
	
<div class="context-block">
		

	<div class="box-header">
		<div class="box-tc">
			<div class="box-ml">
				<div class="box-mr">
					<div class="box-tl">
						<div class="box-tr">

							<h2 class="context-title">
								<img src="{$params.dictionary['locale']|flag_icon}" alt="{$params.dictionary['locale']}" />
								{$params.dictionary['name']|wash()} - 
								{'select context'|i18n( 'extension/addicted/contexts')}
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
									
								</p></div>
							-->
							<table class="list contexts" cellspacing="0">
								
								<tr>
								<th>
									{'Name'|i18n( 'extension/addicted/contexts' )}
								</th>
								<th>
									{'Summary'|i18n( 'extension/addicted/contexts' )}
								</th>
					
								</tr>
								
								{foreach $params.contexts as $context sequence array( 'bglight', 'bgdark' ) as $bgcolor} 
									<tr class="{$bgcolor}">
										{* Name. *} 
										<td>
											<a href='messages?dictionary={$params.dictionary['file']}&context={$context['name']}'>
											{$context['name']|wash()}</a>
										</td>
										{* Summary. *} 
										<td>
											{$context['summary']|wash()}
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
	
	<!--
	<div class="controlbar">
		<div class="box-bc">
			<div class="box-ml">
				<div class="box-mr">
					<div class="box-tc">
						<div class="box-bl">
							<div class="box-br">
								<div class="block">
									<input type="hidden" name="action" value="import" />
									<input type="submit" class="button" name="submitXMLData" value="Import file"/>
									<input type="checkbox" value="on"  name="reportfields" {if $view_parameters.settings.reportfields}checked{/if} />
									display imported field values
									
										<input type="checkbox" value="on"  name="testrun" {if $view_parameters.settings.testrun}checked{/if} />
										test run only
									
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



<div class="break"></div>
<div class="break"></div>
	


