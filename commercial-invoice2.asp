<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="componentfuncs.asp" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote, showroomaddress, custaddress, s, deliveryaddress, clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, str8, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly, ademail, aw, x, str18, baseupholsteryprice
Dim matt1width, matt2width, matt1length, matt2length, base1width, base2width, base1length, base2length, topper1width, topper1length, basewidthstring, mattwidthstring, topperwidthstring, speciallegheight, commercialordertable, collectiondate, loc, countryname, shipperid, shipperdetails, overseasterms, items, componentname1, wrap, wraptext, hbwidth,  totalgross, cm3, totalcost, wraptext2, totalexvat, vat, vatrate, invoiceno, legno, contact1, contact2, contact3, hbheight, baseextras
baseextras=0
cm3=0
wraptext=""
dim componentarray(), dimensionsarray(), tarrifarray(), weightarray(), cubicmetersarray()
dim componentpricearray()
dim m1width, m2width, m1length, m2length
dim weight, tarrifcode, depth, weightcalc


speciallegheight=""
aw="n"
aw=request("aw")
dim purchase_no, i, paymentSum, payments, n, displayterms, orderCurrency, upholsterysum, deltxt
displayterms=""
quote=Request("quote")
custname=""
msg=""
localeref=retrieveuserregion()
Set Con = getMysqlConnection()
If retrieveuserregion()=1 then
Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=1", con)
else
Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
end if
				termstext=rs("terms")
rs.close
set rs=nothing
sql="Select * from region WHERE id_region=" & localeref

'REsponse.Write("sql=" & sql)	
Set rs = getMysqlUpdateRecordSet(sql, con)

Session.LCID = rs("locale")
rs.close
set rs=nothing
Set rs = getMysqlUpdateRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
displayterms=rs("terms")
rs.close
set rs=nothing

Set rs = getMysqlUpdateRecordSet("Select * from savoir_user where user_id=" & retrieveuserid(), con)
ademail=rs("adminemail")
rs.close
set rs=nothing

'purchase_no=Request("val")
purchase_no=CDbl(Request("pno"))
collectionid=CDbl(request("cid"))
loc=CDbl(request("loc"))
shipperid=CDbl(request("sid"))
items=request("items")

'begin section where variables have no data
if loc="" or loc=0 then
		sql="SELECT * from exportLinks L, exportcollshowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & collectionid & " and purchase_no=" & purchase_no
		'response.Write("sql=" & sql)
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		loc=rs1("idlocation")
		rs1.close
		set rs1=nothing
end if

sql="SELECT * from exportLinks L, exportcollshowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & collectionid & " and purchase_no=" & purchase_no & " and s.idlocation=" & loc
		
			Set rs1 = getMysqlQueryRecordSet(sql, con)
			invoiceno=rs1("invoiceNo")
			rs1.close
			set rs1=nothing	
			
if items="" then
		sql="SELECT * from exportLinks L, exportcollshowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & collectionid & " and purchase_no=" & purchase_no & " and s.idlocation=" & loc
			Set rs1 = getMysqlQueryRecordSet(sql, con)
			items = items + rs1.recordcount
			invoiceno=rs1("invoiceNo")
			do until rs1.eof
				if rs1("componentid")=1 then
					sql="Select mattresstype from purchase where purchase_no=" & purchase_no
					Set rs2 = getMysqlQueryRecordSet(sql, con)
					if left(rs2("mattresstype"),3)="Zip" then items=items+1
					rs2.close 
					set rs2=nothing
				end if
				if rs1("componentid")=3 then
					sql="Select basetype from purchase where purchase_no=" & purchase_no
					Set rs2 = getMysqlQueryRecordSet(sql, con)
					if (left(rs2("basetype"),3)="Eas" or left(rs2("basetype"),3)="Nor") then items=items+1
					rs2.close 
					set rs2=nothing
				end if
				rs1.movenext
			loop
			rs1.close
			set rs1=nothing

end if
if shipperid="" then
		sql="SELECT * from exportcollections where exportCollectionsID=" & collectionid
			
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		sid=rs1("shipper_address_id")
		rs1.close
		set rs1=nothing
end if
'end section where variables have no data
selcted=""
count=0
order=""
submit=""

sql = "Select * from productionsizes where purchase_no = " & purchase_no

Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
if rs2("matt1width")<>"" then 
	matt1width=rs2("matt1width")
	hbwidth=matt1width 
	else 
	matt1width=""
end if
if rs2("matt2width")<>"" then 
	matt2width=rs2("matt2width") 
	hbwidth=CDbl(hbwidth)+CDbl(matt2width)
	else 
	matt2width=""
end if
if rs2("matt1length")<>"" then matt1length=rs2("matt1length") else matt1length=""
if rs2("matt2length")<>"" then matt2length=rs2("matt2length") else matt2length=""
if rs2("base1width")<>"" then 
	base1width=rs2("base1width")
	hbwidth=base1width  
	else 
	base1width=""
end if
if rs2("base2width")<>"" then 
	base2width=rs2("base2width") 
	hbwidth=CDbl(hbwidth)+CDbl(base2width) 
	else 
	base2width=""
