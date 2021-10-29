/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.factory
{
	/**
	 * The <code><strong>ClassFactory</strong></code> class is an implementation of the Factory DP
	 * and is extensively used by the control builder classes
	 * 
	 */
	public class ClassFactory implements IClassFactory
	{
    
	    /**
	     * The class type to create
	     * @param generator
	     */
	    public function ClassFactory(generator:Class = null)
	    {
			super();
		   	this.generator = generator;
	    }
	
	    /**
	     * 
	     * @default 
	     */
	    public var generator:Class;
	
		//----------------------------------
		//  properties
		//----------------------------------
	
		/**
		 * 
		 * @default 
		 */
		public var properties:Object = null;
	
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
	
		/**
		 * builds the new instance of the class type asked for.
		 * @return the class type
		 */
		public function newInstance():*
		{
			var instance:Object = new generator();
	
	        if (properties != null)
	        {
	        	for (var p:String in properties)
				{
	        		instance[p] = properties[p];
				}
	       	}
	
	       	return instance;
		}
	}

}
