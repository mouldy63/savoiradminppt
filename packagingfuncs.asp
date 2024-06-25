<%
sub getBoxSizes(byref acon, aBoxSize, byref aWidth, byref aLength, byref aDepth)
	dim ars
	set ars = getMysqlQueryRecordSet("select * from shippingbox where sName='" & aBoxSize & "'", acon)
	aWidth=ars("width")
	aLength=ars("length")
	if aBoxSize="LegBox" then aLength=ars("height")
	aDepth=ars("depth")
	call closemysqlrs(ars)
end sub

sub getPackedWithCompDetails(byref acon, aPn, aCompId, aWholesalePrices, byref aCompName, byref aPrice, byref aQty, byref aTotal, byref aTariffcode, byref aUnitPrice)
	dim ars, ars2, ars3, ars4, ars5, arssql, calctotal, totallegs, asql, bUnitPrice
	dim aDiscount, aDiscountType, aBedsetTotal, aIsTrade, aVatRate, aCompDiscount, zeroprice
	asql = "select * from packagingdata P, Component C, Purchase pc where P.purchase_no=pc.purchase_no and P.componentid=C.componentid and P.purchase_no=" & aPn & " and packedwith='" & aCompId & "'"
	response.write("<br>getPackedWithCompDetails: asql = " & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
	zeroprice="n"
	aCompName=""
	aPrice=""
	aUnitPrice=""
	aQty=""
	aTotal=0
	bUnitPrice=0
	aTariffcode=""
	
	if not ars.eof then
		aCompName="<br>"
		aTariffcode="<br>"
		aQty=""
		do until ars.eof
			calctotal=0
			totallegs=0
			
			set ars2 = getMysqlQueryRecordSet("select * from purchase where purchase_no=" & aPn, acon)
			
			if ars("component")="Valance" then
			if rs("valanceprice")="0" or rs("valanceprice")="0.00" or isNull(rs("valanceprice")="0") or rs("valanceprice")="" then zeroprice="y"
				if aWholesalePrices="y" then
						aPrice=aPrice & getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, aPn, 6),2) & "<br>"
						aUnitPrice=aUnitPrice & getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, aPn, 6),2) & "<br>"
				else
					if zeroprice="y" then
						aPrice=aPrice & getCurrencySymbolForCurrency(orderCurrency) & "10.00<br>"
						aUnitPrice=aUnitPrice & getCurrencySymbolForCurrency(orderCurrency) & "10.00<br>"
					else
						aPrice=aPrice & getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentPriceExVatAfterDiscount(con, aPn, 6),2) & "<br>"
						aUnitPrice=aUnitPrice & getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentPriceExVatAfterDiscount(con, aPn, 6),2) & "<br>"
					end if
					
				end if
				aQty=aQty & "1" & "<br>"
				set ars4 = getMysqlQueryRecordSet("SELECT TARIFFCODE FROM `componentdata` where componentname ='Valance'", acon)
				
				aTariffcode=aTariffcode & ars4("tariffcode") & "<br>"
				ars4.close
				set ars4=nothing
				if aWholesalePrices="y" then	
					aTotal = aTotal + getComponentWholesalePrice2(con, aPn, 6)
				else
					if zeroprice="y" then
					aTotal = aTotal + 10
					else
					aTotal = aTotal + getComponentPriceExVatAfterDiscount(con, aPn, 6)
					end if
				end if
				aCompName=aCompName & "Valance<br>"
			end if
			if ars("component")="Legs" then
			if rs("legprice")="0" or rs("legprice")="0.00" or isNull(rs("legprice")="0") or rs("legprice")="" then zeroprice="y"
				if aWholesalePrices="y" then
					aPrice=aPrice & getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, aPn, 7),2)
					aUnitPrice=aUnitPrice & getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentWholesalePrice2(con, aPn, 7),2)
				else
					if zeroprice="y" then
					aPrice=aPrice & getCurrencySymbolForCurrency(orderCurrency) & "10.00<br>"
					aUnitPrice=aUnitPrice & getCurrencySymbolForCurrency(orderCurrency) & "10.00<br>"
					else
					aPrice=aPrice & getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentPriceExVatAfterDiscount(con, aPn, 7),2) & "<br>"
					aUnitPrice=aUnitPrice & getCurrencySymbolForCurrency(orderCurrency) & formatNumber(getComponentPriceExVatAfterDiscount(con, aPn, 7),2) & "<br>"
					end if
				end if
				set ars4 = getMysqlQueryRecordSet("SELECT TARIFFCODE FROM `componentdata` where componentname ='Box of Legs'", acon)
				
				aTariffcode=aTariffcode & ars4("tariffcode") & "<br>"
				ars4.close
				set ars4=nothing
				if ars2("legqty")<>"" then totallegs=CDbl(ars2("legqty"))
				if ars2("addlegqty")<>"" then totallegs=totallegs + CDbl(ars2("addlegqty"))
				if ars2("headboardlegqty")<>"" then totallegs=totallegs + CDbl(ars2("headboardlegqty"))
				aQty=aQty & "1" & "<br>"
				if aWholesalePrices="y" then
					aTotal = aTotal + getComponentWholesalePrice2(con, aPn, 7)
				else
					if zeroprice="y" then 
					aTotal = aTotal + 10
					else
					aTotal = aTotal + getComponentPriceExVatAfterDiscount(con, aPn, 7)
					end if
				end if
				aCompName=aCompName & "Legs (" & totallegs & ") and Fittings 1 box<br>"
			end if
			if ars("component")="Accessories" then
				if ars("wrappingid") = 3 or ars("wrappingid") = 2 then
					asql = "Select * from orderaccessory where purchase_no=" & aPn & " and orderaccessory_id=" & ars("CompPartNo")
				elseif ars("wrappingid") = 4 then
					asql = "Select * from orderaccessory where purchase_no=" & aPn & " order by orderaccessory_id asc"
				end if
				response.write("<br>getPackedWithCompDetails: asql = " & asql)
				set ars3 = getMysqlQueryRecordSet(asql, acon)
				do until ars3.eof
					aCompName=aCompName & ars3("description") & "<br>"
					if (ars("wrappingid") = 4 or ars("wrappingid") = 3 or ars("wrappingid") = 2) then aTariffcode=aTariffcode & ars3("tariffCode") & "<br>"
					if aWholesalePrices = "y" then
						bUnitPrice = ars3("WholesalePrice")
					else
						bUnitPrice = CDbl(ars3("unitprice"))
						
						
						asql = "select * from purchase where purchase_no=" & aPn
						'response.write("<br>getStandaloneAccessoryCompDetails: asql=" & asql)
						set ars5 = getMysqlQueryRecordSet(asql, acon)
						aDiscount = safeDbl(ars5("discount"))
						aDiscountType = ars5("discounttype")
						aBedsetTotal = safeDbl(ars5("bedsettotal"))
						aIsTrade = (ars5("isTrade") = "y")
						aVatRate = safeDbl(ars5("vatrate"))
						call closers(ars5)
			
						' apply porportion of any discount
						if aDiscount > 0.0 then
							' there is a discount
							if aDiscountType = "percent" then
								' discount type is % so deduct that % from the comp price
								bUnitPrice = bUnitPrice * (1.0 - (aDiscount/100.0))
							elseif aDiscountType = "currency" then
								' discount type is an amount, so deduct component's share of that from the comp price
								aCompDiscount = bUnitPrice / aBedsetTotal * aDiscount
								bUnitPrice = bUnitPrice - aCompDiscount
							end if
						end if
			
						' deduct the VAT
						if not aIsTrade and aVatRate > 0.0 then
							bUnitPrice = bUnitPrice / (1.0 + aVatRate/100.0)
						end if
						bUnitPrice = round(bUnitPrice, 2)
									
						
					end if
					if CDbl(bUnitPrice)=0 then bUnitPrice=10/CDbl(ars3("qty"))
					calctotal= CDbl(ars3("qty"))*CDbl(bUnitPrice)
					
					aTotal = aTotal + calctotal
					aPrice=aPrice & getCurrencySymbolForCurrency(orderCurrency) & formatNumber(calctotal,2) & "<br>"
					aUnitPrice=aUnitPrice & getCurrencySymbolForCurrency(orderCurrency) & formatNumber(bUnitPrice,2) & "<br>"
					aQty = aQty & ars3("qty") & "<br>"
					if len(ars3("description"))>183 then
						aTariffcode=aTariffcode & "<br>"
						aQty=aQty & "<br>"
						aPrice = aPrice & "<br>"
						aUnitPrice = aUnitPrice & "<br>"
					end if
					if len(ars3("description"))>183 then
						aTariffcode=aTariffcode & "<br>"
						aQty=aQty & "<br>"
						aPrice = aPrice & "<br>"
						aUnitPrice = aUnitPrice & "<br>"
					end if
					'response.write("<br>getPackedWithCompDetails: aUnitPrice = " & aUnitPrice)
					ars3.movenext
				loop
				ars3.close
				set ars3=nothing
				
			end if
			
			ars2.close
			set ars2=nothing
			ars.movenext
		loop
	end if
	ars.close
	set ars=nothing
	
	if right(aPrice,4)="<br>" then 
		aPrice=left(aPrice,len(aPrice)-4)
	end if
	if right(aUnitPrice,4)="<br>" then 
		aUnitPrice=left(aUnitPrice,len(aUnitPrice)-4)
	end if
	if right(aQty,4)="<br>" then 
		aQty=left(aQty,len(aQty)-4)
	end if
	if right(aCompName,4)="<br>" then 
		aCompName=left(aCompName,len(aCompName)-4)
	end if
	if right(aTariffcode,4)="<br>" then 
		aTariffcode=left(aTariffcode,len(aTariffcode)-4)
	end if
