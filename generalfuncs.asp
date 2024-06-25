<%
function getPaymentNotificationEmailAddressForShowroom(byref aIdLocation, byref acon)
	dim asql, ars
	asql = "select payment_notification_email from location where idlocation=" & aIdLocation
	Set ars = getMysqlQueryRecordSet(asql, acon)
	getPaymentNotificationEmailAddressForShowroom = ars("payment_notification_email")
	ars.close
	set ars = nothing
end function

function getBuddyLocationIds(byref aIdLocation, byref acon)
	dim asql, ars, avals
	asql = "select buddy_location_ids from location where idlocation=" & aIdLocation
	Set ars = getMysqlQueryRecordSet(asql, acon)
	getBuddyLocationIds = ars("buddy_location_ids")
	ars.close
	set ars = nothing
end function

function makeBuddyLocationList(byref aIdLocation, byref acon)
	makeBuddyLocationList = getBuddyLocationIds(aIdLocation, acon)
	if makeBuddyLocationList = "" or isnull(makeBuddyLocationList) then
		makeBuddyLocationList = aIdLocation
	else
		makeBuddyLocationList = aIdLocation & "," & makeBuddyLocationList
	end if
end function

function getBuddyLocationAndRegionList(byref acon, aIdLocation)
	dim asql, ars, avals, aBuddies, aList, aBuddy, an
	aList = aIdLocation
	asql = "select buddy_location_ids from location where idlocation=" & aIdLocation
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not isnull(ars("buddy_location_ids")) and ars("buddy_location_ids") <> "" then
		aList = aList & "," & ars("buddy_location_ids")
	end if
	ars.close
	getBuddyLocationAndRegionList = ""

	aBuddies = split(aList, ",")
	an = 0
	for each aBuddy in aBuddies
		an = an + 1
	    asql = "select owning_region from location where idlocation=" & aBuddy
	    set ars = getMysqlQueryRecordSet(asql, acon)
	    if an > 1 then getBuddyLocationAndRegionList = getBuddyLocationAndRegionList & ";"
	    getBuddyLocationAndRegionList = getBuddyLocationAndRegionList & aBuddy & "," & ars("owning_region")
		ars.close
	next
	set ars = nothing
end function

function escHiddenFieldTxt(byref val)
	if isnull(val) or val = "" then
		escHiddenFieldTxt = ""
	else
		escHiddenFieldTxt = replace(trim(val), "'", "&#39;")
		escHiddenFieldTxt = replace(trim(val), """", "&#34;")
	end if
end function

function safeHtmlEncode(byref aval)
	if isnull(aval) or isempty(aval) or aval="" then
		safeHtmlEncode = ""
	else
		safeHtmlEncode = server.htmlencode(aval)
	end if
end function

function simpleHtmlEncode(byref aval)
	if isnull(aval) or isempty(aval) or aval="" then
		simpleHtmlEncode = ""
	else
	  	simpleHtmlEncode = Replace(aval,">","&gt;") 
	  	simpleHtmlEncode = Replace(simpleHtmlEncode,"<","&lt;") 
	end if
end function

%>
