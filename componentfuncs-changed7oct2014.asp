<%

sub getComponentSizes(byref acon, acompid, apurchaseno, byref aComp1width, byref aComp1length)
 dim ars, componentwidth, componentlength, asql
 if acompid=1 then 
 	componentwidth="mattresswidth"
	componentlength="mattresslength"
 end if
 if acompid=3 then 
 	componentwidth="basewidth"
	componentlength="baselength"
end if
 if acompid=5 then 
 	componentwidth="topperwidth"
	componentlength="topperlength"
end if
 if acompid=6 then 
 	componentwidth="valancewidth"
	componentlength="valancelength"
end if
 if acompid=7 then 
 	componentwidth="legheight"
	componentlength="legfinish"
end if

 'if acompid=8 then componentwidth="headboardwidth"
 asql="select " & componentwidth & " as w, " & componentlength  & " as l from purchase where purchase_no=" & apurchaseno & ""
 set ars = getMysqlQueryRecordSet(asql, aCon)
 if not ars.eof then
  if acompid=1 and (left(ars("w"),4))<>"Spec" and ars("w")<>"TBC" and ars("w")<>"n" and Not isNull(ars("w")) then aComp1width=left(ars("w"), len(ars("w"))-2) 
  if acompid=1 and (left(ars("l"),4))<>"Spec" and ars("l")<>"TBC" and ars("l")<>"n" and Not isNull(ars("l")) then aComp1length=left(ars("l"), len(ars("l"))-2) 
  
  if acompid=3 and (left(ars("w"),4))<>"Spec" and ars("w")<>"TBC" and ars("w")<>"n" and Not isNull(ars("w")) then aComp1width=left(ars("w"), len(ars("w"))-2)
    if acompid=3 and (left(ars("l"),4))<>"Spec" and ars("l")<>"TBC" and ars("l")<>"n" and Not isNull(ars("l")) then aComp1length=left(ars("l"), len(ars("l"))-2)
	
  if acompid=5 and (left(ars("w"),4))<>"Spec" and ars("w")<>"TBC" and ars("w")<>"n" and Not isNull(ars("w")) then aComp1width=left(ars("w"), len(ars("w"))-2)
    if acompid=5 and (left(ars("l"),4))<>"Spec" and ars("l")<>"TBC" and ars("l")<>"n" and Not isNull(ars("l")) then aComp1length=left(ars("l"), len(ars("l"))-2) 
	
  if acompid=7 and (left(ars("w"),4))<>"Spec" and ars("w")<>"TBC" and ars("w")<>"n" and Not isNull(ars("w")) then aComp1width=left(ars("w"), len(ars("w"))-2)
end if
 ars.close
 set ars = nothing
end sub

sub getComponentWidthSpecialSizes(byref acon, acompid, apurchaseno, byref aCompwidth)
 dim ars, componentwidth, asql
 if acompid=1 then 
 	componentwidth="matt1width"
 end if
 if acompid=3 then 
 	componentwidth="base1width"
end if
 if acompid=5 then 
 	componentwidth="topper1width"
end if
 if acompid=7 then 
 	componentwidth="legheight"
end if
asql="select " & componentwidth & " as w from productionsizes where purchase_no=" & apurchaseno & ""
 set ars = getMysqlQueryRecordSet(asql, aCon)
 if not ars.eof then
  if acompid=1 and Not isNull(ars("w")) then aCompwidth=ars("w")
  if acompid=3 and Not isNull(ars("w")) then aCompwidth=ars("w")
  if acompid=5 and Not isNull(ars("w")) then aCompwidth=ars("w")	
  if acompid=6 and Not isNull(ars("w")) then aCompwidth=ars("w")
  if acompid=7 and Not isNull(ars("w")) then aCompwidth=ars("w")
  end if
 ars.close
 set ars = nothing
end sub

sub getComponentLengthSpecialSizes(byref acon, acompid, apurchaseno, byref aComplength)
 dim ars, componentlength, asql
 if acompid=1 then 
 	componentlength="matt1length"
 end if
 if acompid=3 then 
 	componentlength="base1length"
end if
 if acompid=5 then 
 	componentlength="topper1length"
end if
asql="select " & componentlength & " as w from productionsizes where purchase_no=" & apurchaseno & ""

 set ars = getMysqlQueryRecordSet(asql, aCon)
 if not ars.eof then
  if acompid=1 and Not isNull(ars("w")) then aComplength=ars("w")
  if acompid=3 and Not isNull(ars("w")) then aComplength=ars("w")
  if acompid=5 and Not isNull(ars("w")) then aComplength=ars("w")
  if acompid=6 and Not isNull(ars("w")) then aComplength=ars("w")
 end if
 ars.close
 set ars = nothing
end sub

sub getComponent1WidthSpecialSizes(byref acon, acompid, apurchaseno, byref aCompwidth1, byref aCompwidth2)
 dim ars, componentwidth1, componentwidth2, asql
 if acompid=1 then 
 	componentwidth1="matt1width"
	componentwidth2="matt2width"
 end if
 if acompid=3 then 
 	componentwidth1="base1width"
	componentwidth2="base2width"
end if
asql="select " & componentwidth1 & " as w,  " & componentwidth2 & " as x from productionsizes where purchase_no=" & apurchaseno & ""
'response.Write(asql)
 set ars = getMysqlQueryRecordSet(asql, aCon)
 if not ars.eof then
  	if acompid=1 and Not isNull(ars("w")) then 
  		aCompwidth1=ars("w")
		aCompwidth2=ars("x") 
	end if
 	 if acompid=3 and Not isNull(ars("w")) then 
  		aCompwidth1=ars("w")
		aCompwidth2=ars("x") 
	end if
 end if
 ars.close
 set ars = nothing
end sub

sub getComponent1LengthSpecialSizes(byref acon, acompid, apurchaseno, byref aComplength1, byref aComplength2)
 dim ars, componentlength, componentlength1, componentlength2, asql
 if acompid=1 then 
 	componentlength1="matt1length"
	componentlength2="matt2length"
 end if
 if acompid=3 then 
 	componentlength1="base1length"
	componentlength2="base2length"
end if
asql="select " & componentlength1 & " as w,  " & componentlength2 & " as x from productionsizes where purchase_no=" & apurchaseno & ""
'response.Write(asql)
 set ars = getMysqlQueryRecordSet(asql, aCon)
 if not ars.eof then
	  if acompid=1 then 
			aComplength1=ars("w")
			aComplength2=ars("x") 
	 end if
	  if acompid=3 then 
			aComplength1=ars("w") 
			aComplength2=ars("x") 
	 end if
 end if
 ars.close
 set ars = nothing
end sub

function getHbWidth(byref acon, byval apn)
	dim asql, ars, hbwidth
	asql = "Select * from purchase WHERE purchase_no=" & apn
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		if rs("basewidth")<>"" and left(rs("basewidth"),4)<>"Spec" then hbwidth=rs("basewidth")
		if rs("mattresswidth")<>"" and left(rs("mattresswidth"),4)<>"Spec" then hbwidth=rs("mattresswidth")
		getHbWidth = ""
		getHbWidth = hbwidth
	end if
	closers(ars)	
end function


%>
