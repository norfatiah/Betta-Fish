<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

//$sql = "SELECT * FROM CART WHERE EMAIL = '$email'";

$sql = "SELECT CART.ID, CART.FISHQTY, FISH.FISHNAME, FISH.IMAGE, FISH.FISHPRICE, FISH.QUANTITY FROM CART 
INNER JOIN FISH ON CART.ID = FISH.ID 
WHERE CART.EMAIL = '$email'";


$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["fish"] = array();
    while ($row = $result ->fetch_assoc()){
        $fishlist = array();
        $fishlist[fishid] = $row["ID"];
        $fishlist[fishqty] = $row["FISHQTY"];
        $fishlist[fishname] = $row["FISHNAME"];
        $fishlist[fishprice] = $row["FISHPRICE"];
        $fishlist[imagename] = $row["IMAGE"];
        $fishlist[availqty] = $row["QUANTITY"];
        array_push($response["fish"], $fishlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>