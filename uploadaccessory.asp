<%Option Explicit%>
<%
dim ALLOWED_ROLES, sql, Con, rs, val, editimg
editimg=""
editimg=Request("img")
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
val=Request("val")
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
        <%If Request("edit")="y" Then%>
       <p> You have just uploaded the following image and we have sized it to the correct size for the website.</p>
       <img src="accessories/accessory<%=editimg%>.jpg" width="180" height="177">
       <p>If you are not happy with this image please upload another one by entering details below or <a href="delaccessory.asp?val=<%=editimg%>">click here to delete it</a>.</p>
        
       <p> Or <a href="approveaccessory.asp?val=<%=editimg%>"><b><font color="#990000">CLICK HERE TO SEND TO LONDON FOR APPROVAL</font></b></a></p>
        <%End If%>
        <p><%If Request("edit")="y" Then%>
        <hr>
        Edit the
                          <%Else%>
                          Add an
                          <%End If%>
                            accessory image (image will be scaled to 180px wide x 177px high)</p>
        <form METHOD="POST" ENCTYPE="multipart/form-data" ACTION="douploadimage.asp">
          <div align="center">
 
            <p><strong>
                          </strong><strong> <%If Request("edit")="y" Then%>
                          Edit Image
                          <%Else%>
                          Add Image
                          <%End If%>
                           </strong>
                          <input name="FILE1" type="file" id="FILE1" size="30">
            </p>
            <p align="center"><strong>Enter text for image</strong><br>
              <input name="val" type="hidden" value="<%=val%>">
              <input name="editimg" type="hidden" value="<%=editimg%>">
              <input name="caption" type="text" id="caption" value="" size="60">
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
