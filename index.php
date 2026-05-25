<?php

header("Access-Control-Allow-Origin: http://e-commerce.test");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

header("Content-Type: application/json");

$host = "localhost";
$username = "root";
$password = "";
$dbname = "inventory_db";

$dsn = "mysql:host=$host;dbname=$dbname;charset=utf8";

try {
  $pdo = new PDO($dsn, $username, $password);

  $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

  $sql = "SELECT * FROM products";

  $stmt = $pdo->prepare($sql);

  $stmt->execute();

  $products = $stmt->fetchAll(PDO::FETCH_ASSOC);

  echo json_encode([
    "success" => true,
    "products" => $products
  ]);
} catch (PDOException $e) {

  http_response_code(500);

  echo json_encode([
    "success" => false,
    "message" => "Database error",
    "error" => $e->getMessage()
  ]);
}
