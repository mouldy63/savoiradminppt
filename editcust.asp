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
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="utilfuncs2.asp" -->
<!-- #include file="customerfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, recordfound, id, formfield, val, rs1, rs2, rs3, checked, i, addresscode, dispcustheaderdetails, submitbr, site, owningregion, submitdb, retiredversion, wrongaddress, screenmessage
dim listPriceVal, tmpListPriceVal, tradeDiscountRate, telwork, mobile, orderTotals, orderTotalsForYear, totalsString, totalsForYearString, vals, deladdress, sql, z, preferredshipper, selectedA, slected, complete, nextpage
dim userLocTestStr
Dim addcontact1title, addcontact1name, addcontact1surname, addcontact1tel, addcontact1mobile, addcontact1email,addcontact1pos, removecontact1
Dim addcontact2title, addcontact2name, addcontact2surname, addcontact2tel, addcontact2mobile, addcontact2email,addcontact2pos, removecontact2, fieldName, pid
Dim nextarray(), custcode, differentfollowup, currentactivedate, customertype, showmarketing, reqVip, showVipBox, isVipCandidate
showmarketing=""
customertype=""
customertype=request("customertype")
removecontact1=""
removecontact2=""
removecontact1=request("removecontact1")
removecontact2=request("removecontact2")
addcontact1title=request("addcontact1title")
addcontact1name=request("addcontact1name")
addcontact1surname=request("addcontact1surname")
addcontact1tel=request("addcontact1tel")
addcontact1mobile=request("addcontact1mobile")
addcontact1email=request("addcontact1email")
addcontact1pos=request("addcontact1pos")


addcontact2title=request("addcontact2title")
addcontact2name=request("addcontact2name")
addcontact2surname=request("addcontact2surname")
addcontact2tel=request("addcontact2tel")
addcontact2mobile=request("addcontact2mobile")
addcontact2email=request("addcontact2email")
addcontact2pos=request("addcontact2pos")

preferredshipper=request("preferredshipper")
screenmessage=""
screenmessage=Request("msg")
wrongaddress=Request("wrongaddress")
retiredversion="y"
submitdb=Request("submitdb")
submitbr=Request("submitbrochure")
nextpage=Request("nextpage")
dispcustheaderdetails=""
val=Request("val")
Session("custval")=Request("val")
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
'Set Con = getMysqlConnection()
Set rs = getMysqlQueryRecordSet("Select * from contact WHERE Contact_no=" & val, con)
site=rs("source_site")
owningregion=rs("owning_region")
preferredshipper=rs("PreferredShipper")
rs.close
set rs=nothing
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

'msg=msg & "</font></body></html>"

If submitdb<>"" OR submitbr<>"" or nextpage<> "" Then 
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
if addcontact1title<>"" or addcontact1name<>"" or addcontact1surname<>"" then	
Set rs = getMysqlUpdateRecordSet("Select * from contact WHERE parent_contact_no=" & val & " AND AdditionalContactSeq=1", con)
	if not rs.eof then
		rs("title")=addcontact1title
		rs("first")=addcontact1name
		rs("surname")=addcontact1surname
		rs("telwork")=addcontact1tel
		rs("mobile")=addcontact1mobile
		rs("AdditionalContactEmail")=addcontact1email
		rs("position")=addcontact1pos
		rs.Update
		
	else
		rs.close
		set rs=nothing
		Set rs = getMysqlUpdateRecordSet("Select * from contact", con)
		rs.AddNew
		rs("AdditionalContactSeq")=1
		rs("parent_contact_no")=val
		rs("title")=addcontact1title
		rs("first")=addcontact1name
		rs("surname")=addcontact1surname
		rs("telwork")=addcontact1tel
		rs("mobile")=addcontact1mobile
		rs("AdditionalContactEmail")=addcontact1email
		rs("position")=addcontact1pos
		rs.Update
	end if
rs.close
set rs=nothing
end if


if addcontact2title<>"" or addcontact2name<>"" or addcontact2surname<>"" then	
Set rs = getMysqlUpdateRecordSet("Select * from contact WHERE parent_contact_no=" & val & " AND AdditionalContactSeq=2", con)
	if not rs.eof then
		rs("title")=addcontact2title
		rs("first")=addcontact2name
		rs("surname")=addcontact2surname
		rs("telwork")=addcontact2tel
		rs("mobile")=addcontact2mobile
		rs("AdditionalContactEmail")=addcontact2email
		rs("position")=addcontact2pos
		if removecontact1="y" and removecontact2="" then rs("AdditionalContactSeq")=1
		rs.Update
		
	else
		rs.close
		set rs=nothing
		Set rs = getMysqlUpdateRecordSet("Select * from contact", con)
		rs.AddNew
		rs("AdditionalContactSeq")=2
		rs("parent_contact_no")=val
		rs("title")=addcontact2title
		rs("first")=addcontact2name
		rs("surname")=addcontact2surname
		rs("telwork")=addcontact2tel
		rs("mobile")=addcontact2mobile
		rs("AdditionalContactEmail")=addcontact2email
		rs("position")=addcontact2pos
		rs.Update
	end if
rs.close
set rs=nothing
end if

if removecontact1="y" then
	Set rs = getMysqlUpdateRecordSet("Select * from contact WHERE parent_contact_no=" & val & " AND AdditionalContactSeq=1", con)
	rs.delete
	rs.close
	set rs=nothing
end if

if removecontact2="y" then
	Set rs = getMysqlUpdateRecordSet("Select * from contact WHERE parent_contact_no=" & val & " AND AdditionalContactSeq=2", con)
	rs.delete
	rs.close
	set rs=nothing
end if

Set rs = getMysqlUpdateRecordSet("Select * from contact WHERE Contact_no=" & val, con)
addresscode=rs("code")
if (customertype<>"" and customertype<>"n") then rs("customertype")=customertype else rs("customertype")=Null
if request("telwork")<>"" then rs("telwork")=Request("telwork") else rs("telwork")=Null
if request("mobile")<>"" then rs("mobile")=Request("mobile") else rs("mobile")=Null
if request("title") <> "" Then rs("title")=Request("title") else rs("title")=Null
if request("name") <> "" Then rs("first")=Request("name") else rs("first")=Null
if request("surname") <> "" Then rs("surname")=Request("surname") else rs("surname")=Null
if request("position") <> "" Then rs("position")=Request("position") else rs("position")=Null
if request("company_vat_no") <> "" Then rs("company_vat_no")=trim(Request("company_vat_no")) else rs("company_vat_no")=Null
If request("acceptpost")="y" Then rs("acceptpost")="y" else rs("acceptpost")="n"
If request("acceptemail")="y" Then rs("acceptemail")="y" else rs("acceptemail")="n"
if request("acceptemail")="" or request("acceptemail")="n" then 
	rs("isVIP")="n" 
	rs("isVIPmanuallyset")="n"
end if
if request("preferredshipper")<>"" then rs("preferredshipper")=request("preferredshipper")

reqVip = "n"
if request("vip") = "y" then reqVip = "y"
if rs("isVIP") <> reqVip then
	rs("isVIPmanuallyset")="y"
	response.write("<br>manually set")
else
	response.write("<br>not manually set")
end if
rs("isVIP") = reqVip
'rs("Updatedby")=retrieveUserFullName()
'rs("dateupdated")=date()
tradeDiscountRate = request("tradediscountrate")
if tradeDiscountRate = "" or not isNumeric(tradeDiscountRate) then
	tradeDiscountRate = 0
else
	tradeDiscountRate = cint(tradeDiscountRate)
end if
rs("tradediscountrate") = tradeDiscountRate

rs.Update
Dim contactid
contactid=rs("contact_no")
rs.close
Set rs=nothing

'response.write("<br>addresscode=" & addresscode)
Set rs = getMysqlUpdateRecordSet("Select * from address WHERE Code=" & addresscode, con)
If wrongaddress<>"" then rs("wrongaddress")="y" else rs("wrongaddress")="n"

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
If Request("Status")<>"" then rs("Status")=Request("Status") else rs("Status")=Null
If Request("Initialcontact")<>"" then rs("initial_contact")=Request("Initialcontact") else rs("initial_contact")=Null

response.write("<br>initialcontactdate=" & Request("initialcontactdate"))
response.write("<br>lastcontactdate=" & Request("lastcontactdate"))
response.write("<br>visitdate=" & Request("visitdate"))
If Request("initialcontactdate")<>"" then rs("first_contact_date")=Request("initialcontactdate") else rs("first_contact_date")=date()
If Request("lastcontactdate")<>"" then rs("last_contact_date")=Request("lastcontactdate")
If trim(Request("visitdate"))<>"" and len(trim(Request("visitdate")))>0 then 
rs("VISIT_DATE")=Request("visitdate") 
end if
If Request("location")<>"" then rs("visit_location")=Request("location") else rs("visit_location")=Null
If Request("pricelist")<>"" then rs("price_list")=Request("pricelist") else rs("price_list")=Null

rs.Update
id=rs("code")
rs.close
Set rs=nothing


Set rs2= getMysqlUpdateRecordSet("Select * from interestproductslink WHERE contact_no=" & contactid, con)
If rs2.EOF then
Else
Do while NOT rs2.EOF
rs2.delete
rs2.MoveNext
Loop
End If
rs2.close
set rs2 = nothing

If  Request("commnote")<>"" OR Request("commnextdate")<>"" Then
Set rs = getMysqlUpdateRecordSet("Select * from communication", con)
rs.AddNew
rs("code")=id
rs("date")=toDbDateTime(cdate(request("commdate")))
if request("commtype") <> "n" Then rs("type")=Request("commtype") else rs("type")=Null
if request("commstatus") <> "n" Then rs("commstatus")=Request("commstatus")
if request("commperson") <> "" Then rs("person")=Request("commperson") else rs("person")=Null
rs("staff")=retrieveUserName()
rs("notes")=Request("commnote")
If Request("commnextdate") <> "" Then rs("next")=Request("commnextdate")
rs("source_site")=site
rs("owning_region")=owningregion
rs.Update
rs.close
Set rs=nothing
End If

