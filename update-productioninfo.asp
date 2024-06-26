<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,REGIONAL_ADMINISTRATOR,ORDERDETAILS_VIEWER"
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
<!-- #include file="emailfuncs.asp" -->
<%Dim custcode, orderstatus, firelabel, postcode, accountcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, legprice, baseprice, upholsteredbase, upholsteryprice, valancerequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, orderdate, reference, companyname, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, headboardfinish, manhattantrim, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, contact_no, msg, jsmsg, url, signature, custname, dctype, subtotal, dcresult, outstanding, addrCoName
dim basefabriccost, basefabricmeters, basefabricprice, hbfabriccost, hbfabricmeters, hbfabricprice, valfabriccost, valfabricmeters, valfabricprice, paymentmethod, creditdetails, refundmethod, quote, otype, basefabricdesc, headboardfabricdesc, paymentstotal, valancefabricdesc, accesscheck, extbase, readonly, productiondate
dim i, acc_desc, acc_unitprice, acc_qty, acc_id, accessoriesrequired, accessoriestotalcost, company, orderCurrency, locationname
Dim objMail, aRecipients, contact, isTrade, totalExVat, vat, vatRate, tradeDiscountRate, tradeDiscount, basefabricdirection, headboardfabricdirection, valancefabricdirection, bookeddeliverydate, acknowdate, acknowversion, isamendment, rs4, deldate1, showroomname, tel, telwork, mobile, email_address, oldbed, deliveredon
dim delDateValues(), delDateDescriptions()
Dim paymentmethodname, refundmethodname, amendmentemailrequired
Dim  accountsmsg, accountsubject, redirectUrl, paymentEmailCC
dim ordernote_notetext, ordernote_followupdate, ordernote_action, ordernote_id
dim delphonetype1, delphonetype2, delphonetype3, delphone1, delphone2, delphone3, purchaseno
dim mattressmadeat, mattressstatus, mattcut, mattmachined, springunitdate, mattfinished, tickingbatchno, mattmadeby, mattbcwexpected, mattbcwwarehouse, mattdeldate
Dim boxcut, boxframe, baseprepped, boxmachined, boxtickingbatchno, basemadeby, basefinished, basebcwexpected, basebcwwarehouse, basestatus, basedeldate, basefabricstatus, basesupplier, baseponumber, basepodate,basefabricexpecteddate, basefabricrecdate, basecuttingsent, baseconfirmeddate, basetobcwdate, basefabricqty, basemadeat,basefrTreatingSent, basefrTreatingReceived
Dim matbay, basebay, topperbay, valancebay, legsbay, headboardbay, accessoriesbay
Dim toppercut, toppermachined, toppermadeat, topperstatus, topperbcwexpected, topperbcwwarehouse, topperdeldate, topperfinished, toppertickingbatchno, toppermadeby
dim headboardframe, headboardframechecked, headboardprepped, headboardpreppedchecked, headboardframedchecked, headboardfinished, headboardbcwexpected, headboardbcwwarehouse, headboarddeldate, headboardsupplier, headboardponumber, headboardpodate, headboardfabricexpecteddate, headboardfabricrecdate, headboardcuttingsent, headboardconfirmeddate, headboardtobcwdate, headboardfabricprice, headboardfabricqty, headboardfabricstatus, headboardmadeat, headboardstatus, headboarddetails, frTreatingSent, frTreatingReceived
dim valanceframe, valanceframechecked, valanceprepped, valancepreppedchecked, valanceframedchecked, valancefinished, valancebcwexpected, valancebcwwarehouse, valancedeldate, valancesupplier, valanceponumber, valancepodate, valancefabricexpecteddate, valancefabricrecdate, valancecuttingsent, valanceconfirmeddate, valancetobcwdate, valancefabricprice, valancefabricqty, valancefabricstatus, valancemadeat, valancestatus, valancedetails, sendtosddate, valancelength, valancewidth, valancedrop, valancefrTreatingSent, valancefrTreatingReceived
Dim legsrequired, legschecked, legsfinished, legsfinishedcheck, legsmadeat, legsbcwexpected, legsbcwwarehouse, legsdeldate, legsstatus
Dim  accessoriesbcwexpected, accessoriesbcwwarehouse, accessoriesdeldate, accessoriesstatus, accessoryfabricstatus, accessoryporaised, accessorypackeddate
Dim matt1width, matt2width, matt1length, matt2length, base1width, base2width, base1length, base2length, topper1width, topper1length, totalbasefabricprice, accessoryqtyfollow, acc_supplier, acc_ponumber, acc_podate, acc_eta, acc_received, acc_checked, acc_special, acc_qtyfollow,acc_delivered, acc_status, acc_width, acc_length, acc_height, acc_weight, acc_packedwith,  wrappingtype, legqty, addlegs, headboardlegsmadeat, hblegs, hblegheight
dim currentCompId, newRowRequired, historyRowId, statusChangeIsPermitted, complete
dim basefabemail, valancefabemail, headboardfabemail, fabricmsg, emailsubject, baseemailto, hbemailto, valemailto, baseemailmadeat, valemailmadeat, hbemailmadeat, customerref, legsprepped, exworksdatematt, exworksdatebase, exworksdatetopper, exworksdatehb, exworksdatelegs, exworksdatevalance, exworksdateacc
Dim mattressdelmethod, basedelmethod, topperdelmethod, headboarddelmethod, legsdelmethod, valancedelmethod, accdelmethod, confirmeddelivery
Dim acc_packdesc, acc_packwidth, acc_packheight, acc_packdepth, acc_packkg, acc_packtariffcode
Dim hb_packwidth, hb_packheight, hb_packdepth, hb_packkg
Dim matt1boxsize, matt2boxsize, matt1kg, matt2kg, mattressCrateType, matt1_packwidth, matt1_packheight, matt1_packdepth, matt1_packkg, mattressCrateType2, matt2_packwidth, matt2_packheight, matt2_packdepth, matt2_packkg, baseCrateType, base1_packwidth, base1_packheight, base1_packdepth, base1_packkg, baseCrateType2, base2_packwidth, base2_packheight, base2_packdepth, base2_packkg, topperCrateType, topperCrateType2, topper1_packwidth, topper1_packheight, topper1_packdepth, topper1_packkg, topper2_packwidth, topper2_packheight, topper2_packdepth, topper2_packkg, hbCrateType, hb1_packwidth, hb1_packheight, hb1_packdepth, hb1_packkg, hbCrateType2, hb2_packwidth, hb2_packheight, hb2_packdepth, hb2_packkg, legs1_packwidth, legs1_packheight, legs1_packdepth, legs1_packkg, legs2_packwidth, legs2_packheight, legs2_packdepth, legs2_packkg, valance1_packwidth, valance1_packheight, valance1_packdepth, valance1_packkg, valance2_packwidth, valance2_packheight, valance2_packdepth, valance2_packkg, legsCrateType, legsCrateType2,  accCrateType,  accCrateType2, acc1_packwidth, acc1_packheight, acc1_packdepth, acc1_packkg, acc2_packwidth, acc2_packheight, acc2_packdepth, acc2_packkg, valanceCrateType, valanceCrateType2, legweightstoragefield, mattressweightstoragefield, baseweightstoragefield, topperweightstoragefield, hbweightstoragefield, valanceweightstoragefield, accweightstoragefield, legsweightstoragefield,  mattresscrateqty, mattress2crateqty, basecrateqty, base2crateqty, toppercrateqty, legscrateqty, hbcrateqty, valancecrateqty, accessoriescrateqty, acc1boxsize, acc1kg
Dim base1boxsize, base2boxsize, base1kg, base2kg
Dim topper1boxsize, topper1kg, valance1boxsize, valance1kg, legs1boxsize, legs1kg
Dim hb1boxsize, hb1kg, londonproductiondate, cardiffproductiondate
Dim matt1boxwgt, matt2boxwgt, boxprodwgt1_1, boxprodwgt1_2
Dim base1boxwgt, base2boxwgt, boxprodwgt3_1, boxprodwgt3_2
Dim topper1boxwgt, boxprodwgt5_1
Dim valance1boxwgt, boxprodwgt6_1, valance1cratewgt
Dim legs1boxwgt, boxprodwgt7_1
Dim hb1boxwgt, boxprodwgt8_1
Dim matt1cratewgt, matt2cratewgt, base1cratewgt, base2cratewgt, topper1cratewgt, hb1cratewgt, hb2cratewgt, acc1cratewgt, acc2cratewgt, legs1cratewgt
Dim crateprodwgt1_1, crateprodwgt1_2, crateprodwgt3_1, crateprodwgt3_2, crateprodwgt5_1, crateprodwgt6_1, crateprodwgt7_1, crateprodwgt8_1, crateprodwgt8_2, crateprodwgt9_1, crateprodwgt9_2

londonproductiondate=request("londonproductiondate")
cardiffproductiondate=request("cardiffproductiondate")
matt1kg=request("matt1kg")
matt2kg=request("matt2kg")
base1kg=request("base1kg")
base2kg=request("base2kg")
topper1kg=request("topper1kg")
hb1kg=request("hb1kg")
valance1kg=request("valance1kg")
legs1kg=request("legs1kg")
acc1boxsize=request("acc1boxsize")
acc1kg=request("acc1kg")

matt1boxsize=request("matt1boxsize")
matt2boxsize=request("matt2boxsize")
matt1boxwgt=request("matt1boxwgt")
matt2boxwgt=request("matt2boxwgt")
matt1cratewgt=request("matt1cratewgt")
matt2cratewgt=request("matt2cratewgt")
crateprodwgt1_1=request("crateprodwgt1_1")
crateprodwgt1_2=request("crateprodwgt1_2")
boxprodwgt1_1=defaultSplitString(request("boxprodwgt1_1"),"")
boxprodwgt1_2=defaultSplitString(request("boxprodwgt1_2"),"")
base1boxsize=request("base1boxsize")
base2boxsize=request("base2boxsize")
base1boxwgt=request("base1boxwgt")
base2boxwgt=request("base2boxwgt")
base1cratewgt=request("base1cratewgt")
base2cratewgt=request("base2cratewgt")
crateprodwgt3_1=request("crateprodwgt3_1")
crateprodwgt3_2=request("crateprodwgt3_2")
boxprodwgt3_1=defaultSplitString(request("boxprodwgt3_1"),"")
boxprodwgt3_2=defaultSplitString(request("boxprodwgt3_2"),"")
topper1boxsize=request("topper1boxsize")
topper1boxwgt=request("topper1boxwgt")
topper1cratewgt=request("topper1cratewgt")
crateprodwgt5_1=request("crateprodwgt5_1")
boxprodwgt5_1=request("boxprodwgt5_1")
hb1boxsize=request("hb1boxsize")
hb1boxwgt=request("hb1boxwgt")
boxprodwgt8_1=request("boxprodwgt8_1")
valance1boxsize=request("valance1boxsize")
valance1boxwgt=request("valance1boxwgt")
boxprodwgt6_1=request("boxprodwgt6_1")
legs1boxsize=request("legs1boxsize")
legs1boxwgt=request("legs1boxwgt")
boxprodwgt7_1=request("boxprodwgt7_1")
crateprodwgt6_1=request("crateprodwgt6_1")
valance1cratewgt=request("valance1cratewgt")
crateprodwgt8_1=request("crateprodwgt8_1")
hb1cratewgt=request("hb1cratewgt")
crateprodwgt8_2=request("crateprodwgt8_2")
hb2cratewgt=request("hb2cratewgt")
legs1cratewgt=request("legs1cratewgt")
crateprodwgt7_1=request("crateprodwgt7_1")

mattressCrateType=request("mattressCrateType")
mattressCrateType2=request("mattressCrateType2")
baseCrateType=request("baseCrateType")
baseCrateType2=request("baseCrateType2")
topperCrateType=request("topperCrateType")
topperCrateType2=request("topperCrateType2")
valanceCrateType=request("valanceCrateType")
valanceCrateType2=request("valanceCrateType2")
accCrateType=request("accCrateType")
accCrateType2=request("accCrateType2")
legsCrateType=request("legsCrateType")
legsCrateType2=request("legsCrateType2")
hbCrateType=request("hbCrateType")
hbCrateType2=request("hbCrateType2")
matt1_packwidth=request("matt1_packwidth")
matt1_packheight=request("matt1_packheight")
matt1_packdepth=request("matt1_packdepth")
matt1_packkg=request("matt1_packkg")
matt2_packwidth=request("matt2_packwidth")
matt2_packheight=request("matt2_packheight")
matt2_packdepth=request("matt2_packdepth")
matt2_packkg=request("matt2_packkg")
base1_packwidth=request("base1_packwidth")
base1_packheight=request("base1_packheight")
base1_packdepth=request("base1_packdepth")
base1_packkg=request("base1_packkg")
base2_packwidth=request("base2_packwidth")
base2_packheight=request("base2_packheight")
base2_packdepth=request("base2_packdepth")
base2_packkg=request("base2_packkg")
topper1_packwidth=request("topper1_packwidth")
topper1_packheight=request("topper1_packheight")
topper1_packdepth=request("topper1_packdepth")
topper1_packkg=request("topper1_packkg")
topper2_packwidth=request("topper2_packwidth")
topper2_packheight=request("topper2_packheight")
topper2_packdepth=request("topper2_packdepth")
topper2_packkg=request("topper2_packkg")
hb1_packwidth=request("hb1_packwidth")
hb1_packheight=request("hb1_packheight")
hb1_packdepth=request("hb1_packdepth")
hb1_packkg=request("hb1_packkg")
hb2_packwidth=request("hb2_packwidth")
hb2_packheight=request("hb2_packheight")
hb2_packdepth=request("hb2_packdepth")
hb2_packkg=request("hb2_packkg")
legs1_packwidth=request("legs1_packwidth")
legs1_packheight=request("legs1_packheight")
legs1_packdepth=request("legs1_packdepth")
legs1_packkg=request("legs1_packkg")
legs2_packwidth=request("legs2_packwidth")
legs2_packheight=request("legs2_packheight")
legs2_packdepth=request("legs2_packdepth")
legs2_packkg=request("legs2_packkg")
valance1_packwidth=request("valance1_packwidth")
valance1_packheight=request("valance1_packheight")
valance1_packdepth=request("valance1_packdepth")
valance1_packkg=request("valance1_packkg")
valance2_packwidth=request("valance2_packwidth")
valance2_packheight=request("valance2_packheight")
valance2_packdepth=request("valance2_packdepth")
valance2_packkg=request("valance2_packkg")
acc1_packwidth=request("acc1_packwidth")
acc1_packheight=request("acc1_packheight")
acc1_packdepth=request("acc1_packdepth")
acc1_packkg=request("acc1_packkg")
acc2_packwidth=request("acc2_packwidth")
acc2_packheight=request("acc2_packheight")
acc2_packdepth=request("acc2_packdepth")
acc2_packkg=request("acc2_packkg")
'response.Write("acc2_packkg=" & acc2_packkg)
'response.End()
acc_packwidth=request("acc_packwidth")
acc_packheight=request("acc_packheight")
acc_packdepth=request("acc_packdepth")
acc_packkg=request("acc_packkg")
acc1cratewgt=request("acc1cratewgt")
crateprodwgt9_1=request("crateprodwgt9_1")
acc2cratewgt=request("acc2cratewgt")
crateprodwgt9_2=request("crateprodwgt9_2")

