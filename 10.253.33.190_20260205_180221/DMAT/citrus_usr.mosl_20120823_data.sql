-- Object: TABLE citrus_usr.mosl_20120823_data
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[mosl_20120823_data]
(
    [order_by] NUMERIC(10, 1) NULL,
    [dpam_id] BIGINT NULL,
    [dpam_sba_name] VARCHAR(200) NULL,
    [dpam_accttno] VARCHAR(16) NULL,
    [cdshm_tratm_desc] VARCHAR(8000) NULL,
    [dpm_trans_no] VARCHAR(25) NOT NULL,
    [TRANS_date] VARCHAR(200) NULL,
    [isin_cd] VARCHAR(25) NULL,
    [sett_type] VARCHAR(12) NULL,
    [sett_no] VARCHAR(282) NULL,
    [isin_name] VARCHAR(8000) NULL,
    [opening_bal] VARCHAR(8000) NULL,
    [debit_qty] VARCHAR(8000) NULL,
    [credit_qty] VARCHAR(8000) NULL,
    [closing_bal] NUMERIC(21, 2) NULL,
    [cdshm_trg_settm_no] VARCHAR(8000) NULL,
    [valuation] NUMERIC(18, 0) NULL,
    [rate] NUMERIC(18, 3) NOT NULL,
    [tratm_cd] VARCHAR(8000) NULL,
    [totalhldg] NUMERIC(18, 2) NOT NULL
);

GO