'update delivery addresses
if request("cpcount")>1 then
	dim deliveryAddressId
	Set rs = getMySqlQueryRecordSet("Select * from delivery_address WHERE Contact_no=" & val, con)
	
	while not rs.eof
	    deliveryAddressId = rs("delivery_address_id")
	    set rs2 = getMySqlUpdateRecordSet("select * from delivery_address where delivery_address_id=" & deliveryAddressId, con)
		rs2("delivery_name")=request("deliverydeliveryname_" & deliveryAddressId )
		rs2("add1") = request("deliveryadd1_" & deliveryAddressId )
		rs2("add2") = request("deliveryadd2_" & deliveryAddressId )
		rs2("add3") = request("deliveryadd3_" & deliveryAddressId )
		rs2("town") = request("deliverytown_" & deliveryAddressId )
		rs2("countystate") = request("deliverycounty_" & deliveryAddressId )
		rs2("postcode") = request("deliverypostcode_" & deliveryAddressId )
		rs2("country") = request("deliverycountry_" & deliveryAddressId )
		rs2("contact") = request("deliverycontact1_" & deliveryAddressId )
		rs2("contact2") = request("deliverycontact2_" & deliveryAddressId )
		rs2("contact3") = request("deliverycontact3_" & deliveryAddressId )
		rs2("contacttype1") = request("contacttype1_" & deliveryAddressId )
		rs2("contacttype2") = request("contacttype2_" & deliveryAddressId )
		rs2("contacttype3") = request("contacttype3_" & deliveryAddressId )
		rs2("phone") = request("deliverytel_" & deliveryAddressId )
		rs2("phone2") = request("deliverytel2_" & deliveryAddressId )
		rs2("phone3") = request("deliverytel3_" & deliveryAddressId )
		if request("deliveryretire_" & deliveryAddressId ) = "y" then rs2("retire")="y" else rs2("retire")="n"
	    rs2.update
	    rs2.close
	    rs.movenext
	wend
	rs.close 
	set rs=nothing
end if
'end update delivery addresses

'set new delivery address
if request("maindeliveryaddress")<>"" then 
	Con.execute("update delivery_address set isdefault='n' where contact_no=" & val )
	Con.execute("update delivery_address set isdefault='y' where delivery_address_id=" & request("maindeliveryaddress") )
end if

For i = 1 To Request.Form.Count
	differentfollowup="n"
	currentactivedate=""
	fieldName = Request.Form.Key(i)
	If left(fieldName, 11) = "nextactive_" Then
		pid=right(fieldName, len(fieldName)-11)
		sql="Select * from communication where communication=" & pid
		Set rs2 = getMysqlUpdateRecordSet(sql, con)
		currentactivedate=rs2("next")
		'response.Write("currentactivedate=" & currentactivedate)
		'response.End()
		if rs2("next")<>CDate(request("nextactive_" & pid)) then
		differentfollowup="y"
		end if
		rs2("next")=request("nextactive_" & pid)
		if differentfollowup="y" and request("responseactive_" & pid)="" then
		rs2("response")="(Follow up date changed) " & retrieveusername() & " - " & now() & "<br /><br />" & rs2("response")
		end if
		rs2.Update
		rs2.close
		set rs2=nothing
	end if
	next


For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 12) = "notesactive_" Then
		pid=right(fieldName, len(fieldName)-12)
		if request("notesactive_" & pid)<>"" then
			sql="Select * from communication where communication=" & pid
			Set rs2 = getMysqlUpdateRecordSet(sql, con)
			if not rs2.eof then
			rs2("notes")=request("notesactive_" & pid)
			rs2("response")=rs2("response") & "<br />" & retrieveUserName() & "-" & date() & "<br />" & rs2("response")
			rs2.Update
			end if
			rs2.close
			set rs2=nothing
		end if
	end if
	next
	
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 15) = "responseactive_" Then
		pid=right(fieldName, len(fieldName)-15)
		if request("responseactive_" & pid)<>"" then
			sql="Select * from communication where communication=" & pid
			Set rs2 = getMysqlUpdateRecordSet(sql, con)
			if not rs2.eof then
			rs2("response")=request("responseactive_" & pid) & "<br />" & retrieveUserName() & "-" & date() & "<br /><br />" & rs2("response")
			rs2.Update
			end if
			rs2.close
			set rs2=nothing
		end if
	end if
	next
	
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 17) = "commstatusActive_" Then
		pid=right(fieldName, len(fieldName)-17)
		sql="Select * from communication where communication=" & pid
		Set rs2 = getMysqlUpdateRecordSet(sql, con)
		if request("commstatusActive_" & pid)=rs2("commstatus") then 
		else
			rs2("commstatus")=request("commstatusActive_" & pid)
			if (request("commstatusActive_" & pid)="Completed" or request("commstatusActive_" & pid)="Cancelled") then 
				rs2("CompletedDate")=now() 
				rs2("CommCompletedBy")=retrieveUserName()
			end if
		end if
		rs2.Update
		rs2.close
		set rs2=nothing
	end if
	next

if request("deliveryname")<>"" or request("deliveryadd1")<>"" or request("deliverytown")<>"" or request("deliverycounty")<>"" then
	Set rs = getMysqlUpdateRecordSet("Select * from delivery_address", con)
	rs.AddNew
	rs("contact_no")=val
	rs("delivery_name")=request("deliveryname")
	rs("add1")=request("deliveryadd1")
	rs("add2")=request("deliveryadd2")
	rs("add3")=request("deliveryadd3")
	rs("town")=request("deliverytown")
	rs("countystate")=request("deliverycounty")
	rs("postcode")=request("deliverypostcode")
	rs("country")=request("deliverycountry")
	rs("contact")=request("deliverycontact")
	rs("contact2")=request("deliverycontact2")
	rs("contact3")=request("deliverycontact3")
	rs("contacttype1")=request("contacttype1")
	rs("contacttype2")=request("contacttype2")
	rs("contacttype3")=request("contacttype3")
	rs("phone")=request("deliverytel")
	rs("phone2")=request("deliverytel2")
	rs("phone3")=request("deliverytel3")
	if request("maindeliveryaddress1")="y" then 
		Con.execute("update delivery_address set isdefault='n' where contact_no=" & val )
		rs("ISDEFAULT")="y"
	else 
		rs("ISDEFAULT")="n"
	end if
	rs.update
	rs.close
	set rs=nothing
end if
'delivery end

If request("submitbrochure")<>"" Then
Set rs = getMysqlUpdateRecordSet("Select * from contact WHERE Contact_no=" & val, con)
rs("brochurerequestsent")="n"
rs.update
rs.close
set rs=nothing
End If
For Each formfield in Request.Form
	if left(formfield, 2) = "XX" then
		con.execute("INSERT INTO INTERESTPRODUCTSLINK (contact_no,product_id) VALUES (" & contactid & "," & trim(request.form(formfield)) & ")")
	end if
Next 

Con.close
Set Con=nothing	
if nextpage <> "" then
	Response.Redirect(nextpage)
else
Response.Redirect ("customer-updated.asp")
end if
End If
Set Con = getMysqlConnection()
Set rs = getMysqlQueryRecordSet("Select * from contact WHERE Contact_no=" & val, con)
custcode=rs("code")
rs.close
set rs=nothing
Dim nextcount
nextcount=0
Set rs = getMysqlQueryRecordSet("Select * from communication WHERE code=" & custcode, con)
if not rs.eof then
Do until rs.eof
nextcount=nextcount+1
redim preserve nextarray(nextcount)
nextarray(nextcount)=rs("communication")
rs.movenext
loop
end if
rs.close
set rs=nothing
userLocTestStr = "," & retrieveuserlocation() & ","

' check if customer meets VIP status
Set rs = getMysqlUpdateRecordSet("Select * from contact WHERE Contact_no=" & val, con)
showVipBox = false
isVipCandidate = "n"
if rs("customertype")=1 and rs("acceptemail")="y" and (rs("idlocation")=3 OR rs("idlocation")=4 OR rs("idlocation")=36 OR rs("idlocation")=48) then
	showVipBox = true
	if rs("isVIPmanuallyset")="n" then
		orderTotals = getVIPCustomerOrdersTotal(con, rs("contact_no"))
		totalspend = 0
		for i = 1 to ubound(orderTotals)
			vals = split(orderTotals(i), ":")
			if vals(0)="GBP" then
				totalspend=vals(1)
			end if
		next
		if totalspend > 19998 then 
			rs("isvip") = "y"
			isVipCandidate = "y"
		else
			rs("isvip") = "n"
		end if
		rs.Update
	end if