valanceweightstoragefield=request("valanceweightstoragefield")
accweightstoragefield=request("accweightstoragefield")
legweightstoragefield=request("legweightstoragefield")
valanceweightstoragefield=request("valanceweightstoragefield")
legsweightstoragefield=request("legsweightstoragefield")
mattresscrateqty=request("matt_crateqty")
basecrateqty=request("base_crateqty")
toppercrateqty=request("topper_crateqty")
legscrateqty=request("legs_crateqty")
hbcrateqty=request("hb_crateqty")
valancecrateqty=request("valance_crateqty")
accessoriescrateqty=request("acc_crateqty")

acc_packdesc=Request("acc_packdesc")

acc_packkg=Request("acc_packkg")
accweightstoragefield=request("accweightstoragefield")

hb_packwidth=Request("hb_packwidth")
hb_packheight=Request("hb_packheight")
hb_packdepth=Request("hb_packdepth")
hb_packkg=Request("hb_packkg")

confirmeddelivery=request("confirmeddelivery")
mattressdelmethod=request("mattressdelmethod")
basedelmethod=request("basedelmethod")
topperdelmethod=request("topperdelmethod")
headboarddelmethod=request("headboarddelmethod")
legsdelmethod=request("legsdelmethod")
valancedelmethod=request("valancedelmethod")
accdelmethod=request("accdelmethod")
exworksdatematt=request("exworksdatematt")
exworksdatebase=request("exworksdatebase")
exworksdatetopper=request("exworksdatetopper")
exworksdatehb=request("exworksdatehb")
exworksdatelegs=request("exworksdatelegs")
exworksdatevalance=request("exworksdatevalance")
baseemailto=""
hbemailto=""
valemailto=""
basefabemail=""
valancefabemail=""
headboardfabemail=""
fabricmsg=""
customerref=request("customerref")
complete=request("complete")
hblegheight=request("hblegheight")
headboardlegsmadeat=request("headboardlegsmadeat")
locationname=request("locationname")
hblegs=request("hblegs")
legqty=request("legqty")
addlegs=request("addlegs")
wrappingtype=request("wraptype")
totalbasefabricprice=request("totalbasefabricprice")
matt1width=request("matt1width")
matt2width=request("matt2width")
matt1length=request("matt1length")
matt2length=request("matt2length")
base1width=request("base1width")
base2width=request("base2width")
base1length=request("base1length")
base2length=request("base2length")
topper1width=request("topper1width")
topper1length=request("topper1length")
'valancelength=request("valancelength")
'valancewidth=request("valancewidth")
'valancedrop=request("valancedrop")
accessoriesbcwexpected=request("accessoriesbcwexpected")
accessoriesbcwwarehouse=request("accessoriesbcwwarehouse")
accessoriesdeldate=request("accessoriesdeldate")
accessoriesstatus=request("accessoriesstatus")
'accessoryfabricstatus=request("accessoryfabricstatus")
accessoryporaised=request("accessoryporaised")
accessorypackeddate=request("accessorypackeddate")
legsfinished=request("legsfinished")
legsprepped=request("legsprepped")
legsmadeat=request("legsmadeat")
legsbcwexpected=request("legsbcwexpected")
legsbcwwarehouse=request("legsbcwwarehouse")
legsdeldate=request("legsdeldate")
legsstatus=request("legsstatus")
headboarddetails=request("headboarddetails")
headboardstatus=request("headboardstatus")
headboardmadeat=request("headboardmadeat")
headboardframe=request("headboardframe")
headboardprepped=request("headboardprepped")
headboardfinished=request("headboardfinished")
headboardbcwexpected=request("headboardbcwexpected")
headboardbcwwarehouse=request("headboardbcwwarehouse")
headboarddeldate=request("headboarddeldate")
headboardsupplier=request("headboardsupplier")
headboardponumber=request("headboardponumber")
headboardpodate=request("headboardpodate")
headboardfabricexpecteddate=request("headboardfabricexpecteddate")
headboardfabricrecdate=request("headboardfabricrecdate")
headboardcuttingsent=request("headboardcuttingsent")
headboardconfirmeddate=request("headboardconfirmeddate")
headboardtobcwdate=request("headboardtobcwdate")
headboardfabricprice=request("headboardfabricprice")
headboardfabricqty=request("headboardfabricqty")
headboardfabricstatus=request("headboardfabricstatus")
frTreatingSent=request("frTreatingSent")
frTreatingReceived=request("frTreatingReceived")
basefrTreatingSent=request("basefrTreatingSent")
basefrTreatingReceived=request("basefrTreatingReceived")

valancedetails=request("valancedetails")
valancestatus=request("valancestatus")
valancemadeat=request("valancemadeat")
valanceframe=request("valanceframe")
valanceprepped=request("valanceprepped")
valancefinished=request("valancefinished")
valancebcwexpected=request("valancebcwexpected")
valancebcwwarehouse=request("valancebcwwarehouse")
valancedeldate=request("valancedeldate")
valancesupplier=request("valancesupplier")
valanceponumber=request("valanceponumber")
valancepodate=request("valancepodate")
valancefabricexpecteddate=request("valancefabricexpecteddate")
valancefabricrecdate=request("valancefabricrecdate")
valancecuttingsent=request("valancecuttingsent")
valancefrTreatingSent=request("valancefrTreatingSent")
valancefrTreatingReceived=request("valancefrTreatingReceived")
valanceconfirmeddate=request("valanceconfirmeddate")
sendtosddate=request("sendtosddate")
valancetobcwdate=request("valancetobcwdate")
valancefabricprice=request("valancefabricprice")
valancefabricqty=request("valancefabricqty")
valancefabricstatus=request("valancefabricstatus")

toppercut=request("toppercut")
toppermachined=request("toppermachined")
toppermadeat=request("toppermadeat")
topperstatus=request("topperstatus")
topperbcwexpected=request("topperbcwexpected")
topperbcwwarehouse=request("topperbcwwarehouse")
topperdeldate=request("topperdeldate")
topperfinished=request("topperfinished")
toppertickingbatchno=request("toppertickingbatchno")
toppermadeby=request("toppermadeby")
basemadeat=request("basemadeat")
basefabricqty=request("basefabricqty")
basefabricprice=request("basefabricprice")
basetobcwdate=Request("basetobcwdate")
baseconfirmeddate=request("baseconfirmeddate")
basecuttingsent=request("basecuttingsent")
basefabricrecdate=request("basefabricrecdate")
basefabricexpecteddate=request("basefabricexpecteddate")
basepodate=request("basepodate")
baseponumber=request("baseponumber")
basesupplier=request("basesupplier")
basefabricstatus=request("basefabricstatus")
matbay=request("matbay")
basebay=request("basebay")
topperbay=request("topperbay")
valancebay=request("valancebay")
legsbay=request("legsbay")
headboardbay=request("headboardbay")
accessoriesbay=request("accessoriesbay")
basedeldate=request("basedeldate")
basebcwwarehouse=request("basebcwwarehouse")
basebcwexpected=request("basebcwexpected")
basefinished=request("basefinished")
basemadeby=request("basemadeby")
boxtickingbatchno=request("boxtickingbatchno")
boxmachined=request("boxmachined")
baseprepped=request("baseprepped")
boxframe=request("boxframe")
boxcut=request("boxcut")
mattdeldate=Request("mattdeldate")
mattbcwwarehouse=request("mattbcwwarehouse")
mattbcwexpected=request("mattbcwexpected")
mattmadeby=Request("mattmadeby")
tickingbatchno=Request("tickingbatchno")
deliveredon=Request("deliveredon")
productiondate=Request("productiondate")
mattfinished=Request("mattfinished")
springunitdate=Request("springunitdate")
mattmachined=Request("mattmachined")
mattcut=Request("mattcut")
mattressstatus=Request("mattressqc")
basestatus=Request("baseqc")
mattressmadeat=Request("mattressmadeat")
purchaseno=request("purchaseno")
custcode=Request("custcode")
clientstitle=Request("clientstitle")
if clientstitle<>"" then custname=clientstitle & " "
clientsfirst=Request("clientsfirst")
if clientsfirst<>"" then custname=clientsfirst & " "
clientssurname=Request("clientssurname")
if clientssurname<>"" then custname=clientssurname
telwork=Request("telwork")
mobile=Request("mobile")
orderno=Request("orderno")
accountcode=Request("accountcode")
email_address=Request("email_address")
tel=Request("tel")
add1=Request("add1")
add2=Request("add2")
add3=Request("add3")
town=Request("town")
county=Request("county")
postcode=Request("postcode")
country=Request("country")
add1d=Request("add1d")
add2d=Request("add2d")
add3d=Request("add3d")
townd=Request("townd")
countyd=Request("countyd")
postcoded=Request("postcoded")
countryd=Request("countryd")
companyname=replaceQuotes(Request("companyname"))
deldate=Request("deldate")
orderstatus=Request("orderstatus")
'response.Write("orderstatus= " & orderstatus)
firelabel=Request("firelabel")
delphonetype1=Request("delphonetype1")
delphonetype2=Request("delphonetype2")
delphonetype3=Request("delphonetype3")
delphone1=trim(Request("delphone1"))
delphone2=trim(Request("delphone2"))
delphone3=trim(Request("delphone3"))


Set Con = getMysqlConnection()
Set rs = getMysqlUpdateRecordSet("Select * from fabricstatus WHERE fabricstatus like'" & basefabricstatus & "'", con)
if not rs.eof then
basefabricstatus=rs("fabricstatusid")
end if
rs.close
set rs=nothing

Set rs = getMysqlUpdateRecordSet("Select * from fabricstatus WHERE fabricstatus like'" & headboardfabricstatus & "'", con)
if not rs.eof then
headboardfabricstatus=rs("fabricstatusid")
end if
rs.close
set rs=nothing

Set rs = getMysqlUpdateRecordSet("Select * from fabricstatus WHERE fabricstatus like'" & valancefabricstatus & "'", con)
if not rs.eof then
valancefabricstatus=rs("fabricstatusid")
end if
rs.close
set rs=nothing

sql = "Select * from packagingdata where purchase_no=" & purchaseno

Set rs = getMysqlUpdateRecordSet(sql, con)
if NOT rs.eof then
	do until rs.eof
	rs.delete
	rs.movenext
	loop
end if
rs.close
set rs=nothing


if matt1width<>"" or matt2width<>"" or matt1length<>"" or matt2length<>"" or base1width<>"" or base2width<>"" or base1length<>"" or base2length<>"" or topper1length<>"" or topper1width<>"" then
		Set rs = getMysqlUpdateRecordSet("Select * from ProductionSizes WHERE Purchase_No=" & purchaseno, con)
		If matt1width<>"" then rs("matt1width")=Replace(matt1width, ",", "") else rs("matt1width")=null
		If matt2width<>"" then rs("matt2width")=Replace(matt2width, ",", "") else rs("matt2width")=null
		If matt1length<>"" then rs("matt1length")=Replace(matt1length, ",", "") else rs("matt1length")=null
		If matt2length<>"" then rs("matt2length")=Replace(matt2length, ",", "") else rs("matt2length")=null
		' NOT ON ORDERDETAILS FORM YET If base1width<>"" then rs("base1width")=base1width else rs("base1width")=null
		' NOT ON ORDERDETAILS FORM YET If base2width<>"" then rs("base2width")=base2width else rs("base2width")=null
		' NOT ON ORDERDETAILS FORM YET If base1length<>"" then rs("base1length")=base1length else rs("base1length")=null
		' NOT ON ORDERDETAILS FORM YET If base2length<>"" then rs("base2length")=base2length else rs("base2length")=null
		If topper1width<>"" then rs("topper1width")=Replace(topper1width, ",", "") else rs("topper1width")=null
		If topper1length<>"" then rs("topper1length")=Replace(topper1length, ",", "") else rs("topper1length")=null
		rs.update
		rs.close
		set rs=nothing
end if

sql = "Select * from contact where code = " & custcode

Set rs = getMysqlUpdateRecordSet(sql, con)
'If clientstitle<>"" Then rs("title")=capitalise(lcase(clientstitle)) else rs("title")=null
'If clientsfirst<>"" Then rs("first")=capitalise(lcase(clientsfirst)) else rs("first")=null
'If clientssurname<>"" Then rs("surname")=capitalise(lcase(clientssurname)) else rs("surname")=null
rs("updatedby")=retrieveUserName()
rs("dateupdated")=date()
If telwork <>"" then rs("telwork")=telwork else rs("telwork")=null
If mobile <>"" then rs("mobile")=mobile else rs("mobile")=null
rs.Update
rs.close
set rs=nothing

