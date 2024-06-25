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
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, recordfound, id, sql, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, addperson, newname, locationname, location, collectionid, selected, checked, count2, remove, orders, lname, chcount, consigneeid, cheked, consigneeexists
consigneeexists="n"
lname=request("lname")
orders=""
orders=request("orders")
consigneeid=""

collectionid=request("collectionid")
Set Con = getMysqlConnection()



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
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <style>
    .toggle {
      --width: 50px;
      --height: calc(var(--width) / 3);

      position: relative;
      display: inline-block;
      width: var(--width);
      height: var(--height);
      box-shadow: 0px 1px 3px rgba(0, 0, 0, 0.3);
      border-radius: var(--height);
      cursor: pointer;
    }

    .toggle input {
      display: none;
    }

    .toggle .slider {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      border-radius: var(--height);
      background-color: #ff0000;
      transition: all 0.4s ease-in-out;
    }

    .toggle .slider::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: calc(var(--height));
      height: calc(var(--height));
      border-radius: calc(var(--height) / 2);
      background-color: #fff;
      box-shadow: 0px 1px 3px rgba(0, 0, 0, 0.3);
      transition: all 0.4s ease-in-out;
    }

    .toggle input:checked+.slider {
      background-color: #00d100;
    }

    .toggle input:checked+.slider::before {
      transform: translateX(calc(var(--width) - var(--height)));
    }

    .toggle .labels {
      position: absolute;
      top: 2px;
      left: 0;
      width: 100%;
      height: 100%;
      font-size: 12px;
      font-family: sans-serif;
      transition: all 0.4s ease-in-out;
    }

    .toggle .labels::after {
      content: attr(data-off);
      position: absolute;
      right: 5px;
      color: #ffffff;
      opacity: 1;
      text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.4);
      transition: all 0.4s ease-in-out;
    }

    .toggle .labels::before {
      content: attr(data-on);
      position: absolute;
      left: 5px;
      color: #ffffff;
      opacity: 0;
      text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.4);
      transition: all 0.4s ease-in-out;
    }

    .toggle input:checked~.labels::after {
      opacity: 0;
    }

    .toggle input:checked~.labels::before {
      opacity: 1;
    }
    .adjustpara {
        padding-bottom: 5px;
    float: left;
    margin-left: 14px;
    margin-right: 15px;
    margin-top: 2px;}
  </style>
</head>
<body>
<div class="container">
<!-- #include file="header.asp" -->
<%sql="SELECT * from exportcollections where exportCollectionsID=" & collectionid
Set rs = getMysqlQueryRecordSet(sql, con)
msg=Request("msg")
sql="Select idlocation from exportCollShowrooms WHERE exportCollectionID = " & collectionid
'response.Write(sql)
Set rs2 = getMysqlQueryRecordSet(sql, con)
count2 = 1
If NOT rs2.EOF Then
dim selectedLocationArray()
do until rs2.EOF
	redim preserve selectedLocationArray(count2)
	selectedLocationArray(count2) = rs2("idlocation")
	rs2.movenext
	count2 = count2 + 1
loop
End If
rs2.close
set rs2 = Nothing%>
	
					  <div class="content brochure">
			    <div class="one-col head-col">
			      <%if msg<>"" then%>
            <p><font color="#FF0000"><%=msg%></font></p>
            <%end if%>
            <%if orders<>"" then%>
			<div id="dialog" title="Attention">
  <p>The following orders are currently set up for <%=lname%> showroom: <%=orders%> these will need to be removed first before you can delete the location from the delivery.</p>
</div>

