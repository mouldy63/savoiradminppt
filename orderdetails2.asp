<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,REGIONAL_ADMINISTRATOR,SALES,ORDERDETAILS_VIEWER"
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
<!-- #include file="componentfuncs.asp" -->
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderdetailsfuncs.asp" -->

<%Dim Con, rs, submit, count, sql, msg,  jsmsg, rs1, rs2, rs3, rs7, selcted, isCancelled, isComplete, order, orderCurrency, isTrade, delDate, i, delphonetype1, delphonetype2, delphonetype3, delphone1, delphone2, delphone3, acc_desc, acc_unitprice, acc_qty, acc_id, locationname, pn, legstylecheck
pn=Request("pn")
dim defaultfirelabelid, mattressmadeat, basemadeat,toppermadeatid, headboardmadeatid, headboardlegsmadeatid, headcardiff, legsmadeatid, valancemadeatid, mattressstatus, orderstatus, basestatus, topperstatus, headboardstatus, valancestatus, accessoriesstatus, legsstatus
headcardiff=false
dim delDateValues(), delDateDescriptions(), typenames()
dim mattcut, mattchecked, mattmachined, mattmachinedchecked, springunitdate, mattfinished, tickingbatchno, madeby, mattbcwexpected, mattbcwwarehouse, mattdeldate
dim boxcut, boxcutchecked, boxmachined, boxmachinedchecked, boxframe, boxframechecked, baseprepped, basepreppedchecked,  boxtickingbatchno, basemadeby, basefinished, basebcwexpected, basebcwwarehouse, basedeldate, basefabricstatus,  basefrTreatingSent, basefrTreatingReceived, basesupplier, baseponumber, basepodate, basefabricexpecteddate, basefabricrecdate, basecuttingsent, baseconfirmeddate, basetobcwdate, basefabricprice, basefabricqty
Dim uphfabricstatus
Dim matbay, basebay, topperbay, valancebay, legsbay, headboardbay, accessoriesbay
Dim toppercut, topperchecked, toppermachined, toppermachinedchecked, toppermadeat, topperbcwexpected, topperbcwwarehouse, topperdeldate, topperfinished, toppertickingbatchno, toppermadeby
Dim headboardfabricstatus
dim headboardframe, headboardframechecked, headboardprepped, headboardframedchecked, headboardfinished, headboardbcwexpected, headboardbcwwarehouse, headboarddeldate, headboardsupplier, headboardponumber, headboardpodate, headboardfabricexpecteddate, headboardfabricrecdate, headboardcuttingsent, headboardconfirmeddate, headboardtobcwdate, headboardfabricprice, headboardfabricqty, headboardmadeat, headboarddetails, frTreatingSent, frTreatingReceived
dim valanceframe, valanceframechecked, valanceprepped, valancepreppedchecked, valanceframedchecked, valancefinished, valancebcwexpected, valancebcwwarehouse, valancedeldate, valancesupplier, valanceponumber, valancepodate, valancefabricexpecteddate, valancefabricrecdate, valancecuttingsent, valanceconfirmeddate, valancetobcwdate, valancefabricprice, valancefabricqty, valancemadeat, valancedetails, valancefabricstatus, sendtosddate, valancelength, valancewidth, valancedrop, valancefrTreatingSent, valancefrTreatingReceived
Dim legsfinished, legsmadeat, legsbcwexpected, legsbcwwarehouse, legsdeldate
Dim  accessoriesbcwexpected, accessoriesbcwwarehouse, accessoriesdeldate, accessoryfabricstatus, accessoryporaised, accessorypackeddate
dim prevorder, nextorder, search, submitX, salesOnly, formAction
Dim matt1width, matt2width, matt1length, matt2length, m1width, m1length, m2width, m2length, base1width, base2width, base1length, base2length, topper1width, topper1length, mattwidthdivided, mattlengthdivided, zippedpair, northsouth, basewidth, baselength, basewidth2, baselength2, eastwest, accessoryqtyfollow, acc_design, acc_colour, acc_size, acc_supplier, acc_ponumber, acc_podate, acc_eta, acc_received, acc_checked, acc_special, acc_qtyfollow, x, acc_delivered, acc_length, acc_weight, acc_height, acc_packedwith, acc_width, acc_status, rs4, defaultwrappingid, hbfabricstatus, valfabricstatus, totalLegQty, speciallegheight, legsprepped, rs5, rs6, currentexworksdate, optionselected, lorrycount, splitshipment
Dim deliverymethodMatt, deliverymethodBase, deliverymethodTopper, deliverymethodValance, deliverymethodHb, deliverymethodLegs, deliverymethodAcc, preferredshipper, currentexworksdate2, jobflagMatt, jobflagBase, jobflagTopper, isAdhoc
speciallegheight=""
Dim acc_packdesc, acc_packwidth, acc_packheight, acc_packdepth, acc_packkg, acc_packtariffcode
Dim hb_packwidth, hb_packheight, hb_packdepth, hb_packkg, matt_packkg, matt_box, matt2_box, matt1kg, matt2kg, base_box, base2_box, base1kg, base2kg, topper_box, topper1kg, hb_box, hb1kg
Dim matt1_cratesize, matt1_packwidth, matt1_packheight, matt1_packdepth, matt1_packkg, matt2_cratesize, matt2_packwidth, matt2_packheight, matt2_packdepth, matt2_packkg, base1_packwidth, base1_packheight, base1_packdepth, base1_packkg, base2_cratesize, base2_packwidth, base2_packheight, base2_packdepth, base2_packkg, topper1_packwidth, topper1_packheight, topper1_packdepth, topper1_packkg, topper2_packwidth, topper2_packheight, topper2_packdepth, topper2_packkg, topper2_cratesize, hb1_packwidth, hb1_packheight, hb1_packdepth, hb1_packkg,  hb2_packwidth, hb2_packheight, hb2_packdepth, hb2_packkg, hb2_cratesize, legs1_packwidth, legs1_packheight, legs1_packdepth, legs1_packkg, legs2_packwidth, legs2_packheight, legs2_packdepth, legs2_packkg, legs2_cratesize, valance1_packwidth, valance1_packheight, valance1_packdepth, valance1_packkg, valance2_packwidth, valance2_packheight, valance2_packdepth, valance2_packkg, valance2_cratesize, valance_box, valance1kg, acc1_box, acc1kg, legs_box, legs1kg, savedlegweight, savedvalanceweight, savedboxvalanceweight, savedboxaccweight, savedaccweight, acc1_cratesize, acc1_packwidth, acc1_packheight, acc1_packdepth, acc1_packkg, acc2_cratesize, acc2_packwidth, acc2_packheight, acc2_packdepth, acc2_packkg, hbcrate, hbcrate2, hbcrateqty, mattresscrate, mattresscrate2, mattresscrateqty, basecrate, basecrate2, basecrateqty, toppercrate, toppercrate2, toppercrateqty, valancecrate, valancecrate2, valancecrateqty, legscrate, legscrate2, legscrateqty, accessoriescrate, accessoriescrate2, accessoriescrateqty
Dim headboardwidth, headboardheight, isPinnacle, pinnacleOrderNo, basetxtinc, mattresstxtinc, toppertxtinc, hbtxtinc, basetxtinc3, mattresstxtinc3, toppertxtinc3, hbtxtinc3
Dim basetrimprice, toppertxt
dim dzOrderNum, dzPurchaseNo, dzUserId, dzType
dim mattressIssuedDate, baseIssuedDate, valanceIssuedDate, topperIssuedDate, legsIssuedDate, headboardIssuedDate, gorrivanheight, gorrivanfinish, fbheight, fbfinish
dim gorrivanprint, deltime, ordernote_notetext, ordernote_followupdate, ordernote_action, ordernote_id, orderPNO
dim noteHistory, accreadonly, accdisabled, order_url, disableswitch, selectedtext
dim legsPackedWithCheck,  valancePackedWithCheck, accPackedWithCheck, bookeddeliverydate
dim leftTension
dim rightTension, z, sid, loc, cid
leftTension = -1
rightTension = -1
legsPackedWithCheck=""
valancePackedWithCheck=""
accPackedWithCheck=""
disableswitch=""
gorrivanprint=0
gorrivanheight="&nbsp;"
gorrivanfinish="&nbsp;"
fbheight="&nbsp;"
fbfinish="&nbsp;"
pinnacleOrderNo=""
isPinnacle="n"
acc_desc=""
acc_packwidth=""
acc_packheight=""
acc_packdepth=""
acc_packkg=""
acc_packtariffcode=""

hb_packwidth=""
hb_packheight=""
hb_packdepth=""
hb_packkg=""

matt1_cratesize=""
matt1_packwidth=""
matt1_packheight=""
matt1_packdepth=""
matt1_packkg=""
matt2_cratesize=""
matt2_packwidth=""
matt2_packheight=""
matt2_packdepth=""
matt2_packkg=""
hb1_packwidth=""
hb1_packheight=""
hb1_packdepth=""
hb1_packkg=""
hb2_cratesize=""
hb2_packwidth=""
hb2_packheight=""
hb2_packdepth=""
hb2_packkg=""
acc1_cratesize=""
acc1_packwidth=""
acc1_packheight=""
acc1_packdepth=""
acc1_packkg=""
acc2_cratesize=""
acc2_packwidth=""
acc2_packheight=""
acc2_packdepth=""
acc2_packkg=""
base1_packwidth=""
base1_packheight=""
base1_packdepth=""
base1_packkg=""
base2_packwidth=""
base2_packheight=""
base2_packdepth=""
base2_packkg=""
topper1_packwidth=""
topper1_packheight=""
topper1_packdepth=""
topper1_packkg=""
topper2_packwidth=""
topper2_packheight=""
topper2_packdepth=""
topper2_packkg=""
legs1_packwidth=""
legs1_packheight=""
legs1_packdepth=""
legs1_packkg=""
legs2_packwidth=""
legs2_packheight=""
legs2_packdepth=""
legs2_packkg=""
valance1_packwidth=""
valance1_packheight=""
valance1_packdepth=""
valance1_packkg=""
valance2_packwidth=""
valance2_packheight=""
valance2_packdepth=""
valance2_packkg=""


search=request("search")
submitX=request("submitX")
prevorder=""
nextorder=""
matbay=""
basebay=""
topperbay=""
valancebay=""
legsbay=""
headboardbay=""

msg=Request("msg")
jsmsg=Request("jsmsg")
count=0
submit=Request("submit")


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/extra.css" rel="Stylesheet" type="text/css" />
<link href="Styles/screenP.css" rel="Stylesheet" type="text/css" />

<script src="common/jquery.js" type="text/javascript"></script>
 <script type="text/javascript" src="scripts/dropzone.js"></script>
    <script type="text/javascript" src="scripts/spin.min.js"></script>
	<script src="common/utils.js?date=<%=theDate%>" type="text/javascript"></script>
<script src="common/jquery.eComboBox.custom.js" type="text/javascript"></script>
<script src="scripts/datevalidation.js"></script>

<script Language="JavaScript" type="text/javascript">
	<% if jsmsg <> "" then %>
		alert("<%=jsmsg%>");
	<% end if %>
</script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<script src="scripts/keepalive.js"></script>


<script src="calendar-orderdetails.js?date=<%=theDate%>"></script>
<%Set Con = getMysqlConnection()
If search<>""  then
sql = "Select * from Purchase where order_number = " & search & ""

Set rs = getMysqlQueryRecordSet(sql, con)
pn=rs("purchase_no")

deltime=rs("delivery_Time")
rs.close
set rs=nothing
end if
noteHistory = getOrderNoteHistory(con, pn, "")

