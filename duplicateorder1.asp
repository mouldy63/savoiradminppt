<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="utilfuncs2.asp" -->
<!-- #include file="customerfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->

<%Dim pn
pn=request("pn")
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="css/jquery-confirm.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="scripts/keepalive.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.2.3/jquery-confirm.min.css">
<script src="scripts/jquery-confirm.min.js"></script>



<style type="text/css">
.overdue {
	background-color:rgba(255,0,0,0.1);}
  .arrow {
    width: 70px;
    height: 16px;
    overflow: hidden;
    position: absolute;
    left: 50%;
    margin-left: -35px;
    bottom: -16px;
  }
  .arrow.top {
    top: -16px;
    bottom: auto;
  }
  .arrow.left {
    left: 20%;
  }
  .arrow:after {
    content: "";
    position: absolute;
    left: 20px;
    top: -20px;
    width: 25px;
    height: 25px;
    box-shadow: 6px 5px 9px -9px black;
    -webkit-transform: rotate(45deg);
    -ms-transform: rotate(45deg);
    transform: rotate(45deg);
  }
  .arrow.top:after {
    bottom: -20px;
    top: auto;
  }
  .jconfirm.jconfirm-white .jconfirm-box, .jconfirm.jconfirm-light .jconfirm-box {
	  font-family:"Trebuchet MS",Arial,Verdana,San serif !important;
	  margin-right:40% !important;
	  }
.jconfirm.jconfirm-white .jconfirm-box .jconfirm-buttons button.btn-default, .jconfirm.jconfirm-light .jconfirm-box .jconfirm-buttons button.btn-default {
	font-size:14px !important;}
.jconfirm.jconfirm-white .jconfirm-box .jconfirm-buttons, .jconfirm.jconfirm-light .jconfirm-box .jconfirm-buttons {
	float:none !important;
	text-align:center !important;
	font-size:12px !important;
	font-style:normal !important;}
.jconfirm .jconfirm-box .jconfirm-buttons button {
	font-size:12px !important;}
.jconfirm .jconfirm-box div.jconfirm-title-c {font-size:14px !important;}
.container {
    border: 0px solid #ebebeb !important;
    margin: 2em auto;
    padding: 0 0 3em;
    width: 1020px;
}
  </style>
  <link rel="stylesheet" href="font-awesome-4.7.0/css/font-awesome.min.css">
</head>
<body onLoad="return orderQuoteChangeHandler2();">


</body>
</html>

       <script Language="JavaScript" type="text/javascript">
<!--

	$(document).ready();

function orderQuoteChangeHandler2() { //1
var value = $("#orderquote").val();
	//console.log("value = " + value);
	if (value == 0) {
		alert("Please select an option");
		$("#orderquote").focus();
		return;
	}
jconfirm.defaults = {
    title: 'Hello',
    titleClass: '',
    type: 'default',
    draggable: true,
    alignMiddle: true,
    typeAnimated: true,
    content: '',
    buttons: {},
    defaultButtons: {
        ok: {
            action: function () {
            }
        },
        close: {
            action: function () {
            }
        },
    },
    contentLoaded: function(data, status, xhr){
    },
    icon: '',
    lazyOpen: false,
    bgOpacity: null,
    theme: 'light',
    animation: 'zoom',
    closeAnimation: 'scale',
    animationSpeed: 400,
    animationBounce: 1.2,
    rtl: false,
    container: 'body',
    containerFluid: false,
    backgroundDismiss: false,
    backgroundDismissAnimation: 'shake',
    autoClose: false,
    closeIcon: null,
    closeIconClass: false,
    watchInterval: 100,
    columnClass: 'col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1',
    boxWidth: '50%',
    scrollToPreviousElement: true,
    scrollToPreviousElementAnimate: true,
    useBootstrap: true,
    offsetTop: 50,
    offsetBottom: 50,
    dragWindowGap: 15,
    bootstrapClasses: {
        container: 'container',
        containerFluid: 'container-fluid',
        row: 'row',
    },
    onContentReady: function () {},
    onOpenBefore: function () {},
    onOpen: function () {},
    onClose: function () {},
    onDestroy: function () {},
    onAction: function () {}
};
$.confirm({//2
		title: 'Any changes you made to the customer details will be saved first. Please confirm.',
		buttons: {//3
			Cancel: function () {
				$.alert('Order Cancelled');
			},
			Proceed: {
				action: function () {
						$.confirm({
							title: 'Please choose order type:',
							content: '<span> <br></span>',
							buttons: {
								confirm: {
									text: 'Customer Order',
									btnClass: 'btn-orange',
									action: function () {
										$.confirm({
										title: 'Please let us know what type of customer:',
										content: '<span> <br></span>',
										buttons: {
											confirm: {
											text: 'Retail',
											btnClass: 'btn-orange',
											action: function () {
												window.location.href = 'duplicateorder.asp?pn=<%=pn%>&ordersource=Client Retail';
												$("#form1").submit();
												}
											},
											confirm2: {
											text: 'Trade',
											btnClass: 'btn-orange',
											action: function () {
												window.location.href = 'duplicateorder.asp?pn=<%=pn%>&ordersource=Client Trade';
												$("#form1").submit();
												}
											},
											confirm3: {
											text: 'Contract',
											btnClass: 'btn-orange',
											action: function () {
												window.location.href = 'duplicateorder.asp?pn=<%=pn%>&ordersource=Client Contract';
												$("#form1").submit();
												}
											}
										},
										});
									}
								},
								confirm2: {
									text: 'Floorstock Order',
									btnClass: 'btn-orange',
									action: function () {
										window.location.href = 'duplicateorder.asp?pn=<%=pn%>&ordersource=Floorstock';
									}
								},
								confirm3: {
									text: 'Stock Order',
									btnClass: 'btn-orange',
									action: function () {
										window.location.href = 'duplicateorder.asp?pn=<%=pn%>&ordersource=Stock';
									}
								},
								confirm4: {
									text: 'Marketing Order',
									btnClass: 'btn-orange',
									action: function () {
										window.location.href = 'duplicateorder.asp?pn=<%=pn%>&ordersource=Marketing';
									}
								},
								confirm5: {
									text: 'Test Order',
									btnClass: 'btn-orange',
									action: function () {
										window.location.href = 'duplicateorder.asp?pn=<%=pn%>&ordersource=Test';
									}
								},
								
								someButton: {
                                    text: 'HELP',
                                    btnClass: 'btn-green',
                                    action: function () {
                                        this.$content.find('span').append('<br><b>Customer Order:</b><br>Select this option if you want to place an order for your customer.<br><br><b>Floorstock Order:</b><br>Select this option if you are placing an order which is a floorstock bed for your showroom display.<br><br><b>Stock Order:</b><br>Select this option if you are placing an order for delivery or storage to your warehouse.<br><br><b>Marketing Order:</b><br>Select this option if you are placing an order for Marketing purposes.<br><br>');
                                        return false; // prevent dialog from closing.
                                    }
                                },
								cancel: function () {
									$.alert('Order Cancelled');
									window.location.href = 'edit-purchase.asp?order=<%=pn%>';
									return false;
								},
							},
							
							
							
							
						});
					}
        	}
		}
	});
}


//-->
</script>

<!-- #include file="common/logger-out.inc" -->
