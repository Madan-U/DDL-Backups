-- Object: TABLE dbo.MimansaAngelClientDpHolding
-- Server: 10.253.78.187 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[MimansaAngelClientDpHolding]
(
    [Party_code] CHAR(16) NOT NULL,
    [IsIn] CHAR(12) NOT NULL,
    [HoldQty] INT NULL,
    [Scripname] VARCHAR(150) NULL,
    [Reportdate] SMALLDATETIME NULL,
    [HoldingAccountCode] VARCHAR(16) NULL,
    [HoldingType] VARCHAR(20) NULL,
    [hld_ac_type] VARCHAR(4) NULL,
    [bt_description] VARCHAR(100) NULL,
    [ClosingPrice] MONEY NULL,
    [ClosingDate] SMALLDATETIME NULL
);

GO
