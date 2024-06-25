<script type="text/javascript">
	function isPriceMatrixEnabled() {
		var priceMatrixEnabled = false;
		<%
		dim ars99, asql99, acon99, aPriceMatrixEnabled
		Set acon99 = getMysqlConnection()
		' check its enabled globally
		aPriceMatrixEnabled = isFeatureEnabled(acon99, "PRICE_MATRIX")
		if aPriceMatrixEnabled then
			' is enabled globally, so check it's enabled for the current showroom
			asql99 = "select price_matrix_enabled from location where idlocation=" & retrieveUserLocation()
			set ars99 = getMysqlQueryRecordSet(asql99, acon99)
			if not ars99.eof and ars99("price_matrix_enabled") = "y" then
				%>
				priceMatrixEnabled = true;
				<%
			end if
			ars99.close
			set ars99 = nothing
		end if
		acon99.close
		set acon99 = nothing
		%>
		//trace("@@@ priceMatrixEnabled = " + priceMatrixEnabled);
		return priceMatrixEnabled;
	}
</script>
