-- Object: TABLE citrus_usr.commission_dtls
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[commission_dtls]
(
    [commis_id] NUMERIC(10, 0) IDENTITY(1,1) NOT NULL,
    [commis_dpm_id] NUMERIC(10, 0) NOT NULL,
    [commis_type] CHAR(1) NULL,
    [commis_br_id] VARCHAR(8000) NULL,
    [commis_amt_typ] CHAR(1) NULL,
    [commis_amt] NUMERIC(18, 2) NOT NULL,
    [commis_frm_dt] DATETIME NOT NULL,
    [commis_to_dt] DATETIME NOT NULL,
    [commis_CREATED_BY] VARCHAR(25) NOT NULL,
    [commis_CREATED_DT] DATETIME NOT NULL,
    [commis_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [commis_LST_UPD_DT] DATETIME NOT NULL,
    [commis_DELETED_IND] SMALLINT NOT NULL,
    [commis_min_amt] NUMERIC(18, 0) NULL,
    [BRTYPE] VARCHAR(100) NULL,
    [COMMIS_CR_DR] CHAR(2) NULL,
    [COMMIS_DMT_EX] CHAR(2) NULL,
    [COMMIS_RMT_EX] CHAR(2) NULL
);

GO
