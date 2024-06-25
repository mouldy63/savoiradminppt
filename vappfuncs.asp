<%
function getMadeAtRs(byref acon)
    Set getMadeAtRs = getMysqlQueryRecordSet("Select * from manufacturedat order by ManufacturedAtID", acon)
end function

function getLocationRs(byref acon)
    set getLocationRs = getMysqlQueryRecordSet("Select * from location where owning_region=1 AND retire<>'y' order by adminheading", acon)
end function

function getShowrooms(byref acon, aFilter)
    dim ars, asql, ai, aList()
    asql = "select idlocation from location where idlocation"
    if aFilter <> "" and aFilter <> "all" then
        asql = asql & " = " & aFilter
    else
        asql = asql & " in (select distinct idlocation from purchase where total>0.0) and retire='n' and active='y' order by adminheading"
    end if
    ai = 0
    set ars = getMysqlQueryRecordSet(asql, acon)
    while not ars.eof
        ai = ai + 1
        redim preserve aList(ai)
        aList(ai) = ars("idlocation")
        ars.movenext
    wend
    call closemysqlrs(ars)
    getShowrooms = aList
end function

function getShowroomName(byref acon, aIdLocation)
    dim ars
    set ars = getMysqlQueryRecordSet("select location from location where idlocation=" & aIdLocation, acon)
    getShowroomName = ars("location")
    call closemysqlrs(ars)
end function

' the old way - no longer used - see getRevenueForLocation2
function getRevenueForLocation(byref acon, aIdLocation, aDateFrom, aDateTo, aGbp2usd, aGbp2eur, aLogFile)
    dim aGbpRev, aUsdRev, aEurRev
    aGbpRev = getRevenueForLocationByCurrency(acon, aIdLocation, aDateFrom, aDateTo, "GBP", aLogFile)
    aUsdRev = getRevenueForLocationByCurrency(acon, aIdLocation, aDateFrom, aDateTo, "USD", aLogFile)
    aEurRev = getRevenueForLocationByCurrency(acon, aIdLocation, aDateFrom, aDateTo, "EUR", aLogFile)
    getRevenueForLocation = aGbpRev + (aUsdRev / aGbp2usd) + (aEurRev / aGbp2eur)
end function

