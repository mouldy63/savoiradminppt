<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, dateasc, orderasc, customerasc, coasc, datefrom, datefromstr, datetostr, dateto, dateto1, user, rs2, rs3, receiptasc, amttotal, currencysym, ordervaltotal, totalpayments, totalos, location, payasc, londonmatt1, londonmatt2, londonmatt3, londonmatt4, londonmattFrench, londonmattState, prodlondonmatt1, prodlondonmatt2, prodlondonmatt3, prodlondonmatt4, prodlondonmatt5, prodlondonmattFrench, prodlondonmattState, londonmatt1OB, londonmatt2OB, londonmatt3OB, londonmatt4OB, londonmatt5OB, londonmattFrenchOB, londonmattStateOB, cardiffmatt1, cardiffmatt2, cardiffmatt3, cardiffmatt4, cardiffmatt5, cardiffmattFrench, cardiffmattState, prodcardiffmatt1, prodcardiffmatt2, prodcardiffmatt3, prodcardiffmatt4, prodcardiffmatt5, prodcardiffmattFrench, prodcardiffmattState, cardiffmatt1OB, cardiffmatt2OB, cardiffmatt3OB, cardiffmatt4OB, cardiffmatt5OB, cardiffmattFrenchOB, cardiffmattStateOB, londonbase1, londonbase2, londonbase3, londonbase4, londonbase5, londonbasePlat, londonbaseSlim, londonbaseState, londonbasePeg, cardiffbasePeg, prodlondonbase1, prodlondonbase2, prodlondonbase3, prodlondonbase4, prodlondonbase5, prodlondonbasePlat, prodlondonbaseSlim, prodlondonbaseState, prodlondonbasePeg, londonbase1OB, londonbase2OB, londonbase3OB, londonbase4OB, londonbase5OB, londonbasePlatOB, londonbaseSlimOB, londonbaseStateOB, londonbasePegOB, cardiffbasePegOB, cardiffbase1, cardiffbase2, cardiffbase3, cardiffbase4, cardiffbase5, cardiffbasePlat, cardiffbaseSlim, cardiffbaseState, prodcardiffbase1, prodcardiffbase2, prodcardiffbase3, prodcardiffbase4, prodcardiffbase5, prodcardiffbasePlat, prodcardiffbaseSlim, prodcardiffbaseState,  prodcardiffbasePeg, cardiffbase1OB, cardiffbase2OB, cardiffbase3OB, cardiffbase4OB, cardiffbase5OB, cardiffbasePlatOB, cardiffbaseSlimOB, cardiffbaseStateOB, londonhb, cardiffhb, prodlondonhb, prodcardiffhb, londontoppers, cardifftoppers, Cardiffmattressfinished, LondonmattressNotfinished, CardiffmattressNotfinished, cardiffcwtopper, cardiffhcatopper, cardiffhwtopper, prodcardiffcwtopper, prodcardiffhcatopper, prodcardiffhwtopper, prodcardiffcwtopperOnly, prodcardiffhcatopperOnly, prodcardiffhwtopperOnly, cardiffcwtopperOB, cardiffhcatopperOB, cardiffhwtopperOB, cardiffcwtopperOBOnly, cardiffhcatopperOBOnly, cardiffhwtopperOBOnly, londoncwtopper, londonhcatopper, londonhwtopper, londoncwtopperOnly, londonhcatopperOnly, londonhwtopperOnly, cardiffcwtopperOnly, cardiffhcatopperOnly, cardiffhwtopperOnly, prodlondoncwtopper, prodlondonhcatopper, prodlondonhwtopper,  prodlondoncwtopperOnly, prodlondonhcatopperOnly, prodlondonhwtopperOnly, londoncwtopperOB, londonhcatopperOB, londonhwtopperOB, londoncwtopperOBOnly, londonhcatopperOBOnly, londonhwtopperOBOnly, totalLontoppers,totalCartoppers, prodtotalLontoppers, prodtotalCartoppers, mattressLondonOB, londonhbOB, cardiffhbOB, londontoppersOB, totalLontoppersOB, cardifftoppersOB, totalCartoppersOB, prodlondontoppers, prodcardifftoppers, prodlondonlegs, prodcardifflegs, londonlegs,cardifflegs, londonlegsOB,cardifflegsOB, prodlondonmattsql, prodcardiffmattsql, prodlondonbasesql, prodcardiffbasesql, prodlondontoppersql, prodcardifftoppersql, prodtotalLontoppersql, prodlondontoppersOnlysql, prodcardifftopperonlysql, prodlondonlegssql, prodcardifflegssql, prodlondonhbsql, prodcardiffhbsql, londonmattsql, cardiffmattsql, londontoppersql, londonbasesql, cardiffbasesql, cardifftoppersql, londontoppersOnlysql, cardifftoppersOnlysql, londonlegssql, cardifflegssql, londonhbsql, cardiffhbsql, londonmattOBsql, cardiffmattOBsql, londonbaseOBsql, cardiffbaseOBsql, londontopperOBsql, cardifftopperOBsql, londonhcatopperOBOnlysql, cardiffhcatopperOBOnlysql, cardifflegsOBsql, londonlegsOBsql, londonhbOBsql, cardiffhbOBsql, acardiffNo, cardiffNoW, cardiffNoCR, cardiffNoPF, cardiffNoSC, alondonNo, londonNoW, londonNoCR, londonNoPF, londonNoSC, londonNoLC, londoncfvtopper, cardiffcfvtopper, londoncfvtopperOnly, cardiffcfvtopperOnly, londonmatt5, prodlondoncfvtopper, prodlondoncfvtopperOnly, prodcardiffcfvtopperOnly, prodcardiffcfvtopper, londoncfvtopperOB,  cardiffcfvtopperOB, cardiffcfvtopperOBOnly, londoncfvtopperOBOnly, csvtitle, prodsql
londoncwtopperOnly=0
londonhcatopperOnly=0
londonhwtopperOnly=0
londoncfvtopperOnly=0
cardiffcfvtopperOnly=0
cardiffcwtopperOnly=0
cardiffhcatopperOnly=0
cardiffhwtopperOnly=0
prodlondonlegs=0
prodcardifflegs=0
londonlegs=0
cardifflegs=0
londonlegsOB=0
cardifflegsOB=0
prodcardifftoppers=0
prodlondontoppers=0
totalCartoppersOB=0
cardifftoppersOB=0
totalLontoppersOB=0
londontoppersOB=0
cardiffhbOB=0
londonhbOB=0
mattressLondonOB=0
londonbase1OB=0
londonbase2OB=0
londonbase3OB=0
londonbase4OB=0
londonbase5OB=0
londonbasePegOB=0
londonbasePlatOB=0
londonbaseSlimOB=0
londonbaseStateOB=0
cardiffbase1OB=0
cardiffbase2OB=0
cardiffbase3OB=0
cardiffbase4OB=0
cardiffbase5OB=0
cardiffbasePegOB=0
cardiffbasePlatOB=0
cardiffbaseSlimOB=0
cardiffbaseStateOB=0
londonmatt1=0
londonmatt2=0
londonmatt3=0
londonmatt4=0
londonmatt5=0
londonmattFrench=0
londonmattState=0
prodlondonmatt1=0
prodlondonmatt2=0
prodlondonmatt3=0
prodlondonmatt4=0
prodlondonmatt5=0
prodlondonmattFrench=0
prodlondonmattState=0
londonmatt1OB=0
londonmatt2OB=0
londonmatt3OB=0
londonmatt4OB=0
londonmatt5OB=0
londonmattFrenchOB=0
londonmattStateOB=0
cardiffmatt1=0
cardiffmatt2=0
cardiffmatt3=0
cardiffmatt4=0
cardiffmatt5=0
cardiffmattFrench=0
cardiffmattState=0
prodcardiffmatt1=0
prodcardiffmatt2=0
prodcardiffmatt3=0
prodcardiffmatt4=0
prodcardiffmatt5=0
prodcardiffmattFrench=0
prodcardiffmattState=0
cardiffmatt1OB=0
cardiffmatt2OB=0
cardiffmatt3OB=0
cardiffmatt4OB=0
cardiffmatt5OB=0
cardiffmattFrenchOB=0
cardiffmattStateOB=0
londonbase1=0
londonbase2=0
londonbase3=0
londonbase4=0
londonbase5=0
londonbasePeg=0
londonbasePlat=0
londonbaseSlim=0
londonbaseState=0
cardiffbase1=0
cardiffbase2=0
cardiffbase3=0
cardiffbase4=0
cardiffbase5=0
cardiffbasePeg=0
cardiffbasePlat=0
cardiffbaseSlim=0
cardiffbaseState=0
prodlondonbase1=0
prodlondonbase2=0
prodlondonbase3=0
prodlondonbase4=0
prodlondonbase5=0
prodlondonbasePlat=0
prodlondonbaseSlim=0
prodlondonbasePeg=0
prodlondonbaseState=0
prodcardiffbase1=0
prodcardiffbase2=0
prodcardiffbase3=0
prodcardiffbase4=0
prodcardiffbase5=0
prodcardiffbasePeg=0
prodcardiffbasePlat=0
prodcardiffbaseSlim=0
prodcardiffbaseState=0
londonhb=0
cardiffhb=0
prodlondonhb=0
prodcardiffhb=0
cardiffcwtopper=0
cardiffhcatopper=0
cardiffhwtopper=0
cardiffcfvtopper=0
prodcardiffcwtopper=0
prodcardiffhcatopper=0
prodcardiffhwtopper=0
prodcardiffcfvtopper=0
prodcardiffcwtopperOnly=0
prodcardiffhcatopperOnly=0
prodcardiffhwtopperOnly=0
prodcardiffcfvtopperOnly=0
cardiffcwtopperOB=0
cardiffhcatopperOB=0
cardiffhwtopperOB=0
cardiffcfvtopperOB=0
cardiffcwtopperOBOnly=0
cardiffhcatopperOBOnly=0
cardiffhwtopperOBOnly=0
cardiffcfvtopperOBOnly=0
londoncwtopper=0
londonhcatopper=0
londonhwtopper=0
londoncfvtopper=0
prodlondoncwtopper=0
prodlondonhcatopper=0
prodlondonhwtopper=0
prodlondoncfvtopper=0
prodlondoncwtopperOnly=0
prodlondonhcatopperOnly=0
prodlondonhwtopperOnly=0
prodlondoncfvtopperOnly=0
londoncwtopperOB=0
londonhcatopperOB=0
londonhwtopperOB=0
londoncfvtopperOB=0
londoncwtopperOBOnly=0
londonhcatopperOBOnly=0
londonhwtopperOBOnly=0
londoncfvtopperOBOnly=0
londontoppers=0
cardifftoppers=0
Cardiffmattressfinished=0
LondonmattressNotfinished=0
CardiffmattressNotfinished=0
totalLontoppers=0
totalCartoppers=0
prodtotalLontoppers=0
prodtotalCartoppers=0
location=""
location=request("location")
Set Con = getMysqlConnection()

