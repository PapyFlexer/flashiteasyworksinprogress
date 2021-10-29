package com.flashiteasy.admin.popUp
{
	import com.flashiteasy.admin.popUp.components.RemoteEditorComponent;
	import com.flashiteasy.api.fieservice.transfer.vo.RemoteParameterSet;

	public class RemoteEditorPopUp extends PopUp
	{
		public function RemoteEditorPopUp(p : RemoteParameterSet)
		{
			this._pSet = p;
			super(null, false, true, true, true);
			var editor : RemoteEditorComponent = new RemoteEditorComponent;
			editor.setRemoteParameterSet(this.pSet);
			editor.setRemoteEditorPopUp(this);
			super.addChild( editor );
			super.display();
		}
		
			private var _pSet : RemoteParameterSet;
			
			public function get pSet() : RemoteParameterSet
			{
				return _pSet;
			}
			public function set pSet( value : RemoteParameterSet ) : void
			{
				
				_pSet = value;
			}
		
		
	}
}