Con.close
set Con=nothing%>
<script>
var isSuperuser=<% if isSuperUser() then %> true <% else %> false <%end if%>
var isProductionManager=<% if userHasRole("PRODUCTION_MANAGERS") then %> true <% else %> false <%end if%>
var jsPn = <%=pn%>;
</script>
<script>
jQuery(document).ready(function($) {
var year = new Date().getFullYear();
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
<style>
.packtableborder {
border:1px solid #999999;
}
.greytxt {
color:#999999;}

.AccordionPanel {float: left;}
.AccordionPanelTab {margin-left:5px; float:left;}
.Accordclear {clear:both;}
.stickleft {float:left;left:0px;}
.AccordionPanel table {margin-left:30px; background-color:#d4d4d4;clear:both;margin-bottom:40px;}
#accCrateShow {
	margin-right:90px;
}</style>
<script src="orderdetailsfuncs.js?date=<%=theDate%>"></script>
</head>
<body>

<div class="screenproduction">
<!-- #include file="header.asp" -->

<div class="contentprod brochure">
<div class="one-col head-col"><!--<form name="form1" method="post" action="">-->	
  <p>
<%


order=pn
sql = "Select * from address A, contact C, Purchase P" 
'if userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR") then 
'sql = sql & ", Location L"
'end if
sql = sql & " Where (P.cancelled is null or P.cancelled <> 'y') AND A.code<>217911  AND "
'sql = sql & "C.contact_no<>319256 AND C.contact_no<>24188 AND "
sql = sql & "A.code=C.code AND C.contact_no=P.contact_no AND P.quote='n' "
'sql = sql & " AND P.source_site='SB' " 
sql = sql & " AND P.purchase_no=" & pn

'response.write("<br>" & sql)
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
bookeddeliverydate=rs("bookeddeliverydate")
if not IsNull(rs("preferredshipper")) then preferredshipper=rs("preferredshipper") else preferredshipper=""

isCancelled = safeBool(rs("cancelled") )
isComplete = safeBool(rs("completedorders") )

Set rs1 = getMysqlQueryRecordSet("Select idlocation from Purchase where order_number=" & rs("order_number"), con)
		locationname=rs1("idlocation")
		call closeRs(rs1)
Set rs1 = getMysqlQueryRecordSet("Select location from location where idlocation=" & locationname, con)
locationname=rs1("location")
		call closeRs(rs1)
delDate = rs("deliverydate")
call makeApproxDateOptions(delDateValues, delDateDescriptions, delDate)
call getPhoneNumberTypes(con, typenames)

sql = "Select * from productionsizes where purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
if rs2("matt1width")<>"" then matt1width=rs2("matt1width") else matt1width=""
if rs2("matt2width")<>"" then matt2width=rs2("matt2width") else matt2width=""
if rs2("matt1length")<>"" then matt1length=rs2("matt1length") else matt1length=""
if rs2("matt2length")<>"" then matt2length=rs2("matt2length") else matt2length=""
if rs2("base1width")<>"" then base1width=rs2("base1width") else base1width=""
if rs2("base2width")<>"" then base2width=rs2("base2width") else base2width=""
if rs2("base1length")<>"" then base1length=rs2("base1length") else base1length=""
if rs2("base2length")<>"" then base2length=rs2("base2length") else base2length=""
if rs2("topper1width")<>"" then topper1width=rs2("topper1width") else topper1width=""
if rs2("topper1length")<>"" then topper1length=rs2("topper1length") else topper1length=""
if rs2("legheight")<>"" then speciallegheight=rs2("legheight") else speciallegheight=""
end if
rs2.close
set rs2=nothing

if rs("accessoriesrequired")="y" then
sql = "Select * from packagingdata where purchase_no=" & rs("purchase_no") & " and componentID=9"
Set rs2 = getMysqlUpdateRecordSet(sql, con)
if not rs2.eof then
acc_packdesc=rs2("PackagingDesc")
acc_packwidth=rs2("packwidth")
acc_packheight=rs2("packheight")
acc_packdepth=rs2("packdepth")
acc_packkg=rs2("packkg")
acc_packtariffcode=rs2("packtariffcode")
end if
rs2.close
set rs2=nothing
end if



if rs("headboardrequired")="y" and (rs("wrappingid")=1 or rs("wrappingid")=2) then
hb_packwidth=getHBWidth(con, rs("purchase_no"))
if hb_packwidth="n" then hb_packwidth=0

hb_packheight=getHbHeight(con, rs("purchase_no"))
hb_packdepth=getHbDepth(con, rs("headboardstyle"))
sql = "Select * from packagingdata where purchase_no=" & rs("purchase_no") & " and componentID=8"
'response.Write("sql=" & sql)
Set rs2 = getMysqlUpdateRecordSet(sql, con)
if not rs2.eof then
hb_packwidth=rs2("packwidth")
hb_packheight=rs2("packheight")
hb_packdepth=rs2("packdepth")
hb_packkg=rs2("packkg")
end if
rs2.close
set rs2=nothing
if right(hb_packwidth,2)="cm" then hb_packwidth=left(hb_packwidth,len(hb_packwidth)-2)
end if

sql = "Select * from qc_history where componentid=0 AND purchase_no = " & rs("purchase_no") & " order by QC_date desc"
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
orderstatus=rs2("qc_statusid")
else
orderstatus=10
end if
rs2.close
set rs2=nothing

sql = "Select purchase_no from Purchase Where (cancelled is null or cancelled <> 'y')  AND code<>217911 AND completedorders='n' AND quote='n' AND source_site='SB' AND purchase_no>" & pn  & " order by purchase_no asc"
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
nextorder=rs2("purchase_no")
else
nextorder=""
end if
rs2.close
set rs2=nothing

sql = "Select purchase_no from Purchase Where (cancelled is null or cancelled <> 'y')  AND code<>217911 AND completedorders='n' AND quote='n' AND source_site='SB' AND purchase_no<" & pn  & " order by purchase_no desc"
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
prevorder=rs2("purchase_no")
else
prevorder=""
end if
rs2.close
set rs2=nothing

sql = "Select * from spring_prod_row_number Where purchase_no=" & pn
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
	if rs2("row_number")<>"" then leftTension = rs2("row_number")
	if rs2("row_number_right")<>"" then rightTension = rs2("row_number_right")
end if
rs2.close
set rs2=nothing

defaultfirelabelid=rs("firelabelid")
defaultwrappingid=rs("wrappingid")

if defaultfirelabelid="" or defaultfirelabelid=0 then
  If rs("price_list")="Savoy" or rs("price_list")="Contract" or rs("price_list")="Wholesale" then defaultfirelabelid=2
  If rs("price_list")="Trade" or rs("price_list")="Retail" or rs("price_list")="Net Retail" or rs("price_list")="" or isNUll(rs("price_list")) then defaultfirelabelid=1
  If (rs("owning_region")=4 or rs("owning_region")=23) then defaultfirelabelid=3
end if


sql = "Select * from qc_history where componentid=1 AND purchase_no = " & rs("purchase_no") & " order by QC_date desc"
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
	if rs2("issueddate")<>"" then mattressIssuedDate=rs2("issueddate")
	if rs2("cut")<>"" then mattcut=rs2("cut")
	if rs2("machined")<>"" then mattmachined=rs2("machined")
	mattressmadeat=rs2("madeat")
	if rs2("deliveryMethod") <>"" then deliverymethodMatt=rs2("deliveryMethod")
	if rs2("qc_statusid") <>"" then mattressstatus=rs2("qc_statusid")
	if rs2("springunitdate") <>"" then springunitdate=rs2("springunitdate")
	if rs2("bcwexpected") <>"" then mattbcwexpected=rs2("bcwexpected")
	if rs2("bcwwarehouse") <>"" then mattbcwwarehouse=rs2("bcwwarehouse")
	if rs2("deliverydate") <>"" then mattdeldate=rs2("deliverydate")
	if rs2("finished") <>"" then mattfinished=rs2("finished")
	if rs2("tickingbatchno")<>"" then tickingbatchno=rs2("tickingbatchno")
	if rs2("madeby")<>"" then madeby=rs2("madeby")
	if rs2("jobflag")<>"" then jobflagMatt=rs2("jobflag")
end if
rs2.close
set rs2=nothing
' default deliverymethodMatt if not already set
if deliverymethodMatt = "" then
	if rs("overseasOrder")="y" then deliverymethodMatt=6 else deliverymethodMatt=1
end if

sql = "Select * from bay_content where orderid = " & rs("order_number")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
Do until rs2.eof
If rs2("componentid")=1 then matbay=rs2("baynumber")
If rs2("componentid")=3 then basebay=rs2("baynumber")
If rs2("componentid")=5 then topperbay=rs2("baynumber")
If rs2("componentid")=6 then valancebay=rs2("baynumber")
If rs2("componentid")=7 then legsbay=rs2("baynumber")
If rs2("componentid")=8 then headboardbay=rs2("baynumber")
If rs2("componentid")=9 then accessoriesbay=rs2("baynumber")
rs2.movenext
loop
end if
rs2.close
set rs2=nothing

sql = "Select * from qc_history where componentid=3 AND purchase_no = " & rs("purchase_no") & " order by QC_date desc"
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
	if rs2("issueddate")<>"" then baseIssuedDate=rs2("issueddate")
	If rs2("cut")<>"" then boxcut=rs2("cut")
	if rs2("machined")<>"" then boxmachined=rs2("machined")
	if rs2("framed")<>"" then boxframe=rs2("framed")
	if rs2("prepped")<>"" then baseprepped=rs2("prepped")
	basemadeat=rs2("madeat")
	if rs2("qc_statusid") <>"" then basestatus=rs2("qc_statusid")
	if rs2("bcwexpected") <>"" then basebcwexpected=rs2("bcwexpected")
	if rs2("bcwwarehouse") <>"" then basebcwwarehouse=rs2("bcwwarehouse")
	if rs2("deliverydate") <>"" then basedeldate=rs2("deliverydate")
	if rs2("finished") <>"" then basefinished=rs2("finished")
	if rs2("tickingbatchno")<>"" then boxtickingbatchno=rs2("tickingbatchno")
	if rs2("madeby")<>"" then basemadeby=rs2("madeby")
	if rs2("fabricstatus")<>"" then basefabricstatus=rs2("fabricstatus")
	if rs2("supplier")<>"" then basesupplier=rs2("supplier")
	if rs2("ponumber")<>"" then baseponumber=rs2("ponumber")
	if rs2("podate")<>"" then basepodate=rs2("podate")
	if rs2("fabricexpected")<>"" then basefabricexpecteddate=rs2("fabricexpected")
	if rs2("fabricreceived")<>"" then basefabricrecdate=rs2("fabricreceived")
	if rs2("cuttingsent")<>"" then basecuttingsent=rs2("cuttingsent")
	if rs2("FRTreatmentSent")<>"" then basefrTreatingSent=rs2("FRTreatmentSent")
	if rs2("FRTreatmentReceived")<>"" then basefrTreatingReceived=rs2("FRTreatmentReceived")
	if rs2("confirmeddate")<>"" then baseconfirmeddate=rs2("confirmeddate")
	if rs2("senttobcw")<>"" then basetobcwdate=rs2("senttobcw")
	if rs2("fabricprice")<>"" then basefabricprice=rs2("fabricprice")
	if rs2("fabricqty")<>"" then basefabricqty=rs2("fabricqty")
	if rs2("deliveryMethod")<>"" then deliverymethodBase=rs2("deliveryMethod")
	if rs2("jobflag")<>"" then jobflagBase=rs2("jobflag")
end if
rs2.close
set rs2=nothing
' default deliverymethodBase if not already set
if deliverymethodBase = "" then
	if rs("overseasOrder")="y" then deliverymethodBase=6 else deliverymethodBase=1
end if



sql = "Select * from qc_history where componentid=5 AND purchase_no = " & rs("purchase_no") & " order by QC_date desc"
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
	if rs2("issueddate")<>"" then topperIssuedDate=rs2("issueddate")
	If rs2("cut")<>"" then toppercut=rs2("cut")
	If rs2("machined")<>"" then toppermachined=rs2("machined")
	If toppercut="y" then topperchecked="checked" else topperchecked=""
	If toppermachined="y" then toppermachinedchecked="checked" else toppermachinedchecked=""
	if rs2("madeat")<>"" and NOT IsNull(rs2("madeat")) then
	toppermadeatid=rs2("madeat")
	else
	toppermadeatid=getTopperMadeAt(rs("toppertype"), rs("savoirmodel"), rs("basesavoirmodel"), mattressmadeat, basemadeat)
	end if
	if rs2("qc_statusid") <>"" then topperstatus=rs2("qc_statusid")
	if rs2("bcwexpected") <>"" then topperbcwexpected=rs2("bcwexpected")
	if rs2("bcwwarehouse") <>"" then topperbcwwarehouse=rs2("bcwwarehouse")
	if rs2("deliverydate") <>"" then topperdeldate=rs2("deliverydate")
	if rs2("finished") <>"" then topperfinished=rs2("finished")
	if rs2("tickingbatchno")<>"" then toppertickingbatchno=rs2("tickingbatchno")
	if rs2("madeby")<>"" then toppermadeby=rs2("madeby")
	if rs2("deliveryMethod")<>"" then deliverymethodTopper=rs2("deliveryMethod")
	if rs2("jobflag")<>"" then jobflagTopper=rs2("jobflag")
end if
rs2.close
set rs2=nothing
' default deliverymethodTopper if not already set
if deliverymethodTopper = "" then
	if rs("overseasOrder")="y" then deliverymethodTopper=6 else deliverymethodTopper=1
end if

sql = "Select * from qc_history where componentid=9 AND purchase_no = " & rs("purchase_no") & " order by QC_date desc"
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
	accessoryqtyfollow=rs2("qtytofollow")
	'if rs2("fabricstatus")<>"" then accessoryfabricstatus=rs2("fabricstatus")
	if rs2("qc_statusid") <>"" then accessoriesstatus=rs2("qc_statusid")
	if rs2("bcwexpected") <>"" then accessoriesbcwexpected=rs2("bcwexpected")
	if rs2("bcwwarehouse") <>"" then accessoriesbcwwarehouse=rs2("bcwwarehouse")
	if rs2("deliverydate") <>"" then accessoriesdeldate=rs2("deliverydate")
	if rs2("poraiseddate")<>"" then accessoryporaised=rs2("poraiseddate")
	if rs2("packeddate")<>"" then accessorypackeddate=rs2("packeddate")
	if rs2("deliveryMethod")<>"" then deliverymethodAcc=rs2("deliveryMethod")
end if
rs2.close
set rs2=nothing
' default deliverymethodAcc if not already set
if deliverymethodAcc = "" then
	if rs("overseasOrder")="y" then deliverymethodAcc=6 else deliverymethodAcc=1
end if

sql = "Select * from qc_history where componentid=6 AND purchase_no = " & rs("purchase_no") & " order by QC_date desc"
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
	if rs2("issueddate")<>"" then valanceIssuedDate=rs2("issueddate")
 	valanceframe=rs2("framed")
	valanceprepped=rs2("prepped")
	If valanceframe="y" then valanceframechecked="checked" else valanceframedchecked=""
	If valanceprepped="y" then valancepreppedchecked="checked" else valancepreppedchecked=""
	valancemadeatid=rs2("madeat")
	if rs2("qc_statusid") <>"" then valancestatus=rs2("qc_statusid")
	if rs2("bcwexpected") <>"" then valancebcwexpected=rs2("bcwexpected")
	if rs2("bcwwarehouse") <>"" then valancebcwwarehouse=rs2("bcwwarehouse")
	if rs2("fabricstatus")<>"" then valfabricstatus=rs2("fabricstatus")
	if rs2("deliverydate") <>"" then valancedeldate=rs2("deliverydate")
	if rs2("finished") <>"" then valancefinished=rs2("finished")
	if rs2("supplier")<>"" then valancesupplier=rs2("supplier")
	if rs2("ponumber")<>"" then valanceponumber=rs2("ponumber")
	if rs2("sendtosddate")<>"" then sendtosddate=rs2("sendtosddate")
	if rs2("podate")<>"" then valancepodate=rs2("podate")
	if rs2("fabricexpected")<>"" then valancefabricexpecteddate=rs2("fabricexpected")
	if rs2("fabricreceived")<>"" then valancefabricrecdate=rs2("fabricreceived")
	if rs2("cuttingsent")<>"" then valancecuttingsent=rs2("cuttingsent")
	if rs2("FRTreatmentSent")<>"" then valancefrTreatingSent=rs2("FRTreatmentSent")
	if rs2("FRTreatmentReceived")<>"" then valancefrTreatingReceived=rs2("FRTreatmentReceived")
	if rs2("confirmeddate")<>"" then valanceconfirmeddate=rs2("confirmeddate")
	if rs2("fabricprice")<>"" then valancefabricprice=rs2("fabricprice")
	if rs2("fabricqty")<>"" then valancefabricqty=rs2("fabricqty")
	if rs2("details")<>"" then valancedetails=rs2("details")
	if rs2("deliveryMethod")<>"" then deliverymethodValance=rs2("deliveryMethod")
end if
rs2.close
set rs2=nothing
' default deliverymethodValance if not already set
if deliverymethodValance = "" then
	if rs("overseasOrder")="y" then deliverymethodValance=6 else deliverymethodValance=1
end if


sql = "Select * from qc_history where componentid=8 AND purchase_no = " & rs("purchase_no") & " order by QC_date desc"
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
	if rs2("issueddate")<>"" then headboardIssuedDate=rs2("issueddate")
	if rs2("framed") <>"" then headboardframe=rs2("framed")
	if rs2("prepped") <>"" then headboardprepped=rs2("prepped")
	headboardmadeatid=rs2("madeat")
	headboardlegsmadeatid=rs2("headboardlegsmadeat")
	if rs2("qc_statusid") <>"" then headboardstatus=rs2("qc_statusid")
	if rs2("bcwexpected") <>"" then headboardbcwexpected=rs2("bcwexpected")
	if rs2("bcwwarehouse") <>"" then headboardbcwwarehouse=rs2("bcwwarehouse")
	if rs2("deliverydate") <>"" then headboarddeldate=rs2("deliverydate")
	if rs2("finished") <>"" then headboardfinished=rs2("finished")
	if rs2("fabricstatus")<>"" then hbfabricstatus=rs2("fabricstatus")
	if rs2("supplier")<>"" then headboardsupplier=rs2("supplier")
	if rs2("ponumber")<>"" then headboardponumber=rs2("ponumber")
	if rs2("podate")<>"" then headboardpodate=rs2("podate")
	if rs2("fabricexpected")<>"" then headboardfabricexpecteddate=rs2("fabricexpected")
	if rs2("fabricreceived")<>"" then headboardfabricrecdate=rs2("fabricreceived")
	if rs2("cuttingsent")<>"" then headboardcuttingsent=rs2("cuttingsent")
	if rs2("FRTreatmentSent")<>"" then frTreatingSent=rs2("FRTreatmentSent")
	if rs2("FRTreatmentReceived")<>"" then frTreatingReceived=rs2("FRTreatmentReceived")
	if rs2("confirmeddate")<>"" then headboardconfirmeddate=rs2("confirmeddate")
	if rs2("senttobcw")<>"" then headboardtobcwdate=rs2("senttobcw")
	if rs2("fabricprice")<>"" then headboardfabricprice=rs2("fabricprice")
	if rs2("fabricqty")<>"" then headboardfabricqty=rs2("fabricqty")
	if rs2("details")<>"" then headboarddetails=rs2("details")
	if rs2("deliveryMethod")<>"" then deliverymethodHB=rs2("deliveryMethod")
end if
rs2.close
set rs2=nothing
' default deliverymethodHB if not already set
if deliverymethodHB = "" then
	if rs("overseasOrder")="y" then deliverymethodHB=6 else deliverymethodHB=1
end if

sql = "Select * from qc_history where componentid=7 AND purchase_no = " & rs("purchase_no") & " order by QC_date desc"
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
	if rs2("issueddate")<>"" then legsIssuedDate=rs2("issueddate")
	legsfinished=rs2("Finished")
	legsprepped=rs2("prepped")
	if rs2("madeat")<>"" and NOT IsNULL(rs2("madeat")) then
	legsmadeatid=rs2("madeat")
	else
	legsmadeatid=2
	end if
	if rs2("qc_statusid") <>"" then legsstatus=rs2("qc_statusid")
	if rs2("bcwexpected") <>"" then legsbcwexpected=rs2("bcwexpected")
	if rs2("bcwwarehouse") <>"" then legsbcwwarehouse=rs2("bcwwarehouse")
	if rs2("deliverydate") <>"" then legsdeldate=rs2("deliverydate")
	if rs2("deliveryMethod") <>"" then deliverymethodLegs=rs2("deliveryMethod")
end if
rs2.close
set rs2=nothing
' default deliverymethodLegs if not already set
if deliverymethodLegs = "" then
	if rs("overseasOrder")="y" then deliverymethodLegs=6 else deliverymethodLegs=1
end if

If rs("cancelled")="y" then orderstatus=80
If rs("orderonhold")="y" then orderstatus=90
Dim valancetxt, legstxt


toppertxt=""
valancetxt=""
legstxt=""
basetxtinc=""
mattresstxtinc=""
hbtxtinc=""
toppertxtinc=""
basetxtinc3=""
mattresstxtinc3=""
hbtxtinc3=""
toppertxtinc3=""
'if rs("baserequired")="y" and rs("valancerequired")="y" then valancetxt="Valance packed with base"
'if rs("baserequired")="n" and rs("valancerequired")="y" and rs("mattressrequired")="y" then valancetxt="Valance packed with mattress"
'if rs("baserequired")="n" and rs("valancerequired")="y" and rs("mattressrequired")="n" and rs("topperrequired")="y" then valancetxt="Valance packed with topper"
'if rs("baserequired")="n" and rs("valancerequired")="y" and rs("mattressrequired")="n" and rs("topperrequired")="n" and rs("headboardrequired")="y" then valancetxt="Valance packed with headboard"
'if rs("mattressrequired")="n" and rs("baserequired")="y" and rs("legsrequired")="y" then legstxt="Legs packed with base"
'if rs("mattressrequired")="n" and rs("baserequired")="n" and rs("headboardrequired")="n" and rs("legsrequired")="y" and rs("topperrequired")="y" then legstxt="Legs packed with topper"
'if rs("mattressrequired")="n" and rs("baserequired")="n" and rs("headboardrequired")="y" and rs("legsrequired")="y" and rs("topperrequired")="n" then legstxt="Legs packed with headboard"
'if rs("mattressrequired")="y" and rs("legsrequired")="y" and rs("topperrequired")="n" and rs("valancerequired")="n" and rs("headboardrequired")="n" and rs("baserequired")="n" then legstxt="Legs packed with mattress"
'if rs("mattressrequired")="y" and rs("baserequired")="y" and rs("legsrequired")="y" then
'legstxt="Legs packed with base"
'end if
'if rs("mattressrequired")="y" and rs("topperrequired")="y" then toppertxt="Topper packed with mattress"

if left(rs("mattresstype"),11)="Zipped Pair" and (rs("mattresswidth")<>"Special (as instructions)" AND rs("mattresswidth")<>"Special Width") then
		  if right(rs("mattresswidth"),2)="cm" then
		     mattwidthdivided= left(rs("mattresswidth"), len(rs("mattresswidth"))-2)/2 
			 mattlengthdivided=rs("mattresslength")
		end if
		if right(rs("mattresswidth"),2)="in" then
		     mattwidthdivided= (left(rs("mattresswidth"), len(rs("mattresswidth"))-2)*2.54)/2 
			 mattlengthdivided=left(rs("mattresslength"), len(rs("mattresslength"))-2)*2.54
		end if
		else
		mattwidthdivided=rs("mattresswidth")
		zippedpair="n"
		mattlengthdivided=rs("mattresslength")
		if right(rs("mattresswidth"),2)="in" then
		mattwidthdivided= (left(rs("mattresswidth"), len(rs("mattresswidth"))-2)*2.54)
		end if
		if right(rs("mattresslength"),2)="in" then
			mattlengthdivided= (left(rs("mattresslength"), len(rs("mattresslength"))-2)*2.54)
		end if
end if
if rs("headboardrequired")="y" then
	'if hbfabricstatus<>"" then
	'else
		if rs("hbfabricoptions")="TBC" then hbfabricstatus="1"
		if rs("hbfabricoptions")="Savoir Supply" then hbfabricstatus="1"
		if rs("hbfabricoptions")="" or isNull(rs("hbfabricoptions")) then hbfabricstatus="1"
		if rs("hbfabricoptions")="Customer Own Material" then hbfabricstatus="2"
		if rs("headboardfabricchoice")<>"" then hbfabricstatus="3"
		if headboardponumber<>"" then hbfabricstatus="4"
		if headboardfabricrecdate<>"" then hbfabricstatus="7"
		if headboardcuttingsent<>"" then hbfabricstatus="5"
		if frTreatingSent<>"" then hbfabricstatus="9"
		if frTreatingReceived<>"" then hbfabricstatus="10"
		if headboardconfirmeddate<>"" then hbfabricstatus="6"
	'end if
end if
if rs("valancerequired")="y" then
	'if valfabricstatus<>"" and valfabricstatus<>"0" then
	'else
		if rs("valancefabricoptions")="Savoir Supply" then valfabricstatus="1"
		if rs("valancefabricoptions")="" or isNull(rs("valancefabricoptions")) then valfabricstatus="1"
		if rs("valancefabricoptions")="Customer Own Material" then valfabricstatus="2"
		if rs("valancefabricchoice")<>"" then valfabricstatus="3"
		if valanceponumber<>"" then valfabricstatus="4"
		if valancefabricrecdate<>"" then valfabricstatus="7"
		if valancecuttingsent<>"" then valfabricstatus="5"
		if valancefrTreatingSent<>"" then valfabricstatus="9"
		if valancefrTreatingReceived<>"" then valfabricstatus="10"
		if valanceconfirmeddate<>"" then valfabricstatus="6"
	'end if
end if
'response.Write("hbfabricstatus=" & hbfabricstatus)
'response.End()
m1width=""
m1length=""

if rs("mattressrequired")="y" and rs("wrappingid")=3 then
	if left(rs("mattresstype"),3)<>"Zip" then
	call getComponentSizes(con,1,rs("purchase_no"), m1width, m1length)
		if left(rs("mattresswidth"),4)="Spec" then
		call getComponentWidthSpecialSizes(con,1,rs("purchase_no"), m1width)
		end if
		if left(rs("mattresslength"),4)="Spec" then
		call getComponentLengthSpecialSizes(con,1,rs("purchase_no"), m1length)
		end if
	else
	call getComponentSizes(con,1,rs("purchase_no"), m1width, m1length)
	call getComponentSizes(con,1,rs("purchase_no"), m2width, m2length)
		if left(rs("mattresswidth"),4)<>"Spec" then
		m1width=m1width/2
		m2width=m1width
		end if
		if left(rs("mattresswidth"),4)="Spec" then
		call getComponent1WidthSpecialSizes(con,1,rs("purchase_no"), m1width, m2width)
		end if
		if left(rs("mattresslength"),4)="Spec" then
		call getComponent1LengthSpecialSizes(con,1,rs("purchase_no"), m1length, m2length)
		end if
	end if

end if

if rs("mattressrequired")="y" and rs("wrappingid")=4 then
	sql = "Select * from packagingdata where componentid=1 and comppartno=1 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	If not rs2.eof then
		matt1_cratesize=rs2("Boxsize")
		matt1_packwidth=rs2("packwidth")
		matt1_packheight=rs2("packheight")
		matt1_packdepth=rs2("packdepth")
		matt1_packkg=rs2("packkg")
		mattresscrate=rs2("boxsize")
		mattresscrateqty=rs2("boxQty")
		end if
	rs2.close
	set rs2=nothing
end if

if rs("mattressrequired")="y" and rs("wrappingid")=4 then
	sql = "Select * from packagingdata where componentid=1 and comppartno=2 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	If not rs2.eof then
		matt2_cratesize=rs2("Boxsize")
		matt2_packwidth=rs2("packwidth")
		matt2_packheight=rs2("packheight")
		matt2_packdepth=rs2("packdepth")
		matt2_packkg=rs2("packkg")
		mattresscrate2=rs2("boxsize")
		mattresscrateqty = mattresscrateqty + rs2("boxQty")
	end if
	rs2.close
	set rs2=nothing
end if

if rs("baserequired")="y" and rs("wrappingid")=4 then
sql = "Select * from packagingdata where componentid=3 and comppartno=1 AND purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
base1_packwidth=rs2("packwidth")
base1_packheight=rs2("packheight")
base1_packdepth=rs2("packdepth")
base1_packkg=rs2("packkg")
basecrate=rs2("boxsize")
basecrateqty=rs2("boxQty")
end if
rs2.close
set rs2=nothing
end if

if rs("baserequired")="y" and rs("wrappingid")=4 then
	sql = "Select * from packagingdata where componentid=3 and comppartno=2 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	If not rs2.eof then
		base2_cratesize=rs2("Boxsize")
		base2_packwidth=rs2("packwidth")
		base2_packheight=rs2("packheight")
		base2_packdepth=rs2("packdepth")
		base2_packkg=rs2("packkg")
		basecrate2=rs2("boxsize")
		basecrateqty = basecrateqty + rs2("boxQty")
	end if
	rs2.close
	set rs2=nothing
end if

if rs("topperrequired")="y" and rs("wrappingid")=4 then
sql = "Select * from packagingdata where componentid=5 and comppartno=1 AND purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
topper1_packwidth=rs2("packwidth")
topper1_packheight=rs2("packheight")
topper1_packdepth=rs2("packdepth")
topper1_packkg=rs2("packkg")
toppercrate=rs2("boxsize")
toppercrateqty=rs2("boxQty")

end if
rs2.close
set rs2=nothing
end if

if rs("topperrequired")="y" and rs("wrappingid")=4 then
	sql = "Select * from packagingdata where componentid=5 and comppartno=2 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	If not rs2.eof then
		topper2_cratesize=rs2("Boxsize")
		topper2_packwidth=rs2("packwidth")
		topper2_packheight=rs2("packheight")
		topper2_packdepth=rs2("packdepth")
		topper2_packkg=rs2("packkg")
		toppercrate2=rs2("boxsize")
		toppercrateqty = toppercrateqty + rs2("boxQty")
	end if
	rs2.close
	set rs2=nothing
end if

if rs("legsrequired")="y" and rs("mattressrequired")="n" and rs("baserequired")="n" and rs("topperrequired")="n" and rs("wrappingid")=4 then
sql = "Select * from packagingdata where componentid=7 and comppartno=1 AND purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
	if rs2("PackedWith")<>"" and NOT IsNull(rs2("PackedWith")) then 
		legsPackedWithCheck="checked"
	end if 
	legs1_packwidth=rs2("packwidth")
	legs1_packheight=rs2("packheight")
	legs1_packdepth=rs2("packdepth")
	legs1_packkg=rs2("packkg")
	legscrate=rs2("boxsize")
	legscrateqty=rs2("boxQty")
end if
rs2.close
set rs2=nothing
sql = "Select * from packagingdata where componentid=7 and comppartno=2 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	If not rs2.eof then
		legs2_cratesize=rs2("Boxsize")
		legs2_packwidth=rs2("packwidth")
		legs2_packheight=rs2("packheight")
		legs2_packdepth=rs2("packdepth")
		legs2_packkg=rs2("packkg")
		legscrate2=rs2("boxsize")
		legscrateqty = legscrateqty + rs2("boxQty")
	end if
	rs2.close
	set rs2=nothing
end if

if rs("valancerequired")="y" and rs("mattressrequired")="n" and rs("baserequired")="n" and rs("topperrequired")="n" and rs("wrappingid")=4 then
sql = "Select * from packagingdata where componentid=6 and comppartno=1 AND purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
if rs2("PackedWith")<>"" and NOT IsNull(rs2("PackedWith")) then 
		valancePackedWithCheck="checked"
	end if
valance1_packwidth=rs2("packwidth")
valance1_packheight=rs2("packheight")
valance1_packdepth=rs2("packdepth")
valance1_packkg=rs2("packkg")
valancecrate=rs2("boxsize")
valancecrateqty=rs2("boxQty")
end if
rs2.close
set rs2=nothing
sql = "Select * from packagingdata where componentid=6 and comppartno=2 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	If not rs2.eof then
		valance2_cratesize=rs2("Boxsize")
		valance2_packwidth=rs2("packwidth")
		valance2_packheight=rs2("packheight")
		valance2_packdepth=rs2("packdepth")
		valance2_packkg=rs2("packkg")
		valancecrate2=rs2("boxsize")
		valancecrateqty = valancecrateqty + rs2("boxQty")
	end if
	rs2.close
	set rs2=nothing
end if

if rs("accessoriesrequired")="y" and rs("wrappingid")=4 then
sql = "Select * from packagingdata where componentid=9 and comppartno=1 AND purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
if rs2("PackedWith")<>"" and NOT IsNull(rs2("PackedWith")) and rs2("PackedWith")<>0 then 
		accPackedWithCheck="checked"
	end if
acc1_packwidth=rs2("packwidth")
acc1_packheight=rs2("packheight")
acc1_packdepth=rs2("packdepth")
acc1_packkg=rs2("packkg")
accessoriescrate=rs2("boxsize")
accessoriescrateqty=rs2("boxQty")
end if
rs2.close
set rs2=nothing
sql = "Select * from packagingdata where componentid=9 and comppartno=2 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	If not rs2.eof then
		acc2_cratesize=rs2("Boxsize")
		acc2_packwidth=rs2("packwidth")
		acc2_packheight=rs2("packheight")
		acc2_packdepth=rs2("packdepth")
		acc2_packkg=rs2("packkg")
		accessoriescrate2=rs2("boxsize")
		accessoriescrateqty = accessoriescrateqty + rs2("boxQty")
	end if
	rs2.close
	set rs2=nothing
end if

if rs("headboardrequired")="y" and rs("wrappingid")=4 then
sql = "Select * from packagingdata where componentid=8 and comppartno=1 AND purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
hb1_packwidth=rs2("packwidth")
hb1_packheight=rs2("packheight")
hb1_packdepth=rs2("packdepth")
hb1_packkg=rs2("packkg")
hbcrate=rs2("boxsize")
hbcrateqty=rs2("boxQty")
end if
rs2.close
set rs2=nothing
end if

if rs("headboardrequired")="y" and rs("wrappingid")=4 then
	sql = "Select * from packagingdata where componentid=8 and comppartno=2 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	If not rs2.eof then
		hb2_cratesize=rs2("Boxsize")
		hb2_packwidth=rs2("packwidth")
		hb2_packheight=rs2("packheight")
		hb2_packdepth=rs2("packdepth")
		hb2_packkg=rs2("packkg")
		hbcrate2=rs2("boxsize")
		hbcrateqty = hbcrateqty + rs2("boxQty")
	end if
	rs2.close
	set rs2=nothing
end if

savedlegweight = ""
if rs("legsrequired")="y" and (rs("mattressrequired")="y" or rs("baserequired")="y" or rs("topperrequired")="y") and rs("wrappingid")=4 then
	sql = "Select * from packagingdata where componentid=7 and comppartno=1 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
		If not rs2.eof then
		savedlegweight=rs2("componentweight")
		end if
	rs2.close
	set rs2=nothing
end if
savedvalanceweight = ""
if rs("valancerequired")="y" and (rs("mattressrequired")="y" or rs("baserequired")="y" or rs("topperrequired")="y") and rs("wrappingid")=4 then
	sql = "Select * from packagingdata where componentid=6 and comppartno=1 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
		If not rs2.eof then
		savedvalanceweight=rs2("componentweight")
		end if
	rs2.close
	set rs2=nothing
end if
savedboxvalanceweight = ""
if rs("valancerequired")="y" and (rs("mattressrequired")="y" or rs("baserequired")="y" or rs("topperrequired")="y" or rs("accessoriesrequired")="y" or rs("legsrequired")="y") and rs("wrappingid")=3 then
	sql = "Select * from packagingdata where componentid=6 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
		If not rs2.eof then
		savedboxvalanceweight=rs2("componentweight")
		end if
	rs2.close
	set rs2=nothing
	if savedboxvalanceweight="" then savedboxvalanceweight="6"
end if
savedaccweight = ""

if rs("valancerequired")="y" and (rs("mattressrequired")="y" or rs("baserequired")="y" or rs("topperrequired")="y") and rs("wrappingid")=4 then
	sql = "Select * from packagingdata where componentid=9 and comppartno=1 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
		If not rs2.eof then
		savedaccweight=rs2("componentweight")
		end if
	rs2.close
	set rs2=nothing
end if



if rs("mattressrequired")="y" and rs("wrappingid")=3 then
	matt_box = ""
	matt1kg = ""
	sql = "Select * from packagingdata where componentid=1 and comppartno=1 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	If not rs2.eof then
		if rs2("boxsize")<>"" then matt_box=rs2("boxsize")
		if rs2("packkg")<>"" then matt1kg=rs2("packkg")
	end if
	rs2.close
	set rs2=nothing
	
	matt2_box = ""
	matt2kg = ""
	sql = "Select * from packagingdata where componentid=1 and comppartno=2 AND purchase_no = " & rs("purchase_no")
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	If not rs2.eof then
		if rs2("boxsize")<>"" then matt2_box=rs2("boxsize")
		if rs2("packkg")<>"" then matt2kg=rs2("packkg")
	end if
	rs2.close
	set rs2=nothing
end if
'response.Write("baselen=" & baselength)
basewidth=rs("basewidth")
baselength=rs("baselength")
if right(basewidth,2)="cm" then  basewidth= left(rs("basewidth"), len(rs("basewidth"))-2) 
if right(basewidth,2)="in" then  basewidth= (left(rs("basewidth"), len(rs("basewidth"))-2)*2.54)
if right(baselength,2)="cm" then  baselength= left(rs("baselength"), len(rs("baselength"))-2) 
if right(baselength,2)="in" then  baselength= (left(rs("baselength"), len(rs("baselength"))-2) *2.54)

northsouth="n"
eastwest="n"
if left(rs("basetype"),5)="North" and (rs("basewidth")<>"Special (as instructions)"  AND rs("basewidth")<>"Special Width" AND rs("basewidth")<>"n") then
	northsouth="y"
	if right(basewidth,2)="cm" then  basewidth= left(rs("basewidth"), len(rs("basewidth"))-2) 
	if right(basewidth,2)="in" then  basewidth= (left(rs("basewidth"), len(rs("basewidth"))-2)*2.54)
	basewidth=basewidth/2
			
	if right(baselength,2)="cm" then  baselength= left(rs("baselength"), len(rs("baselength"))-2) 
	if right(baselength,2)="in" then  baselength= (left(rs("baselength"), len(rs("baselength"))-2) *2.54)
	baselength2=baselength
end if
if left(rs("basetype"),4)="East" and (rs("basewidth")<>"Special (as instructions)"  AND  rs("basewidth")<>"Special Width"  AND  rs("basewidth")<>"n") then
	eastwest="y"
	if right(basewidth,2)="cm" then  basewidth= left(rs("basewidth"), len(rs("basewidth"))-2) 
	if right(baselength,2)="cm" then  baselength= left(rs("baselength"), len(rs("baselength"))-2)
	if right(baselength,2)="in" then  baselength= (left(rs("baselength"), len(rs("baselength"))-2) *2.54)
	if rs("baselength")<>"n" and rs("baselength")<>"TBC" and rs("baselength")<>"Special Length" then
		baselength2=baselength-130
		baselength=130
	end if
end if

if rs("upholsteredbase")="TBC" then basefabricstatus="1"
if rs("upholsteredbase")="Yes" then basefabricstatus="1"
if rs("upholsteredbase")="Yes, Com" then basefabricstatus="2"
if rs("basefabricchoice")<>"" then basefabricstatus="3"
if baseponumber<>"" then basefabricstatus="4"
if basefabricrecdate<>"" then basefabricstatus="7"
if basecuttingsent<>"" then basefabricstatus="5"
if basefrTreatingSent<>"" then basefabricstatus="9"
if basefrTreatingReceived<>"" then basefabricstatus="10"
if baseconfirmeddate<>"" then basefabricstatus="6"

if base1width<>"" then basewidth=base1width
if base2width<>"" then basewidth2=base2width
if base1length<>"" then baselength=base1length
if base2length	<>"" then baselength2=base2length
if rs("baserequired")="y" and rs("wrappingid")=3 then
'base_box=checkMatt1Box(con,basewidth,baselength)
'base2_box=checkMatt1Box(con,basewidth2,baselength2)
'base1kg=checkMattKg(con,3,rs("basesavoirmodel"),base_box,basewidth,baselength)
'base2kg=checkMattKg(con,3,rs("basesavoirmodel"),base2_box,basewidth2,baselength2)

base_box = ""
base1kg = ""
sql = "Select * from packagingdata where componentid=3 and comppartno=1 AND purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
if rs2("boxsize")<>"" then base_box=rs2("boxsize")
if rs2("packkg")<>"" then base1kg=rs2("packkg")
end if
rs2.close
set rs2=nothing

base2_box = ""
base2kg = ""
sql = "Select * from packagingdata where componentid=3 and comppartno=2 AND purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
if rs2("boxsize")<>"" then base2_box=rs2("boxsize")
if rs2("packkg")<>"" then base2kg=rs2("packkg")
end if
rs2.close
set rs2=nothing
end if

topper_box=""
topper1kg=""
if rs("topperrequired")="y" and rs("wrappingid")=3 then
sql = "Select * from packagingdata where componentid=5 and comppartno=1 AND purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
if rs2("boxsize")<>"" then topper_box=rs2("boxsize")
if rs2("packkg")<>"" then topper1kg=rs2("packkg")
end if
rs2.close
set rs2=nothing
end if

valance_box=""
valance1kg=""
if rs("valancerequired")="y" and rs("wrappingid")=3 then
sql = "Select * from packagingdata where componentid=6 and comppartno=1 AND purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
if rs2("boxsize")<>"" then valance_box=rs2("boxsize")
if rs2("packkg")<>"" then valance1kg=rs2("packkg")
end if
rs2.close
set rs2=nothing
end if

legs_box=""
legs1kg=""
if rs("legsrequired")="y"  and rs("wrappingid")=3 then
sql = "Select * from packagingdata where componentid=7 and comppartno=1 AND purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
if rs2("boxsize")<>"" then legs_box=rs2("boxsize")
if rs2("packkg")<>"" then legs1kg=rs2("packkg")
end if
rs2.close
set rs2=nothing
end if

hb_box=""
hb1kg=""
if rs("headboardrequired")="y" and rs("wrappingid")=3 then
sql = "Select * from packagingdata where componentid=8 and comppartno=1 AND purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
if rs2("boxsize")<>"" then hb_box=rs2("boxsize")
if rs2("packkg")<>"" then hb1kg=rs2("packkg")
end if
rs2.close
set rs2=nothing
end if

acc1_box=""
acc1kg=""
savedboxaccweight = ""
if rs("accessoriesrequired")="y" and rs("wrappingid")=3 then
sql = "Select * from packagingdata where componentid=9 and comppartno=1 AND purchase_no = " & rs("purchase_no")
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
if rs2("boxsize")<>"" then acc1_box=rs2("boxsize")
if rs2("packkg")<>"" then acc1kg=rs2("packkg")
savedboxaccweight =rs2("componentweight")
end if
rs2.close
set rs2=nothing
end if




if not isnull(rs("ordercurrency")) and rs("ordercurrency") <> "" then
	orderCurrency = rs("ordercurrency")
else
	orderCurrency = "GBP"
end if

salesOnly = false
formAction = "update-productioninfo.asp"
if userHasRole("SALES") and not userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR") then
	salesOnly = true
	formAction = "update-productioninfo-salesonly.asp"
end if
%>

<%If msg<>"" then response.Write("<div id=""floatleft""><font color=red>" & msg & "</font></div><br />")%>
<form name="form2" method="post" action="orderdetails.asp">
    <label for="search"></label>
    Search for an Order Number
    <input type="text" name="search" id="search">
    <input type="submit" name="submitX" id="submitX" value="Submit">
  </form><br>
  <p><a href="editcust.asp?val=<%=rs("contact_no")%>&tab=2#TabbedPanels1">
  GO TO CUSTOMER DETAILS</a></p>
  <%sql = "select p.purchase_no from purchase p where  p.contact_no=" & rs("contact_no") & " and (p.quote='n' or p.quote is null) and (p.cancelled='n' or p.cancelled is null) and p.completedorders='n' group by p.purchase_no"
'response.write("sql = " & sql)
set rs7 = getMysqlQueryRecordSet(sql, con)
if rs7.recordcount>1 then%>
                            <div class="AccordionPanel">
  	<a href="javascript:void(0)" class="stickleft" onclick="getPanelContent('<%=rs("contact_no")%>', 'TRUE', '1');" id="plus1">&nbsp;&nbsp;<img src="images/plus.gif" > Other Current Orders </a>
  	<a href="javascript:void(0)" class="stickleft" onclick="closePanel('<%=rs("contact_no")%>', '1');" id="minus1">&nbsp;&nbsp;<img src="images/minus.gif" > Close List of Other Current Orders</a>
    <div class="AccordionPanelTab">
        </div><div class="Accordclear"></div>
    <div id="panel1" class="AccordionPanelContent"></div>
  
</div><div class="Accordclear"></div>
<%end if%>
<%sql="SELECT * FROM exportlinks L, exportcollshowrooms C, exportcollections E where L.purchase_no=" & order & " and L.linkscollectionid=C.exportCollshowroomsID and C.exportCollectionID =E.exportCollectionsID and exists (select 1 from qc_history_latest q where q.purchase_no=L.purchase_no and q.componentid=L.componentid and q.qc_statusid in (60,120)) group by L.linkscollectionid"
'if isNull(rs("bookeddeliverydate")) or rs("bookeddeliverydate")="" then
'response.Write(sql)
'response.End()
	Set rs5 = getMysqlQueryRecordSet(sql, con)
	if not rs5.eof then
	do until rs5.eof
	sid=rs5("shipper")
	loc=rs5("idlocation")
	cid=rs5("exportCollectionsID")
	'response.Write(rs5("collectiondate"))
	rs5.movenext
	loop
	end if
rs5.close
set rs5=nothing
'end if
%>
  <div id="floatrightP">
<a href="production-orders.asp">LIST ALL ORDERS</a>&nbsp;&nbsp;&nbsp;<%If prevorder<>"" then%>|&nbsp;&nbsp;&nbsp;<a href="orderdetails.asp?pn=<%=prevorder%>">PREVIOUS ORDER</a>&nbsp;&nbsp;&nbsp;<%end if%>
<%If nextorder<>"" then%>&nbsp;&nbsp;&nbsp;<a href="orderdetails.asp?pn=<%=nextorder%>">NEXT ORDER</a>&nbsp;&nbsp;&nbsp;<%end if%>
<br />

<a href="commercial-invoice.asp?pno=<%=rs("purchase_no")%>&sid=<%=sid%>&loc=<%=loc%>&cid=<%=cid%>">Commercial Invoice</a> | <a href="picking-note-pdf.asp?pn=<%=rs("purchase_no")%>" target="_blank">
Picking Note</a> |<%'if CDbl(rs("balanceoutstanding"))=0 then%> 

<a href="#" onclick="toggle_visibility('deltime');setBalanceAlert();">Delivery Note</a> |<%'end if%> <a href="production-list.asp">Production List</a> | <a href="php/PrintPDF.pdf?val=<%=order%>" target="_blank">Print PDF</a>&nbsp;&nbsp;
<br><br>Order Total: <%=getCurrencySymbolForCurrency(orderCurrency)%><%=rs("total")%>
<br>Balance Outstanding: <%=getCurrencySymbolForCurrency(orderCurrency)%><%=rs("balanceoutstanding")%> 
<div id="deltime" style="display:none;"><br />
<form method="post" name="formD" id="formD" onSubmit="return FrontPage_Form2_Validator(this)" action="/php/DeliveryNote.pdf?pn=<%=rs("purchase_no")%>" target="_blank">
Enter Delivery Time: <input name="deltime" type="text" size="20" value="<%=rs("delivery_Time")%>"><br /><br>
Delivered by: <input name="deliveredby" type="text" value="<%=rs("deliveredby")%>" size="20"><br /><br>
<%if rs("giftpackrequired")="y" then%>
<input name="giftpack" id="giftpack" type="checkbox" value="y" onChange="setGiftLetter();" checked>
<%else%>
<input name="giftpack" id="giftpack" type="checkbox" value="y" onChange="setGiftLetter();">
<%end if%> Deliver Gift Pack&nbsp;&nbsp;
<div id="delletter"><button onClick="window.open('giftpack.asp?pn=<%=rs("purchase_no")%>'); return false;">Delivery Letter</button></div>
<br /><br>
<%
if isNull(rs("bookeddeliverydate")) or rs("bookeddeliverydate")="" then
	Set rs5 = getMysqlQueryRecordSet("SELECT L.componentid, L.linkscollectionid, E.collectiondate FROM exportlinks L, exportcollshowrooms C, exportcollections E where L.purchase_no=" & order & " and L.linkscollectionid=C.exportCollshowroomsID and C.exportCollectionID =E.exportCollectionsID and exists (select 1 from qc_history_latest q where q.purchase_no=L.purchase_no and q.componentid=L.componentid and q.qc_statusid in (60,120)) group by L.linkscollectionid", con)
	if not rs5.eof then
	dim shipmentchecked, shipmentidArray(), shipmentcount
	
	shipmentcount=0
	shipmentchecked="checked"
	response.Write("<b>Select shipment date for delivery note</b><br />")
	do until rs5.eof
	shipmentcount = shipmentcount + 1
	redim preserve shipmentidArray(shipmentcount)
	shipmentidArray(shipmentcount)=rs5("linkscollectionid")%>
	
	<input name="shipmentdate" id="shipmentdate" type="radio" value="<%=rs5("linkscollectionid")%>" <%=shipmentchecked%> ><%=rs5("collectiondate")%><br />
	<%shipmentchecked=""
	rs5.movenext
	loop
	end if
	rs5.close
	set rs5=nothing
end if
%>
<input type="submit" name="Save2" id="Save2" value="Go To Delivery Note"></form>
</div>

<p><%Dim mattressrequired, baserequired, topperrequired, headboardrequired, legsrequired, valancerequired
for i=1 to shipmentcount
mattressrequired=false
baserequired=false
topperrequired=false
headboardrequired=false
legsrequired=false
valancerequired=false

sql = "select * from exportlinks where linkscollectionid=" & shipmentidArray(i) & " and purchase_no=" & order
'response.write("sql=" & sql)
set rs5 = getMysqlQueryRecordSet(sql, con)
do until rs5.eof
if rs5("componentid")=1 then mattressrequired=true
if rs5("componentid")=3 then baserequired=true
if rs5("componentid")=5 then topperrequired=true
if rs5("componentid")=6 then valancerequired=true
if rs5("componentid")=7 then legsrequired=true
if rs5("componentid")=8 then headboardrequired=true
rs5.movenext
loop
rs5.close
set rs5=nothing

'if valancerequired then
'if baserequired  then
'valancetxt="Valance packed with base"
'if basetxtinc="" then basetxtinc="Inc Valance" else basetxtinc=basetxtinc & " & Valance" 'crate include
'basetxtinc3="Inc Valance" 'box include
'end if
'if not baserequired and mattressrequired then
'valancetxt="Valance packed with mattress"
'if mattresstxtinc="" then mattresstxtinc="Inc Valance" else mattresstxtinc=mattresstxtinc & " & Valance"
'mattresstxtinc3="Inc Valance" 'box include
'end if
'if not baserequired and not mattressrequired and topperrequired then
'valancetxt="Valance packed with topper"
'if toppertxtinc="" then toppertxtinc="Inc Valance" else toppertxtinc=toppertxtinc & " & Valance"
'toppertxtinc3="Inc Valance" 'box include
'end if
'if not baserequired and not mattressrequired and not topperrequired and headboardrequired then
'valancetxt="Valance packed with headboard"
'if hbtxtinc="" then hbtxtinc="Inc Valance" else hbtxtinc=hbtxtinc & " & Valance"
'hbtxtinc3="Inc Valance" 'box include
'end if
'end if

'if legsrequired then
'if baserequired then
'legstxt="Legs packed with base"
'if basetxtinc="" then basetxtinc="Inc Legs" else basetxtinc=basetxtinc & " & Legs"
'end if
'if not baserequired and mattressrequired then
'legstxt="Legs packed with mattress"
'if mattresstxtinc="" then mattresstxtinc="Inc Legs" else mattresstxtinc=mattresstxtinc & " & Legs"
'end if
'if not baserequired and not mattressrequired and topperrequired then
'legstxt="Legs packed with topper"
'if toppertxtinc="" then toppertxtinc="Inc Legs" else toppertxtinc=toppertxtinc & " & Legs"
'end if
'if not mattressrequired and not baserequired and not topperrequired and headboardrequired then
'legstxt="Legs packed with headboard"
'if hbtxtinc="" then hbtxtinc="Inc Legs" else hbtxtinc=hbtxtinc & " & Legs"
'end if
'end if

'if mattressrequired and topperrequired then
'toppertxt="Topper packed with mattress"
'if mattresstxtinc="" then mattresstxtinc="Inc Topper" else mattresstxtinc=mattresstxtinc & " & Topper"
'end if

next
%>
<form name="jump2">
<select name="myjumpbox"
 OnChange="window.open(jump2.myjumpbox.options[selectedIndex].value)">
     <option selected>Please Select...
     <option value="php/Cases.pdf?pn=<%=rs("purchase_no")%>">Work Sheet - Cases
     <option value="frames.asp?pn=<%=rs("purchase_no")%>">Work Sheet - Frames
     <%if rs("legsrequired")="y" or rs("headboardlegqty")>0 then%>
      <option value="php/Legs.pdf?pn=<%=rs("purchase_no")%>">Work Sheet - Legs
      <%end if%>
      <option value="php/JobFlag.pdf?pn=<%=rs("purchase_no")%>">Job Flag
      <option value="php/PrintPDF.pdf?val=<%=rs("purchase_no")%>">Print PDF
</select>
</form>

</p>
</div>
<div class="clear"></div>
  <div class="delnote">
  
</div>
<div id="mainformdiv">
<form method="post" name="form1" id="form1" onSubmit="return formSubmitHandler(this)" action="<%=formAction%>">
<input name="custcode" type="hidden" value="<%=rs("code")%>">
<input name="orderno" type="hidden" value="<%=rs("order_number")%>">
<input id="purchaseno" name="purchaseno" type="hidden" value="<%=rs("purchase_no")%>">
<input id="locationname" name="locationname" type="hidden" value="<%=locationname%>">
<input id="customerref" name="customerref" type="hidden" value="<%=rs("customerreference")%>">
<input id="baseqc_orig" name="baseqc_orig" type="hidden" value="<%=basestatus%>">
<input type="submit" name="Save" id="Save" value="Save" class="delnote">
<%
call getPhoneNumber(con, order, 1, delphonetype1, delphone1)
call getPhoneNumber(con, order, 2, delphonetype2, delphone2)
call getPhoneNumber(con, order, 3, delphonetype3, delphone3)
%>
<%if rs("ordersource")<>"" then response.Write("<b>" & rs("ordersource") & " Order</b><br /><br />")%>
<table width="950" border="0" cellspacing="0" cellpadding="1">
  <tr>
    <td colspan="2" valign="top"><strong><span class="lgtext">Order Number: <%=rs("order_number")%></span></strong>      </td>
    <td colspan="2" valign="top"><%if userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR") then %>
    <strong>Order Completed (tick if yes)      </strong>  
    	<input name="complete" type="checkbox" id="complete" value="y" <%=ischecked(rs("completedorders") <> "n")%> <%=isDisabled(rs("completedorders") <> "n")%> />
        <%end if%>
	</td>
    <td colspan="2" valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td colspan="2" valign="top">&nbsp;</td>
    <td colspan="2" valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td width="98" valign="top"><strong>Contact:</strong></td>
    <td width="192" valign="top"><%=rs("salesusername")%></td>
    <td colspan="2" valign="top"><strong>Invoice Address</strong></td>
    <td colspan="2" valign="top"><strong>Delivery Address</strong></td>
    </tr>
  <tr>
    <td valign="top"><strong>Order Source:</strong></td>
    <td valign="top"><%=locationname%>&nbsp;</td>
    <td width="101" valign="top"><strong>Line 1</strong></td>
    <td width="223" valign="top"><input name="add1" type="text" id="add1" tabindex="45" value="<%=rs("street1")%>" size="30" maxlength="100" ></td>
    <td width="112" valign="top"><strong>Line 1</strong></td>
    <td width="212" valign="top"><input name="add1d" type="text" id="add1d" tabindex="90" value="<%=rs("deliveryadd1")%>" size="30" maxlength="100"></td>
  </tr>
  <tr>
    <td valign="top"><strong>Clients Title</strong>:</td>
    <td valign="top"><input name="clientstitle" type="text" id="clientstitle" tabindex="1" value="<%=rs("title")%>"></td>
    <td valign="top"><strong>Line 2</strong></td>
    <td valign="top"><input name="add2" type="text" id="add2" tabindex="50" value="<%=rs("street2")%>" size="30" maxlength="100" ></td>
    <td valign="top"><strong>Line 2</strong></td>
    <td valign="top"><input name="add2d" type="text" id="add2d" tabindex="95" value="<%=rs("deliveryadd2")%>" size="30" maxlength="100"></td>
    </tr>
  <tr>
    <td valign="top"><strong>First Name:</strong></td>
    <td valign="top"><input name="clientsfirst" type="text" id="clientsfirst" tabindex="5" value="<%=rs("first")%>"></td>
    <td valign="top"><strong>Line 3</strong></td>
    <td valign="top"><input name="add3" type="text" id="add3" tabindex="55" value="<%=rs("street3")%>" size="30" maxlength="100" ></td>
    <td valign="top"><strong>Line 3</strong></td>
    <td valign="top"><input name="add3d" type="text" id="add3d" tabindex="100" value="<%=rs("deliveryadd3")%>" size="30" maxlength="100"></td>
    </tr>
  <tr>
    <td valign="top"><strong>Surname:</strong></td>
    <td valign="top"><input name="clientssurname" type="text" id="clientssurname" tabindex="10" value="<%=rs("surname")%>" readonly></td>
    <td valign="top"><strong>Town</strong></td>
    <td valign="top"><input name="town" type="text" id="town" tabindex="60" value="<%=rs("town")%>" size="30" maxlength="100"></td>
    <td valign="top"><strong>Town</strong></td>
    <td valign="top"><input name="townd" type="text" id="townd" tabindex="105" value="<%=rs("deliverytown")%>" size="30" maxlength="100"></td>
    </tr>
  <tr>
    <td valign="top"><strong>Account&nbsp;Code:</strong></td>
    <td valign="top"><input name="accountcode" type="text" id="accountcode" tabindex="15" value="<%=rs("accountcode")%>" maxlength="255" ></td>
    <td valign="top"><strong>County</strong></td>
    <td valign="top"><input name="county" type="text" id="county" value="<%=rs("county")%>" size="30" maxlength="100" ></td>
    <td valign="top"><strong>County</strong></td>
    <td valign="top"><input name="countyd" type="text" id="countyd" tabindex="110" value="<%=rs("deliverycounty")%>" size="30" maxlength="100"></td>
    </tr>
  <tr>
    <td valign="top"><strong>Date Ordered:</strong></td>
    <td valign="top"><%=rs("order_date")%></td>
    <td valign="top"><strong>Postcode</strong></td>
    <td valign="top"><input name="postcode" type="text" id="postcode" value="<%=rs("postcode")%>" size="15" maxlength="50" ></td>
    <td valign="top"><strong>Postcode</strong></td>
    <td valign="top"><input name="postcoded" type="text" id="postcoded" tabindex="115" value="<%=rs("deliverypostcode")%>" size="15" maxlength="50"></td>
    </tr>
  <tr>
    <td valign="top"><strong>Customer Ref:</strong></td>
    <td valign="top"><%=rs("customerreference")%></td>
    <td valign="top"><strong>Country</strong></td>
    <td valign="top"><input name="country" type="text" id="country" tabindex="65" value="<%=rs("country")%>" size="30" maxlength="100" ></td>
    <td valign="top"><strong>Country</strong></td>
    <td valign="top"><input name="countryd" type="text" id="countryd" tabindex="120" value="<%=rs("deliverycountry")%>" size="30" maxlength="100"></td>
    </tr>
  <tr>
    <% if not hideVatRate(con, rs("contact_no")) then %>
	    <td valign="top"><strong>VAT Rate:</strong></td>
	    <td valign="top"><%If rs("vatrate")<>"" then response.Write(rs("vatrate") & "%")%></td>
    <% else %>
    	<td colspan="2">&nbsp;</td>
    <% end if %>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top"></td>
    <td valign="top"></td>
  </tr>
  <tr>
    <td valign="top"><strong>Email:</strong></td>
    <td valign="top"><input name="email_address" type="text" id="email_address" tabindex="25" value="<%=rs("email_address")%>"></td>
    <td valign="top"><strong>Co.VAT No:</strong></td>
    <td valign="top"><%=rs("company_vat_no")%></td>
     <td valign="top"><strong>Contact no.1:</strong></td>
        <td valign="top">
        	<select name="delphonetype1" id="delphonetype1" tabindex="125">
	        	<% for n = 1 to ubound(typenames) %>
	    	    	<option value="<%=typenames(n)%>" <%=selected(typenames(n), delphonetype1)%> ><%=typenames(n)%></option>
	        	<% next %>
	        	<% if not arrayContains(typenames, delphonetype1) then %>
		        	<option value="<%=delphonetype1%>" selected ><%=delphonetype1%></option>
	        	<% end if %>
        	</select>
        	&nbsp;<input name="delphone1" type="text" id="delphone1" tabindex="130" value="<%=delphone1%>" size="11" />
        </td>
  </tr>
  <tr>
    <% if not hideOrderType(con, rs("contact_no")) then %>
	    <td valign="top"><strong>Order Type:</strong></td>
	    <td valign="top"><%=getOrderType(rs)%></td>
    <% else %>
		<td colspan="2">&nbsp;</td>
    <% end if %>
    <td valign="top"><strong>Co.Name: </strong></td>
    <td valign="top"><input name="companyname" type="text" id="companyname" tabindex="70" value="<%=rs("company")%>" size="30" maxlength="255"></td>
    <td valign="top"><strong>Contact no 2:</strong></td>
    <td valign="top"><select name="delphonetype2" id="delphonetype2" tabindex="135">
      <% for n = 1 to ubound(typenames) %>
      <option value="<%=typenames(n)%>" <%=selected(typenames(n), delphonetype2) %> ><%=typenames(n)%></option>
      <% next %>
      <% if not arrayContains(typenames, delphonetype2) then %>
      <option value="<%=delphonetype2%>" selected ><%=delphonetype2%></option>
      <% end if %>
    </select>
  &nbsp;
  <input name="delphone2" type="text" id="delphone2" tabindex="140" value="<%=delphone2%>" size="11" /></td>
    </tr>
  <tr>
    <td valign="top"><strong>Tel Home:</strong></td>
    <td valign="top"><input name="tel" type="text" id="tel" tabindex="30" value="<%=rs("tel")%>"></td>
    <%if retrieveUserRegion=1 and (rs("overseasOrder")="n" or isNull(rs("overseasOrder"))) then%>
            <td valign="top"><strong>Expected Delivery:</strong></td>
            <td valign="top"><select name="deldate" id="deldate" tabindex="75">
              <% for i = 1 to ubound(delDateValues) %>
              <option value="<%=delDateValues(i)%>" <%=selected(delDateValues(i), delDate)%> ><%=delDateDescriptions(i)%></option>
              <% next %>
            </select></td>
     <%else%>
     <td>Ex. Works Date: </td>
            <%
			Set rs5 = getMysqlQueryRecordSet("select count(*) as lorrycount from (SELECT linkscollectionid FROM exportlinks where purchase_no=" & order & "  group by linkscollectionid)  as x", con)
			if not rs5.eof then
			lorrycount=rs5("lorrycount")
			end if
				 
			rs5.close
			set rs5=nothing
			
			%>
            <td><%
			if Cint(lorrycount) > 1 then 
			response.Write("Split Shipment Dates")
			splitshipment="y"
			%>
            <%else
			splitshipment="n"
			Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportLinks L, exportCollShowrooms S where L.linkscollectionid=S.exportCollshowroomsID and L.purchase_no=" & order & " and S.exportCollectionID=E.exportCollectionsID", con)
			if not rs5.eof then
			response.Write(rs5("CollectionDate"))
			else
			response.Write("TBA")
			end if
			rs5.close
			set rs5=nothing%>
            <%end if%>
	    </td>
            <%end if%>
    <td valign="top"><strong>Contact no 3:</strong></td>
    <td valign="top"><select name="delphonetype3" id="delphonetype3" tabindex="145">
      <% for n = 1 to ubound(typenames) %>
      <option value="<%=typenames(n)%>" <%=selected(typenames(n), delphonetype3)%> ><%=typenames(n)%></option>
      <% next %>
      <% if not arrayContains(typenames, delphonetype3) then %>
      <option value="<%=delphonetype3%>" selected ><%=delphonetype3%></option>
      <% end if %>
    </select>
  &nbsp;
  <input name="delphone3" type="text" id="delphone3" tabindex="150" value="<%=delphone3%>" size="11" /></td>
    </tr>
  <tr>
    <td valign="top"><strong>Tel Work:</strong></td>
    <td valign="top"><input name="telwork" type="text" id="telwork" tabindex="35" value="<%=rs("telwork")%>">
  &nbsp;</td>
    <td valign="top"><strong>Order Source:</strong></td>
    <td valign="top"><%=locationname%>&nbsp;</td>
    <td valign="top"></td>
    <td valign="top"></td>
  </tr>
  <tr>
    <td valign="top"><strong>Mobile:</strong></td>
    <td valign="top"><input name="mobile" type="text" id="mobile" tabindex="40" value="<%=rs("mobile")%>">
  &nbsp;</td>
    <td valign="top"><strong>Order Status:</strong></td>
    <td valign="top"><%Set rs3 = getMysqlUpdateRecordSet("Select * from OrderStatus", con)%>
           <%Set rs3 = getMysqlUpdateRecordSet("Select * from QC_status where  retiredCoreProducts='n'", con)%>
          <select name="orderstatus" id="orderstatus">
     
             <%do until rs3.eof
%>  <option value="<%=rs3("QC_statusid")%>" <%=selected(rs3("QC_statusid"), orderstatus) %>><%=rs3("QC_status")%></option>
           
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select>&nbsp;</td>
    <td valign="top">Main Production Date:</td>
    <td valign="top">
    <%if isSuperUser() then %>
    <input name="productiondate" type="text" id="productiondate" tabindex="155" value="<%=rs("productiondate")%>" size="10" readonly />
    	  <a href="javascript:clearproductiondate();">X</a>
        <%else%>
        <input name="productiondate" type="text" id="productiondate" tabindex="155" value="<%=rs("productiondate")%>" size="10" readonly />
        <%end if%></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top"><strong>Fire Label:</strong></td>
    <td valign="top"><%Set rs3 = getMysqlUpdateRecordSet("Select * from FireLabel", con)%>
      <select name="firelabel" id="firelabel" tabindex="85">
        <option value="n">None</option>
        <%do until rs3.eof
%>
<option value="<%=rs3("firelabelid")%>" <%=selected(rs3("firelabelid"), defaultfirelabelid) %>><%=rs3("firelabel")%></option>
<%rs3.movenext
loop
rs3.close
set rs3=nothing%>
</select>
&nbsp;</td>
<td valign="top">London Production Date</td>
<td valign="top">
<input name="londonproductiondate" type="text" id="londonproductiondate" tabindex="155" value="<%=rs("londonproductiondate")%>" size="10" readonly>
<%if userHasRole("PRODUCTION_MANAGERS") then%>
 <a href="javascript:clearlondonproductiondate();">X</a>
 <%end if%>
</td>
</tr>
<tr>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top"><strong>Wrap:</strong></td>
<td valign="top"><%Set rs3 = getMysqlUpdateRecordSet("Select * from WrappingTypes", con)%>
<div id="wtype">

<select name="wraptype" id="wraptype" tabindex="85" onchange="wrapTypeChangeHandler();" >
<%do until rs3.eof
%>
<option value="<%=rs3("wrappingid")%>" <%=selected(rs3("wrappingid"), defaultwrappingid) %>><%=rs3("wrap")%></option>
<%rs3.movenext
loop
rs3.close
set rs3=nothing%>

&nbsp;
</select>

</div></td>
<td valign="top">Cardiff Production Date</td>
<td valign="top">
<input name="cardiffproductiondate" type="text" id="cardiffproductiondate" tabindex="155" value="<%=rs("cardiffproductiondate")%>" size="10" readonly>
<%if userHasRole("PRODUCTION_MANAGERS") then%>
 <a href="javascript:clearcardiffproductiondate();">X</a>
<%end if%></td>
</tr>
<tr>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top"><strong>Delivered On:</strong></td>
<td valign="top"><label for="deliveredon"></label>
<input name="deliveredon" type="text" id="deliveredon" tabindex="155" value="<%=rs("bookeddeliverydate")%>" size="10"  onChange="calendarBlurHandler(deliveredon)" readonly> <a href="javascript:cleardeliveredon(); setDeliveredOn()">X</a></td>
</tr>
<tr>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top"><strong>Confirmed Delivery:</strong></td>
<td valign="top">
<%if rs("DeliveryDateConfirmed")="y" then%>
<input type="checkbox" name="confirmeddelivery" id="confirmeddelivery" value="y" checked onChange="setDeliveredOn()">
<%else%>
<input type="checkbox" name="confirmeddelivery" id="confirmeddelivery" value="y" onChange="setDeliveredOn()">
<%end if%>
<label for="confirmeddelivery"></label></td>
</tr>
<tr>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top"><strong>Production Completion Date:</strong></td>
<td valign="top"><%=rs("production_completion_date")%>&nbsp;</td>
</tr>
<%if rs("overseasorder")="y" then %>
<tr>

<td colspan="6" valign="top"><strong>Current Shipper:</strong>

<%Dim shipperaddress
Set rs3 = getMysqlQueryRecordSet("Select * from purchase_shipper where purchase_no=" & rs("purchase_no"), con)
if not rs3.eof then
shipperaddress=rs3("shippername")
if rs3("add1")<>"" then shipperaddress=shipperaddress & ", " & rs3("add1")
if rs3("add2")<>"" then shipperaddress=shipperaddress & ", " & rs3("add2")
if rs3("add3")<>"" then shipperaddress=shipperaddress & ", " & rs3("add3")
if rs3("town")<>"" then shipperaddress=shipperaddress & ", " & rs3("town")
if rs3("countystate")<>"" then shipperaddress=shipperaddress & ", " & rs3("countystate")
if rs3("postcode")<>"" then shipperaddress=shipperaddress & ", " & rs3("postcode")
response.Write(shipperaddress)
end if
rs3.close
set rs3=nothing%>	    </td>
</tr>
<% end if %>
    
      
</table>
<div id="NoteInner">
<hr />
<%if retrieveUserRegion() = 1 or userHasRoleInList("ORDERDETAILS_VIEWER") then
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
                                                            <td width = "400"><%= safeHtmlEncode(noteHistory(i).text) %></td>

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

<div class="clear"></div>

<table width="903" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr>
    <td><table width="1050" border="0" cellspacing="0" cellpadding="0">
     <tr>
        <td colspan="5"><strong>Click or Drag to upload files for this order<br>
            <br>
Files Required for Production:</strong><br />
<%dzOrderNum = rs("order_number")
		dzPurchaseNo = pn
		dzUserId = retrieveUserID()
		dzType = "entry"%>
		<!-- #include file="dropzone_include.asp" --><br /><hr />
</td>
        </tr>
      <tr>
        <td width="417"><strong>SALES (<a href="edit-purchase.asp?prod=y&order=<%=pn%>"><font color="#FF0000">click here to amend sales section</font></a>)</strong></td>
        <td width="213"><strong>FABRIC</strong></td>
        <td width="218"><strong>PRODUCTION</strong></td>
        <td width="202"><strong>LOGISTICS</strong></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><span class="radiobxmargin"><strong><%if rs("mattressrequired")="y" then response.write("Mattress Required") else response.Write("Mattress Not Required ")%></strong></span>
    
     Show
       <label>
       <input type="radio" name="mattressrequired" id="mattressrequired_y" value="y" <%=ischecked2(rs("mattressrequired")="y")%> onClick="javascript:mattressChanged()" >
     </label>
     Hide
     <input name="mattressrequired" type="radio" id="mattressrequired_n" value="n" <%=ischecked2(rs("mattressrequired")="n")%> onClick="javascript:mattressChanged()" >
     <br>
     <br>
     <%if rs("mattressrequired")="y" then%>
<div id="mattress_div">
<div id="matt1">
  <table border="0" align="left" cellpadding="2" cellspacing="0">
 
    
  <tr>
    <td valign="top"><strong>Made At:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%Set rs3 = getMysqlUpdateRecordSet("Select * from ManufacturedAt WHERE manufacturertype='b'", con)%>
      <select name="mattressmadeat" id="mattressmadeat" onChange="javascript: defaultAreaProductionDates(); ">
        <option value="n">Not Allocated</option>
        <%do until rs3.eof
%>
        <option value="<%=rs3("manufacturedatid")%>" <%=selected(rs3("manufacturedatid"), mattressmadeat) %>><%=rs3("manufacturedat")%></option>
        <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%>
      </select>
      &nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top"><strong>Model:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("savoirmodel")%></td>
    <td valign="top"><strong>Type:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("mattresstype")%></td>
    </tr>
    <%if rs("leftsupport")="n" AND rs("rightsupport")="n" then%>
    <%else%>
  <tr>
  <%if rs("leftsupport")="n" then%>
  <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
    <td valign="top"><strong>Left Support:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("leftsupport")%></td>
    <%end if%>
     <%if rs("rightsupport")="n" then%>
      <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
    <td valign="top"><strong>Right Support:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("rightsupport")%></td>
    <%end if%>
    </tr>
    <%end if%>
     <%if rs("tickingoptions")="n" AND rs("ventposition")="n" then%>
    <%else%>
  <tr>
   <%if rs("tickingoptions")="n" then%>
     <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
    <%else%>
    <td valign="top"><strong>Ticking:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("tickingoptions")%></td>
    <%end if%>
    <%if rs("ventposition")="n" then%>
    <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
    <%else%>
    <td valign="top"><strong>Vent Pos:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("ventposition")%></td>
    <%end if%>
  </tr>
  <%end if%>
  <%if mattwidthdivided="n" and mattlengthdivided="n" then%>
  <%else%>
  <tr>
    <td valign="top"><strong> Matt&nbsp;<%if zippedpair<>"n" then%>1&nbsp;<%end if%>Width:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=mattwidthdivided%></td>
    
    <td valign="top"><strong> Matt&nbsp;<%if zippedpair<>"n" then%>1&nbsp;<%end if%>Length:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=mattlengthdivided%></td>
    </tr>
    <%end if%>
    <%if matt1width <>"" or matt1length<>"" then%>
  <tr>
    <td valign="top"><%if matt1width<>"" then %><b>1 width cm</b><%end if%></td>
    <td valign="top" bgcolor="#FFFFFF">
	<%if matt1width<>"" then %>
    <input name="matt1width" type="text" value="<%=formatnumber(matt1width,2)%>" size="7">
    <%end if%></td>
    <td valign="top"><%if matt1length<>"" then %><b>1 length cm</b><%end if%></td>
    <td valign="top" bgcolor="#FFFFFF"><%if matt1length<>"" then %>
    <input name="matt1length" type="text" value="<%=formatnumber(matt1length,2)%>" size="7">
    <%end if%></td>
  </tr>
  <%end if%>
 <%if zippedpair<>"n" then%> 
  <tr>
    <td valign="top"><strong> Matt&nbsp;2&nbsp;Width:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=mattwidthdivided%></td>
    <td valign="top"><strong> Matt 2 Length:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=mattlengthdivided%></td>
    </tr>
  <%end if%>
  <%if matt2width<>"" or matt2length<>"" then%>
  <tr>
    <td valign="top"><%if matt1width<>"" then %><b>2 width cm</b><%end if%></td>
    <td valign="top" bgcolor="#FFFFFF">
	<%if matt2width<>"" then %>
    <input name="matt2width" type="text" value="<%=formatnumber(matt2width,2)%>" size="7">
    <%end if%></td>
    <td valign="top"><%if matt2length<>"" then %><b>2 length cm</b><%end if%></td>
    <td valign="top" bgcolor="#FFFFFF"><%if matt2length<>"" then %>
    <input name="matt2length" type="text" value="<%=formatnumber(matt2length,2)%>" size="7">
    <%end if%></td>
  </tr>
  <%end if%>
  <%if rs("ventfinish")="n" and isNULL(rs("mattressprice")) then 
  else%>
  <tr>
  <%if rs("ventfinish")="n" then %>
  <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
    <%else%>
    <td valign="top"><strong>Vent&nbsp;Finish:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("ventfinish")%></td>
        <%end if%>
     <%if rs("mattressprice")="" or isNULL(rs("mattressprice")) then %>
  <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
    <%else%>   
    <td valign="top"><strong>Price:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=getCurrencySymbolForCurrency(orderCurrency)%><%=rs("mattressprice")%></td>
    <%end if%>
    </tr>
    <%end if%>
     <%if rs("mattressinstructions")<>"" then %>
    <tr>
    <td colspan="4" valign="top" class="box"><strong>Instructions:</strong><br>
  
      <%=rs("mattressinstructions")%>
    </td>
  </tr>
  <%end if%>
  
<% if leftTension <> -1 or rightTension <> -1 then %>
  	<tr>
    	<td colspan="4" valign="top" class="box"><strong>Spring Unit Row Count:</strong><br>
    		<% if rightTension = 0 then%>
    		    Row = <%=leftTension%>
    		<% else %>
    			Left Row = <%=leftTension%><br>
				Right Row = <%=rightTension%>
    		<% end if %>
      	</td>
    </tr>
   <%end if%>
  
</table>
</div>
<div id="matt2">
  <table width="200" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
  </div>
<div id="matt3">  
<table width="200" border="0" cellpadding="2" cellspacing="0" class="prod">
<tr>
<td valign="top">

<strong>Matt Case Cut</strong>

<br>
<input name="mattcut" type="text" id="mattcut" value="<%=mattcut%>" size="10" readonly>
 <a href="javascript:clearmattcut();">X</a>   </td>
</tr>
<tr>
<td valign="top">
<strong>Matt Case Machined</strong>
<br>
<input name="mattmachined" type="text" id="mattmachined" value="<%=mattmachined%>" size="10" readonly>
 <a href="javascript:clearmattmachined();">X</a> </td>
</tr>
<tr>
<td valign="top"><strong>Mattress Ticking Used</strong>
<label for="tickingbatchno"></label>
<input name="tickingbatchno" type="text" id="tickingbatchno" value="<%=tickingbatchno%>" size="20"></td>
</tr>
<tr>
<td valign="top"><strong>Spring Unit Complete Date</strong>
<label for="springunitdate"></label>
<input name="springunitdate" type="text" id="springunitdate" value="<%=springunitdate%>" size="10" readonly> <a href="javascript:clearspringunitdate();">X</a> </td>
</tr>
<tr>
<td valign="top"><strong>Made By:<br>
<%if mattressmadeat<>"" and mattressmadeat<>"n" then
sql="Select * from  manufacturedat M, savoir_user U WHERE U.madeby='y' and M.manufacturedatid=" & mattressmadeat & " and U.id_location = M.id_location and  U.retired='n' order by U.name asc"
else
sql="Select * from  manufacturedat M, savoir_user U WHERE U.madeby='y' and U.id_location = M.id_location and  U.retired='n' order by U.name asc"
end if
Set rs3 = getMysqlUpdateRecordSet(sql, con)%>
<select name="mattmadeby" id="mattmadeby">
<option value="n"></option>
<%do until rs3.eof
%>  <option value="<%=rs3("user_id")%>" <%=selected(rs3("user_id"), madeby) %>><%=rs3("name")%></option>

<%rs3.movenext
loop
rs3.close
set rs3=nothing%></select>
</strong></td>
</tr>
<%if jobflagMatt<>"" then%>
<tr>
<td valign="top"><strong>Job Flag: </strong><%=jobflagMatt%></td>
</tr>
<%end if%>
<tr>
<td valign="top"><strong>Finished:<br>
<input name="mattfinished" type="text" id="mattfinished" value="<%=mattfinished%>" size="10" readonly onChange="calendarBlurHandler(mattfinished); checkMattFinishedStatus();">
 <a href="javascript:clearmattfinished();checkFinishedDateCompleted(null)">X</a> </strong></td>
</tr>
</table>
</div>
<div id="matt4">  
<table width="200" border="0" cellpadding="2" cellspacing="0" class="logistics">
<tr>
<td valign="top"><strong>Matt Planned Production Date<br>
<input name="mattbcwexpected" type="text" id="mattbcwexpected" value="<%=mattbcwexpected%>" size="10" onChange="calendarBlurHandler(mattbcwexpected)" readonly>
 <a href="javascript:clearmattbcwexpected();">X</a>  </strong></td>
</tr>
<tr>
<td valign="top"><strong>London Warehouse Received<br>
<input name="mattbcwwarehouse" type="text" id="mattbcwwarehouse" size="10" value="<%=mattbcwwarehouse%>"  onChange="clearmattbay(); checkMattMadeAt();" readonly>
 <a href="javascript:clearmattbcwwarehouse()">X</a>  </strong></td>
</tr>
<tr>
<td valign="top"><strong>Warehouse Location</strong>
<%Set rs3 = getMysqlUpdateRecordSet("Select * from bays WHERE bay_no <> 39 order by bay_no", con)%>
<select name="matbay" id="matbay" onChange="updateMattStatus();">
<option value="n"></option>
<%do until rs3.eof
%>  <option value="<%=rs3("bay_no")%>" <%=selected(rs3("bay_no"), matbay) %>><%=rs3("bay_name")%></option>
           
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select>
        </td>
    </tr>
    <tr>
      <td valign="top"><strong>Order Status:<br>
        <%Set rs3 = getMysqlUpdateRecordSet("Select * from QC_status where retiredCoreProducts='n' and mainstatusdropdowns='y'", con)%>
          <select name="mattressqc" id="mattressqc" onchange="resetExWorks('mattressqc', 'exworksdatematt'); checkProdDateCompleted(); defaultAreaProductionDates(); checkFinishedDateCompleted('<%=mattressstatus%>')" >
         
             <%do until rs3.eof
%>  <option value="<%=rs3("QC_statusid")%>" <%=selected(rs3("QC_statusid"), mattressstatus) %>><%=rs3("QC_status")%></option>

<%rs3.movenext
loop
rs3.close
set rs3=nothing%></select>
</strong></td>
</tr>
<%if mattressstatus >= 2 then%>
<tr>
<td valign="top"><strong>Confirmed Waiting to Check Date: </strong> <%response.Write(getComponentConfirmedDate(con, pn, 1))%>
</td>
</tr>
<%end if%>
<%if mattressstatus >= 20 then%>
<tr>
<td valign="top"><strong>Issued Date: </strong> <%=mattressIssuedDate%>
</td>
</tr>
<%end if%>
<tr>
<td valign="top"><strong>Delivery Date:<br>
<input name="mattdeldate" type="text" id="mattdeldate" size="10" value="<%=mattdeldate%>" readonly>
 <a href="javascript:clearmattdeldate();">X</a>  </strong></td>
</tr>
<%
currentexworksdate=""%>
<%if retrieveUserLocation()=1 or userHasRoleInList("ORDERDETAILS_VIEWER") then%>
<tr>
<td valign="top"><strong>Delivery Method:<br>
<%Set rs3 = getMysqlUpdateRecordSet("Select * from DeliveryMethod", con)%>
<select name="mattressdelmethod" id="mattressdelmethod" onchange="showHideExWorks('exworksmatt', 'mattressdelmethod', 'exworksdatematt');" >
<option value="">--</option>

<%do until rs3.eof
%>  <option value="<%=rs3("DeliveryMethodID")%>" <%=selected(rs3("DeliveryMethodID"), deliverymethodMatt) %>><%=rs3("DeliveryMethod")%></option>

<%rs3.movenext
loop
rs3.close
set rs3=nothing%></select>
</strong></td>
</tr>
<%end if%>
<tr id="exworksmatt">
<td valign="top">
Ex-Works Date
<%if retrieveUserLocation()=1  or retrieveUserLocation()=27 or userHasRoleInList("ORDERDETAILS_VIEWER") then
Set rs5 = getMysqlQueryRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation and transportmode<>'Adhoc Courier'", con)
else

Set rs5 = getMysqlQueryRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation and transportmode<>'Adhoc Courier' and C.idlocation=" & retrieveUserLocation(), con)
end if%>
<select id="exworksdatematt" name="exworksdatematt" tabindex="4" >

<%currentexworksdate2=""
currentexworksdate=""
isAdhoc=false
Set rs6 = getMysqlQueryRecordSet("Select * from exportlinks L, exportCollShowrooms S, exportcollections E where L.purchase_no=" & rs("purchase_no") & " and L.linksCollectionID=S.exportCollshowroomsID and E.exportCollectionsID=S.exportCollectionID AND L.componentID=1", con)
if not rs6.eof then
currentexworksdate2=rs6("CollectionDate")
currentexworksdate=rs6("linkscollectionid")
if rs6("transportmode")="Adhoc Courier" then isAdhoc=true
end if
rs6.close
set rs6=nothing%>
<%if currentexworksdate="" then%>
		<option value="n" selected>TBA</option>
        <option value="0">Ad-Hoc Courier Collection</option>
<%elseif isAdhoc then%>
		<option value="0">Ad-Hoc Courier Collection</option>
        
<%		currentexworksdate=""
else%>
<option value="<%=currentexworksdate%>" selected><%=currentexworksdate2%></option>
<option value="0">Ad-Hoc Courier Collection</option>
<%end if
Do until rs5.eof
			   optionselected = ""
			   if currentexworksdate<>"" then
 if CInt(currentexworksdate)=rs5("exportCollshowroomsID")  then optionselected = "selected"
 end if
%>
              <option value="<%=rs5("exportCollshowroomsID")%>" <%=optionselected%> ><%response.Write(rs5("adminheading") & ", " & rs5("CollectionDate"))%></option>             <%rs5.movenext
			 loop
			 rs5.close
			 set rs5=nothing%>
            </select></td>
       
    </tr>

<tr id="crateshow">

<td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<tr>
<td colspan="4" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr>
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID > 15 and shippingBoxID < 21)", con)%><select name="mattressCrateType" id="mattressCrateType" onChange="getChangedCrateSize('1','matt1_packwidth','matt1_packheight','matt1_packdepth','matt1_packkg','mattressCrateType','matt_crateqty'); getChangedCrateSize('1','matt2_packwidth','matt2_packheight','matt2_packdepth','matt2_packkg','mattressCrateType','matt_crateqty'); disablefield('mattressCrateType','matt1_packwidth','matt1_packheight','matt1_packdepth'); checkSpecialCrateQty('1','mattressCrateType','matt_crateqty','mattspecialcrate2');" >
 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), mattresscrate)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
 
  </select></td>
  </tr>
