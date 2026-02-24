-- Object: TABLE citrus_usr.Tmps
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Tmps]
(
    [TMP_TRXNO] VARCHAR(20) NULL,
    [TMP_TRXDATE] DATETIME NULL,
    [TMP_BEN_ACCT_NO] VARCHAR(20) NULL,
    [TMP_ISIN_CD] VARCHAR(20) NULL,
    [TMP_TRATM_CD] VARCHAR(50) NULL,
    [TMP_QTY] NUMERIC(9, 0) NULL,
    [TMP_TRANS_DESC] VARCHAR(500) NULL,
    [TMP_STATUS] CHAR(1) NULL
);

GO
