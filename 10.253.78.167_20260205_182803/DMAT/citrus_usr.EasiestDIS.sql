-- Object: TABLE citrus_usr.EasiestDIS
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[EasiestDIS]
(
    [Sr_No] TINYINT NOT NULL,
    [Transaction_ID] INT NOT NULL,
    [Transaction_Type] NVARCHAR(50) NOT NULL,
    [BO_ID] BIGINT NOT NULL,
    [ISIN] NVARCHAR(50) NOT NULL,
    [Transaction_Created_by] NVARCHAR(50) NOT NULL,
    [Setup_Date] DATETIME2 NOT NULL,
    [Execution_Date] DATE NOT NULL,
    [Quantity] SMALLINT NOT NULL,
    [Buy_Sell] NVARCHAR(50) NOT NULL,
    [Cash_Transfer] NVARCHAR(50) NOT NULL,
    [Counter_Client_Id] NVARCHAR(1) NULL,
    [Counter_CM_DP_Id] INT NOT NULL,
    [Counter_Depository_Id] NVARCHAR(1) NULL
);

GO
