<?php

    include "DataBase.php";
    include "include/constants.php";

    $con = new DataBase();

    $table = $_GET['table'];
    $field = $_GET['field'];
    $type = $_GET['type'];

    $result = $con->addField($table, $field, $type);
    echo $result;