-- Object: TABLE citrus_usr.group_mstr
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[group_mstr]
(
    [Grp_id] NUMERIC(18, 0) NULL,
    [grp_cd] VARCHAR(50) NULL,
    [grp_desc] VARCHAR(50) NULL,
    [grp_client_code] VARCHAR(16) NULL,
    [grp_dpm_id] NUMERIC(18, 0) NULL,
    [grp_CREATED_BY] VARCHAR(25) NOT NULL,
    [grp_CREATED_DT] DATETIME NOT NULL,
    [grp_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [grp_LST_UPD_DT] DATETIME NOT NULL,
    [grp_DELETED_IND] SMALLINT NOT NULL
);

GO
