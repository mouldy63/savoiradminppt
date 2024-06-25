<%Option Explicit%>
<%
dim ALLOWED_ROLES, sql, Con, rs, val
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">

<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>

<body bgcolor="#FFFFFF" text="#000000">
<div class="container">
<!-- #include file="header.asp" -->
<div align="center"> 
</div>

<table  border="0" align="center" cellpadding="0" cellspacing="0" class="bodytextunj">
  <tr> 
    <td valign="top">
      <p align="center" class="pagetitles">&nbsp;</p>
      <div align="center">
        <p class="pagetitles">&nbsp;</p>
        <p>Add an accessory image (image will be scaled to 180px wide x 177px high)</p>
        <form METHOD="POST" ENCTYPE="multipart/form-data" ACTION="douploadimage.asp">
          <div align="center">
 
            <p><strong>
                          </strong><strong>Add  Image </strong>
                          <input name="FILE1" type="file" id="FILE1" size="30">
            </p>
            <p align="center"><strong>Enter text for image</strong><br>
              <input name="val" type="hidden" value="<%=val%>">
              <textarea name="caption" cols="60" id="caption"></textarea>
              <br>
              <input name="submit" type="submit" value="Upload Image">
            </p>
</div>
        </form>
        <p class="pagetitles">&nbsp;          </p>
        </p>
        </p>
<p class="pagetitles">&nbsp;</p>
      </div>   
        </td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
  </tr>
</table>
</div>
</body>
</html>
<!-- #include file="common/logger-out.inc" -->
