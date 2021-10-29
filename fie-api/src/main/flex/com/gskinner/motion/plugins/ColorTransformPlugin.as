﻿/**
* ColorTransformPlugin by Grant Skinner. Nov 3, 2009
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
	import flash.geom.ColorTransform;
	
	/**
	* Plugin for GTween. Applies a color transform or tint to the target based on the
	* "redMultiplier", "greenMultiplier", "blueMultiplier", "alphaMultiplier", "redOffset",
	* "greenOffset", "blueOffset", "alphaOffset", and/or "tint" tween values. The tint
	* value is a 32 bit color, where the alpha channel represents the strength of the tint.
	* For example 0x8000FF00 would apply a green tint at 50% (0x80) strength.
	* <br/><br/>
	* Supports the following <code>pluginData</code> properties:<UL>
	* <LI> ColorTransformEnabled: overrides the enabled property for the plugin on a per tween basis.
	* </UL>
	**/
	public class ColorTransformPlugin {
		
	// Static interface:
		/** Specifies whether this plugin is enabled for all tweens by default. **/
		public static var enabled:Boolean=true;
		
		/** @private **/
		protected static var installed:Boolean = false;
		/** @private **/
		protected static var tweenProperties:Array = ["redMultiplier","greenMultiplier","blueMultiplier","alphaMultiplier","redOffset","greenOffset","blueOffset","alphaOffset","tint"];
		
		/**
		* Installs this plugin for use with all GTween instances.
		**/
		public static function install():void {
			if (installed) { return; }
			installed = true;
			GTween.installPlugin(ColorTransformPlugin,tweenProperties,true);
		}
		
	// Public methods:
		/** @private **/
		public static function init(tween:GTween, name:String, value:Number):Number {
			if (!((enabled && tween.pluginData.ColorTransformEnabled == null) || tween.pluginData.ColorTransformEnabled)) { return value; }
			
			if (name == "tint") {
				// try to calculate initial tint:
				var ct:ColorTransform = tween.target.transform.colorTransform;
				var a:uint = Math.min(1,1-ct.redMultiplier);
				var r:uint = Math.min(0xFF,ct.redOffset*a);
				var g:uint = Math.min(0xFF,ct.greenOffset*a);
				var b:uint = Math.min(0xFF,ct.blueOffset*a);
				var tint:uint = a*0xFF<<24 | r<<16 | g<<8 | b;
				return tint;
			} else {
				return tween.target.transform.colorTransform[name];
			}
		}
		
		/** @private **/
		public static function tween(tween:GTween, name:String, value:Number, initValue:Number, rangeValue:Number, ratio:Number, end:Boolean):Number {
			if (!((tween.pluginData.ColorTransformEnabled == null && enabled) || tween.pluginData.ColorTransformEnabled)) { return value; }
			
			var ct:ColorTransform = tween.target.transform.colorTransform;
			if (name == "tint") {
				var aA:uint = initValue>>24&0xFF;
				var rA:uint = initValue>>16&0xFF;
				var gA:uint = initValue>>8&0xFF;
				var bA:uint = initValue&0xFF;
				var tint:uint = initValue+rangeValue>>0;
				var a:uint = aA+ratio*((tint>>24&0xFF)-aA);
				var r:uint = rA+ratio*((tint>>16&0xFF)-rA);
				var g:uint = gA+ratio*((tint>>8&0xFF)-gA);
				var b:uint = bA+ratio*((tint&0xFF)-bA);
				var mult:Number = 1-a/0xFF;
				tween.target.transform.colorTransform = new ColorTransform(mult,mult,mult,ct.alphaMultiplier,r,g,b,ct.alphaOffset);
			} else {
				ct[name] = value;
				tween.target.transform.colorTransform = ct;
			}
			
			// tell GTween not to use the default assignment behaviour:
			return NaN;
		}
		
	}
	
}