<tr><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr>
<td align="center"><label for="matt1_packwidth"></label>
<input name="matt1_packwidth" type="text" id="matt1_packwidth" size="3" maxlength="6" value="<%=matt1_packwidth%>" ></td>
<td align="center"><input name="matt1_packheight" type="text" id="matt1_packheight" size="3" maxlength="6" value="<%=matt1_packheight%>"></td>
<td align="center"><input name="matt1_packdepth" type="text" id="matt1_packdepth" size="3" maxlength="6" value="<%=matt1_packdepth%>"></td>
<td align="center"><input name="matt1_packkg" type="text" id="matt1_packkg" size="4" maxlength="6" value="<%=matt1_packkg%>">
</td>
</tr>
<!-- special crate no.2 -->
<tr class="mattspecialcrate2">
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID = 20)", con)%><select name="mattressCrateType2" id="mattressCrateType2" onChange="getChangedCrateSize('1','matt2_packwidth','matt2_packheight','matt2_packdepth','matt2_packkg','mattressCrateType2','matt_crateqty');" >
 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), mattresscrate2)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
  </select></td>
  </tr>
<tr class="mattspecialcrate2"><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr class="mattspecialcrate2">
<td align="center"><label for="matt2_packwidth"></label>
<input name="matt2_packwidth" type="text" id="matt2_packwidth" size="3" maxlength="6" value="<%=matt2_packwidth%>" ></td>
<td align="center"><input name="matt2_packheight" type="text" id="matt2_packheight" size="3" maxlength="6" value="<%=matt2_packheight%>"></td>
<td align="center"><input name="matt2_packdepth" type="text" id="matt2_packdepth" size="3" maxlength="6" value="<%=matt2_packdepth%>"></td>
<td align="center"><input name="matt2_packkg" type="text" id="matt2_packkg" size="4" maxlength="6" value="<%=matt2_packkg%>">
</td>
</tr>

<!-- special crate no.2 -->
<tr class="mattspecialcrate2">
<td align="center">L</td>
<td align="center">H</td>
<td align="center">W</td>
<td align="center">&nbsp;</td>
</tr>
<tr>
  <td height="29" colspan="4" align="center">Crate Qty: 
    <label for="matt_crateqty"></label>
    <select name="matt_crateqty" id="matt_crateqty" onChange="crateQtyChanged('1','matt1_packwidth','matt1_packheight','matt1_packdepth','matt1_packkg','mattressCrateType','matt_crateqty'); crateQtyChanged('1','matt2_packwidth','matt2_packheight','matt2_packdepth','matt2_packkg','mattressCrateType','matt_crateqty'); checkSpecialCrateQty('1','mattressCrateType','matt_crateqty','mattspecialcrate2');" >
      <option value="1" <%=selected(1, mattresscrateqty)%>>1</option>
      <option value="2" <%=selected(2, mattresscrateqty)%>>2</option>
    </select></td>
  </tr>
</table></td></tr>
<tr id="mattboxshow">
<td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<tr>
<td colspan="2" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr><td width="104" align="center" valign="top">
<%if matt1width="" then matt1width=rs("mattresswidth")
if matt1length="" then matt1length=rs("mattresslength")%>
<select name="matt1boxsize" id="matt1boxsize" onChange="getBoxWeight('1','<%=rs("savoirmodel")%>','matt1boxsize','<%=matt1width%>','<%=matt1length%>','matt1kg');" >
<option value="" <%=selected("", matt_box) %>> </option>
<option value="Small" <%=selected("Small", matt_box) %>>Small</option>
<option value="Medium" <%=selected("Medium", matt_box) %>>Medium</option>
<option value="Large" <%=selected("Large", matt_box) %>>Large</option>
</select></td>
<td width="74" align="center" valign="top"><input name="matt1kg" type="text" id="matt1kg" size="5" maxlength="6" value="<%=matt1kg%>">&nbsp;kg</td>
</tr>
<%if left(rs("mattresstype"),3)="Zip" then
%>
<tr><td width="104" align="center" valign="top">
<select name="matt2boxsize" id="matt2boxsize" onChange="getBoxWeight('1','<%=rs("savoirmodel")%>','matt2boxsize','<%=matt2width%>','<%=matt2length%>','matt2kg');">
<option value="" <%=selected("", matt2_box) %>></option>
<option value="Small" <%=selected("Small", matt2_box) %>>Small</option>
<option value="Medium" <%=selected("Medium", matt2_box) %>>Medium</option>
<option value="Large" <%=selected("Large", matt2_box) %>>Large</option>
</select></td>
<td width="74" align="center" valign="top"><input name="matt2kg" type="text" id="matt2kg" size="5" maxlength="6" value="<%=matt2kg%>">&nbsp;kg</td>
</tr>
<%end if%>

