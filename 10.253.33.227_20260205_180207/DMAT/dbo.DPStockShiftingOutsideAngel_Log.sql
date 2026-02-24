-- Object: TABLE dbo.DPStockShiftingOutsideAngel_Log
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[DPStockShiftingOutsideAngel_Log]
(
    [From_DP] VARCHAR(100) NULL,
    [TD_ISIN_CODE] VARCHAR(100) NULL,
    [TD_CURDATE] DATETIME NULL,
    [NISE_PARTY_CODE] VARCHAR(100) NULL,
    [To_DP] VARCHAR(100) NULL
);

GO