<%end if%>
	<div id="d1">
    
    		<form name="form1" method="post" action="updatecollection.asp" onSubmit="return FrontPage_Form1_Validator(this)">
			  <h1>EDIT  COLLECTION</h1>
			  <p>Collection Date:
			    <br>
			    <input name="collectiondate"  type="text" id="collectiondate"  size="10" maxlength="10" value="<%=rs("collectiondate")%>">
              <a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.collectiondate','calendar_window','width=154,height=288');calendar_window.focus()"> Choose Date </a></p>
			  <p>
			    <%sql="Select * from shipper_address order by shippername asc"
                        Set rs1 = getMysqlQueryRecordSet(sql , con)
						%>
                        
                        <select name="shipperaddress">
              <%do until rs1.eof
			  selected = ""
				if rs1("shipper_address_id") = rs("shipper") then selected = "selected"%>
			    <option value="<%=rs1("shipper_address_id")%>" <%=selected%>><%=rs1("shippername")%></option>
                <%rs1.movenext
				loop
				rs1.close
				set rs1=nothing%>
			  </select>
               
                &nbsp;<br>
			  </p>
               <p>Transport Mode:<br>
			    <input name="transportmode" type="text" id="transportmode" value="<%=rs("transportmode")%>" size="40" maxlength="50">
			    <br>
			  </p>
			  <p>Container Ref:<br>
			    <input name="containerref" type="text" id="containerref" value="<%=rs("containerref")%>" size="40" maxlength="20">
			  </p>
               <p>Terms & Conditions of Delivery Payment<br><br>
			    <%sql="Select * from deliveryterms where deliveryTermsID<>2"
                        Set rs1 = getMysqlQueryRecordSet(sql , con)
						%>
                        
                        <select name="deliveryterms">
              <%do until rs1.eof
			  selected = ""
				if rs1("deliveryTermsID") = rs("ExportDeliveryTerms") then selected = "selected"%>
			    <option value="<%=rs1("deliveryTermsID")%>" <%=selected%>><%=rs1("DeliveryTerms")%> (<%=rs1("deliverydesc")%>)</option>
                <%rs1.movenext
				loop
				rs1.close
				set rs1=nothing%>
			  </select>
               
                &nbsp;<br>
<%chcount=50-len(rs("termstext"))%>
                <textarea name="termstext" rows="1"  cols="40" onKeyPress="return taLimit(this)"  onKeyUp="return taCount(this,'myCounter')"><%=rs("termstext")%></textarea>
                <br />&nbsp;<B><SPAN id=myCounter><%=chcount%></SPAN></B>/50
			  </p>
			  <p>Country of Final Destination:<br>
                <input name="destport" type="text" id="destport" value="<%=rs("DestinationPort")%>" size="40" maxlength="50">
              </p>
			  <p>Status<br> <%sql="Select * from collectionstatus order by collectionStatusID asc"
                        Set rs1 = getMysqlQueryRecordSet(sql , con)
						%>
                        
                        <select name="collectionstatus">
              <%do until rs1.eof
			  selected = ""
				if rs1("collectionStatusID") = rs("collectionStatus") then selected = "selected"%>
			    <option value="<%=rs1("collectionStatusID")%>" <%=selected%>><%=rs1("collectionStatusName")%></option>
                <%rs1.movenext
				loop
				rs1.close
				set rs1=nothing%>
			  </select>
			  </p>
			  <p><input name="amend" type="hidden" value="y">
              <input name="collectid" type="hidden" value="<%=collectionid%>">
	
		      </p>
		      <div id="e1">   <p>Consignee<br />
              <%sql="Select * from consignee_address"
                        Set rs1 = getMysqlQueryRecordSet(sql , con)
						%>
                <select name="consignee" class="formtext" id="consignee">
                  <option value="n">Choose Consignee</option>
                  <%do until rs1.EOF
                  selected = ""
                  if rs1("consignee_ADDRESS_ID") = rs("Consignee") then 
                  selected = "selected"
                  consigneeexists="y"
                  consigneeid=rs1("consignee_ADDRESS_ID")
                  end if
                  %>
                  <option value="<%=rs1("consignee_ADDRESS_ID")%>" <%=selected%>><%=rs1("consigneeName")%></option>
                  <% rs1.movenext 
  loop%>
                  <%
rs1.Close
Set rs1 = Nothing


