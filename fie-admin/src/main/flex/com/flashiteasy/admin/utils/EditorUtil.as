package com.flashiteasy.admin.utils
{
	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.admin.edition.IElementEditorPanel;
	import com.flashiteasy.admin.edition.ParameterSetEditionDescriptor;
	import com.flashiteasy.admin.parameter.ParameterIntrospectionUtil;
	import com.flashiteasy.api.core.IParameterSet;
	
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.Container;

	public class EditorUtil
	{
		public static function findEditor(name:String, panel:IElementEditorPanel):*
		{
		/*for ( var i:int = 0 ; i<panel.numChildren ; i++){
		   var control : * = editorPanelsContainer.getChildAt(i);
		   if(panel.getDescriptor().getParameterSet()==pset)
		   return panel;
		 }*/
			 //var control:DisplayObject;
		}
		
		public static function retrieveEditor(pset:IParameterSet):IElementEditorPanel{
			var box:Container;
			var i:int;
			var d:DisplayObject;
			var panel : IElementEditorPanel;
			var editionDescriptor:ParameterSetEditionDescriptor = ParameterIntrospectionUtil.getParameterSetEditionDescriptor(pset);
				box =(Ref.editorContainer.getChildByName(editionDescriptor.getGroupName()) as Container);
				if(box != null)
				{
					for ( i= 0 ; i<box.numChildren ; i++){
						d=box.getChildAt(i);
						panel = box.getChildAt(i) as IElementEditorPanel;
						var p:IParameterSet=panel.getDescriptor().getParameterSet();
						var c:String=getQualifiedClassName(pset);
						if(getQualifiedClassName(panel.getDescriptor().getParameterSet())==getQualifiedClassName(pset))
							return panel;
							
					}
				}
				
			return null ;
		}
		
		public static function findUniqueName(name:String, usedNames:Array):String
		{
			var found:Boolean=false;
			var newName:String;
			for (var i:int = 0; i < usedNames.length; i++)
			{
				var dupli:String =usedNames[i].toString();
				var j:int=0;
				var tempName:String =name;
				if (name == dupli)
				{
					found=true;
					var tempsubstr:String=tempName.substr(-1, 1);
					var tempsubstr2:String=tempName.substr(-2, 2);
					var howMuch:int = 0;
					var newval:int = 1;
					if (!isNaN(Number(tempsubstr)))
					{
						howMuch=1;
						newval=Number(tempsubstr) + 1;
						if (!isNaN(Number(tempsubstr2)))
						{
							howMuch=2;
							newval=Number(tempsubstr2) + 1;
						}
					}
					var tempstring:String=tempName.substr(0, tempName.length - howMuch);
					newName=tempstring + newval;
					break;
				}
				
			}
			if (found)
			{
				newName=findUniqueName(newName, usedNames);
			}
			if (!found)
			{
				newName=name;
			}
			
			return newName;
		}

	}
}