datefromstr=Request("datefrom")
If datefromstr <>"" then
datefrom=year(datefromstr) & "-" & month(datefromstr) & "-" & day(datefromstr)
end if
datetostr=Request("dateto")
If datetostr <>"" then
dateto=year(datetostr) & "-" & month(datetostr) & "-" & day(datetostr)
end if

count=0

sql="Select NoItemsWeek, WoodworkNoItems, CuttingRoomNoItems, ProductionFloorNoItems, SpringCompletionNoItems,manufacturedatid from manufacturedat"
Set rs = getMysqlQueryRecordSet(sql , con)
Do until rs.eof
	if rs("manufacturedatid")=1 then 
		acardiffNo=rs("NoItemsWeek")
		cardiffNoW=rs("WoodworkNoItems")
		cardiffNoCR=rs("CuttingRoomNoItems")
		cardiffNoPF=rs("ProductionFloorNoItems")
		cardiffNoSC=rs("SpringCompletionNoItems")
	end if
	if rs("manufacturedatid")=2 then 
		alondonNo=rs("NoItemsWeek")
		londonNoW=rs("WoodworkNoItems")
		londonNoCR=rs("CuttingRoomNoItems")
		londonNoPF=rs("ProductionFloorNoItems")
		londonNoSC=rs("SpringCompletionNoItems")
	end if
	rs.movenext
loop
rs.close
set rs=nothing
submit=Request("submit") 
if submit<>"" then
acardiffNo=request("acardiffNo")
cardiffNoW=request("cardiffNoW")
cardiffNoCR=request("cardiffNoCR")
cardiffNoPF=request("cardiffNoPF")
cardiffNoSC=request("cardiffNoSC")
alondonNo=request("alondonNo")
londonNoW=request("londonNoW")
londonNoCR=request("londonNoCR")
londonNoPF=request("londonNoPF")
londonNoSC=request("londonNoSC")
'update new items per week if changed
sql="Select NoItemsWeek, WoodworkNoItems, CuttingRoomNoItems, ProductionFloorNoItems, SpringCompletionNoItems,manufacturedatid from manufacturedat"
Set rs = getMysqlUpdateRecordSet(sql , con)
Do until rs.eof
	if rs("manufacturedatid")=1 then 
		rs("NoItemsWeek")=acardiffNo
		rs("WoodworkNoItems")=cardiffNoW
		rs("CuttingRoomNoItems")=cardiffNoCR
		rs("ProductionFloorNoItems")=cardiffNoPF
		rs("SpringCompletionNoItems")=cardiffNoSC
	end if
	if rs("manufacturedatid")=2 then 
		rs("NoItemsWeek")=alondonNo
		rs("WoodworkNoItems")=londonNoW
		rs("CuttingRoomNoItems")=londonNoCR
		rs("ProductionFloorNoItems")=londonNoPF
		rs("SpringCompletionNoItems")=londonNoSC
	end if
	rs.movenext
	loop
rs.close
set rs=nothing

sql="Select savoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=2  and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "' group by P.savoirmodel"
'response.Write(sql)
'response.End()
londonmattsql="Select P.purchase_no, mattresswidth as w, mattresslength as l, order_number, savoirmodel as n, mattressinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=2  and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then londonmatt1=rs("n")
						if rs("savoirmodel")="No. 2" then londonmatt2=rs("n")
						if rs("savoirmodel")="No. 3" then londonmatt3=rs("n")
						if rs("savoirmodel")="No. 4" then londonmatt4=rs("n")
						if rs("savoirmodel")="No. 4v" then londonmatt5=rs("n")
						if rs("savoirmodel")="French Mattress" then londonmattFrench=rs("n")
						if rs("savoirmodel")="State" then londonmattState=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select savoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=2  and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' group by P.savoirmodel"
'response.Write(sql)
'response.End()
prodlondonmattsql="Select P.purchase_no, mattresswidth as w, mattresslength as l, P.mattressprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, order_number, savoirmodel as n, mattressinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=2  and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' order by P.order_number"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then prodlondonmatt1=rs("n")
						if rs("savoirmodel")="No. 2" then prodlondonmatt2=rs("n")
						if rs("savoirmodel")="No. 3" then prodlondonmatt3=rs("n")
						if rs("savoirmodel")="No. 4" then prodlondonmatt4=rs("n")
						if rs("savoirmodel")="No. 4v" then prodlondonmatt5=rs("n")
						if rs("savoirmodel")="French Mattress" then prodlondonmattFrench=rs("n")
						if rs("savoirmodel")="State" then prodlondonmattState=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select savoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20)  group by P.savoirmodel"
