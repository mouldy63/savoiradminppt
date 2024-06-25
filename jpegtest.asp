<%
Set Jpeg = Server.CreateObject("Persits.Jpeg")
Jpeg.Open Server.MapPath("clock.jpg")
Jpeg.Width = Jpeg.OriginalWidth * .8
Jpeg.Height = Jpeg.OriginalHeight * .8

If Request("Grayscale") = "1" Then
   Jpeg.Grayscale 1
End If

If Request("Sharpen") = "1" Then
   Jpeg.Sharpen 1, 250
End If

If Request("Horflip") = "1" Then
   Jpeg.FlipH
End If

If Request("Verflip") = "1" Then
   Jpeg.FlipV
End If

Jpeg.Quality = Request("Quality")
Jpeg.Interpolation = Request("Interpolation")

If Request("Crop") = 1 Then
   Jpeg.Crop 30, 30, 470, 320
End If

Jpeg.SendBinary
%>