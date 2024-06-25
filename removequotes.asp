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
<%Dim postcode, postcodefull, Con, rs, rs2, recordfound, id, rspostcode, submit1, submit2, count, envelopecount, i, fieldName, fieldValue, fieldNameArray, type1, sql, correspondencename, contact, orderno
Dim mattressrequired, mattressprice, topperrequired, topperprice, baserequired, legprice, baseprice, upholsteredbase, upholsteryprice, valancerequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd
Dim deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype
Dim basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice
Dim specialinstructionsvalance, specialinstructionsdelivery, localeref, order, selcted, cust, custcode, msg, signature, custname, paymentstotal, dctype, subtotal, dcresult, outstanding
dim basefabriccost, basefabricmeters, basefabricprice, hbfabriccost, hbfabricmeters, hbfabricprice, valfabriccost, valfabricmeters, valfabricprice, paymentmethod, recipientordernumbers, reasonquotedeclined, datequotedeclined
recipientordernumbers=""

'count=0
reasonquotedeclined=Request("reasonquotedeclined")
datequotedeclined=Request("datequotedeclined")
submit1=""
submit1=Request("submit1")
Set Con = getMysqlConnection()
Set rs = getMysqlUpdateRecordSet("Select * from region Where id_region=" & retrieveUserRegion() & "", con)
'Session.LCID=1029
Session.LCID=trim(rs("locale"))
rs.close
set rs=nothing%>



<%If submit1 <> "" AND reasonquotedeclined<>"" AND datequotedeclined<>"" Then
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	fieldNameArray = Split(fieldName, "_")
	type1 = fieldNameArray(1)
Set rs = getMysqlUpdateRecordSet("Select * from purchase Where purchase_no=" & type1, con)
rs("quote")="d"
If datequotedeclined<>"" then rs("datequotedeclined")=datequotedeclined
If reasonquotedeclined<>"" then rs("reasonquotedeclined")=reasonquotedeclined
rs.update
rs.close
set rs=nothing


End If
next
End If
Con.close
set Con=nothing

response.Redirect("quotes.asp?msg=qd")
%>


<!-- #include file="common/logger-out.inc" -->
