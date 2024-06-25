<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, dateasc, orderasc, customerasc, coasc, datefrom, datefromstr, datetostr, dateto, dateto1, user, rs2, rs3, receiptasc, amttotal, currencysym, ordervaltotal, totalpayments, totalos, location, payasc, londonmatt1, londonmatt2, londonmatt3, londonmatt4, londonmattFrench, londonmattState, prodlondonmatt1, prodlondonmatt2, prodlondonmatt3, prodlondonmatt4, prodlondonmattFrench, prodlondonmattState, londonmatt1OB, londonmatt2OB, londonmatt3OB, londonmatt4OB, londonmattFrenchOB, londonmattStateOB, cardiffmatt1, cardiffmatt2, cardiffmatt3, cardiffmatt4, cardiffmattFrench, cardiffmattState, prodcardiffmatt1, prodcardiffmatt2, prodcardiffmatt3, prodcardiffmatt4, prodcardiffmattFrench, prodcardiffmattState, cardiffmatt1OB, cardiffmatt2OB, cardiffmatt3OB, cardiffmatt4OB, cardiffmattFrenchOB, cardiffmattStateOB, londonbase1, londonbase2, londonbase3, londonbase4, londonbasePlat, londonbaseSlim, londonbaseState, londonbasePeg, cardiffbasePeg, prodlondonbase1, prodlondonbase2, prodlondonbase3, prodlondonbase4, prodlondonbasePlat, prodlondonbaseSlim, prodlondonbaseState, prodlondonbasePeg, londonbase1OB, londonbase2OB, londonbase3OB, londonbase4OB, londonbasePlatOB, londonbaseSlimOB, londonbaseStateOB, londonbasePegOB, cardiffbasePegOB, cardiffbase1, cardiffbase2, cardiffbase3, cardiffbase4, cardiffbasePlat, cardiffbaseSlim, cardiffbaseState,  prodcardiffbase1, prodcardiffbase2, prodcardiffbase3, prodcardiffbase4, prodcardiffbasePlat, prodcardiffbaseSlim, prodcardiffbaseState,  prodcardiffbasePeg, cardiffbase1OB, cardiffbase2OB, cardiffbase3OB, cardiffbase4OB, cardiffbasePlatOB, cardiffbaseSlimOB, cardiffbaseStateOB, londonhb, cardiffhb, prodlondonhb, prodcardiffhb, londontoppers, cardifftoppers, Cardiffmattressfinished, LondonmattressNotfinished, CardiffmattressNotfinished, cardiffcwtopper, cardiffhcatopper, cardiffhwtopper, prodcardiffcwtopper, prodcardiffhcatopper, prodcardiffhwtopper, prodcardiffcwtopperOnly, prodcardiffhcatopperOnly, prodcardiffhwtopperOnly, cardiffcwtopperOB, cardiffhcatopperOB, cardiffhwtopperOB, cardiffcwtopperOBOnly, cardiffhcatopperOBOnly, cardiffhwtopperOBOnly, londoncwtopper, londonhcatopper, londonhwtopper, londoncwtopperOnly, londonhcatopperOnly, londonhwtopperOnly, cardiffcwtopperOnly,cardiffhcatopperOnly, cardiffhwtopperOnly,  prodlondoncwtopper, prodlondonhcatopper, prodlondonhwtopper,  prodlondoncwtopperOnly, prodlondonhcatopperOnly, prodlondonhwtopperOnly, londoncwtopperOB, londonhcatopperOB, londonhwtopperOB, londoncwtopperOBOnly, londonhcatopperOBOnly, londonhwtopperOBOnly, totalLontoppers,totalCartoppers, prodtotalLontoppers, prodtotalCartoppers, mattressLondonOB, londonhbOB, cardiffhbOB, londontoppersOB, totalLontoppersOB, cardifftoppersOB, totalCartoppersOB, prodlondontoppers, prodcardifftoppers, prodlondonlegs, prodcardifflegs,londonlegs,cardifflegs,londonlegsOB,cardifflegsOB, prodlondonmattsql, prodcardiffmattsql, prodlondonbasesql, prodcardiffbasesql, prodlondontoppersql, prodcardifftoppersql, prodtotalLontoppersql, prodlondontoppersOnlysql, prodcardifftopperonlysql, prodlondonlegssql, prodcardifflegssql, prodlondonhbsql, prodcardiffhbsql, londonmattsql, cardiffmattsql, londontoppersql, londonbasesql, cardiffbasesql, cardifftoppersql, londontoppersOnlysql, cardifftoppersOnlysql, londonlegssql, cardifflegssql, londonhbsql, cardiffhbsql, londonmattOBsql, cardiffmattOBsql, londonbaseOBsql, cardiffbaseOBsql, londontopperOBsql, cardifftopperOBsql, londonhcatopperOBOnlysql, cardiffhcatopperOBOnlysql,cardifflegsOBsql,londonlegsOBsql, londonhbOBsql, cardiffhbOBsql, acardiffNo, cardiffNoW, cardiffNoCR, cardiffNoPF, alondonNo, londonNoW, londonNoCR, londonNoPF
londoncwtopperOnly=0
londonhcatopperOnly=0
londonhwtopperOnly=0
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
londonbasePegOB=0
londonbasePlatOB=0
londonbaseSlimOB=0
londonbaseStateOB=0
cardiffbase1OB=0
cardiffbase2OB=0
cardiffbase3OB=0
cardiffbase4OB=0
cardiffbasePegOB=0
cardiffbasePlatOB=0
cardiffbaseSlimOB=0
cardiffbaseStateOB=0
londonmatt1=0
londonmatt2=0
londonmatt3=0
londonmatt4=0
londonmattFrench=0
londonmattState=0
prodlondonmatt1=0
prodlondonmatt2=0
prodlondonmatt3=0
prodlondonmatt4=0
prodlondonmattFrench=0
prodlondonmattState=0
londonmatt1OB=0
londonmatt2OB=0
londonmatt3OB=0
londonmatt4OB=0
londonmattFrenchOB=0
londonmattStateOB=0
cardiffmatt1=0
cardiffmatt2=0
cardiffmatt3=0
cardiffmatt4=0
cardiffmattFrench=0
cardiffmattState=0
prodcardiffmatt1=0
prodcardiffmatt2=0
prodcardiffmatt3=0
prodcardiffmatt4=0
prodcardiffmattFrench=0
prodcardiffmattState=0
cardiffmatt1OB=0
cardiffmatt2OB=0
cardiffmatt3OB=0
cardiffmatt4OB=0
cardiffmattFrenchOB=0
cardiffmattStateOB=0
londonbase1=0
londonbase2=0
londonbase3=0
londonbase4=0
londonbasePeg=0
londonbasePlat=0
londonbaseSlim=0
londonbaseState=0
cardiffbase1=0
cardiffbase2=0
cardiffbase3=0
cardiffbase4=0
cardiffbasePeg=0
cardiffbasePlat=0
cardiffbaseSlim=0
cardiffbaseState=0
prodlondonbase1=0
prodlondonbase2=0
prodlondonbase3=0
prodlondonbase4=0
prodlondonbasePlat=0
prodlondonbaseSlim=0
prodlondonbasePeg=0
prodlondonbaseState=0
prodcardiffbase1=0
prodcardiffbase2=0
prodcardiffbase3=0
prodcardiffbase4=0
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
prodcardiffcwtopper=0
prodcardiffhcatopper=0
prodcardiffhwtopper=0
prodcardiffcwtopperOnly=0
prodcardiffhcatopperOnly=0
prodcardiffhwtopperOnly=0
cardiffcwtopperOB=0
cardiffhcatopperOB=0
cardiffhwtopperOB=0
cardiffcwtopperOBOnly=0
cardiffhcatopperOBOnly=0
cardiffhwtopperOBOnly=0
londoncwtopper=0
londonhcatopper=0
londonhwtopper=0
prodlondoncwtopper=0
prodlondonhcatopper=0
prodlondonhwtopper=0
prodlondoncwtopperOnly=0
prodlondonhcatopperOnly=0
prodlondonhwtopperOnly=0
londoncwtopperOB=0
londonhcatopperOB=0
londonhwtopperOB=0
londoncwtopperOBOnly=0
londonhcatopperOBOnly=0
londonhwtopperOBOnly=0
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

