<%

sub getComponentSizes(byref acon, acompid, apurchaseno, byref aComp1width, byref aComp1length)
dim ars, componentwidth, componentlength, asql
if acompid=1 then
componentwidth="mattresswidth"
componentlength="mattresslength"
end if
if acompid=3 then
componentwidth="basewidth"
componentlength="baselength"
end if
if acompid=5 then
componentwidth="topperwidth"
componentlength="topperlength"
end if
if acompid=6 then
componentwidth="valancewidth"
componentlength="valancelength"
end if
if acompid=7 then
componentwidth="legheight"
componentlength="legfinish"
end if

'if acompid=8 then componentwidth="headboardwidth"
asql="select " & componentwidth & " as w, " & componentlength  & " as l from purchase where purchase_no=" & apurchaseno & ""
set ars = getMysqlQueryRecordSet(asql, aCon)
if not ars.eof then
if acompid=1 and (left(ars("w"),4))<>"Spec" and ars("w")<>"TBC" and ars("w")<>"n" and Not isNull(ars("w")) then aComp1width=left(ars("w"), len(ars("w"))-2)
if acompid=1 and (left(ars("l"),4))<>"Spec" and ars("l")<>"TBC" and ars("l")<>"n" and Not isNull(ars("l")) then aComp1length=left(ars("l"), len(ars("l"))-2)

if acompid=3 and (left(ars("w"),4))<>"Spec" and ars("w")<>"TBC" and ars("w")<>"n" and Not isNull(ars("w")) then aComp1width=left(ars("w"), len(ars("w"))-2)
if acompid=3 and (left(ars("l"),4))<>"Spec" and ars("l")<>"TBC" and ars("l")<>"n" and Not isNull(ars("l")) then aComp1length=left(ars("l"), len(ars("l"))-2)

if acompid=5 and (left(ars("w"),4))<>"Spec" and ars("w")<>"TBC" and ars("w")<>"n" and Not isNull(ars("w")) then aComp1width=left(ars("w"), len(ars("w"))-2)
if acompid=5 and (left(ars("l"),4))<>"Spec" and ars("l")<>"TBC" and ars("l")<>"n" and Not isNull(ars("l")) then aComp1length=left(ars("l"), len(ars("l"))-2)

if acompid=7 and (left(ars("w"),4))<>"Spec" and ars("w")<>"TBC" and ars("w")<>"n" and Not isNull(ars("w")) then aComp1width=left(ars("w"), len(ars("w"))-2)
end if
ars.close
set ars = nothing
end sub

sub getComponentWidthSpecialSizes(byref acon, acompid, apurchaseno, byref aCompwidth)
dim ars, componentwidth, asql
if acompid=1 then
componentwidth="matt1width"
end if
if acompid=3 then
componentwidth="base1width"
end if
if acompid=5 then
componentwidth="topper1width"
end if
if acompid=7 then
componentwidth="legheight"
end if
asql="select " & componentwidth & " as w from productionsizes where purchase_no=" & apurchaseno & ""
set ars = getMysqlQueryRecordSet(asql, aCon)
if not ars.eof then
if acompid=1 and Not isNull(ars("w")) then aCompwidth=ars("w")
if acompid=3 and Not isNull(ars("w")) then aCompwidth=ars("w")
if acompid=5 and Not isNull(ars("w")) then aCompwidth=ars("w")
if acompid=6 and Not isNull(ars("w")) then aCompwidth=ars("w")
if acompid=7 and Not isNull(ars("w")) then aCompwidth=ars("w")
end if
ars.close
set ars = nothing
end sub

sub getComponentLengthSpecialSizes(byref acon, acompid, apurchaseno, byref aComplength)
dim ars, componentlength, asql
if acompid=1 then
componentlength="matt1length"
end if
if acompid=3 then
componentlength="base1length"
end if
if acompid=5 then
componentlength="topper1length"
end if
asql="select " & componentlength & " as w from productionsizes where purchase_no=" & apurchaseno & ""

set ars = getMysqlQueryRecordSet(asql, aCon)
if not ars.eof then
if acompid=1 and Not isNull(ars("w")) then aComplength=ars("w")
if acompid=3 and Not isNull(ars("w")) then aComplength=ars("w")
if acompid=5 and Not isNull(ars("w")) then aComplength=ars("w")
if acompid=6 and Not isNull(ars("w")) then aComplength=ars("w")
end if
ars.close
set ars = nothing
end sub

