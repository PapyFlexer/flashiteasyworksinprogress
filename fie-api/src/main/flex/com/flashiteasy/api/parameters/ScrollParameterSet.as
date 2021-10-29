/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.parameters {
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.elements.IScrollElementDescriptor;
	
	/**
	/**
	 * The <code><strong>ScrollParameterSet</strong></code> is the parameterSet
	 * that handles the scrolling of a control.
	 */
	
	public class ScrollParameterSet extends AbstractParameterSet
	{
		private var _type : String ="horizontal";
		private var _target : String;
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target: IDescriptor ) : void
		{
			super.apply( target );
			if( target is IScrollElementDescriptor )
			{
				IScrollElementDescriptor( target ).setScrollTarget( scrollTarget , type );
				IScrollElementDescriptor( target ).setScrollSize( maskSize );
			}
		}
		
		/**
		 * Sets the target of the scroller (control) 
		 */
		public function get scrollTarget():String{
			return _target;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set scrollTarget( value:String ):void{
			_target=value;
		}
		
		/**
		 * Sets the scroller type (horizontal, vertical or both) 
		 */
		public function get type():String{
			return _type;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set type( value:String ):void{
			_type=value;
		}
		
		private var mh:Number=100;
		
		/**
		 * Sets the maskHeight of the scroller
		 */
		public function get maskHeight():Number{
			return mh;
			
		}
		/**
		 * 
		 * @private
		 */
		public function set maskHeight(value:Number):void{
			mh=value;
		}
		
		private var mw:Number=100;
		/**
		 * 
		 * Sets the mask width of the scroller
		 */
		public function get maskWidth():Number{
			return mw;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set maskWidth(value:Number):void{
			mw=value;
		}
		
		private var ms:Number=100;
		/**
		 * 
		 * Sets the mask size of the scroller 
		 */
		public function get maskSize():Number{
			return ms;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set maskSize(value:Number):void{
			ms=value;
		}
		
	}
}
