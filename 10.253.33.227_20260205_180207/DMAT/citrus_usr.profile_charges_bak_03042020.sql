-- Object: TABLE citrus_usr.profile_charges_bak_03042020
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[profile_charges_bak_03042020]
(
    [PROC_ID] NUMERIC(10, 0) NOT NULL,
    [PROC_PROFILE_ID] NUMERIC(10, 0) NULL,
    [PROC_SLAB_NO] VARCHAR(20) NULL,
    [PROC_CREATED_BY] VARCHAR(25) NULL,
    [REMARKS] VARCHAR(250) NULL,
    [PROC_CREATED_DT] DATETIME NULL,
    [PROC_LST_UPD_BY] VARCHAR(25) NULL,
    [PROC_LST_UPD_DT] DATETIME NULL,
    [PROC_DELETED_IND ] SMALLINT NULL,
    [proc_dtls_id] NUMERIC(10, 0) NOT NULL
);

GO
