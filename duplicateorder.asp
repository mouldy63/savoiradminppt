<%Option Explicit%>
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
<!-- #include file="neworder_funcs.asp" -->
<!-- #include file="emailfuncs.asp" -->

<%
dim con, rs, cols, sql, pn, newPn, origOrderNum, newOrderNum, newOrderRs, newQcHistoryId, url, thePn, ordersource
dim msg, subject, locationname, recepient, pdfcontent

pn = request("pn")
ordersource=request("ordersource")
set con = getMysqlConnection()
con.begintrans

origOrderNum = getOrderNumber(con, pn)
response.write("<br>origOrderNum = " & origOrderNum)

' copy purchase
cols = getTableColumns2(con, "purchase", "PURCHASE_No,customerreference,LAST_SUPPLIED,deliverydate,bookeddeliverydate,delivery_Time,deliveredby,production_completion_date,productiondate,datequotedeclined,reasonquotedeclined,datereinstated,accesscheck,oldbed,acknowdate,acknowversion,cancelled,cancelled_reason,OrderStatusID,FireLabelID,wrappingid,DeliveryTermsID,OrderConfirmationCode,LondonProductionDate,CardiffProductionDate,NOTES,deliverycharge,giftpackrequired,DeliveryDateConfirmed,signature,baseExDisplayRef,mattressExDisplayRef,topperExDisplayRef,headboardExDisplayRef")
response.write("<br>cols = " & cols)
sql = "insert into purchase (" & cols & ") select "
cols = replace(cols, "`completedorders`", "'n'")
cols = replace(cols, "`orderConfirmationStatus`", "'n'")
cols = replace(cols, "`orderonhold`", "'n'")
cols = replace(cols, "`ORDER_DATE`", "now()")
cols = replace(cols, "`AmendedDate`", "now()")
'cols = replace(cols, "`total`", "0.0")
'cols = replace(cols, "`balanceoutstanding`", "0.0")
'cols = replace(cols, "`paymentstotal`", "0.0")
'cols = replace(cols, "`bedsettotal`", "0.0")
'cols = replace(cols, "`subtotal`", "0.0")
'cols = replace(cols, "`accessoriestotalcost`", "0.0")
'cols = replace(cols, "`totalexvat`", "0.0")
'cols = replace(cols, "`vat`", "0.0")
'cols = replace(cols, "`tradediscount`", "0.0")
'cols = replace(cols, "`discount`", "0.0")
'cols = replace(cols, "`tradediscountrate`", "0.0")
response.write("<br>cols = " & cols)

sql = sql & cols & " from purchase where purchase_no=" & pn
response.write("<br>sql = " & sql)
'response.end
con.execute(sql)


' get new purchase_no
newPn = getLastInsertId(con)
response.write("<br>newPn = " & newPn)

' set order_number on new purchase
newOrderNum = getNextOrderNumberNoTransaction(con)
sql = "update purchase set ordersource='" & ordersource & "', order_number='" & newOrderNum & "',copied_from_pn=" & pn & " where purchase_no=" & newPn
con.execute(sql)
response.write("<br>newOrderNum = " & newOrderNum)

' get the new order
set newOrderRs = getMysqlQueryRecordSet("select * from purchase where purchase_no=" & newPn, con)

' copy first qc_history rows with status 0 (awaiting confirmation)
call createHistoryRow(con, pn, newPn, 0)
if newOrderRs("mattressrequired")="y" then
	call createHistoryRow(con, pn, newPn, 1)
end if
if newOrderRs("baserequired")="y" then
	call createHistoryRow(con, pn, newPn, 3)
end if
if newOrderRs("topperrequired")="y" then
	call createHistoryRow(con, pn, newPn, 5)
end if
if newOrderRs("valancerequired")="y" then
	call createHistoryRow(con, pn, newPn, 6)
end if
if newOrderRs("legsrequired")="y" then
	call createHistoryRow(con, pn, newPn, 7)
end if
if newOrderRs("headboardrequired")="y" then
	call createHistoryRow(con, pn, newPn, 8)
