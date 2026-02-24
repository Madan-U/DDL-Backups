-- Object: TABLE dbo.Tbl_Already_updated_POA
-- Server: 10.253.78.187 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[Tbl_Already_updated_POA]
(
    [cm_blsavingcd] CHAR(20) NULL,
    [Old_ClientID] CHAR(16) NULL,
    [New_Client_Id] CHAR(16) NULL,
    [cm_Name] VARCHAR(100) NULL,
    [cm_opendate] CHAR(8) NULL,
    [cm_dpintrefno] VARCHAR(14) NULL,
    [UPD_date] DATETIME NOT NULL
);

GO
