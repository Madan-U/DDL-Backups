-- Object: TABLE dbo.DMAT_branch
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[DMAT_branch]
(
    [BRANCH_CODE] CHAR(10) NULL,
    [BRANCH] CHAR(40) NULL,
    [Long_Name] CHAR(50) NULL,
    [Address1] VARCHAR(40) NULL,
    [Address2] VARCHAR(40) NULL,
    [City] CHAR(20) NULL,
    [State] CHAR(15) NULL,
    [Nation] CHAR(15) NULL,
    [Zip] CHAR(15) NULL,
    [Phone1] CHAR(15) NULL,
    [Phone2] CHAR(15) NULL,
    [Fax] CHAR(15) NULL,
    [Email] CHAR(50) NULL,
    [Remote] BIT NOT NULL,
    [Security_Net] BIT NOT NULL,
    [Money_Net] BIT NOT NULL,
    [Excise_Reg] CHAR(30) NULL,
    [Contact_Person] CHAR(25) NULL,
    [Prefix] VARCHAR(5) NULL,
    [SharingType] VARCHAR(3) NULL,
    [Trd_Sharing] NUMERIC(18, 4) NULL,
    [Del_Sharing] NUMERIC(18, 4) NULL,
    [Trd_Charges] NUMERIC(18, 4) NULL,
    [Del_Charges] NUMERIC(18, 4) NULL,
    [RemPartyCode] VARCHAR(10) NULL
);

GO
