<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<%Dim Con, rs, rs2, ordernote_notetext, ordernote_action, ordernote_followupdate, submit, order, i, fieldName, pid, sql, order_url

Set Con = getMysqlConnection()

ordernote_notetext = trim(request("ordernote_notetext") )
    ordernote_action = request("ordernote_action")
    ordernote_followupdate = request("ordernote_followupdate")
	order=request("order")
	order_url=request("order_url")

    if trim(request("ordernote_notetext") ) <> "" then
        call addOrderNote(Con, ordernote_notetext, ordernote_action, ordernote_followupdate, order, "MANUAL")
    end if
	
	For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 13) = "notecompleted" Then
		pid=right(fieldName, len(fieldName)-13)
		sql="Select * from  ordernote where ordernote_id=" & pid
		Set rs2 = getMysqlUpdateRecordSet(sql, con)
		rs2("action")="Completed"
		rs2.Update
		rs2.close
		set rs2=nothing
	end if
	next
	
	For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 17) = "Note_followupdate" Then
		pid=right(fieldName, len(fieldName)-17)
		sql="Select * from  ordernote where ordernote_id=" & pid
		Set rs2 = getMysqlUpdateRecordSet(sql, con)
		rs2("followupdate")=Request(fieldName)
		rs2("NoteCompletedDate")=now()
		rs2("NoteCompletedBy")=retrieveUserName()
		rs2.Update
		rs2.close
		set rs2=nothing
	end if
	next
	
Con.close
set Con=nothing
response.Write(order_url)
response.redirect(order_url)%>  


   