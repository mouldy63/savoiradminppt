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
<%Dim postcode, postcodefull, Con, rs, rs2, recordfound, id, rspostcode, submit1, submit2, count, envelopecount, i, fieldName, fieldValue, fieldNameArray, type1, submit3, submit4, submit5, lettercount, corresid, nobrochurealert, xcount, ycount, x, y, sql, correspondencename, contactno
nobrochurealert=Request("nobrochurealert")
corresid=Request("corresid")
'count=0
submit1=""
submit2=""

submit1=Request("submit1")
submit2=Request("submit2")
if isSuperUser() then 
Set Con = getMysqlConnection()

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/printletter.css" rel="Stylesheet" type="text/css" />
<link href="Styles/printletter1.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>
<%If submit1 <> "" Then
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	fieldNameArray = Split(fieldName, "_")
	type1 = fieldNameArray(1)

Set rs = getMysqlUpdateRecordSet("Select * from contact Where code=" & type1, con)
contactno=rs("contact_no")
rs.delete
rs.close
set rs=nothing

Set rs = getMysqlUpdateRecordSet("Select * from address Where code=" & type1, con)
rs.delete
rs.close
set rs=nothing
End If

Set rs = getMysqlUpdateRecordSet("Select * from communication Where code=" & type1, con)
If not rs.eof then
Do until rs.eof
rs.delete
rs.movenext
loop
End If
rs.close
set rs=nothing


Set rs = getMysqlUpdateRecordSet("Select * from interestproductslink Where contact_no=" & contactno, con)
If not rs.eof then
Do until rs.eof
rs.delete
rs.movenext
loop
End If
rs.close
set rs=nothing


next
Con.close
set Con=nothing
response.Redirect("deletespam.asp?msg=deleted")
End If

If submit2 <> "" Then
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	fieldNameArray = Split(fieldName, "_")
	type1 = fieldNameArray(1)

Set rs = getMysqlUpdateRecordSet("Select * from contact Where code=" & type1, con)
rs("retire")="n"
rs.Update
rs.close
set rs=nothing
End If
next
Con.close
set Con=nothing
response.Redirect("deletespam.asp?msg=removed")
End If

%>


       
</body>
</html>
<%End If%>
<!-- #include file="common/logger-out.inc" -->
