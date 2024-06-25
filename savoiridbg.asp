<%Option Explicit%>
<%
dim ALLOWED_ROLES, sql, Con, rs, val
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
Set Con = getMysqlConnection()
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
      <div align="left">
        <p class="pagetitles"><br /><br />
		<%if request("up")=1 then response.write("Image(s) updated")%>&nbsp;</p>
        <h1>Upload background images for Savoirid.com</h1>
        <p>Please make sure they are optimised for the web or they will slow down the website and may begin to lose ranking in google.</p>
        <hr>
        
        
        <form METHOD="POST" ENCTYPE="multipart/form-data" ACTION="douploadimageIDbg.asp">
          <div align="left">
 <p>The 1st image currently is<br>
        <img src="http://www.savoirid.com/savoiridimages/interiordesigner-beds1-bg.jpg" width="100">
        </p>
              <p><strong>
                          </strong><strong>Change 1st Image (width 2048px - recommended height 1428px)<br>
                          </strong>
                          <input name="FILE1" type="file" id="FILE1" size="30">
            </p>
			<p>The 2nd image currently is<br>
        <img src="http://www.savoirid.com/savoiridimages/interiordesigner-beds2-bg.jpg" width="100">
        </p>
           <p><strong>
                          </strong><strong>Change 2nd Image (width 2048px - recommended height 1428px)<br>
                          </strong>
                          <input name="FILE2" type="file" id="FILE2" size="30">
            </p>
            <p>The 3rd image currently is<br>
        <img src="http://www.savoirid.com/savoiridimages/interiordesigner-beds3-bg.jpg" width="100">
        </p>
            <p><strong>
                          </strong><strong>Change 3rd Image (width 2048px - recommended height 1428px)<br>
                          </strong>
                <input name="FILE3" type="file" id="FILE3" size="30">
            </p>
            <p>The 4th image currently is<br>
        <img src="http://www.savoirid.com/savoiridimages/interiordesigner-beds4-bg.jpg" width="100">
        </p>
            <p><strong>
                          </strong><strong>Change 4th Image (width 2048px - recommended height 1428px)<br>
                          </strong>
                <input name="FILE4" type="file" id="FILE4" size="30">
            </p>
            <hr>
                 
              <input name="submit" type="submit" value="Upload Images">
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
<%Con.close
set Con=nothing%>
<!-- #include file="common/logger-out.inc" -->
