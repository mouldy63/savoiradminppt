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
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, recordfound, id, sql
msg=""
msg=Request("msg")
Set Con = getMysqlConnection()
found = false
For Each item In Request.Form
  ItemValue = Request.Form(Item)
  if Instr(ItemValue, "http://") then
	found = true
  End If
Next
For Each item In Request.Form
  ItemValue = Request.Form(Item)
  if Instr(ItemValue, "<") then
	found = true
  End If
Next
If found= true then response.Redirect("error.asp")
'msg="<html><body><font face=""Arial, Helvetica, sans-serif"">"
'If Request("name") <> "" Then msg=msg & " " & Request("name") & " " & Request("surname") & "<br /> "
'If Request("email") <> "" Then msg=msg & "<b>Email address :</b> " & Request("email") & "<br>"
'If Request("address") <> "" Then msg=msg & "<b>Address :</b> " & Request("address") & ", " & Request("address2") & ", " & 'Request("town") & ", " & Request("postcode") &   "<br>"
'If Request("country") <> "" Then msg=msg & "<b>Country :</b> " & Request("country") & "<br>"
'If Request("tel") <> "" Then msg=msg & "<b>Tel :</b> " & Request("tel") & "<br>"
'If Request("company") <> "" Then msg=msg & "<b>Company :</b> " & Request("company") & "<br>"
'If Request("fax") <> "" Then msg=msg & "<b>Fax :</b> " & Request("fax") & "<br>"
'If Request("advert") <> "" Then msg=msg & "<b>Saw an advertisement in :</b> " & Request("advert") & "<br>"
'If Request("read") <> "" Then msg=msg & "<b>Read an article in :</b> " & Request("read") & "<br>"
'If Request("slept") <> "" Then msg=msg & "<b>Slept in Savoir bed in :</b> " & Request("slept") & "<br>"
'If Request("other") <> "" Then msg=msg & "<b>Other lead :</b> " & Request("other") & "<br>"
'If Request("comments") <> "" Then msg=msg & "<br /><b>Any questions or comments :</b> " & Request("comments") & "<br>"
submit=Request("submit") 
'msg=msg & "</font></body></html>"

If submit<>"" Then 
'If Request("name")=""  then response.Redirect("error.asp")
'If Request("address")=""  then response.Redirect("error.asp")
'If Request("email")=""  then response.Redirect("error.asp")
'Dim objMail, aRecipients
'Set objMail = Server.CreateObject("CDONTS.NewMail")

'objMail.From = "noreply@savoirbeds.fr"
'objMail.To = "pv@savoirbeds.co.uk"
'	objMail.BCC = "info@savoirbeds.co.uk"

'objMail.Subject = "Savoirbeds.fr website - information form completed below" 
'objMail.BodyFormat = 0  
'objMail.MailFormat = 0  
'objMail.Body = msg 
'objMail.Send 

'	Set objMail = Nothing	
	
Set Con = getMysqlConnection()
Set rs = getMysqlUpdateRecordSet("Select * from contact", con)
Do until rs.EOF
If lcase(rs("surname"))=lcase(Request("surname")) Then recordfound=true
rs.movenext
loop
rs.close
set rs=nothing
If recordfound=true then
response.Write("record for this customer already exists")
else
Set rs = getMysqlUpdateRecordSet("Select * from address", con)
rs.AddNew
if request("email") <> "" Then rs("email_address")=Request("email") else rs("email_address")=Null
if request("address1") <> "" Then rs("street1")=Request("address1") else rs("street1")=Null
if request("address2") <> "" Then rs("street2")=Request("address2") else rs("street2")=Null
if request("address3") <> "" Then rs("street3")=Request("address3") else rs("street3")=Null
if request("town") <> "" Then rs("town")=Request("town") else rs("town")=Null
if request("county") <> "" Then rs("county")=Request("county") else rs("county")=Null
if request("postcode") <> "" Then rs("postcode")=Request("postcode") else rs("postcode")=Null
if request("country") <> "" Then rs("country")=Request("country") else rs("country")=Null
if request("tel") <> "" Then rs("tel")=Request("tel") else rs("tel")=Null
if request("fax") <> "" Then rs("fax")=Request("fax") else rs("fax")=Null
if request("company") <> "" Then rs("company")=Request("company") else rs("company")=Null
If Request("source")<>"" then rs("source")=Request("source") else rs("source")=Null
If Request("other")<>"" then rs("source_other")=Request("other") else rs("source_other")=Null
If Request("channel")<>"" then rs("channel")=Request("channel") else rs("channel")=Null
rs("first_contact_date")=Request("contactdate")
rs("source_site")="SB"
rs.Update
id=rs("code")
rs.close
Set rs=nothing
Set rs = getMysqlUpdateRecordSet("Select * from communication", con)
If Request("comments")<> "" Then
rs.AddNew
rs("code")=id
if request("type") <> "" Then rs("type")=Request("type") else rs("type")=Null
if request("surname") <> "" Then rs("person")=Request("title") & Request("surname") else rs("person")=Null
rs("notes")=Request("comments")
rs("source_site")="SB"
rs.Update
End If
rs.close
Set rs=nothing
Set rs = getMysqlUpdateRecordSet("Select * from contact", con)
rs.AddNew
rs("code")=id
if request("title") <> "" Then rs("title")=Request("title") else rs("title")=Null
if request("name") <> "" Then rs("first")=Request("name") else rs("first")=Null
if request("surname") <> "" Then rs("surname")=Request("surname") else rs("surname")=Null
if request("position") <> "" Then rs("position")=Request("position") else rs("position")=Null
rs("source_site")="SB"
rs.Update
rs.close
Set rs=nothing
End If
Con.close
Set Con=nothing	
Response.Redirect ("brochure-added.asp")
End If%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
<script src="scripts/keepalive.js"></script>
</head>
<body>
<form action="search-results.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">
<div class="container">
<!-- #include file="header.asp" -->
	
					  <div class="content brochure">
			    <div class="one-col head-col">
			<p>Search for customers below by filling in relevant criteria:
			<%If msg="n" Then%>
            <font color="#FF0000"><b> Please complete at least one field to obtain information</b></font>
            <%End If%>
            <%If msg="c" Then%>
            <font color="#FF0000"><b> Company name needs to be at least 2 characters long</b></font>
            <%End If%>
            <%If msg="s" Then%>
            <font color="#FF0000"><b> Surname name needs to be at least 5 characters long</b></font>
            <%End If%>
            <%If msg="p" Then%>
            <font color="#FF0000"><b> Postcode name needs to be at least 3 characters long</b></font>
            <%End If%>
            </p><p>&nbsp;</p>
                </div>


		<div class="two-col">
         <%If isSuperuser() or userHasRole("SAVOIRSTAFF") then%>
         <div class="row">
      <label><strong>Select Company</strong><br>
      <input name="sb" type="checkbox" value="SB" <% if retrieveUserSite()="SB" then%>checked<%end if%> > Savoir Beds<br />
 

        </label>
        </div>
		<%else%>
        <input type="hidden" name="site" value="<%=retrieveUserSite()%>" />
        <%end if%>
        <div class="row">
				<label for="surname" id="surname"><strong>Surname</strong><br>
				  <input name="surname" type="text" id="surname" class="text" /></label>
          <br>
        </div>
            <div class="row">	
				<label for="postcode" id="postcode"><strong>Postcode</strong><br>
                <input name="postcode" type="text" id="postcode" class="text" /></label>
		  </div>
           <div class="row">	
				<label for="company" id="company"><strong>Company</strong><br>
                <input name="company" type="text" id="company" class="text" /></label>
		  </div>
          <div class="row">	
				<label for="orderno" id="orderno"><strong>Order No.</strong><br>
                <input name="orderno" type="text" id="orderno" class="text" /></label>
		  </div>
