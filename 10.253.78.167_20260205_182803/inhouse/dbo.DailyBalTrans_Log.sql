-- Object: TABLE dbo.DailyBalTrans_Log
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[DailyBalTrans_Log]
(
    [NISE_PARTY_CODE] VARCHAR(10) NOT NULL,
    [CLIENT_CODE] VARCHAR(16) NULL,
    [BENEF_ACCNO] NUMERIC(18, 0) NULL,
    [SEGMENT] VARCHAR(5) NULL,
    [ACTIVE_DATE] DATETIME NULL,
    [LD_DT] DATETIME NULL,
    [LD_AMOUNT] NUMERIC(38, 4) NULL,
    [NET_AVAILABLE] MONEY NULL,
    [CreatedBy] VARCHAR(25) NULL,
    [CreatedOn] DATETIME NOT NULL
);

GO
