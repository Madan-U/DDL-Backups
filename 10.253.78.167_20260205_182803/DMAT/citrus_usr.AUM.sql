-- Object: TABLE citrus_usr.AUM
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[AUM]
(
    [HLD_ISIN_CODE] VARCHAR(12) NULL,
    [HOLDING] MONEY NULL,
    [HLD_HOLD_DATE] SMALLDATETIME NULL,
    [CL_PRICE] MONEY NOT NULL
);

GO
