<%
const ORDER_DATE_SELECT_COUNT = 36
const ACTION_REQUIRED = "To Do"
const NO_FURTHER_ACTION = "No Further Action"
const COMPLETED = "Completed"
const VALIDDATECHARS = "0123456789/"
const ORDER_CONFIRMATION_CODE_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

class payment
	public paymentid
	public paymentType
	public amount
	public receiptNo
	public paymentMethod
	public creditDetails
	public placed
	public invoicedate
	public invoice_number
end class

class ordernote
	public text
	public action
	public followUpDate
	public orderNoteId
	public createdDate
	public noteType
	public userName
	public NoteCompletedDate
	public NoteCompletedBy
end class

dim AddressTableFields, ContactTableFields, ExcludedFields, FieldMappings

FieldMappings = array(array("order","purchase_no"),array("orderno","order_number"),array("add1","street1"),array("add2","street2"),array("add3","street3"),array("add1d","deliveryadd1") _
,array("add2d","deliveryadd2"),array("add3d","deliveryadd3"),array("clientstitle","title"),array("clientsfirst","first"),array("clientssurname","surname") _
,array("postcoded","deliverypostcode"),array("contact","salesusername"),array("townd","deliverytown"),array("dcresult","discount") _
,array("reference","customerreference"),array("deldate","deliverydate"),array("dc","discounttype"),array("outstanding","balanceoutstanding") _
,array("countyd","deliverycounty"),array("specialinstructions2","baseinstructions"),array("specialinstructions3","specialinstructionsheadboard") _
,array("specialinstructions4","specialinstructionsvalance"),array("countryd","deliverycountry"),array("complete","completedorders"))

AddressTableFields = array("street1","street2","street3","postcode","country","town","county","email_address","tel")
ContactTableFields = array("title","first","surname","telwork","mobile")
ExcludedFields = array("submit2","val","prod","legprice2","baseprice2","valfabricprice2","headboardprice2","mattressprice2","topperprice2","basefabricprice2","upholsteryprice2","valanceprice2","hbfabricprice2","deliveryprice2" _
,"converttoorder","additionalpayment","paymentsum","paymentmethod","refund","refundmethod","creditdetails","cust","accessoriestotalcost2" _
,"acc_desc1","acc_desc2","acc_desc3","acc_desc4","acc_desc5","acc_desc6","acc_desc7","acc_desc8","acc_desc9","acc_desc10","acc_desc11","acc_desc12","acc_desc13","acc_desc14","acc_desc15","acc_desc16","acc_desc17","acc_desc18","acc_desc19","acc_desc20" _
,"acc_unitprice1","acc_unitprice2","acc_unitprice3","acc_unitprice4","acc_unitprice5","acc_unitprice6","acc_unitprice7","acc_unitprice8","acc_unitprice9","acc_unitprice10","acc_unitprice11","acc_unitprice12","acc_unitprice13","acc_unitprice14","acc_unitprice15","acc_unitprice16","acc_unitprice17","acc_unitprice18","acc_unitprice19","acc_unitprice20" _
,"acc_qty1","acc_qty2","acc_qty3","acc_qty4","acc_qty5","acc_qty6","acc_qty7","acc_qty8","acc_qty9","acc_qty10","acc_qty11","acc_qty12","acc_qty13","acc_qty14","acc_qty15","acc_qty16","acc_qty17","acc_qty18","acc_qty19","acc_qty20" _
,"acc_id1","acc_id2","acc_id3","acc_id4","acc_id5","acc_id6","acc_id7","acc_id8","acc_id9","acc_id10","acc_id11","acc_id12","acc_id13","acc_id14","acc_id15","acc_id16","acc_id17","acc_id18","acc_id19","acc_id20" _
,"acc_delete1","acc_delete2","acc_delete3","acc_delete4","acc_delete5","acc_delete6","acc_delete7","acc_delete8","acc_delete9","acc_delete10","acc_delete11","acc_delete12","acc_delete13","acc_delete14","acc_delete15","acc_delete16","acc_delete17","acc_delete18","acc_delete19","acc_delete20" _
,"ordernote_id","ordernote_followupdate","ordernote_action","ordernote_NoteCompletedDate","ordernote_NoteCompletedBy","ordernote_notetext" _
,"delphonetype1","delphonetype2","delphonetype3","delphone1","delphone2","delphone3" _
,"amendmentemailrequired" _
)

function getNextOrderNumber(byref acon)
	acon.begintrans
	getNextOrderNumber = getNextOrderNumberNoTransaction(acon)
	acon.committrans
end function

function getNextOrderNumberNoTransaction(byref acon)
	dim ars
	set ars = getMysqlQueryRecordSet("select value from comreg where name='NEXTORDERNUMBER'", aCon)
	getNextOrderNumberNoTransaction = clng(ars("value"))
	ars.close
	set ars = nothing
	acon.execute("update comreg set value='" & getNextOrderNumberNoTransaction+1 & "' where name='NEXTORDERNUMBER'")
end function

function getRandomConfirmationNumber(byref acon)
	dim ars, aNotNew
	aNotNew = true
	
	while aNotNew
		Randomize
		getRandomConfirmationNumber = ""
		dim ai, aLength, an
		aLength = len(ORDER_CONFIRMATION_CODE_CHARS)
		for ai = 1 to 6
			an = cint(rnd() * aLength) + 1
			getRandomConfirmationNumber = getRandomConfirmationNumber & mid(ORDER_CONFIRMATION_CODE_CHARS, an, 1)
		next
	
		' make sure we've not used this code before
		set ars = getMysqlQueryRecordSet("select OrderConfirmationCode from purchase where OrderConfirmationCode='" & getRandomConfirmationNumber & "'", aCon)
		aNotNew = not ars.eof
		ars.close
		set ars = nothing
	wend
	
end function

function getNextReceiptNumber(byref acon) ' assumed to be wrapped in a transaction by the caller
	dim ars
	set ars = getMysqlQueryRecordSet("select value from comreg where name='NEXTRECEIPTNUMBER'", aCon)
	getNextReceiptNumber = clng(ars("value"))
	ars.close
	set ars = nothing
	acon.execute("update comreg set value='" & getNextReceiptNumber+1 & "' where name='NEXTRECEIPTNUMBER'")
end function

function getNextCustomerServiceNumber(byref acon)
	dim ars, aval, ayear, amonth, adbyear, adbmonth, anewval, aindex
	acon.begintrans
	ayear = right(year(now()), 2)
	amonth = padDigits(month(now()), 2) 
	'response.write("<br>ayear=" & ayear)
	'response.write("<br>amonth=" & amonth)
	
	set ars = getMysqlQueryRecordSet("select value from comreg where name='NEXTCUSTOMERSERVICENUMBER'", aCon)
	aval = ars("value")
	call closeRs(ars)
	'response.write("<br>aval=" & aval)
	adbyear = left(aval, 2)
	adbmonth = mid(aval, 3, 2)
	'response.write("<br>adbyear=" & adbyear)
	'response.write("<br>adbmonth=" & adbmonth)
	
	if cstr(ayear) <> cstr(adbyear) or cstr(amonth) <> cstr(adbmonth) then
		' roll over to current month
		anewval = ayear & amonth & "-001"
	else
		' same month, so just increment index
		aindex = padDigits(cint(right(aval, 3)) + 1, 3)
		anewval = left(aval, 5) + aindex
	end if
	acon.execute("update comreg set value='" & anewval & "' where name='NEXTCUSTOMERSERVICENUMBER'")
	acon.committrans
	getNextCustomerServiceNumber = anewval
end function

sub storeOrderChanges(byref aRequest, byref aCon, aPurchaseNo, aContactNo)
	dim aItem, aRsOrder, aRsAddress, aRsContact, aRsOrderAccessory, aOldValue, aNewValue, asql, aNewVersionNo, aTableName
	
	set aRsOrder = getMysqlQueryRecordSet("select * from purchase where purchase_no=" & aPurchaseNo, aCon)
	set aRsContact = getMysqlQueryRecordSet("Select * from contact where contact_no=" & aContactNo, aCon)
	set aRsAddress = getMysqlQueryRecordSet("Select * from address where code=" & aRsContact("code"), aCon)
	set aRsOrderAccessory = getMysqlQueryRecordSet("Select * from orderaccessory where purchase_no=" & aPurchaseNo, aCon)
	aNewVersionNo = cint(aRsOrder("version")) + 1
	
	for each aItem in aRequest.form
		if includeFormField(aItem) then
			aOldValue = getDbFieldValue(aRsOrder, aRsAddress, aRsContact, aRsOrderAccessory, aItem)
			aTableName = getDbFieldTable(getDbFieldName(aItem))
			aNewValue = trim(aRequest(aItem))
			if not areEqual(aOldValue, aNewValue) then
				asql = "insert into orderhistory (purchase_no,version,tablename,field,oldvalue,newvalue,modifiedby,datemodified)"
				asql = asql & " values (" & aPurchaseNo & "," & aNewVersionNo & ",'" & aTableName & "','" & aItem & "','" & replaceQuotes(aOldValue) & "','" & replaceQuotes(aNewValue) & "','" & retrieveUserName() & "','" & toDbDateTime(now()) & "')"
				'response.write("<br/>" & asql)
				aCon.execute(asql)
				'response.end
			end if
		end if
	next

	aRsOrder.close
	set aRsOrder = nothing
	aRsContact.close
	set aRsContact = nothing
	aRsAddress.close
	set aRsAddress = nothing
	aRsOrderAccessory.close
	set aRsOrderAccessory = nothing
	
	'response.end
end sub

function areEqual(byval aVal1, byval aVal2)
	'response.write("<br>:" & aVal1 & ":" & aval2 & ":")
	
	if isNumeric(aVal1) and isNumeric(aVal2) then
		areEqual = (cdbl(aVal1) = cDbl(aVal2))
		exit function
	end if
	
	if myIsNull(aVal1) then aVal1 = ""
	if myIsNull(aVal2) then aVal2 = ""
	aVal1 = trim(cstr(aVal1))
	aVal2 = trim(cstr(aVal2))
	'response.write("<br>:" & len(aVal1) & ":" & len(aVal2) & ":")
	
	if len(aVal1) = 0 and len(aVal2) = 0 then
		areEqual = true
	elseif aVal1 = "" and aVal2 = "n" then
		areEqual = true
	elseif aVal1 = "" and aVal2 = "None" then
		areEqual = true
	elseif aVal1 = "" and aVal2 = "--" then
		areEqual = true
	elseif aVal1 = "" and aVal2 = "TBC" then
		areEqual = true
	elseif aVal1 = aVal2 then
		areEqual = true
	else
		areEqual = false
	end if
end function

function getDbFieldValue(byref aRsOrder, byref aRsAddress, byref aRsContact, byref aRsOrderAccessory, aFormFieldName)
	dim aDbFieldName, aTableName, ars
	aDbFieldName = getDbFieldName(aFormFieldName)
	aTableName = getDbFieldTable(aDbFieldName)
	if aTableName = "address" then
		ars = aRsAddress
	elseif aTableName = "contact" then
		ars = aRsContact
	elseif aTableName = "orderaccessory" then
		ars = aRsOrderAccessory
	else
		ars = aRsOrder
	end if

	on error resume next
	if isnull(ars(aDbFieldName)) then
		getDbFieldValue = "<NULL>"
	else
		getDbFieldValue = trim(cstr(ars(aDbFieldName)))
	end if
	if err.number <> 0 then
		response.write("<br>aFormFieldName=" & aFormFieldName)
		response.write("<br>aDbFieldName=" & aDbFieldName)
		response.write("<br>aTableName=" & aTableName)
		response.write("<br>Error=" & err.description)
		response.end
	end if
	on error goto 0
end function

function includeFormField(aFormFieldName)
	if arrayContains(ExcludedFields, aFormFieldName) then
		includeFormField = false
	else
		includeFormField = true
	end if
end function

function getDbFieldName(aFormFieldName)
	dim ai, aMapping
	getDbFieldName = aFormFieldName
	for ai = lbound(FieldMappings) to ubound(FieldMappings)
		aMapping = FieldMappings(ai)
		if aMapping(0) = aFormFieldName then
			getDbFieldName = aMapping(1)
			exit function
		end if
	next
end function

function getDbFieldTable(aDbFieldName)
	if arrayContains(AddressTableFields, aDbFieldName) then
		getDbFieldTable = "address"
	elseif arrayContains(ContactTableFields, aDbFieldName) then
		getDbFieldTable = "contact"
	else
		getDbFieldTable = "purchase"
	end if
