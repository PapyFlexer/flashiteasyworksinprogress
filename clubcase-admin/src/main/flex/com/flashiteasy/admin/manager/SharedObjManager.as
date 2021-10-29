package com.flashiteasy.admin.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	public class SharedObjManager extends EventDispatcher
	
	{
		private var _so:SharedObject;

		public static const DEFAULT_NAME:String = "com.flashiteasy.admin.manager.SharedObjManager";

		/**
		 * Crée une instance de la classe SharedObjmanager
		 *
		 * @usage <pre><code>var som:SharedObjectManager = new SharedObjectManager($name);</code></pre>
		 *
		 * @param $name Une string representant le shared object à creer/lire sur la machine de l'utilisateur
		 */
		public function SharedObjectManager(name:String):void
		{
			this._so = SharedObject.getLocal(name);
			this._so.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
		}


		private function onStatus($evt:NetStatusEvent):void
		{
			switch ($evt.info.code)
			{
				case "SharedObject.Flush.Success":
					this.dispatchEvent(new Event(Event.COMPLETE));
					break;
				case "SharedObject.Flush.Failed":
					this.dispatchEvent(new Event(Event.CANCEL));
					break;
			}
		}

		/**
		 * Crée un "cookie" (paires clé/valeur)  dans le sharedObj local et le sauve.
		 *
		 * @usage <pre><code>som.setProperty({hasVisited: "true"});</code></pre>
		 *
		 * @param $obj Un objet qui represente la paire clé/valeur à stocker 
		 *
		 * @return neant
		 */
		public function setProperty($obj:Object):void
		{
			var prop:String;
			for (prop in $obj)
			{
				this._so.data[prop] = $obj[prop];
				this._so.flush();
			}
		}
		
		
		/**
		 * Retourne the valeur de la clé passee en argument
		 *
		 * @usage <pre><code>som.getProperty("hasVisited");</code></pre>
		 *
		 * @param $name Une string qui represente le nom de la propriété à récuperer
		 *
		 * @return String
		 */
		public function getProperty($name:String):String
		{
			return this._so.data[$name];
		}
		
		
		/**
		 * nettoie le sharedObj en cours
		 *
		 * @usage <pre><code>som.clear();</code></pre>
		 *
		 * @return Nothing
		 */
		public function clear():void
		{
			this._so.clear();
		}



		public override function toString():String
		{
			return "com.flashiteasy.admin.manager.SharedObjManager";
		}
	}
}