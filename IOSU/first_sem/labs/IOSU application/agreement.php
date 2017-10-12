<?php 

include 'include/constants.php'; 
include 'DataBase.php'; 

$con = new DataBase(); 

$field = $_GET['id']; 

if($field == 'id_employee'){ 
$query = "SELECT id_employee, surname FROM employee"; 
$result = $con->select($query); 
foreach($result as $value){ 
echo '<option id="' . $value['id_employee'] . '">' . $value['surname'] . '</option>'; 
} 
} 
if($field == 'id_service'){ 
$query = "SELECT id_service, name_service FROM service"; 
$result = $con->select($query); 
foreach($result as $value){ 
echo '<option id="' . $value['id_service'] . '">' . $value['name_service'] . '</option>'; 
} 
} 
if($field == 'id_material'){ 
$query = "SELECT id_material, name_material FROM material"; 
$result = $con->select($query); 
foreach($result as $value){ 
echo '<option id="' . $value['id_material'] . '">' . $value['name_material'] . '</option>'; 
} 
} 
if($field == 'id_tool'){ 
$query = "SELECT id_tool, name_tool FROM tool"; 
$result = $con->select($query); 
foreach($result as $value){ 
echo '<option id="' . $value['id_tool'] . '">' . $value['name_tool'] . '</option>'; 
} 
} 
if($field == 'pass_client'){ 
$query = "SELECT pass_client FROM agreement GROUP BY pass_client"; 
$result = $con->select($query); 
foreach($result as $value){ 
echo '<option>' . $value['pass_client'] . '</option>'; 
} 
}
