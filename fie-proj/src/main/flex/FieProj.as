package
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.motion.TimerStoryboardPlayerImpl;
	
	[SWF(width="1360", height="768", frameRate="30", backgroundColor="#FFFFFF" , scale="default" , allowFullScreen="true") ]
	public class FieProj extends AbstractBootstrap
	{
		public function FieProj()
		{
			isProjectorApp = true;
			super();
			// Setting the storyboard player.
			setTimerStoryboardPlayer( new TimerStoryboardPlayerImpl() );
		}
		
		override protected function get businessDelegate() : Class
		{
			// need to be override
			return BusinessDelegate;
		}

	}
}