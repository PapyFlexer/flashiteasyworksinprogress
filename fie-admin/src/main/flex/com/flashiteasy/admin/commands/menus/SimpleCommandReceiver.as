package com.flashiteasy.admin.commands.menus {

	/**
	 * @author gillesroquefeuil
	 */
	import com.flashiteasy.admin.commands.ICommandReceiver;

	public class SimpleCommandReceiver implements ICommandReceiver {

		private var _initialState : Container;
		private var _modifiedState : Container;
		private var _currentPage : Page;

		/**
		 * Constructeur de l'objet récepteur de la commande
		 * Dans le cas qui nous intéresse (DuplicateBlock)
		 * on va garder un objet qui stocke les éléments suivants :
		 * - etat de depart du parent
		 * - etat de fin du parent
		 * - page en cours
		 */

		public function  SimpleCommandReceiver(initialState : Container,
												modifiedState : Container,
												currentPage : Page ) {
			if (initialState && initialState is Container) {
				if (currentPage && currentPage is Page) {									
					_initialState = initialState;
					_modifiedState = modifiedState;
					_currentPage = currentPage;
				} else {
					throw new Error("pas de page selectionnee");
					
				}
			} else {
				throw new Error("pas de block à dupliquer");
			}
		}

		public function get initialState() : Container {
			return _initialState;
		}

		function set initialState(parentContainer : Container) : void {
			_initialState = parentContainer;
		}

		public function get modifiedState() : Container {
			return _modifiedState;
		}

		function set modifiedState(parentContainer : Container) : void {
			_modifiedState = parentContainer;
		}

		function set currentPage(page : Page) : void {
			_currentPage = page;
		}

		public function get currentPage() : Page {
			return _currentPage;
		}
	}
}
