package com.flashiteasy.admin.commands {

	/**
	 * ICommandReceiver est une interface qui doit etre implementee par 
	 * chaque classe qui doit jouer le rôle de recepteur d'une Commande qui 
	 * etend la AbstractCommand.
	 * Ces classes peuvent aussi also definir des listeners pour les evenements 
	 * Event.COMPLETE et ErrorEvent.ERROR dispatchés par AbstractCommand.
	 */
	public interface ICommandReceiver {
	}
}
