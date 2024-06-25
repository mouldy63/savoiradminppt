<%
Option Explicit
%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="customerfuncs.asp" -->
<!-- #include file="fieldoptionfuncs.asp" -->
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="pricematrixfuncs.asp" -->
<!-- #include file="feature_switches.asp" -->
<!-- #include file="emailfuncs.asp" -->
<!-- #include file="neworder_funcs.asp" -->

<%

Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, legsrequired, legprice, addlegprice, baseprice, upholsteredbase, upholsteryprice, basetrimprice, basedrawersprice, valancerequired, valanceprice, bedsettotal, headboardrequired, headboardprice, headboardtrimprice, deliverycharge, deliveryprice, total, val, orderdate, reference, companyname, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, headboardwidth, headboardfinish, manhattantrim, footboardheight, footboardfinish, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, contact_no, custcode, msg, signature, custname, dctype, subtotal, dcresult, outstanding, addrCoName
dim basefabriccost, basefabricmeters, basefabricprice, hbfabriccost, hbfabricmeters, hbfabricprice, valfabriccost, valfabricmeters, valfabricprice, paymentmethod, creditdetails, refundmethod, quote, otype, basefabricdesc, headboardfabricdesc, paymentstotal, accesscheck, extbase, readonly
dim i, acc_desc, acc_unitprice, acc_wholesalePrice, acc_qty, acc_id, accessoriesrequired, accessoriestotalcost, company, orderCurrency, orderSource, locationname, acc_boxwidth, acc_boxlength, acc_boxheight, acc_boxweight, acc_packedwith
Dim objMail, aRecipients, contact, isTrade, totalExVat, vat, vatRate, tradeDiscountRate, tradeDiscount, basefabricdirection, headboardfabricdirection, valancefabricdirection, bookeddeliverydate, productiondate, acknowdate, acknowversion, isamendment, rs4, deldate1, showroomname, tel, telwork, mobile, email_address, oldbed, optionselected
dim delDateValues(), delDateDescriptions()
Dim paymentmethodname, refundmethodname, amendmentemailrequired
Dim accountsmsg, accountsubject, redirectUrl, paymentEmailCC
dim ordernote_notetext, ordernote_followupdate, ordernote_action, ordernote_id
dim delphonetype1, delphonetype2, delphonetype3, delphone1, delphone2, delphone3
dim typenames(), cancelOrderHref, isCancelled, isComplete, vatRates, prod, receiptno, pricelist, refundreceiptno
Dim matt1widthsingle, matt1width, matt2width, matt1length, matt2length, origmatt1width, origmatt2width, origmatt1length, origmatt2length, origmatt1widthsingle, origbase1width, origbase2width, origbase1length, origbase2length, base1width, base2width, base1length, base2length, topper1width, topper1length, origtopper1width, origtopper1length, drawers, drawerconfig, spring, valancewidth, valancelength, valancedrop, acc_design, acc_colour, acc_size, faborderstatus, basetickingoptions, valancefabricoptions, hbfabricoptions, floortype, msg4, msg6, emailIdLocation, drawerheight, legqty, addlegqty, addlegstyle, addlegfinish, basewidthcalc, productionsizelegs, hblegs, qw, orderNumber, isValid, validated, rs5, rs6, rs7, mattressmadeat, basemadeat, toppermadeatid, headboardmadeatid, legsmadeatid, valancemadeatid, headcardiff, legsmadeat, specialinstructionslegs, origlegheight, speciallegheight
dim jsmsg, shipperaddress, shipper, shippername, shipperadd1, shipperadd2, shipperadd3, shippertown, shippercounty, shipperpostcode, shippercountry, shippercontact, shippertel, invoicedate, invoiceno
dim mattressDiscountObj, topperDiscountObj, baseDiscountObj, baseUpholsteryDiscountObj, baseTrimDiscountObj, baseDrawersDiscountObj, legsDiscountObj, addLegsDiscountObj, headboardDiscountObj, headboardTrimDiscountObj, valanceDiscountObj

Dim mattressdiscounttype, standardmattressprice, mattressdiscount, mattressdiscountamt
Dim topperdiscounttype, standardtopperprice, topperdiscount, topperdiscountamt
Dim basediscounttype, standardbaseprice, basediscount, basediscountamt
Dim upholsterydiscounttype, standardupholsteryprice, upholsterydiscount, upholsterydiscountamt
Dim basetrimdiscounttype, standardbasetrimprice, basetrimdiscount, basetrimdiscountamt
Dim basefabricdiscounttype, standardbasefabricprice, basefabricdiscount, basefabricdiscountamt
Dim basedrawersdiscounttype, standardbasedrawersprice, basedrawersdiscount, basedrawersdiscountamt
Dim headboarddiscounttype, standardheadboardprice, headboarddiscount, headboarddiscountamt
Dim headboardtrimdiscounttype, standardheadboardtrimprice, headboardtrimdiscount, headboardtrimdiscountamt
Dim legsdiscounttype, standardlegsprice, legsdiscount, legsdiscountamt
Dim addlegsdiscounttype, standardaddlegsprice, addlegsdiscount, addlegsdiscountamt
Dim valancediscounttype, standardvalanceprice, valancediscount, valancediscountamt
Dim basetrim, basetrimcolour

Dim idLocation, currentexworksdate, lorrycount
dim lorryarray()
Dim splitshipment, overseasduty, deliverycontact
Dim mattreq, basereq, valreq, topperreq, legsreq, hbreq, accreq
Dim pmtamt, duplicateorder, converttoorder
dim dzOrderNum, dzPurchaseNo, dzUserId, dzType, chcount, OrderTotalExVAT, VATWording, VATRatewording
dim noteHistory
Dim fabricbaseemail, fabriclegsemail, fabrichbemail, fabricvalanceemail, fabricaccessoriesemail, amendemailhdg, amendemailcat
Dim emailArray1(), emailArray2(), emailArray3(), arrayCounter, prodchange 'fabric email arrays
Dim fieldname, pid
Dim basePONumber, hbPONumber, valancePONumber, acc_ponumber, accreadonly, accdisabled, acc_received, acc_checked, acc_qtyfollow, acc_delivered, acc_status, wholesaleInv

Dim Wmattressprice, Wtopperprice, WBaseFabricprice, WBaseUphprice, WBaseTrimprice, WBaseDrawerprice, WBaseprice, Wlegsprice, WSupportlegsprice, WHBFabricprice, WHBTrimprice, WHBprice, Wvalanceprice, Wvalancefabprice
Dim wholesaleEnabled, purchaseLocation

Dim deliveryIncludesVat, baseFabricDiscountObj, ableToSeeProduction, bookeddelreadonly, username
bookeddelreadonly="readonly"
Dim SavoirOwned, defaultwrappingid, isVIP, isVIPmanuallyset
isVIP="n"
isVIPmanuallyset = "n"

SavoirOwned="n"

valancePONumber="n"
basePONumber="n"
hbPONumber="n"
prodchange="n"
arrayCounter=0
fabriclegsemail="n"
fabricbaseemail="n"
fabrichbemail="n"
fabricvalanceemail="n"
fabricaccessoriesemail=""
'ableToSeeProduction=""

if retrieveuserregion()=23 or retrieveuserregion()=4 then
OrderTotalExVAT="Sub Total"
VATWording="Sales Tax"
VATRatewording="Sales Tax"
else
OrderTotalExVAT="Order Total, Ex VAT"
VATWording="VAT"
VATRatewording="VAT Rate"
end if

duplicateorder = "n"
duplicateorder = request("dup")

mattreq = "n"
basereq = "n"
valreq = "n"
topperreq = "n"
legsreq = "n"
hbreq = "n"
accreq = "n"


'overseasduty = request("overseasduty")
deliverycontact = request("deliverycontact")
invoicedate = request("invoicedate")
if invoicedate = "" then invoicedate = toDisplayDate(now() )
invoiceno = request("invoiceno")
shipper = request("shipper")
jsmsg = Request("jsmsg")
speciallegheight = request("speciallegheight")
qw = request("qw")
legqty = request("legqty")
addlegqty = request("addlegqty")
addlegstyle=request("addlegstyle")
addlegfinish=request("addlegfinish")
hblegs = request("hblegs")
drawerheight = request("drawerheight")
valancefabricoptions = request("valancefabricoptions")
hbfabricoptions = request("hbfabricoptions")
basetickingoptions = request("basetickingoptions")
valancewidth = request("valancewidth")
valancelength = request("valancelength")
valancedrop = request("valancedrop")
prod = Request("prod")

spring = request("spring")
drawerconfig = request("drawerconfig")
basetrim = request("basetrim")
basetrimcolour = request("basetrimcolour")
isamendment = true
readonly = (request("readonly") = "y")
quote = Request("quote")
order = Request("order")

bedsettotal = Request("bedsettotal")
paymentmethod = Request("paymentmethod")
creditdetails = replaceQuotes(Request("creditdetails") )
refundmethod = Request("refundmethod")
outstanding = Request("outstanding")
total = Request("total")
totalExVat = request("totalexvat")
vat = request("vat")
dcresult = Request("dcresult")
tradeDiscount = Request("tradediscount")
subtotal = Request("subtotal")
dctype = Request("dc")
amendmentemailrequired = Request("amendmentemailrequired")
custname = ""
msg = ""
oldbed = Request("oldbed")
cancelOrderHref = "cancel-order.asp?purchase_no=" & order & "&ret=" & server.urlencode(request.ServerVariables("URL") & "?" & request.ServerVariables("QUERY_STRING") )

localeref = retrieveuserregion()
Set Con = getMysqlConnection()

sql="Select * from purchase where purchase_no =" & order
Set rs = getMysqlQueryRecordSet(sql, con)
defaultwrappingid=rs("wrappingid")
purchaseLocation=rs("idlocation")
username=rs("salesusername")
if rs("quote")="y" then quote="y"
rs.close
set rs=nothing

sql="Select * from location where idlocation =" & purchaseLocation
Set rs = getMysqlQueryRecordSet(sql, con)
if rs("wholesaleEnabled")="y" then wholesaleEnabled="y" else wholesaleEnabled="n"
deliveryIncludesVat = rs("delivery_includes_vat")
'ableToSeeProduction=rs("savoirowned")
if rs("savoirowned")="y" then SavoirOwned="y"
rs.close
set rs=nothing

sql="Select * from qc_history_latest where componentid=3 AND purchase_no =" & order
Set rs = getMysqlQueryRecordSet(sql, con)
if not rs.eof then
if rs("ponumber")<>"" then basePONumber="y"
end if
rs.close
set rs=nothing
sql="Select * from qc_history_latest where componentid=8 AND purchase_no =" & order
Set rs = getMysqlQueryRecordSet(sql, con)
if not rs.eof then
if rs("ponumber")<>"" then hbPONumber="y"
end if
rs.close
set rs=nothing
sql="Select * from qc_history_latest where componentid=6 AND purchase_no =" & order
Set rs = getMysqlQueryRecordSet(sql, con)
if not rs.eof then
if rs("ponumber")<>"" then valancePONumber="y"
end if
rs.close
set rs=nothing

sql = "Select * from region WHERE id_region=" & localeref
Set rs = getMysqlQueryRecordSet(sql, con)
Session.LCID = rs("locale")
call closeRs(rs)
floortype = request("floortype")
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

bookeddeliverydate = Request("bookeddeliverydate")
productiondate = Request("productiondate")
acknowdate = Request("acknowdate")
acknowversion = Request("acknowversion")
basefabricdirection = Request("basefabricdirection")
valancefabricdirection = Request("valancefabricdirection")
headboardfabricdirection = Request("headboardfabricdirection")
mattressrequired = Request("mattressrequired")
topperrequired = Request("topperrequired")
baserequired = Request("baserequired")
legsrequired = Request("legsrequired")
headboardrequired = Request("headboardrequired")
valancerequired = Request("valancerequired")
accessoriesrequired = Request("accessoriesrequired")
deliverycharge = Request("deliverycharge")
specialinstructionsdelivery = Request("specialinstructionsdelivery")
specialinstructionsvalance = Request("specialinstructions4")
valancefabric = Request("valancefabric")
valancefabricchoice = Request("valancefabricchoice")

pleats = Request("pleats")
specialinstructionsheadboard = Request("specialinstructions3")
headboardheight = Request("headboardheight")
headboardwidth = request("headboardwidth")
headboardfinish = Request("headboardfinish")
manhattantrim = Request("manhattantrim")
footboardheight = Request("footboardheight")
footboardfinish = Request("footboardfinish")
headboardfabricchoice = Request("headboardfabricchoice")
extbase = Request("extbase")
headboardfabric = Request("headboardfabric")
headboardstyle = Request("headboardstyle")
basefabricchoice = Request("basefabricchoice")
basefabric = Request("basefabric")
upholsteredbase = Request("upholsteredbase")
baseinstructions = Request("specialinstructions2")
linkposition = Request("linkposition")
linkfinish = Request("linkfinish")
legstyle = Request("legstyle")
legfinish = Request("legfinish")
legheight = Request("legheight")
specialinstructionslegs = request("specialinstructionslegs")
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
mattressprice = request("mattressprice")
topperprice = request("topperprice")
upholsteryprice = request("upholsteryprice")
basetrimprice = request("basetrimprice")
basedrawersprice = request("basedrawersprice")
headboardprice = request("headboardprice")
headboardtrimprice = request("headboardtrimprice")
legprice = request("legprice")
addlegprice = request("addlegprice")
baseprice = request("baseprice")
valanceprice = request("valanceprice")
deliveryprice = request("deliveryprice")
basefabriccost = Request("basefabriccost")
basefabricmeters = Request("basefabricmeters")
basefabricprice = Request("basefabricprice")
basefabricdesc = Request("basefabricdesc")
hbfabriccost = Request("hbfabriccost")
hbfabricmeters = Request("hbfabricmeters")
hbfabricprice = Request("hbfabricprice")
valfabriccost = Request("valfabriccost")
valfabricmeters = Request("valfabricmeters")
valfabricprice = Request("valfabricprice")
headboardfabricdesc = Request("headboardfabricdesc")
deliveryinstructions = Request("deliveryinstructions")
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
companyname = Request("companyname")
orderno = Request("orderno")
val = Request("val")
accesscheck = Request("accesscheck")

' discounts
mattressdiscounttype = Request("mattressdiscounttype")
standardmattressprice = Request("standardmattressprice")
mattressdiscount = Request("mattressdiscount")
if standardmattressprice <> "" and mattressprice <> "" then
    mattressdiscountamt = standardmattressprice - mattressprice
end if

topperdiscounttype = Request("topperdiscounttype")
standardtopperprice = Request("standardtopperprice")
topperdiscount = Request("topperdiscount")
if standardtopperprice <> "" and topperprice <> "" then
    topperdiscountamt = standardtopperprice - topperprice
end if

' base trim discount
basetrimdiscounttype = Request("basetrimdiscounttype")
standardbasetrimprice = Request("standardbasetrimprice")
basetrimdiscount = Request("basetrimdiscount")
if standardbasetrimprice <> "" and basetrimprice <> "" then
    basetrimdiscountamt = standardbasetrimprice - basetrimprice
end if

' base trim discount
basefabricdiscounttype = Request("basefabricdiscounttype")
standardbasefabricprice = Request("standardbasefabricprice")
basefabricdiscount = Request("basefabricdiscount")
if standardbasefabricprice <> "" and basefabricprice <> "" then
    basefabricdiscountamt = standardbasefabricprice - basefabricprice
end if

' base drawers discount
basedrawersdiscounttype = Request("basedrawersdiscounttype")
standardbasedrawersprice = Request("standardbasedrawersprice")
basedrawersdiscount = Request("basedrawersdiscount")
if standardbasedrawersprice <> "" and basedrawersprice <> "" then
    basedrawersdiscountamt = standardbasedrawersprice - basedrawersprice
end if

' base upholstery discount
upholsterydiscounttype = Request("upholsterydiscounttype")
standardupholsteryprice = Request("standardupholsteryprice")
upholsterydiscount = Request("upholsterydiscount")
if standardupholsteryprice <> "" and upholsteryprice <> "" then
    upholsterydiscountamt = standardupholsteryprice - upholsteryprice
end if

' base discount
basediscounttype = Request("basediscounttype")
standardbaseprice = Request("standardbaseprice")
basediscount = Request("basediscount")
if standardbaseprice <> "" and baseprice <> "" then
    basediscountamt = standardbaseprice - baseprice
end if

' legs discount
legsdiscounttype = Request("legsdiscounttype")
standardlegsprice = Request("standardlegsprice")
legsdiscount = Request("legsdiscount")
if standardlegsprice <> "" and legprice <> "" then
    legsdiscountamt = standardlegsprice - legprice
end if

' add legs discount
addlegsdiscounttype=Request("addlegsdiscounttype")
standardaddlegsprice=Request("standardaddlegsprice")
addlegsdiscount=Request("addlegsdiscount")
if standardaddlegsprice <> "" and addlegprice <> "" then
	addlegsdiscountamt = standardaddlegsprice - addlegprice
end if

' headboard discount data
headboarddiscounttype = Request("headboarddiscounttype")
standardheadboardprice = Request("standardheadboardprice")
headboarddiscount = Request("headboarddiscount")
if standardheadboardprice <> "" and headboardprice <> "" then
    headboarddiscountamt = standardheadboardprice - headboardprice
end if

' headboard trim discount data
headboardtrimdiscounttype = Request("headboardtrimdiscounttype")
standardheadboardtrimprice = Request("standardheadboardtrimprice")
headboardtrimdiscount = Request("headboardtrimdiscount")
if standardheadboardtrimprice <> "" and headboardtrimprice <> "" then
    headboardtrimdiscountamt = standardheadboardtrimprice - headboardtrimprice
end if

' get the customer & currency
Set rs = getMysqlQueryRecordSet("select wholesaleInv,contact_no,ordercurrency,ordersource,tradediscountrate,istrade,cancelled,completedorders,vatRate,idlocation from purchase where purchase_no=" & order, con)
contact_no = rs("contact_no")
wholesaleInv= rs("wholesaleInv")
orderCurrency = rs("ordercurrency")
orderSource = rs("ordersource")
tradeDiscountRate = rs("tradediscountrate")
isTrade = (rs("istrade") = "y")
isCancelled = safeBool(rs("cancelled") )
isComplete = safeBool(rs("completedorders") )
vatRate = rs("vatrate")
if vatRate = "" or isNull(vatRate) then vatRate = getVatRate(con, rs("idlocation"))
idLocation = rs("idlocation")
call closeRs(rs)



' get the company name
Set rs = getMysqlQueryRecordSet("select * from address where code = (select code from purchase where purchase_no=" & order & ")", con)
addrCoName = rs("company")
pricelist = rs("price_list")
call closeRs(rs)
vatRates = getVatRates2(con, vatRate, idLocation)

selcted = ""
count = 0

submit = Request("submit2")
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
Set rs = getMysqlUpdateRecordSet("Select * from ProductionSizes WHERE Purchase_No=" & order, con)
If not rs.eof then
    productionsizelegs = "y"

    If rs("matt1width") <> "" then origmatt1width = formatnumber(rs("matt1width"), 2)
    If rs("matt2width") <> "" then origmatt2width = formatnumber(rs("matt2width"), 2)
    If rs("matt1length") <> "" then origmatt1length = formatnumber(rs("matt1length"), 2)
    If rs("matt2length") <> "" then origmatt2length = formatnumber(rs("matt2length"), 2)
    If rs("base1width") <> "" then origbase1width = formatnumber(rs("base1width"), 2)
    If rs("base2width") <> "" then origbase2width = formatnumber(rs("base2width"), 2)
    If rs("base1length") <> "" then origbase1length = formatnumber(rs("base1length"), 2)
    If rs("base2length") <> "" then origbase2length = formatnumber(rs("base2length"), 2)
    If rs("topper1width") <> "" then origtopper1width = formatnumber(rs("topper1width"), 2)
    If rs("topper1length") <> "" then origtopper1length = formatnumber(rs("topper1length"), 2)
    If rs("legheight") <> "" then origlegheight = formatnumber(rs("legheight"), 2)
end if
rs.close
set rs = nothing
If submit <> "" then
    call checkOrderNotEmpty(request, "edit-purchase.asp?order=" & order) ' this will abort the processing of the form if the order is empty

    con.begintrans                                                       ' wrap db update in a transaction
    'call storeOrderChanges(request, con, order, contact_no)
	sql = "delete from wholesale_prices where Purchase_No=" & order
	con.execute(sql)

    sql = "Select * from contact WHERE Contact_no=" & contact_no
    Set rs = getMysqlUpdateRecordSet(sql, con)
    If clientstitle <> "" Then rs("title") = capitalise(lcase(clientstitle) ) else rs("title") = null
    If clientsfirst <> "" Then rs("first") = capitaliseName(clientsfirst) else rs("first") = null
    If clientssurname <> "" Then rs("surname") = capitaliseName(clientssurname) else rs("surname") = null
    custcode = rs("code")
    rs("updatedby") = retrieveUserName()
    rs("dateupdated") = date()
    If telwork <> "" then rs("telwork") = telwork else rs("telwork") = null
    If mobile <> "" then rs("mobile") = mobile else rs("mobile") = null
    rs.Update
    rs.close
    set rs = nothing

    sql = "Select * from address WHERE code=" & custcode
    Set rs = getMysqlUpdateRecordSet(sql, con)
    If companyname <> "" then rs("company") = companyname
    If tel <> "" then rs("tel") = tel else rs("tel") = null
    If email_address <> "" then rs("email_address") = email_address else rs("email_address") = null
    If add1 <> "" then rs("street1") = add1 else rs("street1") = null
    If add2 <> "" then rs("street2") = add2 else rs("street2") = null
    If add3 <> "" then rs("street3") = add3 else rs("street3") = null
    If town <> "" then rs("town") = town else rs("town") = null
    If county <> "" then rs("county") = county else rs("county") = null
    If postcode <> "" then rs("postcode") = postcode else rs("postcode") = null
    If country <> "" then rs("country") = country else rs("country") = null
    rs.Update
    rs.close
    set rs = nothing

    Dim ordertype, amendedversionno, salesagent, hasprodsizes

    'Check whether special width / length entered and add to table
    hasprodsizes = false
    if matt1width <> "" or matt2width <> "" or matt1length <> "" or matt2length <> "" or base1width <> "" or base2width <> "" or base1length <> "" or base2length <> "" or topper1length <> "" or topper1width <> "" or speciallegheight <> "" then hasprodsizes = true

    Set rs = getMysqlUpdateRecordSet("Select * from ProductionSizes WHERE Purchase_No=" & order, con)
    if rs.eof and hasprodsizes then
        rs.AddNew
        rs("purchase_no") = order
    end if
    if not rs.eof or hasprodsizes then
        if areNotEqual(rs("matt1width"), matt1width) or areNotEqual(rs("matt2width"), matt2width) or areNotEqual(rs("matt1length"), matt1length) or areNotEqual(rs("matt2length"), matt2length) then
            ' the mattress has changed significantly, so the packing data will need to be redone
	        call deletePackagingDataForComponent(con, order, 1)
        end if

        If matt1width <> "" then rs("matt1width") = matt1width else rs("matt1width") = null
        If matt2width <> "" then rs("matt2width") = matt2width else rs("matt2width") = null
        If matt1length <> "" then rs("matt1length") = matt1length else rs("matt1length") = null
        If matt2length <> "" then rs("matt2length") = matt2length else rs("matt2length") = null
        
        if areNotEqual(rs("base1width"), base1width) or areNotEqual(rs("base2width"), base2width) or areNotEqual(rs("base1length"), base1length) or areNotEqual(rs("base2length"), base2length) then
            ' the base has changed significantly, so the packing data will need to be redone
	        call deletePackagingDataForComponent(con, order, 3)
        end if

        If base1width <> "" then rs("base1width") = base1width else rs("base1width") = null
        If base2width <> "" then rs("base2width") = base2width else rs("base2width") = null
        If base1length <> "" then rs("base1length") = base1length else rs("base1length") = null
        If base2length <> "" then rs("base2length") = base2length else rs("base2length") = null

        if areNotEqual(rs("topper1width"), topper1width) or areNotEqual(rs("topper1length"), topper1length) then
            ' the topper has changed significantly, so the packing data will need to be redone
	        call deletePackagingDataForComponent(con, order, 5)
        end if

        If topper1width <> "" then rs("topper1width") = topper1width else rs("topper1width") = null
        If topper1length <> "" then rs("topper1length") = topper1length else rs("topper1length") = null

        if areNotEqual(rs("legheight"), speciallegheight) then
            ' the leg has changed significantly, so the packing data will need to be redone
	        call deletePackagingDataForComponent(con, order, 7)
        end if
        If speciallegheight <> "" then rs("legheight") = speciallegheight else rs("legheight") = null
        
        rs.update
    end if
    rs.close
    set rs = nothing

    ' get the existing madeat's, if any
    mattressmadeat = getComponentCurrentMadeAt(con, order, 1)
    basemadeat = getComponentCurrentMadeAt(con, order, 3)
    toppermadeatid = getComponentCurrentMadeAt(con, order, 5)
    legsmadeatid = getComponentCurrentMadeAt(con, order, 7)
    headboardmadeatid = getComponentCurrentMadeAt(con, order, 8)
    valancemadeatid = getComponentCurrentMadeAt(con, order, 6)

	' save the wholesale prices	
	Wmattressprice = request("Wmattressprice")
	Wtopperprice = request("Wtopperprice")
	WBaseFabricprice = request("WBaseFabricprice")
	WBaseUphprice = request("WBaseUphprice")
	WBaseTrimprice = request("WBaseTrimprice")
	WBaseDrawerprice = request("WBaseDrawerprice")
	WBaseprice = request("WBaseprice")
	Wlegsprice = request("Wlegsprice")
	WSupportlegsprice = request("WSupportlegsprice")
	WHBFabricprice = request("WHBFabricprice")
	WHBTrimprice = request("WHBTrimprice")
	WHBprice = request("WHBprice")
	Wvalanceprice = request("Wvalanceprice")
	Wvalancefabprice = request("Wvalancefabprice")
	call saveWholesalePrice(con, order, 1, Wmattressprice)
	call saveWholesalePrice(con, order, 5, Wtopperprice)
	call saveWholesalePrice(con, order, 17, WBaseFabricprice)
	call saveWholesalePrice(con, order, 12, WBaseUphprice)
	call saveWholesalePrice(con, order, 11, WBaseTrimprice)
	call saveWholesalePrice(con, order, 13, WBaseDrawerprice)
	call saveWholesalePrice(con, order, 3, WBaseprice)
	call saveWholesalePrice(con, order, 7, Wlegsprice)
	call saveWholesalePrice(con, order, 16, WSupportlegsprice)
	call saveWholesalePrice(con, order, 15, WHBFabricprice)
	call saveWholesalePrice(con, order, 10, WHBTrimprice)
	call saveWholesalePrice(con, order, 8, WHBprice)
	call saveWholesalePrice(con, order, 6, Wvalanceprice)
	call saveWholesalePrice(con, order, 18, Wvalancefabprice)

    Set rs = getMysqlUpdateRecordSet("Select * from purchase WHERE Purchase_No=" & order, con)
    ' check optimistic locking
    if cint(request("optcounter") ) <> cint(rs("optcounter") ) then
        con.rollbacktrans
        redirectUrl = "edit-purchase.asp?olfail=true&order=" & order
        if quote = "y" then
            redirectUrl = redirectUrl & "&quote=y"
        end if
        response.Redirect(redirectUrl)
    end if
    rs("optcounter") = cint(rs("optcounter") ) + 1

    Session("order") = order
    rs("amendeddate") = date()
    salesagent = rs("salesusername")
    orderno = rs("order_number")
    orderdate = rs("order_date")
    ordertype = rs("ordertype")
	if request("wholesaleinv")="y" then rs("wholesaleInv")="y"
    rs("oldbed") = oldbed
    if deliverycontact <> "" then rs("deliveryContact") = deliverycontact else rs("deliverycontact") = null
    amendedversionno = cint(rs("version") ) + 1
    rs("version") = amendedversionno

    if isColNull(rs, "bookeddeliverydate") and isColNull(rs, "productiondate") and(bookeddeliverydate <> "" or productiondate <> "") then
        call addOrderNote(con, "Contact customer to discuss linen requirements, check production or booked delivery date.", ACTION_REQUIRED, toDbDateTime(now), order, "AUTO")
    end if
    'if overseasduty <> "TBC" then rs("overseasduty") = overseasduty
	rs("wrappingid")=request("wraptype")
    If bookeddeliverydate <> "" then rs("bookeddeliverydate") = bookeddeliverydate else rs("bookeddeliverydate") = null
    If productiondate <> "" then rs("productiondate") = productiondate else rs("productiondate") = null
    If acknowdate <> "" then rs("acknowdate") = acknowdate else rs("acknowdate") = null
    If acknowversion <> "" then rs("acknowversion") = acknowversion else rs("acknowversion") = null
    if rs("completedorders")="n" and Request("complete")="y" then 
                                	rs("ordercompletedUser")=retrieveUserID()
                                	rs("ordercompletedDate")=Now
                                end if
    If request("complete") = "y" then rs("completedorders") = "y"
    If reference <> "" then rs("customerreference") = reference else rs("customerreference") = null
    If companyname <> "" then rs("companyname") = companyname else rs("companyname") = null
    If deldate <> "" then rs("deliverydate") = deldate else rs("deliverydate") = null
    If add1d <> "" then rs("deliveryadd1") = add1d else rs("deliveryadd1") = null
    If add2d <> "" then rs("deliveryadd2") = add2d else rs("deliveryadd2") = null
    If add3d <> "" then rs("deliveryadd3") = add3d else rs("deliveryadd3") = null
    If townd <> "" then rs("deliverytown") = townd else rs("deliverytown") = null
    If countyd <> "" then rs("deliverycounty") = countyd else rs("deliverycounty") = null
    If postcoded <> "" then rs("deliverypostcode") = postcoded else rs("deliverypostcode") = null
    If countryd <> "" then rs("deliverycountry") = countryd else rs("deliverycountry") = null
    If deliveryinstructions <> "" then rs("deliveryinstructions") = deliveryinstructions else rs("deliveryinstructions") = null

    if rs("mattressrequired") = "y" and mattressrequired = "n" then mattreq = "y"
    If mattressrequired = "y" then
        rs("mattressrequired") = "y"
        if rs("savoirmodel") <> savoirmodel then
            ' replace the existing madeat value, as the model has been changed
            mattressmadeat = getMattressMadeAt(savoirmodel)
        end if
        if (rs("savoirmodel") <> savoirmodel) or (rs("mattresstype") <> mattresstype) or (rs("mattresswidth") <> mattresswidth) or (rs("mattresslength") <> mattresslength) then
            ' the mattress has changed significantly, so the packing data will need to be redone
	        call deletePackagingDataForComponent(con, order, 1)
        end if
        If savoirmodel <> "" then rs("savoirmodel") = savoirmodel else rs("savoirmodel") = null
        If mattresstype <> "" then rs("mattresstype") = mattresstype else rs("mattresstype") = null
        If tickingoptions <> "" then rs("tickingoptions") = tickingoptions else rs("tickingoptions") = null
        If mattresswidth <> "" then rs("mattresswidth") = mattresswidth else rs("mattresswidth") = null
        If mattresslength <> "" then rs("mattresslength") = mattresslength else rs("mattresslength") = null
        If leftsupport <> "" then rs("leftsupport") = leftsupport else rs("leftsupport") = null
        If rightsupport <> "" then rs("rightsupport") = rightsupport else rs("rightsupport") = null
        If ventfinish <> "" then rs("ventfinish") = ventfinish else rs("ventfinish") = null
        If ventposition <> "" then rs("ventposition") = ventposition else rs("ventposition") = null
        If mattressinstructions <> "" then rs("mattressinstructions") = mattressinstructions else rs("mattressinstructions") = null
        If mattressprice <> "" then rs("mattressprice") = mattressprice else rs("mattressprice") = null
        call upsertDiscount(con, order, 1, mattressdiscounttype, standardmattressprice, mattressprice)
    end If

    if rs("baserequired") = "y" and baserequired = "n" then basereq = "y"
    If baserequired = "y" then
        rs("baserequired") = "y"
        If rs("basesavoirmodel") <> basesavoirmodel then
            ' replace the existing madeat value, as the model has been changed
            basemadeat = getBaseMadeAt(basesavoirmodel)
        end if
		if (rs("basesavoirmodel") <> basesavoirmodel) or (rs("basetype") <> basetype) or (rs("basewidth") <> basewidth) or (rs("baselength") <> baselength) then
            ' the base has changed significantly, so the packing data will need to be redone
	        call deletePackagingDataForComponent(con, order, 3)
        end if
        If basesavoirmodel <> "" then rs("basesavoirmodel") = basesavoirmodel else rs("basesavoirmodel") = null
        If basetype <> "" then rs("basetype") = basetype else rs("basetype") = null

        If basewidth <> "" then
            rs("basewidth") = basewidth
        else
            rs("basewidth") = null
        end if
		if rs("basefabric")<>basefabric then 
			fabricbaseemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
    		emailArray1(arrayCounter) = "Base Fabric Company"
			emailArray2(arrayCounter) = rs("basefabric")
			emailArray3(arrayCounter) = basefabric
		end if
        if rs("basefabricdirection")<>basefabricdirection then 
			fabricbaseemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
    		emailArray1(arrayCounter) = "Base Fabric Direction"
			emailArray2(arrayCounter) = rs("basefabricdirection")
			emailArray3(arrayCounter) = basefabricdirection
		end if
        if rs("basefabricchoice")<>basefabricchoice then 
			fabricbaseemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
    		emailArray1(arrayCounter) = "Base Fabric Design, Colour & Code"
			emailArray2(arrayCounter) = rs("basefabricchoice")
			emailArray3(arrayCounter) = basefabricchoice
		end if
		
		if basefabricprice="" and rs("basefabricprice")<>"" then  
			fabricbaseemail="y"
			prodchange="y"
		end if
		if basefabricprice<>"" then
			if rs("basefabricprice")<>"" then
				if CDbl(rs("basefabricprice"))<>CDbl(basefabricprice) then 
					fabricbaseemail="y"
					prodchange="y"
				end if
			else
				if rs("basefabricprice")<>CDbl(basefabricprice) then 
					fabricbaseemail="y"
					prodchange="y"
				end if
			end if
		end if
		if prodchange="y" then
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Base Fabric Price Total"
			emailArray2(arrayCounter) = rs("basefabricprice")
			emailArray3(arrayCounter) = basefabricprice
			prodchange="n"
		end if
		
		if basefabricmeters="" and rs("basefabricmeters")<>"" then  
			fabricbaseemail="y"
			prodchange="y"
		end if
		if basefabricmeters<>"" then
			if rs("basefabricmeters")<>"" then
				if CDbl(rs("basefabricmeters"))<>CDbl(basefabricmeters) then 
					fabricbaseemail="y"
					prodchange="y"
				end if
			else
				if rs("basefabricmeters")<>CDbl(basefabricmeters) then 
					fabricbaseemail="y"
					prodchange="y"
				end if
			end if
		end if
		if prodchange="y" then
				arrayCounter=arrayCounter+1
				redim preserve emailArray1(arrayCounter)
				redim preserve emailArray2(arrayCounter)
				redim preserve emailArray3(arrayCounter)
				emailArray1(arrayCounter) = "Base Fabric Quantity"
				emailArray2(arrayCounter) = rs("basefabricmeters")
				emailArray3(arrayCounter) = basefabricmeters
				prodchange="n"
			end if
		
		if basefabriccost="" and rs("basefabriccost")<>"" then  
			fabricbaseemail="y"
			prodchange="y"
		end if
		if basefabriccost<>"" then
			if rs("basefabriccost")<>"" then
				if CDbl(rs("basefabriccost"))<>CDbl(basefabriccost) then 
					fabricbaseemail="y"
					prodchange="y"
				end if
			else
				if rs("basefabriccost")<>CDbl(basefabriccost) then 
					fabricbaseemail="y"
					prodchange="y"
				end if
			end if
		end if
		if prodchange="y" then
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Base Price Per Metre"
			emailArray2(arrayCounter) = rs("basefabriccost")
			emailArray3(arrayCounter) = basefabriccost
			prodchange="n"
		end if
		
		if rs("basefabricdesc")<>basefabricdesc then 
			fabricbaseemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Base Fabric Special Instructions"
			emailArray2(arrayCounter) = rs("basefabricdesc")
			emailArray3(arrayCounter) = basefabricdesc
		end if

        If baselength <> "" then rs("baselength") = baselength else rs("baselength") = null

        If linkposition <> "" then rs("linkposition") = linkposition else rs("linkposition") = null
        If linkfinish <> "" then rs("linkfinish") = linkfinish else rs("linkfinish") = null
        If baseinstructions <> "" then rs("baseinstructions") = baseinstructions else rs("baseinstructions") = null
        If basefabriccost <> "" then rs("basefabriccost") = basefabriccost else rs("basefabriccost")=0
        If basefabricmeters <> "" then rs("basefabricmeters") = basefabricmeters else rs("basefabricmeters")=0
        If basefabricprice <> "" then rs("basefabricprice") = basefabricprice else rs("basefabricprice")=0
        If basefabricdesc <> "" then rs("basefabricdesc") = basefabricdesc else rs("basefabricdesc") = null
        If baseprice <> "" then rs("baseprice") = baseprice else rs("baseprice") = null
        If upholsteredbase <> "" then rs("upholsteredbase") = upholsteredbase else rs("upholsteredbase") = null
        If basetrim <> "" then rs("basetrim") = basetrim else rs("basetrim") = null
        If basetrimcolour <> "" then rs("basetrimcolour") = basetrimcolour else rs("basetrimcolour") = null
        If basefabric <> "None" then rs("basefabric") = basefabric else rs("basefabric") = null
        If basefabricchoice <> "" then rs("basefabricchoice") = basefabricchoice else rs("basefabricchoice") = null
		If basefabricdirection <> "" then rs("basefabricdirection") = basefabricdirection else rs("basefabricdirection") = null
        If upholsteryprice <> "" then rs("upholsteryprice") = upholsteryprice else rs("upholsteryprice") = null
        If basetrimprice <> "" then rs("basetrimprice") = basetrimprice else rs("basetrimprice") = null
        If basedrawersprice <> "" then rs("basedrawersprice") = basedrawersprice else rs("basedrawersprice") = null
        If extbase <> "" then rs("extbase") = extbase else rs("extbase") = null
        rs("basedrawerheight") = drawerheight
        rs("basetickingoptions") = basetickingoptions
        rs("baseheightspring") = spring
      
        rs("basedrawerconfigid") = drawerconfig
		if drawerconfig="n" then rs("basedrawers")="No" else rs("basedrawers")="Yes"
    End If
    
    ' base related discounts
    if baserequired = "y" then
        call upsertDiscount(con, order, 3, basediscounttype, standardbaseprice, baseprice)
    else
    	call deleteDiscount(con, order, 3)
    end if
    if baserequired = "y" and upholsteredbase <> "n" then
        call upsertDiscount(con, order, 12, upholsterydiscounttype, standardupholsteryprice, upholsteryprice)
    else
    	call deleteDiscount(con, order, 12)
    end if
    if baserequired = "y" and basetrim <> "n" then
        call upsertDiscount(con, order, 11, basetrimdiscounttype, standardbasetrimprice, basetrimprice)
    else
    	call deleteDiscount(con, order, 11)
    end if
    if baserequired = "y" and upholsteredbase <> "n" then
        call upsertDiscount(con, order, 17, basefabricdiscounttype, standardbasefabricprice, basefabricprice)
    else
    	call deleteDiscount(con, order, 17)
    end if
    if baserequired = "y" and drawerconfig <> "n" then
        call upsertDiscount(con, order, 13, basedrawersdiscounttype, standardbasedrawersprice, basedrawersprice)
    else
    	call deleteDiscount(con, order, 13)
    end if
    ' end base related discounts

    if rs("topperrequired") = "y" and topperrequired = "n" then topperreq = "y"
    If topperrequired = "y" then
        rs("topperrequired") = "y"
        if rs("toppertype") <> toppertype then
            ' replace the existing madeat value, as the type has been changed
            toppermadeatid = getTopperMadeAt(toppertype, savoirmodel, basesavoirmodel, mattressmadeat, basemadeat)
        end if
		if (rs("toppertype") <> toppertype) or (rs("topperwidth") <> topperwidth) or (rs("topperlength") <> topperlength) then
            ' the base has changed significantly, so the packing data will need to be redone
	        call deletePackagingDataForComponent(con, order, 5)
        end if
        If toppertype <> "" then rs("toppertype") = toppertype else rs("toppertype") = null
        If topperwidth <> "" then rs("topperwidth") = topperwidth else rs("topperwidth") = null
        If topperlength <> "" then rs("topperlength") = topperlength else rs("topperlength") = null
        If toppertickingoptions <> "" then rs("toppertickingoptions") = toppertickingoptions else rs("toppertickingoptions") = null
        If specialinstructionstopper <> "" then rs("specialinstructionstopper") = specialinstructionstopper else rs("specialinstructionstopper") = null
        If topperprice <> "" then rs("topperprice") = topperprice else rs("topperprice") = null
        call upsertDiscount(con, order, 5, topperdiscounttype, standardtopperprice, topperprice)
    end if

    if rs("legsrequired") = "y" and legsrequired = "n" then legsreq = "y"
    if legsrequired = "y" then
	
		if rs("specialinstructionslegs")<>specialinstructionslegs then 
			fabriclegsemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Legs Special Instructions"
			emailArray2(arrayCounter) = rs("specialinstructionslegs")
			emailArray3(arrayCounter) = specialinstructionslegs
		end if
		
        rs("legsrequired") = "y"
        legsmadeatid = getLegsMadeAt()
        if legstyle = "Castors" then rs("floortype") = floortype else rs("floortype") = null
        If legstyle <> "" then rs("legstyle") = legstyle else rs("legstyle") = null
        If legfinish <> "" then rs("legfinish") = legfinish else rs("legfinish") = null
        If legheight <> "" then rs("legheight") = legheight else rs("legheight") = null
        If legprice <> "" then rs("legprice") = legprice else rs("legprice") = null
		If addlegprice<>"" then rs("addlegprice")=addlegprice else rs("addlegprice")=null
        If specialinstructionslegs <> "" then rs("specialinstructionslegs") = specialinstructionslegs else rs("specialinstructionslegs") = null
        rs("legqty") = legqty
        rs("addlegqty") = addlegqty
		If addlegstyle<>"" then rs("addlegstyle")=addlegstyle else rs("addlegstyle")=null
		If addlegfinish<>"" then rs("addlegfinish")=addlegfinish else rs("addlegfinish")=null
        call upsertDiscount(con, order, 7, legsdiscounttype, standardlegsprice, legprice)
		call upsertDiscount(con, order, 16, addlegsdiscounttype, standardaddlegsprice, addlegprice)
    end if

    if rs("headboardrequired") = "y" and headboardrequired = "n" then hbreq = "y"
    If headboardrequired = "y" then
		
	
		if rs("headboardfabricchoice")<>headboardfabricchoice then 
			fabrichbemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Headboard Fabric Description (Design, Colour & Code)"
			emailArray2(arrayCounter) = rs("headboardfabricchoice")
			emailArray3(arrayCounter) = headboardfabricchoice
		end if
        if rs("headboardfabricdirection")<>headboardfabricdirection then 
			fabrichbemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Headboard Fabric Direction"
			emailArray2(arrayCounter) = rs("headboardfabricdirection")
			emailArray3(arrayCounter) = headboardfabricdirection
		end if
        if rs("headboardfabric")<>headboardfabric then 
			fabrichbemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Headboard Fabric Company:"
			emailArray2(arrayCounter) = rs("headboardfabric")
			emailArray3(arrayCounter) = headboardfabric
		end if
		
		if hbfabricprice="" and rs("hbfabricprice")<>"" then  
			fabrichbemail="y"
			prodchange="y"
		end if
		if hbfabricprice<>"" then
			if rs("hbfabricprice")<>"" then
				if CDbl(rs("hbfabricprice"))<>CDbl(hbfabricprice) then 
					fabrichbemail="y"
					prodchange="y"
				end if
			else
				if rs("hbfabricprice")<>CDbl(hbfabricprice) then 
					fabrichbemail="y"
					prodchange="y"
				end if
			end if
		end if
		if prodchange="y" then
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Headboard Fabric Price Total"
			emailArray2(arrayCounter) = rs("hbfabricprice")
			emailArray3(arrayCounter) = hbfabricprice
			prodchange="n"
		end if
		
		if hbfabricmeters="" and rs("hbfabricmeters")<>"" then  
			fabrichbemail="y"
			prodchange="y"
		end if
		if hbfabricmeters<>"" then
			if rs("hbfabricmeters")<>"" then
				if CDbl(rs("hbfabricmeters"))<>CDbl(hbfabricmeters) then 
					fabrichbemail="y"
					prodchange="y"
				end if
			else
				if rs("hbfabricmeters")<>CDbl(hbfabricmeters) then 
					fabrichbemail="y"
					prodchange="y"
				end if
			end if
		end if
		if prodchange="y" then
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Headboard Fabric Quantity"
			emailArray2(arrayCounter) = rs("hbfabricmeters")
			emailArray3(arrayCounter) = hbfabricmeters
			prodchange="n"
		end if
		
		if hbfabriccost="" and rs("hbfabriccost")<>"" then  
			fabrichbemail="y"
			prodchange="y"
		end if
		if hbfabriccost<>"" then
			if rs("hbfabriccost")<>"" then
				if CDbl(rs("hbfabriccost"))<>CDbl(hbfabriccost) then 
					fabrichbemail="y"
					prodchange="y"
				end if
			else
				if rs("hbfabriccost")<>CDbl(hbfabriccost) then 
					fabrichbemail="y"
					prodchange="y"
				end if
			end if
		end if
		if prodchange="y" then
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Headboard Price Per Metre"
			emailArray2(arrayCounter) = rs("hbfabriccost")
			emailArray3(arrayCounter) = hbfabriccost
			prodchange="n"
		end if
		
		if rs("headboardfabricdesc")<>headboardfabricdesc then 
			fabrichbemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Headboard Fabric Special Instructions"
			emailArray2(arrayCounter) = rs("headboardfabricdesc")
			emailArray3(arrayCounter) = headboardfabricdesc
		end if
		
        rs("headboardrequired") = "y"
        if rs("headboardstyle") <> headboardstyle then
            ' replace the existing madeat value, as the style has been changed
            headboardmadeatid = getHeadboardMadeAt(headboardstyle, basemadeat, mattressmadeat)
        end if
		if (rs("headboardstyle") <> headboardstyle) or (rs("headboardwidth") <> headboardwidth) then
            ' the base has changed significantly, so the packing data will need to be redone
	        call deletePackagingDataForComponent(con, order, 8)
        end if
        If hbfabriccost <> "" then rs("hbfabriccost") = hbfabriccost else rs("hbfabriccost")=0
        If hbfabricmeters <> "" then rs("hbfabricmeters") = hbfabricmeters else rs("hbfabricmeters")=0
        If hbfabricprice <> "" then rs("hbfabricprice") = hbfabricprice else rs("hbfabricprice")=0

        If headboardstyle <> "" then rs("headboardstyle") = headboardstyle else rs("headboardstyle") = null
        If headboardfabric <> "None" then rs("headboardfabric") = headboardfabric else rs("headboardfabric") = null
        If headboardfabricchoice <> "" then rs("headboardfabricchoice") = headboardfabricchoice else rs("headboardfabricchoice") = null
        If headboardheight <> "" then rs("headboardheight") = headboardheight else rs("headboardheight") = null
        if headboardwidth <> "" then rs("headboardwidth") = headboardwidth else rs("headboardwidth") = null
        If headboardfinish <> "" then rs("headboardfinish") = headboardfinish else rs("headboardfinish") = null
        If manhattantrim <> "" then rs("manhattantrim") = manhattantrim else rs("manhattantrim") = null
		If left(manhattantrim,2) = "--" then rs("manhattantrim") = "--"
		If footboardheight <> "" then rs("footboardheight") = footboardheight else rs("footboardheight") = null
		If footboardfinish <> "" then rs("footboardfinish") = footboardfinish else rs("footboardfinish") = null
        If specialinstructionsheadboard <> "" then rs("specialinstructionsheadboard") = specialinstructionsheadboard else rs("specialinstructionsheadboard") = null
        If headboardprice <> "" then rs("headboardprice") = headboardprice else rs("headboardprice") = null
        If headboardtrimprice <> "" then rs("headboardtrimprice") = headboardtrimprice else rs("headboardtrimprice") = null
        If headboardfabricdesc <> "" then rs("headboardfabricdesc") = headboardfabricdesc else rs("headboardfabricdesc") = null
		If headboardfabricdirection <> "" then rs("headboardfabricdirection") = headboardfabricdirection else rs("headboardfabricdirection") = null
        rs("hbfabricoptions") = hbfabricoptions
        rs("headboardlegqty") = hblegs
        call upsertDiscount(con, order, 8, headboarddiscounttype, standardheadboardprice, headboardprice)
        call upsertDiscount(con, order, 10, headboardtrimdiscounttype, standardheadboardtrimprice, headboardtrimprice)
    End If

    if rs("valancerequired") = "y" and valancerequired = "n" then valreq = "y"
    If valancerequired = "y" then
	
		if rs("pleats")<>pleats then 
			fabricvalanceemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Valance No. of Pleats"
			emailArray2(arrayCounter) = rs("pleats")
			emailArray3(arrayCounter) = pleats
		end if
		
		if valfabriccost="" and rs("valfabriccost")<>"" then  
			fabricvalanceemail="y"
			prodchange="y"
		end if
		if valfabriccost<>"" then
			if rs("valfabriccost")<>"" then
				if CDbl(rs("valfabriccost"))<>CDbl(valfabriccost) then 
					fabricvalanceemail="y"
					prodchange="y"
				end if
			else
				if rs("valfabriccost")<>CDbl(valfabriccost) then 
					fabricvalanceemail="y"
					prodchange="y"
				end if
			end if
		end if
		if prodchange="y" then
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Valance Fabric Cost per metre"
			emailArray2(arrayCounter) = rs("valfabriccost")
			emailArray3(arrayCounter) = valfabriccost
			prodchange="n"
		end if
		
		if valfabricmeters="" and rs("valfabricmeters")<>"" then  
			fabricvalanceemail="y"
			prodchange="y"
		end if
		if valfabricmeters<>"" then
			if rs("valfabricmeters")<>"" then
				if CDbl(rs("valfabricmeters"))<>CDbl(valfabricmeters) then 
					fabricvalanceemail="y"
					prodchange="y"
				end if
			else
				if rs("valfabricmeters")<>CDbl(valfabricmeters) then 
					fabricvalanceemail="y"
					prodchange="y"
				end if
			end if
		end if
		if prodchange="y" then
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Valance Metres of Fabric"
			emailArray2(arrayCounter) = rs("valfabricmeters")
			emailArray3(arrayCounter) = valfabricmeters
			prodchange="n"
		end if
		
		if valfabricprice="" and rs("valfabricprice")<>"" then  
			fabricvalanceemail="y"
			prodchange="y"
		end if
		if valfabricprice<>"" then
			if rs("valfabricprice")<>"" then
				if CDbl(rs("valfabricprice"))<>CDbl(valfabricprice) then 
					fabricvalanceemail="y"
					prodchange="y"
				end if
			else
				if rs("valfabricprice")<>CDbl(valfabricprice) then 
					fabricvalanceemail="y"
					prodchange="y"
				end if
			end if
		end if
		if prodchange="y" then
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Valance Fabric Price"
			emailArray2(arrayCounter) = rs("valfabricprice")
			emailArray3(arrayCounter) = valfabricprice
			prodchange="n"
		end if
		
		
		
		if rs("valancefabric")<>valancefabric then 
			fabricvalanceemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Valance Fabric Company"
			emailArray2(arrayCounter) = rs("valancefabric")
			emailArray3(arrayCounter) = valancefabric
		end if
		if rs("specialinstructionsvalance")<>specialinstructionsvalance then 
			fabricvalanceemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Valance Special Instructions"
			emailArray2(arrayCounter) = rs("specialinstructionsvalance")
			emailArray3(arrayCounter) = specialinstructionsvalance
		end if
		if rs("valancefabricchoice")<>valancefabricchoice then 
			fabricvalanceemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Valance Fabric Design, Colour & Code"
			emailArray2(arrayCounter) = rs("valancefabricchoice")
			emailArray3(arrayCounter) = valancefabricchoice
		end if
		if rs("valancefabricdirection")<>valancefabricdirection then 
			fabricvalanceemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Valance Fabric Direction"
			emailArray2(arrayCounter) = rs("valancefabricdirection")
			emailArray3(arrayCounter) = valancefabricdirection
		end if
		
		if valancewidth="" and rs("valancewidth")<>"" then  
			fabricvalanceemail="y"
			prodchange="y"
		end if
		if valancewidth<>"" then
			if rs("valancewidth")<>"" then
				if CDbl(rs("valancewidth"))<>CDbl(valancewidth) then 
					fabricvalanceemail="y"
					prodchange="y"
				end if
			else
				if rs("valancewidth")<>CDbl(valancewidth) then 
					fabricvalanceemail="y"
					prodchange="y"
				end if
			end if
		end if
		if prodchange="y" then
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Valance Width"
			emailArray2(arrayCounter) = rs("valancewidth")
			emailArray3(arrayCounter) = valancewidth
			prodchange="n"
		end if
		
		if valancelength="" and rs("valancelength")<>"" then  
			fabricvalanceemail="y"
			prodchange="y"
		end if
		if valancelength<>"" then
			if rs("valancelength")<>"" then
				if CDbl(rs("valancelength"))<>CDbl(valancelength) then 
					fabricvalanceemail="y"
					prodchange="y"
				end if
			else
				if rs("valancelength")<>CDbl(valancelength) then 
					fabricvalanceemail="y"
					prodchange="y"
				end if
			end if
		end if
		if prodchange="y" then
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Valance Length"
			emailArray2(arrayCounter) = rs("valancelength")
			emailArray3(arrayCounter) = valancelength
			prodchange="n"
		end if
		
		if valancedrop="" and rs("valancedrop")<>"" then  
			fabricvalanceemail="y"
			prodchange="y"
		end if
		if valancedrop<>"" then
			if rs("valancedrop")<>"" then
				if CDbl(rs("valancedrop"))<>CDbl(valancedrop) then 
					fabricvalanceemail="y"
					prodchange="y"
				end if
			else
				if rs("valancedrop")<>CDbl(valancedrop) then 
					fabricvalanceemail="y"
					prodchange="y"
				end if
			end if
		end if
		if prodchange="y" then
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Valance Drop"
			emailArray2(arrayCounter) = rs("valancedrop")
			emailArray3(arrayCounter) = valancedrop
			prodchange="n"
		end if
		
		if rs("valancefabricoptions")<>valancefabricoptions then 
			fabricvalanceemail="y"
			arrayCounter=arrayCounter+1
			redim preserve emailArray1(arrayCounter)
			redim preserve emailArray2(arrayCounter)
			redim preserve emailArray3(arrayCounter)
			emailArray1(arrayCounter) = "Valance Fabric Options"
			emailArray2(arrayCounter) = rs("valancefabricoptions")
			emailArray3(arrayCounter) = valancefabricoptions
		end if
		
		
		
        rs("valancerequired") = "y"
        valancemadeatid = getValanceMadeAt()
        If valfabriccost <> "" then rs("valfabriccost") = valfabriccost else rs("valfabriccost")=0
        If valfabricmeters <> "" then rs("valfabricmeters") = valfabricmeters else rs("valfabricmeters")=0
        If valfabricprice <> "" then rs("valfabricprice") = valfabricprice else rs("valfabricprice")=0
        If pleats <> "" then rs("pleats") = pleats else rs("pleats") = null
        If valancefabric <> "None" then rs("valancefabric") = valancefabric else rs("valancefabric") = null
        If valancefabricchoice <> "" then rs("valancefabricchoice") = valancefabricchoice else rs("valancefabricchoice") = null
        If specialinstructionsvalance <> "" then rs("specialinstructionsvalance") = specialinstructionsvalance else rs("specialinstructionsvalance") = null
        If valanceprice <> "" then rs("valanceprice") = valanceprice else rs("valanceprice") = null

        If valancefabricdirection <> "" then rs("valancefabricdirection") = valancefabricdirection else rs("valancefabricdirection") = null
        If valancewidth <> "" then rs("valancewidth") = valancewidth else rs("valancewidth") = null
        If valancelength <> "" then rs("valancelength") = valancelength else rs("valancelength") = null
        If valancedrop <> "" then rs("valancedrop") = valancedrop else rs("valancedrop") = null
        rs("valancefabricoptions") = valancefabricoptions
    End If

    if rs("accessoriesrequired") = "y" and accessoriesrequired = "n" then accreq = "y"
    if accessoriesrequired = "y" then
        rs("accessoriesrequired") = "y"
        accessoriestotalcost = 0.0
        for i = 1 to 20
            acc_id = request("acc_id" &i)
            if request("acc_delete" &i) <> "" and acc_id <> "" then
				if checkAccessoryDeleted(Con, acc_id, arrayCounter, emailArray1, emailArray2, emailArray3) then
							fabricaccessoriesemail="y"
						end if
                sql = "delete from orderaccessory where orderaccessory_id=" & acc_id
                'response.write("<br>a: sql=" & sql)
                con.execute(sql)
            else
                acc_desc = trim(request("acc_desc" &i) )
                acc_design = trim(request("acc_design" &i) )
                acc_colour = trim(request("acc_colour" &i) )
                acc_size = trim(request("acc_size" &i) )
                'response.write("<br>acc_size=" & acc_size)
                acc_unitprice = request("acc_unitprice" &i)
				acc_wholesalePrice = request("acc_wholesalePrice" &i)
                acc_qty = request("acc_qty" &i)
                if acc_desc <> "" then
                    if acc_qty = "" then acc_qty = 1
                    if acc_unitprice = "" then acc_unitprice = 0.0
					if acc_wholesalePrice = "" then acc_wholesalePrice = 0.0
                    if acc_id <> "" then
					    if checkAccessoryChange(Con, acc_id, acc_desc, acc_design, acc_colour, acc_size, acc_unitprice, acc_qty, arrayCounter, emailArray1, emailArray2, emailArray3) then
							fabricaccessoriesemail="y"
						end if
						
                        sql = "update orderaccessory set description='" & replaceQuotes(acc_desc) & "',design='" & replaceQuotes(acc_design) & "',colour='" & replaceQuotes(acc_colour) & "',size='" & replaceQuotes(acc_size) & "',unitprice=" & safeCCur(acc_unitprice) & ",wholesalePrice=" & safeCCur(acc_wholesalePrice) & ",qty=" & acc_qty & " where orderaccessory_id=" & acc_id
                    else
                        sql = "insert into orderaccessory (description,design,colour,size,unitprice,wholesalePrice,qty,purchase_no) values ('" & replaceQuotes(acc_desc) & "','" & replaceQuotes(acc_design) & "','" & replaceQuotes(acc_colour) & "','" & replaceQuotes(acc_size) & "'," & safeCCur(acc_unitprice) & "," & safeCCur(acc_wholesalePrice) & "," & acc_qty & "," & order & ")"
						fabricaccessoriesemail=fabricaccessoriesemail & acc_desc & " "
						arrayCounter=arrayCounter+1
						redim preserve emailArray1(arrayCounter)
						redim preserve emailArray2(arrayCounter)
						redim preserve emailArray3(arrayCounter)
						emailArray1(arrayCounter) = "Accessories: " & acc_desc
						emailArray2(arrayCounter) = "New accessory item"
						emailArray3(arrayCounter) = acc_desc & " "  & acc_design & " " & acc_colour & " " & acc_size & " " & acc_unitprice & " " & acc_qty
                    end if
                    'response.write("<br>sql=" & sql)
                    con.execute(sql)
                    'response.end
                    accessoriestotalcost = accessoriestotalcost + safeCCur(acc_unitprice) * safeCCur(acc_qty)
                elseif acc_id <> "" then
                    sql = "delete from orderaccessory where orderaccessory_id=" & acc_id
                    'response.write("<br>b: sql=" & sql)
                    con.execute(sql)
                end if
            end if
        next
        rs("accessoriestotalcost") = accessoriestotalcost
    end if
    'response.end

    rs("accesscheck") = accesscheck
    If deliverycharge = "y" then
        rs("deliverycharge") = "y"
    else
        rs("deliverycharge") = "n"
    End If
    If specialinstructionsdelivery <> "" then rs("specialinstructionsdelivery") = specialinstructionsdelivery else rs("specialinstructionsdelivery") = null
    If deliveryprice <> "" then rs("deliveryprice") = deliveryprice else rs("deliveryprice") = null
    If dctype <> "" then rs("discounttype") = dctype
    If subtotal <> "" then rs("subtotal") = subtotal
    If bedsettotal <> "" then rs("bedsettotal") = bedsettotal
    If dcresult <> "" then
        rs("discount") = dcresult
    else
        rs("discount") = null
    end if

    if vat = "" then vat = 0.0
    if totalexvat = "" then totalexvat = 0.0
    rs("vat") = vat
    rs("totalexvat") = totalexvat
    rs("vatrate") = request("vatrate")

    if total = "" then total = 0.0
    if outstanding = "" then outstanding = 0.0
    paymentstotal = (total - outstanding)
    rs("total") = total
    rs("balanceoutstanding") = outstanding
    rs("paymentstotal") = paymentstotal

    rs.Update
    rs.close
    set rs = nothing

    sql = "Select * from savoir_user  S, location L where S.id_location=L.idlocation AND username like '" & salesagent & "'"
    Set rs = getMysqlQueryRecordSet(sql, con)
    showroomname = rs("adminheading")
    emailIdLocation = rs("adminemail")
    rs.close
    set rs = nothing

    If ordertype <> "" then
        sql = "Select * from ordertype WHERE ordertypeid=" & ordertype
        'REsponse.Write("sql=" & sql)
        Set rs = getMysqlQueryRecordSet(sql, con)
        Dim ordertypename
        ordertypename = rs("ordertype")
        rs.close
        set rs = nothing
    end if

    If paymentmethod <> "" then
        sql = "Select * from paymentmethod WHERE paymentmethodid=" & paymentmethod
        Set rs = getMysqlQueryRecordSet(sql, con)
        paymentmethodname = rs("paymentmethod")
        rs.close
        set rs = nothing
    end if

    if shipper = "n" then
    else
        sql = "Select * from shipper_address where shipper_address_id=" & shipper
        'response.Write("sql=" & sql)
        Set rs = getMysqlQueryRecordSet(sql, con)
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
        rs.close
        set rs = nothing
        sql = "Select * from purchase_shipper where purchase_no=" & order & ""
        Set rs = getMysqlUpdateRecordSet(sql, con)
        if rs.eof then
            rs.close
            set rs = nothing
            Set rs = getMysqlUpdateRecordSet("Select * from purchase_shipper", con)
            rs.AddNew
        end if
        if shippername <> "" then rs("shipperName") = shippername else rs("shipperName") = ""
        if shipperadd1 <> "" then rs("add1") = shipperadd1 else rs("add1") = ""
        if shipperadd2 <> "" then rs("add2") = shipperadd2 else rs("add2") = ""
        if shipperadd3 <> "" then rs("add3") = shipperadd3 else rs("add3") = ""
        if shippertown <> "" then rs("town") = shippertown else rs("town") = ""
        if shippercounty <> "" then rs("countystate") = shippercounty else rs("countystate") = ""
        if shipperpostcode <> "" then rs("postcode") = shipperpostcode else rs("postcode") = ""
        if shippercountry <> "" then rs("country") = shippercountry else rs("country") = ""
        if shippercontact <> "" then rs("contact") = shippercontact else rs("contact") = ""
        if shippertel <> "" then rs("phone") = shippertel else rs("phone") = ""
        rs.Update

        rs.close
        set rs = nothing
    end if
    If request("exportchoice") <> "" then
        sql = "Select L.exportLinksID from exportcollections E, exportLinks L, exportCollShowrooms S where L.purchase_no=" & order & " and E.collectiondate='" & toUSADate(request("exportchoice") ) & "' AND L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID"
        'response.Write("sql= " & sql)
        'response.End()
        Set rs = getMysqlQueryRecordSet(sql, con)
        Do until rs.eof
            Set rs1 = getMysqlUpdateRecordSet("Select * from exportLinks where exportLinksID=" & rs("exportLinksID"), con)
            rs1("invoiceNo") = invoiceno
            rs1("invoiceDate") = invoicedate
            rs1.update
            rs1.close
            set rs1 = nothing
            rs.movenext
        loop
        rs.close
        set rs = nothing
    end if

    If request("additionalpayment") <> "" then
        dim paymentExists
        Set rs = getMysqlUpdateRecordSet("Select * from payment where purchase_no=" & order, con)
        paymentExists = not rs.eof
        rs.AddNew
        pmtamt = ccur(request("additionalpayment") )
        rs("amount") = pmtamt
        rs("salesusername") = retrieveUserName()
        rs("paymentmethodid") = paymentmethod
        if outstanding > 0.0 then
            rs("paymenttype") = "Additional Payment"
        elseif paymentExists then
            rs("paymenttype") = "Final Payment"
        else
            rs("paymenttype") = "Full Payment"
        end if
        rs("purchase_no") = order
        rs("invoicedate") = invoicedate
        rs("invoice_number") = invoiceno
        rs("placed") = toDbDateTime(now)
        receiptno = getNextReceiptNumber(con)
        rs("receiptno") = receiptno
        if creditdetails <> "" then rs("creditdetails") = creditdetails
        rs.update
    end if

    If refundmethod <> "" then
        sql = "Select * from paymentmethod WHERE paymentmethodid=" & refundmethod
        Set rs = getMysqlQueryRecordSet(sql, con)
        refundmethodname = rs("paymentmethod")
        rs.close
        set rs = nothing
    end if

    If request("refund") <> "" then
        Set rs = getMysqlUpdateRecordSet("Select * from payment where purchase_no=" & order, con)
        rs.AddNew
        pmtamt = ccur(request("refund") )
        rs("amount") = pmtamt * -1.0
        rs("salesusername") = retrieveUserName()
        rs("paymentmethodid") = refundmethod
        rs("paymenttype") = "Refund"
        rs("purchase_no") = order
        rs("placed") = toDbDateTime(now)
        refundreceiptno = getNextReceiptNumber(con)
        rs("receiptno") = refundreceiptno
        rs.update
    end if

    sql = "Select * from payment where purchase_no=" & order
    Set rs = getMysqlUpdateRecordSet(sql, con)
    if not rs.eof then
        do until rs.eof
            if isNull(rs("invoice_number") ) or rs("invoice_number") = "" then
                rs("invoice_number") = request(rs("paymentid") & "invono")
            end if
            rs.update
            rs.movenext
        loop
    end if
    rs.close
    set rs = nothing

    ordernote_notetext = trim(request("ordernote_notetext") )
    ordernote_action = request("ordernote_action")
    ordernote_followupdate = request("ordernote_followupdate")

    if trim(request("ordernote_notetext") ) <> "" then
        call addOrderNote(con, ordernote_notetext, ordernote_action, ordernote_followupdate, order, "MANUAL")
    end if
	
	For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 13) = "notecompleted" Then
		pid=right(fieldName, len(fieldName)-13)
		sql="Select * from  ordernote where ordernote_id=" & pid
		Set rs2 = getMysqlUpdateRecordSet(sql, con)
		rs2("action")="Completed"
		rs2.Update
		rs2.close
		set rs2=nothing
	end if
	next
	
	For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 17) = "Note_followupdate" Then
		pid=right(fieldName, len(fieldName)-17)
		sql="Select * from  ordernote where ordernote_id=" & pid
		Set rs2 = getMysqlUpdateRecordSet(sql, con)
		if Request(fieldname)<>"" then rs2("followupdate")=Request(fieldName)
		rs2("NoteCompletedDate")=now()
		rs2("NoteCompletedBy")=retrieveUserName()
		rs2.Update
		rs2.close
		set rs2=nothing
	end if
	next
	

    if delphone1 <> "" then
        call addUpdatePhoneNumber(con, delphonetype1, order, delphone1, 1)
    else
        call deletePhoneNumber(con, order, 1)
    end if
    if delphone2 <> "" then
        call addUpdatePhoneNumber(con, delphonetype2, order, delphone2, 2)
    else
        call deletePhoneNumber(con, order, 2)
    end if
    if delphone3 <> "" then
        call addUpdatePhoneNumber(con, delphonetype3, order, delphone3, 3)
    else
        call deletePhoneNumber(con, order, 3)
    end if

    ' for each component that has been updated by the user add a qc_history row with status=0 (Awaiting Confirmation)
    ' including components newly added to the order

    if mattressrequired = "y" and request("mattress-changed") = "y" then
        call insertQcHistoryRowIfNotExists(con, 1, order, 0, retrieveUserID(), mattressmadeat)
        if mattressmadeat <> -1 then
            call updateComponentMadeAt(con, order, 1, mattressmadeat)
        end if
    end if

    if baserequired = "y" and request("base-changed") = "y" then
        call insertQcHistoryRowIfNotExists(con, 3, order, 0, retrieveUserID(), basemadeat)
        if basemadeat <> -1 then
            call updateComponentMadeAt(con, order, 3, basemadeat)
        end if
    end if

    if topperrequired = "y" and request("topper-changed") = "y" then
        call insertQcHistoryRowIfNotExists(con, 5, order, 0, retrieveUserID(), toppermadeatid)
        if toppermadeatid <> -1 then
            call updateComponentMadeAt(con, order, 5, toppermadeatid)
        end if
    end if

    if valancerequired = "y" and request("valance-changed") = "y" then
        call insertQcHistoryRowIfNotExists(con, 6, order, 0, retrieveUserID(), valancemadeatid)
        if valancemadeatid <> -1 then
            call updateComponentMadeAt(con, order, 6, valancemadeatid)
        end if
    end if

    if legsrequired = "y" and request("legs-changed") = "y" then
        call insertQcHistoryRowIfNotExists(con, 7, order, 0, retrieveUserID(), legsmadeatid)
        if legsmadeatid <> -1 then
            call updateComponentMadeAt(con, order, 7, legsmadeatid)
        end if
    end if

    if headboardrequired = "y" and request("headboard-changed") = "y" then
        call insertQcHistoryRowIfNotExists(con, 8, order, 0, retrieveUserID(), headboardmadeatid)
        if headboardmadeatid <> -1 then
            call updateComponentMadeAt(con, order, 8, headboardmadeatid)
        end if
    end if

    if accessoriesrequired = "y" and request("accessories-changed") = "y" then
        call insertQcHistoryRowIfNotExists(con, 9, order, 0, retrieveUserID(), 0)
    end if

    con.committrans ' commit transaction

    call log(scriptname, "retrieveUserLocation=" & retrieveUserLocation())
    paymentEmailCC = getPaymentNotificationEmailAddressForShowroom(retrieveUserLocation(), con)
    call log(scriptname, "paymentEmailCC=" & paymentEmailCC)
    call log(scriptname, "defunct: request(additionalpayment)=" & request("additionalpayment"))
    If request("additionalpayment") <> "" then
        Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
        locationname = rs("location")
        call closeRs(rs)

        accountsubject = clientssurname
        If company <> "" then accountsubject = accountsubject & " - " & company
        accountsubject = accountsubject & " - " & orderno & " - " & orderCurrency & fmtCurrNonHtml(pmtamt, false, "") & " - " & paymentmethodname
        accountsmsg = "<html><body><font face=""Arial, Helvetica, sans-serif""><b>CUSTOMER PAYMENT</b><br /><table width=""98%"" border=""1""  cellpadding=""3"" cellspacing=""0"">"
        accountsmsg = accountsmsg & "<tr><td>Order Type</td><td>" & ordertypename & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Payment Amount</td><td>" & fmtCurr2(pmtamt, true, orderCurrency) & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Invoice Date</td><td>" & invoicedate & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Invoice No:</td><td>" & invoiceno & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Payment Type</td><td>" & paymentmethodname & "</td></tr>"
        if creditdetails <> "" then
            accountsmsg = accountsmsg & "<tr><td>Credit Details</td><td>" & creditdetails & "</td></tr>"
        end if
        accountsmsg = accountsmsg & "<tr><td>Customer Surname</td><td>" & clientssurname & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Company</td><td>" & company & "&nbsp;</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Order No</td><td>" & orderno & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Amount Outstanding on this order</td><td>" & fmtCurr2(outstanding, true, orderCurrency) & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Order Total Amount</td><td>" & fmtCurr2(Request("total"), true, orderCurrency) & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Payment Source</td><td>" & locationname & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Price List</td><td>" & pricelist & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Receipt No.</td><td>" & receiptno & "</td></tr>"

        accountsmsg = accountsmsg & "</font></body></html>"

        call log(scriptname, "Sending payment email to SavoirAdminAccounts@savoirbeds.co.uk")
        call sendBatchEmail(accountsubject, accountsmsg, "noreply@savoirbeds.co.uk", "SavoirAdminAccounts@savoirbeds.co.uk", "", paymentEmailCC, true, con)
        call sendPaymentEmail(con, clientssurname, company, orderno, orderCurrency, pmtamt, paymentmethodname, ordertypename, invoicedate, invoiceno, creditdetails, outstanding, Request("total"), pricelist, receiptno, paymentEmailCC)
    end if

    If request("refund") <> "" then
        Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
        locationname = rs("location")
        call closeRs(rs)

        accountsubject = clientssurname
        If company <> "" then accountsubject = accountsubject & " - " & company
        accountsubject = accountsubject & " - " & orderno & " - " & orderCurrency & fmtCurrNonHtml(pmtamt, false, "") & " - " & refundmethodname
        accountsmsg = "<html><body><font face=""Arial, Helvetica, sans-serif""><b>CUSTOMER REFUND</b><br /><table width=""98%"" border=""1""  cellpadding=""3"" cellspacing=""0"">"
        accountsmsg = accountsmsg & "<tr><td>Order Type</td><td>" & ordertypename & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Refund Amount</td><td>" & fmtCurr2(pmtamt, true, orderCurrency) & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Refund Type</td><td>" & paymentmethodname & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Customer Surname</td><td>" & clientssurname & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Company</td><td>" & company & "&nbsp;</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Order No</td><td>" & orderno & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Amount Outstanding on this order</td><td>" & fmtCurr2(outstanding, true, orderCurrency) & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Order Total Amount</td><td>" & fmtCurr2(Request("total"), true, orderCurrency) & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Refund Source</td><td>" & locationname & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Price List</td><td>" & pricelist & "</td></tr>"
        accountsmsg = accountsmsg & "<tr><td>Refund Receipt No.</td><td>" & refundreceiptno & "</td></tr>"
        accountsmsg = accountsmsg & "</font></body></html>"

        call log(scriptname, "Sending refund email to SavoirAdminAccounts@savoirbeds.co.uk")
        call sendBatchEmail(accountsubject, accountsmsg, "noreply@savoirbeds.co.uk", "SavoirAdminAccounts@savoirbeds.co.uk", "", paymentEmailCC, true, con)
		call sendRefundEmail(con, clientssurname, company, orderno, request("refund"), orderCurrency, getRefundMethodName(con, refundmethod), ordertypename, outstanding, Request("total"), pricelist, refundreceiptno, paymentEmailCC)
    end if

    if duplicateorder = "y" then
        Dim subject, recepient, pdfContent, msg5
        msg4 = "<html><body><font face=""Arial, Helvetica, sans-serif"">The following order has been placed on Savoir Admin, this needs to be confirmed before it proceeds to production.  Please log in to Savoir Admin and check the 'Orders to be Confirmed' list.<br /><br />" & clientstitle & " " & clientssurname & " " & companyname & " -  Order number " & orderno & ". <br>Order date: " & orderdate & ".  <br>Order Value: " & total & "</font></body></html>"
        subject = orderno & ", Order to be Confirmed,  " & clientstitle & " " & clientsfirst & " " & clientssurname
        If retrieveUserName() = "maddy" then
            recepient = "info@natalex.co.uk"
        elseif retrieveUserRegion() = 17 or retrieveUserRegion() = 19 then
            recepient = "SavoirAdminNewOrder@savoirbeds.co.uk"
        elseif retrieveUserName() = "dave" then
            recepient = "david@natalex.co.uk"
        else
            recepient = emailIdLocation
        end if
        'response.Write("dealer email=" & dealeremail & "<br />idregion= " & idregion & "")

        call sendBatchEmail(subject, msg4, "noreply@savoirbeds.co.uk", recepient, "", "", true, con)

        ' send order confirmation email with PDF attachment
        pdfContent = createNewOrderPdf(con, order, "n")

        msg5 = "<html><body><font face=""Arial, Helvetica, sans-serif"">New Order " & orderno & " has been placed by " & retrieveUserName() & " - " & locationname & " on Savoir Admin.  Please see the attached.</font></body></html>"
        subject = "New Order " & orderno & ",  " & retrieveUserName() & " - " & locationname
        If retrieveUserName() = "maddy" then
            recepient = "info@natalex.co.uk"
        elseif retrieveUserName() = "dave" then
            recepient = "david@natalex.co.uk"
        else
            recepient = "SavoirAdminNewOrder@savoirbeds.co.uk"
        end if
        call sendBatchEmailWithStringAttachment(subject, msg5, "noreply@savoirbeds.co.uk", recepient, "order-" & orderno & ".pdf", pdfContent, "", true, con)
    end if
	
		'send email to SavoirAdminFabric for fabrics / accessories update
if fabricbaseemail="y" or fabriclegsemail="y" or fabrichbemail="y" or fabricvalanceemail="y" or fabricaccessoriesemail<>"" then
if fabricaccessoriesemail<>"" and (fabricbaseemail="y" or fabriclegsemail="y" or fabrichbemail="y" or fabricvalanceemail="y") then 
	amendemailhdg="FABRIC & ACCESSORIES"
	amendemailcat=1
end if
if fabricaccessoriesemail="" and (fabricbaseemail="y" or fabriclegsemail="y" or fabrichbemail="y" or fabricvalanceemail="y") then 
	amendemailhdg="FABRIC"
	amendemailcat=2
end if
if fabricaccessoriesemail<>"" and (fabricbaseemail<>"y" and fabriclegsemail<>"y" and fabrichbemail<>"y" and fabricvalanceemail<>"y") then 
	amendemailhdg="ACCESSORIES"
	amendemailcat=3
end if
        msg6 = "<html><body><font face=""Arial, Helvetica, sans-serif"">This auto generated email has been sent to the distribution group called SavoirAdminFabric@savoirbeds.co.uk and confirms that there have been fabric updates for an order.<br><br>" & amendemailhdg & " UPDATE FOR:<table border=""1"" cellspacing=""0"" cellpadding=""3"">"
msg6=msg6 & "<tr><td>Order No.</td><td><a href=""http://savoiradminppt.co.uk/edit-purchase.asp?order=" & order & """>" & orderno & "</a></td></tr>"	
msg6=msg6 & "<tr><td>Order Date.</td><td>" & orderdate & "</td></tr>"	
msg6=msg6 & "<tr><td>Customer Name</td><td>" & clientssurname & "</td></tr>"	
if amendemailcat=3 then
else
	msg6=msg6 & "<tr><td>Fabrics Required for</td><td>"
	if fabricbaseemail="y" then msg6=msg6 & "Base, "
	if fabriclegsemail="y" then msg6=msg6 & "Legs, "
	if fabrichbemail="y" then msg6=msg6 & "Headboard, "
	if fabricvalanceemail="y" then msg6=msg6 & "Valance, "
	msg6=left(msg6, len(msg6)-2)
	msg6=msg6 & "&nbsp;</td></tr>"
end if
msg6=msg6 & "<tr><td>Changed By</td><td>" & retrieveUserName() & "</td></tr>"
'if fabricaccessoriesemail<>"" then msg6=msg6 & "<tr><td>Accessories</td><td>" & fabricaccessoriesemail & "</td></tr>"
msg6=msg6 & "</table>"
msg6=msg6 & "<br><table border=""1"" cellspacing=""0"" cellpadding=""3"">"
msg6=msg6 & "<tr><td>Field Changed</td><td>Old Value</td><td>New Value</td></tr>"
for i=1 to arrayCounter
	msg6=msg6 & "<tr>"
	msg6=msg6 & "<td>" & emailArray1(i) & "</td><td>" & emailArray2(i) & "</td><td>" & emailArray3(i) & "</td>"
	msg6=msg6 & "</tr>"
next
msg6=msg6 & "</table></font></body></html>"

		call sendBatchEmail(orderno & ", Fabrics / Accessories Update notification", msg6, "noreply@savoirbeds.co.uk", "SavoirAdminFabric@savoirbeds.co.uk", "", "", true, con)
end if


    If amendmentemailrequired = "1" then
        ' a significant change has been made to the order so set the order to requiring confirmation
        con.execute("update purchase set orderConfirmationStatus='n' where purchase_no=" & order)
    end if

    If amendmentemailrequired = "1" and quote <> "y" and request("complete") <> "y" then
%>
<!-- #include file="include-email-order.asp" -->
<%

        'send email to contact for order confirmation required
        msg4 = "<html><body><font face=""Arial, Helvetica, sans-serif"">The following order has been amended on Savoir Admin, this needs to be confirmed before it proceeds to production.  Please log in to Savoir Admin and check the 'Orders to be Confirmed' list.<br /><br />" & clientstitle & " " & clientssurname & " " & companyname & " -  Order number " & orderno & ".  <br>Order date: " & orderdate & ".  <br>Order Value: " & total & "</font></body></html>"
		If retrieveUserName()="maddy" then
			recepient = "info@natalex.co.uk"
		elseif retrieveUserRegion()=17 or retrieveUserRegion()=19 then
			recepient ="SavoirAdminNewOrder@savoirbeds.co.uk"
		elseif retrieveUserName()="dave" then
			recepient = "david@natalex.co.uk"
		else
			recepient = emailIdLocation
		end if
		call sendBatchEmail(orderno & ", Order to be Confirmed,  " & clientstitle & " " & clientsfirst & " " & clientssurname, msg4, "noreply@savoirbeds.co.uk", recepient, "", "", true, con)
        
    End If

    If quote = "y" then
        response.Redirect("ordercomplete.asp?mattreq=" & mattreq & "&basereq=" & basereq & "&topperreq=" & topperreq & "&valreq=" & valreq & "&hbreq=" & hbreq & "&legsreq=" & legsreq & "&accreq=" & accreq & "&quote=y&val=" & order)
    else
        response.Redirect("ordercomplete.asp?mattreq=" & mattreq & "&basereq=" & basereq & "&topperreq=" & topperreq & "&valreq=" & valreq & "&hbreq=" & hbreq & "&legsreq=" & legsreq & "&accreq=" & accreq & "&prod=" & prod & "&val=" & order)
    end if
end if ' end of if submit

''''' FORM STARTS HERE '''''
dim mattressLocked, baseLocked, baseFabricLocked, topperLocked, legsLocked, headboardLocked, headboardFabricLocked, valanceLocked, accessoriesLocked
mattressLocked = (getComponentStatus(con, order, 1) > 10)
baseLocked = (getComponentStatus(con, order, 3) > 10)
'baseFabricLocked = baseLocked and(getLatestHistoryColVal(con, order, 3, "confirmeddate") <> "")
topperLocked = (getComponentStatus(con, order, 5) > 10)
legsLocked = (getComponentStatus(con, order, 7) > 10)
headboardLocked = (getComponentStatus(con, order, 8) > 10)
'headboardFabricLocked = headboardLocked and(getLatestHistoryColVal(con, order, 8, "confirmeddate") <> "")
valanceLocked = (getComponentStatus(con, order, 6) > 10)
Dim accessoriesstatus
accessoriesstatus=getComponentStatus(con, order, 9)


if orderno = "" then orderno = getOrderNumberForPurchaseNo(con, order)
noteHistory = getOrderNoteHistory(con, order, "")
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
    "http://www.w3.org/TR/html4/strict.dtd">
<html lang = "en">
    <head>
        <title>Administration.</title>

        <meta content = "text/html; charset=UTF-8" http-equiv = "content-type" />

        <meta HTTP-EQUIV = "ROBOTS" content = "NOINDEX,NOFOLLOW" />
        
        <script type = "text/javascript" src = "ckeditor/ckeditor.js"></script>

        <script type = "text/javascript" src = "ckeditor/lang/_languages.js"></script>

        <script src = "ckeditor/_samples/sample.js" type = "text/javascript"></script>

        <link rel = "stylesheet" href = "Styles/jquery.signaturepad.css">
          
        
        <!--[if lt IE 9]><script src="scripts/flashcanvas.js"></script><![endif]-->
        <script src = "common/jquery.js"></script>

		 <script type="text/javascript" src="scripts/dropzone.js"></script>
  		  <script type="text/javascript" src="scripts/spin.min.js"></script>
        <script src="scripts/datevalidation.js"></script>

		<!-- #include file="pricematrixenabled.asp" -->
        <script src = "price-matrix-funcs.js?date=<%=theDate%>"></script>
		<script src = "common/utils.js?date=<%=theDate%>"></script>
		<script src = "order-funcs.js?date=<%=theDate%>"></script>
		<script src = "add-edit-order-common-funcs.js?date=<%=theDate%>"></script>
		<script src = "scripts/keepalive.js"></script>
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.2.3/jquery-confirm.min.css">
<script src="scripts/jquery-confirm.min.js"></script>
<script>
$.noConflict();  //Not to conflict with other scripts
jQuery(document).ready(function($) {
var year = new Date().getFullYear();
$( "#ordernote_followupdate" ).datepicker({
changeMonth: true,
yearRange: year + ":+2",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#ordernote_followupdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#acknowdate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#acknowdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#productiondate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#productiondate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
<%
if userHasRole("ADMINISTRATOR") or userHasRole("REGIONAL_ADMINISTRATOR") or retrieveUserLocation()=purchaseLocation then
bookeddelreadonly=""%>
$( "#bookeddeliverydate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#bookeddeliverydate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
<%end if%>
$( "#invoicedate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#winvoicedate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#invoicedate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
<%for i = 1 to ubound(noteHistory)%>
$( "#Note_followupdate<%=(noteHistory(i).orderNoteId)%>" ).datepicker({
changeMonth: true,
yearRange: year + ":+2",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#Note_followupdate<%=(noteHistory(i).orderNoteId)%>" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
<%next%>
});

</script>
        <SCRIPT LANGUAGE = "VBScript">
            Function MyForm_onSubmit

            If Msgbox("Are you sure you want to delete this record?", vbYesNo + vbExclamation ) = vbNo
            Then MyForm_onSubmit = False
            End If
            End Function
        </SCRIPT>

        <link href = "ckeditor/_samples/sample.css" rel = "stylesheet" type = "text/css" />

        <link href = "Styles/extra.css" rel = "Stylesheet" type = "text/css" />

        <link href = "Styles/screen.css" rel = "Stylesheet" type = "text/css" />

        <link href = "Styles/print.css" rel = "Stylesheet" type = "text/css" media = "print" />
<link rel="stylesheet" href="lightbox.css">
		
        <script Language = "JavaScript" type = "text/javascript">
            <% if jsmsg <> "" then %> alert("<%=jsmsg%>" );

            <% end if %>
        </script>
<style>
.AccordionPanel {float: left;}
.AccordionPanelTab {margin-left:5px; float:left;}
.Accordclear {clear:both;}
.stickleft {float:left;left:0px;}
.AccordionPanel table {margin-left:30px; background-color:#d4d4d4;}


            .rowlineheight tr
            {
                line-height: 0px;
            }

            .rowlineheight table
            {
                float: left;
            }

            .floatleft
            {
                float: left;
            }

            .lineclear
            {
                clear: both;
                line-height: 0px;
            }

            input.myClass
            {
                color: #000000;
                background-color: transparent;
                border: 0px solid;
                text-align: left;
            }
			.readonly {color:#999;}
			.bordergris {border:1px; border-color:#333333; border-style:solid; padding:5px; margin-top:5px;}
			
        </style>
<%if userHasRoleInList("NOPRICESUSER") then
'if (retrieveuserid()=181 or retrieveuserid()=182) then%>
<link href="Styles/noprices.css" rel="Stylesheet" type="text/css" />
<%end if%>
    </head>

    <body>
        <div class = "container">
            <!-- #include file="header.asp" -->
            
            <div class = "content brochure">
            
                <%
                if request("olfail") = "true" then
                %>

                    <p style = "color:red;">Another user has updated this order since it was read from the database,
                    so your changes have been lost. Please re-enter.</p>
                <%
                end if
                %>

                <div class = "one-col head-col">
                    <%
                    sql = "Select * from contact WHERE Contact_no=" & contact_no
                    
                    'response.Write("sql=" & sql)
                    'response.End()
                    Set rs = getMysqlQueryRecordSet(sql, con)
                    isVIP=rs("isVIP")
                    isVIPmanuallyset = rs("isVIPmanuallyset")
                    Response.write("<p>Customer: " & rs("title") & " " & rs("first") & " " & rs("surname") & "</p>")
                    rs.close
                    set rs = nothing

                    If submit <> "" Then
                    %>

                        <p>The
                        <%
                        If quote = "y" Then
                        %>

                                quote
                        <%
                        Else
                        %>

                            order
                        <%
                        End If
                        %>&nbsp;details have been amended on the website.

                           

                        </p>
                    <%
                            con.begintrans ' wrap this mini db update in a transaction
                                sql = "Select * from purchase WHERE purchase_no=" & order & ""

                                Set rs = getMysqlUpdateRecordSet(sql, con)
                                If Request("orderdate") <> "" Then rs("order_date") = Request("orderdate") else rs("order_date") = Null
                                If Request("product") <> "" Then rs("bed") = Request("product") else rs("bed") = Null
                                If Request("lastsupplied") <> "" Then rs("last_supplied") = Request("lastsupplied") else rs("last_supplied") = Null
                                If Request("notes") <> "" Then rs("notes") = Request("notes") else rs("notes") = Null
                                if rs("completedorders")="n" and Request("complete")="y" then 
                                	rs("ordercompletedUser")=retrieveUserID()
                                	rs("ordercompletedDate")=date()
                                end if
                                If Request("complete") = "y" Then rs("completedorders") = "y" else rs("completedorders") = "n"
                                rs.Update
                                rs.close
                                set rs = nothing
                                con.committrans ' commit mini transaction
                    Else
                        if retrieveUserRegion() = 1 or retrieveuserid()=217 then
                            Set rs = getMysqlQueryRecordSet("Select * from purchase WHERE purchase_no=" & order & "", con)
                        else
                            Set rs = getMysqlQueryRecordSet("Select * from purchase WHERE idlocation in (" & makeBuddyLocationList(retrieveUserLocation(), con) & ") and purchase_no=" & order, con)
                        end if
                        orderCurrency = rs("ordercurrency")
                        delDate = rs("deliverydate")
                        call makeApproxDateOptions(delDateValues, delDateDescriptions, delDate)
                        contact = rs("salesusername")
						if contact=retrieveUserName() then bookeddelreadonly=""
                        Set rs1 = getMysqlQueryRecordSet("Select * from contact WHERE Contact_no=" & contact_no & "", con)
                        Set rs2 = getMysqlQueryRecordSet("Select * from address WHERE code=" & rs1("code") & "", con)
                        signature = rs("signature")
                        If rs1("title") <> "" Then custname = custname & capitalise(lcase(rs1("title") ) ) & " "
                        If rs1("first") <> "" Then custname = custname & capitaliseName(rs1("first")) & " "
                        If rs1("surname") <> "" Then custname = custname & capitaliseName(rs1("surname"))

                        call getPhoneNumberTypes(con, typenames)
                        if productionsizelegs <> "y" then
                            If rs("basewidth") <> "" and rs("basewidth") <> null then
                                if right(rs("basewidth"), 2) = "cm" then basewidthcalc = left(rs("basewidth"), len(rs("basewidth") ) -2)
                                if right(rs("basewidth"), 2) = "in" then basewidthcalc = left(rs("basewidth"), len(rs("basewidth") ) -2)
                                if right(rs("basewidth"), 2) <> "cm" and right(rs("basewidth"), 2) <> "in" then basewidthcalc = rs("basewidth")
                            end if
                        end if
                    %><p><a href="editcust.asp?val=<%=rs("contact_no")%>&tab=2#TabbedPanels1">
  GO TO CUSTOMER DETAILS</a></p>

                            <%sql = "select p.purchase_no from purchase p where  p.contact_no=" & contact_no & " and (p.quote='n' or p.quote is null) and (p.cancelled='n' or p.cancelled is null) and p.completedorders='n' group by p.purchase_no"
'response.write("sql = " & sql)
set rs7 = getMysqlQueryRecordSet(sql, con)
if rs7.recordcount>1 then%>
                            <div class="AccordionPanel">
  	<a href="javascript:void(0)" class="stickleft" onclick="getPanelContent('<%=rs("contact_no")%>', 'TRUE', '1');" id="plus1">&nbsp;&nbsp;<img src="images/plus.gif" > Other Current Orders </a>
  	<a href="javascript:void(0)" class="stickleft" onclick="closePanel('<%=rs("contact_no")%>', '1');" id="minus1">&nbsp;&nbsp;<img src="images/minus.gif" > Close  Other Current Orders</a>
    <div class="AccordionPanelTab">
        </div><div class="Accordclear"></div>
    <div id="panel1" class="AccordionPanelContent"></div>
  
</div><div class="Accordclear"></div>
<%end if%>
                  <form method = "post" name = "form1" id = "form1"
                                onSubmit = "return formSubmitHandler(this);">
                                <%if userHasRole("ADMINISTRATOR") and (wholesaleEnabled="y" or retrieveuserid()=1 or retrieveuserid()=2 or retrieveuserid()=16) then%>
            <div align="right" id="wholesaleswitch">WHOLESALE INVOICE : ON
			
            <input name="wholesaleinv" id="wholesaleinv" type="radio" value="y"  onClick="ShowWholesale();" /> OFF<input name="wholesaleinv" id="wholesaleinv" type="radio" value="n" checked onClick="HideWholesale();"  />
           
            </div>
            <%end if%>
                                <input type = "hidden" name = "ordercurrency" id = "ordercurrency" value = "<%= orderCurrency %>" />
                                <input type = "hidden" name = "currency" id = "currency" value = "<%= orderCurrency %>" />

                                <input type = "hidden" name = "ordersource" id = "ordersource" value = "<%= orderSource %>" />

                                <input type = "hidden" name = "mattress-changed" id = "mattress-changed" value = "n" />

                                <input type = "hidden" name = "base-changed" id = "base-changed" value = "n" />

                                <input type = "hidden" name = "topper-changed" id = "topper-changed" value = "n" />

                                <input type = "hidden" name = "valance-changed" id = "valance-changed" value = "n" />

                                <input type = "hidden" name = "legs-changed" id = "legs-changed" value = "n" />

                                <input type = "hidden" name = "headboard-changed" id = "headboard-changed"
                                    value = "n" />

                                <input type = "hidden" name = "accessories-changed" id = "accessories-changed"
                                    value = "n" />

                                <input type = "hidden" name = "optcounter" value = "<%= rs("optcounter") %>" />

                                <input type = "hidden" name = "prod" value = "<%= prod %>" />

                                <input type = "hidden" name = "amendmentemailrequired" value = "0"
                                    id = "amendmentemailrequired" />
                                <%
                            If quote = "y" then%>
							<div align="right"><a href = "print-pdf.asp?quote=y&val=<%= order %>" target = "_blank">PRINT
                                                QUOTE</a>&nbsp;&nbsp;&nbsp;</div>
                            <%else%>

                    <p><%
                                    if userHasRoleInList("ADMINISTRATOR") or retrieveUserID()=217 then
                                    %>Order Completed (tick if yes)
                                                <%
                                                If rs("completedorders") = "n" Then
                                                %>

                                                        <input name = "complete" type = "checkbox" id = "complete"
                                                            value = "y">
                                                <%
                                                else
                                                %>

                                                    <input name = "complete" type = "checkbox" id = "complete"
                                                        value = "y" checked>
                                    <%
                                                End If
                                    end if
                                    %>

                      <span class = "justifyright">
                                        <%
                                        If retrieveuserregion() = 1 or userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR,ORDERDETAILS_VIEWER") then
                                        %>
												<a href = "orderdetails.asp?pn=<%= order %>">PRODUCTION</a>
                                                &nbsp;&nbsp;|&nbsp;&nbsp;
                                                <a href = "/php/balancerequest.pdf?pn=<%= order %>">BALANCE REQUEST LETTER</a>
                                                &nbsp;&nbsp;|&nbsp;&nbsp;
                                               
                                        <%
                                        End if
                                        %>

                                         <a href = "php/PrintPDF.pdf?val=<%= order %>" target = "_blank">PRINT
                                                PDF</a>
                                              &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;<a href = "duplicateorder1.asp?pn=<%= order %>">DUPLICATE
                                                ORDER</a> </span><br>
                                                <br>
                    </p>
                                <%
                            End If
                                %>
                                <p><%if quote<>"y" then%>
                                <input name = "order" type = "hidden" id = "order" value = "<%= order %>">
                                <%end if%>
                                <table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
                                    <tr>
                                        <td width = "10%">
                                            Contact:
                                        </td>

                                        <td width = "23%"><%= contact %></td>

                                        <td colspan = "2">
                                            Invoice Address:
                                        </td>

                                        <td colspan = "2">
                                            Delivery
                                            Address:<button type = "button" onClick = 'copyInvToDelAddr();'>Same as
                                            Contact</button>

                                            <p> <%
                                        set rs3 = getMysqlQueryRecordSet("Select * from delivery_address where retire='n' and contact_no=" & contact_no & " order by isdefault desc", con)
                                        if not rs3.eof then
                                            %>
                                                <label for = "deladddropdown"></label>

                                                                      <select name = "deladddropdown"
                                                                          id = "deladddropdown"
                                                                          onchange = "javascript:populateDelAdd();">
                                                                          <%
                                                                          do until rs3.eof
                                                                          %>

                                                                              <option value = "<%= rs3("DELIVERY_ADDRESS_ID") %>"><%= rs3("DELIVERY_NAME") %></option>
                                                                              <%
                                                                              rs3.movenext
                                                                              loop
                                                                              %>
                                                                      </select>
                                            <%
                                        end if
                                            call closeRs(rs3)
                                            %></td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <%
                                            If quote = "y" then
                                            %>

                                                Quote
                                            <%
                                            Else
                                            %>

                                                Order
                                            <%
                                            End If
                                            %>&nbsp;No:
                                        </td>

                                        <td><%= rs("order_number") %></td>

                                        <td width = "8%">
                                            Line 1:
                                        </td>

                                        <td width = "28%">
                                            <input name = "add1" type = "text" id = "add1" tabindex = "10"
                                                value = "<%= rs2("street1") %>" size = "30" maxlength = "100">
                                        </td>

                                        <td width = "8%">
                                            Line 1:
                                        </td>

                                        <td width = "23%">
                                            <input name = "add1d" type = "text" id = "add1d" tabindex = "20"
                                                value = "<%= rs("deliveryadd1") %>" size = "30" maxlength = "100">
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            Date of
                                            <%
                                        If quote = "y" then
                                            %>

                                                Quote
                                            <%
                                        Else
                                            %>

                                            Order
                                            <%
                                        End If
                                            %>:
                                        </td>

                                        <td><%= rs("order_date") %></td>

                                        <td>
                                            Line 2:
                                        </td>

                                        <td>
                                            <input name = "add2" type = "text" id = "add2" tabindex = "11"
                                                value = "<%= rs2("street2") %>" size = "30" maxlength = "100">
                                        </td>

                                        <td>
                                            Line 2:
                                        </td>

                                        <td>
                                            <input name = "add2d" type = "text" id = "add2d" tabindex = "21"
                                                value = "<%= rs("deliveryadd2") %>" size = "30" maxlength = "100">
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            Customer Reference:
                                        </td>

                                        <td>
                                            <%
                                        if len(rs("customerreference") ) > 30 then
                                            %>

                                                <input name = "reference" type = "text" id = "reference" tabindex = "4"
                                                    value = "<%= rs("customerreference") %>" maxlength = "50">
                                            <%
                                        else
                                            %>

                                            <input name = "reference" type = "text" id = "reference" tabindex = "4"
                                                value = "<%= rs("customerreference") %>" maxlength = "30"> <%
                                        end if
                                            %></td>

                                        <td>
                                            Line 3:
                                        </td>

                                        <td>
                                            <input name = "add3" type = "text" id = "add3" tabindex = "11"
                                                value = "<%= rs2("street3") %>" size = "30" maxlength = "100">
                                        </td>

                                        <td>
                                            Line 3:
                                        </td>

                                        <td>
                                            <input name = "add3d" type = "text" id = "add3d" tabindex = "21"
                                                value = "<%= rs("deliveryadd3") %>" size = "30" maxlength = "100">
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            Clients Title:
                                        </td>

                                        <td>
                                            <input name = "clientstitle" type = "text" id = "clientstitle"
                                                tabindex = "5" value = "<%= rs1("title") %>">
                                        </td>

                                        <td>
                                            Town:
                                        </td>

                                        <td>
                                            <input name = "town" type = "text" id = "town" tabindex = "12"
                                                value = "<%= rs2("town") %>" size = "30" maxlength = "100">
                                        </td>

                                        <td>
                                            Town:
                                        </td>

                                        <td>
                                            <input name = "townd" type = "text" id = "townd" tabindex = "22"
                                                value = "<%= rs("deliverytown") %>" size = "30" maxlength = "100">
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            First Name:
                                        </td>

                                        <td>
                                            <input name = "clientsfirst" type = "text" id = "clientsfirst"
                                                tabindex = "5" value = "<%= rs1("first") %>">
                                        </td>

                                        <td>
                                            County:
                                        </td>

                                        <td>
                                            <input name = "county" type = "text" id = "county" tabindex = "13"
                                                value = "<%= rs2("county") %>" size = "30" maxlength = "100">
                                        </td>

                                        <td>
                                            County:
                                        </td>

                                        <td>
                                            <input name = "countyd" type = "text" id = "countyd" tabindex = "23"
                                                value = "<%= rs("deliverycounty") %>" size = "30" maxlength = "100">
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            Surname:
                                        </td>

                                        <td>
                                            <input name = "clientssurname" type = "text" id = "clientssurname"
                                                tabindex = "5" value = "<%= rs1("surname") %>" readonly>
                                        </td>

                                        <td>
                                            Postcode:
                                        </td>

                                        <td>
                                            <input name = "postcode" type = "text" id = "postcode" tabindex = "14"
                                                value = "<%= rs2("postcode") %>" size = "15" maxlength = "50">
                                        </td>

                                        <td>
                                            Postcode:
                                        </td>

                                        <td>
                                            <input name = "postcoded" type = "text" id = "postcoded" tabindex = "24"
                                                value = "<%= rs("deliverypostcode") %>" size = "15" maxlength = "50">
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            Tel Home:
                                        </td>

                                        <td>
                                            <input name = "tel" type = "text" id = "tel" tabindex = "5"
                                                value = "<%= rs2("tel") %>">
                                        </td>

                                        <td>
                                            Country:
                                        </td>

                                        <td>
                                            <input name = "country" type = "text" id = "country" tabindex = "15"
                                                value = "<%= rs2("country") %>" size = "30" maxlength = "100">
                                        </td>

                                        <td>
                                            Country:
                                        </td>

                                        <td>
                                            <input name = "countryd" type = "text" id = "countryd" tabindex = "25"
                                                value = "<%= rs("deliverycountry") %>" size = "30" maxlength = "100">
                                        </td>
                                    </tr>
                                    <%
                                call getPhoneNumber(con, order, 1, delphonetype1, delphone1)
                                    call getPhoneNumber(con, order, 2, delphonetype2, delphone2)
                                    call getPhoneNumber(con, order, 3, delphonetype3, delphone3)
                                    %>

                                    <tr>
                                        <td>
                                            Tel Work:
                                        </td>

                                        <td>
                                            <input name = "telwork" type = "text" id = "telwork" tabindex = "5"
                                                value = "<%= rs1("telwork") %>">
                                            &nbsp;
                                        </td>

                                        <td>&nbsp;
                                            
                                        </td>

                                        <td>&nbsp;
                                            
                                        </td>

                                        <td>
                                            Contact Name:
                                        </td>

                                        <td>
                                            <input name = "deliverycontact" type = "text" id = "deliverycontact"
                                                tabindex = "25" value = "<%= rs("DeliveryContact") %>" size = "30"
                                                maxlength = "100">
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            Mobile:
                                        </td>

                                        <td>
                                            <input name = "mobile" type = "text" id = "mobile" tabindex = "5"
                                                value = "<%= rs1("mobile") %>">
                                            &nbsp;
                                        </td>

                                        <td>&nbsp;
                                            
                                        </td>

                                        <td>&nbsp;
                                            
                                        </td>

                                        <td>
                                            Contact number 1:
                                        </td>

                                        <td>
                                            <select name = "delphonetype1" id = "delphonetype1">
                                                <%
                                            for n = 1 to ubound(typenames)
                                                %>

                                                <option value = "<%= typenames(n) %>"
                                                    <%= selected(typenames(n), delphonetype1) %>><%= typenames(n) %></option>
                                                <%
                                            next
                                                %>
                                                <%
                                            if not arrayContains(typenames, delphonetype1) then
                                                %>

                                                    <option value = "<%= delphonetype1 %>"
                                                        selected><%= delphonetype1 %></option>
                                                <%
                                            end if
                                                %>
                                            </select>

                                            &nbsp;

                                            <input name = "delphone1" type = "text" id = "delphone1"
                                                value = "<%= delphone1 %>" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            Email Address:
                                        </td>

                                        <td>
                                            <input name = "email_address" type = "text" id = "email_address"
                                                tabindex = "5" value = "<%= rs2("email_address") %>">
                                        </td>
                <td></td>

                <td></td>

                                        <td>
                                            Contact number 2:
                                        </td>

                                        <td>
                                            <select name = "delphonetype2" id = "delphonetype2">
                                                <%
                                            for n = 1 to ubound(typenames)
                                                %>

                                                <option value = "<%= typenames(n) %>"
                                                    <%= selected(typenames(n), delphonetype2) %>><%= typenames(n) %></option>
                                                <%
                                            next
                                                %>
                                                <%
                                            if not arrayContains(typenames, delphonetype2) then
                                                %>

                                                    <option value = "<%= delphonetype2 %>"
                                                        selected><%= delphonetype2 %></option>
                                                <%
                                            end if
                                                %>
                                            </select>

                                            &nbsp;

                                            <input name = "delphone2" type = "text" id = "delphone2"
                                                value = "<%= delphone2 %>" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <%
                                    if not hideVatRate(con, contact_no) then
                                        %>

                                            <td>
                                               <%=VATRatewording%>
                                            </td>

                                            <td>
                                                <select name = "vatrate" id = "vatrate" class="xview">
                                                    <%
                                                    for n = 1 to ubound(vatRates)
                                                    %>

                                                        <option value = "<%= vatRates(n) %>"
                                                            <%= selected(ccur(vatRate), ccur(vatRates(n))) %>><%= formatNumber(vatRates(n), 3, -1) %>%</option>
                                                        <%
                                                        next
                                                        %>
                                                </select>
                                            </td>
                                        <%
                                    else
                                        %>

                                        <td>&nbsp;
                                            
                                        </td>

                                        <td>
                                            <input type = "hidden" name = "vatrate" id = "vatrate"
                                                value = "<%= vatRate %>" />
                                        </td>
                                        <%
                                    end if
                                        %>
                                        <%
                                    if rs1("company_vat_no") <> "" then
                                        %>

                                            <td>
                                                Company VAT Number:
                                            </td>

                                            <td><%= rs1("company_vat_no") %></td>
                                        <%
                                    else
                                        %>

                                        <td>&nbsp;
                                            
                                        </td>

                                        <td>&nbsp;
                                            
                                        </td>
                                        <%
                                    end if
                                        %>

                                        <td>
                                            Contact number 3:
                                        </td>

                                        <td>
                                            <select name = "delphonetype3" id = "delphonetype3">
                                                <%
                                            for n = 1 to ubound(typenames)
                                                %>

                                                <option value = "<%= typenames(n) %>"
                                                    <%= selected(typenames(n), delphonetype3) %>><%= typenames(n) %></option>
                                                <%
                                            next
                                                %>
                                                <%
                                            if not arrayContains(typenames, delphonetype3) then
                                                %>

                                                    <option value = "<%= delphonetype3 %>"
                                                        selected><%= delphonetype3 %></option>
                                                <%
                                            end if
                                                %>
                                            </select>

                                            &nbsp;

                                            <input name = "delphone3" type = "text" id = "delphone3"
                                                value = "<%= delphone3 %>" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Wrap Type:
                                            
                                        </td>

                                        <td><%Set rs3 = getMysqlUpdateRecordSet("Select * from WrappingTypes", con)%>
<select name="wraptype" id="wraptype" tabindex="85" onchange="wrapTypeChangeHandler();" >
<%do until rs3.eof
%>
<option value="<%=rs3("wrappingid")%>" <%=selected(rs3("wrappingid"), defaultwrappingid) %>><%=rs3("wrap")%></option>
<%rs3.movenext
loop
rs3.close
set rs3=nothing%>
</select>
                                            
                                        </td>

                                        <td>
                                            Company Name:
                                        </td>

                                        <td>
                                            <input name = "companyname" value = "<%= rs2("company") %>" type = "text"
                                                id = "companyname" tabindex = "26" size = "30" maxlength = "255">
                                        </td>

                                        <td>
                                            Production Date:
                                        </td>

                                        <td>
                                            <%
                                        if isSuperUser() then
                                            %>

                                                <input name = "productiondate" value = "<%= rs("productiondate") %>"
                                                    type = "text" id = "productiondate" size = "10" maxlength = "10">
                                               
                                            <%
                                        else
                                            %>

                                            <input name = "productiondate" value = "<%= rs("productiondate") %>"
                                                type = "text" id = "productiondate" size = "10" maxlength = "10"
                                                readonly>

                                            <%
                                        end if
                                            %>
                                        </td>
                                    </tr>

                                    <tr>
                                        <%
                                    if not hideOrderType(con, contact_no) then
                                        %>

                                            <td>
                                                Order Type:
                                            </td>

                                            <td><%= getOrderType(rs) %>
                                                <%
                                                otype = getOrderType(rs)
                                                %></td>
                                        <%
                                    else
                                        %>

                                        <td colspan = "2">&nbsp;
                                            
                                        </td>
                                        <%
                                    end if
                                        %>
                                        <% 'response.Write("retregion=" & retrieveUserRegion() & " osorder= " & rs("overseasOrder"))
                                    if retrieveUserRegion() = 1 and(rs("overseasOrder") = "n" or isNull(rs("overseasOrder") ) or isEmpty(rs("overseasOrder") ) ) then
                                        %>

                                            <td>
                                                Approx. Delivery Date:
                                            </td>

                                            <td>
                                                <select id = "deldate" name = "deldate" tabindex = "4">
                                                    <%
                                                    for i = 1 to ubound(delDateValues)
                                                    %>

                                                        <option value = "<%= delDateValues(i) %>"
                                                            <%= selected(delDateValues(i), delDate) %>><%= delDateDescriptions(i) %></option>
                                                        <%
                                                        next
                                                        %>
                                                </select>
                                            </td>
                                        <%
                                    else
                                        %>

                                        <td>
                                            Ex. Works Date:
                                        </td>
                                        <%
                                        Set rs5 = getMysqlQueryRecordSet("select count(*) as lorrycount from (SELECT exportcollectionid FROM exportlinks E, exportcollshowrooms L where E.linkscollectionid=L.exportCollshowroomsID and purchase_no=" & order & "  group by exportcollectionid)  as x", con)
                                        if not rs5.eof then
                                            lorrycount = rs5("lorrycount")
                                        end if

                                            rs5.close
                                            set rs5 = nothing
                                        %>

                                            <td>

                                                <%
                                                    if Cint(lorrycount) > 1 then
                                                        response.Write("Split Shipment Dates")
                                                        splitshipment = "y"
                                                %>
                                                <%
                                                    else
                                                        splitshipment = "n"
                                                        sql = "Select * from exportcollections E, exportLinks L, exportCollShowrooms S where L.purchase_no=" & order & " and L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID"
                                                        'response.Write(sql)
                                                        Set rs5 = getMysqlQueryRecordSet(sql, con)
                                                        if not rs5.eof then
                                                            response.Write(rs5("CollectionDate") )
                                                        else
                                                            response.Write(" TBA")
                                                        end if
                                                        rs5.close
                                                        set rs5 = nothing
                                                %>
                                                <%
                                                    end if
                                                %>
                                            </td>
                                        <%
                                    end if
                                        %>
                                        <%if retrieveuserlocation()=purchaseLocation or  userHasRoleInList("ADMINISTRATOR")  then
										bookeddelreadonly=""
										end if%>

                                            <td>
                                                Booked Delivery Date:
                                            </td>

                                            <td>
                                                <input <%if (userHasRole("ADMINISTRATOR") and retrieveUserName()<>contact) or userHasRole("REGIONAL_ADMINISTRATOR") then%>onClick="confirmGetMessage();"<%end if%> name = "bookeddeliverydate"
                                                    value = "<%= rs("bookeddeliverydate") %>" type = "text"
                                                    id = "bookeddeliverydate" size = "10" maxlength = "10" <%=bookeddelreadonly%>>
     <%if userHasRole("ADMINISTRATOR") or userHasRole("REGIONAL_ADMINISTRATOR") then%>                                             
                            <script type="text/javascript">                        
                                function confirmGetMessage() {
  //display a confirmation box asking the visitor if they want to get a message
  var theAnswer = confirm("This Delivery Date field is for the showroom team to complete, as this date is the actual delivery to the end customers home address. Press OK to continue to enter this date or press CANCEL.");
	
  //if the user presses the "OK" button display the message "Javascript is cool!!"
  if (theAnswer){
     alert("Enter a date");
	 $('#ui-datepicker-div').show();
  }
	
 //otherwise display another message
 else{
	 $('#ui-datepicker-div').hide();
	 $('#bookeddeliverydate').prop('readonly', true);
  }
}
                            </script>

                                               
                                            </td>
                                        <%
                                    else
                                        %>

                                        <td>&nbsp;
                                            
                                        </td>

                                        <td>&nbsp;
                                            
                                        </td>
                                        <%
                                    end if
                                        %>
                                    </tr>

                                    <tr>
                                        <%
                                    if retrieveUserRegion() = 1 then
                                        %>

                                            <td>
                                                Acknowledgement Date:
                                            </td>

                                            <td>
                                                <input name = "acknowdate" value = "<%= rs("acknowdate") %>"
                                                    type = "text" id = "acknowdate" size = "10" maxlength = "10">
                                                
                                            </td>

                                            <td>
                                                Acknowledgement Version:
                                            </td>

                                            <td>
                                                <select id = "acknowversion" name = "acknowversion">
                                                    <option />
                                                    <%
                                                    for i = 1 to 10
                                                    %>

                                                        <option value = "<%= i %>"
                                                            <%= selected(rs("acknowversion"), i) %>><%= i %></option>
                                                        <%
                                                        next
                                                        %>
                                                </select>
                                            </td>
                                        <%
                                    else
                                        %>

                                        <td>&nbsp;
                                            
                                        </td>

                                        <td>&nbsp;
                                            
                                        </td>

                                        <td>&nbsp;
                                            
                                        </td>

                                        <td>&nbsp;
                                            
                                        </td>
                                        <%
                                    end if
                                        %>
                                        <td>Delivery Time:</td><td><%=rs("delivery_Time")%></td>
                                    </tr>
                                    <%
                                if not hideShipper(con, contact_no) then
                                    %>

                                        <tr>
                                            <td>
                                                Current Shipper:
                                            </td>

                                            <td colspan = "4">
                                                <%
                                                Set rs3 = getMysqlQueryRecordSet("Select * from purchase_shipper where purchase_no=" & rs("purchase_no"), con)
                                                if not rs3.eof then
                                                    shipperaddress = rs3("shippername")
                                                    if rs3("add1") <> "" then shipperaddress = shipperaddress & ", " & rs3("add1")
                                                    if rs3("add2") <> "" then shipperaddress = shipperaddress & ", " & rs3("add2")
                                                    if rs3("add3") <> "" then shipperaddress = shipperaddress & ", " & rs3("add3")
                                                    if rs3("town") <> "" then shipperaddress = shipperaddress & ", " & rs3("town")
                                                    if rs3("countystate") <> "" then shipperaddress = shipperaddress & ", " & rs3("countystate")
                                                    if rs3("postcode") <> "" then shipperaddress = shipperaddress & ", " & rs3("postcode")
                                                    response.Write(shipperaddress)
                                                end if
                                                    rs3.close
                                                    set rs3 = nothing
                                                %>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>
                                                Change Shipper:
                                            </td>

                                            <td colspan = "4">
                                                <select name = "shipper" id = "shipper">
                                                    <option value = "n">No</option>
                                                    <%
                                                    Set rs3 = getMysqlUpdateRecordSet("Select * from shipper_address order by shipperName asc", con)
                                                        do until rs3.eof
                                                    %>

                                                        <option value = "<%= rs3("shipper_address_id") %>"><%
                                                            response.Write(rs3("shipperName") & " " & rs3("add1") & " " & rs3("town") )
                                                        %></option>
                                                        <%
                                                        rs3.movenext
                                                            loop
                                                            rs3.close
                                                            set rs3 = nothing
                                                        %>
                                                </select>

                                                &nbsp;
                                            </td>
                                        </tr>
                                    <%
                                else
                                    %>

                                        <input type = "hidden" name = "shipper" id = "shipper" value = "n" />
                                    <%
                                end if
                                    %>

                                    
                                </table>

<div id="NoteInner">
<hr />
<%if retrieveUserRegion() = 1 or SavoirOwned="y" then
                                %>
                    <div id = "ordernote">
                                        <input type = "hidden" name = "ordernote_id" id = "ordernote_id"
                                            value = "<%= ordernote_id %>" />
                                        
                                        <input type = "hidden" name = "order" id = "order"
                                            value = "<%= order %>" />

                        <table width = "98%" border = "0" align = "center" cellpadding = "3"
                                            cellspacing = "3">
                            <tr>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                              <td>Follow-up Date</td>
                              <td>Status</td>
                            </tr>
                            <tr>
                                <td>
                                    Order Notes:
                                </td>

                                <td>
                                    <textarea name = "ordernote_notetext" cols = "50" rows = "2"
                                                        class = "indentleft"></textarea>
                                </td>
<td><input name = "ordernote_followupdate"
                                                        value = "<%= ordernote_followupdate %>" type = "text"
                                                        id = "ordernote_followupdate" size = "10" maxlength = "10">
                              Date&nbsp;</td>

                                <td>
                                    <select name = "ordernote_action" id = "ordernote_action">
                                        <option value = "<%= ACTION_REQUIRED %>"
                                                            <%= selected(ACTION_REQUIRED, ordernote_action) %>><%= ACTION_REQUIRED %></option>

                                        <option value = "<%= NO_FURTHER_ACTION %>"
                                                            <%= selected(NO_FURTHER_ACTION, ordernote_action) %>><%= NO_FURTHER_ACTION %></option>
                                       <option value = "<%= COMPLETED %>"
                                                            <%= selected(COMPLETED, ordernote_action) %>><%= COMPLETED %></option>
                                    </select>
                                </td>
                            </tr>
                        </table>
          </div>
                                    

                                            <p><a href = "javascript:showHideNotesHistory();">Show/Hide Previous Order
                                            Notes</a></p>

                                            <div id = "ordernotehistory">
                                                <table width = "98%" border = "0" align = "center" cellpadding = "3"
                                                    cellspacing = "3">
                                                    <tr>
                                                        <td>
                                                            Text
                                                        </td>

                                                        <td>
                                                            Status</td>

                                                        <td>
                                                            Created By
                                                        </td>

                                                        <td>
                                                            Created
                                                        </td>
                                                        <td> Type </td>
                                                        <td> Task Due Date</td>
                                                        <td> Completed</td>
                                                    </tr>
                                                    <%
                                                    for i = 1 to ubound(noteHistory)
                                                    %>

                                                        <tr>
                                                            <td width = "400"><%= simpleHtmlEncode(noteHistory(i).text) %></td>

                                                            <td><%= noteHistory(i).action %></td>

                                                            <td><%= noteHistory(i).userName %></td>

                                                            <td><%= noteHistory(i).createdDate %></td>
                                                            <td><%= noteHistory(i).noteType %></td>
                                                            <td><%if noteHistory(i).action="Completed" then%>
                                                            <%= toDisplayDate(noteHistory(i).followUpDate) %>
                                                            <%elseif noteHistory(i).action="No Further Action" then
															else%>
                                                            <input name="Note_followupdate<%=(noteHistory(i).orderNoteId)%>" type="text" class="text" id="Note_followupdate<%=(noteHistory(i).orderNoteId)%>" value="<%= toDisplayDate(noteHistory(i).followUpDate) %>" size="10" />
                                                            <%end if%></td>
                                                            <td><%if noteHistory(i).action="Completed" then
															response.Write("Completed<br />" & left(noteHistory(i).NoteCompletedDate,10) & " " & noteHistory(i).NoteCompletedBy)
															elseif noteHistory(i).action="No Further Action" then
															else%>
															<input name="notecompleted<%=(noteHistory(i).orderNoteId)%>" id="notecompleted<%=(noteHistory(i).orderNoteId)%>" type="checkbox" />
                                                            <%end if%></td>
                                                        </tr>
                                                        <%
                                                        next
                                                        %>
                                                </table>
                                            </div>
                                    <%
                                        end if
                                    %>
                                




<hr /><br />
</div>
                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
  <tr>
    <td><strong>Click or Drag to upload files for this order<br>
      <br>
      Files Required for Production:</strong><br />
	<%dzOrderNum = rs("order_number")
		dzPurchaseNo = order
		dzUserId = retrieveUserID()
		dzType = "entry"
		%>
		<!-- #include file="dropzone_include.asp" --><br /><hr />&nbsp;</td>
  </tr>
</table>
                           <div class = "clear"></div>

                                                <p class = "purplebox"><span class = "radiobxmargin">Mattress
                                                Required</span>&nbsp; Yes

                                                <label> <input type = "radio" name = "mattressrequired"
                                                            id = "mattressrequired_y" value = "y"
                                                    <%= ischecked2(rs("mattressrequired")="y") %>
                                                    onClick = "javascript: mattressChanged(
                                                        false)"class = "mattress-field"></label>

                                                No

                                                <input name = "mattressrequired" type = "radio"
                                                    id = "mattressrequired_n" value = "n"
                                                    <%= ischecked2(rs("mattressrequired")="n") %>
                                                    onClick = "javascript: mattressChanged(
                                                        false)"class = "mattress-field">

                                                <%
                                            If splitshipment = "y" then
                                                Set rs5 = getMysqlUpdateRecordSet("Select * from exportlinks L, exportcollections C, exportCollShowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and purchase_no=" & order & " and S.exportCollectionID=C.exportcollectionsID AND L.componentID=1", con)
                                                if not rs5.eof then
                                                    response.Write("<span  class=""justifyright""><font color=""red"">Shipment date: " & rs5("CollectionDate") & "&nbsp;&nbsp; </font></span>")
                                                end if
                                                rs5.close
                                                set rs5 = nothing
                                            end if
                                                %>

                                                </p>

                                                <div id = "mattress_div">
                                                    <table width = "98%" border = "0" align = "center" cellpadding = "3"
                                                        cellspacing = "3">
                                                        <tr>
                                                            <td width = "11%">
                                                                Savoir Model:
                                                            </td>

                                                            <td width = "22%">
                                                                <%
'if retrieveUserRegion()=1 then
'Set rs3 = getMysqlUpdateRecordSet("Select * from Bedmodel where retired='n' order by priority asc", con)
'else
                                                            Set rs3 = getMysqlUpdateRecordSet("Select * from Bedmodel where bedmodelid<>14 and UKonly='n' and retired='n' order by priority asc", con)
                                                                'end if
                                                                %>

                                                                <select name = "savoirmodel" id = "savoirmodel"
                                                                    tabindex = "30"
                                                                    onChange = "defaultVentPosition(); getStandardMattressPrice(); javascript:showtickingoptions(); mattressvegantext();"
                                                                    class = "mattress-field">
                                                                    <option value = "n">--</option>
                                                                    <%
                                                                do until rs3.eof
                                                                    selcted = ""
                                                                    if rs3("bedmodel") = rs("savoirmodel") then selcted = "selected"
                                                                    %>

                                                                        <option value = "<%= rs3("bedmodel") %>"
                                                                            <%= selcted %>><%= rs3("bedmodel") %></option>
                                                                    <%
                                                                    rs3.movenext
                                                                loop
                                                                    rs3.close
                                                                    set rs3 = nothing
                                                                    %>
                                                                </select>
                                                            </td>

                                                            <td width = "10%">
                                                                Mattress Type:
                                                            </td>

                                                            <td>
                                                                <select name = "mattresstype" id = "mattresstype"
                                                                    class = "mattress-field" tabindex = "31"
                                                                    onChange = "javascript:mattspecialwidthSelected(true); javascript:mattspeciallengthSelected(true); "></select>
                                                            </td>

                                                            <td width = "8%">
                                                                Ticking Options
                                                            </td>

                                                            <td width = "24%">
                                                                <select name = "tickingoptions" id = "tickingoptions"
                                                                    class = "mattress-field" tabindex = "32">
                                                                    <%
                                                                    If rs("tickingoptions") <> "" Then
                                                                    %>

                                                                        <option value = "<%= rs("tickingoptions") %>"
                                                                            selected><%= rs("tickingoptions") %></option>
                                                                    <%
                                                                    End If
                                                                    %>

                                                                    <option value = "n">--</option>

                                                                    <option value = "TBC">TBC</option>

                                                                    <option value = "White Trellis">White
                                                                    Trellis</option>

                                                                    <option value = "Grey Trellis">Grey Trellis</option>

                                                                    <option value = "Silver Trellis">Silver
                                                                    Trellis</option>

                                                                   
                                                                </select>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Mattress Width:
                                                            </td>

                                                            <td>
                                                                <select name = "mattresswidth" id = "mattresswidth"
                                                                    class = "mattress-field" tabindex = "33"
                                                                    onChange = "javascript:mattspecialwidthSelected(true); javascript:setMattressTypes($('#mattresstype option:selected').val()); getStandardMattressPrice();">
                                                                    <option value = "n"
                                                                        <%= selected(rs("mattresswidth"), "n") %>>--</option>

                                                                    <option value = "TBC"
                                                                        <%= selected(rs("mattresswidth"), "TBC") %>>TBC</option>

                                                                    <option value = "90cm"
                                                                        <%= selected(rs("mattresswidth"), "90cm") %>>90cm</option>
                                                                        
                                                                         <option value = "96.5cm"
                                                                        <%= selected(rs("mattresswidth"), "96.5cm") %>>96.5cm</option>
                                                                        

                                                                    <option value = "100cm"
                                                                        <%= selected(rs("mattresswidth"), "100cm") %>>100cm</option>
                                                                    <%
                                                                if rs("mattresswidth") = "105cm" then
                                                                    %><option value = "105cm" selected>105cm</option>
                                                                    <%
                                                                end if
                                                                    %>
                                                                    <%
                                                                if rs("mattresswidth") = "120cm" then
                                                                    %><option value = "120cm" selected>120cm</option>
                                                                    <%
                                                                end if
                                                                    %>

                                                                    <option value = "140cm"
                                                                        <%= selected(rs("mattresswidth"), "140cm") %>>140cm</option>

                                                                    <option value = "150cm"
                                                                        <%= selected(rs("mattresswidth"), "150cm") %>>150cm</option>

                                                                    <option value = "152.5cm"
                                                                        <%= selected(rs("mattresswidth"), "152.5cm") %>>152.5cm</option>

                                                                    <option value = "160cm"
                                                                        <%= selected(rs("mattresswidth"), "160cm") %>>160cm</option>
                                                                    <%
                                                                if rs("mattresswidth") = "170cm" then
                                                                    %><option value = "170cm" selected>170cm</option>
                                                                    <%
                                                                end if
                                                                    %>

                                                                    <option value = "180cm"
                                                                        <%= selected(rs("mattresswidth"), "180cm") %>>180cm</option>
                                                                    <%
                                                                if retrieveUserRegion() = 4 or retrieveUserLocation() = 1 or retrieveUserLocation() = 27 or retrieveUserLocation() = 23 then
                                                                    %>

                                                                        <option value = "183cm"
                                                                            <%= selected(rs("mattresswidth"), "183cm") %>>183cm</option>
                                                                    <%
                                                                end if
                                                                    %>
                                                                     <option value = "190cm"
                                                                        <%= selected(rs("mattresswidth"), "190cm") %>>190cm</option>

                                                                    <option value = "193cm"
                                                                        <%= selected(rs("mattresswidth"), "193cm") %>>193cm</option>

                                                                    <option value = "200cm"
                                                                        <%= selected(rs("mattresswidth"), "200cm") %>>200cm</option>

                                                                    <option value = "210cm"
                                                                        <%= selected(rs("mattresswidth"), "210cm") %>>210cm</option>
                                                                    <%
                                                                if rs("mattresswidth") = "240cm" then
                                                                    %><option value = "240cm" selected>240cm</option>
                                                                    <%
                                                                end if
                                                                    %>

                                                                    <option value = "Special Width"
                                                                        <%= selected(rs("mattresswidth"), "Special Width") %>>Special Width</option>
                                                                    <%
                                                                if rs("mattresswidth") = "60in" then
                                                                    %><option value = "60in" selected>60in</option>
                                                                    <%
                                                                end if
                                                                    %>
                                                                    <%
                                                                if rs("mattresswidth") = "76in" then
                                                                    %><option value = "76in" selected>76in</option>
                                                                    <%
                                                                end if
                                                                    %>
                                                                </select>
                                                            </td>

                                                            <td width = "10%">
                                                                Mattress Length:
                                                            </td>

                                                            <td width = "25%">
                                                                <select name = "mattresslength" id = "mattresslength"
                                                                    class = "mattress-field" tabindex = "34"
                                                                    onChange = "javascript:mattspeciallengthSelected(true); getStandardMattressPrice();">
                                                                    <option value = "n"
                                                                        <%= selected(rs("mattresslength"), "n") %>>--</option>

                                                                    <option value = "TBC"
                                                                        <%= selected(rs("mattresslength"), "TBC") %>>TBC</option>

                                                                    <option value = "190cm"
                                                                        <%= selected(rs("mattresslength"), "190cm") %>>190cm</option>

                                                                    <option value = "200cm"
                                                                        <%= selected(rs("mattresslength"), "200cm") %>>200cm</option>

                                                                    <option value = "203cm"
                                                                        <%= selected(rs("mattresslength"), "203cm") %>>203cm</option>

                                                                    <option value = "210cm"
                                                                        <%= selected(rs("mattresslength"), "210cm") %>>210cm</option>
                                                                    <%
                                                                if retrieveUserRegion() = 4 or retrieveUserLocation() = 1 or retrieveUserLocation() = 27 or retrieveUserLocation() = 23 then
                                                                    %>

                                                                    <option value = "213cm"
                                                                        <%= selected(rs("mattresslength"), "213cm") %>>213cm</option>
                                                                    <%
                                                                end if
                                                                    %>
                                                                    <%
                                                                if rs("mattresslength") = "220cm" then
                                                                    %><option value = "220cm" selected>220cm</option>
                                                                    <%
                                                                end if
                                                                    %>

                                                                    <option value = "Special Length"
                                                                        <%= selected(rs("mattresslength"), "Special Length") %>>Special Length</option>
                                                                    <%
                                                                if rs("mattresslength") = "80in" then
                                                                    %><option value = "80in" selected>80in</option>
                                                                    <%
                                                                end if
                                                                    %>
                                                                </select>
                                                            </td>

                                                            <td colspan = "2">&nbsp;
                                                                
                                                            </td>
                                                        </tr>
                                                    </table>

                                                    <div id = "mattspecialwidth1">
                                                        <table width = "50%" border = "0" align = "left"
                                                            cellpadding = "3" cellspacing = "3">
                                                            <tr id = "mattspecialwidth1">
                                                                <td width = "180" class = "mgindent">
                                                                    Mattress 1 Special Width cms
                                                                </td>

                                                                <td>
                                                                    <label for = "matt1width"></label>

                                                                    <input name = "matt1width" type = "text"
                                                                        id = "matt1width"
                                                                        value = "<%= origmatt1width %>" size = "10"
                                                                        class = "mattress-field" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>

                                                    <div id = "mattspecialwidth2">
                                                        <table width = "50%" border = "0" align = "left"
                                                            cellpadding = "3" cellspacing = "3">
                                                            <tr>
                                                                <td width = "180">
                                                                    Mattress 2 Special Width cms
                                                                </td>

                                                                <td>
                                                                    <input name = "matt2width" type = "text"
                                                                        id = "matt2width"
                                                                        value = "<%= origmatt2width %>" size = "10"
                                                                        class = "mattress-field" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>

                                                    <div id = "mattspeciallength1">
                                                        <table width = "50%" border = "0" align = "left"
                                                            cellpadding = "3" cellspacing = "3">
                                                            <tr>
                                                                <td width = "180" class = "mgindent">
                                                                    Mattress 1 Special Length cms
                                                                </td>

                                                                <td>
                                                                    <input name = "matt1length" type = "text"
                                                                        id = "matt1length"
                                                                        value = "<%= origmatt1length %>" size = "10"
                                                                        class = "mattress-field" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>

                                                    <div id = "mattspeciallength2">
                                                        <table width = "50%" border = "0" align = "right"
                                                            cellpadding = "3" cellspacing = "3">
                                                            <tr>
                                                                <td width = "180">
                                                                    Mattress 2 Special Length cms
                                                                </td>

                                                                <td>
                                                                    <input name = "matt2length" type = "text"
                                                                        id = "matt2length"
                                                                        value = "<%= origmatt2length %>" size = "10"
                                                                        class = "mattress-field" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                             <div class = "clear"></div>

                                                    <p>Support (as viewed from the foot looking toward the head
                                                    end):</p>

                                                    <table width = "98%" border = "0" align = "center" cellpadding = "3"
                                                        cellspacing = "3">
                                                        <tr>
                                                            <td width = "11%">
                                                                Left Support:
                                                            </td>

                                                            <td width = "14%">
                                                                <select name = "leftsupport" id = "leftsupport"
                                                                    tabindex = "40" class = "mattress-field">
                                                                    <%
                                                                If rs("leftsupport") <> "" Then
                                                                    %>

                                                                        <option value = "<%= rs("leftsupport") %>"
                                                                            selected><%= rs("leftsupport") %></option>
                                                                    <%
                                                                End If
                                                                    %>

                                                                    <option value = "n">--</option>

                                                                    <option value = "TBC">TBC</option>

                                                                    <option value = "Extra Soft">Extra Soft</option>

                                                                    <option value = "Soft">Soft</option>

                                                                    <option value = "Medium">Medium</option>

                                                                    <option value = "Firm">Firm</option>

                                                                    <option value = "Extra Firm">Extra Firm</option>
                                                                </select>
                                                            </td>

                                                            <td width = "11%">
                                                                Right Support:
                                                            </td>

                                                            <td width = "13%">
                                                                <select name = "rightsupport" id = "rightsupport"
                                                                    tabindex = "41" class = "mattress-field">
                                                                    <%
                                                                If rs("rightsupport") <> "" Then
                                                                    %>

                                                                        <option value = "<%= rs("rightsupport") %>"
                                                                            selected><%= rs("rightsupport") %></option>
                                                                    <%
                                                                End If
                                                                    %>

                                                                    <option value = "n">--</option>

                                                                    <option value = "TBC">TBC</option>

                                                                    <option value = "Extra Soft">Extra Soft</option>

                                                                    <option value = "Soft">Soft</option>

                                                                    <option value = "Medium">Medium</option>

                                                                    <option value = "Firm">Firm</option>

                                                                    <option value = "Extra Firm">Extra Firm</option>
                                                                </select>
                                                            </td>

                                                            <td width = "11%">
                                                                Vent Position:
                                                            </td>

                                                            <td width = "16%">
                                                                <select name = "ventposition" id = "ventposition"
                                                                    tabindex = "42" class = "mattress-field">
                                                                    <%
                                                                If rs("ventposition") <> "" Then
                                                                    %>

                                                                        <option value = "<%= rs("ventposition") %>"
                                                                            selected><%= rs("ventposition") %></option>
                                                                    <%
                                                                End If
                                                                    %>

                                                                    <option value = "n">--</option>

                                                                    <option value = "Vents on Ends">Vents on
                                                                    Ends</option>

                                                                    <option value = "Vents on Sides">Vents on
                                                                    Sides</option>
                                                                </select>
                                                            </td>

                                                            <td width = "10%">
                                                                Vent Finish:
                                                            </td>

                                                            <td width = "14%">
                                                                <select name = "ventfinish" id = "ventfinish"
                                                                    tabindex = "43" class = "mattress-field">
                                                                    <%
                                                                If rs("ventfinish") <> "" Then
                                                                    %>

                                                                        <option value = "<%= rs("ventfinish") %>"
                                                                            selected><%= rs("ventfinish") %></option>
                                                                    <%
                                                                End If
                                                                    %>

                                                                    <option value = "n">--</option>

                                                                    <option value = "Brass">Brass</option>

                                                                    <option value = "Chrome">Chrome</option>
                                                                </select>
                                                            </td>
                                                        </tr>
                                                    </table>

                                                    <p>Mattress Special Instructions:</p>

                                                    <div id = "tick1">
                                                        <img src = "img/white-trellis.jpg" alt = "White Trellis"
                                                            width = "149" height = "96" hspace = "30" align = "right">
                                                    </div>

                                                    <div id = "tick2">
                                                        <img src = "img/grey-trellis.jpg" alt = "Grey Trellis"
                                                            width = "149" height = "96" hspace = "30" align = "right">
                                                    </div>

                                                    <div id = "tick3">
                                                        <img src = "img/silver-trellis.jpg" alt = "Silver Trellis"
                                                            width = "149" height = "96" hspace = "30" align = "right">
                                                    </div>

                                                    <div id = "tick4">
                                                        <img src = "img/oatmeal-trellis.jpg" alt = "oatmeal Trellis"
                                                            width = "149" height = "96" hspace = "30" align = "right">
                                                    </div>

                                                    <strong>
<%
	chcount=250-len(rs("mattressinstructions"))%>
                                                    <textarea name = "mattressinstructions" cols = "65"
                                                        class = "indentleft" id = "mattressinstructions"
                                                        class = "mattress-field"
                                                        tabindex = "44"onKeyUp="return taCount(this,'myCounter')"><%=rs("mattressinstructions")%></textarea>
	<br />&nbsp;<B><SPAN id=myCounter><%=chcount%></SPAN></B>/250

                                                    </strong>
                                                    <%
                                                set mattressDiscountObj = getDiscount(con, rs("purchase_no"), 1, rs("mattressprice") )
                                                    %>

                                                    <table width = "98%" border = "0" align = "center" cellpadding = "3"
                                                        cellspacing = "3" class="xview">
                                                        <tr>
                                                            <td width = "17%" class = "mattressdiscountcls">
                                                                List
                                                                Price: <%= getCurrencySymbolForCurrency(orderCurrency) %><span id = "standardmattresspricespan"><%= mattressDiscountObj.standardPrice %></span>

                                                                <input type = "hidden" name = "standardmattressprice"
                                                                    id = "standardmattressprice"
                                                                    value = "<%= mattressDiscountObj.standardPrice %>"
                                                                    onchange = "setMattressPrice();" />
                                                            </td>

                                                            <td class = "mattressdiscountcls">
                                                                Discount: %

                                                                <input type = "radio" name = "mattressdiscounttype"
                                                                    id = "mattressdiscounttype1" value = "percent"
                                                                    <%= ischecked2(mattressDiscountObj.discountType="percent") %>
                                                                    onchange = "setMattressPrice(); setEditPageMattressDiscountSummary();">
                                                                &nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %><input type = "radio"
                                                                    name = "mattressdiscounttype"
                                                                    id = "mattressdiscounttype2" value = "currency"
                                                                    <%= ischecked2(mattressDiscountObj.discountType="currency") %>
                                                                    onchange = "setMattressPrice(); setEditPageMattressDiscountSummary();">
                                                                &nbsp;

                                                                <input name = "mattressdiscount"
                                                                    value = "<%= mattressDiscountObj.discount %>"
                                                                    type = "text" id = "mattressdiscount"
                                                                    size = "10"
                                                                    onchange = "setMattressPrice(); setEditPageMattressDiscountSummary();">
                                                            </td>

                                                            <td colspan = "2" class = "mattressdiscountcls_dummy">&nbsp;
                                                                
                                                            </td>

                                                            <td width = "25%">
                                                                Mattress
                                                                <span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>

                                                                <label><input name = "mattressprice" type = "text"
                                                                           id = "mattressprice"
                                                                    value = "<%= rs("mattressprice") %>" size = "15"
                                                                    class = "mattress-field"
                                                                    onchange = "setMattressDiscount();" /></label>
                                                                  <div class="showWholesale bordergris">
                                                                  <b>Wholesale Pricing</b><br />
                                                                    Wholesale Mattress
                                                                <span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
                                                                <%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=1"
    															Set rs4 = getMysqlQueryRecordSet(sql, con)
																if not rs4.eof then
																
																Wmattressprice=rs4("price")
																end if
																rs4.close
																set rs4=nothing%>

                                                                <input name = "Wmattressprice" type = "text"
                                                                           id = "Wmattressprice"
                                                                           
                                                                    value = "<%=Wmattressprice%>" size = "10"
                                                                    class = ""
                                                                     />
                                                              </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                            <div class = "clear"></div>

                                                <p class = "purplebox"><span class = "radiobxmargin">Topper
                                                Required</span>&nbsp; Yes

                                                <label>
                                                <input type = "radio" name = "topperrequired" id = "topperrequired_y"
                                                    value = "y"<%= ischecked2(rs("topperrequired")="y") %>
                                                    onClick = "javascript: topperChanged(
                                                        false)"class = "topper-field" /></label>

                                                No

                                                <input type = "radio" name = "topperrequired" id = "topperrequired_n"
                                                    value = "n"<%= ischecked2(rs("topperrequired")="n") %>
                                                    onClick = "javascript: topperChanged(
                                                        false)"class = "topper-field" />
                                                <%
                                            If splitshipment = "y" then
                                                Set rs5 = getMysqlUpdateRecordSet("Select * from exportlinks L, exportcollections C, exportCollShowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and purchase_no=" & order & " and S.exportCollectionID=C.exportcollectionsID AND L.componentID=5", con)
                                                if not rs5.eof then
                                                    response.Write("<span  class=""justifyright""><font color=""red"">Shipment date: " & rs5("CollectionDate") & "&nbsp;&nbsp; </font></span>")
                                                end if
                                                rs5.close
                                                set rs5 = nothing
                                            end if
                                                %></p>

                                                <div id = "topper_div">
                                                    <table width = "98%" border = "0" align = "center" cellpadding = "3"
                                                        cellspacing = "3">
                                                        <tr>
                                                            <td width = "11%">
                                                                Topper Type:
                                                            </td>

                                                            <td width = "22%">
                                                                <select name = "toppertype" id = "toppertype"
                                                                    tabindex = "45" class = "topper-field"
                                                                    onchange = "getStandardTopperPrice(); showtoppertickingoptions(); toppervegantext();">
                                                                    <option value = "n"
                                                                        <%= selected(rs("toppertype"), "n") %>>--</option>

                                                                    <option value = "TBC"
                                                                        <%= selected(rs("toppertype"), "TBC") %>>TBC</option>

                                                                    <option value = "HCa Topper"
                                                                        <%= selected(rs("toppertype"), "HCa Topper") %>>HCa Topper</option>

                                                                    <option value = "HW Topper"
                                                                        <%= selected(rs("toppertype"), "HW Topper") %>>HW Topper</option>

                                                                    <option value = "CW Topper"
                                                                        <%= selected(rs("toppertype"), "CW Topper") %>>CW Topper</option>
                                                                    <option value = "CFv Topper"
                                                                        <%= selected(rs("toppertype"), "CFv Topper") %>>CFv Topper</option>
                                                                </select>
                                                            </td>

                                                            <td>
                                                                Topper Width:
                                                            </td>

                                                            <td>
                                                                <select name = "topperwidth" id = "topperwidth"
                                                                    tabindex = "46"
                                                                    onChange = "javascript:topperspecialwidthSelected(true); getStandardTopperPrice();"
                                                                    class = "topper-field">
                                                                    <option value = "n"
                                                                        <%= selected(rs("topperwidth"), "n") %>>--</option>

                                                                    <option value = "TBC"
                                                                        <%= selected(rs("topperwidth"), "TBC") %>>TBC</option>

                                                                    <option value = "90cm"
                                                                        <%= selected(rs("topperwidth"), "90cm") %>>90cm</option>
                                                                    
                                                                    <option value = "96.5cm"
                                                                        <%= selected(rs("topperwidth"), "96.5cm") %>>96.5cm</option>
                                                                        
                                                                    <option value = "100cm"
                                                                        <%= selected(rs("topperwidth"), "100cm") %>>100cm</option>

                                                                    <%
                                                                if rs("topperwidth") = "105cm" then
                                                                    %><option value = "105cm" selected>105cm</option>
                                                                    <%
                                                                end if
                                                                    %>
                                                                    <%
                                                                if rs("topperwidth") = "120cm" then
                                                                    %><option value = "120cm" selected>120cm</option>
                                                                    <%
                                                                end if
                                                                    %>

                                                                    <option value = "140cm"
                                                                        <%= selected(rs("topperwidth"), "140cm") %>>140cm</option>

                                                                    <option value = "150cm"
                                                                        <%= selected(rs("topperwidth"), "150cm") %>>150cm</option>

                                                                    <option value = "152.5cm"
                                                                        <%= selected(rs("topperwidth"), "152.5cm") %>>152.5cm</option>

                                                                    <option value = "160cm"
                                                                        <%= selected(rs("topperwidth"), "160cm") %>>160cm</option>
                                                                    <%
                                                                if rs("topperwidth") = "170cm" then
                                                                    %><option value = "170cm" selected>170cm</option>
                                                                    <%
                                                                end if
                                                                    %>

                                                                    <option value = "180cm"
                                                                        <%= selected(rs("topperwidth"), "180cm") %>>180cm</option>
                                                                    <%
                                                                if retrieveUserRegion() = 4 or retrieveUserLocation() = 1 or retrieveUserLocation() = 27 or retrieveUserLocation() = 23 then
                                                                    %>

                                                                    <option value = "183cm"
                                                                        <%= selected(rs("topperwidth"), "183cm") %>>183cm</option>
                                                                    <%
                                                                end if
                                                                    %>
                                                                    <option value = "190cm"
                                                                        <%= selected(rs("topperwidth"), "190cm") %>>190cm</option>

                                                                    <option value = "193cm"
                                                                        <%= selected(rs("topperwidth"), "193cm") %>>193cm</option>

                                                                    <option value = "200cm"
                                                                        <%= selected(rs("topperwidth"), "200cm") %>>200cm</option>

                                                                    <option value = "210cm"
                                                                        <%= selected(rs("topperwidth"), "210cm") %>>210cm</option>
                                                                    <%
                                                                if rs("topperwidth") = "240cm" then
                                                                    %><option value = "240cm" selected>240cm</option>
                                                                    <%
                                                                end if
                                                                    %>

                                                                    <option value = "Special Width"
                                                                        <%= selected(rs("topperwidth"), "Special Width") %>>Special Width</option>
                                                                </select>
                                                            </td>

                                                            <td width = "8%">
                                                                Topper Length:
                                                            </td>

                                                            <td width = "24%">
                                                                <select name = "topperlength" id = "topperlength"
                                                                    tabindex = "47"
                                                                    onChange = "javascript:topperspeciallengthSelected(true); getStandardTopperPrice();"
                                                                    class = "topper-field">
                                                                    <option value = "n"
                                                                        <%= selected(rs("topperlength"), "n") %>>--</option>

                                                                    <option value = "TBC"
                                                                        <%= selected(rs("topperlength"), "TBC") %>>TBC</option>

                                                                    <option value = "190cm"
                                                                        <%= selected(rs("topperlength"), "190cm") %>>190cm</option>

                                                                    <option value = "200cm"
                                                                        <%= selected(rs("topperlength"), "200cm") %>>200cm</option>

                                                                    <option value = "203cm"
                                                                        <%= selected(rs("topperlength"), "203cm") %>>203cm</option>

                                                                    <option value = "210cm"
                                                                        <%= selected(rs("topperlength"), "210cm") %>>210cm</option>
                                                                    <%
                                                                if retrieveUserRegion() = 4 or retrieveUserLocation() = 1 or retrieveUserLocation() = 27 or retrieveUserLocation() = 23 then
                                                                    %>

                                                                    <option value = "213cm"
                                                                        <%= selected(rs("topperlength"), "213cm") %>>213cm</option>
                                                                    <%
                                                                end if
                                                                    %>
                                                                    <%
                                                                if rs("topperlength") = "220cm" then
                                                                    %><option value = "220cm" selected>220cm</option>
                                                                    <%
                                                                end if
                                                                    %>

                                                                    <option value = "Special Length"
                                                                        <%= selected(rs("topperlength"), "Special Length") %>>Special Length</option>
                                                                </select>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Ticking Options:
                                                            </td>

                                                            <td>
                                                                <select name = "toppertickingoptions"
                                                                    id = "toppertickingoptions" tabindex = "48"
                                                                    class = "topper-field">
                                                                    <%
                                                                If rs("toppertickingoptions") <> "" Then
                                                                    %>

                                                                        <option value = "<%= rs("toppertickingoptions") %>"
                                                                            selected><%= rs("toppertickingoptions") %></option>
                                                                    <%
                                                                End If
                                                                    %>

                                                                    <option value = "n">--</option>

                                                                    <option value = "TBC">TBC</option>

                                                                    <option value = "White Trellis">White
                                                                    Trellis</option>

                                                                    <option value = "Grey Trellis">Grey Trellis</option>

                                                                    <option value = "Silver Trellis">Silver
                                                                    Trellis</option>

                                                                    
                                                                </select>
                                                            </td>

                                                            <td width = "10%">&nbsp;
                                                                
                                                            </td>

                                                            <td width = "25%">&nbsp;
                                                                
                                                            </td>

                                                            <td>&nbsp;
                                                                
                                                            </td>

                                                            <td>&nbsp;
                                                                
                                                            </td>
                                                        </tr>
                                                    </table>

                                                    <div id = "topperspecialwidth1">
                                                        <table width = "50%" border = "0" align = "left"
                                                            cellpadding = "3" cellspacing = "3">
                                                            <tr id = "topperspecialwidth1">
                                                                <td width = "180" class = "mgindent">
                                                                    Topper Special Width cms
                                                                </td>

                                                                <td>
                                                                    <label for = "topper1width"></label>

                                                                    <input name = "topper1width" type = "text"
                                                                        id = "topper1width"
                                                                        value = "<%= origtopper1width %>"
                                                                        size = "10" class = "topper-field">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>

                                                    <div id = "topperspeciallength1">
                                                        <table width = "50%" border = "0" align = "right"
                                                            cellpadding = "3" cellspacing = "3">
                                                            <tr id = "topperspeciallength1">
                                                                <td width = "180" class = "mgindent">
                                                                    Topper Special Length cms
                                                                </td>

                                                                <td>
                                                                    <label for = "topper1length"></label>

                                                                    <input name = "topper1length" type = "text"
                                                                        id = "topper1length"
                                                                        value = "<%= origtopper1length %>"
                                                                        size = "10" class = "topper-field">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>

                                                    <div id = "tick1t">
                                                        <img src = "img/white-trellis.jpg" alt = "White Trellis"
                                                            width = "149" height = "96" hspace = "30" align = "right">
                                                    </div>

                                                    <div id = "tick2t">
                                                        <img src = "img/grey-trellis.jpg" alt = "Grey Trellis"
                                                            width = "149" height = "96" hspace = "30" align = "right">
                                                    </div>

                                                    <div id = "tick3t">
                                                        <img src = "img/silver-trellis.jpg" alt = "Silver Trellis"
                                                            width = "149" height = "96" hspace = "30" align = "right">
                                                    </div>

                                                    <div id = "tick4t">
                                                        <img src = "img/oatmeal-trellis.jpg" alt = "oatmeal Trellis"
                                                            width = "149" height = "96" hspace = "30" align = "right">
                                                    </div>
                             <div class = "clear"></div>

                                                    <p>Topper Special Instructions:</p>
<%
	chcount=250-len(rs("specialinstructionstopper"))%>
                                                    <textarea name = "specialinstructionstopper" cols = "65"
                                                        class = "indentleft" id = "specialinstructionstopper"
                                                        tabindex = "49"
                                                        class = "topper-field" onKeyUp="return taCount(this,'myCounter1')"><%=rs("specialinstructionstopper")%></textarea><br />&nbsp;<B><SPAN id=myCounter1><%=chcount%></SPAN></B>/250
                                                <%
                                            set topperDiscountObj = getDiscount(con, rs("purchase_no"), 5, rs("topperprice") )
                                                %>

                                                <table width = "98%" border = "0" align = "center" cellpadding = "3"
                                                    cellspacing = "3" class="xview">
                                                    <tr>
                                                        <td width = "17%" class = "topperdiscountcls">
                                                            List
                                                            Price: <%= getCurrencySymbolForCurrency(orderCurrency) %><span id = "standardtopperpricespan"><%= topperDiscountObj.standardPrice %></span>

                                                            <input type = "hidden" name = "standardtopperprice"
                                                                id = "standardtopperprice"
                                                                value = "<%= topperDiscountObj.standardPrice %>"
                                                                onchange = "setTopperPrice();" />
                                                        </td>

                                                        <td class = "topperdiscountcls">
                                                            Discount: %

                                                            <input type = "radio" name = "topperdiscounttype"
                                                                id = "topperdiscounttype1" value = "percent"
                                                                <%= ischecked2(topperDiscountObj.discountType="percent") %>
                                                                onchange = "setTopperPrice(); setEditPageTopperDiscountSummary();">
                                                            &nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %><input type = "radio"
                                                                name = "topperdiscounttype"
                                                                id = "topperdiscounttype2" value = "currency"
                                                                <%= ischecked2(topperDiscountObj.discountType="currency") %>
                                                                onchange = "setTopperPrice(); setEditPageTopperDiscountSummary();">
                                                            &nbsp;

                                                            <input name = "topperdiscount"
                                                                value = "<%= topperDiscountObj.discount %>"
                                                                type = "text" id = "topperdiscount" size = "10"
                                                                onchange = "setTopperPrice(); setEditPageTopperDiscountSummary();">
                                                        </td>

                                                        <td colspan = "2" class = "topperdiscountcls_dummy">&nbsp;
                                                            
                                                        </td>

                                                        <td width = "25%">
                                                            Topper
                                                            <span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>

                                                            <label><input name = "topperprice"
                                                                       value = "<%= rs("topperprice") %>" type = "text"
                                                                id = "topperprice" size = "15"
                                                                onchange = "setTopperDiscount();"
                                                                class = "topper-field" /></label>
                                                                
                                                                <div class="showWholesale bordergris"><b>Wholesale Pricing</b>  <br />
                                                                    Wholesale Topper
                                                                <span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
                                                                <%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=5"
    															Set rs4 = getMysqlQueryRecordSet(sql, con)
																if not rs4.eof then
																
																Wtopperprice=rs4("price")
																end if
																rs4.close
																set rs4=nothing%>

                                                                <input name = "Wtopperprice" type = "text"
                                                                           id = "Wtopperprice"
                                                                           
                                                                    value = "<%=Wtopperprice%>" size = "10"
                                                                    class = "topper-field"
                                                                     />
                                                          </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                                </div>
                           <div class = "clear"></div>

                                                <!-- Base Start -->
                                                <p class = "purplebox"><span class = "radiobxmargin">Base
                                                Required</span>&nbsp;
                                                <%
                                            If rs("baserequired") = "n" Then
                                                %>

                                                Yes

                                                <label>
                                                <input type = "radio" name = "baserequired" id = "baserequired_y"
                                                    value = "y" onClick = "baseChanged(false);" class = "base-field"></label>

                                                No

                                                <input name = "baserequired" type = "radio" id = "baserequired_n"
                                                    value = "n" checked onClick = "baseChanged(false);" class = "base-field">
                                                <%
                                            Else
                                                %>

                                                Yes

                                                <label>
                                                <input type = "radio" name = "baserequired" id = "baserequired_y"
                                                    value = "y" checked onClick = "baseChanged(false);" class = "base-field"></label>

                                                No

                                                <input name = "baserequired" type = "radio" id = "baserequired_n"
                                                    value = "n" onClick = "baseChanged(false);" class = "base-field"> <%
                                            End If
                                                %>
                                                <%
                                            If splitshipment = "y" then
                                                Set rs5 = getMysqlUpdateRecordSet("Select * from exportlinks L, exportcollections C, exportCollShowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and purchase_no=" & order & " and S.exportCollectionID=C.exportcollectionsID AND L.componentID=3", con)
                                                if not rs5.eof then
                                                    response.Write("<span  class=""justifyright""><font color=""red"">Shipment date: " & rs5("CollectionDate") & "&nbsp;&nbsp; </font></span>")
                                                end if
                                                rs5.close
                                                set rs5 = nothing
                                            end if
                                                %></p>

                                                <div id = "base_div">
												<input type="hidden" name="extbase" id="extbase" value="<%=rs("extbase")%>" /> <!-- extbase removed as part of R127, but keeping it as a hidden field to make things easier -->                                                    <span id = "base_span1">

                                                    <table width = "98%" border = "0" align = "center" cellpadding = "3"
                                                        cellspacing = "3">
                                                        <tr>
                                                            <td>
                                                                Savoir Model:
                                                            </td>

                                                            <td>
                                                                <select name = "basesavoirmodel" id = "basesavoirmodel"
                                                                    tabindex = "50" class = "base-field"
                                                                    onchange = "getStandardBasePrice(); getStandardBaseTrimPrice(); getStandardBaseUpholsteryPrice(); showbasetickingoptions(); basevegantext();">
                                                                    <%
                                                                If rs("basesavoirmodel") <> "" Then
                                                                    %>

                                                                        <option value = "<%= rs("basesavoirmodel") %>"
                                                                            selected><%= rs("basesavoirmodel") %></option>
                                                                    <%
                                                                End If
                                                                    %>

                                                                    <option value = "n">--</option>

                                                                    <option value = "No. 1">No. 1</option>

                                                                    <option value = "No. 2">No. 2</option>

                                                                    <option value = "No. 3">No. 3</option>

                                                                    <option value = "No. 4">No. 4</option>
                                                                    
                                                                    <option value = "No. 4v">No. 4v</option>

                                                                    <option value = "Pegboard">Pegboard</option>

                                                                    <option value = "Platform Base">Platform
                                                                    Base</option>

                                                                    <option value = "Savoir Slim">Savoir Slim</option>

                                                                    <option value = "State">State</option>

                                                                    <option value = "Surround">Surround</option>
                                                                </select>
                                                            </td>

                                                            <td>
                                                                Base Type:
                                                            </td>

                                                            <td>
                                                                <select name = "basetype" id = "basetype"
                                                                    tabindex = "51" class = "base-field"
                                                                    onChange = "basespecialwidthSelected(true); basespeciallengthSelected(true); setLinkPosition(null); setLegQty();">
                                                                    <option value = "n"
                                                                        <%= selected(rs("basetype"), "n") %>>--</option>

                                                                    <option value = "TBC"
                                                                        <%= selected(rs("basetype"), "TBC") %>>TBC</option>

                                                                    <option value = "One Piece"
                                                                        <%= selected(rs("basetype"), "One Piece") %>>One Piece</option>

                                                                    <option value = "North-South Split"
                                                                        <%= selected(rs("basetype"), "North-South Split") %>>North-South Split</option>

                                                                    <option value = "East-West Split"
                                                                        <%= selected(rs("basetype"), "East-West Split") %>>East-West Split</option>

                                                                    <option value = "One-Piece"
                                                                        <%= selected(rs("basetype"), "One-Piece") %>>One-Piece</option>
                                                                </select>
                                                            </td>

                                                            <td>
                                                                Base Width:
                                                            </td>

                                                            <td>
                                                                <select name = "basewidth" id = "basewidth"
                                                                    tabindex = "52" class = "base-field"
                                                                    onChange = "basespecialwidthSelected(true); setLegQty(); getStandardBasePrice();">
                                                                    <option value = "n"
                                                                        <%= selected(rs("basewidth"), "n") %>>--</option>

                                                                    <option value = "TBC"
                                                                        <%= selected(rs("basewidth"), "TBC") %>>TBC</option>

                                                                    <option value = "90cm"
                                                                        <%= selected(rs("basewidth"), "90cm") %>>90cm</option>
                                                                    
                                                                    <option value = "96.5cm"
                                                                        <%= selected(rs("basewidth"), "96.5cm") %>>96.5cm</option>
                                                                        
                                                                    <option value = "100cm"
                                                                        <%= selected(rs("basewidth"), "100cm") %>>100cm</option>

                                                                    <%
                                                                if rs("basewidth") = "105cm" then
                                                                    %><option value = "105cm" selected>105cm</option>
                                                                    <%
                                                                end if
                                                                    %>
                                                                    <%
                                                                if rs("basewidth") = "120cm" then
                                                                    %><option value = "120cm" selected>120cm</option>
                                                                    <%
                                                                end if
                                                                    %>

                                                                    <option value = "140cm"
                                                                        <%= selected(rs("basewidth"), "140cm") %>>140cm</option>

                                                                    <option value = "150cm"
                                                                        <%= selected(rs("basewidth"), "150cm") %>>150cm</option>

                                                                    <option value = "152.5cm"
                                                                        <%= selected(rs("basewidth"), "152.5cm") %>>152.5cm</option>

                                                                    <option value = "160cm"
                                                                        <%= selected(rs("basewidth"), "160cm") %>>160cm</option>

                                                                    <%
                                                                if rs("basewidth") = "170cm" then
                                                                    %><option value = "170cm" selected>170cm</option>
                                                                    <%
                                                                end if
                                                                    %>

                                                                    <option value = "180cm"
                                                                        <%= selected(rs("basewidth"), "180cm") %>>180cm</option>
                                                                    <%
                                                                if retrieveUserRegion() = 4 or retrieveUserLocation() = 1 or retrieveUserLocation() = 27 or retrieveUserLocation() = 23 then
                                                                    %>

                                                                    <option value = "183cm"
                                                                        <%= selected(rs("basewidth"), "183cm") %>>183cm</option>
                                                                    <%
                                                                end if
                                                                    %>
                                                                    <option value = "190cm"
                                                                        <%= selected(rs("basewidth"), "190cm") %>>190cm</option>

                                                                    <option value = "193cm"
                                                                        <%= selected(rs("basewidth"), "193cm") %>>193cm</option>

                                                                    <option value = "200cm"
                                                                        <%= selected(rs("basewidth"), "200cm") %>>200cm</option>

                                                                    <option value = "210cm"
                                                                        <%= selected(rs("basewidth"), "210cm") %>>210cm</option>
                                                                    <%
                                                                if rs("basewidth") = "240cm" then
                                                                    %><option value = "240cm" selected>240cm</option>
                                                                    <%
                                                                end if
                                                                    %>

                                                                    <option value = "Special Width"
                                                                        <%= selected(rs("basewidth"), "Special Width") %>>Special Width</option>
                                                                </select>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Base Length:
                                                            </td>

                                                            <td>
                                                                <select name = "baselength" id = "baselength"
                                                                    tabindex = "53" class = "base-field"
                                                                    onChange = "javascript:basespeciallengthSelected(true); getStandardBasePrice();">
                                                                    <option value = "n"
                                                                        <%= selected(rs("baselength"), "n") %>>--</option>

                                                                    <option value = "TBC"
                                                                        <%= selected(rs("baselength"), "TBC") %>>TBC</option>

                                                                    <option value = "190cm"
                                                                        <%= selected(rs("baselength"), "190cm") %>>190cm</option>

                                                                    <option value = "200cm"
                                                                        <%= selected(rs("baselength"), "200cm") %>>200cm</option>

                                                                    <option value = "203cm"
                                                                        <%= selected(rs("baselength"), "203cm") %>>203cm</option>

                                                                    <option value = "210cm"
                                                                        <%= selected(rs("baselength"), "210cm") %>>210cm</option>
                                                                    <%
                                                                if retrieveUserRegion() = 4 or retrieveUserLocation() = 1 or retrieveUserLocation() = 27 or retrieveUserLocation() = 23 then
                                                                    %>

                                                                    <option value = "213cm"
                                                                        <%= selected(rs("baselength"), "213cm") %>>213cm</option>
                                                                    <%
                                                                end if
                                                                    %>
                                                                    <%
                                                                if rs("baselength") = "220cm" then
                                                                    %><option value = "220cm" selected>220cm</option>
                                                                    <%
                                                                end if
                                                                    %>

                                                                    <option value = "Special Length"
                                                                        <%= selected(rs("baselength"), "Special Length") %>>Special Length</option>
                                                                </select>
                                                            </td>

                                                            <td>
                                                                Height Spring
                                                            </td>

                                                            <td>
                                                                <%
                                                            Set rs3 = getMysqlUpdateRecordSet("Select * from baseheightspring", con)
                                                                %>

                                                                <select name = "spring" id = "spring"
                                                                    class = "base-field">
                                                                    <%
                                                                do until rs3.eof
                                                                    selcted = ""
                                                                    if rs3("baseheightspring") = rs("baseheightspring") then selcted = "selected"
                                                                    %>

                                                                        <option value = "<%= rs3("baseheightspring") %>"
                                                                            <%= selcted %>><%= rs3("baseheightspring") %></option>
                                                                    <%
                                                                    rs3.movenext
                                                                loop
                                                                    rs3.close
                                                                    set rs3 = nothing
                                                                    %>
                                                                </select>

                                                                &nbsp;
                                                            </td>

                                                            <td>
                                                                Ticking Options:
                                                            </td>

                                                            <td>
                                                                <select name = "basetickingoptions"
                                                                    id = "basetickingoptions" tabindex = "48"
                                                                    class = "base-field">
                                                                    <option value = "n"
                                                                        <%= selected(rs("basetickingoptions"), "n") %>>--</option>

                                                                    <option value = "TBC"
                                                                        <%= selected(rs("basetickingoptions"), "TBC") %>>TBC</option>

                                                                    <option value = "White Trellis"
                                                                        <%= selected(rs("basetickingoptions"), "White Trellis") %>>White Trellis</option>

                                                                    <option value = "Grey Trellis"
                                                                        <%= selected(rs("basetickingoptions"), "Grey Trellis") %>>Grey Trellis</option>

                                                                    <option value = "Silver Trellis"
                                                                        <%= selected(rs("basetickingoptions"), "Silver Trellis") %>>Silver Trellis</option>
<%if rs("basetickingoptions")="Oatmeal Trellis" then%>
<option value="Oatmeal Trellis" <%=selected(rs("basetickingoptions"), "Oatmeal Trellis")%>>Oatmeal Trellis</option>
<%end if%>
                                                                    
                                                                </select>

                                                                &nbsp;
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Link Position:
                                                            </td>

                                                            <td>
                                                                <select name = "linkposition" id = "linkposition"
                                                                    tabindex = "60" class = "base-field"
                                                                    onChange = "javascript:linkPositionChanged();"></select>
                                                            </td>

                                                            <td>
                                                                <span class = "linkfinishclass">Link Finish</span>
                                                            </td>

                                                            <td>
                                                                <span class = "linkfinishclass">

                                                                <select name = "linkfinish" id = "linkfinish"
                                                                    tabindex = "61" class = "base-field">
                                                                    <%
                                                                    If rs("linkfinish") <> "" Then
                                                                    %>

                                                                        <option value = "<%= rs("linkfinish") %>"
                                                                            selected><%= rs("linkfinish") %></option>
                                                                    <%
                                                                    End If
                                                                    %>

                                                                    <option value = "n">--</option>

                                                                    <option value = "Brass">Brass</option>

                                                                    <option value = "Chrome">Chrome</option>
                                                                </select>

                                                                </span>
                                                            </td>
                                                      </tr>

															<tr>
															<td>
															Base Trim:
															</td>
															<td>
															<select name = "basetrim" id = "basetrim"
															onchange = "setBaseTrimColours(); getStandardBaseTrimPrice(); resetPriceField('basetrimprice',11); showHideBasePriceSummaryRow(11); baseTrim(); ">
															<option value="n" <%=selected(rs("basetrim"), "n")%> >No</option>
															<option value="Standard" <%=selected(rs("basetrim"), "Standard")%> >Standard</option>
															<option value="Self Levelling" <%=selected(rs("basetrim"), "Self Levelling")%> >Self Levelling</option>
															</select>
															</td>
															<td class = "baseTrimColourCls">
															Base Trim Colour:
															</td>
															<td class = "baseTrimColourCls">
															<select name = "basetrimcolour" id = "basetrimcolour"></select>
															</td>
															</tr>
															<tr>
															<tr>
                                                            <td>Drawers:</td>

                                                            <td><%
                                                            Set rs3 = getMysqlUpdateRecordSet("Select * from drawerconfig", con)
                                                                %>

                                                                <select name = "drawerconfig" id = "drawerconfig"
                                                                    tabindex = "58" class = "base-field" onchange = "getStandardBaseDrawersPrice(); resetPriceField('basedrawersprice',13); showDrawersSection(); showHideBasePriceSummaryRow(13); wholesaleDrawers(); ">
                                                                    <option value = "n">No</option>
                                                                    <%
                                                                do until rs3.eof
                                                                    selcted = ""
                                                                    if rs3("drawerconfig") = rs("basedrawerconfigid") then selcted = "selected"
                                                                    %>

                                                                        <option value = "<%= rs3("drawerconfig") %>"
                                                                            <%= selcted %>><%= rs3("drawerconfig") %></option>
                                                                    <%
                                                                    rs3.movenext
                                                                loop
                                                                    rs3.close
                                                                    set rs3 = nothing
                                                                    %>
                                                                </select>

                                                                &nbsp;
                                                            
                                                                
                                                            </td>
															<td class="drawerscls" >Drawer Height:</td>
															<td class="drawerscls" >
															<%
															Set rs3 = getMysqlUpdateRecordSet("Select * from drawerheight", con)
															%>
															<select name = "drawerheight" id = "drawerheight" tabindex = "58">
															<option value = "n" <%=selected(rs("basedrawerheight"), "n")%>>--</option>
															<%
															do until rs3.eof
															%>
															<option value="<%=rs3("drawerheight")%>" <%=selected(rs("basedrawerheight"), rs3("drawerheight"))%> ><%= rs3("drawerheight") %></option>
															<%
															rs3.movenext
															loop
															rs3.close
															set rs3 = nothing
															%>
															</select>
															&nbsp;
															</td>
                                                        </tr>
                                                    </table>

                                                    <div id = "basespecialwidth1">
                                                        <table width = "50%" border = "0" align = "left"
                                                            cellpadding = "3" cellspacing = "3">
                                                            <tr id = "basespecialwidth1">
                                                                <td width = "180" class = "mgindent">
                                                                    Base 1 Special Width cms
                                                                </td>

                                                                <td>
                                                                    <label for = "base1width"></label>

                                                                    <input name = "base1width" type = "text"
                                                                        id = "base1width"
                                                                        value = "<%= origbase1width %>" size = "10"
                                                                        class = "base-field">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>

                                                    <div id = "basespecialwidth2">
                                                        <table width = "50%" border = "0" align = "left"
                                                            cellpadding = "3" cellspacing = "3">
                                                            <tr>
                                                                <td width = "180">
                                                                    Base 2 Special Width cms
                                                                </td>

                                                                <td>
                                                                    <input name = "base2width" type = "text"
                                                                        id = "base2width"
                                                                        value = "<%= origbase2width %>" size = "10"
                                                                        class = "base-field">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>

                                                    <div id = "basespeciallength1">
                                                        <table width = "50%" border = "0" align = "left"
                                                            cellpadding = "3" cellspacing = "3">
                                                            <tr>
                                                                <td width = "180" class = "mgindent">
                                                                    Base 1 Special Length cms
                                                                </td>

                                                                <td>
                                                                    <input name = "base1length" type = "text"
                                                                        id = "base1length"
                                                                        value = "<%= origbase1length %>" size = "10"
                                                                        class = "base-field">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>

                                                    <div id = "basespeciallength2">
                                                        <table width = "50%" border = "0" align = "right"
                                                            cellpadding = "3" cellspacing = "3">
                                                            <tr>
                                                                <td width = "180">
                                                                    Base 2 Special Length cms
                                                                </td>

                                                                <td>
                                                                    <input name = "base2length" type = "text"
                                                                        id = "base2length"
                                                                        value = "<%= origbase2length %>" size = "10"
                                                                        class = "base-field">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                              <div class = "clear"></div>

                                                    <div id = "tick1b">
                                                        <img src = "img/white-trellis.jpg" alt = "White Trellis"
                                                            width = "149" height = "96" hspace = "30" align = "right">
                                                    </div>

                                                    <div id = "tick2b">
                                                        <img src = "img/grey-trellis.jpg" alt = "Grey Trellis"
                                                            width = "149" height = "96" hspace = "30" align = "right">
                                                    </div>

                                                    <div id = "tick3b">
                                                        <img src = "img/silver-trellis.jpg" alt = "Silver Trellis"
                                                            width = "149" height = "96" hspace = "30" align = "right">
                                                    </div>

                                                    <div id = "tick4b">
                                                        <img src = "img/oatmeal-trellis.jpg" alt = "oatmeal Trellis"
                                                            width = "149" height = "96" hspace = "30" align = "right">
                                                    </div>

                                                    <p>Base Special Instructions:</p>
<%
	chcount=250-len(rs("baseinstructions"))%>
                                                    <textarea name = "specialinstructions2" cols = "65"
                                                        class = "indentleft" id = "specialinstructions2"
                                                        class = "base-field"
                                                        tabindex = "62"onKeyUp="return taCount(this,'myCounter2')"><%=rs("baseinstructions")%></textarea><br />&nbsp;<B><SPAN id=myCounter2><%=chcount%></SPAN></B>/250
                                                <%
set baseDiscountObj = getDiscount(con, rs("purchase_no"), 3, rs("baseprice") )
set baseUpholsteryDiscountObj = getDiscount(con, rs("purchase_no"), 12, rs("upholsteryprice") )
set baseTrimDiscountObj = getDiscount(con, rs("purchase_no"), 11, rs("basetrimprice") )
set baseFabricDiscountObj = getDiscount(con, rs("purchase_no"), 17, rs("basefabricprice") )
set baseDrawersDiscountObj = getDiscount(con, rs("purchase_no"), 13, rs("basedrawersprice") )
                                                %>
                         <div class = "clear"></div>

                                                <!-- Base Fabric Start -->
                                                <p>&nbsp;Upholstered Base:

                                                <select name = "upholsteredbase" id = "upholsteredbase" tabindex = "70"
                                                    class = "base-field"
                                                    onChange = "setLinkPosition(null); upholsteredBaseChanged(); getStandardBaseUpholsteryPrice(); showHideBasePriceSummaryRow(17); showHideBasePriceSummaryRow(12);">
                                                    <option value = "n"
                                                        <%= selected(rs("upholsteredbase"), "n") %>>No</option>

                                                    <option value = "TBC"
                                                        <%= selected(rs("upholsteredbase"), "TBC") %>>TBC</option>

                                                    <option value = "Yes"
                                                        <%= selected(rs("upholsteredbase"), "Yes") %>>Yes</option>

                                                    <option value = "Yes, Com"
                                                        <%= selected(rs("upholsteredbase"), "Yes, Com") %>>Yes,
                                                    Com</option>
                                                </select>

                                                </p>

                                                    </span> <!-- end base_span1 -->
                                                    <span id = "base_span2">

                                                    <div id = "uphbase">
                                                        <table width = "98%" border = "0" align = "center"
                                                            cellpadding = "3" cellspacing = "3">
                                                            <tr>
                                                                <td>
                                                                    Base Fabric Direction
                                                                </td>

                                                                <td>
                                                                    <select name = "basefabricdirection"
                                                                        id = "basefabricdirection" class = "base-field">
                                                                        <%
                                                                    If rs("basefabricdirection") <> "" Then
                                                                        %>

                                                                        <option value = "<%= rs("basefabricdirection") %>"
                                                                            selected><%= rs("basefabricdirection") %></option>
                                                                        <%
                                                                    End If
                                                                        %>

                                                <option value = "n">--</option>

                                                <option value = "Fabric on the run">Fabric on the run</option>

                                                <option value = "Fabric on the drop">Fabric on the drop</option>
                                                                    </select>

                                                                    &nbsp;
                                                                </td>

                                                                <td width = "11%">
                                                                    Fabric Company:
                                                                </td>

                                                                <td width = "21%">
                                                                    <input name = "basefabric"
                                                                        value = "<%= rs("basefabric") %>"
                                                                        type = "text" id = "basefabric" size = "25"
                                                                        maxlength = "50" class = "base-field">
                                                                </td>

                                                                <td width = "12%">
                                                                    Fabric Design, Colour & Code:
                                                                </td>

                                                                <td width = "33%">
                                                                    <input name = "basefabricchoice"value="<%= rs("basefabricchoice") %>"
                                                                        type = "text" id = "basefabricchoice"
                                                                        size = "50" maxlength = "100"
                                                                        class = "base-field">
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td>
                                                                    Price Per Metre&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %>
                                                                </td>

                                                                <td>
                                                                    <input name = "basefabriccost"
                                                                        value = "<%= rs("basefabriccost") %>"
                                                                        type = "text" id = "basefabriccost"
                                                                        size = "15" class = "base-field xview">
                                                                </td>

                                                                <td>
                                                                    Fabric Quantity
                                                                </td>

                                                                <td>
                                                                    <input name = "basefabricmeters"
                                                                        value = "<%= rs("basefabricmeters") %>"
                                                                        type = "text" id = "basefabricmeters"
                                                                        size = "15" class = "base-field">
                                                                </td>

                                                            </tr>

                                                        </table>

                                                        <p>Fabric Special Instructions</p>
<%
	chcount=250-len(rs("basefabricdesc"))%>
                                                        <input name = "basefabricdesc" id = "basefabricdesc" type = "text"
                                                            class = "indentleft"
                                                            value = "<%= rs("basefabricdesc") %>" size = "85"
                                                            maxlength = "255" class = "base-field" onKeyUp="return taCount(this,'myCounter3')"><br />&nbsp;<B><SPAN id=myCounter3><%=chcount%></SPAN></B>/250
                                                        <br>
                                                    </div>

                               <div class = "clear"></div>
                           <div class = "clear"></div>

                                                </span> <!-- end base_span2 -->
                                                <!-- Base Fabric End -->
                                                <!-- Base End -->
<!-- base prices summary table -->
<div class="clear"></div>
<!-- #include file="base-price-summary.asp" -->
</div> <!-- end base_div -->
<div class="clear"></div>
                                                <p class = "purplebox"><span class = "radiobxmargin">Legs Required</span>&nbsp;
                                                <%
                                            If rs("legsrequired") = "n" Then
                                                %>

                                                    Yes

                                                    <label>
                                                    <input type = "radio" name = "legsrequired" id = "legsrequired_y"
                                                        value = "y" onClick = "javascript: legsChanged(
                                                        false)"class = "legs-field"></label>

                                                    No

                                                    <input name = "legsrequired" type = "radio" id = "legsrequired_n"
                                                        value = "n" checked onClick = "javascript: legsChanged(
                                                        false)"class = "legs-field">
                                                <%
                                            Else
                                                %>

                                                Yes

                                                <label>
                                                <input type = "radio" name = "legsrequired" id = "legsrequired_y"
                                                    value = "y" checked onClick = "javascript: legsChanged(
                                                    false)"class = "legs-field"></label>

                                                No

                                                <input name = "legsrequired" type = "radio" id = "legsrequired_n"
                                                    value = "n" onClick = "javascript: legsChanged(
                                                    false)"class = "legs-field"> <%
                                            End If
                                                %>
                                                <%
                                            If splitshipment = "y" then
                                                Set rs5 = getMysqlUpdateRecordSet("Select * from exportlinks L, exportcollections C, exportCollShowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and purchase_no=" & order & " and S.exportCollectionID=C.exportcollectionsID AND L.componentID=7", con)
                                                if not rs5.eof then
                                                    response.Write("<span  class=""justifyright""><font color=""red"">Shipment date: " & rs5("CollectionDate") & "&nbsp;&nbsp; </font></span>")
                                                end if
                                                rs5.close
                                                set rs5 = nothing
                                            end if
                                                %></p>

                                                <div id = "legs_div">
<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
<tr>
<td>Feature Leg:&nbsp;
<select name = "legstyle" id = "legstyle" tabindex = "54"
onChange = "setLegFinishes(); showLegStylePriceField(); setLegQty(); showFloorType(); getStandardLegsPrice(); ">
<%= makeSortedOptionString("legstyle", rs("legstyle"), true, con) %>
</select>
</td>
<td>
Qty Legs:&nbsp;
<select name = "legqty" id = "legqty" onChange = "getStandardLegsPrice();">
<%
for i = 0 to 12
%>
<option value = "<%= i %>"
<%= selected(i, rs("legqty")) %>><%= i %></option>
<%
next
%>
</select>
</td>
<td>
Leg Finish:&nbsp;
<select name = "legfinish" id = "legfinish" tabindex = "55" onChange = "getStandardLegsPrice();">
	<%If rs("legfinish")<>"" Then%>
	<option value="<%=rs("legfinish")%>" selected><%=rs("legfinish")%></option>
	<%End If%>
</select>
</td>
<td>
Leg Height:&nbsp;
<select name = "legheight" id = "legheight" tabindex = "56" onChange = "javascript:legspecialheightSelected(true);">
	<%If rs("legheight")<>"" Then%>
	<option value="<%=rs("legheight")%>" selected><%=rs("legheight")%></option>
	<%End If%>
</select>
</td>
<td><span id = "legspecialheight">
Special:
<input name = "speciallegheight" type = "text" id = "speciallegheight" value="<%= origlegheight %>" size = "10" />
</span>
</td>
<td class = "floortypeclass">Floor Type:&nbsp;
<select name = "floortype" id = "floortype" tabindex = "61">
	<option value = "TBC"<%= selected("TBC", rs("floortype")) %>>TBC</option>
	<option value = "Wooden" <%= selected("Wooden", rs("floortype")) %>>Wooden</option>
	<option value = "Carpeted" <%= selected("Carpeted", rs("floortype")) %>>Carpeted</option>
</select>
</td>
</tr>
<tr>
<td>Support Leg:&nbsp;
<select name = "addlegstyle" id = "addlegstyle"
onChange = "defaultAddLegFinish(); getStandardAddLegsPrice();">
<%= makeOptionString("addlegstyle", rs("addlegstyle"), true, con) %>
</select>
</td>
<td>
Qty Legs:&nbsp;
<select name = "addlegqty" id = "addlegqty" onChange = "getStandardAddLegsPrice();">
<%
for i = 0 to 12
%>
<option value = "<%= i %>"
<%= selected(i, rs("addlegqty")) %>><%= i %></option>
<%
next
%>
</select>
</td>
<td>
Leg Finish:&nbsp;
<select name = "addlegfinish" id = "addlegfinish">
	<option value="<%=rs("addlegfinish")%>" selected><%=rs("addlegfinish")%></option>
</select>
</td>
<td></td><td></td><td></td>
</tr>
</table>

                                                    <p>Legs Special Instructions</p>
<%
	chcount=250-len(rs("specialinstructionslegs"))%>
                                                    <input name = "specialinstructionslegs" type = "text"
                                                        class = "indentleft"
                                                        value = "<%= rs("specialinstructionslegs") %>" size = "85"
                                                        maxlength = "255" class = "legs-field" onKeyUp="return taCount(this,'myCounter4')"><br />&nbsp;<B><SPAN id=myCounter4><%=chcount%></SPAN></B>/250
                                                    <%
                                                set legsDiscountObj = getDiscount(con, rs("purchase_no"), 7, rs("legprice") )
                                                set addLegsDiscountObj = getDiscount(con, rs("purchase_no"), 16, rs("addlegprice") )
                                                    %>

                                                    <span id = "legpricespan" class = "floatprice"></span>

                                                    <table width = "100%" border = "0" align = "center" cellpadding = "3" cellspacing="0" class="xview">
                                                        <!-- legs discount -->
                                                        <tr><td colspan="5"></td><td colspan="2" class="showWholesale" style="border-top:1px;border-left:1px;border-right:1px;border-style:solid; border-color:#333; border-bottom:none;" align="center"><b>Wholesale Pricing Unit Price</b></td></tr>
                                                        <tr>
                                                            <td width = "17%"><span class="legsdiscountcls">
                                                                List
                                                                Price: <%= getCurrencySymbolForCurrency(orderCurrency) %><span id = "standardlegspricespan"><%= legsDiscountObj.standardPrice %></span>

                                                                <input type = "hidden" name = "standardlegsprice"
                                                                    id = "standardlegsprice"
                                                                    value = "<%= legsDiscountObj.standardPrice %>"
                                                                    onchange = "setLegsPrice();" />
                                                            </span></td>

                                                            <td><span class="legsdiscountcls">
                                                                Discount: %

                                                                <input type = "radio" name = "legsdiscounttype"
                                                                    id = "legsdiscounttype1" value = "percent"
                                                                    <%= ischecked2(legsDiscountObj.discountType="percent") %>
                                                                    onchange = "setLegsPrice(); setEditPageLegsDiscountSummary();">
                                                                &nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %><input type = "radio"
                                                                    name = "legsdiscounttype"
                                                                    id = "legsdiscounttype2" value = "currency"
                                                                    <%= ischecked2(legsDiscountObj.discountType="currency") %>
                                                                    onchange = "setLegsPrice(); setEditPageLegsDiscountSummary();">
                                                                &nbsp;

                                                                <input name = "legsdiscount"
                                                                    value = "<%= legsDiscountObj.discount %>"
                                                                    type = "text" id = "legsdiscount" size = "10"
                                                                    onchange = "setLegsPrice(); setEditPageLegsDiscountSummary();">
                                                            </span></td>

                                                            <td colspan = "2">&nbsp;</td>

                                                            <td width = "30%" align="right">
                                                                Leg Price
                                                                <span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>

                                                                <label><input name = "legprice"
                                                                    value = "<%= rs("legprice") %>" type = "text"
                                                                    id = "legprice" size = "10" class = "legs-field"
                                                                    onchange = "setLegsDiscount();"></label>
                                                                    
                                                                     
                                                            </td>
                                                            <td class="showWholesale" align="right" style="border-top:0px;border-left:1px;border-right:0px;border-style:solid; border-color:#333; border-bottom:0px;">
                                                                   
                                                                <span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
                                                                <%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=7"
    															Set rs4 = getMysqlQueryRecordSet(sql, con)
																if not rs4.eof then
																
																Wlegsprice=rs4("price")
																end if
																rs4.close
																set rs4=nothing%>

                                                                Leg Price</td><td class="showWholesale" style="border-top:0px;border-left:0px;border-right:1px;border-style:solid; border-color:#333; border-bottom:0px;"> <input name = "Wlegsprice"  class="showWholesale" type = "text" id = "Wlegsprice" value = "<%=Wlegsprice%>" size = "10" />
                                                                     </td>
                                                        </tr>
                                                        <!-- add legs discount -->
                                                        <tr>
                                                            <td width = "17%"><span class="addlegsdiscountcls">
                                                                List
                                                                Price: <%= getCurrencySymbolForCurrency(orderCurrency) %><span id = "standardaddlegspricespan"><%= addLegsDiscountObj.standardPrice %></span>

                                                                <input type = "hidden" name = "standardaddlegsprice"
                                                                    id = "standardaddlegsprice"
                                                                    value = "<%= addLegsDiscountObj.standardPrice %>"
                                                                    onchange = "setAddLegsPrice();" />
                                                            </span></td>

                                                            <td><span class="addlegsdiscountcls">
                                                                Discount: %

                                                                <input type = "radio" name = "addlegsdiscounttype"
                                                                    id = "addlegsdiscounttype1" value = "percent"
                                                                    <%= ischecked2(addLegsDiscountObj.discountType="percent") %>
                                                                    onchange = "setAddLegsPrice(); setEditPageAddLegsDiscountSummary();">
                                                                &nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %><input type = "radio"
                                                                    name = "addlegsdiscounttype"
                                                                    id = "addlegsdiscounttype2" value = "currency"
                                                                    <%= ischecked2(addLegsDiscountObj.discountType="currency") %>
                                                                    onchange = "setAddLegsPrice(); setEditPageAddLegsDiscountSummary();">
                                                                &nbsp;

                                                                <input name = "addlegsdiscount"
                                                                    value = "<%= addLegsDiscountObj.discount %>"
                                                                    type = "text" id = "addlegsdiscount" size = "10"
                                                                    onchange = "setAddLegsPrice(); setEditPageAddLegsDiscountSummary();">
                                                            </span></td>

                                                            <td colspan = "2">&nbsp;</td>

                                                            <td width = "30%" align="right">
                                                                Support Leg Price
                                                                <span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>

                                                                <label><input name = "addlegprice"
                                                                    value = "<%= rs("addlegprice") %>" type = "text"
                                                                    id = "addlegprice" size = "10" class = "addlegs-field"
                                                                    onchange = "setAddLegsDiscount();"></label>
                                                            </td>
                                                            <td class="showWholesale" align="right" style="border-top:0px;border-left:1px;border-right:0px;border-style:solid; border-color:#333; border-bottom:0px;">
                                                                   
                                                                <span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
                                                                <%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=16"
    															Set rs4 = getMysqlQueryRecordSet(sql, con)
																if not rs4.eof then
																
																WSupportlegsprice=rs4("price")
																end if
																rs4.close
																set rs4=nothing%>

                                                                Support Leg Price</td><td class="showWholesale" style="border-top:0px;border-left:0px;border-right:1px;border-style:solid; border-color:#333; border-bottom:0px;"> <input name = "WSupportlegsprice" type = "text"
                                                                           id = "WSupportlegsprice"
                                                                           
                                                                    value = "<%=WSupportlegsprice%>" size = "10"
                                                                     />
                                                                     </td>
                                                        </tr>
                                                        <tr><td colspan="5">&nbsp;</td><td colspan="2" class="showWholesale" style="border-top:1px;border-left:0px;border-right:0px;border-style:solid; border-color:#333; border-bottom:0px;">&nbsp;</td></tr>
                                                    </table>
                                                </div>
                           <div class = "clear"></div>

                                                <!-- Headboard Start -->
                                                <p class = "purplebox"><span class = "radiobxmargin">Headboard
                                                Required</span>&nbsp;
                                                <%
                                            If rs("headboardrequired") = "n" Then
                                                %>

                                                Yes

                                                <label> <input type = "radio" name = "headboardrequired"
                                                            id = "headboardrequired_y" value = "y"
                                                    onClick = "javascript: headboardChanged(
                                                        false)"class = "headboard-field"></label>

                                                No

                                                <input name = "headboardrequired" type = "radio"
                                                    id = "headboardrequired_n" value = "n" checked
                                                    onClick = "javascript: headboardChanged(
                                                        false)"class = "headboard-field">
                                                <%
                                            Else
                                                %>

                                                Yes

                                                <label> <input type = "radio" name = "headboardrequired"
                                                            id = "headboardrequired_y" value = "y" checked
                                                    onClick = "javascript: headboardChanged(
                                                        false)"class = "headboard-field"></label>

                                                No

                                                <input name = "headboardrequired" type = "radio"
                                                    id = "headboardrequired_n" value = "n"
                                                    onClick = "javascript: headboardChanged(
                                                        false)"class = "headboard-field"> <%
                                            End If
                                                %>
                                                <%
                                            If splitshipment = "y" then
                                                Set rs5 = getMysqlUpdateRecordSet("Select * from exportlinks L, exportcollections C, exportCollShowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and purchase_no=" & order & " and S.exportCollectionID=C.exportcollectionsID AND L.componentID=8", con)
                                                if not rs5.eof then
                                                    response.Write("<span  class=""justifyright""><font color=""red"">Shipment date: " & rs5("CollectionDate") & "&nbsp;&nbsp; </font></span>")
                                                end if
                                                rs5.close
                                                set rs5 = nothing
                                            end if
                                                %></p>

                                                <div id = "headboard_div">
                                                    <table width = "98%" border = "0" align = "center" cellpadding = "3"
                                                        cellspacing = "3">
                                                        <tr>
                                                            <td>
                                                                Headboard Style:
                                                            </td>

                                                            <td>
                                                                <select name="headboardstyle" id="headboardstyle" tabindex="80" class="headboard-field" onchange="getStandardHeadboardPrice(); getStandardHeadboardTrimPrice(); resetPriceField('headboardtrimprice',10); showHideHeadboardPriceSummaryRow(10);" >
<!-- #include file="retired-headboard-names.asp" -->
            
		 		<%=makeSortedOptionString("headboardstyle", rs("headboardstyle"), true, con)%>
		 	</select>
                                                            </td>
                                                            <td> Headboard Height: </td>
                                                            <td><select name = "headboardheight" id = "headboardheight"
                                                                    tabindex = "81" class = "headboard-field">
                                                              <%if trim(rs("headboardheight"))="62cm Above Mattress/ Topper" then%>
                                                              <option value="62cm Above Mattress/ Topper" selected>62cm Above Mattress/ Topper</option>
                                                              <%end if%>
                                                              <%= makeOptionString("headboardheight", rs("headboardheight"), true, con) %>
                                                            </select></td>
                                                            <td> Headboard Finish </td>
                                                            <td><select name = "headboardfinish" id = "headboardfinish"
                                                                    tabindex = "82" class = "headboard-field">
                                                              <%
                                                                Set rs3 = getMysqlUpdateRecordSet("Select * from headboardfinish", con)
                                                                    %>
                                                              <%
                                                                Do until rs3.eof
                                                                    %>
                                                              <option value = "<%= rs3("hbfinish") %>"
                                                                        <%= selected(rs3("hbfinish"), rs("headboardfinish")) %>><%= rs3("hbfinish") %></option>
                                                              <%
                                                                rs3.movenext
                                                                loop
                                                                    rs3.close
                                                                    set rs3 = nothing
                                                                    %>
                                                            </select></td>
                                                        </tr>

                                                        <tr>
                                                          <td> Supporting Legs:&nbsp; </td>
                                                          <td><select name = "hblegs" id = "hblegs"
                                                                    class = "headboard-field">
                                                            <%
                                                                for i = 0 to 10
                                                                    %>
                                                            <option value = "<%= i %>"
                                                                        <%= selected(i, rs("headboardlegqty")) %>><%= i %></option>
                                                            <%
                                                                next
                                                                    %>
                                                          </select>
  &nbsp; </td>
                                                          <td><div id = "manhattantrimdiv1"> Wooden Headboard Trim </div>
                                                            <div id = "footboardheightdiv1"> Footboard Height </div>
  &nbsp; </td>
                                                          <td><div id = "manhattantrimdiv2">
                                                            <select name = "manhattantrim" id = "manhattantrim"
                                                                        tabindex = "83" class = "headboard-field"
                                                                        onchange = "getStandardHeadboardTrimPrice(); resetPriceField('headboardtrimprice',10); showHideHeadboardPriceSummaryRow(10); manhattanTrim();" >
                                                              <%= makeOptionString("manhattantrim", rs("manhattantrim"), true, con) %>
                                                            </select>
                                                          </div>
                                                            <div id = "footboardheightdiv2">
                                                              <select name = "footboardheight" id = "footboardheight"
                                                                        tabindex = "83" class = "headboard-field">
                                                                <%= makeOptionString("footboardheight", rs("footboardheight"), true, con) %>
                                                              </select>
                                                            </div>
  &nbsp; </td>
                                                          <td><div id = "footboardfinishdiv1"> Footboard Finish </div></td>
                                                          <td><div id = "footboardfinishdiv2">
                                                            <select name = "footboardfinish" id = "footboardfinish"
                                                                        tabindex = "83" class = "headboard-field">
                                                              <%= makeOptionString("footboardfinish", rs("footboardfinish"), true, con) %>
                                                            </select>
                                                          </div></td>
                                                        </tr>
                                                        <tr>
                                                          <td> Fabric Options: </td>
                                                          <td><select name = "hbfabricoptions" id = "hbfabricoptions"
                                                                    tabindex = "45" class = "headboard-field">
                                                            <option value = "TBC"
                                                                        <%= selected(rs("hbfabricoptions"), "TBC") %>>TBC</option>
                                                            <option value = "Savoir Supply"
                                                                        <%= selected(rs("hbfabricoptions"), "Savoir Supply") %>>Savoir Supply</option>
                                                            <option value = "Customer Own Material"
                                                                        <%= selected(rs("hbfabricoptions"), "Customer Own Material") %>>Customer Own Material</option>
                                                          </select></td>
                                                          <td> Fabric Company: </td>
                                                          <td><input name = "headboardfabric"value="<%= rs("headboardfabric") %>"
                                                                    type = "text" id = "headboardfabric" size = "25"
                                                                    maxlength = "50" class = "headboard-field"></td>
                                                          <td> Fabric Direction </td>
                                                          <td><select name = "headboardfabricdirection"
                                                                    id = "headboardfabricdirection"
                                                                    class = "headboard-field">
                                                            <%
                                                                    If rs("headboardfabricdirection") <> "" Then
                                                                    %>
                                                            <option value = "<%= rs("headboardfabricdirection") %>"
                                                                            selected><%= rs("headboardfabricdirection") %></option>
                                                            <%
                                                                    End If
                                                                    %>
                                                            <option value = "TBC">TBC</option>
                                                            <option value = "Fabric on the run">Fabric on the
                                                              run</option>
                                                            <option value = "Fabric on the drop">Fabric on the
                                                              drop</option>
                                                          </select>
  &nbsp; </td>
                                                        </tr>
                                                        <tr>
                                                          <td> Fabric Description (Design, Colour &amp; Code): </td>
                                                          <td colspan="5"><input name = "headboardfabricchoice"value="<%= rs("headboardfabricchoice") %>"
                                                                    type = "text" id = "headboardfabricchoice"
                                                                    size = "100%" maxlength = "100"
                                                                    class = "headboard-field"></td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Price Per Metre&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %>
                                                            </td>

                                                            <td>
                                                                <input name = "hbfabriccost"
                                                                    value = "<%= rs("hbfabriccost") %>"
                                                                    type = "text" id = "hbfabriccost" size = "15"
                                                                    class = "headboard-field xview">
                                                            </td>

                                                            <td>
                                                                Fabric Quantity
                                                            </td>

                                                            <td>
                                                                <input name = "hbfabricmeters"
                                                                    value = "<%= rs("hbfabricmeters") %>"
                                                                    type = "text" id = "hbfabricmeters" size = "15"
                                                                    class = "headboard-field">
                                                            </td>

                                                        </tr>
                                                    </table>
                                                                <%
                                                            if rs("headboardwidth") <> "n" then
                                                                %>

                                                                    <div id = "headboardwidth2">
                                                                        <table class = "hbmarginleft">
                                                                            <tr>
                                                                                <td>
                                                                                    Headboard Width
                                                                                </td>

                                                                                <td>
                                                                                    <select name = "headboardwidth"
                                                                                        id = "headboardwidth" class = "headboard-field"
                                                                                        tabindex = "52">
                                                                                        <option value = "<%= rs("headboardwidth") %>"
                                                                                            selected><%= rs("headboardwidth") %></option>

                                                                                        <option value = "n"
                                                                                            <%= selected("n", request("headboardwidth")) %>>--</option>

                                                                                        <option value = "TBC"
                                                                                            <%= selected("TBC", request("headboardwidth")) %>>TBC</option>

                                                                                        <option value = "90cm"
                                                                                            <%= selected("90cm", request("headboardwidth")) %>>90cm</option>

                                                                                        <option value = "140cm"
                                                                                            <%= selected("140cm", request("headboardwidth")) %>>140cm</option>

                                                                                        <option value = "150cm"
                                                                                            <%= selected("150cm", request("headboardwidth")) %>>150cm</option>

                                                                                        <option value = "152.5cm"
                                                                                            <%= selected("152.5cm", request("headboardwidth")) %>>152.5cm</option>

                                                                                        <option value = "180cm"
                                                                                            <%= selected("180cm", request("headboardwidth")) %>>180cm</option>
                                                                                        <%
                                                                                        if retrieveUserRegion() = 4 or retrieveUserLocation() = 1 or retrieveUserLocation() = 27 or retrieveUserLocation() = 23 then
                                                                                        %>

                                                                                            <option value = "183cm"
                                                                                                <%= selected("183cm", request("headboardwidth")) %>>183cm</option>
                                                                                            <%
                                                                                            end if
                                                                                            %>

                                                                                            <option value = "193cm"
                                                                                                <%= selected("193cm", request("headboardwidth")) %>>193cm</option>

                                                                                            <option value = "200cm"
                                                                                                <%= selected("200cm", request("headboardwidth")) %>>200cm</option>

                                                                                            <option value = "210cm"
                                                                                                <%= selected("210cm", request("headboardwidth")) %>>210cm</option>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
                                                                <%
                                                            end if
                                                                %>

                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                  <tr>
                                                                    <td><p>Fabric Special Instructions</p>
                                                                    <%
	chcount=250-len(rs("headboardfabricdesc"))%>
                                                                <input name = "headboardfabricdesc"
                                                                    id = "headboardfabricdesc" type = "text"
                                                                    class = "indentleft"
                                                                    value = "<%= rs("headboardfabricdesc") %>"
                                                                    size = "100%" maxlength = "355"
                                                                    class = "headboard-field"  onKeyUp="return taCount(this,'myCounter5')" /><br />&nbsp;<B><SPAN id=myCounter5><%=chcount%></SPAN></B>/250
                                         <div class = "clear"></div><br />
                                         <p>Headboard Special Instructions:</p><%
	chcount=250-len(rs("specialinstructionsheadboard"))%>
                                                                <textarea name = "specialinstructions3" cols = "80"
                                                                    class = "indentleft" id = "specialinstructions3"
                                                                    class = "headboard-field"
                                                             
                                                                    tabindex = "86" onKeyUp="return taCount(this,'myCounter6')"><%=rs("specialinstructionsheadboard")%></textarea><br />&nbsp;<B><SPAN id=myCounter6><%=chcount%></SPAN></B>/250&nbsp;</td>
                                                                   
                                                                  </tr>
                                                                  
                                                                </table>

                                                               <div id="tick5"><img src = "img/virginia.gif" alt = "Virginia" width = "115" height = "119" hspace = "30" align = "right"></div>
                    <div id = "tick6">
                        <img src = "img/savoy.gif" alt = "Savoy" width = "115" height = "119" hspace = "30"
                            align = "right">
                    </div>
                    <div id = "tick7">
                        <img src = "img/penelope.gif" alt = "Penelope" width = "115" height = "119" hspace = "30"
                            align = "right">
                    </div>
                    <div id = "tick8">
                        <img src = "img/nicky.gif" alt = "Nicky" width = "115" height = "119" hspace = "30"
                            align = "right">
                    </div>
                    <div id = "tick9">
                        <img src = "img/mary.gif" alt = "Mary" width = "115" height = "119" hspace = "30"
                            align = "right">
                    </div>
                    <div id = "tick10">
                        <img src = "img/ian.gif" alt = "Ian" width = "115" height = "119" hspace = "30"
                            align = "right">
                    </div>
                    <div id = "tick11">
                        <img src = "img/hatti.gif" alt = "Hatti" width = "115" height = "119" hspace = "30"
                            align = "right">
                    </div>
                    <div id = "tick12">
                        <img src = "img/holly.gif" alt = "Holly" width = "77" height = "119" hspace = "30"
                            align = "right">
                    </div>

                    <div id = "tick13">
                        <img src = "img/f100.gif" alt = "F100" width = "77" height = "119" hspace = "30"
                            align = "right">
                    </div>

                    <div id = "tick14">
                        <img src = "img/MF31.gif" alt = "Alex (M31)" width = "115" height = "119" hspace = "30"
                            align = "right">
                    </div>

                    <div id = "tick15">
                        <img src = "img/MF32.gif" alt = "Elizabeth (M32)" width = "112" height = "119" hspace = "30"
                            align = "right">
                    </div>

                    <div id = "tick16">
                        <img src = "img/Animal.gif" alt = "Animal" width = "91" height = "119" hspace = "30"
                            align = "right">
                    </div>
                    <div id = "tick17">
                        <img src = "img/leo.gif" alt = "Leo (CF5)" width = "115" height = "119" hspace = "30"
                            align = "right">
                    </div>
                    <div id = "tick18">
                        <img src = "img/lotti.gif" alt = "Lotti (CF4)" width = "115" height = "119" hspace = "30"
                            align = "right">
                    </div>
                    <div id = "tick19">
                        <img src = "img/harlech.gif" alt = "Harlech (CF2)" width = "115" height = "119" hspace = "30"
                            align = "right">
                    </div>
                    <div id = "tick20">
                        <img src = "img/felix.gif" alt = "Felix (TF30)" width = "115" height = "119" hspace = "30"
                            align = "right">
                    </div>
                    <div id = "tick21">
                        <img src = "img/claudia.gif" alt = "Claudia" width = "115" height = "119" hspace = "30"
                            align = "right">
                    </div>
					<div id = "tick22">
                        <img src = "img/gorrivan.gif" alt = "Gorrivan" width = "122" height = "119" hspace = "30"
                            align = "right">
                    </div>
					
<%
set headboardDiscountObj = getDiscount(con, rs("purchase_no"), 8, rs("headboardprice") )
set headboardTrimDiscountObj = getDiscount(con, rs("purchase_no"), 10, rs("headboardtrimprice") )
%>
<div class = "clear"></div>
<!-- headboard prices summary table -->
<!-- #include file="headboard-price-summary.asp" -->
                    </div>
                            <div class = "clear"></div>
                                                <!-- Headboard End -->

                                                <p class = "purplebox"><span class = "radiobxmargin">Valance
                                                Required</span>&nbsp;
                                                <%
                                            If rs("valancerequired") = "n" Then
                                                %>

                                                Yes

                                                <label>
                                                <input type = "radio" name = "valancerequired" id = "valancerequired_y"
                                                    value = "y" onClick = "javascript: valanceChanged()"
                                                    class = "valance-field"></label>

                                                No

                                                <input name = "valancerequired" type = "radio" id = "valancerequired_n"
                                                    value = "n" checked onClick = "javascript: valanceChanged()"
                                                    class = "valance-field">
                                                <%
                                            Else
                                                %>

                                                Yes

                                                <label>
                                                <input type = "radio" name = "valancerequired" id = "valancerequired_y"
                                                    value = "y" checked onClick = "javascript: valanceChanged()"
                                                    class = "valance-field"></label>

                                                No

                                                <input name = "valancerequired" type = "radio" id = "valancerequired_n"
                                                    value = "n" onClick = "javascript: valanceChanged()"
                                                    class = "valance-field"> <%
                                            End If
                                                %>
                                                <%
                                            If splitshipment = "y" then
                                                Set rs5 = getMysqlUpdateRecordSet("Select * from exportlinks L, exportcollections C, exportCollShowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and purchase_no=" & order & " and S.exportCollectionID=C.exportcollectionsID AND L.componentID=6", con)
                                                if not rs5.eof then
                                                    response.Write("<span  class=""justifyright""><font color=""red"">Shipment date: " & rs5("CollectionDate") & "&nbsp;&nbsp; </font></span>")
                                                end if
                                                rs5.close
                                                set rs5 = nothing
                                            end if
                                                %></p>

                                                <div id = "valance_div">
                                                    <table width = "98%" border = "0" align = "center" cellpadding = "3"
                                                        cellspacing = "3">
                                                        <tr>
                                                            <td width = "11%">
                                                                No. of Pleats:
                                                            </td>

                                                            <td width = "12%">
                                                                <select name = "pleats" id = "pleats" tabindex = "90"
                                                                    class = "valance-field">
                                                                    <%
                                                                If rs("pleats") <> "" Then
                                                                    %>

                                                                        <option value = "<%= rs("pleats") %>"
                                                                            selected><%= rs("pleats") %></option>
                                                                    <%
                                                                End If
                                                                    %>

                                                                    <option value = "--">--</option>

                                                                    <option value = "TBC">TBC</option>

                                                                    <option value = "0">0</option>

                                                                    <option value = "2">2</option>

                                                                    <option value = "4">4</option>

                                                                    <option value = "5">5</option>
                                                                </select>
                                                            </td>

                                                            <td width = "11%">
                                                                Fabric Company:
                                                            </td>

                                                            <td width = "21%">
                                                                <input name = "valancefabric"value="<%= rs("valancefabric") %>"
                                                                    type = "text" id = "valancefabric" size = "25"
                                                                    maxlength = "50" class = "valance-field">
                                                            </td>

                                                            <td width = "12%">
                                                                Fabric Design, Colour & Code:
                                                            </td>

                                                            <td width = "33%">
                                                                <input name = "valancefabricchoice"value="<%= rs("valancefabricchoice") %>"
                                                                    type = "text" id = "valancefabricchoice"
                                                                    size = "38" maxlength = "100"
                                                                    class = "valance-field">
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Fabric Options:
                                                            </td>

                                                            <td>
                                                                <select name = "valancefabricoptions"
                                                                    id = "valancefabricoptions" tabindex = "45"
                                                                    class = "valance-field">
                                                                    <option value = "Savoir Supply"
                                                                        <%= selected(rs("valancefabricoptions"), "Savoir Supply") %>>Savoir Supply</option>

                                                                    <option value = "Customer Own Material"
                                                                        <%= selected(rs("valancefabricoptions"), "Customer Own Material") %>>Customer Own Material</option>
                                                                </select>
                                                            </td>

                                                            <td>
                                                                Valance Fabric Direction
                                                            </td>

                                                            <td>
                                                                <select name = "valancefabricdirection"
                                                                    id = "valancefabricdirection"
                                                                    class = "valance-field">
                                                                    <%
                                                                If rs("valancefabricdirection") <> "" Then
                                                                    %>

                                                                        <option value = "<%= rs("valancefabricdirection") %>"
                                                                            selected><%= rs("valancefabricdirection") %></option>
                                                                    <%
                                                                End If
                                                                    %>

                                                                    <option value = "n">--</option>

                                                                    <option value = "Fabric on the run">Fabric on the
                                                                    run</option>

                                                                    <option value = "Fabric on the drop">Fabric on the
                                                                    drop</option>
                                                                </select>

                                                                &nbsp;
                                                            </td>

                                                            <td>&nbsp;
                                                                
                                                            </td>

                                                            <td>&nbsp;
                                                                
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Valance Fabric Cost per metre
                                                            </td>

                                                            <td>
                                                                <input name = "valfabriccost"
                                                                    value = "<%= rs("valfabriccost") %>"
                                                                    type = "text" id = "valfabriccost" size = "15"
                                                                    class = "valance-field xview">
                                                            </td>

                                                            <td>
                                                                Metres of Fabric
                                                            </td>

                                                            <td>
                                                                <input name = "valfabricmeters"
                                                                    value = "<%= rs("valfabricmeters") %>"
                                                                    type = "text" id = "valfabricmeters" size = "15"
                                                                    class = "valance-field">
                                                            </td>

                                                            <td>
                                                                Valance Fabric Price
                                                            </td>

                                                            <td>
                                                                <input name = "valfabricprice"
                                                                    value = "<%= rs("valfabricprice") %>"
                                                                    type = "text" id = "valfabricprice" size = "15"
                                                                    class = "valance-field xview">
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Valance Drop
                                                            </td>

                                                            <td>
                                                                <input name = "valancedrop"
                                                                    value = "<%= rs("valancedrop") %>" type = "text"
                                                                    id = "valancedrop" size = "15"
                                                                    class = "valance-field">
                                                            </td>

                                                            <td>
                                                                Valance Width
                                                            </td>

                                                            <td>
                                                                <input name = "valancewidth"
                                                                    value = "<%= rs("valancewidth") %>"
                                                                    type = "text" id = "valancewidth" size = "15"
                                                                    class = "valance-field">
                                                            </td>

                                                            <td>
                                                                Valance Length
                                                            </td>

                                                            <td>
                                                                <input name = "valancelength"
                                                                    value = "<%= rs("valancelength") %>"
                                                                    type = "text" id = "valancelength" size = "15"
                                                                    class = "valance-field">
                                                            </td>
                                                        </tr>
                                                    </table>

                             <div class = "clear"></div>

                                                    <p>Valance Special Instructions:</p>
<%
	chcount=250-len(rs("specialinstructionsvalance"))%>
                                                    <textarea name = "specialinstructions4" cols = "65"
                                                        class = "indentleft" id = "specialinstructions4"
                                                        tabindex = "95"
                                                        class = "valance-field" onKeyUp="return taCount(this,'myCounter7')"><%=rs("specialinstructionsvalance")%></textarea><br />&nbsp;<B><SPAN id=myCounter7><%=chcount%></SPAN></B>/250

                                                    <span class = "floatprice">
                                                    Valance <%= getCurrencySymbolForCurrency(orderCurrency) %>

                                                    <label>
                                                    <input name = "valanceprice" type = "text" id = "valanceprice"
                                                        value = "<%= rs("valanceprice") %>" size = "15"
                                                        class = "valance-field xview"></label>
 <div class="showWholesale">
<table width="30%" border="0" align="right" cellpadding="3" cellspacing="3" class="xview bordergris" style="float:right">
<tr><td colspan="2"><b>Wholesale Pricing</b></td></tr><tr><td>Wholesale Valance</td><td>
                                                                <span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
                                                                <%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=6"
    															Set rs4 = getMysqlQueryRecordSet(sql, con)
																if not rs4.eof then
																
																Wvalanceprice=rs4("price")
															
																end if
																rs4.close
																set rs4=nothing%>

                                                                <input name = "Wvalanceprice" type = "text"
                                                                           id = "Wvalanceprice"
                                                                           
                                                                    value = "<%=Wvalanceprice%>" size = "10"
                                                                     /></td></tr>
                                                                <tr><td>Fabric Price Per Metre</td><td>
                                                                <span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>
                                                                <%sql = "Select * from wholesale_prices WHERE Purchase_No=" & order & " and componentID=18"
    															Set rs4 = getMysqlQueryRecordSet(sql, con)
																if not rs4.eof then
																
																Wvalancefabprice=rs4("price")
															
																end if
																rs4.close
																set rs4=nothing%>

                                                                <input name = "Wvalancefabprice" type = "text"
                                                                           id = "Wvalancefabprice"
                                                                           
                                                                    value = "<%=Wvalancefabprice%>" size = "10"
                                                                     /></td></tr></table>
                                                                 
                                                    </div>
                                                    </span>
                                                </div>
                           <div class = "clear"></div>

                                                <!-- accessories section -->
                                                <p class = "purplebox"><span class = "radiobxmargin">Accessories
                                                Required</span>&nbsp;

                                                Yes

                                                <label> <input type = "radio" name = "accessoriesrequired"
                                                            id = "accessoriesrequired_y" value = "y"
                                                    <%= ischeckedY(rs("accessoriesrequired")) %>
                                                    onClick = "javascript: accessoriesChanged()"
                                                    class = "accessories-field"></label>

                                                No

                                                <input name = "accessoriesrequired" type = "radio"
                                                    id = "accessoriesrequired_n" value = "n"
                                                    <%= ischeckedN(rs("accessoriesrequired")) %>
                                                    onClick = "javascript: accessoriesChanged()"
                                                    class = "accessories-field"> <%
                                            If splitshipment = "y" then
                                                Set rs5 = getMysqlUpdateRecordSet("Select * from exportlinks L, exportcollections C, exportCollShowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and purchase_no=" & order & " and S.exportCollectionID=C.exportcollectionsID AND L.componentID=9", con)
                                                if not rs5.eof then
                                                    response.Write("<span  class=""justifyright""><font color=""red"">Shipment date: " & rs5("CollectionDate") & "&nbsp;&nbsp; </font></span>")
                                                end if
                                                rs5.close
                                                set rs5 = nothing
                                            end if
                                                %></p>
                                                <%
                                            Set rs3 = getMysqlQueryRecordSet("Select F.fabricstatus from qc_history Q, fabricstatus F where F.fabricstatusId=Q.fabricstatus AND Q.componentid=9 AND Q.purchase_no = " & order & " order by Q.QC_date desc", con)
                                            if not rs3.eof then
                                                faborderstatus = rs3("fabricstatus")
                                            end if
                                                rs3.close
                                                set rs3 = nothing
                                                Set rs3 = getMysqlUpdateRecordSet("select * from orderaccessory where purchase_no=" & order & " order by orderaccessory_id", con)
                                                %>

                                                <div id = "accessories_div">
                                                    <table align = "center" border="0" cellspacing="0" cellpadding="2">
                                                        <tr>
                                                            <th>
                                                                Item<br />No.
                                                            </th>

                                                            <th>
                                                                Item&nbsp;Description
                                                            </th>

                                                            <th>
                                                                Design &amp; Detail
                                                            </th>

                                                            <th>
                                                                Colour
                                                            </th>

                                                            <th>
                                                                Size
                                                            </th>

                                                            <th class="xview">
                                                                Unit&nbsp;Price
                                                            </th>

                                                            <th>
                                                                Quantity
                                                            </th>

                                                            <th>
                                                                Status
                                                            </th>

                                                            <th>
                                                                Delete
                                                            </th>

                                                            <th>&nbsp;
                                                                
                                                            </th>
                                                            <th class="showWholesale" style="border-top:1px;border-left:1px;border-right:1px;border-style:solid; border-color:#333; border-bottom:none;">Wholesale Pricing<br />Unit Price
                                                                
                                                            </th>
                                                        </tr>
                                                        <%
                                                    for i = 1 to 20
                                                        acc_desc = ""

                                                        acc_design = ""

                                                        acc_colour = ""

                                                        acc_size = ""

                                                        acc_unitprice = ""
														acc_wholesalePrice = ""

                                                        acc_qty = ""

                                                        acc_id = ""
														acc_ponumber=""
														acc_status=""
														acc_received=""
														acc_checked=""
														acc_delivered=""
														acc_qtyfollow=""
                                                        if not rs3.eof then
                                                            acc_desc = rs3("description")
                                                            acc_design = rs3("design")
                                                            acc_colour = rs3("colour")
                                                            acc_size = rs3("size")
                                                            acc_unitprice = rs3("unitprice")
															acc_wholesalePrice= rs3("wholesalePrice")
                                                            acc_qty = rs3("qty")
                                                            acc_id = rs3("orderaccessory_id")
															acc_ponumber=rs3("ponumber")
															acc_received=rs3("received")
															acc_checked=rs3("checked")
															acc_qtyfollow=rs3("qtytofollow")
															acc_delivered=rs3("delivered")
															if rs3("description")<>"" then acc_status=100
															if acc_ponumber<>"" then acc_status=10
															if acc_received<>"" then acc_status=110
															if acc_checked<>"" then acc_status=120
															if acc_delivered>0 then acc_status=70
															if acc_qtyfollow>0 then acc_status=130
                                                            rs3.movenext
                                                        end if
														if acc_ponumber<>"" then 
														accreadonly=" readonly" 
														accdisabled="disabled"
														else 
														accreadonly=""
														accdisabled=""
														end if
														'response.Write(acc_ponumber)
                                                        %>

                                                                <tr id = "acc_row<%= i %>">
                                                                  <td valign="top"><%= i %></td>
                                                                  <td valign="top"><input type = "text" name = "acc_desc<%= i %>"
                                                                            id = "acc_desc<%= i %>"
                                                                            value = "<%= safeHtmlEncode(acc_desc) %>"
                                                                            size = "20" maxlength = "50"
                                                                            class = "accessories-field<%=accreadonly%>" <%=accreadonly%> /></td>
                                                                  <td valign="top"><input type = "text" name = "acc_design<%= i %>"
                                                                            id = "acc_design<%= i %>"
                                                                            value = "<%= safeHtmlEncode(acc_design) %>"
                                                                            size = "20" maxlength = "50"
                                                                            class = "accessories-field<%=accreadonly%>" <%=accreadonly%> /></td>
                                                                  <td valign="top"><input type = "text" name = "acc_colour<%= i %>"
                                                                            id = "acc_colour<%= i %>"
                                                                            value = "<%= safeHtmlEncode(acc_colour) %>"
                                                                            size = "20" maxlength = "50"
                                                                            class = "accessories-field<%=accreadonly%>" <%=accreadonly%> /></td>
                                                                  <td valign="top"><input type = "text" name = "acc_size<%= i %>"
                                                                            id = "acc_size<%= i %>"
                                                                            value = "<%= safeHtmlEncode(acc_size) %>"
                                                                            size = "20" maxlength = "50"
                                                                            class = "accessories-field<%=accreadonly%>" <%=accreadonly%> /></td>
                                                                  <td valign="top" class="xview"><input type = "text"
                                                                            name = "acc_unitprice<%= i %>"
                                                                            id = "acc_unitprice<%= i %>"
                                                                            value = "<%= fmtCurr2(acc_unitprice, false, orderCurrency) %>"
                                                                            size = "10" class = "accessories-field" /></td>
                                                                  <td valign="top"><select name = "acc_qty<%= i %>"
                                                                            id = "acc_qty<%= i %>"
                                                                            class = "accessories-field<%=accreadonly%>" <%=accdisabled%>>
                                                                    <%
                                                                        for n = 1 to 50
                                                                            %>
                                                                    <option value = "<%= n %>"
                                                                                <%= selected(cstr(n), acc_qty) %>><%= n %></option>
                                                                    <%
                                                                        next
                                                                            %>
                                                                        </select>
                                                                    </td>

                                                                    <td>
                                                                        <%= faborderstatus %>&nbsp;
                                                                    </td>

                                                                    <td>
                                                                        <input type = "checkbox"
                                                                            name = "acc_delete<%= i %>"
                                                                            id = "acc_delete<%= i %>"
                                                                            class = "accessories-field<%=accreadonly%>" <%=accdisabled%> /></td>
                                                                  <td valign="top"><input type = "hidden" name = "acc_id<%= i %>"
                                                                            id = "acc_id<%= i %>"
                                                                            value = "<%= acc_id %>"
                                                                            class = "accessories-field" />
                                                                    </td>
                                                                    <td class="showWholesale" style="border-top:0px; border-bottom:0px; border-left:1px; border-right:1px; border-style:solid; border-color:#333; ">
                                                                <input type = "text"
                                                                            name = "acc_wholesalePrice<%= i %>"
                                                                            id = "acc_wholesalePrice<%= i %>"
                                                                            value = "<%= fmtCurr2(acc_wholesalePrice, false, orderCurrency) %>"
                                                                            size = "10" class = "accessories-field" />
                                                                     </td>

                                                                </tr>
                                                        <%
                                                    next
                                                        rs3.close
                                                        set rs3 = nothing
                                                        %>
                                                        
                                                        <tr><td colspan="10">Accessories
                                                    total:&nbsp;<span id = "accessories_total"></span>

                                                    <input type = "hidden" name = "accessoriestotalcost"
                                                        id = "accessoriestotalcost"
                                                        value = "<%= fmtCurr2(rs("accessoriestotalcost"), false, orderCurrency) %>"></td><td class="showWholesale" style="border-bottom:1px;border-left:1px;border-right:1px;border-style:solid; border-color:#333; border-top:none;">&nbsp;</td></tr>
                                                    </table>

                                                    
                                                </div>
                           <div class = "clear"></div>

                                                <p class = "purplebox"><span class = "radiobxmargin">Delivery
                                                Instructions</span>&nbsp;
                                                <%
                                                If rs("deliverycharge") = "n" Then
                                                %>

                                                    Yes

                                                    <label>
                                                    <input type = "radio" name = "deliverycharge" id = "deliverycharge"
                                                        value = "y" onClick = "javascript: deliveryChanged()"></label>

                                                    No

                                                    <input name = "deliverycharge" type = "radio" id = "deliverycharge"
                                                        value = "n" checked onClick = "javascript: deliveryChanged()">
                                                <%
                                                Else
                                                %>

                                                    Yes

                                                    <label>
                                                    <input type = "radio" name = "deliverycharge" id = "deliverycharge"
                                                        value = "y" checked
                                                        onClick = "javascript: deliveryChanged()"></label>

                                                    No

                                                    <input name = "deliverycharge" type = "radio" id = "deliverycharge"
                                                        value = "n" onClick = "javascript: deliveryChanged()">
                                                <%
                                                End If
                                                %>

                                                </p>

                                                <div id = "delivery_div">
                                                    <table width = "98%" border = "0" align = "center" cellpadding = "3"
                                                        cellspacing = "3">
                                                        <tr>
                                                            <td width = "17%">
                                                                Access Check Required?
                                                            </td>

                                                            <td width = "38%">
                                                                <select name = "accesscheck" id = "accesscheck"
                                                                    tabindex = "90">
                                                                    <%
                                                                If rs("accesscheck") <> "" Then
                                                                    %>

                                                                        <option value = "<%= rs("accesscheck") %>"
                                                                            selected><%= rs("accesscheck") %></option>
                                                                    <%
                                                                End If
                                                                    %>

                                                                    <option value = "No">No</option>

                                                                    <option value = "Yes">Yes</option>
                                                                </select>

                                                                &nbsp;
                                                            </td>

                                                            <td width = "14%">
                                                                Disposal of old bed
                                                            </td>

                                                            <td>
                                                                <select name = "oldbed" id = "oldbed" tabindex = "90">
                                                                    <%
                                                                If rs("oldbed") <> "" Then
                                                                    %>

                                                                        <option value = "<%= rs("oldbed") %>"
                                                                            selected><%= rs("oldbed") %></option>
                                                                    <%
                                                                End If
                                                                    %>

                                                                    <option value = "--">--</option>

                                                                    <option value = "No">No</option>

                                                                    <option value = "Yes">Yes</option>
                                                                </select>
                                                            </td>
                                                        </tr>
                                                    </table>

                                                    <p>Delivery Special Instructions:</p>

                                                    <input name = "specialinstructionsdelivery" type = "text"
                                                        class = "indentleft" id = "specialinstructionsdelivery"
                                                        tabindex = "95"
                                                        value = "<%= rs("specialinstructionsdelivery") %>"
                                                        size = "65" maxlength = "255">
                                                    <span class = "floatprice">
                                                    Delivery <%= getCurrencySymbolForCurrency(orderCurrency) %>

                                                    <label>
                                                    <input name = "deliveryprice" type = "text" id = "deliveryprice"
                                                        value = "<%= rs("deliveryprice") %>" class="xview" size = "15"></label>

                                                    <br /><button type = "button"
                                                         class="xview" onClick = "JavaScript:setDefaultDeliveryCharge()">Get
                                                    Standard Delivery Price</button> </span>
                                                </div>
                           <div class = "clear"></div>

                                                <hr>
                                                <table width = "700" border = "0" align = "center" cellpadding = "2"
                                                    cellspacing = "2">
                                                    <tr>
                                                        <td colspan = "2">
                                                            <h1 align = "center"> <%
                                                        If quote = "y" then
                                                            %>

                                                                Quote Summary - Quote No. <%= orderno %></h1>
                                                            <%
                                                        Else
                                                            %>

                                                            Order Summary - Order No. <%= orderno %></h1>
                                                            <%
                                                        End If
                                                            %>
                                                        </td>
                                                    </tr>

                                                    <tr>
                                                        <td width = "120">
                                                            <b>Item</b>
                                                        </td>

                                                        <td width = "140" class="xview">
                                                            <b>Price</b>
                                                        </td>

                                                        <td width = "80" class="xview">
                                                            <b>List Price</b>
                                                        </td>

                                                        <td width = "80" class="xview">
                                                            <b>Discount Amount</b>
                                                        </td>
                                                    </tr>
                                                    <%
                                                if rs("mattressrequired") = "y" then
                                                    %>

                                                        <tr>
                                                            <td>
                                                                Mattress
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "mattressprice2span"><%= fmtCurr2(rs("mattressprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "mattressprice2"
                                                                    id = "mattressprice2"
                                                                    value = "<%= fmtCurr2(rs("mattressprice"), false, orderCurrency) %>" />
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "standardmattresspricespan2"><%= fmtCurr2(mattressDiscountObj.standardPrice, false, orderCurrency) %></span>
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "mattressdiscountamtspan"><%= fmtCurr2(negToZero(mattressDiscountObj.standardPrice - mattressDiscountObj.price), false, orderCurrency) %></span>
                                                            </td>
                                                        </tr>
                                                    <%
                                                end if
                                                    %>
                                                    <%
                                                if rs("topperrequired") = "y" then
                                                    %>

                                                        <tr>
                                                            <td>
                                                                Topper
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "topperprice2span"><%= fmtCurr2(rs("topperprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "topperprice2"
                                                                    id = "topperprice2"
                                                                    value = "<%= fmtCurr2(rs("topperprice"), false, orderCurrency) %>" />
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "standardtopperpricespan2"><%= fmtCurr2(topperDiscountObj.standardPrice, false, orderCurrency) %></span>
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "topperdiscountamtspan"><%= fmtCurr2(negToZero(topperDiscountObj.standardPrice - topperDiscountObj.price), false, orderCurrency) %></span>
                                                            </td>
                                                        </tr>
                                                    <%
                                                end if
                                                    %>
                                                    <%
                                                if rs("legsrequired") = "y" then
                                                    %>

                                                        <tr>
                                                            <td>
                                                                Leg Price
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "legprice2span"><%= fmtCurr2(rs("legprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "legprice2"
                                                                    id = "legprice2"
                                                                    value = "<%= fmtCurr2(rs("legprice"), false, orderCurrency) %>" />
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "standardlegspricespan2"><%= fmtCurr2(legsDiscountObj.standardPrice, false, orderCurrency) %></span>
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "legsdiscountamtspan"><%= fmtCurr2(negToZero(legsDiscountObj.standardPrice - legsDiscountObj.price), false, orderCurrency) %></span>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Support Leg Price
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "addlegprice2span"><%= fmtCurr2(rs("addlegprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "addlegprice2"
                                                                    id = "addlegprice2"
                                                                    value = "<%= fmtCurr2(rs("addlegprice"), false, orderCurrency) %>" />
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "standardaddlegspricespan2"><%= fmtCurr2(addLegsDiscountObj.standardPrice, false, orderCurrency) %></span>
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "addlegsdiscountamtspan"><%= fmtCurr2(negToZero(addLegsDiscountObj.standardPrice - addLegsDiscountObj.price), false, orderCurrency) %></span>
                                                            </td>
                                                        </tr>
                                                    <%
                                                end if
                                                    %>
                                                    <%
                                                if rs("baserequired") = "y" then
                                                    %>

                                                        <tr>
                                                            <td>
                                                                Base
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "baseprice2span"><%= fmtCurr2(rs("baseprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "baseprice2"
                                                                    id = "baseprice2"
                                                                    value = "<%= fmtCurr2(rs("baseprice"), false, orderCurrency) %>" />
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "standardbasepricespan2"><%= fmtCurr2(baseDiscountObj.standardPrice, false, orderCurrency) %></span>
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "basediscountamtspan"><%= fmtCurr2(negToZero(baseDiscountObj.standardPrice - baseDiscountObj.price), false, orderCurrency) %></span>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Upholstered Base
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "upholsteryprice2span"><%= fmtCurr2(rs("upholsteryprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "upholsteryprice2"
                                                                    id = "upholsteryprice2"
                                                                    value = "<%= fmtCurr2(rs("upholsteryprice"), false, orderCurrency) %>">
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "standardupholsterypricespan2"><%= fmtCurr2(baseUpholsteryDiscountObj.standardPrice, false, orderCurrency) %></span>
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "upholsterydiscountamtspan"><%= fmtCurr2(negToZero(baseUpholsteryDiscountObj.standardPrice - baseUpholsteryDiscountObj.price), false, orderCurrency) %></span>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Base Trim
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "basetrimprice2span"><%= fmtCurr2(rs("basetrimprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "basetrimprice2"
                                                                    id = "basetrimprice2"
                                                                    value = "<%= fmtCurr2(rs("basetrimprice"), false, orderCurrency) %>">
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "standardbasetrimpricespan2"><%= fmtCurr2(baseTrimDiscountObj.standardPrice, false, orderCurrency) %></span>
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "basetrimdiscountamtspan"><%= fmtCurr2(negToZero(baseTrimDiscountObj.standardPrice - baseTrimDiscountObj.price), false, orderCurrency) %></span>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Base Drawers
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "basedrawersprice2span"><%= fmtCurr2(rs("basedrawersprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "basedrawersprice2"
                                                                    id = "basedrawersprice2"
                                                                    value = "<%= fmtCurr2(rs("basedrawersprice"), false, orderCurrency) %>">
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "standardbasedrawerspricespan2"><%= fmtCurr2(baseDrawersDiscountObj.standardPrice, false, orderCurrency) %></span>
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "basedrawersdiscountamtspan"><%= fmtCurr2(negToZero(baseDrawersDiscountObj.standardPrice - baseDrawersDiscountObj.price), false, orderCurrency) %></span>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Base Fabric
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "basefabricprice2span"><%= fmtCurr2(rs("basefabricprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "basefabricprice2"
                                                                    id = "basefabricprice2"
                                                                    value = "<%= fmtCurr2(rs("basefabricprice"), false, orderCurrency) %>">
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "standardbasefabricpricespan2"><%= fmtCurr2(baseFabricDiscountObj.standardPrice, false, orderCurrency) %></span>
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "basefabricdiscountamtspan"><%= fmtCurr2(negToZero(baseFabricDiscountObj.standardPrice - baseFabricDiscountObj.price), false, orderCurrency) %></span>
                                                            </td>
                                                        </tr>
                                                    <%
                                                end if
                                                    %>
                                                    <%
                                                if rs("headboardrequired") = "y" then
                                                    %>

                                                        <tr>
                                                            <td>
                                                                Headboard
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "headboardprice2span"><%= fmtCurr2(rs("headboardprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "headboardprice2"
                                                                    id = "headboardprice2"
                                                                    value = "<%= fmtCurr2(rs("headboardprice"), false, orderCurrency) %>" />
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "standardheadboardpricespan2"><%= fmtCurr2(headboardDiscountObj.standardPrice, false, orderCurrency) %></span>
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "headboarddiscountamtspan"><%= fmtCurr2(negToZero(headboardDiscountObj.standardPrice - headboardDiscountObj.price), false, orderCurrency) %></span>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Headboard Fabric Price
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "hbfabricprice2span"><%= fmtCurr2(rs("hbfabricprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "hbfabricprice2"
                                                                    id = "hbfabricprice2"
                                                                    value = "<%= fmtCurr2(rs("hbfabricprice"), false, orderCurrency) %>">
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Headboard Trim
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "headboardtrimprice2span"><%= fmtCurr2(rs("headboardtrimprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "headboardtrimprice2"
                                                                    id = "headboardtrimprice2"
                                                                    value = "<%= fmtCurr2(rs("headboardtrimprice"), false, orderCurrency) %>" />
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "standardheadboardtrimpricespan2"><%= fmtCurr2(headboardTrimDiscountObj.standardPrice, false, orderCurrency) %></span>
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "headboardtrimdiscountamtspan"><%= fmtCurr2(negToZero(headboardTrimDiscountObj.standardPrice - headboardTrimDiscountObj.price), false, orderCurrency) %></span>
                                                            </td>
                                                        </tr>
                                                    <%
                                                end if
                                                    %>
                                                    <%
                                                if rs("valancerequired") = "y" then
                                                    %>

                                                        <tr>
                                                            <td>
                                                                Valance
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "valanceprice2span"><%= fmtCurr2(rs("valanceprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "valanceprice2"
                                                                    id = "valanceprice2"
                                                                    value = "<%= fmtCurr2(rs("valanceprice"), false, orderCurrency) %>" />
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                Valance Fabric Price
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "valfabricprice2span"><%= fmtCurr2(rs("valfabricprice"), true, orderCurrency) %></span>&nbsp;

                                                                <input type = "hidden" name = "valfabricprice2"
                                                                    id = "valfabricprice2"
                                                                    value = "<%= fmtCurr2(rs("valfabricprice"), false, orderCurrency) %>">
                                                            </td>
                                                        </tr>
                                                    <%
                                                end if
                                                    %>
                                                    <%
                                                if rs("accessoriesrequired") = "y" then
                                                    %>

                                                        <tr>
                                                            <td>
                                                                Accessories Price
                                                            </td>

                                                            <td class="xview">
                                                                <span id = "accessoriestotalcost2span"><%= fmtCurr2(rs("accessoriestotalcost"), true, orderCurrency) %></span>&nbsp;
                                                            </td>
                                                        </tr>
                                                    <%
                                                end if
                                                    %>

                                                    <tr class="xview">
                                                        <td>
                                                            <strong>Bed Set Total</strong>
                                                        </td>

                                                        <td>
                                                            <span id = "bedsettotalspan"><%= fmtCurr2(rs("bedsettotal"), true, orderCurrency) %></span>&nbsp;

                                                            <input type = "hidden" name = "bedsettotal"
                                                                id = "bedsettotal"
                                                                value = "<%= fmtCurr2(rs("bedsettotal"), false, orderCurrency) %>" />
                                                        </td>
                                                    </tr>

                                                    <tr id = "dceditdiv" class="xview">
                                                        <td>
                                                            <button type = "button" class="xview"
                                                                onClick = "JavaScript:showHideDiscounts(true); logChange($('#dcresult'));">Edit DC</button>
                                                        </td>

                                                        <td>&nbsp;
                                                            
                                                        </td>
                                                    </tr>

                                                    <tr id = "dcremovediv" class="xview">
                                                        <td>
                                                            <button type = "button" class="xview"
                                                                onClick = "JavaScript:showHideDiscounts(false); logChange($('#dcresult'));">Remove DC</button>
                                                        </td>
                                                    </tr>

                                                    <tr id = "dcdiv" class="xview">
                                                        <td>
                                                            DC &nbsp;&nbsp; %

                                                            <input type = "radio" name = "dc" class="xview" id = "dc"
                                                                value = "percent"
                                                                <%= ischecked2(rs("discounttype")<>"currency") %>>
                                                            &nbsp;&nbsp; <%= getCurrencySymbolForCurrency(orderCurrency) %>

                                                            <input type = "radio" name = "dc" class="xview" id = "dc2"
                                                                value = "currency"
                                                                <%= ischecked2(rs("discounttype")="currency") %>>
                                                        </td>

                                                        <td>
                                                            <label>
                                                            <input name = "dcresult" type = "text" class="xview" id = "dcresult"
                                                                value = "<%= rs("discount") %>" size = "10"
                                                                maxlength = "25"></label>
                                                        </td>
                                                    </tr>

                                                    <tr class="xview">
                                                        <td>
                                                            <strong>Sub Total</strong>
                                                        </td>

                                                        <td>
                                                            <span id = "subtotalspan"><%= fmtCurr2(rs("subtotal"), true, con) %></span>

                                                            <input type = "hidden" name = "subtotal" id = "subtotal"
                                                                value = "<%= fmtCurr2(rs("subtotal"), false, orderCurrency) %>" />
                                                        </td>
                                                    </tr>

                                                            <%
                                                        if isTrade then
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
		                                                            <span id = "deliveryprice2span"><%= fmtCurr2(rs("deliveryprice"), true, orderCurrency) %></span>&nbsp;
		
		                                                            <input type = "hidden" name = "deliveryprice2"
		                                                                id = "deliveryprice2"
		                                                                value = "<%= fmtCurr2(rs("deliveryprice"), false, orderCurrency) %>" />
		                                                        </td>
		                                                    </tr>

                                                            <tr class="xview">
                                                                <td>
                                                                    <%=OrderTotalExVAT%>
                                                                </td>

                                                                <td>
                                                                    <span id = "totalexvatspan"></span>

                                                                    <input type = "hidden" name = "totalexvat"
                                                                        id = "totalexvat" />
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
		                                                            <span id = "deliveryprice2span"><%= fmtCurr2(rs("deliveryprice"), true, orderCurrency) %></span>&nbsp;
		
		                                                            <input type = "hidden" name = "deliveryprice2"
		                                                                id = "deliveryprice2"
		                                                                value = "<%= fmtCurr2(rs("deliveryprice"), false, orderCurrency) %>" />
		                                                        </td>
		                                                    </tr>
                                                            <tr class="xview">
                                                                <td>
                                                                   <%=OrderTotalExVAT%>
                                                                </td>

                                                                <td>
                                                                    <span id = "totalexvatspan"></span>

                                                                    <input type = "hidden" name = "totalexvat"
                                                                        id = "totalexvat" />
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
                                                                    <span id = "totalspan"><%= fmtCurr2(rs("total"), true, orderCurrency) %></span>

                                                                    <input type = "hidden" name = "total" id = "total"
                                                                        value = "<%= fmtCurr2(rs("total"), false, orderCurrency) %>" />
                                                                </td>
                                                            </tr>

                                                            <tr class="xview">
                                                                <td>&nbsp;
                                                                    
                                                                </td>

                                                                <td>&nbsp;
                                                                    
                                                                </td>
                                                            </tr>
                                                            <%
                                                        If quote <> "y" then
                                                            dim payments, paymentSum, payMethods
                                                            outstanding = safeCCur(rs("balanceoutstanding") )
                                                            'response.write("<br>balanceoutstanding=" &  outstanding)
                                                            payments = getPaymentsForOrder(order, con)
                                                            paymentSum = 0.0
                                                            if ubound(payments) > 0 then
                                                            %>

                                                                        <tr class="xview">
                                                                            <td colspan = "2">
                                                                                <table>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <b>Payments/Refunds</b>
                                                                                        </td>
                                                                                    </tr>

                                                                                    <tr>
                                                                                        <td>
                                                                                            Type
                                                                                        </td>

                                                                                        <td>
                                                                                            Payment Method
                                                                                        </td>

                                                                                        <td>
                                                                                            Invoice Date
                                                                                        </td>

                                                                                        <td>
                                                                                            Invoice No.
                                                                                        </td>

                                                                                        <td>
                                                                                            Date
                                                                                        </td>

                                                                                        <td>
                                                                                            Receipt No.
                                                                                        </td>

                                                                                        <td>
                                                                                            Amount
                                                                                        </td>

                                                                                        <td>
                                                                                            Credit Details
                                                                                        </td>
                                                                                    </tr>
                                                                                    <%
                                                                                    for n = 1 to ubound(payments)
                                                                                        paymentSum = paymentSum + payments(n).amount
                                                                                    %>

                                                                                            <tr class="xview">
                                                                                                <td><%= payments(n).paymentType %></td>

                                                                                                <td><%= payments(n).paymentMethod %></td>

                                                                                                <td><%= payments(n).invoicedate %></td>

                                                                                                <td>
                                                                                                    <%
                                                                                                    if payments(n).invoice_number = "" or payments(n).invoice_number = "0" or isNull(payments(n).invoice_number) then
                                                                                                    %>

                                                                                                        <input name = "<%= payments(n).paymentid %>invono"
                                                                                                            id = "<%= payments(n).paymentid %>invono"type="text"
                                                                                                            size = "5">
                                                                                                    <%
                                                                                                    else
                                                                                                    %>

                                                                                                        <%= payments(n).invoice_number %>
                                                                                                    <%
                                                                                                    end if
                                                                                                    %>
                                                                                                </td>

                                                                                                <td><%= payments(n).placed %></td>

                                                                                                <td><%= payments(n).receiptNo %></td>

                                                                                                <td><%= fmtCurr2(abs(payments(n).amount), true, orderCurrency) %></td>
                                                                                            <%
                                                                                        if payments(n).creditDetails <> "" then
                                                                                            %>

                                                                                                <td><%= payments(n).creditDetails %></td>
                                                                                            <%
                                                                                        end if
                                                                                            %>
                                                                                            </tr>
                                                                                    <%
                                                                                    next
                                                                                    %>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                            <%
                                                            end if
                                                            %>

                                                                    <input type = "hidden" name = "paymentsum"
                                                                        id = "paymentsum" value = "<%= paymentSum %>" />
                                                                    <%
                                                                dim exportdatearray(), compIDarray(), invDate, exportdatearrayWithInvoice(), expcount, expcount2, expcount3, orderhasexports, expdate, z, compprice, totalcompprice, totalcompprice2, exporthasinvoiceno, invno, invoicenumbersexistfororder, totalinvoiced, totalnotinvoiced, cid
                                                                    orderhasexports = "n"
                                                                    invoicenumbersexistfororder = "n"
                                                                    If quote <> "y" then
                                                                        sql = "Select distinct(E.CollectionDate) from exportcollections E, exportLinks L, exportCollShowrooms S where (L.invoiceNo IS NULL or L.invoiceNo='') and L.purchase_no=" & order & " and L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID"
                                                                        expcount = 0
                                                                        'response.Write(sql)
                                                                        Set rs5 = getMysqlQueryRecordSet(sql, con)
                                                                        if rs5.eof then

                                                                        else
                                                                            do until rs5.eof
                                                                                orderhasexports = "y"
                                                                                expcount = expcount + 1
                                                                                redim preserve exportdatearray(expcount)
                                                                                exportdatearray(expcount) = rs5("CollectionDate")
                                                                                rs5.movenext
                                                                            loop
                                                                        end if
                                                                        rs5.close
                                                                        set rs5 = nothing

                                                                        sql = "Select distinct(E.CollectionDate),E.exportcollectionsID from exportcollections E, exportLinks L, exportCollShowrooms S where (L.invoiceNo IS NOT NULL and L.invoiceNo<>'') and L.purchase_no=" & order & " and L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID"
                                                                        expcount3 = 0
                                                                        'response.Write(sql)
                                                                        Set rs5 = getMysqlQueryRecordSet(sql, con)
                                                                        if rs5.eof then
                                                                        else
                                                                            do until rs5.eof
                                                                                invoicenumbersexistfororder = "y"
                                                                                orderhasexports = "y"
                                                                                expcount3 = expcount3 + 1
                                                                                redim preserve exportdatearrayWithInvoice(expcount3)
                                                                                exportdatearrayWithInvoice(expcount3) = rs5("CollectionDate")
                                                                                rs5.movenext
                                                                            loop
                                                                        end if
                                                                        rs5.close
                                                                        set rs5 = nothing
                                                                    %>

                                                                            <tr class="xview">
                                                                                <td>
                                                                                    <strong>Balance Outstanding</strong>
                                                                                </td>

                                                                                <td>
                                                                                    <span id = "outstandingspan"><%= fmtCurr2(rs("balanceoutstanding"), true, orderCurrency) %></span>

                                                                                    <input type = "hidden"
                                                                                        name = "outstanding"
                                                                                        id = "outstanding"
                                                                                        value = "<%= fmtCurr2(rs("balanceoutstanding"), false, orderCurrency) %>" />
                                                                                </td>
                                                                            </tr>
                                                                                    <%
                                                                                    if orderhasexports = "y" then
                                                                                    %>

                                                                                        <tr class="xview">
                                                                                            <td>
                                                                                                <strong>Amount
                                                                                                Invoiced</strong>
                                                                                            </td>

                                                                                            <td>
                                                                                                <%= getCurrencySymbolForCurrency(orderCurrency) %><input type = "text"
                                                                                                    name = "showinvoicedamount"
                                                                                                id = "showinvoicedamount"
                                                                                                value = ""
                                                                                                class = "myClass">
                                                                                            </td>
                                                                                        </tr>

                                                                                        <tr class="xview">
                                                                                            <td>
                                                                                                <strong>Amount Not
                                                                                                Invoiced</strong>
                                                                                            </td>

                                                                                            <td>
                                                                                                <%= getCurrencySymbolForCurrency(orderCurrency) %><input type = "text"
                                                                                                    name = "shownotinvoicedamount"
                                                                                                id = "shownotinvoicedamount"
                                                                                                value = ""
                                                                                                class = "myClass">
                                                                                            </td>
                                                                                        </tr>
                                                                    <%
                                                                                    end if
                                                                    end if
                                                                    %>
                                                </table>

                                                <hr />

                                                <br>
                                                <br>
                                                            <%
                                                        end if
                                                            %>

                                                            <hr />

                                                            <p> <%
                                                        dim orderTotals, vals, totalspend
                                                        if isCancelled then
                                                            'response.write("isVIP" & isVIP)
                                                            if isVIP="y" then
                                                                orderTotals = getCustomerOrdersTotal(con, contact_no)
                                                                
                                                               ' totalsString = "Total spend: <b>"
                                                                for i = 1 to ubound(orderTotals)
                                                                   ' response.write("orderTotals(i)=" & orderTotals(i) & "<br>")
                                                                   ' if i > 1 then totalsString = totalsString & "&nbsp;&nbsp;"
                                                                    vals = split(orderTotals(i), ":")
                                                                    'totalsString = totalsString & fmtCurrNonHtml(vals(1), true, vals(0)) & " (Ex VAT " & fmtCurrNonHtml(vals(2), true, vals(0)) & ")"
                                                                    if vals(0)="GBP" then
                                                                        totalspend= totalspend + vals(1)
                                                                    end if
                                                                next
                                                                response.end
                                                    
                                                                if totalspend < 19999 and isVIPmanuallyset="n" then 
                                                                    sql = "Select * from contact WHERE contact_no=" & contact_no
                                                                    Set rs = getMysqlUpdateRecordSet(sql, con)
                                                                    rs("isVIP")="n"
                                                                    rs.Update
                                                                    rs.close
                                                                    set rs=nothing
                                                                end if
                                                            end if

                                                            %>

                                                                <font color = "#FF0000">Order has been cancelled

                                                                <br>
                                                                <br>
                                                                <%= rs("cancelled_reason") %><br />

                                                                <br />
                                        <%
                                        Set rs3 = getMysqlQueryRecordSet("Select * from payment where purchase_no=" & order & " AND reasonforamend='Order Cancelled'", con)
                                        If not rs3.eof then
                                            response.write("Refund given of " & rs3("amount") & " receipt no. " & rs3("receiptno") )
                                        end if
                                            rs3.close
                                            set rs3 = nothing
                                        %>

                                                                </font>
                                                            <%
                                                        end if
                                                            %>

                                                            </p>

                                                            <p> <input type = "hidden" name = "val" id = "val"
                                                                    value = "<%= contact_no %>">
                                                            <%
                                                        If quote = "y" or quote = "d" then
                                                            %>

                                                                <input type = "hidden" name = "contact_no"
                                                                    id = "contact_no" value = "<%= contact_no %>">
                                                                <input type = "hidden" name = "quote" id = "quote"
                                                                    value = "<%= quote %>">
                                                                <input type = "hidden" name = "contact" id = "contact"
                                                                    value = "<%= contact %>">
                                                                <input type = "hidden" name = "converttoorder"
                                                                    id = "converttoorder" value = "y">
                                                                <input type = "hidden" name = "ordertype"
                                                                    id = "ordertype" value = "<%= rs("ordertype") %>">
                                                                <input type = "hidden" name = "orderno" id = "orderno"
                                                                    value = "<%= rs("order_number") %>">
                                                                <input type = "submit" name = "submit2" id = "submit2"
                                                                    class = "button" tabindex = "105"
                                                                    onClick = "document.pressed=this.value;"
                                                                    value = "Edit Quote"<%= isDisabled(readonly) %> />

                                                                <input type = "submit" name = "submit3" id = "submit3"
                                                                    class = "button" tabindex = "106"
                                                                    onClick = "document.pressed=this.value"
                                                                    value = "Convert Quote to Order"
                                                                    <%= isDisabled(readonly) %> />
                                                            <%
                                                        Else
                                                            %>

                                                            <input type = "submit" name = "submit2" value = "Edit Order"
                                                                id = "submit2" class = "button" tabindex = "105"
                                                                <%= isDisabled(readonly) %> />
                                                            <%
                                                        End If
                                                            %>

                                                            </p>

                    <p><a href = "#top" class = "addorderbox">&gt;&gt; Back to
                                                  Top</a></p>

                                                  <p>&nbsp;</p>
                                                            <p>&nbsp;</p>
                                                            <p>&nbsp;</p>

                                                           
                  </form>


<%end if%>


<%Dim paymentsexist, pendinginvoiceNo, pendinginvoiceDate, pendinginvoiceexists
pendinginvoiceexists="n"
Set rs3 = getMysqlQueryRecordSet("Select * from pending_invoicenos where purchase_no=" & order, con)
if not rs3.eof then
	pendinginvoiceNo=rs3("invoice_no")
	pendinginvoiceDate=rs3("invoice_date")
	pendinginvoiceexists="y"
end if
rs3.close
set rs3=nothing%>
<div class="clear"></div>
<%if quote<>"y" then%>
<div class="showWholesale">
<!-- #include file="wholesale-invoice-form.asp" -->
</div>
<%end if%>
<div class="clear"></div>

<%paymentsexist=0
paymentsexist=getPaymentsForInvoiceNo(invno,order,con)
if quote<>"y" then
	if (idlocation=14 or idlocation=30 or idlocation=40 or idlocation=41) and CDbl(rs("balanceoutstanding"))<>0 and quote<>"y" and pendinginvoiceexists="n" then%>
		<!-- #include file="pendinginvoiceform.asp" -->
	<%else%>
		<!-- #include file="paymentform.asp" -->
	<%end if
end if%>
                        <%if retrieveuserlocation=1 or SavoirOwned="y" then%>
<table width="100%" border="0" cellspacing="2" cellpadding="1">
  <tr>
    <td><hr /><strong><br>
     <%if retrieveuserlocation()=1 then%> Click or Drag to upload files for this order<br>
        <br><%end if%>
Exit Shots Only:</strong><br />
	<%
		dzType = "exit"
		%>
		<!-- #include file="dropzone_include1.asp" --><br /><hr />&nbsp;</td>
  </tr>
</table>
<%end if%>
                        <p> <%
                        if not isCancelled then
                            %>

                                <button type = "button" id = "cancelorder"
                                    onClick = "JavaScript: window.location='<%=cancelOrderHref%>';">Cancel
                                    <%if quote="y" then%>
                                    Quote
                                    <%else%>
                                    Order
									<%end if%></button>
                            <%
                        end if
                            %>

                  </p>
                            <%
                        if qw = "y" then
                            %>

                                <script type = "text/javascript">
                                    function validateForm( theForm )
                                    {
                                        if( theForm.code.value == "" )
                                        {
                                            alert('Please enter the confirmation code' )
                                            theForm.code.focus();
                                            return false;
                                        }
                                        return true;
                                    }
                                </script>

                                <div id = "confirmation-code-form-div">
                                    <p>Please enter the confirmation code for order <%= orderNumber %></p>

                                    <p>
                                    <form name = "confirmation-code-form" method = "post"
                                        action = "confirmation-code-form.asp" onSubmit = "return validateForm(this);">
                                        <input name = "pn" type = "hidden" value = "<%= order %>" />

                                        <br />

                                        <input name = "code" type = "text" />

                                        <br />

                                        <input type = "submit" name = "button" id = "button" value = "Confirm">
                                    </form>

                                    </p>
                                </div>
                            <%
                        end if
                            %>
                </div>
            </div>

            <div>
                <%
            if signature <> "" then
                %>

                    <p>Customer Signature: <%= custname %></p>

                    <div class = "sigPad">
                        <div class = "sigPad sig sigWrapper">
                            <canvas class = "pad" width = "198" height = "55">
                            </canvas>
                        </div>
                    </div>
                <%
            end if
                %>
            </div>
        </div>
    </body>
</html>

<%
if signature <> "" then
%>

<script src = "scripts/jquery.signaturepad.min.js">
</script>

<script Language = "JavaScript" type = "text/javascript">
    var sig = '<%=signature%>';

    $(document ).ready(function( )
    {
        $('.sigPad' ).signaturePad(
        {
            displayOnly: true
        } ).regenerate(sig );
    })
</script>

<script src = "scripts/json2.min.js">
</script>
<%
end if

%>
 <script src="js/lightbox-plus-jquery.min.js"></script>
<script Language = "JavaScript" type = "text/javascript">
function IsNumeric(sText)
{
    var ValidChars = "0123456789.";
    var IsNumber = true;
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
    if (theForm.matt1width && !IsNumeric(theForm.matt1width.value))
    {
        alert('Please enter only numbers for first mattress width')
        theForm.matt1width.focus();
        return false;
    }

    if (theForm.matt2width && !IsNumeric(theForm.matt2width.value))
    {
        alert('Please enter only numbers for second mattress width')
        theForm.matt2width.focus();
        return false;
    }

    if (theForm.matt1length && !IsNumeric(theForm.matt1length.value))
    {
        alert('Please enter only numbers for first mattress length')
        theForm.matt1length.focus();
        return false;
    }

    if (theForm.matt2length && !IsNumeric(theForm.matt2length.value))
    {
        alert('Please enter only numbers for second mattress length')
        theForm.matt2length.focus();
        return false;
    }

    if (theForm.base1width && !IsNumeric(theForm.base1width.value))
    {
        alert('Please enter only numbers for first base width')
        theForm.base1width.focus();
        return false;
    }

    if (theForm.base2width && !IsNumeric(theForm.base2width.value))
    {
        alert('Please enter only numbers for second base width')
        theForm.matt2width.focus();
        return false;
    }

    if (theForm.base1length && !IsNumeric(theForm.base1length.value))
    {
        alert('Please enter only numbers for first base length')
        theForm.base1length.focus();
        return false;
    }

    if (theForm.base2length && !IsNumeric(theForm.base2length.value))
    {
        alert('Please enter only numbers for second base length')
        theForm.base2length.focus();
        return false;
    }

    if (theForm.topper1width && !IsNumeric(theForm.topper1width.value))
    {
        alert('Please enter only numbers for topper width')
        theForm.topper1width.focus();
        return false;
    }

    if (theForm.topper1length && !IsNumeric(theForm.topper1length.value))
    {
        alert('Please enter only numbers for topper length')
        theForm.topper1length.focus();
        return false;
    }

    if (theForm.mattressprice && !IsNumeric(theForm.mattressprice.value))
    {
        alert('Please enter only numbers for mattress price')
        theForm.mattressprice.focus();
        return false;
    }

    if (theForm.topperprice && !IsNumeric(theForm.topperprice.value))
    {
        alert('Please enter only numbers for topper price')
        theForm.topperprice.focus();
        return false;
    }

    if (theForm.baseprice && !IsNumeric(theForm.baseprice.value))
    {
        alert('Please enter only numbers for base price')
        theForm.baseprice.focus();
        return false;
    }

    if (theForm.legprice && !IsNumeric(theForm.legprice.value))
    {
        alert('Please enter only numbers for leg price')
        theForm.legprice.focus();
        return false;
    }
if (theForm.addlegprice && !IsNumeric(theForm.addlegprice.value))
{
alert('Please enter only numbers for support leg price')
theForm.addlegprice.focus();
return false;
}
    if (theForm.speciallegheight && !IsNumeric(theForm.speciallegheight.value))
    {
        alert('Please enter only numbers for special leg height')
        theForm.speciallegheight.focus();
        return false;
    }

    if (theForm.upholsteryprice && !IsNumeric(theForm.upholsteryprice.value))
    {
        alert('Please enter only numbers for upholstery price')
        theForm.upholsteryprice.focus();
        return false;
    }

    if (theForm.basetrimprice && !IsNumeric(theForm.basetrimprice.value))
    {
        alert('Please enter only numbers for base trim price')
        theForm.basetrimprice.focus();
        return false;
    }

    if (theForm.basedrawersprice && !IsNumeric(theForm.basedrawersprice.value))
    {
        alert('Please enter only numbers for base drawers price')
        theForm.basedrawersprice.focus();
        return false;
    }

    if (theForm.basefabricprice && !IsNumeric(theForm.basefabricprice.value))
    {
        alert('Please enter only numbers for base fabric price')
        theForm.basefabricprice.focus();
        return false;
    }

    if (theForm.headboardprice && !IsNumeric(theForm.headboardprice.value))
    {
        alert('Please enter only numbers for headboard price')
        theForm.headboardprice.focus();
        return false;
    }

    if (theForm.headboardtrimprice && !IsNumeric(theForm.headboardtrimprice.value))
    {
        alert('Please enter only numbers for headboard trim price')
        theForm.headboardtrimprice.focus();
        return false;
    }

    if (theForm.hbfabricprice && !IsNumeric(theForm.hbfabricprice.value))
    {
        alert('Please enter only numbers for headboard fabric price')
        theForm.hbfabricprice.focus();
        return false;
    }

    if (theForm.valanceprice && !IsNumeric(theForm.valanceprice.value))
    {
        alert('Please enter only numbers for valance price')
        theForm.valanceprice.focus();
        return false;
    }

    if (theForm.valfabricprice && !IsNumeric(theForm.valfabricprice.value))
    {
        alert('Please enter only numbers for valance fabric price')
        theForm.valfabricprice.focus();
        return false;
    }

    if (theForm.deliveryprice && !IsNumeric(theForm.deliveryprice.value))
    {
        alert('Please enter only numbers for delivery price')
        theForm.deliveryprice.focus();
        return false;
    }

    

    if (theForm.additionalpayment && theForm.additionalpayment.value != "" && theForm.paymentmethod.value == "")
    {
        alert('Please select a payment type');
        theForm.paymentmethod.focus();
        return false;
    }

    if (theForm.refund && theForm.refund.value != "" && theForm.refundmethod.value == "")
    {
        alert('Please select a refund payment type');
        theForm.refundmethod.focus();
        return false;
    }
	
	if ((theForm.drawerconfig.value != "n") && (theForm.drawerheight.value == "n"))
	{
	alert("Please add drawer height");
	theForm.drawerheight.focus();
	return (false);
	}
	
	     if (theForm.ordernote_notetext && theForm.ordernote_action && theForm.ordernote_followupdate && (theForm.ordernote_notetext.value != "" && theForm.ordernote_action.value == "To Do" && theForm.ordernote_followupdate.value == ""))
    {
	alert('Please enter a follow-up date');
	theForm.ordernote_followupdate.focus();
	return false;
	}
	if (theForm.ordernote_followupdate && theForm.ordernote_followupdate.value != "" && !isDate(theForm.ordernote_followupdate.value))
    {
        alert('Please enter a valid follow up date');
        theForm.ordernote_followupdate.focus();
        return false;
    }

    if (theForm.ordernote_followupdate && theForm.ordernote_followupdate.value != "" && theForm.ordernote_followupdate.value != ""
        && theForm.ordernote_notetext.value == "")
    {
        // Have entered a date, so lets have a note
        alert('Please enter a note for the entered follow up date');
        theForm.ordernote_notetext.focus();
        return false;
    }
	
    return true;
}





function OnSubmitForm()
{
    if (document.pressed == 'Edit Quote')
    { //alert("edit");
        document.form1.action = "edit-purchase.asp";
    }
    else if (document.pressed == 'Convert Quote to Order')
    { //alert("summary");
        document.form1.action = "order-added.asp";
    }

    if (document.form1.submit2)
    {
        document.form1.submit2.value = 'Please Wait...';
    }

    if (document.form1.submit3)
    {
        document.form1.submit3.value = 'Please Wait...';
    }
    window.setTimeout("delayedSubmitDisable()", 10);
    return true;
}

function delayedSubmitDisable()
{
    if (document.form1.submit2)
    {
        document.form1.submit2.disabled = true;
    }

    if (document.form1.submit3)
    {
        document.form1.submit3.disabled = true;
    }
}
var vatRateJs;
var isTradeJs;

$(document).ready(init());
	 
function init()
{
    mattressTickingSelected();
    topperTickingSelected();
    baseTickingSelected();
	$('.showWholesale').hide();
	showWholesalePDFButton();
	showtickingoptions();
	showtoppertickingoptions();
	showbasetickingoptions();
	calcTotalWholesaleBasePrice();
	calcTotalWholesaleHeadboardPrice();
    $('.drawerscls').hide();
	$('#minus1').hide();
	$('#plus1').show();
	showDrawersSection("<%=rs("basedrawers")%>");

    $("#tickingoptions").change(mattressTickingSelected);
    $("#toppertickingoptions").change(topperTickingSelected);
    $("#basetickingoptions").change(baseTickingSelected);

    headboardstyle();
    manhattanTrimOptions();
	manhattanTrim();
	baseTrim();
	wholesaleDrawers()
	footboardOptions();
    $("#headboardstyle").change(headboardstyle);
    $("#headboardstyle").change(setHeadboardHeightOptions);
    $("#headboardstyle").change(manhattanTrimOptions);
	$("#headboardstyle").change(footboardOptions);
	$("#headboardstyle").change(manhattanTrim);
	

    //populateFabricDropdown(document.form1.basefabric);
    //populateFabricDropdown(document.form1.headboardfabric);
    //populateFabricDropdown(document.form1.valancefabric);
    setMattressTypes("<%=rs("mattresstype")%>");
    setLinkPosition("<%=rs("linkposition")%>");
    showLegStylePriceField();
    showFloorType();
    showInvoicedData();

    mattspecialwidthSelected(false);
    mattspeciallengthSelected(false);
    basespecialwidthSelected(false);
    basespeciallengthSelected(false);
    topperspecialwidthSelected(false);
    topperspeciallengthSelected(false);
    legspecialheightSelected(false);

    mattressChanged(true);
    topperChanged(true);
    baseChanged(true);
    legsChanged(true);
    upholsteredBaseChanged();
    headboardChanged(true);
    valanceChanged();
    accessoriesChanged();
    deliveryChanged();
    redisplaySummary(false);
    
    // show/hide the lines of the base price summary table
    showHideBasePriceSummaryRow(11);
    showHideBasePriceSummaryRow(12);
    showHideBasePriceSummaryRow(13);
    showHideBasePriceSummaryRow(17);
    calcTotalBasePrice();
	

    // show/hide the lines of the headboard price summary table
    showHideHeadboardPriceSummaryRow(3);
    showHideHeadboardPriceSummaryRow(10);
    calcTotalHeadboardPrice();

    showHideCreditDetails(false);

    <% if isCancelled or isComplete then %>
    // order is cancelled, so make readonly
    $('#form1 input').attr('disabled', true);
    $('#form1 textarea').attr('disabled', true);
    $('#form1 select').attr('disabled', true);
    $('#form12 input').attr('disabled', true);
    $('#form12 textarea').attr('disabled', true);
    $('#form12 select').attr('disabled', true);
	$('#form1 #wholesaleinv').prop('disabled', false);
	$('#form1 #Wlegsprice').prop('disabled', false);
    <% end if %>
	
	<%if basePONumber="y" then%>
	$('#basefabricdirection').attr('disabled', 'disabled');
	$('#upholsteredbase').attr('disabled', 'disabled');
	$('#basefabric').attr('disabled', 'disabled');
	$('#basefabricchoice').attr('disabled', 'disabled');
	$('#basefabricmeters').attr('disabled', 'disabled');
	$('#basefabricdesc').attr('disabled', 'disabled');
	<%end if%>
	<%if hbPONumber="y" then%>
	$('#hbfabricoptions').attr('disabled', 'disabled');
	$('#headboardfabric').attr('disabled', 'disabled');
	$('#headboardfabricdirection').attr('disabled', 'disabled');
	$('#headboardfabricchoice').attr('disabled', 'disabled');
	$('#hbfabricmeters').attr('disabled', 'disabled');
	$('#headboardfabricdesc').attr('disabled', 'disabled');
	<%end if%>
	<%if valancePONumber="y" then%>
	$('#valancefabric').attr('disabled', 'disabled');
	$('#valancefabricchoice').attr('disabled', 'disabled');
	$('#valancefabricoptions').attr('disabled', 'disabled');
	$('#valancefabricdirection').attr('disabled', 'disabled');
	$('#valfabricmeters').attr('disabled', 'disabled');
	$('#valancedrop').attr('disabled', 'disabled');
	$('#valancewidth').attr('disabled', 'disabled');
	$('#valancelength').attr('disabled', 'disabled');
	<%end if%>

    disableComponentSections();

    hideDiscountFields();
    
    setBaseTrimColours('<%=rs("basetrimcolour")%>');

    vatRateJs = $('#vatrate').val()*1.0;
	<% if isTrade then %>
		isTradeJs = "y";
	<% else %>
		isTradeJs = "n";
	<% end if %>
	
	
}


	
function showWholesalePDFButton() 
{	var Winv = $("#winvoiceno").val();
	var Wdate = $("#winvoicedate").val();
	if (Winv=="" || Wdate=="") {
		$("input[name='wholesalePDF']").attr("disabled", true);
	}
	else {
		$("input[name='wholesalePDF']").attr("disabled", false);
	}
}

function HideWholesale() 
{
	$('.showWholesale').hide();
}
function ShowWholesale() 
{
	$('.showWholesale').show();
}

function showInvoicedData()
{
    var invoicedamt = $("#totalinvoiced").val()
    var notinvoicedamt = $("#totalnotinvoiced").val()
    //console.log("invamt=" + invoicedamt);
    $("#showinvoicedamount").val(invoicedamt);
    $("#shownotinvoicedamount").val(notinvoicedamt);
}

function clearinvoicedate()
{
    $('#invoicedate').val('');
}
function clearfinalinvdate()
{
    $('#finalinvdate').val('');
}

$('#invoiceType').change(function()
{
    var url = $("#invoiceType").val();
    var inv = $("#invoiceno").val();

    if (url == "n")
        return;

    var val = $("input[name=exportchoice]:checked").val();
	
    if (!val)
    {
        alert("Please select an invoice date");
        return;
    }
	

    var cid = $("#cid" + val.replace(/\//g, "")).val();
    window.open(url.replace("XXX", cid).replace("YYY", inv));
});

$('#pendingInvoicePrint').change(function()
{
    var url = $("#pendingInvoicePrint").val();
    var inv = $("#invoiceno").val();
	var invdt = $("#invoicedate").val();

    if (url == "n")
        return;

    var val = $("input[name=depositradio]:checked").val();

    if (!val)
    {
        alert("Please select the radio box for updating Deposit invoice date and number");
        return;
    }
	

    window.open(url.replace("YYY", inv).replace("JJJ", invdt));
});



function mattressTickingSelected()
{
    $('#tick1').hide();
    $('#tick2').hide();
    $('#tick3').hide();
    $('#tick4').hide();

    var selection = $("#tickingoptions").val();

    if (selection == "White Trellis")
    {
        $('#tick1').show();
    }
    else if (selection == "Grey Trellis")
    {
        $('#tick2').show();
    }
    else if (selection == "Silver Trellis")
    {
        $('#tick3').show();
    }
    
}

function topperTickingSelected()
{
    $('#tick1t').hide();
    $('#tick2t').hide();
    $('#tick3t').hide();
    $('#tick4t').hide();

    var selection = $("#toppertickingoptions").val();

    if (selection == "White Trellis")
    {
        $('#tick1t').show();
    }
    else if (selection == "Grey Trellis")
    {
        $('#tick2t').show();
    }
    else if (selection == "Silver Trellis")
    {
        $('#tick3t').show();
    }
    
}

function baseTickingSelected()
{
    $('#tick1b').hide();
    $('#tick2b').hide();
    $('#tick3b').hide();
    $('#tick4b').hide();

    var selection = $("#basetickingoptions").val();

    if (selection == "White Trellis")
    {
        $('#tick1b').show();
    }
    else if (selection == "Grey Trellis")
    {
        $('#tick2b').show();
    }
    else if (selection == "Silver Trellis")
    {
        $('#tick3b').show();
    }
    
}


//beginning new legheight section
function legspecialheightSelected(clearvalues)
{
    hidelegspecialheight(clearvalues);
    var slct = $("#legheight option:selected").val();

    if (slct == "Special Height")
    {
        $('#legspecialheight').show();
    }
}

//beginning new mattwidth section
function mattspecialwidthSelected(clearvalues)
{
    hidemattspecialwidth(clearvalues);
    var selection = $("#mattresswidth").val();
    var selection2 = $("#mattresstype").val();

    if ((selection == "Special Width")
        && ((selection2 == "Zipped Pair") || (selection2 == "Zipped Pair (Centre Only)")))
    {
        $('#mattspecialwidth1').show();
        $('#mattspecialwidth2').show();
    }

    if ((selection == "Special Width")
        && ((selection2 != "Zipped Pair") && (selection2 != "Zipped Pair (Centre Only)")))
    {
        $('#mattspecialwidth1').show();
    }
}

function mattspeciallengthSelected(clearvalues)
{
    hidemattspeciallength(clearvalues);
    var selection = $("#mattresslength").val();
    var selection2 = $("#mattresstype").val();

    if ((selection == "Special Length")
        && ((selection2 == "Zipped Pair") || (selection2 == "Zipped Pair (Centre Only)")))
    {
        $('#mattspeciallength1').show();
        $('#mattspeciallength2').show();
    }

    if ((selection == "Special Length")
        && ((selection2 != "Zipped Pair") && (selection2 != "Zipped Pair (Centre Only)")))
    {
        $('#mattspeciallength1').show();
    }
}

function hidelegspecialheight(clearvalues)
{
    $('#legspecialheight').hide();

    if (clearvalues)
    {
        $("#speciallegheight").val("");
    }
}

function hidemattspecialwidth(clearvalues)
{
    $('#mattspecialwidth1').hide();
    $('#mattspecialwidth2').hide();

    if (clearvalues)
    {
        $("#matt1width").val("");
        $("#matt2width").val("");
    }
}

function hidemattspeciallength(clearvalues)
{
    $('#mattspeciallength1').hide();
    $('#mattspeciallength2').hide();

    if (clearvalues)
    {
        $("#matt1length").val("");
        $("#matt2length").val("");
    }
}

//end new section
function pushInvoiceInfo(invno, invdate)
{
    $("#invoiceno").val(invno);
    $("#invoicedate").val(invdate);
}

function clearInvoiceInfo()
{
    $("#invoiceno").val('');
    $("#invoicedate").val('');
}

//beginning new basewidth section
function basespecialwidthSelected(clearvalues)
{
    hidebasespecialwidth(clearvalues);
    var selection = $("#basewidth").val();
    var selection2 = $("#basetype").val();

    if ((selection == "Special Width") && ((selection2 == "North-South Split") || (selection2 == "East-West Split")))
    {
        $('#basespecialwidth1').show();
        $('#basespecialwidth2').show();
    }

    if ((selection == "Special Width") && ((selection2 != "North-South Split") && (selection2 != "East-West Split")))
    {
        $('#basespecialwidth1').show();
    }
}

function basespeciallengthSelected(clearvalues)
{
    hidebasespeciallength(clearvalues);
    var selection = $("#baselength").val();
    var selection2 = $("#basetype").val();

    if ((selection == "Special Length") && ((selection2 == "North-South Split") || (selection2 == "East-West Split")))
    {
        $('#basespeciallength1').show();
        $('#basespeciallength2').show();
    }

    if ((selection == "Special Length") && ((selection2 != "North-South Split") && (selection2 != "East-West Split")))
    {
        $('#basespeciallength1').show();
    }
}

function hidebasespecialwidth(clearvalues)
{

    $('#basespecialwidth1').hide();
    $('#basespecialwidth2').hide();

    if (clearvalues)
    {
        $("#base1width").val("");
        $("#base2width").val("");
    }
}

function hidebasespeciallength(clearvalues)
{
    $('#basespeciallength1').hide();
    $('#basespeciallength2').hide();

    if (clearvalues)
    {
        $("#base1length").val("");
        $("#base2length").val("");
    }
}

//end new section
//beginning new topperwidth section
function topperspecialwidthSelected(clearvalues)
{
    hidetopperspecialwidth(clearvalues);
    var selection = $("#topperwidth").val();

    if (selection == "Special Width")
    {
        $('#topperspecialwidth1').show();
    }
}

function topperspeciallengthSelected(clearvalues)
{
    hidetopperspeciallength(clearvalues);
    var selection = $("#topperlength").val();

    if (selection == "Special Length")
    {
        $('#topperspeciallength1').show();
    }
}

function hidetopperspecialwidth(clearvalues)
{

    $('#topperspecialwidth1').hide();

    if (clearvalues)
    {
        $("#topper1width").val("");
    }
}

function hidetopperspeciallength(clearvalues)
{
    $('#topperspeciallength1').hide();

    if (clearvalues)
    {
        $("#topper1length").val("");
    }
}

//end new section
function headboardstyle()
{
    hideAllHeadboardSwatches();
    var selection = $("#headboardstyle").val();
	 if (selection == "Virginia") {
        $('#tick5').show();
    } else if (selection == "Savoy") {
        $('#tick6').show();
	} else if (selection == "Penelope") {
        $('#tick7').show();
	} else if (selection == "Nicky") {
        $('#tick8').show();
	} else if (selection == "Mary") {
        $('#tick9').show();
	} else if (selection == "Ian (Headboard)") {
        $('#tick10').show();
	} else if (selection == "Hatti") {
        $('#tick11').show();
	} else if (selection == "Holly") {
        $('#tick12').show();
    } else if (selection == "Elliot (F100)") {
        $('#tick13').show();
    } else if (selection == "Alex (MF31)") {
        $('#tick14').show();
    } else if (selection == "Elizabeth (MF32)") {
        $('#tick15').show();
    } else if (selection == "Animal") {
        $('#tick16').show();
    } else if (selection == "Leo (CF5)") {
        $('#tick17').show();
	} else if (selection == "Lotti (CF4)") {
        $('#tick18').show();
	} else if (selection == "Harlech (CF2)") {
        $('#tick19').show();
	} else if (selection == "Felix (TF30)") {
        $('#tick20').show();
	} else if (selection == "Claudia") {
        $('#tick21').show();
	} else if (selection == "Gorrivan") {
        $('#tick22').show();
	}
}
function baseTrim()
{
    var slct = $("#basetrim").val();

    if (slct && (slct.substring(0, 1) == 'n' ))
    {
       $('#WBaseTrimprice').val(0);
	   $('#showBaseTrimWholesale').hide();
    }
	else
    {
        $('#showBaseTrimWholesale').show();
    }
}
function wholesaleDrawers()
{
    var slct = $("#drawerconfig").val();

    if (slct && (slct.substring(0, 1) == 'n' ))
    {
       $('#WBaseDrawerprice').val(0);
	   $('#showDrawerWholesale').hide();
    }
	else
    {
        $('#showDrawerWholesale').show();
    }
}
function manhattanTrimOptions()
{
    var slct = $("#headboardstyle").val();

    if (slct && (slct.substring(0, 9) == 'Manhattan' || slct == 'Holly' || slct == 'Hatti' || slct == 'Harlech (CF2)' || slct == 'Lotti (CF4)' || slct == 'Leo (CF5)' || slct == 'Winston (Stitched)' || slct == 'C2' || slct == 'C4' || slct == 'C5' || slct == 'CF2' || slct == 'CF4' || slct == 'CF5'))
    {
        $('#manhattantrimdiv1').show();
        $('#manhattantrimdiv2').show();
		$('.showTrimWholesale').show();
    }
    else
    {
        $("#manhattantrim option[value='--']").attr('selected', 'selected');
        $('#manhattantrimdiv1').hide();
        $('#manhattantrimdiv2').hide();
		$('.showTrimWholesale').hide();
    }
}

function manhattanTrim()
{
    var slct = $("#manhattantrim").val();

    if (slct && (slct.substring(0, 2) == '--' ))
    {
       $('#WHBTrimprice').val(0);
	   $('.showTrimWholesale').hide();
    }
	else
    {
        $('.showTrimWholesale').show();
    }
}


function footboardOptions()
{
    var slct = $("#headboardstyle").val();

    if (slct && (slct.substring(0, 30) == 'Gorrivan Headboard & Footboard')) {
        $('#footboardheightdiv1').show();
        $('#footboardheightdiv2').show();
		$('#footboardfinishdiv1').show();
        $('#footboardfinishdiv2').show();
    }
    else
    {
        $("#footboardheight option[value='--']").attr('selected', 'selected');
		$("#footboardfinish option[value='--']").attr('selected', 'selected');
        $('#footboardheightdiv1').hide();
        $('#footboardheightdiv2').hide();
		$('#footboardfinishdiv1').hide();
        $('#footboardfinishdiv2').hide();
    }
}

function setHeadboardHeightOptions()
{
    var hbStyle = $("#headboardstyle").val();
    var url = "get-field-options-ajax.asp?fieldname=headboardheight&defaultsrcfield=headboardstyle&defaultsrcopt="
        + escape(hbStyle) + "&ts=" + (new Date()).getTime();
    $('#headboardheight').load(url);
}

function hideAllHeadboardSwatches()
{
  $('#tick5').hide();
	$('#tick6').hide();
	$('#tick7').hide();
	$('#tick8').hide();
	$('#tick9').hide();
	$('#tick10').hide();
	$('#tick11').hide();
    $('#tick12').hide();
    $('#tick13').hide();
    $('#tick14').hide();
    $('#tick15').hide();
    $('#tick16').hide();
	$('#tick17').hide();
	$('#tick18').hide();
	$('#tick19').hide();
	$('#tick20').hide();
	$('#tick21').hide();
	$('#tick22').hide();
}
function showDrawersSection() {
var value = $('#drawerconfig').val();
if (value!="n") {
	$('.drawerscls').show();
} else{
	$('.drawerscls').hide();
	$("#drawerheight option[value='n']").attr('selected', 'selected');
	}

}


function mattressChanged(initialising)
{
    var value = $("input[name=mattressrequired]:checked").val();

    if (value == 'y')
    {
        if (!initialising)
        {
            getStandardMattressPrice(); // so the standard price is shown that results from any defaults
        }
        $('#mattress_div').show("slow");
    }
    else
    {
        $('#mattress_div').hide("slow");
    }

    if (!initialising)
    {
        getStandardTopperPrice(); // topper price dependent on mattress
    }
    redisplaySummary(true);
}

function topperChanged(initialising)
{
    var value = $("input[name=topperrequired]:checked").val();

    if (value == 'y')
    {
        if (!initialising)
        {
            getStandardTopperPrice(); // so the standard price is shown that results from any defaults
        }
        $('#topper_div').show("slow");
    }
    else
    {
        $('#topper_div').hide("slow");
    }
    redisplaySummary(true);
}

function baseChanged(initialising)
{
    var value = $("input[name=baserequired]:checked").val();

    if (value == 'y')
    {
        if (!initialising)
        {
            getStandardBasePrice(); // so the standard price is shown that results from any defaults
        }
        $('#base_div').show("slow");
    }
    else
    {
        $('#base_div').hide("slow");
    }
    
    if (!initialising) {
	    getStandardLegsPrice(); // because having a base makes some legs free
    }
    redisplaySummary(true);
}

function legsChanged(initialising)
{
    var value = $("input[name=legsrequired]:checked").val();

    if (value == 'y')
    {
        if (!initialising)
        {
            getStandardLegsPrice(); // so the standard price is shown that results from any defaults
        }
        $('#legs_div').show("slow");
    }
    else
    {
        $('#legs_div').hide("slow");
    }
    redisplaySummary(true);
}

function upholsteredBaseChanged()
{
    var value = $('#upholsteredbase').val();

    if (value == 'n' || value == 'TBC')
    {
        $('#uphbase').hide("slow");
		$('#basefabricdirection').val("n");
		$('#basefabric').val("");
		$('#basefabricchoice').val("");
		$('#basefabriccost').val("");
		$('#basefabricmeters').val("");
		$('#basefabricdesc').val("");
		$('#basefabricprice').val("");
    }
    else
    {
        $('#uphbase').show("slow");
    }
}

function headboardChanged(initialising)
{
    var value = $("input[name=headboardrequired]:checked").val();

    if (value == 'y')
    {
        if (!initialising)
        {
            getStandardHeadboardPrice(); // so the standard price is shown that results from any defaults
        }
        $('#headboard_div').show("slow");
    }
    else
    {
        $('#headboard_div').hide("slow");
    }
    redisplaySummary(true);
}

function valanceChanged()
{
    var value = $("input[name=valancerequired]:checked").val();

    if (value == 'y')
    {
        $('#valance_div').show("slow");
    }
    else
    {
        $('#valance_div').hide("slow");
    }
    redisplaySummary(true);
}

function accessoriesChanged()
{
    var value = $("input[name=accessoriesrequired]:checked").val();

    if (value == 'y')
    {
        $('#accessories_div').show("slow");
    }
    else
    {
        $('#accessories_div').hide("slow");
    }
    redisplaySummary(true);
}

function deliveryChanged()
{
    var value = $("input[name=deliverycharge]:checked").val();

    if (value == 'y')
    {
        $('#delivery_div').show("slow");
    }
    else
    {
        $('#delivery_div').hide("slow");
        $('#deliveryprice').val("0.00"); // remove delivery price if delivery deselected
		$('#specialinstructionsdelivery').val("");
    }
    redisplaySummary(true);
}

function setDefaultDeliveryCharge()
{
    var country = $('#countryd').val();

    if (country == "")
        country = $('#country').val();
    country = encodeURIComponent(country);
    var postcode = $('#postcoded').val();

    if (postcode == "")
        postcode = $('#postcode').val();
    postcode = encodeURIComponent(postcode);
    var jsVatRate = $('#vatrate').val() * 1.0;

    <% if isTrade then %>
    var jsIsTrade = "y";

    <% else %>
    var jsIsTrade = "n";

    <% end if %>
    var url =
        "ajaxGetShippingCost.asp?country=" + country + "&postcode=" + postcode + "&vatrate=" + jsVatRate + "&istrade="
        + jsIsTrade + "&ts=" + (new Date()).getTime();
    //console.log("url = " + url)
    $.get(url, function(data)
    {
        $('#deliveryprice').val(data);
        $('#deliveryprice').blur();
    });
}

function setLegFinishes()
{

    var slct = $("#legstyle option:selected").val();
    var finishOptions = [];
    var heightOptions = [];
    var defaultFinishSelection = "";
    var defaultHeightSelection = "";

    if (slct == "TBC")
    {
        finishOptions.push("TBC");
        heightOptions.push("TBC");
    }
    else if (slct == "Wooden Tapered")
    {
        finishOptions.push("TBC");
        finishOptions.push("Natural Maple");
        finishOptions.push("Oak");
        finishOptions.push("Walnut");
        finishOptions.push("Ebony");
        finishOptions.push("Rosewood");
        finishOptions.push("Upholstered");
        finishOptions.push("Special (as instructions)");
        heightOptions.push("TBC");
        heightOptions.push("9.5cm/ Low");
        heightOptions.push("13.5cm/ Standard");
        heightOptions.push("17cm/ Tall");
        heightOptions.push("21cm/ Very Tall");
        heightOptions.push("Special Height");
    }
    else if (slct == "Holly")
    {
        finishOptions.push("TBC");
        finishOptions.push("Natural Maple");
        finishOptions.push("Oak");
        finishOptions.push("Ebony");
        finishOptions.push("Rosewood");
		finishOptions.push("Walnut");
        finishOptions.push("Special (as instructions)");
        defaultFinishSelection = "Rosewood";
        heightOptions.push("15cm");
        defaultHeightSelection = "15cm";
    }
     else if (slct == "Ian Leg")
    {
        heightOptions.push("15cm");
        defaultHeightSelection = "15cm";
    }
    else if (slct == "Metal")
    {
		finishOptions.push("Brass");
		finishOptions.push("Silver");
        heightOptions.push("15cm");
        defaultHeightSelection = "15cm";
    }
    else if (slct == "Manhattan")
    {
        finishOptions.push("TBC");
        finishOptions.push("Natural Maple");
        finishOptions.push("Oak");
        finishOptions.push("Ebony");
        finishOptions.push("Walnut");
        finishOptions.push("Special (as instructions)");
        defaultFinishSelection = "Ebony";
        heightOptions.push("13.5cm");
        heightOptions.push("TBC");
        heightOptions.push("9.5cm/ Low");
        heightOptions.push("17cm/ Tall");
        heightOptions.push("21cm/ Very Tall");
		heightOptions.push("Special Height");
        defaultHeightSelection = "13.5cm";
    }
    else if (slct == "Ball & Claw")
    {
        finishOptions.push("TBC");
        finishOptions.push("Silver Gilded");
        finishOptions.push("Gold Gilded");
        finishOptions.push("Special (as instructions)");
        heightOptions.push("15cm");
    }
    else if (slct == "Castors")
    {
        finishOptions.push("Brown");
        heightOptions.push("TBC");
        heightOptions.push("9.5cm/ Low");
        heightOptions.push("13.5cm/ Standard");
        heightOptions.push("17cm/ Tall");
        heightOptions.push("21cm/ Very Tall");
    }
	else if (slct == "Perspex")
    {
        finishOptions.push("Perspex");
        heightOptions.push("TBC");
        heightOptions.push("9.5cm/ Low");
        heightOptions.push("13.5cm/ Standard");
        heightOptions.push("17cm/ Tall");
        heightOptions.push("21cm/ Very Tall");
		heightOptions.push("Special Height");
    }
    else if (slct == "Georgian" || slct == "Georgian (Brass cap)" || slct == "Georgian (Chrome cap)")
    {
        finishOptions.push("Ebony");
        finishOptions.push("Walnut");
        finishOptions.push("Oak");
        finishOptions.push("Rosewood");
		finishOptions.push("Fabric Upholstered");
		finishOptions.push("Special (as instructions)");
        heightOptions.push("20cm");
    }
	  
    else if (slct == "Penelope")
    {
        finishOptions.push("Upholstered");
        heightOptions.push("15cm");
    }
	else if (slct == "Cloud")
    {
        finishOptions.push("Bronze");
        heightOptions.push("15cm");
    }
	else if (slct == "Cylindrical") {
		finishOptions.push("TBC");
		finishOptions.push("Natural");
		finishOptions.push("Oak");
		finishOptions.push("Walnut");
		finishOptions.push("Ebony");
		finishOptions.push("Rosewood");
		finishOptions.push("Special (as instructions)");
		heightOptions.push("TBC");
		heightOptions.push("9.5cm/ Low");
		heightOptions.push("13.5cm/ Standard");
		heightOptions.push("17cm/ Tall");
		heightOptions.push("21cm/ Very Tall");
		heightOptions.push("Special Height");
		defaultHeightSelection = "TBC";
	} else if (slct == "Block Leg") {
		finishOptions.push("TBC");
		finishOptions.push("Ebony");
		finishOptions.push("Oak");
		finishOptions.push("Natural Maple");
		finishOptions.push("Rosewood");
		finishOptions.push("Walnut");
		finishOptions.push("Special (as instructions)");
		heightOptions.push("3cm/Low");
		heightOptions.push("Special Height");
		}
    else if (slct == "Harlech Leg")
    {
		finishOptions.push("Black Brushed Chrome");
		finishOptions.push("Antique Brass")
        heightOptions.push("17cm");
    }
    else if (slct == "Special (as instructions)")
    {
        finishOptions.push("Special (as instructions)");
        heightOptions.push("Special Height");
    }

    $('#legfinish').find('option').remove();

    $.each(finishOptions, function(val, text)
    {
        $('#legfinish').append($('<option></option>').val(text).html(text));
    });

    if (defaultFinishSelection != "")
    {
        $("#legfinish option[value='" + defaultFinishSelection + "']").attr('selected', 'selected');
    }

    $('#legheight').find('option').remove();

    $.each(heightOptions, function(val, text)
    {
        $('#legheight').append($('<option></option>').val(text).html(text));
    });

    if (defaultHeightSelection != "")
    {
        $("#legheight option[value='" + defaultHeightSelection + "']").attr('selected', 'selected');
    }
}

function setBaseTrimColours(defaultColour) {

	var selectedTrim = $("#basetrim option:selected").val();
	var colourOptions = [];
	
	if (selectedTrim == "Standard") {
		colourOptions.push("TBC");
		colourOptions.push("Walnut");
		colourOptions.push("Ebony");
		colourOptions.push("Oak");
		colourOptions.push("Maple");
	} else if (selectedTrim == "Self Levelling") {
		colourOptions.push("TBC");
		colourOptions.push("Ebony Macassar");
		colourOptions.push("Burr Walnut");
	}
	
	$('#basetrimcolour').find('option').remove();
	
	$.each(colourOptions, function(val, text) {
		$('#basetrimcolour').append($('<option></option>').val(text).html(text));
	});
	
	if (defaultColour != "") {
		$("#basetrimcolour option[value='" + defaultColour + "']").attr('selected', 'selected');
	}
	
	if (selectedTrim == "n") {
		$('.baseTrimColourCls').hide();
	} else {
		$('.baseTrimColourCls').show();
	}
}

function showLegStylePriceField()
{
    return; // don't think this is needed
    var slct = $("#legstyle option:selected").val();

    if (slct == "Holly" || slct == "Ball & Claw" || slct == "Manhattan" || slct == "Special (as instructions)")
    {
        $('#legpricespan').show();
    }
    else
    {
        $('#legpricespan').hide();
        $('#legprice').val(''); // remove leg price if leg price field hidden
    }
}

function showFloorType()
{
    var slct = $("#legstyle option:selected").val();

    if (slct == "Castors")
    {
        $('.floortypeclass').show();
    }
    else
    {
        $('.floortypeclass').hide();
        $("#floortype option[value='TBC']").attr('selected', 'selected'); // reset floortype selection
    }
}

function setMattressTypes(defaultSelection)
{
    var slct = $("#mattresswidth option:selected").val();

    if (defaultSelection == null)
        defaultSelection = "";

    var mattressTypeOptions = [];

    if (slct == "90cm" || slct == "100cm" || slct == "105cm" || slct == "120cm" || slct == "140cm")
    {
        mattressTypeOptions.push("--");
        mattressTypeOptions.push("TBC");
        mattressTypeOptions.push("One Piece");
        localDefault = "One Piece";

        if (defaultSelection != "TBC" && defaultSelection != "One Piece")
        {
            defaultSelection = "One Piece";
        }
    }
    else
    {
        mattressTypeOptions.push("--");
        mattressTypeOptions.push("TBC");
        mattressTypeOptions.push("One Piece");
        mattressTypeOptions.push("Zipped Pair");
        mattressTypeOptions.push("Zipped Pair (Centre Only)");
    }

    $('#mattresstype').find('option').remove();
    $.each(mattressTypeOptions, function(val, text)
    {
        $('#mattresstype').append($('<option></option>').val(text).html(text));
    });

    if (defaultSelection != "")
    {
        $("#mattresstype option[value='" + defaultSelection + "']").attr('selected', 'selected');
    }
}

function setLinkPosition(defaultSelection)
    {
        if (defaultSelection == null)
            defaultSelection = "";
        var slctUpBase = $("#upholsteredbase option:selected").val();
        //console.log("slctUpBase = " + slctUpBase);
        var slctBaseType = $("#basetype option:selected").val();
        //console.log("slctBaseType = " + slctBaseType);

        var linkPositionOptions = [];
        linkPositionOptions.push("Link Underneath");

        if (slctUpBase != "Yes")
        {
            linkPositionOptions.push("Link on Ends");
        }
        linkPositionOptions.push("No Link Required");

        if (defaultSelection == "")
        {
            if (slctBaseType == "One Piece")
            {
                defaultSelection = "No Link Required";
            }
            else
            {
                defaultSelection = "Link Underneath";
            }
        }
        //console.log("defaultSelection = " + defaultSelection);

        $('#linkposition').find('option').remove();
        $.each(linkPositionOptions, function(val, text)
        {
            $('#linkposition').append($('<option></option>').val(text).html(text));
        });

        if (defaultSelection != "")
        {
            $("#linkposition option[value='" + defaultSelection + "']").attr('selected', 'selected');
        }

        linkPositionChanged();
    }

function linkPositionChanged()
    {
        var val = $("#linkposition option:selected").val();

        if (val == "No Link Required")
        {
            $('.linkfinishclass').hide();
            $("#linkfinish").val("n")
        }
        else
        {
            $('.linkfinishclass').show();
        }
    }

function defaultVentPosition()
    {
        var slct = $("#savoirmodel option:selected").val();
        var ventPositionDefault = null;

        if (slct == "No. 1" || slct == "No. 2")
        {
            ventPositionDefault = "Vents on Ends";
        }
        else if (slct == "No. 3" || slct == "No. 4")
        {
            ventPositionDefault = "Vents on Sides";
        }

        <% if not mattressLocked then %>

        if (ventPositionDefault != null)
        {
            $("#ventposition option[value='" + ventPositionDefault + "']").attr('selected', 'selected');
        }

        <% end if %>
    }

//function defaultBaseTypeFromBaseWidth()
//    {
//        var slct = $("#basewidth option:selected").val();
//        var baseTypeDefault = null;
//
//        if (slct == "90cm" || slct == "100cm" || slct == "105cm" || slct == "120cm")
//        {
//            baseTypeDefault = "One Piece";
//        }
//        else if (slct == "140cm" || slct == "160cm")
//        {
//            baseTypeDefault = "East-West Split";
//        }
//        else if (slct == "180cm" || slct == "200cm" || slct == "210cm" || slct == "240cm")
//        {
//            baseTypeDefault = "North-South Split";
//        }

        <%' if not baseLocked then %>

       // if (baseTypeDefault != null)
       // {
       //     $("#basetype option[value='" + baseTypeDefault + "']").attr('selected', 'selected');
       // }

        <%' end if %>
//    }

$('#mattressprice').blur(function()
{
    setEditPageMattressDiscountSummary();
});

$('#topperprice').blur(function()
{
    setEditPageTopperDiscountSummary();
});

$('#upholsteryprice').blur(function()
{
    redisplaySummary(true);
});

$('#basetrimprice').blur(function()
{
    redisplaySummary(true);
});

$('#basedrawersprice').blur(function()
{
    redisplaySummary(true);
});

$('#headboardprice').blur(function()
{
    setEditPageHeadboardDiscountSummary();
});

$('#headboardtrimprice').blur(function()
{
    setEditPageHeadboardTrimDiscountSummary();
});

$('#hbfabricprice').blur(function()
{
    redisplaySummary(true);
});

$('#valanceprice').blur(function()
{
    redisplaySummary(true);
});

$('#valfabricprice').blur(function()
{
    calcHBFabricPrice();
    redisplaySummary(true);
});

$('#legprice').blur(function()
{
    setEditPageLegsDiscountSummary();
});

$('#addlegprice').blur(function() {
    setEditPageAddLegsDiscountSummary();
});

$('#baseprice').blur(function()
{
    setEditPageBaseDiscountSummary();
});

$('#deliveryprice').blur(function()
{
    redisplaySummary(true);
});

$('#basefabriccost').blur(function()
{
	calcStandardBaseFabricPrice();
    redisplaySummary(true);
});

$('#basefabricmeters').blur(function()
{
    calcStandardBaseFabricPrice();
    redisplaySummary(true);
});

$('#hbfabriccost').blur(function()
{
    calcHBFabricPrice();
    redisplaySummary(true);
});

$('#hbfabricmeters').blur(function()
{
    calcHBFabricPrice();
    redisplaySummary(true);
});

$('#valfabriccost').blur(function()
{
    calcValFabricPrice();
});

$('#valfabricmeters').blur(function()
{
    calcValFabricPrice();
});

function calendarBlurHandler(ctrl)
    {
        if (ctrl.name == 'ordernote_followupdate')
        {
            $("#ordernote_action option[value='<%=ACTION_REQUIRED%>']").attr('selected', 'selected');
        }
        logChange($('#' + ctrl.name));
    }

function checkPaymentTotal()
    {
        var additionalpayment = $('#additionalpayment').val() / 1.0;
        var invno = $('#invoiceno').val();
        var outstanding = $('#OS' + invno).val() / 1.0;

        if (additionalpayment > outstanding)
        {
            alert("You have an amount greater than the amount outstanding for this invoice which is " + outstanding);
            $('#additionalpayment').val('');
        }
    }

function checkRefundTotal()
    {
        var refund = $('#refund').val() / 1.0;
        var invno = $('#invoiceno').val();
        var payments = $('#PA' + invno).val() / 1.0;
        console.log("payments=" + payments + " refund=" + refund)

        if (refund > payments)
        {
            alert("You are refunding more than has been paid for this invoice which is " + payments);
            $('#refund').val('');
        }
    }

function redisplaySummary(redoSubTotals) {
        var mattressPrice = 0.0;

        if ($("input[name=mattressrequired]:checked").val() == 'y')
        {
            mattressPrice = $('#mattressprice').val() * 1.0; // *1.0 makes sure we get a number
        }
        $('#mattressprice2span').html(getCurrSym() + mattressPrice.toFixed(2));
        $('#mattressprice2').val((mattressPrice).toFixed(2));

        var topperPrice = 0.0;

        if ($("input[name=topperrequired]:checked").val() == 'y')
        {
            topperPrice = $('#topperprice').val() * 1.0; // *1.0 makes sure we get a number
        }
        $('#topperprice2span').html(getCurrSym() + topperPrice.toFixed(2));
        $('#topperprice2').val((topperPrice).toFixed(2));

        var headboardPrice = 0.0;
        var headboardTrimPrice = 0.0;
        var hbFabricPrice = 0.0;

        if ($("input[name=headboardrequired]:checked").val() == 'y')
        {
            headboardPrice = $('#headboardprice').val() * 1.0; // *1.0 makes sure we get a number
            hbFabricPrice = $('#hbfabricprice').val() * 1.0;   // *1.0 makes sure we get a number
            headboardTrimPrice = $('#headboardtrimprice').val() * 1.0; // *1.0 makes sure we get a number
        }
        $('#headboardprice2span').html(getCurrSym() + headboardPrice.toFixed(2));
        $('#headboardprice2').val((headboardPrice).toFixed(2));
        $('#hbfabricprice2span').html(getCurrSym() + hbFabricPrice.toFixed(2));
        $('#hbfabricprice2').val((hbFabricPrice).toFixed(2));
        $('#headboardtrimprice2span').html(getCurrSym() + headboardTrimPrice.toFixed(2));
        $('#headboardtrimprice2').val((headboardTrimPrice).toFixed(2));

        var valancePrice = 0.0;
        var valFabricPrice = 0.0;

        if ($("input[name=valancerequired]:checked").val() == 'y')
        {
            valancePrice = $('#valanceprice').val() * 1.0;     // *1.0 makes sure we get a number
            valFabricPrice = $('#valfabricprice').val() * 1.0; // *1.0 makes sure we get a number
        }
        $('#valanceprice2span').html(getCurrSym() + valancePrice.toFixed(2));
        $('#valanceprice2').val((valancePrice).toFixed(2));
        $('#valfabricprice2span').html(getCurrSym() + valFabricPrice.toFixed(2));
        $('#valfabricprice2').val((valFabricPrice).toFixed(2));

        var basePrice = 0.0;
        var upholsteryPrice = 0.0;
        var baseFabricPrice = 0.0;
        var baseTrimPrice = 0.0;
        var baseDrawersPrice = 0.0;

        if ($("input[name=baserequired]:checked").val() == 'y')
        {
            basePrice = $('#baseprice').val() * 1.0;             // *1.0 makes sure we get a number
            upholsteryPrice = $('#upholsteryprice').val() * 1.0; // *1.0 makes sure we get a number
            baseFabricPrice = $('#basefabricprice').val() * 1.0; // *1.0 makes sure we get a number
            baseTrimPrice = $('#basetrimprice').val() * 1.0; // *1.0 makes sure we get a number
            baseDrawersPrice = $('#basedrawersprice').val() * 1.0; // *1.0 makes sure we get a number
        }
        $('#baseprice2span').html(getCurrSym() + basePrice.toFixed(2));
        $('#baseprice2').val((basePrice).toFixed(2));
        $('#upholsteryprice2span').html(getCurrSym() + upholsteryPrice.toFixed(2));
        $('#upholsteryprice2').val((upholsteryPrice).toFixed(2));
        $('#basefabricprice2span').html(getCurrSym() + baseFabricPrice.toFixed(2));
        $('#basefabricprice2').val((baseFabricPrice).toFixed(2));
        $('#basetrimprice2span').html(getCurrSym() + baseTrimPrice.toFixed(2));
        $('#basetrimprice2').val((baseTrimPrice).toFixed(2));
        $('#basedrawersprice2span').html(getCurrSym() + baseDrawersPrice.toFixed(2));
        $('#basedrawersprice2').val((baseDrawersPrice).toFixed(2));

        var legPrice = 0.0;
		var addLegPrice = 0.0;

        if ($("input[name=legsrequired]:checked").val() == 'y')
        {
            legPrice = $('#legprice').val() * 1.0; // *1.0 makes sure we get a number
			addLegPrice = $('#addlegprice').val()*1.0; // *1.0 makes sure we get a number
        }
        $('#legprice2span').html(getCurrSym() + legPrice.toFixed(2));
        $('#legprice2').val((legPrice).toFixed(2));

		$('#addlegprice2span').html(getCurrSym() + addLegPrice.toFixed(2));
		$('#addlegprice2').val((addLegPrice).toFixed(2));

        var accessoriesTotalCost = 0.0;

        if ($("input[name=accessoriesrequired]:checked").val() == 'y')
        {
            accessoriesTotalCost = $('#accessoriestotalcost').val() * 1.0; // *1.0 makes sure we get a number
        }

        var bedsetTotal =
            mattressPrice + topperPrice + upholsteryPrice + baseFabricPrice + baseTrimPrice + baseDrawersPrice + headboardPrice + headboardTrimPrice + valancePrice + legPrice + addLegPrice
                + basePrice + hbFabricPrice + valFabricPrice + accessoriesTotalCost;
        $('#bedsettotalspan').html(getCurrSym() + bedsetTotal.toFixed(2));
        $('#bedsettotal').val((bedsetTotal).toFixed(2));

        var deliveryPrice = $('#deliveryprice').val() * 1.0; // *1.0 makes sure we get a number
        $('#deliveryprice2span').html(getCurrSym() + deliveryPrice.toFixed(2));
        $('#deliveryprice2').val((deliveryPrice).toFixed(2));

        // now redo the totals
        if (redoSubTotals)
        {
            calcSubtotal();
        }
    }

function calcStandardBaseFabricPrice() {
        var basefabriccost = $('#basefabriccost').val() * 1.0
        var basefabricmeters = $('#basefabricmeters').val() * 1.0
	standardBaseFabricPrice = basefabriccost * basefabricmeters;
	$('#standardbasefabricprice').val((standardBaseFabricPrice).toFixed(2));
	$('#standardbasefabricpricespan').html(standardBaseFabricPrice.toFixed(2));
	setBaseFabricPrice();
    }

function calcHBFabricPrice()
    {
        var hbfabriccost = $('#hbfabriccost').val() * 1.0
        var hbfabricmeters = $('#hbfabricmeters').val() * 1.0
        var hbFabricPrice = hbfabriccost * hbfabricmeters;
        $('#hbfabricprice').val((hbFabricPrice).toFixed(2));
        calcTotalHeadboardPrice();
    }

function calcValFabricPrice()
    {
        var valfabriccost = $('#valfabriccost').val() * 1.0
        var valfabricmeters = $('#valfabricmeters').val() * 1.0
        var valFabricPrice = valfabriccost * valfabricmeters;
        $('#valfabricprice').val((valFabricPrice).toFixed(2));
    }

function hideDiscountFields()
    {
        hideDiscountFieldByName('mattress');
        hideDiscountFieldByName('topper');
        hideDiscountFieldByName('base');
        hideDiscountFieldByName('legs');
        hideDiscountFieldByName('headboard');
    }

function hideDiscountFieldByName(compName)
    {
        if (($('#standard' + compName + 'price').val() / 1.0) == 0.0)
        {
            $('.' + compName + 'discountcls').hide();
            $('.' + compName + 'discountcls_dummy').show();
        }
        else
        {
            $('.' + compName + 'discountcls').show();
            $('.' + compName + 'discountcls_dummy').hide();
        }
    }

function showtickingoptions() {
    
    var selection = $("#savoirmodel").val();
    if (selection == "No. 4v") {
    
    $("#tickingoptions option[value='n']").hide();
    $("#tickingoptions option[value='TBC']").hide();
    $("#tickingoptions option[value='White Trellis']").hide();
    $("#tickingoptions option[value='Silver Trellis']").hide();
    $("#tickingoptions option[value='Grey Trellis']").attr('selected', 'selected');
    //$('#mattressinstructions').val('Vegan Bed - Vegan materials to be used');
    //mattressTickingSelected();
    //defaultTopperTickingOptions();
    //defaultBaseTickingOptions();
    } else {
    $("#tickingoptions option[value='n']").show();
    $("#tickingoptions option[value='TBC']").show();
    $("#tickingoptions option[value='White Trellis']").show();
    $("#tickingoptions option[value='Silver Trellis']").show();
    $("#tickingoptions option[value='Grey Trellis']").show();
    //$('#mattressinstructions').val('');
    }
    
}
function showtoppertickingoptions() {
    
    var selection = $("#toppertype").val();
    if (selection == "CFv Topper") {
    
    $("#toppertickingoptions option[value='n']").hide();
    $("#toppertickingoptions option[value='TBC']").hide();
    $("#toppertickingoptions option[value='White Trellis']").hide();
    $("#toppertickingoptions option[value='Silver Trellis']").hide();
    $("#toppertickingoptions option[value='Grey Trellis']").attr('selected', 'selected');
    //$('#specialinstructionstopper').val('Vegan Bed - Vegan materials to be used');
    //mattressTickingSelected();
    //defaultTopperTickingOptions();
    //defaultBaseTickingOptions();
    } else {
    $("#toppertickingoptions option[value='n']").show();
    $("#toppertickingoptions option[value='TBC']").show();
    $("#toppertickingoptions option[value='White Trellis']").show();
    $("#toppertickingoptions option[value='Silver Trellis']").show();
    $("#toppertickingoptions option[value='Grey Trellis']").show();
    //$('#specialinstructionstopper').val('');
    }
    
}
function showbasetickingoptions() {
    
    var selection = $("#basesavoirmodel").val();
    if (selection == "No. 4v") {
    
    $("#basetickingoptions option[value='n']").hide();
    $("#basetickingoptions option[value='TBC']").hide();
    $("#basetickingoptions option[value='White Trellis']").hide();
    $("#basetickingoptions option[value='Silver Trellis']").hide();
    $("#basetickingoptions option[value='Grey Trellis']").attr('selected', 'selected');
    //$('#specialinstructions2').val('Vegan Bed - Vegan materials to be used');
    //mattressTickingSelected();
    //defaultTopperTickingOptions();
    //defaultBaseTickingOptions();
    } else {
    $("#basetickingoptions option[value='n']").show();
    $("#basetickingoptions option[value='TBC']").show();
    $("#basetickingoptions option[value='White Trellis']").show();
    $("#basetickingoptions option[value='Silver Trellis']").show();
    $("#basetickingoptions option[value='Grey Trellis']").show();
    //$('#specialinstructions2').val('');
    }
    
}

function getCurrSym()
    {
        return '<%=getCurrencySymbolForCurrency(orderCurrency)%>';
    }

// JS for totals
$('#dcresult').blur(function()
{
    calcSubtotal();
});

$('#dc').change(function()
{
    calcSubtotal();
});

$('#dc2').change(function()
{
    calcSubtotal();
});

$('#deliveryprice').blur(function()
{
    setTotal();
});

$('#vatrate').change(function()
{
    setTotal();
});

function calcSubtotal()
    {
        var percent = $('#dc').is(':checked');
        var discount = $('#dcresult').val() / 1.0; // this makes sure we get a number
        var bedsettotal = $('#bedsettotal').val();

        if (discount > 0.0)
        {
            var subtotal;

            if (percent)
            {
                subtotal = bedsettotal * (1.0 - discount / 100.0);
            }
            else
            {
                subtotal = bedsettotal - discount;
            }
            $('#subtotalspan').html(getCurrSym() + subtotal.toFixed(2));
            $('#subtotal').val(subtotal.toFixed(2));
        }
        else
        {
            $('#subtotalspan').html(getCurrSym() + (bedsettotal * 1.0).toFixed(2));
            $('#subtotal').val((bedsettotal * 1.0).toFixed(2));
        }
        setTotal();
    }

function setTotal()
    {
        var deliveryPrice = $('#deliveryprice' ).val() * 1.0;
        var total = $('#subtotal').val() * 1.0;
        <% if isTrade then %>
        var jsIsTrade = true;
        var jsTradeDiscountRate = <%=tradeDiscountRate%>;
        <% else %>
        var jsIsTrade = false;
        <% end if %>
        var jsVatRate = $('#vatrate').val() * 1.0;
        var jsDelIncVat = true;
        <% if deliveryIncludesVat = "n" then %>
            jsDelIncVat = false;
        <% end if %>

        if (jsIsTrade)
        {
            if (jsTradeDiscountRate > 0)
            {
                var tradeDiscount = total * jsTradeDiscountRate / 100.0;
                total = total - tradeDiscount;
                $('#tradediscountspan').html(getCurrSym() + tradeDiscount.toFixed(2));
                $('#tradediscount').val((tradeDiscount).toFixed(2));
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
                
        $('#totalexvatspan').html(getCurrSym() + totalExVat.toFixed(2));
        $('#totalexvat').val((totalExVat).toFixed(2));
        $('#vatspan').html(getCurrSym() + vat.toFixed(2));
        $('#vat').val((vat).toFixed(2));
        $('#totalspan').html(getCurrSym() + total.toFixed(2));
        $('#total').val((total).toFixed(2));
        setOutstanding();
    }
        
$('#additionalpayment').blur(function()
{
    var paymentsum = 0.0;

    if ($('#paymentsum').length > 0)
    {
        paymentsum = $('#paymentsum').val() / 1.0; // this makes sure we get a number
    }
    var outstandingBeforeNewPaymentsAndRefunds = $('#total').val() * 1.0 - paymentsum;
    //console.log("paymentsum = " + paymentsum);
    //console.log("outstandingBeforeNewPaymentsAndRefunds = " + outstandingBeforeNewPaymentsAndRefunds);

    var additionalPayment = $('#additionalpayment').val() / 1.0; // this makes sure we get a number

    if (additionalPayment > outstandingBeforeNewPaymentsAndRefunds)
    {
        $('#additionalpayment').val(outstandingBeforeNewPaymentsAndRefunds.toFixed(2));
    }
    setOutstanding();
});

$('#refund').blur(function()
{
    var paymentsum = $('#paymentsum').val() * 1.0;
    var refund = $('#refund').val() / 1.0; // this makes sure we get a number

    if (refund > paymentsum)
    {
        $('#refund').val(paymentsum.toFixed(2));
    }
    setOutstanding();
});

function setOutstanding()
    {
        var additionalPayment = 0.0;

        if ($('#additionalpayment').length > 0)
        {
            additionalPayment = $('#additionalpayment').val() / 1.0; // this makes sure we get a number
        }
        var refund = 0.0;

        if ($('#refund').length > 0)
        {
            refund = $('#refund').val() / 1.0; // this makes sure we get a number
        }
        var paymentsum = 0.0;

        if ($('#paymentsum').length > 0)
        {
            paymentsum = $('#paymentsum').val() / 1.0; // this makes sure we get a number
        }
        var outstanding = $('#total').val() * 1.0 - paymentsum - additionalPayment + refund;
        $('#outstandingspan').html(getCurrSym() + outstanding.toFixed(2));
        $('#outstanding').val(outstanding.toFixed(2));
    }

// accessories stuff
for (var i = 1; i < 21; i++)
{
    $('#acc_unitprice' + i).blur(function()
    {
        calcAccessoriesTotal();
        showNextAccessoriesRow();
        redisplaySummary(true);
    });
	$('#acc_wholesalePrice' + i).change(function()
    {
        calcAccessoriesTotal();
        showNextAccessoriesRow();
        redisplaySummary(true);
    });
    $('#acc_qty' + i).change(function()
    {
        calcAccessoriesTotal();
        redisplaySummary(true);
    });
    $('#acc_desc' + i).change(function()
    {
        showNextAccessoriesRow();
    });
}

calcAccessoriesTotal();
showNextAccessoriesRow();

function calcAccessoriesTotal()
{
    var total = 0.0;
	var Wtotal = 0.0;

    for (var i = 1; i < 21; i++)
    {
        total += $('#acc_unitprice' + i).val() * $('#acc_qty' + i).val() * 1.0;
		Wtotal += $('#acc_wholesalePrice' + i).val() * $('#acc_qty' + i).val() * 1.0;
    }
    $('#accessories_total').html(getCurrSym() + total.toFixed(2));
	$('#Waccessories_total').html(getCurrSym() + Wtotal.toFixed(2));
    $('#accessoriestotalcost2span').html(getCurrSym() + total.toFixed(2));
    $('#accessoriestotalcost').val(total.toFixed(2));
	$('#Waccessoriestotalcost2span').html(getCurrSym() + Wtotal.toFixed(2));
    $('#Waccessoriestotalcost').val(Wtotal.toFixed(2));
}

function showNextAccessoriesRow()
{
    for (var i = 1; i < 20; i++)
    {
        var ii = i + 1;

        if ($('#acc_desc' + i).val() == "")
        {
            $('#acc_row' + ii).hide();
        }
        else
        {
            $('#acc_row' + ii).show();
        }
    }
}

showHideDiscounts($('#dcresult').val() != "");

function showHideDiscounts(show)
{
    if (show)
    {
        $('#dceditdiv').hide();
        $('#dcremovediv').show();
        $('#dcdiv').show();
    }
    else
    {
        $('#dcresult').val('');
        $('#dcresult').blur();
        $('#dcremovediv').hide();
        $('#dcdiv').hide();
        $('#dceditdiv').show();
    }
}

function copyInvToDelAddr()
{
    $('#add1d').val($('#add1').val());
    $('#add2d').val($('#add2').val());
    $('#add3d').val($('#add3').val());
    $('#townd').val($('#town').val());
    $('#countyd').val($('#county').val());
    $('#postcoded').val($('#postcode').val());
    $('#countryd').val($('#country').val());
}

function populateDelAdd()
{
    var delAddrId = $("#deladddropdown option:selected").val();
    var url = "ajaxGetDeliveryAddress.asp?id=" + delAddrId + "&ts=" + (new Date()).getTime();
    $.get(url, function(data)
    {
        if (data != "")
        {
            var vals = data.split('~');
            $('#add1d').val(vals[0]);
            $('#add2d').val(vals[1]);
            $('#add3d').val(vals[2]);
            $('#townd').val(vals[3]);
            $('#countyd').val(vals[4]);
            $('#postcoded').val(vals[5]);
            $('#countryd').val(vals[6]);
            $('#delphone1').val(vals[7]);
            $('#delphone2').val(vals[8]);
            $('#delphone3').val(vals[9]);
            $('#delphonetype1').val(vals[10]);
            $('#delphonetype2').val(vals[11]);
            $('#delphonetype3').val(vals[12]);
        }
    });
}

$('#form1 input').change(function()
{
    logChange($(this));
});

$('#form1 select').change(function()
{
    logChange($(this));
});

$('#form1 textarea').change(function()
{
    logChange($(this));
});

function logChange(elmnt)
{
    var changedElement = elmnt.attr('name');
    //console.log(changedElement);
    var emailRequired = (changedElement != "additionalpayment" && changedElement != "invoicedate"
        && changedElement != "invoiceno" && changedElement != "paymentmethod" && changedElement != "creditdetails"
        && changedElement != "refund" && changedElement != "refundmethod" && changedElement != "bookeddeliverydate"
        && changedElement != "add1d" && changedElement != "add2d" && changedElement != "add3d"
        && changedElement != "townd" && changedElement != "countyd" && changedElement != "postcoded"
        && changedElement != "countryd" && changedElement != "delphonetype1" && changedElement != "delphone1"
        && changedElement != "delphonetype2" && changedElement != "delphone2" && changedElement != "delphonetype3"
        && changedElement != "delphone3" && changedElement != "deldate" && changedElement != "reference"
        && changedElement != "clientstitle" && changedElement != "clientsfirst" && changedElement != "clientssurname"
        && changedElement != "tel" && changedElement != "telwork" && changedElement != "mobile"
        && changedElement != "email_address" && changedElement != "acknowdate" && changedElement != "add1"
        && changedElement != "add2" && changedElement != "add3" && changedElement != "town"
        && changedElement != "county" && changedElement != "country" && changedElement != "postcode"
        && changedElement != "companyname" && changedElement != "acknowversion" && changedElement != "productiondate"
        && changedElement != "bookeddeliverydate" && changedElement != "ordernote_notetext"
        && changedElement != "ordernote_followupdate" && changedElement != "ordernote_action"
        && changedElement != "accesscheck" && changedElement != "oldbed"
        && changedElement != "specialinstructionsdelivery" && changedElement != "deliveryprice"
        && changedElement != "productiondate");

    //console.log("emailRequired=" + emailRequired);
    if (emailRequired)
    {
        $('#amendmentemailrequired').val("1");
    }

    // record if each component has been changed by the user
    recordMattressChanged(elmnt);

    if (changedElement != 'basefabricdirection' && changedElement != 'basefabric'
        && changedElement != 'basefabricchoice' && changedElement != 'basefabriccost'
        && changedElement != 'basefabricmeters' && changedElement != 'basefabricprice'
        && changedElement != 'basefabricdesc' && changedElement != 'upholsteryprice'
        && changedElement != 'basetrimprice' && changedElement != 'basedrawersprice')
    {
        // only log base changed (& thus re-open the base) if it's something other than the base fabric that's changed
        recordBaseChanged(elmnt);
    //console.log("recordBaseChanged");
    }

    recordTopperChanged(elmnt);
    recordValanceChanged(elmnt);
    recordLegsChanged(elmnt);

    if (changedElement != 'headboardfabric' && changedElement != 'headboardfabricchoice'
        && changedElement != 'hbfabricoptions' && changedElement != 'headboardfabricdirection'
        && changedElement != 'hbfabriccost' && changedElement != 'hbfabricmeters' && changedElement != 'hbfabricprice'
        && changedElement != 'headboardfabricdesc')
    {
        // only log headboard changed (& thus re-open the base) if it's something other than the fabric that's changed
        recordHeadboardChanged(elmnt);
    }

    recordAccessoriesChanged(elmnt);
}

function paymentMethodChanged()
{
    var selection = $("#paymentmethod").val();

    if (selection == "7")
    { // Customer Credit
        showHideCreditDetails(true);
    }
    else
    {
        showHideCreditDetails(false);
        $("#creditdetails").val("");
    }
}

function showHideCreditDetails(show)
{
    if (show)
    {
        $('#creditdetails').show();
        $('#creditdetailsheader').show();
    }
    else
    {
        $('#creditdetails').hide();
        $('#creditdetailsheader').hide();
    }
}

function showHideNotesHistory()
{
    $('#ordernotehistory').toggle();
}

function disableComponentSections()
{
    // mattress status
    <% if mattressLocked then %>
    $('#mattressrequired_y').attr('disabled', true);
    $('#mattressrequired_n').attr('disabled', true);
    $('#mattress_div :input').attr('disabled', true);
    $('#mattress_div :input').css('color', '<%=getLockColourForStatus(getComponentStatus(con, order, 1))%>');
	$('.showWholesale :input').attr('disabled', false);
    <% end if %>

    // topper
    <% if topperLocked then %>
    $('#topperrequired_y').attr('disabled', true);
    $('#topperrequired_n').attr('disabled', true);
    $('#topper_div :input').attr('disabled', true);
    $('#topper_div :input').css('color', '<%=getLockColourForStatus(getComponentStatus(con, order, 5))%>');
	$('.showWholesale :input').attr('disabled', false);
    <% end if %>

    // base
    <% if baseLocked then %>
    $('#baserequired_y').attr('disabled', true);
    $('#baserequired_n').attr('disabled', true);
    $('#base_span1 :input').attr('disabled', true);
    $('#base_span1 :input').css('color', '<%=getLockColourForStatus(getComponentStatus(con, order, 3))%>');
	$('.showWholesale :input').attr('disabled', false);
    <% end if %>

    <% if baseFabricLocked then %>
    $('#base_span2 :input').attr('disabled', true);
    $('#base_span2 :input').css('color', '<%=getLockColourForStatus(getComponentStatus(con, order, 3))%>');
	$('.showWholesale :input').attr('disabled', false);
    <% end if %>

    // legs
    <% if legsLocked then %>
    $('#legsrequired_y').attr('disabled', true);
    $('#legsrequired_n').attr('disabled', true);
    $('#legs_div :input').attr('disabled', true);
    $('#legs_div :input').css('color', '<%=getLockColourForStatus(getComponentStatus(con, order, 7))%>');
	$('.showWholesale :input').attr('disabled', false);
	$('#Wlegsprice').prop('disabled', false);
    <% end if %>

    // headboard
    <% if headboardLocked then %>
    $('#headboardrequired_y').attr('disabled', true);
    $('#headboardrequired_n').attr('disabled', true);
    var lockColour = '<%=getLockColourForStatus(getComponentStatus(con, order, 8))%>';
    $('#headboardstyle').attr('disabled', true);
    $('#headboardstyle').css('color', lockColour);
    $('#headboardheight').attr('disabled', true);
    $('#headboardheight').css('color', lockColour);
    $('#headboardfinish').attr('disabled', true);
    $('#headboardfinish').css('color', lockColour);
	$('#headboardwidth').attr('disabled', true);
    $('#headboardwidth').css('color', lockColour);
    $('#hblegs').attr('disabled', true);
    $('#hblegs').css('color', lockColour);
    $('#specialinstructions3').attr('disabled', true);
    $('#specialinstructions3').css('color', lockColour);
    $('#headboardprice').attr('disabled', true);
    $('#headboardprice').css('color', lockColour);
    $('#headboardtrimprice').attr('disabled', true);
    $('#headboardtrimprice').css('color', lockColour);
	$('.showWholesale :input').attr('disabled', false);
    <% end if %>

    <% if headboardFabricLocked then %>
    var lockColour = '<%=getLockColourForStatus(getComponentStatus(con, order, 8))%>';
    $('#headboardfabric').attr('disabled', true);
    $('#headboardfabric').css('color', lockColour);
    $('#headboardfabricchoice').attr('disabled', true);
    $('#headboardfabricchoice').css('color', lockColour);
    $('#hbfabricoptions').attr('disabled', true);
    $('#hbfabricoptions').css('color', lockColour);
    $('#headboardfabricdirection').attr('disabled', true);
    $('#headboardfabricdirection').css('color', lockColour);
    $('#hbfabriccost').attr('disabled', true);
    $('#hbfabriccost').css('color', lockColour);
    $('#hbfabricmeters').attr('disabled', true);
    $('#hbfabricmeters').css('color', lockColour);
    $('#hbfabricprice').attr('disabled', true);
    $('#hbfabricprice').css('color', lockColour);
    $('#headboardfabricdesc').attr('disabled', true);
    $('#headboardfabricdesc').css('color', lockColour);
	$('.showWholesale :input').attr('disabled', false);
    <% end if %>

    // valance
    <% if valanceLocked then %>
    $('#valancerequired_y').attr('disabled', true);
    $('#valancerequired_n').attr('disabled', true);
    $('#valance_div :input').attr('disabled', true);
    $('#valance_div :input').css('color', '<%=getLockColourForStatus(getComponentStatus(con, order, 6))%>');
	$('.showWholesale :input').attr('disabled', false);
    <% end if %>

    // accessories
    <% if accessoriesLocked then %>
    $('#accessoriesrequired_y').attr('disabled', true);
    $('#accessoriesrequired_n').attr('disabled', true);
    $('#accessories_div :input').attr('disabled', true);
    $('#accessories_div :input').css('color', '<%=getLockColourForStatus(getComponentStatus(con, order, 9))%>');
	$('.showWholesale :input').attr('disabled', false);
    <% end if %>
}

function enableComponentSections()
{
    // mattress status
    $('#mattressrequired_y').attr('disabled', false);
    $('#mattressrequired_n').attr('disabled', false);
    $('#mattress_div :input').attr('disabled', false);

    // topper
    $('#topperrequired_y').attr('disabled', false);
    $('#topperrequired_n').attr('disabled', false);
    $('#topper_div :input').attr('disabled', false);

    // base
    $('#baserequired_y').attr('disabled', false);
    $('#baserequired_n').attr('disabled', false);
    $('#base_span1 :input').attr('disabled', false);
    $('#base_span2 :input').attr('disabled', false);

    // legs
    $('#legsrequired_y').attr('disabled', false);
    $('#legsrequired_n').attr('disabled', false);
    $('#legs_div :input').attr('disabled', false);

    // headboard
    $('#headboardrequired_y').attr('disabled', false);
    $('#headboardrequired_n').attr('disabled', false);
    $('#headboardstyle').attr('disabled', false);
	$('#headboardwidth').attr('disabled', false);
    $('#headboardheight').attr('disabled', false);
    $('#headboardfinish').attr('disabled', false);
    $('#hblegs').attr('disabled', false);
    $('#specialinstructions3').attr('disabled', false);
    $('#headboardprice').attr('disabled', false);
    $('#headboardtrimprice').attr('disabled', false);
    $('#headboardfabric').attr('disabled', false);
    $('#headboardfabricchoice').attr('disabled', false);
    $('#hbfabricoptions').attr('disabled', false);
    $('#headboardfabricdirection').attr('disabled', false);
    $('#hbfabriccost').attr('disabled', false);
    $('#hbfabricmeters').attr('disabled', false);
    $('#hbfabricprice').attr('disabled', false);
    $('#headboardfabricdesc').attr('disabled', false);

    // valance
    $('#valancerequired_y').attr('disabled', false);
    $('#valancerequired_n').attr('disabled', false);
    $('#valance_div :input').attr('disabled', false);

    // accessories
    $('#accessoriesrequired_y').attr('disabled', false);
    $('#accessoriesrequired_n').attr('disabled', false);
    $('#accessories_div :input').attr('disabled', false);
}

function formSubmitHandler(theForm)
{
    var valid = FrontPage_Form1_Validator(theForm);

    if (!valid)
        return false;

    enableComponentSections();
    OnSubmitForm();
    return true;
}
</script>
<script language = "Javascript">
/**
 * DHTML textbox character counter script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
 */

maxL=250;
var bName = navigator.appName;
function taLimit(taObj) {
	if (taObj.value.length==maxL) return false;
	return true;
}

function taCount(taObj,Cnt) { 
	objCnt=createObject(Cnt);
	objVal=taObj.value;
	if (objVal.length <= maxL) {
		/// make sure they can't go beyond 250 chars
		$('#' + taObj.name).attr('maxlength', maxL);
	}
	if (objCnt) {
		if(bName == "Netscape"){	
			objCnt.textContent=maxL-objVal.length;}
		else{objCnt.innerText=maxL-objVal.length;}
	}
	return true;
}
function createObject(objId) {
	if (document.getElementById) return document.getElementById(objId);
	else if (document.layers) return eval("document." + objId);
	else if (document.all) return eval("document.all." + objId);
	else return eval("document." + objId);
}

function getPanelContent(contactno, panelId) {
	var divId = "panel1";
    var url = "searchresults-onecustomer-orderdetails.asp?contactno=" + contactno + "&pno=" + <%=order%> + "&pg=e&ts=" + (new Date()).getTime();
    console.log(url);pn
    $('#' + divId).load(url);
	$('#' + divId).show("slow");
	$('#minus1').show();
	$('#plus1').hide();
}
function closePanel(contactno, panelId) {
	var divId = "panel1";
	$('#' + divId).hide("slow");
	$('#minus1').hide();
	$('#plus1').show();
}

function mattressvegantext() {
    
    var selection = $("#savoirmodel").val();
    if (selection == "No. 4v") {
    	$('#mattressinstructions').val('Vegan Bed - Vegan materials to be used. ' + $('#mattressinstructions').val());
    }
}

function toppervegantext() {
    
    var selection = $("#toppertype").val();
    if (selection == "CFv Topper") {
    	$('#specialinstructionstopper').val('Vegan Bed - Vegan materials to be used. ' + $('#specialinstructionstopper').val());
    }
}

function basevegantext() {
    
    var selection = $("#basesavoirmodel").val();
    
    if (selection == "No. 4v") {
     	$('#specialinstructions2').val('Vegan Bed - Vegan materials to be used,' + $('#specialinstructions2').val());
    }
    
}
</script>
<script src = "edit-purchase-funcs.js?date=<%=theDate%>">
</script>
<%
rs.close
set rs = nothing
rs1.close
set rs1 = nothing
rs2.close
set rs2 = nothing
                    

                    function getOrderType(byref ars)
                        dim ars2
                        if isnull(ars("ordertype") ) or ars("ordertype") = "" then
                            getOrderType = "Unknown"
                        else
                            Set ars2 = getMysqlUpdateRecordSet("Select * from ORDERTYPE where ordertypeid=" & ars("ordertype"), con)
                            getOrderType = ars2("ordertype")
                            ars2.close
                            set ars2 = nothing
                        end if
                    end function

                    Con.Close
                    Set Con = Nothing

                    function capitalise(str)
                        dim words, word
                        if isNull(str) or trim(str) = "" then
                            capitalise = ""
                        else
                            words = split(trim(str), " ")
                            for each word in words
                                word = lcase(word)
                                if len(word) > 0 then
                                    word = ucase(left(word, 1) ) & (right(word, len(word) -1) )
                                    capitalise = capitalise & word & " "
                                end if
                            next
                            capitalise = left(capitalise, len(capitalise) -1)
                        end if
                    end function

                    function getLockColourForStatus(aStatus)

                        if aStatus = 20 then
                            getLockColourForStatus = "red"    'In Production
                        elseif aStatus = 30 then
                            getLockColourForStatus = "orange" ' Order on Stock, Waiting QC
                        elseif aStatus = 40 then
                            getLockColourForStatus = "green"  ' QC Checked
                        elseif aStatus = 50 then
                            getLockColourForStatus = "green"  ' In Bay
                        elseif aStatus = 60 then
                            getLockColourForStatus = "green"  ' Order Picked
                        elseif aStatus = 70 then
                            getLockColourForStatus = "grey"   ' Delivered
                        else
                            getLockColourForStatus = ""
                        end if
                    end function
%>
<!-- #include file="common/logger-out.inc" -->
