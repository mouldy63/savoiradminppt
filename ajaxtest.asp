<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,NOPRICESUSER,TESTER"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
dim con, rs, sql, n
Set con = getMysqlConnection()
sql = "select * from press where pressid=1"
Set rs = getMysqlQueryRecordSet(sql, con)

%>
<html>
<head>
<meta charset="UTF-8">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
</head> 
<body>
<%
for n = 1 to 11
%>
<p><input type="text" name="country<%=n%>" id="country<%=n%>" value="<%=rs("country"&n)%>" size="20" /></p>
<%
next
%>
</body>
</html>
<%
call closemysqlrs(rs)
call closemysqlcon(con)
%>
<script>
	<%
	for n = 1 to 11
	%>
	$('#country<%=n%>').blur(function()	{
	    var url = "ajaxtest2.asp?n=<%=n%>&val=" + $('#country<%=n%>').val();
	    console.log(url);
		var response = $.ajax({
        	type: "GET",
        	url: url,
        	async: false
    		}).responseText;
    	console.log("response = " + response);
    	$('#country<%=n%>').val(response);
	});
	<%
	next
	%>
</script>