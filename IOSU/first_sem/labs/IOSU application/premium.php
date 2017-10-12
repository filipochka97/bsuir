<?php 

include 'include/constants.php'; 
include 'DataBase.php'; 

$con = new DataBase(); 

$surname = $_GET['surname']; 

$query = "SELECT id_employee FROM employee WHERE surname='" . $surname . "'"; 
$result = $con->select($query); 
if($result){ 
$query = "SELECT COUNT(agreement.id_employee) AS 'number' 
FROM agreement, employee 
WHERE employee.surname='" . $surname . 
"' AND agreement.id_employee = employee.id_employee AND YEAR(NOW())=YEAR(date_order) AND MONTH(NOW())=MONTH(date_order)"; 
$result = $con->select($query); 
if($result[0]['number'] >= 2){ 
echo "Премия начислена!"; 
} 
else { 
echo "Отработано недостаточное количество часов!"; 
} 
} 
else { 
echo "Такого работника не существует!"; 
}
