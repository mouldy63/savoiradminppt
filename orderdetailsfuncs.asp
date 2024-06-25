<%
sub addPackedWithAccessoryOptions(byref acon, apn, aCurrentAccNo, aCurrentSelection)
	dim ars, an, aAccCompId
	set ars = getMysqlUpdateRecordSet("select * from orderaccessory where purchase_no=" & order & " order by orderaccessory_id", acon)
	an = 0
	while not ars.eof
		an = an + 1
		if aCurrentAccNo <> an then
			aAccCompId = "9-" & ars("orderaccessory_id")
			response.write("<option value=" & aAccCompId & " " & selected(aCurrentSelection, aAccCompId) & " >Accessory Item " & an & "</option>")
		end if
		ars.movenext
	wend
	call closemysqlrs(ars)
end sub

%>