sub getComponent1WidthSpecialSizes(byref acon, acompid, apurchaseno, byref aCompwidth1, byref aCompwidth2)
dim ars, componentwidth1, componentwidth2, asql
if acompid=1 then
componentwidth1="matt1width"
componentwidth2="matt2width"
end if
if acompid=3 then
componentwidth1="base1width"
componentwidth2="base2width"
end if
asql="select " & componentwidth1 & " as w,  " & componentwidth2 & " as x from productionsizes where purchase_no=" & apurchaseno & ""
'response.Write(asql)
 set ars = getMysqlQueryRecordSet(asql, aCon)
 if not ars.eof then
  	if acompid=1 and Not isNull(ars("w")) then 
  		aCompwidth1=ars("w")
		aCompwidth2=ars("x") 
	end if
 	 if acompid=3 and Not isNull(ars("w")) then 
  		aCompwidth1=ars("w")
		aCompwidth2=ars("x") 
	end if
 end if
 ars.close
 set ars = nothing
end sub

sub getComponent1LengthSpecialSizes(byref acon, acompid, apurchaseno, byref aComplength1, byref aComplength2)
 dim ars, componentlength, componentlength1, componentlength2, asql
 if acompid=1 then 
 	componentlength1="matt1length"
	componentlength2="matt2length"
 end if
 if acompid=3 then 
 	componentlength1="base1length"
	componentlength2="base2length"
end if
asql="select " & componentlength1 & " as w,  " & componentlength2 & " as x from productionsizes where purchase_no=" & apurchaseno & ""
'response.Write(asql)
 set ars = getMysqlQueryRecordSet(asql, aCon)
 if not ars.eof then
	  if acompid=1 then 
			aComplength1=ars("w")
			aComplength2=ars("x") 
	 end if
	  if acompid=3 then 
			aComplength1=ars("w") 
			aComplength2=ars("x") 
	 end if
 end if
 ars.close
 set ars = nothing
end sub

function getHbWidth(byref acon, byval apn)
	dim asql, bsql, ars, ars2, hbwidth
	asql = "Select * from purchase WHERE purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	hbwidth=0
	if not ars.eof then
		if ars("headboardWidth")<>"" and ars("headboardWidth")<>"n" then 
			hbwidth=ars("headboardWidth")
		else
				if ars("basewidth")<>"" and  ars("basewidth")<>"n" and  left(ars("basewidth"),4)<>"Spec" then hbwidth=left(ars("basewidth"),len(ars("basewidth"))-2)
				if ars("mattresswidth")<>"" and ars("mattresswidth")<>"n" and left(ars("mattresswidth"),4)<>"Spec" then hbwidth=left(ars("mattresswidth"),len(ars("mattresswidth"))-2)
				if left(ars("basewidth"),4)="Spec" then
					bsql="Select * from ProductionSizes WHERE purchase_no=" & apn
					set ars2 = getMysqlQueryRecordSet(bsql, acon)
					if not ars2.eof then
						If ars2("Base1Width")<>"" then hbwidth=ars2("Base1Width")
						If ars2("Base2Width")<>"" then hbwidth=CDbl(hbwidth) + CDbl(ars2("Base2Width"))
					end if
					ars2.close
					set ars2=nothing
				end if
				if left(ars("mattresswidth"),4)="Spec" then
					bsql="Select * from ProductionSizes WHERE purchase_no=" & apn
					set ars2 = getMysqlQueryRecordSet(bsql, acon)
					if not ars2.eof then
						If ars2("Matt1Width")<>"" then hbwidth=ars2("Matt1Width")
						If ars2("Matt2Width")<>"" then hbwidth=CDbl(hbwidth) + CDbl(ars2("Matt2Width"))
					end if
					ars2.close
					set ars2=nothing
				end if
			end if
		getHbWidth = ""
		getHbWidth = hbwidth
		end if
	call closers(ars)	
	
end function

