<%Dim hasmattress, hasbase, hastopper, hasvalance, hasheadboard, hasaccessories, haslegs
hasmattress="n"
hasbase="n"
hastopper="n"
hasvalance="n"
hasheadboard="n"
hasaccessories="n"
haslegs="n"
sql = "Select * from productionsizes where purchase_no = " & pnarray(n)

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

sql = "select l.componentid from exportlinks l, exportcollections e, exportcollshowrooms S, purchase P  where l.purchase_no=" & pnarray(n) & " and l.linkscollectionid=S.exportCollshowroomsID and S.exportCollectionID=e.exportcollectionsid and P.purchase_no=l.purchase_no and e.exportcollectionsid=" & collectionid
Dim haspegboard, packpegwith
haspegboard="n"
Set rs = getMysqlQueryRecordSet(sql , con)
if not rs.eof then
	Do until rs.eof
	if rs("componentid")=1 then hasmattress="y"
	if rs("componentid")=3 then hasbase="y"
	if rs("componentid")=5 then hastopper="y"
	if rs("componentid")=6 then hasvalance="y"
	if rs("componentid")=7 then haslegs="y"
	if rs("componentid")=8 then hasheadboard="y"
	if rs("componentid")=9 then hasaccessories="y"
	rs.movenext
	loop
end if
rs.close
set rs=nothing

dim basevalance, toppervalance, mattressvalance, hbvalance, valanceonly
basevalance="n"
toppervalance="n"
mattressvalance="n"
hbvalance="n"
valanceonly="n"

if hasvalance="y" then
	if hasbase="y" then 
	basevalance="y"
	elseif hasbase="n" and hastopper="y" then toppervalance="y"
	elseif hasbase="n" and hastopper="n" and hasmattress="y" then mattressvalance="y"
	elseif hasbase="n" and hastopper="n" and hasmattress="n" and hasheadboard="y" then hbvalance="y"
	else 
	valanceonly="y" 
	end if
end if


sql = "select l.componentid, P.customerreference, P.mattresswidth, P.mattresslength, P.basewidth, P.baselength, P.order_number, P.savoirmodel, P.basesavoirmodel, P.toppertype, P.Headboardstyle, P.headboardheight, P.mattresstype, P.basetype, P.mattressprice, P.baseprice, P.topperprice, P.topperwidth, P.topperlength, P.valanceprice, P.headboardprice, P.legprice, P.headboardlegqty, P.legsrequired, P.legQty, P.AddLegQty, P.topperrequired, P.headboardrequired, P.accessoriestotalcost, P.total, P.vat, P.vatrate, P.totalexvat, P.mattressrequired, P.baserequired, P.headboardwidth, P.valancewidth, P.valancelength, P.legheight, P.legfinish from exportlinks l, exportcollections e, exportcollshowrooms S, purchase P  where l.purchase_no=" & pnarray(n) & " and l.linkscollectionid=S.exportCollshowroomsID and S.exportCollectionID=e.exportcollectionsid and P.purchase_no=l.purchase_no and e.exportcollectionsid=" & collectionid

Set rs = getMysqlQueryRecordSet(sql , con)



'totalcost=rs("total")
'totalexvat=rs("totalexvat")
'vat=rs("vat")
vatrate=rs("vatrate")
orderno=rs("order_number")
itemcount=0

Do until rs.eof
					