</table></td></tr>
<%if mattresstxtinc<>"" then response.Write("<tr id=""mattresstxtincshow""><td>" & mattresstxtinc & "</td></tr>")
if mattresstxtinc3<>"" then response.Write("<tr id=""mattresstxtinc3show""><td>" & mattresstxtinc3 & "</td></tr>")%>
</table>
</div>
<div class="clear"></div>
</div>
<%end if%>
</td>
  </tr>
  <tr><td><hr class="linewidth">
      <strong><%if rs("baserequired")="y" then response.write("Base Required") else response.Write("Base Not Required ")%></strong>
  Show
       <label>
       <input type="radio" name="baserequired" id="baserequired_y" value="y" <%=ischecked2(rs("baserequired")="y")%> onClick="javascript:baseChanged()" >
     </label>
     Hide
     <input name="baserequired" type="radio" id="baserequired_n" value="n" <%=ischecked2(rs("baserequired")="n")%> onClick="javascript:baseChanged()" >
        <br>
<br />
<%if rs("baserequired")="y" then%>
      <div id="base_div">
      <div id="base1">
        <table border="0" align="left" cellpadding="2" cellspacing="0">
 
    
  <tr>
    <td valign="top"><strong>Made At:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%Set rs3 = getMysqlUpdateRecordSet("Select * from ManufacturedAt WHERE manufacturertype='b'", con)%>
      <select name="basemadeat" id="basemadeat" onChange="javascript: defaultAreaProductionDates(); ">
        <option value="n">Not Allocated</option>
        <%do until rs3.eof
		
%>
        <option value="<%=rs3("manufacturedatid")%>" <%=selected(rs3("manufacturedatid"), basemadeat) %>><%=rs3("manufacturedat")%></option>
        <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%>
      </select></td>
    <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
  <%if rs("basesavoirmodel")="n" and  rs("basetype")="n" then
  else%>
  <tr>
  <%if rs("basesavoirmodel")="n" then%>
   <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
    <td valign="top"><strong>Model:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("basesavoirmodel")%></td>
    <%end if%>
     <%if rs("basetype")="n" then%>
      <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
    <td valign="top"><strong>Type:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("basetype")%></td>
     <%end if %>
     </tr>
   <%end if %>
    <%if rs("basetickingoptions")="n" or isNull(rs("basetickingoptions")) then
   else%> 
   <tr>
     <td valign="top"><b>Ticking:</b></td>
     <td valign="top" bgcolor="#FFFFFF"><%=rs("basetickingoptions")%>&nbsp;</td>
     <td valign="top">&nbsp;</td>
     <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
   </tr>
   <%end if%>
   <%if basewidth="n" and baselength="n" then
   else%>
  <tr>
    <td valign="top"><strong> Base <%if eastwest<>"n" or northsouth<>"n" then%>1&nbsp;<%end if%>Width:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=basewidth%></td>
    <td valign="top"><strong> Base <%if eastwest<>"n" or northsouth<>"n"  then%>1&nbsp;<%end if%>Length:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=baselength%></td>
    </tr>
    <%if base1width<>"" then%>
  <tr>
    <td valign="top"><%if base1width<>"" then %>
      <b>1 width cm</b>
      <%end if%></td>
    <td valign="top" bgcolor="#FFFFFF"><%if base1width<>"" then %>
      <%=formatnumber(base1width,2)%>
      <%end if%></td>
    <td valign="top"><%if base1length<>"" then %>
      <b>1 length cm</b>
      <%end if%></td>
    <td valign="top" bgcolor="#FFFFFF"><%if base1length<>"" then %>
      <%=formatnumber(base1length,2)%>
      <%end if%></td>
  </tr>
  <%end if%>
  
  <%if eastwest<>"n" or northsouth<>"n" then%> 
  <tr>
    <td valign="top"><strong> Base 2 Width:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=basewidth%></td>
    <td valign="top"><strong> Base 2 Length:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=baselength2%></td>
  </tr>
  <%end if%>
  <%if base2width<>"" then %>
  <tr>
    <td valign="top"><%if base2width<>"" then %>
      <b>2 width cm</b>
      <%end if%></td>
    <td valign="top" bgcolor="#FFFFFF"><%if base2width<>"" then %>
      <%=formatnumber(base2width,2)%>
      <%end if%></td>
    <td valign="top"><%if base2length<>"" then %>
      <b>2 length cm</b>
      <%end if%></td>
    <td valign="top" bgcolor="#FFFFFF"><%if base2length<>"" then %>
      <%=formatnumber(base2length,2)%>
      <%end if%></td>
  </tr>
  <%end if%>
  <%end if%>
  
  <%if rs("extbase")="no" AND isnull(rs("baseprice")) then
  else%>
  <tr>
  <%if rs("extbase")="no" then%>
  <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
    <td valign="top"><strong>Ext. Base:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("extbase")%>&nbsp;</td>
    <%end if%>
    <%if isnull(rs("baseprice")) then%>
    <%else%>
    <td valign="top"><strong>Base Price:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=getCurrencySymbolForCurrency(orderCurrency)%> <%=rs("baseprice")%> 
      </td>
      <%end if%> 
  </tr>
  <%end if%>
  <%if rs("basedrawers")="No" then
  else%>
  <tr>
    <td valign="top"><strong>Drawer Config.:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("basedrawerconfigid")%></td>
    <td valign="top"><strong>Drawer Height:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("basedrawerheight")%></td>
    </tr>
    <%end if%>
 
<tr>
<%if rs("linkfinish")="n" then%>

<%else%>
<td valign="top"><strong>Link Finish:</strong></td>
<td valign="top" bgcolor="#FFFFFF"><%=rs("linkfinish")%></td>
<%end if%>
<%if rs("linkposition")="n" then%>

<%else%>
<td valign="top"><strong>Link Position:</strong></td>
<td valign="top" bgcolor="#FFFFFF"><%=rs("linkposition")%></td>
<%end if%>
</tr>
<%if rs("baseheightspring")="n" then
else%>
<tr>
<td valign="top"><strong>Height/Spring:</strong></td>
<td valign="top" bgcolor="#FFFFFF"><%=rs("baseheightspring")%></td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
</tr>
<%end if%>
  <%if rs("baseinstructions")<>"" then%>
  <tr>
    <td colspan="4" valign="top" class="box"><strong>Instructions:</strong><br>
      <%=rs("baseinstructions")%></td>
    </tr>
    <%end if%>
  <tr>
    <td colspan="4" valign="top"><strong><br>
      Upholstered Base:</strong> <%=rs("upholsteredbase")
	  %>&nbsp;<br>      <br></td>
    </tr>
   <% If rs("upholsteredbase")="n" or rs("upholsteredbase")="No" or rs("upholsteredbase")="--" then
   else%>
  <tr>
    <td valign="top"><strong>Fabric Options</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("basefabric")%>&nbsp;</td>
    <td><strong>Fabric Selection:</strong></td>
    <td bgcolor="#FFFFFF"><%=rs("basefabricchoice")%>&nbsp;</td>
    </tr>
 
    <tr><td><strong>Base Fabric Direction</strong></td>
    <td bgcolor="#FFFFFF"><%=rs("basefabricdirection")%>
      &nbsp;</td>
    <td><strong>Upholstery</strong></td>
    <td bgcolor="#FFFFFF"><%=getCurrencySymbolForCurrency(orderCurrency)%> <%=rs("upholsteryprice")%> &nbsp;</td>
     
    </tr>

<%if rs("basefabricdesc")<>"" then%>
<tr>
<td colspan="4" class="box"><strong>Fabric Special Instructions&nbsp;</strong><br>
<%=rs("basefabricdesc")%>&nbsp;</td>
</tr>
<%end if%>
<%end if%>
<%if (rs("basetrim")<>"" or Not isNull(rs("basetrim"))) then%>
    <tr>
    <td><strong>Base Trim:</strong></td>
      <td bgcolor="#FFFFFF"><%=rs("basetrim")%></td>
      <td><strong>Base Trim Colour:</strong></td>
      <td bgcolor="#FFFFFF"><%=rs("basetrimcolour")%></td>
    </tr>
<%end if%>
</table>
</div>
<div id="base2">
<% If rs("upholsteredbase")="n" or rs("upholsteredbase")="No" or rs("upholsteredbase")="--" or isNull(rs("upholsteredbase")) then%>
<table width="200" border="0" cellpadding="2" cellspacing="0">
<tr>
<td>&nbsp;</td></tr></table>
<%else%>
<table width="200" border="0" cellpadding="2" cellspacing="0" class="fabric">
<tr>
<td><strong>Fabric Status<br>
<%Set rs3 = getMysqlUpdateRecordSet("Select * from fabricstatus where fabricstatusid=" & basefabricstatus, con)%>
<input name="basefabricstatus" type="text" value="<%=rs3("fabricstatus")%>" readonly>
<%rs3.close
set rs3=nothing%>
</strong></td>
</tr>
<tr>
<td><strong>Supplier<br>
<input type="text" name="basesupplier" id="basesupplier" value="<%=basesupplier%>">
</strong></td>
</tr>
<tr>
<td><strong>Purchase Order No.<br>
<input name="baseponumber" type="text" id="baseponumber" value="<%=baseponumber%>">
</strong></td>
</tr>
<tr>
<td><strong>Purchase Order Date<br>
<input name="basepodate" type="text" id="basepodate" size="10" value="<%=basepodate%>" readonly>
 <a href="javascript:clearbasepodate();">X</a>   </strong></td>
</tr>
<tr>
<td><strong>Expected Date<br>
<input name="basefabricexpecteddate" type="text" id="basefabricexpecteddate" value="<%=basefabricexpecteddate%>" size="10" readonly>
 <a href="javascript:clearbasefabricexpecteddate();">X</a>               </strong></td>
</tr>
<tr>
<td><strong>Received Date<br>
<input name="basefabricrecdate" type="text" id="basefabricrecdate" value="<%=basefabricrecdate%>" size="10" readonly>
 <a href="javascript:clearbasefabricrecdate();">X</a>              </strong></td>
</tr>
<tr>
<td><strong>Cutting Sent<br>
<input name="basecuttingsent" type="text" id="basecuttingsent" size="10" value="<%=basecuttingsent%>" readonly>
 <a href="javascript:clearbasecuttingsent();">X</a>              </strong></td>
</tr>
<tr>
<td><strong>FR Treating Sent<br>
<input name="basefrTreatingSent" type="text" id="basefrTreatingSent" size="10" value="<%=basefrTreatingSent%>" readonly>
 <a href="javascript:clearbasefrTreatingSent();">X</a></strong></td>
</tr>
<tr>
<td><strong>FR Treating Received<br>
<input name="basefrTreatingReceived" type="text" id="basefrTreatingReceived" size="10" value="<%=basefrTreatingReceived%>" readonly>
 <a href="javascript:clearbasefrTreatingReceived();">X</a></strong></td>
</tr>
<tr>
<td><strong>Confirmed Date<br>
<input name="baseconfirmeddate" type="text" id="baseconfirmeddate" size="10" value="<%=baseconfirmeddate%>" readonly>
 <a href="javascript:clearbaseconfirmeddate();">X</a>               </strong></td>
</tr>
<tr>
<td><strong>Date to Savoir Cardiff<br>
<input name="basetobcwdate" type="text" id="basetobcwdate" size="10" value="<%=basetobcwdate%>" readonly>
 <a href="javascript:clearbasetobcwdate();">X</a>              </strong></td>
</tr>
<tr>
<td><strong>Fabric Price</strong>&nbsp;
<%=getCurrencySymbolForCurrency(orderCurrency)%><%=rs("basefabriccost")%>
per mtr</td>
</tr>
<td><strong>Fabric Total Price </strong>
<%=getCurrencySymbolForCurrency(orderCurrency)%><%=rs("basefabricprice")%>
</td>
<tr>
<td><strong>Qty</strong>&nbsp;
<%=rs("basefabricmeters")%>
</td>
</tr>
</table>
<%end if%>
</div>
<div id="base3">
<table width="200" border="0" cellpadding="2" cellspacing="0" class="prod">
<tr>
<td valign="top">
<strong>Box Case Cut</strong>
<br>
<input name="boxcut" type="text" id="boxcut" value="<%=boxcut%>" size="10" readonly>
 <a href="javascript:clearboxcut();">X</a> </td>
</tr>
<tr>
<td valign="top">
<strong>Box Case Machined</strong>
<br>
<input name="boxmachined" type="text" id="boxmachined" value="<%=boxmachined%>" size="10" readonly>
 <a href="javascript:clearboxmachined();">X</a></td>
</tr>
<tr>
<td valign="top"><strong>Box Frame Made</strong>
<br>
<input name="boxframe" type="text" id="boxframe" value="<%=boxframe%>" size="10" readonly>
 <a href="javascript:clearboxframe();">X</a>

</td>
</tr>
<tr>
<td valign="top"><strong>Base Prepped</strong><br>
<input name="baseprepped" type="text" id="baseprepped" value="<%=baseprepped%>" size="10" readonly>
 <a href="javascript:clearbaseprepped();">X</a>
</td>
</tr>
<tr>
<td valign="top"><strong>Box Ticking Used</strong>
<label for="boxtickingbatchno"></label>
<input name="boxtickingbatchno" type="text" id="boxtickingbatchno" value="<%=boxtickingbatchno%>" size="20"></td>
</tr>
<tr>
<td valign="top"><strong>Made By:<br>
<%if basemadeat<>"" and basemadeat<>"n" then
sql="Select * from  manufacturedat M, savoir_user U WHERE U.madeby='y' and M.manufacturedatid=" & basemadeat & " and U.id_location = M.id_location and  U.retired='n' order by U.name asc"
else
sql="Select * from  manufacturedat M, savoir_user U WHERE U.madeby='y' and U.id_location = M.id_location and  U.retired='n' order by U.name asc"
end if
Set rs3 = getMysqlUpdateRecordSet(sql, con)%>
<select name="basemadeby" id="basemadeby">
<option value="n"></option>
<%do until rs3.eof
%>
<option value="<%=rs3("user_id")%>" <%=selected(rs3("user_id"), basemadeby) %>><%=rs3("name")%></option>
<%rs3.movenext
loop
rs3.close
set rs3=nothing%>
</select>
</strong></td>
</tr>
<%if jobflagBase<>"" then%>
<tr>
<td valign="top"><strong>Job Flag: </strong><%=jobflagBase%></td>
</tr>
<%end if%>
<tr>
<td valign="top"><strong>Finished:<br>
<input name="basefinished" type="text" id="basefinished" size="10" value="<%=basefinished%>" onChange="calendarBlurHandler(basefinished); checkBaseFinishedStatus();" readonly>
 <a href="javascript:clearbasefinished(); checkBaseFinishedDateCompleted(null)">X</a></strong></td>
</tr>
</table>
</div>
<div id="base4">
<table width="200" border="0" cellpadding="2" cellspacing="0" class="logistics">
<tr>
<td valign="top"><strong>Base Planned Production Date<br>
<input name="basebcwexpected" type="text" id="basebcwexpected" value="<%=basebcwexpected%>" size="10" onChange="calendarBlurHandler(basebcwexpected)" readonly>
 <a href="javascript:clearbasebcwexpected();">X</a></strong></td>
</tr>
<tr>
<td valign="top"><strong>London Warehouse Received<br>
<input name="basebcwwarehouse" type="text" id="basebcwwarehouse" size="10"  value="<%=basebcwwarehouse%>"  onChange="clearbasebay(); checkBaseMadeAt();" readonly>
 <a href="javascript:clearbasebcwwarehouse();">X</a></strong></td>
</tr>
<tr>
<td valign="top"><strong>Warehouse Location</strong>
<%Set rs3 = getMysqlUpdateRecordSet("Select * from bays WHERE bay_no <> 39 order by bay_no", con)%>
<select name="basebay" id="basebay" onChange="updateBaseStatus();">
<option value="n"></option>
<%do until rs3.eof
%>  <option value="<%=rs3("bay_no")%>" <%=selected(rs3("bay_no"), basebay) %>><%=rs3("bay_name")%></option>
           
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select></td>
            </tr>
            <tr>
              <td valign="top"><strong>Order Status:<br>
                 <%Set rs3 = getMysqlUpdateRecordSet("Select * from QC_status where retiredCoreProducts='n' and  mainstatusdropdowns='y'", con)%>
          <select name="baseqc" id="baseqc" onchange="resetExWorks('baseqc', 'exworksdatebase'); checkBaseProdDateCompleted(); defaultAreaProductionDates(); checkBaseFinishedDateCompleted('<%=basestatus%>')" >" >
          
             <%do until rs3.eof
%>  <option value="<%=rs3("QC_statusid")%>" <%=selected(rs3("QC_statusid"), basestatus) %>><%=rs3("QC_status")%></option>

<%rs3.movenext
loop
rs3.close
set rs3=nothing%></select>
</strong></td>
</tr>
<%if basestatus >= 2 then%>
<tr>
<td valign="top"><strong>Confirmed Waiting to Check Date: </strong> <%response.Write(getComponentConfirmedDate(con, pn, 3))%>
</td>
</tr>
<%end if%>
<%if basestatus >= 20 then%>
<tr>
<td valign="top"><strong>Issued Date: </strong> <%=baseIssuedDate%>
</td>
</tr>
<%end if%>
<tr>
<td valign="top"><strong>Delivery Date:<br>
<input name="basedeldate" type="text" id="basedeldate" value="<%=basedeldate%>" size="10" readonly>
 <a href="javascript:clearbasedeldate();">X</a></strong></td>
</tr>
<%
currentexworksdate=""%>
<%if retrieveUserLocation()=1 or userHasRoleInList("ORDERDETAILS_VIEWER") then%>
<tr>
<td valign="top"><strong>Delivery Method:<br>
<%Set rs3 = getMysqlUpdateRecordSet("Select * from DeliveryMethod", con)%>
<select name="basedelmethod" id="basedelmethod" onchange="showHideExWorks('exworksbase', 'basedelmethod', 'exworksdatebase');">
<option value="">--</option>
<%do until rs3.eof
%>  <option value="<%=rs3("DeliveryMethodID")%>" <%=selected(rs3("DeliveryMethodID"), deliverymethodBase) %>><%=rs3("DeliveryMethod")%></option>
           
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select>
        </strong></td>
      </tr>
      <%end if%>
              <tr id="exworksbase">
      <td valign="top">
      Ex-Works Date
            <%if retrieveUserLocation()=1  or retrieveUserLocation()=27 or userHasRoleInList("ORDERDETAILS_VIEWER") then
			Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation", con)
			else
			
			Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation and C.idlocation=" & retrieveUserLocation(), con)
			end if%>
           <select id="exworksdatebase" name="exworksdatebase" tabindex="4">
            
              <%currentexworksdate2=""
			   currentexworksdate=""
			  Set rs6 = getMysqlUpdateRecordSet("Select * from exportlinks L, exportCollShowrooms S, exportcollections E where L.purchase_no=" & rs("purchase_no") & " and L.linksCollectionID=S.exportCollshowroomsID and E.exportCollectionsID=S.exportCollectionID AND L.componentID=3", con)
			    if not rs6.eof then
			   currentexworksdate2=rs6("CollectionDate")
currentexworksdate=rs6("linkscollectionid")
			   end if
			rs6.close
			set rs6=nothing%>
	
<%if currentexworksdate="" then%>
		<option value="n" selected>TBA</option>
<%else%>
<option value="<%=currentexworksdate%>" selected><%=currentexworksdate2%></option>
<%end if
			  
			  Do until rs5.eof
			   optionselected = "" 
			  			   if currentexworksdate<>"" then
 if CInt(currentexworksdate)=rs5("exportCollshowroomsID")  then optionselected = "selected"
 end if

%>
<option value="<%=rs5("exportCollshowroomsID")%>" <%=optionselected%>><%response.Write(rs5("adminheading") & ", " & rs5("CollectionDate"))%></option><%rs5.movenext
loop
rs5.close
set rs5=nothing%>
</select></td>

</tr>

<tr id="basecrateshow">
<td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<tr>
<td colspan="4" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr>
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID > 15 and shippingBoxID < 21)", con)%><select name="baseCrateType" id="baseCrateType" onChange="getChangedCrateSize('3','base1_packwidth','base1_packheight','base1_packdepth','base1_packkg','baseCrateType','base_crateqty'); getChangedCrateSize('3','base2_packwidth','base2_packheight','base2_packdepth','base2_packkg','baseCrateType','base_crateqty'); disablefield('baseCrateType','base1_packwidth','base1_packheight','base1_packdepth'); checkSpecialCrateQty('3','baseCrateType','base_crateqty','basespecialcrate2');" >
 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), basecrate)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
  </select></td>
</tr>
<tr><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr>
<td align="center"><label for="base1_packwidth"></label>
<input name="base1_packwidth" type="text" id="base1_packwidth" size="3" maxlength="6" value="<%=base1_packwidth%>"></td>
<td align="center"><input name="base1_packheight" type="text" id="base1_packheight" size="3" maxlength="6" value="<%=base1_packheight%>"></td>
<td align="center"><input name="base1_packdepth" type="text" id="base1_packdepth" size="3" maxlength="6" value="<%=base1_packdepth%>"></td>
<td align="center"><input name="base1_packkg" type="text" id="base1_packkg" size="4" maxlength="6" value="<%=base1_packkg%>"></td>
</tr>
<tr>
<td align="center">L</td>
<td align="center">H</td>
<td align="center">W</td>
<td align="center">&nbsp;</td>
</tr>


<!-- special crate no.2 -->
<tr class="basespecialcrate2">
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID = 20)", con)%><select name="baseCrateType2" id="baseCrateType2" onChange="getChangedCrateSize('3','base2_packwidth','base2_packheight','base2_packdepth','base2_packkg','baseCrateType2','base_crateqty');" >
 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), basecrate2)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
  </select></td>
  </tr>
<tr class="basespecialcrate2"><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr class="basespecialcrate2">
<td align="center"><label for="base2_packwidth"></label>
<input name="base2_packwidth" type="text" id="base2_packwidth" size="3" maxlength="6" value="<%=base2_packwidth%>" ></td>
<td align="center"><input name="base2_packheight" type="text" id="base2_packheight" size="3" maxlength="6" value="<%=base2_packheight%>"></td>
<td align="center"><input name="base2_packdepth" type="text" id="base2_packdepth" size="3" maxlength="6" value="<%=base2_packdepth%>"></td>
<td align="center"><input name="base2_packkg" type="text" id="base2_packkg" size="4" maxlength="6" value="<%=base2_packkg%>">
</td>
</tr>

<!-- special crate no.2 -->
<tr class="basespecialcrate2">
<td align="center">L</td>
<td align="center">H</td>
<td align="center">W</td>
<td align="center">&nbsp;</td>
</tr>

<tr>
  <td colspan="4" align="center">Crate Qty:
    <label for="base_crateqty"></label>
    <select name="base_crateqty" id="base_crateqty" onChange="crateQtyChanged('3','base1_packwidth','base1_packheight','base1_packdepth','base1_packkg','baseCrateType','base_crateqty'); crateQtyChanged('3','base2_packwidth','base2_packheight','base2_packdepth','base2_packkg','baseCrateType','base_crateqty'); checkSpecialCrateQty('3','baseCrateType','base_crateqty','basespecialcrate2');" >
      <option value="1" <%=selected(1, basecrateqty)%>>1</option>
      <option value="2" <%=selected(2, basecrateqty)%>>2</option>
    </select></td>
  </tr>

</table></td></tr>
<tr id="baseboxshow">
<td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<tr>
<td colspan="2" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr><td width="104" align="center" valign="top">
<%if base1width="" then base1width=rs("basewidth")
if base1length="" then base1length=rs("baselength")%>
<select name="base1boxsize" id="base1boxsize" onChange="getBoxWeight('3','<%=rs("basesavoirmodel")%>','base1boxsize','<%=base1width%>','<%=base1length%>','base1kg');" >
<option value="" <%=selected("", base_box) %>> </option>
<option value="Small" <%=selected("Small", base_box) %>>Small</option>
<option value="Medium" <%=selected("Medium", base_box) %>>Medium</option>
<option value="Large" <%=selected("Large", base_box) %>>Large</option>
</select></td>
<td width="74" align="center" valign="top"><input name="base1kg" type="text" id="base1kg" size="5" maxlength="6" value="<%=base1kg%>">&nbsp;kg</td>
</tr>
<%if left(rs("basetype"),3)="Eas" or left(rs("basetype"),3)="Nor" then%>
<tr><td width="104" align="center" valign="top">
<select name="base2boxsize" id="base2boxsize" onChange="getBoxWeight('3','<%=rs("basesavoirmodel")%>','base2boxsize','<%=base2width%>','<%=base2length%>','base2kg');" >
<option value="" <%=selected("", base2_box) %>></option>
<option value="Small" <%=selected("Small", base2_box) %>>Small</option>
<option value="Medium" <%=selected("Medium", base2_box) %>>Medium</option>
<option value="Large" <%=selected("Large", base2_box) %>>Large</option>
</select></td>
<td width="74" align="center" valign="top"><input name="base2kg" type="text" id="base2kg" size="5" maxlength="6" value="<%=base2kg%>">&nbsp;kg</td>
</tr>
<%end if%>

</table></td></tr>
<%if basetxtinc<>"" then response.Write("<tr id=""basetxtincshow""><td>" & basetxtinc & "</td></tr>")
if basetxtinc3<>"" then response.Write("<tr id=""basetxtinc3show""><td>" & basetxtinc3 & "</td></tr>")%>
</table>
</div>
<div class="clear"></div>
</div>
<%end if%>
</td>
  </tr>
  <tr><td><hr class="linewidth">
    <strong><%if rs("topperrequired")="y" then response.write("Topper Required") else response.Write("Topper Not Required ")%></strong></span>&nbsp;
     Show
     <label>
       <input type="radio" name="topperrequired" id="topperrequired_y" value="y" <%=ischecked2(rs("topperrequired")="y")%> onClick="javascript:topperChanged()" >
     </label>
     Hide
       <input type="radio" name="topperrequired" id="topperrequired_n" value="n" <%=ischecked2(rs("topperrequired")="n")%> onClick="javascript:topperChanged()" >
       <br>
       <br>
  <%if rs("topperrequired")="y" then%> 
   <div id="topper_div">
   <div id="topp1">
     <table width="400" border="0" align="left" cellpadding="2" cellspacing="0">
 
    
  <tr>
    <td valign="top"><strong>Made At:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%Set rs3 = getMysqlUpdateRecordSet("Select * from ManufacturedAt WHERE manufacturertype='b'", con)%>
      <select name="toppermadeat" id="toppermadeat" onChange="javascript: defaultAreaProductionDates(); ">
        <option value="n">Not Allocated</option>
        <%do until rs3.eof
			
%>
        <option value="<%=rs3("manufacturedatid")%>" <%=selected(rs3("manufacturedatid"), toppermadeatid) %>><%=rs3("manufacturedat")%></option>
        <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%>
      </select>
      &nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
  
  <tr>
  <%if rs("toppertype")="n" or isnull(rs("toppertype")) then %>
      <td width="97" valign="top">&nbsp;</td>
    <td width="195" valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
    <td width="97" valign="top"><strong>Type:</strong></td>
    <td width="195" valign="top" bgcolor="#FFFFFF"><%=rs("toppertype")%></td>
    <%end if%>
     <%if rs("toppertickingoptions")="n" or isnull(rs("toppertickingoptions")) then %>
      <td width="97" valign="top">&nbsp;</td>
    <td width="195" valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
    <td width="321" valign="top"><strong>Ticking:</strong></td>
    <td width="321" valign="top" bgcolor="#FFFFFF"><%=rs("toppertickingoptions")%></td>
    <%end if%>
  </tr>
  <%if rs("topperwidth")="n" or isnull(rs("topperwidth")) or rs("topperlength")="n" or isnull(rs("topperlength")) then %>
  <%else%>
  <tr>
    <td valign="top"><strong> Width:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("topperwidth")%></td>
    <td valign="top"><strong> Length:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("topperlength")%></td>
    </tr>
   
  <tr>
    <td valign="top"><%if topper1width<>"" then %>
      <b>1 width cm</b>
      <%end if%></td>
    <td valign="top" bgcolor="#FFFFFF"><%if topper1width<>"" then %>
      <input name="topper1width" type="text" value="<%=formatnumber(topper1width,2)%>" size="7">
      <%end if%></td>
    <td valign="top"><%if topper1length<>"" then %>
      <b>1 length cm</b>
      <%end if%></td>
    <td valign="top" bgcolor="#FFFFFF"><%if topper1length<>"" then %>
      <input name="topper1length" type="text" value="<%=formatnumber(topper1length,2)%>" size="7">
      <%end if%></td>
  </tr>
   <%end if%>
   <%if rs("topperprice")="" or isnull(rs("topperprice")) then
   else%>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
    <td valign="top"><strong>Price:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=getCurrencySymbolForCurrency(orderCurrency)%>
     <%=rs("topperprice")%></td>
    </tr>
    <%end if%>
    <%if rs("specialinstructionstopper")<>"" Then%>
  <tr>
    <td colspan="4" valign="top" class="box"><strong>Instructions:</strong><br>
      <%=rs("specialinstructionstopper")%></td>
  </tr>
  <%end if%>
  
  
</table>
</div>
<div id="topp2">
<table width="200" border="0" cellpadding="0" cellspacing="0">
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
</table>
</div>
<div id="topp3">

<table width="200" border="0" cellpadding="2" cellspacing="0" class="prod">
<tr>
<td valign="top">
<strong>Topper Case Cut</strong>
<br>
<input name="toppercut" type="text" id="toppercut" value="<%=toppercut%>" size="10" readonly>
 <a href="javascript:cleartoppercut();">X</a> </td>
</tr>
<tr>
<td valign="top">
<strong>Topper Case Machined</strong>
<br>
<input name="toppermachined" type="text" id="toppermachined" value="<%=toppermachined%>" size="10" readonly>
 <a href="javascript:cleartoppermachined();">X</a> </td>
</tr>
<tr>
<td valign="top"><strong>Topper Ticking Used</strong>
<label for="toppertickingbatchno"></label>
<input type="text" name="toppertickingbatchno" id="toppertickingbatchno" value="<%=toppertickingbatchno%>"></td>
</tr>
<tr>
<td valign="top"><strong>Made By:<br>
<%if toppermadeatid<>"" and toppermadeatid<>"n" then
sql="Select * from  manufacturedat M, savoir_user U WHERE U.madeby='y' and M.manufacturedatid=" & toppermadeatid & " and U.id_location = M.id_location and  U.retired='n' order by U.name asc"
else
sql="Select * from  manufacturedat M, savoir_user U WHERE U.madeby='y' and U.id_location = M.id_location and  U.retired='n' order by U.name asc"
end if
Set rs3 = getMysqlUpdateRecordSet(sql, con)%>
<select name="toppermadeby" id="toppermadeby">
<option value="n"></option>
<%do until rs3.eof
%>
<option value="<%=rs3("user_id")%>" <%=selected(rs3("user_id"), toppermadeby) %>><%=rs3("name")%></option>
<%rs3.movenext
loop
rs3.close
set rs3=nothing%>
</select>
</strong></td>
</tr>
<%if jobflagTopper<>"" then%>
<tr>
<td valign="top"><strong>Job Flag: </strong><%=jobflagTopper%></td>
</tr>
<%end if%>
<tr>
<td valign="top"><strong>Finished:<br>
<input name="topperfinished" type="text" id="topperfinished" size="10" value="<%=topperfinished%>" onChange="calendarBlurHandler(topperfinished); checkTopperFinishedStatus();" readonly>
 <a href="javascript:cleartopperfinished();checkTopperFinishedDateCompleted(null)">X</a></strong></td>
</tr>
</table>

</div>
<div id="topp4">
<table width="200" border="0" cellpadding="2" cellspacing="0" class="logistics">
<tr>
<td valign="top"><strong>Topper Planned Production Date<br>
<input name="topperbcwexpected" type="text" id="topperbcwexpected" size="10" value="<%=topperbcwexpected%>" onChange="calendarBlurHandler(topperbcwexpected)" readonly>
 <a href="javascript:cleartopperbcwexpected();">X</a></strong></td>
</tr>
<tr>
<td valign="top"><strong>London Warehouse Received<br>
<input name="topperbcwwarehouse" type="text" id="topperbcwwarehouse" size="10"  onChange="cleartopperbay(); checkTopperMadeAt();" value="<%=topperbcwwarehouse%>" readonly>
 <a href="javascript:cleartopperbcwwarehouse();">X</a></strong></td>
</tr>
<tr>
<td valign="top"><strong>Warehouse Location</strong>

<%Set rs3 = getMysqlUpdateRecordSet("Select * from bays WHERE bay_no <> 39 order by bay_no", con)%>
<select name="topperbay" id="topperbay" onChange="updateTopperStatus();">
<option value="n"></option>
<%do until rs3.eof
%>  <option value="<%=rs3("bay_no")%>" <%=selected(rs3("bay_no"), topperbay) %>><%=rs3("bay_name")%></option>
           
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select></td>
      </tr>
      <tr>
        <td valign="top"><strong>Order Status:<br>
           <%Set rs3 = getMysqlUpdateRecordSet("Select * from QC_status where retiredCoreProducts='n' and mainstatusdropdowns='y'", con)%>
          <select name="topperstatus" id="topperstatus" onchange="resetExWorks('topperstatus', 'exworksdatetopper'); checkTopperProdDateCompleted(); defaultAreaProductionDates(); checkTopperFinishedDateCompleted('<%=topperstatus%>')" >
        
             <%do until rs3.eof
%>  <option value="<%=rs3("QC_statusid")%>" <%=selected(rs3("QC_statusid"), topperstatus) %>><%=rs3("QC_status")%></option>

<%rs3.movenext
loop
rs3.close
set rs3=nothing%></select>
</strong></td>
</tr>
<%if topperstatus >= 2 then%>
<tr>
<td valign="top"><strong>Confirmed Waiting to Check Date: </strong> <%response.Write(getComponentConfirmedDate(con, pn, 5))%>
</td>
</tr>
<%end if%>
<%if topperstatus >= 20 then%>
<tr>
<td valign="top"><strong>Issued Date: </strong> <%=topperIssuedDate%>
</td>
</tr>
<%end if%>
<tr>
<td valign="top"><strong>Delivery Date:<br>
<input name="topperdeldate" type="text" id="topperdeldate" size="10" value="<%=topperdeldate%>" readonly>
 <a href="javascript:cleartopperdeldate();">X</a></strong></td>
