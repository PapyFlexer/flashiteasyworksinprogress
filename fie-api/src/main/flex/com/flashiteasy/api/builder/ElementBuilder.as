/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.builder
{
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.ioc.ClassResolver;
	import com.flashiteasy.api.ioc.IocContainer;

	/**
	 * 
	 * The <code><strong>ElementBuilder</strong></code> class is a factory-like class 
	 * that manages the instanciation of FIE visual and non-visual controls.
	 * It specifically builds fie components, actions and animations.
	 * To do this, ElementBuilder makes extensive use of the ClassResolver class
	 * used by IoC pattern.
	 * 
	 * @see	com.flashiteasy.api.ioc.ClassResolver;
	 */
	public class ElementBuilder
	{
		/**
		 * Empty constructor
		 */
		public function ElementBuilder()
		{
		}

		/**
		 * Separates normal controls from container-based ones then creates them.
		 * 
		 * @param page : the page in which the component is created
		 * @param type : the class name of the component
		 * @param id : the unique id of the component
		 * @param name : the name used on stage for the component (generally used for targetting purposes)
		 * @param parent : the parent container of the element. Top-level container is AbstractBootstrap
		 * @return : the control correctly instanciated with  all its parameters injected at run-time.
		 * 
		 * 
		 * 
		 */
		public function createElement(page:Page, type:String, id:String, name:String, parent:IUIElementContainer=null):IUIElementDescriptor
		{
			var c:Class;
			var p:IParameterSet;
			var params:Array;
			var paramSet:CompositeParameterSet;
            
			if (type == "container")
			{
				c=ClassResolver.resolve(name, ClassResolver.CONTAINER_PACKAGE);
			}
			else
			{
				c=ClassResolver.resolve(name, ClassResolver.CONTROLS_PACKAGE);
			}

			var control:IUIElementDescriptor=new c();
			control.uuid=id;

			// Ajout du control a son parent

			if (parent == null)
				IUIElementDescriptor(control).createControl(page, null, true);
			else
				IUIElementDescriptor(control).createControl(page, parent, true);

			// Recuperation de la liste des parametres du bloc
			//type=getDefinitionByName(getQualifiedClassName(control))as Class;
			params=IocContainer.getInstances(c, IocContainer.GROUP_PARAMETERS);
			paramSet=new CompositeParameterSet();
			// Liste des parametres a injecter dans le bloc

			for (var i:int=0; i < params.length; i++)
				// Pour chaque parametre du bloc 
			{
				p=params[i];
				paramSet.addParameterSet(p);
			}

			// Ajout des parametres dans le control 

			control.setParameterSet(paramSet);
			control.applyParameters();
			return control;
		}
		
		/**
		 * Creates an Action
		 * @param page : the page in which the action is created
		 * @param type : the class name of the action
		 * @param id : the unique id of the action
		 * @return : the action correctly instanciated with all its parameters injected at run-time.
		 * 
		 */
		public function createAction(page:Page, type:String, name:String, id:String):IAction
		{
			var clazz:Class = ClassResolver.resolve(name, ClassResolver.ACTION_PACKAGE);
			var params:Array;
			var p:IParameterSet;
			var paramSet:CompositeParameterSet;
			
			var action:IAction= new clazz();
			action.uuid=id;
			IAction(action).createAction(page);
			params=IocContainer.getInstances(clazz, IocContainer.GROUP_PARAMETERS);
			paramSet=new CompositeParameterSet();
            for (var i:int=0; i < params.length; i++)
            {
                p=params[i];
                paramSet.addParameterSet(p);
            }
			action.setParameterSet(paramSet);
			return action;
		}
		
		/**
		 * Creates a story
		 * @param page : the page in which the animation is created
		 * @param type : the class name of the animation
		 * @param id : the unique id of the animation
		 * @return : the animation correctly instanciated with  all its parameters injected at run-time.
		 * 
		 */
		public function createStory(page:Page, type:String, name:String, id:String):Story
		{
			/*
			var clazz:Class = ClassResolver.resolve(name, ClassResolver.ANIMATION_PACKAGE);
			var params:Array;
			var p:IParameterSet;
			var paramSet:CompositeParameterSet;
			trace ("ElementBuilder tries to creates Story :: " + name);
			var animation:IStory= new clazz();
			animation.uuid=id;
			IStory(animation).createStory(page);
			params=IocContainer.getInstances(clazz, IocContainer.GROUP_PARAMETERS);
			paramSet=new CompositeParameterSet();
            for (var i:int=0; i < params.length; i++)
            {
                p=params[i];
                paramSet.addParameterSet(p);
            }
			animation.setParameterSet(paramSet);
			return animation;*/
			
			var s:Story = new Story();
			s.createStory(page);
			return s;
		}
	}
}