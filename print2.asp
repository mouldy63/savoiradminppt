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
<%Dim postcode, postcodefull, Con, rs, rs2, recordfound, id, rspostcode, submit1, submit2, count, envelopecount, i, fieldName, fieldValue, fieldNameArray, type1, submit3, submit4, submit5, lettercount, corresid, nobrochurealert, xcount, ycount, x, y, sql, correspondencename, val, val2
val2=Request("val2")
val=Request("val")
corresid=Request("corresid")

Set Con = getMysqlConnection()
Set rs = getMysqlUpdateRecordSet("Select * from region Where id_region=" & retrieveUserLocation() & "", con)
'Session.LCID=1029
Session.LCID=trim(rs("locale"))
rs.close
set rs=nothing%>


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
<body onLoad="window.print();">
<div id="donotprintright"><a href="javascript: history.go(-1)" id="donotprintright">BACK</a></div>
<%If corresid<>"" Then
lettercount=0

Set rs = getMysqlQueryRecordSet("Select * from address A, contact C Where A.code=C.code AND A.code=" & val2, con)
%>
<div id="lettercontainer">
<p><%=FormatDateTime(date(), 1)%></p>
<p><%If rs("title")<>"" Then response.write(capitalise(rs("title")) & " ")
If rs("first")<>"" Then response.write(capitalise(rs("first")) & " ")
If rs("surname")<>"" Then response.write(capitalise(rs("surname")) & "<br />")
If rs("company")<>"" Then response.write(rs("company") & "<br />")
If rs("street1")<>"" Then response.write(rs("street1") & "<br />")
If rs("street2")<>"" Then response.write(rs("street2") & "<br />")
If rs("street3")<>"" Then response.write(rs("street3") & "<br />")
If rs("county")<>"" Then response.write(rs("county") & " ")
If rs("postcode")<>"" Then response.write(rs("postcode") & "<br />")
if rs("country")<>"United Kingdom" then
If rs("country")<>"" Then response.write(rs("country"))
end if
%>

</p>

<%Set rs2 = getMysqlQueryRecordSet("Select * from correspondence Where correspondenceid=" & corresid, con)
correspondencename=rs2("correspondencename")
If rs2("greeting")<>"" Then
response.Write("<p>" & rs2("greeting") & " ")
If rs("title")<>"" Then response.write(capitalise(rs("title")) & " ")
If rs("surname")<>"" Then response.write(capitalise(rs("surname")))
response.Write("</p>")
End If
response.Write("<p>" & rs2("correspondence") & "</p>")
rs2.close
set rs2=nothing
Set rs2 = getMysqlUpdateRecordSet("Select * from communication", con)
rs2.AddNew
rs2("code")=type1
rs2("date")=date()
rs2("type")="Letter"
rs2("notes")=correspondencename
rs2("staff")=retrieveUserName()
rs2("owning_region")=rs("owning_region")
rs2("source_site")=rs("source_site")
rs2("person")=rs("title") & " " & rs("first") & " " & rs("surname")
rs2.Update
rs2.close
set rs2=nothing

%>

</div>
<%rs.close
set rs=nothing
End If



If val <> "" Then
sql="Select * from address A, contact C Where A.code=C.code AND A.code=" & val
'response.Write("sql=" & sql)
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
%>
<div id="envelope"><%
If rs("title")<>"" Then response.write(capitalise(rs("title")) & " ")
If rs("first")<>"" Then response.write(capitalise(rs("first")) & " ")
If rs("surname")<>"" Then response.write(capitalise(rs("surname")) & "<br />")
If rs("company")<>"" Then response.write(rs("company") & "<br />")
If rs("street1")<>"" Then response.write(rs("street1") & "<br />")
If rs("street2")<>"" Then response.write(rs("street2") & "<br />")
If rs("street3")<>"" Then response.write(rs("street3") & "<br />")
If rs("county")<>"" Then response.write(rs("county") & " ")
If rs("postcode")<>"" Then response.write(rs("postcode") & "<br />")
if rs("country")<>"United Kingdom" then
If rs("country")<>"" Then response.write(rs("country"))
end if
%>
</div>
<%rs.close
set rs=nothing
End If
con.close
set con=nothing
%>


       
</body>
</html>
<%

function capitalise(str)
dim words, word
if isNull(str) or trim(str)="" then
	capitalise=""
else
	words = split(trim(str), " ")
	for each word in words
		If IsNumeric(word) Then
		Else
		word = lcase(word)
		word = ucase(left(word,1)) & (right(word,len(word)-1))
		capitalise = capitalise & word & " "
		End If
	next
	capitalise = left(capitalise, len(capitalise)-1)
end if
end function

%>

   
<!-- #include file="common/logger-out.inc" -->