end function

function arrayContains(byref aArray, byref aVal)
	dim aItm
	arrayContains = false
	for each aItm in aArray
		if aItm = aVal then
			arrayContains = true
			exit function
		end if
	next
end function

function toDbDateTime(byref aDate)
    toDbDateTime = year(aDate) & "-" & month(aDate) & "-" & day(aDate) & " " & hour(aDate) & "." & minute(aDate) & "." & second(aDate)
end function

function toDbDate(byref aDate)
    toDbDate = year(aDate) & "-" & month(aDate) & "-" & day(aDate)
end function

function myIsNull(byref aStr)
	if isNull(aStr) then
		myIsNull = true
	elseif len(aStr)=6 then
		if asc(mid(aStr, 1, 1))=60 and asc(mid(aStr, 2, 1))=78 and asc(mid(aStr, 3, 1))=85 and asc(mid(aStr, 4, 1))=76 and asc(mid(aStr, 5, 1))=76 and asc(mid(aStr, 6, 1))=62 then
			myIsNull = true
		else
			myIsNull = false
		end if
	else
		myIsNull = false
	end if
end function

function getPaymentsForOrder(aPurchaseNo, byref acon)
	dim ars, thePayments(), aPayment, ai
	set ars = getMysqlQueryRecordSet("select * from payment p, paymentmethod m where p.paymentmethodid=m.paymentmethodid and p.purchase_no=" & aPurchaseNo & " order by p.placed asc", acon)
	ai = 0
	while not ars.eof
		ai = ai + 1
		set aPayment = new payment
		aPayment.paymentid = ars("paymentid")
		aPayment.paymentType = ars("paymenttype")
		aPayment.invoicedate = ars("invoicedate")
		aPayment.invoice_number = ars("invoice_number")
		aPayment.amount = ccur(ars("amount"))
		aPayment.receiptNo = clng(ars("receiptno"))
		aPayment.paymentMethod = ars("paymentmethod")
		aPayment.creditDetails = ars("creditdetails")
		aPayment.placed = ars("placed")
		redim preserve thePayments(ai)
		set thePayments(ai) = aPayment
		ars.movenext
	wend
	if ai = 0 then redim thePayments(0)
	closers(ars)
	getPaymentsForOrder = thePayments
end function
'get payments for order number instead of purchase no.
function getPaymentsForOrderNo(aOrdernoNo, byref acon)
	dim ars, thePayments(), aPayment, ai
	sql="select * from payment p, paymentmethod m where p.paymentmethodid=m.paymentmethodid and p.order_number=" & aOrdernoNo & " order by p.placed asc"
	'response.Write("sql=" & sql)
	set ars = getMysqlQueryRecordSet(sql, acon)
	ai = 0
	while not ars.eof
		ai = ai + 1
		set aPayment = new payment
		aPayment.paymentid = ars("paymentid")
		aPayment.paymentType = ars("paymenttype")
		aPayment.invoicedate = ars("invoicedate")
		aPayment.invoice_number = ars("invoice_number")
		aPayment.amount = ccur(ars("amount"))
		aPayment.receiptNo = clng(ars("receiptno"))
		aPayment.paymentMethod = ars("paymentmethod")
		aPayment.creditDetails = ars("creditdetails")
		aPayment.placed = ars("placed")
		redim preserve thePayments(ai)
		set thePayments(ai) = aPayment
		ars.movenext
	wend
	if ai = 0 then redim thePayments(0)
	closers(ars)
	getPaymentsForOrderNo = thePayments
end function

sub makeApproxDateOptions(byref aValue, byref aDesc, byref aDefault)
	dim ai, aDay, aMonth, aYear, aDefaultFound, aDefArray, aDefDay, aDefMonth, aDefYear
	aDefaultFound = false
	aDefDay = 0
	aDefMonth = 0
	aDefYear = 0
	if aDefault <> "" then
		if instr(aDefault, "-") then
			' date format is yyyy-mm-dd
			aDefArray = split(aDefault, "-")
			aDefDay = cint(aDefArray(2))
			aDefMonth = cint(aDefArray(1))
			aDefYear = cint(aDefArray(0))
		elseif instr(aDefault, ".") then
			' date format is dd.mm.yyyy
			aDefArray = split(aDefault, ".")
			aDefDay = cint(aDefArray(0))
			aDefMonth = cint(aDefArray(1))
			aDefYear = cint(aDefArray(2))
		else
			' date format is dd/mm/yyyy
			aDefArray = split(aDefault, "/")
			aDefDay = cint(aDefArray(0))
			aDefMonth = cint(aDefArray(1))
			aDefYear = cint(aDefArray(2))
		end if
		call roundApproxDate(aDefDay, aDefMonth, aDefYear)
		' rewrite in mysql format, in case it wasn't in the first place
		aDefault = aDefYear & "-" & aDefMonth & "-" & aDefDay
	end if
	'response.write("<br>default day,month,year = " & aDefDay & "," & aDefMonth & "," & aDefYear)

	aDay = cint(day(date))
	aMonth = cint(month(date))
	aYear = cint(year(date))
	
	call roundApproxDate(aDay, aMonth, aYear)
	'response.write("<br>day,month,year = " & aDay & "," & aMonth & "," & aYear)

	redim aValue(ORDER_DATE_SELECT_COUNT)
	redim aDesc(ORDER_DATE_SELECT_COUNT)
	aValue(1) = aYear & "-" & aMonth & "-" & aDay
	aDesc(1) = getApproxDateDescription(aDay, aMonth, aYear)
	if aDay = aDefDay and aMonth = aDefMonth and aYear = aDefYear then
		aDefaultFound = true
	end if
	'response.write("<br>aDefaultFound = " & aDefaultFound)
	
	for ai = 2 to ORDER_DATE_SELECT_COUNT
		if aDay = 5 then
			aDay = 15
		elseif aDay = 15 then
			aDay = 25
		else
			aDay = 5
			if aMonth < 12 then
				aMonth = aMonth + 1
			else
				aMonth = 1
				aYear = aYear + 1
			end if
		end if
		'response.write("<br>day,month,year = " & aDay & "," & aMonth & "," & aYear)
		
		aValue(ai) = aYear & "-" & aMonth & "-" & aDay
		aDesc(ai) = getApproxDateDescription(aDay, aMonth, aYear)
		if aDay = aDefDay and aMonth = aDefMonth and aYear = aDefYear then
			aDefaultFound = true
		end if
	next
	
	if aDefault <> "" and not aDefaultFound then
		redim preserve aValue(ORDER_DATE_SELECT_COUNT+1)
		redim preserve aDesc(ORDER_DATE_SELECT_COUNT+1)
		for ai = ORDER_DATE_SELECT_COUNT+1 to 2 step -1
			aValue(ai) = aValue(ai-1)
			aDesc(ai) = aDesc(ai-1)
		next
		aValue(1) = aDefault
		aDesc(1) = getApproxDateDescription(aDefDay, aDefMonth, aDefYear)
	end if
end sub

sub roundApproxDate(byref aDay, byref aMonth, byref aYear)
	if aDay <= 5 then
		aDay = 5
	elseif aDay <= 15 then
		aDay = 15
	elseif aDay <= 25 then
		aDay = 25
	else
		aDay = 5
		if aMonth < 12 then
			aMonth = aMonth + 1
		else
			aMonth = 1
			aYear = aYear + 1
		end if
	end if
end sub

function getApproxDateDescription(aDay, aMonth, aYear)
	if aDay = 5 then
		getApproxDateDescription = "Beginning"
	elseif aDay = 15 then
		getApproxDateDescription = "Middle"
	else
		getApproxDateDescription = "End"
	end if
	getApproxDateDescription = getApproxDateDescription & " " & monthName(aMonth) & " " & aYear
end function

function getRoundedApproxDateDescription(aDate)
	dim aDateArray, aDay, aMonth, aYear
	
	if aDate = "" then
		getRoundedApproxDateDescription = ""
		exit function
	end if
	
	if instr(aDate, "-") then
		' date format is yyyy-mm-dd
		aDateArray = split(aDate, "-")
		aDay = cint(aDateArray(2))
		aMonth = cint(aDateArray(1))
		aYear = cint(aDateArray(0))
	else
		' date format is dd/mm/yyyy
		aDateArray = split(aDate, "/")
		aDay = cint(aDateArray(0))
		aMonth = cint(aDateArray(1))
		aYear = cint(aDateArray(2))
	end if
	call roundApproxDate(aDay, aMonth, aYear)
	getRoundedApproxDateDescription = getApproxDateDescription(aDay, aMonth, aYear)
end function

function getRoundedApproxDateString(aLeadTime)
	dim aDate, aDay, aMonth, aYear
	aDate = date()
	if aLeadTime <> "" then
		aDate = DateAdd("ww", aLeadTime, aDate)
	end if
	aDay = day(aDate)
	aMonth = month(aDate)
	aYear = year(aDate)
	call roundApproxDate(aDay, aMonth, aYear)
	getRoundedApproxDateString = aYear & "-" & aMonth & "-" & aDay
end function

function getVatRate(byref acon, aidlocation)
	dim ars
	set ars = getMysqlQueryRecordSet("select vatrate from vatrate where idlocation=" & aidlocation & " and isdefault='y'", aCon)
	if not ars.eof then
	getVatRate = cdbl(ars("vatrate"))
	end if
	call closeRs(ars)
end function

sub closeRs(byref ars)
	ars.close
	set ars = nothing
end sub

function padDigits(an, atotalDigits) 
	padDigits = Right(String(atotalDigits,"0") & an, atotalDigits) 
end function

sub addOrderNote(byref acon, aText, aAction, aFollowUpDate, aPurchaseNo, aNoteType)
	dim ars
	Set ars = getMysqlUpdateRecordSet("select * from ordernote", acon)
	
	ars.AddNew
	ars("purchase_no") = aPurchaseNo
	ars("createddate") = toDbDateTime(now)
	ars("username") = retrieveUserName()
	ars("notetext") = aText
	if not isnull(aFollowUpDate) and not isempty(aFollowUpDate) and aFollowUpDate <> "" then
		ars("followupdate") = aFollowUpDate
	end if
	ars("action") = aAction
	ars("notetype") = aNoteType
	ars.update
	ars.close
	set ars = nothing
end sub

sub getOrderNote(byref acon, byref aText, byref aAction, byref aFollowUpDate, byref aOrderNoteId, aPurchaseNo, aNoteType)

	dim ars
	Set ars = getMysqlQueryRecordSet("select * from ordernote where purchase_no=" & aPurchaseNo & " and notetype='" & aNoteType & "'", acon)
	if ars.eof then
		aOrderNoteId = ""
		aText = ""
		aAction = ""
		aFollowUpDate = ""
	else
		aOrderNoteId = cint(ars("ordernote_id"))
		aText = ars("notetext")
		aAction = ars("action")
		aFollowUpDate = ars("followupdate")
	end if
	ars.close
	set ars = nothing
	
end sub

function getOrderNoteHistory(byref acon, aPurchaseNo, aNoteType)

	dim ars, aNotes(), an, aNote, asql
	asql = "select * from ordernote where purchase_no=" & aPurchaseNo
	if aNoteType <> "" then
		asql = asql & " and notetype='" & aNoteType & "'"
	end if
	asql = asql & " order by createddate desc"
	'response.write(asql)
	'response.end
	Set ars = getMysqlQueryRecordSet(asql, acon)
	an = 0
	while not ars.eof
		an = an + 1
		redim preserve aNotes(an)
		set aNote = new ordernote
		aNote.orderNoteId = cint(ars("ordernote_id"))
		aNote.text = ars("notetext")
		aNote.action = ars("action")
		aNote.followUpDate = ars("followupdate")
		aNote.createdDate = ars("createddate")
		aNote.noteType = ars("notetype")
		aNote.userName = ars("username")
		aNote.NoteCompletedDate = ars("NoteCompletedDate")
		aNote.NoteCompletedBy = ars("NoteCompletedBy")
		set aNotes(an) = aNote
		ars.movenext
	wend
	if an = 0 then redim aNotes(0)
	ars.close
	set ars = nothing
	getOrderNoteHistory = aNotes
	
end function

