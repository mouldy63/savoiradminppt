<%
Option Explicit
%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Dim msg
msg = Request("msg")
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="customerfuncs.asp" -->
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="emailfuncs.asp" -->
<!-- #include file="pricematrixfuncs.asp" -->
<!-- #include file="feature_switches.asp" -->
<%
dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, legprice, addlegprice, baseprice, upholsteredbase, upholsteryprice, valancerequired, valanceprice, accessoriesrequired, bedsettotal, subtotal, headboardrequired, headboardprice, headboardtrimprice, deliverycharge, deliveryprice, total, contact_no, contact, ordertype, orderCurrency, orderdate, reference, companyname, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, signature, dcresult, deposit, outstanding, orderid, dctype, returnUrl, paymentmethod, creditdetails, submith, quote, submit3, converttoorder, currencychecked, percentchecked, basefabricdesc, headboardfabricdesc, headboardfinish, manhattantrim, footboardfinish, footboardheight, paymentstotal, accesscheck, extbase, msg3, locationname
dim i, accessoryCost, accessoryDesc, accessoryUnitPrice, accessoryQty, accessoriestotalcost, company, paymentEmailCC
Dim objMail, aRecipients, isTrade, totalExVat, vat, vatRate, tradeDiscountRate, tradeDiscount, myMail, basefabricdirection, headboardfabricdirection, valancefabricdirection, bookeddeliverydate, productiondate, acknowdate, acknowversion, isamendment, amendedversionno, rs4, rs5, deldate1, order, showroomname, tel, telwork, mobile, email_address, oldbed
dim ordernote_notetext, ordernote_followupdate, ordernote_action
dim delphonetype1, delphonetype2, delphonetype3, delphone1, delphone2, delphone3
dim customerSourceSite, receiptno, pricelist, pn, pdfContent, subject, recepient
Dim matt1width, matt2width, matt1length, matt2length, base1width, base2width, base1length, base2length, topper1width, topper1length, drawers, drawerconfig, spring, valancewidth, valancelength, valancedrop, accessoryDesign, accessoryColour, accessorySize, basetickingoptions, hbfabricoptions, valancefabricoptions, floortype, emailIdLocation, msg4, drawerheight, legqty, addlegqty, addlegstyle, addlegfinish, hblegs, legsrequired, mattressmadeat, basemadeat, toppermadeatid, headboardmadeatid, legsmadeatid, valancemadeatid, specialinstructionslegs, msg5, msg6, speciallegheight
Dim mattressdiscounttype, standardmattressprice, mattressdiscount, mattressdiscountamt
Dim topperdiscounttype, standardtopperprice, topperdiscount, topperdiscountamt
Dim basediscounttype, standardbaseprice, basediscount, basediscountamt
Dim upholsterydiscounttype, standardupholsteryprice, upholsterydiscount, upholsterydiscountamt
Dim headboarddiscounttype, standardheadboardprice, headboarddiscount, headboarddiscountamt
Dim headboardtrimdiscounttype, standardheadboardtrimprice, headboardtrimdiscount, headboardtrimdiscountamt
Dim legsdiscounttype, standardlegsprice, legsdiscount, legsdiscountamt
Dim addlegsdiscounttype, standardaddlegsprice, addlegsdiscount, addlegsdiscountamt
Dim valancediscounttype, standardvalanceprice, valancediscount, valancediscountamt
dim basefabricdiscounttype, standardbasefabricprice, basefabricdiscount, basefabricdiscountamt
Dim basetrimdiscounttype, standardbasetrimprice, basetrimdiscount, basetrimprice, basetrimdiscountamt
Dim basedrawersdiscounttype, standardbasedrawersprice, basedrawersdiscount, basedrawersprice, basedrawersdiscountamt
Dim standardtotalprice, totaldiscountamt
Dim shipper, shippername, shipperadd1, shipperadd2, shipperadd3, shippertown, shippercounty, shipperpostcode, shippercountry, shippercontact, shippertel
Dim overseas, exworksdate, overseasduty
Dim basetrim, basetrimcolour, headboardwidth, deliverycontact
Dim OrderTotalExVAT, VATWording, priceMatrixEnabled, aDiscountPercent
Dim deliveryIncludesVat, ordersource, remakeguarantee, wrappingtype
Dim customerLocation, VIPmanuallyset, VIPcustomer, customertype, VIPvalid, orderTotals, totalsString, vals, totalspend, acceptemail
remakeguarantee="n"
ordersource=request("ordersource")

if retrieveuserlocation()=34 or retrieveuserlocation()=39 then
OrderTotalExVAT="Sub Total"
VATWording="NY Tax"
else
OrderTotalExVAT="Order Total, Ex VAT"
VATWording="VAT"
end if

wrappingtype=request("wraptype")
deliverycontact = request("deliverycontact")
headboardwidth = request("headboardwidth")
overseasduty = request("overseasduty")
overseas = "n"
exworksdate = request("exworksdate")
overseas = request("overseas")
shipper = request("shipper")
speciallegheight = request("speciallegheight")
specialinstructionslegs = request("specialinstructionslegs")
hblegs = request("hblegs")
legqty = request("legqty")
addlegqty = request("addlegqty")
addlegstyle = request("addlegstyle")
addlegfinish = request("addlegfinish")
drawerheight = request("drawerheight")
floortype = request("floortype")
hbfabricoptions = request("hbfabricoptions")
valancefabricoptions = request("valancefabricoptions")
basetickingoptions = request("basetickingoptions")
valancewidth = request("valancewidth")
valancelength = request("valancelength")
valancedrop = request("valancedrop")
matt1width = request("matt1width")

matt2width = request("matt2width")
matt1length = request("matt1length")
matt2length = request("matt2length")
base1width = request("base1width")
base2width = request("base2width")
base1length = request("base1length")
base2length = request("base2length")
topper1width = request("topper1width")
topper1length = request("topper1length")
'drawers = request("drawers")
drawerconfig = request("drawerconfig")
spring = request("spring")
basetrim = request("basetrim")
basetrimcolour = request("basetrimcolour")

isamendment = false
converttoorder = ""
converttoorder = Request("converttoorder")
submit3 = Request("submit3")

quote = "n"
quote = Request("quote")
If converttoorder = "y" then quote = "n"
submith = Request("submitH")
dim basefabriccost, basefabricmeters, basefabricprice, hbfabriccost, hbfabricmeters, hbfabricprice, valfabriccost, valfabricmeters, valfabricprice
paymentmethod = Request("paymentmethod")
creditdetails = replaceQuotes(Request("creditdetails") )
oldbed = Request("oldbed")
bookeddeliverydate = Request("bookeddeliverydate")
productiondate = Request("productiondate")
acknowdate = Request("acknowdate")
acknowversion = Request("acknowversion")
dctype = Request("dc")
deposit = Request("deposit")
paymentstotal = deposit
outstanding = Request("outstanding")
total = Request("total")
subtotal = Request("subtotal")
totalExVat = Request("totalexvat")
vat = Request("vat")
vatRate = Request("vatrate")
dcresult = Request("dcresult")
tradeDiscount = Request("tradediscount")
tradeDiscountRate = Request("tradediscountrate")
bedsettotal = Request("bedsettotal")
signature = Request("output")

ordernote_notetext = trim(request("ordernote_notetext") )
ordernote_followupdate = validateDate(request("ordernote_followupdate") )
ordernote_action = request("ordernote_action")

Set Con = getMysqlConnection()
priceMatrixEnabled = isFeatureEnabled(con, "PRICE_MATRIX")

Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
locationname = rs("location")
deliveryIncludesVat = rs("delivery_includes_vat")
call closeRs(rs)

Session.LCID = getLcid(con)

specialinstructionsdelivery = Request("specialinstructionsdelivery")
specialinstructionsvalance = Request("specialinstructionsvalance")
valancefabric = Request("valancefabric")
valancefabricchoice = Request("valancefabricchoice")
pleats = Request("pleats")
specialinstructionsheadboard = Request("specialinstructionsheadboard")
headboardheight = Request("headboardheight")
headboardfabricchoice = Request("headboardfabricchoice")
headboardfabric = Request("headboardfabric")
headboardstyle = Request("headboardstyle")
headboardfabricdirection = Request("headboardfabricdirection")
basefabricchoice = Request("basefabricchoice")
basefabric = Request("basefabric")
basefabricdirection = Request("basefabricdirection")
upholsteredbase = Request("upholsteredbase")
baseinstructions = Request("baseinstructions")
linkposition = Request("linkposition")
linkfinish = Request("linkfinish")
legstyle = Request("legstyle")
legfinish = Request("legfinish")
legheight = Request("legheight")
baselength = Request("baselength")
basestyle = Request("basestyle")
basetype = Request("basetype")
basewidth = Request("basewidth")
basesavoirmodel = Request("basesavoirmodel")
specialinstructionstopper = Request("specialinstructionstopper")
topperlength = Request("topperlength")
toppertickingoptions = Request("toppertickingoptions")
toppertype = Request("toppertype")
topperwidth = Request("topperwidth")
mattressinstructions = Request("mattressinstructions")
ventposition = Request("ventposition")
ventfinish = Request("ventfinish")
leftsupport = Request("leftsupport")
rightsupport = Request("rightsupport")
mattresswidth = Request("mattresswidth")
mattresslength = Request("mattresslength")
tickingoptions = Request("tickingoptions")
mattresstype = request("mattresstype")
savoirmodel = Request("savoirmodel")
if savoirmodel = "No. 1" or savoirmodel = "No. 2" then remakeguarantee="y"
mattressrequired = Request("mattressrequired")
'deliveryinstructions=Request("deliveryinstructions")
tel = Request("tel")
telwork = Request("telwork")
delphonetype1 = Request("delphonetype1")
delphonetype2 = Request("delphonetype2")
delphonetype3 = Request("delphonetype3")
delphone1 = trim(Request("delphone1") )
delphone2 = trim(Request("delphone2") )
delphone3 = trim(Request("delphone3") )
mobile = Request("mobile")
email_address = Request("email_address")
add1 = Request("add1")
add2 = Request("add2")
add3 = Request("add3")
town = Request("town")
county = Request("county")
postcode = Request("postcode")
country = Request("country")
add1d = Request("add1d")
add2d = Request("add2d")
add3d = Request("add3d")
townd = Request("townd")
countyd = Request("countyd")
postcoded = Request("postcoded")
countryd = Request("countryd")

deldate = Request("deldate")

clientstitle = Request("clientstitle")
clientsfirst = Request("clientsfirst")
clientssurname = Request("clientssurname")
reference = Request("reference")
companyname = replaceQuotes(Request("companyname") )

orderdate = Request("orderdate")
orderno = Request("orderno")
contact = Request("contact")
contact_no = Request("contact_no")
isTrade = isTradeCustomer(con, contact_no)
tradeDiscountRate = getTradeDiscountRate(con, contact_no)
ordertype = Request("ordertype")
orderCurrency = Request("ordercurrency")
basefabricdesc = Request("basefabricdesc")
headboardfabricdesc = Request("headboardfabricdesc")
total = 0
bedsettotal = 0
deliverycharge = Request("deliverycharge")
deliveryprice = Request("deliveryprice")
mattressrequired = Request("mattressrequired")
mattressprice = Request("mattressprice")
If mattressprice <> "" Then
    bedsettotal = bedsettotal + CCur(mattressprice)
End If

mattressdiscounttype = Request("mattressdiscounttype")
standardmattressprice = Request("standardmattressprice")
mattressdiscount = Request("mattressdiscount")
if standardmattressprice <> "" and mattressprice <> "" then
    mattressdiscountamt = standardmattressprice - mattressprice
    if mattressdiscountamt < 0.0 then mattressdiscountamt = 0.0
end if

valancerequired = Request("valancerequired")
valanceprice = Request("valanceprice")
valfabriccost = Request("valfabriccost")
valfabricmeters = Request("valfabricmeters")
valfabricprice = Request("valfabricprice")

valancefabricdirection = Request("valancefabricdirection")
If valanceprice <> "" Then
    bedsettotal = bedsettotal + safeCCur(valfabricprice) + safeCCur(valanceprice)
End If

upholsteredbase = Request("upholsteredbase")
upholsteryprice = Request("upholsteryprice")
If upholsteryprice <> "" Then
    bedsettotal = bedsettotal + CCur(upholsteryprice)
End If

baserequired = Request("baserequired")
basefabriccost = Request("basefabriccost")
basefabricmeters = Request("basefabricmeters")
legprice = Request("legprice")
addlegprice = Request("addlegprice")
baseprice = Request("baseprice")
extbase = Request("extbase")
If baseprice <> "" Then
    bedsettotal = bedsettotal + safeCCur(legprice) + safeCCur(addlegprice) + safeCCur(baseprice)
End If

legsdiscounttype = Request("legsdiscounttype")
standardlegsprice = Request("standardlegsprice")
legsdiscount = Request("legsdiscount")
if standardlegsprice <> "" and legprice <> "" then
    legsdiscountamt = standardlegsprice - legprice
    if legsdiscountamt < 0.0 then legsdiscountamt = 0.0
end if

' add legs discount
addlegsdiscounttype = Request("addlegsdiscounttype")
standardaddlegsprice = Request("standardaddlegsprice")
addlegsdiscount = Request("addlegsdiscount")
if standardaddlegsprice <> "" and addlegprice <> "" then
    addlegsdiscountamt = standardaddlegsprice - addlegprice
    if addlegsdiscountamt < 0.0 then addlegsdiscountamt = 0.0
end if

' base fabric & discount
basefabricprice = request("basefabricprice")
If basefabricprice <> "" Then
    bedsettotal = bedsettotal + CCur(basefabricprice)
End If

basefabricdiscounttype = Request("basefabricdiscounttype")
standardbasefabricprice = Request("standardbasefabricprice")
basefabricdiscount = Request("basefabricdiscount")
if standardbasefabricprice <> "" and basefabricprice <> "" then
    basefabricdiscountamt = standardbasefabricprice - basefabricprice
    if basefabricdiscountamt < 0.0 then basefabricdiscountamt = 0.0
end if

' upholstery discount
upholsterydiscounttype = Request("upholsterydiscounttype")
standardupholsteryprice = Request("standardupholsteryprice")
upholsterydiscount = Request("upholsterydiscount")
if standardupholsteryprice <> "" and upholsteryprice <> "" then
    upholsterydiscountamt = standardupholsteryprice - upholsteryprice
    if upholsterydiscountamt < 0.0 then upholsterydiscountamt = 0.0
end if

