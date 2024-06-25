<%
class carrage

	public code
	public name
	public price
	public seq

end class

class addr

	public idAddr
	public line1
	public line2
	public line3
	public line4
	public line5
	public postcode
	public country

end class

class cust

	public idCust
	public title
	public forename
	public surname
	public tel
	public worktel
	public mobile
	public email
	public idAddr_delivery
	public idAddr_invoice
	public wholename
	public cardname

end class

class delivery

	public deliveryId
	public deltype
	public desc
	public cost
	public seq

end class

class orderdelivery

	public idOrder
	public delareaId
	public deldayId
	public deltimeId
			
end class

class card	' non-db for the mo

	public idCust
	public cardNo
	public cardName
	public issueNo
	public seccode
	public cardType
	public expMon
	public expYr
	public startMon
	public startYr
			
end class

function getAllCarrages()

	dim ars, theCarrages(), aCarrage, i
	
	set ars = getQueryRecordSet("SELECT * FROM CARRAGE ORDER BY SEQ")
	i = 0

	while not ars.eof
		i = i + 1
		set aCarrage = new carrage
		aCarrage.code = ars("CODE")
		aCarrage.name = ars("NAME")
		aCarrage.price = ars("PRICE")
		aCarrage.seq = ars("SEQ")
	
		redim preserve theCarrages(i)
		set theCarrages(i) = aCarrage

		ars.movenext
	wend

	closers(ars)
	
	getAllCarrages = theCarrages

end function

function getCarrage(byval aCarrageCode)

	dim ars
	set ars = getQueryRecordSet("SELECT * FROM CARRAGE WHERE CODE='" & aCarrageCode & "'")

	while not ars.eof
		set getCarrage = new carrage
		getCarrage.code = ars("CODE")
		getCarrage.name = ars("NAME")
		getCarrage.price = ars("PRICE")
		getCarrage.seq = ars("SEQ")
		ars.movenext
	wend

	closers(ars)

end function

function insertAddress(byref aAddr)

	dim asql, ars
	asql = "INSERT INTO ADDR (LINE1,LINE2,LINE3,LINE4,LINE5,POSTCODE,COUNTRY)"
	asql = asql + " VALUES ('" & aAddr.line1 & "','" & aAddr.line2 & "','" & aAddr.line3 & "','" & aAddr.line4 & "','" & aAddr.line5 & "','" & aAddr.postcode & "','" & aAddr.country & "')"
	
	call conExecute(asql)
	set ars = getQueryRecordSet("SELECT MAX(IDADDR) AS MX FROM ADDR")
	while not ars.eof
		insertAddress = ars("MX")
		ars.movenext
	wend
	closers(ars)
	
end function

sub updateAddress(byref aAddr)

	dim asql
	asql = "UPDATE ADDR SET LINE1='" & aAddr.line1 & "',LINE2='" & aAddr.line2 & "',LINE3='" & aAddr.line3 & "',LINE4='" & aAddr.line4 & "',LINE5='" & aAddr.line5 & "',POSTCODE='" & aAddr.postcode & "',COUNTRY='" & aAddr.country & "' WHERE IDADDR=" & aAddr.idAddr

	call conExecute(asql)

end sub

function getAddress(byval aIdAddr)

	dim ars
	set ars = getQueryRecordSet("SELECT * FROM ADDR WHERE IDADDR=" & aIdAddr)

	while not ars.eof
		set getAddress = new addr
		getAddress.idAddr = ars("IDADDR")
		getAddress.line1 = ars("LINE1")
		getAddress.line2 = ars("LINE2")
		getAddress.line3 = ars("LINE3")
		getAddress.line4 = ars("LINE4")
		getAddress.line5 = ars("LINE5")
		getAddress.postcode = ars("POSTCODE")
		getAddress.country = ars("COUNTRY")
		ars.movenext
	wend

	closers(ars)

end function