sql="Select NoItemsWeek, WoodworkNoItems, CuttingRoomNoItems, ProductionFloorNoItems, manufacturedatid from manufacturedat"
Set rs = getMysqlQueryRecordSet(sql , con)
Do until rs.eof
	if rs("manufacturedatid")=1 then 
		acardiffNo=rs("NoItemsWeek")
		cardiffNoW=rs("WoodworkNoItems")
		cardiffNoCR=rs("CuttingRoomNoItems")
		cardiffNoPF=rs("ProductionFloorNoItems")
	end if
	if rs("manufacturedatid")=2 then 
		alondonNo=rs("NoItemsWeek")
		londonNoW=rs("WoodworkNoItems")
		londonNoCR=rs("CuttingRoomNoItems")
		londonNoPF=rs("ProductionFloorNoItems")
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
alondonNo=request("alondonNo")
londonNoW=request("londonNoW")
londonNoCR=request("londonNoCR")
londonNoPF=request("londonNoPF")
'update new items per week if changed
sql="Select NoItemsWeek, WoodworkNoItems, CuttingRoomNoItems, ProductionFloorNoItems, manufacturedatid from manufacturedat"
Set rs = getMysqlUpdateRecordSet(sql , con)
Do until rs.eof
	if rs("manufacturedatid")=1 then 
		rs("NoItemsWeek")=acardiffNo
		rs("WoodworkNoItems")=cardiffNoW
		rs("CuttingRoomNoItems")=cardiffNoCR
		rs("ProductionFloorNoItems")=cardiffNoPF
	end if
	if rs("manufacturedatid")=2 then 
		rs("NoItemsWeek")=alondonNo
		rs("WoodworkNoItems")=londonNoW
		rs("CuttingRoomNoItems")=londonNoCR
		rs("ProductionFloorNoItems")=londonNoPF
	end if
	rs.movenext
	loop
