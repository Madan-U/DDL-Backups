-- Object: TABLE citrus_usr.E_DIS_Process_Data
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[E_DIS_Process_Data]
(
    [Sno] INT IDENTITY(1,1) NOT NULL,
    [partycode] VARCHAR(10) NULL,
    [boid] VARCHAR(16) NULL,
    [isin] VARCHAR(16) NULL,
    [qty] FLOAT NULL,
    [ANGEL_TRXN_ID] VARCHAR(50) NULL,
    [CDSL_TRXN_Id] VARCHAR(50) NULL,
    [Request_date] DATETIME NULL,
    [sett_no] VARCHAR(10) NULL,
    [sett_type] VARCHAR(3) NULL,
    [process_status] INT NULL,
    [process_date] DATETIME NULL,
    [slip_no] VARCHAR(20) NULL
);

GO
