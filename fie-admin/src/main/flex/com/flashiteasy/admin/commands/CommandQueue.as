package com.flashiteasy.admin.commands {

        import com.flashiteasy.api.utils.ArrayUtils;
        
        import flash.events.ErrorEvent;
        import flash.events.Event;

        /**
         * CommandQueue fournit les methodes addCommand et removeCommand 
         * pour ajouter ou supprimer une commande dans la queue. CommandQueue étend 
         * AbstractCommand et execute toutes les commandes stockées . Chaque commande avant de s'executer
         * attend que la commande precedante ait dispatch un Event.COMPLETE
         * Les commands ajoutées dans la commandQueue doivent dispatch un Event.COMPLETE pour que la queue s'execute entierement
         */
        public class CommandQueue extends AbstractCommand 
        {
                protected var commands:Array;
                private var currentCommandIndex:uint;
                
                private var commandHistory:CommandHistory;
                
                private var abortOnCommandError:Boolean;

                /**
                 * Cree une nouvelle CommandQueue (Macro).
                 * 
                 * le parametre abortOnCommandError (par defaut sur true) determine si
                 * la command queue doit etre interrompu ou continuée
                 * en cas d'erreur d'une des commandes.
                 */
                /*public function CommandQueue(receiver:ICommandReceiver, 
                                             commandHistory:CommandHistory = null, 
                                             abortOnCommandError:Boolean = true)
                {
                        super(receiver);
                        
                        commands = new Array();
                        currentCommandIndex = 0;
                        
                        this.commandHistory = commandHistory;
                        
                        this.abortOnCommandError = abortOnCommandError;
                }*/
                
                public function CommandQueue(commandHistory:CommandHistory = null, 
                                             abortOnCommandError:Boolean = true)
                {
                        
                        commands = new Array();
                        currentCommandIndex = 0;
                        this.commandHistory = commandHistory;
                        this.abortOnCommandError = abortOnCommandError;
                }
                

                /**
                 * Execute chaque commande de la queue dans l'ordre 
                 * où elles sont stockées.
                  */
                override public function execute():void
                {
                        if (currentCommandIndex < commands.length)
                        {
                               var currentCommand:AbstractCommand = commands[currentCommandIndex];
                                currentCommand.addEventListener(Event.COMPLETE, onCurrentCommandComplete , false , 0 , true);
                                //currentCommand.addEventListener(ErrorEvent.ERROR, onCurrentCommandError);
                                
                                currentCommandIndex++;
                                
                                currentCommand.execute();
                        }
                        else
                        {
                                onCommandComplete();    
                        }
                }

                /**
                 * Ajoute une comande donnee à la fin de la queue.
                 */
                public function addCommand(command:ICommand):void
                {
                        commands.push(command);
                }

                /**
                 * Supprime (si elle existe) une commande de la queue.
                 */
                public function removeCommand(command:ICommand):void
                {
                        var commandIndex:int = ArrayUtils.getIndex(commands, command);
                        if (commandIndex != -1)
                        {
                                commands.splice(commandIndex, 1);
                        }
                }
                
                override public function redo():void
				{
					currentCommandIndex=0;
					execute();
				}
				
                /**
				 * undo chaque commande du batch en une fois.
				 */
				override public function undo():void
				{
					var i : int;
					for (i = commands.length-1; i >= 0 ; i--)
					{
						var currentCommand:AbstractCommand = commands[i];
						currentCommand.undo();
					}
				}
                /**
                 * Gère l'événement COMPLETE sur la commande en cours, ajoute la commande 
                 * correctement executee à l'historique (si defini) et envoie la suivante.
                 */
                private function onCurrentCommandComplete(e:Event):void
                {
                	
                		e.target.removeEventListener(Event.COMPLETE, onCurrentCommandComplete );
                        execute();
                }
                
                /**
                 * Gere l'événement ERROR sur la commande en cours et stoppe
                 * ou continue la queue en fonction de la valeur de abortOnCommandError.
                 */
                private function onCurrentCommandError(e:ErrorEvent):void
                {
                        if (abortOnCommandError == true)
                        {
                                onCommandError(e.text); 
                        }
                        else
                        {
                                execute();      
                        }
                }
                
                /**
                 * Ma classe en String ! ;)
                 */
                public override function toString():String 
                {
                        return "CommandQueue";
                }
        }
}