rs.close
set rs=nothing

sql="Select savoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=2  and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "' group by P.savoirmodel"
'response.Write(sql)
'response.End()
londonmattsql="Select order_number, savoirmodel as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=2  and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then londonmatt1=rs("n")
						if rs("savoirmodel")="No. 2" then londonmatt2=rs("n")
						if rs("savoirmodel")="No. 3" then londonmatt3=rs("n")
						if rs("savoirmodel")="No. 4" then londonmatt4=rs("n")
						if rs("savoirmodel")="French Mattress" then londonmattFrench=rs("n")
						if rs("savoirmodel")="State" then londonmattState=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select savoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=2  and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' group by P.savoirmodel"
'response.Write(sql)
'response.End()
prodlondonmattsql="Select order_number, savoirmodel as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=2  and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then prodlondonmatt1=rs("n")
						if rs("savoirmodel")="No. 2" then prodlondonmatt2=rs("n")
						if rs("savoirmodel")="No. 3" then prodlondonmatt3=rs("n")
						if rs("savoirmodel")="No. 4" then prodlondonmatt4=rs("n")
						if rs("savoirmodel")="French Mattress" then prodlondonmattFrench=rs("n")
						if rs("savoirmodel")="State" then prodlondonmattState=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select savoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20)  group by P.savoirmodel"