sql = "Select * from address where code = " & custcode

Set rs = getMysqlUpdateRecordSet(sql, con)
'If companyname<>"" then rs("company")=companyname else rs("company")=null
If email_address<>"" then rs("email_address")=email_address else rs("email_address")=null
If tel<>"" then rs("tel")=tel else rs("tel")=null
If add1<>"" then rs("street1")=add1 else rs("street1")=null
If add2<>"" then rs("street2")=add2 else rs("street2")=null
If add3<>"" then rs("street3")=add3 else rs("street3")=null
If town<>"" then rs("town")=town else rs("town")=null
If county<>"" then rs("county")=county else rs("county")=null
If postcode<>"" then rs("postcode")=postcode else rs("postcode")=null
If country<>"" then rs("country")=country else rs("country")=null
rs.Update
rs.close
set rs=nothing

sql = "Select * from bay_content where orderid = " & orderno
Set rs2 = getMysqlUpdateRecordSet(sql, con)
If not rs2.eof then
	Do until rs2.eof
		If matbay<>"n" and rs2("componentid")=1 then rs2("baynumber")=matbay
		If basebay<>"n" and rs2("componentid")=3 then rs2("baynumber")=basebay
		If topperbay<>"n" and rs2("componentid")=5 then rs2("baynumber")=topperbay
		If valancebay<>"n" and rs2("componentid")=6 then rs2("baynumber")=valancebay
		If legsbay<>"n" and rs2("componentid")=7 then rs2("baynumber")=legsbay
		If headboardbay<>"n" and rs2("componentid")=8 then rs2("baynumber")=headboardbay
		If accessoriesbay<>"n" and rs2("componentid")=9 then rs2("baynumber")=accessoriesbay
		rs2.update
		rs2.movenext
	loop
end if
rs2.close
set rs2=nothing

If matbay<>"" and matbay<>"n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=1"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if rs2.eof then
		rs2.AddNew
		rs2("componentid")=1
		rs2("baynumber")=matbay
		rs2("orderid")=orderno
		rs2("componenttype")="Mattress"
		rs2.Update
	end if
	rs2.close
	set rs2=nothing
end if

If matbay="n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=1"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if not rs2.eof then
	rs2.delete
	end if
	rs2.close
	set rs2=nothing
end if

If basebay<>"" and basebay<>"n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=3"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if rs2.eof then
		rs2.AddNew
		rs2("componentid")=3
		rs2("baynumber")=basebay
		rs2("orderid")=orderno
		rs2("componenttype")="Base"
		rs2.Update
	end if
	rs2.close
	set rs2=nothing
end if

If basebay="n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=3"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if not rs2.eof then
	rs2.delete
	end if
	rs2.close
	set rs2=nothing
end if

If topperbay<>"" and topperbay<>"n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=5"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if rs2.eof then
		rs2.AddNew
		rs2("componentid")=5
		rs2("baynumber")=topperbay
		rs2("orderid")=orderno
		rs2("componenttype")="Topper"
		rs2.Update
	end if
	rs2.close
	set rs2=nothing
end if

If topperbay="n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=5"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if not rs2.eof then
	rs2.delete
	end if
	rs2.close
	set rs2=nothing
end if

If valancebay<>"" and valancebay<>"n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=6"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if rs2.eof then
		rs2.AddNew
		rs2("componentid")=6
		rs2("baynumber")=valancebay
		rs2("orderid")=orderno
		rs2("componenttype")="Valance"
		rs2.Update
	end if
	rs2.close
	set rs2=nothing
end if

If valancebay="n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=6"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if not rs2.eof then
	rs2.delete
	end if
	rs2.close
	set rs2=nothing
end if

If legsbay<>"" and legsbay<>"n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=7"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if rs2.eof then
		rs2.AddNew
		rs2("componentid")=7
		rs2("baynumber")=legsbay
		rs2("orderid")=orderno
		rs2("componenttype")="Legs"
		rs2.Update
	end if
	rs2.close
	set rs2=nothing
end if

If legsbay="n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=7"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if not rs2.eof then
	rs2.delete
	end if
	rs2.close
	set rs2=nothing
end if

If headboardbay<>"" and headboardbay<>"n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=8"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if rs2.eof then
		rs2.AddNew
		rs2("componentid")=8
		rs2("baynumber")=headboardbay
		rs2("orderid")=orderno
		rs2("componenttype")="Headboard"
		rs2.Update
	end if
	rs2.close
	set rs2=nothing
end if

If headboardbay="n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=8"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if not rs2.eof then
	rs2.delete
	end if
	rs2.close
	set rs2=nothing
end if

If accessoriesbay<>"" and accessoriesbay<>"n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=9"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if rs2.eof then
		rs2.AddNew
		rs2("componentid")=9
		rs2("orderid")=orderno
		rs2("componenttype")="Accessories"
		rs2.Update
	end if
	rs2.close
	set rs2=nothing
end if

If accessoriesbay="n" then
	sql = "Select * from bay_content where orderid = " & orderno & " AND componentid=9"
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	if not rs2.eof then
	rs2.delete
	end if
	rs2.close
	set rs2=nothing
end if
'overseas orders
if exworksdatematt="n" then
	Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=1 and purchase_no=" & purchaseno, con)
	if not rs.eof then
		call log(scriptname, "deleting from exportlinks where componentid=1 and purchase_no=" & purchaseno)
	rs.delete
	end if
	rs.close 
	set rs=nothing
end if
	Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=1 and purchase_no=" & purchaseno, con)
	if (exworksdatematt<>"n" and exworksdatematt<>"") then
		Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=1 and purchase_no=" & purchaseno, con)
		'response.write("<br>exworksdatematt=" & exworksdatematt)
		'response.write("<br>purchaseno=" & purchaseno)
		'response.write("<br>rs.eof=" & rs.eof)
		'response.end
		if rs.eof then
			rs.close
			set rs=nothing
			Set rs = getMysqlUpdateRecordSet("Select * from exportlinks", con)
			rs.AddNew
			rs("purchase_no")=purchaseno
			rs("componentid")=1
			
		end if
		rs("orderconfirmed")="y"
		rs("LinksCollectionID")=exworksdatematt
		rs.Update
		rs.close
		set rs=nothing
	end if
	
if exworksdatevalance="n" then
	Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=6 and purchase_no=" & purchaseno, con)
	if not rs.eof then
		call log(scriptname, "deleting from exportlinks where componentid=6 and purchase_no=" & purchaseno)
	rs.delete
	end if
	rs.close 
	set rs=nothing
end if
if (exworksdatevalance<>"n" and exworksdatevalance<>"") then
Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=6 and purchase_no=" & purchaseno, con)
if rs.eof then
rs.close
set rs=nothing
Set rs = getMysqlUpdateRecordSet("Select * from exportlinks", con)
rs.AddNew
rs("purchase_no")=purchaseno
rs("componentid")=6
end if
rs("orderconfirmed")="y"
if exworksdatevalance = 0 then
exworksdatevalance = getAdhocExportCollection(con, purchaseno)
end if
rs("LinksCollectionID")=exworksdatevalance
rs.Update
rs.close
set rs=nothing
end if

if exworksdatebase="n" then
	Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=3 and purchase_no=" & purchaseno, con)
	if not rs.eof then
		call log(scriptname, "deleting from exportlinks where componentid=3 and purchase_no=" & purchaseno)
	rs.delete
	end if
	rs.close 
	set rs=nothing
end if
if (exworksdatebase<>"n"  and exworksdatebase<>"") then
Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=3 and purchase_no=" & purchaseno, con)
if rs.eof then
rs.close
set rs=nothing
Set rs = getMysqlUpdateRecordSet("Select * from exportlinks", con)
rs.AddNew
rs("purchase_no")=purchaseno
rs("componentid")=3

end if
rs("orderconfirmed")="y"
if exworksdatebase = 0 then
exworksdatebase = getAdhocExportCollection(con, purchaseno)
end if
rs("LinksCollectionID")=exworksdatebase
rs.Update
rs.close
set rs=nothing
end if

if exworksdatetopper="n" then
	Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=5 and purchase_no=" & purchaseno, con)
	if not rs.eof then
		call log(scriptname, "deleting from exportlinks where componentid=5 and purchase_no=" & purchaseno)
	rs.delete
	end if
	rs.close 
	set rs=nothing
end if
if (exworksdatetopper<>"n" and exworksdatetopper<>"")  then
Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=5 and purchase_no=" & purchaseno, con)
if rs.eof then
rs.close
set rs=nothing
Set rs = getMysqlUpdateRecordSet("Select * from exportlinks", con)
rs.AddNew
rs("purchase_no")=purchaseno
rs("componentid")=5

end if
rs("orderconfirmed")="y"
if exworksdatetopper = 0 then
exworksdatetopper = getAdhocExportCollection(con, purchaseno)
end if
rs("LinksCollectionID")=exworksdatetopper
rs.Update
rs.close
set rs=nothing
end if


if exworksdatelegs="n" then
	Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=7 and purchase_no=" & purchaseno, con)
	if not rs.eof then
		call log(scriptname, "deleting from exportlinks where componentid=7 and purchase_no=" & purchaseno)
	rs.delete
	end if
	rs.close 
	set rs=nothing	
end if
if (exworksdatelegs<>"n" and exworksdatelegs<>"") then
Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=7 and purchase_no=" & purchaseno, con)
if rs.eof then
rs.close
set rs=nothing
Set rs = getMysqlUpdateRecordSet("Select * from exportlinks", con)
rs.AddNew
rs("purchase_no")=purchaseno
rs("componentid")=7

end if
rs("orderconfirmed")="y"
if exworksdatelegs = 0 then
exworksdatelegs = getAdhocExportCollection(con, purchaseno)
end if
rs("LinksCollectionID")=exworksdatelegs
rs.Update
rs.close
set rs=nothing
end if

if exworksdatehb="n" then
	Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=8 and purchase_no=" & purchaseno, con)
	if not rs.eof then
		call log(scriptname, "deleting from exportlinks where componentid=8 and purchase_no=" & purchaseno)
	rs.delete
	end if
	rs.close 
	set rs=nothing	
end if	
if (exworksdatehb<>"n" and exworksdatehb<>"") then
Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=8 and purchase_no=" & purchaseno, con)
if rs.eof then
rs.close
set rs=nothing
Set rs = getMysqlUpdateRecordSet("Select * from exportlinks", con)
rs.AddNew
rs("purchase_no")=purchaseno
rs("componentid")=8

end if
rs("orderconfirmed")="y"
if exworksdatehb = 0 then
exworksdatehb = getAdhocExportCollection(con, purchaseno)
end if
rs("LinksCollectionID")=exworksdatehb
rs.Update
rs.close
set rs=nothing
end if


call deleteChildlessAdhocExports(con) ' tidy up the adhoc exports
'end overseas orders

sql = "Select * from purchase where order_number = " & orderno

Set rs = getMysqlUpdateRecordSet(sql, con)

if londonproductiondate<>"" then rs("londonproductiondate")=londonproductiondate else rs("londonproductiondate")=null
if cardiffproductiondate<>"" then rs("cardiffproductiondate")=cardiffproductiondate else rs("cardiffproductiondate")=null
if complete="y" then rs("completedorders")="y"
if confirmeddelivery="y" then rs("DeliveryDateConfirmed")="y" else rs("DeliveryDateConfirmed")="n"
rs("wrappingid")=wrappingtype
if legqty<>"" then rs("legqty")=legqty
if hblegs<>"" then rs("headboardlegqty")=hblegs
if hblegheight<>"" then rs("hblegheight")=hblegheight else rs("hblegheight")=Null
'rs("addlegqty")=addlegs
mattressrequired=rs("mattressrequired")
baserequired=rs("baserequired")
If basefabricprice<>"" then rs("basefabriccost")=basefabricprice
If totalbasefabricprice<>"" then rs("basefabricprice")=totalbasefabricprice
If basefabricqty<>"" then rs("basefabricmeters")=basefabricqty
topperrequired=rs("topperrequired")
headboardrequired=rs("headboardrequired")
valancerequired=rs("valancerequired")
accessoriesrequired=rs("accessoriesrequired")
if productiondate<>"" then rs("productiondate")=productiondate else rs("productiondate")=null

if orderstatus=90 then rs("orderonhold")="y"
'if orderstatus=80 then rs("cancelled")="y"
legsrequired = rs("legsrequired")
if isnull(rs("legstyle")) then legsrequired="n"
if accountcode<>"" then rs("accountcode")=accountcode else rs("accountcode")=null
If deldate<>"" then rs("deliverydate")=deldate else rs("deliverydate")=null

If deliveredon<>"" then rs("bookeddeliverydate")=deliveredon else rs("bookeddeliverydate")=null
if firelabel <>"n" then rs("firelabelid")=firelabel
If add1d<>"" then rs("deliveryadd1")=add1d else rs("deliveryadd1")=null
If add2d<>"" then rs("deliveryadd2")=add2d else rs("deliveryadd2")=null
If add3d<>"" then rs("deliveryadd3")=add3d else rs("deliveryadd3")=null
If townd<>"" then rs("deliverytown")=townd else rs("deliverytown")=null
If countyd<>"" then rs("deliverycounty")=countyd else rs("deliverycounty")=null
If postcoded<>"" then rs("deliverypostcode")=postcoded else rs("deliverypostcode")=null
If countryd<>"" then rs("deliverycountry")=countryd else rs("deliverycountry")=null


rs.Update
rs.close
set rs=nothing

if delphone1 <> "" then
	call addUpdatePhoneNumber(con, delphonetype1, purchaseno, delphone1, 1)
else
	call deletePhoneNumber(con, purchaseno, 1)
end if
if delphone2 <> "" then
	call addUpdatePhoneNumber(con, delphonetype2, purchaseno, delphone2, 2)
else
	call deletePhoneNumber(con, purchaseno, 2)
