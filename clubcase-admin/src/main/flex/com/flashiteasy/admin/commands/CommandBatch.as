package com.flashiteasy.admin.commands {

	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import mx.utils.ArrayUtil;              

	/**
	 * CommandBatch fournit les methodes addCommand et removeCommand
	 * pour ajouter ou supprimer une commande dans la queue. CommandBatch étend
	 * AbstractCommand et execute toutes les commandes stockées d'un coup.
	 * Chaque commande est ajoutée à l'historique (si defini) des que l'evenement
	 * Event_COMPLETE est publié.
	 * Si une seulle erreur intervient dans le batch, l'événement ERROR est envoyé
	 * et la commande est avortée.
	 */

	public class CommandBatch extends AbstractCommand 
	{
		private var commands:Array;
		private var commandsCompleted:uint;

		private var commandHistory:CommandHistory;

		/**
		 * Cree un nouveau CommandBatch.
		 */
		public function CommandBatch(receiver:ICommandReceiver=null, commandHistory:CommandHistory = null)
		{
			super();

			commands = new Array();
			commandsCompleted = 0;

			this.commandHistory = commandHistory;
		}

		/**
		 * Execute chaque commande du batch en une fois.
		 */
		override public function execute():void
		{
			for (var i:uint; i < commands.length; ++i)
			{
				var currentCommand:AbstractCommand = commands[i];
				currentCommand.addEventListener(ErrorEvent.ERROR, onCurrentCommandError);
				currentCommand.execute();
			}
		}


		/**
		 * undo chaque commande du batch en une fois.
		 */
		override public function undo():void
		{
			for (var i:uint; i < commands.length; ++i)
			{
				var currentCommand:AbstractCommand = commands[i];
				currentCommand.undo();
			}
		}
		/**
		 * redo chaque commande du batch en une fois.
		 */
		override public function redo():void
		{
			for (var i:uint; i < commands.length; ++i)
			{
				var currentCommand:AbstractCommand = commands[i];
				currentCommand.redo();
			}
		}
		/**
		 * Ajoute une commande au batch.
		 */
		public function addCommand(command:ICommand):void
		{
			commands.push(command);
		}
		
		/**
		 * Ajoute une commande une commande du batch et supprime la précédente.
		 */
		public function addAndRemoveCommand(command:ICommand):void
		{
			commands.pop();
			commands.push(command);
		}

		/**
		 * Supprime une commande du batch si elle existe.
		 */
		public function removeCommand(command:ICommand):void
		{
			var commandIndex:int = ArrayUtil.getItemIndex(command, commands);
			if (commandIndex != -1)
			{
				commands.splice(commandIndex, 1);
			}
		}

		/**
		 * Gère l'événement ERROR sur la commande en cours et
		 * envoie ERROR sur le batch entier.
		 */
		private function onCurrentCommandError(e:ErrorEvent):void
		{
			onCommandError(e.text);
		}

		/**
		 * Ma classe en String.
		 */
		public override function toString():String 
		{
			return "CommandBatch";
		}
	}
}
