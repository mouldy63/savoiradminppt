<?php use Cake\Routing\Router; ?>


<div id="brochureform" class="brochure" style="background-color:#f3f2f2;">

<?php if ($this->Security->retrieveUserRegion()==1 && ($this->Security->retrieveUserLocation()==3 || $this->Security->retrieveUserLocation()==4 ||$this->Security->retrieveUserLocation()==36 || $this->Security->retrieveUserLocation()==39 || $this->Security->retrieveUserLocation()==1) ) { 
//if (!$this->Security->retrieveUserLocation()==1) { ?>
<div class="colFR">  
	<div id="CollapsiblePanel1" class="CollapsiblePanel">
		<div class="CollapsiblePanelTab" tabindex="0">Payments to be Collected</div>
    		<div class="CollapsiblePanelContent">
  				 <table width="100%" border="0" cellspacing="0" cellpadding="3">
  					<tr>
   					 <td>Delivery Date</td>
   					 <td>Order No.</td>
  					  <td>Customer Name</td>
  					  <td>Balance Outstanding</td>
 					 </tr>
<?php
$thecurrency="GBP";
foreach ($outstandingbalances as $row): 
$thecurrency=$row['ordercurrency'];
?> 					 
 					 <tr>
   					 <td><?php if($row['bookeddeliverydate'] !== null) { 
		       echo date("d/m/Y", strtotime(substr($row['bookeddeliverydate'],0,10))); 
		        }?></td>
   					 <td><a href="/edit-purchase.asp?order='<?=$row['PURCHASE_No'] ?>'"><?= $row['ORDER_NUMBER'] ?></a></td>
  					  <td><a href="/editcust.asp?val='<?=$row['CONTACT_NO'] ?>'"><?= $row['surname'].', '.$row['title'].' '.$row['first'] ?></a></td>
  					  <td><?= $this->MyForm->formatMoneyWithSymbol($row['balanceoutstanding'], $thecurrency) ?></td>
 					 </tr>
 <?php endforeach; ?> 	
				 <tr>
   					 <td></td>
   					 <td></td>
  					  <td><b>TOTAL</b></td>
  					  <td><b><?= $this->MyForm->formatMoneyWithSymbol($totaloutstandingbalance, $thecurrency) ?></b></td>
 					 </tr>				 
 				</table>
 			</div>
 		</div>
	</div>

<?php //} ?>
<?php if ($this->Security->isSavoirOwned()) {
if ($this->Security->retrieveUserRegion()==1 && $savoirowned=='y' && ($this->Security->retrieveUserLocation()==3 || $this->Security->retrieveUserLocation()==4 ||$this->Security->retrieveUserLocation()==36 || $this->Security->retrieveUserLocation()==39 || $this->Security->retrieveUserLocation()==1) ) { ?>
<div class="colFL">
<?php } else { ?>
<div class="bedworks">
<?php } 
if ($this->Security->retrieveUserRegion()==1) {
	$noteslink="orderdetails.asp?pn=";
} else {
	$noteslink="edit-purchase.asp?order=";
}
?>
<div id="CollapsiblePanel2" class="CollapsiblePanel">
	<div class="CollapsiblePanelTab" tabindex="0">Outstanding Tasks</div>
    <div class="CollapsiblePanelContent">
   <table border="0" align="center" cellpadding="8" cellspacing="0">
   <tr><td colspan="6">	ORDER NOTES</td></tr>

  <tr>
    <td>Task&nbsp;Due&nbsp;Date</td>
    <td>Order No.</td>
    <td>Customer Name</td>
    <td>Created By</td>
    <td>Description</td>
    <td>Status</td>
  </tr>
<?php foreach ($outstandingtasks as $rows): 
$overdueclass='';
if ($rows['followupdate']<>'') {
	if ($rows['followupdate'] < date('Y-m-d')) {
		$overdueclass='overdue';
	} else {
		$overdueclass='';
	}
}
?> 	 
<tr class="<?= $overdueclass?>"><td valign="top">
 
<script>
$(function() {
$( "#datechange<?= $rows['ordernote_id']?>" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy',
onSelect: function () {
   var date = $("#datechange<?= $rows['ordernote_id']?>").val();
   window.location.assign('/php/home/changenotedate?dtdate=' + date + '&pn=<?= $rows['purchase_no']?>&dtchange=<?= $rows['ordernote_id']?>');
            }
});
$( "#datechange<?= $rows['ordernote_id']?>" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});
</script>
<input name = "datechange<?= $rows['ordernote_id']?>" type = "text" placeholder="Date change" class = "text" id = "datechange<?= $rows['ordernote_id']?>" value = "<?= $this->MyForm->fmtDateForDatePicker2($rows['followupdate']) ?>" size = "10" style="background-color:transparent; border:none;" /></td>
    <td valign="top">
    <?php 
    if ($rows['quote']=='y') { ?>
    <a href='/edit-purchase.asp?quote=y&order=<?=$rows['purchase_no']?>'><?=$rows['ORDER_NUMBER']?></a>
    <?php 
    } else { ?>
    <a href='/<?=$noteslink?><?=$rows['purchase_no']?>'><?=$rows['ORDER_NUMBER']?></a>
    <?php } ?>
    
    </td>
    <td valign="top"><div id="tip2<?=$rows['CODE']?>"><div title="Mouse follow">
    <?php 
    $custname=$rows['surname'] .','.$rows['title'].' '.$rows['first'];
    if ($rows['company'] !== '') {
    $custname .= '<br><font size="1px"><b>(' .$rows['company'].')</b></font>';
    }
    
    if ($rows['quote']=='y') {
    echo '<a href="/editcust.asp?val='.$rows['CONTACT_NO'].'">'.$custname.'</a>';
    } else {
    echo '<a href="/'.$noteslink.$rows['purchase_no'].'">'.$custname.'</a>';
    }
    
    ?>
    </div></div></td>
    <td valign="top">
    <?php if ($rows['quote']=='y') {
     echo '<a href="/editcust.asp?val='.$rows['CONTACT_NO'].'">'.$rows['username'].'</a>';
     } else {
    echo '<a href="/'.$noteslink.$rows['purchase_no'].'">'.$rows['username'].'</a>';
    }
    ?></td>
    <td valign="top"><div id="tip<?=$rows['ordernote_id']?>"><div title="Mouse follow">
    <?php if ($rows['quote']=='y') {
    echo '<a href="/editcust.asp?val='.$rows['CONTACT_NO'].'">';
    } else {
    echo '<a href="/'.$noteslink.$rows['purchase_no'].'">';
    }
    if (strlen($rows['notetext'])>20) {
     echo substr($rows['notetext'], 0, 17)."...";
    } else {
     echo $rows['notetext'];
    }
    ?></a>
    </div></div></td>
    <td><button class="close<?= $rows['ordernote_id']?> btn btn-primary"><img src="/images/green-button.png" width="20" height="20"></button>
    
                            </td>
   
	<script type="text/javascript">
		$(function() {
			// mouse-on example
			var mouseOnDiv = $('#tip2<?=$rows['CODE']?> div');
			var tipContent = $(
				'<p><?php echo $rows['first']. " " .$rows['surname']."<br />Tel Work: ".$rows['telwork']."<br />Mobile: ".$rows['mobile']."<br />Email: <a href=mailto:".$rows['EMAIL_ADDRESS'].">".$rows['EMAIL_ADDRESS']."</a>" ?></p>'
			);
			mouseOnDiv.data('powertipjq', tipContent);
			mouseOnDiv.powerTip({
				placement: 'e',
				mouseOnToPopup: true
			});
		});
		
		$(function() {
			// mouse-on example
			var mouseOnDiv = $('#tip<?=$rows['ordernote_id']?> div');
			var tipContent = $(
				'<p><?=$rows['notetext']?></p>'
			);
			mouseOnDiv.data('powertipjq', tipContent);
			mouseOnDiv.powerTip({
				placement: 'e',
				mouseOnToPopup: true
			});
		});

		$('.close<?= $rows['ordernote_id']?>').on('click', function () {
			$.confirm({
				title: 'Would you like to complete this task',
				content: '',
				buttons: {
					yes: function () {
						window.location.assign('home/closeordernote?close=<?= $rows['ordernote_id']?>');
					},
					no: function () {
					}
				}
			});
		});
    </script>
  </tr>
  
 <?php endforeach; ?> 
 
 
 <tr><td colspan="6">
	
CUSTOMER NOTES</td></tr>
<?php foreach ($customernotes as $row): 
if ($row['Next']<>'') {
	if ($row['Next'] < date('Y-m-d')) {
		$overdueclass='overdue';
	} else {
		$overdueclass='';
	}
}?>  
  <tr class="<?= $overdueclass ?>">
    <td valign="top">
<script>
$(function() {
$( "#datechanget<?= $row['Communication']?>" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy',
onSelect: function () {
   var date = $("#datechanget<?= $row['Communication']?>").val();
   window.location.assign('/php/home/changetaskdate?dtdate=' + date + '&correschange=' + <?= $row['Communication']?>);
            }
});
$( "#datechanget<?= $row['Communication']?>" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});
</script>
<input name = "datechanget<?= $row['Communication']?>" type = "text" placeholder="Date change" class = "text" id = "datechanget<?= $row['Communication']?>" value = "<?= $this->MyForm->fmtDateForDatePicker2($row['Next']) ?>" size = "10" style="background-color:transparent; border:none;" /></td>
     <td valign="top">-</td>
    <td valign="top"><div id="tip4<?= $row['CODE'] ?>"><div title="Mouse follow">
    <a href="/editcust.asp?tab=4&val=<?= $row['Contact_no'] ?>">
    <?php echo $row['surname'] .','.$row['title'].' '.$row['first'];
    if ($row['company'] !== '') {
    echo '<br><font size="1px"><b>(' .$row['company'].')</b></font>';
    }
    ?></a>
    </div></div></td>
    <td valign="top"><a href="/editcust.asp?tab=4&val=<?= $row['Contact_no'] ?>">
    <?= $row['staff']?>
    </a></td>
    <td valign="top"><div id="tip3<?= $row['Communication'] ?>"><div title="Mouse follow">
    <a href="/editcust.asp?tab=4&val=<?= $row['Contact_no'] ?>">
    <?php if ($row['Response'] != null && strlen($row['Response'])>20) {
     echo substr($row['Response'], 0, 17)."...";
    } else if ($row['Response'] != null && $row['Response']=='' && strlen($row['notes'])>20) {
     echo substr($row['notes'], 0, 17)."...";
    } else if ($row['Response']!= null){
     echo $row['Response'] ." " .$row['notes'];
    } else {
        echo $row['notes'];
    }?>
    </a>
    </div></div>
    <td><button class="close<?= $row['Communication']?> btn btn-primary"><img src="/images/green-button.png" width="20" height="20"></button>
    
                            
	<script type="text/javascript">
	$(function() {
			// mouse-on example
			var mouseOnDiv = $('#tip3<?= $row['Communication'] ?> div');
			var tipContent = $(
				'<p><?= $row['Response'] ?><?= $row['notes'] ?></p>'
			);
			mouseOnDiv.data('powertipjq', tipContent);
			mouseOnDiv.powerTip({
				placement: 'e',
				mouseOnToPopup: true
			});
		});
		
		$(function() {
			// mouse-on example
			var mouseOnDiv = $('#tip4<?= $row['CODE'] ?> div');
			var tipContent = $(
				'<p><?php echo $row['first']." ".$row['surname']."<br />Tel: ".$row['tel']."<br />Tel Work: ".$row['telwork']. "<br />Mobile : ".$row['mobile']."<br />Email: <a href=mailto:".$rows['EMAIL_ADDRESS'].">".$rows['EMAIL_ADDRESS']."</a>" ?></p>'
			);
			mouseOnDiv.data('powertipjq', tipContent);
			mouseOnDiv.powerTip({
				placement: 'e',
				mouseOnToPopup: true
			});
		});
		
		$('.close<?= $row['Communication']?>').on('click', function () {
			$.confirm({
				title: 'Would you like to complete this task',
				content: '',
				buttons: {
					yes: function () {
						$.confirm({
						title: 'Would you like to complete this task',
						content: '' +
						'<form action="" class="formName">' +
						'<div class="form-group">' +
						'<label>You need to enter a response before completing this task:</label>' +
						'<textarea placeholder="Response" class="name form-control" required />' +
						'</div>' +
						'</form>',
						buttons: {
							formSubmit: {
								text: 'Submit',
								btnClass: 'btn-blue',
								action: function () {
									var name = this.$content.find('.name').val();
									
									if(!name){
										$.alert('provide a valid response');
										return false;
									}
									$.alert('Your response is ' + name);
									window.location.assign('home/closecustomernote?corrclose=<?= $row['Communication']?>&name=' + name);
								}
							},
							cancel: function () {
								//close
							},
						},
						onContentReady: function () {
							// bind to events
							var jc = this;
							this.$content.find('form').on('submit', function (e) {
								// if the user submits the form by pressing enter in the field.
								e.preventDefault();
								jc.$$formSubmit.trigger('click'); // reference the button and click it
							});
						}
					});
		
					},
					no: function () {
					}
				}
			});
		});
	</script>
                            </td>
  </tr>
 <?php endforeach; ?>
   </table>
  </div></div>
</div><?php }  ?>
</div>
<?php }  ?>
<script type="text/javascript">
var CollapsiblePanel1 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel1");
</script>
<script type="text/javascript">
var CollapsiblePanel2 = new Spry.Widget.CollapsiblePanel("CollapsiblePanel2");
</script>