end if
if delphone3 <> "" then
	call addUpdatePhoneNumber(con, delphonetype3, purchaseno, delphone3, 3)
else
	call deletePhoneNumber(con, purchaseno, 3)
end if
'Add Whole order status

sql = "Select * from qc_history where componentid=0 AND purchase_no = " & purchaseno & " order by QC_date desc"
Set rs = getMysqlUpdateRecordSet(sql, con)
If rs.eof then
	rs.AddNew
	rs("componentid")=0
	rs("purchase_no")=purchaseno
	rs("qc_statusid")=orderstatus
	if orderstatus=20 then rs("issueddate")=now()
	rs("qc_date")=Now()
	rs("updatedby")=retrieveuserid()
else
	statusChangeIsPermitted = isStatusChangePermitted(cint(rs("qc_statusid")), cint(orderstatus))
	If statusChangeIsPermitted and CInt(rs("qc_statusid"))<>CInt(orderstatus) then
		rs.AddNew 
		rs("componentid")=0
		rs("purchase_no")=purchaseno
		rs("qc_statusid")=orderstatus
		if orderstatus=20 then rs("issueddate")=now()
		if orderstatus>20 then rs("issueddate")=null
		rs("qc_date")=Now()
		rs("updatedby")=retrieveuserid()
	end if
	if not statusChangeIsPermitted then
		jsmsg = jsmsg & "User does not have authority to reopen order. Order status change has not been made. All other changes have been saved."
	end if
end if
rs.update
rs.close
set rs=nothing

'END Add Whole order Status

'Add Mattress QC
If mattressrequired="y" then
	currentCompId = 1
	sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
	set rs = getMysqlQueryRecordSet(sql, con)
	newRowRequired = false
	statusChangeIsPermitted = true
	if rs.eof then
		newRowRequired = true
	else
		if mattressstatus<>"n" then
			statusChangeIsPermitted = isStatusChangePermitted(cint(rs("qc_statusid")), cint(mattressstatus))
			if statusChangeIsPermitted and CInt(rs("qc_statusid"))<>CInt(mattressstatus) then
				newRowRequired = true
			end if
		End if
	end if
	
	if newRowRequired then
		historyRowId = copyHistoryRow(con, purchaseno, currentCompId)
		if historyRowId = 0 then
			call insertQcHistoryRowIfNotExists(con, currentCompId, purchaseno, 0, retrieveuserid(), 0)
			sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
			set rs2 = getMysqlQueryRecordSet(sql, con)
			historyRowId = rs2("qc_historyid")
			closers(rs2)
		end if
	else
		historyRowId = rs("qc_historyid")
	end if
	closers(rs)
	
	sql = "Select * from qc_history where qc_historyid=" & historyRowId
	Set rs = getMysqlUpdateRecordSet(sql, con)
	'response.write("<br>historyRowId=" & historyRowId)
	'response.end

	rs("updatedby")=retrieveuserid()
	if mattcut<>"" then rs("cut")=mattcut else rs("cut")=null
	if mattmachined<>"" then rs("machined")=mattmachined else rs("machined")=Null
	If mattressmadeat<>"n" then rs("madeat")=mattressmadeat else rs("madeat")=Null
	If springunitdate<>"" then rs("springunitdate")=springunitdate else rs("springunitdate") = Null
	If mattbcwexpected<>"" then rs("bcwexpected")=mattbcwexpected else rs("bcwexpected") = Null
	If mattbcwwarehouse<>"" then rs("bcwwarehouse")=mattbcwwarehouse else rs("bcwwarehouse") = Null
	If mattdeldate<>"" then rs("deliverydate")=mattdeldate else rs("deliverydate") = Null
	If mattressstatus<>"n" and statusChangeIsPermitted then rs("qc_statusid")=mattressstatus
	if mattressstatus=20 and statusChangeIsPermitted then rs("issueddate")=now()
	if mattressstatus<20 and statusChangeIsPermitted then rs("issueddate")=null
	If mattfinished<>"" then rs("finished")=mattfinished else rs("finished") = Null
	If tickingbatchno<>"" then rs("tickingbatchno")=tickingbatchno else rs("tickingbatchno")=Null
	If mattmadeby<>"n" then rs("madeby")=mattmadeby else rs("madeby")=null
	if mattressdelmethod<>"" then rs("deliverymethod")=mattressdelmethod

rs.update
closers(rs)

if matt1boxsize<>"" then
	if wrappingtype=3 then
		sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=1"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
			rs.AddNew
		end if
		rs("purchase_no")=purchaseno
		rs("componentid")=1
		rs("boxsize")=matt1boxsize
		if matt1kg<>"" then rs("packkg")=CDbl(matt1kg) else rs("packkg")=NULL
		if boxprodwgt1_1<>"" then rs("ProductWgt")=CDbl(boxprodwgt1_1) else rs("ProductWgt")=NULL
		if matt1boxwgt<>"" then rs("NetPackagingWgt")=CDbl(matt1boxwgt) else rs("NetPackagingWgt")=NULL
		rs("updatedon")=rs("updatedon") & Now() & " : "
		rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
		rs.update
		closers(rs)
	end if
end if

if matt2boxsize<>"" then
	if wrappingtype=3 then
	sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=1"
	Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
		rs.AddNew
		end if
	rs("comppartno")=2
	rs("purchase_no")=purchaseno
	rs("componentid")=1
	rs("boxsize")=matt2boxsize
	if matt2kg<>"" then rs("packkg")=CDbl(matt2kg) else rs("packkg")=NULL
	if boxprodwgt1_2<>"" then rs("ProductWgt")=CDbl(boxprodwgt1_2) else rs("ProductWgt")=NULL
	if matt2boxwgt<>"" then rs("NetPackagingWgt")=CDbl(matt2boxwgt) else rs("NetPackagingWgt")=NULL
	rs("updatedon")=rs("updatedon") & Now() & " : "
	rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
	rs.update
	closers(rs)
	end if
end if

if wrappingtype=4 then
	if mattressCrateType = "Special Size Crate" and mattressCrateType2 = "Special Size Crate" and mattresscrateqty = 2 then
		mattresscrateqty = mattresscrateqty / 2 ' its 1 crate of each type
		sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=1"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
			rs.AddNew
		end if
		rs("comppartno")=2
		rs("purchase_no")=purchaseno
		rs("componentid")=1
		rs("packwidth")=matt2_packwidth
		rs("packheight")=matt2_packheight
		rs("packdepth")=matt2_packdepth
		rs("packkg")=matt2_packkg
		rs("boxsize")=mattressCrateType2
		if matt1_packkg<>"" then rs("packkg")=CDbl(matt1_packkg) else rs("packkg")=NULL
		if crateprodwgt1_2<>"" then rs("ProductWgt")=CDbl(crateprodwgt1_2) else rs("ProductWgt")=NULL
		if matt2cratewgt<>"" then rs("NetPackagingWgt")=CDbl(matt2cratewgt) else rs("NetPackagingWgt")=NULL
		rs("packagingdesc")=null
		rs("packtariffcode")=null
		rs("ComponentWeight")=mattressweightstoragefield
		rs("updatedon")=rs("updatedon") & Now() & " : "
		rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
		rs("boxqty")=mattresscrateqty
		rs.update
		closers(rs)
	else
		sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=1"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if not rs.eof then
			rs.delete
		end if
	end if

	sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=1"
	Set rs = getMysqlUpdateRecordSet(sql, con)
	if rs.eof then
		rs.AddNew
	end if
	rs("comppartno")=1
	rs("purchase_no")=purchaseno
	rs("componentid")=1
	rs("packwidth")=matt1_packwidth
	rs("packheight")=matt1_packheight
	rs("packdepth")=matt1_packdepth
	rs("boxsize")=mattressCrateType	
	if matt1_packkg<>"" then rs("packkg")=CDbl(matt1_packkg) else rs("packkg")=NULL
	if crateprodwgt1_1<>"" then rs("ProductWgt")=CDbl(crateprodwgt1_1) else rs("ProductWgt")=NULL
	if matt1cratewgt<>"" then rs("NetPackagingWgt")=CDbl(matt1cratewgt) else rs("NetPackagingWgt")=NULL
	rs("packagingdesc")=null
	rs("packtariffcode")=null
	rs("ComponentWeight")=mattressweightstoragefield
	rs("updatedon")=rs("updatedon") & Now() & " : "
	rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
	rs("boxqty")=mattresscrateqty
	rs.update
	closers(rs)

end if

if wrappingtype=1 or wrappingtype=2 then
sql = "Select * from packagingdata where purchase_no=" & purchaseno & " and componentID=1"
'response.Write("sql=" & sql)
'response.End()
Set rs2 = getMysqlUpdateRecordSet(sql, con)
if not rs2.eof then
do until rs2.eof
rs2.delete
rs2.movenext
loop
end if
rs2.close
set rs2=nothing
end if



if not statusChangeIsPermitted then
jsmsg = jsmsg & "User does not have authority to reopen mattress. Mattress status change has not been made. All other changes have been saved."
end if
end if
'END Add mattress QC

'Add Topper detail
If topperrequired="y" then
	currentCompId = 5
	sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
	set rs = getMysqlQueryRecordSet(sql, con)
	newRowRequired = false
	statusChangeIsPermitted = true
	if rs.eof then
	newRowRequired = true
	else
		if topperstatus<>"n" then
		statusChangeIsPermitted = isStatusChangePermitted(cint(rs("qc_statusid")), cint(topperstatus))
			if statusChangeIsPermitted and CInt(rs("qc_statusid"))<>CInt(topperstatus) then
			newRowRequired = true
			end if
		end if
	end if

	if newRowRequired then
		historyRowId = copyHistoryRow(con, purchaseno, currentCompId)
		if historyRowId = 0 then
		call insertQcHistoryRowIfNotExists(con, currentCompId, purchaseno, 0, retrieveuserid(), 0)
		sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
		set rs2 = getMysqlQueryRecordSet(sql, con)
		historyRowId = rs2("qc_historyid")
		closers(rs2)
		end if
	else
		historyRowId = rs("qc_historyid")
	end if
	closers(rs)

	sql = "Select * from qc_history where qc_historyid=" & historyRowId
	Set rs = getMysqlUpdateRecordSet(sql, con)
	
	rs("updatedby")=retrieveuserid()
	if toppercut<>"" then rs("cut")=toppercut else rs("cut")=null
	if toppermachined<>"" then rs("machined")=toppermachined else rs("machined")=null
	If toppermadeat<>"n" then rs("madeat")=toppermadeat else rs("madeat")=Null
	If topperbcwexpected<>"" then rs("bcwexpected")=topperbcwexpected else rs("bcwexpected") = Null
	If topperbcwwarehouse<>"" then rs("bcwwarehouse")=topperbcwwarehouse else rs("bcwwarehouse") = Null
	If topperdeldate<>"" then rs("deliverydate")=topperdeldate else rs("deliverydate") = Null
	If topperstatus<>"n" and statusChangeIsPermitted then rs("qc_statusid")=topperstatus
	if topperstatus=20 and statusChangeIsPermitted then rs("issueddate")=now()
	if topperstatus<20 and statusChangeIsPermitted then rs("issueddate")=null
	If topperfinished<>"" then rs("finished")=topperfinished else rs("finished") = Null
	If toppertickingbatchno<>"" then rs("tickingbatchno")=toppertickingbatchno else rs("tickingbatchno")=Null
	If toppermadeby<>"n" then rs("madeby")=toppermadeby else rs("madeby")=null
	if topperdelmethod<>"" then rs("deliverymethod")=topperdelmethod else rs("deliverymethod") = null
	rs.update
	closers(rs)

	if topper1boxsize<>"" then
		if wrappingtype=3 then
			sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=5"
			Set rs = getMysqlUpdateRecordSet(sql, con)
			if rs.eof then
			rs.AddNew
			end if
			rs("purchase_no")=purchaseno
			rs("componentid")=5
			rs("boxsize")=topper1boxsize
			if topper1kg<>"" then rs("packkg")=topper1kg else rs("packkg")=null
			if boxprodwgt5_1<>"" then rs("ProductWgt")=CDbl(boxprodwgt5_1) else rs("ProductWgt")=NULL
			if topper1boxwgt<>"" then rs("NetPackagingWgt")=CDbl(topper1boxwgt) else rs("NetPackagingWgt")=NULL

			'if topper1kg<>"" then rs("packkg")=topper1kg else rs("packkg")=0
			rs("updatedon")=rs("updatedon") & Now() & " : "
			rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
			rs.update
			closers(rs)
		end if
	end if

	if wrappingtype=4 then
	'response.Write("toppercratetype=" & topperCrateType & " toppercratetype2=" & topperCrateType2 & " toppercrateqty=" & toppercrateqty)
	'response.End()
		if topperCrateType = "Special Size Crate" and topperCrateType2 = "Special Size Crate" and toppercrateqty = 2 then
			toppercrateqty = toppercrateqty / 2 ' its 1 crate of each type
			sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=5"
			Set rs = getMysqlUpdateRecordSet(sql, con)
			if rs.eof then
				rs.AddNew
			end if
			rs("comppartno")=2
			rs("purchase_no")=purchaseno
			rs("componentid")=5
			rs("packwidth")=topper2_packwidth
			rs("packheight")=topper2_packheight
			rs("packdepth")=topper2_packdepth
			rs("packkg")=topper2_packkg
			rs("boxsize")=topperCrateType2
			rs("packagingdesc")=null
			rs("packtariffcode")=null
			rs("ComponentWeight")=topperweightstoragefield
			rs("updatedon")=rs("updatedon") & Now() & " : "
			rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
			rs("boxqty")=toppercrateqty
			rs.update
			closers(rs)
		else
			sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=5"
			Set rs = getMysqlUpdateRecordSet(sql, con)
			if not rs.eof then
				rs.delete
			end if
		end if
		sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=5"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
		rs.AddNew
		end if
		rs("comppartno")=1
		rs("purchase_no")=purchaseno
		rs("componentid")=5
		rs("packwidth")=topper1_packwidth
		rs("packheight")=topper1_packheight
		rs("packdepth")=topper1_packdepth
		if topper1_packkg<>"" then rs("packkg")=CDbl(topper1_packkg) else rs("packkg")=NULL
		if crateprodwgt5_1<>"" then rs("ProductWgt")=CDbl(crateprodwgt5_1) else rs("ProductWgt")=NULL
		if topper1cratewgt<>"" then rs("NetPackagingWgt")=CDbl(topper1cratewgt) else rs("NetPackagingWgt")=NULL

		rs("boxsize")=topperCrateType
		rs("packagingdesc")=null
		rs("packtariffcode")=null
		rs("ComponentWeight")=topperweightstoragefield
		rs("updatedon")=rs("updatedon") & Now() & " : "
		rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
		rs("boxqty")=toppercrateqty
		rs.update
		closers(rs)
	end if

	if wrappingtype=1 or wrappingtype=2 then
	sql = "Select * from packagingdata where purchase_no=" & purchaseno & " and componentID=5"
	'response.Write("sql=" & sql)
	'response.End()
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
		if not rs2.eof then
		do until rs2.eof
		rs2.delete
		rs2.movenext
		loop
		end if
	rs2.close
	set rs2=nothing
	end if
	if not statusChangeIsPermitted then
	jsmsg = jsmsg & "User does not have authority to reopen topper. Topper status change has not been made. All other changes have been saved."
	end if