function orderHasOverdueNote(byref acon, aPurchaseNo)
	dim ars
	Set ars = getMysqlQueryRecordSet("select * from ordernote where purchase_no=" & aPurchaseNo & " and followupdate is not null and followupdate < now() and action='" & ACTION_REQUIRED & "'", acon)
	orderHasOverdueNote = not ars.eof
	ars.close
	set ars = nothing
end function

sub getPhoneNumberTypes(byref acon, byref atypenames)
	dim ars, asql, an
	asql = "select typename from phonenumbertype where retired=0 order by seq"
	set ars = getMysqlQueryRecordSet(asql, acon)
	an = 0
	while not ars.eof
		an = an + 1
		redim preserve atypenames(an)
		atypenames(an) = ars("typename")
		ars.movenext
	wend
	ars.close
	set ars = nothing
end sub

sub deletePhoneNumber(byref acon, aPurchaseNo, aSeq)
	dim asql
	asql = "delete from phonenumber where purchase_no=" & aPurchaseNo & " and seq=" & aSeq
	acon.execute(asql)
end sub

sub addUpdatePhoneNumber(byref acon, aPhoneNumberType, aPurchaseNo, aNumber, aSeq)
	dim ars
	Set ars = getMysqlUpdateRecordSet("select * from phonenumber where purchase_no=" & aPurchaseNo & " and seq=" & aSeq, acon)
	if ars.eof then	ars.AddNew
	ars("phonenumbertype") = aPhoneNumberType
	ars("purchase_no") = aPurchaseNo
	ars("number") = aNumber
	ars("seq") = aSeq
	ars.update
	ars.close
	set ars = nothing
end sub

sub getPhoneNumber(byref acon, aPurchaseNo, aSeq, byref aPhoneNumberType, byref aNumber)
	dim ars
	Set ars = getMysqlQueryRecordSet("select * from phonenumber where purchase_no=" & aPurchaseNo & " and seq=" & aSeq, acon)
	if ars.eof then
		aPhoneNumberType = ""
		aNumber = ""
	else
		aPhoneNumberType = ars("phonenumbertype")
		aNumber = ars("number")
	end if
	ars.close
	set ars = nothing
end sub

function arrayContains(byref aArray, byref aElement)
	dim an
	arrayContains = false
	for an = lbound(aArray) to ubound(aArray)
		if aElement = aArray(an) then
			arrayContains = true
			exit function
		end if
	next
end function

function makeContactNumberString(aType, aNumber)
	if aNumber <> "" then
		makeContactNumberString = aType & "&nbsp;" & aNumber
	else
		makeContactNumberString = "&nbsp;"
	end if
end function

function getVatRates(byref acon, byref aDefaultRate, byref aIdLocation)
	dim ars, aVatRates(), aRate, ai
	set ars = getMysqlQueryRecordSet("select * from vatrate where retired='n' and idlocation=" & aIdLocation & " order by seq desc", acon)
	
	if ars.eof then
		' none for this location, so use 1 (London)
		closers(ars)
		set ars = getMysqlQueryRecordSet("select * from vatrate where retired='n' and idlocation=1 order by seq desc", acon)
	end if
	
	ai = 0
	while not ars.eof
		ai = ai + 1
		redim preserve aVatRates(ai)
		aVatRates(ai) = ccur(ars("vatrate"))
		if aDefaultRate = "" and ars("isdefault") = "y" then
			aDefaultRate = aVatRates(ai)
		end if
		ars.movenext
	wend
	if ai = 0 then redim aVatRates(0)
	closers(ars)
	getVatRates = aVatRates
end function

function getVatRates2(byref acon, byref aDefaultRate, byref aIdLocation)
	dim ars, aVatRates(), aRate, ai, aFoundDefault
	set ars = getMysqlQueryRecordSet("select * from vatrate where retired='n' and idlocation=" & aIdLocation & " order by seq desc", acon)
	
	if ars.eof then
		' none for this location, so use 1 (London)
		closers(ars)
		set ars = getMysqlQueryRecordSet("select * from vatrate where retired='n' and idlocation=1 order by seq desc", acon)
	end if
	
	ai = 0
	aFoundDefault = false
	while not ars.eof
		ai = ai + 1
		redim preserve aVatRates(ai)
		aVatRates(ai) = ccur(ars("vatrate"))
		if aVatRates(ai) = ccur(aDefaultRate) then aFoundDefault = true
		ars.movenext
	wend
	if not aFoundDefault then
		ai = ai + 1
		redim preserve aVatRates(ai)
		aVatRates(ai) = ccur(aDefaultRate)
	end if
	if ai = 0 then redim aVatRates(0)
	closers(ars)
	getVatRates2 = aVatRates
end function

function validateDate(byval aDate)
	dim ai
	validateDate = ""
	for ai = 1 to len(aDate)
		if instr(1, VALIDDATECHARS, mid(aDate, ai, 1), 1) = 0 then
			exit function
		end if
	next
	validateDate = aDate
end function

function getComponentStatus(byref acon, aPurchaseNo, aCompId)
	dim ars, asql
	asql = "select QC_StatusID from qc_history where purchase_no=" & aPurchaseNo & " and componentid=" & aCompId & " order by qc_date desc"
	set ars = getMysqlQueryRecordSet(asql, acon)
	getComponentStatus = 0
	if not ars.eof then
		getComponentStatus = ars("QC_StatusID")
	end if
	ars.close
	set ars = nothing
end function

function getComponentStatusLatest(byref acon, aPurchaseNo, aCompId)
	dim ars, asql
	asql = "select QC_StatusID from qc_history_latest where purchase_no=" & aPurchaseNo & " and componentid=" & aCompId & ""
	
	set ars = getMysqlQueryRecordSet(asql, acon)
	getComponentStatusLatest = 0
	if not ars.eof then
		getComponentStatusLatest = ars("QC_StatusID")
	end if
	ars.close
	set ars = nothing
end function

function getComponentStatusTxt(aPurchaseNo, aCompId, byref acon)
	dim ars
	Set ars = getMysqlQueryRecordSet("Select qc_status from qc_history Q, qc_status S where Q.componentid=" & aCompId & " AND Q.purchase_no = " & aPurchaseNo & " and Q.qc_statusid=S.qc_statusid order by Q.QC_date desc", acon)
	getComponentStatusTxt = ""
	If not ars.eof then
		getComponentStatusTxt=ars("qc_status")
	end if
	ars.close
	set ars = nothing
end function

function getComponentStatusTxtLatest(aPurchaseNo, aCompId, byref acon)
	dim ars
	Set ars = getMysqlQueryRecordSet("Select qc_status from qc_history_latest Q, qc_status S where Q.componentid=" & aCompId & " AND Q.purchase_no = " & aPurchaseNo & " and Q.qc_statusid=S.qc_statusid", acon)
	getComponentStatusTxtLatest = ""
	If not ars.eof then
		getComponentStatusTxtLatest=ars("qc_status")
	end if
	ars.close
	set ars = nothing
end function

function getComponentBay(byref acon, aOrderNo, aCompId)
	dim ars, asql
	asql = "Select * from bay_content B, bays X where componentid=" & aCompId & " and orderid = " & aOrderNo & " and B.bayNumber=X.bay_no"
	set ars = getMysqlQueryRecordSet(asql, acon)
	getComponentBay = ""
	if not ars.eof then
		getComponentBay = ars("bay_name")
	end if
	ars.close
	set ars = nothing
	
end function


function getFactories(byref acon)
	dim ars, aFactories(), aId
	Set ars = getMysqlQueryRecordSet("Select * from manufacturedat order by ManufacturedAtID", acon)
	while not ars.eof
		aId = cint(ars("ManufacturedAtID"))
		redim preserve aFactories(aId)
		aFactories(aId) = ars("ManufacturedAt")
		ars.movenext
	wend
	closers(ars)
	getFactories = aFactories
end function

function validateOrderConfirmationCode(byref acon, aPn, aCode)
	dim ars
	set ars = getMysqlQueryRecordSet("select OrderConfirmationCode from purchase where purchase_no="&aPn, acon)
	validateOrderConfirmationCode = false
	if not ars.eof then
		validateOrderConfirmationCode = (ars("OrderConfirmationCode") = aCode)
	end if
	closers(ars)
end function

sub confirmOrder(byref acon, aPn, aUpdatedBy)
	dim ars, asql, aMadeatid
	asql = "update purchase set orderConfirmationStatus='y' where purchase_no=" & aPn
	acon.execute(asql)
	
	if orderHasComponent(acon, aPn, 1) then
		' mattress
		if getComponentStatus(acon, aPn, 1) < 10 then
			' If status less than 'On Order' then move to 'Confirmed, Waiting to Check'. Less than 'on order' is the
			' only way we can tell whether this component has been updated.
			call insertQcHistoryRow(acon, 1, aPn, 2, aUpdatedBy)
		end if
	end if
	if orderHasComponent(acon, aPn, 3) then
		' base
		if getComponentStatus(acon, aPn, 3) < 10 then
			' see comment against mattress 
			call insertQcHistoryRow(acon, 3, aPn, 2, aUpdatedBy)
		end if
	end if
	if orderHasComponent(acon, aPn, 5) then
		' topper
		if getComponentStatus(acon, aPn, 5) < 10 then
			' see comment against mattress 
			call insertQcHistoryRow(acon, 5, aPn, 2, aUpdatedBy)
		end if
	end if
	if orderHasComponent(acon, aPn, 6) then
		' valance
		if getComponentStatus(acon, aPn, 6) < 10 then
			' see comment against mattress 
			call insertQcHistoryRow(acon, 6, aPn, 2, aUpdatedBy)
		end if
	end if
	if orderHasComponent(acon, aPn, 7) then
		' legs
		if getComponentStatus(acon, aPn, 7) < 10 then
			' see comment against mattress 
			call insertQcHistoryRow(acon, 7, aPn, 2, aUpdatedBy)
		end if
	end if
	if orderHasComponent(acon, aPn, 8) then
		' headboard
		if getComponentStatus(acon, aPn, 8) < 10 then
			' see comment against mattress 
			call insertQcHistoryRow(acon, 8, aPn, 2, aUpdatedBy)
		end if
	end if
	if orderHasComponent(acon, aPn, 9) then
		' accessories
		if getComponentStatus(acon, aPn, 9) < 10 then
			' see comment against mattress 
			call insertQcHistoryRow(acon, 9, aPn, 2, aUpdatedBy)
		end if
	end if

	' give the order the lowest component status
	call setOrderStatusByMinComponentStatus(acon, apn, aUpdatedBy)
	
end sub

sub insertQcHistoryRow(byref acon, byval aCompId, byval aPn, byval aOrderStatusId, byval aUpdatedBy)
	dim asql, ars, aMadeAtId, aNewHistoryRowId
	' get the existing madeat value if there is one
	set ars = getMysqlQueryRecordSet("select MadeAt from qc_history where componentid=" & aCompId & " and purchase_no=" & aPn & " order by QC_Date desc", acon)
	aMadeAtId = 0
	if not ars.eof then
		aMadeAtId = ars("MadeAt")
		if isnull(aMadeAtId) then aMadeAtId = 0
	end if
	closers(ars)
	
	aNewHistoryRowId = copyHistoryRow(acon, aPn, aCompId)
	asql = "update qc_history set QC_StatusID=" & aOrderStatusId & ", UpdatedBy=" & aUpdatedBy & ", MadeAt=" & aMadeAtId & " where qc_historyid=" & aNewHistoryRowId
	acon.execute(asql)
end sub
															
sub insertQcHistoryRowIfNotExists(byref acon, byval aCompId, byval aPn, byval aOrderStatusId, byval aUpdatedBy, byval aMadeatid)
	dim asql, ars, aDoInsert, aNewHistoryRowId
	set ars = getMysqlQueryRecordSet("select * from qc_history where componentid=" & aCompId & " and purchase_no=" & aPn & " order by QC_Date desc", acon)
	if ars.eof then
		aDoInsert = true
		if aMadeatid = -1 then
			' We've not been supplied with a madeat value, so use 0 - this shouldn't happen in reality as order_added.asp now adds
			' the qc_history rows with the correct madeat values for each component.
			aMadeatid = 0
		end if
	else
		aDoInsert = (ars("QC_StatusID") <> aOrderStatusId)
		if aMadeatid = -1 and not isnull(ars("MadeAt")) then
			' since we've not been supplied with a madeat value, but there's an existing qc_history entry, use the value from that
			aMadeatid = ars("MadeAt")
		end if
	end if
	
	if aDoInsert then
		' either no status row or the status is zero
		aNewHistoryRowId = copyHistoryRow(acon, aPn, aCompId)
		if aNewHistoryRowId > 0 then
			asql = "update qc_history set QC_StatusID=" & aOrderStatusId & ", UpdatedBy=" & aUpdatedBy & ", MadeAt=" & aMadeatid & " where qc_historyid=" & aNewHistoryRowId
		else
			asql = "insert into qc_history (ComponentID,QC_StatusID,Purchase_No,QC_Date,UpdatedBy,MadeAt) values (" & aCompId & "," & aOrderStatusId & "," & aPn & ",now()," & aUpdatedBy &  "," & aMadeatid & ")"
		end if
		'response.write(asql)
		acon.execute(asql)
	end if
	closers(ars)
