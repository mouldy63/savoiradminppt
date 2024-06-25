$(document).ready(function(){
	$('#editUsrDetail').click(function(){
		var id = $(this).attr('data-id');
		window.location='/php/useradmin/editUser?id='+id;
	});
	$('#editUsrRole').click(function(){
		var id = $(this).attr('data-id');
		window.location='/php/useradmin/editRoles?id='+id;
	});
});