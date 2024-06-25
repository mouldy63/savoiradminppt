<%
function isFeatureEnabled(byref acon, aFeatureName)
	dim asql, ars
	asql = "select value from comreg where name='FS_" & aFeatureName & "'"
	set ars = getMysqlQueryRecordSet(asql, acon)
	isFeatureEnabled = (ars("value") = "y")
	closers(ars)
end function
%>