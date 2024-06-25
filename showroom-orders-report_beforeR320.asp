<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, dateasc, orderasc, customerasc, coasc, datefrom, datefromstr, datetostr, dateto, dateto1, user, rs2, rs3, receiptasc, amttotal, currencysym, ordervaltotal, totalpayments, totalos, location, payasc, matt1TOTAL, matt2TOTAL, matt3TOTAL, matt4TOTAL, mattFrenchTOTAL, mattStateTOTAL, base1TOTAL, base2TOTAL, base3TOTAL, base4TOTAL, basePegTOTAL, basePlatTOTAL, baseSlimTOTAL, baseStateTOTAL, cwtopperTOTAL, hcatopperTOTAL, hwtopperTOTAL, cwtopperonlyTOTAL, hcatopperonlyTOTAL, hwtopperonlyTOTAL, legsTOTAL, hbTOTAL, hide, locationname, recno, sql1, sql2
Session.LCID = 2057
Dim ncountries
locationname=""
hide=""
location=request("location")
Set Con = getMysqlConnection()
if location<>"all" and location<>"allplus" and location<>"" then
	Set rs = getMysqlQueryRecordSet("Select adminheading from location where idlocation=" & location , con)
	if not rs.eof then
	locationname=rs("adminheading")
	end if
	rs.close
	set rs=nothing
end if

matt1TOTAL=0 
matt2TOTAL=0
matt3TOTAL=0
matt4TOTAL=0
mattFrenchTOTAL=0
mattStateTOTAL=0
base1TOTAL=0
base2TOTAL=0
base3TOTAL=0
base4TOTAL=0
basePegTOTAL=0
basePlatTOTAL=0
baseSlimTOTAL=0
baseStateTOTAL=0
cwtopperTOTAL=0
hcatopperTOTAL=0
hwtopperTOTAL=0
cwtopperonlyTOTAL=0
hcatopperonlyTOTAL=0
hwtopperonlyTOTAL=0
legsTOTAL=0
hbTOTAL=0
Dim i
Dim allcountries
submit=Request("submit") 
if submit<>"" then
allcountries="P.idlocation IN ("
if location="all" and location<>"" then
	sql="Select adminheading, idlocation from location where retire='n' order by adminheading"
end if
if location="allplus" and location<>"" then
	sql="Select adminheading, idlocation from location where adminheading is not null order by adminheading"
end if
if location<>"allplus" and location<>"all" and location<>"" then
	sql="Select adminheading, idlocation from location where idlocation =" & location
end if

	Set rs = getMysqlQueryRecordSet(sql, con)
	ncountries=rs.recordcount

	
	ReDim countryarray(ncountries), matt1(ncountries), matt2(ncountries), matt3(ncountries), matt4(ncountries), mattFrench(ncountries), mattState(ncountries), base1(ncountries), base2(ncountries), base3(ncountries), base4(ncountries), basePeg(ncountries), basePlat(ncountries), baseSlim(ncountries), baseState(ncountries), cwtopper(ncountries), hcatopper(ncountries), hwtopper(ncountries), cwtopperonly(ncountries), hcatopperonly(ncountries), hwtopperonly(ncountries), legs(ncountries), hb(ncountries)
	ReDim countrynamearray(ncountries)
	count=1
	Do until rs.eof
	countryarray(count) = rs("idlocation")
	countrynamearray(count)=rs("adminheading")
	count=count+1
	allcountries=allcountries & rs("idlocation") & ","
	rs.movenext
	loop
	rs.close
	set rs=nothing
	
	allcountries=left(allcountries, len(allcountries)-1) & ")"




for i=1 to ncountries
matt1(i)=0
matt2(i)=0
matt3(i)=0
matt4(i)=0
mattFrench(i)=0
mattState(i)=0
base1(i)=0
base2(i)=0
base3(i)=0
base4(i)=0
basePeg(i)=0
basePlat(i)=0
baseSlim(i)=0
baseState(i)=0
cwtopper(i)=0
hcatopper(i)=0
hwtopper(i)=0
cwtopperonly(i)=0
hcatopperonly(i)=0
hwtopperonly(i)=0
legs(i)=0
hb(i)=0

next




datefromstr=Request("datefrom")

If datefromstr <>"" then
datefrom=year(datefromstr) & "-" & month(datefromstr) & "-" & day(datefromstr)
end if
datetostr=Request("dateto")
If datetostr <>"" then
datetostr=DateAdd("d",1,datetostr)
dateto=year(datetostr) & "-" & month(datetostr) & "-" & day(datetostr)