</div>

		<div class="two-col">
        <div class="row">	
				<label for="cref" id="cref"><strong>Customer Ref.</strong><br>
                <input name="cref" type="text" id="cref" class="text" /></label>
		  </div>
		  <div class="row">
        <%if retrieveUserRegion=1 then%>
          <%Set rs = getMysqlQueryRecordSet("Select * from channel Order by channel" , con)%>
		 
          <select name="channel" size="1" class="formtext" id="channel">
            <option value="n">Please enter channel</option>
            <%do until rs.EOF%>
            <option value="<%=rs("channel")%>"><%=rs("channel")%></option>
            <% rs.movenext 
  loop%>
            <%
rs.Close
Set rs = Nothing

%>
          </select>
           
			
				
		  </div>
          <div class="row">
          <%Set rs = getMysqlQueryRecordSet("Select * from contacttype Order by contacttype" , con)%>
		 
          <select name="type" size="1" class="formtext" id="type">
            <option value="n">Please enter type of contact</option>
            <%do until rs.EOF%>
            <option value="<%=rs("contacttype")%>"><%=rs("contacttype")%></option>
            <% rs.movenext 
  loop%>
            <%
rs.Close
Set rs = Nothing

%>
          </select>
           
			
				
		  </div>
           <div class="row">
<%sql="Select * from location"
if not isSuperuser() then
	if userHasRole("SAVOIRSTAFF") then
	    sql=sql & " WHERE owning_region='" & retrieveuserregion() & "'"
		else
		sql=sql & " WHERE idlocation=" & retrieveuserlocation() 
	end if
end if
sql=sql & " Order by location"
'response.Write("sql = " & sql)
'response.Write("<br>superuser = " & isSuperuser())
Set rs = getMysqlQueryRecordSet(sql, con)%>
		 
          <select name="location" size="1" class="formtext" id="location">
            <option value="n">Where customer visited</option>
            <%do until rs.EOF%>
            <option value="<%=rs("location")%>"><%=rs("location")%></option>
            <% rs.movenext 
  loop%>
            <%
rs.Close
Set rs = Nothing

%>
          </select>
           
			
				
		  </div>
          <%end if%>
          <div class="row"></div>
			<div class="row">
	      <input type="submit" name="submit" value="Search Database"  id="submit" class="button" /></div>	
		</div>
	</div>
  </div>
<div>
</div>
        </form>
</body>
</html>
<%Con.Close
Set Con = Nothing
%>
    <script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form1_Validator(theForm)
{
 
   if ((theForm.surname.value == "") && (theForm.postcode.value == "") && (theForm.cref.value == "") && (theForm.orderno.value == "") && (theForm.company.value == "") && (theForm.channel.value == "n") && (theForm.type.value == "n"))
  {
    alert("Please complete one of the fields to obtain results");
    theForm.surname.focus();
    return (false);
  }

if ((theForm.surname.value != "") && (theForm.surname.value.length <2))
  {
    alert("Surname needs to be at least 2 characters long");
    theForm.surname.focus();
    return (false);
  }
if ((theForm.company.value != "") && (theForm.company.value.length <2))
  {
    alert("Company name needs to be at least 2 characters long");
    theForm.company.focus();
    return (false);
  }
    if (((theForm.surname.value != "") || (theForm.postcode.value == "") || (theForm.company.value != "") || (theForm.channel.value != "n") || (theForm.type.value != "n")) && (theForm.orderno.value != ""))
   {
    alert("Only the order number will be returned in this search - any other search criteria entered will be ignored");
    theForm.orderno.focus();
    return (true);
  }
    return true;
} 

//-->
</script>
<!-- #include file="common/logger-out.inc" -->
