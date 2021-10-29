<?php
class JSONParameterSetResolver implements IParameterSetResolver
{
	
	private $param;
	private $content;
	
	public function setParameterSet( RemoteParameterSet $param )
	{
		$this->param = $param;
		//var_dump($this->param);
		$content = file_get_contents( $this->param->source );	
		//var_dump( $content );
		if ($content != -1 )
		{
			$content =" error";
			die();
		}
	}
	protected function extractRequestedParameter( $source, $request )
	{
		$arr = explode("::",$request);
		$jsonreq = $arr[1];
		//var_dump($arr);
		//$jsonreq = 'address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=false';
		if (isset($jsonreq))
		{
			$path = $source . $jsonreq;
			$array = json_decode(file_get_contents($path),true);
			//$array = json_decode(file_get_contents('http://maps.google.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=false'), true);
		}
		//var_dump($path);
		return $array;
	}
	
		
	public function resolve()
	{
		/*echo "resolving... ";
		var_dump($this->param);
		$converter = new ConvertUtils();
		$result = $this->extractRequestedParameter( $param->source, $param->request );
//		return $converter->convertArrayToXML($result );*/
		return "<coucou>hello fie xml from json</coucou>";
	}
		
}

?>