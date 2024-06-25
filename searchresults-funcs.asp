<%
function getCustomersSql(byref aCon, aSurname, aCref, aPostcode, aCompany, aChannel, aContacttype, aCurrent, aFilterType, aFilterVal)

	dim asql
	asql = "select CC.acceptpost,CC.code,CC.contact_no,CC.surname,CC.title,CC.first,AA.company,AA.email_address,AA.street1,AA.street2,AA.street3,AA.county,AA.postcode,AA.country,CC.acceptpost,CC.acceptemail,CC.source_site"
	asql = asql & " from contact CC, address AA where CC.contact_no in ("
	asql = asql & getContactFilterSql(aCon, aCurrent, aCref, aSurname, aPostcode, aCompany, aChannel, aContacttype, aFilterType, aFilterVal)
	asql=asql & " ) and CC.code=AA.code Order by CC.surname asc, CC.first asc"
	getCustomersSql = asql
	'response.write("<p>" & asql & "</p>")

end function

' returns the sql for finding the contacts who have relevant orders
function getContactFilterSql(byref aCon, aCurrent, aCref, aSurname, aPostcode, aCompany, aChannel, aContacttype, aFilterType, aFilterVal)
	dim asql, aBuddyLocationAndRegionList, aPairs, aPair, anLoc, aLocAndReg
	asql = "select distinct c.contact_no from contact c join address a on c.code=a.code and c.retire='n' and c.is_developer='n'"
	if not userHasRole("ADMINISTRATOR") then
		if retrieveuserregion()<>1 then 
			aBuddyLocationAndRegionList = getBuddyLocationAndRegionList(aCon, retrieveUserLocation())
			anLoc = 0
			aPairs = split(aBuddyLocationAndRegionList, ";")
			asql = asql & " AND ("
			for each aPair in aPairs
				anLoc = anLoc + 1
				if anLoc > 1 then
					asql = asql & " OR "
				end if
				aLocAndReg = split(aPair, ",")
				asql = asql & " (c.idlocation=" & aLocAndReg(0) & " AND c.owning_region=" & aLocAndReg(1) & ")"
			next
			asql = asql & ")"
		else
			asql=asql & " and c.owning_region=1"
		end if
	end if
	'asql=asql & " and A.source_site ='SB'"

	if trim(aSurname) <> "" Then
		asql=asql & " and C.surname like '%" & aSurname & "%'"
	end if
	if aPostcode <> "" Then
		asql=asql & " and replace(A.postcode, ' ', '') like '%" & aPostcode & "%'"
	end if
	if aCompany <> "" Then
		asql=asql & " and A.company like '%" & aCompany & "%'"
	end if
	if retrieveUserRegion=1 then
		if aChannel <> "n" Then
			asql=asql & " and A.channel = '" & aChannel & "'"
		end if
		if aContacttype <> "n" Then
			asql=asql & " and A.initial_contact = '" & aContacttype & "'"
		end if
	end if

	if aCurrent = "TRUE" then
		' customers with current orders
		asql = asql & " and exists(select 1 from purchase p where p.contact_no=c.contact_no and p.completedorders='n' and (p.cancelled is null or p.cancelled = 'n')"
		if aCref <> "" then
			asql = asql & " and p.customerreference like '%" & aCref & "%'"
		end if
		asql = asql & ")"
	elseif aCurrent = "FALSE" then
		' customers with completed orders
		asql = asql & " and exists(select 1 from purchase p where p.contact_no=c.contact_no and p.completedorders='y' and (p.cancelled is null or p.cancelled = 'n')"
		if aCref <> "" then
			asql = asql & " and p.customerreference like '%" & aCref & "%'"
		end if
		asql = asql & ")"
	else
		' customers with no orders
		asql = asql & " and not exists(select 1 from purchase p where p.contact_no=c.contact_no and (p.cancelled is null or p.cancelled = 'n')"
		if aCref <> "" then
			asql = asql & " and p.customerreference like '%" & aCref & "%'"
		end if
		asql = asql & ")"
	end if

	if aFilterType <> "" and aFilterVal <> "" then
		if aFilterType = "first" then
			asql = asql & " and C.first like '%" & aFilterVal & "%'"
		elseif aFilterType = "company" then
			asql = asql & " and A.company like '%" & aFilterVal & "%'"
		elseif aFilterType = "add1" then
			asql = asql & " and A.street1 like '%" & aFilterVal & "%'"
		elseif aFilterType = "add2" then
			asql = asql & " and A.street2 like '%" & aFilterVal & "%'"
		elseif aFilterType = "add3" then
			asql = asql & " and A.street3 like '%" & aFilterVal & "%'"
		elseif aFilterType = "email" then
			asql = asql & " and A.email_address like '%" & aFilterVal & "%'"
		elseif aFilterType = "postcode" then
			asql = asql & " and A.postcode like '%" & aFilterVal & "%'"
		elseif aFilterType = "city" then
			asql = asql & " and A.town like '%" & aFilterVal & "%'"
		elseif aFilterType = "channel" then
			asql = asql & " and A.channel like '%" & aFilterVal & "%'"
		elseif aFilterType = "type" then
			asql = asql & " and A.type like '%" & aFilterVal & "%'"
		elseif aFilterType = "visited" then
			asql = asql & " and A.visit_location like '%" & aFilterVal & "%'"
		elseif aFilterType = "A" then
			asql = asql & " and (C.first like '%" & aFilterVal & "%'"
			asql = asql & " or A.company like '%" & aFilterVal & "%'"
			asql = asql & " or A.street1 like '%" & aFilterVal & "%'"
			asql = asql & " or A.street2 like '%" & aFilterVal & "%'"
			asql = asql & " or A.street3 like '%" & aFilterVal & "%'"
			asql = asql & " or A.email_address like '%" & aFilterVal & "%'"
			asql = asql & " or A.postcode like '%" & aFilterVal & "%'"
			asql = asql & " or A.town like '%" & aFilterVal & "%'"
			asql = asql & " or A.channel like '%" & aFilterVal & "%'"
			asql = asql & " or A.type like '%" & aFilterVal & "%'"
			asql = asql & " or A.visit_location like '%" & aFilterVal & "%')"
		end if
	end if
	
	if aFilterVal <> "" and (aFilterType = "company" or aFilterType = "custref" or aFilterType = "A") then
		asql = asql & " join purchase pp on c.contact_no=pp.contact_no"
		if aFilterType = "company" then
			asql = asql & " and pp.companyname like '%" & aFilterVal & "%'"
		elseif aFilterType = "custref" then
			asql = asql & " and pp.customerreference like '%" & aFilterVal & "%'"
		elseif aFilterType = "A" then
			asql = asql & " and (pp.companyname like '%" & aFilterVal & "%'"
			asql = asql & " or pp.customerreference like '%" & aFilterVal & "%')"
		end if
	end if
	
	getContactFilterSql = asql
end function

%>