# Project Setup Video Link (Updated)

Click [here](https://youtu.be/KFLG79ANp3o) to learn how to set up the project.

# Database Schema Quick Guide

- Read this along with the logical ERD provided in the resources for best experience.
  - A **Product** represents a product type. For example, a product might be Nike shoes or Mars chocolate. Each product type has a unique SKU.
  - A **Category** is a broader classification of products. For example, both Nike shoes and Puma shoes belong to Shoes category.
  - A **Warehouse** is a physical location to store items.
  - A warehouse might have a box of 50 books, a box of 30 utensils, and a box of 20 electronic devices. Another warehouse might have a box of 70 biscuits, a box of 30 books, and a box of 50 utensils. Each box represents an **Inventory**.
  - **Transaction** is a supertype that represents any event that affects quantity change. **Order**, **GoodsReceipt**, and **Adjustment** are all the subtypes of transaction.
  - **Movement** records each inventory change. When an **Order** is placed, it can affect multiple inventory; thus, each order can produce multiple records of movement. Similar logic goes to **GoodsReceipt** and **Adjustment**.
  - When an order is placed, it can contain many **Order_Item**. The unit price field is necessary to record the current price of each item purchased. Theoretically, the quantity can be traced back from the movement records, but redundancy is introduced for easier access and simpler logic (find _Table Denormalisation_ to learn more). Similar logic goes to **GoodsReceipt**.

# Additional Info

- **Movement**, **Inventory**, **Order_Item**, **Receipt_Item** are known as _Junction Tables_, in which each record is uniquely identified by a composite primary key. Sometimes, a _surrogate key_ might be introduced for easier foreign key reference, which is utilised by the **Inventory**. Search these terms to find out more.

# API Specification

Query parameter notation (:).

> ## Products Page:
>
> GET http://api.com/products \
> Description: Display all products \
> \
>  GET http://api.com/products/:id \
> Description: Redirect to the Product Details Page specific to a product

> ## Product Details Page:
>
> POST http://api.com/orders \
> Description: A new order is placed \
> \
> POST http://api.com/orders/:id/order_items \
> Description: Order item(s) are recorded when an order is placed \
> \
> POST http://api.com/movements \
> Description: New movement(s) are created after an order is placed \
> \
>  PATCH http://api.com/inventory/:id \
> Description: A specific inventory's info is modified. E.g., quantity is decreased

> ## Orders Page:
>
> GET http://api.com/orders \
> Description: Display all orders \
> \
> POST http://api.com/movements \
>  Description: New movement(s) are created after an order is cancelled \
>  \
> PATCH http://api.com/orders/:id \
> Description: A specific order's info is modified. E.g., user cancels the order \
> \
> PATCH http://api.com/inventory/:id \
> Description: A specific inventory's info is modified. E.g., quantity is increased

> ## Profile Page:
>
> GET http://api.com/orders \
> Description: Display all orders

> ## Admin Page:
>
> GET http://api.com/inventory \
>  Description: Display all inventory \
>  \
> GET http://api.com/movements \
>  Description: Display all movements \
>  \
> POST http://api.com/goods_receipts \
>  Description: A receipt is received \
>  \
> POST http://api.com/goods_receipts/:id/receipt_items \
> Description: Receipt item(s) are recorded when a receipt is received \
> \
> POST http://api.com/movements \
> Description: New movement(s) are created after a receipt is received \
> \
> PATCH http://api.com/inventory/:id \
> Description: A specific inventory's info is modified. E.g., admin restocks the inventory

### Note:

If I have missed anything or made a mistake, you may come up with your own API solution.
