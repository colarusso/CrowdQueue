<?php

$dbh = new PDO("mysql:host=[host];dbname=[database]", "[user]", "[password]");

$cookie = $_COOKIE['_crowdQ'];
$userinfo = preg_split("/-/", $cookie);
$valid_user = 0;
$stmt = $dbh->prepare("select count(*) from users where hex=? AND id=?");
$stmt->execute(array($userinfo[0],$userinfo[1]));
$count = $stmt->fetchColumn();
if ($count == 1) {
	$valid_user = 1; 
}

function checkedin ($s_id,$u_id) {
	global $dbh;
	$stmtt = $dbh->prepare("select count(*) from session_user where session=? AND user=?");
	$stmtt->execute(array($s_id,$u_id));
	$c = $stmtt->fetchColumn();
	return $c;
}

function head () {
	include(dirname(__FILE__) . "../../html/header.html");
}
function home() { 
	include(dirname(__FILE__) . "../../html/body.html");
}
function foot () {
	include(dirname(__FILE__) . "../../html/footer.html");
}

function choose() {
	global $valid_user;
	global $dbh;
	global $userinfo; 
	if ($valid_user == 1) {
		$stmt = $dbh->prepare("select code, title, author, status from session_user join sessions on sessions.id = session_user.session where user=? and sessions.created >= (NOW() - INTERVAL 90 DAY) order by sessions.created DESC");
		$stmt->execute(array($userinfo[1]));
		$session = array();
		echo "<sessions error=\"0\" msg=\"\">\n";
		while ($row = $stmt->fetch (PDO::FETCH_OBJ)) {
			if ($userinfo[1] == $row->author) { $auth = "1"; } else { $auth = "0"; }
			echo "<session code=\"".$row->code."\" author=\"".$auth."\" status=\"".$row->status."\">".$row->title."</session>\n";
		}
		echo "</sessions>";
	} else {
		echo "<session error=\"1\" msg=\"Login Error\">".$valid_user."</session>";		
	}
}

function make() { 
	global $valid_user;
	global $dbh;
	global $userinfo;
 	if ($valid_user == 1) {
		$status = "-1";
		$num = "";
		$title;
		if (!$_GET['code'] and $_GET['type'] and $_GET['length'] and $_GET['max']) {
			$code = substr(md5(rand()), 0, 8);
			$title = urldecode ($_GET['title']);
			if ($title == "") { 
				$title = "Untitled"; 
			} else {
				$title = preg_replace('/[^a-z\s0-9]/i','',$title);
			}
			$type = preg_replace('/[^a-z]/i','',$_GET['type']);
			$length = preg_replace('/[^0-9]/i','',$_GET['length']);
			if ($length > 5) { $length = 5; }
			$max = preg_replace('/[^0-9]/i','',$_GET['max']);
			if ($max > 10) { $max = 10; }
			$stmt = $dbh->prepare("INSERT INTO `sessions` (`author`,`status`,`title`,`type`,`length`,`maxpp` ,`created`) VALUES (?,  '0',  ?,  ?,  ?,  ?, NOW())");
			$stmt->execute(array($userinfo[1],$title,$type,$length,$max));	
			$sessionID = $dbh->lastInsertId();
			$num = dechex(microtime($get_as_float=true)-1000000000 + $sessionID);
			$stm = $dbh->prepare("UPDATE `sessions` SET `code`=? WHERE `id`=?");
			$stm->execute(array($num,$sessionID));	
			$stmx = $dbh->prepare("INSERT INTO `session_user` (`session`,`user`) VALUES (?,?)");
			$stmx->execute(array($sessionID,$userinfo[1]));	
			$status = "0";
		} elseif ($_GET['code']) { 		
			$code = preg_replace('/[^a-z0-9]/i','',$_GET['code']);
			$stmt = $dbh->prepare("select status, code, title, author from sessions where code=? and author=?");
			$stmt->execute(array($code,$userinfo[1]));
			while ($row = $stmt->fetch (PDO::FETCH_OBJ)) {
				$status = $row->status;
				$num = $row->code;
				$title = $row->title;
				$author = $row->author;
			}
		}
		
		if ($status != "-1") {
			echo "<session error=\"0\" msg=\"\" status=\"".$status."\" code=\"".$num."\">".$title."</session>";				
		} else {
			echo "<session error=\"0\" msg=\"\" status=\"-1\"></session>";
		}
		
	} else {
		echo "<session error=\"1\" msg=\"Authentication Error\"></session>";
	}
}

