-- Object: TABLE dbo.HUF_C
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[HUF_C]
(
    [PARTY_CODE] VARCHAR(8000) NULL,
    [UCC_Name] VARCHAR(8000) NULL,
    [email] VARCHAR(8000) NULL,
    [Nomination_Flag] VARCHAR(8000) NULL,
    [UCC_Status] VARCHAR(8000) NULL,
    [pan] VARCHAR(8000) NULL,
    [client_code] VARCHAR(16) NULL,
    [NISE_PARTY_CODE] VARCHAR(10) NULL,
    [status] VARCHAR(40) NULL,
    [type] VARCHAR(40) NULL,
    [sub_type] VARCHAR(40) NULL,
    [name] CHAR(100) NULL,
    [Nominee] VARCHAR(3) NOT NULL
);

GO
