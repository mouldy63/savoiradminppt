function adjustTable(){
	var standardWidth = 1000;
		standardWidth = 164;
	var padding = 3;
	var border = 1;
		
		var twoCellWidth = standardWidth*2 + padding*2 + border;
		var fourCellWidth = twoCellWidth*2 + padding*2 + border;
		var sixCellWidth = twoCellWidth*3 + padding*4 + border*2;
		var eightCellWidth = fourCellWidth*2 + padding*2 + border;
		var tenCellWidth = twoCellWidth*5 + padding*8 + border*4;
		var onesixCellWidth = eightCellWidth*2 + padding*2 + border;
		var threetwoCellWidth = onesixCellWidth*2 + padding*2 + border;
		
		var cellStyle = "max-width:"+standardWidth +"px;" + "min-width:"+standardWidth +"px;";
		var twocellStyle = "max-width:"+(twoCellWidth) +"px;" + "min-width:"+(twoCellWidth) +"px;";
		var fourcellStyle = "max-width:"+(fourCellWidth) +"px;" + "min-width:"+(fourCellWidth) +"px;";
		var sixcellStyle = "max-width:"+(sixCellWidth) +"px;" + "min-width:"+(sixCellWidth) +"px;";
		var eightcellStyle = "max-width:"+(eightCellWidth) +"px;" + "min-width:"+(eightCellWidth) +"px;";
		var tencellStyle = "max-width:"+(tenCellWidth) +"px;" + "min-width:"+(tenCellWidth) +"px;";
		var threetwocellStyle = "max-width:"+(threetwoCellWidth) +"px;" + "min-width:"+(threetwoCellWidth) +"px;";
		
		$('.tablecell').each(function(){
			var newStyle = cellStyle;
			$(this).attr('style',newStyle);
		});
		$('.twotablecell').each(function(){
			var newStyle = twocellStyle;
			$(this).attr('style',newStyle);
		});
		$('.fourtablecell').each(function(){
			var newStyle = fourcellStyle;
			$(this).attr('style',newStyle);
		});
		$('.sixtablecell').each(function(){
			var newStyle = sixcellStyle;
			$(this).attr('style',newStyle);
		});
		$('.eighttablecell').each(function(){
			var newStyle = eightcellStyle;
			$(this).attr('style',newStyle);
		});
		$('.tentablecell').each(function(){
			var newStyle = tencellStyle;
			$(this).attr('style',newStyle);
		});
		$('.threetwotablecell').each(function(){
			var newStyle = threetwocellStyle;
			$(this).attr('style',newStyle);
		});		
	}
function selectPage(page,url){
	$('#page').val(page);
	var searchkey = $('#searchkey').val();
	var sort = $('#sort').val();
	var filter = $('#filter').val();
	$.ajax({
		method:'post',
		url:url,
		data:{'sort':sort,
			'searchkey':searchkey,
			'filter':filter,
			'page':page
			},
		success:function(data){
			var users = JSON.parse(data);
			$('#datatable').empty();
			$('#datatable').append(users['table']);
			adjustTable();
		},
		error:function(){
			alert('transmisson failed!');
		}
	});
}
function sortUsers(string,url,element){
	var strArray = string.split('|');
	var keyword = strArray[0];
	var order = strArray[1];
	var newString = '';
	if(order == 'asc'){
		newString = keyword + '|desc';
	}else{
		newString = keyword + '|asc';
	}
	var onClickString = "sortUsers('" + newString + "','" + url +"',this);return false;";
	element.setAttribute('onclick',onClickString);
	//$(element).attr('onclick',onClickString);
	$.ajax({
		method:'post',
		url:url,
		data:{'sort':string,
			'searchkey':$('#searchkey').val(),
			'filter':'',
			'page':1},
		success:function(data){
			if(data==null||data.length<=0){
				alert('No matched record found!');
				return;
			}
			var user = JSON.parse(data);
			$('#datatable').empty();
			$('#datatable').append(user['table']);
			adjustTable();
			$('#pageNum').empty();
			var totalpage = parseInt(user['totalPage']);
			console.log(totalpage);
			var currentpage = parseInt(user['currentPage']);
			for(var i=1;i<=totalpage;i++){
				if(i==currentpage){
					$('#pageNum').append('<a href="#" class="pageNumber strong">'+ i +'</a>');
				}else{
					$('#pageNum').append('<a href="#" class="pageNumber">'+ i +'</a>');
				}
				
			}
			$('#sort').val(string);
			$('#page').val(1);
		},
		error:function(){}
	});
}

function search(key,url){
	$('#searchkey').val(key);
	$('#filter').val('');
	$('#sort').val('name|asc');
	$('#page').val(1);
	$.ajax({
		method:'post',
		url:url,
		data:{'sort':'name|asc',
			'searchkey':key,
			'filter':'',
			'page':1},
		success:function(data){
			if(data==null||data.length<=0){
				alert('No matched record found!');
				return;
			}
			var user = JSON.parse(data);
			$('#datatable').empty();
			$('#datatable').append(user['table']);
			adjustTable();
			$('#pageNum').empty();
			var totalpage = parseInt(user['totalPage']);
			console.log(totalpage);
			var currentpage = parseInt(user['currentPage']);
			for(var i=1;i<=totalpage;i++){
				if(i==currentpage){
					$('#pageNum').append('<a href="#" class="pageNumber strong">'+ i +'</a>');
				}else{
					$('#pageNum').append('<a href="#" class="pageNumber">'+ i +'</a>');
				}
				
			}
		},
		error:function(){}
	});
}
$(window).resize(function(){
	adjustTable();
});
$(document).ready(function(){
	adjustTable();
	$('#pageNum').on('click','.pageNumber',function(){
		var page = $(this).html();
		var url = $('#pageNum').attr('data-link');
		selectPage(page,url);
		$('.pageNumber').removeClass('strong');
		$(this).addClass('strong');
		return false;
	});
	$('#datatable').on('mouseover','.userrow',function(){
		$(this).attr('style','background-color:lightgrey;');
	});
	$('#datatable').on('mouseout','.userrow',function(){
		$(this).removeAttr('style');
	});
	$('#search').click(function(){
		var url = $(this).attr('data-link');
		var keywords = $('#keywords').val();
		if(keywords.length>0){
			search(keywords,url);
		}
		else{
			alert('Please Enter Keywords!');
		}
	});
	$('#datatable').on('click','.retire',function(){
		var link = $(this).attr('data-link');
		console.log(link);
		if(confirm('Do you want to retire this user?')){
			window.location = link;
		}
		return false;
	});
});