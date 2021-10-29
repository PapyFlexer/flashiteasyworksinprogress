package com.flashiteasy.admin.commands {

	/**
	 * @author gillesroquefeuil
	 */
	/**
	 * IUndoableCommand etend l'interface ICommand par une méthode UNDO.
	 * Cette interface doit etre implementee pour toute commande 
	 * qui peut etre sujet d'un UNDO.
	 */

	public interface IUndoableCommand extends ICommand {
		/**
		 * Undo la commande.
		 */
		function undo() : void
	}
}
