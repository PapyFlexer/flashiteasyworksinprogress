package com.flashiteasy.admin.commands {

        import flash.events.ErrorEvent;
        import flash.events.Event;
        import flash.events.EventDispatcher;      

        /**
         * AbstractCommand implemente ICommand et définit un récepteur pour la commande. 
         * AbstractCommand étend EventDispatcher et envoie des evenements
         * onCommandComplete ou onCommandError.
         * 
         * Toutes les commandes à executer doivent etendre cette classe
         * en overridant la méthode execute
         */
        public class AbstractCommand extends EventDispatcher implements ICommand,IUndoableCommand, IRedoableCommand
        {
                private var receiver:ICommandReceiver;

                /**
                 * Cree un new AbstractCommand et assigne un récepteur
                 * pour la commande.
                 */
                public function AbstractCommand()
                {
                    //this.receiver = receiver;
                }

                /**
                 * Executes the command.
                 */
                public function execute():void
                {
                }
               
                public function undo():void
                {
                }
               
                public function redo():void
                {
                }
               
                /**
                 * Dispatche l'evenement Event.COMPLETE (qui bubbles et est cancelable)
                 * pour indiquer que la commande a été correctement executee.
                 */
                protected function onCommandComplete():void
                {
                        dispatchEvent(new Event(Event.COMPLETE, true, true));
                }
               
                /**
                 * Dispatche l'evenement ErrorEvent.ERROR (qui bubbles et est cancelable)
                 * pour indiquer que la commande a renconté une erreurr à l'execution
                */
                protected function onCommandError(errorMessage:String = null):void
                {
                        dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, true, true,
                                                  errorMessage));
                }

                /**
                 * Retourne le nom de la classe sous forme de String.
                 */
                public override function toString():String
                {
                        return "AbstractCommand";
                }
        }
}