'response.Write(sql)
'response.End()
londonmattOBsql="Select P.purchase_no, mattresswidth as w, mattresslength as l, P.mattressprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, order_number, savoirmodel as n, mattressinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then londonmatt1OB=rs("n")
						if rs("savoirmodel")="No. 2" then londonmatt2OB=rs("n")
						if rs("savoirmodel")="No. 3" then londonmatt3OB=rs("n")
						if rs("savoirmodel")="No. 4" then londonmatt4OB=rs("n")
						if rs("savoirmodel")="No. 4v" then londonmatt5OB=rs("n")
						if rs("savoirmodel")="French Mattress" then londonmattFrenchOB=rs("n")
						if rs("savoirmodel")="State" then londonmattStateOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select savoirmodel,  count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "' group by P.savoirmodel"
'response.Write(sql)
'response.End()
cardiffmattsql="Select P.purchase_no, mattresswidth as w, mattresslength as l, P.mattressprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, order_number, savoirmodel as n, mattressinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then cardiffmatt1=rs("n")
						if rs("savoirmodel")="No. 2" then cardiffmatt2=rs("n")
						if rs("savoirmodel")="No. 3" then cardiffmatt3=rs("n")
						if rs("savoirmodel")="No. 4" then cardiffmatt4=rs("n")
						if rs("savoirmodel")="No. 4v" then cardiffmatt5=rs("n")
						if rs("savoirmodel")="French Mattress" then cardiffmattFrench=rs("n")
						if rs("savoirmodel")="State" then cardiffmattState=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select savoirmodel,  count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=1 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' group by P.savoirmodel"
'response.Write(sql)
'response.End()
prodcardiffmattsql="Select P.purchase_no, mattresswidth as w, mattresslength as l, P.mattressprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, order_number, savoirmodel as n, mattressinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=1  and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then prodcardiffmatt1=rs("n")
						if rs("savoirmodel")="No. 2" then prodcardiffmatt2=rs("n")
						if rs("savoirmodel")="No. 3" then prodcardiffmatt3=rs("n")
						if rs("savoirmodel")="No. 4" then prodcardiffmatt4=rs("n")
						if rs("savoirmodel")="No. 4v" then prodcardiffmatt5=rs("n")
						if rs("savoirmodel")="French Mattress" then prodcardiffmattFrench=rs("n")
						if rs("savoirmodel")="State" then prodcardiffmattState=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

												
sql="Select savoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=1 and P.code<>15919 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) group by P.savoirmodel"
'response.Write(sql)
'response.End()
cardiffmattOBsql="Select P.purchase_no, mattresswidth as w, mattresslength as l, P.mattressprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, order_number, savoirmodel as n, mattressinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=1 and P.code<>15919 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20)"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then cardiffmatt1OB=rs("n")
						if rs("savoirmodel")="No. 2" then cardiffmatt2OB=rs("n")
						if rs("savoirmodel")="No. 3" then cardiffmatt3OB=rs("n")
						if rs("savoirmodel")="No. 4" then cardiffmatt4OB=rs("n")
						if rs("savoirmodel")="No. 4v" then cardiffmatt5OB=rs("n")
						if rs("savoirmodel")="French Mattress" then cardiffmattFrenchOB=rs("n")
						if rs("savoirmodel")="State" then cardiffmattStateOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
											
sql="Select basesavoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=2 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "' group by P.basesavoirmodel"
'response.Write(sql)
'response.End()
londonbasesql="Select P.purchase_no, basewidth as w, baselength as l, (COALESCE(P.baseprice,0) + COALESCE(P.upholsteryprice,0) + (COALESCE(P.basetrimprice,0) + COALESCE(P.basedrawersprice,0) + COALESCE(P.basefabricprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, order_number, basesavoirmodel as n, baseinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=2 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("basesavoirmodel")="No. 1" then londonbase1=rs("n")
						if rs("basesavoirmodel")="No. 2" then londonbase2=rs("n")
						if rs("basesavoirmodel")="No. 3" then londonbase3=rs("n")
						if rs("basesavoirmodel")="No. 4" then londonbase4=rs("n")
						if rs("basesavoirmodel")="No. 4v" then londonbase5=rs("n")
						if rs("basesavoirmodel")="Pegboard" then londonbasePeg=rs("n")
						if rs("basesavoirmodel")="Platform Base" then londonbasePlat=rs("n")
						if rs("basesavoirmodel")="Savoir Slim" then londonbaseSlim=rs("n")
						if rs("basesavoirmodel")="State" then londonbaseState=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select basesavoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=2 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' group by P.basesavoirmodel"
'response.Write(sql)
'response.End()
prodlondonbasesql="Select P.purchase_no, basewidth as w, baselength as l, (COALESCE(P.baseprice,0) + COALESCE(P.upholsteryprice,0) + COALESCE(P.basetrimprice,0) + COALESCE(P.basedrawersprice,0) + COALESCE(P.basefabricprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, order_number, basesavoirmodel as n, baseinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=2 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("basesavoirmodel")="No. 1" then prodlondonbase1=rs("n")
						if rs("basesavoirmodel")="No. 2" then prodlondonbase2=rs("n")
						if rs("basesavoirmodel")="No. 3" then prodlondonbase3=rs("n")
						if rs("basesavoirmodel")="No. 4" then prodlondonbase4=rs("n")
						if rs("basesavoirmodel")="No. 4v" then prodlondonbase5=rs("n")
						if rs("basesavoirmodel")="Pegboard" then prodlondonbasePeg=rs("n")
						if rs("basesavoirmodel")="Platform Base" then prodlondonbasePlat=rs("n")
						if rs("basesavoirmodel")="Savoir Slim" then prodlondonbaseSlim=rs("n")
						if rs("basesavoirmodel")="State" then prodlondonbaseState=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
												
sql="Select basesavoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919 group by P.basesavoirmodel"
'response.Write(sql)
'response.End()
londonbaseOBsql="Select P.purchase_no, basewidth as w, baselength as l, (COALESCE(P.baseprice,0) + COALESCE(P.upholsteryprice,0) + COALESCE(P.basetrimprice,0) + COALESCE(P.basedrawersprice,0) + COALESCE(P.basefabricprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, order_number, basesavoirmodel as n, baseinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("basesavoirmodel")="No. 1" then londonbase1OB=rs("n")
						if rs("basesavoirmodel")="No. 2" then londonbase2OB=rs("n")
						if rs("basesavoirmodel")="No. 3" then londonbase3OB=rs("n")
						if rs("basesavoirmodel")="No. 4" then londonbase4OB=rs("n")
						if rs("basesavoirmodel")="No. 4v" then londonbase5OB=rs("n")
						if rs("basesavoirmodel")="Pegboard" then londonbasePegOB=rs("n")
						if rs("basesavoirmodel")="Platform Base" then londonbasePlatOB=rs("n")
						if rs("basesavoirmodel")="Savoir Slim" then londonbaseSlimOB=rs("n")
						if rs("basesavoirmodel")="State" then londonbaseStateOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select basesavoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "' group by P.basesavoirmodel"
