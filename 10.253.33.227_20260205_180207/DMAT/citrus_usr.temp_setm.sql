-- Object: TABLE citrus_usr.temp_setm
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[temp_setm]
(
    [setm_excm_id] NUMERIC(10, 0) NULL,
    [setm_ccm_id] NUMERIC(10, 0) NULL,
    [setm_excsm_id] NUMERIC(10, 0) NULL,
    [setm_settm_id] NUMERIC(10, 0) NULL,
    [setm_settm_no] VARCHAR(50) NULL,
    [setm_start_dt] DATETIME NULL,
    [setm_payin_dt] DATETIME NULL,
    [setm_payout_dt] DATETIME NULL,
    [setm_tr_start_dt] DATETIME NULL,
    [setm_tr_end_dt] DATETIME NULL,
    [setm_created_by] VARCHAR(25) NULL,
    [setm_created_dt] DATETIME NULL,
    [setm_lst_upd_by] VARCHAR(25) NULL,
    [setm_lst_upd_dt] DATETIME NULL,
    [setm_deleted_ind] SMALLINT NULL
);

GO
