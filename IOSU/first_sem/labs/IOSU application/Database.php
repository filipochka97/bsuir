<?php
class DataBase {
    protected static $pdo;

    public function __construct() {
        if (!self::$pdo) {
            self::$pdo = new PDO('mysql:host=' . DB_SERVER . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET, DB_USER, DB_PASSWORD);
            // self::$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); // закомментить строку при показе
        }
    }

    public function rowsCount($tableName) {
        $query = 'SELECT COUNT(*) FROM ' . $tableName;
        $result = self::$pdo->query($query, PDO::FETCH_NUM);
        $row = $result->fetch();
        return $row[0];
    }

    public function insert($table, array $params) {
        $strfields = implode(', ', array_keys($params));
        $values = array_values($params);
        $parameters = implode(', ', array_fill(0, count($params), '?'));
        $query = 'INSERT INTO ' . $table . ' (' . $strfields . ') VALUES (' . $parameters . ')';
        $pdostmt = self::$pdo->prepare($query);
        for ($i = 0; $i<count($values); $i++) {
            $pdostmt->bindParam($i+1, $values[$i]);
        }
        $result = $pdostmt->execute();
        if ($result) {
           // return self::$pdo->lastInsertId();
            return "Запись добавлена!";
        } else {
            //return false;
            return "Ошибка!";
        }
    }

   /* public function select($query, $username, $types) {
        //$values = array_values($params);
        $pdostmt = self::$pdo->prepare($query);
        //for ($i = 0; $i<count($values); $i++) {
        $pdostmt->bindParam(':username', $username);
        // }
        $result = $pdostmt->execute();
        if ($result) {
            return $pdostmt->fetchAll(PDO::FETCH_ASSOC);
        } else {
            return false;
        }
    }*/

    public function select($query) {
       // $values = array_values($params);
        $pdostmt = self::$pdo->prepare($query);
        //for ($i = 0; $i<count($values); $i++) {
           // $pdostmt->bindParam($i+1, $values[$i], $types[$i]);
           // $pdostmt->bindParam(':')
        //}
        $result = $pdostmt->execute();
        if ($result) {
            return $pdostmt->fetchAll(PDO::FETCH_ASSOC);
        } else {
            return false;
        }
    }

    public function constClient(){
        $query = "SELECT pass_client,COUNT(*) AS total FROM agreement GROUP BY pass_client ORDER BY total DESC LIMIT 1";
        $pdostmt = self::$pdo->prepare($query);
        $result = $pdostmt->execute();
        if ($result) {
            return $pdostmt->fetchAll(PDO::FETCH_ASSOC);
        } else {
            return false;
        }
    }

    public function profit(){
        $query = "SELECT agreement.id_service, service.name_service, COUNT(*) AS total, ((count(*)*service.cost)/2)/service.max_term AS profit
                  FROM agreement, service WHERE agreement.id_service = service.id_service GROUP BY id_service ORDER BY total DESC";
        $pdostmt = self::$pdo->prepare($query);
        $result = $pdostmt->execute();
        if($result){
            return $pdostmt->fetchAll(PDO::FETCH_ASSOC);
        }
        else{
            return false;
        }
    }

    public function serviceSumm($summ){
        $query = "SELECT name_service FROM service WHERE cost >" . $summ;
        $pdostmt = self::$pdo->prepare($query);
        $result = $pdostmt->execute();
        if($result){
            return $pdostmt->fetchAll(PDO::FETCH_ASSOC);
        }
        else{
          //  return false;
        }
    }

    public function dynamic(){
        $query = "select service.name_service, sum(case YEAR(date_order) when '2017' then 1 else 0 end) as '2017', 
                  sum(case YEAR(date_order) when '2016' then 1 else 0 end) as '2016',
                  sum(case YEAR(date_order) when '2015' then 1 else 0 end) as '2015',
                  sum(case YEAR(date_order) when '2014' then 1 else 0 end) as '2014',
                  sum(case YEAR(date_order) when '2013' then 1 else 0 end) as '2013'
                   from service, agreement
                  where agreement.id_service = service.id_service group by name_service";
        $pdostmt = self::$pdo->prepare($query);
        $result = $pdostmt->execute();
        if($result){
            return $pdostmt->fetchAll(PDO::FETCH_ASSOC);
        }
        else{
            return false;
        }
    }

    public function commonList(){
        $query = "SELECT service.name_service FROM service
                  UNION SELECT material.name_material FROM material";
        $pdostmt = self::$pdo->prepare($query);
        $result = $pdostmt->execute();
        if($result){
            return $pdostmt->fetchAll(PDO::FETCH_ASSOC);
        }
        else{
            return false;
        }
    }
    /*public function update($table, array $params){
        $query = "";
    }*/

