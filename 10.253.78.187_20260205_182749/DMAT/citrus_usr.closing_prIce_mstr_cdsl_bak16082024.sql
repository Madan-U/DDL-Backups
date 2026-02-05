-- Object: TABLE citrus_usr.closing_prIce_mstr_cdsl_bak16082024
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[closing_prIce_mstr_cdsl_bak16082024]
(
    [CLOPM_ISIN_CD] VARCHAR(20) NOT NULL,
    [CLOPM_DT] DATETIME NOT NULL,
    [CLOPM_CDSL_RT] NUMERIC(18, 4) NULL,
    [CLOPM_CREATED_BY] VARCHAR(25) NOT NULL,
    [CLOPM_CREATED_DT] DATETIME NOT NULL,
    [CLOPM_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [CLOPM_LST_UPD_DT] DATETIME NOT NULL,
    [CLOPM_DELETED_IND] SMALLINT NOT NULL,
    [clopm_exch] VARCHAR(10) NULL
);

GO
