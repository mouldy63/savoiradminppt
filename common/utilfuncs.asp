<%
dim DOMAINNAME
DOMAINNAME = ""

dim theCurrencyLocations(), theCurrencies(), nCurrencies, theDate
nCurrencies = 0
theDate = year(now()) & month(now()) & day(now())

function selected(firstval, secondval)

	selected = ""
	if not isNull(firstval) and not isNull(secondval) then
		if cstr(firstval) = cstr(secondval) then
			selected = " selected "
		end if
	end if

end function

function isDisabled(aBoolVal)
  if aBoolVal then
    isDisabled = " disabled "
  else
    isDisabled = ""
  end if
end function

function ischecked(firstval)
  if cstr(firstval) = "True" then
    ischecked = " checked "
  else
    ischecked = ""
  end if
end function

function ischecked2(firstval)
  if firstval then
    ischecked2 = " checked "
  else
    ischecked2 = ""
  end if
end function

function ischeckedY(aval)
  if lcase(aval) = "y"  then
    ischeckedY = " checked "
  else
    ischeckedY = ""
  end if
end function

function ischeckedN(aval)
  if lcase(aval) = "n"  or aval="" or isnull(aval) then
    ischeckedN = " checked "
  else
    ischeckedN = ""
  end if
end function

function requestOrSession(aval)
	if request(aval) <> "" then
		requestOrSession = request(aval)
	else
		requestOrSession = session(aval)
	end if
end function

function recordSetOrSession(aval, byref aRs)
	recordSetOrSession = ""
	if request(aval) <> "" then
		recordSetOrSession = request(aval)
	elseif not aRs.eof then
		on error resume next
			recordSetOrSession = aRs(aval)
		if err.number <> 0 then
			recordSetOrSession = ""
		end if
		on error goto 0
	end if
end function

sub replicateForm(byref aReq, byref aResp, excludeList)
	' store the previous form's values
	dim item, excitem, excludeItems, bExclude
	excludeItems = split(excludeList, ",")
	for each item in aReq.form
		bExclude = false
		for each excitem in excludeItems
			if excitem = item then bExclude = true
		next
		if not bExclude then
			aResp.write("<input type='hidden' name='" & item & "' value='" & aReq(item) & "' />")
		end if
	next
end sub

function serialiseFormParams(byref aReq, excludeList)
	serialiseFormParams = serialiseFormParams2(aReq, aResp, excludeList, false)
end function

function serialiseFormParams2(byref aReq, excludeList, noInitialAmp)

	dim item, excitem, excludeItems, bExclude, bFirst
	serialiseFormParams2 = ""
	excludeItems = split(excludeList, ",")
	bFirst = true
	for each item in aReq.form
		bExclude = false
		for each excitem in excludeItems
			if excitem = item then bExclude = true
		next
		if not bExclude then
			if not noInitialAmp or not bFirst then
				serialiseFormParams2 = serialiseFormParams2 & "&"
			end if
			serialiseFormParams2 = serialiseFormParams2 & item & "=" & server.URLEncode(aReq(item))
			bFirst = false
		end if
	next
end function

function formItem2Bool(byref aFormItem)

	formItem2Bool = false
	if trim(aFormItem) <> "" then
		formItem2Bool = true
	end if

end function

function formItem2Dbl(byref aFormItem)

	formItem2Dbl = 0.0
	if trim(aFormItem) <> "" then
		formItem2Dbl = cdbl(trim(aFormItem))
	end if

end function

function isOnline()
	if DOMAINNAME = "" then
		DOMAINNAME = getDomainData("DOMAINNAME")
	end if
	isOnline = (Request.ServerVariables("HTTP_HOST") = DOMAINNAME)
end function

function thisDir()

	dim thisScript, idx
	thisScript = Request.ServerVariables("SCRIPT_NAME")
	idx = instrrev(thisScript, "/")
	
	if idx > 0 then
		thisDir = left(thisScript, idx)
	else
		thisDir = thisScript
	end if

end function

function thisHostDir()

	thisHostDir = "http://" & Request.ServerVariables("HTTP_HOST") + thisDir()

end function

function toDbDate(byref aDate)

	toDbDate = "#" & month(aDate) & "/" & day(aDate) & "/" & year(aDate) & "#"

end function

function toUSADate(byref aDate)

	toUSADate = year(aDate) & "/" & month(aDate) & "/" & day(aDate)

end function

