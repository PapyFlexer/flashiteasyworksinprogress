package com.flashiteasy.admin.localconnection
{
	import flash.utils.ByteArray;
	
	/**
	 * LocalConnector message wrapper
	 */
	public class LocalConnectorMessage
	{
		/**
		 * Maximum byte size of the whole message.
		 */
		public static const MAX_BYTE_SIZE:int = 40960;
	
		/**
		 * Message identifier.
		 */
		protected var _strIdentifier:String = null;
	
		/**
		 * Message payload.
		 */
		protected var _objData:Object = null;
	
	
		/**
		 * Encodes the given <code>LocalConnectorMessage</code> into
		 * a <code>ByteArray</code>.
		 *
		 * @param objMessage message to encode
		 * @return encoded local message
		 */
		public static function encode(objMessage:LocalConnectorMessage):ByteArray
		{
			var objClone:Object = { identifier: null, data: null };
			var objResult:ByteArray = new ByteArray();
	
			objClone.identifier = objMessage.identifier;
			objClone.data = objMessage.data;
			objResult.writeObject(objClone);
	
			return objResult;
		}
	
		/**
		 * Decodes the given <code>ByteArray</code> into
		 * LocalConnectorMessagea <code>LocalConnectorMessage</code>.
		 *
		 * @param objBytes message to decode
		 * @return decoded message
		 */
		public static function decode(objBytes:ByteArray):LocalConnectorMessage
		{
			var objClone:Object = objBytes.readObject();
	
			return new LocalConnectorMessage(objClone['identifier'], objClone['data']);
		}
	
	
		/**
		 * Constructor.
		 *
		 * @param strType message type
		 * @param objData message payload
		 */
		public function LocalConnectorMessage(strIdentifier:String, objData:* = null)
		{
			_strIdentifier = strIdentifier;
			_objData = objData;
		}
	
		/**
		 * Checks whether the message may be sent through a
		 * <code>LocalConnection</code>. The byte size of the whole message
		 * must be less than the <code>MAX_BYTE_SIZE</code> value.
		 *
		 * @return whether the message can be sent
		 */
		public function isValid():Boolean
		{
			var objBytes:ByteArray = encode(this);
			return (MAX_BYTE_SIZE > objBytes.length);
		}
	
	
		/**
		 * Message identifier.
		 */
		public function get identifier():String
		{
			return _strIdentifier;
		}
	
		/**
		 * Message payload.
		 */
		public function get data():Object
		{
			return _objData;
		}
	
	}
}