'response.Write(sql)
'response.End()
londonmattOBsql="Select order_number, savoirmodel as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then londonmatt1OB=rs("n")
						if rs("savoirmodel")="No. 2" then londonmatt2OB=rs("n")
						if rs("savoirmodel")="No. 3" then londonmatt3OB=rs("n")
						if rs("savoirmodel")="No. 4" then londonmatt4OB=rs("n")
						if rs("savoirmodel")="French Mattress" then londonmattFrenchOB=rs("n")
						if rs("savoirmodel")="State" then londonmattStateOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select savoirmodel,  count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "' group by P.savoirmodel"
'response.Write(sql)
'response.End()
cardiffmattsql="Select order_number, savoirmodel as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then cardiffmatt1=rs("n")
						if rs("savoirmodel")="No. 2" then cardiffmatt2=rs("n")
						if rs("savoirmodel")="No. 3" then cardiffmatt3=rs("n")
						if rs("savoirmodel")="No. 4" then cardiffmatt4=rs("n")
						if rs("savoirmodel")="French Mattress" then cardiffmattFrench=rs("n")
						if rs("savoirmodel")="State" then cardiffmattState=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select savoirmodel,  count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=1 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' group by P.savoirmodel"
'response.Write(sql)
'response.End()
prodcardiffmattsql="Select order_number, savoirmodel as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=1  and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then prodcardiffmatt1=rs("n")
						if rs("savoirmodel")="No. 2" then prodcardiffmatt2=rs("n")
						if rs("savoirmodel")="No. 3" then prodcardiffmatt3=rs("n")
						if rs("savoirmodel")="No. 4" then prodcardiffmatt4=rs("n")
						if rs("savoirmodel")="French Mattress" then prodcardiffmattFrench=rs("n")
						if rs("savoirmodel")="State" then prodcardiffmattState=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
												
sql="Select savoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=1 and P.code<>15919 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) group by P.savoirmodel"
'response.Write(sql)
'response.End()
cardiffmattOBsql="Select order_number, savoirmodel as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=1 and P.code<>15919 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20)"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then cardiffmatt1OB=rs("n")
						if rs("savoirmodel")="No. 2" then cardiffmatt2OB=rs("n")
						if rs("savoirmodel")="No. 3" then cardiffmatt3OB=rs("n")
						if rs("savoirmodel")="No. 4" then cardiffmatt4OB=rs("n")
						if rs("savoirmodel")="French Mattress" then cardiffmattFrenchOB=rs("n")
						if rs("savoirmodel")="State" then cardiffmattStateOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select basesavoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=2 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "' group by P.basesavoirmodel"