end if
'END Add Topper QC

'Add accessories detail

If accessoriesrequired="y" then
	for i = 1 to 20
		exworksdateacc=request("exworksdateacc_"&i)
		if exworksdateacc <> "" then
			call updateAccessoryExWorksDates(con, purchaseno, exworksdateacc, i)
		end if

		acc_id = request("acc_id"&i)
		acc_supplier = request("acc_supplier"&i)
		acc_ponumber=request("acc_ponumber"&i)
		acc_podate=request("acc_podate"&i)
		'response.Write(acc_podate)
		'response.end
		acc_eta=request("acc_eta"&i)
		acc_received=request("acc_received"&i)
		acc_checked=request("acc_checked"&i)
		acc_special=request("acc_special"&i)
		acc_qtyfollow=request("acc_qtyfollow"&i)
		acc_delivered=request("acc_delivered"&i)
		acc_status=request("acc_status"&i)
		acc_packtariffcode=request("acc_packtariffcode"&i)
		
		acc_packdepth=request("acc_length"&i)
		acc_packheight=request("acc_height"&i)
		acc_packkg=request("acc_weight"&i)
		acc_packedwith=request("acc_packedwith"&i)
		
	
		if acc_ponumber<>"" then acc_status=10
		if acc_received<>"" then acc_status=110
		if acc_checked<>"" then acc_status=120
		if acc_delivered<>"" then acc_status=70
		if acc_qtyfollow>0 then acc_status=130
	
		if acc_id <> "" then
		if acc_podate="" then
		  acc_podate = "null" 
		  else
		  acc_podate = "'" & toMysqlDate(acc_podate) & "'"
		end if
		if acc_eta="" then
		  acc_eta = "null" 
		  else
		  acc_eta = "'" & toMysqlDate(acc_eta) & "'"
		end if
		if acc_received="" then
		  acc_received = "null" 
		  else
		  acc_received = "'" & toMysqlDate(acc_received) & "'"
		end if
		if acc_checked="" then
		  acc_checked = "null" 
		  else
		  acc_checked = "'" & toMysqlDate(acc_checked) & "'"
		end if
		if acc_delivered="" then
		  acc_delivered = "null" 
		  else
		  acc_delivered = "'" & toMysqlDate(acc_delivered) & "'"
		end if
		sql = "update orderaccessory set supplier='" & replaceQuotes(acc_supplier) & "',ponumber='" & replaceQuotes(acc_ponumber) & "',podate=" & acc_podate & ",eta=" & acc_eta & ",received=" & acc_received & ",checked=" & acc_checked & ",specialinstructions='" & replaceQuotes(acc_special) & "',qtytofollow=" & replaceQuotes(acc_qtyfollow) & ",delivered=" & acc_delivered & ",tariffcode='" & replaceQuotes(acc_packtariffcode) & "',status='" & acc_status & "' where orderaccessory_id=" & acc_id
		con.execute(sql)
		'response.Write("sql=" & sql)
		'response.End()
		
			if wrappingtype=3 or wrappingtype=2 then
			sql = "select * from packagingdata where (CompPartNo=1 or CompPartNo=2) and purchase_no=" & purchaseno & " and componentID=9"
			Set rs = getMysqlUpdateRecordSet(sql, con)
			if not rs.eof then
				do until rs.eof
				rs.delete
				rs.update
				rs.movenext
				loop
			end if
			rs.close
			set rs=nothing
			
			sql = "select * from packagingdata where CompPartNo=" & acc_id & " and purchase_no=" & purchaseno & " and componentID=9"
			Set rs = getMysqlUpdateRecordSet(sql, con)
				if rs.eof then
					rs.AddNew
				end if
				rs("purchase_no")=purchaseno
				rs("componentid")=9
				rs("CompPartNo")=acc_id
				rs("packtariffcode")=acc_packtariffcode
				rs("PackedWith")=acc_packedwith
				
				if acc_packdesc<>"" then rs("PackagingDesc")=acc_packdesc else rs("PackagingDesc")=null
				if acc_packwidth<>"" then rs("packwidth")=acc_packwidth else rs("packwidth")=null
				if acc_packheight<>"" then rs("packheight")=acc_packheight else rs("packheight")=null
				if acc_packdepth<>"" then rs("packdepth")=acc_packdepth else rs("packdepth")=null
				if acc_packkg<>"" then rs("packkg")=acc_packkg else rs("packkg")=null
				if acc1boxsize<>"" then rs("boxsize")=acc1boxsize else rs("boxsize")=null
				'if acc1kg<>"" then rs("packkg")=acc1kg else rs("packkg")=null
				rs("updatedon")=rs("updatedon") & Now() & " : "
				rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
				'if request("accBoxPackedWith")<>"" then rs("PackedWith")=request("accBoxPackedWith") else rs("PackedWith")=null
				rs.update
				closers(rs)
			end if
		end if
	next

	currentCompId = 9
	sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
	set rs = getMysqlQueryRecordSet(sql, con)
	newRowRequired = false
	statusChangeIsPermitted = true
	if rs.eof then
	newRowRequired = true
	else
		if accessoriesstatus<>"n" then
		statusChangeIsPermitted = isStatusChangePermitted(cint(rs("qc_statusid")), cint(accessoriesstatus))
			if statusChangeIsPermitted and CInt(rs("qc_statusid"))<>CInt(accessoriesstatus) then
			newRowRequired = true
			end if
		End if
	end if

	if newRowRequired then
	historyRowId = copyHistoryRow(con, purchaseno, currentCompId)
		if historyRowId = 0 then
		call insertQcHistoryRowIfNotExists(con, currentCompId, purchaseno, 0, retrieveuserid(), 0)
		sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
		set rs2 = getMysqlQueryRecordSet(sql, con)
		historyRowId = rs2("qc_historyid")
		closers(rs2)
		end if
	else
		historyRowId = rs("qc_historyid")
	end if
	closers(rs)

	sql = "Select * from qc_history where qc_historyid=" & historyRowId
	Set rs = getMysqlUpdateRecordSet(sql, con)
	
	rs("updatedby")=retrieveuserid()
	'If accessoryfabricstatus<>"n" then rs("fabricstatus")=accessoryfabricstatus else rs("fabricstatus") = Null
	If accessoriesdeldate<>"" then rs("deliverydate")=accessoriesdeldate else rs("deliverydate") = Null
	If accessoryporaised<>"" then rs("poraiseddate")=accessoryporaised else rs("poraiseddate") = Null
	If accessorypackeddate<>"" then rs("packeddate")=accessorypackeddate else rs("packeddate") = Null
	If accessoriesstatus<>"n" and statusChangeIsPermitted then rs("qc_statusid")=accessoriesstatus
	if accdelmethod<>"" then rs("deliverymethod")=accdelmethod else rs("deliverymethod") = null
	rs.update
	closers(rs)

	'add packaging info
	if wrappingtype=2 then
	'sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=9"
	'	Set rs = getMysqlUpdateRecordSet(sql, con)
	'	if rs.eof then
	'		rs.AddNew
	'	end if
	'	if acc_packdesc<>"" then rs("PackagingDesc")=acc_packdesc else rs("PackagingDesc")=null
	'	if acc_packwidth<>"" then rs("packwidth")=acc_packwidth else rs("packwidth")=null
	'	if acc_packheight<>"" then rs("packheight")=acc_packheight else rs("packheight")=null
	'	if acc_packdepth<>"" then rs("packdepth")=acc_packdepth else rs("packdepth")=null
	'	if acc_packkg<>"" then rs("packkg")=acc_packkg else rs("packkg")=null
	'	rs.update
	'	closers(rs)
	end if
	if wrappingtype=4 then
		sql = "select * from packagingdata where CompPartNo>1 and purchase_no=" & purchaseno & " and componentID=9"
			Set rs = getMysqlUpdateRecordSet(sql, con)
			if not rs.eof then
				do until rs.eof
				rs.delete
				rs.update
				rs.movenext
				loop
			end if
			rs.close
			set rs=nothing
		if accCrateType = "Special Size Crate" and accCrateType2 = "Special Size Crate" and accessoriescrateqty = 2 then
			accessoriescrateqty = accessoriescrateqty / 2 ' its 1 crate of each type
			sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=9"
			Set rs = getMysqlUpdateRecordSet(sql, con)
			if rs.eof then
				rs.AddNew
			end if
			rs("comppartno")=2
			rs("purchase_no")=purchaseno
			rs("componentid")=9
			rs("packwidth")=acc2_packwidth
			rs("packheight")=acc2_packheight
			rs("packdepth")=acc2_packdepth
			if acc2_packkg<>"" then rs("packkg")=CDbl(acc2_packkg) else rs("packkg")=NULL
			if crateprodwgt9_2<>"" then rs("ProductWgt")=CDbl(crateprodwgt9_2) else rs("ProductWgt")=NULL
			if acc2cratewgt<>"" then rs("NetPackagingWgt")=CDbl(acc2cratewgt) else rs("NetPackagingWgt")=NULL
			rs("boxsize")=accCrateType2
			rs("packagingdesc")=null
			rs("packtariffcode")=null
			rs("packedwith")=0
			rs("ComponentWeight")=accweightstoragefield
			rs("updatedon")=rs("updatedon") & Now() & " : "
			rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
			rs("boxqty")=accessoriescrateqty
			rs.update
			closers(rs)
		else
			sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=9"
			Set rs = getMysqlUpdateRecordSet(sql, con)
			if not rs.eof then
				rs.delete
			end if
		end if
	
	sql = "Select * from packagingdata where compPartNo=1 and purchase_no=" & purchaseno & " and componentID=9"
	Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
		rs.AddNew
		end if
	rs("purchase_no")=purchaseno
	rs("componentid")=9
	if acc_packdesc<>"" then rs("PackagingDesc")=acc_packdesc else rs("PackagingDesc")=null
	if acc1_packwidth<>"" then rs("packwidth")=acc1_packwidth else rs("packwidth")=null
	if acc1_packheight<>"" then rs("packheight")=acc1_packheight else rs("packheight")=null
	if acc1_packdepth<>"" then rs("packdepth")=acc1_packdepth else rs("packdepth")=null
	if acc1_packkg<>"" then rs("packkg")=CDbl(acc1_packkg) else rs("packkg")=NULL
	if crateprodwgt9_1<>"" then rs("ProductWgt")=CDbl(crateprodwgt9_1) else rs("ProductWgt")=NULL
	if acc1cratewgt<>"" then rs("NetPackagingWgt")=CDbl(acc1cratewgt) else rs("NetPackagingWgt")=NULL
	if accCrateType<>"" then rs("boxsize")=accCrateType else rs("boxsize")=null
	rs("updatedon")=rs("updatedon") & Now() & " : "
	rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
	if request("accPackedWith")<>"" then rs("PackedWith")=request("accPackedWith") else rs("PackedWith")=null
	rs("ComponentWeight")=accweightstoragefield
	rs("boxqty")=accessoriescrateqty
	rs.update
	closers(rs)
	end if
	
	if wrappingtype=1 then
	sql = "Select * from packagingdata where (comppartno=1 or comppartno>2) and purchase_no=" & purchaseno & " and componentID=9"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
			
		else
		do until rs.eof
		rs.delete
		rs.update
		rs.movenext
		loop
		end if
		closers(rs)
		
	sql = "Select * from orderaccessory where purchase_no=" & purchaseno & ""
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
			
		else
			do until rs.eof
			rs("tariffcode")=null
		rs.movenext
		loop
		end if
		closers(rs)
	end if



	if not statusChangeIsPermitted then
	jsmsg = jsmsg & "User does not have authority to reopen accessories. Accessories status change has not been made. All other changes have been saved."
	end if
end if
'END Add accessories QC