function getHbHeight(byref acon, byval apn)
	dim asql, bsql, ars, ars2, hbheight, floor
	asql = "Select * from purchase WHERE purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	hbheight=0
	if not ars.eof then
		if ars("headboardheight")<>"" then 
			floor=(InStr(ars("headboardheight"),"loor"))
			if floor>0 then
				hbheight=cleantonumber(ars("headboardheight"))
			else
				hbheight=cleantonumber(ars("headboardheight"))
				if hbheight="" then hbheight=0
				if ars("topperrequired")="y" then 
					bsql = "Select * from componentdata WHERE componentid=5 and  componentname like '" & ars("toppertype") & "'"
					set ars2 = getMysqlQueryRecordSet(bsql, acon)
					if not ars2.eof then
						hbheight=CDbl(hbheight) + CDbl(ars2("depth"))
					end if
					ars2.close
					set ars2=nothing
				end if
				if ars("mattressrequired")="y" then 
					bsql = "Select * from componentdata WHERE componentid=1 and  componentname like '" & ars("savoirmodel") & "'"
					set ars2 = getMysqlQueryRecordSet(bsql, acon)
					if not ars2.eof then
						hbheight=CDbl(hbheight) + CDbl(ars2("depth"))
					end if
				end if
				if ars("baserequired")="y" then 
					bsql = "Select * from componentdata WHERE componentid=3 and componentname = '" & ars("basesavoirmodel") & "'"
					set ars2 = getMysqlQueryRecordSet(bsql, acon)
					if not ars2.eof then
						hbheight=CDbl(hbheight) + CDbl(ars2("depth"))
					end if
					ars2.close
					set ars2=nothing
				end if
			end if
		else
			hbheight=0
		end if
	getHbHeight = ""
	getHbHeight = hbheight
	end if
	call closers(ars)
end function

function getHbDepth(byref acon, byval ahbstyle)
	dim asql, ars, hbdepth
	hbdepth=0
	asql = "Select * from componentdata WHERE componentname like '" & ahbstyle & "'"
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		hbdepth=ars("depth")
	end if
	getHbDepth = ""
	getHbDepth = hbdepth
	call closers(ars)	
end function

function getComponentDepth(byref acon, byval ahbstyle, byval aCompId)
dim asql, ars, compdepth
compdepth=0
asql = "Select * from componentdata WHERE componentid=" & aCompId & " and componentname like '" & ahbstyle & "'"
set ars = getMysqlQueryRecordSet(asql, acon)
if not ars.eof then
compdepth=ars("depth")
end if
getComponentDepth = ""
getComponentDepth = compdepth
call closers(ars)
end function

function getShippingComponentDepth(byref acon, byval compstyle)
dim asql, ars, compdepth
compdepth=0
asql = "Select * from shippingbox WHERE sName like '" & compstyle & "%'"
'response.Write("sql=" & asql)
set ars = getMysqlQueryRecordSet(asql, acon)
if not ars.eof then
compdepth=ars("allowance")
end if
getShippingComponentDepth = ""
getShippingComponentDepth = compdepth
call closers(ars)
end function

function checkMatt1Box(byref acon, byval am1width, byval am1length)
dim asql, ars, boxsize
boxsize=""

asql = "Select * from shippingbox where sName = 'Large'"
set ars = getMysqlQueryRecordSet(asql, acon)
if (am1width >= CDbl(ars("width"))) or (am1length >= CDbl(ars("length"))) then
boxsize="Large"
end if
if (am1width < CDbl(ars("width"))) and (am1length < CDbl(ars("length"))) then
boxsize="Large"
end if
call closers(ars)
asql = "Select * from shippingbox where sName = 'Medium'"
set ars = getMysqlQueryRecordSet(asql, acon)
if ((am1width < CDbl(ars("width"))-CDbl(ars("packallowancewidth"))) and (am1length < CDbl(ars("length"))-CDbl(ars("packallowancelength")))) or ((am1width < CDbl(ars("length"))-CDbl(ars("packallowancelength"))) and (am1length < CDbl(ars("width"))-CDbl(ars("packallowancewidth")))) then
boxsize="Medium"
end if
call closers(ars)
asql = "Select * from shippingbox where sName = 'Small'"
set ars = getMysqlQueryRecordSet(asql, acon)
if ((am1width < CDbl(ars("width"))-CDbl(ars("packallowancewidth"))) and (am1length < CDbl(ars("length"))-CDbl(ars("packallowancelength")))) or ((am1width < CDbl(ars("length"))-CDbl(ars("packallowancelength"))) and (am1length < CDbl(ars("width"))-CDbl(ars("packallowancewidth")))) then
boxsize="Small"
end if
call closers(ars)
checkMatt1Box=boxsize
end function

