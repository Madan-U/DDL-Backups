-- Object: TABLE dbo.ContractNoteBounceEmails
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[ContractNoteBounceEmails]
(
    [clientcode] VARCHAR(50) NULL,
    [email] VARCHAR(500) NULL,
    [mobile] VARCHAR(10) NULL,
    [type] VARCHAR(100) NULL,
    [active] VARCHAR(100) NULL,
    [reported_date] VARCHAR(500) NULL,
    [lastbouncedate] VARCHAR(50) NULL,
    [clientname] VARCHAR(50) NULL,
    [sub_broker] VARCHAR(50) NULL
);

GO
