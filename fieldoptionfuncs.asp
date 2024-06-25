<%
dim NOPTIONS
NOPTIONS = 61
class fieldoptions
	public optioncount
	public options
	public defaultoption
end class

function getFieldOptions(afieldname, byref acon)
	dim ars, asql, acount, an, aoptions()
	asql = "select * from fieldoptions where fieldname='" & afieldname & "'"
	set ars = getMysqlQueryRecordSet(asql, acon)
	set getFieldOptions = new fieldoptions
	if ars.eof then
		getFieldOptions.optioncount = 0
	else
		acount = 0
		for an = 1 to NOPTIONS
			if not isnull(ars("option" & an)) and ars("option" & an) <> "" then
				acount = acount + 1
				redim preserve aoptions(acount)
				aoptions(acount) = trim(ars("option" & an))
			end if
		next
		getFieldOptions.optioncount = acount
		getFieldOptions.options = aoptions
		if not isnull(ars("defaultoptionno")) and ars("defaultoptionno") <> "" then
			getFieldOptions.defaultoption = cint(ars("defaultoptionno"))
		end if
	end if
	ars.close
	set ars = nothing
end function

function makeOptionString(aFieldName, aDefaultOption, aStringIds, byref acon)
	makeOptionString = makeOptionString2(aFieldName, aDefaultOption, aStringIds, "", "", false, false, acon)
end function

function makeSortedOptionString(aFieldName, aDefaultOption, aStringIds, byref acon)
	makeSortedOptionString = makeOptionString2(aFieldName, aDefaultOption, aStringIds, "", "", false, true, acon)
end function

function makeOptionString2(aFieldName, aDefaultOption, aStringIds, aDefaultSrcField, aDefaultSrcOpt, aDefaultSrcOptIsStringId, aSort, byref acon)
	dim aFieldOptions, an, aId, aTemp, aChangeMade, anStart, aDefaultFound
	set aFieldOptions = getFieldOptions(aFieldName, acon)
	if aFieldOptions.optioncount = 0 then
		makeOptionString2 = ""
		exit function
	end if
	
	if aSort and aStringIds and aFieldOptions.optioncount > 1 then
		anStart = 1
		if aFieldOptions.options(1)="" or aFieldOptions.options(1)="--" or aFieldOptions.options(1)="n" or aFieldOptions.options(1)="TBC" then
			anStart = anStart + 1
		end if
		if aFieldOptions.options(2)="" or aFieldOptions.options(2)="--" or aFieldOptions.options(2)="n" or aFieldOptions.options(2)="TBC" then
			anStart = anStart + 1
		end if
		aChangeMade = true
		while aChangeMade
			aChangeMade = false
			for an = anStart to aFieldOptions.optioncount - 1
				if strComp(aFieldOptions.options(an), aFieldOptions.options(an+1)) > 0 then
					aTemp = aFieldOptions.options(an)
					aFieldOptions.options(an) = aFieldOptions.options(an+1)
					aFieldOptions.options(an+1) = aTemp
					aChangeMade = true
				end if
			next
		wend
	end if

	if isnull(aDefaultOption) or aDefaultOption = "" then
		' no default supplied so get it from the db
		if aDefaultSrcField <> "" and aDefaultSrcOpt <> "" then
			' look it up on fieldoptiondefaults table
			'response.write("<br/>look it up on fieldoptiondefaults table")
			aDefaultOption = getDefaultFromFieldOptionDefaults(aFieldName, aDefaultSrcField, aDefaultSrcOpt, aDefaultSrcOptIsStringId, aStringIds, acon)
		else
			' use the defaultoptionno from fieldoptions table
			'response.write("<br/>use the defaultoptionno from fieldoptions table")
			if aStringIds then
				aDefaultOption = aFieldOptions.options(aFieldOptions.defaultoption)
			else
				aDefaultOption = aFieldOptions.defaultoption
			end if
		end if
		
	end if
	
	makeOptionString2 = ""
	aDefaultFound = false
	for an = 1 to aFieldOptions.optioncount
		if aStringIds then
			aId = aFieldOptions.options(an)
		else
			aId = an
		end if
		if an > 1 then makeOptionString2 = makeOptionString2 & vbCRLF
		makeOptionString2 = makeOptionString2 & "<option value='" & aId & "' " & selected(aId, aDefaultOption) & " >" & aFieldOptions.options(an) & "</option>"
		if not isnull(aDefaultOption) and aDefaultOption <> "" then
			if cstr(aId) = cstr(aDefaultOption) then
				aDefaultFound = true
			end if
		end if
	next
	if not isnull(aDefaultOption) and aDefaultOption <> "" and not aDefaultFound then
		makeOptionString2 = makeOptionString2 & "<option value='" & aDefaultOption & "' selected >" & aDefaultOption & "</option>"
	end if