'response.Write(sql)
'response.End()
londonbasesql="Select order_number, basesavoirmodel as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=2 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("basesavoirmodel")="No. 1" then londonbase1=rs("n")
						if rs("basesavoirmodel")="No. 2" then londonbase2=rs("n")
						if rs("basesavoirmodel")="No. 3" then londonbase3=rs("n")
						if rs("basesavoirmodel")="No. 4" then londonbase4=rs("n")
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
prodlondonbasesql="Select order_number, basesavoirmodel as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=2 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("basesavoirmodel")="No. 1" then prodlondonbase1=rs("n")
						if rs("basesavoirmodel")="No. 2" then prodlondonbase2=rs("n")
						if rs("basesavoirmodel")="No. 3" then prodlondonbase3=rs("n")
						if rs("basesavoirmodel")="No. 4" then prodlondonbase4=rs("n")
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
londonbaseOBsql="Select order_number, basesavoirmodel as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("basesavoirmodel")="No. 1" then londonbase1OB=rs("n")
						if rs("basesavoirmodel")="No. 2" then londonbase2OB=rs("n")
						if rs("basesavoirmodel")="No. 3" then londonbase3OB=rs("n")
						if rs("basesavoirmodel")="No. 4" then londonbase4OB=rs("n")
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
cardiffbasesql="Select order_number, basesavoirmodel as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("basesavoirmodel")="No. 1" then cardiffbase1=rs("n")
						if rs("basesavoirmodel")="No. 2" then cardiffbase2=rs("n")
						if rs("basesavoirmodel")="No. 3" then cardiffbase3=rs("n")
						if rs("basesavoirmodel")="No. 4" then cardiffbase4=rs("n")
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
prodcardiffbasesql="Select order_number, basesavoirmodel as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=1 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("basesavoirmodel")="No. 1" then prodcardiffbase1=rs("n")
						if rs("basesavoirmodel")="No. 2" then prodcardiffbase2=rs("n")
						if rs("basesavoirmodel")="No. 3" then prodcardiffbase3=rs("n")
						if rs("basesavoirmodel")="No. 4" then prodcardiffbase4=rs("n")
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
cardiffbaseOBsql="Select order_number, basesavoirmodel as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("basesavoirmodel")="No. 1" then cardiffbase1OB=rs("n")
						if rs("basesavoirmodel")="No. 2" then cardiffbase2OB=rs("n")
						if rs("basesavoirmodel")="No. 3" then cardiffbase3OB=rs("n")
						if rs("basesavoirmodel")="No. 4" then cardiffbase4OB=rs("n")
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
londonhbsql="Select order_number, headboardstyle as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=2 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
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
londonlegssql="Select order_number, legstyle as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=2 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
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
prodlondonhbsql="Select order_number, headboardstyle as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=2 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
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
prodlondonlegssql="Select order_number, legstyle as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=2 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
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
londonhbOBsql="Select order_number, headboardstyle as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
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
londonlegsOBsql="Select order_number, legstyle as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
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
cardiffhbsql="Select order_number, headboardstyle as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
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
cardifflegssql="Select order_number, legstyle as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=1 and P.code<>15919 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
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
prodcardiffhbsql="Select order_number, headboardstyle as n from qc_history_latest Q, purchase P where  (P.cancelled is Null or P.cancelled='n') and P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=1 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
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
prodcardifflegssql="Select order_number, legstyle as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=1 and P.code<>15919 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
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
cardiffhbOBsql="Select P.order_number, P.headboardstyle as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
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
cardifflegsOBsql="Select order_number, legstyle as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						cardifflegsOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
londontoppersql="Select p.order_number, p.toppertype as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then londoncwtopper=rs("n")
						if rs("toppertype")="HCa Topper" then londonhcatopper=rs("n")
						if rs("toppertype")="HW Topper" then londonhwtopper=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
londontoppersOnlysql="Select p.order_number, p.toppertype as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then londoncwtopperOnly=rs("n")
						if rs("toppertype")="HCa Topper" then londonhcatopperOnly=rs("n")
						if rs("toppertype")="HW Topper" then londonhwtopperOnly=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
cardifftoppersOnlysql="Select p.order_number, p.toppertype as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then cardiffcwtopperOnly=rs("n")
						if rs("toppertype")="HCa Topper" then cardiffhcatopperOnly=rs("n")
						if rs("toppertype")="HW Topper" then cardiffhwtopperOnly=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
prodlondontoppersql="Select p.order_number, p.toppertype as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then prodlondoncwtopper=rs("n")
						if rs("toppertype")="HCa Topper" then prodlondonhcatopper=rs("n")
						if rs("toppertype")="HW Topper" then prodlondonhwtopper=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
prodlondontoppersOnlysql="Select p.order_number, p.toppertype as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then prodlondoncwtopperOnly=rs("n")
						if rs("toppertype")="HCa Topper" then prodlondonhcatopperOnly=rs("n")
						if rs("toppertype")="HW Topper" then prodlondonhwtopperOnly=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
