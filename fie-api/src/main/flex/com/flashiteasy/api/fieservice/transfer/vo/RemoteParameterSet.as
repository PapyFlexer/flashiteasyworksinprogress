/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.fieservice.transfer.vo
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	
	[ParameterSet(description="null",type="Reflection", groupname="Net")]
	/**
	 * The <code><strong>RemoteParameterSet</strong></code> is a distant (online) ParameterSet.
	 * Contrary to the usual ParameterSet which is written in the xml page description,
	 * this one is not resident and must be called via amfphp.
	 * 
	* <p>The properties of the <code><strong>RemoteParameterSet</strong></code> have the following values:</p>
	* <table class=innertable>
	* <tr><th>uiElementDescriptorIdentifier</th><th>A reference to the control where the RemoteParameterSet is embedded</th></tr>
	* <tr><th>name</th><th>String that names the RemoteParameterSet</th></tr>
  	* <tr><th>request</th><th>Request string, using 'fie://...' syntax</th></tr>
  	* <tr><th>response</th><th>the Object return by amfphp (an xml formatted one)</th></tr>
  	* </table>
	*
	*/
	
	//[ParameterSet(description="Remote",type="Reflection", groupname="Block_Content")]
	public class RemoteParameterSet extends AbstractParameterSet
	{
		/**
		 * Constructor
		 */
		public function RemoteParameterSet()
		{
		}

	 	private var _uiElementDescriptorIdentifier : String;
	 	private var _name : String; // the target uiElement
	 	private var _request : String; // fie://AMF/TXT/newsService/home/
	 	private var _response : Object;		
	 	private var applied:Boolean=false;
	 	private var _source : String;
	 	private var _enabled : Boolean = false;

		/**
		 * The uuid reference to the descriptor where the RemoteParameterSet is embedded
		 */
		 
		public function get uiElementDescriptorIdentifier() : String
		{
			return _uiElementDescriptorIdentifier;
		}
		
		[Parameter(type="Remote", defaultValue="false", label="null")]
		public function get enabled() : Boolean
		{
			return _enabled;
		}
		
		public function set enabled( value : Boolean ) : void 
		{
			_enabled = value ;
		}
		
		/**
		 * @private
		 */
		public function set uiElementDescriptorIdentifier( value : String ) : void
		{
			_uiElementDescriptorIdentifier = value;
		}				
		
		/**
		 * The uuid name of the the RemoteParameterSet
		 */
		public function get name() : String
		{
			return _name;
		}

		/**
		 * 
		 * @private
		 */
		public function set name( value : String ) : void
		{
			_name = value;
		}	
		/**
		 * The request sent to amfphp 
		 */
		public function get request() : String
		{
			return _request;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set request( value : String ) : void
		{
			_request = value;
		}
		
		/**
		 * The response Object sent by amfphp
		 */
		public function get response() : Object
		{
			return _response;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set response( value : Object ) : void
		{
			_response = value;
		}
		
		//[Parameter(type="Remote", defaultValue="null", row="0", sequence="0", label="Remote")]
		/**
		 * The response Object sent by amfphp
		 */
		public function get source() : String
		{
			return _source;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set source( value : String ) : void
		{
			if( _source != value )
			{
				_source = value;
				applied = false;
			}
			
		}	
		
		public function setApplied(value:Boolean):void
		{
			applied= value;
		}	
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target: IDescriptor  ) : void
		{
			if(request!=null && applied==false)
			{
				if ( target is IUIElementDescriptor )
				{
					this._uiElementDescriptorIdentifier=target.uuid;
					IUIElementDescriptor(target).isWaiting = true;
					applied=true;
					// recuperer une reference a la page courante
					AbstractBootstrap.getInstance().getBusinessDelegate().addPageRemoteStack( IUIElementDescriptor(target).getPage(), IUIElementDescriptor(target), this );
					
					// ajouter a la pile d'appel remote de la page  le IUIElementDescriptor lié au RemoteParametreSet*
				}

			}
			
		}			

	}
}
