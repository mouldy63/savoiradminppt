<tr>
    <th scope="row"><?=$title?></th>
    <td><?=$formHelper->formatCurrency($price)?></td>
    <?php
    $discount=0;
    if ($pmEnabled=='y') { 
        if (isset($discountObj['standardPrice']) && $discountObj['standardPrice']>0) { 
            $discount=$discountObj['standardPrice']-$discountObj['price'];
        }
        ?>
        <td><?=$formHelper->formatCurrency($discount)?></td>
        <td>
            <?php
            $discountPc=0;
            if ($discountObj['standardPrice'] > 0) {
                $discountPc=100*$discount/$discountObj['standardPrice']; 
            }
            ?>
            <?= $formHelper->formatPercent($discountPc) ?>
        </td>
        <td>
            <?=$formHelper->formatCurrency($discountObj['standardPrice'])?>
            <input type="hidden" id="<?=$listPriceSpanId?>" value="<?=$discountObj['standardPrice']?>" />
        </td>
    <?php } ?>
</tr>