end sub

sub deleteComponentQcHistory(byref acon, aCompId, aPn)
	dim asql
	asql = "delete from qc_history where Purchase_No=" & aPn & " and ComponentID=" & aCompId
	acon.execute(asql)
	asql = "delete from qc_history_latest where Purchase_No=" & aPn & " and ComponentID=" & aCompId
	acon.execute(asql)
end sub

sub deletePackagingData(byref acon, aCompId, aPn)
	dim asql
	asql = "delete from packagingdata where Purchase_No=" & aPn & " and ComponentID=" & aCompId
	acon.execute(asql)
end sub

sub deleteExportData(byref acon, aCompId, aPn)
	dim asql
	asql = "delete from exportlinks where Purchase_No=" & aPn & " and ComponentID=" & aCompId
	call log(scriptname, "deleting from exportlinks where Purchase_No=" & aPn & " and ComponentID=" & aCompId)
	acon.execute(asql)
end sub

sub clearProductionSizes(byref acon, aCompId, aPn)
	dim aColsStr, aCols, aCol, asql, an
	if aCompId = 1 then
		aColsStr = "Matt1Width,Matt2Width,Matt1Length,Matt2Length"
	elseif aCompId = 3 then
		aColsStr = "Base1Width,Base2Width,Base1Length,Base2Length"
	elseif aCompId = 5 then
		aColsStr = "topper1Width,topper1Length"
	end if
	aCols = split(aColsStr, ",")
	asql = "update productionsizes set"
	an = 0
	for each aCol in aCols
		an = an + 1
		if an > 1 then asql = asql & ","
		asql = asql & " " & aCol & "=null"
	next
	asql = asql & " where purchase_no=" & aPn
	'response.write(asql)
	'response.end
	acon.execute(asql)
	
end sub

function orderHasComponent(byref acon, aPn, aCompId)
	dim asql, ars, aColName, aExistsVal, aNotExistsVal
	aExistsVal = ""
	aNotExistsVal = ""
	
	if aCompId = 1 then
		' mattress
		aColName = "mattressrequired"
		aExistsVal = "y"
	elseif aCompId = 3 then
		' base
		aColName = "baserequired"
		aExistsVal = "y"
	elseif aCompId = 5 then
		' topper
		aColName = "topperrequired"
		aExistsVal = "y"
	elseif aCompId = 6 then
		' valance
		aColName = "valancerequired"
		aExistsVal = "y"
	elseif aCompId = 7 then
		' legs
		aColName = "legsrequired"
		aExistsVal = "y"
	elseif aCompId = 8 then
		' headboard
		aColName = "headboardrequired"
		aExistsVal = "y"
	elseif aCompId = 9 then
		' accessories
		aColName = "accessoriesrequired"
		aExistsVal = "y"
	end if
	'response.write("<br>aColName,aExistsVal = " & aColName & "," & aExistsVal)
	
	asql = "select " & aColName & " from purchase where purchase_no=" & aPn
	'response.write("<br>asql = " & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
	'response.write("<br>ars(aColName) = " & ars(aColName))

	orderHasComponent = false
	if aNotExistsVal <> "" then
		orderHasComponent = (ars(aColName) <> aNotExistsVal)
	else
		orderHasComponent = (ars(aColName) = aExistsVal)
	end if
	
	closers(ars)
end function

function getMattressMadeAt(aSavoirmodel)
	getMattressMadeAt = 0
	If aSavoirmodel="No. 1" or aSavoirmodel="No. 2"  or aSavoirmodel="State" then getMattressMadeAt = 2 '2 is made at london
	If aSavoirmodel="No. 3" or aSavoirmodel="No. 4" or aSavoirmodel="No. 4v" or aSavoirmodel="No. 5" then getMattressMadeAt = 1 '1 is made at Cardiff
	'If aSavoirmodel<>"No. 1" and aSavoirmodel<>"No. 2"  and aSavoirmodel<>"No. 3" and aSavoirmodel<>"No. 4" then getMattressMadeAt = 1 '2 is made at london
end function

function getBaseMadeAt(aBasesavoirmodel)
	getBaseMadeAt = 0
	If aBasesavoirmodel="No. 1" or aBasesavoirmodel="No. 2" or aBasesavoirmodel="State" or aBasesavoirmodel="Savoir Slim" then getBaseMadeAt=2
	If aBasesavoirmodel="No. 3" or aBasesavoirmodel="No. 4" or aBasesavoirmodel="No. 4v" or aBasesavoirmodel="No. 5" then getBaseMadeAt=1
end function

function getTopperMadeAt(aToppertype, aSavoirmodel, aBasesavoirmodel, aMattressmadeat, aBasemadeat)
	getTopperMadeAt = 0
If aToppertype="State HCa Topper" then getTopperMadeAt=2
	If aToppertype="HCa Topper" then getTopperMadeAt=2
	If aToppertype="CFv Topper" then getTopperMadeAt=1
	If aToppertype="HW Topper" and (aSavoirmodel<>"" and aSavoirmodel<>"n") then getTopperMadeAt=aMattressmadeat
	If aToppertype="HW Topper" and (aBasesavoirmodel<>"" and aBasesavoirmodel<>"n") then getTopperMadeAt=aBasemadeat
	If aToppertype="HW Topper" and (aSavoirmodel="" or aSavoirmodel="n")  and (aBasesavoirmodel="" or aBasesavoirmodel="n") then getTopperMadeAt=1
	If aToppertype="CW Topper" and (aSavoirmodel<>"" and aSavoirmodel<>"n") then getTopperMadeAt=aMattressmadeat
	If aToppertype="CW Topper" and (aBasesavoirmodel<>"" and aBasesavoirmodel<>"n") then getTopperMadeAt=aBasemadeat
	If aToppertype="CW Topper" and (aSavoirmodel="" or aSavoirmodel="n") and (aBasesavoirmodel="" or aBasesavoirmodel="n") then getTopperMadeAt=1
	if getTopperMadeAt = "" then getTopperMadeAt = 0 ' happens if theres no mattress or base in the order
end function

function getHeadboardMadeAt(aHeadboardstyle, aBasemadeat, aMattressmadeat)
	dim aHeadcardiff
	getHeadboardMadeAt = 0
	aHeadcardiff = false
	If aHeadboardstyle="C1" or aHeadboardstyle="C2" or aHeadboardstyle="C4" or aHeadboardstyle="C5" or aHeadboardstyle="C6" or aHeadboardstyle="CF1" or aHeadboardstyle="CF2" or aHeadboardstyle="C4" or aHeadboardstyle="C5" then aHeadcardiff=true
	If aHeadcardiff then
		getHeadboardMadeAt=1
		If getHeadboardMadeAt<>"" and aBasemadeat<>"" then getHeadboardMadeAt=aBasemadeat
		If getHeadboardMadeAt<>"" and aMattressmadeat<>"" then getHeadboardMadeAt=aMattressmadeat
	else
		getHeadboardMadeAt=2
	end if
end function

function getValanceMadeAt()
	getValanceMadeAt = 2
end function

function getLegsMadeAt()
	getLegsMadeAt = 2
end function

function getComponentCurrentMadeAt(byref acon, aPn, aCompId)
	dim asql, ars
	getComponentCurrentMadeAt = -1 ' i.e. not set
	asql = "Select * from qc_history where componentid=" & aCompId & " AND purchase_no = " & aPn & " order by QC_date desc"
	'if aCompId=5 then response.write("<br>asql=" & asql)
	Set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof and not isnull(ars("madeat")) then
		getComponentCurrentMadeAt = ars("madeat")
	end if
	ars.close
	set ars=nothing
end function

function getcomponentWoodworkNoTobefinished(byref acon, aWoodworkNoDays, aStrDate, aEndDate, aMadeAt)
	dim asql, ars, iWeek, strYear, enddate, aMadeatName
	if aMadeAt=2 then aMadeatName="london"
	if aMadeAt=1 then aMadeatName="cardiff"
	asql = "Select * from qc_history_latest Q, purchase P where Q.purchase_no=P.purchase_no and Q.componentid<>0 and Q.componentid<>9 and Q.componentid<>6 and Q.componentid<>5 and Q.componentid<>1 AND P.completedorders='n' and P.orderonhold<>'y' and (P.cancelled is Null or P.cancelled='n') and P." & aMadeatName & "productiondate<>'' and (P.DeliveryDateConfirmed<>'y' or P.DeliveryDateConfirmed is Null)  and date_sub(P." & aMadeatName & "productiondate, INTERVAL " & aWoodworkNoDays & " DAY) >='" & aStrDate & "' and date_sub(P." & aMadeatName & "productiondate, INTERVAL " & aWoodworkNoDays & " DAY) < '" & aEndDate & "' AND Q.madeat=" & aMadeAt & " and  Q.finished is Null"
	'response.Write(asql & "<br><br>")
	Set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof and not isnull(ars("madeat")) then
	getcomponentWoodworkNoTobefinished=0
		do until ars.eof
		if ars("componentid")=3 and isnull(ars("Framed")) then getcomponentWoodworkNoTobefinished=getcomponentWoodworkNoTobefinished+1
		'if ars("componentid")=3 and isnull(ars("Framed")) and (left(ars("basetype"),3)="Eas" or left(ars("basetype"),3)="Nor") then getcomponentWoodworkNoTobefinished=getcomponentWoodworkNoTobefinished+1
		if ars("componentid")=8 and isnull(ars("Framed")) then getcomponentWoodworkNoTobefinished=getcomponentWoodworkNoTobefinished+1
		if ars("componentid")=7 and isnull(ars("Finished")) then getcomponentWoodworkNoTobefinished=getcomponentWoodworkNoTobefinished+1
		ars.movenext
		loop
	end if
	ars.close
	set ars=nothing
end function

function getcomponentCuttingNoTobefinished(byref acon, acuttingroomNoDays, aStrDate, aEndDate, aMadeAt)
	dim asql, ars, iWeek, strYear, enddate, aMadeatName
	if aMadeAt=2 then aMadeatName="london"
	if aMadeAt=1 then aMadeatName="cardiff"
	asql = "Select * from qc_history_latest Q, purchase P where Q.purchase_no=P.purchase_no and Q.componentid<>0 and Q.componentid<>9 and Q.componentid<>6 and Q.componentid<>7 AND P.completedorders='n' and P.orderonhold<>'y' and (P.cancelled is Null or P.cancelled='n') and P." & aMadeatName & "productiondate<>'' and (P.DeliveryDateConfirmed<>'y' or P.DeliveryDateConfirmed is Null)  and  date_sub(P." & aMadeatName & "productiondate, INTERVAL " & acuttingroomNoDays & " DAY) >='" & aStrDate & "' and date_sub(P." & aMadeatName & "productiondate, INTERVAL " & acuttingroomNoDays & " DAY) < '" & aEndDate & "'AND Q.madeat=" & aMadeAt & " and  Q.finished is Null"
	
	Set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof and not isnull(ars("madeat")) then
	getcomponentCuttingNoTobefinished=0
	'response.Write(asql & "<br><br>")
		do until ars.eof
		if ars("componentid")=1 and isnull(ars("Machined")) then getcomponentCuttingNoTobefinished=getcomponentCuttingNoTobefinished+1
		'if ars("componentid")=1 and left(ars("mattresstype"),3)="Zip" and isnull(ars("Machined"))  then getcomponentCuttingNoTobefinished=getcomponentCuttingNoTobefinished+1
		if ars("componentid")=3 and isnull(ars("Machined")) then getcomponentCuttingNoTobefinished=getcomponentCuttingNoTobefinished+1
		'if ars("componentid")=3 and isnull(ars("Machined"))  and (left(ars("basetype"),3)="Eas" or left(ars("basetype"),3)="Nor") then getcomponentCuttingNoTobefinished=getcomponentCuttingNoTobefinished+1
		if ars("componentid")=5 and isnull(ars("Machined")) then getcomponentCuttingNoTobefinished=getcomponentCuttingNoTobefinished+1
		if ars("componentid")=8 and isnull(ars("Finished")) then getcomponentCuttingNoTobefinished=getcomponentCuttingNoTobefinished+1
		ars.movenext
		loop
	end if
	ars.close
	set ars=nothing
