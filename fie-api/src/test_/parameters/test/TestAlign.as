package com.flashiteasy.api.parameters.test
{
	import  asunit.framework.TestCase;
	
	import com.flashiteasy.api.parameters.AlignParameterSet;

	public class TestAlign extends TestCase
	{
		private var align:AlignParameterSet;
		
		public function TestAlign(testMethod:String=null)
		{
			super(testMethod);
		}
		
		protected override function setUp():void{
			align = new AlignParameterSet();
		}
		
		protected override function tearDown():void{
			align=null;
		}
		
		public function testInstantiated():void {
   			assertTrue("Alignement initialisé ", align is AlignParameterSet);
   		}


  		public function testSetAlign():void {
   			align.h_align="top";
   			assertTrue("h_align = top", align.h_align == "top");
   			align.v_align="left";
   			assertTrue("v_align = left", align.v_align == "left");
   			
   		}
  		

		
	}
}