<?php use Cake\Routing\Router; ?>
<table class="table">
  <thead>
    <tr>
      <th scope="col">Order No</th>
      <th scope="col">Order Date</th>
      <th scope="col">Contact</th>
      <th scope="col">Source</th>
      <th scope="col">Customer Ref.</th>
      <th scope="col">Archive Information</th>
      <th scope="col">Notes</th>
      <th scope="col">Order Description</th>
    </tr>
  </thead>
  <tbody>
    <?php foreach ($allorders as $allorder): 
        $orderdesc='';
        if ($allorder['mattressrequired']=='y') {
            $orderdesc.="Mattress: ".$allorder['savoirmodel'];
        
            if ($allorder['mattress1width']!='') {
                $orderdesc.=" (".$allorder['mattress1width'].",".$allorder['mattress2width'];
            } else {
                $orderdesc.=" (".$allorder['mattresswidth'];
            }
            if ($allorder['mattress1length']!='') {
                $orderdesc.=" x ".$allorder['mattress1length'].",".$allorder['mattress2length'].")";
            } else {
                $orderdesc.=" x ".$allorder['mattresslength'].")";
            }
            $orderdesc.="<br>";
        }
        if ($allorder['topperrequired']=='y') {
            $orderdesc.=$allorder['toppertype']." (".$allorder['topperwidth']." x ".$allorder['topperlength'].")";
            $orderdesc.="<br>";
        }
        if ($allorder['baserequired']=='y') {
            $orderdesc.="Base: ".$allorder['basesavoirmodel'];
            $orderdesc.=" (".$allorder['basewidth'];
            if ($allorder['base2width']!='') {
                $orderdesc.=",".$allorder['base2width'];
            } 
                $orderdesc.=" x ".$allorder['baselength'];
            if ($allorder['base2length']!='') {
                $orderdesc.=",".$allorder['base2length'];
            } 
            $orderdesc.=")<br>";
        }
        if ($allorder['legsrequired']=='y') {
            $orderdesc.="Legs: ".$allorder['legstyle'];
            $orderdesc.="<br>";
        }
        if ($allorder['headboardrequired']=='y') {
            $orderdesc.="HB: ".$allorder['headboardstyle'];
            $orderdesc.="<br>";
        }
        if ($allorder['valancerequired']=='y') {
            $orderdesc.="Valance";
            $orderdesc.="<br>";
        }
        if ($allorder['accessoriesrequired']=='y') {
            $orderdesc.="Accessories";
            $orderdesc.="<br>";
        }
        ?>
    <tr>
      <th scope="row"><a href="/php/order?pn=<?=$allorder['PURCHASE_No']?>"><?=$allorder['ORDER_NUMBER']?></a></th>
      <td><?=$allorder['ORDER_DATE']?></td>
      <td><?=$allorder['salesusername']?></td>
      <td><?=$allorder['location']?></td>
      <td><?=$allorder['customerreference']?></td>
      <td><?=$allorder['BED']?></td>
      <td><?=$allorder['NOTES']?></td>
      <td><?=$orderdesc?></td>
    </tr>
    <?php endforeach; ?>  
  </tbody>
</table>
  

