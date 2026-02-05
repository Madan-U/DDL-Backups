-- Object: TABLE citrus_usr.delete_babar_cc_mstr
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[delete_babar_cc_mstr]
(
    [CCM_ID] NUMERIC(10, 0) NOT NULL,
    [CCM_CD] VARCHAR(20) NOT NULL,
    [CCM_NAME] VARCHAR(100) NOT NULL,
    [CCM_EXCSM_BIT] NUMERIC(10, 0) NULL,
    [CCM_CREATED_BY] VARCHAR(25) NOT NULL,
    [CCM_CREATED_DT] DATETIME NOT NULL,
    [CCM_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [CCM_LST_UPD_DT] DATETIME NOT NULL,
    [CCM_DELETED_IND] SMALLINT NOT NULL
);

GO
