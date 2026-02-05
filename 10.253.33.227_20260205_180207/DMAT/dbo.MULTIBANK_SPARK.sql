-- Object: TABLE dbo.MULTIBANK_SPARK
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[MULTIBANK_SPARK]
(
    [CL_CODE] VARCHAR(12) NOT NULL,
    [Account_type] INT NOT NULL,
    [Account_desc] VARCHAR(20) NULL,
    [Bank_Name] VARCHAR(40) NOT NULL,
    [Branch_Name] VARCHAR(50) NOT NULL,
    [Bank_Acc_No] VARCHAR(25) NOT NULL,
    [MICRNO] VARCHAR(10) NOT NULL,
    [Defbankacc] CHAR(1) NULL,
    [Type] CHAR(1) NULL,
    [processed_by] CHAR(2) NOT NULL,
    [chequename] VARCHAR(100) NULL,
    [Client_curr] VARCHAR(5) NULL,
    [IFSCode] VARCHAR(11) NULL,
    [FundsPayout] VARCHAR(10) NULL,
    [Created_by] VARCHAR(100) NULL,
    [created_Dt] DATETIME NULL,
    [lst_upd_by] VARCHAR(100) NULL,
    [lst_upd_dt] DATETIME NULL,
    [changed] CHAR(2) NULL,
    [migrate_yn] CHAR(2) NULL
);

GO
