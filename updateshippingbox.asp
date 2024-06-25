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
<%Dim  Con, rs, rs1, addproduct, component,productname,weight,tariff,depth,msg,sql, submit
submit=request("Submit")
if submit<>"" then


Set Con = getMysqlConnection()
sql="Select * from shippingbox where sName='Small'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("widthS")<>"" then rs("width")=request("widthS") else rs("width")=0
if request("lengthS")<>"" then rs("length")=request("lengthS") else rs("length")=0
if request("weightS")<>"" then rs("weight")=request("weightS") else rs("weight")=0
if request("depthS")<>"" then rs("depth")=request("depthS") else rs("depth")=0
if request("packwidthS")<>"" then rs("packallowancewidth")=request("packwidthS") else rs("packallowancewidth")=0
if request("packlengthS")<>"" then rs("packallowancelength")=request("packlengthS") else rs("packallowancelength")=0
rs.update
rs.close
set rs=nothing
sql="Select * from shippingbox where sName='Medium'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("widthM")<>"" then rs("width")=request("widthM") else rs("width")=0
if request("lengthM")<>"" then rs("length")=request("lengthM") else rs("length")=0
if request("weightM")<>"" then rs("weight")=request("weightM") else rs("weight")=0
if request("depthM")<>"" then rs("depth")=request("depthM") else rs("depth")=0
if request("packwidthM")<>"" then rs("packallowancewidth")=request("packwidthM") else rs("packallowancewidth")=0
if request("packlengthM")<>"" then rs("packallowancelength")=request("packlengthM") else rs("packallowancelength")=0
rs.update
rs.close
set rs=nothing

sql="Select * from shippingbox where sName='Large'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("widthL")<>"" then rs("width")=request("widthL") else rs("width")=0
if request("lengthL")<>"" then rs("length")=request("lengthL") else rs("length")=0
if request("weightL")<>"" then rs("weight")=request("weightL") else rs("weight")=0
if request("depthL")<>"" then rs("depth")=request("depthL") else rs("depth")=0
if request("packwidthL")<>"" then rs("packallowancewidth")=request("packwidthL") else rs("packallowancewidth")=0
if request("packlengthL")<>"" then rs("packallowancelength")=request("packlengthL") else rs("packallowancelength")=0
rs.update
rs.close
set rs=nothing
sql="Select * from shippingbox where sName='LegBox'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("widthLB")<>"" then rs("width")=request("widthLB") else rs("width")=0
if request("heightLB")<>"" then rs("height")=request("heightLB") else rs("height")=0
if request("depthLB")<>"" then rs("depth")=request("depthLB") else rs("depth")=0
rs.update
rs.close
set rs=nothing
sql="Select * from shippingbox where sName='WoodenCrates'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("woodencrates")<>"" then rs("weight")=request("woodencrates") else rs("weight")=0
rs.update
rs.close
set rs=nothing
sql="Select * from shippingbox where sName='internalcrate'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("internalcrate")<>"" then rs("allowance")=request("internalcrate") else rs("allowance")=0
rs.update
rs.close
set rs=nothing
sql="Select * from shippingbox where sName='additionalcrate'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("additionalcrate")<>"" then rs("allowance")=request("additionalcrate") else rs("allowance")=0
rs.update
rs.close
set rs=nothing
sql="Select * from shippingbox where sName='roundcrate'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("roundcrate")<>"" then rs("roundtonearest")=request("roundcrate") else rs("roundtonearest")=0
rs.update
rs.close
set rs=nothing
sql="Select * from shippingbox where sName='hcatopper'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("hca")<>"" then rs("allowance")=request("hca") else rs("allowance")=0
rs.update
rs.close
set rs=nothing
sql="Select * from shippingbox where sName='StateHCaTopper'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("statehca")<>"" then rs("allowance")=request("statehca") else rs("allowance")=0
rs.update
rs.close
set rs=nothing
sql="Select * from shippingbox where sName='hwtopper'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("hw")<>"" then rs("allowance")=request("hw") else rs("allowance")=0
rs.update
rs.close
set rs=nothing
sql="Select * from shippingbox where sName='cwtopper'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("cw")<>"" then rs("allowance")=request("cw") else rs("allowance")=0
rs.update
rs.close
set rs=nothing

