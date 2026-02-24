-- Object: TABLE citrus_usr.Profile_charges_mak
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Profile_charges_mak]
(
    [PROC_ID] NUMERIC(10, 0) NOT NULL,
    [PROC_PROFILE_ID] NUMERIC(10, 0) NULL,
    [PROC_SLAB_NO] VARCHAR(20) NULL,
    [PROC_CREATED_BY] VARCHAR(25) NULL,
    [REMARKS] VARCHAR(250) NULL,
    [PROC_CREATED_DT] DATETIME NULL,
    [PROC_LST_UPD_BY] VARCHAR(25) NULL,
    [PROC_LST_UPD_DT] DATETIME NULL,
    [PROC_DELETED_IND] SMALLINT NULL,
    [proc_dtls_id] VARCHAR(30) NULL
);

GO
