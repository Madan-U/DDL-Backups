-- Object: TABLE dbo.10904_ledger
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[10904_ledger]
(
    [Client id] NVARCHAR(255) NULL,
    [Branch Code] NVARCHAR(255) NULL,
    [Trade Back office] NVARCHAR(255) NULL,
    [Amount] FLOAT NULL,
    [Dr / Cr] NVARCHAR(255) NULL,
    [A/c opening dete] DATETIME NULL,
    [Scheme] NVARCHAR(255) NULL
);

GO
