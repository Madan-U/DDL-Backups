-- Object: TABLE citrus_usr.Transaction_DP89
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Transaction_DP89]
(
    [Dp89_dpm_id] NUMERIC(18, 0) NULL,
    [Dp89_dpam_id] NUMERIC(18, 0) NULL,
    [Dp89_Ex_Id] INT NULL,
    [Dp89_Settl_type] VARCHAR(10) NULL,
    [Dp89_Settl_Id] VARCHAR(20) NULL,
    [Dp89_BO_ID] VARCHAR(16) NULL,
    [Dp89_CM_Id] VARCHAR(20) NULL,
    [Dp89_CM_Nm] VARCHAR(100) NULL,
    [Dp89_ISIN] VARCHAR(15) NULL,
    [Dp89_Trx_Qty] NUMERIC(16, 3) NULL,
    [Dp89_Earmark_Shrt_Qty] NUMERIC(16, 3) NULL,
    [Dp89_Txn_Type_Flag] CHAR(1) NULL,
    [Dp89_Trn_Status] CHAR(1) NULL,
    [Dp89_Txn_Id] VARCHAR(16) NULL,
    [Dp89_Int_RefNo] VARCHAR(16) NULL,
    [Dp89_Earmark_DateTime] DATETIME NULL,
    [Dp89_Settl_DateTime] DATETIME NULL,
    [Dp89_Free_Balance] NUMERIC(16, 3) NULL,
    [Dp89_Probable_Status] CHAR(1) NULL,
    [Dp89_Balance_Amt] NUMERIC(16, 3) NULL,
    [Dp89_created_dt] DATETIME NULL,
    [Dp89_created_by] VARCHAR(20) NULL,
    [Dp89_lst_upd_dt] DATETIME NULL,
    [Dp89_lst_upd_by] VARCHAR(20) NULL,
    [Dp89_deleted_ind] SMALLINT NULL
);

GO
