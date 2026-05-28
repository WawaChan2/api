<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, PATCH, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

header('Content-Type: application/json; charset=UTF-8');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
  http_response_code(204);
  exit;
}

spl_autoload_register(function ($class) {
  $folders = [
    'controllers',
    'gateways',
    'database'
  ];

  foreach ($folders as $folder) {
    $path = __DIR__ . "/$folder/$class.php";

    if (file_exists($path)) {
      require $path;
      return;
    }
  }
});

$request = $_SERVER['REQUEST_URI'];
$path = parse_url($request, PHP_URL_PATH);
$parts = array_values(array_filter(explode('/', $path)));

$database = new Database("localhost", "inventory_db", "root", "farah");

switch ($parts[0]) {
  case 'products':
    $productGateway = new ProductGateway($database);
    $productController = new ProductController($productGateway);
    $productController->processRequest($_SERVER['REQUEST_METHOD'], $parts[1] ?? null);
    break;

  case 'orders':
    $orderGateway = new OrderGateway($database);
    $orderController = new OrderController($orderGateway);
    $orderController->processRequest($_SERVER['REQUEST_METHOD'], $parts[1] ?? null);
    break;

  case 'profile':
    break;

  case 'admin':
    break;

  default:
    http_response_code(404);
    echo json_encode(["error" => "Not Found"]);
    break;
}
