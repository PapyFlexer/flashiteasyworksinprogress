<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable
        name = "textes"
        select ="//TextParameterSet/text" />
	<xsl:variable
            name = "images"
            select ="//ImgParameterSet" />
	<xsl:variable
                name = "videos"
                select ="//VideoParameterSet" />
	<xsl:template match="/">
		<html>
			<head>
				<title>FIE Indexation</title>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
    
	<!-- <xsl:template match="text()" /> -->
	<xsl:template match="//ImgParameterSet/source">
		<xsl:call-template name="displayImg" >
			<xsl:with-param name="img" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="//VideoParameterSet/source">
		<xsl:variable name="text" select="." />
		<p> video :<xsl:value-of select="." /></p>
	</xsl:template>

	<xsl:template match="//TextParameterSet/text">
		<xsl:call-template name="displayText" >
			<xsl:with-param name="text" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	
	<!-- affichage des listes -->
	
	<xsl:template match="//container[@type='ListElementDescriptor']">
		<xsl:variable name="params" select="ListParameterSet/list" />
		<xsl:variable name="text" select="count(XmlParameterSet/xml/xml//control[@type='TextElementDescriptor']/preceding-sibling::*) + 1" />
		<xsl:variable name="img" select="count(XmlParameterSet/xml/xml//control[@type='ImgElementDescriptor']/preceding-sibling::*) + 1" />
		<xsl:if test="XmlParameterSet/xml/xml//control[@type='TextElementDescriptor']">
			<xsl:call-template name="displayList" >
				<xsl:with-param name="type" select='"text"'/>
				<xsl:with-param name="pos" select="$text"/>
				<xsl:with-param name="params" select="$params"/>
				<xsl:with-param name="currentPos" select="1"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="XmlParameterSet/xml/xml//control[@type='ImgElementDescriptor']">
			<xsl:call-template name="displayList" >
				<xsl:with-param name="type" select='"img"'/>
				<xsl:with-param name="pos" select="$img"/>
				<xsl:with-param name="params" select="$params"/>
				<xsl:with-param name="currentPos" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
    
	<xsl:template name="displayList" >
		<xsl:param name="type" />
		<xsl:param name="pos" />
		<xsl:param name="params" />
		<xsl:variable name="currentString" select="substring-before(substring-after($params,'['),']')" />
		<xsl:call-template name="display" >
			<xsl:with-param name="type" select="$type"/>
			<xsl:with-param name="pos" select="$pos"/>
			<xsl:with-param name="params" select="$params"/>
			<xsl:with-param name="currentPos" select="1"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="displayParam" >
		<xsl:param name="type" />
		<xsl:param name="pos" />
		<xsl:param name="params" />
		<xsl:param name="currentPos" />
		<xsl:variable name="currentString" select="substring-before($params,'||')" />
		<xsl:if test="$currentPos=$pos">
			<xsl:if test="$type='text'">
				<xsl:if test="contains($params,'||')">
					<xsl:call-template name="displayText">
						<xsl:with-param name="text" select="$currentString"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="not(contains($params,'||'))">
					<xsl:call-template name="displayText">
						<xsl:with-param name="text" select="$params"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>    
			<xsl:if test="$type='img'">
				<xsl:if test="contains($params,'||')">
					<xsl:call-template name="displayImg">
						<xsl:with-param name="img" select="$currentString"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="not(contains($params,'||'))">
					<xsl:call-template name="displayImg">
						<xsl:with-param name="img" select="$params"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>    
		</xsl:if>
		<xsl:if test="$currentPos != $pos">
			<xsl:call-template name="displayParam">
				<xsl:with-param name="type" select="$type"/>
				<xsl:with-param name="pos" select="$pos"/>
				<xsl:with-param name="params" select="substring-after($params,'||')"/>
				<xsl:with-param name="currentPos" select="$currentPos + 1"/>
			</xsl:call-template>
		</xsl:if>
        
	</xsl:template>
	
	<xsl:template name="display" >
		<xsl:param name="type" />
		<xsl:param name="pos" />
		<xsl:param name="params" />
		<xsl:if test="contains($params,'[')" >
			<xsl:call-template name="displayParam">
				<xsl:with-param name="type" select="$type"/>
				<xsl:with-param name="pos" select="$pos"/>
				<xsl:with-param name="params" select="substring-after(substring-before($params,']'),'[')"/>
				<xsl:with-param name="currentPos" select="1"/>
			</xsl:call-template>
			<xsl:call-template name="display">
				<xsl:with-param name="type" select="$type"/>
				<xsl:with-param name="pos" select="$pos"/>
				<xsl:with-param name="params" select="substring-after($params,']')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- ===================================== -->
	
	<xsl:template name="displayText" >
		<xsl:param name="text" />
		<p>{$text}</p>
	</xsl:template>
	
	<xsl:template name="displayImg" >
		<xsl:param name="img" />
		<img src="../{$img}" />
	</xsl:template>
    
</xsl:stylesheet>
