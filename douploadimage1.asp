<%Option Explicit%>
<%
dim ALLOWED_ROLES, sql, Con, rs, val
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
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



<%Dim upload, adnumber, File, Item, Query, img1, img2, img3, img4, img5, cont, fname, absFileName, caption, id, editimg
Server.ScriptTimeout = 18600
Set Upload = Server.CreateObject("Persits.Upload")

'Upload.SetMaxSize 10000000000000, True
Upload.SaveVirtual("imageuploads/temp/")
adnumber = Upload.Form ("adnumber")
caption=Upload.Form ("caption")
val=Upload.Form ("val")
editimg=Upload.Form ("editimg")
Set Con = getMysqlConnection()
Dim fileName, rep, filename1

For Each File in Upload.Files
	if File.Name = "FILE1" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds1.jpg", File, false)
	End If
	if File.Name = "FILE2" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds2.jpg", File, false)
	End If
	if File.Name = "FILE3" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds3.jpg", File, false)
	End If
	if File.Name = "FILE4" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds4.jpg", File, false)
	End If
if File.Name = "FILE10" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds1A.jpg", File, false)
	End If
	if File.Name = "FILE11" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds1B.jpg", File, false)
	End If
	if File.Name = "FILE12" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds1C.jpg", File, false)
	End If
	if File.Name = "FILE13" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds1D.jpg", File, false)
	End If
if File.Name = "FILE20" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds2A.jpg", File, false)
	End If
	if File.Name = "FILE21" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds2B.jpg", File, false)
	End If
	if File.Name = "FILE22" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds2C.jpg", File, false)
	End If
	if File.Name = "FILE23" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds2D.jpg", File, false)
	End If
if File.Name = "FILE30" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds3A.jpg", File, false)
	End If
	if File.Name = "FILE31" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds3B.jpg", File, false)
	End If
	if File.Name = "FILE32" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds3C.jpg", File, false)
	End If
	if File.Name = "FILE33" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirid.com\httpdocs\savoiridimages\interiordesigner-beds3D.jpg", File, false)
	End If
	
Next
'MAIN ARTICLE
If upload.form("alttext")<>"" then 
sql="Select * from texts where textkey like 'MainArticleText'"
	Set rs = getMysqlUpdateRecordSet(sql, con)
	rs("IMGalttext")=Upload.Form("alttext")
	rs.update
	rs.close
	set rs=nothing
end if	
If upload.form("alttext2")<>"" then 
sql="Select * from texts where textkey like 'MainArticleText'"
	Set rs = getMysqlUpdateRecordSet(sql, con)
	rs("IMGalttext3")=Upload.Form("alttext2")
	rs.update
	rs.close
	set rs=nothing
end if	

'ARTICLE 1	
If upload.form("A1alttext")<>"" then 
sql="Select * from texts where textkey like 'Article1Text'"
	Set rs = getMysqlUpdateRecordSet(sql, con)
	rs("IMGalttext")=Upload.Form("A1alttext")
	rs.update
	rs.close
	set rs=nothing
end if	
If upload.form("A1alttext2")<>"" then 
sql="Select * from texts where textkey like 'Article1Text'"
	Set rs = getMysqlUpdateRecordSet(sql, con)
	rs("IMGalttext3")=Upload.Form("A1alttext2")
	rs.update
	rs.close
	set rs=nothing
end if	

'ARTICLE 2	
If upload.form("A2alttext")<>"" then 
sql="Select * from texts where textkey like 'Article2Text'"
	Set rs = getMysqlUpdateRecordSet(sql, con)
	rs("IMGalttext")=Upload.Form("A2alttext")
	rs.update
	rs.close
	set rs=nothing
end if	
If upload.form("A2alttext2")<>"" then 
sql="Select * from texts where textkey like 'Article2Text'"
	Set rs = getMysqlUpdateRecordSet(sql, con)
	rs("IMGalttext3")=Upload.Form("A2alttext2")
	rs.update
	rs.close
	set rs=nothing
end if	

'ARTICLE 3	
If upload.form("A3alttext")<>"" then 
sql="Select * from texts where textkey like 'Article3Text'"
	Set rs = getMysqlUpdateRecordSet(sql, con)
	rs("IMGalttext")=Upload.Form("A3alttext")
	rs.update
	rs.close
	set rs=nothing
end if	
If upload.form("A3alttext2")<>"" then 
sql="Select * from texts where textkey like 'Article3Text'"
	Set rs = getMysqlUpdateRecordSet(sql, con)
	rs("IMGalttext3")=Upload.Form("A3alttext2")
	rs.update
	rs.close
	set rs=nothing
end if	
					
Con.close
set Con=nothing

%> </font></small></p>
<% If Err.Number = 0 THEN
If Upload.Form("fmused")="article1" then response.redirect "savoiridimagesA1.asp?up=1"
If Upload.Form("fmused")="article2" then response.redirect "savoiridimagesA2.asp?up=1"
If Upload.Form("fmused")="article3" then response.redirect "savoiridimagesA3.asp?up=1"
Response.redirect "savoiridimages.asp?up=1"%>
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
