$(document).ready(function(){
	$('#show-report').click(function(){
		$('#control-area').show();
		$('#show-search').hide();
		$('#revenueException').hide();
	});
	$('#enable-month-format').click(function(){
		$('#time-format-selection').val('month');
		$('.month-select').show();
		$('.day-selection').attr('disabled','true');
		return false;
	});
	$('#clear-selection').click(function(){
		if($('.month-select').is(':visible')){
			$('.month-select').hide();
		}
		$('.day-selection').removeAttr('disabled');
		$('.select').val('-1');
		$('option').removeAttr('selected');
		$('.day-selection').val('');
		$('#time-format-selection').val('day')
		return false;
	});
	$('#show-table').click(function(){
		getData('table');
		return false;
	});
	$('#get-csv').click(function(){
		getData('csv');
		return false;
	});
})
function getData(dataFormat){
	var selection = validation();
	if(!selection){
		return false;
	}
	selection.dataformat = dataFormat;
	//console.log(selection);
	if(dataFormat == 'table'){
		$.ajax({
			url:'/php/revenue/getRevenue',
			method:"post",
			data:{revenue:JSON.stringify(selection)},
			success:function(data){
				var raw = JSON.parse(data);
				var table = raw.table;
				$('#table-area').empty();
				$('#table-area').append(table);
			},
			error:function(e){}
		});
	}else{
		var s = JSON.stringify(selection);
		getCSV(s);
	}
	
}
function getCSV(requirement){
	var tempForm = document.createElement('form');
	tempForm.id = "tempForm";
	//tempForm.target = "_blank";
	tempForm.method = "POST";
	tempForm.action = "/php/revenue/getRevenue";
	var tempInput = document.createElement("input");
	tempInput.type = "text";
	tempInput.name = "revenue";
	tempInput.value = requirement;
	tempForm.appendChild(tempInput);
	document.body.appendChild(tempForm);
	tempForm.submit();
	var e = document.getElementById("tempForm");
	e.parentNode.removeChild(e);
}
function validation(){
	var selection = {};
	var dateFormat = $('#time-format-selection').val();
	if(dateFormat == 'month'){
		var month = $('.select-month').val();
		var year = $('.select-year').val();
		if(month==-1||year==-1){
			alert('Please select the month and year');
			return false;
		} 
		var temp = {'month':month,'year':year};
		selection[dateFormat] = temp;
	}else{
		var fromDate = $('.from-date').val();
		var toDate = $('.to-date').val();
		if(fromDate.length==0||fromDate.length==0){
			alert('Please select from date and to date');
			return false;
		}
		var temp = {'from':fromDate,'to':toDate};
		selection[dateFormat]=temp;
		
	}
	var dateRange = $('.select-date-range').val();
	var	showroom = $('.select-showroom').val();
	if(dateRange==-1||showroom==-1){
		alert('Please select date range and showroom');
		return false;
	}
	selection.daterange = dateRange;
	selection.showroom = showroom;
	return selection;
}