function checkMattKg(byref acon, byval aCompId, byval aPartName, byval aboxsize, byval am1width, byval am1length)
	dim asql, ars, aWeight, aBoxWeight
	asql = "Select * from componentdata where componentid = " & aCompId & " and componentname like '" & aPartName & "'"
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		aWeight=CDbl(ars("WEIGHT"))
		'response.write("<br>aWeight=" & aWeight)
		if aCompId<>7 then
		if Right(am1width,2)="cm" then am1width=left(am1width,len(am1width)-2)
		if am1width <>"" then aWeight=aWeight * CDbl(am1width)
		if am1length <> "" then aWeight=aWeight * CDbl(am1length)
		end if
	end if
	if aCompId=7 then
	
		aWeight=am1width*27*aWeight/1000
		
	end if
	if am1width=0 and aCompId=8 then aWeight=30
	'response.write("<br>am1width=" & am1width & "<br>")
	aWeight=formatNumber(aWeight,2)
	'response.Write("mattwt=" & aWeight)
	'response.End()
	
	call closers(ars)
	asql = "Select * from shippingbox where sname = '" & aboxsize & "'"
	'response.Write("sql=" & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		aBoxWeight=CDbl(ars("WEIGHT"))
		aWeight=aWeight+aBoxWeight
	end if
	'response.Write("aBoxWeight=" & aBoxWeight)
	'response.End()
	call closers(ars)
	checkMattKg=aWeight
end function

function getBoxWeight(byref acon, byval aboxname)
	dim asql, ars, aWeight
	if aboxname="Leg Box" then aboxname="LegBox"
	if aboxname="Double Leg Box" then aboxname="DoubleLegBox"
	asql = "Select * from shippingbox where sname = '" & aboxname & "'"
	'response.write("sql=" & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
	aWeight = 0.0
	if not ars.eof then
		aWeight=CDbl(ars("WEIGHT"))
	end if
	
	call closers(ars)
	getBoxWeight=aWeight
end function

function checkCompWeight(byref acon, byval aCompId, byval aPartName, byval am1width, byval am1length)
	dim asql, ars, aWeight
	asql = "Select * from componentdata where componentid = " & aCompId & " and componentname like '" & aPartName & "'"
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		aWeight=CDbl(ars("WEIGHT"))
		if am1width <>"" then aWeight=aWeight * CDbl(am1width)
		if am1length <> "" then aWeight=aWeight * CDbl(am1length)
		if aCompId=8 then
			if am1width<>"" then
				aWeight=CDbl(ars("WEIGHT"))
				aWeight=aWeight * CDbl(am1width)
			else
				aWeight=CDbl(ars("WEIGHT"))
				aWeight=aWeight * 0
			end if
		end if
	end if
	call closers(ars)
	checkCompWeight=aWeight
end function

function getLegWeight(byref acon)
dim asql, ars, aLegWeight
asql = "Select * from componentdata where componentid=7"
set ars = getMysqlQueryRecordSet(asql, acon)
if not ars.eof then
aLegWeight=CDbl(ars("weight"))
else
aLegWeight=0
end if
call closers(ars)
getLegWeight=aLegWeight
end function

function getComponentDimensionsBoxSize(byref acon, byval aBoxSize, byval aCompName, byval aCompID)
dim asql, ars, boxdims, aCompDepth, aBoxDepth
asql = "Select * from shippingbox where sName='" & aBoxSize & "'"
set ars = getMysqlQueryRecordSet(asql, acon)
if not ars.eof then
if aBoxSize="LegBox" or aBoxSize="DoubleLegBox" then
boxdims=ars("width") & "x" & ars("height")
else
boxdims=ars("width") & "x" & ars("length")
end if
aBoxDepth=ars("depth")
end if

call closers(ars)

