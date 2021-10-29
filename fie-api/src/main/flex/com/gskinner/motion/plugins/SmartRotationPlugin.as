﻿/**
* SmartRotationPlugin by Grant Skinner. Nov 3, 2009
* Visit www.gskinner.com/blog for documentation, updates and more free code.
*
*
* Copyright (c) 2009 Grant Skinner
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/

package com.gskinner.motion.plugins {
	
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.IGTweenPlugin;
	
	/**
	* Plugin for GTween. Makes rotation tweens rotate in the shortest direction. For example, rotating
	* from 5 to 330 degrees would rotate -35 degrees with smart rotation, instead of +325 degrees.
	* <br/><br/>
	* Supports the following <code>pluginData</code> properties:<UL>
	* <LI> SmartRotationEnabled: overrides the enabled property for the plugin on a per tween basis.
	* </UL>
	**/
	public class SmartRotationPlugin implements IGTweenPlugin {
		
	// Static interface:
		/** Specifies whether this plugin is enabled for all tweens by default. **/
		public static var enabled:Boolean=true;
		
		/** @private **/
		protected static var instance:SmartRotationPlugin;
		/** @private **/
		protected static var tweenProperties:Array = ["rotation","rotationX","rotationY","rotationZ"];
		
		/**
		* Installs this plugin for use with all GTween instances.
		* 
		* @param properties Specifies the properties to apply this plugin to. Defaults to rotation, rotationX, rotationY, and rotationZ.
		**/
		public static function install(properties:Array=null):void {
			if (instance) { return; }
			instance = new SmartRotationPlugin();
			GTween.installPlugin(instance, properties || tweenProperties, true);
		}
		
	// Public methods:
		/** @private **/
		public function init(tween:GTween, name:String, value:Number):Number {
			return value;
		}
		
		/** @private **/
		public function tween(tween:GTween, name:String, value:Number, initValue:Number, rangeValue:Number, ratio:Number, end:Boolean):Number {
			if (!((enabled && tween.pluginData.SmartRotationEnabled == null) || tween.pluginData.SmartRotationEnabled)) { return value; }
			
			rangeValue %= 360;
			if (rangeValue > 180) { rangeValue -= 360; }
			else if (rangeValue < -180) { rangeValue += 360; }
			
			return initValue+rangeValue*ratio;
		}
		
	}
}