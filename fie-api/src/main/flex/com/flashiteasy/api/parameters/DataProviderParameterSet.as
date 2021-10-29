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
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.elements.IDataProviderElementDescriptor;

	[ParameterSet(description="null", type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>DataProviderParameterSet</strong></code> is the parameterSet
	 * that handles the ComboBox control, its alpha and a repetirion type.
	 * The metadata sets its editors via reflection in the Form Items group, using 
	 * a Datagrid for edition.The datagrid has 2 columns :
	 * <ul>
	 * <li><strong>First column : </strong>Labels</li>
	 * <li><strong>Second column : </strong>Datas</li>
  	 * </ul>
  	 * When users select the Combo on a given position, the Form Container Submit button
  	 * looks for the selectedIndex in the data columns and retuns it as a value, while key is 
  	 * the name given to the FormItem ComboBox. If the data column has not be filled, 
  	 * the value returned is the selected Label.
  	 * 
	 */
	public class DataProviderParameterSet extends AbstractParameterSet
	{
		private var _labels : Array=new Array();
		private var _datas : Array = new Array();
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target: IDescriptor ) : void
		{
			super.apply( target );
			if( target is IDataProviderElementDescriptor )
			{
				IDataProviderElementDescriptor ( target ).setLabels( labels );
				IDataProviderElementDescriptor ( target ).setDatas( datas );
			}
		}
		[Parameter(type="EditableDataGrid",defaultValue="normal", row="0" , sequence="1", label="Data_Provider")]
		/**
		 * Label column of the datagrid 
		 */
		public function get labels():Array{
			return _labels;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set labels( value:Array ):void{
			_labels=value;
		}

		/**
		 * Data column of the datagrid
		 */
		public function get datas():Array{
			return _datas;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set datas( value:Array ):void{
			_datas=value;
		}
		
		/**
		 * Utility function that returns the longest column 
		 * in order to build the DataGrid in admin mode. 
		 * @return the max length of both columns
		 */
		public function getParamLength():int
		{
			 return Math.max(labels.length, datas.length);
		}
	}
}
