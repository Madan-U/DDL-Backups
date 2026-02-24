-- Object: TABLE citrus_usr.YTEMP24122025
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[YTEMP24122025]
(
    [cdshm_dpm_id] NUMERIC(18, 0) NULL,
    [cdshm_ben_acct_no] VARCHAR(16) NULL,
    [cdshm_dpam_id] NUMERIC(10, 0) NULL,
    [cdshm_tratm_cd] VARCHAR(25) NULL,
    [cdshm_tratm_desc] VARCHAR(200) NULL,
    [cdshm_tras_dt] DATETIME NULL,
    [cdshm_isin] VARCHAR(20) NULL,
    [cdshm_qty] NUMERIC(18, 5) NULL,
    [cdshm_int_ref_no] VARCHAR(50) NULL,
    [cdshm_trans_no] VARCHAR(50) NULL,
    [cdshm_sett_type] VARCHAR(6) NULL,
    [cdshm_sett_no] VARCHAR(10) NULL,
    [cdshm_counter_boid] VARCHAR(20) NULL,
    [cdshm_counter_dpid] VARCHAR(20) NULL,
    [cdshm_counter_cmbpid] VARCHAR(20) NULL,
    [cdshm_excm_id] VARCHAR(20) NULL,
    [cdshm_trade_no] VARCHAR(20) NULL,
    [cdshm_tratm_type_desc] VARCHAR(80) NULL,
    [cdshm_opn_bal] NUMERIC(18, 5) NULL,
    [cdshm_bal_type] VARCHAR(30) NULL,
    [CDSHM_TRG_SETTM_NO] VARCHAR(13) NULL
);

GO
