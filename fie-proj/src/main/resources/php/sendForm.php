<?php
	// recup destinataire
	$to = $_POST['mailToUrl'];
	//recup expediteur
	if ($_POST['mailExp']){
		$from = $_POST['mailExp'];
	} else {
		$from = "Soumission formulaire Flash'Iteasy";
	}
	//recup sujet
	if ($_POST['mailSubject']){
		$subject = $_POST['mailSubject'];
	} else {
		$subject = "Soumission formulaire Flash'Iteasy - " . $_SERVER['HTTP_HOST'];
	}
	
	// decompilation $toSend
	$message  = "";
	$message .= "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0 Transitional//EN'>";
	$message .= "<HTML><HEAD><META http-equiv=Content-Type content='text/html; charset=us-ascii'></HEAD>";
	$message .= "<BODY>";
	$message .= "<DIV align='left' width='400px'>";
	$separator = "";
	foreach ($_POST as $k=>$v) {
		if ($k != 'mailToUrl' && $k !='mailExp' && $k != 'mailSubject') {
			$message .= "<BR>";
			$a = utf8_decode($v);
			$key = $k;
			$val = stripslashes($a);
			$message .= $separator . "<P width='300px' style='background: grey; padding: 5; color: black;'>" . $key . "</P><p width='300px' style='border:#CC0000; border:inset; font-size:14px;'>" . $val . "</P>";

			$separator = "<BR><BR>";
		}
	}
	$message .= "</DIV>";
	$message .= "</BODY>";
	$message .= "</HTML>";
	// formation headers du mail
	//////ici on determine le mail en format text
	$headers = "Content-type: text/html; charset=utf-8\r\n";
	$headers .= "From : mailer@flashiteasy.com";
 
////ici on determine l'expediteur et l'adresse de reponse

	$headers .= "\r\nReply-To: " . $to;
	$headers .= "\r\nBcc: gr@flashiteasy.com\r\n";
	$headers .= "X-Mailer:PHP";
// envoi du mail
	$sentOk = mail($to,$subject,$message,$headers);
	// retour vers Flash
	echo "&retour=" . $sentOk . "&";
	//$retour["status"] = $sentOk;
	//$retour["message"] = $sentOk ? "ok" : "notOk";
	//echo "&retour=" . $to . "\n" . $from . "\n" . $subject . "\n" . $message;
	//print $retour;
?>
