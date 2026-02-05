-- Object: TABLE citrus_usr.temp_trans
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[temp_trans]
(
    [cdshm_ben_acct_no] VARCHAR(16) NULL,
    [dpam_sba_name] VARCHAR(150) NULL,
    [cdshm_tras_dt] DATETIME NULL,
    [cdshm_isin] VARCHAR(20) NULL,
    [cdshm_qty] NUMERIC(18, 5) NULL,
    [cdshm_counter_boid] VARCHAR(20) NULL,
    [ISIN_NAME] VARCHAR(282) NULL,
    [counternm] VARCHAR(150) NULL,
    [Reg_cd] VARCHAR(100) NULL,
    [Reg_name] VARCHAR(100) NULL,
    [Reg_adr1] VARCHAR(100) NULL,
    [Reg_adr2] VARCHAR(100) NULL,
    [Reg_adr3] VARCHAR(100) NULL,
    [Reg_adr4] VARCHAR(100) NULL,
    [Reg_adr5] VARCHAR(100) NULL,
    [Reg_adr6] VARCHAR(100) NULL,
    [Reg_adr7] VARCHAR(100) NULL,
    [Reg_phone] VARCHAR(1000) NOT NULL,
    [Reg_fax] VARCHAR(1000) NOT NULL,
    [Reg_email] VARCHAR(1000) NOT NULL
);

GO
