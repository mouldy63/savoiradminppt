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
<%Dim  Con, rs, rs1, addproduct, component,productname,weight,tariff,depth,msg,sql, componentdataid

addproduct=request("addproduct")
component=request("component")
productname=request("productname")
weight=request("weight")
tariff=request("tariff")
depth=request("depth")

Set Con = getMysqlConnection()

if addproduct<>"" and component<>"n" then
sql="Select * from componentdata"
Set rs = getMysqlUpdateRecordSet(sql , con)
rs.AddNew
rs("componentid")=component
if productname<>"" then rs("componentname")=productname
if weight<>"" then rs("weight")=weight
if tariff<>"" then rs("tariffcode")=tariff
if depth<>"" then rs("depth")=depth
rs.Update
rs.close
set rs=nothing


response.Redirect("component-data.asp")

end if


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
            <p><font color="#FF0000"><%=msg%></font></p>     <%end if%>
           
<form name="form1" method="post" action="add-component-data.asp" onSubmit="return FrontPage_Form1_Validator(this)">	<div id="c1">
    		
		  <h1>ADD PRODUCT DATA		  </h1>
		  <p>
		    <%sql="Select * from component order by componentid asc"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						%>
                <select name="component"  class="formtext" id="component">
                  <option value="n">Select Product</option>
                  <%do until rs.EOF%>
                  <option value="<%=rs("componentid")%>"><%=rs("component")%></option>
                  <% rs.movenext 
  loop%>
                  <%
rs.Close
Set rs = Nothing


%>
                </select>
                &nbsp;<br>
			  </p>
               <p>Product Name:<br>
			    <input name="productname" type="text" id="productname" size="40" maxlength="70">
			    <br>
			  </p>
			  <p>Weight per Square Cm (linear for headboards):<br>
			    <input name="weight" type="text" id="weight" size="40" maxlength="20">
			  </p>
			  <p>Harmonised Tariff Code:<br>
<input name="tariff" type="text" id="tariff" size="40" maxlength="20">
</p>

			  <p>Depth of Product (cms):<br>
<input name="depth" type="text" id="depth" size="40" maxlength="20">
              </p>
			  <p>
			    <input type="submit" name="addproduct" id="addproduct" value="Add Product">
			  </p>
			  
           
		</div>
   <div id="c2">
     <p>&nbsp;</p>
     <p><br />  
              
        </p> 
            <p>&nbsp;</p> 
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
function IsNumeric(sText)
	{
	   var ValidChars = "0123456789.";
	   var IsNumber=true;
	   var Char;
	
	 
	   for (i = 0; i < sText.length && IsNumber == true; i++) 
		  { 
		  Char = sText.charAt(i); 
		  if (ValidChars.indexOf(Char) == -1) 
			 {
			 IsNumber = false;
			 }
		  }
	   return IsNumber;
	   
	   }
function FrontPage_Form1_Validator(theForm)
{
 

   if (theForm.component.value == "n")
  {
    alert("Please select a product type");
    theForm.component.focus();
    return (false);
  }
   if (theForm.productname.value == "")
  {
    alert("Please select a product name");
    theForm.etadate.focus();
    return (false);
  }
  if (!IsNumeric(theForm.weight.value)) 
   { 
      alert('Please enter only numbers for weight') 
      theForm.weight.focus();
      return false; 
      }
  if (!IsNumeric(theForm.depth.value)) 
   { 
      alert('Please enter only numbers for depth') 
      theForm.depth.focus();
      return false; 
      }

    return true;
} 

//-->
</script>
<!-- #include file="common/logger-out.inc" -->
