-- Object: TABLE citrus_usr.freeze_Unfreeze_dtls_mak
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[freeze_Unfreeze_dtls_mak]
(
    [fre_id] NUMERIC(18, 0) NULL,
    [fre_action] CHAR(1) NULL,
    [fre_type] CHAR(1) NULL,
    [fre_exec_dt] DATETIME NULL,
    [fre_dpm_id] VARCHAR(20) NULL,
    [fre_dpam_id] VARCHAR(20) NULL,
    [fre_isin_cd] VARCHAR(20) NULL,
    [fre_qty] NUMERIC(18, 5) NULL,
    [fre_status] CHAR(1) NULL,
    [fre_level] CHAR(1) NULL,
    [fre_created_by] VARCHAR(20) NULL,
    [fre_created_dt] DATETIME NULL,
    [fre_lst_upd_by] VARCHAR(20) NULL,
    [fre_lst_upd_dt] DATETIME NULL,
    [fre_deleted_ind] SMALLINT NULL,
    [FRE_BATCH_NO] VARCHAR(20) NULL,
    [FRE_REQ_INT_BY] VARCHAR(25) NULL,
    [FRE_TRNS_NO] VARCHAR(7) NULL,
    [fre_rmks] VARCHAR(200) NULL,
    [fre_for] VARCHAR(50) NULL
);

GO
