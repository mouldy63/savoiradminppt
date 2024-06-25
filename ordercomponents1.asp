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




sql = "select l.componentid, P.customerreference, P.wrappingid, P.mattresswidth, P.mattresslength, P.basewidth, P.baselength, P.order_number, P.savoirmodel, P.basesavoirmodel, P.toppertype, P.Headboardstyle, P.headboardheight, P.mattresstype, P.basetype, P.mattressprice, P.baseprice, P.topperprice, P.topperwidth, P.topperlength, P.valanceprice, P.headboardprice, P.legprice, P.headboardlegqty, P.legsrequired, P.legQty, P.AddLegQty, P.topperrequired, P.headboardrequired, P.accessoriestotalcost, P.total, P.vat, P.vatrate, P.totalexvat, P.mattressrequired, P.baserequired, P.headboardwidth, P.valancewidth, P.valancelength, P.legheight, P.legfinish from exportlinks l, exportcollections e, exportcollshowrooms S, purchase P  where l.purchase_no=" & pnarray(n) & " and l.linkscollectionid=S.exportCollshowroomsID and S.exportCollectionID=e.exportcollectionsid and P.purchase_no=l.purchase_no and e.exportcollectionsid=" & collectionid

Set rs = getMysqlQueryRecordSet(sql , con)



'totalcost=rs("total")
'totalexvat=rs("totalexvat")
'vat=rs("vat")
vatrate=rs("vatrate")
orderno=rs("order_number")
itemcount=0

Do until rs.eof
wrap=rs("wrappingid")					
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
if rs("componentid")="1" then%>
<!-- #include file="mattress-manifest.asp" -->	
<%end if
if rs("componentid")="3" and packpegwith=0 then%>
<!-- #include file="base-manifest.asp" -->	
<%end if
if rs("componentid")="5" then
%>
<!-- #include file="topper-manifest.asp" -->	
<%
end if					
if rs("componentid")="7" then
%>
<!-- #include file="legs-manifest.asp" -->	
<%end if						
if rs("componentid")="8" then
%>
<!-- #include file="hb-manifest.asp" -->	
<%end if						
if rs("componentid")="9" then%>
<!-- #include file="acc-manifest.asp" -->
<%end if
%>