if rs("basesavoirmodel")="Pegboard" then 
haspegboard="y"
end if
if rs("mattressrequired")="y" and haspegboard="y" then
packpegwith=1
elseif rs("topperrequired")="y" and haspegboard="y" then
packpegwith=5
elseif rs("headboardrequired")="y" and haspegboard="y" then
packpegwith=8
else
packpegwith=0
end if

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
							itemcount=itemcount+1
							redim preserve componentarray(itemcount)
							redim preserve componentpricearray(itemcount)
							redim preserve tarrifarray(itemcount)
							redim preserve dimensionsarray(itemcount)
							redim preserve weightarray(itemcount)
							redim preserve cubicmetersarray(itemcount)
							tarrifarray(itemcount)=tarrifcode
							if packpegwith=1 then
								componentarray(itemcount)=rs("savoirmodel") & " mattress & pegboard 2 pc"
							else
								componentarray(itemcount)=rs("savoirmodel") & " mattress 1 pc"
							end if
							'if 1 mattress
							if left(rs("mattresstype"),3)<>"Zip" then
										if rs("mattressprice")="" AND NOT ISNULL(rs("mattressprice")) then
										else
										componentpricearray(itemcount)=rs("mattressprice")
										end if
										'totalcost=totalcost+CDbl(componentpricearray(itemcount))
										call getComponentSizes(con,1,pnarray(n), m1width, m1length)
										if left(rs("mattresswidth"),4)="Spec" then
											call getComponentWidthSpecialSizes(con,1,pnarray(n), m1width)
										end if
										if left(rs("mattresslength"),4)="Spec" then
											call getComponentLengthSpecialSizes(con,1,pnarray(n), m1length)
										end if
										dimensionsarray(itemcount)=m1width & "x" & m1length & "x" & depth & "cm"
										cubicmetersarray(itemcount)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
										weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
										weightarray(itemcount)=round(weightcalc)
										
							else
							'2 mattresses (FIRST MATT)
										call getComponentSizes(con,1,pnarray(n), m1width, m1length)
										if left(rs("mattresswidth"),4)<>"Spec" then
											m1width=m1width/2
										end if 
										if left(rs("mattresswidth"),4)="Spec" then
											call getComponent1WidthSpecialSizes(con,1,pnarray(n), m1width, m2width)
										end if
										if left(rs("mattresslength"),4)="Spec" then
											call getComponent1LengthSpecialSizes(con,1,pnarray(n), m1length, m2length)
										end if
										dimensionsarray(itemcount)=m1width & "x" & m1length & "x" & depth & "cm"
										cubicmetersarray(itemcount)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
										weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
										weightarray(itemcount)=round(weightcalc)
										if rs("mattressprice")<>"" and Not isNull(rs("mattressprice")) then
										componentpricearray(itemcount)=CLng(rs("mattressprice"))/2
										end if
										if rs("mattressprice")<>"" and Not isNull(rs("mattressprice")) then
										totalcost=totalcost+CDbl(componentpricearray(itemcount))
										end if
								
											'2ND MATT
											itemcount=itemcount+1
											redim preserve componentarray(itemcount)
											redim preserve componentpricearray(itemcount)
											redim preserve dimensionsarray(itemcount)
											redim preserve tarrifarray(itemcount)
											redim preserve weightarray(itemcount)
											redim preserve cubicmetersarray(itemcount)
											call getComponentSizes(con,1,pnarray(n), m2width, m2length)
											if left(rs("mattresswidth"),4)<>"Spec" then
											m2width=m2width/2
											end if
											if left(rs("mattresswidth"),4)="Spec" then
												call getComponent1WidthSpecialSizes(con,1,pnarray(n), m1width, m2width)
											end if
											if left(rs("mattresslength"),4)="Spec" then
												call getComponent1LengthSpecialSizes(con,1,pnarray(n), m1length, m2length)
											end if
											dimensionsarray(itemcount)=m2width & "x" & m2length & "x" & depth & "cm"
											cubicmetersarray(itemcount)=CDbl(m2width) * CDbl(m2length) * CDbl(depth)
											weightcalc=((CDbl(m2width) * CDbl(m2length)) * CDbl(weight))+0.5
											weightarray(itemcount)=round(weightcalc)
											
											tarrifarray(itemcount)=tarrifcode
											if packpegwith=1 then
												componentarray(itemcount)=rs("savoirmodel") & " mattress & pegboard 2 pc"
											else
												componentarray(itemcount)=rs("savoirmodel") & " mattress 1 pc"
											end if
											if rs("mattressprice")<>"" AND NOT ISNULL(rs("mattressprice")) then
											componentpricearray(itemcount)=CLng(rs("mattressprice"))/2
											end if
											if rs("mattressprice")<>"" and Not isNull(rs("mattressprice")) then
											totalcost=totalcost+CDbl(componentpricearray(itemcount))
											end if
										end if
							end if
						
						'response.Write("width=" & m1width & ", length=" & m1length & "<Br>")
						if rs("componentid")="3" and packpegwith=0 then 
							Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=3 and componentname = '" & rs("basesavoirmodel") & "'", con)
							If not rs2.eof then
									weight=rs2("weight")
									tarrifcode=rs2("TARIFFCODE")
									depth=rs2("depth")
							end if
							rs2.close
							set rs2=nothing
							components=components & "Base "
							itemcount=itemcount+1
							redim preserve componentarray(itemcount)
							redim preserve componentpricearray(itemcount)
							redim preserve tarrifarray(itemcount)
							redim preserve dimensionsarray(itemcount)
							redim preserve weightarray(itemcount)
							redim preserve cubicmetersarray(itemcount)
							call getComponentSizes(con,3,pnarray(n), m1width, m1length)
							tarrifarray(itemcount)=tarrifcode
							if basevalance="y" then
							componentarray(itemcount)=rs("basesavoirmodel") & " base 1 pc, Inc. Valance 1pc"
							else
							componentarray(itemcount)=rs("basesavoirmodel") & " base 1 pc"
							end if
							if (left(rs("basetype"),3)<>"Eas" and left(rs("basetype"),3)<>"Nor") then
								IF rs("baseprice")<>"" and NOT ISNULL(rs("baseprice")) then
								componentpricearray(itemcount)=rs("baseprice")
								end if
								totalcost=totalcost+CDbl(componentpricearray(itemcount))
									if left(rs("basewidth"),4)="Spec" then
											call getComponentWidthSpecialSizes(con,3,pnarray(n), m1width)
									end if
									if left(rs("baselength"),4)="Spec" then
											call getComponentLengthSpecialSizes(con,3,pnarray(n), m1length)
									end if
									dimensionsarray(itemcount)=m1width & "x" & m1length & "x" & depth & "cm"
									cubicmetersarray(itemcount)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
									weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
									
									weightarray(itemcount)=round(weightcalc)
							else
							'2 BASES (1ST BASE)
							
									call getComponentSizes(con,3,pnarray(n), m1width, m1length)
									if left(rs("basetype"),3)="Nor" then
									m1width=CDbl(m1width)/2
									end if
									if left(rs("basetype"),3)="Eas" then
									m1length=130
									end if
									if left(rs("basewidth"),4)="Spec" then
											call getComponent1WidthSpecialSizes(con,3,pnarray(n), m1width, m2width)
											m1width=m1width
									end if
									if left(rs("baselength"),4)="Spec" then
											call getComponent1LengthSpecialSizes(con,3,pnarray(n), m1length, m2length)
											m1length=m1length
									end if
									dimensionsarray(itemcount)=m1width & "x" & m1length & "x" & depth & "cm"
									cubicmetersarray(itemcount)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
									weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
									
									weightarray(itemcount)=round(weightcalc)
									if rs("baseprice")<>"" and NOT ISNULL(rs("baseprice")) then
									componentpricearray(itemcount)=CLng(rs("baseprice"))/2
									end if
									if rs("baseprice")<>"" and NOT ISNULL(rs("baseprice")) then
									totalcost=totalcost+CDbl(componentpricearray(itemcount))
									end if
									'2ND BASE
									itemcount=itemcount+1
									call getComponentSizes(con,3,pnarray(n), m1width, m1length)
									redim preserve componentarray(itemcount)
									redim preserve componentpricearray(itemcount)
									redim preserve dimensionsarray(itemcount)
									redim preserve tarrifarray(itemcount)
									redim preserve weightarray(itemcount)
									redim preserve cubicmetersarray(itemcount)
									if left(rs("basetype"),3)="Nor" then
								    	m2width=CDbl(m1width)/2
										m2length=m1length
									end if
									if left(rs("basetype"),3)="Eas" then
										m2width=m1width
										m2length=CDbl(m1length)-130
									end if
									if left(rs("basewidth"),4)="Spec" then
											call getComponent1WidthSpecialSizes(con,3,pnarray(n), m1width, m2width)
											m2width=m2width
									end if
									if left(rs("baselength"),4)="Spec" then
											call getComponent1LengthSpecialSizes(con,3,pnarray(n), m1length, m2length)
											m2length=m2length
									end if
									dimensionsarray(itemcount)=m2width & "x" & m2length & "x" & depth & "cm"
									'cubicmetersarray(itemcount)=CDbl(m2width) * CDbl(m2length) * CDbl(depth)
									'weightcalc=((CDbl(m2width) * CDbl(m2length)) * CDbl(weight))+0.5
									'weightarray(itemcount)=round(weightcalc)
									
									'tarrifarray(itemcount)=tarrifcode
									componentarray(itemcount)=rs("basesavoirmodel") & " base 1 pc"
									'componentpricearray(itemcount)=CLng(rs("baseprice"))/2
									'totalcost=totalcost+CDbl(componentpricearray(itemcount))
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
							itemcount=itemcount+1
							redim preserve componentarray(itemcount)
							redim preserve componentpricearray(itemcount)
							redim preserve tarrifarray(itemcount)
							redim preserve dimensionsarray(itemcount)
							redim preserve weightarray(itemcount)
							redim preserve cubicmetersarray(itemcount)
							call getComponentSizes(con,5,pnarray(n), m1width, m1length)
							tarrifarray(itemcount)=tarrifcode
							if left(rs("topperwidth"),4)="Spec" then
											call getComponentWidthSpecialSizes(con,5,pnarray(n), m1width)
											m1width=m1width
									end if
									if left(rs("topperlength"),4)="Spec" then
											call getComponentLengthSpecialSizes(con,5,pnarray(n), m1length)
											m1length=m1length
									end if
							dimensionsarray(itemcount)=m1width & "x" & m1length & "x" & depth & "cm"
							cubicmetersarray(itemcount)=CDbl(m1width) * CDbl(m1length) * CDbl(depth)
							weightcalc=((CDbl(m1width) * CDbl(m1length)) * CDbl(weight))+0.5
							weightarray(itemcount)=round(weightcalc)
							if packpegwith=5 then
								componentarray(itemcount)=rs("toppertype") & " & pegboard 2 pc"
							else
								componentarray(itemcount)=rs("toppertype") & "  1 pc"
							end if
							if rs("topperprice")<>"" and not isNull(rs("topperprice")) then
							componentpricearray(itemcount)=rs("topperprice")
							totalcost=totalcost+CDbl(componentpricearray(itemcount))
							end if
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
							
							call getComponentSizes(con,7,pnarray(n), legheight, legfinish)
							components=components & "Legs "
							itemcount=itemcount+1
							redim preserve componentarray(itemcount)
							redim preserve componentpricearray(itemcount)
							redim preserve tarrifarray(itemcount)
							redim preserve dimensionsarray(itemcount)
							redim preserve weightarray(itemcount)
							redim preserve cubicmetersarray(itemcount)
							tarrifarray(itemcount)=tarrifcode
							if left(rs("legheight"),4)="Spec" then
											call getComponentWidthSpecialSizes(con,7,pnarray(n), m1height)
											legheight=m1height
									end if
							dimensionsarray(itemcount)="22 x 42 x 27cm"
							cubicmetersarray(itemcount)=24948
							weightcalc=((CDbl(legno) * 27 * CDbl(weight))/1000)+0.5
							weightarray(itemcount)=round(weightcalc)
							componentarray(itemcount)=" Legs (" & legno & ") and Fittings 1 box"
							if rs("legprice")<>"" and NOT ISNULL(rs("legprice")) then
							componentpricearray(itemcount)=rs("legprice")
							totalcost=totalcost+CDbl(componentpricearray(itemcount))
							end if
							
						end if
						if rs("componentid")="8" then
						Set rs2 = getMysqlQueryRecordSet("Select * from componentdata where componentid=8 and componentname = '" & rs("headboardstyle") & "'", con)
							If not rs2.eof then
									weight=rs2("weight")
									tarrifcode=rs2("TARIFFCODE")
									depth=rs2("depth")
							end if
							rs2.close
							set rs2=nothing 
							components=components & "Headboard "
							itemcount=itemcount+1
							redim preserve componentarray(itemcount)
							redim preserve componentpricearray(itemcount)
							redim preserve dimensionsarray(itemcount)
							redim preserve weightarray(itemcount)
							redim preserve tarrifarray(itemcount)
							redim preserve cubicmetersarray(itemcount)
							tarrifarray(itemcount)=tarrifcode
							if rs("headboardWidth")<>"" then 
								hbwidth=rs("headboardWidth")
								else
								if hbwidth="" then hbwidth=getHbWidth(con,pnarray(n))
								if hbwidth="" then hbwidth=0
							end if
							if hbwidth<>"" then
							dimensionsarray(itemcount)=hbwidth & "x" & rs("headboardheight") & " "
							else
							dimensionsarray(itemcount)=rs("headboardheight") & " "
							end if
						
							'response.Write("hbwidth=" & hbwidth & " pn=" & pnarray(n))
							'if trim(hbwidth)="" then hbwidth=0
							'hbwidth=1
							'response.Write("<br>hbwidth=" & hbwidth)
							'response.End()
							if left(rs("headboardheight"),4)="Spec" then
							'cubicmetersarray(itemcount)="Height unknown " & cleantonumber(hbwidth) * CDbl(depth)
							else
							'cubicmetersarray(itemcount)=CDbl(hbwidth) * cleantonumber(rs("headboardheight")) * CDbl(depth)
							end if
							if hbwidth<>"n" then
							weightcalc=((cleantonumber(hbwidth)) * CDbl(weight))+0.5
							end if
							weightarray(itemcount)=round(weightcalc)
							if packpegwith=8 then
								componentarray(itemcount)=rs("headboardstyle") & " Headboard & pegboard 2 pc"
							else
								componentarray(itemcount)=rs("headboardstyle") & " Headboard 1 pc"
							end if
							if rs("headboardprice")<>"" and NOT ISNULL(rs("headboardprice")) then
							componentpricearray(itemcount)=rs("headboardprice")
							totalcost=totalcost+CDbl(componentpricearray(itemcount))
							end if
							
						end if
						if rs("componentid")="9" then 
							components=components & "Accessories "
							itemcount=itemcount+1
							redim preserve componentarray(itemcount)
							redim preserve componentpricearray(itemcount)
							redim preserve dimensionsarray(itemcount)
							redim preserve weightarray(itemcount)
							redim preserve tarrifarray(itemcount)
							redim preserve cubicmetersarray(itemcount)
							tarrifarray(itemcount)="-"
							dimensionsarray(itemcount)="-"
							cubicmetersarray(itemcount)="-"
							weightcalc="-"
							weightarray(itemcount)=weightcalc
							componentarray(itemcount)="Accessories"
							if rs("accessoriestotalcost")<>"" and NOT ISNULL(rs("accessoriestotalcost")) then
							componentpricearray(itemcount)=rs("accessoriestotalcost")
							totalcost=totalcost+CDbl(componentpricearray(itemcount))
							end if
							
						end if
						if hasvalance="y" and valanceonly="y" then
							if rs("componentid")="6" then 
								components=components & "Valance "
								itemcount=itemcount+1
								redim preserve componentarray(itemcount)
								redim preserve componentpricearray(itemcount)
								redim preserve tarrifarray(itemcount)
								redim preserve dimensionsarray(itemcount)
								redim preserve weightarray(itemcount)
								redim preserve cubicmetersarray(itemcount)
								call getComponentSizes(con,6,pnarray(n), m1width, m1length)
								tarrifarray(itemcount)="-"
								dimensionsarray(itemcount)="22 x 42 x 27cm"
								cubicmetersarray(itemcount)="-"
								'weightcalc=(CDbl(m1width) * CDbl(m1length)) * CDbl(weight)
								weightarray(itemcount)="-"
								componentarray(itemcount)="Valance 1 pc"
								if rs("valanceprice")<>"" and NOT ISNULL(rs("valanceprice")) then
								componentpricearray(itemcount)=rs("valanceprice")
								totalcost=totalcost+CDbl(componentpricearray(itemcount))
								end if
								
							end if
						end if
%>