'Add Base QC
If baserequired="y" then
	currentCompId = 3
	sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
	set rs = getMysqlQueryRecordSet(sql, con)
	newRowRequired = false
	statusChangeIsPermitted = true
	if rs.eof then
		newRowRequired = true
	else
		if basestatus<>"n" then
			statusChangeIsPermitted = isStatusChangePermitted(cint(rs("qc_statusid")), cint(basestatus))
			if statusChangeIsPermitted and CInt(rs("qc_statusid"))<>CInt(basestatus) then
				newRowRequired = true
			end if
		End if
	end if
	
	if newRowRequired then
		historyRowId = copyHistoryRow(con, purchaseno, currentCompId)
		if historyRowId = 0 then
			call insertQcHistoryRowIfNotExists(con, currentCompId, purchaseno, 0, retrieveuserid(), 0)
			sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
			set rs2 = getMysqlQueryRecordSet(sql, con)
			historyRowId = rs2("qc_historyid")
			closers(rs2)
		end if
	else
		historyRowId = rs("qc_historyid")
	end if
	closers(rs)
	
	sql = "Select * from qc_history where qc_historyid=" & historyRowId
	Set rs = getMysqlUpdateRecordSet(sql, con)
	
	rs("updatedby")=retrieveuserid()
	if boxcut<>"" then rs("cut")=boxcut else rs("cut")=null
	if boxmachined<>"" then rs("machined")=boxmachined else rs("machined")=null
	if boxframe<>"" then rs("framed")=boxframe else rs("framed")=null
	if baseprepped<>"" then rs("prepped")=baseprepped else rs("prepped")=null
	If basemadeat<>"n" then rs("madeat")=basemadeat else rs("madeat")=Null
	baseemailto="SavoirAdminProductionLondon@savoirbeds.co.uk" 
	if basemadeat="1" then 
		baseemailto="SavoirAdminProductionCardiff@savoirbeds.co.uk" 
		baseemailmadeat="Cardiff"
	end if
	if basemadeat="2" then 
		baseemailto="SavoirAdminProductionLondon@savoirbeds.co.uk" 
		baseemailmadeat="London"
	end if
	If basebcwexpected<>"" then rs("bcwexpected")=basebcwexpected else rs("bcwexpected") = Null
	If basebcwwarehouse<>"" then rs("bcwwarehouse")=basebcwwarehouse else rs("bcwwarehouse") = Null
	If basedeldate<>"" then rs("deliverydate")=basedeldate else rs("deliverydate") = Null
	If basestatus<>"n" and statusChangeIsPermitted then rs("qc_statusid")=basestatus
	if basestatus=20 and statusChangeIsPermitted then rs("Issueddate")=now()
	if basestatus<20 and statusChangeIsPermitted then rs("issueddate")=null
	'response.Write("basefabricstats=" & basefabricstatus)
	If basefabricstatus<>"n" then rs("fabricstatus")=basefabricstatus else rs("fabricstatus")=Null
	If basefinished<>"" then rs("finished")=basefinished else rs("finished") = Null
	If boxtickingbatchno<>"" then rs("tickingbatchno")=boxtickingbatchno else rs("tickingbatchno")=Null
	If basemadeby<>"n" then rs("madeby")=basemadeby else rs("madeby")=null
	if basesupplier<>"" then rs("supplier")=basesupplier else rs("supplier")=null
	if baseponumber<>"" then rs("ponumber")=baseponumber else rs("ponumber")=null
	if basepodate<>"" then rs("podate")=basepodate else rs("podate")=null
	if basefabricexpecteddate<>"" then rs("fabricexpected")=basefabricexpecteddate else rs("fabricexpected")=null
	if basefabricrecdate<>"" then rs("fabricreceived")=basefabricrecdate else rs("fabricreceived")=null
	if basecuttingsent<>"" then rs("cuttingsent")=basecuttingsent else rs("cuttingsent")=null
	if basefrTreatingSent<>"" then rs("FRTreatmentSent")=basefrTreatingSent else rs("FRTreatmentSent")=null
	if basefrTreatingReceived<>"" then rs("FRTreatmentReceived")=basefrTreatingReceived else rs("FRTreatmentReceived")=null
	if isNull(rs("confirmeddate")) and baseconfirmeddate<>"" then basefabemail=baseconfirmeddate
	if baseconfirmeddate<>"" then rs("confirmeddate")=baseconfirmeddate else rs("confirmeddate")=null
	if basetobcwdate<>"" then rs("senttobcw")=basetobcwdate else rs("senttobcw")=null
	if basefabricprice<>"" then rs("fabricprice")=basefabricprice else rs("fabricprice")=null
	if basefabricqty<>"" then rs("fabricqty")=basefabricqty else rs("fabricqty")=null
	if basedelmethod<>"" then rs("deliverymethod")=basedelmethod else rs("deliverymethod") = null
	rs.update
	closers(rs)
	
	if base1boxsize<>"" then
if wrappingtype=3 then
sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=3"
Set rs = getMysqlUpdateRecordSet(sql, con)
if rs.eof then
rs.AddNew
end if
rs("purchase_no")=purchaseno
rs("componentid")=3
rs("boxsize")=base1boxsize
if base1kg<>"" then rs("packkg")=base1kg else rs("packkg")=null
if boxprodwgt3_1<>"" then rs("ProductWgt")=CDbl(boxprodwgt3_1) else rs("ProductWgt")=NULL
if base1boxwgt<>"" then rs("NetPackagingWgt")=CDbl(base1boxwgt) else rs("NetPackagingWgt")=NULL
rs("updatedon")=rs("updatedon") & Now() & " : "
rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
rs.update
closers(rs)
end if
end if

if base2boxsize<>"" then
if wrappingtype=3 then
sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=3"
Set rs = getMysqlUpdateRecordSet(sql, con)
if rs.eof then
rs.AddNew
end if
rs("comppartno")=2
rs("purchase_no")=purchaseno
rs("componentid")=3
rs("boxsize")=base2boxsize
if base2kg<>"" then rs("packkg")=base2kg else rs("packkg")=0
if boxprodwgt3_2<>"" then rs("ProductWgt")=CDbl(boxprodwgt3_2) else rs("ProductWgt")=NULL
if base2boxwgt<>"" then rs("NetPackagingWgt")=CDbl(base2boxwgt) else rs("NetPackagingWgt")=NULL
rs("updatedon")=rs("updatedon") & Now() & " : "
rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
rs.update
closers(rs)
end if
end if



if wrappingtype=4 then
	if baseCrateType = "Special Size Crate" and baseCrateType2 = "Special Size Crate" and basecrateqty = 2 then
		basecrateqty = basecrateqty / 2 ' its 1 crate of each type
		sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=3"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
			rs.AddNew
		end if
		rs("comppartno")=2
		rs("purchase_no")=purchaseno
		rs("componentid")=3
		rs("packwidth")=base2_packwidth
		rs("packheight")=base2_packheight
		rs("packdepth")=base2_packdepth
		if base2_packkg<>"" then rs("packkg")=CDbl(base2_packkg) else rs("packkg")=NULL
		if crateprodwgt3_2<>"" then rs("ProductWgt")=CDbl(crateprodwgt3_2) else rs("ProductWgt")=NULL
		if base2cratewgt<>"" then rs("NetPackagingWgt")=CDbl(base2cratewgt) else rs("NetPackagingWgt")=NULL

		rs("boxsize")=baseCrateType2
		rs("packagingdesc")=null
		rs("packtariffcode")=null
		rs("ComponentWeight")=baseweightstoragefield
		rs("updatedon")=rs("updatedon") & Now() & " : "
		rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
		rs("boxqty")=basecrateqty
		rs.update
		closers(rs)
	else
		sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=3"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if not rs.eof then
			rs.delete
		end if
	end if
	sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=3"
	Set rs = getMysqlUpdateRecordSet(sql, con)
	if rs.eof then
	rs.AddNew
	end if
	rs("comppartno")=1
	rs("purchase_no")=purchaseno
	rs("componentid")=3
	rs("packwidth")=base1_packwidth
	rs("packheight")=base1_packheight
	rs("packdepth")=base1_packdepth
	if base1_packkg<>"" then rs("packkg")=CDbl(base1_packkg) else rs("packkg")=NULL
	if crateprodwgt3_1<>"" then rs("ProductWgt")=CDbl(crateprodwgt3_1) else rs("ProductWgt")=NULL
	if base1cratewgt<>"" then rs("NetPackagingWgt")=CDbl(base1cratewgt) else rs("NetPackagingWgt")=NULL
	rs("boxsize")=baseCrateType
	rs("packagingdesc")=null
	rs("packtariffcode")=null
	rs("ComponentWeight")=baseweightstoragefield
	rs("updatedon")=rs("updatedon") & Now() & " : "
	rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
	rs("boxqty")=basecrateqty
	rs.update
	closers(rs)
end if

if wrappingtype=1 or wrappingtype=2 then
sql = "Select * from packagingdata where purchase_no=" & purchaseno & " and componentID=3"
'response.Write("sql=" & sql)
'response.End()
Set rs2 = getMysqlUpdateRecordSet(sql, con)
if not rs2.eof then
do until rs2.eof
rs2.delete
rs2.movenext
loop
end if
rs2.close
set rs2=nothing
end if
if not statusChangeIsPermitted then
jsmsg = jsmsg & "User does not have authority to reopen base. Base status change has not been made. All other changes have been saved."
end if
end if
'END Add mattress QC

'Add headboard QC
If headboardrequired="y" then
	currentCompId = 8
	sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
	set rs = getMysqlQueryRecordSet(sql, con)
	newRowRequired = false
	statusChangeIsPermitted = true
	if rs.eof then
		newRowRequired = true
	else
		if headboardstatus<>"n" then
			statusChangeIsPermitted = isStatusChangePermitted(cint(rs("qc_statusid")), cint(headboardstatus))
			if statusChangeIsPermitted and CInt(rs("qc_statusid"))<>CInt(headboardstatus) then
				newRowRequired = true
			end if
		End if
	end if
	
	if newRowRequired then
		historyRowId = copyHistoryRow(con, purchaseno, currentCompId)
		if historyRowId = 0 then
			call insertQcHistoryRowIfNotExists(con, currentCompId, purchaseno, 0, retrieveuserid(), 0)
			sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
			set rs2 = getMysqlQueryRecordSet(sql, con)
			historyRowId = rs2("qc_historyid")
			closers(rs2)
		end if
	else
		historyRowId = rs("qc_historyid")
	end if
	closers(rs)
	
	sql = "Select * from qc_history where qc_historyid=" & historyRowId
	Set rs = getMysqlUpdateRecordSet(sql, con)
	
	rs("updatedby")=retrieveuserid()
	If headboardframe<>"" then rs("framed")=headboardframe else rs("framed") = Null
	If headboardprepped<>"" then rs("prepped")=headboardprepped else rs("prepped") = Null
	If headboardmadeat<>"n" then rs("madeat")=headboardmadeat else rs("madeat")=Null
	hbemailto="SavoirAdminProductionLondon@savoirbeds.co.uk"
	if headboardmadeat="1" then 
		hbemailto="SavoirAdminProductionCardiff@savoirbeds.co.uk"
		hbemailmadeat="Cardiff"
	end if
	if headboardmadeat="2" then 
		hbemailto="SavoirAdminProductionLondon@savoirbeds.co.uk"
		hbemailmadeat="London"
	end if
	If headboardlegsmadeat<>"n" then rs("headboardlegsmadeat")=headboardlegsmadeat else rs("headboardlegsmadeat")=Null
	If headboardbcwexpected<>"" then rs("bcwexpected")=headboardbcwexpected else rs("bcwexpected") = Null
	If headboardbcwwarehouse<>"" then rs("bcwwarehouse")=headboardbcwwarehouse else rs("bcwwarehouse") = Null
	If headboarddeldate<>"" then rs("deliverydate")=headboarddeldate else rs("deliverydate") = Null
	If headboardstatus<>"n" and statusChangeIsPermitted then rs("qc_statusid")=headboardstatus
	If headboardfabricstatus<>"n" then rs("fabricstatus")=headboardfabricstatus else rs("fabricstatus")=Null
	if headboardfabricstatus=20 and statusChangeIsPermitted then rs("Issueddate")=now()
	if headboardfabricstatus<20 and statusChangeIsPermitted then rs("issueddate")=null
	If headboardfinished<>"" then rs("finished")=headboardfinished else rs("finished") = Null
	if headboardsupplier<>"" then rs("supplier")=headboardsupplier else rs("supplier")=null
	if headboardponumber<>"" then rs("ponumber")=headboardponumber else rs("ponumber")=null
	if headboardpodate<>"" then rs("podate")=headboardpodate else rs("podate")=null
	if headboardfabricexpecteddate<>"" then rs("fabricexpected")=headboardfabricexpecteddate else rs("fabricexpected")=null
	if headboardfabricrecdate<>"" then rs("fabricreceived")=headboardfabricrecdate else rs("fabricreceived")=null
	if headboardcuttingsent<>"" then rs("cuttingsent")=headboardcuttingsent else rs("cuttingsent")=null
	if frTreatingSent<>"" then rs("FRTreatmentSent")=frTreatingSent else rs("FRTreatmentSent")=null
	if frTreatingReceived<>"" then rs("FRTreatmentReceived")=frTreatingReceived else rs("FRTreatmentReceived")=null
	if isNull(rs("confirmeddate")) and headboardconfirmeddate<>"" then headboardfabemail=headboardconfirmeddate
	if headboardconfirmeddate<>"" then rs("confirmeddate")=headboardconfirmeddate else rs("confirmeddate")=null
	if headboardtobcwdate<>"" then rs("senttobcw")=headboardtobcwdate else rs("senttobcw")=null
	if headboardfabricprice<>"" then rs("fabricprice")=headboardfabricprice else rs("fabricprice")=null
	if headboardfabricqty<>"" then rs("fabricqty")=headboardfabricqty else rs("fabricqty")=null
	if headboarddetails<>"" then rs("details")=headboarddetails else rs("details")=null
	if headboarddelmethod<>"" then rs("deliverymethod")=headboarddelmethod else rs("deliverymethod") = null
	rs.update
	closers(rs)
	
