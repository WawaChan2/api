DROP SCHEMA IF EXISTS inventory_db;
CREATE SCHEMA inventory_db CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE inventory_db;

CREATE TABLE users (
  user_id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL,
  phone_number VARCHAR(20),

  PRIMARY KEY (user_id),
  UNIQUE (email)
);

CREATE TABLE suppliers (
  supplier_id INT NOT NULL AUTO_INCREMENT,
  supplier_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  phone_number VARCHAR(20),
  city VARCHAR(100),

  PRIMARY KEY (supplier_id),
  UNIQUE (email)
);

CREATE TABLE warehouses (
  warehouse_id INT NOT NULL AUTO_INCREMENT,
  warehouse_name VARCHAR(100) NOT NULL,
  location VARCHAR(255) NOT NULL,
  city VARCHAR(100) NOT NULL,
  capacity INT NOT NULL,

  PRIMARY KEY (warehouse_id),
  CHECK (capacity >= 0)
);

CREATE TABLE categories (
  category_id INT NOT NULL AUTO_INCREMENT,
  category_name VARCHAR(100) NOT NULL,

  PRIMARY KEY (category_id),
  UNIQUE (category_name)
);

CREATE TABLE transactions (
  transaction_id INT NOT NULL AUTO_INCREMENT,

  PRIMARY KEY (transaction_id)
);

CREATE TABLE products (
  product_id INT NOT NULL AUTO_INCREMENT,
  product_name VARCHAR(100) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  category_id INT NOT NULL,
  sku VARCHAR(100) NOT NULL,
  description TEXT,
  image_url VARCHAR(2083),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (product_id),
  UNIQUE (product_name, category_id),
  CHECK (price >= 0),
  FOREIGN KEY (category_id) REFERENCES categories (category_id),
  UNIQUE (sku)
);

CREATE TABLE inventory (
  inventory_id INT NOT NULL AUTO_INCREMENT,
  product_id INT NOT NULL,
  warehouse_id INT NOT NULL,
  quantity INT NOT NULL,

  PRIMARY KEY (inventory_id),
  UNIQUE (product_id, warehouse_id),
  FOREIGN KEY (product_id) REFERENCES products (product_id),
  FOREIGN KEY (warehouse_id) REFERENCES warehouses (warehouse_id),
  CHECK (quantity >= 0)
);

CREATE TABLE orders (
  order_id INT NOT NULL,
  user_id INT NOT NULL,
  status ENUM('PENDING', 'SHIPPED', 'DELIVERED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
  order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (order_id),
  FOREIGN KEY (order_id) REFERENCES transactions (transaction_id),
  FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE order_items (
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(10, 2) NOT NULL,

  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders (order_id),
  FOREIGN KEY (product_id) REFERENCES products (product_id),
  CHECK (quantity > 0),
  CHECK (unit_price >= 0)
);

CREATE TABLE goods_receipts (
  receipt_id INT NOT NULL,
  supplier_id INT NOT NULL,
  receipt_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (receipt_id),
  FOREIGN KEY (receipt_id) REFERENCES transactions (transaction_id),
  FOREIGN KEY (supplier_id) REFERENCES suppliers (supplier_id)
);

CREATE TABLE receipt_items (
  receipt_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  unit_cost DECIMAL(10, 2) NOT NULL,

  PRIMARY KEY (receipt_id, product_id),
  FOREIGN KEY (receipt_id) REFERENCES goods_receipts (receipt_id),
  FOREIGN KEY (product_id) REFERENCES products (product_id),
  CHECK (quantity > 0),
  CHECK (unit_cost >= 0)
);

CREATE TABLE adjustments (
  adjustment_id INT NOT NULL,
  note TEXT,
  adjustment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (adjustment_id),
  FOREIGN KEY (adjustment_id) REFERENCES transactions (transaction_id)
);

CREATE TABLE movements (
  inventory_id INT NOT NULL,
  transaction_id INT NOT NULL,
  transaction_type ENUM('ORDER', 'ORDER_CANCELLATION', 'GOODS_RECEIPT', 'ADJUSTMENT') NOT NULL,
  quantity_delta INT NOT NULL,
  movement_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (inventory_id, transaction_id),
  FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id),
  FOREIGN KEY (transaction_id) REFERENCES transactions (transaction_id),
  CHECK (quantity_delta != 0)
);