end if
if rs2("base1length")<>"" then base1length=rs2("base1length") else base1length=""
if rs2("base2length")<>"" then base2length=rs2("base2length") else base2length=""
if rs2("topper1width")<>"" then topper1width=rs2("topper1width") else topper1width=""
if rs2("topper1length")<>"" then topper1length=rs2("topper1length") else topper1length=""
if rs2("legheight")<>"" then speciallegheight=rs2("legheight") else speciallegheight=""
end if
rs2.close
set rs2=nothing

sql="select * from phonenumber where purchase_no=" & purchase_no & " order by seq asc"
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
do until rs2.eof
contact1=contact1 & rs2("phonenumbertype") & ": Tel: " & rs2("number") & "<br>"
rs2.movenext
loop
end if
rs2.close
set rs2=nothing

sql = "select l.componentid, P.mattresswidth, P.istrade, P.mattresslength, P.basewidth, P.baselength, P.order_number, P.savoirmodel, P.basesavoirmodel, P.upholsteryprice, P.basefabricprice, P.toppertype, P.Headboardstyle, P.headboardheight, P.mattresstype, P.basetype, P.mattressprice, P.baseprice, P.topperprice, P.topperwidth, P.topperlength, P.valanceprice, P.headboardprice, P.legprice, P.headboardlegqty, P.legsrequired, P.legQty, P.AddLegQty, P.accessoriestotalcost, P.total, P.vat, P.vatrate, P.totalexvat, P.mattressrequired, P.baserequired, P.headboardwidth, P.valancewidth, P.valancelength, P.legheight, P.legfinish from exportlinks l, exportcollections e, exportcollshowrooms S, purchase P  where l.purchase_no=" & purchase_no & " and l.linkscollectionid=S.exportCollshowroomsID and S.exportCollectionID=e.exportcollectionsid and P.purchase_no=l.purchase_no and e.exportcollectionsid=" & collectionid
Set rs = getMysqlQueryRecordSet(sql , con)
'totalcost=rs("total")
'totalexvat=rs("totalexvat")
'vat=rs("vat")
vatrate=rs("vatrate")
orderno=rs("order_number")


					Do until rs.eof
					if rs("componentid")="1" then
					Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=1 and componentname = '" & rs("savoirmodel") & "'", con)
							If not rs2.eof then
									weight=rs2("weight")
									tarrifcode=rs2("TARIFFCODE")
									depth=rs2("depth")
							end if
							rs2.close
							set rs2=nothing
							components=components & "Mattress "
							count=count+1
							redim preserve componentarray(count)
							redim preserve componentpricearray(count)
							redim preserve tarrifarray(count)
							redim preserve dimensionsarray(count)
							redim preserve weightarray(count)
							redim preserve cubicmetersarray(count)
							tarrifarray(count)=tarrifcode
							componentarray(count)=rs("savoirmodel") & " mattress 1 pc"
							'if 1 mattress
							if left(rs("mattresstype"),3)<>"Zip" then
										componentpricearray(count)=rs("mattressprice")
										totalcost=totalcost+CDbl(componentpricearray(count))
										call getComponentSizes(con,1,purchase_no, m1width, m1length)
										if left(rs("mattresswidth"),4)="Spec" then
											call getComponentWidthSpecialSizes(con,1,purchase_no, m1width)
										end if
										if left(rs("mattresslength"),4)="Spec" then
											call getComponentLengthSpecialSizes(con,1,purchase_no, m1length)
										end if
										dimensionsarray(count)=m1width & "x" & m1length & "x" & depth & "cm"
										cubicmetersarray(count)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
										weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
										weightarray(count)=round(weightcalc)
										hbwidth=m1width
										
							else
							'2 mattresses (FIRST MATT)
										call getComponentSizes(con,1,purchase_no, m1width, m1length)
										if left(rs("mattresswidth"),4)<>"Spec" then
										    hbwidth=m1width
											m1width=m1width/2
										end if 
										if left(rs("mattresswidth"),4)="Spec" then
											call getComponent1WidthSpecialSizes(con,1,purchase_no, m1width, m2width)
											hbwidth=m1width
										end if
										if left(rs("mattresslength"),4)="Spec" then
											call getComponent1LengthSpecialSizes(con,1,purchase_no, m1length, m2length)
										end if
										dimensionsarray(count)=m1width & "x" & m1length & "x" & depth & "cm"
										cubicmetersarray(count)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
										weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
										weightarray(count)=round(weightcalc)
										componentpricearray(count)=CLng(rs("mattressprice"))/2
										totalcost=totalcost+CDbl(componentpricearray(count))
								
											'2ND MATT
											count=count+1
											redim preserve componentarray(count)
											redim preserve componentpricearray(count)
											redim preserve dimensionsarray(count)
											redim preserve tarrifarray(count)
											redim preserve weightarray(count)
											redim preserve cubicmetersarray(count)
											call getComponentSizes(con,1,purchase_no, m2width, m2length)
											if left(rs("mattresswidth"),4)<>"Spec" then
											m2width=m2width/2
											end if
											if left(rs("mattresswidth"),4)="Spec" then
												call getComponent1WidthSpecialSizes(con,1,purchase_no, m1width, m2width)
												hbwidth=CDbl(hbwidth)+CDbl(m2width)
											end if
											if left(rs("mattresslength"),4)="Spec" then
												call getComponent1LengthSpecialSizes(con,1,purchase_no, m1length, m2length)
											end if
											dimensionsarray(count)=m2width & "x" & m2length & "x" & depth & "cm"
											cubicmetersarray(count)=CDbl(m2width) * CDbl(m2length) * CDbl(depth)
											weightcalc=((CDbl(m2width) * CDbl(m2length)) * CDbl(weight))+0.5
											weightarray(count)=round(weightcalc)
											
											tarrifarray(count)=tarrifcode
											componentarray(count)=rs("savoirmodel") & " mattress 1 pc"
											componentpricearray(count)=CLng(rs("mattressprice"))/2
											totalcost=totalcost+CDbl(componentpricearray(count))
										end if
							end if
						
						'response.Write("width=" & m1width & ", length=" & m1length & "<Br>")
						if rs("componentid")="3" then 
							Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=3 and componentname = '" & rs("basesavoirmodel") & "'", con)
							If not rs2.eof then
									weight=rs2("weight")
									tarrifcode=rs2("TARIFFCODE")
									depth=rs2("depth")
							end if
							rs2.close
							set rs2=nothing
							components=components & "Base "
							count=count+1
							redim preserve componentarray(count)
							redim preserve componentpricearray(count)
							redim preserve tarrifarray(count)
							redim preserve dimensionsarray(count)
							redim preserve weightarray(count)
							redim preserve cubicmetersarray(count)
							call getComponentSizes(con,3,purchase_no, m1width, m1length)
							tarrifarray(count)=tarrifcode
							'add base extras
							if rs("upholsteryprice")<>"" and rs("upholsteryprice")<>"0" and NOT isNull(rs("upholsteryprice")) then
									baseextras=baseextras+CDbl(rs("upholsteryprice"))
									
								end if
								if rs("basefabricprice")<>"" and rs("basefabricprice")<>"0" and NOT isNull(rs("basefabricprice")) then
									baseextras=baseextras+CDbl(rs("basefabricprice"))
								end if
							'end add base extras
							componentarray(count)=rs("basesavoirmodel") & " base 1 pc"
							if (left(rs("basetype"),3)<>"Eas" and left(rs("basetype"),3)<>"Nor") then
							response.Write(rs("baseprice") & " " & baseextras)
								componentpricearray(count)=CDbl(rs("baseprice"))+baseextras
								if rs("baseprice")="" or isNull(rs("baseprice")) then
									componentpricearray(count)=0+baseextras
									else
									totalcost=totalcost+CDbl(componentpricearray(count))+baseextras
								end if
									if left(rs("basewidth"),4)="Spec" then
											call getComponentWidthSpecialSizes(con,3,purchase_no, m1width)
											hbwidth=m1width
									end if
									if left(rs("baselength"),4)="Spec" then
											call getComponentLengthSpecialSizes(con,3,purchase_no, m1length)
									end if
									dimensionsarray(count)=m1width & "x" & m1length & "x" & depth & "cm"
									cubicmetersarray(count)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
									weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
									
									weightarray(count)=round(weightcalc)
							else
							'2 BASES (1ST BASE)
							
									call getComponentSizes(con,3,purchase_no, m1width, m1length)
									if left(rs("basetype"),3)="Nor" then
									hbwidth=m1width
									m1width=CDbl(m1width)/2
									end if
									if left(rs("basetype"),3)="Eas" then
									hbwidth=m1width
									m1length=130
									end if
									if left(rs("basewidth"),4)="Spec" then
											call getComponent1WidthSpecialSizes(con,3,purchase_no, m1width, m2width)
											hbwidth=m1width
											m1width=m1width
									end if
									if left(rs("baselength"),4)="Spec" then
											call getComponent1LengthSpecialSizes(con,3,purchase_no, m1length, m2length)
											m1length=m1length
									end if
									dimensionsarray(count)=m1width & "x" & m1length & "x" & depth & "cm"
									cubicmetersarray(count)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
									weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
									
									weightarray(count)=round(weightcalc)
									componentpricearray(count)=(CLng(rs("baseprice"))+baseextras)/2
									totalcost=totalcost+CDbl(componentpricearray(count))
									'2ND BASE
									count=count+1
									call getComponentSizes(con,3,purchase_no, m1width, m1length)
									redim preserve componentarray(count)
									redim preserve componentpricearray(count)
									redim preserve dimensionsarray(count)
									redim preserve tarrifarray(count)
									redim preserve weightarray(count)
									redim preserve cubicmetersarray(count)
									if left(rs("basetype"),3)="Nor" then
								    	m2width=CDbl(m1width)/2
										m2length=m1length
									end if
									if left(rs("basetype"),3)="Eas" then
										m2width=m1width
										m2length=CDbl(m1length)-130
									end if
									if left(rs("basewidth"),4)="Spec" then
											call getComponent1WidthSpecialSizes(con,3,purchase_no, m1width, m2width)
											if (trim(hbwidth)<>"" and trim(m2width)<>"") then
											hbwidth=CDbl(hbwidth)+CDbl(m2width)
											end if
											m2width=m2width
									end if
									if left(rs("baselength"),4)="Spec" then
											call getComponent1LengthSpecialSizes(con,3,purchase_no, m1length, m2length)
											m2length=m2length
									end if
									dimensionsarray(count)=m2width & "x" & m2length & "x" & depth & "cm"
									cubicmetersarray(count)=cleantonumber(m2width) * cleantonumber(m2length) * cleantonumber(depth)
									if m2width<>"" and m2length<>"" then
									weightcalc=((CDbl(m2width) * CDbl(m2length)) * CDbl(weight))+0.5
									end if
									weightarray(count)=round(weightcalc)
									
									tarrifarray(count)=tarrifcode
									componentarray(count)=rs("basesavoirmodel") & " base 1 pc"
									componentpricearray(count)=(CLng(rs("baseprice"))+baseextras)/2
									totalcost=totalcost+CDbl(componentpricearray(count))
							end if
							
						end if
						if rs("componentid")="5" then 
						Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=5 and componentname = '" & rs("toppertype") & "'", con)
							If not rs2.eof then
									weight=rs2("weight")
									tarrifcode=rs2("TARIFFCODE")
									depth=rs2("depth")
							end if
							rs2.close
							set rs2=nothing 
							components=components & "Topper "
							count=count+1
							redim preserve componentarray(count)
							redim preserve componentpricearray(count)
							redim preserve tarrifarray(count)
							redim preserve dimensionsarray(count)
							redim preserve weightarray(count)
							redim preserve cubicmetersarray(count)
							call getComponentSizes(con,5,purchase_no, m1width, m1length)
							tarrifarray(count)=tarrifcode
							if left(rs("topperwidth"),4)="Spec" then
											call getComponentWidthSpecialSizes(con,5,purchase_no, m1width)
											m1width=m1width
									end if
									if left(rs("topperlength"),4)="Spec" then
											call getComponentLengthSpecialSizes(con,5,purchase_no, m1length)
											m1length=m1length
									end if
							dimensionsarray(count)=m1width & "x" & m1length & "x" & depth & "cm"
							cubicmetersarray(count)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
							weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
							weightarray(count)=round(weightcalc)
							
							componentarray(count)=rs("toppertype") & "  1 pc"
							componentpricearray(count)=rs("topperprice")
							totalcost=totalcost+CDbl(componentpricearray(count))
						end if
						if rs("componentid")="6" then 
							components=components & "Valance "
							count=count+1
							redim preserve componentarray(count)
							redim preserve componentpricearray(count)
							redim preserve tarrifarray(count)
							redim preserve dimensionsarray(count)
							redim preserve weightarray(count)
							redim preserve cubicmetersarray(count)
							call getComponentSizes(con,6,purchase_no, m1width, m1length)
							tarrifarray(count)="-"
							dimensionsarray(count)=m1width & "x" & m1length & "cm"
							cubicmetersarray(count)="-"
							'weightcalc=(CDbl(m1width) * CDbl(m1length)) * CDbl(weight)
							weightarray(count)="-"
							componentarray(count)="Valance 1 pc"
							componentpricearray(count)=rs("valanceprice")
							totalcost=totalcost+CDbl(componentpricearray(count))
						end if
						if rs("componentid")="7" then 
							if rs("legQty")<>"" then
								legno=rs("legQty")
							end if
							if rs("AddLegQty")<>"" then
								legno=legno + rs("AddLegQty")
							end if
							if rs("headboardlegqty")<>"" then
								legno=legno + rs("headboardlegqty")
							end  if
						Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=7", con)
							If not rs2.eof then
									weight=rs2("weight")
									tarrifcode=rs2("TARIFFCODE")
									depth=rs2("depth")
							end if
							rs2.close
							set rs2=nothing 
							
							call getComponentSizes(con,7,purchase_no, legheight, legfinish)
							components=components & "Legs "
							count=count+1
							redim preserve componentarray(count)
							redim preserve componentpricearray(count)
							redim preserve tarrifarray(count)
							redim preserve dimensionsarray(count)
							redim preserve weightarray(count)
							redim preserve cubicmetersarray(count)
							tarrifarray(count)=tarrifcode
							if left(rs("legheight"),4)="Spec" then
											call getComponentWidthSpecialSizes(con,7,purchase_no, m1height)
											legheight=m1height
									end if
							dimensionsarray(count)="22 x 42 x 27cm"
							cubicmetersarray(count)=24948
							weightcalc=((CDbl(legno) * 27 * CDbl(weight))/1000)+0.5
							weightarray(count)=round(weightcalc)
							componentarray(count)=" Legs (" & legno & ") and Fittings 1 box"
							if rs("legprice")<>"" then
							componentpricearray(count)=rs("legprice")
							else
							componentpricearray(count)=0
							end if
							totalcost=totalcost+CDbl(componentpricearray(count))
						end if
						if rs("componentid")="8" then
						Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=8 and componentname = '" & rs("headboardstyle") & "'", con)
							If not rs2.eof then
									weight=rs2("weight")
									tarrifcode=rs2("TARIFFCODE")
									depth=rs2("depth")
									else
									tarrifcode="-"
									
							end if
							rs2.close
							set rs2=nothing 
							
							components=components & "Headboard "
							count=count+1
							redim preserve componentarray(count)
							redim preserve componentpricearray(count)
							redim preserve dimensionsarray(count)
							redim preserve weightarray(count)
							redim preserve tarrifarray(count)
							redim preserve cubicmetersarray(count)
							tarrifarray(count)=tarrifcode
							if rs("headboardheight")="TBC" then hbheight=215 else hbheight=cleantonumber(rs("headboardheight"))

							if rs("headboardWidth")<>"" then 
								hbwidth=rs("headboardWidth")
								else
								if hbwidth="" then hbwidth=getHbWidth(con,purchase_no)
								if hbwidth="" then hbwidth=0
							end if

							if hbwidth<>"" then
							dimensionsarray(count)=hbwidth & "x" & hbheight & " "
							else
							dimensionsarray(count)=hbheight & " "
							end if
							
							if left(rs("headboardheight"),4)<>"Spec" then
								if depth="" then depth=15
								
							cubicmetersarray(count)=CDbl(hbwidth) * hbheight * CDbl(depth)
							else
							cubicmetersarray(count)="-"
							end if
			
							weightcalc=((CDbl(hbwidth)) * CDbl(weight))+0.5
							weightarray(count)=round(weightcalc)
							
							componentarray(count)=rs("headboardstyle") & " Headboard 1 pc"
							componentpricearray(count)=rs("headboardprice")
							totalcost=totalcost+CDbl(componentpricearray(count))
						end if
						if rs("componentid")="9" then 
							components=components & "Accessories "
							count=count+1
							redim preserve componentarray(count)
							redim preserve componentpricearray(count)
							redim preserve dimensionsarray(count)
							redim preserve weightarray(count)
							redim preserve tarrifarray(count)
							redim preserve cubicmetersarray(count)
							tarrifarray(count)="-"
							dimensionsarray(count)="-"
							cubicmetersarray(count)="-"
							weightcalc="-"
							weightarray(count)=weightcalc
							componentarray(count)="Accessories"
							componentpricearray(count)=rs("accessoriestotalcost")
							totalcost=totalcost+CDbl(componentpricearray(count))
						end if
						rs.movenext
						loop
						rs.close
						set rs=nothing