function toDisplayDate(byref aDate)

	toDisplayDate = day(aDate) & "/" & month(aDate) & "/" & year(aDate)

end function

function secureServerPrefix()
	if DOMAINNAME = "" then
		DOMAINNAME = getDomainData("DOMAINNAME")
	end if
	if isOnline() then
		secureServerPrefix = "https://" & DOMAINNAME & "/"
	else
		secureServerPrefix = ""
	end if
end function

function obfCCNumber(accnumber)
	obfCCNumber = "XXXX XXXX XXXX " &  RIGHT(accnumber, 4)
end function

function formatNum(num, n)

	dim i, diff, s
	formatNum = cstr(num)
	diff = n - len(formatNum)

	for i = 1 to diff
		s = s & "0"
	next

	formatNum = s & formatNum

end function

function getCurrSym()
	getCurrSym = "Â£"
end function

function fmtCurr(aVal, aIncSymbol)
	if aVal <> "" then
		fmtCurr = ""
		if aIncSymbol then 
			fmtCurr = getCurrSym()
		end if
		fmtCurr = fmtCurr & formatNumber(ccur(aVal), 2, -1, 0, 0)
	else
		fmtCurr = ""
	end if
end function

function fmtCurr2(aVal, aIncSymbol, aCurrency)
	if aVal <> "" then
		fmtCurr2 = ""
		if aIncSymbol then 
			fmtCurr2 = getCurrencySymbolForCurrency(aCurrency)
		end if
		fmtCurr2 = fmtCurr2 & formatNumber(ccur(aVal), 2, -1, 0, 0)
	else
		fmtCurr2 = ""
	end if
end function

function fmtCurrNonHtml(aVal, aIncSymbol, aCurrency)
	if aVal <> "" then
		fmtCurrNonHtml = ""
		if aIncSymbol then 
			fmtCurrNonHtml = getCurrencySymbolForCurrencyNonHtml(aCurrency)
		end if
		fmtCurrNonHtml = fmtCurrNonHtml & formatNumber(ccur(aVal), 2, -1, 0, 0)
	else
		fmtCurrNonHtml = ""
	end if
end function

function safeCCur(aVal)
	safeCCur = ccur(0.0)
	on error resume next
		if isNumeric(ccur(aVal)) then
			safeCCur = ccur(aVal)
		end if
	on error goto 0
end function

function safeCurAdd(aVal1, aVal2)
	safeCurAdd = safeCCur(aVal1) + safeCCur(aVal2)
end function


function replaceQuotes(byval astr)
	replaceQuotes = replace(astr, "'", "''")
end function

function getCurrencySymbolForCurrency(byref aCurr)
	getCurrencySymbolForCurrency = "&pound;"
	if aCurr = "EUR" then
		getCurrencySymbolForCurrency = "&#8364;"
	elseif aCurr = "USD" then
		getCurrencySymbolForCurrency = "&#36;"
	elseif aCurr = "CZK" then
		getCurrencySymbolForCurrency = "&#75;&#269;"
	end if
end function

function getCurrencySymbolForCurrencyNonHtml(byref aCurr)
	getCurrencySymbolForCurrencyNonHtml = "£"
	if aCurr = "EUR" then
		getCurrencySymbolForCurrencyNonHtml = "€"
	elseif aCurr = "USD" then
		getCurrencySymbolForCurrencyNonHtml = "$"
	elseif aCurr = "CZK" then
		getCurrencySymbolForCurrencyNonHtml = "Kč"
	end if
end function

function getCurrencyForLocation(byref aLocationId, byref acon)
	dim ai

	for ai = 1 to nCurrencies
		if theCurrencyLocations(ai) = aLocationId then
			getCurrencyForLocation = theCurrencies(ai)
			'response.write("cache")
			exit function
		end if
	next

	dim ars, aCurrency
	set ars = getMysqlQueryRecordSet("select currency from location where idlocation=" & aLocationId, acon)
	getCurrencyForLocation = "GBP"  ' default
	if not ars.eof then
		getCurrencyForLocation = ars("currency")
	end if
	ars.close
	set ars = nothing
	
	nCurrencies = nCurrencies + 1
	redim preserve theCurrencyLocations(nCurrencies)
	redim preserve theCurrencies(nCurrencies)
	
	theCurrencyLocations(nCurrencies) = aLocationId
	theCurrencies(nCurrencies) = getCurrencyForLocation
	'response.write("db")
end function

