<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, customerasc, orderasc, showr,  companyasc, bookeddate, previousOrderNumber, acknowDateWarning
dim diff
companyasc=""
customerasc=""
orderasc=""
bookeddate=""
showr=""
showr=request("showr")
bookeddate=request("bookeddate")
companyasc=request("companyasc")
customerasc=request("customerasc")
orderasc=request("orderasc")
msg=""
msg=Request("msg")
count=0
submit=Request("submit") 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
<script src="scripts/keepalive.js"></script>

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
<% 
postcodefull=Request("postcode")
postcode=Replace(postcodefull, " ", "")
If msg<>"" Then response.Write("<p><font color=""red"">The Brochure Requests were " & msg & "</font></p>")%>
<p>Savoir Documents to download</p>


<!--<form name="form1" method="post" action="">-->	
  <p>
    <%Set Con = getMysqlConnection()


Con.Close
Set Con = Nothing%>
    

    
  </p>

<!--</form>-->
</div>
  </div>
<div>
</div>
       
</body>
</html>
 <script language="JavaScript">
<!--

function selectAll() {

	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = true;
	        }
	    }
	}

}

function deselectAll() {

	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = false;
	        }
	    }
	}

}

//-->
</script>
   
<!-- #include file="common/logger-out.inc" -->
