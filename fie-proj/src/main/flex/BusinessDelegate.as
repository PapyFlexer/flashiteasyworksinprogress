package
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.fieservice.AbstractBusinessDelegate;

	public class BusinessDelegate extends AbstractBusinessDelegate
	{
		public function BusinessDelegate()
		{
			super();
		}
		
		override protected function getServiceUrl() : String
		{
				return AbstractBootstrap.getInstance().getProject().getParameter( AbstractBootstrap.AMF_ENDPOINT );
				//return "";
		}
		
	}
}