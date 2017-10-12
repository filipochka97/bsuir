<?php

    include "DataBase.php";
    include "include/constants.php";

    $con = new DataBase();

    $table = $_GET['table'];
    $nameColumn = $con->show($table);

    $i = 0;
    $keyField = $con->key($table);
    foreach($nameColumn as $key=>$value){
        $field = $value['Field'];
        if($keyField[0]['column_name'] == $value['Field']){
            echo '<option id="key">' . $value['Field'] . '</option>';
        }
        else{
            echo "<option>" . $value['Field'] . "</option>";
        }
        //echo "<option>" . $value['Field'] . "</option>";
        //echo $con->key($table);
        $array[$i] = $value['Field'];
        $i++;
    }

?>