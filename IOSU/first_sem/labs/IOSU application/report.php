<?php

    include 'DataBase.php';
    include 'include/constants.php';

    $con = new DataBase();

    $summ = 0; $result = 0;
    $function = $_GET['value'];
    if(isset($_GET['summ'])){
        $summ = $_GET['summ'];
    }

    if($function == 0){
        $result = $con->constClient();
    }
    if($function == 1){
        $result = $con->profit();
    }
    if($function == 2){
        $result = $con->serviceSumm($summ);
    }
    if($function == 3){
        $result = $con->dynamic();
    }
    if($function == 4){
        $result = $con->commonList();
    }
    if($result){
    $nameColumn = array_keys($result[0]);
    echo "<table><tr>";
    $i = 0;
    $array = array();
    foreach($nameColumn as $value){
        echo "<th>" . $value . "</th>";
        $array[$i] = $value; //названия полей
        $i++;
    }
    echo "</tr>";
    foreach($result as $key=>$value){
        echo "<tr>";
        $countValue = count($array);
        foreach($array as $s){
                echo "<td>" . $value["$s"] . "</td>";
        }
        //var_dump($resu);
        echo "</tr>";
    }
    echo "</table>";
}
