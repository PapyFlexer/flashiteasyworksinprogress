package com.flashiteasy.api.parameters.test {
	
	import asunit.framework.TestSuite;

	public class TestParameters extends TestSuite
	{
		public function TestParameters()
		{
			
			super();
			addTest(new TestAlign("testInstantiated"));
   	 		addTest(new TestAlign("testSetAlign"));
			
		}
		
	}
}