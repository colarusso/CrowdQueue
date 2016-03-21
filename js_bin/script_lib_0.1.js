var firsttime = 1;
var back = "#home";
var base = "#home";
var d = new Date();
var thisyear = d.getFullYear();
var lastresults = "#home";
var pocp = "#person";
var popp = "#person";

var supadd = 0;
var targetpage = "";
var targetid = "";
var clkcount = 0;

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function loadXMLDoc(dname)
{
if (window.XMLHttpRequest)
  {
  xhttp=new XMLHttpRequest();
  }
else
  {
  xhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xhttp.open("GET",dname,false);
xhttp.send("");
return xhttp.responseXML;
}

function make_page (myname,api_call,xsl_call,target,transition,reverse,id,thistitle) {

	var resultDocument;
	
	// code for IE
	if (window.ActiveXObject) {

		var xslt = new ActiveXObject("Msxml2.XSLTemplate.6.0");
		var xsldoc = new ActiveXObject("Msxml2.FreeThreadedDOMDocument.6.0");		
		var xslproc;
		xsldoc.async = false;
		xsldoc.load(xsl_call);
		if (xsldoc.parseError.errorCode != 0) {
		   var myErr = xsldoc.parseError;
		   //WScript.Echo("You have error " + myErr.reason);
		} else {
		   xslt.stylesheet = xsldoc;
		   var xmldoc = new ActiveXObject("Msxml2.DOMDocument.6.0");
		   xmldoc.async = false;
		   xmldoc.load(api_call);
		   if (xmldoc.parseError.errorCode != 0) {
			  var myErr = xmldoc.parseError;
			  //WScript.Echo("You have error " + myErr.reason);
			  resultDocument = "You have error " + myErr.reason	;
		  } else {
			  xslproc = xslt.createProcessor();
			  xslproc.input = xmldoc;
			  //xslproc.addParameter("base", base); // add parameter
			  //xslproc.addParameter("thisyear", thisyear); // add parameter
			  //xslproc.addParameter("id", id); // add parameter
			  xslproc.transform();
			  resultDocument = xslproc.output;
			  //WScript.Echo(xslproc.output);
		  }

		}

	}
	// code for Mozilla, Firefox, Opera, etc.
	else if (document.implementation && document.implementation.createDocument) {
		xml=loadXMLDoc(api_call);
		xsl=loadXMLDoc(xsl_call);

		xsltProcessor=new XSLTProcessor();
		
		// add parameter
		//xsltProcessor.getParameter(null, "base");
		//xsltProcessor.setParameter(null, "base", base);
		//xsltProcessor.getParameter(null, "thisyear");
		//xsltProcessor.setParameter(null, "thisyear", thisyear);
		//xsltProcessor.getParameter(null, "id");
		//xsltProcessor.setParameter(null, "id", id);
		
		xsltProcessor.importStylesheet(xsl);
		resultDocument = xsltProcessor.transformToFragment(xml,document);
	}

	$('#'+target+'_content').html(resultDocument).trigger("create");

	var activePage = $.mobile.pageContainer.pagecontainer("getActivePage").prop('id');
	
	$.mobile.changePage('#'+target, { transition: transition, reverse: reverse });	

	$('#'+activePage+'_title').html(thistitle);
	
}
 
function loadme (myname,transition,reverse,page,id) {
	
	//$.mobile.loading('show');
	var activePage = $.mobile.pageContainer.pagecontainer("getActivePage").prop('id');
	var thistitle = $('#'+activePage+'_title').html();
	$('#'+activePage+'_title').html('<font style="color:orange;">Loading...</font>').trigger( "updatelayout" );
	console.log('loading: '+activePage+'_title');
	
	setTimeout(function(){				
	
		if (page == undefined) {
			page = 1;
		}

		if (myname == 'home') {
			base = myname;
			var target = myname;
			new_session = "1";
			code = "";
			session_status = "";
			item_text = "";
			console.log('new_session: 1');
			api_call = "api/choose/";
			xsl_call = "xsl/choose.xsl";
			make_page(myname,api_call,xsl_call,target,transition,reverse,id,thistitle);
		} else if (myname == 'make') {
			base = myname;
			var target = myname;
			if (page % 2 == 0) { target= target+"_n"; }
			if (new_session == 1) {
				code = "";
				api_call = "api/make/";
				new_session = 0;
			} else {
				api_call = "api/make/?code="+code+"&title="+encodeURIComponent(document.getElementById('sessiontitle').value)+"&type="+$("input[name=type]:checked").val()+"&length="+$('#slider-1').val()*10+"&max="+$('#slider-2').val();
			} 
			xsl_call = "xsl/make.xsl";
			make_page(myname,api_call,xsl_call,target,transition,reverse,id,thistitle);
		} else if (myname == 'ask') {
			base = myname;
			var target = myname;
			if (RUauthor(code) == 0 && session_status != 1) {
				api_call = "api/make/?code="+code;
				xsl_call = "xsl/make.xsl";
				target = "make";
			} else if (SessStat(code) == 2) {
				api_call = "api/read/?code="+code;
				xsl_call = "xsl/read.xsl";
				target = "read";
			} else {
				if (page % 2 == 0) { target= target+"_n"; }
				page++;
				api_call = "api/ask/?code="+code+"&text="+encodeURIComponent(item_text)+"&s="+session_status+"&p="+page;
				xsl_call = "xsl/ask.xsl";
				item_text = "";
			}
			make_page(myname,api_call,xsl_call,target,transition,reverse,id,thistitle);
		} else if (myname == 'vote') {
			base = myname;
			var target = myname;
			if (SessStat(code) == 2) {
				api_call = "api/read/?code="+code;
				xsl_call = "xsl/read.xsl";
				target = "read";
			} else {
				if (page % 2 == 0) { target= target+"_n"; }
				page++;
				api_call = "api/vote/?code="+code+"&q="+item_id+"&v="+vote+"&p="+page;
				xsl_call = "xsl/vote.xsl";
				item_id = "";
			}
			make_page(myname,api_call,xsl_call,target,transition,reverse,id,thistitle);
		} else if (myname == 'read') {
			base = myname;
			var target = myname;
			if (page % 2 == 0) { target= target+"_n"; }
			api_call = "api/read/?code="+code+"&s="+session_status;
			xsl_call = "xsl/read.xsl";
			make_page(myname,api_call,xsl_call,target,transition,reverse,id,thistitle);
		}
		
		console.log('target: '+target);
		console.log('code: '+code);
		console.log('session_status: '+session_status);
		
	}, 1); 
	
} // end loadme

function checkIn(input) {
	if (input) {
		code=encodeURIComponent(input);
		loadme('ask');
	} else {
		alert('You must enter a session code to check-in.');
	}
}

function change_text(type) {
	document.getElementById('type_text_1').innerHTML=type;
	document.getElementById('type_text_2').innerHTML=type;
}

function RUauthor(id) {
	return mysessionsStats[mysessions.indexOf(id)];
}

function SessStat(id) {
	return sessionStat[sessionStat_code.indexOf(id)];
}

function close_session(id) {
	if (RUauthor(id)) {
		var r = confirm("Do you want to close this session and view its results? This will stop submissions and voting, and a closed session cannot be reopened.");
		if (r == true) {
			session_status = "2";
			loadme('read');
		} else {
			return false;
		}
	} else {
		alert('There was an error.');
	}
}