<%

class CompPriceDiscount
	public compPriceDiscountId
	public pn
	public componentId
	public discountType
	public standardPrice
	public discount
	public price
	public orderAccessoryId
end class

function getMatrixPrice(byref acon, byref aExWorksRevenue, byref aWholesalePrice, aCompId, aPriceTypeName, aDim1, aDim2, aDim3, aCurrency, aCompIdSet1, aCompIdSet2)
	dim ars, asql, aWholesaleCol
	aWholesaleCol = aCurrency & "_wholesale"
	asql = "select " & aCurrency & ", ex_works_revenue, " & aWholesaleCol & " from price_matrix_type t, price_matrix p"
	
	if aCompIdSet1 <> "" then
		asql = asql & ", price_matrix_type t1"
	end if
	
	if aCompIdSet2 <> "" then
		asql = asql & ", price_matrix_type t2"
	end if
	
	asql = asql & " where t.price_type_id=p.price_type_id"
	asql = asql & " and t.name='" & aPriceTypeName & "' and p.componentid=" & aCompId
	
	if aCompIdSet1 <> "" then
		asql = asql & " and p.compid_set1=" & aCompIdSet1
	else
		asql = asql & " and p.compid_set1 is null"
	end if
	
	if aCompIdSet2 <> "" then
		asql = asql & " and p.compid_set2=" & aCompIdSet2
	else
		asql = asql & " and p.compid_set2 is null"
	end if
	
	aDim1 = trim(aDim1)
	aDim2 = trim(aDim2)
	aDim3 = trim(aDim3)
	
	if aDim1 <> "" then
		'aDim1 = cleanToNumber(aDim1)
		if aDim1 = "" then aDim1 = "-1" ' just to ensure the query doesn't return anything
		asql = asql & " and p.dim1='" & aDim1 & "'"
	else
		asql = asql & " and p.dim1 is null"
	end if

	if aDim2 <> "" then
		'aDim2 = cleanToNumber(aDim2)
		if aDim2 = "" then aDim2 = "-1" ' just to ensure the query doesn't return anything
		asql = asql & " and p.dim2='" & aDim2 & "'"
	else
		asql = asql & " and p.dim2 is null"
	end if
	if aDim3 <> "" then
		'aDim3 = cleanToNumber(aDim3)
		if aDim3 = "" then aDim3 = "-1" ' just to ensure the query doesn't return anything
		asql = asql & " and p.dim3='" & aDim3 & "'"
	else
		asql = asql & " and p.dim3 is null"
	end if
	
	'response.write("<br>" & asql & "<br>")
	Set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		getMatrixPrice = safeCCur(ars(aCurrency))
		aExWorksRevenue = safeCCur(ars("ex_works_revenue"))
		aWholesalePrice = safeCCur(ars(aWholesaleCol))
	else
		getMatrixPrice = ccur(-1.0)
		aExWorksRevenue = ccur(-1.0)
		aWholesalePrice = ccur(-1.0)
	end if
	closers(ars)
end function

sub upsertDiscount(byref acon, apn, aCompId, aType, aStdPrice, aPrice)
	call doUpsertDiscount(acon, apn, aCompId, aType, aStdPrice, aPrice, "")
end sub

sub upsertAccessoryDiscount(byref acon, apn, aCompId, aType, aStdPrice, aPrice, aOrderAccessoryId)
	call doUpsertDiscount(acon, apn, aCompId, aType, aStdPrice, aPrice, aOrderAccessoryId)
end sub