' base trim & discount
basetrimprice = request("basetrimprice")
If basetrimprice <> "" Then
    bedsettotal = bedsettotal + CCur(basetrimprice)
End If

basetrimdiscounttype = Request("basetrimdiscounttype")
standardbasetrimprice = Request("standardbasetrimprice")
basetrimdiscount = Request("basetrimdiscount")
if standardbasetrimprice <> "" and basetrimprice <> "" then
    basetrimdiscountamt = standardbasetrimprice - basetrimprice
    if basetrimdiscountamt < 0.0 then basetrimdiscountamt = 0.0
end if

' base drawers & discount
basedrawersprice = request("basedrawersprice")
If basedrawersprice <> "" Then
    bedsettotal = bedsettotal + CCur(basedrawersprice)
End If

basedrawersdiscounttype = Request("basedrawersdiscounttype")
standardbasedrawersprice = Request("standardbasedrawersprice")
basedrawersdiscount = Request("basedrawersdiscount")
if standardbasedrawersprice <> "" and basedrawersprice <> "" then
    basedrawersdiscountamt = standardbasedrawersprice - basedrawersprice
    if basedrawersdiscountamt < 0.0 then basedrawersdiscountamt = 0.0
end if

' base discount
basediscounttype = Request("basediscounttype")
standardbaseprice = Request("standardbaseprice")
basediscount = Request("basediscount")
if standardbaseprice <> "" and baseprice <> "" then
    basediscountamt = standardbaseprice - baseprice
    if basediscountamt < 0.0 then basediscountamt = 0.0
end if

topperrequired = Request("topperrequired")
topperprice = Request("topperprice")
If topperprice <> "" Then
    bedsettotal = bedsettotal + safeCCur(topperprice)
End If

topperdiscounttype = Request("topperdiscounttype")
standardtopperprice = Request("standardtopperprice")
topperdiscount = Request("topperdiscount")
if standardtopperprice <> "" and topperprice <> "" then
    topperdiscountamt = standardtopperprice - topperprice
    if topperdiscountamt < 0.0 then topperdiscountamt = 0.0
end if

headboardrequired = Request("headboardrequired")
headboardprice = Request("headboardprice")
headboardtrimprice = Request("headboardtrimprice")
hbfabriccost = Request("hbfabriccost")
hbfabricmeters = Request("hbfabricmeters")
hbfabricprice = Request("hbfabricprice")
headboardfinish = Request("headboardfinish")
manhattantrim = Request("manhattantrim")
footboardheight = Request("footboardheight")
footboardfinish = Request("footboardfinish")
If headboardprice <> "" Then
    bedsettotal = bedsettotal + safeCCur(hbfabricprice) + safeCCur(headboardprice) + safeCCur(headboardtrimprice)
End If

' headboard discount data
headboarddiscounttype = Request("headboarddiscounttype")
standardheadboardprice = Request("standardheadboardprice")
headboarddiscount = Request("headboarddiscount")
if standardheadboardprice <> "" and headboardprice <> "" then
    headboarddiscountamt = standardheadboardprice - headboardprice
    if headboarddiscountamt < 0.0 then headboarddiscountamt = 0.0
end if

' headboard trim discount data
headboardtrimdiscounttype = Request("headboardtrimdiscounttype")
standardheadboardtrimprice = Request("standardheadboardtrimprice")
headboardtrimdiscount = Request("headboardtrimdiscount")
if standardheadboardtrimprice <> "" and headboardtrimprice <> "" then
    headboardtrimdiscountamt = standardheadboardtrimprice - headboardtrimprice
    if headboardtrimdiscountamt < 0.0 then headboardtrimdiscountamt = 0.0
end if

accessoriesrequired = Request("accessoriesrequired")
accessoriestotalcost = 0.0
if accessoriesrequired = "y" then
    for i = 1 to 20
        accessoryCost = safeCCur(Request("acc_unitprice" & i) ) * safeCCur(Request("acc_qty" & i) )
        if accessoryCost > 0.0 then
            accessoriestotalcost = accessoriestotalcost + accessoryCost
        end if
    next
    bedsettotal = bedsettotal + accessoriestotalcost
end if

' discount totals
standardtotalprice = 0
totaldiscountamt = 0
if standardmattressprice > 0 then standardtotalprice = standardtotalprice + standardmattressprice
if mattressdiscountamt > 0 then totaldiscountamt = totaldiscountamt + mattressdiscountamt

if standardbaseprice > 0 then standardtotalprice = standardtotalprice + standardbaseprice
if basediscountamt > 0 then totaldiscountamt = totaldiscountamt + basediscountamt

if standardupholsteryprice > 0 then standardtotalprice = standardtotalprice + standardupholsteryprice
if upholsterydiscountamt > 0 then totaldiscountamt = totaldiscountamt + upholsterydiscountamt

if standardbasetrimprice > 0 then standardtotalprice = standardtotalprice + standardbasetrimprice
if basetrimdiscountamt > 0 then totaldiscountamt = totaldiscountamt + basetrimdiscountamt

if standardbasefabricprice > 0 then standardtotalprice = standardtotalprice + standardbasefabricprice
if basefabricdiscountamt > 0 then totaldiscountamt = totaldiscountamt + basefabricdiscountamt

if standardbasedrawersprice > 0 then standardtotalprice = standardtotalprice + standardbasedrawersprice
if basedrawersdiscountamt > 0 then totaldiscountamt = totaldiscountamt + basedrawersdiscountamt

if standardtopperprice > 0 then standardtotalprice = standardtotalprice + standardtopperprice
if topperdiscountamt > 0 then totaldiscountamt = totaldiscountamt + topperdiscountamt

if standardheadboardprice > 0 then standardtotalprice = standardtotalprice + standardheadboardprice
if headboarddiscountamt > 0 then totaldiscountamt = totaldiscountamt + headboarddiscountamt

if standardheadboardtrimprice > 0 then standardtotalprice = standardtotalprice + standardheadboardtrimprice
if headboardtrimdiscountamt > 0 then totaldiscountamt = totaldiscountamt + headboardtrimdiscountamt

if standardlegsprice > 0 then standardtotalprice = standardtotalprice + standardlegsprice
if legsdiscountamt > 0 then totaldiscountamt = totaldiscountamt + legsdiscountamt

accesscheck = Request("accesscheck")
If deliveryprice <> "" Then
    total = bedsettotal + deliveryprice
End If

'subtotal = bedsettotal

orderno = Request("orderno")
e1 = Request("e1")
correspondence = Request("correspondence")
count = 0
submit = ""
submit = Request("addorder")
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
If found = true then response.Redirect("error.asp")

If submit <> "" or submith <> "" Then
    If ordertype <> "" then
        sql = "Select * from ordertype WHERE ordertypeid=" & ordertype
        Set rs = getMysqlUpdateRecordSet(sql, con)
        Dim ordertypename
        ordertypename = rs("ordertype")
        rs.close
        set rs = nothing
    end if

    If paymentmethod <> "" then
        sql = "Select * from paymentmethod WHERE paymentmethodid=" & paymentmethod
        Set rs = getMysqlQueryRecordSet(sql, con)
        Dim paymentmethodname
        paymentmethodname = rs("paymentmethod")
        rs.close
        set rs = nothing
    end if

    con.begintrans ' wrap db update in a transaction

    sql = "Select * from purchase WHERE order_number=" & request("orderno")
    Set rs = getMysqlUpdateRecordSet(sql, con)
    If not rs.eof then
        If converttoorder = "y" then
            rs("quote") = "n"
			rs("order_date")=now()
            rs.update
        else
            con.rollbacktrans
            response.Write("Order Number already exists - it may be that you have already added this order - please enter a new order")
            response.Redirect("index.asp?orderexists=y")
        end if
    End If
    rs.close
    set rs = nothing
    Dim custcode, contactIdLocation

    ' get the idlocation & email of the contact for the order
    'response.write("contact=" & contact)
    Set rs4 = getMysqlQueryRecordSet("Select * from savoir_user where username like '" & contact & "'", con)
    contactIdLocation = rs4("id_location")
    emailIdLocation = rs4("adminemail")
    call closeRs(rs4)

    sql = "Select * from contact WHERE contact_no=" & contact_no
    Set rs = getMysqlUpdateRecordSet(sql, con)
    customerSourceSite = rs("source_site")
    customerLocation=rs("idlocation")
    customertype=rs("customertype")
    acceptemail=rs("acceptemail")
    VIPvalid="n"
    VIPcustomer=rs("isVIP")
    VIPmanuallyset=rs("isVIPmanuallyset")
    If clientstitle <> "" Then rs("title") = clientstitle
    If clientsfirst <> "" Then rs("first") = clientsfirst
    If clientssurname <> "" Then rs("surname") = clientssurname
    If telwork <> "" then rs("telwork") = telwork
    If mobile <> "" then rs("mobile") = mobile
    If isNull(rs("idlocation") ) or rs("idlocation") = "" then
        rs("idlocation") = contactIdLocation
    end if
    custcode = rs("code")
    rs.Update
    rs.close
    set rs = nothing

    sql = "Select * from address WHERE code=" & custcode
    Set rs = getMysqlUpdateRecordSet(sql, con)
    If tel <> "" then rs("tel") = tel
    If email_address <> "" then rs("email_address") = email_address
    If add1 <> "" then rs("street1") = add1
    If add2 <> "" then rs("street2") = add2
    If add3 <> "" then rs("street3") = add3
    If quote = "n" then rs("status") = "customer"
    If town <> "" then rs("town") = town
    If county <> "" then rs("county") = county
    If postcode <> "" then rs("postcode") = postcode
    If country <> "" then rs("country") = country
    If rs("company") <> "" then company = rs("company") else company = ""
    if retrieveUserLocation()=37 then 
		rs("price_list")="Net Retail"
		pricelist="Net Retail"
		else
		pricelist = rs("price_list")
	end if
    rs.Update
    rs.close
    set rs = nothing

    If converttoorder = "y" then
        Set rs = getMysqlUpdateRecordSet("Select * from purchase WHERE order_number=" & request("orderno"), con)
        If rs("salesusername") <> "" then contact = rs("salesusername")
        else
            Set rs = getMysqlUpdateRecordSet("Select * from purchase", con)
            rs.AddNew
            rs("quote") = quote
            If orderno <> "" then rs("order_number") = orderno
    end if
    If submith <> "" then rs("orderonhold") = "y"
    if headboardwidth <> "" then rs("headboardwidth") = headboardwidth
	rs("wrappingid")=wrappingtype
	rs("ordersource")=ordersource
    rs("overseasOrder") = overseas
    rs("orderConfirmationStatus") = "n"
    rs("amendeddate") = date()
    rs("idlocation") = contactIdLocation
    rs("oldbed") = oldbed
    rs("signature") = signature
    rs("code") = custcode
    rs("source_site") = "SB"
    rs("owning_region") = retrieveUserRegion()
    rs("completedorders") = "n"
    If contact <> "" then rs("salesusername") = contact
    If deliverycontact <> "" then rs("deliverycontact") = deliverycontact
    If bookeddeliverydate <> "" then rs("bookeddeliverydate") = bookeddeliverydate
    If productiondate <> "" then rs("productiondate") = productiondate
    If acknowdate <> "" then rs("acknowdate") = acknowdate
    If acknowversion <> "" then rs("acknowversion") = acknowversion
    If ordertype <> "" then rs("ordertype") = ordertype
    If orderCurrency <> "" then rs("ordercurrency") = orderCurrency
    If orderdate <> "" then rs("order_date") = orderdate
    If reference <> "" then rs("customerreference") = reference
    If companyname <> "" then rs("companyname") = companyname
	'response.Write("deldate=" & deldate)
	'response.End()
    If deldate <> "" then rs("deliverydate") = deldate
	
    If add1d <> "" then rs("deliveryadd1") = add1d
    If add2d <> "" then rs("deliveryadd2") = add2d
    If add3d <> "" then rs("deliveryadd3") = add3d
    If townd <> "" then rs("deliverytown") = townd
    If countyd <> "" then rs("deliverycounty") = countyd
    If postcoded <> "" then rs("deliverypostcode") = postcoded
    If countryd <> "" then rs("deliverycountry") = countryd
    'If deliveryinstructions<>"" then rs("deliveryinstructions")=deliveryinstructions
    If bedsettotal <> "" then rs("bedsettotal") = bedsettotal
    If dcresult <> "" then rs("discount") = dcresult
    If tradediscount <> "" then rs("tradediscount") = tradediscount
    If tradeDiscountRate <> "" then rs("tradediscountrate") = tradeDiscountRate
    If isTrade then
        rs("istrade") = "y"
    else
        rs("istrade") = "n"
    end if
    If dctype <> "" then rs("discounttype") = dctype
    If subtotal <> "" then rs("subtotal") = subtotal
    If vat <> "" then rs("vat") = vat
    If vatRate <> "" then rs("vatrate") = vatRate
    If totalExVat <> "" then rs("totalexvat") = totalExVat
    rs("contact_no") = clng(contact_no)

    If Request("total") <> "" then rs("total") = Request("total")
    If deposit <> "" then rs("paymentstotal") = deposit
    If outstanding <> "" then rs("balanceoutstanding") = outstanding
    If mattressrequired = "y" then
        rs("mattressrequired") = "y"
        mattressmadeat = getMattressMadeAt(savoirmodel)
        If savoirmodel <> "" then rs("savoirmodel") = savoirmodel
        If mattresstype <> "" then rs("mattresstype") = mattresstype
        If tickingoptions <> "" then rs("tickingoptions") = tickingoptions
        If mattresswidth <> "" then rs("mattresswidth") = mattresswidth
        If mattresslength <> "" then rs("mattresslength") = mattresslength
        If leftsupport <> "" then rs("leftsupport") = leftsupport
        If rightsupport <> "" then rs("rightsupport") = rightsupport
        If ventfinish <> "" then rs("ventfinish") = ventfinish
        If ventposition <> "" then rs("ventposition") = ventposition
        If mattressinstructions <> "" then rs("mattressinstructions") = mattressinstructions
        If mattressprice <> "" then rs("mattressprice") = mattressprice
        else
            rs("mattressrequired") = "n"
    end If

    If baserequired = "y" then
        rs("baserequired") = "y"
        basemadeat = getBaseMadeAt(basesavoirmodel)
        If basesavoirmodel <> "" then rs("basesavoirmodel") = basesavoirmodel
        If basetype <> "" then rs("basetype") = basetype
        If basewidth <> "" then rs("basewidth") = basewidth
        If baselength <> "" then rs("baselength") = baselength
        If linkposition <> "" then rs("linkposition") = linkposition
        If linkfinish <> "" then rs("linkfinish") = linkfinish
        If baseinstructions <> "" then rs("baseinstructions") = baseinstructions
        If basefabriccost <> "" then rs("basefabriccost") = basefabriccost
        If basefabricmeters <> "" then rs("basefabricmeters") = basefabricmeters
        If basefabricprice <> "" then rs("basefabricprice") = basefabricprice
        If baseprice <> "" then rs("baseprice") = baseprice
        If upholsteredbase <> "" then rs("upholsteredbase") = upholsteredbase
        If basefabric <> "None" then rs("basefabric") = basefabric
        If basefabricchoice <> "" then rs("basefabricchoice") = basefabricchoice
        If upholsteryprice <> "" then rs("upholsteryprice") = upholsteryprice
        If basetrimprice <> "" then rs("basetrimprice") = basetrimprice
        If basedrawersprice <> "" then rs("basedrawersprice") = basedrawersprice
        If basefabricdesc <> "" then rs("basefabricdesc") = basefabricdesc
        If basefabricdirection <> "" then rs("basefabricdirection") = basefabricdirection
        rs("basetickingoptions") = basetickingoptions
        rs("basedrawerconfigid") = drawerconfig
		if rs("basedrawerconfigid")<>"n" then rs("basedrawers") = "Yes" else rs("basedrawers")="No"
        rs("baseheightspring") = spring
        rs("basedrawerheight") = drawerheight
        rs("extbase") = extbase
		if basetrim <> "n" then rs("basetrim") = basetrim
		if basetrimcolour <> "" then rs("basetrimcolour") = basetrimcolour
    else
        rs("baserequired") = "n"
    End If

    If topperrequired = "y" then
        rs("topperrequired") = "y"
        toppermadeatid = getTopperMadeAt(toppertype, savoirmodel, basesavoirmodel, mattressmadeat, basemadeat)
        If toppertype <> "" then rs("toppertype") = toppertype
        If topperwidth <> "" then rs("topperwidth") = topperwidth
        If topperlength <> "" then rs("topperlength") = topperlength
        If toppertickingoptions <> "" then rs("toppertickingoptions") = toppertickingoptions
        If specialinstructionstopper <> "" then rs("specialinstructionstopper") = specialinstructionstopper
        If topperprice <> "" then rs("topperprice") = topperprice
        else
            rs("topperrequired") = "n"
    end if

    If legstyle <> "--" then
        rs("orderConfirmationStatus") = "n"
        legsrequired = "y"
        rs("legsrequired") = "y"
        legsmadeatid = getLegsMadeAt()
        if floortype <> "" then rs("floortype") = floortype
        If legprice <> "" and legprice <> "0" and trim(legprice) <> "," then rs("legprice") = legprice else rs("legprice") = 0
		If addlegprice <> "" and addlegprice <> "0" and trim(addlegprice) <> "," then rs("addlegprice") = addlegprice else rs("addlegprice") = 0
        If legstyle <> "" then rs("legstyle") = legstyle
        If legfinish <> "" then rs("legfinish") = legfinish
        If legheight <> "" then rs("legheight") = legheight
        if specialinstructionslegs <> "" then rs("specialinstructionslegs") = specialinstructionslegs
