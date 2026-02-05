-- Object: TABLE dbo.Ledger_Opening_Balance
-- Server: 10.253.78.187 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[Ledger_Opening_Balance]
(
    [Client_Code] VARCHAR(20) NULL,
    [Balance] MONEY NULL,
    [DrCr] VARCHAR(5) NULL,
    [Balance_Date] DATETIME NULL
);

GO
