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


Set Con = getMysqlConnection()
Dim fileName, rep, filename1
val=request.Form("val")
'val=Upload.Form ("val")
sql="Select * from press where pressid=" & val
response.Write("sql=" & sql)
Set rs = getMysqlUpdateRecordSet(sql, con)
pressdate=day(rs("date")) & "-" & month(rs("date")) & "-" & year(rs("date"))
call deleteFileX("C:\inetpub\vhosts\savoirbeds.co.uk\httpdocs\press\" & pressdate & ".jpg")
call deleteFileX("C:\inetpub\vhosts\savoirbeds.co.uk\httpdocs\press\" & pressdate & ".pdf")
rs.delete
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
