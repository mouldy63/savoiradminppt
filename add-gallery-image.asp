<%Option Explicit%>
<%
dim ALLOWED_ROLES, sql, Con, rs, val
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
Set Con = getMysqlConnection()
val=request("val")
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

  <%Set rs = getMysqlQueryRecordSet("select * from gallerycategory order by Gallerycategory", con)%>
        
        
        <form METHOD="POST" ENCTYPE="multipart/form-data" ACTION="douploadgalleryimage.asp" onSubmit="return FrontPage_Form1_Validator(this)">>
        

      <p align="center" class="pagetitles">&nbsp;</p>
     
        <h1>Add New gallery image</h1>
        <p>Please make sure they are optimised for the website or they will slow down the website and may begin to lose ranking in google.</p>
        <hr>
     <div id="c1">
          <p><strong>Tick websites for image:</strong><br>
            <br />
          <input type="checkbox" name="website" id="website">
          
        <label for="website">Website</label>&nbsp;&nbsp;
        <input type="checkbox" name="admin" id="admin">
        <label for="admin">Admin</label>
                  
          <p>
            
       <p><strong>Add thumbnail (height 40px)<br>
                </strong>
                          <input name="FILE1" type="file" id="FILE1" size="30">
       </p>
       <p><strong>
                          </strong><strong>Add large image (height 400px)<br>
                          </strong>
                          <input name="FILE2" type="file" id="FILE2" size="30">
            </p>
       <p><strong>Add hi-res image<br>
       </strong>
         <input name="FILE3" type="file" id="FILE3" size="30">
       </p>
          <p><strong>Add jpg name</strong> (do <strong>not</strong> put extension i.e. .jpg)<br>
            (warning if same name already exists it will overwrite it):<br /> <input name="jpgname" type="text">
                 
          
              </p>
          <p><strong>Add Title / Name of image</strong><br>
            <input name="imagename" type="text" id="imagename" size="40" maxlength="255">
          </p>
          <p><strong>Enter keywords for searching for this image<br>
          Please separate each word with a comma and no spaces</strong><br>
            <textarea name="keywords" cols="30" rows="3" id="keywords"></textarea>
          </p>
          <p>&nbsp;</p>
          <p><br>
          </p>
          </div>
     

     
<div id="c2">  <p><strong>Check gallery categories</strong>: </p><p>   <%do until rs.eof%>
            <input type="checkbox" name="XX<%=rs("GCid")%>" value="<%=rs("GCid")%>" >
            <label for="cat"><%=rs("gallerycategory")%></label>  <br />  
            <%rs.movenext
			loop%>  
            </p>  
            <p>  <input name="addingrow" type="hidden" value="y">  <input name="submit" type="submit" value="Add gallery images"></p>      
</div>
 </form>
  </div>   
       

</body>
</html>
<%rs.close
set rs=nothing
Con.close
set Con=nothing%>
<script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form1_Validator(theForm)
{

if ((!theForm.website.checked) && (!theForm.admin.checked)) {
	alert('Please enter  admin and/or  website for images to be uploaded to');
	theForm.website.focus();
	return false; 
}

if ((theForm.FILE1.value == "") && (theForm.FILE2.value == "") && (theForm.FILE3.value == "")) {
	// Have entred a date, so lets have a note
	alert('Please choose a file to upload');
	theForm.FILE1.focus();
	return false; 
}

return true;
}
//-->
</script>
<!-- #include file="common/logger-out.inc" -->
