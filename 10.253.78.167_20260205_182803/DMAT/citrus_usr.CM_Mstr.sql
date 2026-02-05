-- Object: TABLE citrus_usr.CM_Mstr
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[CM_Mstr]
(
    [Cm_Date] DATETIME NULL,
    [Cm_Name1] VARCHAR(164) NULL,
    [CM_Name2] VARCHAR(164) NULL,
    [CM_Name3] VARCHAR(164) NULL,
    [Stock_Exch_ID] NUMERIC(18, 0) NULL,
    [Clearing_House_ID] NUMERIC(18, 0) NULL,
    [CM_ID] VARCHAR(10) NULL,
    [Trade_ID] VARCHAR(10) NULL,
    [Principal_Account] NUMERIC(18, 0) NULL,
    [Unified_Settlement_AcUSA] NUMERIC(18, 0) NULL,
    [CM_Inv_Sec_AcCISA] NUMERIC(18, 0) NULL,
    [Ep_Account] NUMERIC(18, 0) NULL,
    [Address1] VARCHAR(150) NULL,
    [Address2] VARCHAR(150) NULL,
    [Address3] VARCHAR(150) NULL,
    [City] VARCHAR(25) NULL,
    [State] VARCHAR(25) NULL,
    [Country] VARCHAR(25) NULL,
    [Pin_Code] VARCHAR(10) NULL,
    [SP_Reg_Flag] CHAR(1) NULL,
    [cm_created_dt] DATETIME NULL,
    [cm_created_by] VARCHAR(50) NULL,
    [cm_lst_upd_dt] DATETIME NULL,
    [cm_lst_upd_by] VARCHAR(50) NULL,
    [cm_deleted_ind] SMALLINT NULL
);

GO
