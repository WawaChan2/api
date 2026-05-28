<?php

class OrderController
{
    public function __construct(private OrderGateway $gateway) {}

    public function processRequest(string $method, ?string $id): void
    {
        header("Content-Type: application/json; charset=UTF-8");

        if ($method === "GET" && !$id) {
            $this->handleGetRecentOrders();
        } elseif ($method === "DELETE" && $id) {
            $this->handleCancelOrder((int)$id);
        } else {
            http_response_code(405);
            echo json_encode(["message" => "Method Not Allowed"]);
        }
    }

    private function handleGetRecentOrders(): void
    {
        try {
            $orders = $this->gateway->getRecentOrders();
            http_response_code(200); 
            echo json_encode($orders);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(["message" => "Internal Server Error", "error" => $e->getMessage()]);
        }
    }

    private function handleCancelOrder(int $id): void
    {
        try {
            $success = $this->gateway->cancelOrder($id);

            if ($success) {
                http_response_code(200); 
                echo json_encode(["message" => "Order cancelled successfully and inventory restored."]);
            } else {
                http_response_code(404); 
                echo json_encode(["message" => "Order not found or could not be cancelled."]);
            }
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(["message" => "Internal Server Error", "error" => $e->getMessage()]);
        }
    }
}