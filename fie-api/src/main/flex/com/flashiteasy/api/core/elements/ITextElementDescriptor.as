/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
package com.flashiteasy.api.core.elements
{
	import com.flashiteasy.api.core.IUIElementDescriptor;
	
	import flash.text.TextFormat;
	
	/**
	 * The <code><strong>ITextElementDescriptor</strong></code> interface defines methods shared by all text-based controls
	 */
	public interface ITextElementDescriptor extends IUIElementDescriptor
	{
		function initText( text : String , format : TextFormat ) : void ;
		function setAutoSize( autoSize:String ):void;
		function setTextBorder( border:Boolean , borderColor:Number ):void; 
		function setOptions( multiLines:Boolean , wordWrap:Boolean , selectable:Boolean ):void;  
		function get defaultTextFormat():TextFormat;

	}
}