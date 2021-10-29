package com.flashiteasy.admin.commands {

        /**
         * CommandHistory enregistre chaque ICommand passée 
         * par la methode addCommand.
         * Utiliser l'historique de commande dans chaque ICommandReceiver  
         * avec des commandes qui implementent IUndoableCommand et IRedoableCommand. 
         * La methode addCommand doit etre implementee dans le listener du Event.COMPLETE  
         * pour chaque command.
         */
        public class CommandHistory 
        {
                private var commands:Array;
                private var historyIndex:int;
                
                /**
                 * Cree un nouvel Historique.
                 * Selon qu'on veut centraliser toutes les commandes de l'appli 
                 * ou les categoriser, on creera une seule ou plusieurs instances.
                 */
                public function CommandHistory() 
                {
                        commands = new Array();
                        historyIndex = -1;
                }
                
                /**
                 * Ajoute une implementation de ICommand à sa liste de commandes executees 
                 * à la position actuelle de l'index d'historisation. 
                 * Toutes les commandes suivates sont supprimees.
                 */
                public function addCommand(command:ICommand):void
                {
                			historyIndex++;
                			commands.splice(historyIndex, commands.length - historyIndex);
                        	commands[historyIndex] = command;

                        	command.execute();
                  		
                }
                
                /**
                 * Retourne la Commande précédent la commande en cours  
                 * et décremente le historyIndex de 1.
                 * S'il n'existe pas de commandeprécédente,  
                 * on retourne null et l'historyIndex est mis à -1.
                 */
                public function getPreviousCommand():ICommand
                {
                        if (hasPreviousCommand() == true)
                        {
                        		
                        		trace("previous command " + historyIndex);
                        		historyIndex--;
                                return commands[historyIndex+1];        
                        }
                        else
                        {
                                //historyIndex = -1;
                                trace("no previous command");
                                return null;    
                        }
                }
                
                /**
                 * Retourne la commande suivant la commande en cours  
                 * et incrémente l'historyIndex de 1.
                 * S'il n'y a pas de commande suivante, 
                 * l'historyIndex est mis à la valeur de sa length.
                 */
                public function getNextCommand():ICommand
                {
                        if (hasNextCommand() == true)
                        {
                        		historyIndex++;
                        		trace("get next Command " + historyIndex );
                                return commands[historyIndex];        
                        }
                        else
                        {
                                trace("no next command");
                                return null;    
                        }
                }

                /**
                 * Retourne l'existence d'une commande quelconque 
                 * précédant la commande en cours dans l'index.
                 */
                public function hasPreviousCommand():Boolean
                {
                        return historyIndex > -1;
                }
                
                /**
                 * Retourne l'existence d'une commande quelconque 
                 * suivant la commande en cours dans l'index.
                 */
                public function hasNextCommand():Boolean
                {
                        return historyIndex < commands.length-1;
                }
                
                /**
                 * Retourne la valeur en cours de l'index.
                 */
                public function getHistoryIndex():uint
                {
                        return historyIndex;
                }
                
                /**
                 * Ma classe en String ! ;)
                 */
                public function toString():String 
                {
                        return "CommandHistory";
                }
        }
}
