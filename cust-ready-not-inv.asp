<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, recordfound, id, sql, asql, i, excellist, strmonth, stryear, deldate, selectd, bcwwarehouse, tmpdate
excellist=""
excellist=request("excellist")
strmonth=month(date())
if request("month")<>"" then strmonth=request("month")
stryear=year(date())
if request("year")<>"" then stryear=request("year")
deldate = stryear & "-" & strmonth & "-" & left(DateSerial(stryear, strmonth + 1, 0), 2)
tmpdate = DateSerial(stryear, strmonth + 1, 1)
bcwwarehouse = right(tmpdate, 4) & "-" & mid(tmpdate, 4, 2) & "-" & left(tmpdate, 2)
submit=request("submit")
Set Con = getMysqlConnection()
asql = "select * from purchase p join location l on p.idlocation=l.idlocation"
asql = asql & " join contact c on c.contact_no=p.contact_no"
asql = asql & " join address a on a.code=c.code"
asql = asql & " join (select purchase_no as qc_purchase_no, max(deliverydate) as deldate from qc_history_latest where (madeat=1 or madeat=2) and componentid not in (0,9) group by purchase_no) qc on p.purchase_no=qc.qc_purchase_no"
asql = asql & " left join (select purchase_no as qc1_purchase_no, max(bcwwarehouse) as bcwwarehouse1 from qc_history_latest where madeat=1 and componentid not in (0,9) group by purchase_no) qc1 on p.purchase_no=qc1.qc1_purchase_no"
asql = asql & " left join (select purchase_no as qc2_purchase_no, max(bcwwarehouse) as bcwwarehouse2 from qc_history_latest where madeat=2 and componentid not in (0,9) group by purchase_no) qc2 on p.purchase_no=qc2.qc2_purchase_no"
asql = asql & " where (p.cancelled = 'n' or p.cancelled is null)"
asql = asql & " and year(p.production_completion_date)=" & stryear
asql = asql & " and month(p.production_completion_date)=" & strmonth
asql = asql & " and (qc.deldate is null or qc.deldate > '" & deldate & "')"
asql = asql & " and (qc1.qc1_purchase_no is null or (qc1.bcwwarehouse1 is not null and qc1.bcwwarehouse1 < '" & bcwwarehouse & "'))"

if excellist="" then%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

<style type="text/css">
.tablebd {
	border: 1px solid #666;
}
</style>
</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<form action="cust-ready-not-inv.asp" method="post" name="form2" onSubmit="return FrontPage_Form2_Validator(this)">	
					  <div class="content brochure">
			    <div class="one-col head-col">
			<p>Customer Ready Not Invoiced Reports</p>
                </div>


		<div class="two-col">
         <div class="row">
        <div class="row">
		  <p>Month 
<label>
    <select name="month" id="month" >
      <option value="n">Select Month</option>
      <%selectd=""
	  
	  if MonthName(strmonth)=MonthName(month(date())) then selectd="selected" else selectd=""%>
      <option value="<%=month(date())%>" <%=selectd%>><%=MonthName(month(date()))%></option>
      <%For i=1 to 11
	  if MonthName(strmonth)=MonthName(month(DateAdd("m",-i,date()))) then selectd="selected" else selectd=""%>
      <option value="<%=month(DateAdd("m",-i,date()))%>" <%=selectd%>><%=MonthName(month(DateAdd("m",-i,date())))%></option>
      <% next%>
      </select>
  </label>
				  Year
				  <label>
				    <select name="year" id="year">
                     <%selectd=""
					 
					 if stryear=Year(date()) then selectd="selected" else selectd=""%>%>
				      <option value="<%=Year(date())%>" <%=selectd%>><%=Year(date())%></option>
				      <%For i=1 to 10
					  
					  if CInt(stryear)=year(date())-i then selectd="selected" else selectd=""%>%>
				      <option value="<%=year(date())-i%>" <%=selectd%>><%=year(date())-i%></option>
				      <% next%>
			        </select>
			      </label>
				  </h2>
		  </p>
</div>
            <div class="row">
              <input type="submit" name="submit" value="Produce Report"  id="submit" class="button" />
              <label>
                <input name="excellist" type="submit" class="button" id="excellist" value="Download CSV">
              </label>
<input name="Reset" type="reset" class="button" id="button" value="Reset Form">
            </div>
         </div>
		</div>
  </div>
<div>
</div>
        </form>
<%if submit<>"" then
'response.Write(sql & "<br>")
Set rs = getMysqlUpdateRecordSet(asql, con)
response.Write("No. of records: ") & rs.recordcount%>
<table width="100%" border="1" cellspacing="0" cellpadding="4" class="tablebd">
  <tr class="tablebd">
    <td align="left" valign="top"><strong>Customer Name</strong></td>
    <td align="left" valign="top"><strong>Company Name</strong></td>
    <td align="left" valign="top"><strong>Order No.</strong></td>
    <td align="left" valign="top"><strong>Showroom</strong></td>
    <td align="left" valign="top"><strong>Production Completion Date</strong></td>
    <td align="left" valign="top"><strong>Delivery Date</strong></td>
  </tr>
<%Do until rs.eof%>	
  <tr class="tablebd">
    <td><%response.Write("<a href=""editcust.asp?val=" & rs("contact_no") & """>" & rs("surname") & " " & rs("first") & " " & rs("title")) & "</a>"%>&nbsp;</td>
    <td><%=rs("company")%>&nbsp;</td>
    <td><%response.Write("<a href=""orderdetails.asp?pn=" & rs("purchase_no") & """>" & rs("order_number") & "</a>")%>&nbsp;</td>
    <td><%=rs("adminheading")%>&nbsp;</td>
    <td><%=left(rs("production_completion_date"),10)%>&nbsp;</td>
    <td><%=rs("deldate")%>&nbsp;</td>
  </tr>
<%rs.movenext
loop
rs.close
set rs=nothing		%>
</table>
<%end if%>
</body>
</html>


<%end if
If Request("excellist")<>"" then
Set rs = getMysqlUpdateRecordSet(asql, con)
Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
brochuremsg="Customer Ready Not Invoice for  " & monthname(strmonth) & " "  & stryear
tempfile.WriteLine(brochuremsg)
tempfile.WriteLine("Customer Name,Company Name,Order No.,Showroom,Production Completion Date,Delivery Date")
Do until rs.eof
excelLine = """" & rs("surname") & " " & rs("first") & " " & rs("title") & """,""" & rs("company") &  """,""" & rs("order_number") &  """,""" & rs("adminheading") &  """,""" & left(rs("production_completion_date"),10) &  """,""" & rs("deldate") &  """"
tempfile.WriteLine(excelLine)
rs.movenext
loop


tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)

Response.ContentType = "application/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=""customer-ready-notinvoiced.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing
end if
Con.Close
Set Con = Nothing

if excellist="" then%>
  
<script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form2_Validator(theForm)
{
 
   if (theForm.month.value == "n")
  {
    alert("Please enter a month");
    theForm.month.focus();
    return (false);
  }



    return true;
} 

//-->
</script>
<%end if%>
