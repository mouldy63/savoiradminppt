<div id="tableControllPanel">
        <div class="salefigureMenuTile">
            <a id="enableTableEdit" data-current-status="disable" onclick="inputController(this);">EDIT TABLE</a>
        </div>
        <div class="salefigureMenuTile">
            <a id="exportTable" href="#">EXPORT TABLE</a>
        </div>
        <?php if(!$isExchangeRateTable):?>
        <div class="salefigureMenuTile">
            <a id="exchangeRate" data-status="native" onclick="exchangeRate(this); return false;" href="#">CHANGE TO GBP</a>
        </div>
        <?php endif;?>
</div>
<script type="text/javascript">
function inputController(element){
        if($('#tableArea').is(':empty')){
            alert('There is no table!');
        }
        else{
            $('.set_target').each(function(){
                if(this.hasAttribute('disabled')){
                    $(this).removeAttr('disabled');
                    $(this).removeClass('disablebg');
                    $(element).html('LOCK & SAVE');
                }
                else{
                    $(this).attr('disabled','disabled');
                    $(this).addClass('disablebg');
                    $(element).html('EDIT TABLE');
                }
	        });
            var currentStatus = $(element).attr('data-current-status');
            if(currentStatus == 'disable'){
                $(element).attr('data-current-status','active');
                if($('#exchangeRate').attr('data-status')!='native'){
					$('#exchangeRate').trigger('click');
				}
				$('#exchangeRate').attr('onclick','return false;');
				$('#exchangeRate').css('opacity','0.2');
            }
            else{
            	console.log(allTargetsData.isTableChanged());
                if(allTargetsData.isTableChanged()){
                    allTargetsData.saveToDB();
                }
                $(element).attr('data-current-status','disable');
                $('#exchangeRate').attr('onclick','exchangeRate(this); return false;');
				$('#exchangeRate').css('opacity','1');
            }
        }
}

function exchangeRate(e){
	if($(e).attr('data-status') == 'native'){
			$(e).attr('data-status','gbp');
			$(e).html('CHANGE TO NATIVE CURRENCY');
			$('.nativecurrency').each(function(i,element){
			    //console.log(element);
			    var str = $(element).attr('data-currency-array');
				var data  = str.split(',');
				var newData;
				if(data[0]!='-1'){
					newData = parseFloat(data[0])/parseFloat(data[1]);
				}else{
					newData = parseFloat(data[1]);
				}
				var showData = newData.toFixed(2);
				
			    if($(element).find('input').length>0){
			    	var obj = $(element).find('input');
			    	$(obj).val(addComma(showData));
			    }else{
				    
					$(element).html(addComma(showData));
				}
			});
			$('.native_currency_code').each(function(i,element){
				$(element).html('GBP');
			});
		}else{
			$(e).attr('data-status','native');
			$(e).html('CHANGE TO GBP');
			$('.nativecurrency').each(function(i,element){
				var str = $(element).attr('data-currency-array');
                var data  = str.split(',');
				var newData;
				if(data[0]!='-1'){
					newData = parseFloat(data[0]);
				}else{
					newData = parseFloat(data[2]);
				}
				var showData = newData.toFixed(2);
				if($(element).find('input').length>0){
			    	var obj = $(element).find('input');
			    	$(obj).val(addComma(showData));
			    }else{
				    
					$(element).html(addComma(showData));
				}
			});
			$('.native_currency_code').each(function(i,element){
				$(element).html($(element).attr('data-currency-code'));
			});
		}
		return false;
}
$(document).ready(function(){
	$('.salefigureMenuTile').hover(function(){
		var obj = $(this).find('.salefigure_submenu');
		$(obj).show();
	},
	function(){
		var obj = $(this).find('.salefigure_submenu');
		$(obj).hide();
	});
	$('#exportTable').click(function(){
	    if($('#tableArea').is(':empty')){
                    alert('There is no table!');
        }else{
		    var outputFile = 'world.csv'
            exportTableToCSV.apply(this, [$('#theTable'), outputFile]);
        }
	});
});
</script>