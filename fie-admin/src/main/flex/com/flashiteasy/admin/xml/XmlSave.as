package com.flashiteasy.admin.xml
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.fieservice.FileManagerService;
	import com.flashiteasy.admin.popUp.MessagePopUp;
	import com.flashiteasy.admin.utils.BitmapUtils;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.XMLFile;
	import com.flashiteasy.api.utils.StageUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.core.Application;

	public class XmlSave extends EventDispatcher
	{
		private static var pageModificationList:Dictionary=new Dictionary();
		private static var fms:FileManagerService=new FileManagerService();
		private static var alert:MessagePopUp;
		private static var _saveTimer:Timer;

		public static function temporarySave():void
		{
			var page : Page = BrowsingManager.getInstance().getCurrentPage();
			var hasToBeSave:Boolean = ApplicationController.getInstance().getHasToBeSave(page);
			if (hasToBeSave)
			{
				alert = new MessagePopUp(Conf.languageManager.getLanguage("Prepare_for_saving..."), mx.core.Application.application as DisplayObject, true,true,false);
				page.xml = XmlSerializer.serializePage(page);
				ApplicationController.getInstance().removeFromToSave(page);
				alert.closePopUp();
				//temporarySaving();
			}
		}

		
		public static function saveCurrentPage():void
		{
			if(!fms.hasEventListener(FileManagerService.FILE_SAVED) && !fms.hasEventListener(FileManagerService.ERROR))
			{
				alert = new MessagePopUp(Conf.languageManager.getLanguage("Prepare_for_saving..."), mx.core.Application.application as DisplayObject, true);
				
				fms.addEventListener(FileManagerService.FILE_SAVED, saveSuccess, false, 0, true);
				fms.addEventListener(FileManagerService.ERROR, saveError, false, 0, true);
				_saveTimer = new Timer(300);
				_saveTimer.addEventListener(TimerEvent.TIMER, savingPage);
				_saveTimer.start();
			}
		}

		private static function savingPage(e:Event):void
		{

			_saveTimer.stop();
			_saveTimer.removeEventListener(TimerEvent.TIMER, savingPage);
			var page:Page=BrowsingManager.getInstance().getCurrentPage();
			var hasToBeSave:Boolean=ApplicationController.getInstance().getHasToBeSave(page);
			if (hasToBeSave)
			{
				page.xml=XmlSerializer.serializePage(page);
				ApplicationController.getInstance().removeFromToSave(page);
			}
			ApplicationController.getInstance().removeFromSaveList(page);
			alert.changeMessage(Conf.languageManager.getLanguage("Saving..."));
			if (BrowsingManager.getInstance().editType == "xml")
			{
				var pageToPrint : Sprite = StageUtil.getStage() as Sprite;
				fms.exportPageThumbnail( XMLFile( page ).name + ".jpg", Conf.APP_ROOT + "/xml_library/", BitmapUtils.generateThumbnail( Sprite( BitmapUtils.getBiggestContainer( page ).getFace() )));
				fms.saveContent(Conf.APP_ROOT + "/xml_library/" + XMLFile(page).name + ".xml", XMLFile(page).xml);
			}
			else
			{
				fms.exportPageThumbnail( page.getPageUrl() + ".jpg", Conf.APP_ROOT + "/xml/", BitmapUtils.generateThumbnail( Sprite( BitmapUtils.getBiggestContainer( page ).getFace() )));
				fms.saveContent(Conf.APP_ROOT + "/xml/" + page.getPageUrl() + ".xml", page.xml);
			}

		}

		private static function saveError(e:Event):void
		{
			fms.removeEventListener(FileManagerService.ERROR, saveError);
			fms.removeEventListener(FileManagerService.FILE_SAVED, saveSuccess);
			alert.changeMessage(Conf.languageManager.getLanguage("Error_while_saving"));
			alert.showOk();
		}

		private static function saveSuccess(e:Event):void
		{
			fms.removeEventListener(FileManagerService.ERROR, saveError);
			fms.removeEventListener(FileManagerService.FILE_SAVED, saveSuccess);
			trace("XML saved");
			alert.closePopUp();
			
		}


	}
}