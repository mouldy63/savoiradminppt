<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, recordfound, id, sql, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, addperson, newname, locationname, location, lid, selected, consigneename
Set Con = getMysqlConnection()
selected=""
lid=request("lid")

msg=Request("msg")




%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/extra.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>
<div class="container">
<!-- #include file="header.asp" -->
<%sql="SELECT * from consignee_address where consignee_ADDRESS_ID=" & lid
Set rs = getMysqlQueryRecordSet(sql, con)	%>
					  <div class="content brochure">
			    <div class="one-col head-col">
			<p>EDIT CONSIGNEE</p>
            <%if msg<>"" then%>
            <p><font color="#FF0000"><%=msg%></font></p>
            <%end if%>
	<div id="c1">
    		<form name="form1" method="post" action="addconsignee.asp?amend=y">
			
			    <label for="consigneename"></label>
		      </p>
			  <p>Consignee Name:<br>
			    <input name="consigneename" type="text" id="consigneename" value="<%=rs("consigneename")%>" size="40">
		      </p>
			  <p>Address Line 1:<br>
			    <input name="add1" type="text" id="add1" value="<%=rs("add1")%>" size="40">
			  </p>
			  <p>Address Line 2:<br>
			    <input name="add2" type="text" id="add2" value="<%=rs("add2")%>" size="40">
			  </p>
			  <p>Town:<br>
			    <input name="town" type="text" id="town" value="<%=rs("town")%>" size="40">
			  </p>
			  <p>County / State :<br>
			    <input name="county" type="text" id="county" value="<%=rs("countystate")%>" size="40">
			  </p>
			  <p>Country :<br>
			    <input name="country" type="text" id="country" value="<%=rs("country")%>" size="40">
			  </p>
			  <p>Contact Name :<br>
			    <input name="contact" type="text" id="contact" value="<%=rs("contact")%>" size="40">
			  </p>
			  <p>Tel :<br>
			    <input name="tel" type="text" id="tel" value="<%=rs("phone")%>" size="40">
			  </p>
		
			  <p>
			    <input type="submit" name="addperson" id="addperson" value="Amend Consignee">
		      <input name="consigneeid" type="hidden" value="<%=rs("consignee_ADDRESS_ID")%>"></p>
            </form>
		</div>
			    </div>
  </div>
<div>
</div>
        </form>
</body>
</html>
<%

Con.Close
Set Con = Nothing
%>
  
<!-- #include file="common/logger-out.inc" -->