end if
rs.close
set rs=nothing
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="css/jquery-confirm.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="scripts/keepalive.js"></script>
<script src="SpryTabbedPanels.js" type="text/javascript"></script>
<link href="SpryTabbedPanels.css" rel="stylesheet" type="text/css">
<script src="SpryAssets/SpryURLUtils.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.2.3/jquery-confirm.min.css">
<script src="scripts/jquery-confirm.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-powertip/1.2.0/jquery.powertip.min.js" integrity="sha512-fB6Pu241Qezb2hxUhQCKYoo3cmZwfY8AQyCaWBQ1NjA6b2IFXp+5wTB6ONsUucd3jXdn7GiTEToxy52v0jrpVw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-powertip/1.2.0/css/jquery.powertip-dark.css" integrity="sha512-CS3URA90MiFxS2kV7BX0USw/1WdwSXOQA2aFwHRfuJVQP8Ku4SBoNAfUZlVuq++8p8p5V4SRjs53BVaJvQMVgA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script>
$(function() {
var year = new Date().getFullYear();
$( "#commnextdate" ).datepicker({
changeMonth: true,
yearRange: year + ":+2",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#commnextdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#initialcontactdate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#initialcontactdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#visitdate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#visitdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#lastcontactdate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#lastcontactdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#contactagain" ).datepicker({
changeMonth: true,
yearRange: year + ":+2",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#contactagain" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
<%for i = 1 to nextcount%>
$( "#nextactive_<%=nextarray(i)%>" ).datepicker({
changeMonth: true,
yearRange: year + ":+2",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#nextactive_<%=nextarray(i)%>" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
<%next%>
});



</script>


<script src="SpryAssets/SpryCollapsiblePanel.js" type="text/javascript"></script>
<link href="SpryAssets/SpryCollapsiblePanel.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="SpryAssets/SpryURLUtils.js"></script>
<script type="text/javascript">
var params = Spry.Utils.getLocationParamsAsObject();
</script>
<style type="text/css">
.overdue {
	background-color:rgba(255,0,0,0.1);}
  .arrow {
    width: 70px;
    height: 16px;
    overflow: hidden;
    position: absolute;
    left: 50%;
    margin-left: -35px;
    bottom: -16px;
  }
  .arrow.top {
    top: -16px;
    bottom: auto;
  }
  .arrow.left {
    left: 20%;
  }
  .arrow:after {
    content: "";
    position: absolute;
    left: 20px;
    top: -20px;
    width: 25px;
    height: 25px;
    box-shadow: 6px 5px 9px -9px black;
    -webkit-transform: rotate(45deg);
    -ms-transform: rotate(45deg);
    transform: rotate(45deg);
  }
  .arrow.top:after {
    bottom: -20px;
    top: auto;
  }
  .jconfirm.jconfirm-white .jconfirm-box, .jconfirm.jconfirm-light .jconfirm-box {
	  font-family:"Trebuchet MS",Arial,Verdana,San serif !important;
	  margin-right:40% !important;
	  }
.jconfirm.jconfirm-white .jconfirm-box .jconfirm-buttons button.btn-default, .jconfirm.jconfirm-light .jconfirm-box .jconfirm-buttons button.btn-default {
	font-size:14px !important;}
.jconfirm.jconfirm-white .jconfirm-box .jconfirm-buttons, .jconfirm.jconfirm-light .jconfirm-box .jconfirm-buttons {
	float:none !important;
	text-align:center !important;
	font-size:12px !important;
	font-style:normal !important;}
.jconfirm .jconfirm-box .jconfirm-buttons button {
	font-size:12px !important;}
.jconfirm .jconfirm-box div.jconfirm-title-c {font-size:14px !important;}
input[type="checkbox"][readonly] {
  pointer-events: none;
}
#placement-examples div {
    text-align: center;
}
#placement-examples input {
    background-color: #EEE;
    margin: 10px;
    padding: 10px 30px;
}
  </style>
  <link rel="stylesheet" href="font-awesome-4.7.0/css/font-awesome.min.css">
</head>
<body>



<div class="container">
<!-- #include file="header.asp" -->
<form action="editcust.asp" method="post" name="form1" id="form1" onSubmit="return FrontPage_Form1_Validator(this)">
<input type="hidden" name="nextpage" id="nextpage" value="" />
<%
Set rs = getMysqlUpdateRecordSet("Select * from contact WHERE Contact_no=" & val, con)
Set rs1 = getMysqlQueryRecordSet("Select * from address WHERE Code=" & rs("code"), con)
Dim customerLocation, VIPcustomer, totalspend, chked
VIPcustomer=rs("isVIP")

customerLocation=rs("idlocation")
Session("title")=rs("title")
Session("firstname")=rs("first")
Session("surname")=rs("surname")
Session("add1")=rs1("street1")
Session("add2")=rs1("street2")
Session("add3")=rs1("street3")
Session("town")=rs1("town")
Session("county")=rs1("county")
Session("postcode")=rs1("postcode")
Session("country")=rs1("country")
dispcustheaderdetails=rs("title") & " " & rs("first") & " " & rs("surname") & " " & rs1("street1") & " "  & rs1("postcode") & "&nbsp;&nbsp;&nbsp;&nbsp;" & rs1("tel") & "&nbsp;&nbsp;&nbsp;&nbsp;"
If rs("acceptemail")="y" then dispcustheaderdetails=dispcustheaderdetails & " Email: <a href=""mailto:" & rs1("email_address") & """>" & rs1("email_address") & "</a>"
If rs("acceptpost")="n" then dispcustheaderdetails=dispcustheaderdetails & " <font color=""red"">NO MARKETING BY POST</font>"
If rs("acceptemail")="n" then dispcustheaderdetails=dispcustheaderdetails & " <font color=""red"">NO MARKETING BY EMAIL</font>"
'If rs("updatedby")<>"" then dispcustheaderdetails=dispcustheaderdetails & " | Last updated by " & rs("updatedby") & " on " & rs("dateupdated")

listPriceVal = oldToNewPriceListVal(rs1("price_list"))
%>

<%

orderTotals = getCustomerOrdersTotal(con, rs("contact_no"))
totalsString = "Total spend: <b>"
for i = 1 to ubound(orderTotals)
	if i > 1 then totalsString = totalsString & "&nbsp;&nbsp;"
	vals = split(orderTotals(i), ":")
	totalsString = totalsString & fmtCurrNonHtml(vals(1), true, vals(0)) & " (Ex VAT " & fmtCurrNonHtml(vals(2), true, vals(0)) & ")"
next
if ubound(orderTotals) = 0 then totalsString = totalsString & "NONE"
totalsString = totalsString & "</b>"

orderTotalsForYear = getCustomerOrdersTotalCurrentYear(con, rs("contact_no"))
totalsForYearString = "Calendar Year spend: <b>"
for i = 1 to ubound(orderTotalsForYear)
	if i > 1 then totalsForYearString = totalsForYearString & "&nbsp;&nbsp;"
	vals = split(orderTotalsForYear(i), ":")
	totalsForYearString = totalsForYearString & fmtCurrNonHtml(vals(1), true, vals(0)) & " (Ex VAT " & fmtCurrNonHtml(vals(2), true, vals(0)) & ")"
next
if ubound(orderTotalsForYear) = 0 then totalsForYearString = totalsForYearString & "NONE"
totalsForYearString = totalsForYearString & "</b>"

%>  

					  <div class="content brochure">
			    <div class="one-col head-col">
                <div class="whitebox"><b><%response.Write(dispcustheaderdetails)%>
                </b>
                <div class="justifyright"><a href="print2.asp?val=<%=rs("code")%>"><strong>Print Label</strong></a><strong> |  
                
                    <label>Print Letter</label>
                </strong>
                <label>
<select onChange="window.open(this.options[this.selectedIndex].value,'_parent')" name="corresid" id="corresid">
               <option value="n">None</option>
                         <%
Set rs3 = getMysqlQueryRecordSet("Select * from correspondence WHERE owning_region=" & retrieveUserRegion() & "", con)


Do until rs3.eof%>
   <option value="print2a.asp?val2=<%=rs("code")%>&corresid=<%=rs3("correspondenceid")%>"><%=rs3("correspondencename")%></option>
   <%rs3.movenext
   loop
   rs3.close
   set rs3=nothing
   %>
            </select>
            </label></div></div><div class="clear"></div>
		<div id="floatright"><input type="submit" name="submitbrochure" value="Brochure Request"  id="submitbrochure" class="button" /><br /><input type="submit" name="submitdb" value="Save Changes"  id="submitdb" class="button" /><br />
		<%If retrieveuserregion()=1 or retrieveuserlocation=8 or retrieveuserlocation()=14 or retrieveuserlocation()=37 or retrieveuserlocation()=34 or retrieveuserlocation()=17 or retrieveuserlocation()=31 or retrieveuserlocation()=33 or retrieveuserlocation()=38 or retrieveuserlocation()=39 or retrieveuserlocation()=35 or retrieveUserRegion=17 or retrieveuserlocation=25 or retrieveuserlocation=24  or retrieveUserRegion=19 or retrieveuserlocation=40  or retrieveuserlocation=41 or retrieveuserlocation=51 then%>  <label>
		    <select name="orderquote" id="orderquote" onChange="return orderQuoteChangeHandler2();">
		      <option value="0">Please select</option>
              <%if retrieveuserid()=82 then%>
              <option value="add-oldorder.asp?contact_no=<%=val%>&e1=y&quote=n" class="neworder">New Order</option>
              <%elseif  retrieveuserregion()=1 then%>
		      <option value="add-order.asp?contact_no=<%=val%>&e1=y&quote=n">New Order</option>
              <%else%>
               <option value="add-order.asp?contact_no=<%=val%>&e1=y&quote=n&overseas=y">New  Order</option>
              <%end if%>
             <%end if
			 If retrieveuserLocation()=1 and retrieveuserid()<>82 then%>
             <option value="add-order.asp?contact_no=<%=val%>&e1=y&quote=n&overseas=y">New Overseas Order</option>
             <%end if
			 If (retrieveuserRegion()=1 or retrieveuserlocation()=34 or retrieveuserlocation()=24 or retrieveuserlocation()=17 or retrieveuserlocation()=39 or retrieveuserlocation()=37) and retrieveuserid()<>82 then%>
              <option value="add-order.asp?contact_no=<%=val%>&e1=y&quote=y">New Quote</option>
              <%end if%>
              <option value="cusrecord-csv.asp?val=<%=val%>">Download CSV</option>
	        </select>
            
	      </label>
          <script type="text/javascript">
                                $('.orderquote').on('select', function () {
                                    $.confirm({
                                        title: 'Any changes you made to the customer details will be saved first. Please confirm.',
                                        content: 'Customer Order',
                                        buttons: {
                                            yes: function () {
                                                $("#form1").submit();
                                            },
                                            no: function () {
                                            }
                                        }
                                    });
                                });
                            </script>
		</div>
        <%If screenmessage<>"" then response.write("<font color=red>Email of quote has been sent</font>")%>	
        <p>Edit all customer details here using the tabs below and finally clicking on <br>
		  the Update Customer Record Button at the bottom of the page:<br>
			  <span class="row">
			  
			  </span></p>
			<div id="TabbedPanels1" class="TabbedPanels">
			  <ul class="TabbedPanelsTabGroup">
			    <li class="TabbedPanelsTab" tabindex="0">Contact Details</li>
			    <li class="TabbedPanelsTab" tabindex="0">Customer Information/Source</li>
                <li class="TabbedPanelsTab" tabindex="0">Orders & Quotes</li>
                <li class="TabbedPanelsTab" tabindex="0">Delivery Addresses</li>
                <li class="TabbedPanelsTab" tabindex="0">Correspondence/Notes</li>
               <li class="TabbedPanelsTab" tabindex="0">Additional Contacts</li>
		      </ul>
			  <div class="TabbedPanelsContentGroup">
			    <div class="TabbedPanelsContent">
<div class="two-col"><br />
<div class="row">
		  <label for="title" id="title"><strong>Title</strong><br>
		    <input name="title" type="text" class="text" id="title" value="<%=rs("title")%>" /></label>
				  <br>
				  <br>
		  <label for="name" id="name">
                  <strong>First Name</strong><br>
            <input name="name" type="text" class="text" id="name" value="<%=rs("first")%>" />
</label><br>
				  <br>
    <strong>Surname</strong><br />
				<input name="surname" type="text" class="text" id="surname" value="<%=rs("surname")%>" />
		  </div>


			

			<div class="row">
		    <label for="email" id="email" class="b">Email</label>
				<br />
				<input name="email" type="text" class="text" id="email" value="<%=rs1("email_address")%>" />
			</div>

		  <div class="row">
        <label for="address1" id="address" class="b">Address</label>
			  <br />
                <input name="address1" type="text" id="address1" value="<%=rs1("street1")%>" size="40" maxlength="120">
              <br>
                <input name="address2" type="text" id="address2" value="<%=rs1("street2")%>" size="40" maxlength="120">
		      <br>
	        <input name="address3" type="text" id="address3" value="<%=rs1("street3")%>" size="40" maxlength="120">
          </div>
<div class="row">
		  <label for="town" id="town" class="b">Town</label>
  <br />
                <input name="town" type="text" id="town" value="<%=rs1("town")%>">
		        <input name="val" type="hidden" id="val" value="<%=val%>">
</div>
<div class="row">
		  <label for="county" id="county" class="b">County</label>
				<br />
                <input name="county" type="text" id="county" value="<%=rs1("county")%>">
		  </div>
            <div class="row">
	      <label for="postcode" id="postcode" class="b">Post Code</label>
				<br />
                
              <input name="postcode" type="text" id="postcode" value="<%=rs1("postcode")%>" maxlength = "20">

		  </div>
          <%if retrieveUserRegion=1 then%>
          <div class="row">
	      <label for="shipper" id="shipper" class="b">Preferred Shipper</label>
				<br />
                
              <%sql="Select * from shipper_address"
			  Set rs2 = getMysqlQueryRecordSet(sql, con)
			  
if not rs2.eof then%>
              <select name="preferredshipper" id="preferredshipper">
              <%do until rs2.eof
			  selectedA=""
			  if isNull(rs("PreferredShipper")) then
			  else
			  if CInt(rs("PreferredShipper"))=CInt(rs2("shipper_ADDRESS_ID")) then selectedA="selected"
			  end if
			  %>
                <option value="<%=rs2("shipper_ADDRESS_ID")%>" <%=selectedA%>><%response.Write(rs2("shipperName") & ", " & rs2("town"))%></option>
                <%rs2.movenext
				loop%>
              </select>
              <%end if
			  rs2.close
			  set rs2=nothing
			  %>

		  </div><%end if%>
</div>
          <div class="two-col">
          
<br />
			 
        
		   <div class="row">
		  <label for="country" id="country" class="b">Country</label>
	               
                  <%
Set rs2 = getMysqlQueryRecordSet("Select * from region where id_region=" & retrieveuserregion(), con)
Dim countryregion
countryregion=rs2("country")
rs2.close
set rs2=nothing

Set rs2 = getMysqlQueryRecordSet("Select * from countrylist order by country asc", con)%>
				<br />
				   <select name="country" id="country" class="text">
                   <%If trim(rs1("country"))="" Then%>
 <option value="United Kingdom" selected><%=countryregion%></option>
 <%End If%>
<%Do until rs2.EOF
strSelected=""
If rs1("country")=rs2("country") then 
strSelected="selected"
retiredversion="n"
End If
%>
                   
                   <option value="<%=rs2("country")%>" <%=strSelected%>><%=rs2("country")%></option>
<%rs2.movenext
loop
rs2.close
set rs2=nothing
If retiredversion="y" AND rs1("country")<>"" Then%>
 <option value="<%=rs1("Country")%>" selected><%=rs1("Country")%></option>
 <%
 End If
 retiredversion="y"%></select>
                
                
                
		  </div>
<div class="row">
			  <label for="telwork" id="tel"><strong>Tel Home</strong></label>
			 
			  <br />
				<input name="tel" type="text" class="text" id="tel" value="<%=rs1("tel")%>" />
		  </div>
<div class="row">
			  <label for="telwork" id="telwork"><strong>Tel Work</strong></label>
			 
			  <br />
				<input name="telwork" type="text" class="text" id="telwork" value="<%=rs("telwork")%>" />
		  </div>
          <div class="row">
			  <label for="mobile" id="mobile"><strong>Mobile</strong></label>
			 
			  <br />
				<input name="mobile" type="text" class="text" id="mobile" value="<%=rs("mobile")%>" />
		  </div>
			<div class="row">
				<label for="fax" id="fax"><strong>Fax</strong></label>
		    <br />
				<input name="fax" type="text" class="text" id="fax" value="<%=rs1("fax")%>" />
			</div>

			<div class="row">
			  <label for="company" id="company"><strong>Company</strong></label>
		    <br />
				<input name="company" type="text" class="text" id="company" value="<%=rs1("company")%>" />
			</div>	
<div class="row">
			  <label for="position" id="position"><strong>Position in Company</strong></label>
    <br />
				<input name="position" type="text" class="text" id="position" value="<%=rs("position")%>" />
        
    </div>
<div class="row">
			  <label for="company_vat_no" id="company_vat_no"><strong>Company VAT Number</strong></label>
    <br />
				<input name="company_vat_no" type="text" class="text" id="company_vat_no" value="<%=rs("company_vat_no")%>" />
        
    </div>
<div class="row">
			 			  <label for="acceptemail" id="acceptemail"><strong>Customer accepts email marketing (ticked if yes)</strong></label>
  <%if retrieveuserlocation()=1 then showmarketing="" else showmarketing="readonly"
  If rs("acceptemail")="n" Then%>
    	<input name="acceptemail" type="checkbox" id="acceptemail" value="y" <%=showmarketing%> onchange="updateVipCheckbox()">
			<%else%>
         	<input name="acceptemail" type="checkbox" id="acceptemail" value="y" checked <%=showmarketing%> onchange="updateVipCheckbox()">
			<%End If%>

              
			  <br>
			
         			  <label for="acceptpost" id="acceptpost"><strong>Customer accepts postal marketing (ticked if yes)</strong></label>
  <%If rs("acceptpost")="n" Then%>
    	<input name="acceptpost" type="checkbox" id="acceptpost" value="y" <%=showmarketing%>>
			<%else%>
         	<input name="acceptpost" type="checkbox" id="acceptpost" value="y" checked <%=showmarketing%>>
			<%End If%>

        
            <br>
            Wrong Address (ticked if yes)

            <%If rs1("wrongaddress")="n" or isNull(rs1("wrongaddress")) Then%>
            <input name="wrongaddress" type="checkbox" id="wrongaddress" value="y">
            <%else%>
            <input name="wrongaddress" type="checkbox" id="wrongaddress" value="y" checked>
            <%End If
			if showVipBox then%>
<br>
			<br><b>VIP Member </b>
			<% if VIPcustomer="y" then 
			chked="checked"
			else 
			chked=""
			 end if%>
			 <input name="vip" type="checkbox" id="vip" <%=showmarketing%> value="y" <%=chked%> >
			 <input type="button" id="viptooltip" value="?" title=" VIP Member is automatically set to yes when the following criteria are met.<br><br>Cumulative spend of £ 19,999 inc VAT, either<br><br>Harrods, Mayfair or Chelsea as showroom, and customer type set to Private." /> 
			<%end if %>
			
			
</div>
		</div></div>
			    <div class="TabbedPanelsContent">
              <div class="two-col">
			
			
<%

Dim count2, strSelected
count2 = 1
Set rs2 = getMysqlQueryRecordSet("Select product_id from INTERESTproductsLINK WHERE contact_no = " & rs("contact_no"), con)
If NOT rs2.EOF Then
dim selectedInterestsArray()
do until rs2.EOF
	redim preserve selectedInterestsArray(count2)
	selectedInterestsArray(count2) = rs2("product_id")
	rs2.movenext
	count2 = count2 + 1
loop
End If
rs2.close
set rs2 = Nothing
			
		%>


            <div class="row">
			  <label for="products" id="products"><strong><br />Interested&nbsp;in&nbsp;the&nbsp;following&nbsp;Products<br>
			    <br />Savoir Beds
			  </strong></label>
    <br /> <%
Set rs2 = getMysqlQueryRecordSet("Select * from interestproducts WHERE Source_Site='SB' Order by Source_site" , con)
do until rs2.EOF
checked = ""
if isEMPTY(selectedInterestsArray) then
Else
    for i = 1 to ubound(selectedInterestsArray)
        if selectedInterestsArray(i) = rs2("id") then checked = "checked"
    next
end if%>
          <input name="XX<%=rs2("id")%>" type="checkbox" value="<%=rs2("id")%>" <%=checked%>>
          <%=rs2("product")%><br>
          <%
          rs2.movenext 
loop 
%>
          <%rs2.Close
Set rs2 = Nothing
%>


			</div>
   
	<div class="row"> <strong><br />Status: </strong><br />
<%

			
			Set rs2 = getMysqlQueryRecordSet("Select * from Status WHERE retired='n' Order by seq,Status" , con)%>
	 
          <select name="Status" size="1" class="formtext" id="Status" tabindex="35">
          <%If rs1("Status")="" Then%>
          <%End If%>
            <%do until rs2.EOF
			strSelected = ""
if rs2("Status") = rs1("Status") then 
strSelected = "selected"
retiredversion="n"
End If
%>
            <option value="<%=rs2("Status")%>" <%=strSelected%>><%=rs2("Status")%></option>
            <% rs2.movenext 
  loop%>
            <%
rs2.Close
Set rs2 = Nothing
If retiredversion="y" Then%>
 <option value="<%=rs1("Status")%>" selected><%=rs1("Status")%></option>
 <%
 End If
 retiredversion="y"%>
          </select>
           
			
				
			</div>

            <div class="row">
  <%Set rs2 = getMysqlQueryRecordSet("Select * from channel where brochurerequest='y' Order by channel" , con)%>
<b>Channel:</b><br /> <select name="channel" size="1" class="formtext" id="channel">
            <option value="n">Interested In</option>
            <%do until rs2.EOF
			strSelected = ""
if rs2("channel") = rs1("Channel") then strSelected = "selected"%>
            <option value="<%=rs2("channel")%>" <%=strSelected%>><%=rs2("adminwording")%></option>
            <% rs2.movenext 
  loop%>
            <%
rs2.Close
Set rs2 = Nothing

%>
          </select>  
  
  
</div>
<div class="row">
  <%Set rs2 = getMysqlQueryRecordSet("Select * from customertype" , con)%>
<b>Customer Type:</b><br /> <select name="customertype" size="1" class="formtext" id="customertype">
            <option value="n">Customer Type</option>
            <%do until rs2.EOF
			strSelected = ""
if rs("customerType")<>"" and Not IsNull(rs("customertype")) then
if CInt(rs2("customertypeID")) = CInt(rs("customerType")) then strSelected = "selected"
end if%>
            <option value="<%=rs2("customertypeID")%>" <%=strSelected%>><%=rs2("customertype")%></option>
            <% rs2.movenext 
  loop%>
            <%
rs2.Close
Set rs2 = Nothing

%>
          </select>  
  
  
</div>
			</div>
              <div class="two-col">
			
			<div class="row"> <strong><br />Source: I.e. Where seen, read article in, slept on at: </strong><br />
<%

			
			Set rs2 = getMysqlQueryRecordSet("Select * from Source WHERE retired='n' Order by Source" , con)%>
	 
          <select name="source" size="1" class="formtext" id="source" tabindex="35">
   
          <option value="n">Enter where seen, read, slept on</option>
     
            <%do until rs2.EOF
			strSelected = ""
if rs2("Source") = rs1("Source") then 
strSelected = "selected"
retiredversion="n"
End If%>
            <option value="<%=rs2("Source")%>" <%=strSelected%>><%=rs2("Source")%></option>
            <% rs2.movenext 
  loop%>
            <%
rs2.Close
Set rs2 = Nothing
If retiredversion="y" Then%>
 <option value="<%=rs1("Source")%>" selected="selected" ><%=rs1("Source")%></option>
 <%
 End If
 retiredversion="y"%>
          </select>
           
			
				
			</div>
<div class="row">
			  <label for="other" id="other"><strong>Alternative source description.</strong></label>
    <br />
				<input name="other" type="text" class="text" id="other" value="<%=rs1("source_other")%>" />
			</div>

          <div class="row">
          <%Set rs2 = getMysqlQueryRecordSet("Select * from contacttype WHERE retired='n' Order by contacttype" , con)%>
	<b>Initial Contact Made By:</b><br /> 	 
  <select name="initialcontact" size="1" class="formtext" id="initialcontact">
  <%If rs1("Initial_contact")="" then%>
            <option value="n">Initial Contact Made By</option>
            <%End If%>
            <%do until rs2.EOF
			strSelected = ""
if rs2("contacttype") = rs1("Initial_contact") then 
strSelected = "selected"
retiredversion="n"
End If%>
            <option value="<%=rs2("contacttype")%>" <%=strSelected%>><%=rs2("contacttype")%></option>
            <% rs2.movenext 
  loop%>
            <%
rs2.Close
Set rs2 = Nothing
If retiredversion="y" Then%>
 <option value="<%=rs1("Initial_contact")%>" selected><%=rs1("Initial_contact")%></option>
 <%
 End If
retiredversion="y"%>
          </select>  
           
		  </div>
          
          <div class="row"><b>Initial Contact Date:</b><br>
            <label>
              <input name="initialcontactdate" type="text" id="initialcontactdate" value="<%=rs1("first_contact_date")%>" readonly>
            </label>
<br>
          </div>
          <%if retrieveUserRegion=1 or retrieveUserRegion=23 or retrieveUserRegion=9 then%>
 <div class="row">
          <%
          Set rs2 = getMysqlQueryRecordSet("Select * from pricelist where retired='N' Order by pricelist " , con)
          %>
	<b>Price List:</b><br /> 	 
  <select name="pricelist" size="1" class="formtext" id="pricelist" onChange="showHideTradeDiscountRate();" >
            <option value="n">Please enter details of Price List given</option>
            <%do until rs2.EOF
            	tmpListPriceVal = oldToNewPriceListVal(rs2("pricelist"))
            	slected = ""
            	if isnull(listPriceVal) or trim(listPriceVal) = "" then
            		if InStr(rs2("DEFAULT_FOR_LOC_IDS"), userLocTestStr) > 0 then
		            	slected = "selected"
            		end if
            	else
            		slected = isselected(listPriceVal, tmpListPriceVal)
            	end if
            %>
            	<option value="<%=tmpListPriceVal%>" <%=slected%> ><%=tmpListPriceVal%></option>
            <% rs2.movenext 
  loop%>
            <%
rs2.Close
Set rs2 = Nothing

%>
          </select>  
           
		  </div>
		  <%else%>
		  	<input type="hidden" name="pricelist" value="<%=listPriceVal%>" />
		  <%end if%>
<div class="row" id="tradediscountrate" ><b>Trade Discount Rate:</b><br>
	<input name="tradediscountrate" type="text" id="tradediscountrate" value="<%=rs("tradediscountrate")%>" size="5" />%
</div>
		  
<div class="row"><b>Visit Date:</b><br>
            <label>
              <input name="visitdate" type="text" id="visitdate" value="<%=rs1("visit_date")%>" readonly>
            </label>
<br>
          </div>
 <div class="row">
          <%Set rs2 = getMysqlQueryRecordSet("Select * from location WHERE retire='n' AND owning_region = " & retrieveuserregion() , con)%>
	<b>Visit Location:</b><br /> 	 
  <select name="location" size="1" class="formtext" id="location">
            <option value="n">Please enter visit location</option>
            <%do until rs2.EOF
			strSelected = ""
If rs1("visit_location")<>"" and isnumeric(rs1("visit_location")) then		
if rs2("idlocation") = CInt(rs1("visit_location")) then strSelected = "selected"
End If%>
            <option value="<%=rs2("idlocation")%>" <%=strSelected%>><%=rs2("adminheading")%></option>
            <% rs2.movenext 
  loop%>
            <%
rs2.Close
Set rs2 = Nothing

%>
          </select>  
           
		  </div>
 <div class="row"><b>Last Contact Date:</b><br>
   <label>
     <input name="lastcontactdate" type="text" id="lastcontactdate" value="<%=rs1("last_contact_date")%>" readonly>
   </label>
   <br>
 </div> 
      
          			</div>
		      </div>
              
              <div class="TabbedPanelsContent">
                <div class="one-col">
                 <%Set rs2 = getMysqlQueryRecordSet("Select * from purchase WHERE contact_no=" & rs("contact_no") & " AND (cancelled<>'y' or cancelled is null) AND (quote<>'y' or quote is null) AND orderSource<>'Test' ORDER by order_date desc", con)
				 If rs2.EOF then
				 Response.Write("No orders currently")
				 Else%>
                <br /> <br />
                 <table width="97%" border="1" cellspacing="0" cellpadding="3" align="center">
  <tr>

    <td colspan="9"> <b>Existing Orders (<font color="#FF0000">orders in red are not complete</font><font color="#3333CC"> - orders in blue are on HOLD</font><%if retrieveUserRegion()=1 then%><font color="#009900"> - orders in green are QUOTES</font><%end if%><font color="#555555"> - orders in grey are CANCELLED</font>):</b><br>
      <b><%=rs2.recordcount%></b> orders. <%=totalsString%>&nbsp;<%=totalsForYearString%><br/></td></tr>
  <tr>
    <td width="6%">Order No</td>
    <td width="6%">Order Date</td>
    <td width="17%">Customer Ref.</td>
    <td width="43%">Product Purchased</td>
 
    <td width="13%">Notes</td>
    <td width="7%">Order Total ex VAT</td>
    <%if isSuperuser then%>
    <td width="8%">Order Complete</td>
    <%end if%>
  </tr>
				 <%do until rs2.EOF%>
                   
  <tr>
    <td valign="top">
	<%
	if rs2("cancelled")="y" then
		response.write("<a class=""greytext"" href=""edit-purchase.asp?order=" & rs2("purchase_no") & """>" & rs2("order_number") & " CANCELLED ORDER</a>")
	elseif rs2("completedorders")="n" AND rs2("orderonhold")="n" and rs2("quote")="d" then
		response.write("<a class=""greentext"" href=""edit-purchase.asp?quote=y&order=" & rs2("purchase_no") & """>" & rs2("order_number") & " Declined</a>")
	elseif rs2("completedorders")="n" AND rs2("orderonhold")="n" and rs2("quote")="y" then
		response.write("<a class=""greentext"" href=""edit-purchase.asp?quote=y&order=" & rs2("purchase_no") & """>" & rs2("order_number") & "</a>")
	elseif rs2("completedorders")="n" AND rs2("orderonhold")="n" and rs2("quote")="n" then
		response.write("<a class=""redtext"" href=""edit-purchase.asp?order=" & rs2("purchase_no") & """>" & rs2("order_number") & "</a>")
	elseif rs2("orderonhold")="y" AND rs2("completedorders")="n" then
		response.write("<a class=""bluetext"" href=""edit-purchase.asp?order=" & rs2("purchase_no") & """>" & rs2("order_number") & "</a>")
	elseif rs2("completedorders")="y" then 
		response.write("<a href=""edit-purchase.asp?readonly=y&order=" & rs2("purchase_no") & """>" & rs2("order_number") & "</a>")
	else
		' just in case
		response.write("<a href=""edit-purchase.asp?readonly=y&order=" & rs2("purchase_no") & """>" & rs2("order_number") & "</a>")
	end if%>&nbsp;</td>
    <td valign="top"><%
		response.write(left(rs2("order_date"),10))
	%>&nbsp;</td>
    <td valign="top"><%
		response.write(rs2("customerreference"))
	%>&nbsp;</td>
    <td valign="top"><%
		response.write(rs2("bed"))
		if rs2("mattressrequired")="y" then response.write("<b>Mattress:</b> " & getOrderComponentSummary(con, rs2("purchase_no"), 1)) & "<br />"
		if rs2("baserequired")="y" then response.write("<b>Base:</b> " & getOrderComponentSummary(con, rs2("purchase_no"), 3)) & "<br />"
		if rs2("topperrequired")="y" then response.write("<b>Topper:</b> " & getOrderComponentSummary(con, rs2("purchase_no"), 5)) & "<br />"
		if rs2("legsrequired")="y" then response.write("<b>Legs:</b> " & getOrderComponentSummary(con, rs2("purchase_no"), 7)) & "<br />"
		if rs2("valancerequired")="y" then response.write("<b>Valance:</b> Yes<br />")
		if rs2("headboardrequired")="y" then response.write("<b>Headboard:</b>" & getOrderComponentSummary(con, rs2("purchase_no"), 8) & "<br />")
		if rs2("accessoriesrequired")="y" then response.write("<b>Accessories</b>")
	%>
      &nbsp;</td>
   
    <td valign="top"><%
		response.write(rs2("notes"))
		
	%>&nbsp;</td>
    <td align="right" valign="top"><%response.write(fmtCurr2(rs2("totalexvat"), true, rs2("ordercurrency")))%>&nbsp;</td>
    <%if (isSuperuser or userHasRoleInList("ORDER_REOPENER")) then%>
    <td valign="top"> <%If rs2("completedorders")="y" Then%>
    	<a href="orderincomplete.asp?val=<%=rs2("purchase_no")%>">Re-open order</a>
			<%End If%>&nbsp;</td>
       <%end if%>
  </tr>
  <% rs2.movenext 
  loop%>
</table>
<%If rs2.recordcount > 25 then%>
                 <p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
<%end if%>
                 <%End If
rs2.close
set rs2=nothing%>

               
			</div>
		      </div>
              
              <div class="TabbedPanelsContent">
               <p><b>Default? <span class="delfloatright">Edit?</span></b></p>
                <%Set rs2 = getMysqlQueryRecordSet("Select * from delivery_address WHERE Contact_no=" & val & " order by isdefault desc, retire asc", con)
				 If rs2.EOF then
				 Response.Write("No delivery addresses available")
				 Else
				 Dim cp
				 cp=1
				 Do until rs2.eof
				 
				 deladdress=""
				 if rs2("delivery_name")<>"" then deladdress=rs2("delivery_name")
				 if rs2("add1")<>"" then deladdress=deladdress & ", " & rs2("add1")
				 if rs2("add2")<>"" then deladdress=deladdress & ", " & rs2("add2")
				 if rs2("add3")<>"" then deladdress=deladdress & ", " & rs2("add3")
				 if rs2("town")<>"" then deladdress=deladdress & ", " & rs2("town")
				 if rs2("countystate")<>"" then deladdress=deladdress & ", " & rs2("countystate")
				 if rs2("postcode")<>"" then deladdress=deladdress & ", " & rs2("postcode")
				 if rs2("country")<>"" then deladdress=deladdress & ", " & rs2("country")
				  if rs2("phone")<>"" then deladdress=deladdress & ".  <b>CONTACT: " & rs2("phone") & "</b>"
				   if rs2("contact")<>"" then deladdress=deladdress & ", " & rs2("contact")
				 %>
                <p></p>
                <%if rs2("ISDEFAULT")="y" then%>
                             <span class="delfloatleft">  <b>Default</b> </span>
                                <%else%>
                                 <span class="delfloatleft"><input name="maindeliveryaddress" type="radio" id="maindeliveryaddress_<%=rs2("delivery_address_id")%>" onClick="alert('You are changing the default delivery address')" value="<%=rs2("delivery_address_id")%>"></span>
                                 <%end if%>
                <div id="CollapsiblePanel<%=cp%>" class="CollapsiblePanel">
                  <div class="CollapsiblePanelTab" tabindex="0">
                   <span class="delfloatright">EDIT </span> <%if rs2("retire")="y" then%>
                  <font color="red">RETIRED</font> <%=deladdress%>
				  <%else%>
				<span class="deladd"><%=deladdress%></span>
              
				  <%end if%>
				 </div>
                  <div class="CollapsiblePanelContent">
                   <div class="two-col">
                    <div class="row">
                      <p>Delivery Name:<br>
                        <input name="deliverydeliveryname_<%=rs2("delivery_address_id")%>" type="text" id="deliverydeliveryname_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("delivery_name")%>">
                      </p>
                       </div>
                      <div class="row">
			  <p>Address Line 1:<br>
			    <input name="deliveryadd1_<%=rs2("delivery_address_id")%>" type="text" id="deliveryadd1_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("add1")%>">
			  </p>
              </div>
              <div class="row">
			  <p>Address Line 2:<br>
			    <input name="deliveryadd2_<%=rs2("delivery_address_id")%>" type="text" id="deliveryadd2_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("add2")%>">
			  </p>
              </div>
              <div class="row">
                <p>Address Line 3:<br>
			    <input name="deliveryadd3_<%=rs2("delivery_address_id")%>" type="text" id="deliveryadd3_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("add3")%>">
			  </p>
              </div>
              <div class="row">
			  <p>Town:<br>
			    <input name="deliverytown_<%=rs2("delivery_address_id")%>" type="text" id="deliverytown_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("town")%>">
			  </p>
			 </div>
             <div class="row">
                <p>County / State :<br>
			    <input name="deliverycounty_<%=rs2("delivery_address_id")%>" type="text" id="deliverycounty_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("countystate")%>">
			  </p>
              </div>
              </div>
                 <div class="two-col">
                   <div class="row">
              <p>Postcode :<br>
			    <input name="deliverypostcode_<%=rs2("delivery_address_id")%>" type="text" id="deliverypostcode_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("postcode")%>">
			  </p>
              </div>
              <div class="row">
			  <p>Country :<br>
			    <input name="deliverycountry_<%=rs2("delivery_address_id")%>" type="text" id="deliverycountry_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("country")%>">
			  </p>
              </div>
              <div class="row">
			  <p>Contact 1 Name :<br />
			  <input name="deliverycontact1_<%=rs2("delivery_address_id")%>" type="text" id="deliverycontact1_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("contact")%>"><%Set rs3 = getMysqlQueryRecordSet("Select * from phonenumbertype", con)%>
               
<select name="contacttype1_<%=rs2("delivery_address_id")%>">
<%do until rs3.eof
slected=""
if rs3("typename")=rs2("contacttype1") then slected="selected"%>
  <option value="<%=rs3("typename")%>" <%=slected%>><%=rs3("typename")%></option>
  <%rs3.movenext
  loop%>
</select>
<%rs3.close
set rs3=nothing%> </p>
              </div>
              <div class="row">
			  <p>Tel 1 :<br>
			    <input name="deliverytel_<%=rs2("delivery_address_id")%>" type="text" id="deliverytel_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("phone")%>">
			  </p></div>
              
              <div class="row">
			  <p>Contact Name 2 :<br>
			    <input name="deliverycontact2_<%=rs2("delivery_address_id")%>" type="text" id="deliverycontact2_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("contact2")%>">  <%Set rs3 = getMysqlQueryRecordSet("Select * from phonenumbertype", con)%>
               
<select name="contacttype2_<%=rs2("delivery_address_id")%>">
<%do until rs3.eof
  slected=""
if rs3("typename")=rs2("contacttype2") then slected="selected"%>
  <option value="<%=rs3("typename")%>" <%=slected%>><%=rs3("typename")%></option>
  <%rs3.movenext
  loop%>
</select>
<%rs3.close
set rs3=nothing%>
			  </p>
              </div>
              <div class="row">
			  <p>Tel 2 :<br>
			    <input name="deliverytel2_<%=rs2("delivery_address_id")%>" type="text" id="deliverytel2_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("phone2")%>">
			  </p></div>
              
              <div class="row">
			  <p>Contact Name 3 :<br>
			    <input name="deliverycontact3_<%=rs2("delivery_address_id")%>" type="text" id="deliverycontact3_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("contact3")%>"><%Set rs3 = getMysqlQueryRecordSet("Select * from phonenumbertype", con)%>
               
<select name="contacttype3_<%=rs2("delivery_address_id")%>">
<%do until rs3.eof
slected=""
if rs3("typename")=rs2("contacttype3") then slected="selected"%>
  <option value="<%=rs3("typename")%>" <%=slected%>><%=rs3("typename")%></option>
  <%rs3.movenext
  loop%>
</select>
<%rs3.close
set rs3=nothing%>
			  </p>
              </div>
              <div class="row">
			  <p>Tel 3 :<br>
			    <input name="deliverytel3_<%=rs2("delivery_address_id")%>" type="text" id="deliverytel3_<%=rs2("delivery_address_id")%>" size="40" value="<%=rs2("phone3")%>">
			  </p></div>
              
              <div class="row"><p>Tick to Retire this address: 
              <%if rs2("retire")="n" then%>
              <input name="deliveryretire_<%=rs2("delivery_address_id")%>" id="deliveryretire_<%=rs2("delivery_address_id")%>" type="checkbox" value="y">
              <%else%>
              <input name="deliveryretire_<%=rs2("delivery_address_id")%>" id="deliveryretire_<%=rs2("delivery_address_id")%>" type="checkbox" value="y" checked>
              <%end if%></p>              </div>
              </div> <div class="clear">&nbsp;</div><hr />
                 
          
           
                  </div>
                </div>
                <div class="clear"></div>
<%cp=cp+1
				rs2.movenext
				loop%>
				<input name="cpcount" type="hidden" value="<%=cp%>">
				<%end if
				rs2.close 
				set rs2=nothing%>
                <div class="clear"></div>
             <hr />
            
              <div id="CollapsiblePanel<%=cp%>" class="CollapsiblePanel">
                  <div class="CollapsiblePanelTab" tabindex="0">
                  
                  
			  ADD NEW DELIVERY ADDRESS
			
               </div>
                  <div class="CollapsiblePanelContent">
                    <div class="two-col">
              <div class="row">
			  <p>Delivery Name:<br>
			    <input name="deliveryname" type="text" id="deliveryname" size="40">
		      </p>
              </div>
              <div class="row">
			  <p>Address Line 1:<br>
			    <input name="deliveryadd1" type="text" id="deliveryadd1" size="40">
			  </p>
              </div>
              <div class="row">
			  <p>Address Line 2:<br>
			    <input name="deliveryadd2" type="text" id="deliveryadd2" size="40">
			  </p>
              </div>
              <div class="row">
                <p>Address Line 3:<br>
			    <input name="deliveryadd3" type="text" id="deliveryadd3" size="40">
			  </p>
              </div>
              <div class="row">
			  <p>Town:<br>
			    <input name="deliverytown" type="text" id="deliverytown" size="40">
			  </p>
			 </div>
             <div class="row">
                <p>County / State :<br>
			    <input name="deliverycounty" type="text" id="deliverycounty" size="40">
			  </p>
              </div>
               <div class="row">
              <p>Postcode :<br>
			    <input name="deliverypostcode" type="text" id="deliverypostcode" size="40">
			  </p>
              </div>
              <div class="row">
			  <p>Country :<br>
			    <input name="deliverycountry" type="text" id="deliverycountry" size="40">
			  </p>
              </div>
			  
               </div>
             <div class="two-col">
 
             
              <div class="row">
			  <p>Contact 1 Name :<br>
			    <input name="deliverycontact" type="text" id="deliverycontact" size="40">
                <%Set rs3 = getMysqlQueryRecordSet("Select * from phonenumbertype", con)%>
               
<select name="contacttype1">
<%do until rs3.eof%>
  <option value="<%=rs3("typename")%>"><%=rs3("typename")%></option>
  <%rs3.movenext
  loop%>
</select>
<%rs3.close
set rs3=nothing%>
			  </p>
              </div>
              <div class="row">
			  <p>Contact 1 Tel :<br>
			    <input name="deliverytel" type="text" id="deliverytel" size="40">
                
			  </p>
              </div>
               <div class="row">
			  <p>Contact 2 Name :<br>
			    <input name="deliverycontact2" type="text" id="deliverycontact2" size="40">
                 <%Set rs3 = getMysqlQueryRecordSet("Select * from phonenumbertype", con)%>
                
<select name="contacttype2">
<%do until rs3.eof%>
  <option value="<%=rs3("typename")%>"><%=rs3("typename")%></option>
  <%rs3.movenext
  loop%>
</select>
<%rs3.close
set rs3=nothing%>
			  </p>
              </div>
              <div class="row">
			  <p>Contact 2 Tel :<br>
			    <input name="deliverytel2" type="text" id="deliverytel2" size="40">
			  </p>
              </div>
               <div class="row">
			  <p>Contact 3 Name :<br>
			    <input name="deliverycontact3" type="text" id="deliverycontact3" size="40">
                 <%Set rs3 = getMysqlQueryRecordSet("Select * from phonenumbertype", con)%>
               
<select name="contacttype3">
<%do until rs3.eof%>
  <option value="<%=rs3("typename")%>"><%=rs3("typename")%></option>
  <%rs3.movenext
  loop%>
</select>
<%rs3.close
set rs3=nothing%>
			  </p>
              </div>
              <div class="row">
			  <p>Contact 3 Tel :<br>
			    <input name="deliverytel3" type="text" id="deliverytel3" size="40">
			  </p>
              </div>
              <div class="row">
			  <p>Tick if this is the default delivery address 
			    <input name="maindeliveryaddress1" type="checkbox" id="maindeliveryaddress1" value="y">
			   
			  </p>
              </div>
                </div>
                <div class="clear"></div>
              </div>
               </div>
		      </div>           
               <div class="TabbedPanelsContent">
                <div class="two-col">
                  
			</div> <div class="one-col"><br />
            <table width="97%" border="1" cellspacing="0" cellpadding="3" align="center">
  <tr>
    <td colspan="7"> <strong>Add Communication / Note</strong><b> (will be dated today):</b><br><br /></td></tr>
  <tr>
    
    <td>Created By: </td>
    <td>Date Created:</td>
    <td>Contact Name:</td>
    <td>Notes</td>
    <td>Follow Up Date</td>
    <td>Status</td>
  </tr>
				 
                
                   
  <tr>
   
    <td valign="top"><%=retrieveUserName()%>
       </td>
    <td valign="top"><input name="commdate" type="text" value="<%=now()%>" readonly></td>
    <%Dim contactperson
	if rs("title")<>"" then contactperson=rs("title") & " "
	if rs("first")<>"" then contactperson=contactperson & rs("first") & " "
	if rs("surname")<>"" then contactperson=contactperson & rs("surname")%>
    <td valign="top"><input name="commperson" type="text" value="<%=contactperson%>"></td>
    <td valign="top"><textarea name="commnote" rows="5"></textarea></td>
   <td valign="top">
   <label for="commnext" id="commnext">
		  <input name="commnextdate" type="text" class="text" id="commnextdate" value="" size="10" /></label>
    </td>
    <td valign="top"> 
  <select name="commstatus" size="1" class="formtext" id="commstatus">
            <option value="n">Select Status:</option>
           
            <option value="To Do">To Do</option>
            <option value="Completed">Completed</option>
            <option value="Cancelled">Cancelled</option>
            
          </select>  
           </td>
  </tr>

</table>
                 <%Set rs2 = getMysqlQueryRecordSet("Select * from communication WHERE code=" & rs("code") & " ORDER by date desc", con)
				 If rs2.EOF then
				 Response.Write("No notes available")
				 Else%>
                
                 <br>
                 <table width="97%" border="1" cellspacing="0" cellpadding="3" align="center">
  <tr>
    <td colspan="8"> <b>Previous Correspondence / Notes:</b><br><%=rs2.recordcount%> comments/notes<br /></td></tr>
  <tr>
    <td width="10%">Date Created</td>
    <td width="10%">Type</td>
    <td width="11%">Contact Name</td>
    <td width="10%">Contacted By:</td>
    <td width="32%">Notes</td>
    <td width="10%">Follow Up Date</td>
    <td width="17%">Response</td>
    <td width="17%">Status</td>
  </tr>
				 <%do until rs2.EOF%>
                
                   
  <tr>
    <td><%=rs2("date")%>&nbsp;</td>
    <td><%=rs2("type")%>&nbsp;</td>
    <td><%=rs2("person")%>&nbsp;</td>
    <td><%=rs2("staff")%></td>
    <td><%if rs2("commstatus")="To Do" and InStr(rs2("notes"),"Brochure Request")<>0 and rs2("notes")<>"Brochure Request Follow-Up" then%>
      <textarea name="notesactive_<%=rs2("communication")%>"><%=rs2("notes")%></textarea>
	<%else%>
	<%=rs2("notes")%>&nbsp;
    <%end if%>
    </td>
   <td><%if rs2("commstatus")="To Do" and InStr(rs2("notes"),"Brochure Request")<>0 then%>
   <input name="nextactive_<%=rs2("communication")%>" id="nextactive_<%=rs2("communication")%>" type="text" value="<%=rs2("next")%>" >
   <%else%>
   <%=rs2("next")%>&nbsp;
   <%end if%></td>
    <td><%if rs2("commstatus")="To Do" then%><textarea rows="5" name="responseactive_<%=rs2("communication")%>" id="responseactive_<%=rs2("communication")%>"></textarea><%end if%>
      <br /><br /><%=rs2("response")%>&nbsp;</td>
    <td><%if isNull(rs2("commstatus")) then
	elseif rs2("commstatus")="Completed" or rs2("commstatus")="Cancelled" then
	response.Write(rs2("commstatus") & "<br />" & rs2("completedDate") & "<br />" & rs2("commCompletedBy"))
	else
	%>
    <select name="commstatusActive_<%=rs2("communication")%>" size="1" class="formtext" id="commstatusActive_<%=rs2("communication")%>">           
            <option value="To Do"<%= selected(rs2("commstatus"), "To Do") %>>To Do</option>
            <option value="Completed"<%= selected(rs2("commstatus"), "Completed") %>>Completed</option>
            <option value="Cancelled"<%= selected(rs2("commstatus"), "Cancelled") %>>Cancelled</option>
            
          </select>&nbsp;</td>
      <%end if%>
  </tr>
  <% rs2.movenext 
  loop%>
</table>
<%If rs2.recordcount > 8 then%>
                 <p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
<%end if%>
<%End If
rs2.close
set rs2=nothing%>

               
		      </div>
              
              
			  </div>
                      
<!-- new tab additional contacts -->
 <div class="TabbedPanelsContent">
      <div class="two-col">
           <div class="row">
           <%Set rs2 = getMysqlQueryRecordSet("Select * from contact WHERE parent_contact_no=" & val & " AND  	AdditionalContactSeq=1", con)
		   if not rs2.eof then
		   addcontact1title=rs2("title")
		   addcontact1name=rs2("first")
		   addcontact1surname=rs2("surname")
		   addcontact1tel=rs2("telwork")
		   addcontact1mobile=rs2("mobile")
		   addcontact1email=rs2("AdditionalContactEmail")
		   addcontact1pos=rs2("position")
		   end if
		   rs2.close
		   set rs2=nothing
		   %>
                      <p><b>Additional Contact 1:</b>  (Tick to remove contact 
                        1
                        <input name="removecontact1" type="checkbox" id="removecontact1" value="y" onchange="cTrig('removecontact1')">)
                      <label for="removecontact1"></label><br></p>
            </div>
            <div class="row">
                      <p>Title:<br>
                        <input name="addcontact1title" type="text" id="addcontact1title" size="40" value="<%=addcontact1title%>">
                      </p>
            </div>
            <div class="row">
                      <p>First Name:<br>
                        <input name="addcontact1name" type="text" id="addcontact1name" size="40" value="<%=addcontact1name%>">
                      </p>
            </div> 
            <div class="row">
                      <p>Surname:<br>
                        <input name="addcontact1surname" type="text" id="addcontact1surname" size="40" value="<%=addcontact1surname%>">
                      </p>
            </div> 
            <div class="row">
                      <p>Telephone:<br>
                        <input name="addcontact1tel" type="text" id="addcontact1tel" size="40" value="<%=addcontact1tel%>">
                      </p>
            </div> 
            <div class="row">
                      <p>Mobile:<br>
                        <input name="addcontact1mobile" type="text" id="addcontact1mobile" size="40" value="<%=addcontact1mobile%>">
                      </p>
            </div> 
            <div class="row">
                      <p>Email:<br>
                        <input name="addcontact1email" type="text" id="addcontact1email" size="40" value="<%=addcontact1email%>">
                      </p>
            </div> 
            <div class="row">
                      <p>Position in Company:<br>
                        <input name="addcontact1pos" type="text" id="addcontact1pos" size="40" value="<%=addcontact1pos%>">
                      </p>
            </div> 
	  </div> 
      <div class="two-col">
            <div class="row">
             <%Set rs2 = getMysqlQueryRecordSet("Select * from contact WHERE parent_contact_no=" & val & " AND  	AdditionalContactSeq=2", con)
		   if not rs2.eof then
		   addcontact2title=rs2("title")
		   addcontact2name=rs2("first")
		   addcontact2surname=rs2("surname")
		   addcontact2tel=rs2("telwork")
		   addcontact2mobile=rs2("mobile")
		   addcontact2email=rs2("AdditionalContactEmail")
		   addcontact2pos=rs2("position")
		   end if
		   rs2.close
		   set rs2=nothing
		   %>
                      <p><b>Additional Contact 2:</b> (Tick to remove contact
                        2
                        <input name="removecontact2" type="checkbox" id="removecontact2" value="y" onchange="cTrig2('removecontact2')">)
                        <label for="removecontact2"></label><br></p>
            </div>
            <div class="row">
                      <p>Title:<br>
                        <input name="addcontact2title" type="text" id="addcontact2title" size="40" value="<%=addcontact2title%>">
                      </p>
            </div>
            <div class="row">
                      <p>First Name:<br>
                        <input name="addcontact2name" type="text" id="addcontact2name" size="40" value="<%=addcontact2name%>">
                      </p>
            </div> 
            <div class="row">
                      <p>Surname:<br>
                        <input name="addcontact2surname" type="text" id="addcontact2surname" size="40" value="<%=addcontact2surname%>">
                      </p>
            </div> 
            <div class="row">
                      <p>Telephone:<br>
                        <input name="addcontact2tel" type="text" id="addcontact2tel" size="40" value="<%=addcontact2tel%>">
                      </p>
            </div> 
            <div class="row">
                      <p>Mobile:<br>
                        <input name="addcontact2mobile" type="text" id="addcontact2mobile" size="40" value="<%=addcontact2mobile%>">
                      </p>
            </div> 
            <div class="row">
                      <p>Email:<br>
                        <input name="addcontact2email" type="text" id="addcontact2email" size="40" value="<%=addcontact2email%>">
                      </p>
            </div> 
            <div class="row">
                      <p>Position in Company:<br>
                        <input name="addcontact2pos" type="text" id="addcontact2pos" size="40" value="<%=addcontact2pos%>">
                      </p>
            </div> 
	  </div>
</div>

<!-- end tab -->                             

<p>&nbsp;</p>
                </div>

              
			  </div>
<p>&nbsp;</p>
                </div>
			    <div class="row">
			      </div>	
		</div>
		</div>

	</div></div>
 
    
  </div>
<div>
</div>
        </form>
<script type="text/javascript">
<!--
var TabbedPanels1 = new Spry.Widget.TabbedPanels("TabbedPanels1", {defaultTab: params.tab ? params.tab : 0});

//-->
</script>
<%for z=1 to cp %>
<script type="text/javascript">
<!--

var CollapsiblePanel<%=z%> = new Spry.Widget.CollapsiblePanel("CollapsiblePanel<%=z%>", { contentIsOpen: false });

//-->
</script>
<%next%>
</body>
</html>
<%rs.close
set rs=nothing
rs1.close
set rs1=nothing
Con.Close
Set Con = Nothing
%>
       <script Language="JavaScript" type="text/javascript">
<!--

	$(document).ready(showHideTradeDiscountRate());

$('#viptooltip').powerTip({
    placement: 'n',
    smartPlacement: true
});
var jsIsVipCandidate = '<%=isVipCandidate%>';

	function updateVipCheckbox() {
        var acceptEmailCheckbox = document.getElementById("acceptemail");
        var vipCheckbox = document.getElementById("vip");

        if (!acceptEmailCheckbox.checked) {
            vipCheckbox.checked = false;
        } else if (jsIsVipCandidate == "y") {
            vipCheckbox.checked = true;
		}
    }
   
	function IsNumeric(sText)
	{
	   var ValidChars = "0123456789 ";
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

    
 

	if ((theForm.email.value !="") && (!validEmail(theForm.email.value))) {
		alert("Email address is not in the correct format")
		theForm.email.focus()
		theForm.email.select()
		return false
	}
  
	if (theForm.tradediscountrate.value != "" && !IsNumeric(theForm.tradediscountrate.value)) {
		alert("Please enter a whole number for trade discount rate")
		theForm.tradediscountrate.focus()
		theForm.tradediscountrate.select()
		return false
	}
	if (theForm.commstatus.value == "To Do" && theForm.commnextdate.value == "") {
		alert("Please enter a follow-up date")
		theForm.commnextdate.focus()
		theForm.commnextdate.select()
		return false
	}
	

    return true;
} 


function isTradeCustomer() {
	var priceList = document.form1.pricelist.value;
	var isTradeCustomer = (priceList == "Trade" || priceList == "Savoy" || priceList == "Contract" || priceList == "Wholesale" || priceList == "Net Retail");
	return isTradeCustomer;
}

function showHideTradeDiscountRate() {
	if (isTradeCustomer()) {
		$('#tradediscountrate').show();
	} else {
		$('#tradediscountrate').hide();
		document.form1.tradediscountrate.value = 0;
	}
}

function orderQuoteChangeHandler2() { //1
var value = $("#orderquote").val();
	//console.log("value = " + value);
	if (value == 0) {
		alert("Please select an option");
		$("#orderquote").focus();
		return;
	}
jconfirm.defaults = {
    title: 'Hello',
    titleClass: '',
    type: 'default',
    draggable: true,
    alignMiddle: true,
    typeAnimated: true,
    content: '',
    buttons: {},
    defaultButtons: {
        ok: {
            action: function () {
            }
        },
        close: {
            action: function () {
            }
        },
    },
    contentLoaded: function(data, status, xhr){
    },
    icon: '',
    lazyOpen: false,
    bgOpacity: null,
    theme: 'light',
    animation: 'zoom',
    closeAnimation: 'scale',
    animationSpeed: 400,
    animationBounce: 1.2,
    rtl: false,
    container: 'body',
    containerFluid: false,
    backgroundDismiss: false,
    backgroundDismissAnimation: 'shake',
    autoClose: false,
    closeIcon: null,
    closeIconClass: false,
    watchInterval: 100,
    columnClass: 'col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1',
    boxWidth: '50%',
    scrollToPreviousElement: true,
    scrollToPreviousElementAnimate: true,
    useBootstrap: true,
    offsetTop: 50,
    offsetBottom: 50,
    dragWindowGap: 15,
    bootstrapClasses: {
        container: 'container',
        containerFluid: 'container-fluid',
        row: 'row',
    },
    onContentReady: function () {},
    onOpenBefore: function () {},
    onOpen: function () {},
    onClose: function () {},
    onDestroy: function () {},
    onAction: function () {}
};
$.confirm({//2
		title: 'Any changes you made to the customer details will be saved first. Please confirm.',
		buttons: {//3
			Cancel: function () {
				$.alert('Order Cancelled');
			},
			Proceed: {
				action: function () {
						$.confirm({
							title: 'Please choose order type:',
							content: '<span> <br></span>',
							buttons: {
								confirm: {
									text: 'Customer Order',
									btnClass: 'btn-orange',
									action: function () {
										$.confirm({
										title: 'Please let us know what type of customer:',
										content: '<span> <br></span>',
										buttons: {
											confirm: {
											text: 'Retail',
											btnClass: 'btn-orange',
											action: function () {
												$("#nextpage").val(value + "&ordersource=Client Retail");
												$("#form1").submit();
												}
											},
											confirm2: {
											text: 'Trade',
											btnClass: 'btn-orange',
											action: function () {
												$("#nextpage").val(value + "&ordersource=Client Trade");
												$("#form1").submit();
												}
											},
											confirm3: {
											text: 'Contract',
											btnClass: 'btn-orange',
											action: function () {
												$("#nextpage").val(value + "&ordersource=Client Contract");
												$("#form1").submit();
												}
											}
										},
										});
									}
								},
								confirm2: {
									text: 'Floorstock Order',
									btnClass: 'btn-orange',
									action: function () {
										$("#nextpage").val(value + "&ordersource=Floorstock");
										$("#form1").submit();
									}
								},
								confirm3: {
									text: 'Stock Order',
									btnClass: 'btn-orange',
									action: function () {
										$("#nextpage").val(value + "&ordersource=Stock");
										$("#form1").submit();
									}
								},
								confirm4: {
									text: 'Marketing Order',
									btnClass: 'btn-orange',
									action: function () {
										$("#nextpage").val(value + "&ordersource=Marketing");
										$("#form1").submit();
									}
								},
								confirm5: {
									text: 'Test Order',
									btnClass: 'btn-orange',
									action: function () {
										$("#nextpage").val(value + "&ordersource=Test");
										$("#form1").submit();
									}
								},
								
								someButton: {
                                    text: 'HELP',
                                    btnClass: 'btn-green',
                                    action: function () {
                                        this.$content.find('span').append('<br><b>Customer Order:</b><br>Select this option if you want to place an order for your customer.<br><br><b>Floorstock Order:</b><br>Select this option if you are placing an order which is a floorstock bed for your showroom display.<br><br><b>Stock Order:</b><br>Select this option if you are placing an order for delivery or storage to your warehouse.<br><br><b>Marketing Order:</b><br>Select this option if you are placing an order for Marketing purposes.<br><br>');
                                        return false; // prevent dialog from closing.
                                    }

                                },
								cancel: function () {
									$.alert('Order Cancelled');
								}
							},
							
							
							
							
						});
					}
        	},
        	
		}
	});
}

function orderQuoteChangeHandler() {
	var value = $("#orderquote").val();
	//console.log("value = " + value);
	if (value == 0) {
		alert("Please select an option");
		$("#orderquote").focus();
	}
	$("#nextpage").val(value);
	if (confirm("Any changes you made to the customer details will be saved first. Please confirm.")) {
		//console.log("confirmed");
		$("#form1").submit();
	}
}

function cTrig(removecontact1) {
      if (document.getElementById(removecontact1).checked == true) {
		var box= confirm("Are you sure you want to delete contact 1?\n\nThe contact will be deleted when you hit save");
		if (box!=true)
		document.getElementById(removecontact1).checked = false;
	  } else {
        return true;
	  }
}
function cTrig2(removecontact2) {
      if (document.getElementById(removecontact2).checked == true) {
		var box= confirm("Are you sure you want to delete contact 2?\n\nThe contact will be deleted when you hit save");
		if (box!=true)
		document.getElementById(removecontact2).checked = false;
	  } else {
        return true;
	  }
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