</tr>
<%
currentexworksdate=""%>
<%if retrieveUserLocation()=1 or userHasRoleInList("ORDERDETAILS_VIEWER") then%>
<tr>
<td valign="top"><strong>Delivery Method:<br>
<%Set rs3 = getMysqlUpdateRecordSet("Select * from DeliveryMethod", con)%>
<select name="topperdelmethod" id="topperdelmethod" onchange="showHideExWorks('exworkstopper', 'topperdelmethod', 'exworksdatetopper');">
<option value="">--</option>
<%do until rs3.eof
%>  <option value="<%=rs3("DeliveryMethodID")%>" <%=selected(rs3("DeliveryMethodID"), deliverymethodtopper) %>><%=rs3("DeliveryMethod")%></option>
           
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select>
        </strong></td>
      </tr>
      <%end if%>
               <tr id="exworkstopper">
      <td valign="top">
      Ex-Works Date
      <%if retrieveUserLocation()=1  or retrieveUserLocation()=27 or userHasRoleInList("ORDERDETAILS_VIEWER") then
			Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation", con)
			else
			
			Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation and C.idlocation=" & retrieveUserLocation(), con)
			end if%>
           <select id="exworksdatetopper" name="exworksdatetopper" tabindex="4">
            
              <%currentexworksdate2=""
			   currentexworksdate=""
			  Set rs6 = getMysqlUpdateRecordSet("Select * from exportlinks L, exportCollShowrooms S, exportcollections E where L.purchase_no=" & rs("purchase_no") & " and L.linksCollectionID=S.exportCollshowroomsID and E.exportCollectionsID=S.exportCollectionID AND L.componentID=5", con)
			   if not rs6.eof then
			   currentexworksdate2=rs6("CollectionDate")
currentexworksdate=rs6("linkscollectionid")
			   end if
			rs6.close
			set rs6=nothing%>
		
<%if currentexworksdate="" then%>
		<option value="n" selected>TBA</option>
<%else%>
<option value="<%=currentexworksdate%>" selected><%=currentexworksdate2%></option>
<%end if
			  
			  Do until rs5.eof
			   optionselected = ""
			  			   if currentexworksdate<>"" then
 if CInt(currentexworksdate)=rs5("exportCollshowroomsID")  then optionselected = "selected"
 end if

%>
<option value="<%=rs5("exportCollshowroomsID")%>" <%=optionselected%>><%response.Write(rs5("adminheading") & ", " & rs5("CollectionDate"))%></option>
<%rs5.movenext
loop
rs5.close
set rs5=nothing%>
</select></td>

</tr>
<%if toppertxtinc<>"" then response.Write("<tr id=""toppertxtincshow""><td>" & toppertxtinc & "</td></tr>")
if toppertxtinc3<>"" then response.Write("<tr id=""toppertxtinc3show""><td>" & toppertxtinc3 & "</td></tr>")
%>
<tr id="toppercrateshow">
<td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<tr>
<td colspan="4" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr>
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID > 15 and shippingBoxID < 21)", con)%><select name="topperCrateType" id="topperCrateType" onChange="getChangedCrateSize('5','topper1_packwidth','topper1_packheight','topper1_packdepth','topper1_packkg','topperCrateType','topper_crateqty'); getChangedCrateSize('5','topper2_packwidth','topper2_packheight','topper2_packdepth','topper2_packkg','topperCrateType','topper_crateqty'); disablefield('topperCrateType','topper1_packwidth','topper1_packheight','topper1_packdepth'); checkSpecialCrateQty('5','topperCrateType','topper_crateqty','topperspecialcrate2');" >
 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), toppercrate)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
  </select></td>
</tr>
<tr><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr>
<td align="center"><label for="topper1_packwidth"></label>
<input name="topper1_packwidth" type="text" id="topper1_packwidth" size="3" maxlength="6" value="<%=topper1_packwidth%>"></td>
<td align="center"><input name="topper1_packheight" type="text" id="topper1_packheight" size="3" maxlength="6" value="<%=topper1_packheight%>"></td>
<td align="center"><input name="topper1_packdepth" type="text" id="topper1_packdepth" size="3" maxlength="6" value="<%=topper1_packdepth%>"></td>
<td align="center"><input name="topper1_packkg" type="text" id="topper1_packkg" size="4" maxlength="6" value="<%=topper1_packkg%>"></td>
</tr>
<tr>
<td align="center">L</td>
<td align="center">H</td>
<td align="center">W</td>
<td align="center">&nbsp;</td>
</tr>
<!-- special crate no.2 -->
<tr class="topperspecialcrate2">
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID = 20)", con)%><select name="topperCrateType2" id="topperCrateType2" onChange="getChangedCrateSize('5','topper2_packwidth','topper2_packheight','topper2_packdepth','topper2_packkg','topperCrateType2','topper_crateqty');" >
 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), toppercrate2)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
  </select></td>
  </tr>
<tr class="topperspecialcrate2"><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr class="topperspecialcrate2">
<td align="center"><label for="topper2_packwidth"></label>
<input name="topper2_packwidth" type="text" id="topper2_packwidth" size="3" maxlength="6" value="<%=topper2_packwidth%>" ></td>
<td align="center"><input name="topper2_packheight" type="text" id="topper2_packheight" size="3" maxlength="6" value="<%=topper2_packheight%>"></td>
<td align="center"><input name="topper2_packdepth" type="text" id="topper2_packdepth" size="3" maxlength="6" value="<%=topper2_packdepth%>"></td>
<td align="center"><input name="topper2_packkg" type="text" id="topper2_packkg" size="4" maxlength="6" value="<%=topper2_packkg%>">
</td>
</tr>

<!-- special crate no.2 -->
<tr class="topperspecialcrate2">
<td align="center">L</td>
<td align="center">H</td>
<td align="center">W</td>
<td align="center">&nbsp;</td>
</tr>
<tr>
  <td colspan="4" align="center">Crate Qty: 
    <label for="topper_crateqty"></label>
    <select name="topper_crateqty" id="topper_crateqty" onChange="crateQtyChanged('5','topper1_packwidth','topper1_packheight','topper1_packdepth','topper1_packkg','topperCrateType','topper_crateqty'); crateQtyChanged('5','topper2_packwidth','topper2_packheight','topper2_packdepth','topper2_packkg','topperCrateType','topper_crateqty'); checkSpecialCrateQty('5','topperCrateType','topper_crateqty','topperspecialcrate2');" >
      <option value="1" <%=selected(1, toppercrateqty)%>>1</option>
      <option value="2" <%=selected(2, toppercrateqty)%>>2</option>
    </select></td>
  </tr>
</table></td></tr>

<tr id="topperboxshow">
<td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<tr>
<td colspan="2" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr><td width="104" align="center" valign="top">
<%if topper1width="" then topper1width=rs("topperwidth")
if topper1length="" then topper1length=rs("topperlength")%>
<select name="topper1boxsize" id="topper1boxsize" onChange="getBoxWeight('5','<%=rs("toppertype")%>','topper1boxsize','<%=topper1width%>','<%=topper1length%>','topper1kg');">
<option value="" <%=selected("", topper_box) %>> </option>
<option value="Small" <%=selected("Small", topper_box) %>>Small</option>
<option value="Medium" <%=selected("Medium", topper_box) %>>Medium</option>
<option value="Large" <%=selected("Large", topper_box) %>>Large</option>
</select></td>
<td width="74" align="center" valign="top"><input name="topper1kg" type="text" id="topper1kg" size="5" maxlength="6" value="<%=topper1kg%>">&nbsp;kg</td>
</tr>
</table></td></tr>
<%if toppertxt<>"" then response.Write("<tr id=""toppertxtshow""><td>" & toppertxt & "</td></tr>")%>
</table>
</div>
</div>
<%end if%>
</td>
</tr>

<tr><td><hr class="linewidth">
<strong><%if rs("headboardrequired")="y" then response.write("Headboard Required") else response.Write("Headboard Not Required ")%></span>&nbsp;</strong>
Show
       <label>
       <input type="radio" name="headboardrequired" id="headboardrequired_y" value="y" <%=ischecked2(rs("headboardrequired")="y")%> onClick="javascript:headboardChanged()" >
     </label>
     Hide
     <input name="headboardrequired" type="radio" id="headboardrequired_n" value="n" <%=ischecked2(rs("headboardrequired")="n")%> onClick="javascript:headboardChanged()" >
   <br>
   <br>
   <%if rs("headboardrequired")="y" then%>
   <div id="headboard_div">
   <div id="head1">
     <table width="400" border="0" align="left" cellpadding="2" cellspacing="0">
 
    
  <tr>
    <td valign="top"><strong>Made At:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%Set rs3 = getMysqlUpdateRecordSet("Select * from ManufacturedAt WHERE manufacturertype='b'", con)%>
      <select name="headboardmadeat" id="headboardmadeat" onChange="javascript: defaultAreaProductionDates(); ">
        <option value="n">Not Allocated</option>
        <%do until rs3.eof
			
%>
        <option value="<%=rs3("manufacturedatid")%>" <%=selected(rs3("manufacturedatid"), headboardmadeatid) %>><%=rs3("manufacturedat")%></option>
        <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%>
      </select>
  &nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  </tr>
   <%if rs("headboardstyle")="n" or isNull(rs("headboardstyle")) or  rs("headboardfinish")="n" or isNull(rs("headboardfinish"))  then
   else%>
  <tr>
  <%if rs("headboardstyle")="n" or isNull(rs("headboardstyle")) then%>
   <td width="97" valign="top">&nbsp;</td>
    <td width="195" valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
    <td width="97" valign="top"><strong>Styles:</strong></td>
    <td width="195" valign="top" bgcolor="#FFFFFF"><%=rs("headboardstyle")%>
		 	</td>
     <%end if%>
     <%if rs("headboardfinish")="n" or isNull(rs("headboardfinish")) then%>
   <td width="97" valign="top">&nbsp;</td>
    <td width="195" valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
    <td width="321" valign="top"><strong>Headboard Finish:</strong></td>
    <td width="321" valign="top" bgcolor="#FFFFFF"><%=rs("headboardfinish")%></td>
    <%end if%>
  </tr>
  <%end if%>
   <%if rs("headboardheight")="n" or isNull(rs("headboardheight")) or rs("manhattantrim")="n" or isNull(rs("manhattantrim")) then
   else%>
  <tr>
     <%if rs("headboardheight")="n" or isNull(rs("headboardheight")) then%>
   <td width="97" valign="top">&nbsp;</td>
    <td width="195" valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
    <td valign="top"><strong>Headboard Height:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("headboardheight")%>
            </td>
     <%end if%>
       <%if rs("manhattantrim")="n" or isNull(rs("manhattantrim")) then%>
   <td width="97" valign="top">&nbsp;</td>
    <td width="195" valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
    <td valign="top"><strong>Wooden Headboard Trim</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><font color="#FF0000"><%=rs("manhattantrim")%></font>&nbsp;</td>
   <%end if%>
    </tr>
    <%end if%>
    <%if rs("headboardfabric")="n" or isNull(rs("headboardfabric")) or  rs("headboardfabricchoice")="n" or isNull(rs("headboardfabricchoice")) then
	else%>
  <tr>
   <%if rs("headboardfabric")="n" or isNull(rs("headboardfabric")) then%>
   <td width="97" valign="top">&nbsp;</td>
    <td width="195" valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
    <td valign="top"><strong>Fabric Options:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("headboardfabric")%></td>
    <%end if%>
    <%if rs("headboardfabricchoice")="n" or isNull(rs("headboardfabricchoice")) then%>
   <td width="97" valign="top">&nbsp;</td>
    <td width="195" valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
    <td valign="top"><strong>Selection:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("headboardfabricchoice")%></td>
    <%end if%>
  </tr>
  <%end if%>
<%Dim gorrivanexists
gorrivanexists="n"
if rs("headboardstyle")="Gorrivan Headboard & Footboard" then
gorrivanexists="y"
gorrivanheight=rs("footboardheight")
gorrivanfinish=rs("footboardfinish")
fbheight="Footboard Height"
fbfinish="Footboard Finish"
end if
%>
 <%if rs("headboardlegqty")="n" or isNull(rs("headboardlegqty")) then%>
 
  <%else%>
  <tr>
    <td valign="top"><strong>Supporting Leg Qty:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("headboardlegqty")%>&nbsp;</td>
   
   <td width="97" valign="top">Supporting Leg Height &nbsp;</td>
    <td width="195" valign="top" bgcolor="#FFFFFF"><input name="hblegheight" type="text" id="hblegheight" value="<%=rs("hblegheight")%>"  size="10" maxlength="50">&nbsp;</td>
  
    
    </tr>
	
    
  <tr>
   <td valign="top"><strong>Supporting Legs Made At:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"> <%Set rs3 = getMysqlUpdateRecordSet("Select * from ManufacturedAt WHERE manufacturertype='b'", con)%>
      <select name="headboardlegsmadeat" id="headboardlegsmadeat" onChange="javascript: defaultAreaProductionDates(); ">
        <option value="n">Not Allocated</option>
        <%do until rs3.eof
			
%>
        <option value="<%=rs3("manufacturedatid")%>" <%=selected(rs3("manufacturedatid"), headboardlegsmadeatid) %>><%=rs3("manufacturedat")%></option>
        <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%>
  &nbsp;</td>
 
   <td width="97" valign="top"><%=fbheight%>&nbsp;</td>
    <td width="195" valign="top" bgcolor="#FFFFFF"><%=gorrivanheight%>&nbsp;</td>
  
    
    </tr>
	<%gorrivanprint=1
	end if%>
    
    <%if rs("headboardfabricdirection")<>"" then%>
<tr>
<td valign="top"><strong>Headboard Fabric Direction:</strong></td>
<td valign="top" bgcolor="#FFFFFF"><%=rs("headboardfabricdirection")%></td>
	<%if gorrivanexists="y" then
        if gorrivanprint=1 then%>
            <td valign="top"><%=fbfinish%>&nbsp;</td>
            <td valign="top" bgcolor="#FFFFFF"><%=gorrivanfinish%>&nbsp;</td>
        <%gorrivanprint=2
        end if
        if gorrivanprint=0 then%>
            <td valign="top"><%=fbheight%>&nbsp;</td>
            <td valign="top" bgcolor="#FFFFFF"><%=gorrivanheight%>&nbsp;</td>
        <%gorrivanprint=1
        end if%>
    <%else%>
    <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
    <%end if%>
</tr>
<%end if%>
<%if gorrivanexists="y" and gorrivanprint <> 2 then
	if gorrivanprint=0 then%>
	<tr>
	<td valign="top"><strong>&nbsp;</strong></td>
	<td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
	<td valign="top"><%=fbheight%>&nbsp;</td>
	<td valign="top" bgcolor="#FFFFFF"><%=gorrivanheight%>&nbsp;</td>
	</tr>
	<tr>
	<td valign="top"><strong>&nbsp;</strong></td>
	<td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
	<td valign="top"><%=fbfinish%>&nbsp;</td>
	<td valign="top" bgcolor="#FFFFFF"><%=gorrivanfinish%>&nbsp;</td>
	</tr>
	<%end if
	if gorrivanprint=1 then%>
	<tr>
	<td valign="top"><strong>&nbsp;</strong></td>
	<td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
	<td valign="top"><%=fbfinish%>&nbsp;</td>
	<td valign="top" bgcolor="#FFFFFF"><%=gorrivanfinish%>&nbsp;</td>
	</tr>
	<%end if
end if%>
    <tr>
     <%if rs("headboardprice")="n" or isNull(rs("headboardprice")) then%>
     <%else%>
   <td valign="top"></td>
    <td valign="top" bgcolor="#FFFFFF">
  &nbsp;</td>
 
 
    <td valign="top"><strong>Headboard Price:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=getCurrencySymbolForCurrency(orderCurrency)%> <%=rs("headboardprice")%></td>
   
    </tr> 
	<%end if%>
  
    <%if rs("headboardfabricdesc")<>"" then %>
  <tr>
    <td colspan="4" valign="top" class="box"><strong>Fabric Instructions</strong><br>
      <%=rs("headboardfabricdesc")%></td>
  </tr>
  <%end if%>
     <%if rs("specialinstructionsheadboard")<>"" then %>
  <tr>
    <td colspan="4" valign="top" class="box"><strong>Headboard Instructions:<br>
    </strong><%=rs("specialinstructionsheadboard")%></td>
    </tr>
    <%end if%>
  
</table>
</div>
<div id="head2">
<table width="200" border="0" cellpadding="2" cellspacing="0" class="fabric">
<tr>
<td><strong>Headboard Fabric Status<br>
<%Set rs3 = getMysqlUpdateRecordSet("Select * from fabricstatus where fabricstatusid=" & hbfabricstatus, con)%>
<input name="headboardfabricstatus" type="text" value="<%=rs3("fabricstatus")%>" readonly>
<%rs3.close
set rs3=nothing%>
</strong></td>
</tr>
<tr>
<td><strong>Supplier<br>
<input type="text" name="headboardsupplier" id="headboardsupplier" value="<%=headboardsupplier%>">
</strong></td>
</tr>
<tr>
<td><strong>Purchase Order No.<br>
<input type="text" name="headboardponumber" id="headboardponumber" value="<%=headboardponumber%>">
</strong></td>
</tr>
<tr>
<td><strong>Purchase Order Date<br>
<input name="headboardpodate" type="text" id="headboardpodate" size="10" value="<%=headboardpodate%>" readonly>
 <a href="javascript:clearheadboardpodate();">X</a></strong></td>
</tr>
<tr>
<td><strong>Expected Date<br>
<input name="headboardfabricexpecteddate" type="text" id="headboardfabricexpecteddate" size="10" value="<%=headboardfabricexpecteddate%>" readonly>
 <a href="javascript:clearheadboardfabricexpecteddate();">X</a></strong></td>
</tr>
<tr>
<td><strong>Received Date<br>
<input name="headboardfabricrecdate" type="text" id="headboardfabricrecdate" size="10" value="<%=headboardfabricrecdate%>" readonly>
 <a href="javascript:clearheadboardfabricrecdate();">X</a></strong></td>
</tr>
<tr>
<td><strong>Cutting Sent<br>
<input name="headboardcuttingsent" type="text" id="headboardcuttingsent" size="10" value="<%=headboardcuttingsent%>" readonly>
 <a href="javascript:clearheadboardcuttingsent();">X</a></strong></td>
</tr>
<tr>
<td><strong>FR Treating Sent<br>
<input name="frTreatingSent" type="text" id="frTreatingSent" size="10" value="<%=frTreatingSent%>" readonly>
 <a href="javascript:clearfrTreatingSent();">X</a></strong></td>
</tr>
<tr>
<td><strong>FR Treating Received<br>
<input name="frTreatingReceived" type="text" id="frTreatingReceived" size="10" value="<%=frTreatingReceived%>" readonly>
 <a href="javascript:clearfrTreatingReceived();">X</a></strong></td>
</tr>
<tr>
<td><strong>Confirmed Date<br>
<input name="headboardconfirmeddate" type="text" id="headboardconfirmeddate" value="<%=headboardconfirmeddate%>" size="10" readonly>
 <a href="javascript:clearheadboardconfirmeddate();">X</a></strong></td>
</tr>
<tr>
<td><strong>Date to Savoir Cardiff<br>
<input name="headboardtobcwdate" type="text" id="headboardtobcwdate" size="10" value="<%=headboardtobcwdate%>" readonly>
 <a href="javascript:clearheadboardtobcwdate();">X</a></strong></td>
</tr>
<tr>
<td><strong>Confirmed Price</strong>&nbsp;
<%=getCurrencySymbolForCurrency(orderCurrency)%>
<%=rs("hbfabriccost")%>
per mtr</td>
</tr>
<tr>
<td><strong>Fabric Total Price</strong> <%=getCurrencySymbolForCurrency(orderCurrency)%> <%=rs("hbfabricprice")%></td>
</tr>
<tr>
<td><strong>Qty&nbsp;
<%=rs("hbfabricmeters")%>
</strong></td>
</tr>
<%if headboarddetails<>"" then%>
<tr>
<td><strong>Details<br>
<%=headboarddetails%>
<br>
</strong></td>
</tr>
<%end if%>
</table>
</div>
<div id="head3">
<table width="200" border="0" cellpadding="2" cellspacing="0" class="prod">
<tr>
<td valign="top"><strong>Headboard Frame Made</strong>
<input name="headboardframe" type="text" id="headboardframe" size="10" value="<%=headboardframe%>" readonly>
 <a href="javascript:clearheadboardframe();">X</a>
</td>
</tr>
<tr>
<td valign="top"><strong>Headboard Prepped</strong>
<br>
<input name="headboardprepped" type="text" id="headboardprepped" size="10" value="<%=headboardprepped%>" readonly> <a href="javascript:clearheadboardprepped();">X</a>


</td>
</tr>

<tr>
<td valign="top"><strong>Finished:<br>
<input name="headboardfinished" type="text" id="headboardfinished" size="10" value="<%=headboardfinished%>" onChange="calendarBlurHandler(headboardfinished); checkHeadboardFinishedStatus();" readonly>
 <a href="javascript:clearheadboardfinished(); checkHBFinishedDateCompleted(null)">X</a></strong></td>
</tr>


</table>
</div>

<div id="head4">
<table width="200" border="0" cellpadding="2" cellspacing="0" class="logistics">
<tr>
<td valign="top"><strong>Headboard Planned Production Date<br>
<input name="headboardbcwexpected" type="text" id="headboardbcwexpected" size="10" value="<%=headboardbcwexpected%>" onChange="calendarBlurHandler(headboardbcwexpected)" readonly>
 <a href="javascript:clearheadboardbcwexpected();">X</a></strong></td>
</tr>
<tr>
<td valign="top"><strong>London Warehouse Received<br>
<input name="headboardbcwwarehouse" type="text" id="headboardbcwwarehouse" size="10"  onChange="clearheadboardbay(); checkHeadboardMadeAt();" value="<%=headboardbcwwarehouse%>" readonly>
  <a href="javascript:clearheadboardbcwwarehouse();">X</a></strong></td>
</tr>
<tr>
<td valign="top"><strong>Warehouse Location</strong>

         <%Set rs3 = getMysqlUpdateRecordSet("Select * from bays WHERE bay_no <> 39 order by bay_no", con)%>
          <select name="headboardbay" id="headboardbay" onChange="updateHeadboardStatus();">
          <option value="n"></option>
             <%do until rs3.eof
%>  <option value="<%=rs3("bay_no")%>" <%=selected(rs3("bay_no"), headboardbay) %>><%=rs3("bay_name")%></option>
           
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select></td>
    </tr>
    <tr>
      <td valign="top"><strong>Order Status:<br>
         <%Set rs3 = getMysqlUpdateRecordSet("Select * from QC_status where retiredCoreProducts='n' and mainstatusdropdowns='y'", con)%>
          <select name="headboardstatus" id="headboardstatus" onchange="resetExWorks('headboardstatus', 'exworksdatehb'); checkHeadboardProdDateCompleted(); defaultAreaProductionDates(); checkHBFinishedDateCompleted('<%=headboardstatus%>')" >
         
             <%do until rs3.eof
%>  <option value="<%=rs3("QC_statusid")%>" <%=selected(rs3("QC_statusid"), headboardstatus) %>><%=rs3("QC_status")%></option>
           
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select>
      </strong></td>
    </tr>
    <%if headboardstatus >= 2 then%>
    <tr>
      <td valign="top"><strong>Confirmed Waiting to Check Date: </strong> <%response.Write(getComponentConfirmedDate(con, pn, 8))%>
      </td>
      </tr>
    <%end if%>
     <%if headboardstatus >= 20 then%>
    <tr>
      <td valign="top"><strong>Issued Date: </strong> <%response.Write(getComponentIssuedDate(con, pn, 8))%>
      </td>
      </tr>
    <%end if%>
    <tr>
      <td valign="top"><strong>Delivery Date:<br>
<input name="headboarddeldate" type="text" id="headboarddeldate" size="10" value="<%=headboarddeldate%>" readonly>
 <a href="javascript:clearheadboarddeldate();">X</a></strong></td>
</tr>
    
                  <%
				  currentexworksdate=""%>
       <%if retrieveUserLocation()=1 or userHasRoleInList("ORDERDETAILS_VIEWER") then%>
      <tr>
        <td valign="top"><strong>Delivery Method:<br>
        <%Set rs3 = getMysqlUpdateRecordSet("Select * from DeliveryMethod", con)%>
          <select name="headboarddelmethod" id="headboarddelmethod" onchange="showHideExWorks('exworksheadboard', 'headboarddelmethod', 'exworksdatehb');">
         <option value="">--</option>
             <%do until rs3.eof
%>  <option value="<%=rs3("DeliveryMethodID")%>" <%=selected(rs3("DeliveryMethodID"), deliverymethodHb) %>><%=rs3("DeliveryMethod")%></option>
           
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select>
        </strong></td>
      </tr>
      <%end if%>     
    <tr id="exworksheadboard">
      <td valign="top">
      Ex-Works Date
       <%if retrieveUserLocation()=1  or retrieveUserLocation()=27 or userHasRoleInList("ORDERDETAILS_VIEWER") then
			Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation", con)
			else
			
			Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation and C.idlocation=" & retrieveUserLocation(), con)
			end if%>
           <select id="exworksdatehb" name="exworksdatehb" tabindex="4">
            
              <%currentexworksdate2=""
			   currentexworksdate=""
			  Set rs6 = getMysqlUpdateRecordSet("Select * from exportlinks L, exportCollShowrooms S, exportcollections E where L.purchase_no=" & rs("purchase_no") & " and L.linksCollectionID=S.exportCollshowroomsID and E.exportCollectionsID=S.exportCollectionID AND L.componentID=8", con)
			    if not rs6.eof then
			   currentexworksdate2=rs6("CollectionDate")
currentexworksdate=rs6("linkscollectionid")
			   end if
			rs6.close
			set rs6=nothing%>
	<%if currentexworksdate="" then%>
		<option value="n" selected>TBA</option>
<%else%>
<option value="<%=currentexworksdate%>" selected><%=currentexworksdate2%></option>
<%end if
			  
			  Do until rs5.eof
			   optionselected = ""
			   			   if currentexworksdate<>"" then
 if CInt(currentexworksdate)=rs5("exportCollshowroomsID")  then optionselected = "selected"
 end if

%>
<option value="<%=rs5("exportCollshowroomsID")%>" <%=optionselected%>><%response.Write(rs5("adminheading") & ", " & rs5("CollectionDate"))%></option><%rs5.movenext
loop
rs5.close
set rs5=nothing%>
</select></td>

</tr>
<tr id="hbboxshow">
<td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<tr>
<td colspan="2" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr><td width="104" align="center" valign="top">

<select name="hb1boxsize" id="hb1boxsize" onChange="getBoxWeight('8','<%=rs("headboardstyle")%>','hb1boxsize','','','hb1kg');">
<option value="" <%=selected("", hb_box) %>> </option>
<option value="Small" <%=selected("Small", hb_box) %>>Small</option>
<option value="Medium" <%=selected("Medium", hb_box) %>>Medium</option>
<option value="Large" <%=selected("Large", hb_box) %>>Large</option>
</select></td>
<td width="74" align="center" valign="top"><input name="hb1kg" type="text" id="hb1kg" size="5" maxlength="6" value="<%=hb1kg%>">&nbsp;kg</td>
</tr>
</table></td></tr>

<tr id="hbcrateshow">
<td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<tr>
<td colspan="4" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr>
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID > 15 and shippingBoxID < 21)", con)%><select name="hbCrateType" id="hbCrateType" onChange="getChangedCrateSize('8','hb1_packwidth','hb1_packheight','hb1_packdepth','hb1_packkg','hbCrateType','hb_crateqty'); getChangedCrateSize('8','hb2_packwidth','hb2_packheight','hb2_packdepth','hb2_packkg','hbCrateType','hb_crateqty'); disablefield('hbCrateType','hb1_packwidth','hb1_packheight','hb1_packdepth'); checkSpecialCrateQty('8','hbCrateType','hb_crateqty','hbspecialcrate2');" >
 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), hbcrate)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
 
  </select></td>
  </tr>
<tr>
<td align="center"><label for="hb1_packwidth"></label>
<input name="hb1_packwidth" type="text" id="hb1_packwidth" size="3" maxlength="6" value="<%=hb1_packwidth%>"></td>
<td align="center"><input name="hb1_packheight" type="text" id="hb1_packheight" size="3" maxlength="6" value="<%=hb1_packheight%>"></td>
<td align="center"><input name="hb1_packdepth" type="text" id="hb1_packdepth" size="3" maxlength="6" value="<%=hb1_packdepth%>"></td>
<td align="center"><input name="hb1_packkg" type="text" id="hb1_packkg" size="4" maxlength="6" value="<%=hb1_packkg%>"></td>
</tr>
<tr>
<td align="center">L</td>
<td align="center">H</td>
<td align="center">W</td>
<td align="center">&nbsp;</td>
</tr>

<!-- special crate no.2 -->
<tr class="hbspecialcrate2">
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID = 20)", con)%><select name="hbCrateType2" id="hbCrateType2" onChange="getChangedCrateSize('8','hb2_packwidth','hb2_packheight','hb2_packdepth','hb2_packkg','hbCrateType2','hb_crateqty');" >
 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), hbcrate2)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
  </select></td>
  </tr>
<tr class="hbspecialcrate2"><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr class="hbspecialcrate2">
<td align="center"><label for="hb2_packwidth"></label>
<input name="hb2_packwidth" type="text" id="hb2_packwidth" size="3" maxlength="6" value="<%=hb2_packwidth%>" ></td>
<td align="center"><input name="hb2_packheight" type="text" id="hb2_packheight" size="3" maxlength="6" value="<%=hb2_packheight%>"></td>
<td align="center"><input name="hb2_packdepth" type="text" id="hb2_packdepth" size="3" maxlength="6" value="<%=hb2_packdepth%>"></td>
<td align="center"><input name="hb2_packkg" type="text" id="hb2_packkg" size="4" maxlength="6" value="<%=hb2_packkg%>">
</td>
</tr>

<!-- special crate no.2 -->
<tr class="hbspecialcrate2">
<td align="center">L</td>
<td align="center">H</td>
<td align="center">W</td>
<td align="center">&nbsp;</td>
</tr>

<tr>
  <td colspan="4" align="center">Crate Qty:
    <label for="hb_crateqty"></label>
    <select name="hb_crateqty" id="hb_crateqty" onChange="crateQtyChanged('8','hb1_packwidth','hb1_packheight','hb1_packdepth','hb1_packkg','hbCrateType','hb_crateqty'); crateQtyChanged('8','hb2_packwidth','hb2_packheight','hb2_packdepth','hb2_packkg','hbCrateType','hb_crateqty'); checkSpecialCrateQty('8','hbCrateType','hb_crateqty','hbspecialcrate2');" >
      <option value="1" <%=selected(1, hbcrateqty)%>>1</option>
      <option value="2" <%=selected(2, hbcrateqty)%>>2</option>
    </select></td>
  </tr>
</table></td></tr>


<tr id="wrapshow">
<td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<tr>
<td colspan="4" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr>
<td align="center"><label for="hb_packwidth"></label>
<input name="hb_packwidth" type="text" id="hb_packwidth" size="3" maxlength="6" value="<%=hb_packwidth%>"></td>
<td align="center"><input name="hb_packheight" type="text" id="hb_packheight" size="3" maxlength="6" value="<%=hb_packheight%>"></td>
<td align="center"><input name="hb_packdepth" type="text" id="hb_packdepth" size="3" maxlength="6" value="<%=hb_packdepth%>"></td>
<td align="center"><input name="hb_packkg" type="text" id="hb_packkg" size="3" maxlength="6" value="<%=hb_packkg%>"></td>
</tr>
<tr>
<td align="center">W</td>
<td align="center">H</td>
<td align="center">D</td>
<td align="center">&nbsp;</td>
</tr>
</table></td></tr>
<%if hbtxtinc<>"" then response.Write("<tr id=""hbtxtincshow""><td>" & hbtxtinc & "</td></tr>")
if hbtxtinc3<>"" then response.Write("<tr id=""hbtxtinc3show""><td>" & hbtxtinc3 & "</td></tr>")%>
</table>
</div>
 </div>
 <%end if%>
 </td>
  </tr>
  <tr><td><hr class="linewidth"><%if rs("legsrequired") = "y" then legstylecheck="y" else legstylecheck="n"
  if isnull(rs("legstyle")) then legstylecheck=""%>
      <strong><%if legstylecheck="y" then response.Write("Legs Required") else response.Write("Legs Not Required")%>&nbsp;</strong>
      
 
Show
       <label>
       <input type="radio" name="legsrequired" id="legsrequired_y" value="y" <%=ischecked2(legstylecheck="y")%> onClick="javascript:legsChanged()" >
     </label>
     Hide
     <input name="legsrequired" type="radio" id="legsrequired_n" value="n" <%=ischecked2(legstylecheck="n")%> onClick="javascript:legsChanged()" >   <br>
   <br>
   
   <%if legstylecheck="y" then%>
   <div id="legs_div">
   <div id="legs1">
     <table width="400" border="0" align="left" cellpadding="2" cellspacing="0">
       <tr>
         <td valign="top"><strong>Made At:</strong></td>
         <td valign="top" bgcolor="#FFFFFF"><%Set rs3 = getMysqlUpdateRecordSet("Select * from ManufacturedAt WHERE manufacturertype='b'", con)%>
           <select name="legsmadeat" id="legsmadeat" onChange="javascript: defaultAreaProductionDates(); ">
             <option value="n">Not Allocated</option>
             <%do until rs3.eof
			
