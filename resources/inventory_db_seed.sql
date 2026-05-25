USE inventory_db;

START TRANSACTION;

INSERT INTO users (first_name, last_name, email, phone_number) VALUES
('John', 'Tan', 'johntan@example.com', '012-1111111'),
('Sarah', 'Lim', 'sarahlim@example.com', '012-2222222'),
('Michael', 'Lee', 'michaellee@example.com', '012-3333333');

INSERT INTO suppliers (supplier_name, email, phone_number, city) VALUES
('Tech Supply Co', 'contact@techsupply.com', '03-1111111', 'Kuala Lumpur'),
('Global Traders', 'info@globaltraders.com', '03-2222222', 'Penang');

INSERT INTO warehouses (warehouse_name, location, city, capacity) VALUES
('Central Warehouse', 'Jalan Ampang 123', 'Kuala Lumpur', 10000),
('Northern Warehouse', 'Jalan Burma 456', 'Penang', 8000);

INSERT INTO categories (category_name) VALUES
('Electronics'),
('Books'),
('Furniture'),
('Clothing'),
('Food'),
('Others');

INSERT INTO transactions VALUES
(NULL),
(NULL),
(NULL),
(NULL),
(NULL),
(NULL),
(NULL),
(NULL);

INSERT INTO products 
(product_name, price, category_id, sku, description, image_url) VALUES
('Laptop Pro 15', 3500.00, 1, 'ELEC-001', 'High performance laptop', "http://api.test/uploads/laptop.jpg"),
('Wireless Mouse', 80.00, 1, 'ELEC-002', 'Ergonomic mouse', "http://api.test/uploads/wireless-mouse.webp"),

('Java Programming Book', 120.00, 2, 'BOOK-001', 'Learn Java from scratch', "http://api.test/uploads/java-textbook.jpg"),
('Algorithms Book', 150.00, 2, 'BOOK-002', 'Advanced algorithm concepts', "http://api.test/uploads/algorithms.png"),

('Office Chair', 450.00, 3, 'FURN-001', 'Comfortable ergonomic chair', "http://api.test/uploads/office-chair.webp"),
('Standing Desk', 900.00, 3, 'FURN-002', 'Height adjustable desk', "http://api.test/uploads/standing-desk.jpg"),

('T-Shirt Basic', 35.00, 4, 'CLOTH-001', 'Cotton t-shirt', "http://api.test/uploads/t-shirt.jpg"),
('Jeans Slim Fit', 120.00, 4, 'CLOTH-002', 'Modern slim jeans', "http://api.test/uploads/jeans.webp"),

('Instant Noodles', 5.00, 5, 'FOOD-001', 'Quick meal noodles', "http://api.test/uploads/instant-noodles.jpg"),
('Chocolate Bar', 8.00, 5, 'FOOD-002', 'Sweet chocolate snack', "http://api.test/uploads/chocolate-bar.jpg"),

('Oguri Plushie', 159.00, 6, 'OTHE-001', 'None other than the fatty', "http://api.test/uploads/oguri.jpg"),
('Tamamo Cross Plushie', 157.00, 6, 'OTHE-002', 'A legend but also a brokie', "http://api.test/uploads/tamamo.jpg");

INSERT INTO inventory (product_id, warehouse_id, quantity) VALUES
(1, 1, 50),
(1, 2, 30),
(2, 1, 150),
(2, 2, 170),
(3, 1, 120),
(3, 2, 100),
(4, 1, 80),
(4, 2, 70),
(5, 1, 40),
(5, 2, 30),
(6, 1, 40),
(6, 2, 30),
(7, 1, 200),
(7, 2, 170),
(8, 1, 120),
(8, 2, 130),
(9, 1, 500),
(9, 2, 450),
(10, 1, 300),
(10, 2, 230),
(11, 1, 40),
(11, 2, 60),
(12, 1, 30),
(12, 2, 70);

INSERT INTO orders (order_id, user_id, status) VALUES
(1, 1, 'PENDING'),
(2, 2, 'SHIPPED'),
(3, 3, 'DELIVERED');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 3500.00),
(1, 2, 1, 80.00),
(1, 9, 2, 5.00),

(2, 3, 1, 120.00),
(2, 11, 1, 159.00),
(2, 7, 3, 35.00),
(2, 10, 4, 8.00),

(3, 5, 1, 450.00),
(3, 6, 1, 900.00),
(3, 8, 2, 120.00);

INSERT INTO goods_receipts (receipt_id, supplier_id) VALUES
(4, 1),
(5, 2),
(6, 1);

INSERT INTO receipt_items (receipt_id, product_id, quantity, unit_cost) VALUES
(4, 1, 10, 3000.00),
(4, 2, 50, 60.00),
(4, 3, 40, 90.00),

(5, 4, 30, 110.00),
(5, 5, 20, 400.00),
(5, 7, 100, 25.00),
(5, 9, 300, 3.50),

(6, 6, 15, 850.00),
(6, 8, 60, 100.00),
(6, 10, 200, 6.00);

INSERT INTO adjustments (adjustment_id, note) VALUES
(7, 'Corrected inventory after damaged stock count for Wireless Mouse'),
(8, 'Removed expired or damaged Instant Noodles from inventory');

INSERT INTO movements (inventory_id, transaction_id, transaction_type, quantity_delta) VALUES
(2, 1, 'ORDER', -1),
(4, 1, 'ORDER', -1),
(18, 1, 'ORDER', -2),

(5, 2, 'ORDER', -1),
(21, 2, 'ORDER', -1),
(13, 2, 'ORDER', -3),
(19, 2, 'ORDER', -4),

(10, 3, 'ORDER', -1),
(12, 3, 'ORDER', -1),
(16, 3, 'ORDER', -2),

(1, 4, 'GOODS_RECEIPT', 10),
(3, 4, 'GOODS_RECEIPT', 50),
(5, 4, 'GOODS_RECEIPT', 40),

(8, 5, 'GOODS_RECEIPT', 30),
(10, 5, 'GOODS_RECEIPT', 20),
(14, 5, 'GOODS_RECEIPT', 100),
(18, 5, 'GOODS_RECEIPT', 300),

(11, 6, 'GOODS_RECEIPT', 15),
(15, 6, 'GOODS_RECEIPT', 60),
(19, 6, 'GOODS_RECEIPT', 200),

(4, 7, 'ADJUSTMENT', -5),
(17, 8, 'ADJUSTMENT', -50);

COMMIT;

-- ROLLBACK; execute this if an error happens during TRANSACTION