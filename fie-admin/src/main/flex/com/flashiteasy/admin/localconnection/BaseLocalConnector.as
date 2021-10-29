package com.flashiteasy.admin.localconnection
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	public class BaseLocalConnector extends EventDispatcher implements ILocalConnector
	{
		/**
		 * @private
		 * Delai entre chaque invocation de la boucle "check alive" (ping), en millisecondes.
		 */
		private static const CHECK_ALIVE_DELAY:int = 5000;

		/**
		 * Nom du Connector.
		 */
		protected var _strName:String = null;

		/**
		 * Verifie que la connection est etablie.
		 */
		protected var _bIsConnected:Boolean = false;

		/**
		 * nom de la connexion entrante.
		 */
		protected var _strIn:String = null;

		/**
		 * nom de la connexion sortante
		 */
		protected var _strOut:String = null;

		/**
		 * @private
		 * objet recevant la connexion entrante
		 */
		private var __objInConnect:LocalConnection;

		/**
		 * @private
		 * objet recevant la connexion sortante
		 */
		private var __objOutConnect:LocalConnection;

		/**
		 * @private
		 * Timer de la boucle 'check_alive'
		 */
		private var __objTimer:Timer;


		/**
		 * Constructeur.
		 *
		 * @param strIn 	nom de la connexion entrante
		 * @param strOut 	nom de la connexion sortante
		 * @param strName 	nom du connecteur
		 */
		public function BaseLocalConnector(strIn:String, strOut:String, strName:String = null)
		{
			__objInConnect = new LocalConnection();
			__objOutConnect = new LocalConnection();
			__objTimer = new Timer(CHECK_ALIVE_DELAY, 0);

			_strIn = strIn;
			_strOut = strOut;
			_strName = strName;

			__objTimer.addEventListener(TimerEvent.TIMER, checkAliveHandler, false,0, true);
			__objOutConnect.addEventListener(StatusEvent.STATUS, outStatusHandler);
		}


		/**
		 * Specifie un ou plusieurs domaines qui peuvent envoyer des appels LocalConnection
		 * vers l'instance de LocalConnection locale (residente).
		 *
		 * @param ... domains les domaines autorises
		 */
		public function allowDomain(... domains):void
		{
			__objInConnect.allowDomain.apply(__objInConnect, domains);
		}

		/**
		 * Specifie un ou plusieurs domaines qui peuvent envoyer des appels LocalConnection
		 * vers l'instance de LocalConnection locale (residente).
		 * Ma methode <code>allowInsecureDomain()</code> marche de la meme maniere
		 * que l'autre methode<code>allowDomain()</code>, excepte le fait que
		 * <code>allowInsecureDomain()</code> permet a des SWF securises ou non
		 * de faire les appels.
		 *
		 * @param ... domains les domaines autorises
		 */
		public function allowInsecureDomain(... domains):void
		{
			__objInConnect.allowInsecureDomain.apply(__objInConnect, domains);
		}

		/**
		 * Prepare l'instance du connector a recevoir des commandes.
		 * Demarre la boucle 'chek_alive'.
		 */
		public function connect():void
		{
			startListening();
			startCheckAlive();
		}

		
		/**
		 * Deconnecte l'objet LocalConnection resident. Appeler cette methode
		 * pour arreter d'ecouter les commandes.
		 * Stoppe la boucle 'chek_alive'.
		 */
		public function discconnect():void
		{
			stopCheckAlive();
			stopListening();
			setIsConnected(false);
		}

		/**
		 * Envoie l'instance de message <code>LocalConnectorMessage</code>
		 * vers la connexion sortante
		 *
		 * @param objMessage message a envoyer.
		 */
		public function send(objMessage:LocalConnectorMessage):void
		{
			if (!isConnected)
				return;
			var objBytes:ByteArray = LocalConnectorMessage.encode(objMessage);
			__objOutConnect.send(_strOut, "receive", objBytes);
		}

		/**
		 * Methode invoquee sur le connector.
		 *
		 * @param objBytes data reçue par le connector resident.
		 */
		public function receive(objBytes:ByteArray):void
		{
			var objMessage:LocalConnectorMessage = LocalConnectorMessage.decode(objBytes);
			dispatchMessage(objMessage);
		}

		/**
		 * Verifie la dispo de la connection sortante
		 */
		public function ping():void
		{
			trace("PING  "+ name +" ->  "+ _strOut);
			__objOutConnect.send(_strOut, "pong");
		}

		public function pong():void
		{
			trace("PONG  "+ name +" <-  "+ _strIn);
		}

		/**
		 * Met a jour le booleen the <code>isConnected</code>. If the flag value has
		 * been changed, a <code>LocalConnectorEvent</code> is dispatched.
		 *
		 * @param bValue is outbound connection alive
		 */
		protected function setIsConnected(bValue:Boolean):void
		{
			if (_bIsConnected == bValue)
				return;
			_bIsConnected = bValue;
			dispatchEvent(new LocalConnectorEvent(LocalConnectorEvent.CONNECT_STATE_CHANGED));
		}

		/**
		 * Starts the check alive timer; a <code>ping()</code> will be
		 * performed each <code>CHECK_ALIVE_DELAY</code> milliseconds to
		 * ensures that the outbound connection is still opened.
		 */
		protected function startCheckAlive():void
		{
			__objTimer.start();
		}

		/**
		 * Stops the check alive timer.
		 */
		protected function stopCheckAlive():void
		{
			__objTimer.stop();
		}

		/**
		 * Opens the inbound connection; start listening to any connection
		 * named <code>_strIn</code>.
		 */
		protected function startListening():void
		{
			__objInConnect.client = this;
			__objInConnect.connect(_strIn);
		}

		/**
		 * Closes the inbound connection.
		 */
		protected function stopListening():void
		{
			try
			{
				__objInConnect.close();
			}
			catch (e:ArgumentError) // NO PMD
			{
				/*
				 * Mute excpetion : The LocalConnection instance is
				 * not connected, so it cannot be closed.
				 */
				return;
			}
		}

		/**
		 * Dispatches the received <code>LocalConnectorMessage</code>.
		 *
		 * @param objMessage LocalConnectorMessage received through the inbound connection.
		 */
		protected function dispatchMessage(objMessage:LocalConnectorMessage):void
		{
			dispatchEvent(new LocalConnectorEvent(LocalConnectorEvent.MESSAGE_RECEIVED, objMessage));
		}

		/**
		 * @private
		 * Timer handler, Calls the <code>ping()</code> method to check the
		 * outbound connection state.
		 *
		 * @param event timer event
		 */
		private function checkAliveHandler(event:TimerEvent):void
		{
			ping();
		}

		/**
		 * @private
		 * Handles status event dispatched by the outbound connection.
		 * Updates the <code>isConnected</code> flag.
		 *
		 * @param event status event
		 */
		private function outStatusHandler(event:StatusEvent):void
		{
//		trace("Status "+ name +" : "+ event.level );
			setIsConnected("status" == event.level);
		}


		/**
		 * Connector Name.
		 * It's easier to debug a named connector ^_^.
		 */
		public function get name():String
		{
			return _strName;
		}

		/**
		 * Whether the outbound connection is available.
		 */
		public function get isConnected():Boolean
		{
			return _bIsConnected;
		}

	}
}