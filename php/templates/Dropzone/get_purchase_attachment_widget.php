
    <?php foreach ($data as $row) { ?>
        <div style="float:left; margin-right:10px; margin-bottom:20px; padding-right:10px">
        <a href='<?=$row["url"]?>' target='_blank'><img src='<?=$row["thumbUrl"]?>' alt='<?=$row["filename"]?>' title='<?=$row["filename"]?>' height='50'/><br /><?=$row["upload_date"]?><br /><?=$row["username"]?><br /><?=substr($row["filename"], 0, 20)?></a>
        <?php if ($allowDelete) { ?>
            <div><a href='#' onclick='deleteAttachment_<?=$theType?>("<?=$row["purchase_attachment_id"]?>", "<?=$row["id"]?>")' >Delete</a><br /><br /><hr /></div>
        <?php } ?>
        
        </div>
    <?php } ?>

    <div class="clear"></div>
