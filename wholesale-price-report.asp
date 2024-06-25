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
    $('#datefrom').datepicker( {
        changeMonth: true,
		yearRange: "-21:+0",
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'MM yy',
        onClose: function(dateText, inst) { 
            $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
        }
    });
});

</script>

<style>
.hide {display:none;}
.ui-datepicker-calendar {
    display: none;
    }
</style>

</head>
<body>

<div class="containerfull">
<!-- #include file="header.asp" -->
	
<form action="wholesale-report-csv.asp" method="post" name="form1">					  
    <div class="contentfull brochure">
			    <div class="one-col head-col">
			<p> <strong>Wholesale Price Report</strong><br>
			  This report display all orders within the month, based on Production Completion Dates on orders.</p>
			<table border="0" align="center" cellpadding="5" cellspacing="2">
					    <tr>
					      <td><label for="datefrom"><strong>Date : </strong><input name="datefrom" type="text" class="text" id="datefrom" value="<%=request("datefrom")%>" size="10" /></label></td>
					      <td><input type = "submit" name = "submitcsv" value = "Run Report - Produce CSV" id = "submitcsv"
                                        class = "button" onClick="return setFormAction('csv')" /></td>
		      </tr>
                      
					  
			      </table>
<%if submit<>"" then%>				
          <p>&nbsp;</p>
          <p align="center"><br>
          </p>
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

  
<!-- #include file="common/logger-out.inc" -->
