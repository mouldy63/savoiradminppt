<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%
dim purchase_no, quote, contact_no, con, rs, prod, msg, sql
Dim mattreq, basereq, valreq, topperreq, legsreq, hbreq, accreq
msg=request("msg")

mattreq=request("mattreq")
basereq=request("basereq")
valreq=request("valreq")
topperreq=request("topperreq")
legsreq=request("legsreq")
hbreq=request("hbreq")
accreq=request("accreq")

prod=request("prod")
quote="n"
quote=request("quote")
purchase_no=Request("val")

' get customer contact_no
Set Con = getMysqlConnection()
Set rs = getMysqlQueryRecordSet("select * from contact where code = (select code from purchase where purchase_no=" & purchase_no & ")", con)
contact_no = rs("contact_no")
rs.close
set rs = nothing

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>
<div class="container">
<!-- #include file="header.asp" -->
	
					  <div class="content brochure">
			    <div class="one-col head-col">
                <%if msg<>"" then response.Write("<p><font color=red>" & msg & "</font></p>")
                
				If quote<>"y" then%>
			<p>The order has been added/updated.
			<p><a href="php/PrintPDF.pdf?val=<%=purchase_no%>">PRINT PDF</a>
            <%Else%>
            <p>The quote has been added/updated.
			<p><a href="php/PrintPDF.pdf?quote=y&val=<%=purchase_no%>">PRINT QUOTE</a> 
            <%End If%> 
            <%If prod="y" then%>
            &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="orderdetails.asp?pn=<%=purchase_no%>">Return to Production Details</a>
            <%end if%>           
			<p>            
			<form action="editcust.asp" method="post" name="form1" id="form1">
            <input name="val" type="hidden" value="<%=contact_no%>">
			  <input name="submit" type="submit" value="Go back to Customer Record">
			</form></p>
			
             <%if mattreq="y" or basereq="y" or topperreq="y" or valreq="y" or hbreq="y" or legsreq="y" or accreq="y" then%>
             <p>
             <font color="red">Please confirm that you would like to cancel the below items</font>
              <form action="deletecomps.asp" method="get" name="formDel">
            
			<%if mattreq="y" then%>
           <p><input name="mattdel" type="checkbox" value="y">Delete Mattress</p>
           <%end if%>
           <%if basereq="y" then%>
           <p><input name="basedel" type="checkbox" value="y">Delete Base</p>
           <%end if%>
           <%if topperreq="y" then%>
           <p><input name="topperdel" type="checkbox" value="y">Delete Topper</p>
           <%end if%>
           <%if valreq="y" then%>
           <p><input name="valancedel" type="checkbox" value="y">Delete Valance</p>
           <%end if%>
           <%if hbreq="y" then%>
           <p><input name="hbdel" type="checkbox" value="y">Delete Headboard</p>
           <%end if%>
           <%if legsreq="y" then%>
           <p><input name="legsdel" type="checkbox" value="y">Delete Legs</p>
           <%end if%>
           <%if accreq="y" then%>
           <p><input name="accdel" type="checkbox" value="y">Delete Accessories</p>
           <%end if%>
           <input name="purchase_no" type="hidden" value="<%=purchase_no%>">
           <input name="delsubmit" type="submit" value="Delete Components">
            </form>
           <%end if%>
                </div>
    </div>
  </div>
<div>
</div>
</body>
</html>
<!-- #include file="common/logger-out.inc" -->