for i= 1 to items
	if weightarray(i)<>"-" then
totalgross=totalgross+CDbl(weightarray(i))
end if
next

for i= 1 to items
	if cubicmetersarray(i)<>"-" then
cm3=cm3+CDbl(cubicmetersarray(i))
end if
next
cm3=cm3/(100*100*100)
payments = getPaymentsForOrder(purchase_no, con)

if invoiceno="" then
invoiceno="N/a"
end if



Set rs = getMysqlQueryRecordSet("Select * from purchase WHERE purchase_no=" & purchase_no & "", con)
Dim vatcalc
if rs("istrade")="y" then
vat=totalcost*(CDbl(vatrate)/100)
else
vatcalc=totalcost/(1+CDbl(vatrate)/100)
vat=totalcost-vatcalc
end if
wrap=rs("wrappingid")
If rs("deliveryadd1") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd1")) & "<br>"
If rs("deliveryadd2") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd2")) & "<br>"
If rs("deliveryadd3") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd3")) & "<br>"
If rs("deliverytown") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverytown")) & "<br>"
If rs("deliverycounty") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverycounty")) & "<br>"
If rs("deliverypostcode") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverypostcode")) & "<br>"
If rs("deliverycountry") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverycountry"))

Set rs2 = getMysqlQueryRecordSet("Select * from location WHERE idlocation=" & rs("idlocation") & "", con)
If rs2("add1")<>"" then showroomaddress=rs2("add1") & ", "
If rs2("add2")<>"" then showroomaddress=showroomaddress & rs2("add2") & ", "
If rs2("add3")<>"" then showroomaddress=showroomaddress & rs2("add3") & ", "
If rs2("town")<>"" then showroomaddress=showroomaddress & rs2("town") & ", "
If rs2("countystate")<>"" then showroomaddress=showroomaddress & rs2("countystate") & ", "
If rs2("postcode")<>"" then showroomaddress=showroomaddress & rs2("postcode") & ", "
if showroomaddress<>"" then showroomaddress=left(showroomaddress, len(showroomaddress)-2)
showroomaddress=showroomaddress & "<br>"
If rs2("tel")<>"" then showroomaddress=showroomaddress & "Tel: " & rs2("tel")
showroomaddress=showroomaddress & "<br>"
If ademail<>"" then showroomaddress=showroomaddress & "Email: " &ademail
rs2.close
set rs2=nothing
Set rs2 = getMysqlQueryRecordSet("Select * from savoir_user WHERE username like '" & rs("salesusername") & "'", con)
orderCurrency = rs("ordercurrency")
contact = rs2("name")
rs2.close
set rs2=nothing
Set rs1 = getMysqlQueryRecordSet("Select * from contact WHERE code=" & rs("code") & "", con)
Set rs2 = getMysqlQueryRecordSet("Select * from address WHERE code=" & rs1("code") & "", con)