end function

function getcomponentNoTobefinishedNew(byref acon, aProductionFloorNoDays, aStrDate, aEndDate, aMadeAt)
	dim asql, ars, iWeek, strYear, enddate, aMadeatName
	if aMadeAt=2 then aMadeatName="london"
	if aMadeAt=1 then aMadeatName="cardiff"
	asql = "Select * from qc_history_latest Q, purchase P where Q.purchase_no=P.purchase_no and Q.componentid<>0 and Q.componentid<>9 and Q.componentid<>6 AND P.completedorders='n' and P.orderonhold<>'y' and (P.cancelled is Null or P.cancelled='n') and P." & aMadeatName & "productiondate<>'' and (P.DeliveryDateConfirmed<>'y' or P.DeliveryDateConfirmed is Null)   and  date_sub(P." & aMadeatName & "productiondate, INTERVAL " & aProductionFloorNoDays & " DAY) >='" & aStrDate & "' and date_sub(P." & aMadeatName & "productiondate, INTERVAL " & aProductionFloorNoDays & " DAY) < '" & aEndDate & "'AND Q.madeat=" & aMadeAt & " and  Q.finished is Null"
'response.Write(asql)
'response.End()
	Set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof and not isnull(ars("madeat")) then
		getcomponentNoTobefinishedNew = ars.recordcount
		'do until ars.eof
		'if ars("componentid")=1 and left(ars("mattresstype"),3)="Zip" then getcomponentNoTobefinished=getcomponentNoTobefinished+1
		'if ars("componentid")=3 and (left(ars("basetype"),3)="Eas" or left(ars("basetype"),3)="Nor") then getcomponentNoTobefinished=getcomponentNoTobefinished+1
		'ars.movenext
		'loop
	end if
	ars.close
	set ars=nothing
end function


function getcomponentNoTobefinished(byref acon, aStrDate, aEndDate, aMadeAt)
	dim asql, ars, iWeek, strYear, enddate
	asql = "Select * from qc_history_latest Q, purchase P where Q.purchase_no=P.purchase_no and Q.componentid<>0 and Q.componentid<>9 and Q.componentid<>6 AND P.completedorders='n' and P.orderonhold<>'y' and (P.cancelled is Null or P.cancelled='n') and P.productiondate<>'' and (P.DeliveryDateConfirmed<>'y' or P.DeliveryDateConfirmed is Null)  and P.productiondate >'" & aStrDate & "' and P.productiondate < '" & aEndDate & "' AND Q.madeat=" & aMadeAt & " and  Q.finished is Null"
	Set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof and not isnull(ars("madeat")) then
		getcomponentNoTobefinished = ars.recordcount
		'do until ars.eof
		'if ars("componentid")=1 and left(ars("mattresstype"),3)="Zip" then getcomponentNoTobefinished=getcomponentNoTobefinished+1
		'if ars("componentid")=3 and (left(ars("basetype"),3)="Eas" or left(ars("basetype"),3)="Nor") then getcomponentNoTobefinished=getcomponentNoTobefinished+1
		'ars.movenext
		'loop
	end if
	ars.close
	set ars=nothing
end function

function isCompMachined(byref acon, aPn, aCompId)
	dim asql, ars
	asql = "Select * from qc_history_latest where componentid=" & aCompId & " AND purchase_no = " & aPn & ""
	'if aCompId=5 then response.write("<br>asql=" & asql)
	Set ars = getMysqlQueryRecordSet(asql, acon)
	if ars.eof then 
		isCompMachined="y"
	else
		if not ars.eof then
			if isNull(ars("machined")) then isCompMachined="n" else isCompMachined="y"
		end if
	end if
	ars.close
	set ars=nothing
end function

function isFrameFinished(byref acon, aPn, aCompId)
	dim asql, ars
	asql = "Select * from qc_history_latest where componentid=" & aCompId & " AND purchase_no = " & aPn & ""
	'if aCompId=5 then response.write("<br>asql=" & asql)
	Set ars = getMysqlQueryRecordSet(asql, acon)
	if ars.eof then 
		isFrameFinished="y"
	else
		if not ars.eof then
			if isNull(ars("framed")) then isFrameFinished="n" else isFrameFinished="y"
		end if
	end if
	ars.close
	set ars=nothing
end function

function isCompFinished(byref acon, aPn, aCompId)
	dim asql, ars
	asql = "Select * from qc_history_latest where componentid=" & aCompId & " AND purchase_no = " & aPn & ""
	'if aCompId=5 then response.write("<br>asql=" & asql)
	Set ars = getMysqlQueryRecordSet(asql, acon)
	if ars.eof then 
		isCompFinished="y"
	else
		if not ars.eof then
			if isNull(ars("finished")) then isCompFinished="n" else isCompFinished="y"
		end if
	end if
	ars.close
	set ars=nothing
end function

sub updateComponentMadeAt(byref acon, aPn, aCompId, aMadeAt)
	dim asql, ars
	asql = "Select * from qc_history where componentid=" & aCompId & " AND purchase_no = " & aPn & " order by QC_date desc"
	Set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		asql = "update qc_history set madeat=" & aMadeAt & " where qc_historyid=" & ars("qc_historyid")
		acon.execute(asql)
	end if
	ars.close
	set ars=nothing
end sub

sub setOrderStatusByMinComponentStatus(byref acon, byval apn, byval aUpdatedBy)
	dim asql, ars, ars2, aMinOrderComponentStatus, aCompId, aCurrentComponentStatus, aCurrentOrderStatus, aNewHistoryRowId
	asql = "select distinct componentid from qc_history where purchase_no=" & apn & " and componentid <>0"
	set ars = getMysqlQueryRecordSet(asql, acon)
	aMinOrderComponentStatus = 999
	while not ars.eof
		aCompId = ars("componentid")
		asql = "select qc_statusid from qc_history where purchase_no=" & apn & " and componentid=" & aCompId & " order by qc_date desc"
		aCurrentComponentStatus = 999
		set ars2 = getMysqlQueryRecordSet(asql, acon)
		if not ars2.eof then
			aCurrentComponentStatus = ars2("qc_statusid")
		end if
		closers(ars2)
		
		if aCurrentComponentStatus < aMinOrderComponentStatus then
			aMinOrderComponentStatus = aCurrentComponentStatus
		end if
		ars.movenext
	wend
	closers(ars)

	asql = "select qc_statusid from qc_history where purchase_no=" & apn & " and componentid=0 order by qc_date desc"
	aCurrentOrderStatus = 0
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		aCurrentOrderStatus = ars("qc_statusid")
	end if
	closers(ars)
	
	if aMinOrderComponentStatus > aCurrentOrderStatus then
		aNewHistoryRowId = copyHistoryRow(acon, apn, 0)
		asql = "update qc_history set QC_StatusID=" & aMinOrderComponentStatus & ", UpdatedBy=" & aUpdatedBy & ", MadeAt=0 where qc_historyid=" & aNewHistoryRowId
		acon.execute(asql)
	end if
end sub

function copyHistoryRow(byref acon, byval apn, byval acompId)
	dim asql, aqcHistoryId, ars, acols, anewQcHistoryId
	asql = "select qc_historyid from qc_history where purchase_no=" & apn & " and componentid=" & acompId & " order by qc_date desc"
	aqcHistoryId = 0
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		aqcHistoryId = ars("qc_historyid")
	else
		copyHistoryRow = 0
		closers(ars)
		exit function
	end if
	closers(ars)
	
	acols = getTableColumns(acon, "qc_history", "QC_HistoryID")
	asql = "insert into qc_history (" & acols & ") select " & acols & " from qc_history where QC_HistoryID=" & aqcHistoryId
	'response.write("<br>asql = " & asql)
	'response.end
	acon.execute(asql)
	
	asql = "select max(qc_historyid) as m from qc_history"
	set ars = getMysqlQueryRecordSet(asql, acon)
	anewQcHistoryId = 0
	if not ars.eof then
		anewQcHistoryId = ars("m")
	end if
	asql = "update qc_history set qc_date=NOW() where QC_HistoryID=" & anewQcHistoryId
	acon.execute(asql)
	copyHistoryRow = anewQcHistoryId
end function

function getTableColumns(byref acon, byval atableName, aExcludeCol)
	dim ars, aschema, asql, astr
	set ars = getMysqlQueryRecordSet("select database()", acon)
	aschema = ars(0)
	closers(ars)

	asql = "select column_name from information_schema.columns where table_schema = '" & aschema& "' and table_name='" & atableName & "' order by ordinal_position"
	set ars = getMysqlQueryRecordSet(asql, acon)
	
	astr = ""
	while not ars.eof
		if ars("column_name") <> aExcludeCol then
			if astr <> "" then astr = astr & ","
			astr = astr & ars("column_name")
		end if
		ars.movenext
	wend
	closers(ars)

	getTableColumns = astr
end function

function getTableColumns2(byref acon, byval atableName, aExcludeColList)
	dim ars, aschema, asql, astr, aExcludeArray, aExclude, ai
	set ars = getMysqlQueryRecordSet("select database()", acon)
	aschema = ars(0)
	closers(ars)

	asql = "select column_name from information_schema.columns where table_schema = '" & aschema& "' and table_name='" & atableName & "' order by ordinal_position"
	set ars = getMysqlQueryRecordSet(asql, acon)
	
	astr = ""
	aExcludeArray = split(aExcludeColList, ",")
	while not ars.eof
		aExclude = false
		for ai = lbound(aExcludeArray) to ubound(aExcludeArray)
			if aExcludeArray(ai) = ars("column_name") then
				aExclude = true
			end if
		next
		if not aExclude then
			if astr <> "" then astr = astr & ","
astr = astr & "`" & ars("column_name") & "`"
		end if
'response.write("<br>col=" & ars("column_name"))
		ars.movenext
	wend
	closers(ars)

	getTableColumns2 = astr
end function

function getComponentIssuedDate(byref acon, byval apn, byval aCompId)
	dim asql, ars
	asql = "select qc_date from qc_history where purchase_no=" & apn & " and componentid=" & acompId & " and qc_statusid=20 order by qc_date desc"
	set ars = getMysqlQueryRecordSet(asql, acon)
	getComponentIssuedDate = ""
	if not ars.eof then
		getComponentIssuedDate = ars("qc_date")
	end if
	closers(ars)
end function

function getComponentConfirmedDate(byref acon, byval apn, byval aCompId)
	dim asql, ars
	asql = "select qc_date from qc_history where purchase_no=" & apn & " and componentid=" & acompId & " and qc_statusid=2 order by qc_date desc"
	set ars = getMysqlQueryRecordSet(asql, acon)
	getComponentConfirmedDate = ""
	if not ars.eof then
		getComponentConfirmedDate = ars("qc_date")
	end if
	closers(ars)
end function

function isStatusChangePermitted(byval aOldStatus, byval aNewStatus)
	isStatusChangePermitted = false
	'response.write("<br>aOldStatus = " & aOldStatus)
	'response.write("<br>aNewStatus = " & aNewStatus)
	if aOldStatus >= 20 and aNewStatus <= 10 then
		' the status is being changed from 'In Production' or greater to lower than 'On Order' - i.e. someone's trying to amend an order that's in production
		'response.write("<br>ORDER_REOPENER = " & userHasRole("ORDER_REOPENER"))
		if userHasRole("ORDER_REOPENER") then
			isStatusChangePermitted = true
		end if
	else
		isStatusChangePermitted = true
	end if
end function

function getCustomerOrdersTotal(byref acon, byval aContactNo)
	dim asql, ars, aVals(), aCount, aTotExVat
	asql = "select sum(total) as tot,sum(totalexvat) as totexvat,ordercurrency from purchase where (cancelled<>'y' or cancelled is null) AND contact_no=" & aContactNo & " group by ordercurrency"
	set ars = getMysqlQueryRecordSet(asql, acon)
	aCount = 0
	while not ars.eof
		if not isnull(ars("tot")) then
			aCount = aCount + 1
			if not isNull(ars("totexvat")) then
				aTotExVat = ars("totexvat")
			else
				aTotExVat = 0
			end if
			redim preserve aVals(aCount)
			aVals(aCount) = ars("ordercurrency") & ":" & ccur(ars("tot")) & ":" & ccur(aTotExVat)
		end if
		ars.movenext
	wend
	if aCount = 0 then redim aVals(0)
	closers(ars)
	getCustomerOrdersTotal = aVals
