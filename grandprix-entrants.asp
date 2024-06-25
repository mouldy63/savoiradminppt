<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncsGrandPrix.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, recordfound, id, sql, i, excel, des1, des2, des3, entrantyear
entrantyear=request("entrantyear")
excel="n"
msg=""
msg=Request("msg")
excel=request("excel")
Set Con = getMysqlConnection()
sql="SELECT * from designapplicants where year(dateadded)=" & entrantyear & " order by lastname"
Set rs = getMysqlQueryRecordSet(sql, con)

if excel<>"y" then%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script type="text/javascript">
<!--
function winconfirm(rsid){
var answer = confirm ("Are you sure you want to delete this entrant?")
if (answer)
window.location="delentrant.asp?entrantyear=<%=entrantyear%>&id=" + rsid;
else
alert ("Ok - this entrant will NOT be deleted")
}
// -->
</script> 
</head>
<body>
<div class="container">
<!-- #include file="header.asp" -->
	
					  <div class="content brochure">
			    <div class="one-col head-col">
			<p><%=rs.recordcount%> Grandprix design entrants 
             - <a href="grandprix-entrants.asp?excel=y&entrantyear=<%=entrantyear%>">Click here for Excellist</a></p>
             <%if msg<>"" then response.write("<font color=""red"">" & msg & "</font>")%>
                </div>

		  <table border="0" cellspacing="3" cellpadding="3" align="center" class="tblborder">
		    <tr>
		      <td width="38" class="redtext">id</td>
		      <td width="181" class="redtext">Last Name</td>
		      <td width="364" class="redtext">Email/Tel</td>
		      <td width="364" class="redtext">Website/School</td>
		      <td width="181" class="redtext">City/Coountry</td>
		      <td width="364" class="redtext">Design-1</td>
		      <td width="364" class="redtext">Design-2</td>
		      <td width="89" class="redtext">Design-3</td>
		      <td width="89" class="redtext">Feedback Requested</td>
		      <td width="43" class="redtext">Date Added</td>
		      <td width="43" class="redtext">DELETE</td>
		      
	        </tr>
<%'response.Write("sql=" & sql)
Do until rs.eof%>		    <tr>
		      <td><%=rs("id")%></td>
		      <td><%if rs("lastname")<>"" then response.write(rs("lastname"))
			  if rs("firstname")<>"" then response.write(",<br />" & rs("firstname"))
			  if rs("title")<>"" then response.write(",<br />" & rs("title"))
			  %></td>
		      <td><%if rs("email")<>"" then response.Write("E: " & rs("email") & "<br />")%>
		      <%if rs("tel")<>"" then response.Write("T: " & rs("tel"))%></td>
		      <td><%=rs("website")%><br>
		      <%=rs("school")%></td>
		      <td><%=rs("city")%><br>
		        <%=rs("country")%></td>
		      <td><%response.Write(rs("design1") & "<br />" & rs("id") & "-1-" & rs("lastname") & ".pdf")%></td>
		      <td><%if rs("design2") <>"" then response.Write(rs("design2") & "<br />" & rs("id") & "-2-" & rs("lastname") & ".pdf")%></td>
		      <td><%if rs("design3") <>"" then response.Write(rs("design3") & "<br />" & rs("id") & "-3-" & rs("lastname") & ".pdf")%></td>
		      <td><%response.Write(rs("feedback"))%></td>
		      <td><%=rs("dateadded")%></td>
		      <td><a href="delentrant.asp?entrantyear=<%=entrantyear%>&id=<%=rs("id")%>" onClick="winconfirm(<%=rs("id")%>); return false;">DELETE</a></td>
		      
		      </tr>
           <%rs.movenext
		   loop
		%>
	      </table>
		
  </div>
<div>
</div>
        </form>
</body>
</html>
<%end if
If Request("excel")="y" then
Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
'response.write("tempname = " & tempname)
'response.write("tempfolder = " & tempfolder)
'response.end
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
brochuremsg="Savoirgrandprix Entrants "
tempfile.WriteLine(brochuremsg)
tempfile.WriteLine("ID,Lastname,Firstname,Title,Email,Tel,Website,School,City,Country,Design 1,Design 1 pdfname,Design 2,Design 2 pdfname,Design 3,Design 3 pdfname,Date Added")
Do until rs.eof
des1=""
des2=""
des3=""
if rs("design1")<>"" then des1=rs("id") & "-1-" & rs("lastname") & ".pdf"
if rs("design2")<>"" then des2=rs("id") & "-2-" & rs("lastname") & ".pdf"
if rs("design3")<>"" then des3=rs("id") & "-3-" & rs("lastname") & ".pdf"
excelLine = """" & rs("id") & """,""" & rs("lastname") &  """,""" & rs("firstname") &  """,""" & rs("title") &  """,""" & rs("email") &  """,""" & rs("tel") &  """,""" & rs("website") &  """,""" & rs("school") &  """,""" & rs("city") &  """,""" & rs("country") &  """,""" & rs("design1") &  """,""" & des1 &  """,""" & rs("design2") &  """,""" & des2 &  """,""" & rs("design3") &  """,""" & des3 &  """"
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
Response.AddHeader "Content-Disposition", "attachment; filename=""grandprix-entrants.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing
end if
Con.Close
Set Con = Nothing
%>
  
<!-- #include file="common/logger-out.inc" -->
