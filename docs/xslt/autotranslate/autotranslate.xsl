<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:exsl="http://exslt.org/common" version="1.0">
	<!-- 
		
			autotranslate.xsl	pike@labforculture.org 200808
			
			usage: 
			
				xsltproc - -stringparam usecomments yes autotranslate.xsl input.ts
						
			this takes a dictionary, and returns a dictionary
			where for all instances of 'translation' that had no value
			a translation for 'source' was looked for in the rest of the file
			and if found, filled in in the translation
			
			if 'usecomments' is given, and the untranslated message
			had a comment, it will look for a translation of this comment
			instead of the source
			
			before processing:
			
			<context>
				<name>suppa</name>
				<message>
					<source>foo</source>
					<translation>bar</translation>
				</message>
			</context>
			<context>
				<name>aqua</name>
				<message>
					<source>foo</source>
					<translation></translation>
				</message>
			</context>
			
			after processing :
			
			<context>
				<name>suppa</name>
				<message>
					<source>foo</source>
					<translation>bar</translation>
				</message>
			</context>
			<context>
				<name>aqua</name>
				<message>
					<source>foo</source>
					<translation type="unfinished">bar</translation>
				</message>
			</context>
			
	-->

	<xsl:output method="xml" 
		encoding="utf-8" 
		omit-xml-declaration="yes"
		indent="yes"
		doctype-system="TS" />
	
	<xsl:param name="usecomments"></xsl:param>
	
	<xsl:template match="TS">
		<xsl:message>Autotranslate: starting ..</xsl:message>
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="context">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="name">
		<xsl:message>=================</xsl:message>
		<xsl:message>Context <xsl:value-of select="." /></xsl:message>
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
  
	<xsl:template match="message">
		<!--
			<xsl:message>message '<xsl:value-of select="source" />'</xsl:message>
		-->
		<xsl:copy>
			<xsl:copy-of select="source" />
			<xsl:copy-of select="comment" />
			<xsl:if test="translation!=''">
				<xsl:copy-of select="translation">
					<xsl:apply-templates select="@*"/>
				</xsl:copy-of>
			</xsl:if>
			<xsl:if test="translation=''">
				<!--
					<xsl:message>yet untranslated...</xsl:message>
				-->
				<xsl:variable name="source">
					<xsl:if test="$usecomments!=''">
						<xsl:if test="comment">
							<xsl:value-of select="comment" />
						</xsl:if>
						<xsl:if test="not(comment)">
							<xsl:value-of select="source" />
						</xsl:if>
					</xsl:if>
					<xsl:if test="$usecomments=''">
						<xsl:value-of select="source" />
					</xsl:if>
				</xsl:variable>
				<xsl:message>translating '<xsl:value-of select="$source" />'...</xsl:message>
				<xsl:variable name="translationsfrag">
					<xsl:call-template name="translate">
						<xsl:with-param name="source" select="$source" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="translations" select="exsl:node-set($translationsfrag)" />
				<!--
					<xsl:message>translations: <xsl:value-of select="$translations" /></xsl:message>
				-->
				<xsl:variable name="translated">
					<xsl:if test="$translations/translation[@type='finished']">
						<xsl:message>found finished translation</xsl:message>
						<xsl:value-of select="$translations/translation[@type='finished'][1]" />
					</xsl:if>
					<xsl:if test="not($translations/translation[@type='finished'])">
						<xsl:if test="$translations/translation[@type='obsolete']">
							<xsl:message>found obsolote translation</xsl:message>
							<xsl:value-of select="$translations/translation[@type='obsolete'][1]" />
						</xsl:if>
						<xsl:if test="not($translations/translation[@type='obsolete'])">
							<xsl:if test="$translations/translation[@type='unfinished']">
								<xsl:message>found unfinished translation</xsl:message>
								<xsl:value-of select="$translations/translation[@type='unfinished'][1]" />
							</xsl:if>
							<xsl:if test="not($translations/translation[@type='unfinished'])">
								<xsl:message>no translation found !</xsl:message>
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:variable>
				<xsl:message>=&gt;<xsl:value-of select="$translated" /></xsl:message>
				<translation type="unfinished">
					<xsl:value-of select="$translated" />
				</translation>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>
  
	<xsl:template name="translate">
		<xsl:param name="context"></xsl:param>
		<xsl:param name="source">foo</xsl:param>
		<xsl:param name="type"></xsl:param>
		<xsl:if test="$context=''">
			<xsl:for-each select="//context">
				<xsl:call-template name="_translatectx">
					<xsl:with-param name="source" select="$source" />
					<xsl:with-param name="type" select="$type" />
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="$context!=''">
			<xsl:for-each select="//context[name=$context]">
				<xsl:call-template name="_translatecontext">
					<xsl:with-param name="source" select="$source" />
					<xsl:with-param name="type" select="$type" />
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="_translatectx">
		<xsl:param name="source">foo</xsl:param>
		<xsl:param name="type"></xsl:param>
		<xsl:for-each select="message[source=$source]">
			<xsl:if test="translation!=''">
				<xsl:if test="$type=''">
					<xsl:call-template name="_translatecopy" />
				</xsl:if>
				<xsl:if test="$type!='' and translation/@type=$type">
					<xsl:call-template name="_translatecopy" />
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="_translatecopy">
		<xsl:if test="translation/@type">
			<xsl:copy-of select="translation" />
		</xsl:if>
		<xsl:if test="not(translation/@type)">
			<xsl:element name="translation">
				<xsl:attribute name="type">finished</xsl:attribute>
				<xsl:value-of select="translation" />
			</xsl:element>
		</xsl:if>		
	</xsl:template>
</xsl:stylesheet>