-- Object: TABLE citrus_usr.REAM_MAK
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[REAM_MAK]
(
    [ream_id] NUMERIC(10, 0) NOT NULL,
    [ream_excm_id] NUMERIC(10, 0) NULL,
    [ream_code] VARCHAR(25) NULL,
    [ream_desc] VARCHAR(50) NULL,
    [ream_created_by] VARCHAR(25) NULL,
    [ream_created_dt] DATETIME NULL,
    [ream_lst_upd_by] VARCHAR(25) NULL,
    [ream_lst_upd_dt] DATETIME NULL,
    [ream_deleted_ind] SMALLINT NULL,
    [ream_trantm_id] NUMERIC(18, 0) NULL
);

GO