' the old old way - no longer used - see getRevenueForLocationByCurrency2
function getRevenueForLocationByCurrency(byref acon, aIdLocation, aDateFrom, aDateTo, aCurr, aLogFile)

    dim ars, asql, aVal, aVatFactor, aLine
    getRevenueForLocationByCurrency = 0.0

    ' istrade = y
    asql = "select sum(totalexvat) as totalexvat, sum(accessoriestotalcost) as acctotal, sum(basefabricprice) as basefabtotal, sum(hbfabricprice) as hbfabtotal, sum(valfabricprice) as valfabtotal from purchase where idlocation=" & aIdLocation & " and istrade='y' and ordercurrency='" & aCurr & "'"
    if aDateFrom <> "" then
        asql = asql & " and production_completion_date is not null and production_completion_date >= '" & aDateFrom & "'"
    end if
    if aDateTo <> "" then
        asql = asql & " and production_completion_date is not null and production_completion_date <= '" & aDateTo & "'"
    end if
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "getRevenueForLocationByCurrency: currency=" & aCurr)
        call addItemToLine(aLine, "sql")
        call addItemToLine(aLine, """" &asql& """")
        call writeLine(aLogFile, aLine)
    end if

    set ars = getMysqlQueryRecordSet(asql, acon)
    if not ars.eof then
        getRevenueForLocationByCurrency = getRevenueForLocationByCurrency + safeCur(ars("totalexvat") ) - safeCur(ars("acctotal") ) - safeCur(ars("basefabtotal") ) - safeCur(ars("hbfabtotal") ) - safeCur(ars("valfabtotal") )
        if not isNull(aLogFile) then
            call addItemToLine(aLine, "Trade totals:")
            call addPairToLine(aLine, "total ex vat", ars("totalexvat") )
            call addPairToLine(aLine, "accessories total", ars("acctotal") )
            call addPairToLine(aLine, "base fabric price", ars("basefabtotal") )
            call addPairToLine(aLine, "headboard fabric cost", ars("hbfabtotal") )
            call addPairToLine(aLine, "valance fabric cost", ars("valfabtotal") )
            call writeLine(aLogFile, aLine)
        end if
    end if
    call closemysqlrs(ars)

    if not isNull(aLogFile) then
        ' provide a breakdown of the orders included
        asql = "select order_number, istrade, total, totalexvat as totalexvat, accessoriestotalcost as acctotal, basefabricprice as basefabtotal, hbfabricprice as hbfabtotal, valfabricprice as valfabtotal from purchase where idlocation=" & aIdLocation & " and istrade='y' and ordercurrency='" & aCurr & "'"
        if aDateFrom <> "" then
            asql = asql & " and production_completion_date is not null and production_completion_date >= '" & aDateFrom & "'"
        end if
        if aDateTo <> "" then
            asql = asql & " and production_completion_date is not null and production_completion_date <= '" & aDateTo & "'"
        end if

        set ars = getMysqlQueryRecordSet(asql, acon)
        if not ars.eof then
            call addItemToLine(aLine, "Breakdown of orders included in trade summation:")
            call writeLine(aLogFile, aLine)
        else
            call addItemToLine(aLine, "SQL returned no orders for trade summation")
            call writeLine(aLogFile, aLine)
        end if
        while not ars.eof
            call addPairToLine(aLine, "Order number", ars("order_number") )
            call addPairToLine(aLine, "total", ars("total") )
            call addPairToLine(aLine, "total ex vat", ars("totalexvat") )
            call addPairToLine(aLine, "accessories total", ars("acctotal") )
            call addPairToLine(aLine, "base fabric price", ars("basefabtotal") )
            call addPairToLine(aLine, "headboard fabric cost", ars("hbfabtotal") )
            call addPairToLine(aLine, "valance fabric cost", ars("valfabtotal") )
            call writeLine(aLogFile, aLine)
            ars.movenext
        wend
        call closemysqlrs(ars)
    end if

    ' istrade = n
    asql = "select order_number, totalexvat, accessoriestotalcost, basefabricprice, hbfabricprice, valfabricprice, vatrate from purchase where idlocation=" & aIdLocation & " and istrade='n' and ordercurrency='" & aCurr & "'"
    if aDateFrom <> "" then
        asql = asql & " and production_completion_date is not null and production_completion_date >= '" & aDateFrom & "'"
    end if
    if aDateTo <> "" then
        asql = asql & " and production_completion_date is not null and production_completion_date <= '" & aDateTo & "'"
    end if
    'trace("<br>getRevenueForLocationByCurrency: sql = " & asql)
    set ars = getMysqlQueryRecordSet(asql, acon)

    if not isNull(aLogFile) then
        if not ars.eof then
            call addItemToLine(aLine, "Breakdown of orders included in non-trade summation:")
            call writeLine(aLogFile, aLine)
        else
            call addItemToLine(aLine, "SQL returned no orders for non-trade summation")
            call writeLine(aLogFile, aLine)
        end if
    end if

    while not ars.eof
        aVatFactor = 1.0 + safeCur(ars("vatrate") ) / 100.0
        aVal = safeCur(ars("totalexvat") ) - safeCur(ars("accessoriestotalcost") ) / aVatFactor - safeCur(ars("basefabricprice") ) / aVatFactor - safeCur(ars("hbfabricprice") ) / aVatFactor - safeCur(ars("valfabricprice") ) / aVatFactor
        getRevenueForLocationByCurrency = getRevenueForLocationByCurrency + aVal
        if not isNull(aLogFile) then
            call addPairToLine(aLine, "Order number", ars("order_number") )
            call addPairToLine(aLine, "vat rate", ars("vatrate") )
            call addPairToLine(aLine, "total ex vat", ars("totalexvat") )
            call addPairToLine(aLine, "accessories total", ars("accessoriestotalcost") )
            call addPairToLine(aLine, "base fabric price", ars("basefabricprice") )
            call addPairToLine(aLine, "headboard fabric cost", ars("hbfabricprice") )
            call addPairToLine(aLine, "valance fabric cost", ars("valfabricprice") )
            call writeLine(aLogFile, aLine)
        end if
        ars.movenext
    wend
    call closemysqlrs(ars)
end function

' the old way - no longer used - see getExWorksRevenueForLocation
function getRevenueForLocation2(byref acon, aIdLocation, aDateFrom, aDateTo, aGbp2usd, aGbp2eur, aMadeAt, aLogFile)
    dim aGbpRev, aUsdRev, aEurRev
    aGbpRev = getRevenueForLocationByCurrency2(acon, aIdLocation, aDateFrom, aDateTo, "GBP", aMadeAt, aLogFile)
    aUsdRev = getRevenueForLocationByCurrency2(acon, aIdLocation, aDateFrom, aDateTo, "USD", aMadeAt, aLogFile)
    aEurRev = getRevenueForLocationByCurrency2(acon, aIdLocation, aDateFrom, aDateTo, "EUR", aMadeAt, aLogFile)
    getRevenueForLocation2 = aGbpRev + (aUsdRev / aGbp2usd) + (aEurRev / aGbp2eur)
end function

function getRevenueForLocationByCurrency2(byref acon, aIdLocation, aDateFrom, aDateTo, aCurr, aMadeAt, aLogFile)

    dim ars, asql, aVatFactor, aLine, aIsTrade, aCompId, aCompPrice
    getRevenueForLocationByCurrency2 = 0.0

    asql = "select p.*, q.componentid"
    asql = asql & " from purchase p, qc_history_latest q"
    asql = asql & " where p.purchase_no=q.purchase_no and p.idlocation=" & aIdLocation & " and p.ordercurrency='" & aCurr & "' and q.componentid not in (0,9)"
    if aDateFrom <> "" then
        asql = asql & " and production_completion_date is not null and production_completion_date >= '" & aDateFrom & "'"
    end if
    if aDateTo <> "" then
        asql = asql & " and production_completion_date is not null and production_completion_date <= '" & aDateTo & "'"
    end if
    if aMadeAt <> "0" then
        asql = asql & " and q.madeat=" & aMadeAt
    end if
    'trace("<br>getRevenueForLocationByCurrency2: sql = " & asql)
    set ars = getMysqlQueryRecordSet(asql, acon)

    if not isNull(aLogFile) then
        if not ars.eof then
            call addItemToLine(aLine, "Breakdown of orders included in summation:")
            call writeLine(aLogFile, aLine)
        else
            call addItemToLine(aLine, "SQL returned no orders for summation")
            call writeLine(aLogFile, aLine)
        end if
    end if

    while not ars.eof
        aIsTrade = ars("istrade")
        if aIsTrade = "y" then
            aVatFactor = 1.0
        else
            aVatFactor = 1.0 + safeCur(ars("vatrate") ) / 100.0
        end if
        aCompId = ars("componentid")
        aCompPrice = getComponentPrice(aCon, ars, aCompId)
        if(aCompPrice > 0.0) then
            getRevenueForLocationByCurrency2 = getRevenueForLocationByCurrency2 + aCompPrice / aVatFactor
        end if
        if not isNull(aLogFile) then
            call addPairToLine(aLine, "Order number", ars("order_number") )
            call addPairToLine(aLine, "vat rate", ars("vatrate") )
            call addPairToLine(aLine, "total ex vat", ars("totalexvat") )
            call addPairToLine(aLine, "accessories total", ars("accessoriestotalcost") )
            call addPairToLine(aLine, "base fabric price", ars("basefabricprice") )
            call addPairToLine(aLine, "headboard fabric cost", ars("hbfabricprice") )
            call addPairToLine(aLine, "valance fabric cost", ars("valfabricprice") )
            call addPairToLine(aLine, "upholstery price", ars("upholsteryprice") )
            call writeLine(aLogFile, aLine)
        end if
        ars.movenext
    wend
    call closemysqlrs(ars)
end function

function getExWorksRevenueForLocation(byref acon, aIdLocation, aDateFrom, aDateTo, aGbp2usd, aGbp2eur, aMadeAt, aLogFile)
    dim ars3, ars4, asql, aVatFactor, aLine, aIsTrade, aCompId, aExWorksPrice, aCurr, aCompPrice
    dim aSubCompId, aSubCompExWorksPrice, aSubCompExWorksPriceTotal, aPriceFromMatrix
    getExWorksRevenueForLocation = 0.0

    asql = "select p.*, q.componentid, c.component as compname"
    asql = asql & " from purchase p, qc_history_latest q, component c"
    asql = asql & " where p.purchase_no=q.purchase_no and p.idlocation=" & aIdLocation & " and q.componentid not in (0,9)"
    asql = asql & " and q.componentid=c.componentid"
    if aDateFrom <> "" then
        asql = asql & " and production_completion_date is not null and production_completion_date >= '" & aDateFrom & "'"
    end if
    if aDateTo <> "" then
        asql = asql & " and production_completion_date is not null and production_completion_date <= '" & aDateTo & "'"
    end if
    if aMadeAt <> "0" then
        asql = asql & " and q.madeat=" & aMadeAt
    end if
    'trace("<br>getExWorksRevenueForLocation: sql = " & asql)
    set ars3 = getMysqlQueryRecordSet(asql, acon)

    if not isNull(aLogFile) then
        if not ars3.eof then
            call addItemToLine(aLine, "Breakdown of orders included in summation:")
            call writeLine(aLogFile, aLine)
        else
            call addItemToLine(aLine, "SQL returned no orders for summation")
            call writeLine(aLogFile, aLine)
        end if
    end if
    
    while not ars3.eof
        if not isNull(aLogFile) then
            call addPairToLine(aLine, "Order number", ars3("order_number") )
            call addPairToLine(aLine, "Component", ars3("compname") )
            call addPairToLine(aLine, "vat rate", ars3("vatrate") )
            call addPairToLine(aLine, "total ex vat", ars3("totalexvat") )
            call addPairToLine(aLine, "is trade", ars3("istrade") )
            call addPairToLine(aLine, "order currency", ars3("ordercurrency") )
            call writeLine(aLogFile, aLine)
        end if

        aIsTrade = ars3("istrade")
        aCurr = ars3("ordercurrency")
        if aIsTrade = "y" then
            aVatFactor = 1.0
        else
            aVatFactor = 1.0 + safeCur(ars3("vatrate") ) / 100.0
        end if
        aCompId = ars3("componentid")
        aPriceFromMatrix = true
        aExWorksPrice = getExWorksRevenueComponentPrice(aCon, ars3("purchase_no"), aCompId)
        if aExWorksPrice < 0 then
        	aCompPrice = getComponentPrice2(aCon, ars3, aCompId)
        	aExWorksPrice = convertComponentPriceToExWorksRevenue(acon, aCompPrice, aIdLocation, aCurr, aGbp2usd, aGbp2eur)
        	aExWorksPrice = aExWorksPrice / aVatFactor
	        aPriceFromMatrix = false
        end if
        
        ' deal with the sub components
        set ars4 = getMysqlQueryRecordSet("select * from component where parentcomponentid=" & aCompId, acon)
        aSubCompExWorksPriceTotal = 0.0
        while not ars4.eof
        	aSubCompId = ars4("componentid")
        	'trace("<br>subcomp: aSubCompId=" & aSubCompId)
        	aSubCompExWorksPrice = getExWorksRevenueComponentPrice(aCon, ars3("purchase_no"), aSubCompId)
        	'trace("<br>subcomp: aSubCompExWorksPrice=" & aSubCompExWorksPrice)
	        if aSubCompExWorksPrice < 0 then
	        	aCompPrice = getComponentPrice2(aCon, ars3, aSubCompId)
	        	'trace("<br>subcomp: aCompPrice=" & aCompPrice)
	        	aSubCompExWorksPrice = convertComponentPriceToExWorksRevenue(acon, aCompPrice, aIdLocation, aCurr, aGbp2usd, aGbp2eur)
	        	'trace("<br>subcomp: aSubCompExWorksPrice=" & aSubCompExWorksPrice)
	        	aSubCompExWorksPrice = aSubCompExWorksPrice / aVatFactor
	        end if
	        aSubCompExWorksPriceTotal = aSubCompExWorksPriceTotal + aSubCompExWorksPrice
        	ars4.movenext
        wend
    	call closemysqlrs(ars4)

        aExWorksPrice = aExWorksPrice + aSubCompExWorksPriceTotal

        if not isNull(aLogFile) then
            call addPairToLine(aLine, "Component ex-works price total", (aExWorksPrice-aSubCompExWorksPriceTotal) )
            call addPairToLine(aLine, "Sub-components ex-works price total", aSubCompExWorksPriceTotal )
            call addPairToLine(aLine, "Component ex-works price total", aExWorksPrice )
            if aPriceFromMatrix then
            	call addItemToLine(aLine, "Ex-works price came from price matrix" )
            else
            	call addItemToLine(aLine, "Ex-works price came from order" )
            end if
            call writeLine(aLogFile, aLine)
        end if

        if(aExWorksPrice > 0.0) then
            getExWorksRevenueForLocation = getExWorksRevenueForLocation + aExWorksPrice
        end if
        ars3.movenext
    wend
    call closemysqlrs(ars3)
end function

function getExWorksRevenueComponentPrice(byref aCon, apn, aCompId)
	getExWorksRevenueComponentPrice = getExWorksRevenue(acon, apn, aCompId)
end function

function convertComponentPriceToExWorksRevenue(byref acon, aCompPrice, aLocationId, aOrderCurrency, aGbp2usd, aGbp2eur)
	dim ars, asql, aRevenueFactor
	
	asql = " select revenue_factor from location where idlocation=" & aLocationId
	set ars = getMysqlQueryRecordSet(asql, acon)
	aRevenueFactor = safeCur(ars("revenue_factor"))
	call closemysqlrs(ars)

	convertComponentPriceToExWorksRevenue = aCompPrice / aRevenueFactor
	if aOrderCurrency = "USD" then
		convertComponentPriceToExWorksRevenue = convertComponentPriceToExWorksRevenue / aGbp2usd
	elseif aOrderCurrency = "EUR" then
		convertComponentPriceToExWorksRevenue = convertComponentPriceToExWorksRevenue / aGbp2eur
	end if
	
	'trace("<br>convertComponentPriceToExWorksRevenue: aRevenueFactor = " & aRevenueFactor)
	'trace("<br>convertComponentPriceToExWorksRevenue: aOrderCurrency = " & aOrderCurrency)
	'trace("<br>convertComponentPriceToExWorksRevenue: aCompPrice = " & aCompPrice)
	'trace("<br>convertComponentPriceToExWorksRevenue: convertComponentPriceToExWorksRevenue = " & convertComponentPriceToExWorksRevenue)
end function

function getInvoicedItemCount(byref acon, aIdLocation, aDateFrom, aDateTo, aMadeAt, aLogFile)
    dim ars, asql, aLine
    asql = "select count(*) as count from qc_history_latest where componentid <> 0 and finished is not null"
    if aMadeAt <> "0" then
        asql = asql & " and madeat=" & aMadeAt
    end if
    asql = asql & " and purchase_no in (select p.purchase_no from purchase p, payment t where p.idlocation=" & aIdLocation & " and p.purchase_no=t.purchase_no and t.paymenttype in ('Full Payment','Final Payment')"
    if aDateFrom <> "" then
        asql = asql & " and t.invoicedate >= '" & aDateFrom & "'"
    end if
    if aDateTo <> "" then
        asql = asql & " and t.invoicedate <= '" & aDateTo & "'"
    end if
    asql = asql & ")"
    'trace("<br>getInvoicedItemCount: sql = " & asql)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "getInvoicedItemCount: sql")
        call addItemToLine(aLine, """" &asql& """")
        call writeLine(aLogFile, aLine)
    end if
    set ars = getMysqlQueryRecordSet(asql, acon)
    if ars.eof then
        getInvoicedItemCount = 0
    else
        getInvoicedItemCount = cint(ars("count") )
    end if
    call closemysqlrs(ars)

    if not isNull(aLogFile) then
        ' provide a breakdown of the orders included
        asql = "select p.order_number from qc_history_latest q, purchase p where q.componentid <> 0 and q.finished is not null and q.purchase_no=p.purchase_no"
        if aMadeAt <> "0" then
            asql = asql & " and q.madeat=" & aMadeAt
        end if
        asql = asql & " and q.purchase_no in (select p.purchase_no from purchase p, payment t where p.idlocation=" & aIdLocation & " and p.purchase_no=t.purchase_no and t.paymenttype in ('Full Payment','Final Payment')"
        if aDateFrom <> "" then
            asql = asql & " and t.invoicedate >= '" & aDateFrom & "'"
        end if
        if aDateTo <> "" then
            asql = asql & " and t.invoicedate <= '" & aDateTo & "'"
        end if
        asql = asql & ")"

        set ars = getMysqlQueryRecordSet(asql, acon)
        if not ars.eof then
            call addItemToLine(aLine, "Orders included:")
            call writeLine(aLogFile, aLine)
        else
            call addItemToLine(aLine, "SQL returned no orders")
            call writeLine(aLogFile, aLine)
        end if
        while not ars.eof
            call addPairToLine(aLine, "Order number", ars("order_number") )
            call writeLine(aLogFile, aLine)
            ars.movenext
        wend
        call closemysqlrs(ars)
    end if
end function

function getCompletedItemCount(byref acon, aIdLocation, aDateFrom, aDateTo, aMadeAt, aLogFile)
    dim ars, asql, aLine
    asql = "select count(*) as count from qc_history_latest where componentid <> 0"
    if aMadeAt <> "0" then
        asql = asql & " and madeat=" & aMadeAt
    end if
    asql = asql & " and purchase_no in (select purchase_no from purchase where idlocation=" & aIdLocation & ")"
    if aDateFrom <> "" then
        asql = asql & " and finished is not null and finished >= '" & aDateFrom & "'"
    end if
    if aDateTo <> "" then
        asql = asql & " and finished is not null and finished <= '" & aDateTo & "'"
    end if
    'trace("<br>getCompletedItemCount: sql = " & asql)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "getCompletedItemCount: sql")
        call addItemToLine(aLine, """" &asql& """")
        call writeLine(aLogFile, aLine)
    end if
    set ars = getMysqlQueryRecordSet(asql, acon)
    if ars.eof then
        getCompletedItemCount = 0
    else
        getCompletedItemCount = cint(ars("count") )
    end if
    call closemysqlrs(ars)

    if not isNull(aLogFile) then
        ' provide a breakdown of the orders included
        asql = "select p.order_number from qc_history_latest q, purchase p where q.componentid <> 0 and q.finished is not null and q.purchase_no=p.purchase_no"
        asql = "select p.order_number from qc_history_latest q, purchase p where q.componentid <> 0 and q.purchase_no=p.purchase_no"
        if aMadeAt <> "0" then
            asql = asql & " and q.madeat=" & aMadeAt
        end if
        asql = asql & " and q.purchase_no in (select purchase_no from purchase where idlocation=" & aIdLocation & ")"
        if aDateFrom <> "" then
            asql = asql & " and finished is not null and finished >= '" & aDateFrom & "'"
        end if
        if aDateTo <> "" then
            asql = asql & " and finished is not null and finished <= '" & aDateTo & "'"
        end if

        set ars = getMysqlQueryRecordSet(asql, acon)
        if not ars.eof then
            call addItemToLine(aLine, "Orders included:")
            call writeLine(aLogFile, aLine)
        else
            call addItemToLine(aLine, "SQL returned no orders")
            call writeLine(aLogFile, aLine)
        end if
        while not ars.eof
            call addPairToLine(aLine, "Order number", ars("order_number") )
            call writeLine(aLogFile, aLine)
            ars.movenext
        wend
        call closemysqlrs(ars)
    end if
end function

function getInvoicedProductionThroughput(byref acon, aIdLocation, aDateFrom, aDateTo, aMadeAt, aLogFile)
    dim ars, asql, aPn, aCompId, ars2, aInProdDate, aFinishedDate, aDiff, aData(), aCount, aLine
    asql = "select purchase_no, componentid, finished, qc_historyid from qc_history_latest where componentid <> 0"
    if aMadeAt <> "0" then
        asql = asql & " and madeat=" & aMadeAt
    end if
    asql = asql & " and purchase_no in (select purchase_no from purchase where idlocation=" & aIdLocation & ")"
    if aDateFrom <> "" then
        asql = asql & " and finished is not null and finished >= '" & aDateFrom & "'"
    end if
    if aDateTo <> "" then
        asql = asql & " and finished is not null and finished <= '" & aDateTo & "'"
    end if
    'trace("<br>getInvoicedProductionThroughput: sql = " & asql)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "getInvoicedProductionThroughput: sql")
        call addItemToLine(aLine, """" &asql& """")
        call writeLine(aLogFile, aLine)
    end if

    set ars = getMysqlQueryRecordSet(asql, acon)
    while not ars.eof
        aInProdDate = ""
        aFinishedDate = ""
        if not isnull(ars("finished") ) and ars("finished") <> "" then
            aFinishedDate = cdate(ars("finished") )
        end if
        aPn = ars("purchase_no")
        aCompId = ars("componentid")
        if not isNull(aLogFile) then
            call addItemToLine(aLine, "getInvoicedProductionThroughput: order no. ")
            call addItemToLine(aLine, getOrderNumberForPurchaseNo(acon, aPn) )
            call writeLine(aLogFile, aLine)
        end if
        ' the old way using last time the status changed to 20
        'asql = "select qc_date from qc_history where purchase_no=" & aPn & " and componentid=" & aCompId & " and qc_statusid=20 order by qc_historyid desc"
		' the new way using issueddate
		asql = "select max(issueddate) as first from qc_history where issueddate is not null and purchase_no=" & aPn & " and componentid=" & aCompId
        if not isNull(aLogFile) then
            call addItemToLine(aLine, "getInvoicedProductionThroughput: sql")
            call addItemToLine(aLine, """" &asql& """")
            call writeLine(aLogFile, aLine)
        end if
        set ars2 = getMysqlQueryRecordSet(asql, acon)
        if not ars2.eof and not isnull(ars2("first")) then
            aInProdDate = cdate(ars2("first"))
        end if
        call closemysqlrs(ars2)

        'trace("<br>getInvoicedProductionThroughput: qc_historyid = " & ars("qc_historyid"))
        'trace("<br>getInvoicedProductionThroughput: aInProdDate = " & aInProdDate)
        'trace("<br>getInvoicedProductionThroughput: aFinishedDate = " & aFinishedDate)
        if aInProdDate <> "" and aFinishedDate <> "" then
            aDiff = datediff("D", aInProdDate, aFinishedDate)
            'trace("<br>getInvoicedProductionThroughput: aDiff = " & aDiff)
            aCount = aCount + 1
            redim preserve aData(aCount)
            aData(aCount) = aDiff
            if not isNull(aLogFile) then
                call addItemToLine(aLine, "InProdDate")
                call addItemToLine(aLine, aInProdDate)
                call addItemToLine(aLine, "FinishedDate")
                call addItemToLine(aLine, aFinishedDate)
                call addItemToLine(aLine, "Diff")
                call addItemToLine(aLine, aDiff)
                call writeLine(aLogFile, aLine)
            end if
        else
            if not isNull(aLogFile) then
                call addItemToLine(aLine, "Not using this order due to an unavilable date as follows")
                call addItemToLine(aLine, "InProdDate")
                call addItemToLine(aLine, aInProdDate)
                call addItemToLine(aLine, "FinishedDate")
                call addItemToLine(aLine, aFinishedDate)
                call addItemToLine(aLine, "Diff")
                call addItemToLine(aLine, aDiff)
                call writeLine(aLogFile, aLine)
            end if
        end if

        ars.movenext
    wend
    call closemysqlrs(ars)

    getInvoicedProductionThroughput = median(aData)
	'trace("<br>getInvoicedProductionThroughput: getInvoicedProductionThroughput = " & getInvoicedProductionThroughput)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "Median")
        call addItemToLine(aLine, getInvoicedProductionThroughput)
        call writeLine(aLogFile, aLine)
    end if
end function

' no longer used - replaced with getOrderDateVsCompletionDate2 below
function getOrderDateVsCompletionDate(byref acon, aIdLocation, aDateFrom, aDateTo, aLogFile)
    dim ars, asql, aOrderDate, aCompletionDate, aDiff, aLine, aData(), aCount
    asql = "select purchase_no, production_completion_date, order_date from purchase where idlocation=" & aIdLocation & " and order_date is not null and production_completion_date is not null"
    if aDateFrom <> "" then
        asql = asql & " and production_completion_date >= '" & aDateFrom & "'"
    end if
    if aDateTo <> "" then
        asql = asql & " and production_completion_date <= '" & aDateTo & "'"
    end if
    'trace("<br>getOrderDateVsCompletionDate: sql = " & asql)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "getOrderDateVsCompletionDate: sql")
        call addItemToLine(aLine, """" &asql& """")
        call writeLine(aLogFile, aLine)
    end if

    set ars = getMysqlQueryRecordSet(asql, acon)
    aCount = 0
    while not ars.eof
        aOrderDate = cdate(ars("order_date") )
        aCompletionDate = cdate(ars("production_completion_date") )

        'trace("<br>getOrderDateVsCompletionDate: purchase_no = " & ars("purchase_no"))
        'trace("<br>getOrderDateVsCompletionDate: aOrderDate = " & aOrderDate)
        'trace("<br>getOrderDateVsCompletionDate: aCompletionDate = " & aCompletionDate)
        aDiff = datediff("D", aOrderDate, aCompletionDate)
        if not isNull(aLogFile) then
            call addItemToLine(aLine, "order no. ")
            call addItemToLine(aLine, getOrderNumberForPurchaseNo(acon, ars("purchase_no") ) )
            call addItemToLine(aLine, "OrderDate ")
            call addItemToLine(aLine, aOrderDate)
            call addItemToLine(aLine, "CompletionDate ")
            call addItemToLine(aLine, aCompletionDate)
            call addItemToLine(aLine, "Diff ")
            call addItemToLine(aLine, aDiff)
            call writeLine(aLogFile, aLine)
        end if
        'trace("<br>getOrderDateVsCompletionDate: aDiff = " & aDiff)
        aCount = aCount + 1
        redim preserve aData(aCount)
        aData(aCount) = aDiff

        ars.movenext
    wend
    call closemysqlrs(ars)

    if not isNull(aLogFile) then
        call writeLine(aLogFile, aLine)
    end if
    getOrderDateVsCompletionDate = median(aData)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "Median ")
        call addItemToLine(aLine, getOrderDateVsCompletionDate)
        call writeLine(aLogFile, aLine)
    end if
'trace("<br>getOrderDateVsCompletionDate = " & getOrderDateVsCompletionDate)
end function

function getOrderDateVsCompletionDate2(byref acon, aIdLocation, aDateFrom, aDateTo, aMadeAt, aLogFile)
    dim ars, asql, aOrderDate, aMaxFinishedDate, aDiff, aLine, aData(), aCount
    asql = "select * from purchase where order_date is not null and idlocation=" & aIdLocation
    asql = asql & " and purchase_no in (select distinct purchase_no from qc_history_latest"
    asql = asql & " where componentid not in (0,9) and finished is not null and finished >= '" & aDateFrom & "' and finished <= '" & aDateTo & "'"
    if aMadeAt <> 0 then
        asql = asql & " and madeat=" & aMadeAt
    end if
    asql = asql & ")"
    'trace("<br>getOrderDateVsCompletionDate2: sql = " & asql)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "getOrderDateVsCompletionDate2: sql")
        call addItemToLine(aLine, """" &asql& """")
        call writeLine(aLogFile, aLine)
    end if

    set ars = getMysqlQueryRecordSet(asql, acon)
    aCount = 0
    while not ars.eof
        aOrderDate = cdate(ars("order_date") )
        aMaxFinishedDate = getMaxFinishedDateForOrderItems(acon, ars("purchase_no") )

        if not isNull(aMaxFinishedDate) then
            if aMaxFinishedDate >= cdate(aDateFrom) and aMaxFinishedDate <= cdate(aDateTo) then
                'trace("<br>getOrderDateVsCompletionDate2: purchase_no = " & ars("purchase_no"))
                'trace("<br>getOrderDateVsCompletionDate2: aOrderDate = " & aOrderDate)
                'trace("<br>getOrderDateVsCompletionDate2: aMaxFinishedDate = " & aMaxFinishedDate)
                aDiff = datediff("D", aOrderDate, aMaxFinishedDate)
                if not isNull(aLogFile) then
                    call addItemToLine(aLine, "order no. ")
                    call addItemToLine(aLine, getOrderNumberForPurchaseNo(acon, ars("purchase_no") ) )
                    call addItemToLine(aLine, "OrderDate ")
                    call addItemToLine(aLine, aOrderDate)
                    call addItemToLine(aLine, "Last component finished date ")
                    call addItemToLine(aLine, aMaxFinishedDate)
                    call addItemToLine(aLine, "Diff ")
                    call addItemToLine(aLine, aDiff)
                    call writeLine(aLogFile, aLine)
                end if
                'trace("<br>getOrderDateVsCompletionDate2: aDiff = " & aDiff)
                aCount = aCount + 1
                redim preserve aData(aCount)
                aData(aCount) = aDiff
            else
            'trace("<br>Discarding " & ars("purchase_no") & " " & aMaxFinishedDate)
            end if
        end if

        ars.movenext
    wend
    call closemysqlrs(ars)

    if not isNull(aLogFile) then
        call writeLine(aLogFile, aLine)
    end if
    getOrderDateVsCompletionDate2 = median(aData)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "Median ")
        call addItemToLine(aLine, getOrderDateVsCompletionDate2)
        call writeLine(aLogFile, aLine)
    end if
'trace("<br>getOrderDateVsCompletionDate2 = " & getOrderDateVsCompletionDate2)
end function

function getFirstInProductionDateVsCompletionDate(byref acon, aIdLocation, aDateFrom, aDateTo, aMadeAt, aLogFile)
    dim ars, asql, aFirstInProdDate, aMaxFinishedDate, aDiff, aLine, aData(), aCount
    asql = "select * from purchase where order_date is not null and idlocation=" & aIdLocation
    asql = asql & " and purchase_no in (select distinct purchase_no from qc_history_latest"
    asql = asql & " where componentid not in (0,9) and finished is not null and finished >= '" & aDateFrom & "' and finished <= '" & aDateTo & "'"
    if aMadeAt <> 0 then
        asql = asql & " and madeat=" & aMadeAt
    end if
    asql = asql & ")"
    'trace("<br>getFirstInProductionDateVsCompletionDate: sql = " & asql)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "getFirstInProductionDateVsCompletionDate: sql")
        call addItemToLine(aLine, """" &asql& """")
        call writeLine(aLogFile, aLine)
    end if

    set ars = getMysqlQueryRecordSet(asql, acon)
    aCount = 0
    while not ars.eof
        aFirstInProdDate = getFirstInProductionDateForOrder(acon, ars("purchase_no") )
        aMaxFinishedDate = getMaxFinishedDateForOrderItems(acon, ars("purchase_no") )

        if not isNull(aFirstInProdDate) and not isNull(aMaxFinishedDate) then
            if aMaxFinishedDate >= cdate(aDateFrom) and aMaxFinishedDate <= cdate(aDateTo) then
                'trace("<br>getFirstInProductionDateVsCompletionDate: purchase_no = " & ars("purchase_no"))
                'trace("<br>getFirstInProductionDateVsCompletionDate: FirstInProdDate = " & aFirstInProdDate)
                'trace("<br>getFirstInProductionDateVsCompletionDate: MaxFinishedDate = " & aMaxFinishedDate)
                aDiff = datediff("D", aFirstInProdDate, aMaxFinishedDate)
                if not isNull(aLogFile) then
                    call addItemToLine(aLine, "order no. ")
                    call addItemToLine(aLine, getOrderNumberForPurchaseNo(acon, ars("purchase_no") ) )
                    call addItemToLine(aLine, "First In Production Date ")
                    call addItemToLine(aLine, aFirstInProdDate)
                    call addItemToLine(aLine, "Last component finished date ")
                    call addItemToLine(aLine, aMaxFinishedDate)
                    call addItemToLine(aLine, "Diff ")
                    call addItemToLine(aLine, aDiff)
                    call writeLine(aLogFile, aLine)
                end if
                'trace("<br>getFirstInProductionDateVsCompletionDate: aDiff = " & aDiff)
                aCount = aCount + 1
                redim preserve aData(aCount)
                aData(aCount) = aDiff
            else
            'trace("<br>Discarding " & ars("purchase_no") & " " & aMaxFinishedDate)
            end if
        end if

        ars.movenext
    wend
    call closemysqlrs(ars)

    if not isNull(aLogFile) then
        call writeLine(aLogFile, aLine)
    end if
    getFirstInProductionDateVsCompletionDate = median(aData)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "Median ")
        call addItemToLine(aLine, getFirstInProductionDateVsCompletionDate)
        call writeLine(aLogFile, aLine)
    end if
	'trace("<br>getFirstInProductionDateVsCompletionDate = " & getFirstInProductionDateVsCompletionDate)
end function

function getThroughput(byref acon, aIdLocation, aDateFrom, aDateTo, aMadeAt, aLogFile)
    dim ars, asql, aFirstStartedDate, aMaxFinishedDate, aDiff, aLine, aData(), aCount, aFirstInProdDate
    asql = "select * from purchase where order_date is not null"
    if aIdLocation <> 0 then
    	asql = asql & " and idlocation=" & aIdLocation
    end if
    asql = asql & " and purchase_no in (select distinct purchase_no from qc_history_latest"
    asql = asql & " where componentid not in (0,9) and finished is not null and finished >= '" & aDateFrom & "' and finished <= '" & aDateTo & "'"
    if aMadeAt <> 0 then
        asql = asql & " and madeat=" & aMadeAt
    end if
    asql = asql & ")"
    trace("<br>getThroughput: sql = " & asql)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "getThroughput: sql")
        call addItemToLine(aLine, """" &asql& """")
        call writeLine(aLogFile, aLine)
    end if

    set ars = getMysqlQueryRecordSet(asql, acon)
    aCount = 0
    while not ars.eof
    	aFirstInProdDate = getFirstInProductionDateForOrder(acon, ars("purchase_no") )
        aFirstStartedDate = getFirstStartedDateForOrder(acon, ars("purchase_no") )
        aMaxFinishedDate = getMaxFinishedDateForOrderItems(acon, ars("purchase_no") )
        trace("<br>getThroughput: purchase_no = " & ars("purchase_no"))
        trace("<br>getThroughput: aFirstInProdDate = " & aFirstInProdDate)
        trace("<br>getThroughput: aFirstStartedDate = " & aFirstStartedDate)
        trace("<br>getThroughput: aMaxFinishedDate = " & aMaxFinishedDate)

        if not isNull(aFirstStartedDate) and not isNull(aMaxFinishedDate) then
            if aMaxFinishedDate >= cdate(aDateFrom) and aMaxFinishedDate <= cdate(aDateTo) then
                trace("<br>getThroughput: FirstStartedDate = " & aFirstStartedDate)
                trace("<br>getThroughput: MaxFinishedDate = " & aMaxFinishedDate)
                aDiff = datediff("D", aFirstStartedDate, aMaxFinishedDate)
                if not isNull(aLogFile) then
                    call addItemToLine(aLine, "order no. ")
                    call addItemToLine(aLine, getOrderNumberForPurchaseNo(acon, ars("purchase_no") ) )
                    call addItemToLine(aLine, "First In Production Date ")
                    call addItemToLine(aLine, aFirstStartedDate)
                    call addItemToLine(aLine, "Last component finished date ")
                    call addItemToLine(aLine, aMaxFinishedDate)
                    call addItemToLine(aLine, "Diff ")
                    call addItemToLine(aLine, aDiff)
                    call writeLine(aLogFile, aLine)
                end if
                trace("<br>getThroughput: aDiff = " & aDiff)
                aCount = aCount + 1
                redim preserve aData(aCount)
                aData(aCount) = aDiff
            else
            	trace("<br>Discarding " & ars("purchase_no") & " " & aMaxFinishedDate)
            end if
        else
           	trace("<br>Discarding " & ars("purchase_no") & " " & aFirstStartedDate & " " & aMaxFinishedDate)
        end if

        ars.movenext
    wend
    call closemysqlrs(ars)

    if not isNull(aLogFile) then
        call writeLine(aLogFile, aLine)
    end if
    getThroughput = median(aData)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "Median ")
        call addItemToLine(aLine, getThroughput)
        call writeLine(aLogFile, aLine)
    end if
	trace("<br>getThroughput = " & getThroughput)
end function

function getDeliveryScheduleAchieved(byref acon, aIdLocation, aDateFrom, aDateTo, aMadeAt, aLogFile)
    dim ars, asql, aProductionDate, aFinishedDate, aCompletedTotal, aCompletedInTimeTotal, aDiff, aLine
    asql = "select q.purchase_no, q.componentid, q.finished, q.bcwexpected from qc_history_latest q, purchase p where q.purchase_no=p.purchase_no and q.finished is not null and q.bcwexpected is not null"
    if aIdLocation <> "" and aIdLocation <> "all" then
        asql = asql & " and p.idlocation=" & aIdLocation
    end if
    if aMadeAt <> "0" then
        asql = asql & " and q.madeat=" & aMadeAt
    end if
    if aDateFrom <> "" then
        asql = asql & " and q.finished >= '" & aDateFrom & "'"
    end if
    if aDateTo <> "" then
        asql = asql & " and q.finished <= '" & aDateTo & "'"
    end if
    'trace("<br>getDeliveryScheduleAchieved: sql = " & asql)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "getDeliveryScheduleAchieved: sql")
        call addItemToLine(aLine, """" &asql& """")
        call writeLine(aLogFile, aLine)
    end if

    aCompletedTotal = 0
    aCompletedInTimeTotal = 0

    set ars = getMysqlQueryRecordSet(asql, acon)
    while not ars.eof
        aProductionDate = cdate(ars("bcwexpected") )
        aFinishedDate = cdate(ars("finished") )
        if not isNull(aLogFile) then
            call addItemToLine(aLine, "getDeliveryScheduleAchieved: order no. ")
            call addItemToLine(aLine, getOrderNumberForPurchaseNo(acon, ars("purchase_no") ) )
            call addItemToLine(aLine, "ComponentId")
            call addItemToLine(aLine, ars("componentid") )
            call addItemToLine(aLine, "ProductionDate")
            call addItemToLine(aLine, aProductionDate)
            call addItemToLine(aLine, "FinishedDate")
            call addItemToLine(aLine, aFinishedDate)
            call writeLine(aLogFile, aLine)
        end if

        aCompletedTotal = aCompletedTotal + 1
        aDiff = datediff("D", aProductionDate, aFinishedDate)
        if aDiff <= 0 then
            aCompletedInTimeTotal = aCompletedInTimeTotal + 1
        'trace("<br>completed in time")
        end if

        ars.movenext
    wend
    call closemysqlrs(ars)

    'trace("<br>getDeliveryScheduleAchieved: aCompletedTotal = " & aCompletedTotal)
    'trace("<br>getDeliveryScheduleAchieved: aCompletedInTimeTotal = " & aCompletedInTimeTotal)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "getDeliveryScheduleAchieved: CompletedTotal")
        call addItemToLine(aLine, aCompletedTotal)
        call writeLine(aLogFile, aLine)
        call addItemToLine(aLine, "getDeliveryScheduleAchieved: CompletedInTimeTotal")
        call addItemToLine(aLine, aCompletedInTimeTotal)
        call writeLine(aLogFile, aLine)
    end if
    if aCompletedTotal > 0 then
        getDeliveryScheduleAchieved = 100.0 * aCompletedInTimeTotal / aCompletedTotal
    else
        getDeliveryScheduleAchieved = 0
    end if
'trace("<br>getDeliveryScheduleAchieved: getDeliveryScheduleAchieved = " & getDeliveryScheduleAchieved)
end function

function getApproxDelDateVsBookedDelDate(byref acon, aIdLocation, aDateFrom, aDateTo, aLogFile)
    dim ars, asql, aApproxDelDate, aBookedDelDate, aDiff, aLine, aData(), aCount
    asql = "select purchase_no, deliverydate, bookeddeliverydate from purchase where deliverydate is not null and bookeddeliverydate is not null"
    if aIdLocation <> "" and aIdLocation <> "all" then
        asql = asql & " and idlocation=" & aIdLocation
    end if
    if aDateFrom <> "" then
        asql = asql & " and deliverydate >= '" & aDateFrom & "'"
    end if
    if aDateTo <> "" then
        asql = asql & " and deliverydate <= '" & aDateTo & "'"
    end if
    'trace("<br>getApproxDelDateVsBookedDelDate: sql = " & asql)
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "getApproxDelDateVsBookedDelDate: sql")
        call addItemToLine(aLine, """" &asql& """")
        call writeLine(aLogFile, aLine)
    end if

    set ars = getMysqlQueryRecordSet(asql, acon)
    aCount = 0
    while not ars.eof
        aApproxDelDate = cdate(ars("deliverydate") )
        aBookedDelDate = cdate(ars("bookeddeliverydate") )

        'trace("<br>getApproxDelDateVsBookedDelDate: purchase_no = " & ars("purchase_no"))
        'trace("<br>getApproxDelDateVsBookedDelDate: aApproxDelDate = " & aApproxDelDate)
        'trace("<br>getApproxDelDateVsBookedDelDate: aBookedDelDate = " & aBookedDelDate)
        aDiff = datediff("D", aApproxDelDate, aBookedDelDate)
        if not isNull(aLogFile) then
            call addItemToLine(aLine, "order no. ")
            call addItemToLine(aLine, getOrderNumberForPurchaseNo(acon, ars("purchase_no") ) )
            call addItemToLine(aLine, "Approx delivery date ")
            call addItemToLine(aLine, aApproxDelDate)
            call addItemToLine(aLine, "Booked delivery date ")
            call addItemToLine(aLine, aBookedDelDate)
            call addItemToLine(aLine, "Diff ")
            call addItemToLine(aLine, aDiff)
            call writeLine(aLogFile, aLine)
        end if
        'trace("<br>getApproxDelDateVsBookedDelDate: aDiff = " & aDiff)
        aCount = aCount + 1
        redim preserve aData(aCount)
        aData(aCount) = aDiff

        ars.movenext
    wend
    call closemysqlrs(ars)

    if not isNull(aLogFile) then
        call writeLine(aLogFile, aLine)
    end if
    'trace("<br>aCount=" & aCount)
    if aCount > 0 then
	    getApproxDelDateVsBookedDelDate = mean(aData)
    else
	    getApproxDelDateVsBookedDelDate = 0.0
    end if
    if not isNull(aLogFile) then
        call addItemToLine(aLine, "Mean ")
        call addItemToLine(aLine, getApproxDelDateVsBookedDelDate)
        call writeLine(aLogFile, aLine)
    end if
'trace("<br>getApproxDelDateVsBookedDelDate = " & getApproxDelDateVsBookedDelDate)
end function

function getFactoryName(byref acon, aManufacturedAtID)
    dim ars
    Set ars = getMysqlQueryRecordSet("Select * from manufacturedat where ManufacturedAtID=" & aManufacturedAtID, acon)
    getFactoryName = ""
    if not ars.eof then
        getFactoryName = ars("ManufacturedAt")
    end if
    closers(ars)
end function

sub addItemToLine(byref aline, byref aitem)
    if aline <> "" then aline = aline & ","
    aline = aline & aitem
end sub

sub addPairToLine(byref aline, byref aitem1, byref aitem2)
    call addItemToLine(aline, aitem1)
    call addItemToLine(aline, aitem2)
end sub

sub writeLine(byref afile, byref aline)
    on error resume next
    afile.WriteLine(aline)
    if err.number <> 0 then
    end if

    on error goto 0
    aline = ""
end sub

sub writeBlankLine(byref afile)
    afile.WriteLine("")
end sub

function median(ByVal aNumericArray)
    Dim arrLngAns, lngElement1, lngElement2, dblSum, dblAns, lngElementCount

    'sort array
    arrLngAns = BubbleSortArray(aNumericArray)
    If Not IsArray(arrLngAns) Then
        median = 0
        Exit Function
    End If

    lngElementCount = (UBound(arrLngAns) - LBound(arrLngAns) ) + 1

    If UBound(arrLngAns) Mod 2 = 0 Then
        lngElement1 = (UBound(arrLngAns) / 2) + _
            (LBound(arrLngAns) / 2)
    Else
        lngElement1 = Int(UBound(arrLngAns) / 2) + _
            Int(LBound(arrLngAns) / 2) + 1
    End If

    If lngElementCount Mod 2 <> 0 Then
        dblAns = arrLngAns(lngElement1)
    Else
        lngElement2 = lngElement1 + 1
        on error resume next
        dblSum = arrLngAns(lngElement1) + arrLngAns(lngElement2)
        if err.number <> 0 then
            dblAns = arrLngAns(lngElement1)
        end if
        on error goto 0
        dblAns = dblSum / 2
    End If

    median = dblAns
End Function

function mean(ByVal aNumericArray)
    Dim dblSum, lngElementCount, ai

    lngElementCount = UBound(aNumericArray)
    dblSum = 0.0
    for ai = 1 to UBound(aNumericArray)
        dblSum = dblSum + aNumericArray(ai)
    next

    mean = dblSum / lngElementCount
End Function

function bubbleSortArray(byval aNumericArray)

    Dim aAns, aTemp, aSorted, aCtr, aCount, aStart

    aAns = aNumericArray
    If Not IsArray(aAns) Then
        bubbleSortArray = vbEmpty
        Exit Function
    End If

    on error resume next
    aStart = LBound(aAns)
    aCount = UBound(aAns)
    if err.number <> 0 then
        bubbleSortArray = vbEmpty
        Exit Function
    end if
    on error goto 0

    aSorted = False

    Do While Not aSorted
        aSorted = True

        For aCtr = aCount - 1 To aStart Step -1
            If aAns(aCtr + 1) < aAns(aCtr) Then
                aSorted = False
                aTemp = aAns(aCtr)
                aAns(aCtr) = aAns(aCtr + 1)
                aAns(aCtr + 1) = aTemp
            End If
        Next

    Loop

    bubbleSortArray = aAns
End Function

function getComponentPrice(byref aCon, byref aPurchaseRs, aCompId)
    dim ars, aPriceField, asql
    set ars = getMysqlQueryRecordSet("select PRICE_FIELD_NAME from component where componentid=" & aCompId, acon)
    if not ars.eof then
        aPriceField = ars("PRICE_FIELD_NAME")
        getComponentPrice = safeCur(aPurchaseRs(aPriceField) )
        if aCompId = 3 then
            ' add in upholstery price
            getComponentPrice = getComponentPrice + safeCur(aPurchaseRs("upholsteryprice") )
        end if
    else
        getComponentPrice = 0.0
    end if
    call closemysqlrs(ars)
end function

function getComponentPrice2(byref aCon, byref aPurchaseRs, aCompId)
    dim ars2, asql, aPriceField
    set ars2 = getMysqlQueryRecordSet("select PRICE_FIELD_NAME from component where componentid=" & aCompId, acon)
    if not ars2.eof then
    	'trace("<br>getComponentPrice2: aPriceField = " & aPriceField)
    	aPriceField = ars2("PRICE_FIELD_NAME")
    	'trace("<br>getComponentPrice2: aCompId = " & aCompId)
        getComponentPrice2 = safeCur(aPurchaseRs(aPriceField))
    else
        getComponentPrice2 = 0.0
    end if
    call closemysqlrs(ars2)
end function

function getMaxFinishedDateForOrderItems(byref acon, aPn)
    dim asql, ars, acount
    asql = "select count(*) as count from qc_history_latest where purchase_no=" & aPn & " and componentid not in (0,9) and finished is null"
    set ars = getMysqlQueryRecordSet(asql, acon)
    acount = defaultInt(ars("count"), 0)
    call closemysqlrs(ars)
    if acount > 0 then
    	' order has unfinished components, so it shouldn't be included in the calculation
    	trace("<br>getMaxFinishedDateForOrderItems: " & aPn & " has unfinished components")
        getMaxFinishedDateForOrderItems = null
        exit function
    end if

    asql = "select max(finished) as maxfin from qc_history_latest where purchase_no=" & aPn & " and componentid not in (0,9) and finished is not null"
    set ars = getMysqlQueryRecordSet(asql, acon)
    if not ars.eof then
        getMaxFinishedDateForOrderItems = cdate(ars("maxfin") )
    else
        getMaxFinishedDateForOrderItems = null
    end if
    call closemysqlrs(ars)
end function

function getFirstInProductionDateForOrder(byref acon, aPn)
    dim asql, ars
    ' the old way before issueddate was added to qc_history
    'asql = "select min(qc_date) as first from qc_history where purchase_no=" & aPn & " and componentid not in (0,9) and qc_date is not null and qc_statusid=20"
    ' the new way using issueddate
    asql = "select min(issueddate) as first from qc_history where issueddate is not null and purchase_no=" & aPn & " and componentid not in (0,9)"
    set ars = getMysqlQueryRecordSet(asql, acon)
    if not ars.eof then
        if not isnull(ars("first") ) then
            getFirstInProductionDateForOrder = cdate(ars("first") )
        else
            getFirstInProductionDateForOrder = null
        end if
    else
        getFirstInProductionDateForOrder = null
    end if
    call closemysqlrs(ars)
end function

function getFirstStartedDateForOrder(byref acon, aPn)
    dim asql, ars
    asql = "select min(first) as first from ("
	asql = asql + " select min(cut) as first from qc_history where cut is not null and purchase_no=" & aPn & " and componentid not in (0,9)"
	asql = asql + " union"
	asql = asql + " select min(Machined) as first from qc_history where Machined is not null and purchase_no=" & aPn & " and componentid not in (0,9)"
	asql = asql + " union"
	asql = asql + " select min(Framed) as first from qc_history where Framed is not null and purchase_no=" & aPn & " and componentid not in (0,9)"
	asql = asql + " union"
	asql = asql + " select min(prepped) as first from qc_history where prepped is not null and purchase_no=" & aPn & " and componentid not in (0,9)"
	asql = asql + " ) as x"
    set ars = getMysqlQueryRecordSet(asql, acon)
    if not ars.eof then
        if not isnull(ars("first") ) then
            getFirstStartedDateForOrder = cdate(ars("first") )
        else
            getFirstStartedDateForOrder = null
        end if
    else
        getFirstStartedDateForOrder = null
    end if
    call closemysqlrs(ars)
end function
%>