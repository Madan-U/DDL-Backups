-- DDL Export
-- Server: 192.168.31.174
-- Database: DDL_Test_Lab
-- Exported: 2026-01-28T16:24:52.019705

USE DDL_Test_Lab;
GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.OrderItems
-- --------------------------------------------------
ALTER TABLE [dbo].[OrderItems] ADD CONSTRAINT [FK_OrderItems_Orders] FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Orders] ([OrderID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.OrderItems
-- --------------------------------------------------
ALTER TABLE [dbo].[OrderItems] ADD CONSTRAINT [FK_OrderItems_Products] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products] ([ProductID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Orders
-- --------------------------------------------------
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [FK_Orders_Customers] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([CustomerID])

GO

-- --------------------------------------------------
-- FUNCTION dbo.fn_GetCustomerOrderCount
-- --------------------------------------------------

-------------------------------------------------------
-- 5. Function
-------------------------------------------------------
CREATE   FUNCTION dbo.fn_GetCustomerOrderCount
(
    @CustomerID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @cnt INT;

    SELECT @cnt = COUNT(*)
    FROM dbo.Orders
    WHERE CustomerID = @CustomerID;

    RETURN @cnt;
END;

GO

-- --------------------------------------------------
-- INDEX dbo.Customers
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Customers_Email] ON [dbo].[Customers] ([Email])

GO

-- --------------------------------------------------
-- INDEX dbo.Customers
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Customers_Email] ON [dbo].[Customers] ([Email])

GO

-- --------------------------------------------------
-- INDEX dbo.OrderItems
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_OrderItems_Order_Product] ON [dbo].[OrderItems] ([OrderID], [ProductID])

GO

-- --------------------------------------------------
-- INDEX dbo.Orders
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Orders_CustomerID] ON [dbo].[Orders] ([CustomerID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Customers
-- --------------------------------------------------
ALTER TABLE [dbo].[Customers] ADD CONSTRAINT [PK_Customers] PRIMARY KEY ([CustomerID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Customers
-- --------------------------------------------------
ALTER TABLE [dbo].[Customers] ADD CONSTRAINT [UQ_Customers_Email] UNIQUE ([Email])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.OrderAudit
-- --------------------------------------------------
ALTER TABLE [dbo].[OrderAudit] ADD CONSTRAINT [PK_OrderAudit] PRIMARY KEY ([AuditID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.OrderItems
-- --------------------------------------------------
ALTER TABLE [dbo].[OrderItems] ADD CONSTRAINT [PK_OrderItems] PRIMARY KEY ([OrderItemID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Orders
-- --------------------------------------------------
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [PK_Orders] PRIMARY KEY ([OrderID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Products
-- --------------------------------------------------
ALTER TABLE [dbo].[Products] ADD CONSTRAINT [PK_Products] PRIMARY KEY ([ProductID])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_CreateCustomer
-- --------------------------------------------------

-------------------------------------------------------
-- 6. Stored Procedures
-------------------------------------------------------
CREATE   PROCEDURE dbo.usp_CreateCustomer
    @FullName NVARCHAR(100),
    @Email NVARCHAR(150)
AS
BEGIN
    INSERT INTO dbo.Customers (FullName, Email)
    VALUES (@FullName, @Email);
END;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_CreateOrder
-- --------------------------------------------------

CREATE   PROCEDURE dbo.usp_CreateOrder
    @CustomerID INT,
    @Status NVARCHAR(50)
AS
BEGIN
    INSERT INTO dbo.Orders (CustomerID, Status)
    VALUES (@CustomerID, @Status);
END;

GO

-- --------------------------------------------------
-- TABLE dbo.Customers
-- --------------------------------------------------
CREATE TABLE [dbo].[Customers]
(
    [CustomerID] INT IDENTITY(1,1) NOT NULL,
    [FullName] NVARCHAR(100) NOT NULL,
    [Email] NVARCHAR(150) NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT (sysdatetime())
);

GO

-- --------------------------------------------------
-- TABLE dbo.OrderAudit
-- --------------------------------------------------
CREATE TABLE [dbo].[OrderAudit]
(
    [AuditID] INT IDENTITY(1,1) NOT NULL,
    [OrderID] INT NOT NULL,
    [OldStatus] NVARCHAR(50) NULL,
    [NewStatus] NVARCHAR(50) NULL,
    [ChangedOn] DATETIME2 NOT NULL DEFAULT (sysdatetime())
);

GO

-- --------------------------------------------------
-- TABLE dbo.OrderItems
-- --------------------------------------------------
CREATE TABLE [dbo].[OrderItems]
(
    [OrderItemID] INT IDENTITY(1,1) NOT NULL,
    [OrderID] INT NOT NULL,
    [ProductID] INT NOT NULL,
    [Quantity] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Orders
-- --------------------------------------------------
CREATE TABLE [dbo].[Orders]
(
    [OrderID] INT IDENTITY(1,1) NOT NULL,
    [CustomerID] INT NOT NULL,
    [OrderDate] DATETIME2 NOT NULL DEFAULT (sysdatetime()),
    [Status] NVARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Products
-- --------------------------------------------------
CREATE TABLE [dbo].[Products]
(
    [ProductID] INT IDENTITY(1,1) NOT NULL,
    [ProductName] NVARCHAR(150) NOT NULL,
    [Price] DECIMAL(10, 2) NOT NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.trg_Orders_StatusChange
-- --------------------------------------------------

-------------------------------------------------------
-- 7. Trigger
-------------------------------------------------------
CREATE   TRIGGER trg_Orders_StatusChange
ON dbo.Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.OrderAudit (OrderID, OldStatus, NewStatus)
    SELECT
        d.OrderID,
        d.Status,
        i.Status
    FROM deleted d
    JOIN inserted i
        ON d.OrderID = i.OrderID
    WHERE d.Status <> i.Status;
END;

GO

-- --------------------------------------------------
-- VIEW dbo.vw_OrderSummary
-- --------------------------------------------------
CREATE VIEW dbo.vw_OrderSummary
AS
SELECT
    o.OrderID,
    c.FullName,
    o.OrderDate,
    o.Status
FROM dbo.Orders o
JOIN dbo.Customers c
    ON o.CustomerID = c.CustomerID;

GO