%>
             <option value="<%=rs3("manufacturedatid")%>" <%=selected(rs3("manufacturedatid"), legsmadeatid) %>><%=rs3("manufacturedat")%></option>
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%>
           </select>
           &nbsp;</td>
       </tr>
        <%if rs("legstyle")="n" or isNull(rs("legstyle")) or rs("legstyle")="--" then
		else%>
  <tr>
    <td width="101" valign="top"><strong>Leg Style:</strong></td>
    <td width="195" valign="top" bgcolor="#FFFFFF"><%=rs("legstyle")%>
      </td>
  </tr>
   <%end if%>
    <%if rs("legfinish")="n" or isNull(rs("legfinish")) then
	else%>
  <tr>
    <td valign="top"><strong>Leg Finish:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("legfinish")%></td>
  </tr>
     <%end if%>
      <%if rs("legheight")="n" or isNull(rs("legheight")) then
	else%>
  <tr>
    <td valign="top"><strong>Leg Height:</strong></td>
    <td valign="top" bgcolor="#FFFFFF">
	<%if speciallegheight<>"" then response.Write(speciallegheight & "cm") else response.Write(rs("legheight"))%></td>
  </tr>
   <%end if%>
      <%if rs("legprice")="n" or isNull(rs("legprice")) then
	else%>
  <tr>
    <td valign="top"><strong>
      Leg Price:</strong></td>
    <td valign="top" bgcolor="#FFFFFF">
      <%=getCurrencySymbolForCurrency(orderCurrency)%><%=rs("legprice")%></td>
  </tr>
  
  <%end if%>
  <%if NOT isNull(rs("floortype")) then%>
  <tr>
    <td valign="top"><strong>Floor Type:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("floortype")%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  </tr>
  <%end if%>
  <tr>
    <td valign="top"><strong>Standard Legs:</strong></td>
    <td valign="top" bgcolor="#FFFFFF"><%=rs("legqty")%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
  </tr>
  <tr>
    <td valign="middle"><strong>Additional Legs:</strong></td>
    <td valign="middle" bgcolor="#FFFFFF"><%=rs("addlegqty")%>&nbsp;</td>
  </tr>
  <tr>
    <td valign="top"><strong>TOTAL NO. OF LEGS:</strong></td>
    <td valign="top" bgcolor="#FFFFFF">
    <%
    totalLegQty = 0
    if rs("legqty") <> "" then totalLegQty = totalLegQty + cint(rs("legqty"))
    if rs("addlegqty") <> "" then totalLegQty = totalLegQty + cint(rs("addlegqty"))
	%>
    <%=totalLegQty%>&nbsp;</td>
  </tr>
  <%if rs("specialinstructionslegs")<>"" then%>
  <tr>
    <td colspan="2" valign="top" class="box"><b>Instructions:</b><br /><%=rs("specialinstructionslegs")%></td>
    </tr>
  <%end if%>
     </table>
   </div>
<div id="legs2">
  <table width="200" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
</div>
<div id="legs3">
<table width="200" border="0" cellpadding="2" cellspacing="0" class="prod">
<tr>
<td valign="top"><strong>Legs Prepped</strong><br>
<input name="legsprepped" type="text" id="legsprepped" value="<%=legsprepped%>" size="10" readonly>
 <a href="javascript:clearlegsprepped();">X</a></td>
</tr>

<tr>
<td valign="top"> <strong>Legs Finished</strong><br>
<input name="legsfinished" type="text" id="legsfinished" value="<%=legsfinished%>" size="10" onChange="calendarBlurHandler(legsfinished); checkLegsFinishedStatus();" readonly>
 <a href="javascript:clearlegsfinished();checkLegsFinishedDateCompleted(null)">X</a>

</td>
</tr>

</table>
</div>
<div id="legs4">
<table width="200" border="0" cellpadding="2" cellspacing="0" class="logistics">
<tr>
<td valign="top"><strong>Legs Planned Production Date<br>
<input name="legsbcwexpected" type="text" id="legsbcwexpected" size="10" value="<%=legsbcwexpected%>" onChange="calendarBlurHandler(legsbcwexpected)" readonly>
 <a href="javascript:clearlegsbcwexpected();">X</a></strong></td>
</tr>
<tr>
<td valign="top"><strong>London Warehouse Received<br>
<input name="legsbcwwarehouse" type="text" id="legsbcwwarehouse" size="10" value="<%=legsbcwwarehouse%>" onChange="clearlegsbay(); checkLegsMadeAt();" readonly>
 <a href="javascript:clearlegsbcwwarehouse();">X</a></strong></td>
</tr>
<tr>
<td valign="top"><strong>Warehouse Location</strong>

<%Set rs3 = getMysqlUpdateRecordSet("Select * from bays WHERE bay_no = 39 or bay_no=41 order by bay_no", con)%>
<select name="legsbay" id="legsbay" onChange="updateLegsStatus();">
<option value="n"></option>
<%do until rs3.eof
%>  <option value="<%=rs3("bay_no")%>" <%=selected(rs3("bay_no"), legsbay) %>><%=rs3("bay_name")%></option>
           
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select></td>
    </tr>
    <tr>
      <td valign="top"><strong>Order Status:<br>
         <%Set rs3 = getMysqlUpdateRecordSet("Select * from QC_status where retiredCoreProducts='n' and mainstatusdropdowns='y'", con)%>
          <select name="legsstatus" id="legsstatus" onChange="resetExWorks('legsstatus', 'exworksdatelegs'); checkLegsProdDateCompleted(); defaultAreaProductionDates(); checkLegsFinishedDateCompleted('<%=legsstatus%>')" >
   
             <%do until rs3.eof
%>  <option value="<%=rs3("QC_statusid")%>" <%=selected(rs3("QC_statusid"), legsstatus) %>><%=rs3("QC_status")%></option>

<%rs3.movenext
loop
rs3.close
set rs3=nothing%></select>
</strong></td>
</tr>
<%if legsstatus >= 2 then%>
<tr>
<td valign="top"><strong>Confirmed Waiting to Check Date: </strong> <%response.Write(getComponentConfirmedDate(con, pn, 7))%>
</td>
</tr>
<%end if%>
<%if legsstatus >= 20 then%>
<tr>
<td valign="top"><strong>Issued Date: </strong> <%=legsIssuedDate%>
</td>
</tr>
<%end if%>
<tr>
<td valign="top"><strong>Delivery Date:<br>
<input name="legsdeldate" type="text" id="legsdeldate" size="10" value="<%=legsdeldate%>" readonly>
 <a href="javascript:clearlegsdeldate();">X</a></strong></td>
</tr>
<%
currentexworksdate=""%>
<%if retrieveUserLocation()=1 or userHasRoleInList("ORDERDETAILS_VIEWER") then%>
<tr>
<td valign="top"><strong>Delivery Method:<br>
<%Set rs3 = getMysqlUpdateRecordSet("Select * from DeliveryMethod", con)%>
<select name="legsdelmethod" id="legsdelmethod" onchange="showHideExWorks('exworkslegs', 'legsdelmethod', 'exworksdatelegs');" >
<option value="">--</option>
<%do until rs3.eof
%>  <option value="<%=rs3("DeliveryMethodID")%>" <%=selected(rs3("DeliveryMethodID"), deliverymethodlegs) %>><%=rs3("DeliveryMethod")%></option>
           
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select>
        </strong></td>
      </tr>
      <%end if%>
    <tr id="exworkslegs">
      <td valign="top">
      Ex-Works Date
      <%if retrieveUserLocation()=1  or retrieveUserLocation()=27 or userHasRoleInList("ORDERDETAILS_VIEWER") then
			Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation", con)
			else
			
			Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation and C.idlocation=" & retrieveUserLocation(), con)
			end if%>
           <select id="exworksdatelegs" name="exworksdatelegs" tabindex="4">
            
              <%currentexworksdate2=""
			   currentexworksdate=""
			  Set rs6 = getMysqlUpdateRecordSet("Select * from exportlinks L, exportCollShowrooms S, exportcollections E where L.purchase_no=" & rs("purchase_no") & " and L.linksCollectionID=S.exportCollshowroomsID and E.exportCollectionsID=S.exportCollectionID AND L.componentID=7", con)
			    if not rs6.eof then
			   currentexworksdate2=rs6("CollectionDate")
currentexworksdate=rs6("linkscollectionid")
			   end if
			rs6.close
			set rs6=nothing%>
	<%if currentexworksdate="" then%>
		<option value="n" selected>TBA</option>
<%else%>
<option value="<%=currentexworksdate%>" selected><%=currentexworksdate2%></option>
<%end if

Do until rs5.eof
optionselected = ""
if currentexworksdate<>"" then
if CInt(currentexworksdate)=rs5("exportCollshowroomsID")  then optionselected = "selected"
end if

%>
<option value="<%=rs5("exportCollshowroomsID")%>" <%=optionselected%>><%response.Write(rs5("adminheading") & ", " & rs5("CollectionDate"))%></option><%rs5.movenext
loop
rs5.close
set rs5=nothing%>
</select></td>

</tr>
<%if legstxt<>"" then response.Write("<tr id=""legstxtshow""><td>" & legstxt & "</td></tr>")
if rs("mattressrequired")="n" and rs("baserequired")="n" and rs("topperrequired")="n" then%>
<tr class="legscrateshow">
<td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<tr>
<td colspan="4" align="center" valign="bottom"><p>Amend Commercial <br>
  Invoice Container Manifest</p></td></tr>
<tr class="nolegcrate">
  <td colspan="3" align="center" valign="bottom">No crate</td>
  <td align="center" valign="bottom"><input type="checkbox" name="nolegcrate" id="nolegcrate" onChange="CrateOrPack('nolegcrate','legspackedwithshow','hidelegcrate','legsspecialcrate2','legs1_packwidth','legs1_packheight','legs1_packdepth','legs1_packkg','7','legsPackedWith','legspackedwithcompnofield','legsCrateType','legs_crateqty','legsCrateType2');" <%=legsPackedWithCheck%> value="y">
    <label for="nolegcrate"></label></td>
</tr>
<tr class="hidelegcrate"><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td width="50" align="center" valign="bottom">Kg</td>
</tr>
<tr class="hidelegcrate">
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID > 15 and shippingBoxID < 21)", con)%><select name="legsCrateType" id="legsCrateType" onChange="getChangedCrateSize('7','legs1_packwidth','legs1_packheight','legs1_packdepth','legs1_packkg','legsCrateType','legs_crateqty'); getChangedCrateSize('7','legs2_packwidth','legs2_packheight','legs2_packdepth','legs2_packkg','legsCrateType','legs_crateqty'); disablefield('legsCrateType','legs1_packwidth','legs1_packheight','legs1_packdepth'); checkSpecialCrateQty('7','legsCrateType','legs_crateqty','legsspecialcrate2'); " >
 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), legscrate)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
  </select></td>
</tr><tr class="hidelegcrate">
<td width="40" align="center"><label for="legs1_packwidth"></label>
<input name="legs1_packwidth" type="text" id="legs1_packwidth" size="3" maxlength="6" value="<%=legs1_packwidth%>"></td>
<td width="40" align="center"><input name="legs1_packheight" type="text" id="legs1_packheight" size="3" maxlength="6" value="<%=legs1_packheight%>"></td>
<td width="39" align="center"><input name="legs1_packdepth" type="text" id="legs1_packdepth" size="3" maxlength="6" value="<%=legs1_packdepth%>"></td>
<td align="center"><input name="legs1_packkg" type="text" id="legs1_packkg" size="4" maxlength="6" value="<%=legs1_packkg%>"></td>
</tr>
<tr class="hidelegcrate">
<td align="center">L</td>
<td align="center">H</td>
<td align="center">W</td>
<td align="center">&nbsp;</td>
</tr>

<!-- special crate no.2 -->
<tr class="legsspecialcrate2">
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID = 20)", con)%><select name="legsCrateType2" id="legsCrateType2" onChange="getChangedCrateSize('7','legs2_packwidth','legs2_packheight','legs2_packdepth','legs2_packkg','legsCrateType2','legs_crateqty');" >
 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), legscrate2)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
  </select></td>
  </tr>
<tr class="legsspecialcrate2"><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr class="legsspecialcrate2">
<td align="center"><label for="legs2_packwidth"></label>
<input name="legs2_packwidth" type="text" id="legs2_packwidth" size="3" maxlength="6" value="<%=legs2_packwidth%>" ></td>
<td align="center"><input name="legs2_packheight" type="text" id="legs2_packheight" size="3" maxlength="6" value="<%=legs2_packheight%>"></td>
<td align="center"><input name="legs2_packdepth" type="text" id="legs2_packdepth" size="3" maxlength="6" value="<%=legs2_packdepth%>"></td>
<td align="center"><input name="legs2_packkg" type="text" id="legs2_packkg" size="4" maxlength="6" value="<%=legs2_packkg%>">
</td>
</tr>

<!-- special crate no.2 -->
<tr class="legsspecialcrate2">
<td align="center">L</td>
<td align="center">H</td>
<td align="center">W</td>
<td align="center">&nbsp;</td>
</tr>

<tr class="hidelegcrate">
  <td colspan="4" align="center">Crate Qty:
    <label for="legs_crateqty"></label>
    <select name="legs_crateqty" id="legs_crateqty" onChange="crateQtyChanged('7','legs1_packwidth','legs1_packheight','legs1_packdepth','legs1_packkg','legsCrateType','legs_crateqty'); crateQtyChanged('7','legs2_packwidth','legs2_packheight','legs2_packdepth','legs2_packkg','legsCrateType','legs_crateqty');  checkSpecialCrateQty('7','legsCrateType','legs_crateqty','legsspecialcrate2'); ">
      <option value="1" <%=selected(1, legscrateqty)%>>1</option>
      <option value="2" <%=selected(2, legscrateqty)%>>2</option>
    </select></td>
  </tr>
</table></td></tr>
<%end if%>
<tr class="legspackedwithshow"><td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<%Set rs3 = getMysqlQueryRecordSet("Select * from PackagingData where purchase_no=" & rs("purchase_no") & " and componentid=7", con)
if not rs3.eof then
selectedtext=rs3("PackedWith")
else
selectedtext=""
end if
%>
<tr class="legspackedwithshow">
  <td width="145" colspan="4" align="center">Legs Packed with:<br>
    <label for="legsPackedWith"></label>
    <select name="legsPackedWith" id="legsPackedWith" onChange="getCratePackedWith('7','legsPackedWith','legspackedwithcompnofield');">
      <option value="" ></option>
      <%if rs("topperrequired")="y" then%>
      <option value="5" <%=selected(selectedtext, 5)%>>Topper</option>
      <%end if
	  if rs("baserequired")="y" then%>
      <option value="3" <%=selected(selectedtext, 3)%>>Base</option>
      <%end if
	  if rs("mattressrequired")="y" then%>
      <option value="1" <%=selected(selectedtext, 1)%>>Mattress</option>
      <%end if
	  if rs("mattressrequired")<>"y" and rs("baserequired")<>"y" and rs("topperrequired")<>"y" then
       if rs("valancerequired")="y" then%>
      <option value="6" <%=selected(selectedtext, 6)%>>Valance</option>
       <%end if
       if rs("accessoriesrequired")="y" then%>
      <option value="9" <%=selected(selectedtext, 9)%>>Accessories</option>
       <%end if
	   end if%>
    </select>
    <input name="legspackedwithcompnofield" id="legspackedwithcompnofield" type="hidden" value="<%=selectedtext%>"></td>
  </tr>
<%
rs3.close
set rs3=nothing%>
</table></td></tr>


<tr id="legsboxshow">
<td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<tr>
<td colspan="2" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr><td width="104" align="center" valign="top">
<select name="legs1boxsize" id="legs1boxsize">
<option value="" <%=selected("", legs_box) %>></option>
<option value="Leg Box" <%=selected("Leg Box", legs_box) %>>Leg Box</option>
<option value="Double Leg Box" <%=selected("Double Leg Box", legs_box) %>>Double Leg Box</option>

</select></td>
<td width="71" align="center" valign="top"><input name="legs1kg" type="text" id="legs1kg" size="5" maxlength="6" value="<%=legs1kg%>">&nbsp;kg</td>
</tr>
</table></td></tr>


</table>
</div>
 </div>
 <%end if%>
   </td>
  </tr>
  <tr><td><hr class="linewidth"> 
   <strong>Valance Required</span>&nbsp;<%If rs("valancerequired")="n" Then%>
     Show
     <label>
       <input type="radio" name="valancerequired" id="valancerequired_y" value="y" onClick="javascript:valanceChanged()" >
     </label>
     Hide
     <input name="valancerequired" type="radio" id="valancerequired_n" value="n" checked onClick="javascript:valanceChanged()" >
   <%Else%>
     Show
     <label>
       <input type="radio" name="valancerequired" id="valancerequired_y" value="y" checked onClick="javascript:valanceChanged()" >
     </label>
     Hide
     <input name="valancerequired" type="radio" id="valancerequired_n" value="n"  onClick="javascript:valanceChanged()" >
   <%End If%>
   <br>
   <br>
   </strong>
   <%If rs("valancerequired")="y" Then%>
   <div id="valance_div">
   <div id="valance1">
     <table width="400" border="0" align="left" cellpadding="2" cellspacing="0">
       <tr>
         <td valign="top"><strong>Made At:</strong></td>
         <td colspan="3" valign="top"><%if valancemadeatid=3 then
		 Set rs3 = getMysqlUpdateRecordSet("Select * from ManufacturedAt", con)
		 else
		 Set rs3 = getMysqlUpdateRecordSet("Select * from ManufacturedAt where retired='n'", con)
		 end if%>
           <select name="valancemadeat" id="valancemadeat" onChange="javascript: defaultAreaProductionDates(); ">
             <option value="n">Not Allocated</option>
             <%do until rs3.eof
			
%>
             <option value="<%=rs3("manufacturedatid")%>" <%=selected(rs3("manufacturedatid"), valancemadeatid) %>><%=rs3("manufacturedat")%></option>
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%>
           </select></td>
         </tr>
         <%if (rs("pleats")="n" or isNull(rs("pleats"))) and  (rs("valancefabricdirection")="n" or isNull(rs("valancefabricdirection"))) then
		 else%>
       <tr>
        <%if rs("pleats")="n" or isNull(rs("pleats")) then%>
   <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
         <td valign="top"><strong>No. of Pleats:</strong></td>
         <td valign="top" bgcolor="#FFFFFF"><%=rs("pleats")%></td>
         <%end if%>
          <%if rs("valancefabricdirection")="n" or isNull(rs("valancefabricdirection")) then%>
   <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
         <td valign="top"><strong>Fabric Direction</strong></td>
         <td valign="top" bgcolor="#FFFFFF"><%=rs("valancefabricdirection")%></td>
         <%end if%>
         </tr>
          <%end if%>
              <%if (rs("valancefabric")="n" or isNull(rs("valancefabric"))) and (rs("valancefabricchoice")="n" or isNull(rs("valancefabricchoice"))) then
			  else%>
        <tr>
          <%if rs("valancefabric")="n" or isNull(rs("valancefabric")) then%>
   <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
          <td valign="top"><strong>Fabric Options: </strong></td>
          <td valign="top" bgcolor="#FFFFFF"><%=rs("valancefabric")%></td>
          <%end if%>
          <%if rs("valancefabricchoice")="n" or isNull(rs("valancefabricchoice")) then%>
   <td valign="top">&nbsp;</td>
    <td valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
          <td valign="top"><strong>Fabric Selection:</strong></td>
          <td valign="top" bgcolor="#FFFFFF"><%=rs("valancefabricchoice")%></td>
          <%end if%>
          </tr>
          <%end if%>
      

 
           <%if rs("valanceprice")="n" or isNull(rs("valanceprice")) then%>
   <tr> <td valign="top">&nbsp;</td>
    <td colspan="3" valign="top" bgcolor="#FFFFFF">&nbsp;</td>
  <%else%>
          <td valign="top"><strong> Price:</strong></td>
          <td colspan="3" valign="top" bgcolor="#FFFFFF"> 
       
        <%=getCurrencySymbolForCurrency(orderCurrency)%><%=rs("valanceprice")%></td>
      
        </tr> 
         <%end if%>

    <%if rs("valancefabricoptions")="n" or isNull(rs("valancefabricoptions")) then
		   else%>
        <tr>
          <td valign="top"><strong>Valance Fabric Options</strong></td>
          <td colspan="3" valign="top" bgcolor="#FFFFFF"><%=rs("valancefabricoptions")%></td>
        </tr>
          <%end if%>  
           <%if rs("valancefabricdesc")="n" or isNull(rs("valancefabricdesc")) then
		   else%>
        <tr>
          <td valign="top"><strong>Valance Fabric Description</strong></td>
          <td colspan="3" valign="top" bgcolor="#FFFFFF"><%=rs("valancefabricdesc")%></td>
        </tr>
          <%end if%>
       
           <%if rs("valancelength")<>"" then%>
        <tr>
          <td valign="top"><strong>Length Size (cm)</strong></td>
          <td valign="top" bgcolor="#FFFFFF" colspan="3"><%=rs("valancelength")%></td>
     
        </tr>
        <%end if%>
          <%if rs("valancewidth")<>"" then%> 
        <tr>
          <td valign="top"><strong>Width Size (cm)</strong></td>
          <td valign="top" bgcolor="#FFFFFF" colspan="3"><%=rs("valancewidth")%></td>
 
        </tr>
        <%end if%>
      <%if rs("valancedrop")<>"" then%> 
        <tr>
          <td valign="top"><strong>Drop Size (cm)</strong></td>
          <td valign="top" bgcolor="#FFFFFF" colspan="3"><%=rs("valancedrop")%></td>

</tr>
<%end if%>
<%if rs("specialinstructionsvalance")<>"" then %>
<tr>
<td colspan="4" valign="top"  class="box"><b>Instructions:</b><br /><%=rs("specialinstructionsvalance")%>&nbsp;</td>
</tr>
<%end if%>

</table>
<p>&nbsp;</p>
<div class="clear"></div>
<p>&nbsp;</p>


</span>
</div>
<div id="valance2">
<table width="200" border="0" cellpadding="2" cellspacing="0" class="fabric">
<tr>
<td><strong>Valance Fabric Status<br>

<%
Set rs3 = getMysqlUpdateRecordSet("Select * from fabricstatus where fabricstatusid=" & valfabricstatus, con)%>
<input name="valancefabricstatus" type="text" value="<%=rs3("fabricstatus")%>" readonly>
<%rs3.close
set rs3=nothing%>
</strong></td>
</tr>
<%if rs("specialinstructionsvalance") <>"" then%>
<tr>
<td><strong>Valance Special Instructions:</strong><br><%=rs("specialinstructionsvalance")%>
</td>
</tr>
<%end if%>
<tr>
<td><strong>Supplier<br>
<input type="text" name="valancesupplier" id="valancesupplier" value="<%=valancesupplier%>">
</strong></td>
</tr>
<tr>
<td><strong>Purchase Order No.<br>
<input type="text" name="valanceponumber" id="valanceponumber" value="<%=valanceponumber%>">
</strong></td>
</tr>
<tr>
<td><strong>Purchase Order Date<br>
<input name="valancepodate" type="text" id="valancepodate" size="10" value="<%=valancepodate%>" readonly>
 <a href="javascript:clearvalancepodate();">X</a></strong></td>
</tr>
<tr>
<td><strong>Expected Date<br>
<input name="valancefabricexpecteddate" type="text" id="valancefabricexpecteddate" size="10" value="<%=valancefabricexpecteddate%>" readonly>
 <a href="javascript:clearvalancefabricexpecteddate();">X</a></strong></td>
</tr>
<tr>
<td><strong>Received Date<br>
<input name="valancefabricrecdate" type="text" id="valancefabricrecdate" size="10" value="<%=valancefabricrecdate%>" readonly>
 <a href="javascript:clearvalancefabricrecdate();">X</a></strong></td>
</tr>
<tr>
<td><strong>Cutting Sent<br>
<input name="valancecuttingsent" type="text" id="valancecuttingsent" size="10" value="<%=valancecuttingsent%>" readonly>
 <a href="javascript:clearvalancecuttingsent();">X</a></strong></td>
</tr>
<tr>
<td><strong>FR Treating Sent<br>
<input name="valancefrTreatingSent" type="text" id="valancefrTreatingSent" size="10" value="<%=valancefrTreatingSent%>" readonly>
 <a href="javascript:clearvalancefrTreatingSent();">X</a></strong></td>
</tr>
<tr>
<td><strong>FR Treating Received<br>
<input name="valancefrTreatingReceived" type="text" id="valancefrTreatingReceived" size="10" value="<%=valancefrTreatingReceived%>" readonly>
 <a href="javascript:clearvalancefrTreatingReceived();">X</a></strong></td>
</tr>
<tr>
<td><strong>Confirmed Date<br>
<input name="valanceconfirmeddate" type="text" id="valanceconfirmeddate" size="10" value="<%=valanceconfirmeddate%>" readonly>
 <a href="javascript:clearvalanceconfirmeddate();">X</a></strong></td>
</tr>
<tr>
<td><strong>Sent to SD Date<br>
<input name="sendtosddate" type="text" id="sendtosddate" size="10" value="<%=sendtosddate%>" readonly>
 <a href="javascript:clearsendtosddate();">X</a></strong></td>
</tr>
<tr>
<td><strong>Fabric Price  </strong>
<%=getCurrencySymbolForCurrency(orderCurrency)%><%=rs("valfabriccost")%>
</td>
</tr>
<tr>
<td><strong>Fabric Total Price</strong> <%=getCurrencySymbolForCurrency(orderCurrency)%><%=rs("valfabricprice")%></td>
</tr>
<tr>
<td><strong>Qty </strong>
<%=rs("valfabricmeters")%>
</td>
</tr>
<tr>
<td><strong>Details<br>
<input type="text" name="valancedetails" id="valancedetails" value="<%=valancedetails%>">
<br>
</strong></td>
</tr>
</table>
</div>
<div id="valance3">

<table width="200" border="0" cellpadding="0" cellspacing="0"  class="prod">
<tr>
<td><strong>Valance Finished</strong><br>
<input name="valancefinished" type="text" id="valancefinished" value="<%=valancefinished%>" size="10" onChange="calendarBlurHandler(valancefinished); checkValanceFinishedStatus();" readonly>
 <a href="javascript:clearvalancefinished();checkValanceFinishedDateCompleted(null)">X</a></td>
</tr>
</table>

</div>
<div id="valance4">
<table width="200" border="0" cellpadding="2" cellspacing="0" class="logistics">
<tr>
<td valign="top"><strong>Valance Planned Production Date<br>
<input name="valancebcwexpected" type="text" id="valancebcwexpected" size="10" onChange="calendarBlurHandler(valancebcwexpected)" value="<%=valancebcwexpected%>" readonly>
 <a href="javascript:clearvalancebcwexpected();">X</a></strong></td>
</tr>
<tr>
<td valign="top"><strong>London Warehouse Received<br>
<input name="valancebcwwarehouse" type="text" id="valancebcwwarehouse" size="10"  onChange="clearvalancebay(); checkValanceMadeAt();" value="<%=valancebcwwarehouse%>" readonly>
 <a href="javascript:clearvalancebcwwarehouse();">X</a></strong></td>
</tr>
<tr>
<td valign="top"><strong>Warehouse Location</strong>

<%Set rs3 = getMysqlUpdateRecordSet("Select * from bays WHERE bay_no <> 39 order by bay_no", con)%>
<select name="valancebay" id="valancebay" onChange="updateValanceStatus();">
<option value="n"></option>
<%do until rs3.eof
%>  <option value="<%=rs3("bay_no")%>" <%=selected(rs3("bay_no"), valancebay) %>><%=rs3("bay_name")%></option>
           
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select></td>
        </tr>
        <tr>
          <td valign="top"><strong>Order Status:<br>
             <%Set rs3 = getMysqlUpdateRecordSet("Select * from QC_status where retiredCoreProducts='n' and mainstatusdropdowns='y'", con)%>
          <select name="valancestatus" id="valancestatus" onchange="resetExWorks('valancestatus', 'exworksdatevalance'); checkValanceProdDateCompleted(); defaultAreaProductionDates(); checkValanceFinishedDateCompleted('<%=valancestatus%>')" >
             <%do until rs3.eof
%>  <option value="<%=rs3("QC_statusid")%>" <%=selected(rs3("QC_statusid"), valancestatus) %>><%=rs3("QC_status")%></option>

<%rs3.movenext
loop
rs3.close
set rs3=nothing%></select>
</strong></td>
</tr>
<%if valancestatus >= 2 then%>
<tr>
<td valign="top"><strong>Confirmed Waiting to Check Date: </strong> <%response.Write(getComponentConfirmedDate(con, pn, 6))%>
</td>
</tr>
<%end if%>
<%if valancestatus >= 20 then%>
<tr>
<td valign="top"><strong>Issued Date: </strong> <%=valanceIssuedDate%>
</td>
</tr>
<%end if%>
<tr>
<td valign="top"><strong>Delivery Date:<br>
<input name="valancedeldate" type="text" id="valancedeldate" size="10" value="<%=valancedeldate%>" readonly>
 <a href="javascript:clearvalancedeldate();">X</a></strong></td>
</tr>
<%
currentexworksdate=""%>
<%if retrieveUserLocation()=1 or userHasRoleInList("ORDERDETAILS_VIEWER") then%>
<tr>
<td valign="top"><strong>Delivery Method:<br>
<%Set rs3 = getMysqlUpdateRecordSet("Select * from DeliveryMethod", con)%>
<select name="valancedelmethod" id="valancedelmethod" onchange="showHideExWorks('exworksvalance', 'valancedelmethod', 'exworksdatevalance');">
<option value="">--</option>
<%do until rs3.eof
%>  <option value="<%=rs3("DeliveryMethodID")%>" <%=selected(rs3("DeliveryMethodID"), deliverymethodvalance) %>><%=rs3("DeliveryMethod")%></option>
           
             <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select>
        </strong></td>
      </tr>
      <%end if%>
    <tr id="exworksvalance">
      <td valign="top">
      Ex-Works Date
      <%if retrieveUserLocation()=1  or retrieveUserLocation()=27 or userHasRoleInList("ORDERDETAILS_VIEWER") then
			Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation", con)
			else
			
			Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation and C.idlocation=" & retrieveUserLocation(), con)
			end if%>
           <select id="exworksdatevalance" name="exworksdatevalance" tabindex="4">
            
              <%currentexworksdate2=""
			   currentexworksdate=""
			  Set rs6 = getMysqlUpdateRecordSet("Select * from exportlinks L, exportCollShowrooms S, exportcollections E where L.purchase_no=" & rs("purchase_no") & " and L.linksCollectionID=S.exportCollshowroomsID and E.exportCollectionsID=S.exportCollectionID AND L.componentID=6", con)
			    if not rs6.eof then
			   currentexworksdate2=rs6("CollectionDate")
currentexworksdate=rs6("linkscollectionid")
			   end if
			rs6.close
			set rs6=nothing%>
	<%if currentexworksdate="" then%>
		<option value="n" selected>TBA</option>
<%else%>
<option value="<%=currentexworksdate%>" selected><%=currentexworksdate2%></option>
<%end if
			  
			  Do until rs5.eof
			   optionselected = "" 
			  			   if currentexworksdate<>"" then
 if CInt(currentexworksdate)=rs5("exportCollshowroomsID")  then optionselected = "selected"
 end if

%>
<option value="<%=rs5("exportCollshowroomsID")%>" <%=optionselected%>><%response.Write(rs5("adminheading") & ", " & rs5("CollectionDate"))%></option><%rs5.movenext
loop
rs5.close
set rs5=nothing%>
</select></td>

</tr>
<%if valancetxt<>"" then response.Write("<tr id=""valancetxtshow3""><td>" & valancetxt & "</td></tr>")
if valancetxt<>"" then response.Write("<tr id=""valancetxtshow4""><td>" & valancetxt & "</td></tr>")
if rs("mattressrequired")="n" and rs("baserequired")="n" and rs("topperrequired")="n" then%>
<tr class="valancecrateshow">
<td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<tr>
<td colspan="4" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr class="novalancecrate">
  <td colspan="3" align="center" valign="bottom">No crate</td>
  <td align="center" valign="bottom"><input type="checkbox" name="novalancecrate" id="novalancecrate" onChange="CrateOrPack('novalancecrate','valancepackedwithshow','hidevalancecrate','valancespecialcrate2','valance1_packwidth','valance1_packheight','valance1_packdepth','valance1_packkg','6','valancePackedWith','valancepackedwithcompnofield','valanceCrateType','valance_crateqty','valanceCrateType2');" <%=valancePackedWithCheck%> value="y">
    <label for="novalancecrate"></label></td>
</tr>
<tr class="hidevalancecrate"><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr class="hidevalancecrate">
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID > 15 and shippingBoxID < 21)", con)%><select name="valanceCrateType" id="valanceCrateType" onChange="getChangedCrateSize('6','valance1_packwidth','valance1_packheight','valance1_packdepth','valance1_packkg','valanceCrateType',''); getChangedCrateSize('6','valance2_packwidth','valance2_packheight','valance2_packdepth','valance2_packkg','valanceCrateType',''); disablefield('valanceCrateType','valance1_packwidth','valance1_packheight','valance1_packdepth'); checkSpecialCrateQty('6','valanceCrateType','valance_crateqty','valancespecialcrate2');" >

 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), valancecrate)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
  </select></td>
</tr><tr class="hidevalancecrate">

<td align="center"><label for="legs1_packwidth"></label>
<input name="valance1_packwidth" type="text" id="valance1_packwidth" size="3" maxlength="6" value="<%=valance1_packwidth%>"></td>
<td align="center"><input name="valance1_packheight" type="text" id="valance1_packheight" size="3" maxlength="6" value="<%=valance1_packheight%>"></td>
<td align="center"><input name="valance1_packdepth" type="text" id="valance1_packdepth" size="3" maxlength="6" value="<%=valance1_packdepth%>"></td>
<td align="center"><input name="valance1_packkg" type="text" id="valance1_packkg" size="4" maxlength="6" value="<%=valance1_packkg%>"></td>
</tr>
<tr class="hidevalancecrate">
<td align="center">L</td>
<td align="center">H</td>
<td align="center">W</td>
<td align="center">&nbsp;</td>
</tr>

<!-- special crate no.2 -->
<tr class="valancespecialcrate2">
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID = 20)", con)%><select name="valanceCrateType2" id="valanceCrateType2" onChange="getChangedCrateSize('6','valance2_packwidth','valance2_packheight','valance2_packdepth','valance2_packkg','valanceCrateType2','valance_crateqty');" >
 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), valancecrate2)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
  </select></td>
  </tr>
<tr class="valancespecialcrate2"><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr class="valancespecialcrate2">
<td align="center"><label for="valance2_packwidth"></label>
<input name="valance2_packwidth" type="text" id="valance2_packwidth" size="3" maxlength="6" value="<%=valance2_packwidth%>" ></td>
<td align="center"><input name="valance2_packheight" type="text" id="valance2_packheight" size="3" maxlength="6" value="<%=valance2_packheight%>"></td>
<td align="center"><input name="valance2_packdepth" type="text" id="valance2_packdepth" size="3" maxlength="6" value="<%=valance2_packdepth%>"></td>
<td align="center"><input name="valance2_packkg" type="text" id="valance2_packkg" size="4" maxlength="6" value="<%=valance2_packkg%>">
</td>
</tr>