prodcardifftopperonlysql="Select p.order_number, p.toppertype as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then prodcardiffcwtopperOnly=rs("n")
						if rs("toppertype")="HCa Topper" then prodcardiffhcatopperOnly=rs("n")
						if rs("toppertype")="HW Topper" then prodcardiffhwtopperOnly=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
																		
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
londontopperOBsql="Select p.order_number, p.toppertype as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then londoncwtopperOB=rs("n")
						if rs("toppertype")="HCa Topper" then londonhcatopperOB=rs("n")
						if rs("toppertype")="HW Topper" then londonhwtopperOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
cardifftoppersql="Select p.order_number, p.toppertype as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished >= '" & datefrom & "' and q.finished <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then cardiffcwtopper=rs("n")
						if rs("toppertype")="HCa Topper" then cardiffhcatopper=rs("n")
						if rs("toppertype")="HW Topper" then cardiffhwtopper=rs("n")
						
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
prodcardifftoppersql="Select p.order_number, p.toppertype as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "' AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then prodcardiffcwtopper=rs("n")
						if rs("toppertype")="HCa Topper" then prodcardiffhcatopper=rs("n")
						if rs("toppertype")="HW Topper" then prodcardiffhwtopper=rs("n")
						
						rs.movenext
						loop
						rs.close
						set rs=nothing
												
sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
cardifftopperOBsql="Select p.order_number, p.toppertype as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then cardiffcwtopperOB=rs("n")
						if rs("toppertype")="HCa Topper" then cardiffhcatopperOB=rs("n")
						if rs("toppertype")="HW Topper" then cardiffhwtopperOB=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no NOT  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
cardiffhcatopperOBOnlysql="Select p.order_number, p.toppertype as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=1 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no NOT  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then cardiffcwtopperOBOnly=rs("n")
						if rs("toppertype")="HCa Topper" then cardiffhcatopperOBOnly=rs("n")
						if rs("toppertype")="HW Topper" then cardiffhwtopperOBOnly=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

sql="Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no NOT  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by p.toppertype"
'response.Write(sql)
londonhcatopperOBOnlysql="Select p.order_number, p.toppertype as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and P.code<>15919   and q.madeat=2 and q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no NOT  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))"
 Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("toppertype")="CW Topper" then londoncwtopperOBOnly=rs("n")
						if rs("toppertype")="HCa Topper" then londonhcatopperOBOnly=rs("n")
						if rs("toppertype")="HW Topper" then londonhwtopperOBOnly=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
																	
sql="Select * FROM qc_history_latest Q, purchase P WHERE (p.cancelled is Null or p.cancelled='n') and  P.purchase_no=Q.purchase_no and P.code<>15919 and Q.componentid=5  and Q.madeat=2 and finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
'response.Write(sql)
 Set rs = getMysqlQueryRecordSet(sql , con)
						londontoppers=rs.recordcount
						totalLontoppers=londontoppers-(CInt(londoncwtopper)+CInt(londonhcatopper)+CInt(londonhwtopper))
						rs.close
						set rs=nothing

sql="Select * FROM qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and P.code<>15919 and Q.componentid=5  and Q.madeat=2 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
'response.Write(sql)
 Set rs = getMysqlQueryRecordSet(sql , con)
						prodlondontoppers=rs.recordcount
						prodtotalLontoppers=prodlondontoppers-(CInt(prodlondoncwtopper)+CInt(prodlondonhcatopper)+CInt(prodlondonhwtopper))
						rs.close
						set rs=nothing
												
sql="Select * FROM qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentid=5  and Q.madeat=2 and Q.finished is null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
'response.Write(sql)
 Set rs = getMysqlQueryRecordSet(sql , con)
						londontoppersOB=rs.recordcount
						totalLontoppersOB=londontoppersOB-(CInt(londoncwtopperOB)+CInt(londonhcatopperOB)+CInt(londonhwtopperOB))
						rs.close
						set rs=nothing

