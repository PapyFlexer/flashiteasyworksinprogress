package com.flashiteasy.admin.uicontrol
{
	import flash.events.Event;
	
	import mx.containers.Panel;
	import mx.controls.Button;
	import mx.core.EventPriority;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	//////////////////////////////////////////////////////////////
	//	STYLES
	//////////////////////////////////////////////////////////////

	/**
     * Sets the horizontal alignment of the header children added with addTitleBarComponent and the titleTextField.
     * Values are "left" and "right".
     *
     * @default right
     */
    [Style(name="headerHorizontalAlign", type="String", enumeration="left,right", inherit="no")]

    /**
     * Sets the vertical alignment of the header children added with addTitleBarComponent and the titleTextField.
     * Values are "top, "middle" and "bottom".
     *
     * @default middle
     */
    [Style(name="headerVerticalAlign", type="String", enumeration="top,middle,bottom", inherit="no")]

    /**
     * Sets the horizontal gap of the header children added with addTitleBarComponent.
     * If no value is set, then the value of horizontalGap will be used for the gap.
     *
     * @default 6
     */
    [Style(name="headerHorizontalGap", type="Number", inherit="no")]
	
	/**
	 * Flash'Iteasy
	 * Fie team is
	 * dany, didier, gilles
	 * & many thanks to alexis, ghazi, jean-françois
	 */public class AdvancedPanel extends Panel
	{
		

		/////////////////////////////////////////////////////////////////////////////////
		// DEFAULT STYLES INIT
		/////////////////////////////////////////////////////////////////////////////////

		/**
		 * @private
		 */
    	private static var defaultStylesInitialized:Boolean = setDefaultStyles();

		/**
		 * @private
		 */
		private static function setDefaultStyles ():Boolean
		{
			var s:CSSStyleDeclaration = StyleManager.getStyleDeclaration("Pod");
			if (!s)
				s = new CSSStyleDeclaration();
			
			if (!s.getStyle("headerHorizontalAlign"))
				s.setStyle("headerHorizontalAlign", "right");
			
			if (!s.getStyle("headerVerticalAlign"))
				s.setStyle("headerVerticalAlign", "middle");
				
			if (!s.getStyle("headerHorizontalGap"))
				s.setStyle("headerHorizontalGap", 2);
			
        	StyleManager.setStyleDeclaration('AdvancedPanel', s, true);
			
			return true;
        }

        /////////////////////////////////////////////////////////////////////////////////
		//
		/////////////////////////////////////////////////////////////////////////////////

		/**
		/**
		 * @private
		 *
		 * When childeren are added to the header via mxml they are stored here until their parent assets (the header) have been created.
		 */
		protected var creationQueue:Array = [];

		/**
		 * Exposed for declaritive instantiation of title bar assets.  For MXML use only.
		 */
		[ArrayElementType("mx.core.UIComponent")]
		/**
		 * 
		 * @default 
		 */
		public var titleBarChildren:Array = [];
		
		/**
		 * @private
		 */
		protected var titleBarAssets:Array = [];

		/**
		 * The default class to be used when calling <code>addTitleBarComponent()</code> with no parameter.
		 */
		public var defaultTitleBarComponentClass:Class = Button;
		
		
		/**
		 * @private
		 */
		override public function styleChanged (styleProp:String):void
		{
			super.styleChanged(styleProp);

			var allStyles:Boolean = !styleProp || styleProp == "styleName";
			if (allStyles || styleProp == "headerHorizontalAlign" || styleProp == "headerVerticalAlign" || styleProp == "headerHorizontalGap")
			{
				invalidateProperties();
			}
		}
		/**
		 * @private
		 */
		override protected function createChildren ():void
		{
			super.createChildren();

			assignTitleBarListener();
			
			var child:UIComponent;
			for each (child in titleBarChildren)
				addTitleBarComponent(child);
				
			titleBarChildren = [];
		}
		
		/**
		 * Assigns default event handlers to the titleBar.
		 */
		protected function assignTitleBarListener ():void
		{
			titleBar.addEventListener(FlexEvent.CREATION_COMPLETE, titleBar_onCreationComplete, false, EventPriority.DEFAULT_HANDLER);
		}

		/**
		 * Adds new children to the title bar area.
		 * For most cases, title bar components should be added declaritively via MXML using titleBarChildren which calls this on the creation complete event.
		 * If however, assets are needing to be added dynamically at runtime, the developer can add them via this method.
		 *
		 * @see #titleBarChildren
		 * 
		 * @param value The UIComponent to be added.
		 *
		 * @return The UIComponent to be added.
		 */
		public function addTitleBarComponent (child:UIComponent = null):UIComponent
		{
			if (!child)
				child = new defaultTitleBarComponentClass();

			
			child.owner = this;
			
			titleBarAssets.push(child);
			
			if (!titleBar)
				creationQueue.push(child);
			
			else
				titleBar.addChild(child);
				
			invalidateDisplayList();
			
			return child;
		}
		/**
		 * @private
		 *
		 * Depending on the instantiation of this component, the titleBar may not be created yet when calling addTitleBarComponent().
		 * In order to avoid null pointer references, if a titleBarComponent is being added and the titleBar = null, the added child
		 * is placed in the creation queue.  TitleBar then references this queue and adds the components listed.
		 */
		protected function titleBar_onCreationComplete (evt:FlexEvent):void
		{
			var titleBarChild:UIComponent;
			var i:int = 0;
			var l:int = creationQueue.length;
			for (i; i < l; i++)
			{
				titleBarChild = creationQueue[i] as UIComponent;
				titleBar.addChild(titleBarChild);
			}

			creationQueue = [];
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			repositionHeaderElements();
		}
		/**
		 * Repositions the child elements of the header.
		 */
		protected function repositionHeaderElements():void
		{
			var uic:UIComponent;
			var tx:Number = 0; //target x value
			var px:Number = 0; //previous x value
			var ty:Number = 0; //target y value
			
			var headerHorizontalAlign:String = getStyle('headerHorizontalAlign');
			var headerVerticalAlign:String = getStyle('headerVerticalAlign');
			var headerHorizontalGap:Number = getStyle('headerHorizontalGap');
			
			if (titleTextField)
			{
				switch (headerVerticalAlign)
				{
					case "top":
					{
						ty = 5;
						break;
					}

					case "bottom":
					{
						ty = getHeaderHeight() - titleTextField.getExplicitOrMeasuredHeight();
						break;
					}

					case "middle":
					default:
					{
						ty = (getHeaderHeight() - titleTextField.getExplicitOrMeasuredHeight()) / 2;
						break;
					}
				}

				titleTextField.move(titleTextField.x, ty);
			}

			var i:int = 0;
			var l:int = titleBarAssets.length;
			if (l == 0)
				return;
			
			for (i; i < l; i++)
			{
				uic = UIComponent(titleBarAssets[i]);
				uic.setActualSize(uic.getExplicitOrMeasuredWidth(), uic.getExplicitOrMeasuredHeight());
				
				//set the target y value
				switch (headerVerticalAlign)
				{
					case "top":
					{
						ty = 5;
						break;
					}
					
					case "bottom":
					{
						ty = getHeaderHeight() - uic.getExplicitOrMeasuredHeight();
						break;
					}
					
					case "middle":
					default:
					{
						ty = (getHeaderHeight() - uic.getExplicitOrMeasuredHeight()) / 2;
						break;
					}
				}
				
				//set the target x value
				switch (headerHorizontalAlign)
				{
					case "left":
					{
						if (i == 0)
							tx = titleTextField.x + titleTextField.getExplicitOrMeasuredWidth() + headerHorizontalGap;
						
						else
							tx = px;
						
						px = tx + uic.getExplicitOrMeasuredWidth() + headerHorizontalGap;
						break;
					}
					
					case "right":
					default:
					{
						if (i == 0)
							tx = unscaledWidth - borderMetrics.right - uic.getExplicitOrMeasuredWidth() - 10;
						
						else
							tx = px - uic.getExplicitOrMeasuredWidth() - headerHorizontalGap;
						
						px = tx;							
						break;
					}
				}
				
				if (uic.x != tx || uic.y != ty)
					uic.move(tx, ty);
			}
		}
		
		////////////////////////////////////////////////////////////////////////
		//	HEADER HEIGHT
		////////////////////////////////////////////////////////////////////////

		/**
		 * A convenience method for retrieving the header height.
		 *
		 * @return The height of the header.
		 */
		[Bindable("headerHeightChanged")]
		/**
		 * 
		 * @return 
		 */
		public function get headerHeight ():Number
		{
			return getHeaderHeight();
		}

		/**
		 * @private
		 */
		public function set headerHeight (value:Number):void
		{
			setStyle("headerHeight", value);

			dispatchEvent(new Event("headerHeightChanged"));
		}
		

	}
}