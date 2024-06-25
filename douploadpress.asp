<%Option Explicit%>
<%
dim ALLOWED_ROLES, sql, Con, rs, val
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



<%Dim upload, adnumber, File, Item, Query, img1, img2, img3, img4, img5, cont, fname, absFileName, caption, id, editimg, pressdate, country1, country2, country3, country4, country5, country6, country7, country8, country9, urllink
Server.ScriptTimeout = 18600
Set Upload = Server.CreateObject("Persits.Upload")

'Upload.SetMaxSize 10000000000000, True
Upload.SaveVirtual("imageuploads/temp/")
pressdate= Upload.Form ("pressdate")
urllink= Upload.Form ("urllink")
country1=Upload.Form ("country1")
country2=Upload.Form ("country2")
country3=Upload.Form ("country3")
country4=Upload.Form ("country4")
country5=Upload.Form ("country5")
country6=Upload.Form ("country6")
country7=Upload.Form ("country7")
country8=Upload.Form ("country8")
country9=Upload.Form ("country9")
pressdate=day(pressdate) & "-" & month(pressdate) & "-" & year(pressdate)
val=Upload.Form ("val")
Set Con = getMysqlConnection()
Dim fileName, rep, filename1

For Each File in Upload.Files
	if File.Name = "pressjpg" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirbeds.co.uk\httpdocs\press\" & pressdate & ".jpg", File, false)
	End If
	if File.Name = "presspdf" then
		call processFileAbsoluteNOresize("C:\inetpub\vhosts\savoirbeds.co.uk\httpdocs\press\" & pressdate & ".pdf", File, false)
	End If
Next
Set rs = getMysqlUpdateRecordSet("Select * from press", con)
rs.AddNew
rs("date")=pressdate
rs("country")=Upload.Form("maincountry")
if urllink<>"" then rs("urllink")=urllink else rs("urllink")=""
if country1="y" then rs("country1")="y" else rs("country1")="n"
if country2="y" then rs("country2")="y" else rs("country2")="n"
if country3="y" then rs("country3")="y" else rs("country3")="n"
if country4="y" then rs("country4")="y" else rs("country4")="n"
if country5="y" then rs("country5")="y" else rs("country5")="n"
if country6="y" then rs("country6")="y" else rs("country6")="n"
if country7="y" then rs("country7")="y" else rs("country7")="n"
if country8="y" then rs("country8")="y" else rs("country8")="n"
if country9="y" then rs("country9")="y" else rs("country9")="n"
rs.Update
rs.close
set rs=nothing
Con.close
set Con=nothing

%> </font></small></p>
<% If Err.Number = 0 THEN 
response.Redirect("presslist.asp")
%>
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
