<% option explicit %>
<!-- #include file="../common/adovbs2.inc" -->
<!-- #include file="../common/mysqldbfuncs.asp" -->
<!-- #include file="funcs.asp" -->
<!-- #include file="../utilfuncs2.asp" -->
<!-- #include file="../common/sha256.asp" -->
<!-- #include file="../common/logger.asp" -->
<%Dim rs, nextasp, user, region, location, password, con, sql, myform, roles, site, superuser, savoirowned, userid, scriptname, nosuper, salt, hash, isRestCall

call openLogger()
scriptname = "login.asp"
isRestCall = (request("rest") = "y")
set con = getMysqlConnection()

if isRestCall then
	user = cleanForDb(trim(request("username")))
	password = cleanForDb(trim(request("password")))
else
set myform = RemoveChars()  ' replace < with null
user = lcase(trim(myform("username")))
	password = trim(myform("password"))
end if

'response.write("<br>user = " & user)
'response.write("<br>password = " & password)
'response.write("<br>hash = " & hash)
'response.write("<br>salt = " & salt)
'response.end

if user = "" then
	response.redirect("/php/home")
end if

set rs = getMysqlQueryRecordSet("select salt from savoir_user where lower(username)='" & user & "'", con)
if rs.eof then
	call log(scriptname, user & " not in DB")
	call closemysqlrs(rs)
	call closemysqlcon(con)
	call clearUserSession(con)
	nextasp = "access.asp?failed=true&ret=" & server.urlencode(request("ret"))
	response.redirect nextasp
	response.end
end if
salt = rs("salt")
call closemysqlrs(rs)

if request("rest") = "y" then
	' if called from the rest service the password will already be hashed
	hash = password
else
hash = sha256(salt & password)
end if
'response.write("<br>user = " & user)
'response.write("<br>password = " & password)
'response.write("<br>hash = " & hash)
'response.write("<br>salt = " & salt)
'response.end

sql = "SELECT DISTINCT R.ROLENAME FROM SAVOIR_USER U, SAVOIR_USERROLE UR, SAVOIR_ROLE R"
sql = sql & " WHERE U.USER_ID=UR.USER_ID AND UR.ROLE_ID=R.ROLE_ID"
sql = sql & " AND LOWER(U.USERNAME)='" & user & "' AND binary U.PW='" & hash & "' AND U.RETIRED='n'"
sql = sql & " ORDER BY R.ROLENAME"

set rs = getMysqlQueryRecordSet(sql, con)
'response.write("<br>sql = " & sql)
'response.write("<br>eof = " & rs.eof)
'response.write("<br>ret = " & request("ret"))
'response.end

if rs.eof then
	nextasp = "access.asp?failed=true&ret=" & server.urlencode(request("ret"))
	call log(scriptname, user & " failed to logon")
else
	roles = ""
	while not rs.eof
		if roles <> "" then
			roles = roles & ","
		end if
		roles = roles & rs("ROLENAME")
		rs.movenext
	wend
	nextasp = request("ret")
	call log(scriptname, user & " successfully logged on")
end if

if nextasp = "" then
	nextasp = "/php/home"
end if

rs.Close

sql = "SELECT ID_LOCATION,ID_REGION,SITE,SUPERUSER,USER_ID,SAVOIROWNED FROM SAVOIR_USER U JOIN LOCATION L ON U.ID_LOCATION=L.IDLOCATION WHERE LOWER(USERNAME)='" & user & "'"
set rs = getMysqlQueryRecordSet(sql, con)
region = rs("ID_REGION")
location = rs("ID_LOCATION")
site = rs("SITE")
superuser = rs("SUPERUSER") = "Y"
savoirowned = rs("SAVOIROWNED") = "y"
userid=rs("user_id")
rs.Close
set rs = nothing

nosuper = ""
sql = "SELECT ROLENAME,NOSUPER FROM SAVOIR_ROLE ORDER BY ROLENAME"
set rs = getMysqlQueryRecordSet(sql, con)
while not rs.eof
	if nosuper <> "" then nosuper = nosuper & ","
	nosuper = nosuper & rs("ROLENAME") & "=" & rs("NOSUPER")
	rs.movenext
wend
rs.Close
set rs = nothing

'response.write("<br>" & nosuper)
'response.end
if roles <> "" then
	call storeUserRoles(roles)
	call storeNoSuper(nosuper)
	call storeUserName(user)
	call storeUserID(userid)
	call storeUserRegion(region)
	call storeUserLocation(location)
	call storeUserSite(site)
	call setSuperuser(superuser)
	call setSavoirOwned(savoirowned)
	call storeSessionAndWriteCakeCookie(con, userid, user, superuser, roles)
else
	call clearUserSession(con)
end if

con.Close
set con = nothing

call closeLogger()

'response.write("<br>roles = " & roles)
'response.write("<br>nextasp = " & nextasp)
'response.end
if not isRestCall then response.redirect nextasp

Function RemoveChars() 
  dim frm,item,val
  set frm = Server.CreateObject("Scripting.Dictionary") 
  frm.CompareMode=1    ' mode 1 = text
  For each Item in Request.Form
  	val = Replace(Request.Form(Item),">","&gt;") 
  	val = Replace(val,"<","&lt;") 
  	val = Replace(val,"'","") 
  	val = Replace(val,"--","") 
    frm.Add Cstr(Item), val
  Next 
  set RemoveChars = frm 
End Function 
%>

