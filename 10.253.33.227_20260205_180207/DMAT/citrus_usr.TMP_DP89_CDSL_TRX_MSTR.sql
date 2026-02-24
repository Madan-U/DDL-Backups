-- Object: TABLE citrus_usr.TMP_DP89_CDSL_TRX_MSTR
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TMP_DP89_CDSL_TRX_MSTR]
(
    [TmpDp89_Ex_Id] NUMERIC(18, 0) NULL,
    [TmpDp89_Ex_Nm] VARCHAR(100) NULL,
    [TmpDp89_CH_Id] NUMERIC(18, 0) NULL,
    [TmpDp89_DP_Id] VARCHAR(6) NULL,
    [TmpDp89_Settl_Id] VARCHAR(13) NULL,
    [TmpDp89_BO_ID] VARCHAR(16) NULL,
    [TmpDp89_BO_Nm] VARCHAR(100) NULL,
    [TmpDp89_CM_Id] VARCHAR(8) NULL,
    [TmpDp89_CM_Nm] VARCHAR(100) NULL,
    [TmpDp89_ISIN] VARCHAR(12) NULL,
    [TmpDp89_ISIN_Nm] VARCHAR(50) NULL,
    [TmpDp89_Trx_Qty] NUMERIC(18, 0) NULL,
    [TmpDp89_Earmark_Shrt_Qty] NUMERIC(18, 0) NULL,
    [TmpDp89_Txn_Type_Flag] CHAR(1) NULL,
    [TmpDp89_Trn_Status] CHAR(1) NULL,
    [TmpDp89_Txn_Id_Early_Payin] NUMERIC(18, 0) NULL,
    [TmpDp89_Setup_TimeStamp] VARCHAR(20) NULL,
    [TmpDp89_Int_RefNo] VARCHAR(16) NULL,
    [TmpDp89_Settl_Type_desc] VARCHAR(40) NULL,
    [TmpDp89_Earmark_DateTime] VARCHAR(20) NULL,
    [TmpDp89_Settl_DateTime] VARCHAR(20) NULL,
    [TmpDp89_Free_Balance] NUMERIC(18, 0) NULL,
    [TmpDp89_Probable_Status] CHAR(1) NULL,
    [TmpDp89_Balance_Amt] NUMERIC(18, 0) NULL
);

GO