<!-- special crate no.2 -->
<tr class="valancespecialcrate2">
<td align="center">L</td>
<td align="center">H</td>
<td align="center">W</td>
<td align="center">&nbsp;</td>
</tr>

<tr class="hidevalancecrate">
  <td colspan="4" align="center">Crate Qty:
    <label for="valance_crateqty"></label>
    <select name="valance_crateqty" id="valance_crateqty" onChange="crateQtyChanged('6','valance1_packwidth','valance1_packheight','valance1_packdepth','valance1_packkg','valanceCrateType','valance_crateqty'); crateQtyChanged('6','valance2_packwidth','valance2_packheight','valance2_packdepth','valance2_packkg','valanceCrateType','valance_crateqty'); checkSpecialCrateQty('6','valanceCrateType','valance_crateqty','valancespecialcrate2');" >
      <option value="1" <%=selected(1, valancecrateqty)%>>1</option>
      <option value="2" <%=selected(2, valancecrateqty)%>>2</option>
    </select></td>
  </tr>
</table></td></tr>
<%end if%>
<tr class="valancepackedwithshow"><td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<%Set rs3 = getMysqlQueryRecordSet("Select * from PackagingData where purchase_no=" & rs("purchase_no") & " and componentid=6", con)
if not rs3.eof then
selectedtext=rs3("PackedWith")
else
selectedtext=""
end if
%>
<tr class="valancepackedwithshow">
  <td colspan="4" align="center">Valance Packed with:<br>
    <label for="valancePackedWith"></label>
    <select name="valancePackedWith" id="valancePackedWith" onChange="getCratePackedWith('6','valancePackedWith','valancepackedwithcompnofield');">
      <option value="" ></option>
      <%if rs("topperrequired")="y" then%>
      <option value="5" <%=selected(selectedtext, 5)%>>Topper</option>
      <%end if
	  if rs("baserequired")="y" then%>
      <option value="3" <%=selected(selectedtext, 3)%>>Base</option>
      <%end if
	  if rs("mattressrequired")="y" then%>
      <option value="1" <%=selected(selectedtext, 1)%>>Mattress</option>
      <%end if
       if rs("legsrequired")="y" then%>
      <option value="7" <%=selected(selectedtext, 7)%>>Legs</option>
       <%end if
	   if rs("headboardrequired")="y" then%>
      <option value="8" <%=selected(selectedtext, 8)%>>Headboard</option>
       <%end if
       if rs("accessoriesrequired")="y" then%>
      <option value="9" <%=selected(selectedtext, 9)%>>Accessories</option>
       <%end if%>
    </select>
    <input name="valancepackedwithcompnofield" id="valancepackedwithcompnofield" type="hidden" value="<%=selectedtext%>"></td>
  </tr>
<%rs3.close
set rs3=nothing%>

</table></td></tr>

<%end if%>
<%if rs("mattressrequired")="n" and rs("topperrequired")="n" and rs("baserequired")="n" and rs("headboardrequired")="n" and rs("accessoriesrequired")="n" then%>
<tr id="valanceboxshow">
<td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<tr>
<td colspan="2" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr><td width="104" align="center" valign="top">
<select name="valance1boxsize" id="valance1boxsize">
<option value="" <%=selected("", valance_box) %>> </option>
<option value="LegBox" <%=selected("LegBox", valance_box) %>>Leg Box </option>
<option value="Small" <%=selected("Small", valance_box) %>>Small</option>
<option value="Medium" <%=selected("Medium", valance_box) %>>Medium</option>
<option value="Large" <%=selected("Large", valance_box) %>>Large</option>
</select></td>
<td width="71" align="center" valign="top"><input name="valance1kg" type="text" id="valance1kg" size="5" maxlength="6" value="<%=valance1kg%>">&nbsp;kg</td>
</tr>
</table></td></tr>
<%else%>
<tr class="valanceboxshow"><td><table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<%Set rs3 = getMysqlQueryRecordSet("Select * from PackagingData where purchase_no=" & rs("purchase_no") & " and componentid=6", con)
if not rs3.eof then
selectedtext=rs3("PackedWith")
else
selectedtext=""
end if
%>
<tr>
  <td colspan="4" align="center">Valance Packed with:<br>
    <label for="valanceBoxPackedWith"></label>
    <select data-oldval="<%=selectedtext%>" name="valanceBoxPackedWith" id="valanceBoxPackedWith" onChange="getBoxPackedWith('6','valanceBoxPackedWith');">
      <option value="" ></option>
      <%
	  if rs("baserequired")="y" then%>
      <option value="3" <%=selected(selectedtext, 3)%>>Base</option>
      <%end if
	  if rs("topperrequired")="y" then%>
      <option value="5" <%=selected(selectedtext, 5)%>>Topper</option>
      <%end if
	  if rs("mattressrequired")="y" then%>
      <option value="1" <%=selected(selectedtext, 1)%>>Mattress</option>
       <%end if
	  if rs("legsrequired")="y" then%>
      <option value="7" <%=selected(selectedtext, 7)%>>Legs</option>
       <%end if
	   if rs("accessoriesrequired")="y" then
	   	call addPackedWithAccessoryOptions(con, order, 0, selectedtext)
       end if%>
    </select>
  </tr>
<%rs3.close
set rs3=nothing%>

</table></td></tr>
<%end if%>
</tr>
</table>
</div>
</div>


<tr><td>

<!-- accessories section -->
<strong>Accessories Required</strong>&nbsp;
     Show
     <label>
       <input type="radio" name="accessoriesrequired" id="accessoriesrequired_y" value="y" <%=ischeckedY(rs("accessoriesrequired"))%> onClick="javascript:accessoriesChanged()" >
     </label>
     Hide
     <input name="accessoriesrequired" type="radio" id="accessoriesrequired_n" value="n" <%=ischeckedN(rs("accessoriesrequired"))%> onClick="javascript:accessoriesChanged()" >
</p>
<%
Set rs3 = getMysqlUpdateRecordSet("select * from orderaccessory where purchase_no=" & order & " order by orderaccessory_id", con)
%>
<%if rs3.recordcount > 0 then%>
<div id="accessories_div">
<div id="accessory1">
<%if rs3.recordcount < 1 then%>
<table width="415">
	<tr><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th><th>&nbsp;</th></tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;
			</td>
			
			
		</tr>

	</table>
<%else%>
	<table>
	<tr><th>&nbsp;</th><th colspan="2" align="left" bgcolor="#FFFFCC">Item&nbsp;Description</th>
	  <th colspan="2" align="left" bgcolor="#FFFFCC">Design &amp; Details</th>
	  <th align="left" bgcolor="#FFFFCC">Colour</th>
	  <th align="left" bgcolor="#FFFFCC">Size</th>
	  <th align="left" bgcolor="#FFFFCC">Unit&nbsp;Price</th>
	  <th align="left" bgcolor="#FFFFCC">Qty</th>
	  <th align="left" bgcolor="#FFFFCC">Status</th>
	  </tr>
	<% Dim acc_count, accCompId
	acc_count=rs3.recordcount
	for i = 1 to rs3.recordcount
	
		acc_desc = ""
		acc_design = ""
		acc_colour = ""
		acc_size = ""
		acc_unitprice = ""
		acc_qty = ""
		acc_id = ""
		acc_supplier=""
		acc_status=""
		if not rs3.eof then
			acc_desc = rs3("description")
			acc_design = rs3("design")
			acc_colour = rs3("colour")
			acc_size = rs3("size")
			acc_unitprice = rs3("unitprice")
			acc_qty = rs3("qty")
			acc_id = rs3("orderaccessory_id")
			acc_supplier = rs3("supplier")
			acc_ponumber=trim(rs3("ponumber"))
			acc_podate=rs3("podate")
			acc_eta=rs3("eta")
			acc_received=rs3("received")
			acc_checked=rs3("checked")
			acc_special=rs3("specialinstructions")
			acc_qtyfollow=rs3("qtytofollow")
			acc_delivered=rs3("delivered")
			acc_packtariffcode=rs3("tariffcode")
			if rs3("description")<>"" then acc_status=100
			if acc_ponumber<>"" then acc_status=10
			if acc_received<>"" then acc_status=110
			if acc_checked<>"" then acc_status=120
			if acc_delivered>0 then acc_status=70
			if acc_qtyfollow>0 then acc_status=130
			rs3.movenext
		end if
		if acc_ponumber<>"" then 
			accreadonly="" 
			accdisabled=""
			else 
			accreadonly=""
			accdisabled=""
		end if
	%>
		<tr>
		  <td valign="top">&nbsp;</td>
		  <td colspan="9" valign="top"><hr></td>
		  </tr>
		<tr>
			<td valign="top"><b>Item&nbsp;<br>
No.&nbsp;<%=i%></b></td>
			<td colspan="2" valign="top"><%=acc_desc%></td>
			<td colspan="2" valign="top"><%=acc_design%>&nbsp;</td>
			<td valign="top"><%=acc_colour%>&nbsp;</td>
			<td valign="top"><%=acc_size%>&nbsp;</td>
			<td valign="top"><%=fmtCurr2(acc_unitprice, false, orderCurrency)%></td>
			<td valign="top"><%=acc_qty%></td>
               <%Set rs4 = getMysqlUpdateRecordSet("Select * from qc_status where qc_statusid=" & acc_status, con)%>
          
     
			<td valign="top"><strong><%=rs4("qc_status")%></strong></td>
                 <%rs4.close
		  set rs4=nothing%>
			</tr>
		<tr>
		  <td valign="top">&nbsp;</td>
		  <th colspan="9"><hr />&nbsp;</th>
		  </tr>
		<tr>
		  <td valign="top">&nbsp;</td>
		  <th align="left">Supplier</th>
		  <th align="left">Purchase <br>
		    Order No.</th>
		  <th align="left">Purchase <br>
		    Order Date</th>
		  <th align="left">ETA<br>
		    Date</th>
		  <th align="left">Received<br>
		    Date</th>
		  <th align="left">Checked &amp; <br>
		    Picked Date</th>
		  <th align="left">Special Instructions<br>
/ Details</th>
<th align="left">Qty to <br>
follow</th>
<th align="left">Delivered <br>
Date</th>
<th align="left" class="tariffcode">Tariff Code <br></th>
</tr>
      
      <tr>
<td valign="top">&nbsp;</td>
<td valign="top"><strong>
<input name="acc_supplier<%=i%>" type="text" id="acc_supplier" value="<%=acc_supplier%>" size="10" maxlength="25" <%=accreadonly%>>
</strong></td>
<td valign="top"><input name="acc_ponumber<%=i%>" type="text" id="acc_ponumber" value="<%=acc_ponumber%>" size="10" maxlength="15">
&nbsp;</td>
<td valign="top"><input name="acc_podate<%=i%>" type="text" id="acc_podate<%=i%>" value="<%=acc_podate%>" size="10" readonly <%=accdisabled%>>
<br>
 <%if accdisabled="" then%><a href="javascript:clearacc_podate(<%=i%>);">(X)</a><%end if%></td>
<td valign="top"><input name="acc_eta<%=i%>" type="text" id="acc_eta<%=i%>" value="<%=acc_eta%>" size="10" readonly <%=accdisabled%> >
<br>
 <%if accdisabled="" then%><a href="javascript:clearacc_eta(<%=i%>);">(X)</a><%end if%></td>
<td valign="top"><input name="acc_received<%=i%>" type="text" id="acc_received<%=i%>" value="<%=acc_received%>" size="10" readonly <%=accdisabled%> >
<br>
 <%if accdisabled="" then%><a href="javascript:clearacc_received(<%=i%>);">(X)</a><%end if%></td>
<td valign="top"><input name="acc_checked<%=i%>" type="text" id="acc_checked<%=i%>" value="<%=acc_checked%>" size="10" readonly <%=accdisabled%> >
<br>
 <%if accdisabled="" then%><a href="javascript:clearacc_checked(<%=i%>);">(X)</a><%end if%></td>
<td valign="top"><input name="acc_special<%=i%>" type="text" id="acc_special" value="<%=acc_special%>" size="20" maxlength="100" <%=accdisabled%>></td>
<td valign="top"><select name="acc_qtyfollow<%=i%>" id="acc_qtyfollow" <%=accdisabled%>>
<%for x=0 to 20%>
<option value="<%=x%>" <%=selected(x, acc_qtyfollow) %>><%=x%></option>
<%next%>
</select></td>
<td valign="top"><input name="acc_delivered<%=i%>" type="text" id="acc_delivered<%=i%>" value="<%=acc_delivered%>" size="10" readonly  <%=accdisabled%>>
<br>
 <%if accdisabled="" then%><a href="javascript:clearacc_delivered(<%=i%>);">(X)</a><%end if%></td>
 <td valign="top" class="tariffcode"><input name="acc_packtariffcode<%=i%>" type="text" id="acc_packtariffcode<%=i%>" value="<%=acc_packtariffcode%>" size="10" />
<br>
</td>
</tr>

      <tr class="accexpboxonly">
        <td valign="top">&nbsp;</td>
        <td valign="top">Width cm</td>
        <td valign="top">Length cm</td>
        <td valign="top">Height cm</td>
        <td valign="top">Weight kg</td>
        <td colspan="6" valign="top">Packed With</td>
      </tr>
      <tr class="accexpboxonly">
          <td valign="top">&nbsp;</td>
          <td valign="top"><strong>
           <%sql="Select * from packagingdata where CompPartNo=" & acc_id
		   Set rs4 = getMysqlUpdateRecordSet(sql, con)
		   if not rs4.eof then
		   	acc_length=rs4("packdepth")
			acc_width=rs4("packwidth")
			acc_height=rs4("packheight")
			acc_weight=rs4("packkg")
			acc_packedwith=rs4("packedwith")
			selectedtext=rs4("packedwith")
			if isNull(rs4("packkg")) then acc_weight=0
			
		   end if
		   rs4.close
		   set rs4=nothing
		   
		   %>
            <input name="acc_width<%=i%>" type="text" id="acc_width<%=i%>" value="<%=acc_width%>" size="10" maxlength="25" >
          </strong></td>
          <td valign="top"><input name="acc_length<%=i%>" type="text" id="acc_length<%=i%>" value="<%=acc_length%>" size="10" maxlength="25" ></td>
          <td valign="top"><input name="acc_height<%=i%>" type="text" id="acc_height<%=i%>" value="<%=acc_height%>" size="10" maxlength="25" ></td>
          <td valign="top">
          <input name="acc_weight<%=i%>" type="text" id="acc_weight<%=getAccIdForSequence(con, order, i)%>" value="<%=acc_weight%>" size="10" maxlength="25" ></td>
         
          <td valign="top">
          <select data-oldval="<%=selectedtext%>" name="acc_packedwith<%=i%>" id="acc_packedwith<%=i%>" onChange="getBoxPackedWith('9','acc_packedwith<%=i%>',<%=acc_id%>);" >
          <option value="0" <%=selected(selectedtext, 0)%>>Nothing</option>
         <%
          call addPackedWithAccessoryOptions(con, order, i, selectedtext)
	  
	  	  if defaultwrappingid = 3 then ' these options only valid for box
			  if rs("topperrequired")="y" then%>
			  <option value="5" <%=selected(selectedtext, 5)%>>Topper</option>
			  <%end if
			  if rs("mattressrequired")="y" then%>
			  <option value="1" <%=selected(selectedtext, 1)%>>Mattress</option>
			   <%end if
			   if rs("baserequired")="y" then%>
			  <option value="3" <%=selected(selectedtext, 3)%>>Base</option>
			  <%end if
			  if rs("legsrequired")="y" then%>
			  <option value="7" <%=selected(selectedtext, 7)%>>Legs</option>
			   <%end if
			   if rs("headboardrequired")="y" then%>
			  <option value="8" <%=selected(selectedtext, 8)%>>Headboard</option>
			   <%end if
	  	  end if
		  %>
          </select>
          </td>
          <td valign="top">&nbsp;</td>
          <td valign="top">&nbsp;</td>
          <td valign="top">&nbsp;</td>
          <td valign="top">&nbsp;</td>
          <td valign="top">&nbsp;</td>
      </tr>

<tr bgcolor="#666666">
<td colspan="11" valign="top">&nbsp;</td>
</tr>
<tr bgcolor="#666666">
<td colspan="11" valign="top" align="right">

</td>
</tr>
<input name="acc_status<%=i%>" type="hidden" value="<%=acc_status%>">
<input name="acc_id<%=i%>" type="hidden" value="<%=acc_id%>">
<% next
rs3.close
set rs3 = nothing

%>
<tr>
<td colspan="10" valign="top" align="right">



<%if rs("accessoriesrequired")="y" then
currentexworksdate=""%>
<%if retrieveUserLocation()=1 or userHasRoleInList("ORDERDETAILS_VIEWER") then%>
<p align="right"><strong>Delivery Method:<br>
</strong></p>
<p align="right"><strong>
<%Set rs3 = getMysqlUpdateRecordSet("Select * from DeliveryMethod", con)%>
<select name="accdelmethod" id="accdelmethod" onchange="showHideExWorks('exworksacc', 'accdelmethod', 'exworksdateacc')">
<option value="">--</option>
<%do until rs3.eof
%>  <option value="<%=rs3("DeliveryMethodID")%>" <%=selected(rs3("DeliveryMethodID"), deliverymethodacc) %>><%=rs3("DeliveryMethod")%></option>
          
          <%rs3.movenext
	  loop
	  rs3.close
	  set rs3=nothing%></select>
    </strong></p>
      <%end if%>
      <div id="exworksacc"> 
         <p align="right"> Ex-Works Date
      <%if retrieveUserLocation()=1  or retrieveUserLocation()=27 or userHasRoleInList("ORDERDETAILS_VIEWER") then
			Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation", con)
			else
			
			Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where  E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation and C.idlocation=" & retrieveUserLocation(), con)
			end if%>
           <select id="exworksdateacc" name="exworksdateacc" tabindex="4">
            
              <%currentexworksdate2=""
			   currentexworksdate=""
			  Set rs6 = getMysqlQueryRecordSet("Select * from exportlinks L, exportCollShowrooms S, exportcollections E where L.purchase_no=" & rs("purchase_no") & " and L.linksCollectionID=S.exportCollshowroomsID and E.exportCollectionsID=S.exportCollectionID AND  L.componentID=9", con)
			    if not rs6.eof then
				currentexworksdate2=rs6("CollectionDate")
			   currentexworksdate=rs6("linkscollectionid")
			   end if
			rs6.close
			set rs6=nothing%>
			<%if currentexworksdate="" then%>
		<option value="n" selected>TBA</option>
<%else%>
<option value="<%=currentexworksdate%>" selected><%=currentexworksdate2%></option>
<%end if

			  Do until rs5.eof
			   optionselected = "" 
			  			   if currentexworksdate<>"" then
 if CInt(currentexworksdate)=rs5("exportCollshowroomsID")  then optionselected = "selected"
 end if

%>
              <option value="<%=rs5("exportCollshowroomsID")%>" <%=optionselected%>><%response.Write(rs5("adminheading") & ", " & rs5("CollectionDate"))%></option><%rs5.movenext
			 loop
			 rs5.close
			 set rs5=nothing%>
            </select></p>
         <% end if %> 
         </div>
   <p><br>
	  <strong>Accessories total:</strong>&nbsp;<%=getCurrencySymbolForCurrency(orderCurrency)%><%=rs("accessoriestotalcost")%>
	  <%end if%>
	  </p> 
<%if rs("mattressrequired")="n" and rs("topperrequired")="n" and rs("baserequired")="n" and rs("headboardrequired")="n" and rs("legsrequired")="n" then%>
<table id="accboxshow" border="0" align="right" cellpadding="1" cellspacing="2" class="packtableborder logistics" style="float:right;">    
<tr>
<td colspan="2" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr><td width="104" align="center" valign="top">
<select name="acc1boxsize" id="acc1boxsize" onChange="getBoxWeight('9','','acc1boxsize','','','acc1kg'); getAccBoxSizes();" >

	<option value="" <%=selected("", acc1_box) %>> </option>
	<option value="Small" <%=selected("Small", acc1_box) %>>Small</option>
	<option value="Medium" <%=selected("Medium", acc1_box) %>>Medium</option>
	<option value="Large" <%=selected("Large", acc1_box) %>>Large</option>
    <%
	if acc1_box="Special" then%>
    <option value="Special" <%=selected("Special", acc1_box) %>>Special</option>
    <%end if%>
</select></td>
<td width="74" align="center" valign="top"><input name="acc1kg" type="text" id="acc1kg" size="5" maxlength="6" value="<%=acc1kg%>">&nbsp;kg</td>
</tr>
<%else%>
<tr class="accboxshow" align="right"><td colspan="10"><table border="0" cellpadding="1" cellspacing="2" class="packtableborder logistics" style="float:right;">
<%Set rs3 = getMysqlQueryRecordSet("Select * from PackagingData where purchase_no=" & rs("purchase_no") & " and componentid=9", con)
if not rs3.eof then
	selectedtext=rs3("PackedWith")
else
	selectedtext=""
end if
%>
<tr>
  <td colspan="4" align="center">Packed with:<br>
    <label for="accBoxPackedWith"></label>
    <select data-oldval="<%=selectedtext%>" name="accBoxPackedWith" id="accBoxPackedWith" onChange="showHideAccWrap(); getBoxPackedWith('9','accBoxPackedWith',<%=acc_id%>); getAccBoxSizes();">
     <option value="" >&nbsp;</option> 
     <option value="0" <%=selected(selectedtext, 0)%> >Nothing</option> 
      <%
	  
	  if rs("topperrequired")="y" then%>
      <option value="5" <%=selected(selectedtext, 5)%>>Topper</option>
      <%end if
	  if rs("mattressrequired")="y" then%>
      <option value="1" <%=selected(selectedtext, 1)%>>Mattress</option>
       <%end if
	   if rs("baserequired")="y" then%>
      <option value="3" <%=selected(selectedtext, 3)%>>Base</option>
      <%end if
	  if rs("legsrequired")="y" then%>
      <option value="7" <%=selected(selectedtext, 7)%>>Legs</option>
       <%end if
	   if rs("accessoriesrequired")="y" then
	     call addPackedWithAccessoryOptions(con, order, 0, selectedtext)
       end if%>
    </select>
  </tr>
<%rs3.close
set rs3=nothing%>

</table></td></tr>
<%end if%>
</tr>
</table>

     
          <table id="accCrateShow" border="0" align="left" cellpadding="3" cellspacing="2" class="packtableborder logistics" style="float:right;">

<tr id="crateshow">

<td>

<table border="0" align="left" cellpadding="1" cellspacing="2" class="packtableborder">
<%'if rs("mattressrequired")="n" and rs("topperrequired")="n" and rs("baserequired")="n" then%>
<tr>
<td colspan="4" align="center" valign="bottom">Amend Commercial <br>
Invoice Container Manifest</td></tr>
<tr class="noacccrate">
  <td colspan="3" align="center" valign="bottom">No crate</td>
  <td align="center" valign="bottom"><input type="checkbox" name="noacccrate" id="noacccrate" onChange="CrateOrPack('noacccrate','accpackedwithshow','hideacccrate','accspecialcrate2','acc1_packwidth','acc1_packheight','acc1_packdepth','acc1_packkg','9','accPackedWith','accpackedwithcompnofield','accCrateType','acc_crateqty','accCrateType2');" <%=accPackedWithCheck%> value="y">
    <label for="noacccrate"></label></td>
</tr>

<tr class="hideacccrate">
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID > 15 and shippingBoxID < 21)", con)%><select name="accCrateType" id="accCrateType" onChange="getChangedCrateSize('9','acc1_packwidth','acc1_packheight','acc1_packdepth','acc1_packkg','accCrateType','acc_crateqty'); getChangedCrateSize('9','acc2_packwidth','acc2_packheight','acc2_packdepth','acc2_packkg','accCrateType','acc_crateqty'); disablefield('accCrateType','acc1_packwidth','acc_packheight','acc1_packdepth'); checkSpecialCrateQty('9','accCrateType','acc_crateqty','accspecialcrate2'); " >

 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), accessoriescrate)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
  </select></td>
  </tr>
<tr class="hideacccrate"><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr class="hideacccrate">

<td align="center"><label for="acc1_packwidth"></label>
<input name="acc1_packwidth" type="text" id="acc1_packwidth" size="3" maxlength="6" value="<%=acc1_packwidth%>" ></td>
<td align="center"><input name="acc1_packheight" type="text" id="acc1_packheight" size="3" maxlength="6" value="<%=acc1_packheight%>"></td>
<td align="center"><input name="acc1_packdepth" type="text" id="acc1_packdepth" size="3" maxlength="6" value="<%=acc1_packdepth%>"></td>
<td align="center"><input name="acc1_packkg" type="text" id="acc1_packkg" size="4" maxlength="6" value="<%=acc1_packkg%>">
</td>
</tr>

<tr class="hideacccrate">
<td align="center">L</td>
<td align="center">H</td>
<td align="center">W</td>
<td align="center">&nbsp;</td>
</tr>
<!-- special crate no.2 -->
<tr class="accspecialcrate2">
  <td colspan="4" align="center" valign="bottom">Crate Type:
<%Set rs3 = getMysqlQueryRecordSet("Select * from shippingbox WHERE (shippingBoxID = 20)", con)%><select name="accCrateType2" id="accCrateType2" onChange="getChangedCrateSize('9','acc2_packwidth','acc2_packheight','acc2_packdepth','acc2_packkg','accCrateType2','acc_crateqty');" >
 <%Do until rs3.eof%>
    <option value="<%=rs3("sName")%>" <%=selected(rs3("sName"), accessoriescrate2)%>><%=rs3("sName")%></option>
 <%rs3.movenext
 loop
 rs3.close
 set rs3=nothing %>
  </select></td>
  </tr>
<tr class="accspecialcrate2"><td colspan="3" align="center" valign="bottom"> Dimensions (cm)</td>
<td align="center" valign="bottom">Kg</td>
</tr>
<tr class="accspecialcrate2">
<td align="center"><label for="acc2_packwidth"></label>
<input name="acc2_packwidth" type="text" id="acc2_packwidth" size="3" maxlength="6" value="<%=acc2_packwidth%>" ></td>
<td align="center"><input name="acc2_packheight" type="text" id="acc2_packheight" size="3" maxlength="6" value="<%=acc2_packheight%>"></td>
<td align="center"><input name="acc2_packdepth" type="text" id="acc2_packdepth" size="3" maxlength="6" value="<%=acc2_packdepth%>"></td>
<td align="center"><input name="acc2_packkg" type="text" id="acc2_packkg" size="4" maxlength="6" value="<%=acc2_packkg%>">
</td>
</tr>

<!-- special crate no.2 -->
<tr class="accspecialcrate2">
<td align="center">L</td>
<td align="center">H</td>
<td align="center">W</td>
<td align="center">&nbsp;</td>
</tr>
<tr class="hideacccrate">
  <td colspan="4" align="center">Crate Qty:
    <label for="acc_crateqty"></label>
    <select name="acc_crateqty" id="acc_crateqty" onChange="crateQtyChanged('9','acc1_packwidth','acc1_packheight','acc1_packdepth','acc1_packkg','accCrateType','acc_crateqty'); crateQtyChanged('9','acc2_packwidth','acc2_packheight','acc2_packdepth','acc2_packkg','accCrateType','acc_crateqty'); disablefield('accCrateType','acc1_packwidth','acc_packheight','acc1_packdepth'); checkSpecialCrateQty('9','accCrateType','acc_crateqty','accspecialcrate2'); " >
      <option value="1" <%=selected(1, accessoriescrateqty)%>>1</option>
      <option value="2" <%=selected(2, accessoriescrateqty)%>>2</option>
    </select></td>
  </tr>


<%'end if
Set rs3 = getMysqlQueryRecordSet("Select * from PackagingData where purchase_no=" & rs("purchase_no") & " and componentid=9", con)
if not rs3.eof then
selectedtext=rs3("PackedWith")
else
selectedtext=""
end if
%>


<tr class="accpackedwithshow">
  <td width="196" colspan="4" align="center">Packed with:<br>
    <label for="accPackedWith"></label>
    <select name="accPackedWith" id="accPackedWith" onClick="getCratePackedWith('9','accPackedWith','accpackedwithcompnofield'); getAccCrateSizes(); showHideAccWrap();">
      <option value="" ></option>
      <option value="0" <%=selected(selectedtext, 0)%> >Nothing</option> 
      <%if rs("topperrequired")="y" then%>
      <option value="5" <%=selected(selectedtext, 5)%>>Topper</option>
      <%end if
	  if rs("baserequired")="y" then%>
      <option value="3" <%=selected(selectedtext, 3)%>>Base</option>
      <%end if
	  if rs("mattressrequired")="y" then%>
      <option value="1" <%=selected(selectedtext, 1)%>>Mattress</option>
       <%end if
       if rs("legsrequired")="y" then%>
      <option value="7" <%=selected(selectedtext, 7)%>>Legs</option>
       <%end if
	   if rs("headboardrequired")="y" then%>
      <option value="8" <%=selected(selectedtext, 8)%>>Headboard</option>
       <%end if
       if rs("valancerequired")="y" then%>
      <option value="6" <%=selected(selectedtext, 6)%>>Valance</option>
       <%end if%>
    </select>
    <input name="accpackedwithcompnofield" id="accpackedwithcompnofield" type="hidden" value="<%=selectedtext%>"></td>
  </tr>
<%
rs3.close
set rs3=nothing
%>
</table>



            </td>
		  </tr>
	</table>
   
  
	

	<p>&nbsp;</p>
</div>
<%end if%>
   </td></tr>
   
</table>
<table>
<tr><td colspan="4"><hr class="linewidth"></td></tr>
<tr><td colspan="4"><b>Delivery Details</b></td></tr>
<tr>
  <td width="162">Access Check Required?</td>
  <td width="388"><%=rs("accesscheck")%>&nbsp;</td>
  <td width="152">Disposal of old bed?</td>
  <td width="238"><%=rs("oldbed")%>&nbsp;</td>
</tr>

<tr>
  <td>Special delivery instructions&nbsp;</td>
  <td><%=rs("specialinstructionsdelivery")%></td>
  <td>Delivery <%=getCurrencySymbolForCurrency(orderCurrency)%></td>
  <td><%=rs("deliveryprice")%></td>
</tr>

</table>
<%if retrieveuserlocation=1 or retrieveuserlocation=3 or retrieveuserlocation=23 or retrieveuserlocation=5 or retrieveuserlocation=4 or retrieveuserlocation=24 or retrieveuserlocation=27 or userHasRole("REGIONAL_ADMINISTRATOR") then%>
<table width="90%" border="0" cellspacing="2" cellpadding="1">
  <tr>
    <td><hr /><strong><br>
      Click or Drag to upload files for this order<br>
        <br>
Exit Shots Only:</strong><br />
	<%
		dzType = "exit"
		%>
		<!-- #include file="dropzone_include.asp" --><br /><hr />&nbsp;</td>
  </tr>
</table>
<%end if%>
</form>



</div>  <!-- end mainformdiv -->
<p>&nbsp;</p><p>&nbsp;</p>
<script Language="JavaScript" type="text/javascript">
function delayedSubmitDisable() {
  if (document.form1.submit2) {
	document.form1.submit2.disabled = true;  
  }
  if (document.form1.submit3) {
	document.form1.submit3.disabled = true;  
  }
}