if legqty<>"" then rs("legqty") = legqty
if addlegqty<>"" then rs("addlegqty") = addlegqty
If addlegstyle <> "" then rs("addlegstyle") = addlegstyle
If addlegfinish <> "" then rs("addlegfinish") = addlegfinish
    else
        legsrequired = "n"
        rs("legqty") = 0
        rs("addlegqty") = 0
    end if

    If headboardrequired = "y" then
        rs("headboardrequired") = "y"
        headboardmadeatid = getHeadboardMadeAt(headboardstyle, basemadeat, mattressmadeat)
        If headboardstyle <> "" then rs("headboardstyle") = headboardstyle
        If headboardfabric <> "None" then rs("headboardfabric") = headboardfabric
        If headboardfabricchoice <> "" then rs("headboardfabricchoice") = headboardfabricchoice
        If headboardheight <> "" then rs("headboardheight") = headboardheight
        If specialinstructionsheadboard <> "" then rs("specialinstructionsheadboard") = specialinstructionsheadboard
        If headboardprice <> "" then rs("headboardprice") = headboardprice
        If headboardtrimprice <> "" then rs("headboardtrimprice") = headboardtrimprice
        If hbfabriccost <> "" then rs("hbfabriccost") = hbfabriccost
        If hbfabricmeters <> "" then rs("hbfabricmeters") = hbfabricmeters
        If hbfabricprice <> "" then rs("hbfabricprice") = hbfabricprice
        If headboardfabricdesc <> "" then rs("headboardfabricdesc") = headboardfabricdesc
        If headboardfinish <> "" then rs("headboardfinish") = headboardfinish
        If manhattantrim <> "" then rs("manhattantrim") = manhattantrim
		If footboardheight <> "" then rs("footboardheight") = footboardheight
		If footboardfinish <> "" then rs("footboardfinish") = footboardfinish
        If headboardfabricdirection <> "" then rs("headboardfabricdirection") = headboardfabricdirection
        rs("hbfabricoptions") = hbfabricoptions
        rs("headboardlegqty") = hblegs
    else
        rs("headboardrequired") = "n"
    End If
    If valancerequired = "y" then
        rs("valancerequired") = "y"
        valancemadeatid = getValanceMadeAt()
        If pleats <> "" then rs("pleats") = pleats
        If valancefabric <> "None" then rs("valancefabric") = valancefabric
        If valancefabricchoice <> "" then rs("valancefabricchoice") = valancefabricchoice
        If specialinstructionsvalance <> "" then rs("specialinstructionsvalance") = specialinstructionsvalance
        If valanceprice <> "" then rs("valanceprice") = valanceprice
        If valfabriccost <> "" then rs("valfabriccost") = valfabriccost
        If valfabricmeters <> "" then rs("valfabricmeters") = valfabricmeters
        If valfabricprice <> "" then rs("valfabricprice") = valfabricprice

        If valancefabricdirection <> "" then rs("valancefabricdirection") = valancefabricdirection
        If valancewidth <> "" then rs("valancewidth") = valancewidth
        If valancelength <> "" then rs("valancelength") = valancelength
        If valancedrop <> "" then rs("valancedrop") = valancedrop
        rs("valancefabricoptions") = valancefabricoptions
    else
        rs("valancerequired") = "n"
    End If
    If accessoriesrequired = "y" then
        rs("accessoriesrequired") = "y"
        accessoriestotalcost = 0.0
        for i = 1 to 20
            accessoryDesc = replaceQuotes(trim(Request("acc_desc" & i) ) )

            accessoryDesign = trim(Request("acc_design" & i) )

            accessoryColour = trim(Request("acc_colour" & i) )

            accessorySize = replaceQuotes(trim(Request("acc_size" & i) ) )

            accessoryUnitPrice = safeCCur(Request("acc_unitprice" & i) )

            accessoryQty = safeCCur(Request("acc_qty" & i) )
            if accessoryDesc <> "" and accessoryUnitPrice > 0.0 and accessoryQty > 0 then
                accessoriestotalcost = accessoriestotalcost + accessoryUnitPrice * accessoryQty
            end if
        next
        rs("accessoriestotalcost") = accessoriestotalcost
    else
        rs("accessoriesrequired") = "n"
        rs("accessoriestotalcost") = 0.0
    End If
    rs("accesscheck") = accesscheck
    If deliverycharge = "y" then
        rs("deliverycharge") = "y"
        rs("orderConfirmationStatus") = "n"
        If specialinstructionsdelivery <> "" then rs("specialinstructionsdelivery") = specialinstructionsdelivery
        If deliveryprice <> "" then rs("deliveryprice") = deliveryprice
        else
            rs("deliverycharge") = "n"
    End If
    rs.Update
    orderid = rs("purchase_no")
    order = rs("purchase_no")
    rs.close
    set rs = nothing

    'adding oversea collection information begins
    if (exworksdate <> "n" and exworksdate <>"") then

        if mattressrequired = "y" and (overseas = "y" or retrieveUserRegion() <> 1) then
            Set rs = getMysqlUpdateRecordSet("Select * from exportlinks", con)
            rs.AddNew
            rs("LinksCollectionID") = exworksdate
            rs("purchase_no") = order
            rs("componentid") = 1
            rs.Update
            rs.close
            set rs = nothing
        end if
        if valancerequired = "y" and(overseas = "y" or retrieveUserRegion() <> 1) then
            Set rs = getMysqlUpdateRecordSet("Select * from exportlinks", con)
            rs.AddNew
            rs("LinksCollectionID") = exworksdate
            rs("purchase_no") = order
            rs("componentid") = 6
            rs.Update
            rs.close
            set rs = nothing
        end if
        if baserequired = "y" and(overseas = "y" or retrieveUserRegion() <> 1) then
            Set rs = getMysqlUpdateRecordSet("Select * from exportlinks", con)
            rs.AddNew
            rs("LinksCollectionID") = exworksdate
            rs("purchase_no") = order
            rs("componentid") = 3
            rs.Update
            rs.close
            set rs = nothing
        end if
        if topperrequired = "y" and(overseas = "y" or retrieveUserRegion() <> 1) then
            Set rs = getMysqlUpdateRecordSet("Select * from exportlinks", con)
            rs.AddNew
            rs("LinksCollectionID") = exworksdate
            rs("purchase_no") = order
            rs("componentid") = 5
            rs.Update
            rs.close
            set rs = nothing
        end if
        if legsrequired = "y" and(overseas = "y" or retrieveUserRegion() <> 1) then
            Set rs = getMysqlUpdateRecordSet("Select * from exportlinks", con)
            rs.AddNew
            rs("LinksCollectionID") = exworksdate
            rs("purchase_no") = order
            rs("componentid") = 7
            rs.Update
            rs.close
            set rs = nothing
        end if
        if headboardrequired = "y" and(overseas = "y" or retrieveUserRegion() <> 1) then
            Set rs = getMysqlUpdateRecordSet("Select * from exportlinks", con)
            rs.AddNew
            rs("LinksCollectionID") = exworksdate
            rs("purchase_no") = order
            rs("componentid") = 8
            rs.Update
            rs.close
            set rs = nothing
        end if
        if accessoriesrequired = "y" and(overseas = "y" or retrieveUserRegion() <> 1) then
            Set rs = getMysqlUpdateRecordSet("Select * from exportlinks", con)
            rs.AddNew
            rs("LinksCollectionID") = exworksdate
            rs("purchase_no") = order
            rs("componentid") = 9
            rs.Update
            rs.close
            set rs = nothing
        end if
    end if
    'adding oversea collection information ends
    if matt1width <> "" or matt2width <> "" or matt1length <> "" or matt2length <> "" or base1width <> "" or base2width <> "" or base1length <> "" or base2length <> "" or topper1length <> "" or topper1width <> "" or speciallegheight <> "" then
       
		Set rs = getMysqlUpdateRecordSet("Select * from ProductionSizes where purchase_no=" & order, con)
		if rs.eof then
			Set rs = getMysqlUpdateRecordSet("Select * from ProductionSizes", con)
        	rs.AddNew
        	rs("purchase_no") = orderid
		end if
			If matt1width <> "" then rs("matt1width") = matt1width else rs("matt1width") = null
			If matt2width <> "" then rs("matt2width") = matt2width else rs("matt2width") = null
			If matt1length <> "" then rs("matt1length") = matt1length else rs("matt1length") = null
			If matt2length <> "" then rs("matt2length") = matt2length else rs("matt2length") = null
			If base1width <> "" then rs("base1width") = base1width else rs("base1width") = null
			If base2width <> "" then rs("base2width") = base2width else rs("base2width") = null
			If base1length <> "" then rs("base1length") = base1length else rs("base1length") = null
			If base2length <> "" then rs("base2length") = base2length else rs("base2length") = null
			If topper1width <> "" then rs("topper1width") = topper1width else rs("topper1width") = null
			If topper1length <> "" then rs("topper1length") = topper1length else rs("topper1length") = null
			If speciallegheight <> "" then rs("legheight") = speciallegheight else rs("legheight") = null
        rs.update
        rs.close
        set rs = nothing
    end if

    If bookeddeliverydate <> "" or productiondate <> "" then
        call addOrderNote(con, "Contact customer to discuss linen requirements, check production or booked delivery date.", ACTION_REQUIRED, toDbDateTime(now), orderid, "AUTO")
    end if
    if ordernote_notetext <> "" then
        call addOrderNote(con, ordernote_notetext, ordernote_action, ordernote_followupdate, orderid, "MANUAL")
    end if

    sql = "Select * from savoir_user  S, location L where S.id_location=L.idlocation AND username like '" & contact & "'"

    Set rs = getMysqlQueryRecordSet(sql, con)
    If rs.eof then
    else
        showroomname = rs("adminheading")
    end if
    rs.close
    set rs = nothing

    'Add shipper
    if shipper <> "" and shipper <> "n" then
        Set rs = getMysqlQueryRecordSet("Select * from shipper_address where shipper_address_id=" & shipper, con)
        if not rs.eof then
            shippername = rs("shipperName")
            shipperadd1 = rs("add1")
            shipperadd2 = rs("add2")
            shipperadd3 = rs("add3")
            shippertown = rs("town")
            shippercounty = rs("countystate")
            shipperpostcode = rs("postcode")
            shippercountry = rs("country")
            shippercontact = rs("contact")
            shippertel = rs("phone")
        end if
        rs.close
        set rs = nothing

        Set rs = getMysqlUpdateRecordSet("Select * from purchase_shipper", con)
        rs.Addnew
        rs("shipperName") = shippername
        rs("add1") = shipperadd1
        rs("add2") = shipperadd2
        rs("add3") = shipperadd3
        rs("town") = shippertown
        rs("countystate") = shippercounty
        rs("postcode") = shipperpostcode
        rs("country") = shippercountry
        rs("contact") = shippercontact
        rs("phone") = shippertel
        rs("purchase_no") = orderid
        rs.Update
        rs.close
        set rs = nothing
    end if
    'end add shipper


    ' insert the orderaccessory records
    If accessoriesrequired = "y" then
	sql="delete from orderaccessory where purchase_no=" & orderid
	con.execute(sql)
	
        for i = 1 to 20
            accessoryDesc = replaceQuotes(trim(Request("acc_desc" & i) ) )

            accessoryDesign = replaceQuotes(trim(Request("acc_design" & i) ) )

            accessoryColour = replaceQuotes(trim(Request("acc_colour" & i) ) )

            accessorySize = replaceQuotes(trim(Request("acc_size" & i) ) )

            accessoryUnitPrice = safeCCur(Request("acc_unitprice" & i) )

            accessoryQty = safeCCur(Request("acc_qty" & i) )
            if accessoryDesc <> "" and accessoryQty > 0 then
                sql = "insert into orderaccessory (description,design,colour,size,unitprice,qty,purchase_no) values ('" & replaceQuotes(accessoryDesc) & "','" & replaceQuotes(accessoryDesign) & "','" & replaceQuotes(accessoryColour) & "','" & replaceQuotes(accessorySize) & "'," & accessoryUnitPrice & "," & accessoryQty & "," & orderid & ")"
                con.execute(sql)
            end if
        next
    End If
    ' add payment record
    If deposit <> "" then
        Set rs = getMysqlUpdateRecordSet("Select * from payment", con)
        rs.AddNew
        rs("amount") = deposit
        rs("salesusername") = contact
        rs("paymentmethodid") = paymentmethod
        If safeCCur(deposit) < safeCCur(Request("total") ) then
            rs("paymenttype") = "Deposit"
        else
            rs("paymenttype") = "Full Payment"
        end if
        rs("purchase_no") = orderid
        rs("placed") = toDbDateTime(now)
        receiptno = getNextReceiptNumber(con)
        rs("receiptno") = receiptno
        if creditdetails <> "" then rs("creditdetails") = creditdetails
        rs.update
    end if

    if delphone1 <> "" then
        call addUpdatePhoneNumber(con, delphonetype1, orderid, delphone1, 1)
    end if
    if delphone2 <> "" then
        call addUpdatePhoneNumber(con, delphonetype2, orderid, delphone2, 2)
    end if
    if delphone3 <> "" then
        call addUpdatePhoneNumber(con, delphonetype3, orderid, delphone3, 3)
    end if

    ' discounts
    If mattressrequired = "y" then
        call upsertDiscount(con, orderid, 1, mattressdiscounttype, standardmattressprice, mattressprice)
    else
        call deleteDiscount(con, orderid, 1)
    end If

    If baserequired = "y" then
        call upsertDiscount(con, orderid, 3, basediscounttype, standardbaseprice, baseprice)
    else
        call deleteDiscount(con, orderid, 3)
    end If

    If baserequired = "y" and upholsteredbase <> "n" then
        call upsertDiscount(con, orderid, 12, upholsterydiscounttype, standardupholsteryprice, upholsteryprice)
    else
        call deleteDiscount(con, orderid, 12)
    end If

    If baserequired = "y" and upholsteredbase <> "n" then
        call upsertDiscount(con, orderid, 17, basefabricdiscounttype, standardbasefabricprice, basefabricprice)
    else
        call deleteDiscount(con, orderid, 17)
    end If

    If baserequired = "y" and basetrim <> "n" then
        call upsertDiscount(con, orderid, 11, basetrimdiscounttype, standardbasetrimprice, basetrimprice)
    else
        call deleteDiscount(con, orderid, 11)
    end If

	If baserequired = "y" and drawerconfig <> "n" then
		call upsertDiscount(con, orderid, 13, basedrawersdiscounttype, standardbasedrawersprice, basedrawersprice)
	else
		call deleteDiscount(con, orderid, 13)
	end If

    If topperrequired = "y" then
        call upsertDiscount(con, orderid, 5, topperdiscounttype, standardtopperprice, topperprice)
    else
        call deleteDiscount(con, orderid, 5)
    end If

    If headboardrequired = "y" then
        call upsertDiscount(con, orderid, 8, headboarddiscounttype, standardheadboardprice, headboardprice)
    else
        call deleteDiscount(con, orderid, 8)
    end If

    If headboardrequired = "y" and manhattantrim <> "--" and manhattantrim <> "n" then
        call upsertDiscount(con, orderid, 10, headboardtrimdiscounttype, standardheadboardtrimprice, headboardtrimprice)
    else
        call deleteDiscount(con, orderid, 10)
    end If

    If legsrequired = "y" then
        call upsertDiscount(con, orderid, 7, legsdiscounttype, standardlegsprice, legprice)
		call upsertDiscount(con, orderid, 16, addlegsdiscounttype, standardaddlegsprice, addlegprice)
    else
        call deleteDiscount(con, orderid, 7)
    end If

    ' convert SH customer to SB
    ' response.write("<br>customerSourceSite=" & customerSourceSite & "," & contact_no)
    if customerSourceSite <> "SB" then
        call convertCustomerToSavoir(con, contact_no, customerSourceSite)
    end if

    ' insert the qc_history rows
    call insertQcHistoryRowIfNotExists(con, 0, order, 0, retrieveUserID(), 0)
    if mattressrequired = "y" then
        call insertQcHistoryRowIfNotExists(con, 1, order, 0, retrieveUserID(), mattressmadeat)
    end if
    if baserequired = "y" then
        call insertQcHistoryRowIfNotExists(con, 3, order, 0, retrieveUserID(), basemadeat)
    end if
    if topperrequired = "y" then
        call insertQcHistoryRowIfNotExists(con, 5, order, 0, retrieveUserID(), toppermadeatid)
    end if
    if valancerequired = "y" then
        call insertQcHistoryRowIfNotExists(con, 6, order, 0, retrieveUserID(), valancemadeatid)
    end if
    if legsrequired = "y" then
        call insertQcHistoryRowIfNotExists(con, 7, order, 0, retrieveUserID(), legsmadeatid)
    end if
    if headboardrequired = "y" then
        call insertQcHistoryRowIfNotExists(con, 8, order, 0, retrieveUserID(), headboardmadeatid)
    end if
    if accessoriesrequired = "y" then
        call insertQcHistoryRowIfNotExists(con, 9, order, 0, retrieveUserID(), 0)
    end if

    if submit<>"" and quote="n" then

    orderTotals = getCustomerOrdersTotal(con, contact_no)
    totalsString = "Total spend: <b>"
    for i = 1 to ubound(orderTotals)
        if i > 1 then totalsString = totalsString & "&nbsp;&nbsp;"
        vals = split(orderTotals(i), ":")
        totalsString = totalsString & fmtCurrNonHtml(vals(1), true, vals(0)) & " (Ex VAT " & fmtCurrNonHtml(vals(2), true, vals(0)) & ")"
        if vals(0)="GBP" then
        totalspend=vals(1)
        end if
    next
    if customertype=1 and acceptemail="y" and (customerLocation=3 OR customerLocation=4 OR customerLocation=36 OR customerLocation=48) then VIPvalid="y"
        if VIPvalid="y" and totalspend > 19998 and VIPmanuallyset="n" then 
            sql = "Select * from contact WHERE contact_no=" & contact_no
            Set rs = getMysqlUpdateRecordSet(sql, con)
            rs("isVIP")="y"
            rs.Update
            rs.close
            set rs=nothing
        end if
    end if

    ' now that the customer has placed an order, we can set them as wanting to receive emails
    sql = "update contact set acceptemail='y' where contact_no=" & contact_no
    con.execute(sql)
    
    con.committrans ' commit transaction

    ' DONT DO ANY MORE DB UPDATES AFTER HERE AS THEY WILL BE LOST

    If deposit <> "" then
        'send email to accounts
        Dim accountsmsg, accountsubject
        accountsubject = clientssurname
        If company <> "" then accountsubject = accountsubject & " - " & company
        accountsubject = accountsubject & " - " & orderno & " - " & orderCurrency & fmtCurr2(deposit, false, "") & " - " & paymentmethodname
        accountsmsg = "<html><body><font face=""Arial, Helvetica, sans-serif""><b>CUSTOMER PAYMENT</b><br /><table width=""98%"" border=""1""  cellpadding=""3"" cellspacing=""0"">"
        accountsmsg = accountsmsg & "<tr><td>Order Type</td><td>" & ordertypename & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Payment Amount</td><td>" & fmtCurr2(deposit, true, orderCurrency) & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Payment Type</td><td>" & paymentmethodname & "</td></tr>"
        if creditdetails <> "" then
            accountsmsg = accountsmsg & "<tr><td>Credit Details</td><td>" & creditdetails & "</td></tr>"
        end if
        accountsmsg = accountsmsg & "<tr><td>Customer Surname</td><td>" & clientssurname & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Company</td><td>" & company & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Order No</td><td>" & orderno & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Amount Outstanding on this order</td><td>" & fmtCurr2(outstanding, true, outstanding) & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Order Total Amount</td><td>" & fmtCurr2(deposit, true, Request("total") ) & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Payment Source</td><td>" & locationname & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Price List</td><td>" & pricelist & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Receipt No.</td><td>" & receiptno & "</td></tr>"
        accountsmsg = accountsmsg & "</font></body></html>"

        Set myMail = CreateObject("CDO.Message")
        myMail.BodyPart.charset = "utf-8"
        myMail.Configuration.Fields.Item _
            ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2

        'Name or IP of remote SMTP server
        myMail.Configuration.Fields.Item _
            ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "127.0.0.1"

        'Server port
        myMail.Configuration.Fields.Item _
            ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25

        myMail.Configuration.Fields.Update
        myMail.Subject = accountsubject
        myMail.From = "noreply@savoirbeds.co.uk"
        If retrieveUserName() = "maddy" then
            myMail.To = "info@natalex.co.uk"
		elseif retrieveUserRegion() = 17 or retrieveUserRegion() = 19 then
            myMail.To = "Pv@savoirbeds.co.uk,da@savoirbeds.co.uk"
		elseif retrieveUserName() = "dave" then
            myMail.To = "david@natalex.co.uk"
        else
            myMail.To = "SavoirAdminAccounts@savoirbeds.co.uk"
        end if
        paymentEmailCC = getPaymentNotificationEmailAddressForShowroom(retrieveuserlocation(), con)
	    call log(scriptname, "retrieveUserLocation=" & retrieveUserLocation())
	    call log(scriptname, "paymentEmailCC=" & paymentEmailCC)
	    call log(scriptname, "deposit=" & deposit)
        if paymentEmailCC <> "" then
            myMail.CC = paymentEmailCC
        end if
        myMail.BCC = "david@natalex.co.uk"
        myMail.HtmlBody = accountsmsg

        myMail.Send
        set myMail = nothing
	    call log(scriptname, "payment email sent")
    end if

    total = Request("total")
