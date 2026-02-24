-- Object: TABLE citrus_usr.client_charges_cdsl_bak_03122024
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[client_charges_cdsl_bak_03122024]
(
    [CLIC_ID] NUMERIC(18, 0) NULL,
    [CLIC_TRANS_DT] DATETIME NULL,
    [CLIC_DPM_ID] NUMERIC(18, 0) NULL,
    [CLIC_DPAM_ID] VARCHAR(25) NULL,
    [CLIC_CHARGE_NAME] VARCHAR(150) NULL,
    [CLIC_CHARGE_AMT] NUMERIC(18, 5) NULL,
    [CLIC_FLG] CHAR(1) NULL,
    [CLIC_CREATED_BY] VARCHAR(25) NULL,
    [CLIC_CREATED_DT] DATETIME NULL,
    [CLIC_LST_UPD_BY] VARCHAR(25) NULL,
    [CLIC_LST_UPD_DT] DATETIME NULL,
    [CLIC_DELETED_IND] SMALLINT NULL,
    [CLIC_POST_TOACCT] NUMERIC(18, 0) NULL,
    [trans_dt] DATETIME NULL,
    [dpam_id] NUMERIC(18, 0) NULL,
    [charge_name] VARCHAR(50) NULL,
    [charge_val] NUMERIC(18, 5) NULL,
    [post_toacct] NUMERIC(10, 0) NULL,
    [FLG] CHAR(1) NULL,
    [Q_FLG] INT NOT NULL,
    [Qtr] DATETIME NULL
);

GO
