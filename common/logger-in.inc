<!-- #include file="logger.asp" -->
<%
dim qparam, scriptname
call openLogger()
scriptname = Request.ServerVariables("SCRIPT_NAME")
call log(scriptname, "Enter: No. of query params=" & Request.Querystring.count)
for each qparam in Request.Querystring
	call log(scriptname, "Enter: " & qparam & "=" & Request.Querystring(qparam))
next
%>