'add packaging info if normal wrap
if hb_packwidth="" and hb_packheight="" and hb_packdepth="" and hb_packkg="" then
else
if wrappingtype=1 or wrappingtype=2 then
sql = "Select * from packagingdata where purchase_no=" & purchaseno & " and componentID=8"
Set rs = getMysqlUpdateRecordSet(sql, con)
if rs.eof then
rs.AddNew
end if
rs("purchase_no")=purchaseno
rs("componentid")=8
rs("boxsize")=null
if hb_packwidth<>"" then rs("packwidth")=hb_packwidth
if hb_packheight<>"" then rs("packheight")=hb_packheight
if hb_packdepth<>"" then rs("packdepth")=hb_packdepth
if hb_packkg<>"" then rs("packkg")=hb_packkg else rs("packkg")=null
if hbCrateType<>"" then rs("boxsize")=hbCrateType else rs("boxsize")=null
rs("updatedon")=rs("updatedon") & Now() & " : "
rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
rs.update
closers(rs)
end if
end if
if hb1boxsize<>"" then
if wrappingtype=3 then
sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=8"
Set rs = getMysqlUpdateRecordSet(sql, con)
if rs.eof then
rs.AddNew
end if
rs("packwidth")=null
rs("packheight")=null
rs("packdepth")=null
rs("purchase_no")=purchaseno
rs("componentid")=8
rs("boxsize")=hb1boxsize
if hb1kg<>"" then rs("packkg")=hb1kg else rs("packkg")=null
if boxprodwgt8_1<>"" then rs("ProductWgt")=CDbl(boxprodwgt8_1) else rs("ProductWgt")=NULL
if hb1boxwgt<>"" then rs("NetPackagingWgt")=CDbl(hb1boxwgt) else rs("NetPackagingWgt")=NULL
rs("updatedon")=rs("updatedon") & Now() & " : "
rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
rs.update
closers(rs)
end if
end if

if wrappingtype=4 then
	if hbCrateType = "Special Size Crate" and hbCrateType2 = "Special Size Crate" and hbcrateqty = 2 then
		hbcrateqty = hbcrateqty / 2 ' its 1 crate of each type
		sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=8"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
			rs.AddNew
		end if
		rs("comppartno")=2
		rs("purchase_no")=purchaseno
		rs("componentid")=8
		rs("packwidth")=hb2_packwidth
		rs("packheight")=hb2_packheight
		rs("packdepth")=hb2_packdepth
		rs("packkg")=hb2_packkg
		if hb2_packkg<>"" then rs("packkg")=CDbl(hb2_packkg) else rs("packkg")=NULL
		if crateprodwgt8_2<>"" then rs("ProductWgt")=CDbl(crateprodwgt8_2) else rs("ProductWgt")=NULL
		if hb2cratewgt<>"" then rs("NetPackagingWgt")=CDbl(hb2cratewgt) else rs("NetPackagingWgt")=NULL
		rs("boxsize")=hbCrateType2
		rs("packagingdesc")=null
		rs("packtariffcode")=null
		rs("ComponentWeight")=hbweightstoragefield
		rs("updatedon")=rs("updatedon") & Now() & " : "
		rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
		rs("boxqty")=hbcrateqty
		rs.update
		closers(rs)
	else
		sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=8"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if not rs.eof then
			rs.delete
		end if
	end if
sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=8"
Set rs = getMysqlUpdateRecordSet(sql, con)
if rs.eof then
rs.AddNew
end if
rs("comppartno")=1
rs("purchase_no")=purchaseno
rs("componentid")=8
rs("packwidth")=safeDbl(hb1_packwidth)
rs("packheight")=safeDbl(hb1_packheight)
rs("packdepth")=safeDbl(hb1_packdepth)
if hb1_packkg<>"" then rs("packkg")=safeDbl(hb1_packkg) else rs("packkg")=NULL
if crateprodwgt8_1<>"" then rs("ProductWgt")=CDbl(crateprodwgt8_1) else rs("ProductWgt")=NULL
if hb1cratewgt<>"" then rs("NetPackagingWgt")=CDbl(hb1cratewgt) else rs("NetPackagingWgt")=NULL
rs("boxsize")=hbCrateType
rs("packagingdesc")=null
rs("packtariffcode")=null
rs("ComponentWeight")=safeDbl(hbweightstoragefield)
rs("ProductWgt")=crateprodwgt8_1
rs("NetPackagingWgt")=hb1cratewgt
rs("updatedon")=rs("updatedon") & Now() & " : "
rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
rs("boxqty")=defaultInt(hbcrateqty, 0)
rs.update
closers(rs)
end if



if not statusChangeIsPermitted then
jsmsg = jsmsg & "User does not have authority to reopen headboard. Headboard status change has not been made. All other changes have been saved."
end if
end if
'END Add headboard QC

'Add valance QC
If valancerequired="y" then
	currentCompId = 6
	sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
	set rs = getMysqlQueryRecordSet(sql, con)
	newRowRequired = false
	statusChangeIsPermitted = true
	if rs.eof then
		newRowRequired = true
	else
		if valancestatus<>"n" then
			statusChangeIsPermitted = isStatusChangePermitted(cint(rs("qc_statusid")), cint(valancestatus))
			if statusChangeIsPermitted and CInt(rs("qc_statusid"))<>CInt(valancestatus) then
				newRowRequired = true
			end if
		End if
	end if
	
	if newRowRequired then
		historyRowId = copyHistoryRow(con, purchaseno, currentCompId)
		if historyRowId = 0 then
			call insertQcHistoryRowIfNotExists(con, currentCompId, purchaseno, 0, retrieveuserid(), 0)
			sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
			set rs2 = getMysqlQueryRecordSet(sql, con)
			historyRowId = rs2("qc_historyid")
			closers(rs2)
		end if
	else
		historyRowId = rs("qc_historyid")
	end if
	closers(rs)
	
	sql = "Select * from qc_history where qc_historyid=" & historyRowId
	Set rs = getMysqlUpdateRecordSet(sql, con)
	
	rs("updatedby")=retrieveuserid()
	If valancemadeat<>"n" then rs("madeat")=valancemadeat else rs("madeat")=Null
	valemailto="SavoirAdminProductionLondon@savoirbeds.co.uk"
	if valancemadeat="1" then 
		valemailto="SavoirAdminProductionCardiff@savoirbeds.co.uk"
		valemailmadeat="Cardiff"
	end if
	if valancemadeat="2" then 
		valemailto="SavoirAdminProductionLondon@savoirbeds.co.uk"
		valemailmadeat="London"
	end if
	If valancebcwexpected<>"" then rs("bcwexpected")=valancebcwexpected else rs("bcwexpected") = Null
	If valancebcwwarehouse<>"" then rs("bcwwarehouse")=valancebcwwarehouse else rs("bcwwarehouse") = Null
	If valancedeldate<>"" then rs("deliverydate")=valancedeldate else rs("deliverydate") = Null
	If valancestatus<>"n" and statusChangeIsPermitted then rs("qc_statusid")=valancestatus
	if valancestatus=20 and statusChangeIsPermitted then rs("Issueddate")=now()
	if valancestatus<20 and statusChangeIsPermitted then rs("issueddate")=null
	If valancefabricstatus<>"n" then rs("fabricstatus")=valancefabricstatus else rs("fabricstatus")=Null
	If valancefinished<>"" then rs("finished")=valancefinished else rs("finished") = Null
	if valancesupplier<>"" then rs("supplier")=valancesupplier else rs("supplier")=null
	if valanceponumber<>"" then rs("ponumber")=valanceponumber else rs("ponumber")=null
	'if valancelength<>"" then rs("valancelength")=valancelength else rs("valancelength")=null
	'if valancewidth<>"" then rs("valancewidth")=valancewidth else rs("valancewidth")=null
	'if valancedrop<>"" then rs("valancedrop")=valancedrop else rs("valancedrop")=null
	if sendtosddate<>"" then rs("sendtosddate")=sendtosddate else rs("sendtosddate")=null
	if valancepodate<>"" then rs("podate")=valancepodate else rs("podate")=null
	if valancefabricexpecteddate<>"" then rs("fabricexpected")=valancefabricexpecteddate else rs("fabricexpected")=null
	if valancefabricrecdate<>"" then rs("fabricreceived")=valancefabricrecdate else rs("fabricreceived")=null
	if valancecuttingsent<>"" then rs("cuttingsent")=valancecuttingsent else rs("cuttingsent")=null
	if valancefrTreatingSent<>"" then rs("FRTreatmentSent")=valancefrTreatingSent else rs("FRTreatmentSent")=null
	if valancefrTreatingReceived<>"" then rs("FRTreatmentReceived")=valancefrTreatingReceived else rs("FRTreatmentReceived")=null
	if isNull(rs("confirmeddate")) and valanceconfirmeddate<>"" then valancefabemail=valanceconfirmeddate
	if valanceconfirmeddate<>"" then rs("confirmeddate")=valanceconfirmeddate else rs("confirmeddate")=null
	if valancefabricprice<>"" then rs("fabricprice")=valancefabricprice else rs("fabricprice")=null
	if valancefabricqty<>"" then rs("fabricqty")=valancefabricqty else rs("fabricqty")=null
	if valancedetails<>"" then rs("details")=valancedetails else rs("details")=null
	if valancedelmethod<>"" then rs("deliverymethod")=valancedelmethod else rs("deliverymethod") = null
	rs.update
	closers(rs)
	
if wrappingtype=4 then
if valanceCrateType = "Special Size Crate" and valanceCrateType2 = "Special Size Crate" and valancecrateqty = 2 then
		valancecrateqty = valancecrateqty / 2 ' its 1 crate of each type
		sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=6"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
			rs.AddNew
		end if
		rs("comppartno")=2
		rs("purchase_no")=purchaseno
		rs("componentid")=6
		rs("packwidth")=valance2_packwidth
		rs("packheight")=valance2_packheight
		rs("packdepth")=valance2_packdepth
		rs("packkg")=valance2_packkg
		rs("boxsize")=valanceCrateType2
		rs("packagingdesc")=null
		rs("packtariffcode")=null
		rs("ComponentWeight")=valanceweightstoragefield
		rs("updatedon")=rs("updatedon") & Now() & " : "
		rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
		rs("boxqty")=valancecrateqty
		rs.update
		closers(rs)
	else
		sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=6"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if not rs.eof then
			rs.delete
		end if
	end if

sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=6"
Set rs = getMysqlUpdateRecordSet(sql, con)
if rs.eof then
rs.AddNew
end if
rs("comppartno")=1
rs("purchase_no")=purchaseno
rs("componentid")=6
rs("packwidth")=valance1_packwidth
rs("packheight")=valance1_packheight
rs("packdepth")=valance1_packdepth
rs("packkg")=valance1_packkg
if valanceCrateType<>"" then 
	rs("boxsize")=valanceCrateType
	rs("ProductWgt")=crateprodwgt6_1
	rs("NetPackagingWgt")=valance1cratewgt 
	else 
	rs("boxsize")=null
end if
rs("packagingdesc")=null
rs("packtariffcode")=null
rs("updatedon")=rs("updatedon") & Now() & " : "
rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
if request("accPackedWith")<>"" then rs("PackedWith")=request("accPackedWith") else rs("PackedWith")=null
rs("ComponentWeight")=CInt(valanceweightstoragefield)
rs("boxqty")=valancecrateqty
rs.update
closers(rs)
end if

if valance1boxsize<>"" and mattressrequired="n" and baserequired="n" and topperrequired="n" and headboardrequired="n" then
if wrappingtype=3 then
sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=6"
Set rs = getMysqlUpdateRecordSet(sql, con)
if rs.eof then
rs.AddNew
end if
rs("packwidth")=null
rs("packheight")=null
rs("packdepth")=null
rs("purchase_no")=purchaseno
rs("componentid")=6
rs("boxsize")=valance1boxsize
rs("ProductWgt")=boxprodwgt6_1
rs("NetPackagingWgt")=valance1boxwgt
if valance1kg<>"" then rs("packkg")=valance1kg else rs("packkg")=0
rs("updatedon")=rs("updatedon") & Now() & " : "
rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
rs.update
closers(rs)
end if
end if

if request("valancePackedWith")<>"" and (mattressrequired="y" or baserequired="y" or topperrequired="y" or headboardrequired="y" or accessoriesrequired="y" or legsrequired="y") then
	if wrappingtype=4 then
		sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=6"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
			rs.AddNew
		end if
		rs("packwidth")=null
		rs("packheight")=null
		rs("packdepth")=null
		rs("purchase_no")=purchaseno
		rs("componentid")=6
		rs("boxsize")=null
		rs("packkg")=0
		rs("updatedon")=rs("updatedon") & Now() & " : "
		rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
		'response.Write("vpw=" & request("valancePackedWith"))
		rs("Packedwith")=request("valancePackedWith")
		rs.update
		closers(rs)
	end if
end if

if request("valanceBoxPackedWith")<>"" and (mattressrequired="y" or baserequired="y" or topperrequired="y"  or accessoriesrequired="y" or legsrequired="y") then
if wrappingtype=3 then
sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=6"
Set rs = getMysqlUpdateRecordSet(sql, con)
if rs.eof then
rs.AddNew
end if
rs("packwidth")=null
rs("packheight")=null
rs("packdepth")=null
rs("purchase_no")=purchaseno
rs("componentid")=6
rs("boxsize")=null
rs("packkg")=0
rs("updatedon")=rs("updatedon") & Now() & " : "
rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
response.Write("vpw=" & request("valanceBoxPackedWith"))
rs("Packedwith")=request("valanceBoxPackedWith")
rs.update
closers(rs)
end if
end if

if request("accBoxPackedWith")<>"" and request("accBoxPackedWith")<>"0" and (mattressrequired="y" or baserequired="y" or topperrequired="y"  or valancerequired="y" or legsrequired="y") then
	if wrappingtype=3 then
		sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=9"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
			rs.AddNew
		end if
		rs("packwidth")=null
		rs("packheight")=null
		rs("packdepth")=null
		rs("purchase_no")=purchaseno
		rs("componentid")=9
		rs("boxsize")=null
		rs("packkg")=0
		rs("updatedon")=rs("updatedon") & Now() & " : "
		rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
		rs("Packedwith")=request("accBoxPackedWith")
		rs.update
		closers(rs)
	end if
	
end if

