<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<xsl:variable name = "path_to_project" select ="string('../')" />
<xsl:variable name = "link_level" select ="/page/@link" />
	<xsl:output method="xml"

	media-type="text/html"  omit-xml-declaration="yes"

               doctype-public= "-//W3C//DTD XHTML 1.0 Strict//EN"

               doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"

               indent="yes"/>

	<xsl:template match="/">

	<html>
		<head>
		<title>
		 <xsl:value-of select="//metas/pageinfo/title"/> 
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
		<meta name="Keywords">
						<xsl:attribute name="content">
							<xsl:value-of select="//metas/pageinfo/keywords"  />
						</xsl:attribute>
		</meta>
		<meta name="Description">
						<xsl:attribute name="content">
							<xsl:value-of select="//metas/pageinfo/description"  />
						</xsl:attribute>
		</meta>
			<style type="text/css">
			<xsl:text>
			
			* {
			      margin:0;
			      padding:0; 
			}
			p
			{
				line-height:90% ;
			}
			  </xsl:text>
</style>
		<script type="text/javascript" >
			<xsl:attribute name="src">
				<xsl:copy-of select="$path_to_project" />
				<xsl:value-of select="$link_level" />
				<xsl:text>js/swfobject.js</xsl:text>
			</xsl:attribute>
		</script>

		<script type="text/javascript">
		<xsl:text>
				var flashvars = {};
				flashvars.redirect = "</xsl:text>
				<xsl:copy-of select="$path_to_project" />
				<xsl:value-of select="$link_level" />
				<xsl:value-of select="//metas/href"  />
				<xsl:text>"
				var attributes = {id: "flashredir"};
				var params = {};
				params.menu = "false";
				params.quality = "high";
				params.scale = "noscale";
				params.salign = "tl";
				params.bgcolor = "#ffffff";
				params.allowFullScreen = "true";
				params.allowScriptAccess = "always";
				swfobject.embedSWF("</xsl:text>
				<xsl:copy-of select="$path_to_project" />
				<xsl:value-of select="$link_level" />
				<xsl:text>config/redirect.swf", "flashredir", "10", "10", "0", "expressInstall.swf", flashvars, params, attributes);
				</xsl:text>
			</script>			  
			  
			  
			  
			  
			  
			  
			  
		<script type="text/javascript">
			<xsl:text>
			  var _gaq = _gaq || [];
			  _gaq.push(['_setAccount', '</xsl:text>
			  <xsl:value-of select="//metas/gc"  />
			  <xsl:text>']);
			  _gaq.push(['_trackPageview']);
			
			  (function() {
			    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
			    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
			    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
			  })();
			 </xsl:text>
</script>
		</head>

		<body>
		<div id="flashredir"></div>
		<xsl:apply-templates/>
		</body>
	</html>
	</xsl:template>
	
	<xsl:template match="//control" >
		<xsl:call-template name="buildLink" />
	</xsl:template>
	
	<xsl:template match="//container">
		<xsl:call-template name="buildLink">

			<xsl:with-param name="type" select="string('container')" />

		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="buildComponent">
		<xsl:if test="contains(@type,'CheckBoxElementDescriptor')">
				<xsl:if test="not(./LabelPlacementParameterSet/labelPlacement)">
					<p>
					<xsl:call-template name="buildStyle" >
					   <xsl:with-param name="add_id" select="false"/>

					</xsl:call-template>
					<label>
						<xsl:attribute name="for">
							<xsl:value-of select="@id"  />
						</xsl:attribute>
						<xsl:value-of select="./LabelParameterSet/label" />
					</label>
					<input type="checkbox" style="margin-left:5px;">
						<xsl:attribute name="id">
							<xsl:value-of select="@id"  />
						</xsl:attribute>
						<xsl:if test='./FormItemParameterSet/name' >
							<xsl:attribute name="name">
								<xsl:value-of select='./FormItemParameterSet/name'  />
							</xsl:attribute>
						</xsl:if>
					</input>
					</p>
				</xsl:if>
				<xsl:if test="./LabelPlacementParameterSet/labelPlacement='bottom'">
					<div>
						<xsl:call-template name="buildStyle" />
						<p style="text-align: center; vertical-align: middle;">
							<input type="checkbox" style="margin:auto;">
							<xsl:if test='./FormItemParameterSet/name' >
								<xsl:attribute name="name">
									<xsl:value-of select='./FormItemParameterSet/name'  />
								</xsl:attribute>
							</xsl:if>
							</input>
							<br />
							<xsl:value-of select="./LabelParameterSet/label" />
						</p>
					</div>
				</xsl:if>
				<xsl:if test="./LabelPlacementParameterSet/labelPlacement='right'">
					<p>
					<xsl:call-template name="buildStyle" />
					<input type="checkbox" style="margin-right:5px;" />
					<xsl:value-of select="./LabelParameterSet/label" />
					<xsl:if test='./FormItemParameterSet/name' >
						<xsl:attribute name="name">
							<xsl:value-of select='./FormItemParameterSet/name'  />
						</xsl:attribute>
					</xsl:if>
		
					</p>
				</xsl:if>
				<xsl:if test="./LabelPlacementParameterSet/labelPlacement='top'">
					<div>
						<xsl:call-template name="buildStyle" />
						<p style="text-align: center; vertical-align: middle;">
							
							<xsl:value-of select="./LabelParameterSet/label" />
							<br />
							<input type="checkbox" style="margin:auto;">
							<xsl:if test='./FormItemParameterSet/name' >
								<xsl:attribute name="name">
									<xsl:value-of select='./FormItemParameterSet/name'  />
								</xsl:attribute>
							</xsl:if>
							</input>
							
						</p>
					</div>
				</xsl:if>
		</xsl:if>
		<xsl:if test="contains(@type,'TextElementDescriptor')">
			<div>
				<xsl:call-template name="buildStyle" />
				<xsl:value-of select="./TextParameterSet/text" disable-output-escaping="yes" />
			</div>
		</xsl:if>
		<xsl:if test="contains(@type,'ComboBox')">
			<select>
				<xsl:call-template name="buildStyle" />
				
<xsl:call-template name="buildSelect" />
			</select>
		</xsl:if>
		<xsl:if test="contains(@type,'TextInput')">
			<input type="text">
			<xsl:if test='./FormItemParameterSet/name' >
				<xsl:attribute name="name">
					<xsl:value-of select='./FormItemParameterSet/name'  />
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="buildStyle" />
	
			</input>
		</xsl:if>
		<xsl:if test="contains(@type,'DailyMotion')">
			<object type="application/x-shockwave-flash">
				<xsl:call-template name="buildStyle" />
				<xsl:attribute name="data">
				<xsl:if test="DailyMotionParameterSet/apiDomain='youtube'">
						<xsl:text>http://www.youtube.com/v/</xsl:text>
						<xsl:value-of select="DailyMotionParameterSet/source" />
				</xsl:if>
				<xsl:if test="not(DailyMotionParameterSet/apiDomain='youtube')">
						<xsl:text>http://www.dailymotion.com/swf/video/</xsl:text>
						<xsl:value-of select="DailyMotionParameterSet/source" />
				</xsl:if>
				</xsl:attribute>
				
				<param name="wmode" value="transparent" />
				<xsl:if test="DailyMotionParameterSet/apiDomain='youtube'">
						<param name="FlashVars" value="playerMode=embedded" />
				</xsl:if>
				<xsl:if test="not(DailyMotionParameterSet/apiDomain='youtube')">
					<param name="movie">
					<xsl:attribute name="value">
						<xsl:text>http://www.dailymotion.com/video/swf/</xsl:text>
						<xsl:value-of select="DailyMotionParameterSet/source" />
					</xsl:attribute>
					</param>
					<param name="allowFullScreen" value="true"></param>
					<param name="allowScriptAccess" value="always" />
				</xsl:if>
			</object>
		</xsl:if>
		<xsl:if test="contains(@type,'InternalBrowsing')">
			<xsl:variable name = "id" select ="TargetsParameterSet/target" />
		</xsl:if>
		<xsl:if test="contains(@type,'SwfElementDescriptor')">
			<object type="application/x-shockwave-flash">
				<xsl:call-template name="buildStyle" />
				<xsl:attribute name="data">
					<xsl:copy-of select="$path_to_project" />
					<xsl:value-of select="$link_level" />
					<xsl:value-of select="ImgParameterSet/source" />
				</xsl:attribute>
				<param name="wmode" value="transparent"/>
				<param name="allowFullScreen" value="true"></param>
				<param name="allowScriptAccess" value="always" />
				<param name="salign" value="tl" />
				<xsl:if test="not(ResizableParameterSet)">
					<param name="scale" value="exactfit" />
				</xsl:if>
				<xsl:if test="ResizableParameterSet/mode='no_scale'">
					<param name="scale" value="noscale" />
				</xsl:if>
				<xsl:if test="ResizableParameterSet/mode='scale'">
				</xsl:if>
			</object>
		</xsl:if>
		<xsl:if test="contains(@type,'VideoElementDescriptor')">
			<object>
				<xsl:call-template name="buildStyle" />
				<xsl:attribute name="data">
					<xsl:value-of select="VideoParameterSet/source" />
				</xsl:attribute>
				
				<xsl:attribute name="type">	
					<xsl:if test="contains(VideoParameterSet/source,'.avi')">
						<xsl:text>video/avi</xsl:text>	
					</xsl:if>
					<xsl:if test="contains(VideoParameterSet/source,'.flv')">
						<xsl:text>video/flv</xsl:text>	
					</xsl:if>
				</xsl:attribute>
				
			</object> 
		</xsl:if>
		<xsl:if test="contains(@type,'ImgElementDescriptor')">
			<img>
			<xsl:choose>
				<xsl:when test='./ResizableParameterSet/mode="no_scale"'>
					<xsl:call-template name="buildStyle" >
						<xsl:with-param name="enable_size" select="'false'" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
	  				<xsl:call-template name="buildStyle" />
	   			</xsl:otherwise>
   			</xsl:choose>

			
			<xsl:attribute name="src">
				<xsl:copy-of select="$path_to_project" />
				<xsl:value-of select="$link_level" />
				<xsl:value-of select="./ImgParameterSet/source"  />
			</xsl:attribute>
			<xsl:attribute name="alt">
				<xsl:value-of select="@id"  />
			</xsl:attribute>
			</img>
		</xsl:if>
		<xsl:if test="contains(@type,'RectElementDescriptor')">
			<div>
	  			<xsl:call-template name="buildStyle" />
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="text()" />


	<xsl:template name="buildSelect" >

		
				<xsl:call-template name="split">
					<xsl:with-param name="string">
						<xsl:value-of select="./DataProviderParameterSet/labels"/>
					</xsl:with-param>
					<xsl:with-param name="data">
						<xsl:value-of select="./DataProviderParameterSet/datas"/>
					</xsl:with-param>
				</xsl:call-template>

	</xsl:template>
	
	<xsl:template name="buildLink" >
		 <xsl:param name="type" select="string('control')" />
		 <xsl:variable name="id" select="@id" />

		 <xsl:choose>
		<xsl:when test="//action[contains(@type,'ExternalBrowsingAction')]/TargetsParameterSet/targets=@id and //action[contains(@type,'ExternalBrowsingAction')]/TargetsParameterSet[targets=$id]/../@page=@page ">
			
			<a>

				<xsl:attribute name="href">
					<xsl:value-of select="//action[contains(@type,'ExternalBrowsingAction')]/TargetsParameterSet[targets/text()=$id]/../ExternalLinkParameterSet/link" />
				</xsl:attribute>
				<xsl:attribute name="title">
					<xsl:value-of select="lol" />
				</xsl:attribute>
				<xsl:if test="$type='container'">
					<div>
						<xsl:call-template name="buildStyle" />

						<xsl:call-template name="buildComponent" />

						<xsl:apply-templates/>

					</div>

				</xsl:if>
				<xsl:if test="$type='control'">

						<xsl:call-template name="buildComponent" />
				</xsl:if>
			</a>
		</xsl:when>
		<xsl:when test="//action[contains(@type,'InternalBrowsingAction')]/TargetsParameterSet/targets=@id and //action[contains(@type,'InternalBrowsingAction')]/TargetsParameterSet[targets=$id]/../@page=@page">
			<a>

				<xsl:attribute name="href">
					<xsl:value-of select="$link_level" />
					<xsl:value-of select="//action[contains(@type,'InternalBrowsingAction')]/TargetsParameterSet[targets/text()=$id]/../InternalLinkParameterSet/page" />
					<xsl:text>.html</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="title">
					<xsl:value-of select="@id" />
				</xsl:attribute>
				<xsl:if test="$type='container'">

					<div>

						<xsl:call-template name="buildStyle" />

						<xsl:call-template name="buildComponent" />

						<xsl:apply-templates/>

					</div>
					
				</xsl:if>
				<xsl:if test="$type='control'">

						<xsl:call-template name="buildComponent" />
				</xsl:if>
			</a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="$type='container'">

					<div>

						<xsl:call-template name="buildStyle" />

						<xsl:call-template name="buildComponent" />

						<xsl:apply-templates/>

					</div>
					
				</xsl:if>
				<xsl:if test="$type='control'">

						<xsl:call-template name="buildComponent" />

						<xsl:apply-templates/>
				</xsl:if>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="split">
		<xsl:param name="string"/>
		<xsl:param name="data"/>
		<xsl:choose>
			<xsl:when test="contains($string,',')">
				<option>
					<xsl:attribute name="value">
						<xsl:value-of select="substring-before($data,',')"/>
					</xsl:attribute>
					<xsl:value-of select="substring-before($string,',')"/>
				</option>
				<xsl:call-template name="split">
					<xsl:with-param name="string">
						<xsl:value-of select="substring-after($string,',')"/>
					</xsl:with-param>
					<xsl:with-param name="data">
						<xsl:value-of select="substring-after($data,',')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<option>
					<xsl:attribute name="value">
						<xsl:value-of select="$data"/>
					</xsl:attribute>
					<xsl:value-of select="$string"/>
				</option>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="buildId" >
		<xsl:call-template name="string-replace-all">
	      <xsl:with-param name="text" select="@page" />
	      <xsl:with-param name="replace" select="'/'" />
	      <xsl:with-param name="by" select="'_'" />
	    </xsl:call-template>
		<xsl:text>_</xsl:text>
		<xsl:value-of select="@id"/>
	</xsl:template>
	
	
	<xsl:template name="buildStyle" >
		 <xsl:param name="enable_size" select="string('true')" />
		 <xsl:param name="add_id" select="string('true')" />
		 <xsl:if test="$add_id='true'">
			 <xsl:attribute name="id">
				<xsl:call-template name="buildId" />
			</xsl:attribute>
		</xsl:if>
		<xsl:attribute name="style">
		<xsl:call-template name="makePositionStyle" />
		<xsl:if test="$enable_size='true'">
			<xsl:call-template name="makeSizeStyle" />
		</xsl:if>
		<xsl:call-template name="makeBorderStyle" />
		<xsl:call-template name="makeBackgroundStyle" />
	
		<xsl:call-template name="makePointerStyle" />
		</xsl:attribute>
		<xsl:if test="./BackgroundImageParameterSet/alpha">
			<xsl:call-template name="makeBackgroundImageAlpha" />
		</xsl:if>
	
	</xsl:template>
	<xsl:template name="makePointerStyle">
		<xsl:choose>
		<xsl:when test="./MouseEnableParameterSet[enableMouse='false']">
			<xsl:text>pointer-events:none;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
		<xsl:if test="../../MouseEnableParameterSet[enableMouse='false']">
			<xsl:if test="not(../../MouseEnableParameterSet[enableMouseChildren='false'])">
				<xsl:text>pointer-events:auto;</xsl:text>
			</xsl:if> 
		</xsl:if>
		</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	<xsl:template name="makeSizeStyle">
			<xsl:text> width: </xsl:text> 
			<xsl:if test="not(./SizeParameterSet/width)">
				<xsl:text>100</xsl:text> 
			</xsl:if>
			<xsl:if test="./SizeParameterSet/width">
				<xsl:value-of select ="./SizeParameterSet/width/text()" /> 
			</xsl:if>
			
			<xsl:if test="./SizeParameterSet[is_percent_w='true']">
				<xsl:text>%;</xsl:text>
			</xsl:if>
			<xsl:if test="not(./SizeParameterSet[is_percent_w='true'])">
				<xsl:text>px;</xsl:text>
			</xsl:if>
			
			<xsl:text> height: </xsl:text>
			<xsl:if test="not(./SizeParameterSet/height)">
				<xsl:text>100</xsl:text> 
			</xsl:if>
			<xsl:if test="./SizeParameterSet/height">
				<xsl:value-of select ="./SizeParameterSet/height/text()" /> 
			</xsl:if>
			<xsl:if test="./SizeParameterSet[is_percent_h='true']">
				<xsl:text>%;</xsl:text>
			</xsl:if>
			<xsl:if test="not(./SizeParameterSet[is_percent_h='true'])">
				<xsl:text>px;</xsl:text>
			</xsl:if>
			
		
	<xsl:if test="./AlphaParameterSet/alpha">
		<xsl:text>filter: alpha(opacity=</xsl:text>
		<xsl:value-of select="round(./AlphaParameterSet/alpha * 100)" />
		<xsl:text>); opacity: 0.</xsl:text>
		<xsl:value-of select="round(./AlphaParameterSet/alpha * 100)" />
		<xsl:text>;</xsl:text>
	</xsl:if>
	<xsl:if test="./MaskTypeParameterSet[enable='true']">
	<xsl:text> overflow: hidden;</xsl:text>
	</xsl:if>
	<xsl:if test="./MaskTypeParameterSet/RoundedCornerParameterSet">
	
	<xsl:text> -moz-border-radius: </xsl:text>
	<xsl:value-of select ="./MaskTypeParameterSet/RoundedCornerParameterSet/topLeft" />
	<xsl:text>px </xsl:text>
	<xsl:value-of select ="./MaskTypeParameterSet/RoundedCornerParameterSet/topRight" />
	<xsl:text>px </xsl:text>
	<xsl:value-of select ="./MaskTypeParameterSet/RoundedCornerParameterSet/bottomRight" />
	<xsl:text>px </xsl:text>
	<xsl:value-of select ="./MaskTypeParameterSet/RoundedCornerParameterSet/bottomLeft" />
	<xsl:text>px;</xsl:text>
	<xsl:text> border-radius: </xsl:text>
	<xsl:value-of select ="./MaskTypeParameterSet/RoundedCornerParameterSet/topLeft" />
	<xsl:text>px </xsl:text>
	<xsl:value-of select ="./MaskTypeParameterSet/RoundedCornerParameterSet/topRight" />
	<xsl:text>px </xsl:text>
	<xsl:value-of select ="./MaskTypeParameterSet/RoundedCornerParameterSet/bottomRight" />
	<xsl:text>px </xsl:text>
	<xsl:value-of select ="./MaskTypeParameterSet/RoundedCornerParameterSet/bottomLeft" />
	<xsl:text>px;</xsl:text>
	</xsl:if>
	<xsl:if test="./RotationParameterSet/rotation">
	<xsl:text> -webkit-transform: rotate(</xsl:text>
	<xsl:value-of select ="./RotationParameterSet/rotation" />
	<xsl:text>deg);</xsl:text>
    <xsl:text> -moz-transform: rotate(</xsl:text>
    <xsl:value-of select ="./RotationParameterSet/rotation" />
    <xsl:text>deg);</xsl:text>
    <xsl:text> transform: rotate(</xsl:text>
    <xsl:value-of select ="./RotationParameterSet/rotation" />
   	<xsl:text>deg);</xsl:text>
	</xsl:if>
	</xsl:template>
	
	<xsl:template name="makePositionStyle">
		<xsl:text>position: absolute; top: </xsl:text> 
		<xsl:if test="not(./PositionParameterSet/y)">
			<xsl:text>0</xsl:text> 
		</xsl:if>
		<xsl:if test="./PositionParameterSet/y">
			<xsl:value-of select ="./PositionParameterSet/y/text()" /> 
		</xsl:if>
		
		<xsl:if test="./PositionParameterSet[is_percent_y='true']">
			<xsl:text>%;</xsl:text>
		</xsl:if>
		<xsl:if test="not(./PositionParameterSet[is_percent_y='true'])">
			<xsl:text>px;</xsl:text>
		</xsl:if>
			
		<xsl:text> left: </xsl:text>
		<xsl:if test="not(./PositionParameterSet/x)">
			<xsl:text>0</xsl:text> 
		</xsl:if>
		<xsl:if test="./PositionParameterSet/x">
			<xsl:value-of select ="./PositionParameterSet/x/text()" /> 
		</xsl:if>
		<xsl:if test="./PositionParameterSet[is_percent_x='true']">
			<xsl:text>%;</xsl:text>
		</xsl:if>
		<xsl:if test="not(./PositionParameterSet[is_percent_x='true'])">
			<xsl:text>px;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="makeBackgroundStyle">
		
		<xsl:if test="./BackgroundColorParameterSet/backgroundColor">
			<xsl:text> background-color: rgb(</xsl:text>
			<xsl:value-of select ="./BackgroundColorParameterSet/backgroundColor/text()" /> 
			<xsl:text>);</xsl:text>
		</xsl:if>
		<xsl:if test="./BackgroundColorParameterSet/backgroundAlpha">
		<xsl:text> background-color: rgba(</xsl:text>
		<xsl:value-of  select="./BackgroundColorParameterSet/backgroundColor/text()" />
		<xsl:text>,</xsl:text>
		<xsl:value-of  select="round(./BackgroundColorParameterSet/backgroundAlpha* 100) div100" />
		<xsl:text>);</xsl:text>
		</xsl:if>
		
		<xsl:choose>
		<xsl:when test="./BackgroundImageParameterSet/alpha">
			<xsl:text></xsl:text>
		</xsl:when>
		<xsl:otherwise>
		<xsl:if test="./BackgroundImageParameterSet/source">
			<xsl:text> background-image: url('</xsl:text>
			<xsl:copy-of select="$path_to_project" />
			<xsl:value-of select="$link_level" />
			<xsl:value-of select="./BackgroundImageParameterSet/source"  />
			<xsl:text>'); </xsl:text>
			<xsl:text>background-repeat: no-repeat; </xsl:text>
			<xsl:text>-webkit-background-size: 100% 100%; </xsl:text>
			<xsl:text>-moz-background-size: 100% 100%; </xsl:text>
			<xsl:text>-o-background-size: 100% 100%; </xsl:text>
			<xsl:text>background-size: 100% 100%;</xsl:text>
			</xsl:if>
		</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="makeBackgroundImageAlpha">
		<img>
		<xsl:attribute name="style">
			<xsl:text>position: absolute; top: 0px; left: 0px; width: 100%; height: 100%;</xsl:text>
			<xsl:text> filter: alpha(opacity=</xsl:text>
			<xsl:value-of select="round(./BackgroundImageParameterSet/alpha * 100)" />
			<xsl:text>); opacity: 0.</xsl:text>
			<xsl:value-of  select="round(./BackgroundImageParameterSet/alpha * 100)" />
			<xsl:text>;</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="src">
		 	<xsl:copy-of select="$path_to_project" />
			<xsl:value-of select="$link_level" />
			<xsl:value-of select="./BackgroundImageParameterSet/source"  />
		 </xsl:attribute>
		 </img>
	</xsl:template>
	
	<xsl:template name="makeBorderStyle">
	
		<xsl:if test='./BorderParameterSet/enable = "true"'>
			
			<xsl:variable name = "border_color" select ='substring-after(./BorderParameterSet/color,"x")' />
			<xsl:if test="./BorderParameterSet/borderRight">	
				<xsl:text>border-right: </xsl:text>
				<xsl:value-of select="./BorderParameterSet/borderRight" />
				<xsl:text>px solid #</xsl:text>
				<xsl:value-of select="$border_color" />
				<xsl:text>;</xsl:text>
			</xsl:if>
			<xsl:if test="./BorderParameterSet/borderLeft">	
				<xsl:text>border-left: </xsl:text>
				<xsl:value-of select="./BorderParameterSet/borderLeft" />
				<xsl:text>px solid #</xsl:text>
				<xsl:value-of select="$border_color" />
				<xsl:text>;</xsl:text>
			</xsl:if>
			<xsl:if test="./BorderParameterSet/borderTop">	
				<xsl:text>border-top: </xsl:text>
				<xsl:value-of select="./BorderParameterSet/borderTop" />
				<xsl:text>px solid #</xsl:text>
				<xsl:value-of select="$border_color" />
				<xsl:text>;</xsl:text>
			</xsl:if>
			<xsl:if test="./BorderParameterSet/borderBottom">	
				<xsl:text>border-bottom: </xsl:text>
				<xsl:value-of select="./BorderParameterSet/borderBottom" />
				<xsl:text>px solid #</xsl:text>
				<xsl:value-of select="$border_color" />
				<xsl:text>;</xsl:text>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="substring-before-last">
	    <xsl:param name="pText"/>
	    <xsl:param name="pDelim" />
	     <!-- <xsl:value-of select="$pText" />-->
	      <xsl:value-of select="string('&#8629;=====start =====&#8629;')" disable-output-escaping="yes" />
	    <!--  <xsl:value-of select="$pDelim" disable-output-escaping="yes" />-->
	   <!--<xsl:value-of select="substring-before($pText, $pDelim)" disable-output-escaping="yes" />-->
	    <xsl:if test="contains($pText, $pDelim)">
	      <xsl:value-of select="substring-before($pText, $pDelim)" disable-output-escaping="yes" />
	       <xsl:if test="string-length(substring-after(substring-after($pText, $pDelim),$pDelim))!=0">
	       	<xsl:value-of select="$pDelim"/>
	         </xsl:if>
	       <xsl:call-template name="substring-before-last">
	         <xsl:with-param name="pText" select=
	          "substring-after($pText, $pDelim)"/>
	         <xsl:with-param name="pDelim" select="$pDelim"/>
	       </xsl:call-template>
	     </xsl:if>
 	</xsl:template>
 	
 	<xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
