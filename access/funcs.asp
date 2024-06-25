<%
dim pw, encrypt, SAVOIR_ROLES, SAVOIR_NOSUPER, SAVOIR_NAMES, SAVOIR_REGION, SAVOIR_LOCATION, SAVOIR_SUPERUSER, SAVOIR_USER_SITE, SAVOIR_USER_ID, SAVOIR_OWNED
pw = "<J^c41yrv?h1va"
encrypt = false
SAVOIR_ROLES = "SAVOIR_ROLES"
SAVOIR_NOSUPER = "SAVOIR_NOSUPER"
SAVOIR_NAMES = "SAVOIR_NAMES"
SAVOIR_REGION = "SAVOIR_REGION"
SAVOIR_LOCATION = "SAVOIR_LOCATION"
SAVOIR_SUPERUSER = "SAVOIR_SUPERUSER"
SAVOIR_USER_SITE = "SAVOIR_USER_SITE"
SAVOIR_USER_ID = "SAVOIR_USER_ID"
SAVOIR_OWNED = "SAVOIR_OWNED"

sub storeUserRoles(aRoles)
	session(SAVOIR_ROLES) = aRoles
end sub

sub storeNoSuper(aNoSuper)
	session(SAVOIR_NOSUPER) = aNoSuper
end sub

sub storeUserName(aName)
	session(SAVOIR_NAMES) = aName
end sub

sub storeUserID(aUserID)
	session(SAVOIR_USER_ID) = aUserID
end sub

sub storeUserRegion(aRegion)
	session(SAVOIR_REGION) = aRegion
end sub

sub storeUserLocation(aLocation)
	session(SAVOIR_LOCATION) = aLocation
end sub

sub storeUserSite(aUserSite)
	session(SAVOIR_USER_SITE) = aUserSite
end sub

sub setSuperuser(aIsSuperuser)
	if aIsSuperuser then
		session(SAVOIR_SUPERUSER) = "Y"
	else
		session(SAVOIR_SUPERUSER) = "N"
	end if
end sub

sub setSavoirOwned(aSavoirOwned)
	if aSavoirOwned then
		session(SAVOIR_OWNED) = "Y"
	else
		session(SAVOIR_OWNED) = "N"
	end if
end sub

sub clearUserSession(byref acon)
	deleteSessionLog(acon)
	session.contents.remove(SAVOIR_ROLES)
	session.contents.remove(SAVOIR_NOSUPER)
	session.contents.remove(SAVOIR_NAMES)
	session.contents.remove(SAVOIR_REGION)
	session.contents.remove(SAVOIR_LOCATION)
	session.contents.remove(SAVOIR_SUPERUSER)
	session.contents.remove(SAVOIR_OWNED)
	session.contents.remove(SAVOIR_USER_SITE)
	session.contents.remove(SAVOIR_USER_ID)
	Response.Cookies("CakeCookie[SavoirAdminSession]").Expires = DateAdd("d",-1,now())
	Response.Cookies("SavoirAdminSession").Expires = DateAdd("d",-1,now())
	Response.Cookies("CAKEPHP").Expires = DateAdd("d",-1,now())
	Response.Cookies("PHPSESSID").Expires = DateAdd("d",-1,now())
	session.abandon
end sub

function retrieveUserRoles()
	retrieveUserRoles = session(SAVOIR_ROLES)
end function

function retrieveNoSuper()
	retrieveNoSuper = session(SAVOIR_NOSUPER)
end function

function retrieveUserName()
	retrieveUserName = session(SAVOIR_NAMES)
end function

function retrieveUserID()
	retrieveUserID = session(SAVOIR_USER_ID)
end function

function retrieveUserRegion()
	retrieveUserRegion = session(SAVOIR_REGION)
end function

function retrieveUserLocation()
	retrieveUserLocation = session(SAVOIR_LOCATION)
end function

function retrieveUserSite()
	retrieveUserSite = session(SAVOIR_USER_SITE)
end function

function isSuperuser()
	isSuperuser = session(SAVOIR_SUPERUSER) = "Y"
end function

function isSavoirOwned()
	isSavoirOwned = session(SAVOIR_OWNED) = "Y"
end function

function isSuperuserForRole(aRole)
	dim aRoleMap, aRoleItem, aData
	if not isSuperuser() then
		isSuperuserForRole = false
		exit function
	end if
		
	aRoleMap = split(retrieveNoSuper(), ",")
	for each aRoleItem in aRoleMap
		'response.write("<br>aRoleItem=" & aRoleItem)
		aData = split(aRoleItem, "=")
		'response.write("<br>aRole=" & aRole & " aData0=" & aData(0) & " aData1=" & aData(1))
		if aData(0) = aRole then
			isSuperuserForRole = (aData(1) = "n")
			'response.write("<br>isSuperuserForRole=" & isSuperuserForRole)
			exit function
	end if 
	next
