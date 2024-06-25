<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%
dim dzOrderNum, dzPurchaseNo, dzUserId, dzType
dzOrderNum = 10000
dzPurchaseNo = 12345
dzUserId = 99
dzType = "entry"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head>
	<title>Drop Zone Test</title>
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8">
    <script type="text/javascript" src="common/jquery.js"></script>
    <script type="text/javascript" src="scripts/dropzone.js"></script>
    <script type="text/javascript" src="scripts/spin.min.js"></script>
	<script src="common/utils.js" type="text/javascript"></script>
    <style>
		.dz-class {
		    background: none repeat scroll 0 0 rgba(0, 0, 0, 0.03);
		    border: 1px solid rgba(0, 0, 0, 0.03);
		    border-radius: 3px;
		    min-height: 200px;
		    padding: 23px;
		}
    </style>
</head>
<body>
<!-- #include file="dropzone_include.asp" -->
<hr/>
<%
dzType = "exit"
%>
<!-- #include file="dropzone_include.asp" -->
</body>
</html>
<!-- #include file="common/logger-out.inc" -->