end function

function getVIPCustomerOrdersTotal(byref acon, byval aContactNo)
	dim asql, ars, aVals(), aCount, aTotExVat
	asql = "select sum(total) as tot,sum(totalexvat) as totexvat,ordercurrency from purchase where (cancelled<>'y' or cancelled is null) AND (quote<>'y' or quote is null) AND contact_no=" & aContactNo & " group by ordercurrency"
	set ars = getMysqlQueryRecordSet(asql, acon)
	aCount = 0
	while not ars.eof
		if not isnull(ars("tot")) then
			aCount = aCount + 1
			if not isNull(ars("totexvat")) then
				aTotExVat = ars("totexvat")
			else
				aTotExVat = 0
			end if
			redim preserve aVals(aCount)
			aVals(aCount) = ars("ordercurrency") & ":" & ccur(ars("tot")) & ":" & ccur(aTotExVat)
		end if
		ars.movenext
	wend
	if aCount = 0 then redim aVals(0)
	closers(ars)
	getVIPCustomerOrdersTotal = aVals
end function

function getCustomerOrdersTotalCurrentYear(byref acon, byval aContactNo)
	dim asql, ars, aVals(), aCount, aTotExVat
	asql = "select sum(total) as tot,sum(totalexvat) as totexvat,ordercurrency from purchase where (cancelled<>'y' or cancelled is null) AND contact_no=" & aContactNo & " and year(order_date) = year(now()) group by ordercurrency"
	set ars = getMysqlQueryRecordSet(asql, acon)
	aCount = 0
	while not ars.eof
		if not isnull(ars("tot")) then
			aCount = aCount + 1
			if not isNull(ars("totexvat")) then
				aTotExVat = ars("totexvat")
			else
				aTotExVat = 0
			end if
			redim preserve aVals(aCount)
			aVals(aCount) = ars("ordercurrency") & ":" & ccur(ars("tot")) & ":" & ccur(aTotExVat)
		end if
		ars.movenext
	wend
	if aCount = 0 then redim aVals(0)
	closers(ars)
	getCustomerOrdersTotalCurrentYear = aVals
end function

function getStatusList(byref acon)
	dim ars, aStatuses(), aId
	Set ars = getMysqlQueryRecordSet("Select * from qc_status order by qc_statusid", acon)
	while not ars.eof
		aId = cint(ars("qc_statusid"))
		redim preserve aStatuses(aId)
		aStatuses(aId) = ars("qc_status")
		ars.movenext
	wend
	closers(ars)
	getStatusList = aStatuses
end function

function getLatestHistoryColVal(byref acon, byval apn, byval aCompId, byval aColName)
	dim ars
	Set ars = getMysqlQueryRecordSet("select " & aColName & " as val from qc_history_latest where purchase_no=" & apn & " and componentid=" & aCompId, acon)
	if not ars.eof then
		getLatestHistoryColVal = ars("val")
	else
		getLatestHistoryColVal = ""
	end if
	closers(ars)
end function

function getOrderNumberForPurchaseNo(byref acon, apn)
	dim ars
	Set ars = getMysqlQueryRecordSet("select order_number from purchase where purchase_no=" & apn, acon)
	getOrderNumberForPurchaseNo = ars("order_number")
	closers(ars)
end function

function calcOrderProductionCompletionDate(byref acon, apn)
	dim ars, aMattressFinDate, aTopperFinDate, aBaseFinDate, aHeadboardFinDate, aCompletionDate
	
	aMattressFinDate = getComponentFinishedDate(acon, apn, 1)
	if aMattressFinDate = "not finished" then
		calcOrderProductionCompletionDate = ""
		'response.write("<br>mattress not finished")
		exit function
	end if
	
	aTopperFinDate = getComponentFinishedDate(acon, apn, 5)
	if aTopperFinDate = "not finished" then
		calcOrderProductionCompletionDate = ""
		'response.write("<br>topper not finished")
		exit function
	end if

	aBaseFinDate = getComponentFinishedDate(acon, apn, 3)
	if aBaseFinDate = "not finished" then
		calcOrderProductionCompletionDate = ""
		'response.write("<br>base not finished")
		exit function
	end if

	aHeadboardFinDate = getComponentFinishedDate(acon, apn, 8)
	if aHeadboardFinDate = "not finished" then
		calcOrderProductionCompletionDate = ""
		'response.write("<br>headboard not finished")
		exit function
	end if

	'response.write("<br>aMattressFinDate = " & aMattressFinDate)
	'response.write("<br>aTopperFinDate = " & aTopperFinDate)
	'response.write("<br>aBaseFinDate = " & aBaseFinDate)
	'response.write("<br>aHeadboardFinDate = " & aHeadboardFinDate)
	
	aCompletionDate = cdate("01/01/1970")
	if aMattressFinDate <> "" then
		if datediff("S", aCompletionDate, aMattressFinDate) > 0 then aCompletionDate = aMattressFinDate
	end if
	if aTopperFinDate <> "" then
		if datediff("S", aCompletionDate, aTopperFinDate) > 0 then aCompletionDate = aTopperFinDate
	end if
	if aBaseFinDate <> "" then
		if datediff("S", aCompletionDate, aBaseFinDate) > 0 then aCompletionDate = aBaseFinDate
	end if
	if aHeadboardFinDate <> "" then
		if datediff("S", aCompletionDate, aHeadboardFinDate) > 0 then aCompletionDate = aHeadboardFinDate
	end if

	if datediff("S", aCompletionDate, cdate("01/01/1970")) = 0 then
		calcOrderProductionCompletionDate = ""
	else
		calcOrderProductionCompletionDate = aCompletionDate
	end if
end function

function getComponentFinishedDate(byref acon, apn, aCompId)
	dim ars
	getComponentFinishedDate = ""
	set ars = getMysqlQueryRecordSet("select finished from qc_history_latest where componentid=" & aCompId & " and purchase_no=" & apn, acon)
	if not ars.eof then
		if not isnull(ars("finished")) then
			getComponentFinishedDate = ars("finished")
		else
			getComponentFinishedDate = "not finished"
		end if
	end if
	closers(ars)
end function

sub setOrderProductionCompletionDate(byref acon, apn)
	dim aCompletionDate, asql
	aCompletionDate = calcOrderProductionCompletionDate(acon, apn)
	'response.write("<br>aCompletionDate = " & aCompletionDate)
	if aCompletionDate <> "" then
		asql = "update purchase set production_completion_date = '" & toMysqlDate(aCompletionDate) & "' where purchase_no=" & apn
	acon.execute(asql)
		else
		asql = "update purchase set production_completion_date = null where purchase_no=" & apn

		'response.write("<br>asql = " & asql)
		acon.execute(asql)
	end if
end sub

function hideOrderType(byref acon, aContactNo)
	dim asql, ars
	asql = "select * from contact where contact_no=" & aContactNo & " and idlocation=8" ' New York
	'response.write("<br>setDefaultDeliveryAddress: asql = " & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
	hideOrderType = not ars.eof ' if customer is from new york, order type should be hidden
	call closeRs(ars)
end function

function hideVatRate(byref acon, aContactNo)
	hideVatRate = hideOrderType(acon, aContactNo) ' same as hideOrderType functionality, for the moment at least
end function

function hideShipper(byref acon, aContactNo)
	hideShipper = hideOrderType(acon, aContactNo) ' same as hideOrderType functionality, for the moment at least
end function

function hideOrderCurrency(byref acon, aContactNo)
	hideOrderCurrency = hideOrderType(acon, aContactNo) ' same as hideOrderType functionality, for the moment at least
end function

function hidePaymentType(byref acon, aContactNo)
	hidePaymentType = hideOrderType(acon, aContactNo) ' same as hideOrderType functionality, for the moment at least
end function

function getComponentPrice(byref acon, acompid, apn)
	dim ars, asql
	getComponentPrice = 0.0
	asql = "select * from purchase where purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		if acompid = 1 then
			' mattress
			getComponentPrice = safeCur(ars("mattressprice"))
	end if
		if acompid = 3 then
			' base
			getComponentPrice = safeCur(ars("baseprice")) + safeCur(ars("drawerprice")) + safeCur(ars("basetrimprice")) + safeCur(ars("basedrawersprice")) + safeCur(ars("basefabricprice")) + safeCur(ars("upholsteryprice"))
	end if
		if acompid = 5 then
			' topper
			getComponentPrice = safeCur(ars("topperprice"))
	end if
		if acompid = 6 then
			' valance
			getComponentPrice = safeCur(ars("valanceprice")) + safeCur(ars("valfabricprice"))
	end if
		if acompid = 7 then
			' legs
			getComponentPrice = safeCur(ars("legprice")) + safeCur(ars("addlegprice"))
	end if
		if acompid = 8 then
			' headboard
			getComponentPrice = safeCur(ars("headboardprice")) + safeCur(ars("headboardtrimprice")) + safeCur(ars("hbfabricprice"))
	end if
		if acompid = 9 then
			' accessories
			getComponentPrice = safeCur(ars("accessoriestotalcost"))
	end if
	end if
	closers(ars)
end function

function getCustRef(byref acon, byval apn)
	dim asql, ars
	asql = "select customerreference from purchase where purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	getCustRef = ""
	if not ars.eof then
		getCustRef = ars("customerreference")
	end if
	closers(ars)
end function

function getColourForEntry(byref acon, byval apn, byval afname, byval acompid)
	dim asql, ars
	asql = "select * from QC_history_latest where componentid=" & acompid & " and purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	getColourForEntry = ""
	if not ars.eof then
		if ars(afname)<>"" then
		getColourForEntry = "green" 
		else
		getColourForEntry = "red" 
		end if
	end if
	closers(ars)
end function


function getOrderNo(byref acon, byval apn)
	dim asql, ars
	asql = "select order_number from purchase where purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	getOrderNo = ""
	if not ars.eof then
		getOrderNo = ars("order_number")
	end if
	closers(ars)
end function

function getWrapType(byref acon, byval apn)
	dim asql, ars
	asql = "select W.wrapName from purchase P, wrappingtypes W where P.purchase_no=" & apn & " and P.wrappingid=W.wrappingid"
	set ars = getMysqlQueryRecordSet(asql, acon)
	getWrapType = ""
	if not ars.eof then
		getWrapType = ars("wrapName")
	end if
	closers(ars)
end function

function getDeliveryAddress(byref acon, byval apn)
	dim asql, ars, ars2, ars3, deladd2, intresult, compadd1, compadd2, deliveryaddress1, deliveryaddressfound
	deliveryaddressfound="n"
	asql = "Select * from purchase WHERE purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
	deliveryaddress=""
	If ars("deliveryadd1") <> "" then deliveryaddress= ars("deliveryadd1") & "<br>"
	If ars("deliveryadd1") <> "" then compadd1=ars("deliveryadd1") & "<br>"
	If ars("deliveryadd2") <> "" then deliveryaddress=deliveryaddress & ars("deliveryadd2") & "<br>"
	If ars("deliveryadd3") <> "" then deliveryaddress=deliveryaddress & ars("deliveryadd3") & "<br>"
	If ars("deliverytown") <> "" then deliveryaddress=deliveryaddress & ars("deliverytown") & "<br>"
	If ars("deliverycounty") <> "" then deliveryaddress=deliveryaddress & ars("deliverycounty") & "<br>"
	If ars("deliverypostcode") <> "" then deliveryaddress=deliveryaddress & ars("deliverypostcode") & "<br>"
	If ars("deliverypostcode") <> "" then compadd1=compadd1 & ars("deliverypostcode") & "<br>"
	If ars("deliverycountry") <> "" then deliveryaddress=deliveryaddress & ars("deliverycountry")
	
	asql = "Select * from delivery_address WHERE contact_no=" & ars("contact_no")
		set ars2 = getMysqlQueryRecordSet(asql, acon)
		if not ars2.eof then
			If ars2("add1") <> "" then compadd2= ars2("add1") & "<br>"
			If ars2("postcode") <> "" then compadd2=compadd2 & ars2("postcode") & "<br>"
			intresult=StrComp(compadd1,compadd2,1)
			if intresult=0 then
				deliveryaddress=ars2("DELIVERY_NAME") & "<br>" & deliveryaddress
				deliveryaddressfound="y"
			end if
		end if
		closers(ars2)
		if deliveryaddressfound="n" then
			asql = "Select * from address WHERE code=" & ars("code")
			set ars2 = getMysqlQueryRecordSet(asql, acon)
			if not ars2.eof then
				If ars2("street1") <> "" then compadd2=ars2("street1") & "<br>"
				If ars2("postcode") <> "" then compadd2=compadd2 & ars2("postcode") & "<br>"
				intresult=StrComp(compadd1,compadd2,1)
				if intresult=0 then
					asql = "Select * from contact WHERE contact_no=" & ars("contact_no")
					set ars3 = getMysqlQueryRecordSet(asql, acon)
					if not ars3.eof then
					deliveryaddress=ars3("title") & " " & ars3("first") & " " & ars3("surname") & "<br>" & deliveryaddress
					end if
					closers(ars3)
					deliveryaddressfound="y"
				end if
			end if
			closers(ars2)
		end if
		
		getDeliveryAddress = ""
		getDeliveryAddress = deliveryaddress
	end if
	closers(ars)
