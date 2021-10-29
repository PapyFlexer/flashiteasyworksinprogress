package com.flashiteasy.admin.utils
{
	import flash.text.TextField;
	
	public class TextUtils
	{


		//mixed $search  , mixed $replace  , mixed $subject  [, int &$count  ] )
		/**
		 * str_replace - mimicks the functionality of the PHP str_replace method
		 * 
		 * http://sg2.php.net/manual/en/function.str-replace.php
		 * 
		 * @param search - a String/Array
		 * @param replace - 
		 * @param subject - string that will be subjected to the search and replace.
		 * 
		 * @return String with the replacements done.
		 * 
		 */ 
		public static function str_replace(search:Object, replace:Object, subject:String):String
		{
			// if search criteria is an Array, make sure replace element has 
			// sufficient elements to swap
			if(search is Array)
			{
				var i:int; 
				if(replace is Array)
				{
					if(replace.length < search.length)
					{
						for(i = replace.length; i < search.length; i++)
						{
							replace[i] = "";
						}
					}
				}
				else if (replace is String)
				{
					var replaceStr:String = String(replace);
					replace = [];
					for(i = 0; i < search.length; i ++)
					{
						replace[i] = replaceStr;
					}
				}
				// do the actual replace
				for(i = 0; i < search.length; i++)
				{
					subject = subject.split(search[i]).join(replace[i]);
				}
				return subject;
			}
			else if (search is String)// search criteria is a string.
			{
				if(!(replace is String))
					replace = replace.toString();
			}
			
			else // everything else will be forced to become a string
			{
				search = search.toString();
				replace = replace.toString();
			}
			return subject.split(search).join(replace);
		}
	}
}