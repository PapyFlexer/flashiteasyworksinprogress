package com.flashiteasy.admin.localconnection
{
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	public interface ILocalConnector extends IEventDispatcher
	{
	
		/**
		 * Specifie un ou plusieurs domaines qui peuvent envoyer des appels LocalConnection
		 * vers l'instance de LocalConnection locale (residente).
		 *
		 * @param ... domains les domaines autorises
		 */
		function allowDomain(... domains):void;
		
		
		
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
		function allowInsecureDomain(... domains):void;
		
		
		
	
		/**
		 * Prepare l'instance du connector a recevoir des commandes.
		 * Demarre la boucle 'chek_alive'.
		 */
		function connect():void;
		
		
		
		/**
		 * Deconnecte l'objet LocalConnection resident. Appeler cette methode
		 * pour arreter d'ecouter les commandes.
		 * Stoppe la boucle 'chek_alive'.
		 */
		function discconnect():void;
	
	
	
		/**
		 * Envoie l'instance de message <code>LocalConnectorMessage</code>
		 * vers la connexion sortante
		 *
		 * @param objMessage message a envoyer.
		 */
		function send(objMessage:LocalConnectorMessage):void;
		
		
		/**
		 * Methode invoquee sur le connector.
		 *
		 * @param objBytes data reçue par le connector resident.
		 */
		function receive(objBytes:ByteArray):void;
	
		/**
		 * Verifie que la connection est operationnelle en sortie.
		 */
		function ping():void;
		/**
		 *  Verifie que la connection est operationnelle en entree.
		 */
		function pong():void;
	
		/**
		 * Nom du connector
		 */
		function get name():String;
		
		
		/**
		 * Verifie la dispo de la connection sortante.
		 */
		function get isConnected():Boolean;
	
	}
}