if wrappingtype=1 or wrappingtype=2 then
sql = "Select * from packagingdata where purchase_no=" & purchaseno & " and componentID=6"
'response.Write("sql=" & sql)
'response.End()
Set rs2 = getMysqlUpdateRecordSet(sql, con)
if not rs2.eof then
do until rs2.eof
rs2.delete
rs2.movenext
loop
end if
rs2.close
set rs2=nothing
end if

if not statusChangeIsPermitted then
jsmsg = jsmsg & "User does not have authority to reopen valance. Valance status change has not been made. All other changes have been saved."
end if
end if
'END Add valance QC

'Add legs detail
If legsrequired="y" then
currentCompId = 7
sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
set rs = getMysqlQueryRecordSet(sql, con)
newRowRequired = false
statusChangeIsPermitted = true
if rs.eof then
newRowRequired = true
else
if legsstatus<>"n" then
statusChangeIsPermitted = isStatusChangePermitted(cint(rs("qc_statusid")), cint(legsstatus))
if statusChangeIsPermitted and CInt(rs("qc_statusid"))<>CInt(legsstatus) then
newRowRequired = true
end if
End if
end if

if newRowRequired then
historyRowId = copyHistoryRow(con, purchaseno, currentCompId)
if historyRowId = 0 then
call insertQcHistoryRowIfNotExists(con, currentCompId, purchaseno, 0, retrieveuserid(), 0)
sql = "Select * from qc_history where componentid=" & currentCompId & " AND purchase_no = " & purchaseno & " order by QC_date desc"
set rs2 = getMysqlQueryRecordSet(sql, con)
historyRowId = rs2("qc_historyid")
closers(rs2)
end if
else
historyRowId = rs("qc_historyid")
end if
closers(rs)

sql = "Select * from qc_history where qc_historyid=" & historyRowId
Set rs = getMysqlUpdateRecordSet(sql, con)

rs("updatedby")=retrieveuserid()
if legsfinished<>"" then rs("finished")=legsfinished else rs("finished")=null
if legsprepped<>"" then rs("prepped")=legsprepped else rs("prepped")=null
If legsmadeat<>"n" then rs("madeat")=legsmadeat else rs("madeat")=Null
If legsbcwexpected<>"" then rs("bcwexpected")=legsbcwexpected else rs("bcwexpected") = Null
If legsbcwwarehouse<>"" then rs("bcwwarehouse")=legsbcwwarehouse else rs("bcwwarehouse") = Null
If legsdeldate<>"" then rs("deliverydate")=legsdeldate else rs("deliverydate") = Null
If legsstatus<>"n" and statusChangeIsPermitted then rs("qc_statusid")=legsstatus
if legsstatus=20 and statusChangeIsPermitted then rs("Issueddate")=now()
if legsstatus<20 and statusChangeIsPermitted then rs("issueddate")=null
if legsdelmethod<>"" then rs("deliverymethod")=legsdelmethod else rs("deliverymethod") = null
rs.update
closers(rs)

if wrappingtype=4 then
if legsCrateType = "Special Size Crate" and legsCrateType2 = "Special Size Crate" and legscrateqty = 2 then
		legscrateqty = legscrateqty / 2 ' its 1 crate of each type
		sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=7"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
			rs.AddNew
		end if
		rs("comppartno")=2
		rs("purchase_no")=purchaseno
		rs("componentid")=7
		rs("packwidth")=legs2_packwidth
		rs("packheight")=legs2_packheight
		rs("packdepth")=legs2_packdepth
		rs("packkg")=legs2_packkg
		rs("boxsize")=legsCrateType2
		rs("ProductWgt")=crateprodwgt7_2
		rs("NetPackagingWgt")=legs1cratewgt 
		rs("packagingdesc")=null
		rs("packtariffcode")=null
		rs("ComponentWeight")=legsweightstoragefield
		rs("updatedon")=rs("updatedon") & Now() & " : "
		rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
		rs("boxqty")=legscrateqty
		rs.update
		closers(rs)
	else
		sql = "Select * from packagingdata where comppartno=2 and purchase_no=" & purchaseno & " and componentID=7"
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if not rs.eof then
			rs.delete
		end if
	end if
sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=7"
Set rs = getMysqlUpdateRecordSet(sql, con)
if rs.eof then
rs.AddNew
end if
rs("comppartno")=1
rs("purchase_no")=purchaseno
rs("componentid")=7
rs("packwidth")=legs1_packwidth
rs("packheight")=legs1_packheight
rs("packdepth")=legs1_packdepth
rs("packkg")=legs1_packkg
rs("boxsize")=legsCrateType
	rs("ProductWgt")=crateprodwgt7_1
	rs("NetPackagingWgt")=legs1cratewgt 
rs("packagingdesc")=null
rs("packtariffcode")=null
rs("ComponentWeight")=legweightstoragefield
rs("updatedon")=rs("updatedon") & Now() & " : "
rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
if request("legsPackedWith")<>"" then rs("PackedWith")=request("legsPackedWith") else rs("PackedWith")=null
rs("boxqty")=legscrateqty
rs.update
closers(rs)
end if

if wrappingtype=3 then
sql = "Select * from packagingdata where comppartno=1 and purchase_no=" & purchaseno & " and componentID=7"
Set rs = getMysqlUpdateRecordSet(sql, con)
if rs.eof then
rs.AddNew
end if
rs("packwidth")=null
rs("packheight")=null
rs("packdepth")=null
rs("purchase_no")=purchaseno
rs("componentid")=7
rs("boxsize")=legs1boxsize
rs("packedwith")=null
if legs1kg<>"" then rs("packkg")=legs1kg else rs("packkg")=null
if boxprodwgt7_1<>"" then rs("ProductWgt")=CDbl(boxprodwgt7_1) else rs("ProductWgt")=NULL
if legs1boxwgt<>"" then rs("NetPackagingWgt")=CDbl(legs1boxwgt) else rs("NetPackagingWgt")=NULL
rs("updatedon")=rs("updatedon") & Now() & " : "
rs("updatedby")=rs("updatedby") & retrieveuserid() & " : "
rs.update
closers(rs)
end if



if wrappingtype=1 or wrappingtype=2 then
sql = "Select * from packagingdata where purchase_no=" & purchaseno & " and componentID=7"
'response.Write("sql=" & sql)
'response.End()
Set rs2 = getMysqlUpdateRecordSet(sql, con)
if not rs2.eof then
do until rs2.eof
rs2.delete
rs2.movenext
loop
end if
rs2.close
set rs2=nothing
end if

if not statusChangeIsPermitted then
jsmsg = jsmsg & "User does not have authority to reopen order legs. Legs status change has not been made. All other changes have been saved."
end if
end if
'END Add legs QC

' save order notes
ordernote_notetext = trim(request("ordernote_notetext"))
ordernote_action = request("ordernote_action")
ordernote_followupdate = request("ordernote_followupdate")

if ordernote_notetext <> "" then
call addOrderNote(con, ordernote_notetext, ordernote_action, ordernote_followupdate, purchaseno, "MANUAL")
end if

' update the order production completion date
call setOrderProductionCompletionDate(con, purchaseno)

function capitalise(str)
	dim words, word
	if isNull(str) or trim(str)="" then
	capitalise=""
	else
	words = split(trim(str), " ")
	for each word in words
	word = lcase(word)
	if len(word) > 0 then
	word = ucase(left(word,1)) & (right(word,len(word)-1))
	capitalise = capitalise & word & " "
	end if
	next
	capitalise = left(capitalise, len(capitalise)-1)
	end if
end function

'send fabric confirmation email if dataentered
if basefabemail<>"" then
emailsubject=""
fabricmsg=""
emailsubject=custname & " - " & orderno & " - "
if companyname<>"" then emailsubject=emailsubject & companyname & " - Base - Fabric Confirmed"
fabricmsg="<html><body style=""font-family:Arial, Helvetica;color:#000000;font-size:12px"">This auto generated email has been sent to the distribution group called " & baseemailto & ", and a copy has been sent to distribution group called SavoirAdminFabric@savoirbeds.co.uk , and confirms the following,<br /><br />"
if custname<>"" then fabricmsg=fabricmsg & "Customer Name: " & custname & "<br />"
if companyname<>"" then fabricmsg=fabricmsg & "Company: " & companyname & "<br />"
if orderno<>"" then fabricmsg=fabricmsg & "Order Number: " & orderno & "<br />"
if customerref<>"" then fabricmsg=fabricmsg & "Customer Ref: " & customerref & "<br />"
if baseemailmadeat<>"" then fabricmsg=fabricmsg & "Base made at: " & baseemailmadeat & "<br />"
if locationname<>"" then fabricmsg=fabricmsg & "Showroom: " & locationname & "<br />"
fabricmsg=fabricmsg & "Confirmed for: Base<br />"
fabricmsg=fabricmsg & "Fabric confirmed on: " & basefabemail & "<br />"
fabricmsg=fabricmsg & "</body></html>"
call sendBatchEmail(emailsubject, fabricmsg, "noreply@savoirbeds.co.uk", baseemailto, "", "SavoirAdminFabric@savoirbeds.co.uk", true, con)
end if

if valancefabemail<>"" then
emailsubject=""
fabricmsg=""
emailsubject=custname & " - " & orderno & " - "
if companyname<>"" then emailsubject=emailsubject & companyname & " - Valance - Fabric Confirmed"
fabricmsg="<html><body style=""font-family:Arial, Helvetica;color:#000000;font-size:12px"">This auto generated email has been sent to the distribution group called  " & valemailto & ", and a copy has been sent to distribution group called SavoirAdminFabric@savoirbeds.co.uk , and confirms the following,<br /><br />"
if custname<>"" then fabricmsg=fabricmsg & "Customer Name: " & custname & "<br />"
if companyname<>"" then fabricmsg=fabricmsg & "Company: " & companyname & "<br />"
if orderno<>"" then fabricmsg=fabricmsg & "Order Number: " & orderno & "<br />"
if customerref<>"" then fabricmsg=fabricmsg & "Customer Ref: " & customerref & "<br />"
if valemailmadeat<>"" then fabricmsg=fabricmsg & "Valance made at: " & valemailmadeat & "<br />"
if locationname<>"" then fabricmsg=fabricmsg & "Showroom: " & locationname & "<br />"
fabricmsg=fabricmsg & "Confirmed for: Valance<br />"
fabricmsg=fabricmsg & "Fabric confirmed on: " & valancefabemail & "<br />"
fabricmsg=fabricmsg & "</body></html>"
call sendBatchEmail(emailsubject, fabricmsg, "noreply@savoirbeds.co.uk", valemailto, "", "SavoirAdminFabric@savoirbeds.co.uk", true, con)
end if

if headboardfabemail<>"" then
emailsubject=""
fabricmsg=""
emailsubject=custname & " - " & orderno & " - "
if companyname<>"" then emailsubject=emailsubject & companyname & " - Headboard - Fabric Confirmed"
fabricmsg="<html><body style=""font-family:Arial, Helvetica;color:#000000;font-size:12px"">This auto generated email has been sent to the distribution group called  " & hbemailto & ", and a copy has been sent to distribution group called SavoirAdminFabric@savoirbeds.co.uk , and confirms the following,<br /><br />"
if custname<>"" then fabricmsg=fabricmsg & "Customer Name: " & custname & "<br />"
if companyname<>"" then fabricmsg=fabricmsg & "Company: " & companyname & "<br />"
if orderno<>"" then fabricmsg=fabricmsg & "Order Number: " & orderno & "<br />"
if customerref<>"" then fabricmsg=fabricmsg & "Customer Ref: " & customerref & "<br />"
if locationname<>"" then fabricmsg=fabricmsg & "Showroom: " & locationname & "<br />"
if hbemailmadeat<>"" then fabricmsg=fabricmsg & "Headboard made at: " & hbemailmadeat & "<br />"
fabricmsg=fabricmsg & "Confirmed for: Headboard<br />"
fabricmsg=fabricmsg & "Fabric confirmed on: " & headboardfabemail & "<br />"
fabricmsg=fabricmsg & "</body></html>"
call sendBatchEmail(emailsubject, fabricmsg, "noreply@savoirbeds.co.uk", hbemailto, "", "SavoirAdminFabric@savoirbeds.co.uk", true, con)
end if

'end fab email
msg = msg & "Details updated"
'response.write("<br>" & msg)
url = "orderdetails.asp?pn=" & purchaseno & "&msg=" & server.urlencode(msg)
if jsmsg <> "" then url = url & "&jsmsg=" & server.urlencode(jsmsg)

Con.Close
Set Con = Nothing

response.redirect(url)
%>
<!-- #include file="common/logger-out.inc" -->
<%
sub updateAccessoryExWorksDates(byref acon, apn, aExworksdateacc, aCompItemNo)
	dim ars
	if aExworksdateacc="n" then
		Set ars = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=9 and purchase_no=" & apn & " and compItemNo=" & aCompItemNo, con)
		if not ars.eof then
			call log(scriptname, "deleting from exportlinks where componentid=9 and purchase_no=" & apn & " and compItemNo=" & aCompItemNo)
			ars.delete
		end if
		ars.close 
		set ars=nothing	
	end if
	
	if (aExworksdateacc<>"n" and aExworksdateacc<>"") then
		Set ars = getMysqlUpdateRecordSet("Select * from exportlinks where componentid=9 and purchase_no=" & apn & " and compItemNo=" & aCompItemNo, con)
		if ars.eof then
			ars.close
			Set ars = getMysqlUpdateRecordSet("Select * from exportlinks", con)
			ars.AddNew
			ars("purchase_no")=apn
			ars("componentid")=9
			ars("compItemNo")=aCompItemNo
		end if
		ars("orderconfirmed")="y"
		if aExworksdateacc = 0 then
			aExworksdateacc = getAdhocExportCollection(con, apn)
		end if
		ars("LinksCollectionID")=aExworksdateacc
		ars.Update
		ars.close
		set ars=nothing
	end if
end sub
%>