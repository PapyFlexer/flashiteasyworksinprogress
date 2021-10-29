package com.flashiteasy.test {
	import flash.display.Sprite;

	import com.flashiteasy.api.controls.SoundElementDescriptor;

	import asunit.framework.TestCase;
	
	/**
	 * @author hanne
	 */
	public class TestSoundElementDescriptor extends TestCase {
		
		private var s:SoundElementDescriptor;
		
		public function TestSoundElementDescriptor(testMethod : String = null) {
			super(testMethod);
		}
		override protected function setUp():void{
			s=new SoundElementDescriptor();
			s.createControl();
		}
		public function testInstantiated():void {
   			assertFalse("son initialisée ", s==null);
   		}
   		public function testSound():void{
   			
   		}
   		
		override protected function tearDown():void{
			super.tearDown();
			s.destroy();
		}
	}
}
