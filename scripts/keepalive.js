    function keepSessionAlive() {
        $.post("ping.asp");
    }

    $(document).ready(doKeepSessionAlive());
    
    function doKeepSessionAlive() {
    	window.setInterval("keepSessionAlive()", 60000);
    }