sql="Select * FROM qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentid=5 and P.code<>15919 and Q.madeat=1 and Q.finished >= '" & datefrom & "' and Q.finished <= '" & dateto & "'"
'response.Write(sql)
 Set rs = getMysqlQueryRecordSet(sql , con)
						cardifftoppers=rs.recordcount
						totalCartoppers=cardifftoppers-(CInt(cardiffcwtopper)+CInt(cardiffhcatopper)+CInt(cardiffhwtopper))
						rs.close
						set rs=nothing
						
sql="Select * FROM qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentid=5 and P.code<>15919 and Q.madeat=1 and P.production_completion_date >= '" & datefrom & "' and P.production_completion_date <= '" & dateto & "'"
'response.Write(sql)
 Set rs = getMysqlQueryRecordSet(sql , con)
						prodcardifftoppers=rs.recordcount
						prodtotalCartoppers=prodcardifftoppers-(CInt(prodcardiffcwtopper)+CInt(prodcardiffhcatopper)+CInt(prodcardiffhwtopper))
						rs.close
						set rs=nothing		
										
sql="Select * FROM qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentid=5  and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919"
'response.Write(sql)
 Set rs = getMysqlQueryRecordSet(sql , con)
						cardifftoppersOB=rs.recordcount
						totalCartoppersOB=cardifftoppersOB-(CInt(cardiffcwtopperOB)+CInt(cardiffhcatopperOB)+CInt(cardiffhwtopperOB))
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

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
	
<form action="items-produced.asp" method="post" name="form1">					  
    <div class="content brochure">
			    <div class="one-col head-col">
			<p>Items Produced</p>

            <table width="530" border="1" cellspacing="2" cellpadding="1" align="right">
              <tr>
                <td colspan="2" rowspan="2" valign="bottom">No of Items Produced in Week</td>
                <td colspan="3">Production Screen Schedule Days from Production complete</td>
              </tr>
              <tr>
                <td align="left" valign="bottom">Woodwork</td>
                <td align="left" valign="bottom">Cutting Room</td>
                <td align="left" valign="bottom">Production Floor</td>
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
              </tr>
            </table>
