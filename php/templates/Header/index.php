<div>
	<a href='/php/home' style='float: left;'><img
		src='/images/logo-s.gif' border='0' />
	</a>
	<p align='right' style='margin-top: 14px; float: right;'>
		&nbsp;Lead Time: London = <?= $LondonNo ?> weeks, Cardiff = <?= $CardiffNo ?> weeks | Logged in as <?php echo $this->Security->retrieveUserName(); ?> | <a href='/access/logout.asp'> Logout</a>
	</p>
</div>
<div class='clear'></div>
<div id='adminhdr'>
	<ul>
		
		</li>
		<?php if ($this->Security->userHasRoleInList('ADMINISTRATOR,REGIONAL_ADMINISTRATOR,TESTER')) { ?>
			<li><a href='/php/AddCustomer'>Add Customer</a></li>
		<?php } ?>
		<li class='dropdown'><a href='#' class='dropbtn'>Brochure Requests</a>
		<div class='dropdown-content'>
		<?php if ($this->Security->userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR,TESTER") && $this->Security->retrieveUserRegion()!=6) { ?>
				<a href='/php/OutstandingBrochureRequests'>Outstanding Requests</a>
		<?php } ?>
		<?php if ($this->Security->userHasRoleInList('ADMINISTRATOR,REGIONAL_ADMINISTRATOR,TRADE')) { ?>		
				<a href='/php/OutstandingCoBrochureRequests'>Company Requests</a>
		<?php } ?>
		</div>
		</li>
		<?php if ($this->Security->userHasRoleInList("ONLINE_SHOWROOM") || $this->Security->retrieveUserRegion()==1) { ?>
		<li><a href='/php/marketingarticles'>Marketing</a>
		</li>
		<?php } ?>
		<?php if ($this->Security->userHasRoleInList("ONLINE_SHOWROOM") || $this->Security->retrieveUserRegion()==1 || $this->Security->retrieveUserRegion()==27) { ?>
		<li class='dropdown'><a href='#' class='dropbtn'>Customer
				Services</a>
		<div class='dropdown-content'>
				<a href='/php/customerservice/add'>Add Case</a>
				<?php if ($this->Security->userHasRoleInList('ADMINISTRATOR')) { ?>
				<a href='/php/customerservicehistory'>Closed Cases</a>
				<?php } ?>
				<a href='/php/customerservice'>Outstanding Cases</a>
			</div>
		</li>
		<?php } ?>
		
		<?php if ($this->Security->retrieveUserRegion()==1 || $this->Security->retrieveUserRegion()==17 || $this->Security->retrieveUserRegion()==19 || $this->Security->retrieveUserRegion()==4 || $this->Security->retrieveUserRegion()==26 || $this->Security->retrieveUserRegion()==18 || $this->Security->retrieveUserLocation()==14 || $this->Security->retrieveUserLocation()==17 || $this->Security->retrieveUserLocation()==25 || $this->Security->retrieveUserLocation()==31 || $this->Security->retrieveUserLocation()==33 || $this->Security->retrieveUserLocation()==34 || $this->Security->retrieveUserLocation()==41 || $this->Security->retrieveUserLocation()==35 || $this->Security->retrieveUserLocation()==38 || $this->Security->retrieveUserLocation()==51) { ?>
		<li class='dropdown'><a href='#' class='dropbtn'>Orders</a>
		<div class='dropdown-content'>
				<a href='/php/awaitingorders'>Awaiting Confirmation</a>
				<a href='/php/currentorders'>Current Orders</a>
				<a href='/php/heldorders'>Held Orders</a>
				<a href="/php/harrodsImport">Harrods Ecom Import</a>
					<?php if ($this->Security->retrieveUserRegion()==1 || $this->Security->retrieveUserLocation()==17 || $this->Security->retrieveUserLocation()==24 || $this->Security->retrieveUserLocation()==34 || $this->Security->retrieveUserLocation()==37 || $this->Security->retrieveUserLocation()==39) { ?>
					<a href='/php/quotes'>Quotes</a>
					<?php } ?>
			</div>
		</li>
		<?php } ?>
		<?php if ($this->Security->userHasRoleInList('ADMINISTRATOR')) { ?>
		<li class='dropdown'><a href='#' class='dropbtn'>Production</a>
		<div class='dropdown-content'>
				<a href='/php/shipper'>Add Shipper</a><a
					href='/php/consignee'>Add Consignee</a><a
					href='/php/ordersinproduction'>Orders In Production</a><a
					href='/php/packagingdata'>Packaging Information</a><a
					href='/php/itemsproduced'>Production Admin</a><a
					href='/php/productionlist'>Production List</a><a
					href='/php/fabricstatus'>Fabric Screen</a><a href='/php/accessory'>Accessories
					Screen</a><a href='/php/StaffPicklist'>Staff List</a>
				<hr />
				<a href='/php/deliveriesbooked?madeat=1'>Cardiff Screen</a><a
					href='/php/deliveriesbooked?madeat=2'>London Screen</a><a
					href='http://wrap.savoirproduction.co.uk/production.php'>Labels
					Screen</a>
			</div>
		</li>
		<?php } ?>
		<?php if ($this->Security->retrieveUserRegion()==1 || $this->Security->retrieveUserLocation()==1 || $this->Security->retrieveUserLocation()==27 || $this->Security->retrieveUserId()==217 || $this->Security->retrieveUserRegion()>1) { ?>
		<li class='dropdown'><a href='#' class='dropbtn'>Sales Admin</a>
		<div class='dropdown-content'>
				<?php if ($this->Security->retrieveUserLocation()==1 || $this->Security->retrieveUserLocation()==27) { ?>
				<a href='/php/CancelledExports'>Cancelled Shipments</a>
				<?php } ?>
				<a href='/php/DeliveredShipments'>Delivered Shipments</a>
				<a href='/php/PlannedExports'>Planned Export Collections</a>
			</div>
		</li>
		<?php } ?>
		<?php if ($this->Security->retrieveUserRegion()==1) { ?>
		<li class='dropdown'><a href='#' class='dropbtn'>Reports</a>
		<div class='dropdown-content'>
			<a href='/php/revenue'>Accounts</a><a href='/php/brochurereport'>Brochures for Prospects</a>
			<?php if ($this->Security->userHasRole('ADMINISTRATOR')) { ?>
					<a href='/php/BrochureFollowUp'>Brochure Followup Reports</a>
					<?php } ?>
					<a href='/php/customerordersreport'>Customer Orders</a><a
					href='/php/CustomerReadyNotInvoiced'>Customer Ready Not Invoiced</a><a
					href='/php/deliveryreport'>Delivery</a>
					<?php if ($this->Security->isSuperuser()) { ?>
					<a href='/php/customerprospectreport'>Full Customer/Prospects</a>
					<a href='/php/itemstatusreport'>Item Status Report</a>
					<?php } ?>
			<?php if ($this->Security->userHasRole('ADMINISTRATOR')) { ?>
					<a href="/php/orderStatusReport">Order Status Report</a>
					<?php } ?>
					<?php if ($this->Security->isSuperuser() || $this->Security->retrieveUserId()==199 || $this->Security->retrieveUserId()==90) { ?>
					<a href="/php/showroomordersreport">Showroom Report</a>
					<?php } ?>
			<?php if ($this->Security->userHasRole('ADMINISTRATOR')) { ?>
				<a href="/php/ShowroomSalesReportPopup">Showroom Sales Report</a>
			<?php } ?>
					<a href="/php/tradesearch">Trade</a>
					
			</div>
		</li>
		<?php } ?>
		
		<?php if (!$this->Security->isSuperuser() && $this->Security->isSavoirOwned() && $this->Security->userHasRoleInList('ADMINISTRATOR,REGIONAL_ADMINISTRATOR,SALES') && $this->Security->retrieveUserRegion()!=1) { ?>
		<li class='dropdown'><a href='#' class='dropbtn'>Reports</a>
			<?php if (!$this->Security->isSuperuser() && $this->Security->userHasRoleInList('ADMINISTRATOR,REGIONAL_ADMINISTRATOR,') && $this->Security->retrieveUserRegion()!=1) { ?>
			<div class='dropdown-content'>
					<a href='/php/deliveryreport'>Delivery</a>
				</div>
			<?php } ?>
			<div class='dropdown-content'>
				<a href="/php/ShowroomSalesReportPopup">Showroom Sales Report</a>
			</div>
		</li>
		<?php } ?>
					
		
		
		<?php if ($this->Security->retrieveUserId()==219) { ?>
  		<li class="dropdown">
   		 <a href="#" class="dropbtn">Reports</a>
   		 <div class="dropdown-content">
    	  <a href="/php/customerprospectreport/ny">Full Customer/Prospects</a>
    	</div>
 		 </li>
  		<?php } ?>
  		<?php if ($this->Security->isSuperuser()) { ?>
		<li class='dropdown'><a href='#' class='dropbtn'>Admin
				Control</a>
		<div class='dropdown-content'>
				<a href='/php/correspondence'>Correspondence</a><a
					href='/php/spamdelete'>Delete Spam</a><a href='/php/showrooms'>Edit
					Showrooms</a><a href='/php/terms'>Edit Terms & Conditions</a>
					<a href="/wholesale-price-report.asp">Wholesale Price Report</a>
					<a
					href='/php/newsalesfigures/monthly'>Sale Figures</a>
					<a href='/php/useradmin/'>Manage
					Users</a>
			</div>
		</li>
		<?php } ?>
	</ul>
