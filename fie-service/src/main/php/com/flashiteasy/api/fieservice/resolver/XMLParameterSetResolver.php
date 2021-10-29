<?php
class XMLParameterSetResolver implements IParameterSetResolver
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
		$params = explode("/",$param[1]);
		/*for ( $i=0; $i<count($params); $i++)
		{
			$index = substr($params[$i], -1);
			$trunc = substr($params[$i], 0,-1);
			$array[$i]= $trunc . "[" . $index . "]" ;
		}*/
		//return $params;
		return $param[1];
	}
	
	protected function getRequestedObject($xml, $arr)
	{
		//$str = "return \$xml->".implode("->",$arr).";";
//		//return $xml->title[1];
		//var_dump($str);
		//return eval($str);
		$value = $xml->xpath($arr);
		return $value[0];
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
	
	public function XML2Array ( $xml , $recursive = false )
	{
	    if ( ! $recursive )
	    {
	        $array = simplexml_load_string ( $xml ) ;
	    }
	    else
	    {
	        $array = $xml ;
	    }
	   
	    $newArray = array () ;
	    $array = ( array ) $array ;
	    foreach ( $array as $key => $value )
	    {
	        $value = ( array ) $value ;
	        if ( isset ( $value [ 0 ] ) )
	        {
	            $newArray [ $key ] = trim ( $value [ 0 ] ) ;
	        }
	        else
	        {
	            $newArray [ $key ] = $this->XML2Array ( $value , true ) ;
	        }
	    }
	    return $newArray ;
	}	
	
	protected function getRequestedParameter( $obj, $params )
	{
		//var_dump($this->getRecursiveValue( $obj, $params ) );
		return $this->getRecursiveValue( $obj, $params );
	}
	
	protected function getRecursiveValue( $obj , $params)
	{
		if ($obj[$params[0]] != null && count( $params) == 1)
		{
			return $obj[$params[0]];
		}
		else if ($obj[$params[0]] != null && count( $params) > 1)
		{
			//array_shift($params);
			return $this->getRecursiveValue( $obj[$params[0]], array_slice($params,1));
		}
		
	}
	
	public function resolve()
	{
		//$obj = $this->XML2Array( $this->content);
		$obj = simplexml_load_string($this->content);
		//var_dump($obj);
		//var_dump($obj->title);
		//return $obj->title;
		//return "resolve";
		//return $this->getRequestedParameter( $obj, $this->extractRequestedParameter( $this->param->request) );
		return (string) $this->getRequestedObject( $obj, $this->extractRequestedParameter( $this->param->request) );
	}
		
}

?>