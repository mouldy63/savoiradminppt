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
<%Dim Con, rs, val, rs1, i, selected

Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />


<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
	


	<form action="douploadpress.asp" method="post" enctype="multipart/form-data" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
        <p>Add press item below</p>

        <label for="maincountry"></label>
        <select name="maincountry" id="maincountry">
        <%Set rs1 = getMysqlQueryRecordSet("Select * from store_country order by country_id", con)
		  Do until rs1.eof
		 %>
          <option value="<%=rs1("country_id")%>"><%=rs1("country")%></option>
          <%rs1.movenext
		  loop
		  rs1.close
		  set rs1=nothing%>
        </select>
        If the main press item is not for the UK select which country it is for (this will ensure that it is prioritised before any UK press items.
        <p>Date:<br />
          <input name="pressdate" type="text" id="pressdate" size="10" readonly><a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.pressdate','calendar_window','width=154,height=288');calendar_window.focus()">
      Choose Date</a></p>
        <p><b>Select which countries the press item should appear on:</b></p>
        <p>
          
          <%Set rs1 = getMysqlQueryRecordSet("Select * from store_country order by country_id", con)
		  Do until rs1.eof%>
          
          <input name="country<%=rs1("country_id")%>" value="y" id="country<%=rs1("country_id")%>" type="checkbox"><%=rs1("country")%>&nbsp;&nbsp;
          <%
	rs1.movenext
	loop
	rs1.close
	set rs1=nothing%>
          
          
        </p>
      <p>If press item needs a link to a URL instead of a pdf please add it here:
        <input name="urllink" type="text" value="" size="70">
        <br>
      <p>Upload press image (jpg 350px x 438px)<br>
        <label for="pressjpg"></label>
        <input type="file" name="pressjpg" id="pressjpg">
      <p>Upload press pdf (if required)<br>
        <label for="presspdf"></label>
      <input type="file" name="presspdf" id="presspdf">            
      <p>
        <input type="submit" name="submit1" value="Add Press item"  id="submit1" class="button" />
    </form>
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
