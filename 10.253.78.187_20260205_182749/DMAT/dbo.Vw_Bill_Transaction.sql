-- Object: TABLE dbo.Vw_Bill_Transaction
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[Vw_Bill_Transaction]
(
    [BILL_TRXN_ID] NUMERIC(18, 0) NOT NULL,
    [CLIENT_CODE] VARCHAR(16) NULL,
    [BENEF_ACCNO] VARCHAR(8) NULL,
    [TRXN_TYPE] VARCHAR(10) NULL,
    [NARRATION] VARCHAR(200) NULL,
    [AMOUNT] MONEY NULL,
    [BILL_NO] NUMERIC(15, 0) NULL,
    [BILL_DATE] DATETIME NULL,
    [REMARKS] VARCHAR(200) NULL,
    [DPM_CHARGES] MONEY NULL,
    [SERV_TAX] MONEY NULL
);

GO
