<%
function getDeliveryReportRs(byref acon, alocation, adelcall, agiftpack, areporttype, adatefrom, adateto, ashowr, acustomerasc, aorderasc, acompanyasc, adeldate, aproddate)
	if adatefrom <> "" then
		adatefrom=year(adatefrom) & "/" & month(adatefrom) & "/" & day(adatefrom)
	end if
	if adateto <>"" then
		adateto=year(adateto) & "/" & month(adateto) & "/" & day(adateto)
	end if
	
	dim asql
	if userHasRole("ADMINISTRATOR") or userHasRole("REGIONAL_ADMINISTRATOR") or retrieveuserid()=22 then
		else
		alocation = retrieveUserLocation()
	end if
	
	asql = "Select * from address A, contact C, Purchase P, Location L" 
	if adelcall <> "" then
		asql = asql & " , communication cn" 
	end if
	asql = asql & " WHERE P.idlocation=L.idlocation"
	asql = asql & " AND P.contact_no=C.contact_no"
	asql = asql & " AND C.code=A.code"
	if adelcall <> "" then
		asql = asql & " AND C.code=cn.code"  
	end if
	
	asql = asql & " AND (P.cancelled is null or P.cancelled <> 'y') AND C.retire='n' AND P.orderonhold<>'y' AND P.quote='n'"
	
	if agiftpack="y" then
		asql=asql & " AND giftpackrequired = 'y'"
	end if
	
	if alocation<>"all" then
		asql = asql & " AND L.idlocation=" & alocation & " "
	end if
	
	if not userHasRole("ADMINISTRATOR") AND retrieveuserid()<>22 AND userHasRole("REGIONAL_ADMINISTRATOR") then
		asql = asql & " AND L.owning_region=" & retrieveuserregion() & " "
	end if
	
	
	if areporttype="delivery" then
		asql = asql & " and P.bookeddeliverydate is not null and P.bookeddeliverydate<>'' "
		if adatefrom<>"" then
			asql = asql & " AND P.bookeddeliverydate > DATE_ADD('" & adatefrom & "', INTERVAL -1 DAY) "
		end if
		if adateto<>"" then
			asql = asql & " AND P.bookeddeliverydate < DATE_ADD('" & adateto & "', INTERVAL 1 DAY) " 
		end if
	end if
	
	if areporttype="production" then
		asql = asql & " AND P.idlocation=L.idlocation and P.production_completion_date is not null and P.production_completion_date<>''"
		if adatefrom<>"" then
			asql = asql & " AND P.production_completion_date > DATE_ADD('" & adatefrom & "', INTERVAL -1 DAY) " 
		end if
		if adateto<>"" then
			asql = asql & " AND P.production_completion_date < DATE_ADD('" & adateto & "', INTERVAL 1 DAY) " 
		end if
	end if
	
	if adelcall <> "" then
		asql = asql & " AND cn.type='Post Delivery Call'" 
	end if
	
	asql = asql & " AND P.source_site='SB' " 
	
	if ashowr="a" then
		asql = asql & " order by L.adminheading asc"
	end if
	if ashowr="d" then
		asql = asql & " order by L.adminheading desc"
	end if
	if acustomerasc="a" then
		asql = asql & " order by C.surname asc"
	end if
	if acustomerasc="d" then
		asql = asql & " order by C.surname desc"
	end if
	if aorderasc="a" then
		asql = asql & " order by P.order_number asc"
	end if
	if aorderasc="d" then
		asql = asql & " order by P.order_number desc"
	end if
	if acompanyasc="a" then
		asql = asql & " order by A.company asc"
	end if
	if acompanyasc="d" then
		asql = asql & " order by A.company desc"
	end if
	
	if adeldate="a" then
		asql = asql & " order by P.bookeddeliverydate asc"
	end if
	if adeldate="d" then
		asql = asql & " order by P.bookeddeliverydate desc"
	end if
	
	if aproddate="a" then
		asql = asql & " order by P.production_completion_date asc"
	end if
	if aproddate="d" then
		asql = asql & " order by P.production_completion_date desc"
	end if
	
	if acustomerasc=""  and  adeldate="" and aorderasc="" and acompanyasc=""  and (adeldate=""  or aproddate="") and ashowr="" then
		asql = asql & " order by P.order_number asc"
	end if
	'response.write("<br/>" & asql & "<br/>")
	call log(scriptname, "getDeliveryReportRs: asql=" & asql)
	
	set getDeliveryReportRs = getMysqlQueryRecordSet(asql, acon)
end function
%>
