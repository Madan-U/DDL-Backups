-- Object: TABLE citrus_usr.Tmp_CM_Mstr
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Tmp_CM_Mstr]
(
    [Tmp_Cm_Date] DATETIME NULL,
    [Tmp_Cm_Name1] VARCHAR(164) NULL,
    [Tmp_CM_Name2] VARCHAR(164) NULL,
    [Tmp_CM_Name3] VARCHAR(164) NULL,
    [Tmp_Stock_Exch_ID] NUMERIC(18, 0) NULL,
    [Tmp_Clearing_House_ID] NUMERIC(18, 0) NULL,
    [Tmp_CM_ID] VARCHAR(10) NULL,
    [Tmp_Trade_ID] VARCHAR(10) NULL,
    [Tmp_Principal_Account] NUMERIC(18, 0) NULL,
    [Tmp_Unified_Settlement_AcUSA] NUMERIC(18, 0) NULL,
    [Tmp_CM_Inv_Sec_AcCISA] NUMERIC(18, 0) NULL,
    [Tmp_Ep_Account] NUMERIC(18, 0) NULL,
    [Tmp_Address1] VARCHAR(150) NULL,
    [Tmp_Address2] VARCHAR(150) NULL,
    [Tmp_Address3] VARCHAR(150) NULL,
    [Tmp_City] VARCHAR(25) NULL,
    [Tmp_State] VARCHAR(25) NULL,
    [Tmp_Country] VARCHAR(25) NULL,
    [Tmp_Pin_Code] VARCHAR(10) NULL,
    [Tmp_SP_Reg_Flag] CHAR(1) NULL
);

GO
