-- Object: TABLE dbo.tbl_ipo_offmarket_data
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[tbl_ipo_offmarket_data]
(
    [Transaction_Date] DATE NULL,
    [TD_AC_CODE] VARCHAR(100) NULL,
    [TD_ISIN_CODE] VARCHAR(100) NULL,
    [TD_QTY] DECIMAL(16, 4) NULL,
    [TD_DESCRIPTION] VARCHAR(500) NULL,
    [TD_DEBIT_CREDIT] VARCHAR(1) NULL,
    [TD_REMARKS] VARCHAR(MAX) NULL,
    [TD_BENEFICIERY] VARCHAR(500) NULL,
    [TD_COUNTERDP] VARCHAR(500) NULL
);

GO
