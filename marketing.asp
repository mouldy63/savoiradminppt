<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim Con, rs, rs1, recordfound, id, rspostcode, submit, count, sql, location
count=0
submit=Request("submit")
Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />

<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<link href="Styles/marketing.css" rel="Stylesheet" type="text/css" />



</head>
<body>


<div class="container">
<!-- #include file="header.asp" -->
<!--<div class="content brochure">-->
<!--<div class="one-col head-col">-->
      <p>
            <a href="#"><button onclick="functionShow()">New</button></a> <a href="#"><button>Edit</button></a>
      </p>
        <%If submit<>"" Then
        %>
        <p>Your article has been added.</p>

        <%sql="Select * from marketing"
        'response.Write("sql=" & sql)
        'response.End()
        Set rs = getMysqlUpdateRecordSet(sql, con)
        rs.addnew
        rs("locationpageid")=val
        If Request("ArticleHeader")<>"" Then rs("ArticleHeader")=Request("ArticleHeader") else rs("ArticleHeader")=Null
        If Request("ArticleLink")<>"" Then rs("ArticleLink")=Request("ArticleLink") else rs("ArticleLink")=Null

        rs.Update
        rs.close
        set rs=nothing

        Else
        %>
      <div id="newArticleForm">
          <form method=post id="myForm">
              <input type="text"  placeholder="Article Header" id="ArticleHeader" class="centertext"/><br>
                <br>
              <input type="text"  placeholder="Article Link" id="ArticleLink" class="centertext" /><br>
              <p><a href="#"><button onclick="clearForm()">Cancel</button></a> <input type="submit" value="Save" id="submit" disabled> </p>
          </form>

      </div>

<div>
<%

End If
Con.Close
Set Con = Nothing%>
</div>
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="common/jquery.js" type="text/javascript"></script>
<script>
$(':text').keyup(function() {
    if($('#ArticleHeader').val() != "" && $('#ArticleLink').val() != "") {
       $('#submit').removeAttr('disabled');
    } else {
       $('#submit').attr('disabled', true);
    }
});

    function functionShow() {
        var x = document.getElementById('newArticleForm');
        x.style.display = 'block'
    }

    function clearForm(){
        var x = document.getElementById('newArticleForm');
        x.style.display = 'none'
        document.getElementById("myForm").reset();
    }


</script>
</body>
</html>


<!-- #include file="common/logger-out.inc" -->
