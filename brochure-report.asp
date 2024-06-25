<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, recordfound, id, sql, i
Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<script>
$(function() {
var year = new Date().getFullYear();
$( "#monthfrom" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#monthfrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#monthto" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#monthto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});

</script>

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<form action="brochure-results.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
					  <div class="content brochure">
			    <div class="one-col head-col">
			<p>Brochure Request Reports</p><p>&nbsp;</p>
                </div>


		<div class="two-col">
         <div class="row">
    
        <input type="hidden" name="site" value="<%=retrieveUserSite()%>" />
        <div class="row">
		  <p>Find no of brochure requests from Prospect status between dates </p>
		  <p>from&nbsp;
		    <label>
		      <input name="monthfrom" type="text" id="monthfrom" size="10">
		      &nbsp;&nbsp;&nbsp;&nbsp;to&nbsp;
		      <input name="monthto" type="text" id="monthto" size="10">
		       </label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;              </p>
				<p><strong>OR</strong> by Month
				  <label>
    <select name="month" id="month" >
      <option value="n">Select Month</option>
      <option value="<%=month(date())%>"><%=MonthName(month(date()))%></option>
      <%For i=1 to 11%>
      <option value="<%=month(DateAdd("m",-i,date()))%>"><%=MonthName(month(DateAdd("m",-i,date())))%></option>
      <% next%>
      </select>
  </label>
				  Year
				  <label>
				    <select name="year" id="year">
				      <option value="<%=Year(date())%>"><%=Year(date())%></option>
				      <%For i=1 to 10%>
				      <option value="<%=year(date())-i%>"><%=year(date())-i%></option>
				      <% next%>
			        </select>
			      </label>
				  </h2>
		  </p>
				<p><br>
		  </p>
</div>
            <div class="row">
              <input type="submit" name="submit" value="Search Database"  id="submit" class="button" />
              <label>
                <input name="excellist" type="submit" class="button" id="excellist" value="Produce CSV file">
              </label>
<input name="Reset" type="reset" class="button" id="button" value="Reset Form">
            </div>
         </div>
		</div>
  </div>
<div>
</div>
        </form>
</body>
</html>
<%Con.close
set Con=nothing%>
    <script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form1_Validator(theForm)
{
 
   if ((theForm.monthfrom.value == "") && (theForm.monthto.value == "") && (theForm.month.value == "n"))
  {
    alert("Please complete one of the fields to obtain results");
    theForm.monthfrom.focus();
    return (false);
  }

if ((theForm.monthfrom.value != "") && (theForm.monthto.value != "") && (theForm.month.value != "n"))
  {
    alert("Please reset the form and choose either Dates from and to OR month and year");
    theForm.monthfrom.focus();
    return (false);
  }

    return true;
} 

//-->
</script>
<!-- #include file="common/logger-out.inc" -->
