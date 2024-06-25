<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #INCLUDE file="utilfuncs2.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #INCLUDE file="orderfuncs.asp" -->
<!-- #INCLUDE file="customerfuncs.asp" -->
<%Dim title, sql, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, recordfound, id, formfield, submit2, emailsallowed, post, basic, emailfound, custcode, rs2, strSelected, showmarketing
showmarketing=""

emailfound=false

submit2=""
submit2=Request("submit2")
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

If submit<>"" OR submit2<>"" Then 
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
If Request("type")<>"" then rs("initial_contact")=Request("type") else rs("initial_contact")=Null
rs("status")=Request("status")
If Request("visitdate")<>"" then rs("visit_date")=Request("visitdate") else rs("visit_date")=Null

If Request("location")<>"n" then rs("visit_location")=Request("location") else rs("visit_location")=Null

rs("first_contact_date")=Date()
rs("owning_region")=retrieveuserregion()
rs("source_site")=Request("site")
rs("price_list")=getDefaultPriceListForLocation(con, retrieveuserlocation())
rs.Update
id=rs("code")
rs.close
Set rs=nothing

Set rs = getMysqlUpdateRecordSet("Select * from communication", con)
If comments<> "" or submit<>"" Then
rs.AddNew
rs("code")=id
if request("submit") <> "" Then rs("type")="Brochure Request (Admin)" else rs("type")=Null
if request("surname") <> "" Then rs("person")=Request("title") & Request("surname") else rs("person")=Null
rs("notes")=Request("comments")
rs("owning_region")=retrieveuserregion()
rs("source_site")=Request("site")
rs("date")=date()
rs.Update
End If
rs.close
Set rs=nothing
Set rs = getMysqlUpdateRecordSet("Select * from contact", con)
rs.AddNew
rs("code")=id
rs("dateadded")=date()
if request("title") <> "" Then rs("title")=Request("title") else rs("title")=Null
if request("name") <> "" Then rs("first")=Request("name") else rs("first")=Null
if request("surname") <> "" Then rs("surname")=Request("surname") else rs("surname")=Null
if request("position") <> "" Then rs("position")=Request("position") else rs("position")=Null
if request("emailsallowed")="y" then rs("acceptemail")="y" else rs("acceptemail")="n"
if request("post")="y" then rs("acceptpost")="y" else rs("acceptpost")="n"
rs("owning_region")=retrieveuserregion()
rs("retire")="n"
rs("idlocation")=retrieveuserlocation()
rs("updatedby")=retrieveusername()
If submit2<>"" Then rs("Brochurerequestsent")=Null
rs("source_site")=Request("site")
rs.Update
Dim contactid
contactid=rs("contact_no")
rs.close
Set rs=nothing
For Each formfield in Request.Form
	if left(formfield, 2) = "XX" then
		con.execute("INSERT INTO INTERESTPRODUCTSLINK (contact_no,product_id) VALUES (" & contactid & "," & trim(request.form(formfield)) & ")")
	end if
Next 

Con.close
Set Con=nothing	
Response.Redirect ("editcust.asp?val=" & contactid)
End If
Set Con = getMysqlConnection()%>

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
<style>
input[type="checkbox"][readonly] {
  pointer-events: none;
}
</style>
</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<form action="brochure.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
    <div class="content brochure">
			    <div class="one-col head-col">
			<p><strong id="docs-internal-guid-6208f503-965b-4d1b-f67c-81fbb9cfdcff">Please enter details of the new customer below</strong>:</p>
			<p>&nbsp;</p>
                </div>


		<div class="two-col">
    
        <input type="hidden" name="site" value="<%=retrieveUserSite()%>" />

        
        <div class="row">
				<label for="title" id="title"><strong>Title</strong><br>
				  <input name="title" type="text" id="title" class="text" /></label>
				  <br>
				  <br>
				  First
				  <label for="name" id="name"><strong> Name</strong><br>
                  <input name="name" type="text" id="name" class="text" />
</label><br>
				  <br>
    <strong>Surname</strong><br />
				<input name="surname" type="text" id="surname" class="text" />
		  </div>


			

			<div class="row">
		    <label for="email" id="email" class="b">Email</label>
				<br />
				<input name="email" type="text" id="email" class="text"  value="<%=Request("email")%>"/>
			</div>

            
			<div class="row">
	      <label for="address1" id="address" class="b">Address</label>
			  <br />
                <input name="address1" type="text" id="address1" value="" size="40" maxlength="120">
              <br>
                <input name="address2" type="text" id="address2" value="" size="40" maxlength="120">
		      <br>
		      <input name="address3" type="text" id="address3" value="" size="40" maxlength="120">
            </div>
