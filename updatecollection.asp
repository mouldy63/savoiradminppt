<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR, SAVOIRSTAFF"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim Con, rs, userid, sql, addcollection, msg, location, collectiondate, etadate, shipperaddress, transportmode, containerref, amend, collectid,  formfield,collectionstatus, id, etadate1, destport, deliveryterms, termstext, consignee, consigneebutton
termstext=request("termstext")
collectionstatus=request("collectionstatus")
collectid=request("collectid")
amend=request("amend")
addcollection=request("addcollection")
location=request("location")
collectiondate=request("collectiondate")
shipperaddress=request("shipperaddress")
transportmode=request("transportmode")
containerref=request("containerref")
destport=request("destport")
deliveryterms=request("deliveryterms")
consignee=request("consignee")
consigneebutton=request("consigneebutton")
'response.write("button=" & consigneebutton)
'response.end()
'if consigneebutton="" then consignee="n"
dim showroomarray(), count 

if addcollection<>"" then
			Set Con = getMysqlConnection()
				if amend="y" then
						sql="SELECT * from exportcollections where exportCollectionsID=" & collectid
						Set rs = getMysqlUpdateRecordSet(sql, con)
						rs("collectionStatus")=collectionstatus
						if consigneebutton="" then 
							rs("DeliverToConsignee")="n"
						else
							rs("DeliverToConsignee")="y"
						end if
						if consignee<>"n" then 
							rs("Consignee")=consignee
						else
							rs("Consignee")=null
							rs("DeliverToConsignee")="n"
						end if
					else
						sql="SELECT * from exportcollections"
						Set rs = getMysqlUpdateRecordSet(sql, con)
						rs.AddNew
						rs("collectionstatus")=1
						if consignee<>"n" then rs("Consignee")=consignee
						if consigneebutton<>"" and consignee<>"n" then rs("DeliverToConsignee")="y"
				end if
				if termstext <>"" then rs("termstext")=termstext else rs("termstext")=""
				if collectiondate <>"" then rs("collectiondate")=collectiondate else rs("collectiondate")=""
				if shipperaddress <>"" then rs("shipper")=shipperaddress else rs("shipper")=""
				if deliveryterms <>"n" then rs("ExportDeliveryTerms")=deliveryterms else rs("ExportDeliveryTerms")=0
				if destport <>"" then rs("DestinationPort")=destport else rs("DestinationPort")=""
				if transportmode <>"" then rs("transportmode")=transportmode else rs("transportmode")=""
				if containerref <>"" then rs("containerref")=containerref else rs("containerref")=""
				rs("dateadded")=date()
				rs("addedby")=retrieveuserID()
				rs.Update
				collectid=rs("exportCollectionsID")
				rs.close
				set rs=nothing
				
				if collectionstatus=5 then
						sql="SELECT * from exportlinks where LinksCollectionId=" & collectid
						Set rs = getMysqlUpdateRecordSet(sql, con)
						call log(scriptname, "deleting from exportlinks where LinksCollectionId=" & collectid)
						do until rs.eof
						rs.delete
						rs.movenext
						loop
				end if
				
				if amend<>"y" then
						sql="select * from exportCollShowrooms where exportCollectionID=" & collectid
						Set rs = getMysqlUpdateRecordSet(sql, con)
						if not rs.eof then
						do until rs.eof
							rs.delete
							rs.movenext
							loop
						end if
						rs.close
						set rs=nothing
				
								
						if collectionstatus<>5 then
						For Each formfield in Request.Form
							if left(formfield, 2) = "XX" then
								id = right(formfield, len(formfield)-2)
								 etadate=request.form("YY" & id)
								 if etadate = "" then
									etadate = null
								 else
									etadate = "'" & toMysqlDate(cDate(etadate)) & "'"
								 end if
								con.execute("INSERT INTO exportCollShowrooms (exportCollectionID,idLocation,ETAdate) VALUES (" & collectid & "," & trim(request.form(formfield)) & "," & etadate & ")")
							end if
						Next 
						end if
				end if
				
				if amend="y" then
					if collectionstatus<>5 then
						For Each formfield in Request.Form
							if left(formfield, 2) = "XX" then
								id = right(formfield, len(formfield)-2)
								 etadate=request.form("YY" & id)
								 if etadate = "" then
									etadate = null
								 else
									etadate1 = "'" & toMysqlDate(cDate(etadate)) & "'"
								 end if
								sql="select * from exportCollShowrooms where exportCollectionID=" & collectid & " AND idlocation=" & id
								response.Write(sql & "<br>")
								response.write(etadate)
								Set rs = getMysqlUpdateRecordSet(sql, con)
								if not rs.eof then
										rs("etadate")=etadate
										rs.update
										rs.close
										set rs=nothing	
										redim preserve showroomarray(count)
										showroomarray(count)=id		
								else
										con.execute("INSERT INTO exportCollShowrooms (exportCollectionID,idLocation,ETAdate) VALUES (" & collectid & "," & trim(request.form(formfield)) & "," & etadate1 & ")")
										redim preserve showroomarray(count)
										showroomarray(count)=id
								end if
								end if
						Next
				
					end if
					end if
			
			
				
			Con.Close
				Set Con = Nothing	
end if
	

response.Redirect("/php/plannedexports")
%>
  
<!-- #include file="common/logger-out.inc" -->
