<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<%Dim con, rs, sql, baserequired, pn, basestatus, baseconfirmeddate, headboardrequired, headboardstatus, headboardconfirmeddate

pn = request("purchaseno")
basestatus = request("baseqc_orig")
baseconfirmeddate = request("baseconfirmeddate")
headboardconfirmeddate = request("headboardconfirmeddate")

Set Con = getMysqlConnection()

sql = "Select * from purchase where purchase_no = " & pn
Set rs = getMysqlQueryRecordSet(sql, con)
baserequired = rs("baserequired")
headboardrequired = rs("headboardrequired")
headboardstatus = request("headboardstatus")
rs.close
set rs = nothing

If baserequired="y" then
	sql = "Select * from qc_history where componentid=3 AND purchase_no = " & pn & " order by QC_date desc"
	Set rs = getMysqlUpdateRecordSet(sql, con)
	if (baseconfirmeddate <> rs("confirmeddate")) or (baseconfirmeddate<>"" and isnull(rs("confirmeddate"))) or (baseconfirmeddate="" and not isnull(rs("confirmeddate"))) then
		if baseconfirmeddate<>"" then rs("confirmeddate")=baseconfirmeddate else rs("confirmeddate")=null
		rs("qc_date")=Now()
		rs("updatedby")=retrieveuserid()
		rs.update
	end if
	closers(rs)
end if

If headboardrequired="y" then
	sql = "Select * from qc_history where componentid=8 AND purchase_no = " & pn & " order by QC_date desc"
	Set rs = getMysqlUpdateRecordSet(sql, con)
	if (headboardconfirmeddate <> rs("confirmeddate")) or (headboardconfirmeddate<>"" and isnull(rs("confirmeddate"))) or (headboardconfirmeddate="" and not isnull(rs("confirmeddate"))) then
		if headboardconfirmeddate<>"" then rs("confirmeddate")=headboardconfirmeddate else rs("confirmeddate")=null
		rs("qc_date")=Now()
		rs("updatedby")=retrieveuserid()
		rs.update
	end if
	closers(rs)
end if

Con.Close
Set Con = Nothing
response.redirect("orderdetails.asp?pn=" & pn & "&msg=Details updated")
%>
<!-- #include file="common/logger-out.inc" -->
