<?php
/**
 * @var \App\View\AppView $this
 * @var \App\Model\Entity\Customerservice[]|\Cake\Collection\CollectionInterface $customerservice
 */
?>

<div class="container minthirtyfive-top-margin">
    <div class="bg-grey">
        <div class= "row">
            <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 col-xl-12">
            
                <h3 class="title">Customer Service List</h3>
                <p>Total number of reports open = <?= $total ?></p>
                <table width="935" border="0" cellpadding="6" cellspacing="2" id="myTable">
                <thead style="background-color:white">
                <tr>
                    <th><b>Customer Service No.</b></th>
                    <th><strong>Location</strong></th>
                    <th><strong>Order No</strong></th>
                    <th><strong>Customer Name</strong></th> 
                    <th><b>Customer Service Date</b></th>
                    <th><strong>Item Description</strong></th>
                    <th><strong>Latest Note</strong></th>
                    <th><strong>Last note by</strong></th>
                    <th><strong>Savoir Staff resolving this issue</strong></th>

                    <th><b>Follow-up Date</b></th>
                
                    </tr>
                </thead>
                <tbody>
                        <?php foreach ($customerservices as $customerservice): 
                        $followupdate='';
                        $notetext='';
                        $addedby='';
                        list($notetext, $addedby)=getnote($this->AuxiliaryData,$customerservice['CSID']);
                        if (isset($customerservice['followupdate'])){
                        	$followupdate=date("d/m/Y", strtotime(substr($customerservice['followupdate'],0,10)));
                        }
                        ?>
                        <tr>
                           
                            <td valign='top'><a href='/php/Customerservice/report?csid=<?= $customerservice['CSID'] ?>'><?= $customerservice['CSNumber'] ?></a></td>
                            <td valign='top'><?= $customerservice['adminheading'] ?></td>
                            <td valign='top'><?= $customerservice['OrderNo'] ?></td>
                            <td valign='top'><?= $customerservice['custname'] ?></td>
                            <td valign='top'><?php echo date("d/m/Y", strtotime(substr($customerservice['dataentrydate'],0,10))) ?></td>
                            <td valign='top'><?= $customerservice['ItemDesc'] ?></td>
                            <td valign='top'><?= $notetext ?></td>
                            
                            <td valign='top'><?= $addedby ?></td>
                            <td valign='top'><?= $customerservice['savoirstaffresolvingissue'] ?></td>
                            <?php
                            $string = $followupdate;//string variable
							$date = date('d-m-Y',time());//date variable

							$time1 = strtotime($string);
							$time2 = strtotime($date);
							if($time1<$time2){
                          	
                           		$red="require";
                          	 } else {
                          	 	$red="";
                          	 }
                          	 ?>
                            <td valign='top' class="<?= $red ?>">
                            
                            <?php echo $followupdate ?>
                            
                            </td>
                          
                        </tr>
                        <?php endforeach; ?>
                        </tbody>
                </table>
            </div> 
        </div>
    </div>
</div>
<script>


$(document).ready( function () {
    $('#myTable').DataTable({
    "paging": true,
    "order": [[ 0, "asc" ]], //or asc 
    "columnDefs" : [{"targets":[4, 9], "type":"date-eu"}],
    "fixedHeader": true,
    
    });
    var table = $('#myTable').DataTable();
$('#myTable').css( 'display', 'block' );
table.columns.adjust().draw();


});


</script>
<?php 
function getnote($auxhelper,$csid) {

    $sql = "Select * from customerservicenotes C join savoir_user U on C.noteaddedby=U.user_id where CSID = ". $csid ." order by csnotesid desc, dateadded desc limit 1";
    $note='';
    $addedby='';
    //debug($sql);
    //die;
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				$note=$rows['note'];
				$addedby=$rows['username'];
	    	 endforeach;
    return [$note, $addedby];
} 
?>

