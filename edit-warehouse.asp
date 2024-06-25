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
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, recordfound, id, sql, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, addperson, newname, locationname, location, lid, selected
Set Con = getMysqlConnection()
selected=""
lid=request("lid")

msg=Request("msg")


sql="SELECT * from location_address where LOCATION_ADDRESS_ID=" & lid
Set rs = getMysqlQueryRecordSet(sql, con)

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
	
					  <div class="content brochure">
			    <div class="one-col head-col">
			<p>EDIT WAREHOUSE</p>
            <%if msg<>"" then%>
            <p><font color="#FF0000"><%=msg%></font></p>
            <%end if%>
	<div id="c1">
    		<form name="form1" method="post" action="addwarehouse.asp?amend=y">
			  <p>Select Warehouse owning location:
			   <% sql="SELECT * from location where retire='n' order by adminheading asc"
					Set rs1 = getMysqlQueryRecordSet(sql, con)
					%>
			    <select name="idlocation">
              <%do until rs1.eof
			  selected = ""
				if rs1("idlocation") = rs("idlocation") then selected = "selected"%>
			    <option value="<%=rs1("idlocation")%>" <%=selected%>><%=rs1("adminheading")%></option>
                <%rs1.movenext
				loop
				rs1.close
				set rs1=nothing%>
			  </select>
			    <label for="warehousename"></label>
		      </p>
			  <p>Warehouse Name:<br>
			    <input name="warehousename" type="text" id="warehousename" value="<%=rs("warehousename")%>" size="40">
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
			  <p>Tick if this is the default warehouse
              <%if rs("ISDEFAULT")="y" then%>
                <input name="mainwarehouse" type="checkbox" id="mainwarehouse" value="y" checked>
				<%else%>
				 <input name="mainwarehouse" type="checkbox" id="mainwarehouse" value="y">
				<%end if%>
             
              </p>
			  <p>
			    <input type="submit" name="addperson" id="addperson" value="Amend Warehouse">
		      <input name="warehouseid" type="hidden" value="<%=rs("LOCATION_ADDRESS_ID")%>"></p>
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
