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
        <p class="pagetitles"><a href="updateweb.asp?country=1&typeofupdate=savoirid"><< Back to Savoirid Main menu</a><br /><br />
		<%if request("up")=1 then response.write("Image / text updated")%>&nbsp;</p>
        <h1>Upload Main Article image to Savoirid.com</h1>
        <hr>
        
        <p>The intro image currently is<br>
        <img src="http://www.savoirid.com/savoiridimages/interiordesigner-beds1.jpg">
        </p>
        <form METHOD="POST" ENCTYPE="multipart/form-data" ACTION="douploadimage1.asp">
          <div align="left">
 
            <p><strong>
                          </strong><strong>Add Intro Image (width 465px - recommended height 103px)<br>
                          </strong>
                          <input name="FILE1" type="file" id="FILE1" size="30">
            </p>
			
            <p>Img Alt text<br>
            <%sql="Select * from texts where textkey like 'MainArticleText'"
			  Set rs = getMysqlUpdateRecordSet(sql, con)%>
              <textarea name="alttext" cols="60" id="alttext" ><%=rs("imgalttext")%></textarea>
              
            </p>
           <hr>
           <h1>Upload Main Article Pop Up Header image to Savoirid.com</h1>
           <p>The main article pop up header image currently is<br>
             <img src="http://www.savoirid.com/savoiridimages/interiordesigner-beds2.jpg"> </p>
           <p><strong>Add main article pop up header image  (width 702px - recommended height 273px)<br>
           </strong>
             <input name="FILE2" type="file" id="FILE2" size="30">
           </p>
           
            <p><strong>Enter alt text for image</strong><br>
            <%
			  Set rs = getMysqlUpdateRecordSet(sql, con)%>
              <textarea name="alttext2" cols="60" id="alttext2" ><%=rs("imgalttext3")%></textarea>
             
            </p>
            <p>&nbsp;</p>
            <h1>Upload extra image1</h1><br>
              <p>To add this image into the text copy and paste the following code and click on &quot;Source&quot; button<br>
                PLEASE ADD ALT TEXT (description of images)                <br>
                <font color="#FF0000">
              &lt;span id=&quot;ctr&quot;&gt;&lt;img src=&quot;savoiridimages/interiordesigner-beds3.jpg&quot; alt=&quot;&quot; /&gt;&lt;/span&gt;</font> </p>           
            <p><input name="FILE3" type="file" id="FILE3" size="30"></p>
            <h1>Upload extra Image 2 </h1>
            <p>To add this image into the text copy and paste the following code and click on &quot;Source&quot; button <br>
              PLEASE ADD ALT TEXT (description of images)              <br>
              <font color="#FF0000"> &lt;span id=&quot;ctr&quot;&gt;&lt;img src=&quot;savoiridimages/interiordesigner-beds4.jpg&quot; alt=&quot;&quot; /&gt;&lt;/span&gt;</font></p>
            <p><input name="FILE4" type="file" id="FILE4" size="30">
            </p>
            <hr>
              <%rs.close
			  set rs=nothing%>   
                <input name="submit" type="submit" value="Upload Image or update Alt Text">
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
