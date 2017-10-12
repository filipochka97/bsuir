<?php

    include 'DataBase.php';
    include 'include/constants.php';

    $con = new DataBase();

    $table = $_GET['table'];
    $id = $_GET['id'];

    $result = $con->deleteRecord($table, $id);
    echo $result;