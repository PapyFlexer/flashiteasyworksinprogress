package com.flashiteasy.admin.commands.menus {
	
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.admin.commands.ICommandReceiver;
	import com.flashiteasy.admin.commands.IRedoableCommand;	

	public class SimpleCommand extends AbstractCommand implements IRedoableCommand, IUndoableCommand {

		private var _receiver : SimpleCommandReceiver;
		private var selectedFace : *;

		public function SimpleCommand(receiver : ICommandReceiver) {
			_receiver = SimpleCommandReceiver(receiver);
			//_receiver.initialState = 
			//_receiver.currentPage = 
			
			super(_receiver);
		}

		public function redo() : void {
		}

		public function undo() : void {
			var page : Page = _receiver.currentPage;
			if (page is Page ) {
				//var currentState : Container = _receiver.modifiedState;
				var previousState :Container = _receiver.initialState;
				
				// on affecte le résultat
				// toto = previousState
			} else {
				throw new Error("vous effectuez un UNDO sur une autre page!");
				super.onCommandError();	
			}
		}

		override public function execute() : void {
			// entrer ici la commande réelle
		}

	}
}