function getLcid(byref acon)
	dim ars
	if session("LCID") = "" then
		Set ars = getMysqlUpdateRecordSet("Select locale from region WHERE id_region=" & retrieveuserregion(), con)
		session("LCID") = ars("locale")
		call closeRs(ars)
	end if
	getLcid = session("LCID")
	getLcid = 2057
end function

function getEmailCharset(byref acon)
	dim ars
	if session("EmailCharset") = "" then
		Set ars = getMysqlUpdateRecordSet("Select charset from region WHERE id_region=" & retrieveuserregion(), con)
		session("EmailCharset") = ars("charset")
		call closeRs(ars)
	end if
	getEmailCharset = session("EmailCharset")
end function

function isTestSystem()
	dim aServerName
	aServerName = request.serverVariables("SERVER_NAME")
	'response.write("aServerName = " & aServerName)
	isTestSystem = (left(aServerName, 16) = "savoiradmintest.")
end function

function cleanToNumber(astr)
	if isnull(astr) or astr="" then
		cleanToNumber=0
		exit function
	end if
	dim ai, okChars
	okChars = "1234567890."
	cleanToNumber = ""
	astr = trim(astr)
	for ai = 1 to len(astr)
		if instr(1, okChars, mid(astr, ai, 1), 1) <> 0 then
			cleanToNumber = cleanToNumber & mid(astr, ai, 1)
		end if
	next
end function

function negToZero(aval)
	if aval < 0.0 then
		negToZero = 0.0
	else
		negToZero = aval
	end if
end function

function getBasicProductInfo(byref acon, byval apn)
	dim ars, adesc, aSql
	aSql="select * from purchase where purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(aSql, acon)
	adesc = ""
	while not ars.eof
		if ars("mattressrequired")="y" then adesc=adesc & ars("savoirmodel") & "<br>" 
		if ars("baserequired")="y" then adesc=adesc & ars("basesavoirmodel") & "<br>"
		if ars("topperrequired")="y" then adesc=adesc & ars("toppertype") & "<br>"
		if ars("legsrequired")="y" then adesc=adesc & ars("legstyle") & "<br>"
		if ars("headboardrequired")="y" then adesc=adesc & ars("headboardstyle") & "<br>"
		if ars("valancerequired")="y" then adesc=adesc & "Valance" & "<br>"
		if ars("accessoriesrequired")="y" then adesc=adesc & "Accessories" & "<br>"
		ars.movenext
	wend
	ars.close
	getBasicProductInfo = adesc
end function

function getExWorksDate(byref acon, byval apn)
	dim ars, ars2, aExworks, aSql
	aSql="select * from exportlinks E, exportcollshowrooms S where E.LinksCollectionid=S.exportcollshowroomsid and purchase_no=" & apn & " group by exportcollectionid"
	set ars = getMysqlQueryRecordSet(aSql, acon)
	if not ars.eof then
	aExworks = ""
	while not ars.eof
		set ars2 = getMysqlQueryRecordSet("Select * from ExportCollections where exportcollectionsid=" & ars("exportcollectionid"), acon)
		
		aExworks=aExworks & ars2("collectiondate") & "<br>"
		ars2.close
		ars.movenext
	wend
	end if
	ars.close
	getExWorksDate = aExworks
end function

function getComTotal(byref acon, byval apn)
	dim ars, aComTotal, aSql
	aSql="select sum(amount) as n from payment where inccom='y' AND purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(aSql, acon)
	aComTotal = ""
	if not ars.eof then
	aComTotal = ars("n")
	end if
	ars.close
	getComTotal = aComTotal
end function

function utf8toLatin1(ByVal lStr)
	Dim lT, lI, lA
	For lI = 1 To Len(lStr)
		lA = Asc(Mid(lStr, lI, 1))
		If lA <= 127 Then
			lT = lT & Chr(lA)
		ElseIf lA >= 194 And lA <= 223 And lI < Len(lStr) Then
			lI = lI + 1
			lT = lT & Chr((lA And 31)*64 + (Asc(Mid(lStr, lI, 1)) And 63))
		End If
	Next
	utf8toLatin1 = lT
End Function

Function Utf8ToUnicode(strText)
   if isnull(strText) or strText = "" then
   	Utf8ToUnicode = ""
   	exit function
   end if
   With CreateObject("ADODB.Stream")

      .Open
      .Charset = "Windows-1252"

      .WriteText strText

      .Position = 0
      .Type = 2 ' adTypeText
      .Charset = "utf-8"

      Utf8ToUnicode = .ReadText(-1) 'adReadAll

      .Close
   End With
