<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Response.Buffer = False
Server.ScriptTimeout =182900%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, rs4, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype, notes, bookeddeliverydate, contactno, orderdate, visitlocation, deliveryaddresses, additionalcontacts, orderstatus, mattstatus,basestatus,topperstatus,valancestatus,legsstatus,hbstatus,accstatus,mattressreq,basereq,topperreq,valancereq,legsreq,hbreq,accreq, accdetails

msg=""



if (retrieveuserid()=2) then	
Set Con = getMysqlConnection()
sql="SELECT P.order_date, P.order_number, L.adminheading, P.Ordersource, P.purchase_no, P.totalexvat, P.mattressrequired, P.baserequired, P.topperrequired, P.valancerequired, P.legsrequired, P.headboardrequired, P.accessoriesrequired FROM Purchase P, Location L WHERE P.idlocation=L.idlocation and P.cancelled='y' and P.order_date > '2020-12-31'"
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
contactno=""

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Order Date,Order No,Location,Order Source,Order Status,Total Ex Vat,Mattress,Mattress Status,Base,Base Status,Topper,Topper Status,Valance,Valance Status,Legs,Legs Status,Headboard,Headboard Status,Accessories,Accessories Status,Accessory Detail")
Do until rs.eof
		orderstatus=""
		mattstatus=""
		basestatus=""
		topperstatus=""
		valancestatus=""
		legsstatus=""
		hbstatus=""
		accstatus=""
		mattressreq="no"
		basereq="no"
		topperreq="no"
		valancereq="no"
		legsreq="no"
		hbreq="no"
		accreq="no"
		accdetails=""
		if rs("mattressrequired")="y" then mattressreq="yes"
		if rs("baserequired")="y" then basereq="yes"
		if rs("topperrequired")="y" then topperreq="yes"
		if rs("valancerequired")="y" then valancereq="yes"
		if rs("legsrequired")="y" then legsreq="yes"
		if rs("headboardrequired")="y" then hbreq="yes"
		if rs("accessoriesrequired")="y" then 
			accreq="yes"
			sql3="Select * from orderaccessory O left join qc_status Q on Q.qc_statusID=O.Status WHERE Purchase_no=" & rs("purchase_no") & ""
			Set rs3 = getMysqlQueryRecordSet(sql3, con)
			if not rs3.eof then
				Do until rs3.eof
				accdetails=accdetails & rs3("description") & " STATUS: " & rs3("QC_status") & " | "
				
				rs3.movenext 
  				loop
				rs3.close
				set rs3=nothing
			end if
		end if
			sql3="Select * from qc_history_latest QC, qc_status QI WHERE QC.qc_statusID=QI.qc_statusID and Purchase_no=" & rs("purchase_no") & ""
			
			Set rs3 = getMysqlQueryRecordSet(sql3, con)
			if not rs3.eof then
				Do until rs3.eof
				if rs3("componentid")=0 then orderstatus=rs3("QC_status")
				if rs3("componentid")=1 then mattstatus=rs3("QC_status")
				if rs3("componentid")=3 then basestatus=rs3("QC_status")
				if rs3("componentid")=5 then topperstatus=rs3("QC_status")
				if rs3("componentid")=6 then valancestatus=rs3("QC_status")
				if rs3("componentid")=7 then legsstatus=rs3("QC_status")
				if rs3("componentid")=8 then hbstatus=rs3("QC_status")
				if rs3("componentid")=9 then accstatus=rs3("QC_status")
				
				rs3.movenext 
  				loop
				rs3.close
				set rs3=nothing
			end if
			
			

excelLine = """" & rs("order_date") & """,""" & rs("order_number") & """,""" & rs("adminheading") & """,""" & rs("ordersource") & """,""" & orderstatus & """,""" & rs("totalexvat") & """,""" & mattressreq & """,""" & mattstatus & """,""" & basereq & """,""" & basestatus & """,""" & topperreq & """,""" & topperstatus & """,""" & valancereq & """,""" & valancestatus & """,""" & legsreq & """,""" & legsstatus & """,""" & hbreq & """,""" & hbstatus & """,""" & accreq & """,""" & accstatus & """,""" & accdetails & """"
tempfile.WriteLine(excelLine)


rs.movenext
loop
rs.close
set rs=nothing

tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)

Response.ContentType = "application/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=""cancelledordersdatadump.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing
Con.Close
Set Con = Nothing
end if
%>
