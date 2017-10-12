<?php
    include "DataBase.php";
    include "include/constants.php";

    $con = new DataBase();
    session_start();
    $_SESSION['name'] = $_GET['name'];
    //var_dump($_SESSION['name']);

    $table = $_GET['name'];
    $nameColumn = $con->show($table);
    $query = "SELECT * FROM " . $table;
    $result = $con->select($query); // значения таблицы

    echo "<table tabindex=\"0\" name=" . $table . "><tr>";
    $i = 0;
    $array = array();
    foreach($nameColumn as $key=>$value){
        echo "<th>" . $value['Field'] . "</th>";
        $array[$i] = $value['Field']; //названия полей
        $i++;
    }
    echo "</tr>";
   foreach($result as $key=>$value){
       echo "<tr tabindex=\"0\">";
       $i = 1;
       $countValue = count($array);
       foreach($array as $s){
           if($table == 'agreement') {
               switch ($s) {
                   case 'id_employee':
                       $query = "SELECT employee.surname FROM employee, agreement
                              WHERE agreement.id_employee = employee.id_employee AND agreement.id_employee = $value[$s]";
                       $result = $con->select($query);
                       echo "<td tabindex=\"0\">" . $result[0]['surname'] . "</td>";
                       break;
                   case 'id_service':   $query = "SELECT service.name_service FROM service, agreement
                              WHERE agreement.id_service = service.id_service AND agreement.id_service = $value[$s]";
                       $result = $con->select($query);
                       echo "<td tabindex=\"0\">" . $result[0]['name_service'] . "</td>";
                       break;
                   case 'id_material':  $query = "SELECT material.name_material FROM material, agreement
                              WHERE agreement.id_material = material.id_material AND agreement.id_material = $value[$s]";
                       $result = $con->select($query);
                       echo "<td tabindex=\"0\">" . $result[0]['name_material'] . "</td>";
                       break;
                   case 'id_tool':  $query = "SELECT tool.name_tool FROM tool, agreement
                              WHERE tool.id_tool = agreement.id_tool AND agreement.id_tool = $value[$s]";
                       $result = $con->select($query);
                       echo "<td tabindex=\"0\">" . $result[0]['name_tool'] . "</td>";
                      /* echo '<td id="note"><button type="button" class="btn btn-warning"
                data-toggle="modal" data-target="#myModalDel">Удалить</button></td>';*/
                       break;
                   default: echo "<td tabindex=\"0\">" . $value["$s"] . "</td>";
               }
           }
           else {
               echo "<td tabindex=\"0\">" . $value["$s"] . "</td>";
           }
           if($i == $countValue) {
               echo '<td id="note"><button type="button" class="btn btn-warning"
                data-toggle="modal" data-target="#myModalDel">Удалить</button></td>';
           }
           $i++;
       }
       echo "</tr>";
   }
    echo "</table>";
?>