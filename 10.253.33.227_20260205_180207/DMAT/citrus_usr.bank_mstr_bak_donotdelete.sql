-- Object: TABLE citrus_usr.bank_mstr_bak_donotdelete
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[bank_mstr_bak_donotdelete]
(
    [BANM_ID] NUMERIC(10, 0) NOT NULL,
    [BANM_NAME] VARCHAR(200) NULL,
    [BANM_BRANCH] VARCHAR(200) NULL,
    [BANM_MICR] VARCHAR(12) NULL,
    [BANM_RMKS] VARCHAR(250) NULL,
    [BANM_CREATED_BY] VARCHAR(25) NULL,
    [BANM_CREATED_DT] DATETIME NOT NULL,
    [BANM_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [BANM_LST_UPD_DT] DATETIME NOT NULL,
    [BANM_DELETED_IND] SMALLINT NOT NULL,
    [banm_rtgs_cd] VARCHAR(20) NULL,
    [banm_payloc_cd] VARCHAR(20) NULL
);

GO