asql = "Select * from componentdata where componentname='" & aCompName & "' and componentid=" & aCompID
'response.Write("sql=" & asql)
if aCompID=6 or aCompID=7 then
boxdims=boxdims & "x" & aBoxDepth & "cm"
else
set ars = getMysqlQueryRecordSet(asql, acon)
if not ars.eof then
'aCompDepth=CDbl(ars("depth"))+2
if CDbl(aCompDepth) > CDbl(aBoxDepth) then
boxdims=boxdims & "x" & aCompDepth & "cm"
else
boxdims=boxdims & "x" & aBoxDepth & "cm"
end if
end if
call closers(ars)
end if
getComponentDimensionsBoxSize=boxdims
end function

function getCrateSize(byref acon, byval aCompID, byval aPn)
dim asql, ars, aDims
asql = "Select * from packagingdata where componentid=" & aCompid & " and purchase_no=" & aPn

set ars = getMysqlQueryRecordSet(asql, acon)
if not ars.eof then
aDims=ars("packwidth") & "x" & ars("packheight") & "x" & ars("packdepth")
else
aDims="-"
end if
call closers(ars)
getCrateSize=aDims
end function

function getBoxSize(byref acon, byval aCompID, byval aPn, byval aQty)
dim asql, ars, aBoxSize, boxdims
asql = "Select * from packagingdata where CompPartNo=" & aQty & " and componentid=" & aCompid & " and purchase_no=" & aPn

set ars = getMysqlQueryRecordSet(asql, acon)
if not ars.eof then
aBoxSize=ars("boxsize")
end if
call closers(ars)
if aBoxSize<>"" then
asql = "Select * from shippingbox where sName='" & aBoxSize & "'"
set ars = getMysqlQueryRecordSet(asql, acon)
if not ars.eof then
if aCompID=7 then
boxdims=ars("width") & "x" & ars("height") & "x" & ars("depth")
else
boxdims=ars("width") & "x" & ars("length") & "x" & ars("depth")
end if
end if
call closers(ars)
end if
getBoxSize=boxdims
end function

function getBoxName(byref acon, byval aCompID, byval aPn, byval aQty)
dim asql, ars, aBoxName
asql = "Select * from packagingdata where CompPartNo=" & aQty & " and componentid=" & aCompid & " and purchase_no=" & aPn
set ars = getMysqlQueryRecordSet(asql, acon)
if not ars.eof then
aBoxName=ars("boxsize")
end if
call closers(ars)
getBoxName=aBoxName
end function

function getCrateSizeVol(byref acon, byval aCompID, byval aPn)
dim asql, ars, aVol
asql = "Select * from packagingdata where componentid=" & aCompid & " and purchase_no=" & aPn

set ars = getMysqlQueryRecordSet(asql, acon)
if not ars.eof then
if ars("packwidth")<>"" and ars("packheight")<>"" and ars("packdepth")<>"" then
aVol=(CDbl(ars("packwidth")) * CDbl(ars("packheight")) * CDbl(ars("packdepth")))/1000000
end if
else
aVol=0
end if
call closers(ars)
getCrateSizeVol=aVol
end function

function getBoxSizeVol(byref acon, byval aBoxSize)
dim asql, ars, aVol
asql = "Select * from shippingbox where sName='" & aBoxSize & "'"
set ars = getMysqlQueryRecordSet(asql, acon)
if not ars.eof then
if ars("width")<>"" and ars("depth")<>"" and ars("length")<>"" then
aVol=(CDbl(ars("width")) * CDbl(ars("depth")) * CDbl(ars("length")))/1000000
end if
else
aVol=0
end if
call closers(ars)
getBoxSizeVol=aVol
end function

function getCrateWeight(byref acon, byval aCompID, byval aPn, byval aQty)
dim asql, ars, aWeight
asql = "Select * from packagingdata where CompPartNo=" & aQty & " and componentid=" & aCompid & " and purchase_no=" & aPn
set ars = getMysqlQueryRecordSet(asql, acon)
if not ars.eof then
aWeight=ars("packkg")
if isNull(ars("packkg")) then aWeight=0 else aWeight=ars("packkg")
else
aWeight=0
end if
call closers(ars)
getCrateWeight=aWeight
end function