signature = rs("signature")

If rs1("title") <> "" Then custname=custname & capitalise(lcase(rs1("title"))) & " "
If rs1("first") <> "" Then custname=custname & capitalise(lcase(rs1("first"))) & " "
If rs1("surname") <> "" Then custname=custname & capitalise(lcase(rs1("surname")))
clienthdg="<font family=""Tahoma""><font size=""8"">"
clienthdg=clienthdg & "Client: <br>"
clienthdg=clienthdg & "Company: <br>"
if rs1("company_vat_no")<>"" then clienthdg=clienthdg & "VAT No: <br>"
clienthdg=clienthdg & "Home Tel: <br>"
clienthdg=clienthdg & "Work Tel: <br>"
clienthdg=clienthdg & "Mobile: <br>"
clienthdg=clienthdg & "Email: <br>"
clienthdg=clienthdg & "Client Ref: <br>"
clienthdg=clienthdg & "</font></font>"

clientdetails="<font family=""Tahoma""><font size=""9""><b>"
clientdetails=clientdetails & Utf8ToUnicode(custname) & "&nbsp;</b><br></font><font family=""Tahoma""><font size=""8""><b>"
clientdetails=clientdetails & rs2("company") & "&nbsp;<br>"
if rs1("company_vat_no")<>"" then clientdetails=clientdetails & rs1("company_vat_no") & "<br>"
clientdetails=clientdetails & rs2("tel") & "&nbsp;<br>"
clientdetails=clientdetails & rs1("telwork") & "&nbsp;<br>"
clientdetails=clientdetails & rs1("mobile") & "&nbsp;<br>"
clientdetails=clientdetails & rs2("email_address") & "&nbsp;<br>"
clientdetails=clientdetails & rs("customerreference") & "&nbsp;<br>"
clientdetails=clientdetails & "</font></font>"

