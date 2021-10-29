package com.flashiteasy.test {
	import com.flashiteasy.api.controls.VideoElementDescriptor;
	import com.flashiteasy.api.controls.TextElementDescriptor;
	import flash.display.Sprite;

	import com.flashiteasy.api.container.BlockElementDescriptor;
	import asunit.framework.TestCase;

	/**
	 * @author hanne
	 */
	public class TestBlockElementDescriptor extends TestCase {
		
		private var b:BlockElementDescriptor;
		
		public function TestBlockElementDescriptor(testMethod : String = null) {
			super(testMethod);
		}
		
		protected override function setUp():void{
			b=new BlockElementDescriptor();
			b.createControl();
			b.uuid="blockTest";
		}
		
		public function testInstantiated():void {
   			assertTrue("block initialisée ", b.getFace() is Sprite);
   		}
   		
   		public function testlayoutElements():void {
   			var tf:TextElementDescriptor=new TextElementDescriptor();
			tf.createControl();
			tf.uuid="texttest";
			b.layoutElement(tf);
   			assertTrue("texte initialisée ", tf.getFace() is Sprite);
   			assertTrue("1 child apres ajout", b.length()==1);
   			assertFalse("block wait child" ,b.getFace().contains(tf.getFace()));
   			b.deleteChild(tf);
   			assertTrue("texte retiré mais pas detruit", tf.getFace() is Sprite);
   			assertTrue("aucun child apres suppression", b.length()==0);
   			
   			//===================
   			
   			b.layoutElement(tf);
   			assertTrue("texte initialisée ", tf.getFace() is Sprite);
   			b.applyParameters();
   			assertTrue("texte apply", tf.isLoaded());
   			assertFalse("child cree mais pas ajoute", b.length()==2);
   			assertTrue("texte ajoute apres apply" ,b.getFace().contains(tf.getFace()));
   			assertTrue("ajout child et apply", b.length()==1);
   			
   			//===================
   			
   			var tf2:TextElementDescriptor=new TextElementDescriptor();
   			tf2.createControl(null,true,false);
   			tf2.applyParameters();
   			b.layoutElement(tf2);
   			assertTrue("2 child apres ajout", b.length()==2);
   			assertTrue("texte en auto display" ,b.getFace().contains(tf2.getFace()));
   			
   			//assertTrue("texte en auto display" ,b.getFace().contains(tf.getFace()));
   			
   			
   			b.deleteChildren();
   			assertFalse("texte retiré et detruit", tf.getFace() is Sprite);
   			assertTrue("aucun child apres suppression", b.length()==0);
   			
   		}
   		
		public function testMultiplelayout():void {
			
			var b2:BlockElementDescriptor=new BlockElementDescriptor();
			b2.createControl(b);
			b2.uuid="testBlock2";
			assertTrue("1 child apres ajout", b.length()==1);
			assertTrue("block initialisée ", b2.getFace() is Sprite);
			var v:VideoElementDescriptor= new VideoElementDescriptor();
			v.createControl(b2);
			b.applyParameters();
			assertTrue("video ajouté",b2.length()==1);
			assertTrue("bloc non modifie",b.length()==1);
			assertTrue("video charge ", v.isLoaded());
			assertTrue("block initialisée ", b2.getFace() is Sprite);
			b2.destroy();
			assertTrue("sous bloc supprime",b.length()==0);
			
		}
		override protected function tearDown():void{
			super.tearDown();
			b.destroy();
		}
		
	}
}


