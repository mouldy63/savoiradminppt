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
<%Dim postcode, postcodefull, Con, rs, rs2, recordfound, id, rspostcode, submit1, submit2, count, envelopecount, i, fieldName, fieldValue, fieldNameArray, type1, submit3, submit4, submit5, lettercount, corresid, nobrochurealert, xcount, ycount, x, y, sql, correspondencename, userlocation, userregion
userlocation=retrieveUserLocation()
userregion=retrieveUserRegion()
nobrochurealert=Request("nobrochurealert")
corresid=Request("corresid")
'count=0
submit1=""
submit2=""
submit3=""
submit4=""
submit5=""
Set Con = getMysqlConnection()
submit1=Request("submit1")
If submit1<>"" then 
 		sql="Select * from correspondence Where owning_location=" & userlocation & " and correspondencename like 'Brochure Request%'"
		Set rs = getMysqlQueryRecordSet(sql, con)
		If not rs.eof then
			corresid=rs("correspondenceid")
		else
			sql="Select * from correspondence Where owning_region=" & userregion & " and correspondencename like 'Brochure Request%'"
			Set rs = getMysqlQueryRecordSet(sql, con)
			If not rs.eof then
				corresid=rs("correspondenceid")
			end if
		end if
end if
submit2=Request("submit2")
submit3=Request("submit3")
submit4=Request("submit4")
submit5=Request("submit5")


Set rs = getMysqlUpdateRecordSet("Select * from region Where id_region=" & retrieveUserRegion() & "", con)
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

<%If submit4 <> "" Then
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	fieldNameArray = Split(fieldName, "_")
	type1 = fieldNameArray(1)

Set rs = getMysqlUpdateRecordSet("Select * from contact Where code=" & type1, con)
rs("retire")="y"
rs.Update
rs.close
set rs=nothing
End If
next
Con.close
set Con=nothing
response.Redirect("brochure-requests.asp?msg=deleted")
End If

If submit3 <> "" Then
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	fieldNameArray = Split(fieldName, "_")
	type1 = fieldNameArray(1)

Set rs = getMysqlUpdateRecordSet("Select * from contact Where code=" & type1, con)
rs("brochurerequestsent")="y"
rs.Update
rs.close
set rs=nothing
End If
next
Con.close
set Con=nothing
response.Redirect("brochure-requests.asp?msg=removed")
End If

If submit1 <> "" Then
If nobrochurealert<>"n" Then%>
<div id="donotprint"><a href="javascript: history.go(-1)" onClick="return confirm('Remember to remove brochure requests when you have finished printing?'); " id="donotprint">BACK</a></div>
<%Else%>
<div id="donotprint"><a href="javascript: history.go(-1)" id="donotprint">BACK</a></div>
<%End If%>
<%
lettercount=0
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	lettercount=lettercount+1
	end if
next
count=0
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	count=count+1
	fieldNameArray = Split(fieldName, "_")
	type1 = fieldNameArray(1)

Set rs = getMysqlQueryRecordSet("Select * from address A, contact C Where A.code=C.code AND A.code=" & type1, con)
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
If rs("country")<>"" Then response.write(rs("country"))
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
response.Write(rs2("correspondence"))
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
<%If count<lettercount Then%>
<div style="page-break-after:always">&nbsp;</div>	
<%End If%>
<%rs.close
set rs=nothing
End If
next
End If


If submit2 <> "" Then
If nobrochurealert<>"n"  Then%>
<div id="donotprint"><a href="javascript: history.go(-1)" onClick="return confirm('Remember to remove brochure requests when you have finished printing?'); " id="donotprint">BACK</a></div>
<%Else%>
<div id="donotprint"><a href="javascript: history.go(-1)" id="donotprint">BACK</a></div>
<%End If%>
<%
envelopecount=0
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	envelopecount=envelopecount+1
	end if
next
count=0
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	count=count+1
	fieldNameArray = Split(fieldName, "_")
	type1 = fieldNameArray(1)

Set rs = getMysqlQueryRecordSet("Select * from address A, contact C Where A.code=C.code AND A.code=" & type1, con)
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
If rs("country")<>"" Then response.write(rs("country"))
%>
</div>
<%If count<envelopecount Then%>
<div style="page-break-after:always">&nbsp;</div>	
<%End If%>

<%rs.close
set rs=nothing
End If
next
End If



If submit5 <> "" AND userlocation<>8 Then
	If nobrochurealert<>"n"  Then%>
	<div id="donotprintright"><a href="javascript: history.go(-1)" onClick="return confirm('Remember to remove brochure requests when you have finished printing?'); " id="donotprintright">BACK</a></div>
	<%Else%>
	<div id="donotprintright"><a href="javascript: history.go(-1)" id="donotprintright">BACK</a></div>
	<%End If%>
