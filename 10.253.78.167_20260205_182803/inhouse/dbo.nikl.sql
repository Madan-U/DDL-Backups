-- Object: TABLE dbo.nikl
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[nikl]
(
    [Cl_code] VARCHAR(10) NULL,
    [Party_code] CHAR(10) NOT NULL,
    [Instru] TINYINT NOT NULL,
    [BankID] VARCHAR(8) NULL,
    [Cltdpid] VARCHAR(20) NULL,
    [Depository] VARCHAR(7) NULL,
    [DefDp] INT NULL
);

GO
