<%
If Session("SAVOIR_NAMES") Is Nothing Then
    response.write("n")
Else
    response.write("y")
End If
%>