<div id="mydz_<?=$dzType?>" class="dz-class"></div>
<div id="attachment_widget_<?=$dzType?>"></div>
<br>
<script type="text/javascript">

    var myDropzone<?=$dzType?> = new Dropzone(
        "div#mydz_<?=$dzType?>",
        {
                url : "/php/services/dropzoneUpload/<?=$dzPurchaseNo?>/<?=$dzOrderNum?>/<?=$dzUserId?>/<?=$dzType?>",
                init: function() {
			      this.on("addedfile", function(file) {
					$('.dz-error-mark').hide();
					$('.dz-success-mark').hide();
					startSpinner('mydz_<?=$dzType?>');
			      });
			      this.on("queuecomplete", function(file) {
					$('.dz-error-mark').hide();
					$('.dz-success-mark').hide();
					loadAttachmentWidget_<?=$dzType?>();
					stopSpinner();
			      });
			    }
         });
	
	function loadAttachmentWidget_<?=$dzType?>() {
      	startSpinner('mydz_<?=$dzType?>');
		var url = "/php/dropzone/getPurchaseAttachmentWidget?pn=<?=$dzPurchaseNo?>&type=<?=$dzType?>&ts=" + (new Date()).getTime();
		$('#attachment_widget_<?=$dzType?>').load(url);
		stopSpinner();
	}
	
	$(document).ready(loadAttachmentWidget_<?=$dzType?>());

	function deleteAttachment_<?=$dzType?>(id, fileId) {
		if (!confirm("Are you sure you want to delete the attachment?")) {
			return;
		}
		trace("deleting " + id + " " + fileId);
      	startSpinner('mydz_<?=$dzType?>');
		var url = "/php/services/dropzoneDelete/" + id + "/" + fileId;
		$.get(url, function(msg) {
			trace(msg);
			if (msg != null && msg != "") {
				alert(msg);
			}
			loadAttachmentWidget_<?=$dzType?>();
			stopSpinner();
		});
	}
	
</script>