end if

count=0


if location<>"all" and location<>"allplus" then ncountries=1
for i=1 to ncountries
	if location="all" or location="allplus" then
	sql="Select P.savoirmodel, count(*) as n from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.mattressrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.savoirmodel"
	else
	sql="Select P.savoirmodel, count(*) as n from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.mattressrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.savoirmodel"
	end if

                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof
						if rs("savoirmodel")="No. 1" then matt1(i)=rs("n")
						if rs("savoirmodel")="No. 2" then matt2(i)=rs("n")
						if rs("savoirmodel")="No. 3" then matt3(i)=rs("n")
						if rs("savoirmodel")="No. 4" then matt4(i)=rs("n")
						if rs("savoirmodel")="French Mattress" then mattFrench(i)=rs("n")
						if rs("savoirmodel")="State" then mattState(i)=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
	if location="all" or location="allplus" then
	sql="Select P.basesavoirmodel, count(*) as n from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.baserequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.basesavoirmodel"
	else
	sql="Select P.basesavoirmodel, count(*) as n from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.baserequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.basesavoirmodel"
	end if

                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof						
						if rs("basesavoirmodel")="No. 1" then base1(i)=rs("n")
						if rs("basesavoirmodel")="No. 2" then base2(i)=rs("n")
						if rs("basesavoirmodel")="No. 3" then base3(i)=rs("n")
						if rs("basesavoirmodel")="No. 4" then base4(i)=rs("n")
						if rs("basesavoirmodel")="Pegboard" then basePeg(i)=rs("n")
						if rs("basesavoirmodel")="Platform Base" then basePlat(i)=rs("n")
						if rs("basesavoirmodel")="Savoir Slim" then baseSlim(i)=rs("n")
						if rs("basesavoirmodel")="State" then baseState(i)=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
						
	if location="all" or location="allplus" then
	sql="Select P.toppertype, count(*) as n from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (P.mattressrequired='y' or baserequired='y') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	else
	sql="Select P.toppertype, count(*) as n from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (P.mattressrequired='y' or baserequired='y') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	end if

                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof						
						if rs("toppertype")="CW Topper" then cwtopper(i)=rs("n")
						if rs("toppertype")="HCa Topper" then hcatopper(i)=rs("n")
						if rs("toppertype")="HW Topper" then hwtopper(i)=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
	if location="all" or location="allplus" then
	sql="Select P.toppertype, count(*) as n from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (mattressrequired='n' and baserequired='n') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	else
	sql="Select P.toppertype, count(*) as n from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (mattressrequired='n' and baserequired='n') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	end if

                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof						
						if rs("toppertype")="CW Topper" then cwtopperonly(i)=rs("n")
						if rs("toppertype")="HCa Topper" then hcatopperonly(i)=rs("n")
						if rs("toppertype")="HW Topper" then hwtopperonly(i)=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing

	if location="all" or location="allplus" then
	sql="Select count(*) as n from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.legsrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	else
	sql="Select count(*) as n from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.legsrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	end if

                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof	
						legs(i)=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
	if location="all" or location="allplus" then
	sql="Select count(*) as n from purchase P where P.idlocation=" & countryarray(i) & " and (P.cancelled is Null or P.cancelled='n') and P.headboardrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	else
	sql="Select count(*) as n from purchase P where P.idlocation=" & location & " and (P.cancelled is Null or P.cancelled='n') and P.headboardrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	end if

                        Set rs = getMysqlQueryRecordSet(sql , con)
						Do until rs.eof						
						hb(i)=rs("n")
						rs.movenext
						loop
						rs.close
						set rs=nothing
						
	next
	
	if location="all" or location="allplus" then	
	'totals sql
	sql="Select P.savoirmodel, count(*) as n from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.mattressrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.savoirmodel"

	
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof
							if rs("savoirmodel")="No. 1" then matt1TOTAL=rs("n")
							if rs("savoirmodel")="No. 2" then matt2TOTAL=rs("n")
							if rs("savoirmodel")="No. 3" then matt3TOTAL=rs("n")
							if rs("savoirmodel")="No. 4" then matt4TOTAL=rs("n")
							if rs("savoirmodel")="French Mattress" then mattFrenchTOTAL=rs("n")
							if rs("savoirmodel")="State" then mattStateTOTAL=rs("n")
							rs.movenext
							loop
							rs.close
							set rs=nothing
							
	sql="Select P.basesavoirmodel, count(*) as n from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.baserequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.basesavoirmodel"
	
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							if rs("basesavoirmodel")="No. 1" then base1TOTAL=rs("n")
							if rs("basesavoirmodel")="No. 2" then base2TOTAL=rs("n")
							if rs("basesavoirmodel")="No. 3" then base3TOTAL=rs("n")
							if rs("basesavoirmodel")="No. 4" then base4TOTAL=rs("n")
							if rs("basesavoirmodel")="Pegboard" then basePegTOTAL=rs("n")
							if rs("basesavoirmodel")="Platform Base" then basePlatTOTAL=rs("n")
							if rs("basesavoirmodel")="Savoir Slim" then baseSlimTOTAL=rs("n")
							if rs("basesavoirmodel")="State" then baseStateTOTAL=rs("n")
							rs.movenext
							loop
							rs.close
							set rs=nothing
							
	sql="Select P.toppertype, count(*) as n from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (P.mattressrequired='y' or baserequired='y') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							if rs("toppertype")="CW Topper" then cwtopperTOTAL=rs("n")
							if rs("toppertype")="HCa Topper" then hcatopperTOTAL=rs("n")
							if rs("toppertype")="HW Topper" then hwtopperTOTAL=rs("n")
							rs.movenext
							loop
							rs.close
							set rs=nothing
							
	sql="Select P.toppertype, count(*) as n from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.topperrequired='y' and (mattressrequired='n' and baserequired='n') and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "' group by P.toppertype"
	
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							if rs("toppertype")="CW Topper" then cwtopperonlyTOTAL=rs("n")
							if rs("toppertype")="HCa Topper" then hcatopperonlyTOTAL=rs("n")
							if rs("toppertype")="HW Topper" then hwtopperonlyTOTAL=rs("n")
							rs.movenext
							loop
							rs.close
							set rs=nothing
	
	sql="Select count(*) as n from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.legsrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							legsTOTAL=rs("n")
							rs.movenext
							loop
							rs.close
							set rs=nothing
							
	sql="Select count(*) as n from purchase P where " & allcountries & " and (P.cancelled is Null or P.cancelled='n') and P.headboardrequired='y' and P.code<>15919 and P.order_date >= '" & datefrom & "' and P.order_date <= '" & dateto & "'"
	
							Set rs = getMysqlQueryRecordSet(sql , con)
							Do until rs.eof						
							hbTOTAL=rs("n")
							rs.movenext
							loop
							rs.close
							set rs=nothing
										
	end if
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