'response.Write(sql)
'response.End()
cardiffbasesql="Select P.purchase_no, basewidth as w, baselength as l, (COALESCE(P.baseprice,0) + COALESCE(P.upholsteryprice,0) + COALESCE(P.basetrimprice,0) + COALESCE(P.basedrawersprice,0) + COALESCE(P.basefabricprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, order_number, basesavoirmodel as n, baseinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("basesavoirmodel")="No. 1" then cardiffbase1=rs("n")
						if rs("basesavoirmodel")="No. 2" then cardiffbase2=rs("n")
						if rs("basesavoirmodel")="No. 3" then cardiffbase3=rs("n")
						if rs("basesavoirmodel")="No. 4" then cardiffbase4=rs("n")
						if rs("basesavoirmodel")="No. 4v" then cardiffbase5=rs("n")
						if rs("basesavoirmodel")="Pegboard" then cardiffbasePeg=rs("n")
						if rs("basesavoirmodel")="Platform Base" then cardiffbasePlat=rs("n")
						if rs("basesavoirmodel")="Savoir Slim" then cardiffbaseSlim=rs("n")
						if rs("basesavoirmodel")="State" then cardiffbaseState=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing	

						
sql="Select basesavoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=1 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' group by P.basesavoirmodel"
'response.Write(sql)
'response.End()
prodcardiffbasesql="Select P.purchase_no, basewidth as w, baselength as l, (COALESCE(P.baseprice,0) + COALESCE(P.upholsteryprice,0) + COALESCE(P.basetrimprice,0) + COALESCE(P.basedrawersprice,0) + COALESCE(P.basefabricprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, order_number, basesavoirmodel as n, baseinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=1 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("basesavoirmodel")="No. 1" then prodcardiffbase1=rs("n")
						if rs("basesavoirmodel")="No. 2" then prodcardiffbase2=rs("n")
						if rs("basesavoirmodel")="No. 3" then prodcardiffbase3=rs("n")
						if rs("basesavoirmodel")="No. 4" then prodcardiffbase4=rs("n")
						if rs("basesavoirmodel")="No. 4v" then prodcardiffbase5=rs("n")
						if rs("basesavoirmodel")="Pegboard" then prodcardiffbasePeg=rs("n")
						if rs("basesavoirmodel")="Platform Base" then prodcardiffbasePlat=rs("n")
						if rs("basesavoirmodel")="Savoir Slim" then prodcardiffbaseSlim=rs("n")
						if rs("basesavoirmodel")="State" then prodcardiffbaseState=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing	

						
sql="Select basesavoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919 group by P.basesavoirmodel"
'response.Write(sql)
'response.End()
cardiffbaseOBsql="Select P.purchase_no, basewidth as w, baselength as l, (COALESCE(P.baseprice,0) + COALESCE(P.upholsteryprice,0) + COALESCE(P.basetrimprice,0) + COALESCE(P.basedrawersprice,0) + COALESCE(P.basefabricprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, order_number, basesavoirmodel as n, baseinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("basesavoirmodel")="No. 1" then cardiffbase1OB=rs("n")
						if rs("basesavoirmodel")="No. 2" then cardiffbase2OB=rs("n")
						if rs("basesavoirmodel")="No. 3" then cardiffbase3OB=rs("n")
						if rs("basesavoirmodel")="No. 4" then cardiffbase4OB=rs("n")
						if rs("basesavoirmodel")="No. 4v" then cardiffbase5OB=rs("n")
						if rs("basesavoirmodel")="Pegboard" then cardiffbasePegOB=rs("n")
						if rs("basesavoirmodel")="Platform Base" then cardiffbasePlatOB=rs("n")
						if rs("basesavoirmodel")="Savoir Slim" then cardiffbaseSlimOB=rs("n")
						if rs("basesavoirmodel")="Savoir Slim" then cardiffbaseStateOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
																		
sql="Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=2 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
'response.Write(sql)
'response.End()
'londonhbsql="Select P.purchase_no, headboardwidth as w, headboardheight as l, order_number, headboardstyle as n, specialinstructionsheadboard as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=2 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
londonhbsql ="Select P.purchase_no, (COALESCE(P.headboardprice,0) + COALESCE(P.hbfabricprice,0) + COALESCE(P.headboardtrimprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, P.idlocation, P.headboardfabric, P.headboardfabricchoice, P.headboardfabricdesc, headboardwidth as w, headboardheight as l, order_number, headboardstyle as n, specialinstructionsheadboard as x, lx.adminheading from qc_history_latest Q join purchase P on P.purchase_no=Q.purchase_no left join location lx on lx.idlocation = P.idlocation where (P.cancelled is Null or P.cancelled='n') and Q.componentID=8 and Q.madeat=2 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						londonhb=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=2 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
'response.Write(sql)
'response.End()
londonlegssql="Select P.purchase_no, (COALESCE(P.legprice,0) + COALESCE(P.addlegprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, legheight as w, legheight as l, order_number, legstyle as n,legfinish as lf,legheight as lh, specialinstructionslegs as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=2 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						londonlegs=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=2 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
'response.Write(sql)
'response.End()
'prodlondonhbsql="Select P.purchase_no, headboardwidth as w, headboardheight as l, order_number, headboardstyle as n, specialinstructionsheadboard as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=2 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
prodlondonhbsql="Select P.purchase_no, (COALESCE(P.headboardprice,0) + COALESCE(P.hbfabricprice,0) + COALESCE(P.headboardtrimprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, P.idlocation, P.headboardfabric, P.headboardfabricchoice, P.headboardfabricdesc, headboardwidth as w, headboardheight as l, order_number, headboardstyle as n, specialinstructionsheadboard as x, lx.adminheading from qc_history_latest Q join purchase P on P.purchase_no=Q.purchase_no left join location lx on lx.idlocation = P.idlocation where (P.cancelled is Null or P.cancelled='n') and Q.componentID=8 and Q.madeat=2 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"

                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						prodlondonhb=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=2 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
'response.Write(sql)
'response.End()
prodlondonlegssql="Select P.purchase_no, (COALESCE(P.legprice,0) + COALESCE(P.addlegprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, legheight as w, legheight as l, order_number, legstyle as n,legfinish as lf,legheight as lh, specialinstructionslegs as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=2 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						prodlondonlegs=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
												
sql="Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
'response.Write(sql)
'response.End()
'londonhbOBsql="Select P.purchase_no, headboardwidth as w, headboardheight as l, order_number, headboardstyle as n, specialinstructionsheadboard as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
londonhbOBsql ="Select P.purchase_no, (COALESCE(P.headboardprice,0) + COALESCE(P.hbfabricprice,0) + COALESCE(P.headboardtrimprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, P.idlocation, P.headboardfabric, P.headboardfabricchoice, P.headboardfabricdesc, headboardwidth as w, headboardheight as l, order_number, headboardstyle as n, specialinstructionsheadboard as x, lx.adminheading from qc_history_latest Q join purchase P on P.purchase_no=Q.purchase_no left join location lx on lx.idlocation = P.idlocation where (P.cancelled is Null or P.cancelled='n') and Q.componentID=8 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						londonhbOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
'response.Write(sql)
'response.End()
londonlegsOBsql="Select P.purchase_no, (COALESCE(P.legprice,0) + COALESCE(P.addlegprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, legheight as w, legheight as l, order_number, legstyle as n,legfinish as lf,legheight as lh, specialinstructionslegs as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						londonlegsOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
'response.Write(sql)
'response.End()
'cardiffhbsql="Select P.purchase_no, headboardwidth as w, headboardheight as l, order_number, headboardstyle as n, specialinstructionsheadboard as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
cardiffhbsql ="Select P.purchase_no, (COALESCE(P.headboardprice,0) + COALESCE(P.hbfabricprice,0) + COALESCE(P.headboardtrimprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, P.idlocation, P.headboardfabric, P.headboardfabricchoice, P.headboardfabricdesc, headboardwidth as w, headboardheight as l, order_number, headboardstyle as n, specialinstructionsheadboard as x, lx.adminheading from qc_history_latest Q join purchase P on P.purchase_no=Q.purchase_no left join location lx on lx.idlocation = P.idlocation where (P.cancelled is Null or P.cancelled='n') and Q.componentID=8 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						cardiffhb=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

						
sql="Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
'response.Write(sql)
'response.End()
cardifflegssql="Select P.purchase_no, (COALESCE(P.legprice,0) + COALESCE(P.addlegprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, legheight as w, legheight as l, order_number, legstyle as n,legfinish as lf,legheight as lh, specialinstructionslegs as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						cardifflegs=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
							
