-- Create Database
CREATE DATABASE UTBshopDB;
USE UTBshopDB;

-- Table for Users
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    UserName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) DEFAULT 'User', -- Possible values: 'User', 'Admin'
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Table for Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    Price DECIMAL(10,2) NOT NULL,
    ImagePath NVARCHAR(255), -- Path for product image
    Stock INT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Table for Cart
CREATE TABLE Cart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    AddedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

-- Table for Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'Pending', -- Possible values: 'Pending', 'Shipped', 'Completed'
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Table for OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Price DECIMAL(10,2) NOT NULL, -- Price of product at the time of order
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE NO ACTION
);

-- Table for Product Management Logs (Optional)
CREATE TABLE ProductLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    Action NVARCHAR(50) NOT NULL, -- Possible actions: 'Added', 'Updated', 'Deleted'
    AdminID INT NOT NULL,
    ActionDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (AdminID) REFERENCES Users(UserID)
);

-- Insert Example Users (Admin and Regular Users)
INSERT INTO Users (UserName, Email, PasswordHash, Role)
VALUES 
('Admin', 'admin@utbshop.com', 'adminpassword123', 'Admin'),
('JohnDoe', 'johndoe@gmail.com', 'hashedpassword123', 'User'),
('JaneDoe', 'janedoe@gmail.com', 'hashedpassword456', 'User'),
('AliceSmith', 'alice.smith@gmail.com', 'hashedpassword789', 'User');

-- Insert Example Products
INSERT INTO Products (ProductName, Description, Price, ImagePath, Stock)
VALUES 
('Laptop XYZ', 'A powerful laptop with 16GB RAM and 512GB SSD.', 1200.00, 'images/laptop_xyz.png', 10),
('Smartphone ABC', 'A sleek smartphone with 128GB storage.', 800.00, 'images/smartphone_abc.png', 15),
('Wireless Mouse', 'A wireless mouse with ergonomic design.', 25.00, 'images/wireless_mouse.png', 50),
('Headphones Pro', 'Noise-cancelling over-ear headphones.', 150.00, 'images/headphones_pro.png', 30);

-- Insert Example Cart Data (User JohnDoe adds products to the cart)
INSERT INTO Cart (UserID, ProductID, Quantity)
VALUES 
(2, 1, 1), -- JohnDoe adds 1 Laptop
(2, 3, 2), -- JohnDoe adds 2 Wireless Mouse
(3, 4, 1); -- JaneDoe adds 1 Headphones Pro

-- Insert Example Orders
INSERT INTO Orders (UserID, TotalAmount, Status)
VALUES 
(2, 1250.00, 'Pending'), -- JohnDoe places an order
(3, 150.00, 'Pending');  -- JaneDoe places an order

-- Insert Example OrderDetails
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price)
VALUES 
(1, 1, 1, 1200.00), -- JohnDoe's Laptop order
(1, 3, 2, 25.00),  -- JohnDoe's Wireless Mouse order
(2, 4, 1, 150.00); -- JaneDoe's Headphones order
