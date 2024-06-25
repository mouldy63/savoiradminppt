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
	<%sql="SELECT * from savoir_user where username='production' order by retired asc, name asc"

Set rs = getMysqlUpdateRecordSet(sql, con)
%>
					  <div class="content brochure">
			    <div class="one-col head-col">
			<p>STAFF EDIT SECTION 
            </p>
            <%if msg<>"" then%>
            <p><font color="#FF0000"><%=msg%></font></p>
            <%end if%>
			<form name="form1" method="post" action="addtopicklist.asp">
			  <p>
			    <label for="newname"></label>
			    Add New Person:
			    <input type="text" name="newname" id="newname">
		        <input type="submit" name="addperson" id="addperson" value="Add">
			  </p>
            </form>
		
                </div>


		<div class="two-col">
        <p>
		  <table width="416" border="0" cellspacing="2" cellpadding="2">
		    <tr>
		      <td width="124" class="redtext">NAME</td>
		      <td width="61" class="redtext">Location</td>
		      <td width="62" class="redtext">Pick List</td>
		      <td width="251" class="redtext">Made By</td>
		      <td width="151" class="redtext">&nbsp;</td>
	        </tr>
<%'response.Write("sql=" & sql)
Do until rs.eof
location=rs("id_location")
if location=1 then locationname="Bedworks"
if location=27 then locationname="Cardiff"%>		    <tr>
		      <td><%if rs("retired")="y" then %>
			  <span class="retired"><%=rs("NAME")%></span>
              <%else%>
             <%=rs("NAME")%> 
              <%end if%>
              </td>
		      <td><%=locationname%>&nbsp;</td>
		      <td><%=rs("pickedby")%></td>
		      <td><%=rs("madeby")%></td>
		      <td><a href="editpickname.asp?userid=<%=rs("user_id")%>">Edit</a> | 
			  <%if rs("retired")="y" then %>
              <a href="unretire-picklist.asp?userid=<%=rs("user_id")%>">Un-Retire</a>
              <%else%>
               <a href="retire-picklist.asp?userid=<%=rs("user_id")%>">Retire</a>
              <%end if%>
              </td>
		      </tr>
           <%rs.movenext
		   loop
		%>
	      </table></p>
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
