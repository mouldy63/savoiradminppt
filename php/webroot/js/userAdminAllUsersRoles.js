function adjustTable(){
	var standardWidth = jQuery('#tableArea').width();
		standardWidth = Math.round((standardWidth-100)/18);
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
		data:{'sort':'name|asc',
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
function search(key,url){
	$('#searchkey').val(key);
	$('#filter').val('');
	$('#sort').val('name|asc');
        console.log(url);
	$.ajax({
		method:'post',
		url:url,
		data:{'sort':'name|asc',
			'searchkey':key,
			'filter':'',
			'page':1},
		success:function(data){
                    console.log(data);
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
	
	$('#allUserRoleTable').on('click','.edit',function(){
		var td = $(this).parent();
		var tr = $(this).parent().parent();
		$(tr).find('.controlled').removeAttr('disabled');
		$(this).hide();
		$(td).find('.hidebutton').show();
	});
	
	$('#allUserRoleTable').on('click','.CancelRolesChange',function(){
		var td = $(this).parent();
		var tr = $(this).parent().parent();
		var allinputs = $(tr).find('.controlled');
		$(allinputs).prop('checked',false);
		$(allinputs).removeAttr('checked');
		$(allinputs).each(function(index,value){
			if(value.hasAttribute('data-original')){
				$(value).prop('checked', true);
				//this.checked = true;
			}
		});
		$(tr).find('.controlled').attr('disabled','true');
		$(td).find('.edit').show();
		$(td).find('.hidebutton').hide();
	});
	$('#allUserRoleTable').on('click','.SaveRolesChange',function(){
		var row = $(this).parent().parent();
		var selected = row.find('input:checked');
		var roles = [];
		var td = $(this).parent();
		var tr = $(this).parent().parent();
		if(selected.length<=0){
			alert('You have to selected at least one role!');
		}else{
			for(var i=0;i<selected.length;i++){
				roles[i] = $(selected[i]).val();
			}
			var user_id = $(this).attr('data-id');
			$.ajax({
				method:'post',
				url:'/php/useradmin/editRoles',
				data:{'id':user_id,
					'role_ids':JSON.stringify(roles)
				},
				success:function(data){
					if(data=='y'){
						alert('Changes to User Roles have been saved and updated');
						$(tr).find('.controlled').attr('disabled','true');
						$(td).find('.edit').show();
						$(td).find('.hidebutton').hide();
					}
				},
				error:function(){}
				
			});
		}
		
	});
	$('.editController').click(function(){
		if($('.controlled').is(':disabled')){
			$('.controlled').removeAttr('disabled');
			$(this).html('Disable Edit');
		}else{
			$('.controlled').attr('disabled','true');
			$(this).html('Enable Edit');
		}
	});
});