<%
envelopecount=0
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	envelopecount=envelopecount+1
	end if
next
count=0
xcount = -1
	ycount = 0
	y = 40
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	count=count+1
	fieldNameArray = Split(fieldName, "_")
	type1 = fieldNameArray(1)

	
	xcount = xcount + 1
	if xcount > 2 then
   	 	xcount = 0
    		if ycount < 6 then
       			y = y + 135
   			 else
      			y = y + 169
     			ycount = -1
   		    end if
    	    ycount = ycount + 1
	end if
	if xcount = 0 then
 	   x = 12
	elseif xcount = 1 then
       x = 242
	else
	   x = 480
	end if
	Response.Write("<div style=""display: block; width: 200px; position: absolute; left: " & x & "px; top: " & y & "px;"">")
	sql="Select * from address A, contact C Where A.code=C.code AND A.code=" & type1
	'response.Write("sql=" & sql)
	'response.End()
	Set rs = getMysqlQueryRecordSet(sql, con)
	If rs("title")<>"" Then response.write(capitalise(rs("title")) & " ")
	If rs("first")<>"" Then response.write(capitalise(rs("first")) & " ")
	If rs("surname")<>"" Then response.write(capitalise(rs("surname")) & "<br />")
	If rs("company")<>"" Then response.write(rs("company") & "<br />")
	If rs("street1")<>"" Then response.write(rs("street1") & "<br />")
	If rs("street2")<>"" Then response.write(rs("street2") & "<br />")
	If rs("street3")<>"" Then response.write(rs("street3") & "<br />")
	If rs("county")<>"" Then response.write(rs("county") & " ")
	If rs("postcode")<>"" Then response.write(rs("postcode") & "<br />")
	If rs("country")<>"" Then response.write(rs("country"))
	Response.Write("</div>")
	count=count+1%>

	<%rs.close
	set rs=nothing
	End if

next
End If


If submit5 <> "" AND userlocation=8 Then
	If nobrochurealert<>"n"  Then%>
	<div id="donotprintright"><a href="javascript: history.go(-1)" onClick="return confirm('Remember to remove brochure requests when you have finished printing?'); " id="donotprintright">BACK</a></div>
	<%Else%>
	<div id="donotprintright"><a href="javascript: history.go(-1)" id="donotprintright">BACK</a></div>
	<%End If%>
<%
envelopecount=0
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	envelopecount=envelopecount+1
	end if
next
count=0
xcount = -1
	ycount = 0
	y = 140
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	count=count+1
	fieldNameArray = Split(fieldName, "_")
	type1 = fieldNameArray(1)

	
	xcount = xcount + 1
	if xcount > 1 then
   	 	xcount = 0
    		if ycount < 2 then
       			y = y + 280
   			 else
      			y = y + 360
     			ycount = -1
   		    end if
    	    ycount = ycount + 1
	end if
	if xcount = 0 then
 	   x = 100
	else
	   x = 450
	end if
	Response.Write("<div style=""display: block; width: 200px; position: absolute; left: " & x & "px; top: " & y & "px;"">")
	sql="Select * from address A, contact C Where A.code=C.code AND A.code=" & type1
	'response.Write("sql=" & sql)
	'response.End()
	Set rs = getMysqlQueryRecordSet(sql, con)
	If rs("title")<>"" Then response.write(capitalise(rs("title")) & " ")
	If rs("first")<>"" Then response.write(capitalise(rs("first")) & " ")
	If rs("surname")<>"" Then response.write(capitalise(rs("surname")) & "<br />")
	If rs("company")<>"" Then response.write(rs("company") & "<br />")
	If rs("street1")<>"" Then response.write(rs("street1") & "<br />")
	If rs("street2")<>"" Then response.write(rs("street2") & "<br />")
	If rs("street3")<>"" Then response.write(rs("street3") & "<br />")
	If rs("county")<>"" Then response.write(rs("county") & " ")
	If rs("postcode")<>"" Then response.write(rs("postcode") & "<br />")
	If rs("country")<>"" Then response.write(rs("country"))
	Response.Write("</div>")
	count=count+1%>

	<%rs.close
	set rs=nothing
	End if

next
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
<!--<script Language="JavaScript" type="text/javascript">
<!--
	$(document).ready(init);
	function init() {
		var timeout = 1;
		if ( $.browser.safari) {
			timeout = 16000;
		}
		
		window.setTimeout("checkPrint();", timeout);
	}
	function checkPrint() {
		confirm("Did it print OK");
	};
	
	
//-->
<!--</script>-->
   
<!-- #include file="common/logger-out.inc" -->
