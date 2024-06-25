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
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="emailfuncs.asp" -->
<%Dim postcode, postcodefull, Con, rs, rs2, recordfound, id, rspostcode, submit1, submit2, count, envelopecount, i, fieldName, fieldValue, fieldNameArray, type1, sql, correspondencename, contact, orderno
Dim mattressrequired, mattressprice, topperrequired, topperprice, baserequired, legprice, baseprice, upholsteredbase, upholsteryprice, valancerequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd
Dim deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype
Dim basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice
Dim specialinstructionsvalance, specialinstructionsdelivery, localeref, order, selcted, cust, custcode, msg, signature, custname, paymentstotal, dctype, subtotal, dcresult, outstanding, deldate1
dim basefabriccost, basefabricmeters, basefabricprice, hbfabriccost, hbfabricmeters, hbfabricprice, valfabriccost, valfabricmeters, valfabricprice, paymentmethod, recipientordernumbers, companyname, extbase, basefabricdesc, headboardfinish, headboardfabricdirection, headboardfabricdesc, accesscheck, tradeDiscount, totalExVat
dim isamendment, tel, telwork, delphonetype1, delphone1, mobile, delphonetype2, delphone2, delphonetype3, delphone3, email_address, ordertypename, bookeddeliverydate, ordernote_notetext, basefabricdirection
dim rs4, oldbed, accessoriestotalcost, vat, matt1width, matt2width, matt1length, matt2length, topper1width, topper1length, base1width, base2width, base1length, base2length, drawers, drawerconfig, drawerheight, addlegqty, legqty, specialinstructionslegs, hbfabricoptions, hblegs, valancefabricdirection, valancedrop, valancewidth, valancelength, legsrequired, productionsizelegs

recipientordernumbers=""

'count=0

submit1=""
submit1=Request("submit1")
Set Con = getMysqlConnection()
Set rs = getMysqlUpdateRecordSet("Select * from region Where id_region=" & retrieveUserRegion() & "", con)
'Session.LCID=1029
Session.LCID=trim(rs("locale"))
rs.close
set rs=nothing%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/printletter.css" rel="Stylesheet" type="text/css" />
<link href="Styles/printletter1.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
</head>
<body>
<%If submit1 <> "" Then
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	fieldNameArray = Split(fieldName, "_")
	type1 = fieldNameArray(1)
Set rs = getMysqlUpdateRecordSet("Select * from purchase Where purchase_no=" & type1, con)
rs("orderonhold")="n"
'rs("order_date")=now()
recipientordernumbers=recipientordernumbers & " " & rs("order_number")
rs.update
rs.close
set rs=nothing
Set rs = getMysqlUpdateRecordSet("Select * from ProductionSizes WHERE Purchase_No=" & type1, con)
If not rs.eof then
	productionsizelegs="y"

	If rs("matt1width")<>"" then matt1width=formatnumber(rs("matt1width"),2)
	If rs("matt2width")<>"" then matt2width=formatnumber(rs("matt2width"),2)
	If rs("matt1length")<>"" then matt1length=formatnumber(rs("matt1length"),2)
	If rs("matt2length")<>"" then matt2length=formatnumber(rs("matt2length"),2)
	If rs("base1width")<>"" then base1width=formatnumber(rs("base1width"),2)
	If rs("base2width")<>"" then base2width=formatnumber(rs("base2width"),2)
	If rs("base1length")<>"" then base1length=formatnumber(rs("base1length"),2)
	If rs("base2length")<>"" then base2length=formatnumber(rs("base2length"),2)
	If rs("topper1width")<>"" then topper1width=formatnumber(rs("topper1width"),2)
	If rs("topper1length")<>"" then topper1length=formatnumber(rs("topper1length"),2)
	If rs("legheight")<>"" then legheight=formatnumber(rs("legheight"),2)
end if
rs.close
set rs=nothing
sql="Select * from purchase P, Address A, Contact C Where C.retire='n' AND A.code=C.code AND C.code=P.code AND P.purchase_no=" & type1
Set rs = getMysqlUpdateRecordSet(sql, con)
response.Write("sql=" & sql)
totalExVat=rs("totalExVat")