</div>
<div id='adminhdr2'>
	<form action='/php/advancedsearch/results' method='post' name='formSearch3'	id='formSearch3' onSubmit='return FrontPageForm1_Validator(this)'>
		<label for='surname' id='surname'><strong>Surname:&nbsp;</strong>
		<input name='surname' type='text' class='text' id='surname' size='16' />
		</label>
		<label for='cref' id='cref'><strong>&nbsp;&nbsp;Customer Ref:&nbsp;</strong>
		<input name='cref' type='text' class='text' id='cref' size='16' />
		</label>
		<label for='company' id='cref'><strong>&nbsp;&nbsp;Company:&nbsp;</strong>
		<input name='company' type='text' class='text' id='company' size='16' />
		</label>
		<label for='orderno' id='orderno'><strong>&nbsp;&nbsp;Order	No:&nbsp;</strong>
		<input name='orderno' type='text' class='text' id='orderno'	size='7' />
		</label> 
		<input name='channel' type='hidden' value=''>
		<input name='type' type='hidden' value='n'>
		<input name='qresults' type='hidden' value='y'>
		<input name='sb' type='hidden' value='SB'>
		<input name='postcode' type='hidden' value=''>
		<input name='email' type='hidden' value=''>
		<input name='contacttype' type='hidden' value=''>
		<input name='location' type='hidden' value=''>
		<input type='submit' name='submitSearch' value='Search' id='submitSearch' class='button' />&nbsp;&nbsp;
		<a href='/php/advancedsearch'>Advanced Search</a>
	</form>
	
</div>

<script Language='JavaScript' type='text/javascript'>
		function FrontPageForm1_Validator(theForm) {
			if ((theForm.surname.value == '') && (theForm.orderno.value == '')
					&& (theForm.company.value == '')
					&& (theForm.cref.value == '')) {
				alert('Please complete one of the fields to obtain results');
				theForm.surname.focus();
				return (false);
			}
			if ((theForm.surname.value != '')
					&& (theForm.surname.value.length < 2)) {
				alert('Surname needs to be at least 2 characters long');
				theForm.surname.focus();
				return (false);
			}
			return true;
		}
		
		function showShowroomSalesReportPopup() {
			window.open('/php/ShowroomSalesReportPopup','popUpWindow','height=100,width=500,left=100,top=100,resizable=no,scrollbars=no,toolbar=no,menubar=no,location=no,directories=no, status=yes');
		}
	</script>