If rs2("street1")<>"" then custaddress= rs2("street1") & "<br>"
If rs2("street2")<>"" then custaddress=custaddress & rs2("street2") & "<br>"
If rs2("street3")<>"" then custaddress=custaddress & rs2("street3") & "<br>"
If rs2("town")<>"" then custaddress=custaddress & rs2("town") & "<br>"
If rs2("county")<>"" then custaddress=custaddress & rs2("county") & "<br>"
If rs2("postcode")<>"" then custaddress=custaddress & rs2("postcode") & "<br>"
If rs2("country")<>"" then custaddress=custaddress & rs2("country")
s = "<br><br><table cellpadding=""1""> "
s = s & " <tr height=""0""><td colspan=""7"" height=""0""></td></tr>"
s = s & " <tr><td width=""11"" height=""55""></td> "
s = s & " <td width=""54"" valign=""top"">" & clienthdg & "</td><td width=""112"" valign=""top"">" & Utf8ToUnicode(clientdetails) & "</td><td width=""24""></td><td width=""166""><b>" & Utf8ToUnicode(custaddress) & "</b></td><td width=""24""></td><td width=""166""><b>" & deliveryaddress & "</b></td> "
s = s & " </tr> "
s = s & " </table> "
If quote="y" then 
hdg="Pricing is subject to change.  This quote is valid for 60 days"
hdg2="Quote for:"
Else
hdg2="Order for:"
End If   
payments = getPaymentsForOrder(purchase_no, con)