function getComponentPriceExVatAfterDiscount(byref acon, aPn, aCompId)
	dim asql, ars, aPurchaseRs, aBasicPrice, aComponentPrice, aPriceFieldName, aDiscount, aDiscountType, aBedsetTotal, aCompDiscount, aVatRate, aIsTrade
	set aPurchaseRs = getMysqlQueryRecordSet("select * from purchase where purchase_no=" & aPn, acon)
	set ars = getMysqlQueryRecordSet("select PRICE_FIELD_NAME from component where componentid=" & aCompId, acon)
    if not ars.eof then
    	aPriceFieldName = ars("PRICE_FIELD_NAME")
        aBasicPrice = safeCur(aPurchaseRs(aPriceFieldName))
        aComponentPrice = aBasicPrice
		if aCompid=3 then
		
		if aPurchaseRs("upholsteryprice")<>"" and aPurchaseRs("upholsteryprice")<>"0" and NOT isNull(aPurchaseRs("upholsteryprice")) then aComponentPrice=aComponentPrice+CDbl(aPurchaseRs("upholsteryprice"))
		if aPurchaseRs("basefabricprice")<>"" and aPurchaseRs("basefabricprice")<>"0" and NOT isNull(aPurchaseRs("basefabricprice")) then aComponentPrice=aComponentPrice+CDbl(aPurchaseRs("basefabricprice"))
		if aPurchaseRs("basetrimprice")<>"" and aPurchaseRs("basetrimprice")<>"0" and NOT isNull(aPurchaseRs("basetrimprice")) then aComponentPrice=aComponentPrice+CDbl(aPurchaseRs("basetrimprice"))						
		if aPurchaseRs("basedrawersprice")<>"" and aPurchaseRs("basedrawersprice")<>"0" and NOT isNull(aPurchaseRs("basedrawersprice")) then aComponentPrice=aComponentPrice+CDbl(aPurchaseRs("basedrawersprice"))								
		end if
		if aCompid=6 then
		if aPurchaseRs("valfabricprice")<>"" and aPurchaseRs("valfabricprice")<>"0" and NOT isNull(aPurchaseRs("valfabricprice")) then aComponentPrice=aComponentPrice+CDbl(aPurchaseRs("valfabricprice"))
		end if
		if aCompid=7 then
		if aPurchaseRs("addlegprice")<>"" then aComponentPrice=aComponentPrice+CDbl(aPurchaseRs("addlegprice"))
		end if
		if aCompid=8 then
		if aPurchaseRs("hbfabricprice")<>"" and NOT isNull(aPurchaseRs("hbfabricprice")) then aComponentPrice=aComponentPrice+CDbl(aPurchaseRs("hbfabricprice"))
		if aPurchaseRs("headboardtrimprice")<>"" and NOT isNull(aPurchaseRs("headboardtrimprice")) then aComponentPrice=aComponentPrice+CDbl(aPurchaseRs("headboardtrimprice"))
		end if
    	'response.write("<br>aPriceFieldName=" & aPriceFieldName)
    	'response.write("<br>basic price: aComponentPrice=" & aComponentPrice)
        
        aDiscount = safeDbl(aPurchaseRs("discount"))
    	'response.write("<br>aDiscount=" & aDiscount)
        if aDiscount > 0.0 then
        	' there is a discount
        	aDiscountType = aPurchaseRs("discounttype")
	    	'response.write("<br>aDiscountType=" & aDiscountType)
        	if aDiscountType = "percent" then
        		' discount type is % so deduct that % from the comp price
        		aComponentPrice = aComponentPrice * (1.0 - (aDiscount/100.0))
		    	'response.write("<br>after % discount deduction: aComponentPrice=" & aComponentPrice)
        	elseif aDiscountType = "currency" then
        		' discount type is an amount, so deduct component's share of that from the comp price
	        	aBedsetTotal = safeDbl(aPurchaseRs("bedsettotal"))
	        	aCompDiscount = aComponentPrice / aBedsetTotal * aDiscount
	        	aComponentPrice = aComponentPrice - aCompDiscount
		    	'response.write("<br>aBedsetTotal=" & aBedsetTotal)
		    	'response.write("<br>aCompDiscount=" & aCompDiscount)
		    	'response.write("<br>after amount discount deduction: aComponentPrice=" & aComponentPrice)
        	end if
        else
        	' no discount
        end if
        
        ' deduct the VAT
        aIsTrade = (aPurchaseRs("isTrade") = "y")
        aVatRate = safeDbl(aPurchaseRs("vatrate"))
    	'response.write("<br>aIsTrade=" & aIsTrade)
    	'response.write("<br>aVatRate=" & aVatRate)
        if not aIsTrade and aVatRate > 0.0 then
        	aComponentPrice = aComponentPrice / (1.0 + aVatRate/100.0)
        end if
    	'response.write("<br>after VAT deduction aComponentPrice=" & aComponentPrice)
        
        ' now round it
        aComponentPrice = round(aComponentPrice, 2)
    	'response.write("<br>after rounding aComponentPrice=" & aComponentPrice)
    else
    	' we don't have a price field on PURCHASE for this component
        aComponentPrice = 0.0
    end if
    call closers(ars)
    call closers(aPurchaseRs)
    getComponentPriceExVatAfterDiscount = aComponentPrice
