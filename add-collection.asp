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
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, recordfound, id, sql, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, addperson, newname, locationname, location
Set Con = getMysqlConnection()



msg=Request("msg")



%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/extra.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>
<div class="container">
<!-- #include file="header.asp" -->
	
					  <div class="content brochure">
			    <div class="one-col head-col">
			      <%if msg<>"" then%>
            <p><font color="#FF0000"><%=msg%></font></p>
            <%end if%>
<form name="form1" method="post" action="updatecollection.asp" onSubmit="return FrontPage_Form1_Validator(this)">	<div id="c1">
    		
		  <h1>ADD NEW COLLECTION		  </h1>
		  <p>Collection Date:
		    <br>
			    <input name="collectiondate" value="" type="text" id="collectiondate"  size="10" maxlength="10">
              <a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.collectiondate','calendar_window','width=154,height=288');calendar_window.focus()"> Choose Date </a>
		      </p>
		
			  <p>
			    <%sql="Select * from shipper_address order by shippername asc"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						%>
                <select name="shipperaddress"  class="formtext" id="shipperaddress">
                  <option value="all">Shipper Address</option>
                  <%do until rs.EOF%>
                  <option value="<%=rs("shipper_address_id")%>"><%=rs("shippername")%></option>
                  <% rs.movenext 
  loop%>
                  <%
rs.Close
Set rs = Nothing


%>
                </select>
                &nbsp;<br>
			  </p>
               <p>Transport Mode:<br>
			    <input name="transportmode" type="text" id="transportmode" size="40" maxlength="50">
			    <br>
			  </p>
			  <p>Container Ref:<br>
			    <input name="containerref" type="text" id="containerref" size="40" maxlength="20">
			  </p>
			  <p>Terms of Delivery<br />
              <%sql="Select * from deliveryterms where deliveryTermsID<>2"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						%>
                <select name="deliveryterms"  class="formtext" id="deliveryterms">
                  <option value="n">Choose Delivery Terms</option>
                  <%do until rs.EOF%>
                  <option value="<%=rs("deliveryTermsID")%>"><%=rs("DeliveryTerms")%> (<%=rs("deliverydesc")%>)</option>
                  <% rs.movenext 
  loop%>
                  <%
rs.Close
Set rs = Nothing


%>
                </select>			  
                 &nbsp;<br>
                <textarea name="termstext" cols="40" rows="1" onKeyPress="return taLimit(this)" onKeyUp="return taCount(this,'myCounter')" ></textarea><br />&nbsp;<B><SPAN id=myCounter>50</SPAN></B>/50</p>
                <p>
			  <p>Destination Port<br>
			    <input name="destport" type="text" id="destport" size="40" maxlength="50">
			  </p>
			   <p>Add Consignee<br />
              <%sql="Select * from consignee_address"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						%>
                <select name="consignee"  class="formtext" id="consignee">
                  <option value="n">Choose Consignee</option>
                  <%do until rs.EOF%>
                  <option value="<%=rs("consignee_ADDRESS_ID")%>"><%=rs("consigneeName")%></option>
                  <% rs.movenext 
  loop%>
                  <%
rs.Close
Set rs = Nothing


%>
                </select>	
               
             
			  <p><a href="/php/consignee"><font color='red'>Add New Consignee</font></a></p>
           
		</div>
   <div id="c2">
     <p>&nbsp;</p>
     <p>Choose which showrooms can use this Collection</p>
   <p>   <% Set rs = getMysqlQueryRecordSet("select * from location where retire='n' order by adminheading", con)
   do until rs.eof%>
   ETA Date: 
                <input name="YY<%=rs("idlocation")%>" id="YY<%=rs("idlocation")%>" value="" type="text" size="10" maxlength="10">
              <a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.YY<%=rs("idlocation")%>','calendar_window','width=154,height=288');calendar_window.focus()"> Choose Date </a>
            <input type="checkbox" name="XX<%=rs("idlocation")%>" id="XX<%=rs("idlocation")%>" value="<%=rs("idlocation")%>" >
            <%=rs("adminheading")%> <br />  
            <%rs.movenext
			loop%>  
        </p> 
            <p>
			    <input type="submit" name="addcollection" id="addcollection" value="Add Collection">
        </p> 
               </form>
   </div>     
                </div>
  </div>
<div>
</div>
        </form>
</body>
</html>
<%

Con.Close
Set Con = Nothing
%>
  <script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form1_Validator(theForm)
{
 

   if (theForm.collectiondate.value == "")
  {
    alert("Please select a collection date");
    theForm.collectiondate.focus();
    return (false);
  }
   if (theForm.etadate.value == "")
  {
    alert("Please select an ETA date");
    theForm.etadate.focus();
    return (false);
  }
   if (theForm.shipperaddress.value == "all")
  {
    alert("Please select a shipper");
    theForm.shipperaddress.focus();
    return (false);
  }
  if (theForm.deliveryterms.value == "n")
  {
    alert("Please select delivery terms");
    theForm.deliveryterms.focus();
    return (false);
  }

    return true;
} 

//-->
</script>
\<script language = "Javascript">
/**
 * DHTML textbox character counter script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
 */

maxL=50;
var bName = navigator.appName;
function taLimit(taObj) {
	if (taObj.value.length==maxL) return false;
	return true;
}

function taCount(taObj,Cnt) { 
	objCnt=createObject(Cnt);
	objVal=taObj.value;
	if (objVal.length>maxL) objVal=objVal.substring(0,maxL);
	if (objCnt) {
		if(bName == "Netscape"){	
			objCnt.textContent=maxL-objVal.length;}
		else{objCnt.innerText=maxL-objVal.length;}
	}
	return true;
}
function createObject(objId) {
	if (document.getElementById) return document.getElementById(objId);
	else if (document.layers) return eval("document." + objId);
	else if (document.all) return eval("document.all." + objId);
	else return eval("document." + objId);
}
</script>
<!-- #include file="common/logger-out.inc" -->