end function

function getDefaultFromFieldOptionDefaults(aTrgField, aSrcField, aSrcOpt, aSrcOptIsStringId, aTrgOptIsStringId, byref acon)
	if aSrcOptIsStringId then
		aSrcOpt = getFieldOptionNoForOption(aSrcField, aSrcOpt, acon)
	end if
	
	getDefaultFromFieldOptionDefaults = getDefaultFromFieldOptionDefaultsById(aTrgField, aSrcField, aSrcOpt, acon)

	if aTrgOptIsStringId then
		if getDefaultFromFieldOptionDefaults = 0 then
			'response.write("<br/>getDefaultFromFieldOptionDefaults: 0")
			getDefaultFromFieldOptionDefaults = ""
		else
			'response.write("<br/>getDefaultFromFieldOptionDefaults: else")
			getDefaultFromFieldOptionDefaults = getFieldOptionByNo(aTrgField, getDefaultFromFieldOptionDefaults, acon)
		end if
	end if
end function

function getDefaultFromFieldOptionDefaultsById(aTrgField, aSrcField, aSrcOpt, byref acon)
	dim ars, asql, an
	asql = "select * from fieldoptiondefaults where sourcefieldname='" & aSrcField & "' and targetfieldname='" & aTrgField & "' and sourceoptionno=" & aSrcOpt
	'response.write("<br/>getDefaultFromFieldOptionDefaultsById: sql=" & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
	if ars.eof then
		getDefaultFromFieldOptionDefaultsById = 0
	else
		getDefaultFromFieldOptionDefaultsById = cint(ars("targetoptionno"))
	end if
	'response.write("<br/>getDefaultFromFieldOptionDefaultsById: returning " & getDefaultFromFieldOptionDefaultsById)
	ars.close
	set ars = nothing
end function

function getFieldOptionNoForOption(afieldname, aOption, byref acon)
	dim ars, asql, an
	asql = "select * from fieldoptions where fieldname='" & afieldname & "'"
	'response.write("<br/>getFieldOptionNoForOption: sql=" & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
	if ars.eof then
		getFieldOptionNoForOption = 1
	else
		for an = 1 to NOPTIONS
			if not isnull(ars("option" & an)) and ars("option" & an) = aOption then
				getFieldOptionNoForOption = an
			end if
		next
	end if
	'response.write("<br/>getFieldOptionNoForOption: returning " & getFieldOptionNoForOption)
	ars.close
	set ars = nothing
end function

function getFieldOptionByNo(afieldname, aOptionNo, byref acon)
	dim ars, asql
	asql = "select * from fieldoptions where fieldname='" & afieldname & "'"
	'response.write("<br/>getFieldOptionByNo: sql=" & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
	if ars.eof then
		getFieldOptionByNo = ""
	else
		getFieldOptionByNo = ars("option" & aOptionNo)
	end if
	'response.write("<br/>getFieldOptionByNo: returning " & getFieldOptionByNo)
	ars.close
	set ars = nothing
end function
%>
