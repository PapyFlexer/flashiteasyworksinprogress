package com.flashiteasy.api.core.elements
{
	import com.flashiteasy.api.core.IUIElementDescriptor;

	/**
	 * The <code><strong>IMaskElementDescriptor</strong></code> interface defines methods shared by all visual elements able to be masked
	 */
	public interface IMaskElementDescriptor extends IUIElementDescriptor
	{
		function setMask(type:String):void;
		function drawStarMask(branchAmount:int, innerSize:int, angle:int):void
		function drawBurstMask(branchAmount:int, innerSize:int, angle:int):void
		function drawPolygonMask(faceAmount:int, angle:int):void
		function drawExternalMask(target:String):void
		function drawRoundedCornerMask(tl:int, tr:int, bl:int, br:int):void
		function setMaskEnable(enable:Boolean):void
	}
}