end if
if newOrderRs("accessoriesrequired")="y" then
	call createHistoryRow(con, pn, newPn, 9)
end if


' copy order accessories
cols = getTableColumns2(con, "orderaccessory", "orderaccessory_id,PODate,POnumber,Status,ETA,Received,Checked,Delivered")
sql = "insert into orderaccessory (" & cols & ") select " & replace(cols,"`purchase_no`",cstr(newPn)) & " from orderaccessory where purchase_no=" & pn
response.write("<br>sql = " & sql)
con.execute(sql)

' copy order notes (not required by Daryl)
'cols = getTableColumns2(con, "ordernote", "ordernote_id")
'sql = "insert into ordernote (" & cols & ") select " & replace(cols,"`purchase_no`",cstr(newPn)) & " from ordernote where purchase_no=" & pn
'con.execute(sql)
'response.write("<br>sql = " & sql)

' copy phone numbers
cols = getTableColumns2(con, "phonenumber", "phonenumber_id")
sql = "insert into phonenumber (" & cols & ") select " & replace(cols,"`purchase_no`",cstr(newPn)) & " from phonenumber where purchase_no=" & pn
con.execute(sql)
response.write("<br>sql = " & sql)

' copy production sizes
cols = getTableColumns2(con, "productionsizes", "ProductionSizesID")
sql = "insert into productionsizes (" & cols & ") select " & replace(cols,"`Purchase_No`",cstr(newPn)) & " from productionsizes where purchase_no=" & pn
con.execute(sql)
response.write("<br>sql = " & sql)

call closers(newOrderRs)
con.committrans

' send order confirmation email with PDF attachment
'pdfContent = createNewOrderPdf(con, newPn, "n")

Set rs = getMysqlQueryRecordSetWithErrorLogging("Select * from location where idlocation=" & retrieveuserlocation(), con)
locationname = rs("location")
call closeRs(rs)

msg = "<html><body><font face=""Arial, Helvetica, sans-serif"">New Order " & newOrderNum & " has been placed by " & retrieveUserName() & " - " & locationname & " on Savoir Admin.  Please see the attached.</font></body></html>"
subject = "New Order " & newOrderNum & " (duplicated from " & origOrderNum & "),  " & retrieveUserName() & " - " & locationname
if retrieveUserRegion() = 17 or retrieveUserRegion() = 19 then
	recepient = "Pv@savoirbeds.co.uk,da@savoirbeds.co.uk"
else
	recepient = "SavoirAdminNewOrder@savoirbeds.co.uk"
end if
'call sendBatchEmailWithStringAttachment(subject, msg, "noreply@savoirbeds.co.uk", recepient, "order-" & newOrderNum & ".pdf", pdfContent, "", true, con)

call closemysqlcon(con)

url = "edit-purchase.asp?dup=y&order=" & newPn & "&jsmsg=" & server.urlencode("Order " & newOrderNum & " created. You are now editing the new order.")
response.redirect(url)

sub createHistoryRow(byref acon, aOldPn, aNewPn, aCompId)
	dim asql
	asql = "insert into qc_history (ComponentID,QC_StatusID,Purchase_No,QC_Date,UpdatedBy,MadeAt) select ComponentID,QC_StatusID," & aNewPn & ",now()," & retrieveUserID() & ",MadeAt from qc_history where purchase_no=" & aOldPn & " and componentid=" & aCompId & " and qc_statusid=0 order by qc_date asc limit 1"
	con.execute(asql)
	response.write("<br>asql = " & asql)
end sub

function getOrderNumber(byref acon, aPn)
	dim ars
	Set ars = getMysqlQueryRecordSet("select order_number from purchase where purchase_no=" & aPn, acon)
	getOrderNumber = ars("order_number")
	call closers(ars)
end function

function getLastInsertId(acon)
	dim ars
	set ars = getMysqlQueryRecordSet("select last_insert_id() as n", acon)
	getLastInsertId = ars("n")
	call closers(ars)
end function
%>
<!-- #include file="common/logger-out.inc" -->
