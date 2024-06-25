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
<%Dim postcode, postcodefull, Con, rs, rs2, submit, recordfound, id, rspostcode, count, envelopecount, i, fieldName, fieldValue, fieldNameArray, type1, lettercount, corresid, nobrochurealert, xcount, ycount, x, y, sql, fso, filename, filename1
submit=Request("submit")
Set Con = getMysqlConnection()
Set rs = getMysqlUpdateRecordSet("Select * from region Where id_region=" & retrieveUserLocation() & "", con)
'Session.LCID=1029
Session.LCID=trim(rs("locale"))
rs.close
set rs=nothing
if isSuperUser() then %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/printletter.css" rel="Stylesheet" type="text/css" />
<link href="Styles/printletter1.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
</head>
<body>
<%If submit <> "" Then
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	fieldNameArray = Split(fieldName, "_")
	type1 = fieldNameArray(1)

Set rs = getMysqlUpdateRecordSet("Select * from accessories Where accessoryid=" & type1, con)
rs("approved")="y"
rs.Update
rs.close
set rs=nothing
End If
next

For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "YY_" Then
	fieldNameArray = Split(fieldName, "_")
	type1 = fieldNameArray(1)

			  Set fso = CreateObject("Scripting.FileSystemObject")
					filename1 = Server.MapPath("accessories/" & type1 & ".jpg")
					'response.Write("filename1 =" & filename1)
					'response.End()
					If fso.FileExists(filename1) Then
						fso.Deletefile(filename1)
					End If

Set rs = getMysqlUpdateRecordSet("Select * from accessories Where accessoryid=" & type1, con)

rs.delete

rs.close
set rs=nothing

End If
next
End If

%>


       
</body>
</html>
<%end If
con.close
set con=nothing

%>
   
<!-- #include file="common/logger-out.inc" -->
