-- DDL Export
-- Server: 192.168.31.174
-- Database: DBA_Inventory
-- Exported: 2026-01-28T17:12:33.613008

USE DBA_Inventory;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UpdateSQLInventoryConfigInfo
-- --------------------------------------------------

/*
===============================================================================
Procedure Name : usp_UpdateSQLInventoryConfigInfo
Created On     : 2026-01-25
Purpose        : Collect server hardware and SQL info. 
                 Creates the table if it is missing, then inserts data.
===============================================================================
*/

CREATE PROCEDURE [dbo].[usp_UpdateSQLInventoryConfigInfo]
AS
BEGIN
    SET NOCOUNT ON;

    ---------------------------------------------------------------------------
    -- Step 1: Check if Table exists; if not, Create it
    ---------------------------------------------------------------------------
    IF OBJECT_ID('[dbo].[SQL_Inventory_Config_Info]', 'U') IS NULL
    BEGIN
        CREATE TABLE [dbo].[SQL_Inventory_Config_Info](
            [Collection_Date] [datetime] NOT NULL DEFAULT (GETUTCDATE()),
            [Server_IP]       [nvarchar](50) NOT NULL,
            [Host_Name]       [nvarchar](128) NOT NULL,
            [SQL_Instance]    [nvarchar](128) NOT NULL, 
            [SQL_Version]     [nvarchar](max) NOT NULL, 
            [CPU]             [int] NOT NULL,           
            [Memory_GB]       [decimal](10, 2) NOT NULL
        );
        
        PRINT 'Table [dbo].[SQL_Inventory_Config_Info] was missing and has been created.';
    END

    ---------------------------------------------------------------------------
    -- Variable declarations
    ---------------------------------------------------------------------------
    DECLARE 
        @CPU        INT,
        @Memory_GB  DECIMAL(10,2),
        @Host_IP    NVARCHAR(50),
        @Host_Name  NVARCHAR(128),
        @SQL_Version NVARCHAR(MAX);

    ---------------------------------------------------------------------------
    -- Step 2: Get CPU cores and Physical RAM
    ---------------------------------------------------------------------------
    SELECT 
        @CPU = cpu_count,
        @Memory_GB = CAST(physical_memory_kb / 1024.0 / 1024.0 AS DECIMAL(10,2))
    FROM sys.dm_os_sys_info;

    ---------------------------------------------------------------------------
    -- Step 3: Get Host IP
    ---------------------------------------------------------------------------
    SELECT TOP 1 @Host_IP = local_net_address
    FROM sys.dm_exec_connections
    WHERE local_net_address IS NOT NULL
      AND local_net_address NOT IN ('127.0.0.1', '::1')
    ORDER BY session_id;

    SET @Host_IP = ISNULL(@Host_IP, '127.0.0.1');

    ---------------------------------------------------------------------------
    -- Step 4: Get Host and Version info
    ---------------------------------------------------------------------------
    SET @Host_Name = CAST(SERVERPROPERTY('MachineName') AS NVARCHAR(128));
    SET @SQL_Version = CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(100)) 
                       + ' - ' + CAST(SERVERPROPERTY('Edition') AS NVARCHAR(100));

    ---------------------------------------------------------------------------
    -- Step 5: Insert collected information
    ---------------------------------------------------------------------------
    INSERT INTO [dbo].[SQL_Inventory_Config_Info]
    (
        [Collection_Date],
        [Server_IP],
        [Host_Name],
        [SQL_Instance],
        [SQL_Version],
        [CPU],
        [Memory_GB]
    )
    VALUES
    (
        GETUTCDATE(),
        @Host_IP,
        @Host_Name,
        @@SERVERNAME, 
        @SQL_Version,
        @CPU,
        @Memory_GB
    );

    PRINT 'Data successfully collected for ' + @@SERVERNAME;
END;

GO

-- --------------------------------------------------
-- TABLE dbo.SQL_Inventory_Config_Info
-- --------------------------------------------------
CREATE TABLE [dbo].[SQL_Inventory_Config_Info]
(
    [Collection_Date] DATETIME NOT NULL DEFAULT (getutcdate()),
    [Server_IP] NVARCHAR(50) NOT NULL,
    [Host_Name] NVARCHAR(128) NOT NULL,
    [SQL_Instance] NVARCHAR(128) NOT NULL,
    [SQL_Version] NVARCHAR(MAX) NOT NULL,
    [CPU] INT NOT NULL,
    [Memory_GB] DECIMAL(10, 2) NOT NULL
);

GO

