-- Object: TABLE dbo.MultiDpAccount_Spark
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[MultiDpAccount_Spark]
(
    [Cl_code] VARCHAR(12) NOT NULL,
    [Env_type] CHAR(1) NOT NULL,
    [Dpname] VARCHAR(40) NULL,
    [Cltdpacc] VARCHAR(16) NULL,
    [Depository] VARCHAR(10) NULL,
    [Defacc] CHAR(1) NOT NULL,
    [Type] CHAR(1) NULL,
    [Processed_by] CHAR(2) NULL,
    [SlipName] VARCHAR(100) NULL,
    [POA] CHAR(1) NULL,
    [Activation_status] VARCHAR(8) NULL,
    [Created_by] VARCHAR(100) NULL,
    [created_Dt] DATETIME NULL,
    [lst_upd_by] VARCHAR(100) NULL,
    [lst_upd_dt] DATETIME NULL,
    [changed] CHAR(2) NULL,
    [migrate_yn] CHAR(2) NULL
);

GO