sql="Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=1 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
'response.Write(sql)
'response.End()
'prodcardiffhbsql="Select P.purchase_no, headboardwidth as w, headboardheight as l, order_number, headboardstyle as n, specialinstructionsheadboard as x from qc_history_latest Q, purchase P where  (P.cancelled is Null or P.cancelled='n') and P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=1 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
prodcardiffhbsql="Select P.purchase_no, (COALESCE(P.headboardprice,0) + COALESCE(P.hbfabricprice,0) + COALESCE(P.headboardtrimprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, P.idlocation, P.headboardfabric, P.headboardfabricchoice, P.headboardfabricdesc, headboardwidth as w, headboardheight as l, order_number, headboardstyle as n, specialinstructionsheadboard as x, lx.adminheading from qc_history_latest Q join purchase P on P.purchase_no=Q.purchase_no left join location lx on lx.idlocation = P.idlocation where (P.cancelled is Null or P.cancelled='n') and Q.componentID=8 and Q.madeat=1 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						prodcardiffhb=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=1 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
'response.Write(sql)
'response.End()
prodcardifflegssql="Select P.purchase_no, (COALESCE(P.legprice,0) + COALESCE(P.addlegprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, legheight as w, legheight as l, order_number, legstyle as n,legfinish as lf,legheight as lh, specialinstructionslegs as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=1 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						prodcardifflegs=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
																	
sql="Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
'response.Write(sql)
'response.End()
'cardiffhbOBsql="Select P.purchase_no, headboardwidth as w, headboardheight as l, P.order_number, P.headboardstyle as n, specialinstructionsheadboard as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
cardiffhbOBsql ="Select P.purchase_no, (COALESCE(P.headboardprice,0) + COALESCE(P.hbfabricprice,0) + COALESCE(P.headboardtrimprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, P.idlocation, P.headboardfabric, P.headboardfabricchoice, P.headboardfabricdesc, headboardwidth as w, headboardheight as l, order_number, headboardstyle as n, specialinstructionsheadboard as x, lx.adminheading from qc_history_latest Q join purchase P on P.purchase_no=Q.purchase_no left join location lx on lx.idlocation = P.idlocation where (P.cancelled is Null or P.cancelled='n') and Q.componentID=8 and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						cardiffhbOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
'response.Write(sql)
'response.End()
cardifflegsOBsql="Select P.purchase_no, (COALESCE(P.legprice,0) + COALESCE(P.addlegprice,0)) as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, legheight as w, legheight as l, order_number, legstyle as n,legfinish as lf,legheight as lh, specialinstructionslegs as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						cardifflegsOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
												
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
londontoppersql="Select P.purchase_no, P.topperprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, topperwidth as w, topperlength as l, p.order_number, p.toppertype as n, specialinstructionstopper as x FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then londoncwtopper=rs("n")
						if rs("toppertype")="HCa Topper" then londonhcatopper=rs("n")
						if rs("toppertype")="HW Topper" then londonhwtopper=rs("n")
						if rs("toppertype")="CFv Topper" then londoncfvtopper=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
londontoppersOnlysql="Select P.purchase_no, P.topperprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, topperwidth as w, topperlength as l, p.order_number, p.toppertype as n, specialinstructionstopper as x FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then londoncwtopperOnly=rs("n")
						if rs("toppertype")="HCa Topper" then londonhcatopperOnly=rs("n")
						if rs("toppertype")="HW Topper" then londonhwtopperOnly=rs("n")
						if rs("toppertype")="CFv Topper" then londoncfvtopperOnly=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
cardifftoppersOnlysql="Select P.purchase_no, P.topperprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, topperwidth as w, topperlength as l, p.order_number, p.toppertype as n, specialinstructionstopper as x FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then cardiffcwtopperOnly=rs("n")
						if rs("toppertype")="HCa Topper" then cardiffhcatopperOnly=rs("n")
						if rs("toppertype")="HW Topper" then cardiffhwtopperOnly=rs("n")
						if rs("toppertype")="CFv Topper" then cardiffcfvtopperOnly=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
												
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
prodlondontoppersql="Select P.purchase_no, P.topperprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, topperwidth as w, topperlength as l, p.order_number, p.toppertype as n, specialinstructionstopper as x FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) order by P.order_number"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then prodlondoncwtopper=rs("n")
						if rs("toppertype")="HCa Topper" then prodlondonhcatopper=rs("n")
						if rs("toppertype")="HW Topper" then prodlondonhwtopper=rs("n")
						if rs("toppertype")="CFv Topper" then prodlondoncfvtopper=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
prodlondontoppersOnlysql="Select P.purchase_no, P.topperprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, topperwidth as w, topperlength as l, p.order_number, p.toppertype as n, specialinstructionstopper as x FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then prodlondoncwtopperOnly=rs("n")
						if rs("toppertype")="HCa Topper" then prodlondonhcatopperOnly=rs("n")
						if rs("toppertype")="HW Topper" then prodlondonhwtopperOnly=rs("n")
						if rs("toppertype")="CFv Topper" then prodlondoncfvtopperOnly=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
prodcardifftopperonlysql="Select P.purchase_no, P.topperprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, topperwidth as w, topperlength as l, p.order_number, p.toppertype as n, specialinstructionstopper as x FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then prodcardiffcwtopperOnly=rs("n")
						if rs("toppertype")="HCa Topper" then prodcardiffhcatopperOnly=rs("n")
						if rs("toppertype")="HW Topper" then prodcardiffhwtopperOnly=rs("n")
						if rs("toppertype")="CFv Topper" then prodcardiffcfvtopperOnly=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
																		
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
londontopperOBsql="Select P.purchase_no, P.topperprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, topperwidth as w, topperlength as l, p.order_number, p.toppertype as n, specialinstructionstopper as x FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then londoncwtopperOB=rs("n")
						if rs("toppertype")="HCa Topper" then londonhcatopperOB=rs("n")
						if rs("toppertype")="HW Topper" then londonhwtopperOB=rs("n")
						if rs("toppertype")="CFv Topper" then londoncfvtopperOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
cardifftoppersql="Select P.purchase_no, P.topperprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, topperwidth as w, topperlength as l, p.order_number, p.toppertype as n, specialinstructionstopper as x FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then cardiffcwtopper=rs("n")
						if rs("toppertype")="HCa Topper" then cardiffhcatopper=rs("n")
						if rs("toppertype")="HW Topper" then cardiffhwtopper=rs("n")
						if rs("toppertype")="CFv Topper" then cardiffcfvtopper=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
prodcardifftoppersql="Select P.purchase_no, P.topperprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, topperwidth as w, topperlength as l, p.order_number, p.toppertype as n, specialinstructionstopper as x FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then prodcardiffcwtopper=rs("n")
						if rs("toppertype")="HCa Topper" then prodcardiffhcatopper=rs("n")
						if rs("toppertype")="HW Topper" then prodcardiffhwtopper=rs("n")
						if rs("toppertype")="CFv Topper" then prodcardiffcfvtopper=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
												
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
cardifftopperOBsql="Select P.purchase_no, P.topperprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, topperwidth as w, topperlength as l, p.order_number, p.toppertype as n, specialinstructionstopper as x FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then cardiffcwtopperOB=rs("n")
						if rs("toppertype")="HCa Topper" then cardiffhcatopperOB=rs("n")
						if rs("toppertype")="HW Topper" then cardiffhwtopperOB=rs("n")
						if rs("toppertype")="CFv Topper" then cardiffcfvtopperOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no NOT  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