end sub

sub getStandaloneAccessoryCompDetails(byref acon, aPn, aCompPartNo, aWrapType, aWholesalePrices, byref aPackaccunitprice, byref aAcctotalforitem, byref aPackaccqty, byref aPackaccdesc, byref aPacktarrifcode)
	dim asql, bsql, ars, ars2, ars3, an, aUnitPrice, aIsTrade, aVatRate, aDiscount, aDiscountType, aBedsetTotal, aCompDiscount, orderCurrency
	if aWrapType <> 4 and not isnull(aCompPartNo) and aCompPartNo <> "" then
' need to get the right orderaccessory, plus any others packed with it
		asql = "Select * from orderaccessory where purchase_no=" & aPn & " and orderaccessory_id=" & aCompPartNo & " union"
		asql = asql & " select oa.* FROM packagingdata pd join orderaccessory oa on pd.comppartno=oa.orderaccessory_id where pd.componentid=9 and pd.packedwith='9-" & aCompPartNo & "' and oa.purchase_no=" & aPn
	else
' get all the orderaccessory rows
		asql = "Select * from orderaccessory where purchase_no=" & aPn
	end if
	'find currency
	bsql= "Select * from purchase where purchase_no=" & aPn
	set ars3 = getMysqlQueryRecordSet(bsql, acon)
		orderCurrency=ars3("ordercurrency")
	ars3.close
	set ars3=nothing
