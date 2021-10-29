package com.flashiteasy.test {
	import com.flashiteasy.test.TestRectangleElementDescriptor;
	import com.flashiteasy.test.TestImageElementDescriptor;

	import asunit.framework.TestSuite;
	
	/**
	 * @author hanne
	 */
	public class AllTest extends TestSuite {
		public function AllTest() {
			super();
			
			// Test Rectangle
			
			addTest(new TestRectangleElementDescriptor());
			
			// Test Image
			
			/*addTest(new TestImageElementDescriptor("testInstantiated"));
			addTest(new TestImageElementDescriptor("testSize"));
			addTest(new TestImageElementDescriptor("testImage"));*/
			
			addTest(new TestImageElementDescriptor());
			
			// Test Video
			
			/*addTest(new TestVideoElementDescriptor("testInstantiated"));
			addTest(new TestVideoElementDescriptor("testSize"));
			addTest(new TestVideoElementDescriptor("testVideo"));*/
			addTest(new TestVideoElementDescriptor());
			
			// Test Texte
			
			/*addTest(new TestTextElementDescriptor("testInstantiated"));
			addTest(new TestTextElementDescriptor("testSize"));
			addTest(new TestTextElementDescriptor("testText"));*/
			addTest(new TestTextElementDescriptor());
			
			// Test Sound
			
			// Test block
			
			addTest(new TestBlockElementDescriptor());
			
			addTest(new TestListElementDescriptor());
			addTest(new TestPadding());
			
		}
	}
}
