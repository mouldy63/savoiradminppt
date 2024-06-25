<h1>QC Test </h1>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#cmd1").click(function(){
            jQuery.ajax({
                type: "POST",
                url: "/php/fabricstatus/qctest",
                data: JSON.stringify({cmd: "cmd1"}),
                dataType: "json",
                success: function (data) {
                	var receiveddata = JSON.parse(data);
                	jQuery('#info').append(receiveddata['info']);
                }
            });
    });
	jQuery("#cmd2").click(function(){
            jQuery.ajax({
                type: "POST",
                url: "/php/fabricstatus/qctest",
                data: JSON.stringify({cmd: "cmd2"}),
                dataType: "json",
                success: function (data) {
                	var receiveddata = data;
                	jQuery('#info').append(receiveddata['info']);
                },
                error: function (errormessage) {
                   console.log(errormessage);
                }
        });
    });

});


</script>
<button id="cmd1">Button 1</button>
<button id="cmd2">Button 2</button>
<div id="info">
</div>
<div>
</div>
<div>
<style>
th,td{
	text-align:center;
}
table tr td{
	text-align:center;
}
.onecell{
	max-width:200px;
	min-width:200px;
}
.threecell{
	max-width:600px;
	min-width:600px;
}
.nobottomcell{
	border-bottom:none;
}
.leftcell{
	border-left: 1px solid black;
}
.innerTable{
	margin-bottom:0;
}
.innerTable tr:nth-child(even){
	background:none !important;
}
</style>
<h3>Table Test</h3>
<table style="border:1px solid black;border-collapse: collapse;">
<thead>
<tr>
	<th class="onecell nobottomcell">
	
	</th>
	<th class="threecell nobottomcell leftcell">
	No.2
	</th>
	<th class="onecell nobottomcell leftcell">
	
	</th>
</tr>
<tr>
	<th class="onecell">
		No.1
	</th>
	<th class="threecell leftcell">
		<table class="innerTable">
			<tr>
				<th class="onecell nobottomcell">
					three 1
				</th>
				<th class="onecell  nobottomcell">
					three 2
				</th>
				<th class="onecell  nobottomcell">
					three 3
				</th>
			</tr>
		</table>
	</th>
	<th class="onecell leftcell">
		No.3
	</th>
</tr>
</thead>
<tbody>
<tr>
	<td class="onecell">
		This is Column 1
	</td>
	<td class="threecell leftcell">
		<table class="innerTable">
		<tbody>
			<tr>
				<td class="onecell nobottomcell">
					subcolumn 1
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 2
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 3
				</td>
			</tr>
			<tr>
				<td class="onecell nobottomcell">
					subcolumn 1
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 2
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 3
				</td>
			</tr>
			<tr>
				<td class="onecell nobottomcell">
					subcolumn 1
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 2
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 3
				</td>
			</tr>
			<tr>
				<td class="onecell nobottomcell">
					subcolumn 1
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 2
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 3
				</td>
			</tr>
		</tbody>
		</table>
	</td>
	<td class="onecell leftcell">
		This is Column 3
	</td>
</tr>
<tr>
	<td class="onecell">
		This is Column 1
	</td>
	<td class="threecell leftcell">
		<table class="innerTable">
		<tbody>
			<tr>
				<td class="onecell nobottomcell">
					subcolumn 1
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 2
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 3
				</td>
			</tr>
			<tr>
				<td class="onecell nobottomcell">
					subcolumn 1
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 2
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 3
				</td>
			</tr>
			<tr>
				<td class="onecell nobottomcell">
					subcolumn 1
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 2
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 3
				</td>
			</tr>
			<tr>
				<td class="onecell nobottomcell">
					subcolumn 1
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 2
				</td>
				<td class="onecell  nobottomcell">
					subcolumn 3
				</td>
			</tr>
		</tbody>
		</table>
	</td>
	<td class="onecell leftcell">
		This is Column 3
	</td>
</tr>
</tbody>
</table>
</div>