function ask() {
	global $valid_user;
	global $dbh;
	global $userinfo;
 	if ($valid_user == 1) {
		if ($_GET['code']) {			
			$status = $_GET['s'];
			$code = preg_replace('/[^a-z0-9]/i','',$_GET['code']);
			if ($status) {
				$stmt = $dbh->prepare("UPDATE `sessions` SET `status`=? WHERE `code`=? and author = ?");
				$stmt->execute(array($_GET['s'],$code,$userinfo[1]));
			}
			$stmt = $dbh->prepare("select id, status, title, type, author, length, maxpp from sessions where code=?");
			$stmt->execute(array($code));
			#$auth = "";
			while ($row = $stmt->fetch (PDO::FETCH_OBJ)) {
				if ($userinfo[1] == $row->author) { $auth = "1"; } else { $auth = "0"; }
				$id = $row->id;
				$status = $row->status;
				$title = $row->title;
				$type = $row->type;
				$author = $row->author;
				$length = $row->length;
				$length = $length*18*6;
				$maxpp = $row->maxpp;
			}			

			$myitems = 0;
			$stmt = $dbh->prepare("select count(*) from questions where session=? and author=?");
			$stmt->execute(array($id,$userinfo[1]));
			$myitems = $stmt->fetchColumn() + 1;

			if ($_GET['text'] and $myitems <= $maxpp and $status==1) {
				$qtext = urldecode ($_GET['text']);
				$qtext = strip_tags($qtext);
				$stmt = $dbh->prepare("INSERT INTO `questions` (`session`,`author`,`content`) VALUES (?,  ?,  ?)");
				$stmt->execute(array($id,$userinfo[1],$qtext));	
				$myitems++;
				
				$q = $dbh->lastInsertId();
				$v = 1;
				$stmt = $dbh->prepare("INSERT INTO `votes` (`user`,`session`,`question`,`vote`) VALUES (?, ?, ?, ?)");
				$stmt->execute(array($userinfo[1],$id,$q,$v));	
				$ups = 1;
				$downs = 0;
				$votes = 1;
				$score = ($ups + 2) / ($votes + 4);
				$mid_score = abs($score - 0.5);
				$stm = $dbh->prepare("UPDATE `questions` SET `votes`=?, `ups`=?, `downs`=?, `score`=?, `mid_score`=? WHERE `id`=?");
				$stm->execute(array($votes,$ups,$downs,$score,$mid_score,$q));					
			} elseif ($status==0) {
				$stmx = $dbh->prepare("INSERT INTO `session_user` (`session`,`user`) VALUES (?,?)");
				$stmx->execute(array($id,$userinfo[1]));		
			}
			
			$stmt = $dbh->prepare("select count(*) from session_user where session=? and user=?");
			$stmt->execute(array($id,$userinfo[1]));
			$checked = $stmt->fetchColumn();
			 
			if ($_GET['p']) {
				$page = $_GET['p'];
			} else {
				$page = 2;
			}
			if ($userinfo[1] == $author) { $auth = "1"; } else { $auth = "0"; }
			if (($status == 0 or $status == 1) and $checked == 1) {
				echo "<session error=\"0\" msg=\"\" status=\"".$status."\" code=\"".$code."\" author=\"".$auth."\" myitems=\"".$myitems."\" maxitems=\"".$maxpp."\" type=\"".$type."\" length=\"".$length."\" uid=\"".microtime(true)*(10000)."\" page=\"".$page."\">".$title."</session>";				
			} elseif ($status == 2) {
				echo "<session error=\"0\" msg=\"\" status=\"".$status."\" code=\"".$code."\" author=\"".$auth."\" myitems=\"".$myitems."\" maxitems=\"".$maxpp."\" type=\"".$type."\" length=\"".$length."\" page=\"".$page."\">".$title."</session>";			
			} else {
				echo "<session error=\"1\" msg=\"That code (i.e., ".$code.") does not match any session currently accepting new check ins.\"></session>";
			}
		} else {
			echo "<session error=\"1\" msg=\"You must enter a session code.\"></session>";
		}
	} else {
		echo "<session error=\"1\" msg=\"Authentication\"></session>";
	}
}

