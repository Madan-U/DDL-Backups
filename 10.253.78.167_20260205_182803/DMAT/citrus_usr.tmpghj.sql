-- Object: TABLE citrus_usr.tmpghj
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tmpghj]
(
    [dpam_id] BIGINT NULL,
    [dpam_sba_name] VARCHAR(200) NULL,
    [dpam_acctno] VARCHAR(16) NULL,
    [trans_desc] VARCHAR(200) NULL,
    [dpm_trans_no] VARCHAR(10) NULL,
    [trans_date] DATETIME NULL,
    [isin_cd] VARCHAR(12) NULL,
    [sett_type] VARCHAR(50) NULL,
    [sett_no] VARCHAR(10) NULL,
    [opening_bal] NUMERIC(19, 3) NULL,
    [qty] NUMERIC(19, 3) NULL,
    [order_by] INT NULL,
    [line_no] BIGINT NULL,
    [cdshm_trg_settm_no] VARCHAR(13) NULL,
    [tratm_cd] VARCHAR(25) NULL,
    [exedt] DATETIME NULL,
    [c_d_flag] CHAR(1) NULL
);

GO
