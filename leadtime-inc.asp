<%
sub getLongestLeadTime(byref acon, byref aLongestLeadTime, byref acardiffNo, byref alondonNo)
	dim asql, ars, alondonitems, acardiffitems
	asql="Select count(*) as n from qc_history_latest Q, purchase P where P.purchase_no=Q.purchase_no and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=2 or Q.QC_StatusID=20) AND  P.orderonhold<>'y' and  (P.cancelled is Null or P.cancelled='n')"
	Set ars = getMysqlQueryRecordSet(asql , acon)
	alondonitems=ars("n")
	ars.close
	set ars=nothing
	
	asql="Select count(*) as n from qc_history_latest Q, purchase P where P.purchase_no=Q.purchase_no and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=2 or Q.QC_StatusID=20) and P.code<>15919 AND  P.orderonhold<>'y'and (P.cancelled is Null or P.cancelled='n')"
	Set ars = getMysqlQueryRecordSet(asql , acon)
	acardiffitems=ars("n")
	ars.close
	set ars=nothing
	
	asql="Select NoItemsWeek, manufacturedatid from manufacturedat"
	Set ars = getMysqlQueryRecordSet(asql , acon)
	Do until ars.eof
		if ars("manufacturedatid")=1 then acardiffNo=ars("NoItemsWeek")
		if ars("manufacturedatid")=2 then alondonNo=ars("NoItemsWeek")
		ars.movenext
	loop
	ars.close
	set ars=nothing
	acardiffNo=round(CDbl(acardiffitems)/CDbl(acardiffNo)+0.5)
	alondonNo=round(CDbl(alondonitems)/CDbl(alondonNo)+0.5)
	if acardiffNo > alondonNo then aLongestLeadTime=acardiffNo else aLongestLeadTime=alondonNo
end sub
%>