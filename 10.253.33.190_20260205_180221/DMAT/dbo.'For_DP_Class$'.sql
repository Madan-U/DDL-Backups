-- Object: TABLE dbo.'For DP Class$'
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].['For DP Class$']
(
    [BR code as per DP] NVARCHAR(255) NULL,
    [BA BO code] NVARCHAR(255) NULL,
    [Branch Code] NVARCHAR(255) NULL,
    [Status] BIT NOT NULL,
    [BO code as per DP class] NVARCHAR(255) NULL,
    [Branchname as per DP] NVARCHAR(255) NULL,
    [Contact Person] NVARCHAR(255) NULL,
    [Add1] NVARCHAR(255) NULL,
    [Add2] NVARCHAR(255) NULL,
    [Add3] NVARCHAR(255) NULL,
    [City] NVARCHAR(255) NULL,
    [Pin] NVARCHAR(255) NULL,
    [Phone] NVARCHAR(255) NULL,
    [Fax] NVARCHAR(255) NULL,
    [Email] NVARCHAR(255) NULL,
    [bm_allow] NVARCHAR(255) NULL,
    [bm_batchno] NVARCHAR(255) NULL,
    [Ip_add] NVARCHAR(255) NULL,
    [Sahring with BA] NVARCHAR(255) NULL,
    [bm_server] NVARCHAR(255) NULL,
    [bm_database] NVARCHAR(255) NULL,
    [bm_pwd] NVARCHAR(255) NULL,
    [bm_workarea] NVARCHAR(255) NULL,
    [mkrid] NVARCHAR(255) NULL,
    [mkrdt] NVARCHAR(255) NULL,
    [flag] NVARCHAR(255) NULL,
    [type] NVARCHAR(255) NULL,
    [Actv Dt] NVARCHAR(255) NULL,
    [Deact Dt] NVARCHAR(255) NULL,
    [Bc_Certificateholder] NVARCHAR(255) NULL,
    [Bc_certificatefromdt] NVARCHAR(255) NULL,
    [Bc_certificateto] NVARCHAR(255) NULL,
    [Bc_owner] FLOAT NULL,
    [Bc_CertFrom] NVARCHAR(255) NULL,
    [Bc_CertNo] NVARCHAR(255) NULL
);

GO
