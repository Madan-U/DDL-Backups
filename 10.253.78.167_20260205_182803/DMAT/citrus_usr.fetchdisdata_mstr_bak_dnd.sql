-- Object: TABLE citrus_usr.fetchdisdata_mstr_bak_dnd
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[fetchdisdata_mstr_bak_dnd]
(
    [BOID] VARCHAR(16) NULL,
    [SLIP_NO] VARCHAR(20) NULL,
    [SERIES_TYPE] VARCHAR(20) NULL,
    [ID] VARCHAR(10) NULL,
    [ENTM_ID] VARCHAR(20) NULL,
    [SERIES_FROM] VARCHAR(20) NULL,
    [SERIES_TO] VARCHAR(20) NULL,
    [REMARKS] VARCHAR(100) NULL,
    [FLAG] CHAR(1) NULL,
    [CREATED_DT] DATETIME NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [LST_UPD_DT] DATETIME NULL,
    [LST_UPD_BY] VARCHAR(30) NULL,
    [DELETED_IND] SMALLINT NULL,
    [RECHK_FLAG] CHAR(1) NULL
);

GO