function insertCustomer(byref aCust)

	dim asql, ars
	asql = "INSERT INTO CUST (TITLE,FORENAME,SURNAME,TEL,WORKTEL,MOBILE,EMAIL,IDADDR_DELIVERY,IDADDR_INVOICE,WHOLENAME,CARDNAME)"
	asql = asql + " VALUES ('" & aCust.title & "','" & aCust.forename & "','" & aCust.surname & "','" & aCust.tel & "','" & aCust.worktel & "','" & aCust.mobile & "','" & aCust.email & "'," & aCust.idAddr_delivery & "," & aCust.idAddr_invoice & ",'" & aCust.wholename & "','" & aCust.cardname & "')"
	
	call conExecute(asql)
	set ars = getQueryRecordSet("SELECT MAX(IDCUST) AS MX FROM CUST")
	while not ars.eof
		insertCustomer = ars("MX")
		ars.movenext
	wend
	closers(ars)
	
end function

sub updateCustomer(byref aCust)

	dim asql
	asql = "UPDATE CUST SET TITLE='" & aCust.title & "',FORENAME='" & aCust.forename & "',SURNAME='" & aCust.surname & "'," &_
		"TEL='" & aCust.tel & "',WORKTEL='" & aCust.worktel & "',MOBILE='" & aCust.mobile & "',EMAIL='" & aCust.email & "'," &_
		"IDADDR_DELIVERY=" & aCust.idAddr_delivery & ",IDADDR_INVOICE=" & aCust.idAddr_invoice & ",WHOLENAME='" & aCust.wholename & "',CARDNAME='" & aCust.cardname & "' " &_
		"WHERE IDCUST=" & aCust.idCust

	'response.write(asql)
	call conExecute(asql)

end sub

function getCustomer(byval aIdCust)

	dim ars
	set ars = getQueryRecordSet("SELECT * FROM CUST WHERE IDCUST=" & aIdCust)

	while not ars.eof
		set getCustomer = new cust
		getCustomer.idCust = ars("IDCUST")
		getCustomer.title = ars("TITLE")
		getCustomer.forename = ars("FORENAME")
		getCustomer.surname = ars("SURNAME")
		getCustomer.tel = ars("TEL")
		getCustomer.worktel = ars("WORKTEL")
		getCustomer.mobile = ars("MOBILE")
		getCustomer.email = ars("EMAIL")
		getCustomer.idAddr_delivery = ars("IDADDR_DELIVERY")
		getCustomer.idAddr_invoice = ars("IDADDR_INVOICE")
		getCustomer.wholename = ars("WHOLENAME")
		getCustomer.cardname = ars("CARDNAME")
		ars.movenext
	wend

	closers(ars)

end function

function getCurrentCustomer()

	set getCurrentCustomer = getCurrentCustomer2(false)
	
end function

function getCurrentCustomer2(byval singleAddress)

	dim aIdCust, aInvAddr, aDelAddr
	aIdCust = session("IDCUST")
	if aIdCust = "" then
		set getCurrentCustomer2 = new cust
		set aDelAddr = new addr
		getCurrentCustomer2.idAddr_delivery = insertAddress(aDelAddr)
		if singleAddress then
			getCurrentCustomer2.idAddr_invoice = getCurrentCustomer2.idAddr_delivery
		else
			set aInvAddr = new addr
			getCurrentCustomer2.idAddr_invoice = insertAddress(aInvAddr)
		end if
		aIdCust = insertCustomer(getCurrentCustomer2)
		getCurrentCustomer2.idCust = aIdCust
		session("IDCUST") = aIdCust
	else
		set getCurrentCustomer2 = getCustomer(aIdCust)
	end if
	
end function

function getDelivery(byval aDeliveryId, byval aType)

	dim ars
	set ars = getQueryRecordSet("SELECT * FROM DELIVERY WHERE DELIVERYID='" & aDeliveryId & "' AND DELTYPE='" & aType & "'")
	set getDelivery = new delivery

	while not ars.eof
		getDelivery.deliveryId = ars("DELIVERYID")
		getDelivery.deltype = ars("DELTYPE")
		getDelivery.desc = ars("DESC")
		getDelivery.cost = ccur(ars("COST"))
		getDelivery.seq = cint(ars("SEQ"))
		ars.movenext
	wend
	
	closers(ars)

end function

