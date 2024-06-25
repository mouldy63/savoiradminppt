<%Option Explicit%>

<!-- #include file="access/funcs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<%Dim postcode, postcodefull, val, Con, rs, rs1, rs2, recordfound, id, rspostcode, submit, count, findus, sql, accessoryid, formfield, accessorytext, pressid, presstext, presspriority, imageid, region, localeref, charsetref
Session.LCID=1029
count=0
val=""
val=Request("val")
submit=Request("submit") 
Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

<link rel="stylesheet" href="Styles/jquery.signaturepad.css">
<!--[if lt IE 9]><script src="scripts/flashcanvas.js"></script><![endif]-->
<script src="scripts/jquery.min.js"></script>

</head><body><div id="content">

</head>
<body>
<div class="container">



        
	<%

Set rs = getMysqlUpdateRecordSet("Select * from czech WHERE id=1", con)
	%>

<%response.Write(rs("testtext"))%>
<%rs.close
set rs=nothing

Con.Close
Set Con = Nothing%>       
<div style="font-family: Arial, Verdana, sans-serif; font-size: 12px; color: rgb(34, 34, 34); background-color: rgb(255, 255, 255); ">
	<p>
		pomůže</p>
</div>
    </div>   
</body>
</html>

 