%>
<!-- #include file="include-email-order.asp" -->
<%
    If submith <> "" then
    else
        Set myMail = CreateObject("CDO.Message")
        myMail.BodyPart.charset = "utf-8"
        myMail.Configuration.Fields.Item _
            ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2

        'Name or IP of remote SMTP server
        myMail.Configuration.Fields.Item _
            ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "127.0.0.1"

        'Server port
        myMail.Configuration.Fields.Item _
            ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25

        myMail.Configuration.Fields.Update
        If submit = "SAVE QUOTE" then
            myMail.Subject = "Savoirbeds QUOTE"
        else
            myMail.Subject = "NEW ORDER - " & clientssurname & " - " & orderno & " - " & showroomname
        end if
        myMail.From = "noreply@savoirbeds.co.uk"
        If retrieveUserName() = "maddy" then
            'myMail.To = "info@natalex.co.uk"
        'elseif retrieveUserRegion()=4 then
        '			myMail.To = "pv@savoirbeds.co.uk"
        elseif retrieveUserName() = "dave" then
            myMail.To = "david@natalex.co.uk"
        else
            myMail.To = "SavoirAdminNewOrder@savoirbeds.co.uk"
        end if
        myMail.BCC = "david@natalex.co.uk"
        msg = "This auto generated email has been sent to the distribution group called SavoirAdminNewOrder@savoirbeds.co.uk and confirms the following new order<br /><br />" & msg
        myMail.HtmlBody = msg
        'response.Write("dealer email=" & dealeremail & "<br />idregion= " & idregion & "")
        If submit = "SAVE QUOTE" then
        else
        'myMail.Send
        end if

        set myMail = nothing

        If accesscheck = "Yes" and submit <> "SAVE QUOTE" then
            msg3 = "<html><body><font face=""Arial, Helvetica, sans-serif"">Access check required for " & clientstitle & " " & clientssurname & "<br> Order number " & orderno & ". <br>Order source: " & retrieveUserName() & " - " & locationname & ".  <br>Delivery special instructions are: " & specialinstructionsdelivery & "</font></body></html>"

            Set myMail = CreateObject("CDO.Message")
            myMail.BodyPart.charset = "utf-8"
            myMail.Configuration.Fields.Item _
                ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2

            'Name or IP of remote SMTP server
            myMail.Configuration.Fields.Item _
                ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "127.0.0.1"

            'Server port
            myMail.Configuration.Fields.Item _
                ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25

            myMail.Configuration.Fields.Update
            myMail.Subject = "Access Check Required : " & clientssurname & " " & orderno
            myMail.From = "noreply@savoirbeds.co.uk"
            If retrieveUserName() = "maddy" then
                myMail.To = "info@natalex.co.uk"
            'elseif retrieveUserRegion()=4 then
            '		myMail.To = "pv@savoirbeds.co.uk"
            elseif retrieveUserName() = "dave" then
                myMail.To = "david@natalex.co.uk"
            else
                myMail.To = "SavoirAdminAccessCheck@savoirbeds.co.uk"
            end if
            myMail.HtmlBody = msg3
            'response.Write("dealer email=" & dealeremail & "<br />idregion= " & idregion & "")

            'myMail'
            set myMail = nothing
        End If
    End If
    
    'send email to showroom to alert them to new order being placed
    If ordersource = "Floorstock" or ordersource = "Marketing" then
    
        sql = "Select * from savoir_user S, savoir_userrole U WHERE S.user_id=U.user_id and role_id=17"
        Set rs5 = getMysqlQueryRecordSet(sql, con)
        Dim multiplerecips
        Do until rs5.eof
       	 multiplerecips = multiplerecips & rs5("adminemail")&" "
        rs5.movenext
        loop
        rs5.close
        set rs5 = nothing
    
    
        msg6 = "<html><body><font face=""Arial, Helvetica, sans-serif"">As this order type is (Marketing or Floorstock) then this needs to be approved and confirmed by the following users before this is put into production:<br><br>S.Frederickson<br>Another user – TBC </font></body></html>"
        subject = orderno & ", Floorstock/Marketing Order to be Confirmed,  " & clientstitle & " " & clientsfirst & " " & clientssurname
        If retrieveUserName() = "maddy" then
            recepient = "info@natalex.co.uk"
        elseif retrieveUserName() = "dave" then
            recepient = "david@natalex.co.uk"
        else
            recepient = emailIdLocation
        end if
        call sendBatchEmail(subject, msg6, "noreply@savoirbeds.co.uk", multiplerecips, "", "", true, con)
	end if        
        
    'send email to showroom to alert them to new order being placed
    If quote = "n" or converttoorder = "y" then
        msg4 = "<html><body><font face=""Arial, Helvetica, sans-serif"">The following order has been placed on Savoir Admin, this needs to be confirmed before it proceeds to production.  Please log in to Savoir Admin and check the 'Orders to be Confirmed' list.<br /><br />" & clientstitle & " " & clientssurname & " " & companyname & " -  Order number " & orderno & ". <br>Order date: " & orderdate & ".  <br>Order Value: " & total & "</font></body></html>"
        subject = orderno & ", Order to be Confirmed,  " & clientstitle & " " & clientsfirst & " " & clientssurname
        If retrieveUserName() = "maddy" then
            'recepient = "info@natalex.co.uk"
        elseif retrieveUserRegion() = 17 or retrieveUserRegion() = 19 then
            recepient = "Pv@savoirbeds.co.uk,da@savoirbeds.co.uk"
        elseif retrieveUserName() = "dave" then
            recepient = "david@natalex.co.uk"
        else
            recepient = emailIdLocation
        end if
        'response.Write("dealer email=" & dealeremail & "<br />idregion= " & idregion & "")

        call sendBatchEmail(subject, msg4, "noreply@savoirbeds.co.uk", recepient, "", "", true, con)

        ' send order confirmation email with PDF attachment
       '' pdfContent = createNewOrderPdf(con, orderid, "n")

        msg5 = "<html><body><font face=""Arial, Helvetica, sans-serif"">New Order " & orderno & " has been placed by " & retrieveUserName() & " - " & locationname & " on Savoir Admin.  Please see the attached.</font></body></html>"
        subject = "New Order " & orderno & ",  " & retrieveUserName() & " - " & locationname
        If retrieveUserName() = "maddy" then
            recepient = "info@natalex.co.uk"
        elseif retrieveUserRegion() = 17 or retrieveUserRegion() = 19 then
            recepient = "Pv@savoirbeds.co.uk,da@savoirbeds.co.uk"
        elseif retrieveUserName() = "dave" then
            recepient = "david@natalex.co.uk"
        else
            recepient = "SavoirAdminNewOrder@savoirbeds.co.uk"
        end if
		'REMOVED ONLY ON PPT AS ERROR WITH TEMP FILE - MADDY 21/11/17
        'call sendEmailWithStringAttachment(subject, msg5, "noreply@savoirbeds.co.uk", recepient, "order-" & orderno & ".pdf", pdfContent, con)
    end if

    If quote = "n" or converttoorder = "y" then
        response.Redirect("ordercomplete.asp?val=" & orderid)
    else
        response.Redirect("ordercomplete.asp?quote=y&val=" & orderid)
    end If
