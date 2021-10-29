/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 *
 */

package com.flashiteasy.api.controls
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.container.MultipleUIElementDescriptor;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.FieSprite;
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.IAlignElementDescriptor;
	import com.flashiteasy.api.core.elements.IBackgroundColorableElementDescriptor;
	import com.flashiteasy.api.core.elements.IBackgroundImageElementDescriptor;
	import com.flashiteasy.api.core.elements.IBorderElementDescriptor;
	import com.flashiteasy.api.core.elements.IColorMatrixElementDescriptor;
	import com.flashiteasy.api.core.elements.IFilterElementDescriptor;
	import com.flashiteasy.api.core.elements.IMaskElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.events.FieStageResizeEvent;
	import com.flashiteasy.api.fieservice.transfer.vo.RemoteParameterSet;
	import com.flashiteasy.api.managers.SWFSize;
	import com.flashiteasy.api.managers.StageResizeManager;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.LoaderUtil;
	import com.flashiteasy.api.utils.MaskShapes;
	import com.flashiteasy.api.utils.NameUtils;
	import com.flashiteasy.api.utils.XMLParser;
	
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;

	/**
	 * Descriptor class for the <code><strong>RadioButtonGroup</strong></code> form item.
	 * <p>
	 * SimpleUIElementDescriptor : basic control, extended by every other visual control.
	 * Owns every basic methods and parameters (size, position, alignment, ...). </p>
	 * Actually is a pseudo-abstract class defining the functions that will init the control.
	 * <p>
	 * All comtrols extending this class must implement <code><strong>setContent()</strong></code>
	 * and <code><strong>getContent()</strong></code> methods.
	 * </p>
	 */
	public class SimpleUIElementDescriptor extends EventDispatcher implements IUIElementDescriptor, IFilterElementDescriptor, IAlignElementDescriptor, IBackgroundImageElementDescriptor, IBackgroundColorableElementDescriptor, IMaskElementDescriptor, IBorderElementDescriptor
	{

		private var _page:Page;
		private var innerMask:Sprite;
		private var enable_mask:Boolean=false;
		private var mask_type:String;
		private var mask_target:String;

		/**
		 * The element
		 * @default null on stage
		 */
		protected var face:FieUIComponent;

		// Size et position

		/**
		 * X position
		 * @default 0
		 */
		protected var _x:Number;

		/**
		 * Y position
		 * @default 0
		 */
		protected var _y:Number;

		/**
		 * A boolean to enable the setting of the X position in percent
		 * @default false
		 */
		public var _isPercentX:Boolean;

		/**
		 * A boolean to enable the setting of the Y position in percent
		 * @default false
		 */
		public var _isPercentY:Boolean;

		// Positionnement relatif a un bloc

		/**
		 * Name of the target element on stage, used when relative positionning is activated.
		 * @default null
		 */
		protected var targetId:String=null; // uuid de la target

		/**
		 * Instance of the target element on stage (by its descriptor), used when relative positionning is activated.
		 * @default null
		 */
		protected var target:SimpleUIElementDescriptor; // reference a la target

		/**
		 * relative positionning type, used when relative positionning is activated (possible values : top, bottom, lef, right).
		 * @default null
		 */
		protected var mode:String; // mode de positionnement ( bottom left right top )

		//---- size -----

		// width and height value from parameterSet

		/**
		 * Width of the element
		 * @default 100
		 */
		protected var w:Number;

		/**
		 * Height of the element
		 * @default 100
		 */
		protected var h:Number;

		/**
		 * A boolean to enable the setting of the element's width in percent
		 * @default false
		 */
		public var _isPercentW:Boolean;

		/**
		 * A boolean to enable the setting of the element's height in percent
		 * @default false
		 */
		public var _isPercentH:Boolean;

		// Real size in pixel

		private var _width:Number;
		private var _height:Number;

		// --- Align ----

		private var _v_align:String;
		private var _h_align:String;

		// ---- resize container
		// indique si le control resize le container 

		private var _resizeContainer:Boolean=true;


		// ==== Background color

		/**
		 * Numeric value of the background color (0xRRGGBB)
		 * @default : 0xFFFFFF
		 */
		protected var bgColor:Number;

		/**
		 * Numeric value of the alpha applied to backgound (0=transparent, 1=opaque, any value between)
		 * @default : 1
		 */
		protected var bgAlpha:Number;

		// ---- background image -----

		/**
		 * URL of the background image source (if used).
		 * @default : 0xFFFFFF
		 */
		protected var BackgroundImage:String="";

		/**
		 * Instance of a loader taht will call the image source (if used).
		 * @default : null;
		 */
		protected var BackgroundImageLoader:Loader;

		// ------ matrice de couleurs ----

		private var filterMatrix:Array;


		// ======================


		private var _xml:XML; // variable pour le changement de xml

		private var bmp:Bitmap; // variable pour la creation d un bitmap

		// ==== reference au bloc parent

		/**
		 * A reference to the parent container, used mostly in cascading pages hierarchy.
		 * @default
		 */
		protected var parentContainer:DisplayObjectContainer;

		/**
		 * A reference to the parent block, used mostly in cascading groups.
		 * @default
		 */
		protected var parentBlock:IUIElementContainer;

		// ====== status du control ===========

		/**
		 * A booelan that states if the control must wait for all its data is loaded before triggering the rendering.
		 * @default true
		 */
		public var waitComplete:Boolean; // Attend ou non le chargement de ses données pour s afficher


		private var is_loaded:Boolean=false;
		private var _isWaiting:Boolean=false;

		// ===== Border ================

		protected var borderComponent:UIComponent=new UIComponent;
		private var enableBorder:Boolean=false;
		private var borderColor:Number;
		private var borderTop:int;
		private var borderBottom:int;
		private var borderLeft:int;
		private var borderRight:int;

		// ==== Scroller ===============

		/**
		 * Does the control need a scroller ?
		 * @default false
		 */
		protected var scroll:Boolean=false;

		/**
		 * Returns the page instance containing the control
		 * @return
		 */
		public function getPage():Page
		{
			return _page;
		}

		/**
		 * Affects the control to the page passed as argument. Used with copy/paste .
		 * @param page
		 */
		public function setPage(page:Page):void
		{
			_page=page;
			/*if(dispatch)*/
			// dispatch a change event so the page knows someting has changed
			dispatchEvent(new Event(FieEvent.PAGE_CHANGE));
		}

		/**
		 * Creation of the control on stage
		 * <p> This methods instanciates the control and adds it in its parent, a page or a container.
		 * </p>
		 * @param page page instance where the control is created.
		 * @param parent parent instance, can be the page or a container
		 * @param waitComplete
		 */
		private var hasStageListener:Boolean=false;

		public function createControl(page:Page, parent:IUIElementContainer=null, waitComplete:Boolean=true):void
		{
			this._page=page;
			this.waitComplete=waitComplete;

			// No hard dependency there, the face type used is injected.
			//face=FieUIComponent(IocContainer.getInstance(getDescriptorType(), IocContainer.GROUP_FACES));
			face=new FieUIComponent();
			ElementList.getInstance().addElement(this, page);
			if (parent != null)
			{
				parent.layoutElement(this);
			}
			else
			{
				parentContainer=AbstractBootstrap.getInstance();
				//parentContainer.addEventListener(FieEvent.CONTAINER_RESIZE, parentResize);
				//AbstractBootstrap.getInstance().getStage().addEventListener(Event.RESIZE, resizeStage);
				trace("adding stage Listener to :: " + this.uuid + " hasStageListener :: " + hasStageListener);
				if (!hasStageListener)
					StageResizeManager.getInstance(AbstractBootstrap.getInstance().getStage(), 60).addEventListener(FieStageResizeEvent.STAGE_RESIZE_PROGRESS, resizeStage);
				hasStageListener=true;
					//BrowsingManager.getInstance().addEventListener(FieEvent.PAGE_UNLOAD, removeStageListener);
			}
			initControl();
			dispatchEvent(new Event(FieEvent.CONTROL_INIT));
		}

		private function removeStageListener(e:Event):void
		{
			StageResizeManager.getInstance(AbstractBootstrap.getInstance().getStage(), 60).removeEventListener(FieStageResizeEvent.STAGE_RESIZE_PROGRESS, resizeStage);
			BrowsingManager.getInstance().removeEventListener(FieEvent.PAGE_UNLOAD, removeStageListener);

		}

		protected function resizeStage(e:Event):void
		{
			trace("STAGE WAS resized" + this.uuid);

			//sizeChanged = true;
			if (face != null)
			{
				parentResize(e);
				//parentResize(e);
				if (this is MultipleUIElementDescriptor)
				{
					if (!MultipleUIElementDescriptor(this).resizable)
					{
						trace("resize browser from stage change");
						resizeBrowser();
					}
				}
				else
				{
					//
				}
			}

			//parentResize(e);
		}

		// Resize le browser en fonction de la taille du container 

		public function resizeBrowser(e:Event=null):void
		{
			if (!LoaderUtil.isInApplication())
			{
				var stageW:Number=AbstractBootstrap.getInstance().getStage().stageWidth;
				var stageH:Number=AbstractBootstrap.getInstance().getStage().stageHeight;
				//get actual size of container on Stage
				var totalWidth:Number=x > 0 ? Math.round(width + x) : Math.round(width);
				var totalHeight:Number=y > 0 ? Math.round(height + y) : Math.round(height);
				//get browser Window available size
				/*var browserW:Number = SWFFit.innerW;
				 var browserH:Number = SWFFit.innerH;*/

				var browserW:Number=SWFSize.getBrowserWidth();
				var browserH:Number=SWFSize.getBrowserHeight();


				trace("UUID :: " + uuid + "resizeBrowser w/h" + totalWidth + "/" + totalHeight);

				trace("UUID :: " + uuid + "resizeBrowser aftr check % w/h" + totalWidth + "/" + totalHeight);
				//Is it fitting : in this case return 0
				trace("resizeBrowser sw/sh" + stageW + "/" + stageH);
				trace("resizeBrowser browserW/browserH" + browserW + "/" + browserH);
				//trace("resizeBrowser SWFFit.minW/SWFFit.minH" + SWFFit.minWid+ "/" + SWFFit.minHei);
				var widthFit:Number=browserW < totalWidth /*&& (totalWidth-browserW)>18 */ ? totalWidth : 0;
				var heightFit:Number=browserH < totalHeight /*&& (totalHeight-browserH)>18*/ ? totalHeight : 0;
				if (widthFit == 0) //Case width fitting making it relative
				{
					trace("widthFit = 0");
					//only in case it's not already the case
					/*if(SWFFit.minWid != 0)
					   {
					   SWFFit.minWid = 0;

					   //StageResizeManager.getInstance(AbstractBootstrap.getInstance().getStage(),10).dispatchEvent(new FieStageResizeEvent(FieStageResizeEvent.STAGE_RESIZE_PROGRESS));

					 }*/
					SWFSize.resizeSWFW("100%");
				}
				else //In other case we do something
				{
					trace("widthFit = " + totalWidth);
					SWFSize.resizeSWFW(totalWidth);
					/*if(SWFFit.minWid != totalWidth)
					   {

					   trace("make W");
					   SWFFit.minWid = totalWidth;
					   //dispatchW = false;
					   }
					   else
					   {
					   //donothing
					 }*/
				}
				if (heightFit == 0) //Case width fitting making it relative
				{
					trace("heightFit = 0");
					//only in case it's not already the case
					/*if(SWFFit.minHei != 0 )
					   {
					   SWFFit.minHei = 0;
					   //StageResizeManager.getInstance(AbstractBootstrap.getInstance().getStage(),10).dispatchEvent(new FieStageResizeEvent(FieStageResizeEvent.STAGE_RESIZE_PROGRESS));

					   //dispatch =true
					 }*/
					SWFSize.resizeSWFH("100%");
				}
				else //In other case we do something
				{
					trace("heightFit = " + totalHeight);
					//if(sizerH.value != totalHeight)
					/*if(SWFFit.minHei != totalHeight)
					   {
					   trace("make H");
					   SWFFit.minHei = totalHeight;
					   //dispatchH = false;
					   }
					   else
					   {
					   //donothing
					 }*/
					SWFSize.resizeSWFH(totalHeight);
				}
					//SWFFit.startFit();
				/*trace("Sizer Size W/H :: "+SWFFit.minWid+"/"+SWFFit.minHei);
				   trace("Sizer sttedSize W/H :: "+AbstractBootstrap.getInstance().getStage().stageWidth+"/"+AbstractBootstrap.getInstance().getStage().stageHeight);
				 */
			}
			else
			{
				//trace("resizeBrowser :: " + parentContainer);
				var event:FieEvent=new FieEvent(FieEvent.RESIZE_STAGE_CONTAINER);
				event.info={width: width + x, height: height + y};
				trace("event.info w :: " + event.info.width + " /h :: " + event.info.height);
				BrowsingManager.getInstance().dispatchEvent(event);
			}
		}

		/**
		 * This method is left empty because all control will extend this peseudo-abstract class.
		 * It launches the initialization of the control.
		 */
		protected function initControl():void
		{
			//Should be overrided
		}

		/**
		 * Sets the parent container
		 * @param parent the IUIElementContainer that will host the control.
		 */
		public function setParent(parent:IUIElementContainer):void
		{
			if (parentBlock != null)
			{
				//parentBlock.removeEventListener(FieEvent.CONTAINER_RESIZE, parentResize);
			}
			parentBlock=parent;
			if (parent == null)
			{

				//AbstractBootstrap.getInstance().removeEventListener(FieEvent.CONTAINER_RESIZE, resize);
				parentContainer=null;
			}

			else
			{
				//parentBlock.addEventListener(FieEvent.CONTAINER_RESIZE, parentResize, false, 0, true);
				parentContainer=parent.getFace();
			}
		}

		private function parentResize(e:Event):void
		{
			if (is_loaded)
			{
				initSize();
				drawBorder();
			}
		}

		/**
		 * Returns a boolean stating if the element has a parent cotainer
		 * @return true or false
		 */
		public function hasParent():Boolean
		{
			if (parentBlock != null)
				return true;
			return false;
		}

		/**
		 * returns the parent instance.
		 * @return
		 */
		public function getParent():IUIElementContainer
		{
			if (hasParent())
				return parentBlock;
			return null;

		}


		/**
		 * Returns the parent instance as a container. If no exists, returns the AbstractBootstrap as global parent
		 * @return
		 */
		public function getContainer():DisplayObjectContainer
		{
			if (hasParent())
				return parentContainer;
			return AbstractBootstrap.getInstance();

		}

		//=======================================================
		// ====== Initialisation des parametres ================
		//=======================================================



		/**
		 * Parameters initialization. The <code>setBackgroundColor<strong></strong></code> sets the element background color.
		 * @param color the element's backgroundcolor expressed as 0xRRGGBB
		 * @param alpha the element's backgroundalpha, expressed as a Number ranging from 0 to 1.
		 */
		public function setBackgroundColor(color:Number, alpha:Number):void
		{
			bgColor=color;
			bgAlpha=alpha;
		}


		/**
		 * Parameters initialization. The <code>setBorder<strong></strong></code> sets the element border and color (thickness can be set differently for each side).
		 * 		 *
		 * @param enable boolean that activates the border of the element
		 * @param color the element's border color expressed as 0xRRGGBB
		 * @param borderTop thickness of the top side
		 * @param borderBottom thickness of the bottom side
		 * @param borderLeft thickness of the left side
		 * @param borderRight thickness of the right side
		 */
		public function setBorder(enable:Boolean, color:Number, borderTop:int, borderBottom:int, borderLeft:int, borderRight:int):void
		{
			enableBorder=enable;
			this.borderColor=color;
			this.borderTop=borderTop;
			this.borderBottom=borderBottom;
			this.borderLeft=borderLeft;
			this.borderRight=borderRight;
		}
		
		public function setScale( scaleX: Number , scaleY : Number ) : void 
		{
			face.scaleX = scaleX;
			face.scaleY - scaleY;
		}

		// ------ Load d une image de fond ---------

		/**
		 * Sets an image as element's background. Also instanciates its loader.
		 * @param source the url of the image
		 * @param alpha the transparency applied to the image background
		 * @param repeat the pattern replication mode (diabled for now)
		 */
		public function setBackgroundImage(source:String, alpha:Number, repeat:String):void
		{
			if (BackgroundImageLoader == null)
			{
				BackgroundImageLoader=new Loader();
			}
			BackgroundImageLoader.alpha=alpha;
			if (source != BackgroundImage && source != null)
			{
				BackgroundImage=source;

				if (repeat == null)
				{

					var ul:URLRequest=new URLRequest(AbstractBootstrap.getInstance().getBaseUrl() + "/" + source);
					BackgroundImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBackgroundImageComplete, false, 0, true);
					BackgroundImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadBackgroundImageFail, false, 0, true);
					BackgroundImageLoader.load(ul);
				}
			}
		}

		/**
		 * Method fired when the background image has completed its loading.
		 * @param e event complete
		 */
		protected function loadBackgroundImageComplete(e:Event):void
		{
			BackgroundImageLoader.width=Math.abs(width);
			BackgroundImageLoader.height=Math.abs(height);
			BackgroundImageLoader.scaleX=width < 0 ? -Math.abs(BackgroundImageLoader.scaleX) : Math.abs(BackgroundImageLoader.scaleX);
			BackgroundImageLoader.scaleY=height < 0 ? -Math.abs(BackgroundImageLoader.scaleY) : Math.abs(BackgroundImageLoader.scaleY);
			face.addChildAt(BackgroundImageLoader, 0);
			BackgroundImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadBackgroundImageComplete);
		}

		/**
		 * Method fired when the background image loading has failed.
		 * @param e event error.
		 */
		protected function loadBackgroundImageFail(e:IOErrorEvent):void
		{
			trace("background image fail ");
		}

		// Fonction indiquant si le control a une position relative a un bloc

		/**
		 * Activates the relative positioning of the element by defining the target element and the positioning mode.
		 * @param target the name of the element to which the position is relative
		 * @param mode the type of relative positionning
		 */
		public function setTargetPosition(target:String, mode:String):void
		{
			this.targetId=target;
			this.mode=mode;
			if (this.targetId != null && this.targetId != "")
			{
				// recupere une reference de la target
				this.target=SimpleUIElementDescriptor(ElementList.getInstance().getElement(target, _page));
				if (!this.target.getFace().hasEventListener(FieEvent.MOVED))
				{
					// repositionne le control si la target bouge ou se resize
					this.target.getFace().addEventListener(FieEvent.MOVED, setRelativePosition, false, 0, true);
					this.target.getFace().addEventListener(FieEvent.RESIZE, setRelativePosition, false, 0, true);
				}
			}

		}


		/**
		 * Applies filters to the element
		 * @param filter an array of filters applied to the element
		 */
		public function setFilters(filter:Array):void
		{
			face.filters=filter;
		}

		/**
		 * A variable thats records if the original element size has been modified. Used to fire a resize event
		 * @default false
		 */
		protected var sizeChanged:Boolean=false;

		/**
		 * Sets the definite size of the element, after having computed all the parameters that acts on size.
		 * @param w real width of the element
		 * @param h real height of the element
		 * @param isPercentW is the width expressed in percent
		 * @param isPercentH is the height expressed in percent
		 */
		public function setActualSize(w:Number, h:Number, isPercentW:Boolean, isPercentH:Boolean):void
		{
			if (this.w != w || this.h != h || _isPercentH != isPercentH || _isPercentW != isPercentW)
			{
				this.w=w;
				this.h=h;
				_isPercentW=isPercentW;
				_isPercentH=isPercentH;
				sizeChanged=true;
			}
		}


		/**
		 * Sets the alignement of the element, in relation to its parent
		 * @param v_align the vertical align mode (top, middle, bottom)
		 * @param h_align the horizontal align mode (top, center, bottom)
		 */
		public function setAlign(v_align:String, h_align:String):void
		{
			_v_align=v_align;
			_h_align=h_align;
		}

		//=========== Fonction s executant a la fin de l initialisation des parametres 

		/**
		 * Method fired after the parameters have been initialized
		 *
		 */
		protected function onComplete():void
		{
			if (!isWaiting || !waitComplete)
			{
				if (is_loaded)
				{
					drawBorder();
				}
				initSize();
				drawContent();
				drawMask();
				
				if (!waitComplete)
				{
					end();
				}
			}

		}

		/**
		 *
		 */
		protected function drawBorder():void
		{
			if (enableBorder)
			{
				borderComponent.width=Math.abs(width);
				borderComponent.height=Math.abs(width);
				var horizontalmultiplier:int=width < 0 ? -1 : 1;
				var verticalmultiplier:int=height < 0 ? -1 : 1;
				borderComponent.graphics.clear();
				borderComponent.graphics.moveTo(0, borderTop * 0.5 * verticalmultiplier);
				if (borderTop == 0)
				{
					borderComponent.graphics.lineStyle();
				}
				else
				{
					borderComponent.graphics.lineStyle(borderTop, borderColor, 1, false, "normal", CapsStyle.NONE);
				}

				borderComponent.graphics.lineTo(width, borderTop * 0.5 * verticalmultiplier);
				if (borderRight == 0)
				{
					borderComponent.graphics.lineStyle();
				}
				else
				{
					borderComponent.graphics.lineStyle(borderRight, borderColor, 1, false, "normal", CapsStyle.NONE);
				}

				borderComponent.graphics.moveTo(width - borderRight * 0.5 * horizontalmultiplier, 0);
				borderComponent.graphics.lineTo(width - borderRight * 0.5 * horizontalmultiplier, height);
				if (borderBottom == 0)
				{
					borderComponent.graphics.lineStyle();
				}
				else
				{
					borderComponent.graphics.lineStyle(borderBottom, borderColor, 1, false, "normal", CapsStyle.NONE);
				}
				borderComponent.graphics.moveTo(width, height - borderBottom * 0.5 * verticalmultiplier);
				borderComponent.graphics.lineTo(0, height - borderBottom * 0.5 * verticalmultiplier);
				if (borderLeft == 0)
				{
					borderComponent.graphics.lineStyle();
				}
				else
				{
					borderComponent.graphics.lineStyle(borderLeft, borderColor, 1, false, "normal", CapsStyle.NONE);
				}
				borderComponent.graphics.moveTo(borderLeft * 0.5 * horizontalmultiplier, height);
				borderComponent.graphics.lineTo(borderLeft * 0.5 * horizontalmultiplier, 0);
				face.addChild(borderComponent);
			}
			else
			{
				borderComponent.graphics.clear();
			}
		}

		private function drawInnerMask():void
		{
			if (innerMask != null)
			{
				face.removeChild(innerMask);
				innerMask=null;
			}
			var tmp:Number;
			innerMask=new Sprite();
			innerMask.graphics.clear();
			innerMask.graphics.beginFill(0xFF00FF, 1);
			mask_target=null;
			switch (mask_type)
			{
				case "normal":
					innerMask.graphics.drawRect(0, 0, width, height);
					break;
				case "circle":
					tmp=Math.min(width, height);
					innerMask.graphics.drawCircle(width / 2, height / 2, tmp / 2);
					break;
				case "ellipse":
					innerMask.graphics.drawEllipse(0, 0, width, height);
					break;
				case "roundRectangle":
					innerMask.graphics.drawRoundRectComplex(0, 0, width, height, mask_object.tl, mask_object.tr, mask_object.bl, mask_object.br);
					break;
				case "star":
					tmp=Math.min(width, height);
					MaskShapes.star(innerMask, width / 2, height / 2, mask_object.amount, mask_object.radius, tmp / 2, mask_object.angle);

					break;
				case "polygon":
					MaskShapes.polygon(innerMask, width, height, mask_object.amount, mask_object.angle);
					break;
				case "burst":
					tmp=Math.min(width, height);
					//targ : Sprite, sides : uint, innerRadius : Number, angle : Number = 0
					MaskShapes.burst(innerMask, width / 2, height / 2, mask_object.amount, mask_object.radius, tmp / 2, mask_object.angle);

			}
			innerMask.graphics.endFill();

			face.addChild(innerMask);
			face.mask=innerMask;
		}

		// Fonction indiquant si le control doit masquer un bloc
		/**
		 * A variable that keeps the name of mask target when the element must act as a mask
		 * @default null
		 */
		public var targetToMaskId:String=null;

		/**
		 * A variable that states if the element must act as a mask for another one
		 * @default false
		 */
		public var isMaskEnable:Boolean=false;

		/**
		 * A variable that states if the element must act as a mask for another one
		 * @default null
		 */
		public var isMask:Boolean=false;

		/**
		 * applies the current element as a mask for the given target
		 */
		public function setMaskToTarget():void
		{

			var targetToMask:SimpleUIElementDescriptor=SimpleUIElementDescriptor(ElementList.getInstance().getElement(targetToMaskId, _page));

			if (targetToMask.getFace().mask != face)
			{
				if (isMaskEnable)
				{
					targetToMask.hasExternalMask=this;
					isMask=true;
					targetToMask.setExternalMask();
				}
				else
				{

					isMask=false;
					targetToMask.hasExternalMask=null;
					targetToMask.setExternalMask();
				}

			}

		}


		/**
		 * A variable that keeps the instance of another element on stage, the one the present element must be masked by.
		 * @default null
		 */
		public var hasExternalMask:SimpleUIElementDescriptor=null;

		/**
		 * Sets another element as masking the current one.
		 */
		public function setExternalMask():void
		{
			if (hasExternalMask != null)
			{
				face.mask=null;
				FieSprite(face).enableNesting=false;
				FieSprite(hasExternalMask.getFace()).enableNesting=false;
				face.mask=hasExternalMask.getFace();
				hasExternalMask.isMaskEnable=true;
			}
			else
			{
				if (innerMask == null)
					face.mask=null;
			}
		}

		/*	public function enableMask(enable:Boolean):void
		   {
		   enable_mask=enable;
		   if(!enable_mask)
		   unsetExternalMask();
		 }*/

		private var mask_object:Object=null;

		/**
		 * Sets the typ of te internal mask
		 * @param type
		 */
		public function setMask(type:String):void
		{
			unsetExternalMask();
			mask_type=type;
			mask_object=null;
			mask_target=null;
		}

		/**
		 * Sets the internal mask as a <strong>star</strong>.
		 * @param branchAmount the number of <strong>star</strong> branches
		 * @param innerSize the inner radius of the <strong>star</strong> branches
		 * @param angle the starting angle of the <strong>star</strong>
		 */
		public function drawStarMask(branchAmount:int, innerSize:int, angle:int):void
		{
			unsetExternalMask();
			mask_type="star";
			mask_object={amount: branchAmount, radius: innerSize, angle: angle};
			mask_target=null;
		}

		/**
		 * Sets the internal mask as a <strong>burst</strong>.
		 * @param branchAmount the number of <strong>burst</strong> branches
		 * @param innerSize the inner radius of the <strong>burst</strong> branches
		 * @param angle the starting angle of the <strong>burst</strong>
		 */
		public function drawBurstMask(branchAmount:int, innerSize:int, angle:int):void
		{
			unsetExternalMask();
			mask_type="burst";
			mask_object={amount: branchAmount, radius: innerSize, angle: angle};
			mask_target=null;
		}


		/**
		 * Sets the internal mask as a <strong>polygon</strong>.
		 * @param faceAmount the number of <strong>polygon</strong> branches
		 * @param angle the starting angle of the <strong>polygon</strong>
		 */
		public function drawPolygonMask(faceAmount:int, angle:int):void
		{
			unsetExternalMask();
			mask_type="polygon";
			mask_object={amount: faceAmount, angle: angle};
			mask_target=null;
		}


		/**
		 * Sets the internal mask as a <strong>rounded rectangle</strong>, where each corner size is free.
		 * @param tl top left corner circle radius
		 * @param tr top right corner circle radius
		 * @param bl bottom left corner circle radius
		 * @param br bottom right corner circle radius
		 */
		public function drawRoundedCornerMask(tl:int, tr:int, bl:int, br:int):void
		{
			unsetExternalMask();
			mask_type="roundRectangle";
			mask_object={tl: tl, tr: tr, bl: bl, br: br};
			mask_target=null;
		}

		/**
		 * Sets the external mask as a <strong>rtarget</strong>.
		 * @param target the name of the element masking the current one
		 */
		public function drawExternalMask(target:String):void
		{
			unsetExternalMask();
			mask_target=target;
			mask_type="external";
			mask_object=null;
		}

		private function unsetExternalMask():void
		{
			if (hasExternalMask != null)
			{
				face.mask=null;
				FieSprite(face).enableNesting=true;
				FieSprite(hasExternalMask.getFace()).enableNesting=true;
				hasExternalMask.isMask=false;
				hasExternalMask.isMaskEnable=false;
				hasExternalMask=null;
				mask_target=null;
			}
		}

		/**
		 *
		 * @param enable
		 */
		public function setMaskEnable(enable:Boolean):void
		{
			enable_mask=enable;

			if (!enable_mask)
				unsetExternalMask();
		}

		/**
		 *
		 */
		protected function drawMask():void
		{
			//if external mask exist we don't try to draw
			//
			if (hasExternalMask == null)
			{
				if (enable_mask)
				{
					if (mask_type != "external")
					{
						drawInnerMask();
					}
					else
					{
						//if (mask_target != null && mask_target != "null")
						//{
						var targetMask:SimpleUIElementDescriptor=SimpleUIElementDescriptor(ElementList.getInstance().getElement(mask_target, _page));
						if (targetMask != null)
						{
							hasExternalMask=targetMask;
							targetMask.isMask=true;

							targetMask.targetToMaskId=this.uuid;
							targetMask.isMaskEnable=true;
							if (innerMask != null)
							{
								face.removeChild(innerMask);
								face.mask=null;
								innerMask=null;
							}
							FieSprite(face).enableNesting=false;
							if (targetMask.getFace() != null)
							{
								setExternalMask();
							}
						}
							//}

					}
					if (isMask)
					{
						var targetToMask:SimpleUIElementDescriptor=SimpleUIElementDescriptor(ElementList.getInstance().getElement(targetToMaskId, _page));
						FieSprite(targetToMask.getFace()).enableNesting=false;
						FieSprite(face).enableNesting=false;
						targetToMask.setExternalMask();
					}


				}
				else
				{
					if (!isMask)
					{
						if (innerMask != null)
						{
							face.removeChild(innerMask);
							innerMask=null;
						}
						face.mask=null;
					}
					else
					{
						//FieSprite(face).enableNesting = false;
						setMaskToTarget();
					}
				}


			}

		}

		// fonction appelée apres l'initialisation de la taille du composant

		/**
		 *
		 */
		protected function drawContent():void
		{
			//Should be overrided
		}

		// Fonction s executant quand tout les parametres sont initialisé

		/**
		 * Method that initializes position and size
		 */
		public function initSize(align:Boolean=true):void
		{
			applySize();

			// Init de la position
			// si la position est relative par rapport a un autre bloc

			if (target != null)
			{
				if (target.isLoaded()) // verifie si la cible est chargee pour appliquer la position
				{
					setRelativePosition();
				}
				else // attend son load sinon
				{
					target.addEventListener(FieEvent.COMPLETE, setRelativePosition, false, 0, true);
				}
			}
			else
			{

				if (align)
					applyPosition();
			}
			//if(align)
			applyAlign();
		}


		/**
		 * Applies the element alignment
		 */
		public function applyAlign():void
		{

			if (_v_align != null && _h_align != null)
			{
				if (this.parentContainer != null)
				{
					if (!isNaN(this.parentContainer.height) && !isNaN(this.parentContainer.width))
					{

						var _stage:Stage;
						if (parentContainer is AbstractBootstrap)
						{
							_stage=AbstractBootstrap(parentContainer).getStage();
						}
						var X:Number=_x;
						var Y:Number=_y;
						if (_isPercentX)
						{
							if (this.parentContainer != null && !(parentContainer is AbstractBootstrap))
							{
								X=Math.round(parentContainer.width * _x * 0.01);
							}
							else
							{
								X=Math.round(AbstractBootstrap.getInstance().stage.stageWidth * _x * 0.01);
							}
						}

						if (_isPercentY)
						{
							if (this.parentContainer != null && !(parentContainer is AbstractBootstrap))
							{
								Y=Math.round(parentContainer.height * _y * 0.01);
							}
							else
							{
								Y=Math.round(AbstractBootstrap.getInstance().stage.stageHeight * _y * 0.01);
							}
						}
						///Change +face.x and +face.y to +_x and +_y
						//so it's always calculate from real parameter
						switch (_v_align)
						{
							case "top":
								//face.y=this.parentBlock.padding_top;
								break;
							case "bottom":

								if (parentContainer is AbstractBootstrap)
								{
									face.y=_stage.stageHeight - (face.height * face.scaleY) + Y;
								}
								else
								{
									face.y=this.parentContainer.height - (face.height * face.scaleY) + Y;

								}

								break;
							case "middle":
								if (parentContainer is AbstractBootstrap)
								{
									face.y=((_stage.stageHeight - (face.height * face.scaleY)) * 0.5) + Y;

								}
								else
								{

									face.y=((this.parentContainer.height - (face.height * face.scaleY)) * 0.5) + Y;
								}
								break;
							default:
								break;
						}
						switch (_h_align)
						{
							case "left":
								//face.x=this.parentBlock.padding_left;
								break;
							case "right":
								if (parentContainer is AbstractBootstrap)
								{
									face.x=_stage.stageWidth - (face.width * face.scaleX) + X;

								}
								else
								{
									face.x=this.parentContainer.width - (face.width * face.scaleX) + X;
								}
								break;
							case "middle":
								if (parentContainer is AbstractBootstrap)
								{

									face.x=((_stage.stageWidth - (face.width * face.scaleX)) * 0.5) + X;
								}
								else
								{
									face.x=((this.parentContainer.width - (face.width * face.scaleX)) * 0.5) + X;
								}
								break;
							default:
								break;
						}
					}
				}
			}

		}

		/**
		 * Aplies the element size
		 */
		public function applySize():void
		{
			if (sizeChanged || _isPercentW || _isPercentW || _isPercentX || _isPercentY)
			{
				if (!scroll)
				{
					if (_isPercentW)
					{
						if (this.parentContainer != null && !(parentContainer is AbstractBootstrap))
						{
							width=this.parentContainer.width * w / 100;
						}
						else if (parentContainer is AbstractBootstrap)
						{
							width=AbstractBootstrap.getInstance().getStage().stageWidth * w / 100;
						}
					}
					else
					{
						width=w;
					}
					if (_isPercentH)
					{

						if (this.parentContainer != null && !(parentContainer is AbstractBootstrap))
						{

							height=this.parentContainer.height * h / 100;
						}
						else if (parentContainer is AbstractBootstrap)
						{
							height=AbstractBootstrap.getInstance().stage.stageHeight * h / 100;

						}
					}
					else
					{

						height=h;
					}
					if (width != face.width || height != face.height)
					{
						face.width=width;
						face.height=height;
						dispatchEvent(new Event(FieEvent.RESIZE));
					}
					if (BackgroundImageLoader != null)
					{
						BackgroundImageLoader.width=Math.abs(width);
						BackgroundImageLoader.height=Math.abs(height);
						BackgroundImageLoader.scaleX=width < 0 ? -Math.abs(BackgroundImageLoader.scaleX) : Math.abs(BackgroundImageLoader.scaleX);
						BackgroundImageLoader.scaleY=height < 0 ? -Math.abs(BackgroundImageLoader.scaleY) : Math.abs(BackgroundImageLoader.scaleY);
					}
				}

				sizeChanged=false;
				onSizeChanged();
			}

			// Draw background Color 
			if (!isNaN(bgColor))
			{
				Sprite(face).graphics.clear();
				Sprite(face).graphics.beginFill(bgColor, bgAlpha);
				Sprite(face).graphics.drawRect(0, 0, width, height);
				Sprite(face).graphics.endFill();
			}
			else
			{
				Sprite(face).graphics.clear();
			}

		}

		/**
		 *
		 */
		protected function onSizeChanged():void
		{
			// overriden by subclasses 	
		}


		/**
		 *
		 */
		protected function onControlLoaded():void
		{

		}

		/**
		 * Sets the element position
		 * @param x element position along the x axis
		 * @param y element position along the x axis
		 * @param isPercentX  the x position expressed in percent ?
		 * @param isPercentY  the y position expressed in percent ?
		 */
		public function setPosition(x:Number, y:Number, isPercentX:Boolean, isPercentY:Boolean):void
		{
			if (!_lockPosition)
			{
				_x=x;
				_y=y;
				_isPercentX=isPercentX;
				_isPercentY=isPercentY;
			}
		}

		/**
		 * Sets the element X position
		 * @param x the xPosition
		 * @param apply a boolean that states if the stage must be rendered (refreshed);
		 */
		public function setX(x:Number, apply:Boolean=false):void
		{
			if (!_lockPosition)
			{
				_x=x;
				if (apply)
				{
					applyPosition();
				}
			}

		}

		/**
		 * Sets the element Y position
		 * @param y the yPosition
		 * @param apply a boolean taht states if the stage must be rendered (refreshed);
		 */
		public function setY(y:Number, apply:Boolean=false):void
		{
			if (!_lockPosition)
			{
				_y=y;
				if (apply)
				{
					applyPosition();
				}
			}
		}

		/**
		 * Applies the positionning of the element
		 */
		public function applyPosition():void
		{

			if (!_lockPosition)
			{
				// Si la cible est positionné par rapport a une cible 

				if (this.target != null)
				{
					setRelativePosition();
				}
				else
				{

					// Sinon positionnement par rapport a ses parametres
					var x:Number=_x;
					var y:Number=_y;

					var paddingLeft:int=0;
					var paddingRight:int=0;
					var paddingTop:int=0;
					var paddingBottom:int=0;
					var startX:Number=face.x;
					var startY:Number=face.y;

					// Si le control possede un parent , recupere les valeurs de son padding

					if (hasParent())
					{
						if (parentBlock.getDescriptorType() != ButtonElementDescriptor)
						{
							paddingLeft=parentBlock.padding_left;
							paddingRight=parentBlock.padding_right;
							paddingTop=parentBlock.padding_top;
							paddingBottom=parentBlock.padding_bottom;
						}
					}

					// Positionnement en pourcentage
					if (_isPercentX)
					{
						if (this.parentContainer != null && !(parentContainer is AbstractBootstrap))
						{
							face.x=Math.round(parentContainer.width * _x * 0.01);
						}
						else
						{
							face.x=Math.round(AbstractBootstrap.getInstance().stage.stageWidth * _x * 0.01);
						}

						// ----- Application du padding  ----------

						// Calcule si la position en X est inferieur au padding a gauche et ne sort pas du bloc a gauche

						if ((face.width * face.scaleX) <= parentContainer.width - paddingLeft && face.x < paddingLeft && face.x >= 0)
						{
							face.x=paddingLeft;
						}

						// Calcule si la position en X est superieur au padding a droite  et ne sort pas du bloc a droite

						if ((width * face.scaleX) < parentContainer.width - (paddingRight) && face.x + (width * face.scaleX) > parentContainer.width - paddingRight && face.x + (width * face.scaleX) <= parentContainer.width && face.x != paddingLeft)
						{
							face.x-=((width * face.scaleX) + face.x) - (parentContainer.width - paddingRight);
						}
					}
					else
					{
						face.x=_x;
					}
					if (_isPercentY)
					{
						if (this.parentContainer != null && !(parentContainer is AbstractBootstrap))
						{
							face.y=Math.round(this.parentContainer.height * _y * 0.01);
						}
						else
						{
							face.y=Math.round(AbstractBootstrap.getInstance().stage.stageHeight * _y * 0.01);
						}

						if ((height * face.scaleY) < (parentContainer.height - (paddingTop + paddingBottom)) && face.y < paddingTop && face.y >= 0)
						{
							face.y=paddingTop;
						}
						if ((height * face.scaleY) < (parentContainer.height - (paddingBottom)) && face.y + (height * face.scaleY) > parentContainer.height - paddingBottom && (face.y + (height * face.scaleY)) <= parentContainer.height && face.y != paddingTop && face.y != height - ((height * face.scaleY) + paddingBottom))
						{
							face.y=((height * face.scaleY) + face.y) - (parentContainer.height - paddingBottom);
						}
					}
					else
					{

						face.y=_y;
					}
				}
				if (face.y != startY || face.x != startX)
				{
					dispatchEvent(new Event(FieEvent.MOVED));
				}
			}
		}



		/**
		 * Sets the relative positionning of the block
		 * @param e
		 */
		protected function setRelativePosition(e:Event=null):void
		{
			switch (mode)
			{
				case "bottom":
					face.x=(target.getFace().x + _x);
					face.y=(target.getFace().y + target.getFace().height + _y);
					break;
				case "right":
					face.x=(target.getFace().x + target.getFace().width + _x);
					face.y=(target.getFace().y + _y);
					break;
			}
			this.getFace().dispatchEvent(new Event(FieEvent.MOVED));

		}

		// ==== Fonction de manipulation des parametres ======

		// applique de nouveaux parametres en fonction d un XML

		/**
		 * Applies new parameters, based on an xml string passed
		 * @param xml the xml string used to modify the element parameters
		 */
		public function changeXML(xml:String):void
		{

			_xml=new XML(xml);

			// Parse le XML et apply les parametres

			XMLParser.unserializeParameters(this, _xml);
			applyParameters();
		}

		// initialise les parametres

		/**
		 * Applies the element (descriptor) parameters (see parameters package)
		 */
		public function applyParameters():void
		{
			if (_params != null)
			{
				_params.apply(this);
				dispatchEvent(new Event(FieEvent.PARAMETER_APPLIED));
			}
			onComplete();
			//CompositeParameterSet(param).setParameterSet( MaskType(editor).getParameter());
		}

		/**
		 * Updates dynamic parameters (see remoteParameterSet) coming from a data source (RSS, SQL request, ...)
		 * @param remoteParameterSet
		 */
		public function updateParameterSet(remoteParameterSet:RemoteParameterSet):void
		{
			
				
			for each (var parameter:IParameterSet in CompositeParameterSet(_params).getParametersSet())
			{
				var fqcn:String=getQualifiedClassName(parameter);
				if (fqcn == remoteParameterSet.name.split("#")[0])
				{
					// virer l'eventlistener 
					var oValue:* = parameter[remoteParameterSet.name.split("#")[1]];
					parameter[remoteParameterSet.name.split("#")[1]]=remoteParameterSet.response;
					parameter.apply(this);
					isWaiting=false;
					invalidate();
					parameter[remoteParameterSet.name.split("#")[1]]=oValue;
					break;
				}
			}
			trace(" remote complete ");
		}

		// ==== Getter et Setter ========

		/**
		 * Automatic resize of the container
		 */
		public function get resizeContainer():Boolean
		{
			return _resizeContainer;
		}

		/**
		 * @private
		 */
		public function set resizeContainer(value:Boolean):void
		{
			_resizeContainer=value;
		}

		/**
		 * The parameters, represented by the interface <code><strong>IParameterSet</strong></code>.
		 * @default null
		 */
		protected var _params:IParameterSet;

		/**
		 * Returns the element parameters
		 * @return an IParameterSet
		 */
		public function getParameterSet():IParameterSet
		{
			return _params;
		}

		/**
		 *
		 * @param value
		 */
		public function setParameterSet(value:IParameterSet):void
		{
			_params=value;
		}

		private var _uuid:String;

		/**
		 * the unique (on page) id of the element
		 */
		public function get uuid():String
		{
			return _uuid;
		}

		/**
		 *
		 * @privatee
		 */
		public function set uuid(value:String):void
		{
			_uuid=value;
		}

		/**
		 * The element width
		 */
		public function get width():Number
		{
			return _width;
		}

		/**
		 *
		 * @private
		 */
		public function set width(value:Number):void
		{
			_width=value;
		}

		/**
		 * element's height
		 */
		public function get height():Number
		{

			return _height;
		}

		/**
		 *
		 * @private
		 */
		public function set height(value:Number):void
		{
			_height=value;
		}

		// ========Fonction generique d un control=========

		// Boolean specifiant si le bloc a fini son chargement

		/**
		 * Boolean value that states if the element has finished its loading
		 * @return a boolean true id loaded
		 */
		public function isLoaded():Boolean
		{
			return this.is_loaded;
		}
		
		
		/**
		 * Boolean value that states if the element has finished its loading
		 * @return a boolean true id loaded
		 */
		public function setIsLoaded(value:Boolean=false):void
		{
			this.is_loaded=value;
		}


		// Variable specifiant si le control possede a scroller

		/**
		 * Boolean value that states if the element is targeted by a scroller
		 */
		public function get hasScroll():Boolean
		{
			return scroll;
		}

		/**
		 *
		 * @private
		 */
		public function set hasScroll(value:Boolean):void
		{
			scroll=value;
		}

		// Renvoi l interface graphique du control

		/**
		 * Method that returns the graphical (sprite) of the element (which is always a descriptor)
		 * @return a FieUIComponent
		 */
		public function getBackgroundImage():Loader
		{
			return BackgroundImageLoader;
		}
		/**
		 * Method that returns the graphical (sprite) of the element (which is always a descriptor)
		 * @return a FieUIComponent
		 */
		public function getFace():FieUIComponent
		{
			return face;
		}

		/**
		 *
		 * @return
		 */
		public function get percentWidth():Boolean
		{
			return _isPercentW;
		}

		/**
		 *
		 * @return
		 */
		public function get percentHeight():Boolean
		{
			return _isPercentH;
		}

		/**
		 *
		 * @return
		 */
		public function get realX():Number
		{
			return face.x;
		}

		/**
		 *
		 * @return
		 */
		public function get realY():Number
		{
			return face.y;
		}

		/**
		 *
		 * @return
		 */
		public function get x():Number
		{
			return _x;
		}

		/**
		 *
		 * @return
		 */
		public function get y():Number
		{
			return _y;
		}

		/**
		 *
		 * @return
		 */
		public function get percentX():Boolean
		{
			return _isPercentX;
		}

		/**
		 *
		 * @return
		 */
		public function get percentY():Boolean
		{
			return _isPercentY;
		}


		public function get h_align():String
		{
			return _h_align;
		}


		public function get v_align():String
		{
			return _v_align;
		}

		// Renvoi la classe

		/**
		 *
		 * @return
		 */
		public function getDescriptorType():Class
		{
			throw new Error("getDescriptorType Must be overridden");
			return SimpleUIElementDescriptor;
		}

		// Detruit le control

		/**
		 *
		 * @param e
		 */
		public function remove(e:Event):void
		{
			destroy();
		}

		// Destruction d un objet

		/**
		 * Destroy the element and prepares it to be garbage collected
		 */
		public function destroy():void
		{
			trace ("destroying SimpleUI (called by super())");
			removeBitmap();
			removeListener();
			setParent(null);
			if (face != null && face.parent != null)
			{
				//delete MultipleUIElementDescriptor(face.parent).widthIncreaseList[this];
				//delete MultipleUIElementDescriptor(face.parent).heightIncreaseList[this];
				face.parent.removeChild(face);
			}
			face=null;
			ElementList.getInstance().removeElement(this, _page);
			dispatchEvent(new Event(FieEvent.REMOVED));

		}

		/**
		 * Remove the element from its container without destroying it
		 */
		public function removeFromParent():void
		{
			if (hasParent())
			{
				parentBlock.removeChild(this);
				parentBlock=null;
				parentContainer=null;
			}
			else
			{
				// Retire l element de la stage 
				face.parent.removeChild(getFace());
			}
		}

		// Fonction a appeler pour indiquer la fin du chargement d un control

		/**
		 * Method fired when the rendering of the element is finished?.
		 */
		protected function end():void
		{
			if (!is_loaded)
			{
				is_loaded=true;
				// if it is a first level component
				if (!hasParent())
				{
					// remains invisible until the whole page is loaded 
					if (!_page.isDisplayed)
					{
						face.visible=false;
					}
					AbstractBootstrap.getInstance().addChild(face);
					//Workaround to get keyboard listeners to respond
					AbstractBootstrap.getInstance().getStage().focus = this.face;
				}
				dispatchEvent(new Event(FieEvent.COMPLETE));
				//trace (this.uuid +" has been loaded");
				onControlLoaded();

			}
			if (enableBorder)
				drawBorder();
		}

		// ============= Methodes listener  ============

		// Listener ajouté lorsque le child est ajouté a la scene 


		/**
		 * Methods that dispathes an event to all stage when the element is resized, so automatically sized and positionned elements knows they hace to reinitiate their positio, and coordinates.
		 * @param e
		 */
		protected function propagateScale(e:Event):void
		{
			face.dispatchEvent(new Event(FieEvent.SCALE));
		}

		// lors du resize du parent , le control recalcule sa position et sa taille

		/**
		 * Re-initiates the sizing of the element
		 * @param e
		 */
		protected function resize(e:Event):void
		{
			// recalcule de la size et de la position du control
			initSize();
		}


		/**
		 * Removes the resizing events from the element
		 */
		public function removeListener():void
		{
			if (parentBlock != null)
			{
				//parentBlock.‚removeEventListener(FieEvent.CONTAINER_RESIZE, resize);
			}
			if (parentContainer != null)
			{
				this.parentContainer.removeEventListener(FieEvent.SCALE, propagateScale);
				//parentContainer.removeEventListener(FieEvent.CONTAINER_RESIZE, resize);
				if (parentContainer is AbstractBootstrap)
				{
					trace("remove stage listener from :: " + this.uuid);
					StageResizeManager.getInstance(AbstractBootstrap.getInstance().getStage()).removeEventListener(FieStageResizeEvent.STAGE_RESIZE_PROGRESS, resizeStage);
					AbstractBootstrap.getInstance().getStage().removeEventListener(Event.RESIZE, resizeStage);
					hasStageListener=false;
						//AbstractBootstrap.getInstance().removeEventListener(FieEvent.CONTAINER_RESIZE, resize);

				}

			}

		}

		// =======================



		// ================= BITMAP ===========================

		/**
		 * methods that gets a DisplayObject target and transforms it into a BitmapData object
		 * @param target
		 */
		public function makeBitmap(target:DisplayObject):void
		{
			if (!isNaN(width) && !isNaN(height))
			{
				var pageBmp:BitmapData;
				pageBmp=new BitmapData(width, height, true, 0);
				var m:Matrix=new Matrix();
				m.scale(target.scaleX, target.scaleY);
				pageBmp.draw(target, m, new ColorTransform(), "normal", null, true);
				bmp=new Bitmap(pageBmp);
				face.addChild(bmp);
			}
		}

		/**
		 * Removes the bitmap from the element
		 */
		public function removeBitmap():void
		{
			if (bmp != null)
			{
				face.removeChild(bmp);
				bmp=null;
			}
		}


		private var _lockPosition:Boolean=false;

		/**
		 *
		 * @param lock
		 */
		public function lockPosition(lock:Boolean):void
		{
			_lockPosition=lock;
		}


		/**
		 *
		 * @return
		 */
		public function getContent():Array
		{
			return null;
		}

		/**
		 *
		 * @param a
		 */
		public function setContent(a:Array):void
		{
		}

		public function invalidate():void
		{
			onComplete();
		}

		/**
		 *
		 * @param value
		 */
		public function set isWaiting(value:Boolean):void
		{
			_isWaiting=value;
		}

		/**
		 *
		 * @return
		 */
		public function get isWaiting():Boolean
		{
			return _isWaiting;
		}

		/**
		 * Cloning method used when copy/paste or duplicate actions are perfomed. takes chareg of the descriptor and its parameters (simple and/or composite).
		 * @param sameId Boolean that states if the copied element must keep its uuid or generate a new one. The clone is not added in the ElementList until its page is set
		 * (see next method)
		 * @return the IUIElementDescriptorof the element to be copied, cut and/or duplicated.
		 */
		public function clone(sameId:Boolean=false):IUIElementDescriptor
		{
			var c:Class=getDescriptorType();
			var control:IUIElementDescriptor=new c();
			//control.uuid=sameId ? control.uuid : "";
			control.uuid="";
			control.createControl(_page);
			control.setParameterSet(cloneParameters());
			ElementList.getInstance().removeElement(control, _page);
			control.addEventListener(FieEvent.PAGE_CHANGE, pageSet);
			control.addEventListener(FieEvent.COMPLETE, cloneComplete);
			control.getFace().visible=false;
			return control;
		}

		// The clone is not added in the ElementList until its page is set

		private function pageSet(e:Event):void
		{
			var el:IUIElementDescriptor=e.target as IUIElementDescriptor;
			el.removeEventListener(FieEvent.PAGE_CHANGE, pageSet);

			// Give an unique uuid to the clone if it doesn t have any
			if (el.uuid == "")
			{
				el.uuid=NameUtils.findUniqueName(this.uuid, ElementList.getInstance().getElementsId(BrowsingManager.getInstance().getCurrentPage()));
				/*if(el.uuid != this.uuid)
				{
					var event : FieEvent = new FieEvent(FieEvent.CONTROLNAME_CHANGE);
					event.info = {oldId: this.uuid, newId: el.uuid};
					el.dispatchEvent(event);
				}*/
			}
			// add the clone to the elementList
			ElementList.getInstance().addElement(el, BrowsingManager.getInstance().getCurrentPage());
		}

		private function cloneComplete(e:Event):void
		{
			var el:IUIElementDescriptor=e.target as IUIElementDescriptor;
			el.removeEventListener(FieEvent.COMPLETE, cloneComplete);
			el.getFace().visible=true;
			trace("clone complete");
		}

		private function cloneParameters():IParameterSet
		{
			var pSet:CompositeParameterSet=getParameterSet() as CompositeParameterSet;
			var clonedPset:CompositeParameterSet=new CompositeParameterSet;
			var params:Array=ArrayUtils.clone(pSet.getParametersSet());
			clonedPset.setParameterSet(params);
			return clonedPset;

		}

		/**
		 * Methods that gives the element its index relative to its parent container.
		 * @return the int representing the level of the current element in its parent.
		 */
		public function getIndex():int
		{
			if (hasParent())
			{
				return getParent().getChildIndex(this);
			}
			else
			{
				return face.parent.getChildIndex(face);
			}
		}


	}
}



