package com.flashiteasy.admin.components.validators
{
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.api.assets.StyleList;
	
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class StyleNameValidator extends Validator
	{
		
		public function StyleNameValidator()
		{
			super();
		}
		
		override protected function doValidation(value:Object):Array 
		{
			var ValidatorResults:Array = new Array();
			// Call base class doValidation().
	        ValidatorResults = super.doValidation(value);       
	        // Return if there are errors.
	        if (ValidatorResults.length > 0)
	            return ValidatorResults;
	 
	        if (String(value).length == 0)
	            return ValidatorResults;
	            
	        if(!StyleList.getInstance().checkName(String(value)))
	        {
	        	ValidatorResults.push(new ValidationResult(true, null, Conf.languageManager.getLanguage("style_name_already_used") ))
	        	return ValidatorResults;
	        }
	        else
	        {
	        	return ValidatorResults;
	        }
			

	    }
	}
}