<?php use Cake\Routing\Router; ?>
<div class="container" style="padding-left:20px;">
<form name="legsform" id="legsform" method="post" action="/php/Order/imagedropzone">
<input type="hidden" name="pn" id="pn" value="<?=$purchase['PURCHASE_No'] ?>" />
    <div class="row">
        <hr class="h-divider">
    </div> 
    <div class="row">
     <p><strong>Click or Drag to upload files for this order<br><br>

     Files Required for Production:</strong></p>
</div>
<div class="row">
     <div  class="col-md-2" id="mydz_<?=$dzType?>" class="dz-class"></div>
    <div  class="col-md-2" id="attachment_widget_<?=$dzType?>"></div>
</div>

    </div> 
</form>

</div>
<script>
    function imagedropzoneInit() {
    
        overrideImagedropzoneSubmit();

        $(".imagedropzonefield").on("change", function() {
            imagedropzoneFieldChanged = true;
        });
        $(".imagedropzonefield").on("focus", function() {
            submitComponentForm(99);
        });
    }

    var myDropzone<?=$dzType?> = new Dropzone(
        "div#mydz_<?=$dzType?>",
        {
                url : "php/services/dropzoneUpload/<?=$dzPurchaseNo?>/<?=$dzOrderNum?>/<?=$dzUserId?>/<?=$dzType?>",
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
		var url = "ajaxGetPurchaseAttachmentWidget.asp?pn=<?=$dzPurchaseNo?>&type=<?=$dzType?>&ts=" + (new Date()).getTime();
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
		var url = "php/services/dropzoneDelete/" + id + "/" + fileId;
		$.get(url, function(msg) {
			trace(msg);
			if (msg != null && msg != "") {
				alert(msg);
			}
			loadAttachmentWidget_<?=$dzType?>();
			stopSpinner();
		});
	}
	

    function overrideImagedropzoneSubmit() { 
        $('#imagedropzoneform').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();
            $('#loading-spinner').show();
    
            $.ajax({
                type: 'POST',
                url: '/php/Order/imagedropzone',
                data: formData,
                success: function(compsToReload) {
                    reloadComponents(compsToReload);
                },
                error: function(xhr, status, error) {
                    console.error(error);
                },
                complete: function() {
                    $('#loading-spinner').hide();
                }
            });
        });
        imagedropzoneFieldChanged = false;
    }

    showHideDiscounts($('#dcresult').val() != "");

    function submitImagedropzoneForm() {
        $('#imagedropzoneform').submit();
    }    
    
</script>
