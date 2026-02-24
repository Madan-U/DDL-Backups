-- Object: TABLE citrus_usr.freeze_unfreeze_dtls_cdsl_mak
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[freeze_unfreeze_dtls_cdsl_mak]
(
    [int_id] NUMERIC(10, 0) IDENTITY(1,1) NOT NULL,
    [fre_id] NUMERIC(10, 0) NULL,
    [fre_trans_type] CHAR(1) NULL,
    [fre_dpmid] NUMERIC(18, 0) NULL,
    [fre_level] CHAR(1) NULL,
    [fre_initiated_by] INT NULL,
    [fre_sub_option] INT NULL,
    [fre_DPAM_ID] VARCHAR(16) NULL,
    [fre_isin] VARCHAR(12) NULL,
    [fre_qty_type] CHAR(1) NULL,
    [fre_qty] NUMERIC(16, 3) NULL,
    [fre_frozen_for] CHAR(1) NULL,
    [fre_activation_type] INT NULL,
    [fre_activation_dt] DATETIME NULL,
    [fre_expiry_dt] DATETIME NULL,
    [fre_reason_cd] NUMERIC(2, 0) NULL,
    [fre_int_ref_no] VARCHAR(16) NULL,
    [fre_rmks] VARCHAR(100) NULL,
    [fre_status] CHAR(1) NULL,
    [fre_deleted_ind] INT NULL,
    [fre_created_by] VARCHAR(25) NULL,
    [fre_created_dt] DATETIME NULL,
    [fre_lst_upd_by] VARCHAR(25) NULL,
    [fre_lst_upd_dt] DATETIME NULL,
    [fre_batch_no] NUMERIC(18, 0) NULL,
    [fre_upload_status] CHAR(1) NULL
);

GO
