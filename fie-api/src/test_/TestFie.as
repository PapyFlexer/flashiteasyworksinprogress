package com.flashiteasy.test {
	import asunit.textui.TestRunner;
	
	/**
	 * @author hanne
	 */
	public class TestFie extends TestRunner {
		public function TestFie() {
			super();
			start(AllTest, null, TestRunner.SHOW_TRACE);
		}
	}
}
