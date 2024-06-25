<%

function getWholesaleOrderTotal(byref acon, aPno)
	dim ars, aTotalPrice, aPrice2, aPrice3, aCompName, afabfound, auphfound, baseextraComps
	baseextraComps=0
	Set ars = getMysqlQueryRecordSet("Select *  from purchase where purchase_no=" & aPno, acon)
	if ars("baserequired")="y" then
		if not isNull(ars("basetrimprice")) and ars("basetrimprice")<>"" then baseextraComps=baseextraComps+CDbl(ars("basetrimprice"))
		if not isNull(ars("basedrawersprice")) and ars("basedrawersprice")<>"" then baseextraComps=baseextraComps+CDbl(ars("basedrawersprice"))
		if not isNull(ars("upholsteryprice")) and ars("upholsteryprice")<>"" then baseextraComps=baseextraComps+CDbl(ars("upholsteryprice"))
		if not isNull(ars("baseprice")) and ars("baseprice")<>"" then aTotalPrice=aTotalPrice+CDbl(ars("baseprice"))+baseextraComps
	end if
	if ars("mattressrequired")="y" then
		if not isNull(ars("mattressprice")) and ars("mattressprice")<>"" then aTotalPrice=aTotalPrice+CDbl(ars("mattressprice"))
	end if
	if ars("topperrequired")="y" then
		if not isNull(ars("topperprice")) and ars("topperprice")<>"" then aTotalPrice=aTotalPrice+CDbl(ars("topperprice"))
	end if
	if ars("headboardrequired")="y" then
		if not isNull(ars("headboardprice")) and ars("headboardprice")<>"" then aTotalPrice=aTotalPrice+CDbl(ars("headboardprice"))
	end if
	if Not IsNull(ars("discount")) then
		if ars("discounttype")="percent" and CDbl(ars("discount"))>0 then aTotalPrice=aTotalPrice - (CDbl(ars("discount"))/100 * aTotalPrice)
		if ars("discounttype")="currency" and CDbl(ars("discount"))>0 then aTotalPrice=aTotalPrice - CDbl(ars("discount"))
	end if
	if ars("istrade")="y" then
		if Not IsNull(ars("tradediscount")) then
			aTotalPrice=aTotalPrice - CDbl(ars("tradediscount"))
		end if
	end if
	
		if ars("istrade")<>"y" then
		aTotalPrice=aTotalPrice/(1 + CDbl(ars("VATrate"))/100)
		end if
		getWholesaleOrderTotal=aTotalPrice
		closers(ars)
end function

function getComponentPriceXVat(byref acon, aCompID, aPno)
	dim ars, aPrice, aPrice2, aPrice3, aCompName, afabfound, auphfound, baseextraComps, isTrade, VATrate
	baseextraComps=0
	if aCompID=1 then aCompName="mattressprice"
	if aCompID=3 then aCompName="baseprice"
	if aCompID=5 then aCompName="topperprice"
	if aCompID=6 then aCompName="valanceprice"
	if aCompID=7 then aCompName="legprice"
	if aCompID=8 then aCompName="headboardprice"
	if aCompID=9 then aCompName="accessoriestotalcost"
	auphfound="n"
	afabfound="n"
	if aCompID=3 then
	Set ars = getMysqlQueryRecordSet("Select *  from purchase where purchase_no=" & aPno, acon)
	isTrade=ars("isTrade")
	VATrate=ars("vatrate")
	if not isNull(ars("basetrimprice")) and ars("basetrimprice")<>"" then baseextraComps=baseextraComps+CDbl(ars("basetrimprice"))
	if not isNull(ars("basedrawersprice")) and ars("basedrawersprice")<>"" then baseextraComps=baseextraComps+CDbl(ars("basedrawersprice"))
	end if
	Set ars = getMysqlQueryRecordSet("Select " & aCompName & " as n from purchase where purchase_no=" & aPno, acon)
		aPrice = ars("n")
	closers(ars)
	if aPrice<>"" then
	getComponentPriceXVat=CDbl(aPrice)
	end if
	if baseextraComps<>"" then
	getComponentPriceXVat=getComponentPriceXVat+baseextraComps
	end if
	if isTrade<>"y" then
		getComponentPriceXVat=getComponentPriceXVat/(1 + CDbl(VATrate)/100)
	end if
	
end function


function getExportDate(byref acon, aCompid, aPno)
	dim ars, aCompName
		Set ars = getMysqlQueryRecordSet("Select *  from exportlinks E, ExportCollections C where E.linkscollectionid=C.exportcollectionsid and E.purchase_no=" & aPno & " and E.componentId= " & aCompid, acon)
		if not ars.eof then
		getExportDate=ars("collectionDate")
		else
		getExportDate=Null
		end if
		closers(ars)
end function
%>
