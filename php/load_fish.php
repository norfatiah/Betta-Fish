<?php
error_reporting(0);
include_once("dbconnect.php");
$sql = "SELECT * FROM FISH";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $response["fish"] = array();
    while ($row = $result ->fetch_assoc()){
        $fishlist = array();
        $fishlist[fishid] = $row["ID"];
        $fishlist[fishname] = $row["FISHNAME"];
        $fishlist[fishprice] = $row["FISHPRICE"];
        $fishlist[fishqty] = $row["QUANTITY"];
        $fishlist[fishimage] = $row["IMAGE"];
        $fishlist[rating] = $row["RATING"];
        array_push($response["fish"], $fishlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>