function vote() {
	global $valid_user;
	global $dbh;
	global $userinfo;
 	if ($valid_user == 1) {
		if ($_GET['code']) {			
			$status = $_GET['s'];
			$code = preg_replace('/[^a-z0-9]/i','',$_GET['code']);
			$stmt = $dbh->prepare("select id, status, type, title from sessions where code=?");
			$stmt->execute(array($code));
			#$auth = "";
			while ($row = $stmt->fetch (PDO::FETCH_OBJ)) {
				$id = $row->id;
				$status = $row->status;
				$type = $row->type;
				$title = $row->title;
			}			
			
			$bob = "";
			if ($_GET['q'] and $_GET['v'] and $status == 1 and checkedin($id,$userinfo[1])==1) {
				$q = preg_replace('/[^0-9]/i','',$_GET['q']);
				$v = preg_replace('/[^0-9\-]/i','',$_GET['v']);
				$stmt = $dbh->prepare("INSERT INTO `votes` (`user`,`session`,`question`,`vote`) VALUES (?, ?, ?, ?)");
				$stmt->execute(array($userinfo[1],$id,$q,$v));	
				
				$stmt = $dbh->prepare("select count(*) from votes where question=? AND vote='1'");
				$stmt->execute(array($q));
				$ups = $stmt->fetchColumn();
				$stmt = $dbh->prepare("select count(*) from votes where question=? AND vote='-1'");
				$stmt->execute(array($q));
				$downs = $stmt->fetchColumn();
				$votes = $ups + $downs;
				$score = ($ups + 2) / ($votes + 4);
				$mid_score = abs($score - 0.5);
				$stm = $dbh->prepare("UPDATE `questions` SET `votes`=?, `ups`=?, `downs`=?, `score`=?, `mid_score`=? WHERE `id`=?");
				$stm->execute(array($votes,$ups,$downs,$score,$mid_score,$q));	
			}			

			$seen = 0;
			$stmt = $dbh->prepare("select count(*) from votes where session=? and user=?");
			$stmt->execute(array($id,$userinfo[1]));
			$seen = $stmt->fetchColumn() + 1;
			
			$items = 0;
			$stmt = $dbh->prepare("select count(*) from questions where session=?");
			$stmt->execute(array($id));
			$items = $stmt->fetchColumn();
			$voters = 0;
			$stmt = $dbh->prepare("select count(DISTINCT user) from session_user where session=?");
			$stmt->execute(array($id));
			$voters = $stmt->fetchColumn();
			
			if ($_GET['p']) {
				$page = $_GET['p'];
			} else {
				$page = 2;
			}
			if ($userinfo[1] == $author) { $auth = "1"; } else { $auth = "0"; }
			if (($status == 0 or $status == 1) and $id != '' and checkedin($id,$userinfo[1])==1) {
				if ($items > 0) {
					$stmt = $dbh->prepare("select * from (select * from questions where session = ?) A left join (select * from votes where user = ?) B on B.question = A.id where B.user is null order by mid_score ASC, A.created ASC limit 1");
					$stmt->execute(array($id,$userinfo[1]));
					while ($row = $stmt->fetch (PDO::FETCH_OBJ)) {
						$qid = $row->id;
						$content = $row->content;
					}
					if ($content == "") { $content = "null"; }
				} else {
					$content = "null";
				}
				echo "<session error=\"0\" msg=\"\" title=\"".$title."\" status=\"".$status."\" code=\"".$code."\" qid=\"".$qid."\" author=\"".$auth."\" seen=\"".$seen."\" type=\"".$type."\" page=\"".$page."\" voters=\"".$voters."\" items=\"".$items."\"><![CDATA[".stripslashes ($content)."]]></session>";				
			} elseif ($status == 2) {
				echo "<session error=\"0\" msg=\"\" title=\"".$title."\" status=\"".$status."\" code=\"".$code."\" qid=\"".$qid."\" author=\"".$auth."\" seen=\"".$seen."\" type=\"".$type."\" page=\"".$page."\" voters=\"".$voters."\" items=\"".$items."\"><![CDATA[".stripslashes ($content)."]]></session>";				
			} else {
				echo "<session error=\"1\" msg=\"That code (i.e., ".$code.") does not match any session currently accepting new check ins.\"></session>";
			}
		} else {
			echo "<session error=\"1\" msg=\"You must enter a session code.\"></session>";
		}
	} else {
		echo "<session error=\"1\" msg=\"Authentication\"></session>";
	}
}

function read() {
	global $valid_user;
	global $dbh;
	global $userinfo;
 	if ($valid_user == 1) {
		if ($_GET['code']) {
			$status = $_GET['s'];
			$code = preg_replace('/[^a-z0-9]/i','',$_GET['code']);
			if ($status == 2) {
				$stmt = $dbh->prepare("UPDATE `sessions` SET `status`=? WHERE `code`=? and author = ?");
				$stmt->execute(array($_GET['s'],$code,$userinfo[1]));
			}
			$stmt = $dbh->prepare("select id, status, title from sessions where code=?");
			$stmt->execute(array($code));
			while ($row = $stmt->fetch (PDO::FETCH_OBJ)) {
				$id = $row->id;
				$status = $row->status;
				$title = $row->title;
			}
			$items = 0;
			$votes = 0; 
			$voters = 0;
			$stmt = $dbh->prepare("select count(*) from questions where session=?");
			$stmt->execute(array($id));
			$items = $stmt->fetchColumn();
			$stmt = $dbh->prepare("select sum(votes) from questions where session=?");
			$stmt->execute(array($id));
			$votes = $stmt->fetchColumn();
			$stmt = $dbh->prepare("select count(DISTINCT user) from session_user where session=?");
			$stmt->execute(array($id));
			$voters = $stmt->fetchColumn();
			
			if ($status == 2) {
				$stmt = $dbh->prepare("select score, content from questions where session=? order by score DESC, questions.created ASC limit 100");
				$stmt->execute(array($id));
				$session = array();
				echo "<session error=\"0\" msg=\"\" title=\"".$title."\" items=\"".$items."\" votes=\"".$votes."\" voters=\"".$voters."\">\n";
				while ($row = $stmt->fetch (PDO::FETCH_OBJ)) {
					echo "<item score=\"".$row->score."\"><![CDATA[".stripslashes ($row->content)."]]></item>\n";
				}
				echo "</session>";			
			} else {
				echo "<session error=\"1\" msg=\"There was an error.\"></session>";
			}
		} else {
			echo "<session error=\"1\" msg=\"You must enter a session code.\"></session>";
		}
	} else {
		echo "<session error=\"1\" msg=\"Authentication\"></session>";
	}

}
?>
