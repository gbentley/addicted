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
	{* DESIGN: Header START *}
	<div class="box-header">
		<div class="box-tc">
			<div class="box-ml">
				<div class="box-mr">
					<div class="box-tl">
						<div class="box-tr">
							<h1 class="context-title">
								{'Select dictionary'|i18n( 'extension/addicted/dictionaries')}
							</h1>
							{* DESIGN: Mainline *}
							<div class="header-mainline">
							</div>
							{* DESIGN: Header END *}
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	{* DESIGN: Content START *}
	<div class="box-ml">
		<div class="box-mr">
			<div class="box-content">
				<table class="list dictionaries" cellspacing="0">
					<tr>
						<th>
							{'Name'|i18n( 'extension/addicted/dictionaries' )}
						</th>
						<th>
							{'Country'|i18n( 'extension/addicted/dictionaries' )}
						</th>
						<th>
							{'Locale'|i18n( 'extension/addicted/dictionaries' )}
						</th>
					</tr>
					{foreach $params.dictionaries as $dictionary sequence array( 'bglight', 'bgdark' ) as $bgcolor} 
						<tr class="{$bgcolor}">
							{* Language. *} 
							<td>
								<img src="{$dictionary['locale']|flag_icon}" alt="{$dictionary['locale']}" />
								<a href='contexts?dictionary={$dictionary['file']}'>
								{$dictionary['name']|wash()}</a>
							</td>
							{* Country. *} 
							<td>
								{$dictionary['country']|wash()}
							</td>
							{* Locale. *} 
							<td>
								{$dictionary['locale']|wash()}
							</td>
						</tr>
					{/foreach} 
				</table>
				{* DESIGN: Content END *}
			</div>
		</div>
	</div>
	
	<!--
	<div class="controlbar">
		{* DESIGN: Control bar START *}
		<div class="box-bc">
			<div class="box-ml">
				<div class="box-mr">
					<div class="box-tc">
						<div class="box-bl">
							<div class="box-br">
								<div class="block">
									<input class="button" type="submit" name="RemoveButton" value="{'Remove selected'|i18n( 'design/admin/content/translations' )}" title="{'Remove selected languages.'|i18n( 'design/admin/content/translations' )}" />
									<input class="button" type="submit" name="NewButton" value="{'Add language'|i18n( 'design/admin/content/translations' )}" title="{'Add a new language. The new language can then be used when translating content.'|i18n( 'design/admin/content/translations' )}" />
								</div>
								{* DESIGN: Control bar END *}
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	-->
	
</div>

