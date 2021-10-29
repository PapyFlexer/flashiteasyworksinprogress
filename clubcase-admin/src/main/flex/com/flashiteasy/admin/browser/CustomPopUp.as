package
{
	import com.flashiteasy.admin.conf.Conf;
	
	import mx.containers.TitleWindow;
	import mx.controls.Button;
	import mx.controls.Text;
	import mx.controls.TextInput;
	
	public class CustomPopUp
	{
				// Variable pour les popup

		private var uploadBox:TitleWindow; // fenetre popup

		// elements dont les popup auront eventuellement besoin

		private var popup_text1:Text;
		private var popup_text2:Text;
		private var popup_textInput:TextInput;
		private var popup_button1:Button;
		private var popup_button2:Button;
		
		public function CustomPopUp()
		{
		}
		
		private function popup_mkdir(e:Event):void{
				uploadBox=new TitleWindow();
				uploadBox=PopUpManager.createPopUp( mx.core.Application.application as DisplayObject , TitleWindow, true) as TitleWindow;
				uploadBox.showCloseButton=true;
				uploadBox.title=Conf.languageManager.getLanguage("Create_New_Version");
				uploadBox.addEventListener(CloseEvent.CLOSE, close_popup);
				popup_text1=new Text();
				popup_text1.text=Conf.languageManager.getLanguage("New_Version_Name");
				popup_textInput= new TextInput();
				popup_textInput.text=Conf.languageManager.getLanguage("New_Version");
				popup_button1=new Button();
				popup_button1.x=360;
				popup_button1.y=40;
				popup_button1.label=Conf.languageManager.getLanguage("Confirm");
				popup_button1.addEventListener(MouseEvent.CLICK, confirmMkdir);
				popup_button2=new Button();
				popup_button2.x=360;
				popup_button2.y=70;
				popup_button2.label=Conf.languageManager.getLanguage("Cancel");
				popup_button2.addEventListener(MouseEvent.CLICK, close_popup);
				uploadBox.addChild(popup_text1);
				uploadBox.addChild(popup_textInput);
				uploadBox.addChild(popup_button1);
				uploadBox.addChild(popup_button2);
				PopUpManager.centerPopUp(uploadBox);
		}
		
		// Fonction traitant les evenements 
		
		private function confirmMkdir(e:Event):void{
				current_action="_mkdir";
				variables.action=current_action;
				variables.noms=default_directory+"/"+popup_textInput.text;
				var _fileRequest:URLRequest=new URLRequest(file_manager);
				_fileRequest.data=variables;
				_fileRequest.method="POST";
				loader.load(_fileRequest);
		}
		
		private function close_popup(e:Event):void{
				close_popup2();
			}
			

		private function close_popup2():void
			{
				
				popup_button1.removeEventListener(MouseEvent.CLICK, confirmMkdir);
				popup_button2.removeEventListener(MouseEvent.CLICK, close_popup);
				uploadBox.removeAllChildren();
				PopUpManager.removePopUp(uploadBox);
			}

	}
}