-- Object: TABLE dbo.Traded_Before_FEB_2023_data
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[Traded_Before_FEB_2023_data]
(
    [CLTCODE] VARCHAR(10) NOT NULL,
    [VDT] DATETIME NULL,
    [active_date] DATETIME NULL,
    [inactive_from] DATETIME NULL,
    [BO_Status] VARCHAR(8) NOT NULL,
    [HOLD_VALUE] VARCHAR(8000) NULL,
    [CNT_TRANS] INT NULL
);

GO
