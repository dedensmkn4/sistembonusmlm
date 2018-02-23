<?php 
if(isset($_POST['id_upline']) && isset($_POST['id_member']))
	{
		include('koneksi.php');
		$id_member = $_POST['id_member'];
		$id_upline = $_POST['id_upline'];
		$input = mysql_query("CALL tambah_pasangan('$id_member', '$id_upline')") or die(mysql_error());
		if($input){
			echo "DATA BERHASIL DITAMBAHKAN";
			echo "<a href='index.php'>Back</a>";
		}
		else{
			echo "GAGAL MENAMBAHKAN DATA";
			echo "<a href='index.php'>Back</a>";
		}
	}
	else
	{
		echo "Isikan Semua Data";
	}

 ?>