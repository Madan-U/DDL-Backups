-- Object: TABLE citrus_usr.E_Dis_Trxn_Data_bkp_2202
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[E_Dis_Trxn_Data_bkp_2202]
(
    [Sno] BIGINT IDENTITY(1,1) NOT NULL,
    [Refno] BIGINT NULL,
    [Partycode] VARCHAR(15) NULL,
    [BOID] VARCHAR(16) NULL,
    [ISIN] VARCHAR(20) NULL,
    [Qty] MONEY NULL,
    [NO_of_days] INT NULL,
    [status] VARCHAR(10) NULL,
    [FLAG] VARCHAR(10) NULL,
    [updatedatetime] DATETIME NULL,
    [Request_date] DATETIME NULL,
    [Request_Id] VARCHAR(50) NULL,
    [ANGEL_TRXN_ID] VARCHAR(50) NULL,
    [CDSL_TRXN_Id] VARCHAR(50) NULL,
    [CDSL_Response_Id] VARCHAR(50) NULL,
    [Ex_qty] VARCHAR(50) NULL,
    [valid] VARCHAR(50) NULL,
    [Pend_qty] VARCHAR(50) NULL,
    [dummy1] VARCHAR(50) NULL,
    [dummy2] VARCHAR(50) NULL,
    [dummy3] VARCHAR(50) NULL
);

GO