%>
                </select>	
                </div>
                <div id="e2">
               <%cheked=""
               if consigneeid<>"" and consigneeid<>"n" then
               %>
                <p id="editconsig"><a href="/php/editconsignee?lid=<%=consigneeid%>" target="_blank"><font color='red'>Edit Consignee</font></a></p>
             <%end if%>
            </div>
            <div id="e3"> <p><a href="/php/consignee" target="_blank"><font color='red'>Add New Consignee</font></a></p></div>
            
             <div  id="useconsig" class="clear">
            <% if rs("DeliverToConsignee")="y" then 
            cheked="checked"
            else
            cheked=""
            end if%>
             <p><div class="adjustpara">Use Consignee Address as all delivery addresses on manifest? </div><label class="toggle">
    <input type="checkbox" name="consigneebutton" id="consigneebutton" <%=cheked%>>>
    <span class="slider"></span>
    <span class="labels" data-on="Yes" data-off="No"></span>
  </label></p></div>

			 
			   <p><a href="/php/CommercialManifest.pdf?cid=<%=collectionid%>" target="_blank"><font color='red'>View Manifest Document</font></a></p>
			    <p><a href="container-details1.asp?id=<%=collectionid%>" target="_blank"><font color='red'>View Export Collection</font></a></p>
  
		</div>
 <div id="d2"><br> <%
' Open Database Connection

Set rs1 = getMysqlQueryRecordSet("select * from location where retire='n' order by adminheading" , con)
	do until rs1.EOF
		  	checked = ""
if isEMPTY(selectedLocationArray) then
Else
    for i = 1 to ubound(selectedLocationArray)
        if selectedLocationArray(i) = rs1("idlocation") then checked = "checked"
	
    next
end if
	
           Set rs2 = getMysqlQueryRecordSet("select * from exportcollshowrooms where exportCollectionID=" & collectionid  & " and idlocation=" & rs1("idlocation") , con)
		   if not rs2.eof then%>
			<input name="YY<%=rs1("idlocation")%>" id="YY<%=rs1("idlocation")%>" value="<%=rs2("etadate")%>" type="text" size="10" maxlength="10">
             <a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.YY<%=rs1("idlocation")%>','calendar_window','width=154,height=288');calendar_window.focus()"> Choose Date </a>
             
		<%else%>
        	<input name="YY<%=rs1("idlocation")%>" id="YY<%=rs1("idlocation")%>" value="" type="text" size="10" maxlength="10">
             <a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.YY<%=rs1("idlocation")%>','calendar_window','width=154,height=288');calendar_window.focus()"> Choose Date </a>
        <%end if
		rs2.close
		 set rs2=nothing
             %>
               <input name="XX<%=rs1("idlocation")%>" id="XX<%=rs1("idlocation")%>" type="checkbox"   value="<%=rs1("idlocation")%>" <%=checked%>>
          <%=rs1("adminheading")%> | <a href="remove-collection.asp?id=<%=rs1("idlocation")%>&collectionid=<%=collectionid%>&remove=y"><font color="#FF0000">Remove</font></a> <br>
          <%rs1.movenext 
loop 
rs1.Close
Set rs1 = Nothing
%>
<p><input type="submit" name="addcollection" id="addcollection" value="Save Changes"></p>

</div>       
                </div>
  </div>
<div>
</div>
        </form>
</body>
</html>
<%
rs.Close
Set rs = Nothing
Con.Close
Set Con = Nothing
%>
  <script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form1_Validator(theForm)
{
 
   if (theForm.location.value == "all")
  {
    alert("Please select a location");
    theForm.location.focus();
    return (false);
  }
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

    return true;
} 

//-->
</script>
  <script>
  $( function() {
    $( "#dialog" ).dialog();
  } );
  </script>
  <script language = "Javascript">
/**
 * DHTML textbox character counter script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
 */
$(function () {
 $('#consignee').change(function () {
 	var value = $('#consignee').val();
   if (value=='n') {
   //$( "#consigneebutton" ).prop( "checked", false );
   $("#editconsig").hide();
   $("#useconsig").hide();
   } else {
   //$( "#consigneebutton" ).prop( "checked", true );
   $("#editconsig").show();
   $("#useconsig").show();
   }

  });
});

$(document).ready(function() {
	$consignee=$('#consignee').val();
	if ($consignee=='' || $consignee=='n') {
		$("#useconsig").hide();
	}
    $('#consigneebutton').click(function() {
		var chbox=$("input[type=checkbox][name=consigneebutton]:checked").val();
		var consig = $('#consignee').val();
		if (chbox != true ) {
		 //$("#consignee").val("n");
		} 
		if (chbox != true && consig=='n') {
			alert("Please select a consignee first");
			return false;
		}
		
    })
    
});


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
