package com.flashiteasy.test {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Timer;

	import com.flashiteasy.api.parameters.SizeParameterSet;
	import flash.display.Sprite;

	import com.flashiteasy.api.controls.TextElementDescriptor;
	import com.flashiteasy.api.container.BlockElementDescriptor;

	import asunit.framework.TestCase;
	
	/**
	 * @author hanne
	 */
	public class TestPadding extends TestCase {
		
		private var b:BlockElementDescriptor;
		private var tf:TextElementDescriptor=new TextElementDescriptor();
		private var tf2:TextElementDescriptor=new TextElementDescriptor();
		private var tf3:TextElementDescriptor=new TextElementDescriptor();
		
		public function TestPadding(testMethod : String = null) {
			super(testMethod);
		}
		protected override function setUp():void{
			b=new BlockElementDescriptor();
			b.createControl(null,true );
			b.uuid="paddingblockTest";
			b.setPadding(10 , 10, 10, 10);
			b.setActualSize("500","500");
			b.setResizeBehavior(true,true,true,true);
			b.applyParameters();
		}
		
		public function testlayoutElements():void {
   			
			tf.createControl();
			tf.uuid="textpaddingtest";
			tf.setActualSize(""+100,""+100);
			tf.setPosition("0", "0");
			
			tf2.createControl();
			tf2.uuid="textpaddingtest2";
			tf2.setActualSize(""+100,""+100);
			tf2.setPosition("400", "400");
			

			tf3.createControl();
			tf3.uuid="textpaddingtest3";
			tf3.setActualSize(""+400,""+400);
			tf3.setPosition("400", "400");
			tf.applyParameters();
			tf2.applyParameters();
			tf3.applyParameters();
			
			tf.getFace().addEventListener("lol", testchangeHandler);
			tf2.getFace().addEventListener("lol", testchangeHandler);
			tf3.getFace().addEventListener("lol", testchangeHandler);
			b.layoutElement(tf);
			//var	_timer:Timer = new Timer(3000, 0);
			//_timer.start();

			assertTrue("contains " , b.getFace().contains(tf.getFace()));
   			assertTrue("contains b",fie_test.GLOBAL_STAGE.contains(b.getFace()));
			b.layoutElement(tf2);

   			b.layoutElement(tf3);
   			
   		}
   		protected function testchangeHandler(e:Event):void {
   			try{
			if(e.target == tf.getFace()){
    		assertTrue("padding left ", e.target.x==10);
   			assertTrue("padding top", e.target.y==10);
			}
			if(e.target == tf2.getFace()){
   			assertTrue("padding right", tf2.getFace().x==390);
   			assertTrue("padding bottom", tf2.getFace().y==390);
			}
			if(e.target == tf3.getFace()){
   			assertTrue("resize right "+b.getFace().width , b.getFace().width==810);
   			assertTrue("resize bottom" +b.getFace().height, b.getFace().height==810);
			}
   			}
   			catch(err:Error) {
 				 fail("testSetData failed: "+err.message);
			}
		}
		override protected function tearDown():void{
			super.tearDown();
			b.destroy();
		}
	}
}


