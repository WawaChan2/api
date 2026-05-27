<?php

class ProductGateway
{
  private PDO $connection;

  public function __construct(Database $database)
  {
    $this->connection = $database->getConnection();
  }

  public function getAll()
  {
    $sql = "SELECT products.*, categories.category_name 
    FROM 
    products 
    INNER JOIN 
    categories 
    ON products.category_id = categories.category_id";

    $stmt = $this->connection->prepare($sql);
    $stmt->execute();

    return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }
}