End If ' end of "If submit<>"" or submith<>"" Then"



returnUrl = "add-order.asp?" & serialiseFormParams2(request, "", true)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
    "http://www.w3.org/TR/html4/strict.dtd">
<html lang = "en">
    <head>
        <title>Administration.</title>

        <meta http-equiv = "Content-Type" content = "text/html; charset=UTF-8" />

        <meta HTTP-EQUIV = "ROBOTS" content = "NOINDEX,NOFOLLOW" />

        <link href = "Styles/print.css" rel = "Stylesheet" type = "text/css" media = "print" />
        <link href = "Styles/screen.css" rel = "Stylesheet" type = "text/css" />
        <%
        If quote = "n" then
        %>

            <link rel = "stylesheet" href = "Styles/jquery.signaturepad.css">
            
            <!--[if lt IE 9]><script src="scripts/flashcanvas.js"></script><![endif]-->
        <%
        End If
        %>

        <script src = "scripts/jquery.min.js"></script>

<script src = "scripts/keepalive.js"></script>
<!-- #include file="pricematrixenabled.asp" -->
<script src = "price-matrix-funcs.js?date=<%=theDate%>"></script>

<%if userHasRoleInList("NOPRICESUSER") then
'if (retrieveuserid()=181 or retrieveuserid()=182) then%>
<link href="Styles/noprices.css" rel="Stylesheet" type="text/css" />
<%end if%>
    </head>

    <body>
        <div class = "container">
            <!-- #include file="header.asp" -->

            <div class = "content brochure">
                <div class = "one-col head-col">
                    <p></p>
                    <%
                    If quote = "n" or converttoorder = "y" then
                    %>

                        <form action = "order-added.asp" method = "post" name = "form1" class = "sigPad"
                            onSubmit = "return FrontPage_Form1_Validator(this)">
                    <%
                    Else
                    %>

                        <form action = "order-added.asp" method = "post" name = "form1" class = "sigPad2"
                            onSubmit = "return FrontPage_Form1_Validator(this)">
                    <%
                    End If
                    %>

                            <table width = "750" border = "0" align = "center" cellpadding = "2" cellspacing = "2">
                                <tr>
                                    <td colspan = "10">
                                        <%
                                        If quote = "n" then
                                        %>

                                            <h1>Order Summary - Order No. <%= orderno %>&nbsp; -
                                            <%
                                            Response.Write(Request("clientstitle") & " " & Request("clientsfirst") & " " & Request("clientssurname") )
                                            %></h1>
                                        <%
                                        Else
                                        %>

                                            <h1>Quote Summary - Quote No. <%= orderno %>&nbsp; -
                                            <%
                                            Response.Write(Request("clientstitle") & " " & Request("clientsfirst") & " " & Request("clientssurname") )
                                            %></h1>
                                        <%
                                        End If
                                        %>
                                    </td>
                                </tr>

                                <tr>
                                    <td>&nbsp;</td>

                                    <td width = "160" align="center" class="xview">
                                        <b>Price Charged</b>
                                    </td>
                                    <%
                                    if priceMatrixEnabled then
                                    %>

                                        <td colspan="2" width = "100" align="center" class="xview">
                                            <b>DC</b>
                                        </td>

                                        <td width = "100" align="center" class="xview">
                                            <b>Price List</b>
                                        </td>

                                    <%
                                    end if
                                    %>
                                </tr>
                            <%
                            If mattressrequired = "y" Then
                            %>
<input name="mattressprice" type="hidden" value="<%=mattressprice%>" />
<input name="standardmattressprice" type="hidden" value="<%=standardmattressprice%>" />
<input name="mattressdiscounttype" type="hidden" value="<%=mattressdiscounttype%>" />
<input name="mattressdiscount" type="hidden" value="<%=mattressdiscount%>" />
<input name="mattressdiscountamt" type="hidden" value="<%=mattressdiscountamt%>" />
                                <tr>
                                    <td>Mattress</td>

                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(mattressprice, false, orderCurrency) %></td>
                                    <%
                                    if priceMatrixEnabled and standardmattressprice > 0.0 then
                                    	aDiscountPercent = 100 * mattressdiscountamt / standardmattressprice
                                    %>
                                    	<% if mattressdiscountamt > 0 then %>
			                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(mattressdiscountamt, false, orderCurrency) %></td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
                                    	<% if aDiscountPercent > 0 then %>
			                                <td class="xview" align="center"><%=FormatNumber(aDiscountPercent, 2)%>%</td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
		                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(standardmattressprice, false, orderCurrency) %></td>
                                    <%
                                    else
                                    %>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    <%
                                    end if
                                    %>
                                </tr>
                            <%
                            End If
                            If topperrequired = "y" Then
                            %>
<input name="topperprice" type="hidden" value="<%=topperprice%>" />
<input name="standardtopperprice" type="hidden" value="<%=standardtopperprice%>" />
<input name="topperdiscounttype" type="hidden" value="<%=topperdiscounttype%>" />
<input name="topperdiscount" type="hidden" value="<%=topperdiscount%>" />
<input name="topperdiscountamt" type="hidden" value="<%=topperdiscountamt%>" />
                                <tr>
                                    <td>Topper</td>

                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(topperprice, false, orderCurrency) %></td>
                                    <%
                                    if priceMatrixEnabled and standardtopperprice > 0.0 then
                                    	aDiscountPercent = 100 * topperdiscountamt / standardtopperprice
                                    %>
                                    	<% if topperdiscountamt > 0 then %>
			                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(topperdiscountamt, false, orderCurrency) %></td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
                                    	<% if aDiscountPercent > 0 then %>
			                                <td class="xview" align="center"><%=FormatNumber(aDiscountPercent, 2)%>%</td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
		                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(standardtopperprice, false, orderCurrency) %></td>
                                    <%
                                    else
                                    %>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    <%
                                    end if
                                    %>
                                </tr>
                            <%
                            End If
                            If legstyle <> "--" then
                            %>
<input name="legprice" type="hidden" value="<%=legprice%>" />
<input name="standardlegsprice" type="hidden" value="<%=standardlegsprice%>" />
<input name="legsdiscounttype" type="hidden" value="<%=legsdiscounttype%>" />
<input name="legsdiscount" type="hidden" value="<%=legsdiscount%>" />
<input name="legsdiscountamt" type="hidden" value="<%=legsdiscountamt%>" />
                                <tr>
                                    <td>Legs</td>

                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(legprice, false, orderCurrency) %></td>
                                    <%
                                    if priceMatrixEnabled and standardlegsprice > 0.0 then
                                    	aDiscountPercent = 100 * legsdiscountamt / standardlegsprice
                                    %>
                                    	<% if legsdiscountamt > 0 then %>
			                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(legsdiscountamt, false, orderCurrency) %></td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
                                    	<% if aDiscountPercent > 0 then %>
			                                <td class="xview" align="center"><%=FormatNumber(aDiscountPercent, 2)%>%</td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
		                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(standardlegsprice, false, orderCurrency) %></td>
                                    <%
                                    else
                                    %>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    <%
                                    end if
                                    %>
                                </tr>

<input name="addlegprice" type="hidden" value="<%=addlegprice%>" />
<input name="standardaddlegsprice" type="hidden" value="<%=standardaddlegsprice%>" />
<input name="addlegsdiscounttype" type="hidden" value="<%=addlegsdiscounttype%>" />
<input name="addlegsdiscount" type="hidden" value="<%=addlegsdiscount%>" />
<input name="addlegsdiscountamt" type="hidden" value="<%=addlegsdiscountamt%>" />
                                <tr>
                                    <td>Support Legs</td>

                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(addlegprice, false, orderCurrency) %></td>
                                    <%
                                    if priceMatrixEnabled and standardaddlegsprice > 0.0 then
                                    	aDiscountPercent = 100 * addlegsdiscountamt / standardaddlegsprice
                                    %>
                                    	<% if addlegsdiscountamt > 0 then %>
			                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(addlegsdiscountamt, false, orderCurrency) %></td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
                                    	<% if aDiscountPercent > 0 then %>
			                                <td class="xview" align="center"><%=FormatNumber(aDiscountPercent, 2)%>%</td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
		                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(standardaddlegsprice, false, orderCurrency) %></td>
                                    <%
                                    else
                                    %>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    <%
                                    end if
                                    %>
                                </tr>
                            <%
                            End If
                            If baserequired = "y" Then
                            %>
<input name="basefabricprice" type="hidden" value="<%=basefabricprice%>" />
<input name="standardbasefabricprice" type="hidden" value="<%=standardbasefabricprice%>" />
<input name="basefabricdiscounttype" type="hidden" value="<%=basefabricdiscounttype%>" />
<input name="basefabricdiscount" type="hidden" value="<%=basefabricdiscount%>" />
<input name="basefabricdiscountamt" type="hidden" value="<%=basefabricdiscountamt%>" />
                                <tr>
                                    <td>Base Fabric Price</td>

                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(basefabricprice, false, orderCurrency) %></td>
                                    <%
                                    if priceMatrixEnabled and standardbasefabricprice > 0.0 then
                                    	aDiscountPercent = 100 * basefabricdiscountamt / standardbasefabricprice
                                    %>
                                    	<% if basefabricdiscountamt > 0 then %>
			                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(basefabricdiscountamt, false, orderCurrency) %></td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
                                    	<% if aDiscountPercent > 0 then %>
			                                <td class="xview" align="center"><%=FormatNumber(aDiscountPercent, 2)%>%</td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
		                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(standardbasefabricprice, false, orderCurrency) %></td>
                                    <%
                                    else
                                    %>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    <%
                                    end if
                                    %>
                                </tr>
<input name="baseprice" type="hidden" value="<%=baseprice%>" />
<input name="standardbaseprice" type="hidden" value="<%=standardbaseprice%>" />
<input name="basediscounttype" type="hidden" value="<%=basediscounttype%>" />
<input name="basediscount" type="hidden" value="<%=basediscount%>" />
<input name="basediscountamt" type="hidden" value="<%=basediscountamt%>" />
                                <tr>
                                    <td>Base</td>

                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(baseprice, false, orderCurrency) %></td>
                                    <%
                                    if priceMatrixEnabled and standardbaseprice > 0.0 then
                                    	aDiscountPercent = 100 * basediscountamt / standardbaseprice
                                    %>
                                    	<% if basediscountamt > 0 then %>
			                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(basediscountamt, false, orderCurrency) %></td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
                                    	<% if aDiscountPercent > 0 then %>
			                                <td class="xview" align="center"><%=FormatNumber(aDiscountPercent, 2)%>%</td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
		                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(standardbaseprice, false, orderCurrency) %></td>
                                    <%
                                    else
                                    %>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    <%
                                    end if
                                    %>
                                </tr>
<input name="upholsteryprice" type="hidden" value="<%=upholsteryprice%>" />
<input name="standardupholsteryprice" type="hidden" value="<%=standardupholsteryprice%>" />
<input name="upholsterydiscounttype" type="hidden" value="<%=upholsterydiscounttype%>" />
<input name="upholsterydiscount" type="hidden" value="<%=upholsterydiscount%>" />
<input name="upholsterydiscountamt" type="hidden" value="<%=upholsterydiscountamt%>" />
                                <tr>
                                    <td>Upholstered Base</td>

                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(upholsteryprice, false, orderCurrency) %></td>
                                    <%
                                    if priceMatrixEnabled and standardupholsteryprice > 0.0 then
                                    	aDiscountPercent = 100 * upholsterydiscountamt / standardupholsteryprice
                                    %>
                                    	<% if upholsterydiscountamt > 0 then %>
			                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(upholsterydiscountamt, false, orderCurrency) %></td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
                                    	<% if aDiscountPercent > 0 then %>
			                                <td class="xview" align="center"><%=FormatNumber(aDiscountPercent, 2)%>%</td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
		                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(standardupholsteryprice, false, orderCurrency) %></td>
                                    <%
                                    else
                                    %>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    <%
                                    end if
                                    %>
                                </tr>
