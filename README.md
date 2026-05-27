# Project Setup Video Link (Updated)

Click [here](https://youtu.be/KFLG79ANp3o) to learn how to set up the project.

## Database Schema Quick Guide

- Read this along with the logical ERD provided in the resources for best experience.
  - A **Product** represents a product type. For example, a product might be Nike shoes or Mars chocolate. Each product type has a unique SKU.
  - A **Category** is a broader classification of products. For example, both Nike shoes and Puma shoes belong to Shoes category.
  - A **Warehouse** is a physical location to store items.
  - A warehouse might have a box of 50 books, a box of 30 utensils, and a box of 20 electronic devices. Another warehouse might have a box of 70 biscuits, a box of 30 books, and a box of 50 utensils. Each box represents an **Inventory**.
  - **Transaction** is a supertype that represents any event that affects quantity change. **Order**, **GoodsReceipt**, and **Adjustment** are all the subtypes of transaction.
  - **Movement** records each inventory change. When an **Order** is placed, it can affect multiple inventory; thus, each order can produce multiple records of movement. Similar logic goes to **GoodsReceipt** and **Adjustment**.
  - When an order is placed, it can contain many **Order_Item**. The unit price field is necessary to record the current price of each item purchased. Theoretically, the quantity can be traced back from the movement records, but redundancy is introduced for easier access and simpler logic (find _Table Denormalisation_ to learn more). Similar logic goes to **GoodsReceipt**.

## Additional Info

- **Movement**, **Inventory**, **Order_Item**, **Receipt_Item** are known as _Junction Tables_, in which each record is uniquely identified by a composite primary key. Sometimes, a _surrogate key_ might be introduced for easier foreign key reference, which is utilised by the **Inventory**. Search these terms to find out more.
