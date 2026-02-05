-- Object: TABLE citrus_usr.DPHD_MAK
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[DPHD_MAK]
(
    [DPHD_ID] NUMERIC(10, 0) NOT NULL,
    [DPHD_DPAM_ID] NUMERIC(10, 0) NOT NULL,
    [DPHD_ISIN] VARCHAR(20) NOT NULL,
    [DPHD_TRATM_ID] NUMERIC(10, 0) NOT NULL,
    [DPHD_HOLDING_DT] DATETIME NOT NULL,
    [DPHD_CREATED_BY] VARCHAR(20) NOT NULL,
    [DPHD_CREATED_DT] DATETIME NOT NULL,
    [DPHD_LST_UPD_BY] VARCHAR(20) NOT NULL,
    [DPHD_LST_UPD_DT] DATETIME NOT NULL,
    [DPHD_DELETED_IND] SMALLINT NOT NULL,
    [dphd_nomgau_fname] VARCHAR(100) NULL,
    [dphd_nomgau_mname] VARCHAR(50) NULL,
    [dphd_nomgau_lname] VARCHAR(50) NULL,
    [dphd_nomgau_fthname] VARCHAR(100) NULL,
    [dphd_nomgau_dob] DATETIME NULL,
    [dphd_nomgau_pan_no] VARCHAR(15) NULL,
    [dphd_nomgau_gender] VARCHAR(1) NULL,
    [NOM_NRN_NO] VARCHAR(20) NULL
);

GO
