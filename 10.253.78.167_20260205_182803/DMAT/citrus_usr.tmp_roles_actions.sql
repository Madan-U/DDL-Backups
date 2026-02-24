-- Object: TABLE citrus_usr.tmp_roles_actions
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tmp_roles_actions]
(
    [ROLA_ROL_ID] NUMERIC(10, 0) NOT NULL,
    [ROLA_ACT_ID] NUMERIC(10, 0) NOT NULL,
    [ROLA_ACCESS1] NUMERIC(10, 0) NOT NULL,
    [ROLA_CREATED_BY] VARCHAR(25) NOT NULL,
    [ROLA_CREATED_DT] DATETIME NOT NULL,
    [ROLA_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [ROLA_LST_UPD_DT] DATETIME NOT NULL,
    [ROLA_DELETED_IND] SMALLINT NOT NULL
);

GO