cardiffhcatopperOBOnlysql="Select P.purchase_no, P.topperprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, topperwidth as w, topperlength as l, p.order_number, p.toppertype as n, specialinstructionstopper as x FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no NOT  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then cardiffcwtopperOBOnly=rs("n")
						if rs("toppertype")="HCa Topper" then cardiffhcatopperOBOnly=rs("n")
						if rs("toppertype")="HW Topper" then cardiffhwtopperOBOnly=rs("n")
						if rs("toppertype")="CFv Topper" then cardiffcfvtopperOBOnly=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no NOT  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
londonhcatopperOBOnlysql="Select P.purchase_no, P.topperprice as p, P.discount, P.ordercurrency, P.istrade, P.vatrate, topperwidth as w, topperlength as l, p.order_number, p.toppertype, specialinstructionstopper as x as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no NOT  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then londoncwtopperOBOnly=rs("n")
						if rs("toppertype")="HCa Topper" then londonhcatopperOBOnly=rs("n")
						if rs("toppertype")="HW Topper" then londonhwtopperOBOnly=rs("n")
						if rs("toppertype")="CFv Topper" then londoncfvtopperOBOnly=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
																	
sql="Select * FROM qc_history_latest Q, purchase P WHERE (p.cancelled is Null or p.cancelled='n') and  P.purchase_no=Q.purchase_no and P.code<>15919 and Q.componentid=5  and Q.madeat=2 and finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
'response.Write(sql)
 Set rs = getMysqlQueryRecordSet(sql , con)
						londontoppers=rs.recordcount
						totalLontoppers=londontoppers-(CInt(londoncwtopper)+CInt(londonhcatopper)+CInt(londonhwtopper)+CInt(londoncfvtopper))
						rs.close
						set rs=nothing

sql="Select * FROM qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and P.code<>15919 and Q.componentid=5  and Q.madeat=2 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
'response.Write(sql)
 Set rs = getMysqlQueryRecordSet(sql , con)
						prodlondontoppers=rs.recordcount
						prodtotalLontoppers=prodlondontoppers-(CInt(prodlondoncwtopper)+CInt(prodlondonhcatopper)+CInt(prodlondonhwtopper)+CInt(prodlondoncfvtopper))
						rs.close
						set rs=nothing
												
sql="Select * FROM qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentid=5  and Q.madeat=2 and Q.finished is null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
'response.Write(sql)
 Set rs = getMysqlQueryRecordSet(sql , con)
						londontoppersOB=rs.recordcount
						totalLontoppersOB=londontoppersOB-(CInt(londoncwtopperOB)+CInt(londonhcatopperOB)+CInt(londonhwtopperOB)+CInt(londoncfvtopperOB))
						rs.close
						set rs=nothing

sql="Select * FROM qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentid=5 and P.code<>15919 and Q.madeat=1 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
'response.Write(sql)
 Set rs = getMysqlQueryRecordSet(sql , con)
						cardifftoppers=rs.recordcount
						totalCartoppers=cardifftoppers-(CInt(cardiffcwtopper)+CInt(cardiffhcatopper)+CInt(cardiffhwtopper)+CInt(cardiffcfvtopper))
						rs.close
						set rs=nothing
												
sql="Select * FROM qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentid=5 and P.code<>15919 and Q.madeat=1 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
'response.Write(sql)
 Set rs = getMysqlQueryRecordSet(sql , con)
						prodcardifftoppers=rs.recordcount
						prodtotalCartoppers=prodcardifftoppers-(CInt(prodcardiffcwtopper)+CInt(prodcardiffhcatopper)+CInt(prodcardiffhwtopper)+CInt(prodcardiffcfvtopper))
						rs.close
						set rs=nothing
																
