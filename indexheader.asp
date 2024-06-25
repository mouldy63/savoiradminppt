<%dim Con, rs, sql, cardiffNo, londonNo, londonitems, cardiffitems, n
Set Con = getMysqlConnection()

sql="Select count(*) as n from qc_history_latest Q, purchase P where P.purchase_no=Q.purchase_no and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=2 or Q.QC_StatusID=20) AND  P.orderonhold<>'y' and  (P.cancelled is Null or P.cancelled='n')"
Set rs = getMysqlQueryRecordSet(sql , con)
londonitems=rs("n")
rs.close
set rs=nothing

sql="Select count(*) as n from qc_history_latest Q, purchase P where P.purchase_no=Q.purchase_no and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=2 or Q.QC_StatusID=20) and P.code<>15919 AND  P.orderonhold<>'y'and (P.cancelled is Null or P.cancelled='n')"
Set rs = getMysqlQueryRecordSet(sql , con)
cardiffitems=rs("n")
rs.close
set rs=nothing

sql="Select NoItemsWeek, manufacturedatid from manufacturedat"
Set rs = getMysqlQueryRecordSet(sql , con)
Do until rs.eof
	if rs("manufacturedatid")=1 then cardiffNo=rs("NoItemsWeek")
	if rs("manufacturedatid")=2 then londonNo=rs("NoItemsWeek")
	rs.movenext
loop
rs.close
set rs=nothing
cardiffNo=round(CDbl(cardiffitems)/CDbl(cardiffNo)+0.5)
londonNo=round(CDbl(londonitems)/CDbl(londonNo)+0.5)
%>
<table width="100%" border="0" cellpadding="0" cellspacing="0" summary="page layout">
  <tr >
    <td width="25%" class="logobg" ><p align="left" class="lindalliancelogo"><img src="/images/logo.gif" width="255" height="66" /><br>
      </p>
    </td>
    <td width="50%" valign="middle" class="logobg"><div align="center">
      <h1 class="lindalliancelogo"><br>
        <em class="strapline">  Administration Area </em></h1>
    </div></td>
    <td width="25%" valign="middle" class="logobg"><div align="left">
      <p align="right">&nbsp;</p>
      </div></td>
  </tr>
  <tr bgcolor="#CCCCCC">
    <td height="25" colspan="3"><p style="float:left">&nbsp;Lead Time: London = <%=londonNo%> weeks, Cardiff = <%=cardiffNo%> weeks</p><p align="right"><a href="/index.asp"> Admin Menu </a>  | <%if retrieveUserRegion()=1 then%><a href="/production-index.asp"> Production </a>    |<%end if%> <a href="javascript:history.go(-1)">Back</a>&nbsp;|<a href="/access/logout.asp"> Logoff</a><br />Logged in as <%=retrieveUserName()%></p></td>
  </tr>
</table>
