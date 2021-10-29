package
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.motion.TimerStoryboardPlayerImpl;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	[SWF(width="1200", height="700", frameRate="30", backgroundColor="#FFFFFF" , scale="noscale" , allowFullScreen="true") ]
	public class FieApp extends AbstractBootstrap
	{
		public function FieApp()
		{
			
			super();
			//Uncomment this line to make banners type project with the hard coded url of your project
			//this.setBaseUrl("http://localhost:8888/target/fie-projects/test");
			
			// Setting the "runtime" storyboard player.
			setTimerStoryboardPlayer( new TimerStoryboardPlayerImpl() );
			
		}
		
		override protected function get businessDelegate() : Class
		{
			// need to be override
			return BusinessDelegate;
		}

	}
}