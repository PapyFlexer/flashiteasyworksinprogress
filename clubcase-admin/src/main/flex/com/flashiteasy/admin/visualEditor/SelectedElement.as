package com.flashiteasy.admin.visualEditor
{
	import com.flashiteasy.admin.parameter.ParameterIntrospectionUtil;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.parameters.AlignParameterSet;
	import com.flashiteasy.api.parameters.PositionParameterSet;
	import com.flashiteasy.api.parameters.RotationParameterSet;
	import com.flashiteasy.api.parameters.SizeParameterSet;
	import com.flashiteasy.api.utils.DisplayListUtils;
	import com.flashiteasy.api.utils.MatrixUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class SelectedElement
	{

		public var element:IUIElementDescriptor;

		private var positionParameter:PositionParameterSet;
		private var startPosition:Point;
		private var startSize:Point;
		private var globalStartPosition:Point;
		private var clickPosition:Point;
		private var selectionPosition:Point;
		private var alignParameter:AlignParameterSet;
		private var sizeParameter:SizeParameterSet;
		private var startWidth:Number;
		private var startHeight:Number;

		private var rotationParameter:RotationParameterSet;
		private var startRotation:Number;
		private var parentFace:DisplayObjectContainer;

		public function SelectedElement(elem:IUIElementDescriptor)
		{
			element = elem;
			var face : FieUIComponent = element.getFace();
			positionParameter=ParameterIntrospectionUtil.retrieveParameter(new PositionParameterSet(), element) as PositionParameterSet;
			sizeParameter=ParameterIntrospectionUtil.retrieveParameter(new SizeParameterSet(), element) as SizeParameterSet;
			rotationParameter=ParameterIntrospectionUtil.retrieveParameter(new RotationParameterSet(), element) as RotationParameterSet;
			alignParameter=ParameterIntrospectionUtil.retrieveParameter(new AlignParameterSet(), element) as AlignParameterSet;
			this.startWidth=face.width;
			this.startHeight=face.height;
			startRotation=MatrixUtils.getAngle(face.transform.concatenatedMatrix);
			startPosition=new Point(positionParameter.x, positionParameter.y);
			startSize=new Point(sizeParameter.width, sizeParameter.height);
			globalStartPosition=element.getFace().localToGlobal(new Point());
			parentFace = element.getContainer();

		}

		public function set start_position(value:Point):void
		{
			startPosition=value;
		}

		public function get global_start_position():Point
		{
			return globalStartPosition;
		}

		public function get start_position():Point
		{
			return startPosition;
		}

		public function get start_size():Point
		{
			return startSize;
		}


		public function get rotation():RotationParameterSet
		{
			return rotationParameter;
		}

		public function get size():SizeParameterSet
		{
			return sizeParameter;
		}

		public function get position():PositionParameterSet
		{
			return positionParameter;
		}

		public function get align():AlignParameterSet
		{
			return alignParameter;
		}

		public function get start_rotation():Number
		{
			return startRotation;
		}

		public function get originalWidth():Number
		{
			return startWidth;
		}

		public function get originalHeight():Number
		{
			return startHeight;
		}

		public function getBounds():Rectangle
		{
			return DisplayListUtils.getRealBounds(element.getFace());
		}

		public function get uuid():String
		{
			return element.uuid;
		}

		public function setPosition(x:Number, y:Number, percentX:Boolean, percentY:Boolean, changePercent:Boolean=false):void
		{


			if (changePercent)
			{
				positionParameter.is_percent_x=percentX;
				positionParameter.is_percent_y=percentY;
			}
			changePosition(x, y);
		}

		public function addPercentToDefaultPosition(percentX:Number, percentY:Number):void
		{
			if (!positionParameter.is_percent_x)
			{
				positionParameter.x=startPosition.x + startPosition.x / 100 * percentX;
			}
			if (!positionParameter.is_percent_y)
			{
				positionParameter.y=startPosition.y + startPosition.y / 100 * percentY;
			}

		}

		public function addValueToDefaultPosition(x:Number, y:Number):void
		{
			if (positionParameter.is_percent_x)
			{
				var parentXDiff:Number=(x * 100) / parentFace.width;
				positionParameter.x=startPosition.x + parentXDiff;
			}
			else
			{
				positionParameter.x=startPosition.x + x;
			}
			if (positionParameter.is_percent_y)
			{
				var parentYDiff:Number=(y * 100) / parentFace.height;
				positionParameter.y=startPosition.y + parentYDiff;
			}
			else
			{
				positionParameter.y=startPosition.y + y;
			}
		}

		private function getAlignTransformPoint(p:Point):Point
		{
			var parentContainer:DisplayObjectContainer=parentFace;
			var alignPoint:Point=p;
			if (parentContainer != null)
			{
				if (!isNaN(parentContainer.height) && !isNaN(parentContainer.width))
				{
					var faceHeight:Number=sizeParameter.is_percent_h ? parentContainer.height * sizeParameter.height / 100 : sizeParameter.height;
					var faceWidth:Number=sizeParameter.is_percent_w ? parentContainer.width * sizeParameter.width / 100 : sizeParameter.width;
					var parentH: Number = parentContainer is AbstractBootstrap ? AbstractBootstrap(parentContainer).getStage().stageHeight : parentContainer.height;
					var parentW: Number = parentContainer is AbstractBootstrap ? AbstractBootstrap(parentContainer).getStage().stageWidth : parentContainer.width;
					switch (alignParameter.v_align)
					{
						case "top":
							//getFace().y=this.parentBlock.padding_top;
							break;
						case "bottom":
							alignPoint.y=p.y - (parentH - faceHeight);
							break;
						case "middle":

							alignPoint.y=p.y - ((parentH - faceHeight) * 0.5);
							break;
						default:
							break;
					}
					switch (alignParameter.h_align)
					{
						case "left":
							//getFace().x=this.parentBlock.padding_left;
							break;
						case "right":
							alignPoint.x=p.x - (parentW - faceWidth);
							break;
						case "middle":
							alignPoint.x=p.x - ((parentW - faceWidth) * 0.5);
							break;
						default:
							break;
					}
				}
			}
			return alignPoint;
		}

		public function changePosition(x:Number, y:Number):void
		{
			var p:Point=getAlignTransformPoint(new Point(Math.round(x),Math.round(y)));
			if (positionParameter.is_percent_x)
			{
				positionParameter.x=p.x * 100 / (parentFace.width);
			}
			else
			{
				positionParameter.x=p.x;
			}
			if (positionParameter.is_percent_y)
			{
				positionParameter.y=p.y * 100 / (parentFace.height);
			}
			else
			{
				positionParameter.y=p.y;
			}
		}

		public function setPositionFromGlobal(globalPoint:Point):void
		{
			var localPoint:Point=parentFace.globalToLocal(globalPoint);
			changePosition(localPoint.x, localPoint.y);
		}

		public function addPercentToDefaultSize(percentW:Number, percentH:Number):void
		{

				if (!sizeParameter.is_percent_h)
				{
					sizeParameter.height=startHeight + startHeight / 100 * percentH;
				}
				else
				{
					var heightInPixel:Number=startHeight + (startHeight / 100 * percentH);
					sizeParameter.height=heightInPixel * 100 / parentFace.height;
				}

				if (!sizeParameter.is_percent_w)
				{
					sizeParameter.width=startWidth + startWidth / 100 * percentW;
				}
				else
				{

					var widthInPixel:Number=startWidth + startWidth / 100 * percentW;
					sizeParameter.width=widthInPixel * 100 / parentFace.width;
				}


		}

		public function setPercentToSize(percentW:Number, percentH:Number):void
		{
			sizeParameter.height=sizeParameter.height / 100 * percentH;
			sizeParameter.width=sizeParameter.width / 100 * percentW;
		}



		public function changeSize(width:Number, height:Number):void
		{
			if (sizeParameter.is_percent_h)
			{
				sizeParameter.height=height * 100 / parentFace.height;
			}
			else
			{
				sizeParameter.height=height;
			}
			if (sizeParameter.is_percent_w)
			{
				sizeParameter.width=width * 100 / parentFace.width;
			}
			else
			{
				sizeParameter.width=width;
			}
		}


		public function setSize(width:Number, height:Number, percentH:Boolean, percentW:Boolean, changePercent:Boolean=false):void
		{

			if (changePercent)
			{
				sizeParameter.is_percent_h=percentH;
				sizeParameter.is_percent_w=percentW;
			}

			if (sizeParameter.is_percent_h)
			{
				sizeParameter.height=height * 100 / parentFace.height;
			}
			else
			{
				sizeParameter.height=height;
			}
			if (sizeParameter.is_percent_w)
			{
				sizeParameter.width=width * 100 / parentFace.width;
			}
			else
			{
				sizeParameter.width=width;
			}
		}

		public function setRotation(angle:Number):void
		{
			rotationParameter.rotation=angle;
		}

		public function setGlobalRotation(angle:Number):void
		{
			var invertMatrix:Matrix=parentFace.transform.concatenatedMatrix;
			var parentAngle:Number=MatrixUtils.getAngle(invertMatrix);
			var trueAngle:Number=angle - parentAngle;
			setRotation(trueAngle);
		}

		public function getFace():DisplayObject
		{
			return element.getFace();
		}

		public function actualize():void
		{
			startPosition=new Point(positionParameter.x, positionParameter.y);
			startSize=new Point(sizeParameter.width, sizeParameter.height);
			startWidth=element.getFace().width;
			globalStartPosition=element.getFace().localToGlobal(new Point());
			startHeight=element.getFace().height;
			startRotation=MatrixUtils.getAngle(element.getFace().transform.concatenatedMatrix);
		}

		public function refresh(refreshSize:Boolean=true):void
		{
			if (refreshSize)
			{
				sizeParameter.apply(element);
			}
			rotationParameter.apply(element);
			positionParameter.apply(element);
			SimpleUIElementDescriptor(element).invalidate();
		}


	}
}