Set rs3 = getMysqlQueryRecordSet("select * from orderaccessory where purchase_no=" & purchase_no & " order by orderaccessory_id", con)
xacc="<table><tr><td width=""10"" height=""20""></td><td>Item&nbsp;Description</td><td>Design</td><td>Colour</td><td>Size</td><td align=""right"">Qty</td><td align=""right"">Unit&nbsp;Price</td><td align=""right"">Total</td></tr>"
if not rs3.eof then
 do until rs3.eof
xacc=xacc & "<tr ><td width=""10"" height=""20""></td>"
xacc=xacc & "<td width=""150""><b>" & rs3("description") & "</b></td>"
xacc=xacc & "<td width=""100""><b>" & rs3("design") & "</b></td>"
xacc=xacc & "<td width=""80""><b>" & rs3("colour") & "</b></td>"
xacc=xacc & "<td width=""80""><b>" & rs3("size") & "</b></td>"
xacc=xacc & "<td width=""40"" align=""right""><b>" & rs3("qty") & "</b></td>"
xacc=xacc & "<td width=""50"" align=""right""><b>" & fmtCurr2(rs3("unitprice"), true, rs("ordercurrency")) & "</b></td>"
if (rs3("unitprice")<>"" and CDbl(rs3("unitprice"))>0.0) then accesscost=rs3("qty")*CDbl(rs3("unitprice")) else accesscost=0
xacc=xacc & "<td width=""40"" align=""right""><b>" & fmtCurr2(accesscost, true, rs("ordercurrency")) & "</b></td>"
xacc=xacc & "</tr>"
xacc=xacc & "<tr><td></td><td colspan=""7""><hr style=""color:#eeeeee;""></td></tr>"
accesscost=0   
	rs3.movenext
	loop
