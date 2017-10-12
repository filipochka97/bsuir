<?php

    include 'DataBase.php';
    include 'include/constants.php';

    $con = new DataBase();

    session_start();
    $table = $_SESSION['name'];
    $id = $_GET['id'];
    $field = $_GET['field'];
    $value = $_GET['value'];

    $result = $con->update($table, $id, $field, $value);
    echo $result;
