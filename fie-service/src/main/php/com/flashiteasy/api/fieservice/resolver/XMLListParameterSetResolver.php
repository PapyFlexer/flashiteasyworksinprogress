<?php
class XMLListParameterSetResolver implements IParameterSetResolver
{
	
	private $param;
	private $content;
	
	public function setParameterSet( RemoteParameterSet $param )
	{
		$this->param = $param;
		$content = $this->readFileContent( $param->source );	
		if ($content != -1 )
		{
			$content =" error";
		}
	}
	
	protected function extractRequestedParameter( $request )
	{
		$param = explode("::",$request);
		$params = $param[1];
		return $params;
	}
	
	
	protected function readFileContent( $source )
	{
		$this->content = file_get_contents( $source );
		if ($this->content !== false) {
		   return $this->content;
		} else {
		   return -1;
		}
	}
	
	protected function getRequestedParameter( $obj, $params )
	{
		//return $this->getRecursiveValue( $obj, $params );
		return $this->getRequestedObject( simplexml_load_string($obj), $params );
	}
	
	protected function getRecursiveValue( $obj , $params)
	{
		$xmlObject = simplexml_load_string( $obj );
		//$xmlObject = "qsdqsdq";
		//$converter = new ObjectAndXML();
		//var_dump($xmlObject);
		return $obj;
		//$xmlObject->test = "youhouu";
		//return $xmlObject;
	}
	
	protected function getRequestedObject($xml, $xpathStr)
	{
		$xmlObj = simplexml_load_string($xml);
		$xmlReturn = $xmlObj;
		$ns = $xmlObj->getNamespaces(true);
		
		if (strpos($xpathStr,"#") !== FALSE)
		{
			$tmp = explode("#", $xpathStr);
			$req = $tmp[0];
			$nums = explode("/", $tmp[1]);
			if(isset($nums[0]))
			{
				$from = $nums[0];
				$xpathStr = $req . "[position()>". $from;
				if(isset($nums[1]))
				{
					$qty = $from+$nums[1]+1;
					$xpathStr = $xpathStr." and position()<". $qty;
				}
				$xpathStr = $xpathStr."]";
			}
		}
		
		$temp = $xmlObj->xpath($xpathStr);
		
		$dom = new DOMDocument();
		$count = count($temp);
		for ($i = 0; $i < $count; $i++) {
			$domnode = dom_import_simplexml($temp[$i]);
			$domnode = $dom->importNode($domnode, true);
			$domnode = $dom->appendChild($domnode);
		}
		return $dom->saveXML();
	}
	public function resolve()
	{
		$obj = $this->content;
//		$res = $this->getRequestedParameter( $obj, $this->extractRequestedParameter( $this->param->request) );
		$res = $this->getRequestedObject( $obj, $this->extractRequestedParameter( $this->param->request) );
		//var_dump($res);
		return $res;
	}
		
}

?>