end if
rs3.close
set rs3 = nothing
	
xacc=xacc & "</table>"
sql = "Select * from exportcollections where  exportCollectionsID= " & collectionid
set rs3 = getMysqlQueryRecordSet(sql, con)
collectiondate=rs3("collectiondate")
rs3.close
set rs3=nothing

sql = "Select * from shipper_address where  shipper_Address_Id= " & shipperid
set rs3 = getMysqlQueryRecordSet(sql, con)
if not rs3.eof then
if rs3("contact")<>"" then shipperdetails=rs3("contact") & " - "
if rs3("shippername")<>"" then shipperdetails=shipperdetails & rs3("shippername") & " "
if rs3("phone")<>"" then shipperdetails=shipperdetails & rs3("phone") & " "
end if
rs3.close
set rs3=nothing
if rs("overseasduty")<>"" then
sql = "Select * from overseas_duty where overseas_dutyID=" & rs("overseasduty")
set rs3 = getMysqlQueryRecordSet(sql, con)
if not rs3.eof then
overseasterms=rs3("terms")
else
overseasterms="-"
end if
rs3.close
set rs3=nothing
end if

sql = "Select * from region R, location L where L.idlocation = " & loc & " and L.owning_region=R.id_region"

set rs3 = getMysqlQueryRecordSet(sql, con)
countryname=rs3("country")
rs3.close
set rs3=nothing

if wrap <> "" then
sql = "Select CommercialText from WrappingTypes where wrappingid = " & wrap
set rs3 = getMysqlQueryRecordSet(sql, con)
wraptext=rs3("commercialText")
if wrap=1 then wraptext2="Piece"
if wrap=2 then wraptext2="Piece"
if wrap=3 then wraptext2="Box"
if wrap=4 then wraptext2="Crate"
rs3.close
set rs3=nothing
end if

sql = "Select * from exportlinks where purchase_no = " & purchase_no & " and linkscollectionid= " & collectionid
set rs3 = getMysqlQueryRecordSet(sql, con)
rs3.close
set rs3=nothing
commercialordertable="<table border=1 width=""100%"" cellspacing=""1"" cellpadding=""4""><tr><td colspan=""2"">Seller:<br>Savoir Beds Limited<br>1 Old Oak Lane<br>London NW10 6UD<br>UK</td><td>Date: " & collectiondate & "<br><br>Invoice No. " & invoiceno & "</td><td>Customer's Order No. " & rs("order_number") & "<br><br>Other References:<br>" & Utf8ToUnicode(rs("customerreference")) & "</td></tr><tr><td colspan=""2"">Consignee:<br>" & deliveryaddress & "<br>" & contact1 & "</td><td colspan=""2"">Buyer:<br>" & Utf8ToUnicode(custaddress) & "</td></tr>"
commercialordertable=commercialordertable & "<tr><td>Country of Origin:<br><br>UK  </td><td>Country of Final Destination:<br><br> " & ucase(countryname) & "</td><td colspan=""2"">Country of Origin of Goods: <br><br>United Kingdom</td></tr>"
commercialordertable=commercialordertable & "<tr><td colspan=""2"">Terms & Conditions of Delivery and Payment:<br><br>" & overseasterms & "  </td><td colspan=""2"">Mode of Transport and Other Transport Information:<br><br>" & shipperdetails & "<hr>Currency of Sale: " & orderCurrency & "</td></tr>"
commercialordertable=commercialordertable & "<tr><td>Marks & Numbers:<br><br>" & items & "</td><td colspan=""2"">Description of Goods<br><br>" & components & "<br>" & wraptext & "</td><td>Gross Weight (kg): " & totalgross & "<br><br>Cube (M3): " & formatnumber(cm3,2) & "</td></tr></table>"
commercialordertable=commercialordertable & "<table width=""100%"" border=""1"" cellspacing=""2"" cellpadding=""1""><tr><td colspan=""3"">Number&nbsp;&&nbsp;Kind&nbsp;of&nbsp;Packages</td><td>Dimensions</td><td>Harmonized Tariff Code</td><td align=""right"">Weight (kg)</td> <td>Qty</td><td align=""right"">Unit&nbsp;Price</td><td align=""right"">Amount</td></tr>"
for i= 1 to items
commercialordertable=commercialordertable & "<tr><td width=""70""> " & i & " of " & items & "</td><td width=""50"">" & wraptext2 & "&nbsp;</td><td width=""170"">" & componentarray(i) & "</td><td>" & dimensionsarray(i) & "</td><td>" & tarrifarray(i) & "</td><td align=""right"">" & weightarray(i) & "</td><td align=""center"">1</td><td align=""right"">" & getCurrencySymbolForCurrency(orderCurrency)  & formatnumber(componentpricearray(i),2) & "</td><td align=""right"">" & getCurrencySymbolForCurrency(orderCurrency)  & formatnumber(componentpricearray(i),2) & "</td></tr>"
next
commercialordertable=commercialordertable & "<tr><td width=""70""></td><td width=""50""></td><td width=""170""></td><td></td><td>VALUE</td><td align=""right""></td><td align=""center""></td><td align=""right""></td><td align=""right"">" & getCurrencySymbolForCurrency(orderCurrency)  & formatnumber(totalcost,2) & "</td></tr>"
commercialordertable=commercialordertable & "</table>"