sub doUpsertDiscount(byref acon, apn, aCompId, aType, aStdPrice, aPrice, aOrderAccessoryId)
	dim ars, asql, aDiscount
	'trace("<br>aPrice= " & aPrice)
	'trace("<br>aType= " & aType)
	aDiscount = 0.0
	if aPrice = "" then aPrice = 0.0
	if aStdPrice > 0.0 then
		if aType = "percent" then
			aDiscount = 100.0 * (1.0 - aPrice / aStdPrice)
		else
			aDiscount = aStdPrice - aPrice
		end if
	end if
	'trace("<br>pn= " & apn)
	'trace("<br>aDiscount= " & aDiscount)
	
	'trace("<br>aStdPrice= " & aStdPrice)
	'response.end
	
	'if aDiscount > 0.0 then
		asql = "Select * from comp_price_discount where purchase_no=" & apn & " and componentid=" & aCompId
		if not isnull(aOrderAccessoryId) and not isempty(aOrderAccessoryId) and aOrderAccessoryId <> "" then
			asql = asql & " and orderaccessory_id=" & aOrderAccessoryId
		end if
		'trace("<br>asql=" & asql & "<br>")
		set ars = getMysqlUpdateRecordSet(asql, acon)
		if ars.eof then
			ars.AddNew
		end if
		ars("componentid") = aCompId
		ars("discounttype") = aType
		ars("standard_price") = aStdPrice
		ars("discount") = aDiscount
		ars("price") = aPrice
		ars("purchase_no") = apn
		if not isnull(aOrderAccessoryId) and not isempty(aOrderAccessoryId) and aOrderAccessoryId <> "" then
			ars("orderaccessory_id") = aOrderAccessoryId
		end if
		ars.update
		closers(ars)
	'else
	'	call doDeleteDiscount(acon, apn, aCompId, aOrderAccessoryId)
	'end if

end sub

sub deleteDiscount(byref acon, apn, aCompId)
	call doDeleteDiscount(acon, apn, aCompId, "")
end sub

sub deleteAccessoryDiscount(byref acon, apn, aCompId, aOrderAccessoryId)
	call doDeleteDiscount(acon, apn, aCompId, aOrderAccessoryId)
end sub

sub doDeleteDiscount(byref acon, apn, aCompId, aOrderAccessoryId)
	dim asql
	asql = "delete from comp_price_discount where purchase_no=" & apn & " and componentid=" & aCompId
	if not isnull(aOrderAccessoryId) and not isempty(aOrderAccessoryId) and aOrderAccessoryId <> "" then
		asql = asql & " and orderaccessory_id=" & aOrderAccessoryId
	end if
	acon.execute(asql)
end sub

function getDiscount(byref acon, apn, aCompId, aDefaultPrice)
	set getDiscount = doGetDiscount(acon, apn, aCompId, aDefaultPrice, "")
end function

function getAccessoryDiscount(byref acon, apn, aCompId, aDefaultPrice, aOrderAccessoryId)
	set getAccessoryDiscount = doGetDiscount(acon, apn, aCompId, aDefaultPrice, aOrderAccessoryId)
end function

function doGetDiscount(byref acon, apn, aCompId, aDefaultPrice, aOrderAccessoryId)
	dim asql, ars
	
	set doGetDiscount = new CompPriceDiscount
	doGetDiscount.pn = apn
	doGetDiscount.componentId = aCompId
	
	asql = "select * from comp_price_discount where purchase_no=" & apn & " and componentid=" & aCompId
	if not isnull(aOrderAccessoryId) and not isempty(aOrderAccessoryId) and aOrderAccessoryId <> "" then
		asql = asql & " and orderaccessory_id=" & aOrderAccessoryId
	end if
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		doGetDiscount.compPriceDiscountId = ars("comp_price_discount_id")
		doGetDiscount.discountType = ars("discounttype")
		doGetDiscount.standardPrice = ccur(ars("standard_price"))
		doGetDiscount.discount = cdbl(ars("discount"))
		doGetDiscount.price = ccur(ars("price"))
		if not isnull(aOrderAccessoryId) and not isempty(aOrderAccessoryId) and aOrderAccessoryId <> "" then
			doGetDiscount.orderAccessoryId = ars("orderaccessory_id")
		end if
	else
		doGetDiscount.compPriceDiscountId = 0
		doGetDiscount.discountType = "percent"
		doGetDiscount.standardPrice = ccur(0.0)
		doGetDiscount.discount = cdbl(0.0)
		if not isnull(aDefaultPrice) and aDefaultPrice <> "" then
			doGetDiscount.price = ccur(aDefaultPrice)
		else
			doGetDiscount.price = ccur(0.0)
		end if
	end if
	closers(ars)

