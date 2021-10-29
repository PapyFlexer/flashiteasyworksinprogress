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
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.elements.ICloneElementDescriptor;
	import com.flashiteasy.api.selection.ElementList;

	[ParameterSet(description="null", type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>ImgParameterSet</strong></code> is the parameterSet
	 * that handles the Image control..
	 * The metadata sets its editors via reflection in the Content group, using 
	 * a source component in admin mode (browser).
  	 * 
	 */
	public class CloneParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		
		private var _source : String; //uuid of targetted element
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target: IDescriptor ) : void
		{
			super.apply( target );
			if( target is ICloneElementDescriptor)
			{
				ICloneElementDescriptor( target ).cloneTarget(_source, _applyEnterFrame, _applyReflection);
			}
		}
		
		[Parameter(type="List", defaultValue="",  row="1",sequence="2",label="Target")]
		/**
		 * The uuid of the element to clone.  
		 */
		public function get target():String{
			return _source;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set target( value:String ):void{
			_source=value;
		}
 
  		private var _applyReflection : Boolean = false;
 		
		[Parameter(type="Boolean",defaultValue="false",row="0",sequence="0",label="Reflect.")]
		/**
		 * The uuid of the element to clone.  
		 */
		public function get applyReflection():Boolean{
			return _applyReflection;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set applyReflection( value:Boolean ):void{
			_applyEnterFrame=value;
		}
 

 
 		private var _applyEnterFrame : Boolean = false;
 		
		[Parameter(type="Boolean",defaultValue="false",row="0",sequence="1",label="Enter Frame")]
		/**
		 * The uuid of the element to clone.  
		 */
		public function get applyEnterFrame():Boolean{
			return _applyEnterFrame;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set applyEnterFrame( value:Boolean ):void{
			_applyEnterFrame=value;
		}
 
        /**
         * Lists availables targets on stage using their uuids
         * @param name
         * @return 
         */
        public function getPossibleValues(name:String):Array
        {
            return ElementList.getInstance().getElementsAsString( BrowsingManager.getInstance().getCurrentPage() );
        }		
	}
		
}