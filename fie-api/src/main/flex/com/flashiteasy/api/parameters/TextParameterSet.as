/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.parameters
{
	import com.flashiteasy.api.assets.StyleList;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.elements.ITextElementDescriptor;
	import com.flashiteasy.api.text.Style;
	
	import flash.text.TextFormat;

	[ParameterSet(description="Text", type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>RoundedCornerParameterSet</strong></code> is the parameterSet
	 * that handles the masking of a control by a rounded rectangle.It sets the bottom left,
	 * bottom right, top left and top right corners using a radius value.
	 */

	public class TextParameterSet extends AbstractParameterSet implements IRemoteParameterSet,IParameterSetStaticValues
	{
		private var _text : String ="Entrez votre texte";
		private var _textSize : int = 12;
		private var _police : String = "_Arial";
		private var _remoteParameterList : Array;
		private var _defaultTextFormat:TextFormat = new TextFormat("_Arial",12,"0x000000");
		/**
		 * 
		 * @default defaultTextFormat Arial c.12
		 */
		public var textStyle : Style ;
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target: IDescriptor ) : void
		{
			if( target is ITextElementDescriptor )
			{
				if(_style != null && style.length>0 )
				{/*
					var xml : XML = new XML(_style);
					textStyle = StyleParser.parseStyle(xml);
					*/
					textStyle = StyleList.getInstance().getStyle(_style);
				}
				else
				{
					textStyle = null ;
				}
				if(textStyle != null ) 
					ITextElementDescriptor( target ).initText( text , textStyle.getTextFormat() ) ;
				else
					ITextElementDescriptor( target ).initText( text , null ) ;
			}
		}
		
		[Parameter(type="Text", defaultValue="Entrez votre texte", label="texte")]
		/**
		 * Sets the raw text content (string) 
		 */
		public function get text():String{
			return _text;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set text( value:String ):void{
			_text=value;
		}
		
		private var _style : String = "";
		
		/**
		 * Sets the style on the text control, using style name
		 */
		public function get style() : String
		{
			return _style;	
		}
		
		/**
		 * 
		 * @private
		 */
		public function set style( value : String ) : void 
		{
			_style = value ;
		}
		
		/**
		 * Sets the font
		 */
		public function get police():String{
			return _police;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set police( value:String ):void{
			_police=value;
		}
		
		/**
		 * Sets the distant content of the text control : SQL request, RSS flux, ...
		 */
		public function get remoteParameterList() : Array
		{
			return _remoteParameterList;	
		}
		
		/**
		 * 
		 * @private
		 */
		public function set remoteParameterList( value : Array ) : void	
		{
			_remoteParameterList = value;
		}
		
		public function getDefaultTextFormat():TextFormat
		{
			return _defaultTextFormat;
		}
		
		/**
		 * Lists text available sizes
		 * @param name
		 * @return 
		 */
		public function getPossibleValues(name:String):Array
		{
			if(name=="textSize"){
				return ["6","8","10","12","14","16","18","20","22"];
			}
			if(name=="police"){
				
			}
			return null;
		}

	}
}