<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$id = $_POST['id'];
$quantity = $_POST['fishqty'];


$sqlsearch = "SELECT * FROM CART WHERE EMAIL = '$email' AND ID= '$id'";

$result = $conn->query($sqlsearch);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        $quantity = $row["FISHQTY"];
    }
    $quantity = $quantity;
    $sqlinsert = "UPDATE CART SET FISHQTY = '$quantity' WHERE ID = '$id' AND EMAIL = '$email'";
    
}else{
    $sqlinsert = "INSERT INTO CART(EMAIL,ID,FISHQTY) VALUES ('$email','$id',$quantity)";
}

if ($conn->query($sqlinsert) === true)
{
    $sqlquantity = "SELECT * FROM CART WHERE EMAIL = '$email'";

    $resultq = $conn->query($sqlquantity);
    if ($resultq->num_rows > 0) {
        $quantity = 0;
        while ($row = $resultq ->fetch_assoc()){
            $quantity = $row["FISHQTY"] + $quantity;
        }
    }

    $quantity = $quantity;
    echo "success,".$quantity;
}
else
{
    echo "failed";
}

?>