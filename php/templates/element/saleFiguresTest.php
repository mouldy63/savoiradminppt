<?php
use Cake\Core\Configure;
use Cake\Routing\Router;
?>
<?php 	$isTestOn = $test['isTestOn'];
		$testInfo = $test['testInfo'];
		if($isTestOn=='y'){
			$testData = $test['testData'];
		}
?>
<div id="tableControllPanel">
		<div class="salefigureMenuTile inputcell" <?php echo $isTestOn=='y'?'style="opacity:0.4;"':'';?> >
          Start time: <input type="date" <?php echo $isTestOn=='y'?'disabled':'';?> id="testStartTime" onchange="changeDate('data-ch-1');" value="<?php if(!empty($testInfo['startTime'])){echo date('Y-m-d',strtotime($testInfo['startTime']));}?>"/>
       </div>
       <div class="salefigureMenuTile inputcell" <?php echo $isTestOn=='y'?'style="opacity:0.4;"':'';?> >
          End time: <input type="date" <?php echo $isTestOn=='y'?'disabled':'';?> id="testEndTime" onchange="changeDate('data-ch-2');" value="<?php if(!empty($testInfo['startTime'])){ echo date('Y-m-d',strtotime($testInfo['endTime']));}?>"/>
       </div>

       <div class="salefigureMenuTile">
          <a id="changeTestStatus" data-current-status="<?php echo $isTestOn=='y'?'on':'off'; ?>" data-ch-1="n" data-ch-2="n" onclick="changeTestStatus(this);return false;" data-id="<?php echo empty($testInfo)?-1:$testInfo['id'];?>" href="#"><?php if($isTestOn=='y'):?>STOP TEST<?php else:?>SET TEST & START<?php endif;?></a>
       </div>
</div>

<div id="testArea">
<?php if($isTestOn=='y'):?>
<table id="testTable">
<thead>
<tr>
	<th class = "twotablecell bordercell">ORDER NUMBER</th>
	<th class = "twotablecell bordercell">ORDER AMOUNT</th>
	<th class = "twotablecell bordercell">SHOWROOM</th>
	<th class = "twotablecell bordercell">ORDER DATE</th>
	<th class = "twotablecell bordercell">CURRENCY CODE</th>
	<th class = "twotablecell bordercell">RATE</th>
</tr>
</thead>
<tbody id="testTable" style="height:200px;">
<?php foreach($testData as $t):
	$date = $t["a"]["ORDER_DATE"];
	$testYear = date('Y',strtotime($date));
	$testMonth = date('m',strtotime($date));
?>
<tr>
	<td class = "twotablecell bordercell"><a href="/orderdetails.asp?pn=<?php echo $t["a"]["PURCHASE_No"]; ?>" target="_blank"><?php echo $t["a"]["ORDER_NUMBER"]; ?></a>
	</td>
	<td class = "twotablecell bordercell"><?php echo $t["a"]["totalexvat"];?></td>
	<td class = "twotablecell bordercell"><?php echo $t["b"]["location"];?></td>
	<td class = "twotablecell bordercell"><?php echo date('d/m/Y',strtotime($t["a"]["ORDER_DATE"]));?></td>
	<td class = "twotablecell bordercell"><?php echo $t["a"]["ordercurrency"];?></td>
	<td class = "twotablecell bordercell"><?php echo $t["c"]["exchange_rate"];?></td>
</tr>
<?php endforeach;?>
</tbody>
</table>
<?php endif;?>
</div>

<script type="text/javascript">
function changeDate(t){
	$('#changeTestStatus').attr(t,'y');
	 //console.log($('#testStartTime').val());
	 //console.log($('#testEndTime').val());
}
function changeTestStatus(element){
	var currentStatus = $(element).attr('data-current-status');
	var testId = $(element).attr('data-id');
	var url = "";
	var action = '<?php echo $action;?>';
	if(action == 'year'){
		url = "<?php echo Router::url('/', true);?>saleFigures/world";
	}else{
		url = "<?php echo Router::url('/', true);?>saleFigures/worldMonthlyFigures";
	}
	if(currentStatus == 'on'){

		$.ajax({
			method:"post",
			url:"<?php echo Router::url('/', true);?>saleFigures/test",
			data:{"status":"off","id":testId,"action":"<?php echo $action;?>"},
			success:function(data){
				$(element).attr('data-current-status','off');
				$(element).html('SET TEST & START');
				alert('The Test mode has been stopped.');
				if(data == 'redirect'){
					window.location=url;
				}
			},
			error:function(e){
				alert('Server error');
			}
		});
	}
	else{
		var startTime = $('#testStartTime').val();
		var endTime = $('#testEndTime').val();
		if(startTime.length>0&&endTime.length>0){
			//if($(element).attr('data-ch-1')=='y'||$(element).attr('data-ch-2')=='y'){
				$.ajax({
					method:"post",
					url:"<?php echo Router::url('/', true);?>saleFigures/test",
					data:{"status":"on","id":testId,"action":"<?php echo $action;?>","start":startTime,"end":endTime},
					success:function(data){
						$(element).attr('data-current-status','on');
						$(element).html('STOP TEST');
						alert('The Test mode is on.');
						var action = '<?php echo $action;?>';
						if(data == 'redirect'){
							window.location=url;
						}						
					},
					error:function(e){
						alert('Server error');
					}
				});
				
				
			//}else{
			//	alert('Please change the date.');
			//}
		}else{
			alert('Please set test first.');
		}
	}
}
</script>