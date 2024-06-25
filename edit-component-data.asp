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
componentdataid=request("id")
addproduct=request("addproduct")
component=request("component")
productname=request("productname")
weight=request("weight")
tariff=request("tariff")
depth=request("depth")

Set Con = getMysqlConnection()

if addproduct<>"" then
sql="Select * from componentdata where componentdata_id=" & componentdataid
Set rs = getMysqlUpdateRecordSet(sql , con)

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
<%sql="Select * from componentdata D, component C where D.componentid=C.componentid and componentdata_id=" & componentdataid
Set rs = getMysqlUpdateRecordSet(sql , con)
  %>      
<form name="form1" method="post" action="edit-component-data.asp" onSubmit="return FrontPage_Form1_Validator(this)">	<div id="c1">
    		
		  <h1>ADD PRODUCT DATA		  </h1>
		  <p>
		    <%response.Write(rs("component"))%>

                &nbsp;<br>
			  </p>
               <p>Product Name:<br>
			    <input name="productname" type="text" id="productname" value="<%=rs("componentname")%>" size="40" maxlength="70">
			    <br>
			  </p>
			  <p>Weight per Square Cm (linear for headboards):<br>
			    <input name="weight" type="text" id="weight" value="<%=rs("weight")%>" size="40" maxlength="20">
			  </p>
			  <p>Harmonised Tariff Code:<br>
<input name="tariff" type="text" id="tariff" value="<%=rs("tariffcode")%>" size="40" maxlength="20">
</p>

			  <p>Depth of Product (cms):<br>
<input name="depth" type="text" id="depth" value="<%=rs("depth")%>" size="40" maxlength="20">
              </p>
			  <p><input name="id" type="hidden" value="<%=componentdataid%>">
			    <input type="submit" name="addproduct" id="addproduct" value="Update">
			  </p>
			  
           
		</div>
   <div id="c2">
     <p>&nbsp;</p>
     <p><br />  
              
        </p> 
            <p>&nbsp;</p> 
               </form>
               <%rs.close
			   set rs=nothing%>
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
