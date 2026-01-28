-- DDL Export
-- Server: 192.168.31.174
-- Database: InventoryDB
-- Exported: 2026-01-28T19:04:29.678715

USE InventoryDB;
GO

-- --------------------------------------------------
-- CHECK dbo.db_inventory
-- --------------------------------------------------
ALTER TABLE [dbo].[db_inventory] ADD CONSTRAINT [CK__db_invent__envir__4AB81AF0] CHECK ([environment]='UAT' OR [environment]='Dev' OR [environment]='Prod')

GO

-- --------------------------------------------------
-- CHECK dbo.db_inventory
-- --------------------------------------------------
ALTER TABLE [dbo].[db_inventory] ADD CONSTRAINT [CK__db_invent__statu__4BAC3F29] CHECK ([status]='Maintenance' OR [status]='Down' OR [status]='Active')

GO

-- --------------------------------------------------
-- INDEX dbo.db_inventory
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_db_inventory_application_name] ON [dbo].[db_inventory] ([application_name])

GO

-- --------------------------------------------------
-- INDEX dbo.db_inventory
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_db_inventory_environment] ON [dbo].[db_inventory] ([environment])

GO

-- --------------------------------------------------
-- INDEX dbo.db_inventory
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_db_inventory_ip_address] ON [dbo].[db_inventory] ([ip_address])

GO

-- --------------------------------------------------
-- INDEX dbo.db_inventory
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_db_inventory_server_name] ON [dbo].[db_inventory] ([server_name])

GO

-- --------------------------------------------------
-- INDEX dbo.db_inventory
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_db_inventory_status] ON [dbo].[db_inventory] ([status])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.db_inventory
-- --------------------------------------------------
ALTER TABLE [dbo].[db_inventory] ADD CONSTRAINT [PK__db_inven__3213E83F482176F9] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- TABLE dbo.db_inventory
-- --------------------------------------------------
CREATE TABLE [dbo].[db_inventory]
(
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [server_name] NVARCHAR(100) NOT NULL,
    [db_name] NVARCHAR(100) NOT NULL,
    [ip_address] NVARCHAR(15) NOT NULL,
    [port] INT NOT NULL,
    [cpu_cores] INT NOT NULL,
    [memory_gb] INT NOT NULL,
    [application_name] NVARCHAR(100) NOT NULL,
    [owner_team] NVARCHAR(100) NOT NULL,
    [environment] NVARCHAR(10) NOT NULL,
    [status] NVARCHAR(20) NOT NULL,
    [created_at] DATETIME2 NULL DEFAULT (getdate()),
    [updated_at] DATETIME2 NULL DEFAULT (getdate())
);

GO