end function

function userHasRole(aRole)

	Dim aRoles, aTemp
	
	if isSuperuserForRole(aRole) then
		userHasRole = true
	else
		userHasRole = false
		aRoles=split(retrieveUserRoles,",")
		for each aTemp in aRoles
			if aTemp = aRole then
				userHasRole = true
			end if
		next
	end if

end function

function userHasRoleInList(aRoleList)
	Dim aRoles, aTemp

		userHasRoleInList = false
		aRoles=split(aRoleList,",")
		for each aTemp in aRoles
			if not userHasRoleInList then
				userHasRoleInList = userHasRole(aTemp)
			end if
		next

end function

function isOnline()
	isOnline = (Request.ServerVariables("HTTP_HOST") <> "localhost")
end function

function getThisDomain()
	getThisDomain = request.serverVariables("SERVER_NAME")
end function

function cipherString(aStr)

	if not encrypt or isNull(aStr) or aStr = "" then
		cipherString = aStr
	else
		cipherString = EncryptString(aStr, pw)
	end if

end function

function decipherString(aStr)

	if not encrypt or isNull(aStr) or aStr = "" then
		decipherString = aStr
	else
		decipherString = DecryptString(aStr, pw)
	end if

end function

Function EncryptString(byval Uncoded, byval Password)
	Dim Char, TxtChar, PwdChar, NewChar
    Uncoded = Swap(Uncoded)                            'Run the text through the swap function

    For Char = 1 to LEN(Uncoded)
      TxtChar = ASC(MID(Uncoded, Char, 1))             'Store character codes of text and password
      PwdChar = ASC(MID(Password, (Char MOD LEN(Password) + 1), 1))

      NewChar = TxtChar + PwdChar                      'Combine them into one new character code
      If NewChar > 255 Then NewChar = NewChar - 255    'Charactercode can't be >255 or <1

      EncryptString = EncryptString & Chr(NewChar)                 'Add new charactercode
    Next

    Uncoded = Swap(Uncoded)                            'back-swap the text so it will be displayed correctly (not necessary for successful encryption)
End Function

Function DecryptString(byval Coded, byval Password)
	Dim Char, CodChar, PwdChar, NewChar
    For Char = 1 to LEN(Coded)
      CodChar = ASC(MID(Coded, Char, 1))               'Store character codes of text and password
      PwdChar = ASC(MID(Password, (Char MOD LEN(Password) + 1), 1))

      NewChar = CodChar - PwdChar                      'Restore the original charactercode
      if NewChar < 1 then NewChar = NewChar + 255

      DecryptString = DecryptString & Chr(NewChar)                 'Add original charactercode
    Next

    DecryptString = Swap(DecryptString)                            'Swap the result to get the original string
End Function

Function Swap(byval Inp)
    Dim InpTemp(3), Char, Outp, i                                  'Make array with 4 positions

    For Char = 1 to LEN(Inp) step 4                    'Walk through the string

	  if Char + 2 < LEN(Inp) then                      'If there are enough characters left to do a swap

	    for i = 0 to 3
	      InpTemp(i) = MID(Inp, Char + i, 1)           'Store 4 characters in array
        next

        if LEN(Inp) MOD 4 > 1 then                     'I used two ways of swapping (for extra security), it depends on the length of the string wich swap will be done
          Outp = Outp & InpTemp(2) & InpTemp(3) & InpTemp(0) & InpTemp(1)
        else
		  Outp = Outp & InpTemp(3) & InpTemp(2) & InpTemp(1) & InpTemp(0)
	    end if

	  else
	    Outp = Outp & MID(Inp, Char, LEN(Inp) - Char + 1)   'If swap couldn't be made, just add the remaining characters
	  end if

    Next

    Swap = Outp                                        'Return the swapped string
End Function

sub storeSessionAndWriteCakeCookie(byref acon, auserid, auser, asuperuser, aroles)
	dim ars
	set ars = getMysqlUpdateRecordSet("select * from sessionlog where sessionid='" & Session.SessionID & "'", acon)
	if ars.eof then ars.addNew
	ars("username") = auser
	ars("user_id") = auserid
	ars("sessionid") = Session.SessionID
	ars("superuser") = asuperuser
	ars("roles") = aroles
	ars("created") = now()
	ars.Update
	ars.close
	set ars=nothing
	Response.Cookies("CakeCookie[SavoirAdminSession]") = Session.SessionID
	Response.cookies("CakeCookie[SavoirAdminSession]").expires=dateadd("n",30,Now()) ' 30 minute lifetime
	Response.Cookies("SavoirAdminSession") = Session.SessionID
	Response.cookies("SavoirAdminSession").expires=dateadd("n",30,Now()) ' 30 minute lifetime
end sub

sub deleteSessionLog(byref acon)
	acon.execute("delete from sessionlog where sessionid='" & Session.SessionID & "'")
end sub

%>