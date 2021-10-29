<?php 
interface IParameterSetResolver
{

	public function setParameterSet( RemoteParameterSet $param );
	public function resolve();

}
?>