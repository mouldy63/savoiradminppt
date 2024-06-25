<%
dim theSql, theRs, totalExVat, deldate1, msg, isamendment, rs4
dim tradeDiscount, companyname, clientstitle, clientsfirst, clientssurname, contact, orderno, add1, add2, add3, town, county, postcode, country, orderdate
dim reference, deldate, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, mattressrequired, savoirmodel, mattresstype
dim tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventfinish, ventposition, mattressinstructions, mattressprice, topperrequired
dim toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, topperprice, baserequired, basesavoirmodel, extbase
dim basefabricdesc, basetype, basewidth, baselength, drawers, drawerconfig, drawerheight, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions
dim legprice, basefabriccost, basefabricmeters, basefabricprice, baseprice, upholsteredbase, basefabric, basefabricchoice, upholsteryprice, headboardrequired
dim hbfabriccost, headboardfinish, headboardfabricdesc, hbfabricmeters, hbfabricprice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight
dim specialinstructionsheadboard, headboardprice, headboardfabricdirection, hbfabricoptions, addlegqty, legqty, specialinstructionslegs, valancerequired
dim valfabriccost, valfabricmeters, valfabricprice, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, valancefabricdirection, valancedrop
dim valancewidth, valancelength, valanceprice, deliverycharge, bedsettotal, paymentstotal, specialinstructionsdelivery, deliveryprice, dctype, subtotal
dim dcresult, total, outstanding, accesscheck, tel, telwork, delphonetype1, delphone1, delphonetype2, delphone2, delphonetype3, delphone3, mobile, email_address
dim ordertypename, bookeddeliverydate, ordernote_notetext, ordernote_followupdate, ordernote_action, matt1width, matt2width, matt1length, matt2length
dim topper1width, topper1length, base1width, base2width, base1length, base2length, basefabricdirection, legsrequired, order
dim oldbed, accessoriestotalcost, vat, showroomname, floortype, hblegs

isamendment = false
order = thePn
theSql = "Select * from purchase P, Address A, Contact C Where C.retire='n' AND A.code=C.code AND C.code=P.code AND P.purchase_no=" & thePn
Set theRs = getMysqlQueryRecordSet(theSql, con)
response.Write("<br>theSql=" & theSql)
totalExVat=theRs("totalExVat")

tradeDiscount=theRs("tradeDiscount")
companyname=theRs("company")
clientstitle=theRs("title")
clientsfirst=theRs("first")
clientssurname=theRs("surname")
contact=theRs("salesusername")
orderno=theRs("order_number")
add1=theRs("street1")
add2=theRs("street2")
add3=theRs("street3")
town=theRs("town")
county=theRs("county")
postcode=theRs("postcode")
country=theRs("country")
orderdate=theRs("order_date")
reference=theRs("customerreference")
deldate=theRs("deliverydate")
add1d=theRs("deliveryadd1")
add2d=theRs("deliveryadd2")
add3d=theRs("deliveryadd3")
townd=theRs("deliverytown")
countyd=theRs("deliverycounty")
postcoded=theRs("deliverypostcode")
countryd=theRs("deliverycountry")
deliveryinstructions=theRs("deliveryinstructions")
If theRs("mattressrequired")="y" then 
mattressrequired="y"
savoirmodel=theRs("savoirmodel")
mattresstype=theRs("mattresstype")
tickingoptions=theRs("tickingoptions")
mattresswidth=theRs("mattresswidth")
mattresslength=theRs("mattresslength")
leftsupport=theRs("leftsupport")
rightsupport=theRs("rightsupport")
ventfinish=theRs("ventfinish")
ventposition=theRs("ventposition")
mattressinstructions=theRs("mattressinstructions")
mattressprice=theRs("mattressprice")
end If
If theRs("topperrequired")="y" then
topperrequired="y"
toppertype=theRs("toppertype")
topperwidth=theRs("topperwidth")
topperlength=theRs("topperlength")
toppertickingoptions=theRs("toppertickingoptions")
specialinstructionstopper=theRs("specialinstructionstopper")
topperprice=theRs("topperprice")
end if
If theRs("baserequired")="y" then
baserequired="y"
basesavoirmodel=theRs("basesavoirmodel")
extbase=theRs("extbase")
basefabricdesc=theRs("basefabricdesc")
basetype=theRs("basetype")
basewidth=theRs("basewidth")
baselength=theRs("baselength")
drawers=theRs("basedrawers")
drawerconfig=theRs("basedrawerconfigID")
drawerheight=theRs("basedrawerheight")
legstyle=theRs("legstyle")
legfinish=theRs("legfinish")
legheight=theRs("legheight")
linkposition=theRs("linkposition")
linkfinish=theRs("linkfinish")
baseinstructions=theRs("baseinstructions")
legprice=theRs("legprice")
basefabriccost=theRs("basefabriccost")
basefabricmeters=theRs("basefabricmeters")
basefabricprice=theRs("basefabricprice")
baseprice=theRs("baseprice")
upholsteredbase=theRs("upholsteredbase")
basefabric=theRs("basefabric")
basefabricchoice=theRs("basefabricchoice")
upholsteryprice=theRs("upholsteryprice")
End If
If theRs("headboardrequired")="y" then
	headboardrequired="y"
