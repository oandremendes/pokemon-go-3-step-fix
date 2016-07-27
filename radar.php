<?php
$servername = "localhost";
$username = "YOUR_USER_HERE";
$password = "YOUR_PASSWORD_HERE";
$dbname = "pogo";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 

$sql = "SELECT * FROM nearby WHERE encounterID = " . $argv[1];
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
	echo $row["latitude"].",".$row["longitude"];
    }
} else {
    echo "error,error";
}
$conn->close();
?>