sql="Select * from shippingbox where sName='Expak MB'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("internalLengthExpakMB")<>"" then rs("internallength")=request("internalLengthExpakMB") else rs("internallength")=0
if request("internalWidthExpakMB")<>"" then rs("internalwidth")=request("internalWidthExpakMB") else rs("internalwidth")=0
if request("internalHeightExpakMB")<>"" then rs("internalheight")=request("internalHeightExpakMB") else rs("internalheight")=0
if request("widthExpakMB")<>"" then rs("width")=request("widthExpakMB") else rs("width")=0
if request("lengthExpakMB")<>"" then rs("length")=request("lengthExpakMB") else rs("length")=0
if request("heightExpakMB")<>"" then rs("height")=request("heightExpakMB") else rs("height")=0
if request("weightExpakMB")<>"" then rs("weight")=request("weightExpakMB") else rs("weight")=0
rs.update
rs.close
set rs=nothing

sql="Select * from shippingbox where sName='Expak T'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("internalLengthExpakT")<>"" then rs("internallength")=request("internalLengthExpakT") else rs("internallength")=0
if request("internalWidthExpakT")<>"" then rs("internalwidth")=request("internalWidthExpakT") else rs("internalwidth")=0
if request("internalHeightExpakT")<>"" then rs("internalheight")=request("internalHeightExpakT") else rs("internalheight")=0
if request("widthExpakT")<>"" then rs("width")=request("widthExpakT") else rs("width")=0
if request("lengthExpakT")<>"" then rs("length")=request("lengthExpakT") else rs("length")=0
if request("heightExpakT")<>"" then rs("height")=request("heightExpakT") else rs("height")=0
if request("weightExpakT")<>"" then rs("weight")=request("weightExpakT") else rs("weight")=0
rs.update
rs.close
set rs=nothing

sql="Select * from shippingbox where sName='Expak 1M'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("internalLengthExpak1M")<>"" then rs("internallength")=request("internalLengthExpak1M") else rs("internallength")=0
if request("internalWidthExpak1M")<>"" then rs("internalwidth")=request("internalWidthExpak1M") else rs("internalwidth")=0
if request("internalHeightExpak1M")<>"" then rs("internalheight")=request("internalHeightExpak1M") else rs("internalheight")=0
if request("widthExpak1M")<>"" then rs("width")=request("widthExpak1M") else rs("width")=0
if request("lengthExpak1M")<>"" then rs("length")=request("lengthExpak1M") else rs("length")=0
if request("heightExpak1M")<>"" then rs("height")=request("heightExpak1M") else rs("height")=0
if request("weightExpak1M")<>"" then rs("weight")=request("weightExpak1M") else rs("weight")=0
rs.update
rs.close
set rs=nothing

sql="Select * from shippingbox where sName='Expak H'"
Set rs = getMysqlUpdateRecordSet(sql , con)
if request("internalLengthExpakH")<>"" then rs("internallength")=request("internalLengthExpakH") else rs("internallength")=0
if request("internalWidthExpakH")<>"" then rs("internalwidth")=request("internalWidthExpakH") else rs("internalwidth")=0
if request("internalHeightExpakH")<>"" then rs("internalheight")=request("internalHeightExpakH") else rs("internalheight")=0
if request("widthExpakH")<>"" then rs("width")=request("widthExpakH") else rs("width")=0
if request("lengthExpakH")<>"" then rs("length")=request("lengthExpakH") else rs("length")=0
if request("heightExpakH")<>"" then rs("height")=request("heightExpakH") else rs("height")=0
if request("weightExpakH")<>"" then rs("weight")=request("weightExpakH") else rs("weight")=0
rs.update
rs.close
set rs=nothing
msg="Box / Crate info has been updated"

Con.close
set con=nothing
end if
response.Redirect("component-data.asp?msg=" & msg)
%>

<!-- #include file="common/logger-out.inc" -->