function getDeliveriesForType(byval aType, byref arrDelIdsToExclude)

	dim ars, asql, theDeliveries(), aDelivery, i
	
	asql = "SELECT * FROM DELIVERY WHERE DELTYPE='" & aType & "'"
	for i = 1 to ubound(arrDelIdsToExclude)
		asql = asql & " AND DELIVERYID <> '" & arrDelIdsToExclude(i) & "'"
	next
	
	asql = asql & " ORDER BY SEQ"
	set ars = getQueryRecordSet(asql)
	i = 0

	while not ars.eof
		i = i + 1
		set aDelivery = new delivery
		aDelivery.deliveryId = ars("DELIVERYID")
		aDelivery.deltype = ars("DELTYPE")
		aDelivery.desc = ars("DESC")
		aDelivery.cost = ccur(ars("COST"))
		aDelivery.seq = cint(ars("SEQ"))
	
		redim preserve theDeliveries(i)
		set theDeliveries(i) = aDelivery

		ars.movenext
	wend
	
	if i = 0 then redim theDeliveries(0)

	closers(ars)
	
	getDeliveriesForType = theDeliveries

end function

function getCurrentOrderDelivery(byval aIdOrder)

	dim ars
	set ars = getQueryRecordSet("SELECT * FROM ORDERDELIVERY WHERE IDORDER=" & aIdOrder)
	set getCurrentOrderDelivery = new orderdelivery
	getCurrentOrderDelivery.idOrder = aIdOrder

	if ars.eof then
		getCurrentOrderDelivery.delareaId = ""
		getCurrentOrderDelivery.deldayId = ""
		getCurrentOrderDelivery.deltimeId = ""
		call insertOrderDelivery(getCurrentOrderDelivery)
	else
		while not ars.eof
			getCurrentOrderDelivery.delareaId = ars("DELAREAID")
			getCurrentOrderDelivery.deldayId = ars("DELDAYID")
			getCurrentOrderDelivery.deltimeId = ars("DELTIMEID")
			ars.movenext
		wend
	end if
	
	closers(ars)

end function

sub insertOrderDelivery(byref aOrderDelivery)

	dim asql
	asql = "INSERT INTO ORDERDELIVERY (IDORDER,DELAREAID,DELDAYID,DELTIMEID)"
	asql = asql + " VALUES (" & aOrderDelivery.idOrder & ",'" & aOrderDelivery.delareaId & "','" & aOrderDelivery.deldayId & "','" & aOrderDelivery.deldayId & "')"
	call conExecute(asql)
	'response.write("<br>asql = " & asql)
	
end sub

sub updateOrderDelivery(byref aOrderDelivery)

	dim asql
	asql = "UPDATE ORDERDELIVERY SET DELAREAID='" & aOrderDelivery.delareaId & "',DELDAYID='" & aOrderDelivery.deldayId & "',DELTIMEID='" & aOrderDelivery.deltimeId & "' WHERE IDORDER=" & aOrderDelivery.idOrder
	call conExecute(asql)

end sub

function getCard(byval aIdCust)

	set getCard = new card
	if session("currentcard") <> "" then
		dim cardvals
		cardvals = split(session("currentcard"), "@@@")
		getCard.cardNo = getCardVal(cardvals(0))
		getCard.cardName = getCardVal(cardvals(1))
		getCard.issueNo = getCardVal(cardvals(2))
		getCard.seccode = getCardVal(cardvals(3))
		getCard.cardType = getCardVal(cardvals(4))
		getCard.expMon = getCardVal(cardvals(5))
		getCard.expYr = getCardVal(cardvals(6))
		getCard.startMon = getCardVal(cardvals(7))
		getCard.startYr = getCardVal(cardvals(8))
	end if

end function

sub updateCard(byval aIdCust, byref aCard)

	dim strCard
	call appendCardVal(strCard, aCard.cardNo)
	call appendCardVal(strCard, aCard.cardName)
	call appendCardVal(strCard, aCard.issueNo)
	call appendCardVal(strCard, aCard.seccode)
	call appendCardVal(strCard, aCard.cardType)
	call appendCardVal(strCard, aCard.expMon)
	call appendCardVal(strCard, aCard.expYr)
	call appendCardVal(strCard, aCard.startMon)
	call appendCardVal(strCard, aCard.startYr)
	session("currentcard") = strCard

end sub

sub appendCardVal(byref strCard, byval aVal)

	if aVal = "" then aVal = "___"
	strCard = strCard & aVal & "@@@" 

end sub

function getCardVal(byval aVal)

	getCardVal = aVal
	if getCardVal = "___" then getCardVal = ""

end function
%>