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
<%Dim postcode, postcodefull, val, Con, rs, rs1, recordfound, id, rspostcode, submit, count, findus, sql, typeofupdate, website, gallerycat, msg
val=request("val")
if val<>"" then msg="Gallery sequence has been updated"
gallerycat=request("gallerycat")
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
<script type="text/javascript">
<!--
function winconfirm(rsid){
var answer = confirm ("Are you sure you want to delete this image and test?")
if (answer)
window.location="delgalleryimg.asp?gallerycat=<%=gallerycat%>&id=" + rsid;
else
alert ("Ok - the image/text will NOT be deleted")
}
// -->
</script> 
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
<%if msg<>"" then%>
<p><font color="#CC0000"><%=msg%></font></p>
<%end if%>

<p>Click on image number below to edit image text or click on Image to change/edit Image:</p>
<p>
	
<%
sql="Select * from gallery G, gallerylinks C where C.gallerycat=" & gallerycat & " and G.id=C.galleryid order by G.priority"

'response.Write("sql=" & sql)
'response.End()
%>
<table border="0" cellpadding="3" class="indentleft">
 <tr> <td>Priority</td><td>&nbsp;</td><td>Image No.</td><td>Image</td></tr>
<%
Set rs = getMysqlQueryRecordSet(sql, con)
Do until rs.eof
%>
 <form name="form1" method="post" action="changeimageseq.asp">
<tr>
    <%
	response.Write("<td><input name=""RC" & rs("ID") & """ type=""text"" value=" & rs("priority") & " size=""4""></td><td>&nbsp;</td><td><a href=""amend-gallerytext.asp?val=" & rs("id") & """>" & rs("jpgname") & "</a></td><td><a href=""gallery-image.asp?val=" & rs("id") & """><img src=""http://savoirbeds.co.uk/gallery/collections/thumb/" &  rs("jpgname")  & ".jpg"" border=""0"" width=""40""></a></td>")
	%>
    <td><a href="delgalleryimg.asp?id=<%=rs("id")%>" onClick="winconfirm(<%=rs("id")%>); return false;">Delete Image and Text</a></td>
</tr>
<%rs.movenext
loop

rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>

</table>
<p><input name="gallerycat" type="hidden" value="<%=gallerycat%>">
<input type="submit" name="Submit" value="Change Sequence">&nbsp;</p>     
  </div>
  </div>
<div>
</div>
       
</body>
</html>

   
<!-- #include file="common/logger-out.inc" -->