end function

function getExWorksRevenue(byref acon, apn, aCompId)
	dim aTypeColName, aDim1ColName, aDim2ColName, aDim3ColName, aCompIdSet1, aCompIdSet2, aMultiplierColName
	dim asql, ars, aExWorksRevenue, aMatrixPrice, aWholesalePrice
	
	asql = "select * from price_matrix_comp_lookup where componentid=" & aCompId
	set ars = getMysqlQueryRecordSet(asql, acon)
	if ars.eof then
		getExWorksRevenue = 0.0
		exit function
	end if
	
	aTypeColName = ars("type_col_name")
	if not isnull(ars("dim1_col_name")) and ars("dim1_col_name") <> "" then
		aDim1ColName = ars("dim1_col_name")
	end if
	if not isnull(ars("dim2_col_name")) and ars("dim2_col_name") <> "" then
		aDim2ColName = ars("dim2_col_name")
	end if
	if not isnull(ars("dim3_col_name")) and ars("dim3_col_name") <> "" then
		aDim3ColName = ars("dim3_col_name")
	end if
	if not isnull(ars("multiplier_col_name")) and ars("multiplier_col_name") <> "" then
		aMultiplierColName = ars("multiplier_col_name")
	end if
	if not isnull(ars("compid_set1")) and ars("compid_set1") <> "" then
		aCompIdSet1 = ars("compid_set1")
	end if
	if not isnull(ars("compid_set2")) and ars("compid_set2") <> "" then
		aCompIdSet2 = ars("compid_set2")
	end if
	closers(ars)
	trace("<br>***** apn=" & apn)
	trace("<br>aCompId=" & aCompId)
	trace("<br>aTypeColName=" & aTypeColName)
	trace("<br>aDim1ColName=" & aDim1ColName)
	trace("<br>aDim2ColName=" & aDim2ColName)
	trace("<br>aDim3ColName=" & aDim3ColName)
	trace("<br>aMultiplierColName=" & aMultiplierColName)
	trace("<br>aCompIdSet1=" & aCompIdSet1)
	trace("<br>aCompIdSet2=" & aCompIdSet2)
	
	dim aPriceTypeName, aDim1, aDim2, aDim3, aMultiplier
	asql = "select * from purchase where purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	if left(aTypeColName, 1) = "*" then
		aPriceTypeName = right(aTypeColName, len(aTypeColName)-1)
	else
		aPriceTypeName = ars(aTypeColName)
	end if
	if aDim1ColName <> "" then
		aDim1 = ars(aDim1ColName)
	end if
	if aDim2ColName <> "" then
		aDim2 = ars(aDim2ColName)
	end if
	if aDim3ColName <> "" then
		aDim3 = ars(aDim3ColName)
	end if
	aMultiplier = 1
	if aMultiplierColName <> "" then
		aMultiplier = defaultInt(ars(aMultiplierColName), 1)
	end if
	closers(ars)
	
	aMatrixPrice = getMatrixPrice(acon, aExWorksRevenue, aWholesalePrice, aCompId, aPriceTypeName, aDim1, aDim2, aDim3, "GBP", aCompIdSet1, aCompIdSet2)
	
	getExWorksRevenue = aExWorksRevenue * aMultiplier
	
	trace("<br>aPriceTypeName=" & aPriceTypeName)
	trace("<br>aDim1=" & aDim1)
	trace("<br>aDim2=" & aDim2)
	trace("<br>aDim3=" & aDim3)
	trace("<br>aMultiplier=" & aMultiplier)
	trace("<br>aMatrixPrice=" & aMatrixPrice)
	trace("<br>getExWorksRevenue=" & getExWorksRevenue)
end function

%>