$(document).ready(init());
function init() {
	
<% if mattbcwwarehouse <> "" then %>
	$("#matbay option[value='40']").hide();
<%end if%>
<% if basebcwwarehouse <> "" then %>
	$("#basebay option[value='40']").hide();
<%end if%>
<% if topperbcwwarehouse <> "" then %>
	$("#topperbay option[value='40']").hide();
<%end if%>
<% if headboardbcwwarehouse <> "" then %>
	$("#headboardbay option[value='40']").hide();
<%end if%>
<% if legsbcwwarehouse <> "" then %>
	$("#legsbay option[value='40']").hide();
<%end if%>
<% if valancebcwwarehouse <> "" then %>
	$("#valancebay option[value='40']").hide();
<%end if%>

	$('.mattspecialcrate2').hide();
	$('.basespecialcrate2').hide();
	$('.topperspecialcrate2').hide();
	$('.hbspecialcrate2').hide();
	$('.legsspecialcrate2').hide();
	$('.valancespecialcrate2').hide();
	$('.legspackedwithshow').hide();
	$('.valancepackedwithshow').hide();
	$('.accpackedwithshow').hide();
	<%if legsPackedWithCheck="checked" then%>
	CrateOrPack('nolegcrate','legspackedwithshow','hidelegcrate','legsspecialcrate2','legs1_packwidth','legs1_packheight','legs1_packdepth','legs1_packkg','7','legsPackedWith','legspackedwithcompnofield','legsCrateType','legs_crateqty','legsCrateType2');
	<%end if%>
	<%if valancePackedWithCheck="checked" then%>
	CrateOrPack('novalancecrate','valancepackedwithshow','hidevalancecrate','valancespecialcrate2','valance1_packwidth','valance1_packheight','valance1_packdepth','valance1_packkg','6','valancePackedWith','valancepackedwithcompnofield','valanceCrateType','valance_crateqty','valanceCrateType2');
	<%end if%>
	<%if accPackedWithCheck="checked" then
	%>
	CrateOrPack('noacccrate','accpackedwithshow','hideacccrate','accspecialcrate2','acc1_packwidth','acc1_packheight','acc1_packdepth','acc1_packkg','9','accPackedWith','accpackedwithcompnofield','accCrateType','acc_crateqty','accCrateType2');
	<%end if%>

	
	defaultAreaProductionDates();
	tickingSelected();
	$('#minus1').hide();
	$('#plus1').show();
	checkWrapShow();
	checkCrateShow();
	checkWrapType();
	 
	<%if (rs("mattressrequired")="y" or rs("baserequired")="y" or rs("topperrequired")="y") and rs("legsrequired")="y"  then%>
	//$('.legspackedwithshow').show();
	//$('.valancepackedwithshow').show();
	<%end if%>
	
	$("#tickingoptions").change(tickingSelected);
	headboardstyle();
	manhattanTrimOptions();
	$("#headboardstyle").change(headboardstyle);
	$("#headboardstyle").change(setHeadboardHeightOptions);
	$("#headboardstyle").change(setLegStyleOptions);
	$("#headboardstyle").change(manhattanTrimOptions);
	setMattressTypes("<%=rs("mattresstype")%>");
	setLinkPosition("<%=rs("linkposition")%>");
	showLegStylePriceField();
	mattressChanged();
	topperChanged();
	baseChanged();
	headboardChanged();
	valanceChanged();
	legsChanged();
	accessoriesChanged();
	deliveryChanged();
	setGiftLetter();
	<% if rs("mattressrequired")="y" then %>
defaultCrateSize('1','matt1_packwidth','matt1_packheight','matt1_packdepth','matt1_packkg','mattressCrateType','matt_crateqty', true);
defaultCrateSize('1','matt2_packwidth','matt2_packheight','matt2_packdepth','matt2_packkg','mattressCrateType2','matt2_crateqty', true);
defaultBoxSize('1','matt1boxsize','matt1kg','matt2boxsize','matt2kg', true);
<% end if %>
<% if rs("baserequired")="y" then %>
defaultCrateSize('3','base1_packwidth','base1_packheight','base1_packdepth','base1_packkg',' ','base_crateqty', true);
defaultCrateSize('3','base2_packwidth','base2_packheight','base2_packdepth','base2_packkg','baseCrateType2','base2_crateqty', true);
defaultBoxSize('3','base1boxsize','base1kg','base2boxsize','base2kg', true);
<% end if %>
<% if rs("topperrequired")="y" then %>
defaultCrateSize('5','topper1_packwidth','topper1_packheight','topper1_packdepth','topper1_packkg','topperCrateType','topper_crateqty', true); defaultCrateSize('5','topper2_packwidth','topper2_packheight','topper2_packdepth','topper2_packkg','topperCrateType2','topper_crateqty', true);
defaultBoxSize('5','topper1boxsize','topper1kg','','', true);
<% end if %>
<% if rs("valancerequired")="y" then %>
defaultCrateSize('6','valance1_packwidth','valance1_packheight','valance1_packdepth','valance1_packkg','valanceCrateType','valance_crateqty', true); defaultCrateSize('6','valance2_packwidth','valance2_packheight','valance2_packdepth','valance2_packkg','valanceCrateType2','valance_crateqty', true);
defaultBoxSize('6','valance1boxsize','valance1kg','','', true);
<% end if %>
<% if rs("legsrequired")="y" then %>
defaultCrateSize('7','legs1_packwidth','legs1_packheight','legs1_packdepth','legs1_packkg','legsCrateType','legs_crateqty', true); defaultCrateSize('7','legs2_packwidth','legs2_packheight','legs2_packdepth','legs2_packkg','legsCrateType2','legs_crateqty', true);
defaultBoxSize('7','legs1boxsize','legs1kg','','', true);
<% end if %>
<% if rs("headboardrequired")="y" then %>
defaultCrateSize('8','hb1_packwidth','hb1_packheight','hb1_packdepth','hb1_packkg','hbCrateType','hb_crateqty', true); defaultCrateSize('8','hb2_packwidth','hb2_packheight','hb2_packdepth','hb2_packkg','hbCrateType','hb_crateqty', true);
defaultBoxSize('8','hb1boxsize','hb1kg','','', true);
<% end if %>
<% if rs("accessoriesrequired")="y" then %>
defaultCrateSize('9','acc1_packwidth','acc1_packheight','acc1_packdepth','acc1_packkg','accCrateType','acc_crateqty', true); defaultCrateSize('9','acc2_packwidth','acc2_packheight','acc2_packdepth','acc2_packkg','accCrateType','acc_crateqty', true);
defaultBoxSize('9','acc1boxsize','acc1kg','','', true);
<% end if %>

disablefield('mattressCrateType','matt1_packwidth','matt1_packheight','matt1_packdepth');
disablefield('baseCrateType','base1_packwidth','base1_packheight','base1_packdepth');
disablefield('topperCrateType','topper1_packwidth','topper1_packheight','topper1_packdepth');
disablefield('hbCrateType','hb1_packwidth','hb1_packheight','hb1_packdepth');
disablefield('legsCrateType','legs1_packwidth','legs1_packheight','legs1_packdepth');
disablefield('valanceCrateType','valance1_packwidth','valance1_packheight','valance1_packdepth');
disablefield('accCrateType','acc1_packwidth','acc1_packheight','acc1_packdepth');
<%if rs("wrappingid")="4" then%>
getCratePackedWithInit('7','legsPackedWith','legspackedwithcompnofield');
getCratePackedWithInit('6','valancePackedWith','valancepackedwithcompnofield');
getCratePackedWithInit('9','accPackedWith','accpackedwithcompnofield');
<%end if%>
<%if savedlegweight="" then%>
	getCratePackedWith('7','legsPackedWith','legspackedwithcompnofield');
<%end if%>
<%if savedvalanceweight="" then%>
	getCratePackedWith('6','valancePackedWith','valancepackedwithcompnofield'); 
<%end if%>
<%if savedaccweight="" then%>
	getCratePackedWith('9','accPackedWith','accpackedwithcompnofield');
<%end if%>
if (defaultBoxPackedWith('6', 'valanceBoxPackedWith')) {
	getBoxPackedWith('6','valanceBoxPackedWith');
}
<%
Set rs3 = getMysqlUpdateRecordSet("select * from orderaccessory where purchase_no=" & order & " order by orderaccessory_id", con)
if not rs3.eof then
do until rs3.eof
%>
if (defaultBoxPackedWith('9', 'accBoxPackedWith')) {
	getBoxPackedWith('9','accBoxPackedWith',<%=rs3("orderaccessory_id")%>);
}
<%rs3.movenext
loop
end if
rs3.close
set rs3=nothing%>

	<% if isCancelled or isComplete then %>
		// order is cancelled or complete, so make readonly
		$('#form1 input').attr('disabled', 'disabled');
		$('#form1 textarea').attr('disabled', 'disabled');
		$('#form1 select').attr('disabled', 'disabled');
	<% end if %>
	
	disableComponentSections();
	
	enableWrapDropdown();
	 disableWrapDropdown();
	
	<% if rs("completedorders") <> "n" then %>
		disableWholeForm();
	<% end if %>
	
	defaultComponentProductionDates(false);

	<% if salesOnly then %>
		// mostly read only for sales (showrooms)
		$('#mainformdiv :input').attr('disabled', true);
		$('#baseconfirmeddate').attr('disabled', false);
		$('#headboardconfirmeddate').attr('disabled', false);
		$('#purchaseno').attr('disabled', false);
		$('#baseqc_orig').attr('disabled', false);
		$('#Save').attr('disabled', false);
		$('.callink').hide();
	<% end if %>
	
	showHideExWorks('exworksmatt', 'mattressdelmethod', 'exworksdatematt');
	showHideExWorks('exworksbase', 'basedelmethod', 'exworksdatebase');
	showHideExWorks('exworkstopper', 'topperdelmethod', 'exworksdatetopper');
	showHideExWorks('exworksheadboard', 'headboarddelmethod', 'exworksdatehb');
	showHideExWorks('exworkslegs', 'legsdelmethod', 'exworksdatelegs');
	showHideExWorks('exworksvalance', 'valancedelmethod', 'exworksdatevalance');
	showHideExWorks('exworksacc', 'accdelmethod', 'exworksdateacc');
	
	// show/hide the accessories wrap div and it's contents
	showHideAccWrap();
	
}

function setBalanceAlert() {
	var message;
	var curr = "<%=getCurrencySymbolForCurrency(orderCurrency)%>";
	var decoded = $("<div/>").html(curr).text();
	var outstanding="<%=rs("balanceoutstanding")%>";
	if (outstanding>0) {
	message = "OUTSTANDING BALANCE REMINDER\n\nan outstanding balance of " + decoded + "<%=rs("balanceoutstanding")%> remains";
    alert(message);
	}
}



function orderHasComponent(compId) {
	<% if rs("mattressrequired") = "y" then %>
	if (compId == 1) return true;
	<% end if %>
	<% if rs("baserequired") = "y" then %>
	if (compId == 3) return true;
	<% end if %>
	<% if rs("topperrequired") = "y" then %>
	if (compId == 5) return true;
	<% end if %>
	<% if rs("valancerequired") = "y" then %>
	if (compId == 6) return true;
	<% end if %>
	<% if rs("legsrequired") = "y" then %>
	if (compId == 7) return true;
	<% end if %>
	<% if rs("headboardrequired") = "y" then %>
	if (compId == 8) return true;
	<% end if %>
	<% if rs("accessoriesrequired") = "y" then %>
	if (compId == 9) return true;
	<% end if %>
}

function getPanelContent(contactno, panelId) {
	var divId = "panel1";
    var url = "searchresults-onecustomer-orderdetails.asp?contactno=" + contactno + "&pno=" + <%=order%> + "&pg=o&ts=" + (new Date()).getTime();
    //console.log(url);pn
    $('#' + divId).load(url);
	$('#' + divId).show("slow");
	$('#minus1').show();
	$('#plus1').hide();
}

function formSubmitHandler(theForm) {
	var valid = FrontPage_Form1_Validator(theForm);
	if (!valid) {
		return false;
	}
	enableComponentSections();
	return true;
}


function FrontPage_Form1_Validator(theForm) {
	if (theForm.mattfinished && theForm.mattfinished.value=="" && theForm.mattressqc.value > 49 && theForm.mattressqc.value < 71) 
	   { 
	      alert('Please enter mattress finish date') 
	      theForm.mattfinished.focus();
	      return false; 
	      } 
	if (theForm.basefinished && theForm.basefinished.value=="" && theForm.baseqc.value > 49 && theForm.baseqc.value < 71) 
	   { 
	      alert('Please enter base finish date') 
	      theForm.basefinished.focus();
	      return false; 
	      } 
	if (theForm.topperfinished && theForm.topperfinished.value=="" && theForm.topperstatus.value > 49 && theForm.topperstatus.value < 71) 
	   { 
	      alert('Please enter topper finish date') 
	      theForm.topperfinished.focus();
	      return false; 
	      } 
	if (theForm.headboardfinished && theForm.headboardfinished.value=="" && theForm.headboardstatus.value > 49 && theForm.headboardstatus.value < 71) 
	   { 
	      alert('Please enter headboard finish date') 
	      theForm.headboardfinished.focus();
	      return false; 
	      } 
	if (theForm.legsfinished && theForm.legsfinished.value=="" && theForm.legsstatus.value > 49 && theForm.legsstatus.value < 71) 
	   { 
	      alert('Please enter legs finish date') 
	      theForm.legsfinished.focus();
	      return false; 
	      } 

	if (theForm.valancefinished && theForm.valancefinished.value=="" && theForm.valancestatus.value > 49 && theForm.valancestatus.value < 71) 
	   { 
	      alert('Please enter valance finish date') 
	      theForm.valancefinished.focus();
	      return false; 
	      } 
		  	  
	if (theForm.mattbcwexpected && theForm.mattbcwexpected.value=="" && theForm.mattressqc.value > 19 && theForm.mattressqc.value < 70) 
	   { 
	      alert('Please enter mattress production date') 
	      theForm.mattbcwexpected.focus();
	      return false; 
	      } 
	if (theForm.basebcwexpected && theForm.basebcwexpected.value=="" && theForm.baseqc.value > 19 && theForm.baseqc.value < 70) 
	   { 
	      alert('Please enter base production date') 
	      theForm.basebcwexpected.focus();
	      return false; 
	      } 
	if (theForm.headboardbcwexpected && theForm.headboardbcwexpected.value=="" && theForm.headboardstatus.value > 19 && theForm.headboardstatus.value < 70) 
	   { 
	      alert('Please enter headboard production date') 
	      theForm.headboardbcwexpected.focus();
	      return false; 
	      } 	
	 if (theForm.topperbcwexpected && theForm.topperbcwexpected.value=="" && theForm.topperstatus.value > 19 && theForm.topperstatus.value < 70) 
	   { 
	      alert('Please enter topper production date') 
	      theForm.topperbcwexpected.focus();
	      return false; 
	      } 		
	 if (theForm.valancebcwexpected && theForm.valancebcwexpected.value=="" && theForm.valancestatus.value > 19 && theForm.valancestatus.value < 70) 
	   { 
	      alert('Please enter valance production date') 
	      theForm.valancebcwexpected.focus();
	      return false; 
	      } 
	 if (theForm.legsbcwexpected && theForm.legsbcwexpected.value=="" && theForm.legsstatus.value > 19 && theForm.legsstatus.value < 70) 
	   { 
	      alert('Please enter legs production date') 
	      theForm.legsbcwexpected.focus();
	      return false; 
	      }		  
	
	if (theForm.tickingbatchno && !IsNumeric(theForm.tickingbatchno.value)) 
	   { 
	      alert('Please enter only numbers for mattress ticking batch number') 
	      theForm.tickingbatchno.focus();
	      return false; 
	      } 
	if (theForm.boxtickingbatchno && !IsNumeric(theForm.boxtickingbatchno.value)) 
	   { 
	      alert('Please enter only numbers for box ticking batch number') 
	      theForm.boxtickingbatchno.focus();
	      return false; 
	      } 
	if (theForm.ordernote_followupdate && theForm.ordernote_notetext && theForm.ordernote_followupdate.value != "" && theForm.ordernote_notetext.value == "") {
		alert('Please enter a note');
		theForm.ordernote_notetext.focus();
		return false; 
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


	$('#ordernote_followupdate').blur(function() {
		calendarBlurHandler(document.form1.ordernote_followupdate);
	});
	
	function getCurrSym() {
		return '<%=getCurrencySymbolForCurrency(orderCurrency)%>';
	}
	

// accessories stuff
for (var i = 1; i < 21; i++) {
	$('#acc_unitprice'+i).blur(function() {
		calcAccessoriesTotal();
		showNextAccessoriesRow();
	});
	$('#acc_qty'+i).change(function() {
		calcAccessoriesTotal();
	});
	$('#acc_desc'+i).change(function() {
		showNextAccessoriesRow();
	});
}






$("#delphonetype1").eComboBox({
	'editableElements' : false
});
$("#delphonetype2").eComboBox({
	'editableElements' : false
});
$("#delphonetype3").eComboBox({
	'editableElements' : false
});

$('#form1 input').change(function() {
    logChange($(this));
});

$('#form1 select').change(function() {
    logChange($(this));
});

$('#form1 textarea').change(function() {
    logChange($(this));
});


function FrontPage_Form2_Validator(theForm)
{

 if (theForm.deltime.value == "")
  {
    alert("Please enter a delivery time");
    theForm.deltime.focus();
    return (false);
  }
  if (theForm.deliveredby.value == "")
  {
    alert("Please enter delivery name");
    theForm.deliveredby.focus();
    return (false);
  }
return true;
}

function enableWrapDropdown() {
	<% if ((getComponentStatus(con, order, 1) < 11) and (getComponentStatus(con, order, 3) < 11) and (getComponentStatus(con, order, 5) < 11) and (getComponentStatus(con, order, 7) < 11) and (getComponentStatus(con, order, 8) < 11)) then %>
		//$('#wtype :input').attr('enabled', true);
		//$('#wtype :input').css('color', 'black');
		//$("#wraptype option[value='2']").prop("disabled","disabled");

	<% end if %>
}


function disableComponentSections() {
	// mattress status
	<% if getComponentStatus(con, order, 1) > 10 then %>
		$('#matt1 :input').attr('disabled', true);
		$('#matt1 :input').css('color', 'red');
	<% end if %>

	// topper
	<% if getComponentStatus(con, order, 5) > 10 then %>
		$('#topp1 :input').attr('disabled', true);
		$('#topp1 :input').css('color', 'red');
	<% end if %>

	// base
	<% if getComponentStatus(con, order, 3) > 10 then %>
		$('#base1 :input').attr('disabled', true);
		$('#base1 :input').css('color', 'red');
	<% end if %>

	// headboard
	<% if getComponentStatus(con, order, 8) > 10 then %>
		$('#head1 :input').attr('disabled', true);
		$('#head1 :input').css('color', 'red');
	<% end if %>

	// valance
	<% if getComponentStatus(con, order, 6) > 10 then %>
		$('#valance1 :input').attr('disabled', true);
		$('#valance1 :input').css('color', 'red');
	<% end if %>

	// accessories
	<% Dim accessoriesstatus2
		accessoriesstatus2=getComponentStatus(con, order, 9)
		
		
	if accessoriesstatus2=10 or accessoriesstatus2=100 or accessoriesstatus2=40 or accessoriesstatus2=120 or accessoriesstatus2=50 or accessoriesstatus2=0 then 
	else %>
		$('#accessory1 :input').attr('disabled', true);
		$('#accessory1 :input').css('color', 'red');
	<% end if %>

	// legs
	<% if getComponentStatus(con, order, 7) > 10 then %>
		$('#legs1 :input').attr('disabled', true);
		$('#legs1 :input').css('color', 'red');
	<% end if %>
}
function disableWrapDropdown() {
	<% if ((getComponentStatus(con, order, 1) > 10) or (getComponentStatus(con, order, 3) > 10) or (getComponentStatus(con, order, 5) > 10) or (getComponentStatus(con, order, 6) > 10) or (getComponentStatus(con, order, 7) > 10) or (getComponentStatus(con, order, 8) > 10) or (getComponentStatus(con, order, 9) > 10)) then 
     if defaultwrappingid="1" then %>
	 $("#wraptype option[value='2']").prop("disabled","disabled");
	 $("#wraptype option[value='3']").prop("disabled","disabled");
	 $("#wraptype option[value='4']").prop("disabled","disabled");
	 <%end if
	 if defaultwrappingid="2" then %>
	 $("#wraptype option[value='1']").prop("disabled","disabled");
	 $("#wraptype option[value='3']").prop("disabled","disabled");
	 $("#wraptype option[value='4']").prop("disabled","disabled");
	 <%end if
	 if defaultwrappingid="3" then %>
	 $("#wraptype option[value='2']").prop("disabled","disabled");
	 $("#wraptype option[value='1']").prop("disabled","disabled");
	 $("#wraptype option[value='4']").prop("disabled","disabled");
	 <%end if
	 if defaultwrappingid="4" then %>
	 $("#wraptype option[value='2']").prop("disabled","disabled");
	 $("#wraptype option[value='3']").prop("disabled","disabled");
	 $("#wraptype option[value='1']").prop("disabled","disabled");
	 <%end if%>
 <%end if%>
}

function defaultComponentProductionDates(mainProdDateChanged) {
	var mainProdDate = $('#productiondate').val();
	var mattstatus=$('#mattressqc').val();
	var mattmadeat=$('#mattressmadeat').val();
	var basestatus=$('#baseqc').val();
	var basemadeat=$('#basemadeat').val();
	var topperstatus=$('#topperstatus').val();
	var toppermadeat=$('#toppermadeat').val();
	var valancestatus=$('#valancestatus').val();
	var valancemadeat=$('#valancemadeat').val();
	var hbstatus=$('#headboardstatus').val();
	var hbmadeat=$('#headboardmadeat').val();
	var legsstatus=$('#legsstatus').val();
	var legsmadeat=$('#legsmadeat').val();
	
	if (mainProdDate && mainProdDate != '') {
		<% if rs("mattressrequired")="y" then %>
			//console.log(mattmadeat);
			if (mattstatus > 19) {
			defaultSingleComponentProductionDate(mainProdDate, 'mattbcwexpected');
			}
		<% end if %>
		<% if rs("baserequired")="y" then %>
			//console.log("baserequired");
			if (basestatus > 19) {
			defaultSingleComponentProductionDate(mainProdDate, 'basebcwexpected');
			}
		<% end if %>
		<% if rs("topperrequired")="y" then %>
			//console.log("topperrequired");
			if (topperstatus > 19) {
			defaultSingleComponentProductionDate(mainProdDate, 'topperbcwexpected');
			}
		<% end if %>
		<% if rs("headboardrequired")="y" then %>
			//console.log("headboardrequired");
			if (headboardstatus > 19) {
			defaultSingleComponentProductionDate(mainProdDate, 'headboardbcwexpected');
			}
		<% end if %>
		<% if legstylecheck="y" then %>
			//console.log("legsrequired");
			if (legsstatus > 19) {
			defaultSingleComponentProductionDate(mainProdDate, 'legsbcwexpected');
			}
		<% end if %>
		<% if rs("valancerequired")="y" then %>
			//console.log("valancerequired");
			if (valancestatus > 19) {
			defaultSingleComponentProductionDate(mainProdDate, 'valancebcwexpected');
			}
		<% end if %>
		<% if rs("accessoriesrequired")="y" then %>
			//console.log("accessoriesrequired");
			defaultSingleComponentProductionDate(mainProdDate, 'accessoriesbcwexpected');
		<% end if %>
		
	}
}


function defaultAreaProductionDates() {
	var mainProdDate = $('#productiondate').val();
	if (mainProdDate != '') {
		var mainproddateTemp = swapUkUsDateString(mainProdDate);
		mainproddateTemp = Date.parse(mainproddateTemp);
	}
	
	<%if rs("londonproductiondate")="" or isNull(rs("londonproductiondate")) then%>
	var mainLondonProdDateOrig = $('#londonproductiondate').val();
	<%else%>
	var mainLondonProdDateOrig = '<%=rs("londonproductiondate")%>';
	<%end if%>
	
	<%if rs("cardiffproductiondate")="" or isNull(rs("cardiffproductiondate")) then%>
	var mainCardiffProdDateOrig = $('#cardiffproductiondate').val();
	<%else%>
	var mainCardiffProdDateOrig = '<%=rs("cardiffproductiondate")%>';
	<%end if%>
	//console.log("mainCardiffProdDate=" + mainCardiffProdDate + "<br>");
	var mattstatus=$('#mattressqc').val();
	var mattmadeat=$('#mattressmadeat').val();
	var mattproddate=$('#mattbcwexpected').val();
	var mattproddateOrig=mattproddate;
		
		mattproddate = swapUkUsDateString(mattproddate);
		mattproddate = Date.parse(mattproddate);
	
	var basestatus=$('#baseqc').val();
	var basemadeat=$('#basemadeat').val();
	var baseproddate=$('#basebcwexpected').val();
	var baseproddateOrig=baseproddate;
		
		baseproddate = swapUkUsDateString(baseproddate);
		baseproddate = Date.parse(baseproddate);
		
	var topperstatus=$('#topperstatus').val();
	var toppermadeat=$('#toppermadeat').val();
	var topperproddate=$('#topperbcwexpected').val();
	var topperproddateOrig=topperproddate;
		
		topperproddate = swapUkUsDateString(topperproddate);
		topperproddate = Date.parse(topperproddate);
		
	var valancestatus=$('#valancestatus').val();
	var valancemadeat=$('#valancemadeat').val();
	var valanceproddate=$('#valancebcwexpected').val();
	var valanceproddateOrig=valanceproddate;
		
		valanceproddate = swapUkUsDateString(valanceproddate);
		valanceproddate = Date.parse(valanceproddate);
		
	var hbstatus=$('#headboardstatus').val();
	var hbmadeat=$('#headboardmadeat').val();
	var hbproddate=$('#headboardbcwexpected').val();
	var hbproddateOrig=hbproddate;
		
		hbproddate = swapUkUsDateString(hbproddate);
		hbproddate = Date.parse(hbproddate);
		
	var legsstatus=$('#legsstatus').val();
	var legsmadeat=$('#legsmadeat').val();
	var legsproddate=$('#legsbcwexpected').val();
	var legsproddateOrig=legsproddate;
		
		legsproddate = swapUkUsDateString(legsproddate);
		legsproddate = Date.parse(legsproddate);
		
	var londonProdDateExists='false';
	var CardiffProdDateExists='false';
	
	if (mainLondonProdDateOrig && mainLondonProdDateOrig != '') {
		var mainLondonProdDate = swapUkUsDateString(mainLondonProdDate);
		mainLondonProdDate = Date.parse(mainLondonProdDate);
	}
	if (mainCardiffProdDateOrig && mainCardiffProdDateOrig != '') {
		var mainCardiffProdDate = swapUkUsDateString(mainCardiffProdDate);
		mainCardiffProdDate = Date.parse(mainCardiffProdDate);
	}
	
		<% if rs("mattressrequired")="y" then %>
			if (mattstatus > 19 && mattmadeat==2 && mattproddate && mattproddate !='') {
				londonProdDateExists='true';
				if (!mainLondonProdDate || mainLondonProdDate == '') {
					mainLondonProdDateOrig=mattproddateOrig;
				} else {
					if (mattproddate > mainLondonProdDate) {
					mainLondonProdDate=mattproddate;
					mainLondonProdDateOrig=mattproddateOrig;
					} 
				}
				
			}
			//console.log("londonProdDateExists=" + londonProdDateExists);
			if (mattstatus > 19 && mattmadeat==1 && mattproddate && mattproddate !='') {
				CardiffProdDateExists='true';
				if (!mainCardiffProdDate || mainCardiffProdDate == '') {
					mainCardiffProdDateOrig=mattproddateOrig;
				} else {
					if (mattproddate > mainCardiffProdDate) {
					mainCardiffProdDate=mattproddate;
					mainCardiffProdDateOrig=mattproddateOrig;
					} 
				}
				
			}
		<% end if %>
		<% if rs("baserequired")="y" then %>
		//console.log("mainCardiffProdDate=" + mainCardiffProdDate + " baseproddate=" + baseproddate);
			if (basestatus > 19 && basemadeat==2 && baseproddate && baseproddate !='') {
				londonProdDateExists='true';
				if (!mainLondonProdDate || mainLondonProdDate == '') {
					mainLondonProdDateOrig=baseproddateOrig;
				} else {
					if (baseproddate > mainLondonProdDate) {
					mainLondonProdDate=baseproddate;
					mainLondonProdDateOrig=baseproddateOrig;
					}
				}
				
			}
			if (basestatus > 19 && basemadeat==1 && baseproddate && baseproddate !='') {
				CardiffProdDateExists='true';
				if (!mainCardiffProdDate || mainCardiffProdDate == '') {
					mainCardiffProdDateOrig=baseproddateOrig;
				} else {
					if (baseproddate > mainCardiffProdDate) {
					mainCardiffProdDate=baseproddate;
					mainCardiffProdDateOrig=baseproddateOrig;
					} 
				}
				
			}
		<% end if %>
		<% if rs("topperrequired")="y" then %>
			if (topperstatus > 19 && toppermadeat==2 && topperproddate && topperproddate !='') {
				londonProdDateExists='true';
				if (!mainLondonProdDate || mainLondonProdDate == '') {
					mainLondonProdDateOrig=topperproddateOrig;
				} else {
					if (topperproddate > mainLondonProdDate) {
					mainLondonProdDate=topperproddate;
					mainLondonProdDateOrig=topperproddateOrig;
					}
				}
				
			}
			if (topperstatus > 19 && toppermadeat==1 && topperproddate && topperproddate !='') {
				CardiffProdDateExists='true';
				if (!mainCardiffProdDate || mainCardiffProdDate == '') {
					mainCardiffProdDateOrig=topperproddateOrig;
				} else {
					if (topperproddate > mainCardiffProdDate) {
					mainCardiffProdDate=topperproddate;
					mainCardiffProdDateOrig=topperproddateOrig;
					} 
				}
				
			}
		<% end if %>
		<% if rs("headboardrequired")="y" then %>
		//console.log("mainCardiffProdDate=" + mainCardiffProdDate + " baseproddate=" + baseproddate);
			if (hbstatus > 19 && hbmadeat==2 && hbproddate && hbproddate !='') {
				londonProdDateExists='true';
				if (!mainLondonProdDate || mainLondonProdDate == '') {
					mainLondonProdDateOrig=hbproddateOrig;
				} else {
					if (hbproddate > mainLondonProdDate) {
					mainLondonProdDate=hbproddate;
					mainLondonProdDateOrig=hbproddateOrig;
					}
				}
				
			}
			if (hbstatus > 19 && hbmadeat==1 && hbproddate && hbproddate !='') {
				CardiffProdDateExists='true';
				if (!mainCardiffProdDate || mainCardiffProdDate == '') {
					mainCardiffProdDateOrig=hbproddateOrig;
				} else {
					if (hbproddate > mainCardiffProdDate) {
					mainCardiffProdDate=hbproddate;
					mainCardiffProdDateOrig=hbproddateOrig;
					} 
				}
				
			}
		<% end if %>
		<% if rs("legsrequired")="y" then %>
		//console.log("mainCardiffProdDate=" + mainCardiffProdDate + " baseproddate=" + baseproddate);
			if (legsstatus > 19 && legsmadeat==2 && legsproddate && legsproddate !='') {
				londonProdDateExists='true';
				if (!mainLondonProdDate || mainLondonProdDate == '') {
					mainLondonProdDateOrig=legsproddateOrig;
				} else {
					if (legsproddate > mainLondonProdDate) {
					mainLondonProdDate=legsproddate;
					mainLondonProdDateOrig=legsproddateOrig;
					}
				}
				
			}
			if (legsstatus > 19 && legsmadeat==1 && legsproddate && legsproddate !='') {
				CardiffProdDateExists='true';
				if (!mainCardiffProdDate || mainCardiffProdDate == '') {
					mainCardiffProdDateOrig=legsproddateOrig;
				} else {
					if (legsproddate > mainCardiffProdDate) {
					mainCardiffProdDate=legsproddate;
					mainCardiffProdDateOrig=legsproddateOrig;
					} 
				}
				
			}
		<% end if %>
		<% if rs("valancerequired")="y" then %>
		//console.log("mainCardiffProdDate=" + mainCardiffProdDate + " baseproddate=" + baseproddate);
			if (valancestatus > 19 && valancemadeat==2 && valanceproddate && valanceproddate !='') {
				londonProdDateExists='true';
				if (!mainLondonProdDate || mainLondonProdDate == '') {
					mainLondonProdDateOrig=valanceproddateOrig;
				} else {
					if (valanceproddate > mainLondonProdDate) {
					mainLondonProdDate=valanceproddate;
					mainLondonProdDateOrig=valanceproddateOrig;
					}
				}
				
			}
			if (valancestatus > 19 && valancemadeat==1 && valanceproddate && valanceproddate !='') {
				CardiffProdDateExists='true';
				if (!mainCardiffProdDate || mainCardiffProdDate == '') {
					mainCardiffProdDateOrig=valanceproddateOrig;
				} else {
					if (valanceproddate > mainCardiffProdDate) {
					mainCardiffProdDate=valanceproddate;
					mainCardiffProdDateOrig=valanceproddateOrig;
					} 
				}
				
			}
		<% end if %>
		
		if (mainLondonProdDateOrig && mainLondonProdDateOrig != '') {
			mainLondonProdDate = swapUkUsDateString(mainLondonProdDateOrig);
			mainLondonProdDate = Date.parse(mainLondonProdDate);
		}
		if (mainCardiffProdDateOrig && mainCardiffProdDateOrig != '') {
			mainCardiffProdDate = swapUkUsDateString(mainCardiffProdDateOrig);
			mainCardiffProdDate = Date.parse(mainCardiffProdDate);
		}
		if (mainCardiffProdDate > mainLondonProdDate) {
			$('#productiondate').val(mainCardiffProdDateOrig);
		} 
		
		if (mainLondonProdDate > mainCardiffProdDate) {
			$('#productiondate').val(mainLondonProdDateOrig);
		}
		
		
		$('#londonproductiondate').val(mainLondonProdDateOrig);
		$('#cardiffproductiondate').val(mainCardiffProdDateOrig);
		
		if (londonProdDateExists=='false') {
			$('#londonproductiondate').val('');
		}
		if (CardiffProdDateExists=='false') {
			$('#cardiffproductiondate').val('');
		}
		//console.log("londonProdDateExists=" + londonProdDateExists);
		//console.log("CardiffProdDateExists=" + CardiffProdDateExists);
}



function calendarBlurHandler(ctrl) {
	if (ctrl.name == 'productiondate') {
		defaultComponentProductionDates(true);
	} else if (ctrl.name == 'mattbcwexpected' 
		|| ctrl.name == 'basebcwexpected'
		|| ctrl.name == 'topperbcwexpected'
		|| ctrl.name == 'headboardbcwexpected'
		|| ctrl.name == 'legsbcwexpected'
		|| ctrl.name == 'valancebcwexpected'
		|| ctrl.name == 'accessoriesbcwexpected') {
			componentProductionDateUpdateHandler(ctrl.name);
			defaultAreaProductionDates();
	} else if (ctrl.name == 'ordernote_followupdate') {
		$("#ordernote_action option[value='<%=ACTION_REQUIRED%>']").attr('selected', 'selected');
	} else if (ctrl.name == 'mattfinished') {
		checkAllMattDatesCompleted();
	} else if (ctrl.name == 'basefinished') {
		checkAllBaseDatesCompleted();
	} else if (ctrl.name == 'topperfinished') {
		checkAllTopperDatesCompleted();
	} else if (ctrl.name == 'headboardfinished') {
		checkAllHeadboardDatesCompleted();
	} else if (ctrl.name == 'legsfinished') {
		checkAllLegsDatesCompleted();
	}
	logChange($('#'+ctrl.name));
}

function showHideExWorks(exWorksDivId, delMthdCtrlId, exWorksDateCtrlId) {
	var exWorksDiv = $('#' + exWorksDivId);
	if (exWorksDiv.length == 0) {
		// exworks div does not exist
		return;
	}

	var delMethodCtrl = $('#' + delMthdCtrlId);
	var isOverseasOrder = <% if rs("overseasOrder")="y" then response.write("true") else response.write("false") %>;
	var delMthd = "";
	if (delMethodCtrl.length > 0) {
		delMthd = delMethodCtrl.val();
	}

	if (isOverseasOrder || delMthd == "6") {
		// del method is overseas export
		exWorksDiv.show();
	} else {
		exWorksDiv.hide();
		var exWorksDateCtrl = $('#' + exWorksDateCtrlId);
		if (exWorksDiv.length > 0) {
			$("#" + exWorksDateCtrlId + " option[value='n']").attr('selected', 'selected');
		}
	}
}



</script>
      
<%



function getOrderType(byref ars)
	dim ars2
	if isnull(ars("ordertype")) or ars("ordertype") = "" then
		getOrderType = "Unknown"
	else
		Set ars2 = getMysqlUpdateRecordSet("Select * from ORDERTYPE where ordertypeid=" & ars("ordertype"), con)
		getOrderType = ars2("ordertype")
		ars2.close
		set ars2 = nothing
	end if
end function
  


%>
<%



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

rs.close
set rs=nothing
Con.Close
Set Con = Nothing
%>
<!-- #include file="common/logger-out.inc" -->
