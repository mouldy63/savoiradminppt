<%Option Explicit%>
<%
dim ALLOWED_ROLES, sql, Con, rs, val, rs2, i, checked, count2
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
Set Con = getMysqlConnection()

val=request("val")
count2 = 1
Set rs2 = getMysqlQueryRecordSet("Select gallerycat from gallerylinks WHERE galleryid = " & val, con)
If NOT rs2.EOF Then
dim catArray()
do until rs2.EOF
	redim preserve catArray(count2)
	catArray(count2) = rs2("gallerycat")
	rs2.movenext
	count2 = count2 + 1
loop
End If
rs2.close
set rs2 = Nothing


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


      <p align="center" class="pagetitles">&nbsp;</p>
      <div align="left">
        <p class="pagetitles"><br /><br />
		<%if request("up")=1 then response.write("Image(s) updated")%>&nbsp;</p>
        <h1>Change this gallery image</h1>
        <p>Please make sure they are optimised for the web or they will slow down the website and may begin to lose ranking in google.</p>
        <hr>
        <%Set rs = getMysqlQueryRecordSet("select * from gallery where id=" & val, con)%>
        
        <form METHOD="POST" ENCTYPE="multipart/form-data" ACTION="douploadgalleryimage.asp">
    
          <div id="c1">
 <p>The  image currently is<br>
        <img src="http://www.savoirbeds.co.uk/gallery/collections/thumb/<%=rs("jpgname")%>.jpg" width="40">
        </p>
              <p><strong>
                          </strong><strong>Change thumbnail (height 40px)<br>
                          </strong>
                          <input name="FILE1" type="file" id="FILE1" size="30">
              </p>
            <p><strong>
                          </strong><strong>Change large image (height 400px)<br>
                          </strong>
                          <input name="FILE2" type="file" id="FILE2" size="30">
            </p>
            <p><strong>Add hi-res image<br>
       </strong>
         <input name="FILE3" type="file" id="FILE3" size="30">
         <br>
         <br>
         <%if rs("website")="y" then%>
<input type="checkbox" name="website" id="website" checked>
<%else%>
<input type="checkbox" name="website" id="website">
<%end if%>
         <label for="website">Website</label>
         &nbsp;&nbsp;
         <%if rs("sadmin")="y" then%>
         <input type="checkbox" name="admin" id="admin" checked>
         <%else%>
          <input type="checkbox" name="admin" id="admin">
         <%end if%>
         <label for="admin">Admin</label>
            </p>
            <p><strong>Keywords (comma separated list please)</strong><br>
              <textarea name="keywords" cols="30" rows="3" id="keywords"><%=rs("keywords")%></textarea>
            </p>
            <input name="jpgname" type="hidden" value="<%=rs("jpgname")%>">
             <input name="gallerycat" type="hidden" value="<%=rs("cat")%>">  
            <input name="galleryid" type="hidden" value="<%=val%>">    
           
              </p>
          </div>
    

        <div id="c2">  <p><strong>Check gallery categories</strong>: </p><p>   <%Set rs2 = getMysqlQueryRecordSet("select * from gallerycategory order by Gallerycategory" , con)
	do until rs2.EOF
		  	checked = ""
if isEMPTY(catArray) then
Else
    for i = 1 to ubound(catArray)
        if catArray(i) = rs2("GCID") then checked = "checked"
    next
end if
		  %>
          <input name="XX<%=rs2("GCid")%>" type="checkbox"  value="<%=rs2("GCid")%>" <%=checked%>>
          <%=rs2("gallerycategory")%><br>
          <%rs2.movenext 
loop 
rs2.Close
Set rs2 = Nothing
	
	%>  
            </p>  
            <p>    <input name="submit" type="submit" value="Update gallery images"> </p>      
</div>
 </form>
</div>
</body>
</html>
<%rs.close
set rs=nothing
Con.close
set Con=nothing%>
<!-- #include file="common/logger-out.inc" -->
