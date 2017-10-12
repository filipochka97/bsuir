<?php

    include 'DataBase.php';
    include 'include/constants.php';

    $con = new DataBase();

    $table = $_GET['table'];
    $field = $_GET['field'];

    $result = $con->deleteField($table, $field);
    echo $result;