hbfabriccost=theRs("hbfabriccost")
headboardfinish=theRs("headboardfinish")
headboardfabricdesc=theRs("headboardfabricdesc")
hbfabricmeters=theRs("hbfabricmeters")
hbfabricprice=theRs("hbfabricprice")
headboardstyle=theRs("headboardstyle")
headboardfabric=theRs("headboardfabric")
headboardfabricchoice=theRs("headboardfabricchoice")
headboardheight=theRs("headboardheight")
specialinstructionsheadboard=theRs("specialinstructionsheadboard")
headboardprice=theRs("headboardprice")
headboardfabricdirection=theRs("headboardfabricdirection")
hbfabricoptions=theRs("hbfabricoptions")
End If
if theRs("legsrequired")="y" then
	addlegqty=theRs("addlegqty")
	legqty=theRs("legqty")
	specialinstructionslegs=theRs("specialinstructionslegs")
	legsrequired = "y"
else
	legsrequired = "n"
end if
If theRs("valancerequired")="y" then
	valancerequired="y"
valfabriccost=theRs("valfabriccost")

valfabricmeters=theRs("valfabricmeters")
valfabricprice=theRs("valfabricprice")
pleats=theRs("pleats")
valancefabric=theRs("valancefabric")
valancefabricchoice=theRs("valancefabricchoice")
specialinstructionsvalance=theRs("specialinstructionsvalance")
valancefabricdirection=theRs("valancefabricdirection")
valancedrop=theRs("valancedrop")
valancewidth=theRs("valancewidth")
valancelength=theRs("valancelength")
valanceprice=theRs("valanceprice")
End If
If theRs("deliverycharge")="y" then
deliverycharge="y"
End If
bedsettotal=theRs("bedsettotal")
paymentstotal=theRs("paymentstotal")
specialinstructionsdelivery=theRs("specialinstructionsdelivery")
deliveryprice=theRs("deliveryprice")
dctype=theRs("discounttype")
subtotal=theRs("subtotal")
dcresult=theRs("discount")
total=theRs("total")
outstanding=theRs("balanceoutstanding")
accesscheck=theRs("accesscheck")
tel = theRs("tel")
telwork = theRs("telwork")
mobile = theRs("mobile")
email_address = theRs("email_address")
ordertypename = theRs("ordertype")
bookeddeliverydate = theRs("bookeddeliverydate")
basefabricdirection = theRs("basefabricdirection")
oldbed = theRs("oldbed")
vat = theRs("vat")
showroomname = getShowroomName(con, theRs("idlocation"))
accessoriestotalcost = theRs("accessoriestotalcost")
floortype = theRs("floortype")
hblegs = theRs("headboardlegqty")

call getProductionSizes(con, matt1width, matt2width, matt1length, matt2length, topper1width, topper1length, base1width, base2width, base1length, base2length, thePn)

call getPhoneNumber(con, thePn, 1, delphonetype1, delphone1)
call getPhoneNumber(con, thePn, 2, delphonetype2, delphone2)
call getPhoneNumber(con, thePn, 3, delphonetype3, delphone3)

call closers(theRs)
%>
<!-- #include file="include-email-order.asp" -->
<%
dim aSubject, aSender, aTo, aBcc, aAttachment, aCc
aSubject = "NEW ORDER - " & clientssurname & " - " & orderno & " - " & showroomname
aSender = "noreply@savoirbeds.co.uk"
aTo = "SavoirAdminNewOrder@savoirbeds.co.uk"
msg = "This auto generated email has been sent to the distribution group called SavoirAdminNewOrder@savoirbeds.co.uk and confirms the following new order<br /><br />" & msg

call sendBatchEmail(aSubject, msg, aSender, aTo, aAttachment, aCc, true, con)

function getShowroomName(byref acon, aIdLocation)
	dim ars
	set ars = getMysqlQueryRecordSet("select * from location where idlocation=" & aIdLocation, con)
	getShowroomName = ars("adminheading")
	call closers(ars)
end function

sub getProductionSizes(byref acon, byref amatt1width, byref amatt2width, byref amatt1length, byref amatt2length, byref atopper1width, byref atopper1length, byref abase1width, byref abase2width, byref abase1length, byref abase2length, apn)
	dim ars
	set ars = getMysqlQueryRecordSet("select * from productionsizes where purchase_no=" & apn, con)
	if not ars.eof then
		amatt1width = ars("matt1width")
		amatt2width = ars("matt2width")
		amatt1length = ars("matt1length")
		amatt2length = ars("matt2length")
		atopper1width = ars("topper1width")
		atopper1length = ars("topper1length")
		abase1width = ars("base1width")
		abase2width = ars("base2width")
		abase1length = ars("base1length")
		abase2length = ars("base2length")
	end if
	call closers(ars)
end sub 
%>