End Function

function trace(amsg)
	'response.write(amsg)
end function

function capitaliseName(aname)
	dim awords, aword, atmp, apos
	if isNull(aname) or trim(aname)="" then
		capitaliseName = ""
		exit function
	end if

	awords = split(trim(aname), " ")
	for each aword in awords
		aword = mylcase(aword)
		if len(aword)<2 then
			aword = myucase(aword)
		else
			aword = myucase(left(aword,1)) & (right(aword,len(aword)-1))
		end if
		
		' Mc
		if len(aword)>2 and left(aword, 2) = "Mc" then
			atmp = left(aword,2) & myucase(mid(aword, 3, 1))
			if len(aword)>3 then
				atmp = atmp & right(aword,len(aword)-3)
			end if
			aword = atmp
		end if

		' Mac
		if len(aword)>3 and left(aword, 3) = "Mac" then
			atmp = left(aword,3) & myucase(mid(aword, 4, 1))
			if len(aword)>4 then
				atmp = atmp & right(aword,len(aword)-4)
			end if
			aword = atmp
		end if

		' names with apostropies
		apos = instr(aword, "'")
		if apos > 0  and apos < len(aword) then
			aword = left(aword, apos-1) & "'" & myucase(mid(aword, apos+1, 1)) & right(aword,len(aword)-apos-1)
		end if

		capitaliseName = capitaliseName & aword & " "
	next
	capitaliseName = left(capitaliseName, len(capitaliseName)-1)

end function

function mylcase(aword)
	dim an, ascval
	mylcase = ""
	
	if isNull(aword) or trim(aword)="" then
		exit function
	end if
	
	aword = trim(aword)
	
	for an = 1 to len(aword)
		ascval = asc(mid(aword, an, 1))
		if ascval > 64 and ascval < 123 then
			mylcase = mylcase & lcase(mid(aword, an, 1))
		else
			mylcase = mylcase & mid(aword, an, 1)
		end if
	next
end function

function myucase(aword)
	dim an, ascval
	myucase = ""
	
	if isNull(aword) or trim(aword)="" then
		exit function
	end if
	
	aword = trim(aword)
	
	for an = 1 to len(aword)
		ascval = asc(mid(aword, an, 1))
		if ascval > 64 and ascval < 123 then
			myucase = myucase & ucase(mid(aword, an, 1))
		else
			myucase = myucase & mid(aword, an, 1)
		end if
	next
end function

function areEqual(ax, ay)
	areEqual = false
	if isnull(ax) or isempty(ax) then ax = ""
	if isnull(ay) or isempty(ay) then ay = ""
	areEqual = (ax = ay)
end function

function areNotEqual(ax, ay)
	areNotEqual = not areEqual(ax, ay)
end function

function cleanHtmlCode(aval)
	cleanHtmlCode = ""
	if isnull(aval) or aval = "" then
		exit function
	end if
	cleanHtmlCode = replace(aval, "<br>", " ")
	cleanHtmlCode = replace(cleanHtmlCode, "<br />", " ")
	cleanHtmlCode = replace(cleanHtmlCode, "&nbsp;", " ")
	cleanHtmlCode = replace(cleanHtmlCode, "&pound;", "£")
	cleanHtmlCode = replace(cleanHtmlCode, "&#36;", "$")
	cleanHtmlCode = replace(cleanHtmlCode, "&#8364;", "€")
end function

sub arraypop(byref aArray)
	dim an
	For an=1 To UBound(aArray)-1
	    aArray(an) = aArray(an + 1)
	Next
	ReDim Preserve aArray(UBound(aArray) - 1)
end sub

sub dumparray(byref aArray)
	dim an
	For an=1 To UBound(aArray)
	    response.write("<br>" & an & " = " & aArray(an))
	Next
end sub

function cleanForCSV(astr)
	dim ai, okChars
	okChars = " 1234567890.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!£$%^&*()_+=-{}[]:;@'~#?/>.<,|\"

	if isnull(astr) or astr = "" then
		cleanForCSV = astr
		exit function
	end if
	astr = replace(trim(astr), """", "'")

	cleanForCSV = ""
	for ai = 1 to len(astr)
		if instr(1, okChars, mid(astr, ai, 1), 1) <> 0 then
			cleanForCSV = cleanForCSV & mid(astr, ai, 1)
		end if
	next
end function
%>
