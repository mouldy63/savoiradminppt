<?php if (!empty($data[0])) { ?>
<table>
	<thead>
		<tr>
			<?php foreach($data[0] as $key=>$value):?>
			<th class = "tablecell align-left"><?php echo $key?></th>
			<?php endforeach;?>
		</tr>
	<thead>
	<tbody>
		<?php
		foreach($data as $user):
		$refunds='';
		$payments='';
		?>
		<tr class="userrow">
			<td class = "tablecell align-left">
				<?php echo $user["order date"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["production completion date"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["delivery date"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["ex-works date"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["order number"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["surname"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["company"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["showroom"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["currency"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo number_format((double)$user["discount"],2,'.','');?>
			</td>
			<td class = "tablecell align-left">
            	<?php echo $user["discountPercent"];?>
            </td>
            <td class = "tablecell align-left">
                <?php echo $user["vat"];?>
            </td>
            <td class = "tablecell align-left">
                <?php echo $user["vatrate"];?>
            </td>
            <td class = "tablecell align-left">
                <?php echo $user["total"];?>
            </td>
            <td class = "tablecell align-left">
                <?php echo $user["total After Discount"];?>
            </td>
            <td class = "tablecell align-left">
                <?php echo $user["total inc VAT"];?>
            </td>
            <td class = "tablecell align-left">
                <?php echo $user["balance outstanding"];?>
            </td>
             <td class = "tablecell align-left">
                <?php echo isset($user["payments"]) ? str_replace(",","<br>",$user["payments"]) : '';?>
            </td>
            <td class = "tablecell align-left">
                <?php echo isset($user["refunds"]) ? str_replace(",","<br>",$user["refunds"]) : '';?>
            </td>
			<td class = "tablecell align-left">
				<?php echo $user["no1 mattress"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["no2 mattress"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["no3 mattress"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["no4 mattress"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["other mattress"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["no1 base"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["no2 base"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["no3 base"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["no4 base"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["savoir slim base"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["other base"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["hw topper"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["hca topper"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["cw topper"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["cw topper"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["headboard"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["accessories"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["delivery"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["completed order"];?>
			</td>
			<td class = "tablecell align-left">
				<?php echo $user["closed date/user"];?>
			</td>
		</tr>
		<?php 
		endforeach;
		?>
	</tbody>
</table>
<?php } else {
 echo "<h1 align='left' style='color:red; margin-top:30px;'>No results to show</h1>";
} ?>