<input name="basetrimprice" type="hidden" value="<%=basetrimprice%>" />
<input name="standardbasetrimprice" type="hidden" value="<%=standardbasetrimprice%>" />
<input name="basetrimdiscounttype" type="hidden" value="<%=basetrimdiscounttype%>" />
<input name="basetrimdiscount" type="hidden" value="<%=basetrimdiscount%>" />
<input name="basetrimdiscountamt" type="hidden" value="<%=basetrimdiscountamt%>" />
                                <tr>
                                    <td>Base Trim</td>

                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(basetrimprice, false, orderCurrency) %></td>
                                    <%
                                    if priceMatrixEnabled and standardbasetrimprice > 0.0 then
                                    	aDiscountPercent = 100 * basetrimdiscountamt / standardbasetrimprice
                                    %>
                                    	<% if basetrimdiscountamt > 0 then %>
			                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(basetrimdiscountamt, false, orderCurrency) %></td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
                                    	<% if aDiscountPercent > 0 then %>
			                                <td class="xview" align="center"><%=FormatNumber(aDiscountPercent, 2)%>%</td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
		                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(standardbasetrimprice, false, orderCurrency) %></td>
                                    <%
                                    else
                                    %>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    <%
                                    end if
                                    %>
                                </tr>
<input name="basedrawersprice" type="hidden" value="<%=basedrawersprice%>" />
<input name="standardbasedrawersprice" type="hidden" value="<%=standardbasedrawersprice%>" />
<input name="basedrawersdiscounttype" type="hidden" value="<%=basedrawersdiscounttype%>" />
<input name="basedrawersdiscount" type="hidden" value="<%=basedrawersdiscount%>" />
<input name="basedrawersdiscountamt" type="hidden" value="<%=basedrawersdiscountamt%>" />
                                <tr>
                                    <td>Base Drawers</td>

                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(basedrawersprice, false, orderCurrency) %></td>
                                    <%
                                    if priceMatrixEnabled and standardbasedrawersprice > 0.0 then
                                    	aDiscountPercent = 100 * basedrawersdiscountamt / standardbasedrawersprice
                                    %>
                                    	<% if basedrawersdiscountamt > 0 then %>
			                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(basedrawersdiscountamt, false, orderCurrency) %></td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
                                    	<% if aDiscountPercent > 0 then %>
			                                <td class="xview" align="center"><%=FormatNumber(aDiscountPercent, 2)%>%</td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
		                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(standardbasedrawersprice, false, orderCurrency) %></td>
                                    <%
                                    else
                                    %>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    <%
                                    end if
                                    %>
                                </tr>
                            <%
                            End If

                            If headboardrequired = "y" Then
                            %>
<input name="headboardprice" type="hidden" value="<%=headboardprice%>" />
<input name="standardheadboardprice" type="hidden" value="<%=standardheadboardprice%>" />
<input name="headboarddiscounttype" type="hidden" value="<%=headboarddiscounttype%>" />
<input name="headboarddiscount" type="hidden" value="<%=headboarddiscount%>" />
<input name="headboarddiscountamt" type="hidden" value="<%=headboarddiscountamt%>" />
                                <tr>
                                    <td>Headboard</td>

                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(headboardprice, false, orderCurrency) %></td>
                                    <%
                                    if priceMatrixEnabled and standardheadboardprice > 0.0 then
                                    	aDiscountPercent = 100 * headboarddiscountamt / standardheadboardprice
                                    %>
                                    	<% if headboarddiscountamt > 0 then %>
			                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(headboarddiscountamt, false, orderCurrency) %></td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
                                    	<% if aDiscountPercent > 0 then %>
			                                <td class="xview" align="center"><%=FormatNumber(aDiscountPercent, 2)%>%</td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
		                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(standardheadboardprice, false, orderCurrency) %></td>
                                    <%
                                    else
                                    %>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    <%
                                    end if
                                    %>
                                </tr>

<input name="headboardtrimprice" type="hidden" value="<%=headboardtrimprice%>" />
<input name="standardheadboardtrimprice" type="hidden" value="<%=standardheadboardtrimprice%>" />
<input name="headboardtrimdiscounttype" type="hidden" value="<%=headboardtrimdiscounttype%>" />
<input name="headboardtrimdiscount" type="hidden" value="<%=headboardtrimdiscount%>" />
<input name="headboardtrimdiscountamt" type="hidden" value="<%=headboardtrimdiscountamt%>" />
                                <tr>
                                    <td>Headboard Trim</td>

                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(headboardtrimprice, false, orderCurrency) %></td>
                                    <%
                                    if priceMatrixEnabled and standardheadboardtrimprice > 0.0 then
                                    	aDiscountPercent = 100 * headboardtrimdiscountamt / standardheadboardtrimprice
                                    %>
                                    	<% if headboardtrimdiscountamt > 0 then %>
			                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(headboardtrimdiscountamt, false, orderCurrency) %></td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
                                    	<% if aDiscountPercent > 0 then %>
			                                <td class="xview" align="center"><%=FormatNumber(aDiscountPercent, 2)%>%</td>
                                    	<% else %>
	                                    	<td align="center">-</td>
                                    	<% end if %>
		                                <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(standardheadboardtrimprice, false, orderCurrency) %></td>
                                    <%
                                    else
                                    %>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    	<td align="center">-</td>
                                    <%
                                    end if
                                    %>
                                </tr>

<input name="hbfabricprice" type="hidden" value="<%=hbfabricprice%>" />
                                <tr>
                                    <td>Headboard Fabric Price</td>
                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(hbfabricprice, false, orderCurrency) %></td>
                                	<td align="center">-</td>
                                	<td align="center">-</td>
                                	<td align="center">-</td>
                                </tr>
                            <%
                            End If
                            If valancerequired = "y" Then
                            %>
<input name="valanceprice" type="hidden" value="<%=valanceprice%>" />
                                <tr>
                                    <td>Valance</td>
                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(valanceprice, false, orderCurrency) %></td>
                                	<td align="center">-</td>
                                	<td align="center">-</td>
                                	<td align="center">-</td>
                                </tr>

<input name="valfabricprice" type="hidden" value="<%=valfabricprice%>" />
                                <tr>
                                    <td>Valance Fabric Price</td>
                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(valfabricprice, false, orderCurrency) %></td>
                                	<td align="center">-</td>
                                	<td align="center">-</td>
                                	<td align="center">-</td>
                                </tr>

                            <%
                            End If

                            If accessoriesrequired = "y" Then
                            %>
