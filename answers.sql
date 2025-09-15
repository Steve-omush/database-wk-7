/*
========================================
Question 1: Achieving 1NF (First Normal Form)
Task: Ensure no repeating values per cell by representing one product per row.
Approach: Define a 1NF table and insert the rows explicitly.
========================================
 */
-- Re-runnable: drop then create the normalized 1NF table
DROP TABLE IF EXISTS ProductDetail_1NF;

CREATE TABLE
  ProductDetail_1NF (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Product VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID, Product)
  );

-- Insert each product as its own row (1NF)
INSERT INTO
  ProductDetail_1NF (OrderID, CustomerName, Product)
VALUES
  (101, 'John Doe', 'Laptop'),
  (101, 'John Doe', 'Mouse'),
  (102, 'Jane Smith', 'Tablet'),
  (102, 'Jane Smith', 'Keyboard'),
  (102, 'Jane Smith', 'Mouse'),
  (103, 'Emily Clark', 'Phone');

/*
========================================
Question 2: Achieving 2NF (Second Normal Form)
Task: Remove partial dependency (CustomerName depends only on OrderID) from
OrderDetails(OrderID, CustomerName, Product, Quantity).
Approach: Seed OrderDetails with the sample data, then normalize into Orders and OrderItems.
========================================
 */
-- Seed the original (1NF but not 2NF) table
DROP TABLE IF EXISTS OrderDetails;

CREATE TABLE
  OrderDetails (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Product VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, Product)
  );

INSERT INTO
  OrderDetails (OrderID, CustomerName, Product, Quantity)
VALUES
  (101, 'John Doe', 'Laptop', 2),
  (101, 'John Doe', 'Mouse', 1),
  (102, 'Jane Smith', 'Tablet', 3),
  (102, 'Jane Smith', 'Keyboard', 1),
  (102, 'Jane Smith', 'Mouse', 2),
  (103, 'Emily Clark', 'Phone', 1);

-- Normalize to 2NF: separate order header (Orders) and order lines (OrderItems)
DROP TABLE IF EXISTS OrderItems;

DROP TABLE IF EXISTS Orders;

CREATE TABLE
  Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
  );

CREATE TABLE
  OrderItems (
    OrderID INT NOT NULL,
    Product VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders (OrderID)
  );

-- Populate Orders with unique order headers
INSERT INTO
  Orders (OrderID, CustomerName)
SELECT DISTINCT
  OrderID,
  CustomerName
FROM
  OrderDetails;

-- Populate OrderItems with order line items
INSERT INTO
  OrderItems (OrderID, Product, Quantity)
SELECT
  OrderID,
  Product,
  Quantity
FROM
  OrderDetails;