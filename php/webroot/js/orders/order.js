$(document).ready(function() {
	topComponentLoadWatch('mattress', 1);
	topComponentLoadWatch('topper', 5);
	topComponentLoadWatch('base', 3);
	topComponentLoadWatch('legs', 7);
	topComponentLoadWatch('headboard', 8);
	topComponentLoadWatch('valance', 6);
	registerTextareaUsageCounter('order_notetext', 'order_notetext_counter', 250);
	
	$("#order_productiondate").datepicker({dateFormat: 'dd/mm/yy'});
	$("#order_bookeddeliverydate").datepicker({dateFormat: 'dd/mm/yy'});
	$("#order_acknowdate").datepicker({dateFormat: 'dd/mm/yy'});
});
