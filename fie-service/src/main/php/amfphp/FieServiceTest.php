<?php
/*
 * Created on 7 avr. 10
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */
 include("globals.php");
 
 phpinfo();
 $service = new FieService();
 echo $service->helloFie();
 
 echo "<hr>";
 
 $transfer = new RemoteParameterListTO();
 $remoteparam = new RemoteParameterSet();
// 
$remoteparam->request = "fie://JSON::address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=false";
$remoteparam->source = "http://maps.google.com/maps/api/geocode/json?";
//$remoteparam->request = "fie://XMLList::channel/item#2/4";
//$remoteparam->source = "http://www.france24.com/fr/monde/rss&language=fr";
//$remoteparam->request = "fie://XML::channel0/item1/title0";
//$remoteparam->source = "http://localhost:8888/target/fie-projects/fie-app/config/articles2.xml";
 
 $transfer->remoteParameterList = Array($remoteparam); 

//$url = 'http://api.geonames.org/weatherJSON?north=44.1&south=-9.9&east=-22.4&west=55.2&username=demo';
//$url='http://www.flickr.com/services/feeds/photos_public.gne?tags=punctuation,atsign&format=json';
//$json2= json_decode(file_get_contents("http://maps.google.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=false"));
//$json = file_get_contents($url);
//var_dump($json);

$array = json_decode(file_get_contents('http://maps.google.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=false'), true);
$converter = new ConvertUtils();
$file = file_get_contents('http://maps.google.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=false');
$result = $converter->convertJsonToXML($file);

//echo $result;
//echo '<pre>';
//var_dump($result);
var_dump($service->getRemoteParameterList(  $transfer ) );
//echo '</pre>';
?>