end function

function getComponentWholesalePrice(byref acon, byval aCompID, byval aPn)
dim asql, ars
getComponentWholesalePrice=0
asql = "Select * from wholesale_prices WHERE componentID=" & aCompID & " and purchase_no='" & aPn & "'"
set ars = getMysqlQueryRecordSet(asql, acon)
if not ars.eof then
getComponentWholesalePrice=Cdbl(ars("price"))
end if
call closers(ars)
end function

function getComponentWholesalePrice2(byref acon, aPn, aCompId)
	dim asql, ars, aBasicPrice, aComponentPrice, aPriceFieldName
	asql="select * from wholesale_prices where componentid=" & aCompId & " and purchase_no=" & aPn
	set ars = getMysqlQueryRecordSet(asql, acon)
    if not ars.eof then
    	aComponentPrice = safeCur(ars("price"))
    else
        aComponentPrice = 0.0
    end if
	if aCompId=3 then 
	
	aComponentPrice=aComponentPrice+getComponentExtrasWholesalePrice(con, aPn, 11)
	aComponentPrice=aComponentPrice+getComponentExtrasWholesalePrice(con, aPn, 12)
	aComponentPrice=aComponentPrice+getComponentExtrasWholesalePrice(con, aPn, 13)
	aComponentPrice=aComponentPrice+getComponentExtrasWholesalePrice(con, aPn, 14)
	aComponentPrice=aComponentPrice+getComponentExtrasWholesalePrice(con, aPn, 17)
	end if
	if aCompId=6 then 
	aComponentPrice=aComponentPrice+getComponentExtrasWholesalePrice(con, aPn, 18)
	end if
	if aCompId=7 then 
	aComponentPrice=aComponentPrice+getComponentExtrasWholesalePrice(con, aPn, 16)
	end if
	if aCompId=8 then 
	aComponentPrice=aComponentPrice+getComponentExtrasWholesalePrice(con, aPn, 10)
	aComponentPrice=aComponentPrice+getComponentExtrasWholesalePrice(con, aPn, 15)
	end if

    call closers(ars)
    getComponentWholesalePrice2 = aComponentPrice
end function

function getComponentExtrasWholesalePrice(byref acon, aPn, aCompId)
	dim asql, ars, aBasicPrice, aComponentPrice, aPriceFieldName
	asql="select * from wholesale_prices where componentid=" & aCompId & " and purchase_no=" & aPn
	set ars = getMysqlQueryRecordSet(asql, acon)
    if not ars.eof then
    	aComponentPrice = safeCur(ars("price"))
    else
        aComponentPrice = 0.0
    end if
    call closers(ars)
    getComponentExtrasWholesalePrice = aComponentPrice
end function

function getCompPartNo(byref acon, aPn, aCompId)
	dim asql, ars, aBasicPrice, aComponentPrice, aPriceFieldName
	asql="select * from packagingdata where componentid=" & aCompId & " and purchase_no=" & aPn
	set ars = getMysqlQueryRecordSet(asql, acon)
    if not ars.eof then
    	getCompPartNo = ars("PackedWith")
    else
        getCompPartNo = ""
    end if
    call closers(ars)
    getCompPartNo = getCompPartNo