<script src="scripts/keepalive.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<script>
$(function() {
var year = new Date().getFullYear();
$( "#datefrom" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#datefrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#dateto" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#dateto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});

</script>
<%if location<>"all" and location<>"allplus" then
hide="hide"%>
<style>
.hide {display:none;}

</style>
<%end if%>
</head>
<body>

<div class="containerfull">
<!-- #include file="header.asp" -->
	
<form action="showroom-orders-report.asp" method="post" name="form1">					  
    <div class="contentfull brochure">
			    <div class="one-col head-col">
			<p>Showroom Orders Report</p>
			<table border="0" align="center" cellpadding="5" cellspacing="2">
					    <tr>
					      <td><label for="datefrom" id="surname"><strong>Date of Order Start :</strong><br>
		  <input name="datefrom" type="text" class="text" id="datefrom" value="<%=request("datefrom")%>" size="10" /></label></td>
					      <td><strong>Date of Order End: </strong><br>
                          <input name="dateto" type="text" class="text" id="dateto" size="10" value="<%=request("dateto")%>" /></td>
					      <td> <%Dim optionselected
                                    sql = "Select * from location where retire<>'y' order by adminheading"
                                    Set rs = getMysqlQueryRecordSet(sql, con)
                                    %>

                                    <select name = "location" size = "1" class = "formtext" id = "location">
                                    <%optionselected=""
									if location="all" then optionselected="selected"%>
                                   	  <option value = "all" <%=optionselected%>>Current Showrooms</option>
                                      <%optionselected=""
									  if location="allplus" then optionselected="selected"%>
                                      <option value = "allplus" <%=optionselected%>>Current & Retired</option>
                                        
                                        <%
                                        do until rs.EOF
										optionselected=""
                                        if locationname=rs("adminheading") then optionselected="selected"%>

                                      <option value = "<%=rs("idlocation")%>" <%=optionselected%>><%=rs("adminheading")%></option>
                                        <%
                                        rs.movenext
                                        loop
                                        rs.Close
                                        Set rs = Nothing
                                        %>
                                    </select>&nbsp;</td>
              </tr>
                      
					    <tr>
					      <td colspan="3" align="left">				          
					        <input type = "submit" name = "submitcsv" value = "Download CSV" id = "submitcsv"
                                        class = "button" onClick="return setFormAction('csv')" />
					        <input type = "submit" name = "submit" value = "Search" id = "submit"
                                        class = "button" onClick="return setFormAction('')" />
					      </td>
	      </tr>
			      </table>
<%if submit<>"" then%>				
          <p>&nbsp;</p>
          <p align="center">Dates: From <%=request("datefrom")%> to <%=request("dateto")%><br>
          </p>
<table border="0" cellspacing="3" cellpadding="1" align="center">
<%if location="all" or location="allplus" then%>
  <tr>
    <td>&nbsp;</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><strong>
<%=countrynamearray(i)%>
</strong></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><strong>TOTAL</strong></td>
    </tr>
<%else%>
<td>&nbsp;</td>
    <td bgcolor="#FFFFFF"><strong><%=locationname%></strong></td>
    <td>&nbsp;</td>
<%end if%>
  <tr>
    <td><strong>Mattresses</strong></td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td>No. 1</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=matt1(i)%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=matt1TOTAL%></td>
    </tr>
  <tr>
    <td>No. 2</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=matt2(i)%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=matt2TOTAL%></td>
    </tr>
  <tr>
    <td>No. 3</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=matt3(i)%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=matt3TOTAL%></td>
    </tr>
  <tr>
    <td>No. 4</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=matt4(i)%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=matt4TOTAL%></td>
    </tr>
  <tr>
    <td>French Mattress</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=mattFrench(i)%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=mattFrenchTOTAL%></td>
    </tr>
  <tr>
    <td>State</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=mattState(i)%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=mattStateTOTAL%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>">&nbsp;</td>
    </tr>
  <tr>
    <td><strong>Box Springs</strong></td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td>No. 1</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=base1(i)%>&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=base1TOTAL%></td>
    </tr>
  <tr>
    <td>No. 2</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=base2(i)%>&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=base2TOTAL%></td>
    </tr>
  <tr>
    <td>No. 3</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=base3(i)%>&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=base3TOTAL%></td>
    </tr>
  <tr>
    <td>No. 4</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=base4(i)%>&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=base4TOTAL%></td>
    </tr>
  <tr>
    <td>Pegboard</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=basePeg(i)%>&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=basePegTOTAL%></td>
    </tr>
  <tr>
    <td>Platform</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=basePlat(i)%>&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=basePlatTOTAL%></td>
    </tr>
  <tr>
    <td>Savoir Slim</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=baseSlim(i)%>&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=baseSlimTOTAL%></td>
    </tr>
  <tr>
    <td>State</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=baseState(i)%>&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=baseStateTOTAL%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td><strong>Toppers Linked with mattress or base</strong></td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td>HCA</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=hcatopper(i)%>&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=hcatopperTOTAL%></td>
    </tr>
  <tr>
    <td>HW</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=hwtopper(i)%>&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=hwtopperTOTAL%></td>
    </tr>
  <tr>
    <td>CW</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=cwtopper(i)%>&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=cwtopperTOTAL%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td><strong>Toppers only (no base or mattress)</strong></td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td>HCA</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=hcatopperonly(i)%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=hcatopperonlyTOTAL%></td>
    </tr>
  <tr>
    <td>HW</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=hwtopperonly(i)%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=hwtopperonlyTOTAL%></td>
    </tr>
  <tr>
    <td>CW</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=cwtopperonly(i)%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=cwtopperonlyTOTAL%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td><strong>Legs</strong></td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=legs(i)%>&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=legsTOTAL%></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF">&nbsp;</td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"></td>
    </tr>
  <tr>
    <td><strong>Headboards</strong></td>
    <%for i=1 to ncountries%>
    <td bgcolor="#FFFFFF"><%=hb(i)%></td>
    <%next%>
    <td bgcolor="#FFFFFF" class="<%=hide%>"><%=hbTOTAL%></td>
    </tr>
          </table>
          <p>&nbsp;</p>
          <p>
            <%end if%>
          </p>
        </div>
  </div>
<div>
</div>
        </form>
</body>
</html>

 <%Con.Close
Set Con = Nothing%> 
<!-- #include file="common/logger-out.inc" -->
<script Language="JavaScript" type="text/javascript">

	function setFormAction(actionName) {
		if (actionName == "csv") {
			document.form1.action = "showroom-orders-csv.asp"
		} else {
			document.form1.action = "showroom-orders-report.asp"
		}
		return true;
	}

</script>