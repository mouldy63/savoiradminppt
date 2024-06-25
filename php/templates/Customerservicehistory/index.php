<?php
/**
 * @var \App\View\AppView $this
 * @var \App\Model\Entity\Customerservice[]|\Cake\Collection\CollectionInterface $customerservice
 */
?>
<?php echo $this->Html->css('bootstrap.min.css', array('inline' => false)); ?>
<?php echo $this->Html->css('userAdmin.css', array('inline' => false)); ?>
<?php echo $this->Html->css('style.css', array('inline' => false)); ?>
<?php echo $this->Html->css('jquery-ui.min.css', array('inline' => false)); ?>
<?php echo $this->Html->script('popper.min.js', array('inline' => false)); ?>
<?php echo $this->Html->script('bootstrap.min.js', array('inline' => false)); ?>
<?php echo $this->Html->script('jquery-ui.min.js', array('inline' => false)); ?>
<script>
$(function() {
var year = new Date().getFullYear();
$( "#datefrom" ).datepicker({
changeMonth: true,
yearRange: "1997:"+year,
changeYear: true
});
$( "#datefrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#dateto" ).datepicker({
changeMonth: true,
yearRange: "1997:"+year,
changeYear: true
});
$( "#dateto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});
</script>

<div class="container">
    <div class="bg-grey">
        <div class= "row">
            <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 col-xl-12">
            
                <p class="margintwenty-top">Customer Service List</p>
                
                <form name="form1" id="form1" method="post" action="/php/Customerservicehistory">
                <p>
                <label for="datefrom">
                Choose between CS closed dates: From:
                <input name="datefrom" type="text" id="datefrom" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($datefrom) ?>">
		      

                <label for="dateto">
               <input name="dateto" type="text" id="dateto" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($dateto) ?>">
                </label>
                </p>
                <p>
               <input type="submit" onclick="changeFormAction('form1', '/php/Customerservicehistory');" name="search" value="Search Database"  id="search" class="button" /> 
               <input name="excellist" onclick="changeFormAction('form1', '/php/Customerservicehistory/export');" type="submit" class="button" id="excellist" value="Download CSV file" />
 
                <p>
                
                Number of closed reports = <?= $noofrecs ?>
                </p>
                </form>
                
                <table id="myTable">
                <thead
                <tr style="background-color:white">
                    <th width="71" valign="bottom">Customer Service No.</th>
                    <th width="69" valign="bottom">Location</th>
                    <th width="72" valign="bottom">Order No</th>
                    <th width="72" valign="bottom">Customer Service Date</th>
                    <th width="72" valign="bottom">Date Closed</th>
                    <th width="106" valign="bottom">Item Description</th>
                    <th width="106" valign="bottom">Problem with Product</th>
                    <th width="100" valign="bottom">Replacement Price</th>
                    <th width="49" valign="bottom">Service Code</th>
                    <th width="49" valign="bottom">Closing Notes</th>
                    <th width="71" valign="bottom">Closed by<br></th>
                    </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($customerservices as $customerservice): ?>
                        <tr>
                           
                            <td valign="top"><a href="/php/customerservice/closedreport?csid=<?= $customerservice['CSID'] ?>"><?= $customerservice['CSNumber'] ?></a></td>
                            <td valign="top"><?= $customerservice['adminheading'] ?></td>
                            <td valign="top"><a href="/edit-purchase.asp?order=<?= $customerservice['PURCHASE_No'] ?>"><?= $customerservice['OrderNo'] ?></a></td>
                            <td valign="top"><?php echo date("d/m/Y", strtotime(substr($customerservice['dataentrydate'],0,10))) ?></td>
                            <td valign="top"><?php echo date("d/m/Y", strtotime(substr($customerservice['datecaseclosed'],0,10))) ?></td>
                            <td valign="top"><?php $customerservice['ItemDesc'] ?></td>
                            <td valign="top"><?php $customerservice['ProblemDesc'] ?></td>
                            <td valign="top">
                            <?php if ($customerservice['replacementprice'] <> '') {
                            echo "£" .(number_format($customerservice['replacementprice'], 2, '.', ',')); 
                            } else {
                            echo "£0.00";
                            }
                            ?>
                            </td>
                            <td valign="top"><?= $customerservice['ServiceCode'] ?></td>
                            
                            <td valign="top"><?= $customerservice['closedcasenotes'] ?></td>
                            <td valign="top"><?= $customerservice['closedby'] ?></td>
                           
                            
                        </tr>
                        <?php endforeach; ?>
                        </tbody>
                </table>
                
            </div> 
        </div>
    </div>
</div>
<script>

function changeFormAction(formId, newAction) {
	//console.log("New action = " + newAction);
	$('#' + formId).attr('action', newAction);
}


$(document).ready( function () {
    $('#myTable').DataTable({
    "paging": true,
    "lengthMenu": [ 50, 75, 100, 200 ],
    "responsive": true,
    "order": [[ 0, "asc" ]], //or asc 
    "columnDefs" : [{"targets":[3, 4], "type":"date-eu"}],
    "fixedHeader": true,
    
    });
    


});


$("#export_form").submit(function(event) {
	$('#exp_datefrom').val($('#datefrom').val());
	$('#exp_dateto').val($('#dateto').val());
});
</script>
