-- Object: TABLE citrus_usr.roles_bak_18032021
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[roles_bak_18032021]
(
    [ROL_ID] NUMERIC(10, 0) NOT NULL,
    [ROL_CD] VARCHAR(200) NULL,
    [ROL_DESC] VARCHAR(200) NULL,
    [ROL_CREATED_BY] VARCHAR(25) NOT NULL,
    [ROL_CREATED_DT] DATETIME NOT NULL,
    [ROL_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [ROL_LST_UPD_DT] DATETIME NOT NULL,
    [ROL_DELETED_IND] SMALLINT NOT NULL
);

GO