sql="Select * FROM qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentid=5  and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
'response.Write(sql)
 Set rs = getMysqlQueryRecordSet(sql , con)
						cardifftoppersOB=rs.recordcount
						totalCartoppersOB=cardifftoppersOB-(CInt(cardiffcwtopperOB)+CInt(cardiffhcatopperOB)+CInt(cardiffhwtopperOB)+CInt(cardiffcfvtopperOB))
						rs.close
						set rs=nothing
												
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
<script src="scripts/keepalive.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<script>
$(function() {
var year = new Date().getFullYear();
$( "#datefrom" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#datefrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#dateto" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'

});
$( "#dateto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});

</script>

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
	
					  
    <div class="content brochure">
			    <div class="one-col head-col">
			<p>Items Produced</p>
<form action="items-produced.asp" method="post" name="form1">
            <table width="530" border="1" cellspacing="2" cellpadding="1" align="right">
              <tr>
                <td colspan="2" rowspan="2" valign="bottom">No of Items Produced in Week</td>
                <td colspan="4">Production Screen Schedule Days from Production complete</td>
              </tr>
              <tr>
                <td align="left" valign="bottom">Woodwork</td>
                <td align="left" valign="bottom">Cutting Room</td>
                <td align="left" valign="bottom">Production Floor</td>
				<td align="left" valign="bottom">Spring Completion</td>
              </tr>
              <tr>
                <td width="63">London</td>
                <td><label for="alondonNo"></label>
                <input name="alondonNo" type="text" id="alondonNo" size="5" value="<%=alondonNo%>"></td>
                <td align="left"><input name="londonNoW" type="text" id="londonNoW" size="5" value="<%=londonNoW%>">
                days <a href="deliveriesbookedwoodwork.asp?madeat=2">VIEW</a></td>
                <td align="left"><input name="londonNoCR" type="text" id="londonNoCR" size="5" value="<%=londonNoCR%>">
                days <a href="deliveriesbookedcuttingroom.asp?madeat=2">VIEW</a></td>
                <td align="left"><input name="londonNoPF" type="text" id="londonNoPF" size="5" value="<%=londonNoPF%>">
                days <a href="deliveriesbooked1.asp?madeat=2">VIEW</a></td>
                <td align="left"><input name="londonNoSC" type="text" id="londonNoSC" size="5" value="<%=londonNoSC%>">
                days <a href="deliveriesbooked1.asp?madeat=2">VIEW</a></td>
              </tr>
              <tr>
                <td>Cardiff</td>
                <td width="82"><input name="acardiffNo" type="text" id="acardiffNo" size="5" value="<%=acardiffNo%>"></td>
                <td width="114" align="left"><input name="cardiffNoW" type="text" id="cardiffNoW" size="5" value="<%=cardiffNoW%>">
                days <a href="deliveriesbookedwoodwork.asp?madeat=1">VIEW</a></td>
                <td width="113" align="left"><input name="cardiffNoCR" type="text" id="cardiffNoCR" size="5" value="<%=cardiffNoCR%>">
                days <a href="deliveriesbookedcuttingroom.asp?madeat=1">VIEW</a></td>
                <td width="106" align="left"><input name="cardiffNoPF" type="text" id="cardiffNoPF" size="5" value="<%=cardiffNoPF%>">
                days <a href="deliveriesbooked1.asp?madeat=1">VIEW</a></td>
                <td width="106" align="left"><input name="cardiffNoSC" type="text" id="cardiffNoSC" size="5" value="<%=cardiffNoSC%>">
				days <a href="deliveriesbooked1.asp?madeat=1">VIEW</a></td>
                
              </tr>
            </table>
<table width="400" border="0" align="center" cellpadding="5" cellspacing="2">
					    <tr>
					      <td><label for="datefrom" id="surname"><strong>Completed date from :</strong><br>
		  <input name="datefrom" type="text" class="text" id="datefrom" size="10" />
					      </label></td>
					      <td><strong>Completed date to: </strong><br>
                          <input name="dateto" type="text" class="text" id="dateto" size="10" /></td>
				        </tr>
                      
					    <tr>
					      <td colspan="2" align="left">				          <span class="row">
					        <input type="submit" name="submit" value="Search Database or Update Items per week"  id="submit" class="button" />
					      </span></td>
	      </tr>
			      </table>
</form>
<%if submit<>"" then%>	
			
          <p>Production Items Produced Report</p>
          <p>Dates: From <%=request("datefrom")%> to <%=request("dateto")%><br>
          </p><table border="0" cellspacing="3" cellpadding="3">
  <tr>
    <td>&nbsp;</td>
    <td colspan="2" align="left" bgcolor="#FFFFFF"><strong>Orders produced</strong>      <br>
      <br>      <strong>Production complete is not null</strong></td>
    <td align="left">&nbsp;</td>
    <td colspan="2" align="left" bgcolor="#FFFFFF"><strong>Items produced</strong>      <br>
      <br>      <strong>Finished date is not null</strong></td>
    <td align="left">&nbsp;</td>
    <td colspan="2" align="left" bgcolor="#FFFFFF"><strong>Order Book</strong>      <br>
      <br>      <strong>Finished date is null</strong></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><strong>London</strong></td>
    <td bgcolor="#FFFFFF"><strong>Cardiff</strong></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><strong>London</strong></td>
    <td bgcolor="#FFFFFF"><strong>Cardiff</strong></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><strong><a href="itemsproducedLoc-csv.asp?factory=2">London</a></strong></td>
    <td bgcolor="#FFFFFF"><strong><a href="itemsproducedLoc-csv.asp?factory=1">Cardiff</a></strong></td>
    </tr>
  <tr>
    <td><strong>Mattresses</strong></td>
    <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="London Mattress Orders Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=prodlondonmattsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form2">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
    <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Mattress Orders Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=prodcardiffmattsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form3">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
    <td>&nbsp;</td>
    
    <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="London Mattress Items Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=londonmattsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form4">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
 <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Mattress Items Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=cardiffmattsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form5">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
    <td>&nbsp;</td>
    
    <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="London Mattress Order Book"
    prodsql=londonmattOBsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form6">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
    <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Mattress Order Book"
    prodsql=cardiffmattOBsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form7">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    </tr>
  <tr>
    <td>No. 1</td>
    <td bgcolor="#FFFFFF"><%=prodlondonmatt1%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffmatt1%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmatt1%></td>
    <td bgcolor="#FFFFFF"><%=cardiffmatt1%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmatt1OB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffmatt1OB%></td>
    </tr>
  <tr>
    <td>No. 2</td>
    <td bgcolor="#FFFFFF"><%=prodlondonmatt2%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffmatt2%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmatt2%></td>
    <td bgcolor="#FFFFFF"><%=cardiffmatt2%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmatt2OB%>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=cardiffmatt2OB%></td>
    </tr>
  <tr>
    <td>No. 3</td>
    <td bgcolor="#FFFFFF"><%=prodlondonmatt3%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffmatt3%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmatt3%></td>
    <td bgcolor="#FFFFFF"><%=cardiffmatt3%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmatt3OB%>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=cardiffmatt3OB%></td>
    </tr>
  <tr>
    <td>No. 4</td>
    <td bgcolor="#FFFFFF"><%=prodlondonmatt4%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffmatt4%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmatt4%></td>
    <td bgcolor="#FFFFFF"><%=cardiffmatt4%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmatt4OB%>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=cardiffmatt4OB%></td>
    </tr>
  <tr>
  <tr>
    <td>No. 4v</td>
    <td bgcolor="#FFFFFF"><%=prodlondonmatt5%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffmatt5%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmatt5%></td>
    <td bgcolor="#FFFFFF"><%=cardiffmatt5%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmatt5OB%>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=cardiffmatt5OB%></td>
    </tr>
  <tr>
    <td>French Mattress</td>
    <td bgcolor="#FFFFFF"><%=prodlondonmattFrench%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffmattFrench%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmattFrench%></td>
    <td bgcolor="#FFFFFF"><%=cardiffmattFrench%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmattFrenchOB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffmattFrenchOB%></td>
    </tr>
  <tr>
    <td>State</td>
    <td bgcolor="#FFFFFF"><%=prodlondonmattState%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffmattState%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmattState%></td>
    <td bgcolor="#FFFFFF"><%=cardiffmattState%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonmattStateOB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffmattStateOB%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
  <tr>
    <td><strong>Box Springs</strong></td>
    
    <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="London Base Orders Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=prodlondonbasesql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form8">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
<td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Base Orders Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=prodcardiffbasesql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form9">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
    <td>&nbsp;</td>
    
     <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="London Base Items Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=londonbasesql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form10">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
<td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Base Items Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=cardiffbasesql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form11">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>

    <td>&nbsp;</td>
    
      <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="London Base Order Book"
    prodsql=londonbaseOBsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form12">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
  <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Base Order Book"
    prodsql=cardiffbaseOBsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form13">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>

    </tr>
  <tr>
    <td>No. 1</td>
    <td bgcolor="#FFFFFF"><%=prodlondonbase1%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffbase1%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbase1%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbase1%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbase1OB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbase1OB%></td>
    </tr>
  <tr>
    <td>No. 2</td>
    <td bgcolor="#FFFFFF"><%=prodlondonbase2%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffbase2%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbase2%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbase2%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbase2OB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbase2OB%></td>
    </tr>
  <tr>
    <td>No. 3</td>
    <td bgcolor="#FFFFFF"><%=prodlondonbase3%>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=prodcardiffbase3%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbase3%>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=cardiffbase3%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbase3OB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbase3OB%></td>
    </tr>
  <tr>
    <td>No. 4</td>
    <td bgcolor="#FFFFFF"><%=prodlondonbase4%>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=prodcardiffbase4%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbase4%>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=cardiffbase4%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbase4OB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbase4OB%></td>
    </tr>
  <tr>
    <td>No. 4v</td>
    <td bgcolor="#FFFFFF"><%=prodlondonbase5%>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=prodcardiffbase5%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbase5%>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=cardiffbase5%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbase5OB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbase5OB%></td>
    </tr>
  <tr>
    <td>Pegboard</td>
    <td bgcolor="#FFFFFF"><%=prodlondonbasePeg%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffbasePeg%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbasePeg%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbasePeg%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbasePegOB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbasePegOB%></td>
    </tr>
  <tr>
    <td>Platform</td>
    <td bgcolor="#FFFFFF"><%=prodlondonbasePlat%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffbasePlat%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbasePlat%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbasePlat%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbasePlatOB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbasePlatOB%></td>
    </tr>
  <tr>
    <td>Savoir Slim</td>
    <td bgcolor="#FFFFFF"><%=prodlondonbaseSlim%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffbaseSlim%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbaseSlim%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbaseSlim%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbaseSlimOB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbaseSlimOB%></td>
    </tr>
  <tr>
    <td>State</td>
    <td bgcolor="#FFFFFF"><%=prodlondonbaseState%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffbaseState%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbaseState%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbaseState%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonbaseStateOB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffbaseStateOB%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
  <tr>
    <td><strong>Toppers Linked with mattress or base</strong></td>
    
     <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="London Toppers (linked) Orders Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=prodlondontoppersql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form14">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
     <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Toppers (linked) Orders Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=prodcardifftoppersql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form15">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
 
    <td>&nbsp;</td>
    
     <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="London Toppers (linked) Items Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=londontoppersql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form16">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
     <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Toppers (linked) Items Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=cardifftoppersql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form17">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
    <td>&nbsp;</td>
    
     <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="London Toppers (linked)  Order Book"
    prodsql=londontopperOBsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form18">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
  <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Toppers (linked)  Order Book"
    prodsql=cardifftopperOBsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form19">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
 
    </tr>
  <tr>
    <td>HCA</td>
    <td bgcolor="#FFFFFF"><%=prodlondonhcatopper%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffhcatopper%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonhcatopper%></td>
    <td bgcolor="#FFFFFF"><%=cardiffhcatopper%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonhcatopperOB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffhcatopperOB%></td>
    </tr>
  <tr>
    <td>HW</td>
    <td bgcolor="#FFFFFF"><%=prodlondonhwtopper%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffhwtopper%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonhwtopper%></td>
    <td bgcolor="#FFFFFF"><%=cardiffhwtopper%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonhwtopperOB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffhwtopperOB%></td>
    </tr>
  <tr>
    <td>CW</td>
    <td bgcolor="#FFFFFF"><%=prodlondoncwtopper%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffcwtopper%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londoncwtopper%></td>
    <td bgcolor="#FFFFFF"><%=cardiffcwtopper%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londoncwtopperOB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffcwtopperOB%></td>
    </tr>
  <tr>
    <td>CFv</td>
    <td bgcolor="#FFFFFF"><%=prodlondoncfvtopper%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffcfvtopper%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londoncfvtopper%></td>
    <td bgcolor="#FFFFFF"><%=cardiffcfvtopper%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londoncfvtopperOB%></td>
    <td bgcolor="#FFFFFF"><%=cardiffcfvtopperOB%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
  <tr>
    <td><strong>Toppers only (no base or mattress)</strong></td>
    
    <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="London Toppers only Orders Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=prodlondontoppersOnlysql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form20">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
    <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Toppers only Orders Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=prodcardifftopperonlysql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form21">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
    <td>&nbsp;</td>
     <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="London Toppers Only Items Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=londontoppersOnlysql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form22">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
     <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Toppers Only Items Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=cardifftoppersOnlysql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form23">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    

    <td>&nbsp;</td>
    
     <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="London Toppers only Order Book"
    prodsql=londonhcatopperOBOnlysql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form24">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
    <td bgcolor="#FFFFFF">
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Toppers only Order Book"
    prodsql=cardiffhcatopperOBOnlysql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form25">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    

    </tr>
  <tr>
    <td>HCA</td>
    <td bgcolor="#FFFFFF"><%=prodlondonhcatopperOnly%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffhcatopperOnly%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonhcatopperOnly%></td>
    <td bgcolor="#FFFFFF"><%=cardiffhcatopperOnly%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonhcatopperOBOnly%></td>
    <td bgcolor="#FFFFFF"><%=cardiffhcatopperOBOnly%></td>
    </tr>
  <tr>
    <td>HW</td>
    <td bgcolor="#FFFFFF"><%=prodlondonhwtopperOnly%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffhwtopperOnly%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonhwtopperOnly%></td>
    <td bgcolor="#FFFFFF"><%=cardiffhwtopperOnly%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonhwtopperOBOnly%></td>
    <td bgcolor="#FFFFFF"><%=cardiffhwtopperOBOnly%></td>
    </tr>
  <tr>
    <td>CW</td>
    <td bgcolor="#FFFFFF"><%=prodlondoncwtopperOnly%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffcwtopperOnly%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londoncwtopperOnly%></td>
    <td bgcolor="#FFFFFF"><%=cardiffcwtopperOnly%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londoncwtopperOBOnly%></td>
    <td bgcolor="#FFFFFF"><%=cardiffcwtopperOBOnly%></td>
    </tr>
  <tr>
    <td>CFv</td>
    <td bgcolor="#FFFFFF"><%=prodlondoncfvtopperOnly%></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffcfvtopperOnly%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londoncfvtopperOnly%></td>
    <td bgcolor="#FFFFFF"><%=cardiffcfvtopperOnly%></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londoncfvtopperOBOnly%></td>
    <td bgcolor="#FFFFFF"><%=cardiffcfvtopperOBOnly%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
  <tr>
    <td><strong>Legs</strong></td>
    
       <td bgcolor="#FFFFFF"><%=prodlondonlegs%>
    <%csvtitle=""
    prodsql=""
    csvtitle="London Leg Orders Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=prodlondonlegssql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form26" style="float:right">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
     <td bgcolor="#FFFFFF"><%=prodcardifflegs%>
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Leg Orders Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=prodcardifflegssql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form27" style="float:right">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>

    <td>&nbsp;</td>
    
       <td bgcolor="#FFFFFF"><%=londonlegs%>
    <%csvtitle=""
    prodsql=""
    csvtitle="London Leg Items Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=londonlegssql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form28" style="float:right">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
     <td bgcolor="#FFFFFF"><%=cardifflegs%>
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Leg Items Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=cardifflegssql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form29" style="float:right">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
    <td>&nbsp;</td>
    
     <td bgcolor="#FFFFFF"><%=londonlegsOB%>
    <%csvtitle=""
    prodsql=""
    csvtitle="London Legs Order Book"
    prodsql=londonlegsOBsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form30" style="float:right">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
 <td bgcolor="#FFFFFF"><%=cardifflegsOB%>
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Legs Order Book"
    prodsql=cardifflegsOBsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form31" style="float:right">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
  <tr>
    <td><strong>Headboards</strong></td>
    
     <td bgcolor="#FFFFFF"><%=prodlondonhb%>
    <%csvtitle=""
    prodsql=""
    csvtitle="London Headboard Orders Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=prodlondonhbsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form32" style="float:right">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
    <td bgcolor="#FFFFFF"><%=prodcardiffhb%>
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Headboard Orders Produced between " & request("datefrom") & " to "  & request("dateto")
    prodsql=prodcardiffhbsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form33" style="float:right">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
   
    <td>&nbsp;</td>
    
     <td bgcolor="#FFFFFF"><%=londonhb%>
    <%csvtitle=""
    prodsql=""
    csvtitle="London Headboard Items Produced betwee " & request("datefrom") & " to "  & request("dateto")
    prodsql=londonhbsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form34" style="float:right">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
     <td bgcolor="#FFFFFF"><%=cardiffhb%>
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Headboard Items Produced betwee " & request("datefrom") & " to "  & request("dateto")
    prodsql=cardiffhbsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form35" style="float:right">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
    <td>&nbsp;</td>
    
     <td bgcolor="#FFFFFF"><%=londonhbOB%>
    <%csvtitle=""
    prodsql=""
    csvtitle="London Headboard Order Book"
    prodsql=londonhbOBsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form35" style="float:right">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>
    
     <td bgcolor="#FFFFFF"><%=cardiffhbOB%>
    <%csvtitle=""
    prodsql=""
    csvtitle="Cardiff Headboard Order Book"
    prodsql=cardiffhbOBsql%>
    <form action="itemsproduced-csv2.asp" method="post" name="form35" style="float:right">
    <input id="title" name="title" type="hidden" value="<%=csvtitle%>">
    <input id="prodsql" name="prodsql" type="hidden" value="<%=prodsql%>">
    <input type="submit" value="CSV">
    </form>&nbsp;</td>


    </tr>
          </table>
          <p>&nbsp;</p>
          <p>
            <%end if%>
          </p>
</form>
        </div>
  </div>
<div>
</div>
        
</body>
</html>

 <%Con.Close
Set Con = Nothing%> 
