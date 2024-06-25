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
<!-- #include file="generalfuncs.asp" -->

<%Dim Con, rs, userid, sql, addperson, msg, newname, strname, locationid, selected
userid=request("userid")

Set Con = getMysqlConnection()

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
	<%sql="SELECT * from savoir_user where user_id=" & userid


Set rs = getMysqlQueryRecordSet(sql, con)
locationid=rs("id_location")
strname=rs("name")%>
					  <div class="content brochure">
			    <div class="one-col head-col">
			<p>STAFF EDIT DETAILS 
            </p>
           
			<form name="form1" method="post" action="updatepickname.asp?userid=<%=userid%>">
			  <p>
			    <label for="newname"></label>
			    Edit name:
			    <input type="text" name="newname" id="newname" value="<%=strname%>">
			  </p>
			  <p><%if rs("pickedby")="y" then%>
              <input name="pick" type="checkbox" id="pick" value="y" checked>
              <%else%>
              <input name="pick" type="checkbox" id="pick" value="y">
              <%end if%>
			    
		      Picklist</p>
			  <p>
              <%if rs("madeby")="y" then%>
                <input name="made" type="checkbox" id="made" value="y" checked>
                <%else%>
              <input name="made" type="checkbox" id="made" value="y">
              <%end if%> 
                Made By
</p>
			  <p>
			    <label for="factory"></label>
			    <select name="factory" id="factory">
                <%if locationid=27 then %>
                 <option value="27" selected>Cardiff</option>
                <%else%>
                <option value="27">Cardiff</option>
                <%end if%>
                
			     <%if locationid=1 then %>
                 <option value="1" selected>Bedworks</option>
                <%else%>
               <option value="1">Bedworks</option>
                <%end if%>
			     
		        </select>
		      Base			  </p>
			  <p>
			    <label for="pick"></label>
			    <input type="submit" name="addperson" id="addperson" value="Edit">
		      </p>
            </form>
		
                </div>

</div></div>
</body>
</html>
<%rs.close
set rs=nothing
con.close
set con=nothing%>
<!-- #include file="common/logger-out.inc" -->