<input name="accessoriestotalcost" type="hidden" value="<%=accessoriestotalcost%>" />
                                <tr>
                                    <td>Accessories</td>
                                    <td class="xview" align="center"><%=getCurrencySymbolForCurrency(orderCurrency)%><%= fmtCurr2(accessoriestotalcost, false, orderCurrency) %></td>
                                	<td align="center">-</td>
                                	<td align="center">-</td>
                                	<td align="center">-</td>
                                </tr>
                            <%
                            End If
                            %>
                                <tr class="xview">
                                    <td>
                                        <strong>Bed Set Total</strong>
                                    </td>

                                    <td align="center">
                                        <span id = "bedsettotalspan"><%= fmtCurr2(bedsettotal, true, orderCurrency) %></span>&nbsp;
                                        <input type = "hidden" name = "bedsettotal" id = "bedsettotal" value="<%= fmtCurr2(bedsettotal, false, orderCurrency) %>" />
                                    </td>
                                        <%
                                        if priceMatrixEnabled then
                                        	if standardtotalprice > 0 then
		                                    	aDiscountPercent = 100 * totaldiscountamt / standardtotalprice
                                        	else
		                                    	aDiscountPercent = 0.0
                                        	end if
                                        %>
	                                    	<% if mattressdiscountamt > 0 then %>
	                                            <td align="center">
	                                                <span id = "totaldiscountamtspan"><%= fmtCurr2(totaldiscountamt, true, orderCurrency) %></span>
	                                            </td>
	                                    	<% else %>
		                                    	<td align="center">-</td>
	                                    	<% end if %>
                                            <input name = "totaldiscountamt" type = "hidden" id = "totaldiscountamt" value = "<%= fmtCurr2(totaldiscountamt, false, orderCurrency) %>" />

	                                    	<% if aDiscountPercent > 0 then %>
				                                <td class="xview" align="center"><%=FormatNumber(aDiscountPercent, 2)%>%</td>
	                                    	<% else %>
		                                    	<td align="center">-</td>
	                                    	<% end if %>

	                                    	<% if standardtotalprice > 0 then %>
	                                            <td align="center">
	                                                <span><%= fmtCurr2(standardtotalprice, true, orderCurrency) %></span>
	                                            </td>
	                                    	<% else %>
		                                    	<td align="center">-</td>
	                                    	<% end if %>
                                            <input name = "standardtotalprice" type = "hidden" id = "standardtotalprice" value = "<%= fmtCurr2(standardtotalprice, false, orderCurrency) %>" />
                                        <%
                                        else
                                        %>
	                                    	<td align="center">-</td>
	                                    	<td align="center">-</td>
	                                    	<td align="center">-</td>
                                        <%
                                        end if
                                        %>
                                </tr>

                                <tr id = "dceditdiv" class="xview">
                                    <td>
                                        <button type = "button" class="xview" onClick = "JavaScript:showHideDiscounts(true);">Edit
                                        DC</button>
                                    </td>
                                </tr>

                                <tr id = "dcremovediv" class="xview">
                                    <td>
                                        <button type = "button" class="xview" onClick = "JavaScript:showHideDiscounts(false);">Remove
                                        DC</button>
                                    </td>
                                </tr>

                                <tr id = "dcdiv" class="xview">
                                    <td>
                                        DC &nbsp;&nbsp; %
                                        <%
                                        If converttoorder = "y" then
                                            if dctype = "currency" then currencychecked = "checked" else currencychecked = ""
                                            if dctype = "percent" then percentchecked = "checked" else percentchecked = ""
                                        %>

                                            <input type = "radio" name = "dc" id = "dc" value = "percent"
                                                <%= percentchecked %>>
                                            &nbsp;&nbsp; <%= getCurrencySymbolForCurrency(orderCurrency) %>

                                            <input type = "radio" name = "dc" id = "dc2" value = "currency"
                                                <%= currencychecked %>>
                                        <%
                                        else
                                        %>

                                            <input type = "radio" name = "dc" id = "dc" value = "percent" checked>
                                            &nbsp;&nbsp; <%= getCurrencySymbolForCurrency(orderCurrency) %>

                                            <input type = "radio" name = "dc" id = "dc2" value = "currency">
                                        <%
                                        end if
                                        %>
                                    </td>

                                    <td>
                                        <label> <input name = "dcresult" type = "text" id = "dcresult" size = "10"
                                                    maxlength = "25" value = "<%= dcresult %>"></label>
                                    </td>
                                </tr>

                                <tr class="xview">
                                    <td>
                                        <strong>Sub Total</strong>
                                    </td>

                                    <td>
                                        <span id = "subtotalspan"><%= fmtCurr2(subtotal, true, orderCurrency) %></span>

                                        <input type = "hidden" name = "subtotal" id = "subtotal"
                                            value = "<%= fmtCurr2(subtotal, false, orderCurrency) %>" />
                                    </td>
                                </tr>

                               
                                        <%
                                        if isTrade then
                                        %>
                                        <%
                                        if tradeDiscountRate > 0 then
                                        %>

                                                <tr class="xview">
                                                    <td>
                                                        Trade Discount (<%= tradeDiscountRate %>%)
                                                    </td>

                                                    <td>
                                                        <span id = "tradediscountspan"></span>

                                                        <input type = "hidden" name = "tradediscount"
                                                            id = "tradediscount" />

                                                        <input type = "hidden" name = "tradediscountrate"
                                                            id = "tradediscountrate"
                                                            value = "<%= tradeDiscountRate %>" />
                                                    </td>
                                                </tr>
                                        <%
                                        end if
                                        %>
								<tr class="xview">
                                    <td>
                                        Delivery Charge
                                    </td>

                                    <td>
                                        <%= fmtCurr2(deliveryprice, true, orderCurrency) %>

                                        <input type = "hidden" name = "deliveryprice" id = "deliveryprice"
                                            value = "<%= fmtCurr2(deliveryprice, false, orderCurrency) %>" />
                                    </td>
                                </tr>
                                            <tr class="xview">
                                                <td>
                                                    <%=OrderTotalExVAT%>
                                                </td>

                                                <td>
                                                    <span id = "totalexvatspan"></span>

                                                    <input type = "hidden" name = "totalexvat" id = "totalexvat" />
                                                </td>
                                            </tr>

                                            <tr class="xview">
                                                <td>
                                                    <%=VATWording%>
                                                </td>

                                                <td>
                                                    <span id = "vatspan"></span>

                                                    <input type = "hidden" name = "vat" id = "vat" />
                                                </td>
                                            </tr>
                                        <%
                                        else
                                        %>
											<tr class="xview">
			                                    <td>
			                                        Delivery Charge
			                                    </td>
			
			                                    <td>
			                                        <%= fmtCurr2(deliveryprice, true, orderCurrency) %>
			
			                                        <input type = "hidden" name = "deliveryprice" id = "deliveryprice"
			                                            value = "<%= fmtCurr2(deliveryprice, false, orderCurrency) %>" />
			                                    </td>
			                                </tr>
                                            <tr class="xview">
                                                <td>
                                                    <%=OrderTotalExVAT%>
                                                </td>

                                                <td>
                                                    <span id = "totalexvatspan"></span>

                                                    <input type = "hidden" name = "totalexvat" id = "totalexvat" />
                                                </td>
                                            </tr>

                                            <tr class="xview">
                                                <td>
                                                   <%=VATWording%>
                                                </td>

                                                <td>
                                                    <span id = "vatspan"></span>

                                                    <input type = "hidden" name = "vat" id = "vat" />
                                                </td>
                                            </tr>
                                        <%
                                        end if
                                        %>
                                            <tr class="xview">
                                                <td>
                                                    <strong>TOTAL</strong>
                                                </td>

                                                <td>
                                                    <span id = "totalspan"><%= fmtCurr2(total, true, orderCurrency) %></span>

                                                    <input type = "hidden" name = "total" id = "total"
                                                        value = "<%= fmtCurr2(total, false, orderCurrency) %>" />
                                                </td>
                                            </tr>

                                            <tr class="xview">
                                                <td>&nbsp;
                                                    
                                                </td>

                                                <td>&nbsp;
                                                    
                                                </td>
                                            </tr>
                                            <%
                                            If quote = "n" or converttoorder = "y" then
                                            %>

                                                <tr class="xview">
                                                    <td>
                                                        Deposit paid
                                                    </td>

                                                    <td>
                                                        <input name = "deposit" type = "text" id = "deposit" size = "10"
                                                            maxlength = "25">
                                                    </td>
                                                </tr>

                                                <tr class="xview">
                                                    <td>
                                                        <strong>Balance Outstanding</strong>
                                                    </td>

                                                    <td>
                                                        <span id = "outstandingspan"><%= fmtCurr2(total, true, orderCurrency) %></span>

                                                        <input type = "hidden" name = "outstanding" id = "outstanding"
                                                            value = "<%= fmtCurr2(total, false, orderCurrency) %>" />
                                                    </td>
                                                </tr>
                                                        <%
                                                        if not hidePaymentType(con, contact_no) then
                                                        %>

                                                                <tr class="xview">
                                                                    <td>&nbsp;
                                                                        
                                                                    </td>

                                                                    <td>&nbsp;
                                                                        
                                                                    </td>

                                                                    <td>
                                                                        <span id = "creditdetailsheader">Enter credit
                                                                        details</span>
                                                                    </td>
                                                                </tr>

                                                                <tr class="xview">
                                                                    <td>
                                                                        Payment Method
                                                                    </td>

                                                                    <td>
                                                                        <%
                                                                        sql = "Select * from paymentmethod"
                                                                            Set rs = getMysqlQueryRecordSet(sql, con)
                                                                        %><label>
                                                                    <select name = "paymentmethod" id = "paymentmethod"
                                                                        onChange = "paymentMethodChanged();">
                                                                                <%
                                                                                do until rs.eof
                                                                                %>

                                                                                    <option value = "<%= rs("paymentmethodid") %>"><%= rs("paymentmethod") %></option>
                                                                                    <%
                                                                                    rs.movenext
                                                                                    loop
                                                                                        rs.close
                                                                                        set rs = nothing
                                                                                    %>
                                                                            </select>

                                                                            </label>
                                                                    </td>

                                                                    <td>
                                                                        <input type = "text" name = "creditdetails"
                                                                            id = "creditdetails" size = "30"
                                                                            maxlength = "50" />
                                                                    </td>
                                                                </tr>
                                                        <%
                                                        else
                                                        %>

                                                            <input name = "paymentmethod" value = "5" type = "hidden"
                                                                id = "paymentmethod" />
                                                        <%
                                                        end if
                                                        %>

                                                            <tr>
                                                                <td>
                                                                    Dispose of Old Bed
                                                                </td>

                                                                <td>
                                                                    <%= oldbed %>&nbsp;
                                                                </td>
                                                            </tr>
                                            <%
                                            End If
                                            %>
                            </table>

                            <p>&nbsp;</p>

                            <table width = "90%" border = "0" align = "center" cellpadding = "2" cellspacing = "2">
                                <%
                                if retrieveUserRegion() = 1 or retrieveUserLocation()=24 or retrieveUserLocation()=17 or retrieveUserLocation()=34 or retrieveUserLocation()=37 then
                                %>

                                    <tr>
                                        <td colspan = "2">
                                            <%
                                            Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
                                                
												response.Write(rs("terms") )
                                                rs.close
                                                set rs = nothing
                                            %>
                                            <%
                                                If quote = "n" or converttoorder = "y" then
                                            %>

                                                    <label><input name = "terms" type = "checkbox" id = "terms"
                                                        value = "terms">
                                                    I have read and understood, the terms and conditions above</label>
                                            <%
                                                End If
                                            %><br />

                                                <br />
                                        </td>
                                    </tr>
                                <%
                                end if
                                %>

                                <tr>
                                    <td width = "87%">&nbsp;
                                        
                                    </td>

                                    <td width = "13%" align = "right">
                                        <input name = "clientstitle" type = "hidden" value = "<%= clientstitle %>">
                                        <input name = "clientsfirst" type = "hidden" value = "<%= clientsfirst %>">
                                        <input name = "clientssurname" type = "hidden" value = "<%= clientssurname %>">
                                        <input name = "add1" type = "hidden" value = "<%= add1 %>">
                                        <input name = "add2" type = "hidden" value = "<%= add2 %>">
                                        <input name = "add3" type = "hidden" value = "<%= add3 %>">
                                        <input name = "town" type = "hidden" value = "<%= town %>">
                                        <input name = "county" type = "hidden" value = "<%= county %>">
                                        <input name = "postcode" type = "hidden" value = "<%= postcode %>">
                                        <input name = "country" type = "hidden" value = "<%= country %>">
                                        <input name = "contact" type = "hidden" value = "<%= contact %>">
                                        <input name = "orderno" type = "hidden" value = "<%= orderno %>">
                                        <input name = "ordertype" type = "hidden" value = "<%= ordertype %>">
                                        <input name = "ordercurrency" type = "hidden" value = "<%= orderCurrency %>">
                                        <%
                                        If converttoorder = "y" then
                                        %>

                                            <input name = "converttoorder" type = "hidden"
                                                value = "<%= converttoorder %>">
                                        <%
                                        End If
                                        %>
                                        <input name = "wraptype" type = "hidden" value = "<%= wrappingtype %>">
										<input name = "ordersource" type = "hidden" value = "<%= ordersource %>">
                                        <input name = "orderdate" type = "hidden" value = "<%= orderdate %>">
                                        <input name = "bookeddeliverydate" type = "hidden"
                                            value = "<%= bookeddeliverydate %>">
                                        <input name = "productiondate" type = "hidden" value = "<%= productiondate %>">
                                        <input name = "acknowdate" type = "hidden" value = "<%= acknowdate %>">
                                        <input name = "acknowversion" type = "hidden" value = "<%= acknowversion %>">
                                        <input name = "reference" type = "hidden" value = "<%= reference %>">
                                        <input name = "companyname" type = "hidden" value = "<%= companyname %>">
                                        <input name = "deldate" type = "hidden" value = "<%= deldate %>">
                                     
                                        <input name = "add1d" type = "hidden" value = "<%= add1d %>">
                                        <input name = "add2d" type = "hidden" value = "<%= add2d %>">
                                        <input name = "add3d" type = "hidden" value = "<%= add3d %>">
                                        <input name = "tel" type = "hidden" value = "<%= tel %>">
                                        <input name = "telwork" type = "hidden" value = "<%= telwork %>">
                                        <input name = "delphonetype1" type = "hidden" value = "<%= delphonetype1 %>">
                                        <input name = "delphonetype2" type = "hidden" value = "<%= delphonetype2 %>">
                                        <input name = "delphonetype3" type = "hidden" value = "<%= delphonetype3 %>">
                                        <input name = "delphone1" type = "hidden" value = "<%= delphone1 %>">
                                        <input name = "delphone2" type = "hidden" value = "<%= delphone2 %>">
                                        <input name = "delphone3" type = "hidden" value = "<%= delphone3 %>">
                                        <input name = "deliverycontact" type = "hidden"
                                            value = "<%= deliverycontact %>">
                                        <input name = "mobile" type = "hidden" value = "<%= mobile %>">
                                        <input name = "email_address" type = "hidden" value = "<%= email_address %>">
                                        <input name = "townd" type = "hidden" value = "<%= townd %>">
                                        <input name = "countyd" type = "hidden" value = "<%= countyd %>">
                                        <input name = "postcoded" type = "hidden" value = "<%= postcoded %>">
                                        <input name = "countryd" type = "hidden" value = "<%= countryd %>">
<!--<input name="deliveryinstructions" type="hidden" value="<%=escHiddenFieldTxt(deliveryinstructions)%>">-->
                                        <input name = "mattressrequired" type = "hidden"
                                            value = "<%= mattressrequired %>">
                                        <input name = "savoirmodel" type = "hidden" value = "<%= savoirmodel %>">
                                        <input name = "mattresstype" type = "hidden" value = "<%= mattresstype %>">
                                        <input name = "tickingoptions" type = "hidden" value = "<%= tickingoptions %>">
                                        <input name = "mattresswidth" type = "hidden" value = "<%= mattresswidth %>">
                                        <input name = "mattresslength" type = "hidden" value = "<%= mattresslength %>">
                                        <input name = "leftsupport" type = "hidden" value = "<%= leftsupport %>">
                                        <input name = "rightsupport" type = "hidden" value = "<%= rightsupport %>">
                                        <input name = "ventfinish" type = "hidden" value = "<%= ventfinish %>">
                                        <input name = "ventposition" type = "hidden" value = "<%= ventposition %>">
                                        <input name = "mattressinstructions" type = "hidden"
                                            value = "<%= escHiddenFieldTxt(mattressinstructions) %>">
                                        <input name = "topperrequired" type = "hidden" value = "<%= topperrequired %>">
                                        <input name = "toppertype" type = "hidden" value = "<%= toppertype %>">
                                        <input name = "topperwidth" type = "hidden" value = "<%= topperwidth %>">
                                        <input name = "topperlength" type = "hidden" value = "<%= topperlength %>">
                                        <input name = "toppertickingoptions" type = "hidden"
                                            value = "<%= toppertickingoptions %>">
                                        <input name = "specialinstructionstopper" type = "hidden"
                                            value = "<%= escHiddenFieldTxt(specialinstructionstopper) %>">
                                        <input name = "baserequired" type = "hidden" value = "<%= baserequired %>">
                                        <input name = "basesavoirmodel" type = "hidden"
                                            value = "<%= basesavoirmodel %>">
                                        <input name = "basetype" type = "hidden" value = "<%= basetype %>">
                                        <input name = "basewidth" type = "hidden" value = "<%= basewidth %>">
                                        <input name = "baselength" type = "hidden" value = "<%= baselength %>">
                                        <input name = "extbase" type = "hidden" value = "<%= extbase %>">
                                        <input name = "legstyle" type = "hidden" value = "<%= legstyle %>">
                                        <input name = "legfinish" type = "hidden" value = "<%= legfinish %>">
                                        <input name = "legheight" type = "hidden" value = "<%= legheight %>">
                                        <input name = "specialinstructionslegs" type = "hidden"
                                            value = "<%= specialinstructionslegs %>">
                                        <input name = "linkposition" type = "hidden" value = "<%= linkposition %>">
                                        <input name = "linkfinish" type = "hidden" value = "<%= linkfinish %>">
                                        <input name = "baseinstructions" type = "hidden"
                                            value = "<%= escHiddenFieldTxt(baseinstructions) %>">
                                        <input name = "upholsteredbase" type = "hidden"
                                            value = "<%= upholsteredbase %>">
                                        <input name = "basefabric" type = "hidden" value = "<%= basefabric %>">
                                        <input name = "basefabriccost" type = "hidden" value = "<%= basefabriccost %>">
                                        <input name = "basefabricmeters" type = "hidden"
                                            value = "<%= basefabricmeters %>">
                                        <input name = "basefabricchoice" type = "hidden"
                                            value = "<%= basefabricchoice %>">
                                        <input name = "basefabricdesc" type = "hidden" value = "<%= basefabricdesc %>">
                                        <input name = "basefabricdirection" type = "hidden"
                                            value = "<%= basefabricdirection %>">
                                        <input name = "headboardrequired" type = "hidden"
                                            value = "<%= headboardrequired %>">
                                        <input name = "headboardstyle" type = "hidden" value = "<%= headboardstyle %>">
                                        <input name = "oldbed" type = "hidden" value = "<%= oldbed %>">
                                        <input name = "headboardfabric" type = "hidden"
                                            value = "<%= headboardfabric %>">
                                        <input name = "headboardfabricchoice" type = "hidden"
                                            value = "<%= headboardfabricchoice %>">
                                        <input name = "headboardheight" type = "hidden"
                                            value = "<%= headboardheight %>">
                                        <input name = "headboardwidth" type = "hidden" value = "<%= headboardwidth %>">
                                        <input name = "hbfabriccost" type = "hidden" value = "<%= hbfabriccost %>">
                                        <input name = "hbfabricmeters" type = "hidden" value = "<%= hbfabricmeters %>">
                                        <input name = "headboardfabricdesc" type = "hidden"
                                            value = "<%= headboardfabricdesc %>">
                                        <input name = "headboardfabricdirection" type = "hidden"
                                            value = "<%= headboardfabricdirection %>">
                                        <input name = "headboardfinish" type = "hidden"
                                            value = "<%= headboardfinish %>">
                                        <input name = "manhattantrim" type = "hidden" value = "<%= manhattantrim %>">
                                       <input name = "footboardheight" type = "hidden" value = "<%= footboardheight %>">
                                       <input name = "footboardfinish" type = "hidden" value = "<%= footboardfinish %>">
                                        <input name = "specialinstructionsheadboard" type = "hidden"
                                            value = "<%= escHiddenFieldTxt(specialinstructionsheadboard) %>">
                                        <input name = "valancerequired" type = "hidden"
                                            value = "<%= valancerequired %>">
                                        <input name = "pleats" type = "hidden" value = "<%= pleats %>">
                                        <input name = "valancefabric" type = "hidden" value = "<%= valancefabric %>">
                                        <input name = "valancefabricchoice" type = "hidden"
                                            value = "<%= valancefabricchoice %>">
                                        <input name = "valancefabricdirection" type = "hidden"
                                            value = "<%= valancefabricdirection %>">
                                        <input name = "valfabriccost" type = "hidden" value = "<%= valfabriccost %>">
                                        <input name = "valfabricmeters" type = "hidden"
                                            value = "<%= valfabricmeters %>">
                                        <input name = "accessoriesrequired" type = "hidden"
                                            value = "<%= accessoriesrequired %>">
                                        <input name = "matt1width" type = "hidden" value = "<%= matt1width %>">
                                        <input name = "matt2width" type = "hidden" value = "<%= matt2width %>">
                                        <input name = "matt1length" type = "hidden" value = "<%= matt1length %>">
                                        <input name = "matt2length" type = "hidden" value = "<%= matt2length %>">
                                        <input name = "base1width" type = "hidden" value = "<%= base1width %>">
                                        <input name = "base2width" type = "hidden" value = "<%= base2width %>">
                                        <input name = "base1length" type = "hidden" value = "<%= base1length %>">
                                        <input name = "base2length" type = "hidden" value = "<%= base2length %>">
                                        <input name = "basetickingoptions" type = "hidden"
                                            value = "<%= basetickingoptions %>">
                                        <input name = "topper1width" type = "hidden" value = "<%= topper1width %>">
                                        <input name = "topper1length" type = "hidden" value = "<%= topper1length %>">
                                        <input name = "vatrate" type = "hidden" value = "<%= vatrate %>">
                                        
                                        <input name = "drawerconfig" type = "hidden" value = "<%= drawerconfig %>">
                                        <input name = "basetrim" type = "hidden" value = "<%= basetrim %>">
										<input name = "basetrimcolour" type = "hidden" value = "<%= basetrimcolour %>">
                                        <input name = "valancewidth" type = "hidden" value = "<%= valancewidth %>">
                                        <input name = "valancelength" type = "hidden" value = "<%= valancelength %>">
                                        <input name = "valancedrop" type = "hidden" value = "<%= valancedrop %>">
                                        <input name = "valancefabricoptions" type = "hidden"
                                            value = "<%= valancefabricoptions %>">
                                        <input name = "hbfabricoptions" type = "hidden"
                                            value = "<%= hbfabricoptions %>">
                                        <input name = "drawerheight" type = "hidden" value = "<%= drawerheight %>">
                                        <input name = "legqty" type = "hidden" value = "<%= legqty %>">
                                        <input name = "addlegqty" type = "hidden" value = "<%= addlegqty %>">