    public function delete($table){

    }

    public function show($table){
        $query="SHOW COLUMNS FROM " . $table;
        $pdostmt = self::$pdo->prepare($query);
        $result = $pdostmt->execute();
        if($result){
            return $pdostmt->fetchAll(PDO::FETCH_ASSOC);
        } else {
            return false;
        }
    }

    public function key($table){
        //$query = "SHOW COLUMNS FROM "  . $table  . " WHERE " . $table . "." . $field . "='PRIMARY KEY'";
        $query = "SELECT k.column_name FROM information_schema.table_constraints t JOIN information_schema.key_column_usage k 
                    USING(constraint_name,table_schema,table_name) WHERE t.constraint_type='PRIMARY KEY' 
                    AND t.table_schema='" . DB_NAME . "' AND t.table_name='" . $table . "'";
        $pdostmt = self::$pdo->prepare($query);
        $result = $pdostmt->execute();
        if($result){
            //return var_dump($result) ;
            return $pdostmt->fetchAll(PDO::FETCH_ASSOC);
        }
        else{
           // return "<option>" . $result[0] . "</option>";
            //return var_dump($result[0]);
        }
    }

    public function deleteField($table, $field){
        $query = "ALTER TABLE " . $table . " DROP " . $field;
        $pdostmt = self::$pdo->prepare($query);
        $result = $pdostmt->execute();
        if($result){
            return "Поле удалено!";
        }
        else{
            return "Ошибка!";
        }
    }

    public function addField($table, $field, $type){
        //$query = "ALTER TABLE t2 ADD d TIMESTAMP";
        $query = "ALTER TABLE " . $table . " ADD " . $field . " " . $type;
        $pdostmt = self::$pdo->prepare($query);
        $result = $pdostmt->execute();
        if($result){
            return "Поле добавлено!";
        }
        else{
            return "Ошибка!";
        }
    }

    public function deleteRecord($table, $number)
    {
        //$query = "DELETE FROM pages WHERE id=$id";
        $testQuery = "SELECT COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE
                      WHERE TABLE_SCHEMA ='mydb' AND TABLE_NAME ='agreement' AND 
                      CONSTRAINT_NAME <>'PRIMARY' AND REFERENCED_TABLE_NAME is not null";
        $pdostmt = self::$pdo->prepare($testQuery);
        $result = $pdostmt->execute();
        if ($result) {
            $id_table = 'id_' . $table;
            $array = $pdostmt->fetchAll(PDO::FETCH_ASSOC);
            $i = 0;
            foreach($array as $key=>$value){
                //var_dump(in_array("$id_table", $value["COLUMN_NAME"], false));
                if ($id_table == $value["COLUMN_NAME"]){
                    $i++;
                }
            }
            if ($i) {
                $testQuery = "SELECT agreement.id_agreement FROM agreement, " . $table . " WHERE " . $table . ".id_" . $table . "=$number AND " .
                    "agreement.id_" . $table .
                    "=" . $table . ".id_" . $table;
                $pdostmt = self::$pdo->prepare($testQuery);
                $result = $pdostmt->execute();
                if($result){
                    $query = "DELETE FROM " . $table . " WHERE id_" . $table . "=$number";
                    $pdostmt = self::$pdo->prepare($query);
                    $result = $pdostmt->execute();
                    if($result){
                        return "Запись удалена!";
                    }
                    else{
                        return "Эта строка используется в других таблицах!";
                    }
                }
                else{
                    $query = "DELETE FROM " . $table . " WHERE id_" . $table . "=$number";
                    $pdostmt = self::$pdo->prepare($query);
                    $result = $pdostmt->execute();
                    if ($result) {
                        return "Запись удалена!";
                    } else {
                        return "Ошибка!";
                    }
                }
            } else {
                $query = "DELETE FROM " . $table . " WHERE id_" . $table . "=$number";
                $pdostmt = self::$pdo->prepare($query);
                $result = $pdostmt->execute();
                if ($result) {
                    return "Запись удалена!";
                } else {
                    return "Ошибка!";
                }
            }
        }
    }


    public function update($table, $id, $field, $value){
        $query = "UPDATE " . $table . " SET " . $field . "='" . $value . "' WHERE id_" . $table . "=" . $id;

        $pdostmt = self::$pdo->prepare($query);
        $result = $pdostmt->execute();
        if($result){
            return "Запись обновлена!";
        }
        else{
            return "Ошибка!";
        }
    }



}