end function

function getDelAddressLinecount(byref acon, byval apn)
	dim asql, ars, lc
	lc=0
	asql = "Select * from purchase WHERE purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		If ars("deliveryadd1") <> "" then lc=lc+2
		If ars("deliveryadd2") <> "" then lc=lc+1
		If ars("deliveryadd3") <> "" then lc=lc+1
		If ars("deliverytown") <> "" then lc=lc+1
		If ars("deliverycounty") <> "" then lc=lc+1
		If ars("deliverypostcode") <> "" then lc=lc+1
		If ars("deliverycountry") <> "" then lc=lc+1
	end if
	closers(ars)
	asql = "Select * from phonenumber WHERE purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
	lc=lc+ars.recordcount
	end if
	closers(ars)
	getDelAddressLinecount = ""
	getDelAddressLinecount = lc
end function

function getDeliveryContact(byref acon, byval apn)
	dim asql, ars, deliveryinfo
	asql = "Select * from purchase WHERE purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		deliveryinfo=""
		If ars("deliveryContact") <> "" then deliveryinfo= ars("deliveryContact")
		getDeliveryContact = ""
		getDeliveryContact = deliveryinfo
	end if
	closers(ars)
end function

function getDeliveryPrice(byref acon, byval apn)
	dim asql, ars
	asql = "Select * from purchase WHERE purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	getDeliveryPrice = 0.0
	if not ars.eof and ars("deliveryprice") <> "" then
		 getDeliveryPrice = cdbl(ars("deliveryprice"))
	end if
	closers(ars)
end function

function checkifdiscount(byref acon, byval apn)
	dim asql, ars, discount
	discount=false
	asql = "Select * from comp_price_discount WHERE purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		do until ars.eof
		If Cdbl(ars("discount")) > 0 then discount=true
		ars.movenext
		loop
	end if
	closers(ars)
	asql = "Select * from purchase WHERE purchase_no=" & apn	
		set ars = getMysqlQueryRecordSet(asql, acon)
		if not ars.eof then
			if isNull(ars("tradediscount")) then
			else
				if Cdbl(ars("tradediscount"))>0 then discount=true
			end if
			if isNull(ars("discount")) then
			else
				if Cdbl(ars("discount"))>0 then discount=true
			end if
		end if
	closers(ars)
	checkifdiscount=discount

end function
	
function getDeliveryTelNos(byref acon, byval apn)
	dim asql, ars, deliverynos
	asql = "Select * from phonenumber WHERE purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		Do until ars.eof
		deliverynos=deliverynos & ars("phonenumbertype") & " " & ars("number") & "<br>"
		ars.movenext
		loop
		getDeliveryTelNos = ""
		getDeliveryTelNos = deliverynos
	end if
	closers(ars)	
end function

function getPaymentsForInvoiceNo(aInvNo, aPurchaseNo, byref acon)
	dim ars, aAmount, aSql
	if aInvNo<>"" then
	aSql="select * from payment where invoice_number='" & aInvNo & "' and purchase_no=" & aPurchaseNo
	set ars = getMysqlQueryRecordSet(aSql, acon)
	aAmount = 0
	while not ars.eof
		aAmount=aAmount + CDbl(ars("amount"))
		ars.movenext
	wend
	closers(ars)
	getPaymentsForInvoiceNo = aAmount
	else
	getPaymentsForInvoiceNo=0
	end if
	
end function

function getOutstandingForInvoiceNo(aTotalInvoice, aInvNo, aPurchaseNo, byref acon)
	dim ars, aAmount, aSql, aOutstandingAmt
	if aInvNo<>"" then
	aSql="select * from payment where invoice_number='" & aInvNo & "' and purchase_no=" & aPurchaseNo
	set ars = getMysqlQueryRecordSet(aSql, acon)
	aAmount = 0
	while not ars.eof
		aAmount=aAmount + CDbl(ars("amount"))
		ars.movenext
	wend
	aOutstandingAmt=CDbl(aTotalInvoice)-aAmount
	closers(ars)
	getOutstandingForInvoiceNo = aOutstandingAmt
	else
	getOutstandingForInvoiceNo=0
	end if
end function

sub checkOrderNotEmpty(byref areq, aForwardUrl)
	dim aIsEmpty, aRespStr
	aIsEmpty = (areq("mattressrequired") <> "y") and (areq("baserequired") <> "y") and (areq("headboardrequired") <> "y") and (areq("topperrequired") <> "y") and (areq("valancerequired") <> "y") and (areq("legsrequired") <> "y") and (areq("accessoriesrequired") <> "y") and (areq("deliverycharge") <> "y")
	
	if aIsEmpty then
		aRespStr = "<html><head></head><body>"
		aRespStr = aRespStr & "<script language='JavaScript' type='text/javascript'>"
		aRespStr = aRespStr & "alert('The order appears to have nothing in it. If this intentional, then please cancel the order instead. If not, then there may have been an error in the form - please report this to your manager. The order has not been updated.');"
		aRespStr = aRespStr & " window.location='" & aForwardUrl & "';"
		aRespStr = aRespStr & "</script>"
		aRespStr = aRespStr & "</body></html>"
		response.write(aRespStr)
		response.end
	end if
end sub

function checkAccessoryChange(byref aCon, aacc_id, aacc_desc, aacc_design, aacc_colour, aacc_size, aacc_unitprice, aacc_qty, byref aarrayCounter, byref aemailArray1, byref aemailArray2, byref aemailArray3)
	dim ars, aSql, accFieldValueOld, accFieldValueNew, accFieldName
	checkAccessoryChange=false
	aSql="select * from orderaccessory where orderaccessory_id='" & aacc_id & "'"
	set ars = getMysqlQueryRecordSet(aSql, acon)
	accFieldName="<br>"
	accFieldValueOld="<br>"
	accFieldValueNew="<br>"
	if ars("description")<>aacc_desc then
		accFieldName=accFieldName & "Description:<br>"
		accFieldValueOld=accFieldValueOld & ars("description") & "<br>"
		accFieldValueNew=accFieldValueNew & aacc_desc & "<br>"
		checkAccessoryChange=true
	end if
	if ars("design")<>aacc_design then
		accFieldName=accFieldName & "Design:<br>"
		accFieldValueOld=accFieldValueOld & ars("design") & "<br>"
		accFieldValueNew=accFieldValueNew & aacc_design & "<br>"
		checkAccessoryChange=true
	end if
	if ars("colour")<>aacc_colour then
		accFieldName=accFieldName & "Colour:<br>"
		accFieldValueOld=accFieldValueOld & ars("colour") & "<br>"
		accFieldValueNew=accFieldValueNew & aacc_colour & "<br>"
		checkAccessoryChange=true
	end if
	if ars("size")<>aacc_size then
		accFieldName=accFieldName & "Size:<br>"
		accFieldValueOld=accFieldValueOld & ars("size") & "<br>"
		accFieldValueNew=accFieldValueNew & aacc_size & "<br>"
		checkAccessoryChange=true
	end if
	if CDbl(ars("unitprice"))<>CDbl(aacc_unitprice) then
		accFieldName=accFieldName & "Colour:<br>"
		accFieldValueOld=accFieldValueOld & ars("unitprice") & "<br>"
		accFieldValueNew=accFieldValueNew & aacc_unitprice & "<br>"
		checkAccessoryChange=true
	end if
	if CDbl(ars("qty"))<>CDbl(aacc_qty) then
		accFieldName=accFieldName & "Quantity:<br>"
		accFieldValueOld=accFieldValueOld & ars("qty") & "<br>"
		accFieldValueNew=accFieldValueNew & aacc_qty & "<br>"
		checkAccessoryChange=true
	end if
	if checkAccessoryChange then
		aarrayCounter=aarrayCounter+1
		redim preserve aemailArray1(aarrayCounter)
		redim preserve aemailArray2(aarrayCounter)
		redim preserve aemailArray3(aarrayCounter)
		aemailArray1(aarrayCounter) = "Accessories: " & acc_desc & " " & accFieldName
		aemailArray2(aarrayCounter) = accFieldValueOld
		aemailArray3(aarrayCounter) = accFieldValueNew
	end if
	closers(ars)
end function

function checkAccessoryDeleted(byref aCon, aacc_id, byref aarrayCounter, byref aemailArray1, byref aemailArray2, byref aemailArray3)
	dim ars, aSql, accFieldValueOld, accFieldValueNew, accFieldName
	checkAccessoryDeleted=false
	aSql="select * from orderaccessory where orderaccessory_id='" & aacc_id & "'"
	set ars = getMysqlQueryRecordSet(aSql, acon)
	accFieldName="<br>"
	accFieldValueOld="<br>"
	accFieldValueNew="<br>"
	accFieldName=accFieldName & "Description:<br>"
	accFieldValueOld=accFieldValueOld & ars("description") & "<br>"
	accFieldName=accFieldName & "Design:<br>"
	accFieldValueOld=accFieldValueOld & ars("design") & "<br>"
	accFieldName=accFieldName & "Colour:<br>"
	accFieldValueOld=accFieldValueOld & ars("colour") & "<br>"
	accFieldName=accFieldName & "Size:<br>"
	accFieldValueOld=accFieldValueOld & ars("size") & "<br>"
	accFieldName=accFieldName & "Colour:<br>"
	accFieldValueOld=accFieldValueOld & ars("unitprice") & "<br>"
	accFieldName=accFieldName & "Quantity:<br>"
	accFieldValueOld=accFieldValueOld & ars("qty") & "<br>"
	aarrayCounter=aarrayCounter+1
	redim preserve aemailArray1(aarrayCounter)
	redim preserve aemailArray2(aarrayCounter)
	redim preserve aemailArray3(aarrayCounter)
	aemailArray1(aarrayCounter) = "Accessories: " & acc_desc & " " & accFieldName
	aemailArray2(aarrayCounter) = accFieldValueOld
	aemailArray3(aarrayCounter) = "Accessory Deleted"
	closers(ars)
end function

function getOrderComponentSummary(byref acon, apn, acomponentId)
	dim aKeys(), aVals(), asql, an, aAdaptedValue, ars
	getOrderComponentSummary = ""

 	call getColNamesForComponent(acomponentId, aKeys, aVals)
 	if ubound(aKeys) = 0 then
 		exit function
 	end if

 	asql = "select "
 	for an = 1 to ubound(aKeys)
 		if an > 1 then asql = asql & ","
 		asql = asql & aKeys(an)
 	next
 	asql = asql & " from purchase where purchase_no=" & apn
 	'response.write("<br>asql = " & asql)
 	'response.end
 	set ars = getMysqlQueryRecordSet(asql, acon)
 	
 	if not ars.eof then
	 	for an = 1 to ubound(aKeys)
	 		aAdaptedValue = adaptComponentValue(acon, aKeys(an), ars(aKeys(an)), acomponentId, apn)
	 		getOrderComponentSummary = getOrderComponentSummary & aAdaptedValue & " "
	 	next
 	end if
 	
 	call closemysqlrs(ars)
end function

