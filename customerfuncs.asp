<%

class communicationnote
	public text
	public commDate
	public commType
	public person
	public notes
	public actionnext
	public actionresponse
	public staff
end class

function oldToNewPriceListVal(byref aOldVal)
	oldToNewPriceListVal = aOldVal
	if lcase(aOldVal) = "direct" then
		oldToNewPriceListVal = "Retail"
	end if
end function

function isTradeCustomer(byref acon, byref aContactNo)
	dim asql, ars, aPriceList
	asql = "select a.price_list from contact c, address a where a.code=c.code and c.contact_no=" & aContactNo
	set ars = getMysqlQueryRecordSet(asql, acon)
	aPriceList = oldToNewPriceListVal(ars("price_list"))
	isTradeCustomer = (lcase(aPriceList) = "trade" or lcase(aPriceList) = "savoy" or lcase(aPriceList) = "contract" or lcase(aPriceList) = "wholesale" or lcase(aPriceList) = "net retail")
	call closeRs(ars)
end function

function getDefaultPriceListForLocation(byref acon, aLocationId)
	dim asql, ars
	getDefaultPriceListForLocation = "Retail"
	asql = "select PriceList from pricelist where DEFAULT_FOR_LOC_IDS like '%," & aLocationId & ",%'"
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		getDefaultPriceListForLocation = ars("PriceList")
	end if
	call closeRs(ars)

end function

function isContractCustomer(byref acon, byref aContactNo)
	dim asql, ars, aPriceList
	asql = "select a.price_list from contact c, address a where a.code=c.code and c.contact_no=" & aContactNo
	set ars = getMysqlQueryRecordSet(asql, acon)
	aPriceList = oldToNewPriceListVal(ars("price_list"))
	isContractCustomer = (lcase(aPriceList) = "contract")
	call closeRs(ars)
end function

function getTradeDiscountRate(byref acon, byref aContactNo)
	dim asql, ars, aRate
	asql = "select tradediscountrate from contact where contact_no=" & aContactNo
	set ars = getMysqlQueryRecordSet(asql, acon)
	aRate = ars("tradediscountrate")
	if isnull(aRate) or isempty(aRate) or aRate="" then
		getTradeDiscountRate = 0
	else
		getTradeDiscountRate = cint(aRate)
	end if
	call closeRs(ars)
end function

function getCustomerNotes(byref acon, aCode)

	dim ars, aNotes(), an, aNote, asql
	asql = "select * from communication where code=" & aCode
	asql = asql & " order by date desc"
	'response.write(asql)
	'response.end
	Set ars = getMysqlQueryRecordSet(asql, acon)
	an = 0
	while not ars.eof
		an = an + 1
		redim preserve aNotes(an)
		set aNote = new communicationnote
		aNote.commDate = ars("date")
		aNote.commType = ars("type")
		aNote.person = ars("person")
		aNote.notes = ars("notes")
		aNote.actionnext = ars("next")
		aNote.actionresponse = ars("response")
		aNote.staff = ars("staff")
		set aNotes(an) = aNote
		ars.movenext
	wend
	if an = 0 then redim aNotes(0)
	ars.close
	set ars = nothing
	getCustomerNotes = aNotes
	
end function


sub convertCustomerToSavoir(byref acon, aContactNo, aPrevSourceSite)
	dim ars, asql, acode
	
	' contact
	asql = "select * from contact where contact_no=" & aContactNo
	set ars = getMysqlUpdateRecordSet(asql, acon)
	while not ars.eof
		if ars("code") <> "" then
			acode = ars("code")
		end if
		'response.write("<br>contact = " & ars("surname"))
		ars("source_site") = "SB"
		ars("previous_source_site") = aPrevSourceSite
		ars.update
		ars.movenext
	wend
	call closeRs(ars)
	
	' address
	if acode <> "" then
		asql = "select * from address where code=" & acode
		set ars = getMysqlUpdateRecordSet(asql, acon)
		while not ars.eof
			'response.write("<br>address = " & ars("alpha_name"))
			ars("source_site") = "SB"
			ars.update
			ars.movenext
		wend
		call closeRs(ars)
	end if
	
	' communication
	if acode <> "" then
		asql = "select * from communication where code=" & acode
		set ars = getMysqlUpdateRecordSet(asql, acon)
		while not ars.eof
			'response.write("<br>communication = " & ars("person"))
			ars("source_site") = "SB"
			ars.update
			ars.movenext
		wend
		call closeRs(ars)
	end if

end sub

sub setDefaultDeliveryAddress(byref acon, aContactNo, aContactNoToCopy, aContactLocationId)
	dim asql, ars, ars2

	' is this customer from the right location?
	asql = "select * from contact where contact_no=" & aContactNo & " and idlocation=" & aContactLocationId
	'response.write("<br>setDefaultDeliveryAddress: asql = " & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
	if ars.eof then
		' customer not from this location
		'response.write("<br>setDefaultDeliveryAddress: wrong location")
		call closeRs(ars)
		exit sub
	end if
	call closeRs(ars)


	' does this customer have a default already?
	asql = "select * from delivery_address where contact_no=" & aContactNo & " and isdefault='y'"
	'response.write("<br>setDefaultDeliveryAddress: asql = " & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		' got one already, so nothing to do
		'response.write("<br>setDefaultDeliveryAddress: already got a default delivery address")
		call closeRs(ars)
		exit sub
	end if
	call closeRs(ars)
	
	' copy the default one
	asql = "select * from delivery_address where contact_no=" & aContactNoToCopy
	'response.write("<br>setDefaultDeliveryAddress: asql = " & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
	if ars.eof then
		' doesn't exist, so nothing more we can do
		call closeRs(ars)
		exit sub
	end if
	
	set ars2 = getMysqlUpdateRecordSet("select * from delivery_address", acon)
	ars2.AddNew
	ars2("CONTACT_NO") = aContactNo
	call copyValBetweenRecordSets(ars, ars2, "DELIVERY_NAME")
	call copyValBetweenRecordSets(ars, ars2, "ADD1")
	call copyValBetweenRecordSets(ars, ars2, "ADD2")
	call copyValBetweenRecordSets(ars, ars2, "ADD3")
	call copyValBetweenRecordSets(ars, ars2, "TOWN")
	call copyValBetweenRecordSets(ars, ars2, "COUNTYSTATE")
	call copyValBetweenRecordSets(ars, ars2, "POSTCODE")
	call copyValBetweenRecordSets(ars, ars2, "COUNTRY")
	call copyValBetweenRecordSets(ars, ars2, "CONTACT")
	call copyValBetweenRecordSets(ars, ars2, "PHONE")
	call copyValBetweenRecordSets(ars, ars2, "CONTACTTYPE1")
	call copyValBetweenRecordSets(ars, ars2, "CONTACT2")
	call copyValBetweenRecordSets(ars, ars2, "PHONE2")
	call copyValBetweenRecordSets(ars, ars2, "CONTACTTYPE2")
	call copyValBetweenRecordSets(ars, ars2, "CONTACT3")
	call copyValBetweenRecordSets(ars, ars2, "PHONE3")
	call copyValBetweenRecordSets(ars, ars2, "CONTACTTYPE3")
	ars2("ISDEFAULT") = "y"
	ars2("RETIRE") = "n"

	ars2.Update

	call closeRs(ars2)
	call closeRs(ars)
	
end sub

sub copyValBetweenRecordSets(byref aRsSrc, byref aRsTrg, aColName)
	if not isnull(aRsSrc(aColName)) then
		aRsTrg(aColName) = aRsSrc(aColName)
	else
		aRsTrg(aColName) = null
	end if
end sub
%>