<div class="row">
		  <label for="town" id="town" class="b">Town/City</label>
				<br />
                <input name="town" type="text" id="town" value="">
		  </div>
          <div class="row">
		  <label for="county" id="county" class="b">County/State</label>
				<br />
                <input name="county" type="text" id="county" value="">
		  </div>
          <div class="row">
		    <label for="postcode" id="postcode" class="b">Post Code/Zip Code</label>
				<br />
                <%If Request("postcode")<> "" Then%>
                <input name="postcode" type="text" id="postcode" value="<%=Request("postcode")%>"><SCRIPT LANGUAGE=JAVASCRIPT SRC="https://services.postcodeanywhere.co.uk/popups/javascript.aspx?account_code=savoi11112&license_key=tf86-hh48-pc89-wj73"></SCRIPT>
				<%Else%>
                <input name="postcode" type="text" id="postcode" value=""><SCRIPT LANGUAGE=JAVASCRIPT SRC="https://services.postcodeanywhere.co.uk/popups/javascript.aspx?account_code=savoi11112&license_key=tf86-hh48-pc89-wj73"></SCRIPT>
                <%End If%>
			</div>
            <div class="row">
		  <label for="country" id="country" class="b">Country</label>
	               
                  <%
Set rs2 = getMysqlQueryRecordSet("Select * from region where id_region=" & retrieveUserRegion(), con)
Dim countryregion

countryregion=rs2("country")
rs2.close
set rs2=nothing

Set rs2 = getMysqlQueryRecordSet("Select * from countrylist order by country asc", con)%>
				<br />
				   <select name="country" id="country" class="text">
                  
<%Do until rs2.EOF
If countryregion=rs2("country") then 
strSelected="selected"
else
strSelected=""

End If
%>
                   
                   <option value="<%=rs2("country")%>" <%=strSelected%>><%=rs2("country")%></option>
<%rs2.movenext
loop
rs2.close
set rs2=nothing
%></select>
                
                
                
		  </div>
            
     
<div class="row">
			  <label for="tel" id="tel"><strong>Tel</strong></label>
		    <br />
				<input name="tel" type="text" id="tel" class="text" />
		  </div>

			<div class="row">
				<label for="fax" id="fax"><strong>Fax</strong></label>
		    <br />
				<input name="fax" type="text" id="fax" class="text" />
			</div>

			
		<div class="row"><b>Visit Date:</b><br>
            <label>
              <input name="visitdate" type="text" id="visitdate" readonly><a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.visitdate','calendar_window','width=154,height=288');calendar_window.focus()">
      Choose Date
       </a>
            </label>
<br>
          </div>
 <div class="row">
          <%Set rs = getMysqlQueryRecordSet("Select * from location WHERE retire='n' AND owning_region = " & retrieveuserregion() , con)%>
	<b>Visit Location:</b><br /> 	 
  <select name="location" size="1" class="formtext" id="location">
            <option value="n">Please enter visit location</option>
            <%do until rs.EOF
%>
            <option value="<%=rs("idlocation")%>"><%=rs("adminheading")%></option>
            <% rs.movenext 
  loop%>
            <%
rs.Close
Set rs = Nothing

%>
          </select>  
           	
			
		</div>
        

			
			
			
		</div>

		<div class="two-col">
			
			<div class="row">
<%
Set rs = getMysqlQueryRecordSet("Select * from channel where brochurerequest='y'", con)
%><div class="row">

			  <label><b>Interested In:</b><br />
			    <select name="channel" id="channel" class="text" onChange="showHideCompanyField(this)">

<%Do until rs.EOF%>

                   
                   <option value="<%=rs("channel")%>"><%=rs("adminwording")%></option>
<%rs.movenext
loop
rs.close
set rs=nothing
%>
		        </select>
		      </label>
			
				
			</div>
             <div id="company_fields" class="row">
				<label for="company"><b><span id="company_label">Company</span></b></label><br />
				<input name="company" type="text" id="company" class="text" /><br /><br />
                <label for="position"><b>Your Job Title</b></label><br />
				<input name="position" type="text" id="position" class="text" />
			</div>	
		<div class="row">
        	<label for="where" class="b">Where did you hear about us?</label><br>
			  <label>
			    <select name="where" id="where" class="text" onChange="javascript:populateSourceDropdown(this)">
			      ' these values must be in the SOURCE column of the SOURCE table & MUST NOT include spaces
			      ' remember to keep the other list in brochure_source.asp up to date
			       <option value=""></option>
                   <option value="Advertising">Saw advertisement in</option>
			      <option value="Editorial">Read article in</option>
			      <option value="Hotel">Slept on a Savoir at</option>
			      <option value="Internet">Internet Search</option>
			      <option value="recommendation">Recommendation</option>
			      <option value="other">Other</option>
		        </select>
		      </label><br />
			<div id="source_div" /></div>
</div>
           
