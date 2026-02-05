-- Object: TABLE dbo.tbl_Backup_Details
-- Server: 10.253.78.167 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[tbl_Backup_Details]
(
    [Collection_Time] DATETIME NOT NULL,
    [Server_Name] VARCHAR(255) NULL,
    [DatabaseName] VARCHAR(255) NULL,
    [DatabaseID] INT NOT NULL,
    [Recovery_Model] VARCHAR(25) NULL,
    [Full_Backup_Start] DATETIME NULL,
    [Full_Backup_End] DATETIME NULL,
    [Diff_Backup_Start] DATETIME NULL,
    [Diff_Backup_End] DATETIME NULL,
    [Log_Backup_Start] DATETIME NULL,
    [Log_Backup_End] DATETIME NULL,
    [Full_Backup_Path] VARCHAR(255) NULL,
    [Diff_Backup_Path] VARCHAR(255) NULL,
    [Log_Backup_Path] VARCHAR(255) NULL,
    [Full_Backup_Size_GB] DECIMAL(10, 2) NULL,
    [Diff_Backup_Size_GB] DECIMAL(10, 2) NULL,
    [Log_Backup_Size_GB] DECIMAL(10, 2) NULL,
    [Time_Since_Last_Full_Backup_Minutes] INT NULL,
    [Time_Since_Last_Diff_Backup_Minutes] INT NULL,
    [Time_Since_Last_Log_Backup_Minutes] INT NULL,
    [Time_Since_Last_Full_Backup_Detail] VARCHAR(75) NULL,
    [Time_Since_Last_Diff_Backup_Detail] VARCHAR(75) NULL,
    [Time_Since_Last_Log_Backup_Detail] VARCHAR(75) NULL
);

GO
