package com.flashiteasy.admin.components.filterComponents
{
	import com.flashiteasy.admin.components.filterComponents.panels.*;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.popUp.PopUp;
	import com.flashiteasy.api.parameters.FilterParameterSet;
	import com.flashiteasy.api.utils.StringUtils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientBevelFilter;
	import flash.filters.GradientGlowFilter;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.core.UIComponent;

	public class FilterPopUp extends PopUp
	{
		// Filter Panels
		private var filterPanel:IFilterPanel;
		// Filter factory
		private var filterFactory:IFilterFactory;

		private var currentFilters:Array=[];

		private var applyFilterBtn:Button;
		private var filterCombo:ComboBox=new ComboBox;
		private var filterFormContainer:Canvas=new Canvas;

		private var filterParam:FilterParameterSet;

		private var filterCodes:Array=[];
		private var filterTypes:Array=[];

		private var editFilter:*;
		private var editFilterIndex:int;

		public function FilterPopUp(filterParam:FilterParameterSet, editFilter:*=null, editFilterIndex:int=0, parent:DisplayObject=null, modal:Boolean=false, centered:Boolean=true, closeOnOk:Boolean=true)
		{
			super(parent, modal, centered, closeOnOk);

			this.filterParam=filterParam;
			
			var wrapper:HBox = new HBox;
			wrapper.setStyle("paddingTop",10);
			wrapper.setStyle("paddingLeft",10);
			wrapper.setStyle("paddingRight",10);
			addChild(wrapper);
			var filters:Array=["< "+Conf.languageManager.getLanguage("None")+" >", Conf.languageManager.getLanguage("Bevel"), Conf.languageManager.getLanguage("Blur"), Conf.languageManager.getLanguage("Color_Matrix"), Conf.languageManager.getLanguage("Convolution"), Conf.languageManager.getLanguage("Drop_Shadow"), Conf.languageManager.getLanguage("Glow"), Conf.languageManager.getLanguage("Gradient_Bevel"), Conf.languageManager.getLanguage("Gradient_Glow")];
			filterCombo.dataProvider=filters;
			filterCombo.addEventListener(Event.CHANGE, setFilter);
			wrapper.addChild(filterCombo);
			addChild(filterFormContainer);


			var bottomWrapper:HBox = new HBox;
			bottomWrapper.setStyle("paddingTop",10);
			bottomWrapper.setStyle("paddingLeft",10);
			bottomWrapper.setStyle("paddingRight",10);
			applyFilterBtn=new Button;
			applyFilterBtn.enabled=false;
			applyFilterBtn.label=Conf.languageManager.getLanguage("Validate");
			applyFilterBtn.addEventListener(MouseEvent.CLICK, applyFilter);

				this.editFilterIndex = editFilterIndex;
			if (editFilter != null)
			{
				filterCombo.enabled=false;
				initFilter(editFilter);
				initValues();
				createFilterPanel();

			}
			else
			{
				initValues();
				addChild(bottomWrapper)
				bottomWrapper.addChild(applyFilterBtn);
			}

			super.getWindow().width=400;
			super.getWindow().height=400;
			super.display();
		}



		private function initFilter(editFilter:*):void
		{
			if (editFilter == null)
			{
				return;
			}

			var clazz:Class=Class(getDefinitionByName(getQualifiedClassName(editFilter)));
			switch (clazz)
			{
				case BevelFilter:
					filterCombo.selectedItem=Conf.languageManager.getLanguage("Bevel");
					break;
				case BlurFilter:
					filterCombo.selectedItem=Conf.languageManager.getLanguage("Blur");
					break;
				case ColorMatrixFilter:
					filterCombo.selectedItem=Conf.languageManager.getLanguage("Color_Matrix");
					break;
				case ConvolutionFilter:
					filterCombo.selectedItem=Conf.languageManager.getLanguage("Convolution");
					break;
				case DropShadowFilter:
					filterCombo.selectedItem=Conf.languageManager.getLanguage("Drop_Shadow");
					break;
				case GlowFilter:
					filterCombo.selectedItem=Conf.languageManager.getLanguage("Glow");
					break;
				case GradientBevelFilter:
					filterCombo.selectedItem=Conf.languageManager.getLanguage("Gradient_Bevel");
					break;
				case GradientGlowFilter:
					filterCombo.selectedItem=Conf.languageManager.getLanguage("Gradient_Glow");
					break;
				default:
					trace("Error in filter Name");
					break;
			}
			this.editFilter=editFilter;
			//this.editFilterIndex=filterParam.getFilterIndex(editFilter);
			filterParam.removeFilter(editFilterIndex);
		}
		
		public function setFilterIndex(index:int): void
		{
			this.editFilterIndex=index;
		}

		private function initValues():void
		{
			if (filterParam.filterString != null && filterParam.filterString != "" && filterParam.filterString != "[]")
			{
				filterCodes=StringUtils.StringToArray(filterParam.filterString, "||");
				filterTypes=StringUtils.StringToArray(filterParam.types, ",");
			}
		}

		protected override function onClose():void
		{
			if (editFilter == null)
			{
				removeTemporaryFilter();
			}
		}

		private function setFilter(e:Event):void
		{
			createFilterPanel();
		}

		private var currentFilter:String="";

		private function createFilterPanel():void
		{
			if (currentFilter != filterCombo.selectedItem)
			{
				currentFilter=filterCombo.selectedItem as String;
				hideFilterForm();

				if (filterCombo.selectedIndex <= 0)
				{
					removeTemporaryFilter();
					return;
				}

				applyFilterBtn.enabled=true;

				switch (filterCombo.selectedItem)
				{
					case Conf.languageManager.getLanguage("Bevel"):
						filterPanel=new BevelPanel;
						break;
					case Conf.languageManager.getLanguage("Blur"):
						filterPanel=new BlurPanel;
						break;
					case Conf.languageManager.getLanguage("Color_Matrix"):
						filterPanel=new ColorMatrixPanel;
						break;
					case Conf.languageManager.getLanguage("Convolution"):
						filterPanel=new ConvolutionPanel;
						break;
					case Conf.languageManager.getLanguage("Drop_Shadow"):
						filterPanel=new DropShadowPanel;
						break;
					case Conf.languageManager.getLanguage("Glow"):
						filterPanel=new GlowPanel;
						break;
					case Conf.languageManager.getLanguage("Gradient_Bevel"):
						filterPanel=new GradientBevelPanel;
						break;
					case Conf.languageManager.getLanguage("Gradient_Glow"):
						filterPanel=new GradientGlowPanel;
						break;
					default:
						trace("Error in filter Name");
						break;
				}

				// if a filter is beeing edited , set panel values
				if (editFilter != null)
				{
					filterPanel.setValues(editFilter);
				}

				var panelDO:UIComponent;
				if ((panelDO=filterPanel as UIComponent) != null)
				{
					filterFormContainer.addChild(panelDO);
				}
				filterPanel.resetForm();
				setFactory(filterPanel.filterFactory);
			}
		}

		private function removeTemporaryFilter():void
		{
			setFactory(null);
			applyTemporaryFilter();
			applyFilterBtn.enabled=false;
		}

		private function setFactory(factory:IFilterFactory):void
		{
			if (filterFactory == factory)
			{
				return;
			}

			if (filterFactory != null)
			{
				filterFactory.removeEventListener(Event.CHANGE, filterChange);
			}

			filterFactory=factory;
			if (factory == null || filterParam == null)
			{
				return;
			}
			// apply the new filter
			filterFactory.addEventListener(Event.CHANGE, filterChange, false, 0, true);
			applyTemporaryFilter();
		}

		private function filterEdit(e:Event):void
		{
			applyTemporaryFilter();
		}

		private var filterString:String ;
		private function initFilterParam():void
		{
			var i:uint;
			filterString ="[";
			for (i=0; i < filterCodes.length; i++)
			{
				
				if (i > 0)
				{
					filterString+="||";
				}
				filterString+=filterCodes[i];
			}
			filterString += "]";
			var typeString:String="[";
			for (i=0; i < filterTypes.length; i++)
			{
				if (i > 0)
				{
					typeString+=",";
				}
				typeString+=filterTypes[i];
			}
			typeString+="]";
			filterParam.filterString=filterString;
			filterParam.types=typeString;
		}

		private function applyTemporaryFilter():void
		{

			if (filterFactory != null)
			{
				// Add the current filter to the set temporarily
				//filterCodes.push(filterFactory.getCode());
				//filterTypes.push(filterFactory.getType());
				filterCodes.splice(this.editFilterIndex, 0, filterFactory.getCode());
				filterTypes.splice(this.editFilterIndex, 0, filterFactory.getType());
				
			}
			initFilterParam();

			// Refresh the filter set of the filter target
			dispatchEvent(new Event(Event.CHANGE));

			if (filterFactory != null)
			{
				// Remove the current filter from the set
				// (This doesn't remove it from the filter target, since 
				// the target uses a copy of the filters array internally.)
				//filterCodes.pop();
				//filterTypes.pop();
				filterCodes.splice(this.editFilterIndex, 1);
				filterTypes.splice(this.editFilterIndex, 1);
			}
		}

		private function applyFilter(event:MouseEvent):void
		{
			if (filterFactory != null)
			{
				
				//filterCodes.push(filterFactory.getCode());
				//filterTypes.push(filterFactory.getType());
				filterCodes.splice(this.editFilterIndex, 0, filterFactory.getCode());
				filterTypes.splice(this.editFilterIndex, 0, filterFactory.getType());
				
				initFilterParam();
				//
				removeTemporaryFilter();
			}
			
			if (filterCombo.selectedIndex > 0)
			{
				filterPanel.resetForm();
			}
		}

		private function hideFilterForm():void
		{
			if (filterFormContainer.numChildren > 0)
			{
				filterFormContainer.removeChildAt(0);
			}
		}

		private function filterChange(event:Event):void
		{
			applyTemporaryFilter();
		}
	}
}