tradeDiscount=rs("tradeDiscount")
companyname=rs("company")
clientstitle=rs("title")
clientsfirst=rs("first")
clientssurname=rs("surname")
contact=rs("salesusername")
orderno=rs("order_number")
add1=rs("street1")
add2=rs("street2")
add3=rs("street3")
town=rs("town")
county=rs("county")
postcode=rs("postcode")
country=rs("country")
orderdate=rs("order_date")
reference=rs("customerreference")
deldate=rs("deliverydate")
add1d=rs("deliveryadd1")
add2d=rs("deliveryadd2")
add3d=rs("deliveryadd3")
townd=rs("deliverytown")
countyd=rs("deliverycounty")
postcoded=rs("deliverypostcode")
countryd=rs("deliverycountry")
deliveryinstructions=rs("deliveryinstructions")
If rs("mattressrequired")="y" then 
mattressrequired="y"
savoirmodel=rs("savoirmodel")
mattresstype=rs("mattresstype")
tickingoptions=rs("tickingoptions")
mattresswidth=rs("mattresswidth")
mattresslength=rs("mattresslength")
leftsupport=rs("leftsupport")
rightsupport=rs("rightsupport")
ventfinish=rs("ventfinish")
ventposition=rs("ventposition")
mattressinstructions=rs("mattressinstructions")
mattressprice=rs("mattressprice")
end If
If rs("topperrequired")="y" then
topperrequired="y"
toppertype=rs("toppertype")
topperwidth=rs("topperwidth")
topperlength=rs("topperlength")
toppertickingoptions=rs("toppertickingoptions")
specialinstructionstopper=rs("specialinstructionstopper")
topperprice=rs("topperprice")
end if
If rs("baserequired")="y" then
baserequired="y"
basesavoirmodel=rs("basesavoirmodel")
extbase=rs("extbase")
basefabricdesc=rs("basefabricdesc")
basetype=rs("basetype")
basewidth=rs("basewidth")
baselength=rs("baselength")
drawers=rs("basedrawers")
drawerconfig=rs("basedrawerconfigID")
drawerheight=rs("basedrawerheight")
legstyle=rs("legstyle")
legfinish=rs("legfinish")
legheight=rs("legheight")
linkposition=rs("linkposition")
linkfinish=rs("linkfinish")
baseinstructions=rs("baseinstructions")
legprice=rs("legprice")
basefabriccost=rs("basefabriccost")
basefabricmeters=rs("basefabricmeters")
basefabricprice=rs("basefabricprice")
baseprice=rs("baseprice")
upholsteredbase=rs("upholsteredbase")
basefabric=rs("basefabric")
basefabricchoice=rs("basefabricchoice")
upholsteryprice=rs("upholsteryprice")
End If
If rs("headboardrequired")="y" then
	headboardrequired="y"
hbfabriccost=rs("hbfabriccost")
headboardfinish=rs("headboardfinish")
headboardfabricdesc=rs("headboardfabricdesc")
hbfabricmeters=rs("hbfabricmeters")
hbfabricprice=rs("hbfabricprice")
headboardstyle=rs("headboardstyle")
headboardfabric=rs("headboardfabric")
headboardfabricchoice=rs("headboardfabricchoice")
headboardheight=rs("headboardheight")
specialinstructionsheadboard=rs("specialinstructionsheadboard")
headboardprice=rs("headboardprice")
headboardfabricdirection=rs("headboardfabricdirection")
hbfabricoptions=rs("hbfabricoptions")
End If
if rs("legsrequired")="y" then
addlegqty=rs("addlegqty")
legqty=rs("legqty")
specialinstructionslegs=rs("specialinstructionslegs")
end if
If rs("valancerequired")="y" then
	valancerequired="y"
valfabriccost=rs("valfabriccost")

valfabricmeters=rs("valfabricmeters")
valfabricprice=rs("valfabricprice")
pleats=rs("pleats")
valancefabric=rs("valancefabric")
valancefabricchoice=rs("valancefabricchoice")
specialinstructionsvalance=rs("specialinstructionsvalance")
valancefabricdirection=rs("valancefabricdirection")
valancedrop=rs("valancedrop")
valancewidth=rs("valancewidth")
valancelength=rs("valancelength")
valanceprice=rs("valanceprice")
End If
If rs("deliverycharge")="y" then
deliverycharge="y"
End If
bedsettotal=rs("bedsettotal")
paymentstotal=rs("paymentstotal")
specialinstructionsdelivery=rs("specialinstructionsdelivery")
deliveryprice=rs("deliveryprice")
dctype=rs("discounttype")
subtotal=rs("subtotal")
dcresult=rs("discount")
total=rs("total")
outstanding=rs("balanceoutstanding")
accesscheck=rs("accesscheck")

order = type1
%>
<!-- #include file="include-email-order.asp" -->
<%
msg="This auto generated email has been sent to the distribution group called SavoirAdminNewOrder@savoirbeds.co.uk and confirms the following new order<br /><br />" & msg

call sendBatchEmail("ORDER BELOW - Savoirbeds Order Form", msg, "noreply@savoirbeds.co.uk", "SavoirAdminNewOrder@savoirbeds.co.uk", "", "", true, con)


rs.Update
rs.close
set rs=nothing
End If
next
End If
Con.close
set Con=nothing

response.Redirect("orderssubmitted.asp?val=" & recipientordernumbers)
%>


       
</body>
</html>
<%

function capitalise(str)
dim words, word
if isNull(str) or trim(str)="" then
	capitalise=""
else
	words = split(trim(str), " ")
	for each word in words
		If IsNumeric(word) Then
		Else
		word = lcase(word)
		word = ucase(left(word,1)) & (right(word,len(word)-1))
		capitalise = capitalise & word & " "
		End If
	next
	capitalise = left(capitalise, len(capitalise)-1)
end if
end function

%>
<!--<script Language="JavaScript" type="text/javascript">
<!--
	$(document).ready(init);
	function init() {
		var timeout = 1;
		if ( $.browser.safari) {
			timeout = 16000;
		}
		
		window.setTimeout("checkPrint();", timeout);
	}
	function checkPrint() {
		confirm("Did it print OK");
	};
	
	
//-->
<!--</script>-->
   
<!-- #include file="common/logger-out.inc" -->
