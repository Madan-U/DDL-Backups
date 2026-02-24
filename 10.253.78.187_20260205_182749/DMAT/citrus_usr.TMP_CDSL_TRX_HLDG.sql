-- Object: TABLE citrus_usr.TMP_CDSL_TRX_HLDG
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TMP_CDSL_TRX_HLDG]
(
    [TMPHLDG_BOID] VARCHAR(16) NULL,
    [TMPHLDG_BONM] VARCHAR(60) NULL,
    [TMPHLDG_ISIN] VARCHAR(12) NULL,
    [TMPHLDG_ISIN_SHRT_DESC] VARCHAR(20) NULL,
    [TMPHLDG_BAL_TYPE] VARCHAR(30) NULL,
    [TMPHLDG_CLSNG_BAL] NUMERIC(18, 5) NULL,
    [TMPHLDG_DPM_ID] NUMERIC(10, 0) NULL,
    [TMPHLDG_DPAM_ID] NUMERIC(10, 0) NULL,
    [tmphldg_cur_qty] NUMERIC(18, 5) NULL,
    [tmphldg_free_qty] NUMERIC(18, 5) NULL,
    [tmphldg_freeze_qty] NUMERIC(18, 5) NULL,
    [tmphldg_demat_pnd_ver_qty] NUMERIC(18, 5) NULL,
    [tmphldg_demat_pnd_conf_qty] NUMERIC(18, 5) NULL,
    [tmphldg_remat_pnd_conf_qty] NUMERIC(18, 5) NULL,
    [tmphldg_safe_keeping_qty] NUMERIC(18, 5) NULL,
    [tmphldg_lockin_qty] NUMERIC(18, 5) NULL,
    [tmphldg_earmark_qty] NUMERIC(18, 5) NULL,
    [tmphldg_elimination_qty] NUMERIC(18, 5) NULL,
    [tmphldg_avail_lend_qty] NUMERIC(18, 5) NULL,
    [tmphldg_lend_qty] NUMERIC(18, 5) NULL,
    [tmphldg_borrow_qty] NUMERIC(18, 5) NULL,
    [tmphldg_pledge_qty] NUMERIC(18, 5) NULL,
    [TMPHLDG_HOLDING_DT] DATETIME NULL,
    [TMPHLDG_SETTID_02] VARCHAR(13) NULL,
    [TMPHLDG_SETTID_04] VARCHAR(13) NULL,
    [TMPHLDG_CTR_SETTID] VARCHAR(13) NULL
);

GO
