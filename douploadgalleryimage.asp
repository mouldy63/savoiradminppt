<%Option Explicit%>
<%
dim ALLOWED_ROLES, sql, Con, rs, val, rs2
ALLOWED_ROLES = "ADMINISTRATOR,SALES,WEBSITEADMIN"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->

<!-- #include file="aspupload.asp" -->
<!-- #include file="filefuncs1.asp" -->

<html>

<head>
<title>Image Upload</title>
<link href="stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body bgcolor="#FFFFFF" 
<div align="center"></div>
<p align="center"><small><font face="Verdana">



<%Dim upload, adnumber, File, Item, Query, img1, img2, img3, img4, img5, cont, fname, absFileName, caption, id, editimg, gallerycat, addingrow, website, admin, jpgname, pubid, formfield, hires, galleryid, keywords, imagename
hires=""
addingrow=""
Server.ScriptTimeout = 18600
Set Upload = Server.CreateObject("Persits.Upload")

'Upload.SetMaxSize 10000000000000, True
Upload.SaveVirtual("imageuploads/temp/")
adnumber = Upload.Form ("adnumber")
imagename=Upload.Form ("imagename")
keywords = Upload.Form ("keywords")
addingrow=Upload.Form("addingrow")
galleryid=Upload.Form("galleryid")
website=Upload.Form("website")
jpgname=Upload.Form("jpgname")
admin=Upload.Form("admin")
caption=Upload.Form ("caption")
gallerycat=Upload.Form("gallerycat")
val=Upload.Form ("jpgname")
editimg=Upload.Form ("editimg")
Set Con = getMysqlConnection()
Dim fileName, rep, filename1

For Each File in Upload.Files
	if File.Name = "FILE1" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirbeds.co.uk\httpdocs\gallery\collections\thumb\" & val & ".jpg", File, false)
	End If
	if File.Name = "FILE2" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirbeds.co.uk\httpdocs\gallery\collections\large\" & val & ".jpg", File, false)
	End If
	if File.Name = "FILE3" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirbeds.co.uk\httpdocs\gallery\collections\hires\" & val & ".jpg", File, false)
		hires="y"
	End If

Next
If addingrow="y" then
Set rs = getMysqlUpdateRecordSet("select * from gallery", con)
rs.AddNew
else
Set rs = getMysqlUpdateRecordSet("select * from gallery where id=" & galleryid, con)
'response.Write(sql)
'response.End()
Set rs2= getMysqlUpdateRecordSet("Select * from gallerylinks WHERE galleryid=" & galleryid, con)
Do while NOT rs2.EOF
rs2.delete
rs2.MoveNext
Loop
rs2.close

end if

If website<>"" then rs("website")="y" else rs("website")="n"
If admin<>"" then rs("sadmin")="y" else rs("sadmin")="n"
rs("priority")=99999
rs("jpgname")=jpgname
if imagename<>"" then rs("imageName")=imagename else rs("imageName") = Null
if keywords<>"" then rs("keywords")=keywords else rs("keywords") = Null
if hires="y" then rs("hires")="y" else hires="n"
rs.update
pubid=rs("id")
rs.close
set rs=nothing
for each item in Upload.Form
	if left(item.name, 2) = "XX" then
		con.execute("INSERT INTO GALLERYLINKS (galleryid,gallerycat) VALUES (" & pubid & "," & trim(item.value) & ")")
	end if
Next 

Con.close
set Con=nothing

%> </font></small></p>
<% If Err.Number = 0 THEN
Response.redirect "gallery-image.asp?val=" & pubid%>
<table width="612" border="0" align="center" class="link">
  <tr class="textunjustified">
    <td height="210"><p align="center" class="telno"><span class="bodytextunj">      <a href="logoff.asp" class="textunjustifiedwhite">Log Off</a></span></p>
      <p align="center" class="bodytextunj"><small>Image Uploaded
              Successfully</small></p>
			      <p align="center">
        <% Else %>
      </p>
      <p align="center" class="bodytextunj"><small>An
              error occured</small></p>
      <p align="center" class="bodytextunj"><small>Error
              Number = <%=Err.Number%> </small></p>
      <p align="center" class="bodytextunj"><small>Description
              = <%=Err.Description%>
        <% If Err.Number = 13 THEN %>
      </small></p>
      <p align="center" class="bodytextunj">In
    order to change an image you must first delete the old one<font face="Verdana, Arial, Helvetica, sans-serif" color="#000099"> </font></p></td>
  </tr>
</table>
<p align="center">&nbsp;</p>
<p align="center"><small><b><font face="verdana" size="2"></font></b></small></p>
<% End If %>
<% End If 
%>
<p align="center"><small><b></b></small></p>
</body>
</html>
<!-- #include file="common/logger-out.inc" -->
