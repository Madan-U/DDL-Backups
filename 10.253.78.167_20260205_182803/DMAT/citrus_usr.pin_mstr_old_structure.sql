-- Object: TABLE citrus_usr.pin_mstr_old_structure
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[pin_mstr_old_structure]
(
    [PM_PIN_CODE] NUMERIC(18, 0) NULL,
    [PM_DISTRICT_CODE] NUMERIC(18, 0) NULL,
    [PM_DISTRICT_NAME] VARCHAR(100) NULL,
    [PM_STATE_NAME] VARCHAR(40) NULL,
    [PM_STATUS_FLAG] CHAR(1) NULL,
    [PM_CREATED_BY] VARCHAR(50) NULL,
    [PM_CREATED_DT] DATETIME NULL,
    [PM_LST_UPD_BY] VARCHAR(50) NULL,
    [PM_LST_UPD_DT] DATETIME NULL,
    [PM_DELETED_IND] SMALLINT NULL,
    [PM_CITYREF_NO] CHAR(2) NULL
);

GO
