package com.flashiteasy.api.parameters
{
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.elements.IListElementDescriptor;

	[ParameterSet(description="null",type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>ListTypeParameterSet</strong></code> is the parameterSet
	 * that handles the automatic positionning of the ListContainer Control.
	 * Possible values are :
	 * <ul>
	 * <li><strong>Horizontal : </strong>children elements are distributed horizontally </li>
	 * <li><strong>Vertical : </strong>children elements are distributed vertically </li>
	 * <li><strong>Tile : </strong>child children are distributed as a grid line after line </li>
	 * <li><strong>HAccordion : </strong>child children are distributed horizontally with just one part visible at a given time. </li>
	 * <li><strong>VAccordion : </strong>child children are distributed vertically with just one part visible at a given time. </li>
	 * <li><strong>Carrousel : </strong>children elements along an ellipse and turn </li>
  	 * </ul>
	 */
	public class ListTypeParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		private var _type : String = "horizontal";
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target:IDescriptor):void
		{
			if ( target is IListElementDescriptor )
			{
				IListElementDescriptor(target).setType(_type);
				IListElementDescriptor(target).setCarrouselSpeed(speed);
				IListElementDescriptor(target).setAccordionHeaderSize(accordionHeaderSize);
			}
		}
		
		[Parameter(type="Combo",defaultValue="horizontal", row="0", sequence="0", label="List_type")]
		/**
		 * The type of automatic positionning in the container (horizontal, vertical, tile or carrousel) 
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * 
		 * @private
		 */
		public function set type(value:String):void
		{
			_type=value;
		}
		
		private var speed:Number = 0.03;
		
		[Parameter(type="Number",defaultValue="0.03",min="-0.10",max="0.10",interval="0.01",row="1",sequence="1",label="Max_Carrousel_speed")]
		/**
		 * The speed at which the carrousel is turning 
		 */
		public function get carrouselSpeed():Number
		{
			return speed;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set carrouselSpeed( value : Number ) : void 
		{
			speed = value;
		}

		private var accordionHeaderSize:uint = 20;
		
		[Parameter(type="Number",defaultValue="20",min="0",max="100",interval="1",row="1",sequence="2",label="HeaderSize")]
		/**
		 * The size of the accordion header (vertical or horizontal)
		 */
		public function get headerSize():Number
		{
			return accordionHeaderSize;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set headerSize( value : Number ) : void 
		{
			accordionHeaderSize = value;
		}

		/**
		 * 
		 * @param name
		 * @return 
		 */
		public function getPossibleValues(name:String):Array
		{
			return ['horizontal', 'vertical', 'tile', 'hAccordion', 'vAccordion', 'carrousel'];
		}
		
		
	}
}