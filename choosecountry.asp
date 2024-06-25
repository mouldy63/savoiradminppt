<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim  Con, rs

Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
	<script type="text/javascript" src="ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="ckeditor/lang/_languages.js"></script>


<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
<script src="scripts/keepalive.js"></script>

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">

<p>Website Updates</p>
<div id="c1">	
<%
Set rs = getMysqlQueryRecordSet("Select * from store_country order by priority", con)
%>		<form action="updateweb.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">
<p>Choose Country .</p>
  <p>
    <input type="radio" name="typeofupdate" id="Text and menus" value="text">
    <label for="Text and menus"></label>
    Text and menus</p>
    <p>
    <input type="radio" name="typeofupdate" id="Alerts" value="alerts">
    <label for="alerts"></label>
    Alerts</p>
  <p>
    <input type="radio" name="typeofupdate" id="Text and menus" value="seo">
    <label for="Text and menus2"></label> 
    SEO Metatags
</p>
  <p>
    <input type="radio" name="typeofupdate" id="Text and menus" value="mobile">
    <label for="Text and menus"></label> 
    Mobile text not included in main site
</p>
<p>
    <input type="radio" name="typeofupdate" id="Text and menus" value="savoirid">
    <label for="Text and menus"></label> 
    Savoirid.com Text and images
</p>
  <p>
    <label>
      <select name="country" id="country">
      <%Do until rs.eof%>
        <option value="<%=rs("country_id")%>"><%=rs("country")%></option>
        <%rs.movenext
		loop
		rs.close
		set rs=nothing%>
      </select>
    </label>
  </p>
  <p>

    <input type="submit" name="submit" value="Choose"  id="submit" class="button" />
  </p>
  <p>&nbsp;</p>
  <p>&nbsp;</p>
</form>
</div>
<div id="c2">
<h1>Update Gallery Text / Images</h1>
<%Set rs = getMysqlQueryRecordSet("Select * from gallerycategory order by gallerycategory asc", con)%>
<form action="gallerylist.asp" method="get">
  <p>
    <select name="gallerycat">
      <option value="n">Please Choose Gallery</option>
      <%Do until rs.eof%>
      <option value="<%=rs("gcid")%>"><%=rs("gallerycategory")%></option>
      <%rs.movenext
  loop
  rs.close
  set rs=nothing%>
    </select>
  </p>
  <p>
    <input type="submit" name="subgallery" id="subgallery" value="Update Gallery">
  </p>
  <p><a href="add-gallerycategory.asp">Add Gallery Category</a><br>
    <a href="add-gallery-image.asp">Add New Images</a><br>
    <a href="galleryshowroom.asp">Search and Download Images</a></p>
</form>
<hr>
<p><strong>SAVOIRBEDS PRESS</strong></p>
<p><a href="addpress.asp">Add New Press Item</a><br>
  <a href="presslist.asp">Amend countries available to press item </a></p>
<hr>
<h1>Update Store Addresses / Opening Times</h1>
<p><a href="storelist.asp">Click here to update Store details</a></p>
<hr>
<h1>Update Savoirid.com background images</h1>
<p><a href="savoiridbg.asp">Click here to update background images</a></p>
<p>&nbsp;</p>
</div>
<div class="clear">&nbsp;</div>
<%

Con.Close
Set Con = Nothing%>       
  </div>
  </div>
<div>
</div>
       
</body>
</html>

   
<!-- #include file="common/logger-out.inc" -->
