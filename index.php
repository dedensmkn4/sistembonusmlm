<!DOCTYPE html>
<html>
<head>
	<title>DEDEN | REMOTE PARTHNER</title>
</head>
<body>
<form class='form-search' method=POST action='aksi_inputdata.php' >
          <table class='table table-bordered'>
          <tr><td>ID Upline</td><td>:
          <select class="_f_id_upline" name="id_upline">
          </select>	
			</td>
		  </tr>
		  <tr><td>Posisi</td><td>:<input class='span6 _f_posisi' value="kosong"  type=text name="posisi" disabled></td></tr>
          <tr><td>ID Member Baru</td><td>:<input class='span6'   type=text name="id_member" required></td></tr>
          <tr><td colspan=2><input class='btn btn-success' type=submit value=Proses>
                            <input class='btn btn-danger' type=button value=Batal onclick=self.history.back()></td></tr>
          </table></form>

<script src="jquery.min.js" type="text/javascript"></script>
<script type="text/javascript">// <![CDATA[
    $(document).ready(function() {
    	var id_up = $("._f_id_upline").val();
    	if (id_up == null) {
    		loadComboupline();
    	}

    	function loadComboupline(){
    		$.ajax({
                type: "POST",
                url: "getidupline.php",
                data: "id_upline=combo",
                cache: false,
                success: function(html) {
                	console.log(html);
                    $("._f_id_upline").html(html);
                } 
            });
    	}

        $("._f_id_upline").change(function() {
            var id_upline =$(this).val();
            var dataSend = 'id_upline='+id_upline;
            $.ajax({
                type: "POST",
                url: "getidupline.php",
                data: dataSend,
                cache: false,
                success: function(html) {
                	console.log(html);
                    $("._f_posisi").val(html);
                } 
            });
        });
    });
 </script>  

</body>
</html>

