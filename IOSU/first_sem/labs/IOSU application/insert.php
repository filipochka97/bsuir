<?php

    include 'Database.php';
include 'include/constants.php';
    //include 'getuser1.php';
    //include 'include/constants.php';
   // include 'getuser1.php';

    $con = new DataBase();
    session_start();

    $table = $_SESSION['name'];
    $nameColumn = $con->show($table);

    $array = array();
    /*foreach($nameColumn as $key=>$value){
        $key = $value["Field"];
        //$array["$key"] =
    }*/
    $array = $_POST;
    $result = $con->insert($table, $array);
    echo $result;