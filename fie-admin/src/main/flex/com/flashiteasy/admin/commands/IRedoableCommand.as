package com.flashiteasy.admin.commands {

	import com.flashiteasy.admin.commands.ICommand;

	/**
	 * IRedoableCommand etend l'interface ICommand par une méthode REDO.
	 * Cette interface doit etre implementee pour toute commande 
	 * qui peut etre sujet d'un REDO.
	 */

	public interface IRedoableCommand extends ICommand {
		/**
		 * Redo la commande.
		 */
		function redo() : void
	}
}
