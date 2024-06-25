<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim postcode, postcodefull, val, Con, rs, rs1, recordfound, id, rspostcode, submit, count, findus, sql, typeofupdate, website, gallerycat, cnt, formfield, searchSrc, jpgname
jpgname=request("jpgname")

gallerycat=request("gallerycat")
searchSrc = false
For Each formfield in Request.Form
	if left(formfield, 2) = "XX" then
		searchSrc = true
	end if	
Next 

cnt = 0
count=0
submit=Request("submit") 
Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
	
<SCRIPT LANGUAGE="VBScript">
Function MyForm_onSubmit
  If Msgbox("Are you sure you want to delete this record?", vbYesNo + vbExclamation) = vbNo Then
    MyForm_onSubmit = False
  End If
End Function
</SCRIPT>

<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">


<p>CLICK ON IMAGE TO START DOWNLOADING IMAGE</p>
<p>
	
<%
sql="Select * from gallery G, gallerylinks C where G.id=C.galleryid "
if searchSrc then 
		sql= sql & " AND ("
		For Each formfield in Request.Form 
					if left(formfield, 2) = "XX" then
						cnt = cnt + 1
						sql = sql & "C.gallerycat=" & right(formfield, len(formfield)-2) & " OR "
					end if	
				Next 
		if cnt = 0 then
		else
				sql = left(sql, len(sql)-4) & ")"
		end if
	end if
if jpgname<>"" then sql=sql & " AND G.jpgname like '%" & jpgname & "%'"
sql=sql & " order by cat"

'response.End()
%>
<table border="0" cellpadding="3" class="indentleft">
  
<%
Set rs = getMysqlQueryRecordSet(sql, con)%>
<p>No. of images = <%=rs.recordcount%></p>
<%
count=1
Do until rs.eof
%>
<%if count=1 then%>
<tr>
<%end if%>
<td>
    <%
	%>
    </td><td>
    <a href="http://savoirbeds.co.uk/imagedownloader.php?file=gallery/collections/large/<%=rs("jpgname")%>.jpg"><img src="http://savoirbeds.co.uk/gallery/collections/large/<%=rs("jpgname")%>.jpg"" border="0" height="100"></a><br /><%=response.Write(rs("jpgname"))%><br />
    <a href="http://savoirbeds.co.uk/imagedownloader.php?file=gallery/collections/hires/<%=rs("jpgname")%>.jpg">Download Medium image</a>
	<%if rs("hires")="y" then%>
    <br /><a href="http://savoirbeds.co.uk/imagedownloader.php?file=gallery/collections/hires/<%=rs("jpgname")%>.jpg">Download Hi Res image</a>
    <%end if%></td>
    <%
count=count+1
if count=6 then%>
</td><tr>
<%count=1%>
<%end if%>

</td>
<%rs.movenext
loop

rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>
</tr></table>
<p>&nbsp;</p>     
  </div>
  </div>
<div>
</div>
       
</body>
</html>

 
<!-- #include file="common/logger-out.inc" -->
