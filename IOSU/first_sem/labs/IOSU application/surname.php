<?php 

include 'include/constants.php'; 
include 'DataBase.php'; 

$con = new DataBase(); 

$query = "SELECT surname FROM employee"; 
$result = $con->select($query); 

foreach($result as $value){ 
echo '<option>' . $value['surname'] . '</option>'; 
}