sub getColNamesForComponent(acomponentId, byref aKeys, byref aVals)
	if acomponentId = 1 then
		' mattress
		redim preserve aKeys(7)
		redim preserve aVals(7)
		aKeys(1) = "savoirmodel"
		aVals(1) = "Model"
		aKeys(2) = "mattresstype"
		aVals(2) = "Type"
		aKeys(3) = "mattresswidth"
		aVals(3) = "Width"
		aKeys(4) = "mattresslength"
		aVals(4) = "Length"
		aKeys(5) = "leftsupport"
		aVals(5) = "Left Support"
		aKeys(6) = "rightsupport"
		aVals(6) = "Right Support"
		aKeys(7) = "tickingoptions"
		aVals(7) = "Ticking Options"
	end if
	if acomponentId = 3 then
		' base
		redim preserve aKeys(4)
		redim preserve aVals(4)
		aKeys(1) = "basesavoirmodel"
		aVals(1) = "Model"
		aKeys(2) = "basetype"
		aVals(2) = "Type"
		aKeys(3) = "basewidth"
		aVals(3) = "Width"
		aKeys(4) = "baselength"
		aVals(4) = "Length"
		'aKeys(5) = "basefabric"
		'aVals(5) = "Fabric"
		'aKeys(6) = "basefabricdirection"
		'aVals(6) = "Fabric Direction"
	end if
	if acomponentId = 5 then
		' topper
		redim preserve aKeys(4)
		redim preserve aVals(4)
		aKeys(1) = "toppertype"
		aVals(1) = "Type"
		aKeys(2) = "topperwidth"
		aVals(2) = "Width"
		aKeys(3) = "topperlength"
		aVals(3) = "Length"
		aKeys(4) = "toppertickingoptions"
		aVals(4) = "Ticking Options"
	end if
	if acomponentId = 8 then
		' headboard
		redim preserve aKeys(1)
		redim preserve aVals(1)
		aKeys(1) = "headboardstyle"
		aVals(1) = "Style"
		'aKeys(2) = "headboardfabric"
		'aVals(2) = "Fabric"
		'aKeys(3) = "headboardheight"
		'aVals(3) = "Height"
		'aKeys(4) = "headboardfinish"
		'aVals(4) = "Finish"
		'aKeys(5) = "headboardfabricdirection"
		'aVals(5) = "Fabric Direction"
	end if 
	if acomponentId = 6 then
		' valance
		redim preserve aKeys(6)
		redim preserve aVals(6)
		aKeys(1) = "valancefabric"
		aVals(1) = "Fabric"
		aKeys(2) = "valancefabricchoice"
		aVals(2) = "Selection"
		aKeys(3) = "valancefabricDirection"
		aVals(3) = "Fabric Direction"
		aKeys(4) = "valancewidth"
		aVals(4) = "Width"
		aKeys(5) = "valancelength"
		aVals(5) = "Length"
		aKeys(6) = "valancedrop"
		aVals(6) = "Drop"
	end if
	if acomponentId = 7 then
		' legs
		redim preserve aKeys(3)
		redim preserve aVals(3)
		aKeys(1) = "legstyle"
		aVals(1) = "Style"
		aKeys(2) = "legfinish"
		aVals(2) = "Finish"
		aKeys(3) = "legheight"
		aVals(3) = "Height"
	end if
end sub

function adaptComponentValue(byref acon, akey, aOldValue, acomponentId, apn)
	dim asql, ars
	adaptComponentValue = aOldValue
	
	if acomponentId = 1 then
		' mattress
		if akey = "mattresswidth" and aOldValue = "Special Width" then
			asql = "SELECT matt1width,matt2width FROM productionsizes where purchase_no=" & apn
			set ars = getMysqlQueryRecordSet(asql, acon)
			if not ars.eof then
				adaptComponentValue = ars("matt1width") & "cm"
				if ars("matt2width") <> "" then
					adaptComponentValue = adaptComponentValue & " &amp; " & ars("matt2width") & "cm"
				end if
			end if
		 	call closemysqlrs(ars)
		end if
	end if
	
	if acomponentId = 1 then
		' mattress
		if akey = "mattresslength" and aOldValue = "Special Length" then
			asql = "SELECT matt1length,matt2length FROM productionsizes where purchase_no=" & apn
			set ars = getMysqlQueryRecordSet(asql, acon)
			if not ars.eof then
				adaptComponentValue = ars("matt1length") & "cm"
				if ars("matt2length") <> "" then
					adaptComponentValue = adaptComponentValue & " &amp; " & ars("matt2length") & "cm"
				end if
			end if
		 	call closemysqlrs(ars)
		end if
	end if
	
	if acomponentId = 3 then
		' base
		if akey = "basewidth" and aOldValue = "Special Width" then
			asql = "SELECT base1width,base2width FROM  productionsizes where purchase_no=" & apn
			set ars = getMysqlQueryRecordSet(asql, acon)
			if not ars.eof then
				adaptComponentValue = ars("base1width") & "cm"
				if ars("base2width") <> "" then
					adaptComponentValue = adaptComponentValue & " &amp; " & ars("base2width") & "cm"
				end if
			end if
		 	call closemysqlrs(ars)
		end if
	end if
	
	if acomponentId = 3 then
		' base
		if akey = "baselength" and aOldValue = "Special Length" then
			asql = "SELECT base1length,base2length FROM  productionsizes where purchase_no=" & apn
			set ars = getMysqlQueryRecordSet(asql, acon)
			if not ars.eof then
				adaptComponentValue = ars("base1length") & "cm"
				if ars("base2length") <> "" then
					adaptComponentValue = adaptComponentValue & " &amp; " & ars("base2length") & "cm"
				end if
			end if
		 	call closemysqlrs(ars)
		end if
	end if
	
	if acomponentId = 5 then
		' topper
		if akey = "topperwidth" and aOldValue = "Special Width" then
			asql = "SELECT topper1width FROM  productionsizes where purchase_no=" & apn
			set ars = getMysqlQueryRecordSet(asql, acon)
			if not ars.eof then
				adaptComponentValue = ars("topper1width") & "cm"
			end if
		 	call closemysqlrs(ars)
		end if
	end if
	
	if acomponentId = 5 then
		' topper
		if akey = "topperlength" and aOldValue = "Special Length" then
			asql = "SELECT topper1length FROM  productionsizes where purchase_no=" & apn
			set ars = getMysqlQueryRecordSet(asql, acon)
			if not ars.eof then
				adaptComponentValue = ars("topper1length") & "cm"
			end if
		 	call closemysqlrs(ars)
		end if
	end if
	
end function

sub deleteChildlessAdhocExports(byref acon)
	dim asql, ars
	asql = "select e.exportCollectionsID,s.exportCollshowroomsID from exportcollections e, exportcollshowrooms s"
	asql = asql & " where e.exportCollectionsID=s.exportCollectionID"
	asql = asql & " and e.transportmode='Adhoc Courier' and e.containerref='Adhoc Courier'"
	asql = asql & " and s.exportCollshowroomsID not in (SELECT distinct LinksCollectionID from exportlinks)"
	Set ars = getMysqlQueryRecordSet(asql, acon)
	while not ars.eof
	acon.execute("delete from exportcollections where exportCollectionsID=" & ars("exportCollectionsID"))
	acon.execute("delete from exportcollshowrooms where exportCollshowroomsID=" & ars("exportCollshowroomsID"))
	ars.movenext
	wend
	ars.close
	set ars = nothing
end sub

sub deletePackagingDataForComponent(byref acon, apn, acompid)
	dim asql
	asql = "delete from packagingdata where Purchase_no=" & apn & " and componentID=" & acompid
	call log(scriptname, "deletePackagingDataForComponent: " & aSql)
	acon.execute(asql)
	asql = "update packagingdata set packedwith=null where packedwith='" & acompid & "' and Purchase_no=" & apn
	'response.end()
	call log(scriptname, "deletePackagingDataForComponent: " & aSql)
	acon.execute(asql)
end sub

sub saveWholesalePrice(byref acon, apn, acompid, aprice)
	dim asql, ars
	if aprice <> "" then
		asql = "Select * from wholesale_prices WHERE Purchase_No=" & apn & " and componentID=" & acompid
	    Set ars = getMysqlUpdateRecordSet(asql, acon)
		if  ars.eof then
			ars.AddNew
			ars("componentID")=acompid
			ars("purchase_no")=apn
		end if
		ars("price")=aprice
		ars.Update	
		call closemysqlrs(ars)
	else
		acon.execute("delete from wholesale_prices WHERE Purchase_No=" & apn & " and componentID=" & acompid)
	end if
end sub

function getAccIdForSequence(byref acon, aPn, aSeq)
	dim asql, ars, an
	asql = "select * from orderaccessory where purchase_no=" & aPn & " order by orderaccessory_id"
	Set ars = getMysqlQueryRecordSet(asql, acon)
	an = 0
	getAccIdForSequence = 0
	while not ars.eof
		an = an + 1
		if an = aSeq then
			getAccIdForSequence = ars("orderaccessory_id")
		end if
		ars.movenext
	wend
	call closemysqlrs(ars)
end function

function getCustomerOrdersAndValues(byref acon, byval aContactNo, aDate)
	dim asql, ars, aVals(), aCount, aTotExVat
	aDate=toUSADate(aDate)
	asql = "select purchase_no, order_date, order_number, total, ordercurrency from purchase where order_date > '" & aDate & "' and (cancelled<>'y' or cancelled is null) AND contact_no=" & aContactNo & " order by order_date asc"
	'response.Write("asql=" & asql)
	'response.End()
	set ars = getMysqlQueryRecordSet(asql, acon)
	aCount = 0
	while not ars.eof
		if not isnull(ars("total")) then
			aCount = aCount + 1
			redim preserve aVals(aCount)
			aVals(aCount) = left(ars("order_date"),10) & "&nbsp;<a href=""edit-purchase.asp?order=" & ars("purchase_no") & """>" & ars("order_number") & "</a>&nbsp;" & (fmtCurr2(ars("total"), true, ars("ordercurrency")))
		end if
		ars.movenext
	wend
	if aCount = 0 then redim aVals(0)
	closers(ars)
	getCustomerOrdersAndValues = aVals
end function

function getCustomerOrderNos(byref acon, byval aContactNo, aDate)
	dim asql, ars, aVals(), aCount, aTotExVat
	aDate=toUSADate(aDate)
	asql = "select purchase_no, order_date, order_number, total, ordercurrency from purchase where order_date > '" & aDate & "' and (cancelled<>'y' or cancelled is null) AND contact_no=" & aContactNo & " order by order_date asc"
	'response.Write("asql=" & asql)
	'response.End()
	set ars = getMysqlQueryRecordSet(asql, acon)
	getCustomerOrderNos=""
	while not ars.eof
	getCustomerOrderNos=getCustomerOrderNos & ars("order_number") & vbCrLf
		ars.movenext
	wend
	closers(ars)
end function

function getCustomerOrderVals(byref acon, byval aContactNo, aDate)
	dim asql, ars, aVals(), aCount, aTotExVat
	aDate=toUSADate(aDate)
	asql = "select purchase_no, order_date, order_number, total, ordercurrency from purchase where order_date > '" & aDate & "' and (cancelled<>'y' or cancelled is null) AND contact_no=" & aContactNo & " order by order_date asc"
	'response.Write("asql=" & asql)
	'response.End()
	set ars = getMysqlQueryRecordSet(asql, acon)
	getCustomerOrderVals=""
	while not ars.eof
	getCustomerOrderVals=getCustomerOrderVals & fmtCurr2(ars("total"), true, ars("ordercurrency")) & vbCrLf
		ars.movenext
	wend
	closers(ars)
end function



function getCustomerAddress(byref acon, aCode)
	dim ars, aAddress, asql
	asql = "select * from address where code=" & aCode

	Set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		if ars("Company")<>"" then aAddress = ars("Company") & "<br>"
		if ars("street1")<>"" then aAddress = aAddress & ars("street1") & "<br>"
		if ars("street2")<>"" then aAddress = aAddress & ars("street2") & "<br>"
		if ars("street3")<>"" then aAddress = aAddress & ars("street3") & "<br>"
		if ars("town")<>"" then aAddress = aAddress & ars("town") & "<br>"
		if ars("county")<>"" then aAddress = aAddress & ars("county") & "<br>"
		if ars("postcode")<>"" then aAddress = aAddress & ars("postcode") & "<br>"
		if ars("country")<>"" then aAddress = aAddress & ars("country") & "<br>"
	end if
	ars.close
	set ars = nothing
	getCustomerAddress = aAddress
end function
%>
 