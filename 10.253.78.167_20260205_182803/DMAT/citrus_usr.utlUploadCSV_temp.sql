-- Object: TABLE citrus_usr.utlUploadCSV_temp
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[utlUploadCSV_temp]
(
    [utl_id] INT IDENTITY(1,1) NOT NULL,
    [utl_BBOCODE] VARCHAR(50) NULL,
    [utl_BalanceAmount] NUMERIC(20, 2) NULL,
    [utl_BOID] VARCHAR(20) NULL
);

GO
