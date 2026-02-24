-- Object: TABLE dbo.Tbl_CMBill_BSE_NSE
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[Tbl_CMBill_BSE_NSE]
(
    [Party_code] VARCHAR(10) NULL,
    [ISIN] VARCHAR(12) NULL,
    [sauda_date] DATETIME NULL,
    [PQTYDEL] INT NULL,
    [PAMTDEL] MONEY NULL,
    [segment] VARCHAR(100) NULL,
    [SQTYDEL] VARCHAR(100) NULL,
    [SAMTDEL] VARCHAR(100) NULL
);

GO