<input name = "addlegstyle" type = "hidden" value = "<%= addlegstyle %>">
<input name = "addlegfinish" type = "hidden" value = "<%= addlegfinish %>">
                                        <input name = "hblegs" type = "hidden" value = "<%= hblegs %>">
                                        <input name = "spring" type = "hidden" value = "<%= spring %>">
                                        <input name = "overseas" type = "hidden" value = "<%= overseas %>">
                                        <input name = "exworksdate" type = "hidden" value = "<%= exworksdate %>">
                                        <input name = "speciallegheight" type = "hidden"
                                            value = "<%= speciallegheight %>">
                                        <%
                                        if accessoriesrequired = "y" then
                                            for i = 1 to 20
                                                accessoryDesc = replaceQuotes(trim(Request("acc_desc" & i) ) )

                                                accessoryDesign = replaceQuotes(trim(Request("acc_design" & i) ) )

                                                accessoryColour = replaceQuotes(trim(Request("acc_colour" & i) ) )

                                                accessorySize = replaceQuotes(trim(Request("acc_size" & i) ) )

                                                accessoryUnitPrice = safeCCur(Request("acc_unitprice" & i) )

                                                accessoryQty = safeCCur(Request("acc_qty" & i) )
                                                if accessoryDesc <> "" and accessoryQty > 0 then
                                        %>

                                                        <input name = "acc_desc<%= i %>" type = "hidden"
                                                            value = "<%= accessoryDesc %>">
                                                        <input name = "acc_design<%= i %>" type = "hidden"
                                                            value = "<%= accessoryDesign %>">
                                                        <input name = "acc_colour<%= i %>" type = "hidden"
                                                            value = "<%= accessoryColour %>">
                                                        <input name = "acc_size<%= i %>" type = "hidden"
                                                            value = "<%= accessorySize %>">
                                                        <input name = "acc_unitprice<%= i %>" type = "hidden"
                                                            value = "<%= accessoryUnitPrice %>">
                                                        <input name = "acc_qty<%= i %>" type = "hidden"
                                                            value = "<%= accessoryQty %>">
                                        <%
                                                end if
                                            next
                                        end if
                                        %>

                                        <input name = "accesscheck" type = "hidden" value = "<%= accesscheck %>">
                                        <input name = "specialinstructionsvalance" type = "hidden"
                                            value = "<%= escHiddenFieldTxt(specialinstructionsvalance) %>">
                                        <input name = "deliverycharge" type = "hidden" value = "<%= deliverycharge %>">
                                        <input name = "specialinstructionsdelivery" type = "hidden"
                                            value = "<%= escHiddenFieldTxt(specialinstructionsdelivery) %>">
                                        <input name = "quote" type = "hidden" value = "<%= quote %>">
                                        <input name = "contact_no" type = "hidden" value = "<%= contact_no %>">
                                        <input name = "shipper" type = "hidden" value = "<%= shipper %>">
                                        <input name = "ordernote_notetext" type = "hidden"
                                            value = "<%= escHiddenFieldTxt(ordernote_notetext) %>">
                                        <input name = "ordernote_followupdate" type = "hidden"
                                            value = "<%= ordernote_followupdate %>">
                                        <input name = "ordernote_action" type = "hidden"
                                            value = "<%= ordernote_action %>">
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <hr />
                                        <%
                                        If quote = "n" or converttoorder = "y" then
                                            if ordertype = "1" then
                                        %>

                                                <b>Customer Signature</b>

                                                <br>
                                                <br>
                                                Print your name:

                                                <input type = "text" name = "name" id = "name"
                                                    value = "<%Response.Write(Request("clientstitle") & " " & Request("clientsfirst") & " " & Request("clientssurname"))%>">
                                                <p class = "drawItDesc">Draw your signature</p>

                                                <ul class = "sigNav">
                                                    <li class = "clearButton"><a href = "#clear">Clear</a></li>

                                                    <li class = "drawIt"><a href = "#draw-it">Please sign below</a></li>
                                                </ul>

                                                <div class = "sig sigWrapper">
                                                    <div class = "typed"></div>

                                                    <canvas class = "pad" width = "298" height = "55">
                                                    </canvas>

                                                    <input type = "hidden" name = "output" id = "output"
                                                        class = "output">
                                                </div>
                                        <%
                                            end if
                                        %>
                                        <%
                                        end if
                                        %>
                                        <%
                                        If quote = "y" then
                                        %>

                                            <input type = "submit" name = "addorder" id = "addorder"
                                                value = "SAVE QUOTE">
                                        <%
                                        Else
                                        %>

                                            <input type = "submit" name = "addorder" id = "addorder"
                                                value = "PLACE ORDER">
                                            <input type = "submit" name = "submitH" id = "submitH" value = "HOLD ORDER">
                                        <%
                                        End If
                                        %>

                                            <p>&nbsp;</p>

                                            <p> <p><%
                                            Response.Write(Request("clientstitle") & " " & Request("clientsfirst") & " " & Request("clientssurname") )
                                            %>&nbsp;</p>

                                            &nbsp;</p>
                                    </td>
                <td align = "right" valign = "top"></td>
                                </tr>
                            </table>

                            <p>&nbsp;</p>

                            <p>&nbsp;</p>

                            <p>&nbsp;</p>

                            <p>&nbsp;</p>

                            <p><br> </p>

                            <p>&nbsp;</p>
                        </form>
            <p></p>
                </div>
            </div>
        </div>
<div></div>

        <script Language = "JavaScript" type = "text/javascript">
        <!--
       function IsNumeric(sText)
           {
              var ValidChars = "0123456789.";
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
       function FrontPage_Form1_Validator(theForm)
       {
           if (theForm.terms && theForm.terms.checked == false)
         {
           alert("Please accept the terms and conditions");
           theForm.terms.focus();
           return (false);
         }
        
       if (!IsNumeric(theForm.dcresult.value)) 
          { 
             alert('Please enter only numbers for DC section') 
             theForm.dcresult.focus();
             return false; 
             }		
       if (theForm.deposit && !IsNumeric(theForm.deposit.value)) 
          { 
             alert('Please enter only numbers for the deposit') 
             theForm.deposit.focus();
             return false; 
             }	
             
       // require that the total Field be greater than the deposit Field
       if (theForm.deposit && theForm.total) {
           var chkVal = theForm.deposit.value/1.0;
           var chkVal2 = theForm.total.value/1.0;
           if (chkVal > chkVal2) {
               alert("The deposit cannot be greater than the total: " + chkVal + "," + chkVal2);
               theForm.deposit.focus();
               return false;
           }
       }
       if (document.form1.addorder) {
           document.form1.addorder.value = 'Please Wait...';
       }
       if (document.form1.submitH) {
           document.form1.submitH.value = 'Please Wait...';
       }
       window.setTimeout("delayedSubmitDisable()", 10);
       
       return true;
       } 
       
       function delayedSubmitDisable() {
         if (document.form1.addorder) {
           document.form1.addorder.disabled = true;  
         }
         if (document.form1.submitH) {
           document.form1.submitH.disabled = true;  
         }
       }
       //-->
        </script>
        <%
        if ordertype = 1 then
        %>

        <script src = "scripts/jquery.signaturepad.min.js">
        </script>

        <script>
            $(document ).ready(function( )
            {
                $('.sigPad' ).signaturePad(
                {
                    drawOnly: true
                } );
            });
        </script>

<script src = "scripts/json2.min.js">
</script>
        <%
        end if
        %>

        <script Language = "JavaScript" type = "text/javascript">
			var vatRateJs;
			var isTradeJs;
            $(document ).ready(init() );

            function init()
			
            {
                calcSubtotal();
                showHideCreditDetails(false );
			    vatRateJs = <%=vatRate%>;
				<% if isTrade then %>
					isTradeJs = "y";
				<% else %>
					isTradeJs = "n";
				<% end if %>
            }

            $('#dcresult' ).blur(function( )
            {
                calcSubtotal();
            });

            $('#dc' ).change(function( )
            {
                calcSubtotal();
            });

            $('#dc2' ).change(function( )
            {
                calcSubtotal();
            });


            function calcSubtotal()
            {
                var percent = $('#dc' ).attr('checked' );
                var discount = $('#dcresult' ).val() / 1.0; // this makes sure we get a number
                var bedsettotal = $('#bedsettotal' ).val();

                if( discount > 0.0 )
                {
                    var subtotal;

                    if( percent )
                    {
                        subtotal = bedsettotal * (1.0 - discount / 100.0);
                    }

                    else
                    {
                        subtotal = bedsettotal - discount;
                    }
                    $('#subtotalspan' ).html(getCurrSym() + subtotal.toFixed(2 ) );
                    $('#subtotal' ).val(subtotal.toFixed(2 ) );
                }

                else
                {
                    $('#subtotalspan' ).html(getCurrSym() + (bedsettotal * 1.0).toFixed(2 ) );
                    $('#subtotal' ).val((bedsettotal * 1.0).toFixed(2 ) );
                }
                setTotal();
            }

            function setTotal()
            {
            	var deliveryPrice = $('#deliveryprice' ).val() * 1.0;
                var total = $('#subtotal' ).val() * 1.0;
                <% if isTrade then %>
                var jsIsTrade = true;
                var jsTradeDiscountRate = <%=tradeDiscountRate%>;
                <% else %>
                var jsIsTrade = false;
                <% end if %>
                var jsVatRate = <%=vatRate%>;
                var jsDelIncVat = true;
                <% if deliveryIncludesVat = "n" then %>
                	jsDelIncVat = false;
                <% end if %>

                if( jsIsTrade )
                {
                    if( jsTradeDiscountRate > 0 )
                    {
                        var tradeDiscount = total * jsTradeDiscountRate / 100.0;
                        total = total - tradeDiscount;
                        $('#tradediscountspan' ).html(getCurrSym() + tradeDiscount.toFixed(2 ) );
                        $('#tradediscount' ).val((tradeDiscount).toFixed(2 ) );
                    }
                	if (jsDelIncVat) {
	                    total = total + deliveryPrice;
	                    var totalExVat = total;
	                    var vat = totalExVat * jsVatRate / 100.0;
	                    total = totalExVat + vat;
                	} else {
	                    var vat = total * jsVatRate / 100.0;
	                    var totalExVat = total + deliveryPrice;
	                    total = totalExVat + vat;
                	}
                }
                else
                {
                	if (jsDelIncVat) {
	                    total = total + deliveryPrice;
	                    var totalExVat = total / (1 + jsVatRate / 100.0);
	                    var vat = total - totalExVat;
                	} else {
	                    var totalExVat = total / (1 + jsVatRate / 100.0) + deliveryPrice;
	                    total = total + deliveryPrice;
	                    var vat = total - totalExVat;
                	}
                }
                
                $('#totalexvatspan' ).html(getCurrSym() + totalExVat.toFixed(2 ) );
                $('#totalexvat' ).val((totalExVat).toFixed(2 ) );
                $('#vatspan' ).html(getCurrSym() + vat.toFixed(2 ) );
                $('#vat' ).val((vat).toFixed(2 ) );
                $('#totalspan' ).html(getCurrSym() + total.toFixed(2 ) );
                $('#total' ).val((total).toFixed(2 ) );
                setOutstanding();
            }

            function getCurrSym()
            {
                return '<%=getCurrencySymbolForCurrency(orderCurrency)%>';
            }

            $('#deposit' ).blur(function( )
            {
                setOutstanding();
            });

            function setOutstanding()
            {
                var outstanding = $('#total' ).val() * 1.0 - $('#deposit' ).val() * 1.0;
                $('#outstandingspan' ).html(getCurrSym() + outstanding.toFixed(2 ) );
                $('#outstanding' ).val(outstanding.toFixed(2 ) );
            }
            <%if converttoorder="y" then%>
				showHideDiscounts(true);
			<%else%>
				showHideDiscounts(false );
			<%end if%>


            function showHideDiscounts( show )
            {
                if( show )
                {
                    $('#dceditdiv' ).hide();
                    $('#dcremovediv' ).show();
                    $('#dcdiv' ).show();
                }

                else
                {
                    $('#dcresult' ).val('' );
                    $('#dcresult' ).blur();
                    $('#dcremovediv' ).hide();
                    $('#dcdiv' ).hide();
                    $('#dceditdiv' ).show();
                }
            }

            function paymentMethodChanged()
            {
                var selection = $("#paymentmethod" ).val();

                if( selection == "7" )
                { // Customer Credit
                    showHideCreditDetails(true );
                }

                else
                {
                    showHideCreditDetails(false );
                    $("#creditdetails" ).val("" );
                }
            }

            function showHideCreditDetails( show )
            {
                if( show )
                {
                    $('#creditdetails' ).show();
                    $('#creditdetailsheader' ).show();
                }

                else
                {
                    $('#creditdetails' ).hide();
                    $('#creditdetailsheader' ).hide();
                }
            }
        </script>
    </body>
</html>
<%
Con.close
Set Con = nothing
%>
<!-- #include file="common/logger-out.inc" -->
