<%@ Page Language="vb" %>

<script runat="server">
    Private Sub Calendar1_SelectionChanged(sender As Object, e As System.EventArgs)
        Dim strjscript as string = "<script language=""javascript"">"
        strjscript = strjscript & "window.opener.document." & Httpcontext.Current.Request.Querystring("formname") & ".value = '" & Calendar1.SelectedDate & "'; window.opener.calendarBlurHandler(window.opener.document." & Httpcontext.Current.Request.Querystring("formname") & "); window.close();"
        strjscript = strjscript & "</script" & ">" 'Don't Ask, Tool Bug
        Literal1.text = strjscript
    End Sub
    
    Private Sub Calendar1_DayRender(sender As Object, e As System.Web.UI.WebControls.DayRenderEventArgs)
       If e.Day.Date = datetime.now().tostring("d") Then
       e.Cell.BackColor = System.Drawing.Color.LightGray
       End If
    End Sub
</script>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html>
<head>
    <title>Choose a Date</title> 
<link href="/Styles/screen.css" rel="stylesheet" type="text/css">
</head>
<body leftmargin="0" topmargin="0">
  <div align="center"><form runat="server">
       <p>Choose a date below and this will automatically fill the date in on your form       </p>
       <asp:Calendar id="Calendar1" runat="server" OnSelectionChanged="Calendar1_SelectionChanged" OnDayRender="Calendar1_dayrender" showtitle="true" DayNameFormat="FirstTwoLetters" SelectionMode="Day" BackColor="#ffffff" Font-Name="Arial" Font-Size="x-small" FirstDayOfWeek="Monday" BorderColor="#000000" ForeColor="#00000" Height="60" Width="120">
         <TitleStyle backcolor="#000080" forecolor="#ffffff" />
            <NextPrevStyle backcolor="#000080" forecolor="#ffffff" />
            <OtherMonthDayStyle forecolor="#c0c0c0" />
    </asp:Calendar>
        <asp:Literal id="Literal1" runat="server"></asp:Literal>
    </form></div>  
</body>
</html>

