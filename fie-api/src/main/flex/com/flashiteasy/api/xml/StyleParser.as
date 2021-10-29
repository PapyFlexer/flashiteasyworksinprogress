/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.xml
{
	import com.flashiteasy.api.text.Style;
	import com.flashiteasy.api.utils.StringUtils;
	
	/**
	 * The <code><strong>StyleParser</strong></code> class is
	 * a parsing utility class parsing dealing with the file describing the project style
	 */
	public class StyleParser
	{
		/**
		 * Parses the style XML file. 
		 * @param styleXML
		 * @return 
		 */
		public static function parseStyle( styleXML : XML ): Style
		{
			   if( styleXML == null || styleXML.length() == 0)
			   {
			  	 return null ;
			   }
			   else
			   {
			   	var style : Style = new Style();
			   	var xml : XML;
			   for each ( xml in styleXML.* )
			   {
			   var nodeName : String = xml.name();
			   	if(style[nodeName] is Boolean)
			   	{
			   		style[xml.name()] = StringUtils.StringToBoolean(xml.children()[0]);
			   	}
			   	else if(!isNaN(Number(style[xml.name()])))
			   	{
			   		
			   		style[xml.name()] = /*parseFloat(*/Number(xml.children()[0]);//);
			   	}
			   	else
			   	{
			   		style[xml.name()] = xml.children()[0];
			   	}
			   	
			   }
			   return style;
			}
		}

	}
}