package com.flashiteasy.admin.utils
{
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.api.utils.ArrayUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.TextInput;
	
	public class TextInputErrorUtils
	{
		public function TextInputErrorUtils()
		{
		}
		
		private static var textInputs  : Array = [];
		
		public static function showError( ti : TextInput , error : String ) : void 
		{
			ti.setStyle("styleName", "TextError");
			ti.errorString=Conf.languageManager.getLanguage(error);
			ti.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
			ti.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			if (!ti.hasEventListener(Event.CHANGE))
			{
				ti.addEventListener(Event.CHANGE, removeError);
			}
			textInputs.push(ti);
		}
		
		public static function resetError(ti : TextInput):void
		{
			ti.errorString=null;
			ti.setStyle("styleName", null);
			ArrayUtils.removeDuplicate(textInputs);
			ArrayUtils.removeElement(textInputs , ti);
		}
		
		public static function resetErrors():void
		{
			for each(var ti : TextInput in textInputs )
			{
				resetError(ti);
			}
		}


		private static function removeError(e:Event):void
		{
			resetError(TextInput(e.target));
			e.target.removeEventListener(Event.CHANGE, removeError);
		}
		

	}
}