<?php
/*
 * Created on 1 juin 2010
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */

 
class FormManager
{

 	public function getFormInfos(FormDataTO &$transfer) 
 	{
 		
		$transfer->success = $this->sendDataByMail( $transfer );
		if ($transfer->success == false)
		{
			$transfer->code = 1;
			$transfer->message = "form could not be sent due to a network error";
		} else{
			$transfer->code = 0;
		}
 		return $transfer;		
	}
	
	public function sendDataByMail( FormDataTO &$transfer )
	{
		$phpFileUrl = $transfer->phpFilePath;
		$formItems = $transfer->formData;
		
		$curl_connection =  curl_init( $phpFileUrl );
		curl_setopt($curl_connection, CURLOPT_CONNECTTIMEOUT, 30);
    	curl_setopt($curl_connection, CURLOPT_USERAGENT, "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
    	curl_setopt($curl_connection, CURLOPT_RETURNTRANSFER, true);
    	curl_setopt($curl_connection, CURLOPT_SSL_VERIFYPEER, false);
    	curl_setopt($curl_connection, CURLOPT_FOLLOWLOCATION, 1);
	
		//echo "<form method='post' action='".$phpFileUrl."' >";
		foreach( $formItems as $key=>$v)
		{
			$post_items[] = $key. "=". $v;
			//echo "<input type='hidden' name='".$key."' value='".$v."'";
		}
		$post_string = implode ('&', $post_items);
		
		//echo "<input type='submit' name='submit'  />";
		//echo "</form>";
		curl_setopt($curl_connection, CURLOPT_POSTFIELDS, $post_string);

		$result = curl_exec($curl_connection);
		curl_close($curl_connection);
		return $result;
	}
} 
 
?>