<div class="row">
			  <label for="other" id="other"><strong>If none of the sources above - state here where heard, seen about us.</strong></label>
    <br />
				<input name="other" type="text" id="other" class="text" />
		  </div>
            <div class="row">
			  <label for="products" id="products"><strong>Which of the following products are you interested in</strong><br /></label>
    <br /> <%Set rs = getMysqlQueryRecordSet("Select * from interestproducts WHERE Source_Site='SB'" , con)%>
    <b>Savoir Beds</b><br />
		<%do until rs.EOF%>
          <input name="XX<%=rs("id")%>" type="checkbox" value="<%=rs("id")%>">
          <%=rs("product")%><br>
          <%
          rs.movenext 
loop 
%>
          <%rs.Close
Set rs = Nothing

%>
			</div>
<div class="row">
	  <label for="comments" id="comments" class="b">Any questions or comments?</label>
			  <br />
				<textarea name="comments" rows="2" cols="20" id="comments"></textarea>
		  </div>
            <div class="row"><hr /><br />
              <b>Admin:
            </b><br>
         
          <%Set rs = getMysqlQueryRecordSet("Select * from contacttype WHERE retired='n' Order by contacttype" , con)%>
		 
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
          <%Set rs = getMysqlQueryRecordSet("Select * from status WHERE retired='n' Order by seq, status" , con)%>
		 <b>Status:</b><br>
          <select name="status" size="1" class="formtext" id="status">
            <%do until rs.EOF%>
            <option value="<%=rs("status")%>"><%=rs("status")%></option>
            <% rs.movenext 
  loop%>
            <%
rs.Close
Set rs = Nothing

%>
          </select>
           
			
			</p>	
		  </div>
          <div class="row"> Marketing Correspondence<br>
           <br><%if retrieveuserlocation()=1 then showmarketing="" else showmarketing="readonly"%>
           <input type="checkbox" name="post" value="y" id="post" checked <%=showmarketing%> /> <label for="post">Customer accepts postal marketing (tick if yes)<br>
           </label>
         </label>
         <div class="clear"></div>
        
         <input type="checkbox" name="emailsallowed" value="y" id="emailsallowed" checked  <%=showmarketing%> />
         Customer accepts email marketing (tick if yes)</div>
          <div class="row"></div>
			<div class="row">
			  <input type="submit" name="submit2" value="Add to database only"  id="submit2" class="button" />
	      <input type="submit" name="submit" value="Add Brochure Request to database"  id="submit" class="button" /></div>	
		</div>
	</div>
    <p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
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
     window.onload = init();
	function init() {
		populateSourceDropdown(document.form1.where);
		showHideCompanyField(document.form1.channel);
	};
	
	function populateSourceDropdown(e) {
		var url = "brochure_source.asp?sg="+e.options[e.selectedIndex].value + "&txt=" + encodeURI(e.options[e.selectedIndex].text)+ "&ts=" + (new Date()).getTime();
		//alert("url = " + url);
		$('#source_div').load(url);
	}
	
	function showHideCompanyField(e) {
		if (e.options[e.selectedIndex].value == 'Direct') {
			$("#company_fields").hide("fast");
		} else {
			$("#company_fields").show("fast");
		}

		if (e.options[e.selectedIndex].value == 'Hotel') {
			$("#company_label").html("Hotel Name");
		} else {
			$("#company_label").html("Company");
		}
	}
	
	function IsNumeric(sText)
	{
	   var ValidChars = "0123456789";
	   var IsNumber=true;
	   var Char;
	
	 
	   for (i = 0; i < sText.length && IsNumber == true; i++) 
		  { 
		  Char = sText.charAt(i); 
		  if (ValidChars.indexOf(Char) == -1) 
			 {
			 IsNumber = false;
			 }
		  }
	   return IsNumber;
	   
	   }

	function validEmail(email) {
		invalidChars = " /:,;"
		if (email == "") {
			return false
		}
		for (i=0; i<invalidChars.length; i++) {
			badChar = invalidChars.charAt(i)
			if (email.indexOf(badChar,0) > -1) {
				return false
			}
		}
		atPos = email.indexOf("@",1)
		if (atPos == -1) {
			return false
		}
		if (email.indexOf("@",atPos+1) > -1) {
			return false
		}
		periodPos = email.indexOf(".",atPos)
		if (periodPos == -1) {
			return false
		}
		if (periodPos+3 > email.length) {
			return false
		}
		return true
	}
function FrontPage_Form1_Validator(theForm)
{
   
   if (theForm.surname.value == "")
  {
    alert("Please enter surname");
    theForm.surname.focus();
    return (false);
  }

 

	if (!validEmail(theForm.email.value)) {
		alert("invalid email address - please re-enter")
		theForm.email.focus()
		theForm.email.select()
		return false
	}
  

    return true;
} 

//-->
</script>

<%

function capitalise(str)
dim words, word
if isNull(str) or trim(str)="" then
	capitalise=""
else
	words = split(trim(str), " ")
	for each word in words
		word = lcase(word)
		word = ucase(left(word,1)) & (right(word,len(word)-1))
		capitalise = capitalise & word & " "
	next
	capitalise = left(capitalise, len(capitalise)-1)
end if

end function

%>
<!-- #include file="common/logger-out.inc" -->
