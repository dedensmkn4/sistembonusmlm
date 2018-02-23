<?php 
	
	include('koneksi.php');
		if ($_POST['id_upline'] !=="combo") {
			if ($_POST['id_upline']=="ID") {
				echo "kosong";
			}
			else {
				$query = "select (CASE WHEN id_kiri IS NULL THEN 'kiri' ELSE 'kanan' END) as posisi from jaringan where id_member='".$_POST['id_upline']."'";
				$results = mysql_query($query);
				$res = mysql_fetch_assoc($results);
				echo $res['posisi'];
			}
		}
		else{
			$query = "select * from jaringan where id_kiri is null or id_kanan is null";
			$results = mysql_query($query); 
			echo '<option value="ID">ID</option>';
	        while ($rows = mysql_fetch_assoc($results)) {
	            echo '<option value="'.$rows['id_member'].'">'.$rows['id_member'].'</option>;';
	        }
		}

 ?>