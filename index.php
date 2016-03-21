<?php
require("./php/functions.php");
if (!$_COOKIE['_crowdQ']) {
	# create new user
	$hex = substr(md5(rand()), 0, 8);
	$sttmt = $dbh->prepare("INSERT INTO `crowdquest`.`users` (`hex`) VALUES (?)");
	$sttmt->execute(array($hex));
	$num = $dbh->lastInsertId();
	$crumb = $hex.'-'.$num;
	setcookie("_crowdQ", $crumb,time()+(86400*3));
} else {
	# advance expiration date by three days
	setcookie("_crowdQ", $_COOKIE['_crowdQ'],time()+(86400*3));
}
header("Content-type:text/html");
head();	
home(); 
foot();
?>