' Clear out the existing HTTP header information
Response.Expires = 0
Response.Buffer = TRUE
Response.Clear
Response.Buffer = TRUE
Response.ContentType = "application/pdf"

Response.Expires = 0
Response.Expiresabsolute = Now() - 1
Response.AddHeader "pragma","no-cache"
Response.AddHeader "cache-control","private"
Response.CacheControl = "no-cache" 

dim PDF, str, streamPDF
str=""

const csPropGraphLineColor=405
const csPropGraphZoom= 1
const csPropGraphWZoom= 50 
const csPropGraphHZoom= 50
const csPropTextFont  = 100
const csHTML_FontName = 100
const csHTML_FontSize  = 101
const csHTML_TableDraw =0


const csPropTextSize  = 101
const csPropTextAlign = 102
const csPropTextColor = 103
const csPropTextUnderline = 104
const csPropTextRender  = 105
const csPropAddTextWidth = 113
const csPropParSpace    = 200
const csPropParLeft 	= 201
const csPropParTop 		= 202
const csPropPosX	    = 205
const csPropPosY	    = 206
const csPropInfoTitle 	= 300

'
const algLeft = "0"
const algRight = "1"
const algCenter = "2"
const algJustified = "3"
'
const pTrue = "1"
const pFalse = "0"

Sub DrawBox(X, Y, Width, Height)
	PDF.AddBox X, Y, X+Width, Y+Height
End Sub
set PDF = server.createobject("aspPDF.EasyPDF")
'PDF.License("C:\Program Files (x86)\MITData\01022012-44318-S1538.lic")
PDF.License("$1987662561;'David Mildenhall';PDF;1;0-94.136.44.145;0-217.199.174.247")
PDF.page "A4", 0  'landscape

'PDF.DEBUG = True
PDF.SetMargins 10,15,10,5


PDF.SetProperty csPropTextAlign, algCenter
YPos = int(PDF.GetProperty(csPropPosY))
PDF.SetPos 0, YPos - 5
'PDF.AddLine 60, 55, 520, 55
PDF.SetTrueTypeFont "F15", "Tahoma", 0, 0
PDF.SetProperty csPropParLeft, "20"
PDF.SetProperty csPropPosX, "20"
PDF.SetProperty csHTML_FontName, "F1"
PDF.SetProperty csHTML_FontSize, "8"
PDF.SetProperty csPropTextColor,"#999"
PDF.SetProperty csPropTextAlign, "0"
PDF.SetProperty csPropAddTextWidth, 1
PDF.SetFont "F15", 12, "#999"


PDF.AddHTML "<p align=""center""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
PDF.AddTextPos 250, 66, "Commercial Invoice"
PDF.AddHTML commercialordertable
if rs("istrade")="y" then
totalcost=totalcost+vat
else
end if
if vatrate="0" then
PDF.AddHTMLPos 130, 660, "<table width=""100%""><tr><td width=""300"" ><br><img src=""images/CI-sig.gif"" width=""349"" height=""118""></td><td width=""200"" align=""right""><br><br><br><br>TOTAL&nbsp;INVOICE&nbsp;AMOUNT: </td><td align=""right""><br><br><br>" & getCurrencySymbolForCurrency(orderCurrency)  & formatnumber(totalcost,2) & "</td></tr></table><br><table width=""100%""><tr><td align=""center"">VAT Reg No. GB 706 8175 27<br>Savoir Beds Limited, registered in England: No. 3395749.<br>Registered Address: 1 Old Oak Lane, London NW10 6UD, UK</td></tr></table>"
else
PDF.AddHTMLPos 130, 660, "<table width=""100%""><tr><td width=""300"" ><br><img src=""images/CI-sig.gif"" width=""349"" height=""118""></td><td width=""200"" align=""right""><br><br>VAT at " & vatrate & "%: <br><br>TOTAL&nbsp;INVOICE&nbsp;AMOUNT: </td><td align=""right""><br>" & getCurrencySymbolForCurrency(orderCurrency)  & formatnumber(vat,2) & "<br><br>" & getCurrencySymbolForCurrency(orderCurrency)  & formatnumber(totalcost,2) & "</td></tr></table><br><table width=""100%""><tr><td align=""center"">VAT Reg No. GB 706 8175 27<br>Savoir Beds Limited, registered in England: No. 3395749.<br>Registered Address: 1 Old Oak Lane, London NW10 6UD, UK</td></tr></table>"
end if




PDF.BinaryWrite
set pdf = nothing
rs1.close
rs.close
rs2.close
set rs1=nothing
set rs=nothing
set rs2=nothing

function capitalise(str)
dim words, word
if isNull(str) or trim(str)="" then
	capitalise=""
else
	words = split(trim(str), " ")
	for each word in words
		word = lcase(word)
		word = ucase(left(word,1)) & (right(word,len(word)-1))
		capitalise = capitalise & word & " "
	next
	capitalise = left(capitalise, len(capitalise)-1)
end if

end function

  
con.close
set con=nothing

%>