package com.flashiteasy.admin.localconnection
{
import flash.events.Event;

/**
 * Describes the events dispatched by a <code>ILocalConnector</code> instance.
 *
 * @langversion ActionScript 3.0
 * @playerversion Flash 9.0
 */
public class LocalConnectorEvent extends Event
{
	/**
	 * Event : LocalConnector connection state changed.
	 */
	public static const CONNECT_STATE_CHANGED:String = "LocalConnector__connectStateChanged";

	/**
	 * Event : LocalConnector received a message.
	 */
	public static const MESSAGE_RECEIVED:String = "LocalConnector__messageReceived";


	/**
	 * message received, if relevant.
	 */
	protected var _objMessage:LocalConnectorMessage = null;


	/**
	 * Constructor.
	 *
	 * @param strType event type
	 */
	public function LocalConnectorEvent(strType:String, objMessage:LocalConnectorMessage=null)
	{
		super(strType, false, false);
		_objMessage = objMessage;
	}

	/**
	 * @inheritDoc
	 */
	override public function clone():Event
	{
		return new LocalConnectorEvent(type, message);
	}


	/**
	 * message received, if relevant.
	 */
	public function get message():LocalConnectorMessage
	{
		return _objMessage;
	}

}
}}