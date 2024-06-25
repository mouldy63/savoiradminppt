<% option explicit
Response.Expires = 0
Response.Buffer = True
Session.LCID = 2057 %>
<!-- #include file="adovbs2.inc" -->
<!-- #include file="login.inc" -->
<!-- #INCLUDE file="mysqldbfuncs.asp" -->
 <%Dim con, rs, val, valueid, valueret
  val=Request("valueid")
  ' Open Database Connection
Set Con = getDBConnection()
Set rs = getUpdateRecordSet("Select * from images WHERE imgid = " & val, con)%>
<html>
<head>
<title>Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
//-->
</style>
<link href="stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<!-- #include file="header.asp" -->
<div align="center"> 
</div>

<table  border="0" align="center" cellpadding="0" cellspacing="0" class="bodytextunj">
  <tr> 
    <td valign="top">
      <p align="center" class="pagetitles">&nbsp;</p>
      <div align="center">
        <p class="pagetitles">Edit  image / caption to the gallery </p>
        <p class="pagetitles">        <a href="editpages.asp" class="textunjustifiedwhite">Main menu</a> | <a href="javascript: history.go(-1)">Back</a> </p>
        <form METHOD="POST" ENCTYPE="multipart/form-data" ACTION="douploadimage.asp">
          <div align="center">
            <p class="bodytextunj"><strong>Overwrite LANDSCAPE Image with <br>
              </strong>(leave blank if image is not to be replaced)<strong><br> 
              </strong>
                          <input name="FILE1" type="file" id="FILE1" size="30">
            </p>
            <p align="center" class="bodytextunj"><strong><strong>Overwrite PORTRAIT Image with <br>
            </strong></strong>(leave blank if image is not to be replaced)<strong><strong><br>
            </strong>
            <input name="FILE2" type="file" id="FILE2" size="30">
            <br>
            <br>
<br>
              Enter caption below</strong><br>
              <textarea name="caption" cols="30" rows="4" id="caption"><%=rs("Caption")%></textarea> 
            </p>
            <p align="center" class="bodytextunj">
            <input name="val" type="hidden" value="<%=rs("gallery")%>">
              <input name="editimg" type="hidden" id="editimg" value="<%=rs("imgid")%>">
              <br>
              <input name="submit" type="submit" value="Edit Image / text">
            </p>
          </div>
        </form>
        <p class="pagetitles">&nbsp;          </p>
        <table width="173" border="1" align="center" bordercolor="#000033" bgcolor="#CCCCCC">
          <tr>
            <td align="center" class="maintext"><strong><font color="#FF0000">Pressing the button <font size="3"><br>
      below</font> will delete<br>
      the entire gallery record listed above </font></strong>
                <form method="post" action="deleteimage.asp" name="MyForm">
                  <input type="hidden" name="reference" value="<%=rs("imgid")%>">
                   <input name="gallery" type="hidden" value="<%=rs("gallery")%>">
                  <input type="submit" value="Delete Image Record" name="submit">
              </form></td>
          </tr>
        </table>
        </p>
        </p>
<p class="pagetitles">&nbsp;</p>
      </div>   
        </td>
  </tr>
</table>

</body>
</html>
<%rs.close
set rs=nothing
con.close
set con=nothing%>