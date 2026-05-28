<?php

class OrderGateway
{
    private PDO $conn;

    public function __construct(Database $database)
    {
        $this->conn = $database->getConnection();
    }

    public function getRecentOrders(): array{
        try {

            $sql= "SELECT * FROM orders
                   WHERE order_date >= NOW() - INTERVAL 7 DAY ORDER BY order_date DESC;
            $stmt = $this->conn->query($sql);
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
            }
            
            publi function cancelOrder(int $orderId): bool{
              try {
                    $this->conn->beginTransaction();
                    $itemsSql = "SELECT product_id, quantity FROM order_items WHERE order_id = :order_id";
                    $itemsStmt = $this->conn->prepare($itemsSql);
                    $itemsStmt->bindValue(":order_id", $orderId, PDO::PARAM_INT);
                    $itemsStmt->execute();
                    $items = $itemsStmt->fetchAll(PDO::FETCH_ASSOC);

                    if(empty($items)){
                    $this->conn->rollBack();
                    return false;
                    }

                    $txtSql= "INSERT INTO transactions (ttransaction_id) VALUES (NULL)";
                    $this->conn->query($txtSql);
                    $transactionId = (int)$this->conn->lastInsertId();

                    foreach($items as $item){
                        $invSql= "SELECT inventory_id FROM inventory WHERE product_id = :product_id LIMIT 1";
                        $invStmt = $this->conn->prepare($invSql);
                        $invStmt->bindValue(":product_id", $item["product_id"], PDO::PARAM_INT);
                        $invStmt->execute();
                        $inventory = $invStmt->fetch(PDO::FETCH_ASSOC);

                        if($inventory){
                            $inventoryId= $inventory["inventory_id"];

                            $updateStock = "UPDATE inventory 
                                    SET quantity = quantity + :quantity 
                                    WHERE inventory_id = :inventory_id";
                            $stockStmt = $this->conn->prepare($updateStock);
                            $stockStmt->bindValue(":quantity", $item["quantity"], PDO::PARAM_INT);
                            $stockStmt->bindValue(":inventory_id", $inventoryId, PDO::PARAM_INT);
                            $stockStmt->execute();

                            $movementSql = "INSERT INTO movements (inventory_id, transaction_id, transaction_type, quantity_delta, movement_date) 
                                    VALUES (:inventory_id, :transaction_id, 'ADJUSTMENT', :quantity_delta, NOW())";
                            $movementStmt = $this->conn->prepare($movementSql);
                            $movementStmt->bindValue(":inventory_id", $inventoryId, PDO::PARAM_INT);
                            $movementStmt->bindValue(":transaction_id", $transactionId, PDO::PARAM_INT);
                            $movementStmt->bindValue(":quantity_delta", $item["quantity"], PDO::PARAM_INT); 
                            $movementStmt->execute();

                    }
                }
                $updateOrderSql = "UPDATE orders SET status = 'CANCELLED' WHERE order_id = :order_id";
                $orderStmt = $this->conn->prepare($updateOrderSql);
                $orderStmt->bindValue(":order_id", $orderId, PDO::PARAM_INT);
                $orderStmt->execute();

                $this->conn->commit();
                return true;

            } catch (Exception $e) {
            $this->conn->rollBack();
            throw $e;
        }
    }
}