end function

function getAccWholesale(byref acon, aPn, aAccId)
	dim asql, ars, aBasicPrice, aComponentPrice, aPriceFieldName
	asql="SELECT * FROM orderaccessory WHERE orderaccessory_id=" & aAccId & " and purchase_no=" & aPn
	response.Write("sql=" & asql)
	'response.end()
	set ars = getMysqlQueryRecordSet(asql, acon)
    if not ars.eof then
    	getAccWholesale = CDbl(ars("WholesalePrice")) * CDbl(ars("qty"))
    else
        getAccWholesale = 0
    end if
    call closers(ars)
end function
	
function getAccWholesaleTotal(byref acon, aPn)
	dim asql, ars, aBasicPrice, aComponentPrice, aPriceFieldName
	asql="SELECT * FROM orderaccessory WHERE purchase_no=" & aPn
	'response.Write("sql=" & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
    if not ars.eof then
		do until ars.eof
			getAccWholesaleTotal = getAccWholesaleTotal+(CDbl(ars("WholesalePrice")) * CDbl(ars("qty")))
		ars.movenext
		loop
    else
        getAccWholesaleTotal = 0
    end if
    call closers(ars)
end function

sub getAccWholesaleUnit(byref acon, aPn, aAccId, aOrderCurrency, byref aAccWholesale, byref aAccWholesaleUnit,  byref aAccWholesaleTotal)
	dim asql, ars, aBasicPrice, aComponentPrice, aPriceFieldName, an
	' need to get the right orderaccessory, plus any others packed with it
	asql = "Select * from orderaccessory where purchase_no=" & aPn & " and orderaccessory_id=" & aAccId & " union"
	asql = asql & " select oa.* FROM packagingdata pd join orderaccessory oa on pd.comppartno=oa.orderaccessory_id where pd.componentid=9 and pd.packedwith='9-" & aAccId & "' and oa.purchase_no=" & aPn
	'response.Write("sql=" & asql)
	'response.end()
	set ars = getMysqlQueryRecordSet(asql, acon)
    aAccWholesale = "0.00"
    aAccWholesaleUnit = "0.00"
	aAccWholesaleTotal=0
    an = 0
    while not ars.eof
    	an = an + 1
    	if an = 1 then
    		aAccWholesale = ""
    		aAccWholesaleUnit = ""
    	else
    		aAccWholesale = aAccWholesale & "<br/>" & getCurrencySymbolForCurrency(aOrderCurrency)
    		aAccWholesaleUnit = aAccWholesaleUnit & "<br/>" & getCurrencySymbolForCurrency(aOrderCurrency)
    	end if
    	aAccWholesale = aAccWholesale & formatnumber(CDbl(ars("WholesalePrice")) * CDbl(ars("qty")), 2)
    	aAccWholesaleUnit = aAccWholesaleUnit & formatnumber(ars("WholesalePrice"), 2)
		aAccWholesaleTotal=aAccWholesaleTotal+(formatnumber(CDbl(ars("WholesalePrice")) * CDbl(ars("qty")), 2))
    	ars.movenext
    wend
    call closers(ars)
end sub


function getAccWholesaleQty(byref acon, aPn, aAccId)
	dim asql, ars, aBasicPrice, aComponentPrice, aPriceFieldName
	asql="SELECT * FROM orderaccessory WHERE orderaccessory_id=" & aAccId & " and purchase_no=" & aPn
	set ars = getMysqlQueryRecordSet(asql, acon)
    if not ars.eof then
    	getAccWholesaleQty = ars("qty")
    else
        getAccWholesaleQty = ""
    end if
    call closers(ars)
end function

function getAccWholesaleWeight(byref acon, aPn, aAccId)
	dim asql, ars, aBasicPrice, aComponentPrice, aPriceFieldName
	asql="SELECT * FROM packagingdata WHERE CompPartNo=" & aAccId & " and purchase_no=" & aPn
	response.Write("sql=" & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
    if not ars.eof then
    	getAccWholesaleWeight = CDbl(ars("packkg"))
    else
        getAccWholesaleWeight = 0
    end if
    call closers(ars)
end function
%>
