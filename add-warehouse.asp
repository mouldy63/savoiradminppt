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
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, recordfound, id, sql, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, addperson, newname, locationname, location
Set Con = getMysqlConnection()



msg=Request("msg")


sql="SELECT * from location where retire='n' order by adminheading asc"

Set rs = getMysqlUpdateRecordSet(sql, con)

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
			      <%if msg<>"" then%>
            <p><font color="#FF0000"><%=msg%></font></p>
            <%end if%>
	<div id="c1">
    		<form name="form1" method="post" action="addwarehouse.asp">
			  <h1>ADD NEW WAREHOUSE</h1>
			  <p>Select Warehouse owning location:
			    
			    <select name="idlocation">
              <%do until rs.eof%>
			    <option value="<%=rs("idlocation")%>"><%=rs("adminheading")%></option>
                <%rs.movenext
				loop
				rs.close
				set rs=nothing%>
			  </select>
			    <label for="warehousename"></label>
		      </p>
			  <p>Warehouse Name:<br>
			    <input name="warehousename" type="text" id="warehousename" size="40">
		      </p>
			  <p>Address Line 1:<br>
			    <input name="add1" type="text" id="add1" size="40">
			  </p>
			  <p>Address Line 2:<br>
			    <input name="add2" type="text" id="add2" size="40">
			  </p>
			  <p>Town:<br>
			    <input name="town" type="text" id="town" size="40">
			  </p>
			  <p>County / State :<br>
			    <input name="county" type="text" id="county" size="40">
			  </p>
			  <p>Country :<br>
			    <input name="country" type="text" id="country" size="40">
			  </p>
			  <p>Contact Name :<br>
			    <input name="contact" type="text" id="contact" size="40">
			  </p>
			  <p>Tel :<br>
			    <input name="tel" type="text" id="tel" size="40">
			  </p>
			  <p>Tick if this is the default warehouse 
			    <input name="mainwarehouse" type="checkbox" id="mainwarehouse" value="y">
			   
			  </p>
			  <p>
			    <input type="submit" name="addperson" id="addperson" value="Add Warehouse">
		      </p>
            </form>
		</div>
        <div id="c2">
        <h1>Current Warehouses (click on warehouse to edit)</h1>
        <p>
        <%sql="SELECT * from location_address  order by idlocation asc, warehousename asc"

Set rs = getMysqlUpdateRecordSet(sql, con)
do until rs.eof
if rs("isdefault")="y" then 
response.Write("<a href=""edit-warehouse.asp?lid=" & rs("LOCATION_ADDRESS_ID") & """><font color=""red"">" & rs("warehousename") & " - " & rs("country") & "</font></a><br />")
else
response.Write("<a href=""edit-warehouse.asp?lid=" & rs("LOCATION_ADDRESS_ID") & """>" & rs("warehousename") & " - " & rs("country") & "</a><br />")
end if
rs.movenext
loop
rs.close
set rs=nothing%></p>

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
