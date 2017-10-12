

<?php
//include "DataBase.php";


$con = mysqli_connect('localhost','root','rootroot','mydb');
if (!$con) {
    die('Could not connect: ' . mysqli_error($con));
}
$table = $_GET['name'];
mysqli_select_db($con,"mydb");
$query="SHOW COLUMNS FROM " . $table;
$nameColumn = mysqli_query($con, $query);
$sql="SELECT * FROM " . $table;
$result = mysqli_query($con,$sql);

/*echo "<table>
<tr>
<th>Firstname</th>
<th>Lastname</th>
<th>Age</th>
<th>Hometown</th>
<th>Job</th>
</tr>";*/
echo "<table><tr>";
$i = 0;
$array = array();
while($row1 = mysqli_fetch_array($nameColumn)){
    echo "<th>" . $row1['Field'] . "</th>";
    $array[$i] = $row1['Field'];
    $i++;
}
echo "</tr>";
while($row = mysqli_fetch_array($result)) {
    echo "<tr>";
    /*while($row1 = mysqli_fetch_array($nameColumn)) {
        echo "<td>" . $row["$row1['Field']"] . "</td>";
    }*/
    foreach($array as $s){
        echo "<td>" . $row["$s"] . "</td>";
    }
    echo "</tr>";
}
echo "</table>";
mysqli_close($con);

?>
</body>
</html>