'	response.write("<br>getStandaloneAccessoryCompDetails: asql=" & asql)
'response.end
	set ars = getMysqlQueryRecordSet(asql, acon)
	aPackaccunitprice = ""
	aAcctotalforitem = ""
	aPackaccqty = ""
	aPackaccdesc = ""
	aPacktarrifcode = ""
	an = 0
	while not ars.eof
		an = an + 1
		if an > 1 then
			aPackaccunitprice = aPackaccunitprice & "<br/>" & getCurrencySymbolForCurrency(orderCurrency)
			aAcctotalforitem = aAcctotalforitem & "<br/>" & getCurrencySymbolForCurrency(orderCurrency)
			aPackaccqty = aPackaccqty & "<br/>"
			aPackaccdesc = aPackaccdesc & "<br/>"
			aPacktarrifcode = aPacktarrifcode & "<br/>"
		end if
		if aWholesalePrices = "y" then
			aUnitPrice = ars("WholesalePrice")
		else
			aUnitPrice = safeDbl(ars("unitprice"))
			asql = "select * from purchase where purchase_no=" & aPn
			'response.write("<br>getStandaloneAccessoryCompDetails: asql=" & asql)
			set ars2 = getMysqlQueryRecordSet(asql, acon)
	        aDiscount = safeDbl(ars2("discount"))
        	aDiscountType = ars2("discounttype")
        	aBedsetTotal = safeDbl(ars2("bedsettotal"))
	        aIsTrade = (ars2("isTrade") = "y")
	        aVatRate = safeDbl(ars2("vatrate"))
	        call closers(ars2)

	    	' apply porportion of any discount
	        if aDiscount > 0.0 then
	        	' there is a discount
	        	if aDiscountType = "percent" then
	        		' discount type is % so deduct that % from the comp price
	        		aUnitPrice = aUnitPrice * (1.0 - (aDiscount/100.0))
	        	elseif aDiscountType = "currency" then
	        		' discount type is an amount, so deduct component's share of that from the comp price
		        	aCompDiscount = aUnitPrice / aBedsetTotal * aDiscount
		        	aUnitPrice = aUnitPrice - aCompDiscount
	        	end if
	        end if

	        ' deduct the VAT
	        if not aIsTrade and aVatRate > 0.0 then
	        	aUnitPrice = aUnitPrice / (1.0 + aVatRate/100.0)
	        end if
	        aUnitPrice = round(aUnitPrice, 2)
		end if
		if CDbl(aUnitPrice)=0 then aUnitPrice=10
		aPackaccunitprice = "$" & aPackaccunitprice & formatnumber(aUnitPrice,2)
		aAcctotalforitem = "$" & aAcctotalforitem & formatnumber(CDbl(aUnitPrice)*CDbl(ars("qty")))
		aPackaccqty = aPackaccqty & ars("qty")
		aPackaccdesc = aPackaccdesc & ars("description")
		aPacktarrifcode = aPacktarrifcode & ars("tariffcode")
		ars.movenext
	wend
	ars.close
	set ars=nothing
	'response.End()
	if right(aPackaccunitprice,4)="<br>" then 
		aPackaccunitprice=left(aPackaccunitprice,len(aPackaccunitprice)-4)
	end if
	if right(aPackaccqty,4)="<br>" then 
		aPackaccqty=left(aPackaccqty,len(aPackaccqty)-4)
	end if
	if right(aPackaccdesc,4)="<br>" then 
		aPackaccdesc=left(aPackaccdesc,len(aPackaccdesc)-4)
	end if
	if right(aPacktarrifcode,4)="<br>" then 
		aPacktarrifcode=left(aPacktarrifcode,len(aPacktarrifcode)-4)
	end if
