<table id="example" class="display nowrap" style="width:100%">
    <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
        </tr>
    </thead>
</table>

<script>
$(document).ready(function() {
    $('#example').DataTable({
        "ajax": {
            "url": "/php/test/page",
            "dataSrc": "data" // The property containing the data in the returned JSON
        },
        "serverSide": true,
        "scrollY": 400,
        "paging": true
    });
});
</script>