<table width="400" border="0" align="center" cellpadding="5" cellspacing="2">
					    <tr>
					      <td><label for="datefrom" id="surname"><strong>Completed date from :</strong><br>
		  <input name="datefrom" type="text" class="text" id="datefrom" size="10" /><a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.datefrom','calendar_window','width=154,height=288');calendar_window.focus()">
      Choose Date
       </a></label></td>
					      <td><strong>Completed date to: </strong><br>
                          <input name="dateto" type="text" class="text" id="dateto" size="10" /><a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.dateto','calendar_window','width=154,height=288');calendar_window.focus()">
      Choose Date
       </a></td>
				        </tr>
                      
					    <tr>
					      <td colspan="2" align="left">				          <span class="row">
					        <input type="submit" name="submit" value="Search Database or Update Items per week"  id="submit" class="button" />
					      </span></td>
	      </tr>
			      </table>
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
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=London Mattress Orders Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=prodlondonmattsql %>">CSV</a></strong>&nbsp;</td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=Cardiff Mattress Orders Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=prodcardiffmattsql%>">CSV</a></strong>&nbsp;</td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=London Mattress Items Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=londonmattsql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=Cardiff Mattress Items Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=cardiffmattsql %>">CSV</a></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=London Mattress Order Book&prodsql=<%=londonmattOBsql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=Cardiff Mattress Order Book&prodsql=<%=cardiffmattOBsql %>">CSV</a></td>
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
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=London Base Orders Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=prodlondonbasesql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=Cardiff Base Orders Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=prodcardiffbasesql %>">CSV</a>&nbsp;</td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=London Base Items Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=londonbasesql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=Cardiff Base Items Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=cardiffbasesql %>">CSV</a></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=London Base Order Book&prodsql=<%=londonbaseOBsql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=Cardiff Base Order Book&prodsql=<%=cardiffbaseOBsql %>">CSV</a></td>
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
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=London Toppers (linked) Orders Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=prodlondontoppersql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=Cardiff Toppers (linked) Orders Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=prodcardifftoppersql%>">CSV</a></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=London Toppers (linked) Items Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=londontoppersql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=Cardiff Toppers (linked) Items Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=cardifftoppersql %>">CSV</a></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=London Toppers (linked)  Order Book&prodsql=<%=londontopperOBsql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><a href="itemsproduced-csv.asp?title=Cardiff Toppers (linked) Order Book&prodsql=<%=cardifftopperOBsql %>">CSV</a></td>
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
    <td bgcolor="#FFFFFF"><%=prodtotalLontoppers%> <a href="itemsproduced-csv.asp?title=London Toppers only Orders Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=prodlondontoppersOnlysql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><%=prodtotalCartoppers%> <a href="itemsproduced-csv.asp?title=Cardiff Toppers only Orders Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=prodcardifftopperonlysql %>">CSV</a></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=totalLontoppers%> <a href="itemsproduced-csv.asp?title=London Toppers Only Items Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=londontoppersOnlysql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><%=totalCartoppers%> <a href="itemsproduced-csv.asp?title=Cardiff Toppers Only Items Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=cardifftoppersOnlysql %>">CSV</a></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=totalLontoppersOB%> <a href="itemsproduced-csv.asp?title=London Toppers only Order Book&prodsql=<%=londonhcatopperOBOnlysql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><%=totalCartoppersOB%> <a href="itemsproduced-csv.asp?title=Cardiff Topers only Order Book&prodsql=<%=cardiffhcatopperOBOnlysql %>">CSV</a></td>
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
    <td bgcolor="#FFFFFF"><%=prodlondonlegs%> <a href="itemsproduced-csv.asp?title=London Leg Orders Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=prodlondonlegssql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><%=prodcardifflegs%> <a href="itemsproduced-csv.asp?title=Cardiff Leg Orders Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=prodcardifflegssql %>">CSV</a></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonlegs%> <a href="itemsproduced-csv.asp?title=London Leg Items Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=londonlegssql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><%=cardifflegs%> <a href="itemsproduced-csv.asp?title=Cardiff Leg Items Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=cardifflegssql %>">CSV</a></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonlegsOB%> <a href="itemsproduced-csv.asp?title=London Legs Order Book&prodsql=<%=londonlegsOBsql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><%=cardifflegsOB%> <a href="itemsproduced-csv.asp?title=Cardiff Legs Order Book&prodsql=<%=cardifflegsOBsql %>">CSV</a></td>
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
    <td bgcolor="#FFFFFF"><%=prodlondonhb%> <a href="itemsproduced-csv.asp?title=London Headboard Orders Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=prodlondonhbsql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><%=prodcardiffhb%> <a href="itemsproduced-csv.asp?title=Cardiff Headboard Orders Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=prodcardiffhbsql %>">CSV</a></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonhb%> <a href="itemsproduced-csv.asp?title=London Heaboard Items Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=londonhbsql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><%=cardiffhb%> <a href="itemsproduced-csv.asp?title=Cardiff Headboard Items Produced between <%=request("datefrom")%> to <%=request("dateto")%>&prodsql=<%=cardiffhbsql %>">CSV</a></td>
    <td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><%=londonhbOB%> <a href="itemsproduced-csv.asp?title=London Headboard Order Book&prodsql=<%=londonhbOBsql %>">CSV</a></td>
    <td bgcolor="#FFFFFF"><%=cardiffhbOB%> <a href="itemsproduced-csv.asp?title=Cardiff Headboard Order Book&prodsql=<%=cardiffhbOBsql %>">CSV</a></td>
  </tr>
          </table>
          <p>&nbsp;</p>
          <p>
            <%end if%>
          </p>
        </div>
  </div>
<div>
</div>
        </form>
</body>
</html>

 <%Con.Close
Set Con = Nothing%> 
<!-- #include file="common/logger-out.inc" -->
