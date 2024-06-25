<%
Dim ffJpeg

Set ffJpeg = Server.CreateObject("Persits.Jpeg")

sub processFile(byval aFilename, byref aFile, byref aMove, byref aWidth, byref aHeight)
	dim aRealFilename
	aRealFilename = Server.MapPath(aFilename)
	if Upload.FileExists(arealFilename) then
		Upload.DeleteFile(arealFilename)
	end if
	if aMove then
		aFile.MoveVirtual(aFilename)
	else
		aFile.CopyVirtual(aFilename)
	end if
	If aWidth > 0 then
	call resizeImage(aRealFilename, aWidth, aHeight)
	End If
end sub

sub processFileAbsolute(byval aFilename, byref aFile, byref aMove, byref aWidth, byref aHeight)
	if Upload.FileExists(aFilename) then
		Upload.DeleteFile(aFilename)
	end if
	if aMove then
		aFile.Move(aFilename)
	else
		aFile.Copy(aFilename)
	end if
	If aWidth > 0 then
		call resizeImage(aFilename, aWidth, aHeight)
	End If
end sub

sub processFileAbsoluteNOresize(byval aFilename, byref aFile, byref aMove)
	if Upload.FileExists(aFilename) then
		Upload.DeleteFile(aFilename)
	end if
	if aMove then
		aFile.Move(aFilename)
	else
	'response.Write(aFilename)
	'response.End()
		aFile.Copy(aFilename)
		aFile.delete
	end if
end sub

sub deleteFile(byval aFilename)
	dim aRealFilename
	aRealFilename = Server.MapPath(aFilename)
	if Upload.FileExists(aRealFilename) then
		Upload.DeleteFile(aRealFilename)
	end if
end sub

sub deleteFileX(byval aFilename)
	dim aRealFilename
	aRealFilename = aFilename
	if Upload.FileExists(aRealFilename) then
		Upload.DeleteFile(aRealFilename)
	end if
end sub

sub renameFile(byval aOldname, byval aNewname)
	dim aRealOldname, aRealNewname
	aRealOldname = Server.MapPath(aOldname)
	aRealNewname = Server.MapPath(aNewname)
	if Upload.FileExists(aOldname) then
		call Upload.MoveFile(aOldname, aNewname)
	end if
end sub

sub resizeImage(byref aFilename, byref aWidth, byref aHeight)

	ffJpeg.Open aFilename
	'ffJpeg.Canvas.Brush.Solid = False ' or a solid bar would be drawn
	'ffJpeg.Canvas.Bar 1, 1, ffJpeg.Width, ffJpeg.Height
	ffJpeg.Sharpen 1, 110
	ffJpeg.Width = aWidth
	ffJpeg.Height = aHeight

	'ffJpeg.Height = ffJpeg.Width * ffJpeg.OriginalHeight / ffJpeg.OriginalWidth
	ffJpeg.Canvas.Pen.Color = &000000' black
	ffJpeg.Canvas.Pen.Width = 2
	ffJpeg.Save aFilename
end sub



function getFileNameExtension(afilename)
	dim aidx
	aidx = instrrev(afilename, ".")
	getFileNameExtension = ""
	if aidx > 0 then
		getFileNameExtension = right(afilename, len(afilename)-aidx+1)
	end if
end function
%>
