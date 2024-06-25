<%
const ORDERSTATUS_BASKET = "BASKET"
const ORDERSTATUS_PENDING = "PENDING"
const ORDERSTATUS_PAID = "PAID"
const ORDERSTATUS_ARCHIVED = "ARCHIVED"

class order

	public idOrder
	public ref
	public placed
	public idCust
	public status
	public carrageCode
	public pc

end class

class orderItem

	public idOrderItem
	public idOrder
	public idProd
	public idOpt1
	public idOpt2
	public idOpt3
	public qty

end class

class orderItemPrice

	public unitPrice
	public totalPrice

end class

class orderPrice

	public goodsPrice
	public goodsPricePreDiscount
	public carragePrice
	public totalPrice
	public delSuppThreshold
	public delSuppAmount
	public delSuppThresholdCrossed
	public discount

end class

function createOrderRef()

	dim aprefix, anextrefno
	aprefix = getDomainData("REFPREFIX")
	if not isOnline() then
		aprefix = "T" & aprefix
	end if
	anextrefno = cint(getDomainData("NEXTREFNO"))
	call updateDomainData("NEXTREFNO", anextrefno+1)
	
	createOrderRef = aprefix & anextrefno

end function

function createDateBasedOrderRef()

	dim aMaxIdOrderRef, aprefix, aParts, aSeq, dte, aDatePart, aMaxOrderDate, aStrDte

	aMaxIdOrderRef = getMaxIdOrderRef()
	dte = date()
	'response.write("<br>aMaxIdOrderRef = " & aMaxIdOrderRef)
	aprefix = getDomainData("REFPREFIX")
	
	if aMaxIdOrderRef <> "" then
		aMaxIdOrderRef = right(aMaxIdOrderRef, len(aMaxIdOrderRef)-len(aprefix))
		'response.write("<br>aMaxIdOrderRef = " & aMaxIdOrderRef)
		aParts = split(aMaxIdOrderRef, "-")
		aSeq = cint(aParts(1))
		'response.write("<br>aParts(0) = " & aParts(0))
		'response.write("<br>aSeq = " & aSeq)
		aStrDte = mid(aParts(0),5,2) & "/" & right(aParts(0),2) & "/" & left(aParts(0),4)
		'response.write("<br>aParts(0) = " & aParts(0))
		'response.write("<br>aStrDte = " & aStrDte)
		'response.end
		aMaxOrderDate = cdate(aStrDte)
		'response.write("<br>aMaxOrderDate = " & aMaxOrderDate)
	else
		aMaxOrderDate = cdate(#01/01/2000#)
	end if
	
	
	if aMaxOrderDate < dte then
		'response.write("<br>aMaxOrderDate < dte")
		aDatePart = formatNum(year(dte),4) & formatNum(month(dte),2) & formatNum(day(dte),2)
		aSeq = 1
	else
		'response.write("<br>NOT aMaxOrderDate < dte")
		aDatePart = aParts(0)
		aSeq = aSeq + 1
	end if
	'response.write("<br>aDatePart = " & aDatePart)
	'response.write("<br>aSeq = " & aSeq)
	'response.end
	
	createDateBasedOrderRef = aprefix & aDatePart & "-" & formatNum(aSeq, 4)
	'response.write("<br>createDateBasedOrderRef = " & createDateBasedOrderRef)

end function

function createOrder()

	dim ars
	call conExecute("INSERT INTO ORDERS (REF,PLACED,STATUS,CARRAGECODE,PC) VALUES ('',DATE(),'" & ORDERSTATUS_BASKET & "','','')")
	set ars = getQueryRecordSet("SELECT MAX(IDORDER) AS MAXID FROM ORDERS")
	while not ars.eof
		createOrder = ars("MAXID")
		ars.movenext
	wend
	closers(ars)
	'response.write("<br>createOrder = " & createOrder)
	'response.end
	
end function

sub updateOrder(byref aOrder)

	dim asql
	if isnull(aOrder.idCust) then aOrder.idCust = 0
	asql = "UPDATE ORDERS SET REF='" & aOrder.ref & "',PLACED=" & toDbDate(aOrder.placed) & ",IDCUST=" & aOrder.idCust & ",STATUS='" & aOrder.status & "',CARRAGECODE='" & aOrder.carrageCode & "',PC='" & aOrder.pc & "' WHERE IDORDER=" & aOrder.idOrder
	'response.write(asql)
	'response.end
	call conExecute(asql)

end sub

function getCurrentOrder()

	dim aIdOrder
	aIdOrder = session("IDORDER")
	if aIdOrder = "" then
		aIdOrder = createOrder()
		session("IDORDER") = aIdOrder
	end if
	
	set getCurrentOrder = getOrder(aIdOrder)

end function

function getMaxIdOrderRef()

	dim ars
	set ars = getQueryRecordSet("SELECT REF FROM ORDERS WHERE IDORDER=(SELECT MAX(IDORDER) FROM ORDERS WHERE REF IS NOT NULL AND REF <> '')")
	getMaxIdOrderRef = ""
	while not ars.eof
		getMaxIdOrderRef = trim(ars("REF"))
		ars.movenext
	wend
	closers(ars)

end function

function currentOrderExists()

	currentOrderExists = (session("IDORDER") <> "")

end function

function getOrder(byval aIdOrder)

	dim ars
	
	set ars = getQueryRecordSet("SELECT * FROM ORDERS WHERE IDORDER=" & aIdOrder)
	while not ars.eof
		set getOrder = new order
		getOrder.idOrder = cint(ars("IDORDER"))
		getOrder.ref = ars("REF")
		getOrder.placed = cdate(ars("PLACED"))
		getOrder.idCust = ars("IDCUST")
		getOrder.status = ars("STATUS")
		getOrder.carrageCode = ars("CARRAGECODE")
		getOrder.pc = ars("PC")
		ars.movenext
	wend
	closers(ars)

end function

function getAllOrders(byval aStatus1, byval aStatus2)

	dim ars, theOrders(), anOrder, i, asql
	
	asql = "SELECT * FROM ORDERS"
	if aStatus1 <> "" then
		asql = asql & " WHERE STATUS='" & aStatus1 & "'"
	end if
	if aStatus2 <> "" then
		asql = asql & " OR STATUS='" & aStatus2 & "'"
	end if
	asql = asql & " ORDER BY IDORDER DESC"
	set ars = getQueryRecordSet(asql)
	i = 0

	while not ars.eof
		i = i + 1
		set anOrder = new order
		anOrder.idOrder = cint(ars("IDORDER"))
		anOrder.ref = ars("REF")
		anOrder.placed = cdate(ars("PLACED"))
		anOrder.idCust = cint(ars("IDCUST"))
		anOrder.status = ars("STATUS")
		anOrder.carrageCode = ars("CARRAGECODE")
		anOrder.pc = ars("PC")
	
		redim preserve theOrders(i)
		set theOrders(i) = anOrder

		ars.movenext
	wend
	
	if i = 0 then redim theOrders(0)

	closers(ars)
	
	getAllOrders = theOrders

end function

function updateOrderCarrage(byval aCarrageCode, byval aIdOrder)

	dim asql
	asql = "UPDATE ORDERS SET CARRAGECODE='" & aCarrageCode & "' WHERE IDORDER=" & aIdOrder
	call conExecute(asql)

end function

sub addItemToBasket(byval aIdProd, byval aIdOpt1, byval aIdOpt2, byval aIdOpt3, byval aQty)

	dim aIdOrder, asql, ars, aIdOrderItem, aNewQty
	aIdOrder = session("IDORDER")
	if aIdOrder = "" then
		aIdOrder = createOrder()
		session("IDORDER") = aIdOrder
	end if
	
	if aIdOpt1 = "" then aIdOpt1 = 0
	if aIdOpt2 = "" then aIdOpt2 = 0
	if aIdOpt3 = "" then aIdOpt3 = 0
	
	asql = "SELECT * FROM ORDERITEM WHERE IDORDER=" & aIdOrder & " AND IDPROD=" & aIdProd & " AND IDOPT1=" & aIdOpt1 & " AND IDOPT2=" & aIdOpt2 & " AND IDOPT3=" & aIdOpt3
	set ars = getQueryRecordSet(asql)
	aIdOrderItem = 0
	aNewQty = aQty
	while not ars.eof
		aIdOrderItem = ars("IDORDERITEM")
		aNewQty = ars("QTY") + aQty
		ars.movenext
	wend
	closers(ars)
	
	if aQty = 0 then aNewQty = 0 ' ensure we delete the entry if aQty was 0
	
	if aIdOrderItem = 0 then
		' no similar order in basket, so add
		asql = "INSERT INTO ORDERITEM (IDORDER,IDPROD,IDOPT1,IDOPT2,IDOPT3,QTY) VALUES (" & aIdOrder & "," & aIdProd & "," & aIdOpt1 & "," & aIdOpt2 & "," & aIdOpt3 & "," & aNewQty & ")"
	else
		' similar order in basket, so update or delete
		if aNewQty = 0 then
			asql = "DELETE FROM ORDERITEM WHERE IDORDERITEM=" & aIdOrderItem
		else
			asql = "UPDATE ORDERITEM SET QTY=" & aNewQty & " WHERE IDORDERITEM=" & aIdOrderItem
		end if
	end if
	
	call conExecute(asql)

end sub

function getOrderItems(byval aIdOrder)

	dim ars, theOrderItems(), aOrderItem, i
	
	set ars = getQueryRecordSet("SELECT * FROM ORDERITEM WHERE IDORDER=" & aIdOrder & " ORDER BY IDORDERITEM")
	i = 0

	while not ars.eof
		i = i + 1
		set aOrderItem = new orderItem
		aOrderItem.idOrderItem = ars("IDORDERITEM")
		aOrderItem.idOrder = ars("IDORDER")
		aOrderItem.idProd = ars("IDPROD")
		aOrderItem.idOpt1 = ars("IDOPT1")
		aOrderItem.idOpt2 = ars("IDOPT2")
		aOrderItem.idOpt3 = ars("IDOPT3")
		aOrderItem.qty = ars("QTY")
	
		redim preserve theOrderItems(i)
		set theOrderItems(i) = aOrderItem

		ars.movenext
	wend
	
	if i = 0 then redim theOrderItems(0)

	closers(ars)
	
	getOrderItems = theOrderItems

end function

function getOrderItem(byval aIdOrderItem)

	dim ars
	
	set ars = getQueryRecordSet("SELECT * FROM ORDERITEM WHERE IDORDERITEM=" & aIdOrderItem)

	while not ars.eof
		set getOrderItem = new orderItem
		getOrderItem.idOrderItem = ars("IDORDERITEM")
		getOrderItem.idOrder = ars("IDORDER")
		getOrderItem.idProd = ars("IDPROD")
		getOrderItem.idOpt1 = ars("IDOPT1")
		getOrderItem.idOpt2 = ars("IDOPT2")
		getOrderItem.idOpt3 = ars("IDOPT3")
		getOrderItem.qty = ars("QTY")
		ars.movenext
	wend
	
end function

function getBasket()

	dim aIdOrder
	aIdOrder = session("IDORDER")
	if aIdOrder = "" then
		aIdOrder = createOrder()
		session("IDORDER") = aIdOrder
	end if
	
	getBasket = getOrderItems(aIdOrder)

end function

function getOrderItemPrice(byval aIdOrderItem)

	dim ars, ars2, aPrice, aIdOpt
	
	set ars = getQueryRecordSet("SELECT * FROM ORDERITEM WHERE IDORDERITEM=" & aIdOrderItem)
	while not ars.eof
	
		aPrice = getProdOptComboPrice(ars("IDPROD"), ars("IDOPT1"), ars("IDOPT2"), ars("IDOPT3"))
		
		if aPrice < 0 then
			' no combo price, so use prod & prod opt
			set ars2 = getQueryRecordSet("SELECT * FROM PROD WHERE IDPROD=" & ars("IDPROD"))
			aPrice = ccur(ars2("PRICE"))
			closers(ars2)
			
			aIdOpt = ars("IDOPT1")
			if aIdOpt <> 0 then
				'response.write("<br>ars('IDPROD') = " & ars("IDPROD"))
				'response.write("<br>aIdOpt = " & aIdOpt)
				'response.end
				set ars2 = getQueryRecordSet("SELECT * FROM PRODOPT WHERE IDPROD=" & ars("IDPROD") & " AND IDOPT=" & aIdOpt)
				aPrice = aPrice + ccur(ars2("ADDPRICE"))
				closers(ars2)
			end if
	
			aIdOpt = ars("IDOPT2")
			if aIdOpt <> 0 then
				set ars2 = getQueryRecordSet("SELECT * FROM PRODOPT WHERE IDPROD=" & ars("IDPROD") & " AND IDOPT=" & aIdOpt)
				aPrice = aPrice + ccur(ars2("ADDPRICE"))
				closers(ars2)
			end if
	
			aIdOpt = ars("IDOPT3")
			if aIdOpt <> 0 then
				set ars2 = getQueryRecordSet("SELECT * FROM PRODOPT WHERE IDPROD=" & ars("IDPROD") & " AND IDOPT=" & aIdOpt)
				aPrice = aPrice + ccur(ars2("ADDPRICE"))
				closers(ars2)
			end if
		end if

		set getOrderItemPrice = new orderItemPrice
		getOrderItemPrice.unitPrice = aPrice
		getOrderItemPrice.totalPrice = aPrice * cint(ars("QTY"))

		ars.movenext
	wend

	closers(ars)

end function

' the moshulu style carrage price
function getOrderPrice(byval aIdOrder)

	dim ars, ars2, aPrice, aIdOpt, aOrderItemPrice, aOrder, aCarrage
	
	set getOrderPrice = new orderPrice
	getOrderPrice.goodsPrice = 0.0
	getOrderPrice.carragePrice = 0.0
	getOrderPrice.totalPrice = 0.0

	set ars = getQueryRecordSet("SELECT * FROM ORDERITEM WHERE IDORDER=" & aIdOrder)
	while not ars.eof
	
		set aOrderItemPrice = getOrderItemPrice(ars("IDORDERITEM"))
		getOrderPrice.goodsPrice = getOrderPrice.goodsPrice + aOrderItemPrice.totalPrice

		ars.movenext
	wend
	
	set aOrder = getOrder(aIdOrder)
	if aOrder.carrageCode <> "" then
		set aCarrage = getCarrage(aOrder.carrageCode)
		getOrderPrice.carragePrice = aCarrage.price
	end if

	closers(ars)
	
	getOrderPrice.totalPrice = getOrderPrice.goodsPrice + getOrderPrice.carragePrice

end function

' the savoirbeds style carrage price
function getOrderPrice2(byval aIdOrder)

	dim ars, ars2, aPrice, aIdOpt, aOrderItemPrice, aOrder, aDiscount
	
	set getOrderPrice2 = new orderPrice
	getOrderPrice2.goodsPricePreDiscount = 0.0
	getOrderPrice2.carragePrice = 0.0
	getOrderPrice2.totalPrice = 0.0
	getOrderPrice2.discount = 0
	set aOrder = getOrder(aIdOrder)

	set ars = getQueryRecordSet("SELECT * FROM ORDERITEM WHERE IDORDER=" & aIdOrder)
	while not ars.eof
	
		set aOrderItemPrice = getOrderItemPrice(ars("IDORDERITEM"))
		getOrderPrice2.goodsPricePreDiscount = getOrderPrice2.goodsPricePreDiscount + aOrderItemPrice.totalPrice
		if aOrder.pc <> "" then
			aDiscount = getDiscountForOrderItem(ars("IDORDERITEM"), aOrder.pc)
			getOrderPrice2.goodsPrice = getOrderPrice2.goodsPrice + aOrderItemPrice.totalPrice * (1.0 - cdbl(adiscount)/100.0)
		else
			getOrderPrice2.goodsPrice = getOrderPrice2.goodsPrice + aOrderItemPrice.totalPrice
		end if

		ars.movenext
	wend
	
	getOrderPrice2.delSuppThreshold = getDelivery("THRESHOLD", "DELSUPP").cost
	getOrderPrice2.delSuppAmount = getDelivery("SUPPLEMENT", "DELSUPP").cost
	getOrderPrice2.delSuppThresholdCrossed = (getOrderPrice2.goodsPrice < getOrderPrice2.delSuppThreshold)
	
	dim adelareacost, adeldaycost, adeltimecost, aOrderDelivery
	set aOrderDelivery = getCurrentOrderDelivery(aIdOrder)
	adelareacost = getDelivery(aOrderDelivery.delareaId, "DELAREA").cost
	adeldaycost = getDelivery(aOrderDelivery.deldayId, "DELDAY").cost
	adeltimecost = getDelivery(aOrderDelivery.deltimeId, "DELTIME").cost
	
	getOrderPrice2.carragePrice = adelareacost + adeldaycost + adeltimecost
	if getOrderPrice2.delSuppThresholdCrossed then
		getOrderPrice2.carragePrice = getOrderPrice2.carragePrice + getOrderPrice2.delSuppAmount
	end if

	closers(ars)
	
	getOrderPrice2.totalPrice = getOrderPrice2.goodsPrice + getOrderPrice2.carragePrice

end function

function getOrderItemCount(byval aIdOrder)

	dim ars
	
	getOrderItemCount = 0

	set ars = getQueryRecordSet("SELECT SUM(QTY) AS ITEMCOUNT FROM ORDERITEM WHERE IDORDER=" & aIdOrder)
	while not ars.eof
		getOrderItemCount = ars("ITEMCOUNT")
		ars.movenext
	wend
	if isNull(getOrderItemCount) then getOrderItemCount = 0
	
	closers(ars)

end function

sub deleteOrder(byval aIdOrder)

	dim asql

	asql = "DELETE FROM ORDERITEM WHERE IDORDER=" & aIdOrder
	call conExecute(asql)
	asql = "DELETE FROM ORDERS WHERE IDORDER=" & aIdOrder
	call conExecute(asql)
	
end sub

function getPCDiscount(aPcCode)

	dim val
	getPCDiscount = -100
	val = getDomainData("PC_" & aPcCode)
	if val <> "" then
		getPCDiscount = cint(val)
	end if

end function

%>