end sub

function getSumOfValues(aValue)
	dim an, achar, atemp
	
	if IsNumeric(aValue) then
		getSumOfValues = aValue
		exit function
	end if
	
	getSumOfValues = 0.0
	atemp = ""
	for an = 1 to len(aValue)
		achar = mid(aValue, an, 1)
		if not achar="," then
			if not IsNumeric(achar) and not achar = "." then
				if atemp <> "" then
					getSumOfValues = getSumOfValues + cdbl(atemp)
					atemp = ""
				end if
			else 
				atemp = atemp & achar
			end if
		end if
	next
	if atemp <> "" and IsNumeric(atemp) then
	
		getSumOfValues = getSumOfValues + cdbl(atemp)
	end if

end function

function getPackedWithAccessoryWeights(byref acon, aPn, aCompPartNo)
	dim asql, ars
	asql="select packkg from packagingdata where purchase_no=" & aPn & " and packedwith='9-" & aCompPartNo & "'"
	set ars = getMysqlQueryRecordSet(asql, acon)
	getPackedWithAccessoryWeights = ""
	while not ars.eof
			getPackedWithAccessoryWeights = getPackedWithAccessoryWeights '& "<br/>" & ars("packkg")
			ars.movenext
	wend
	call closers(ars)
end function
%>

