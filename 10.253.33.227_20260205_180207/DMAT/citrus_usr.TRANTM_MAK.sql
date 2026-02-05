-- Object: TABLE citrus_usr.TRANTM_MAK
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TRANTM_MAK]
(
    [trantm_id] NUMERIC(10, 0) NOT NULL,
    [trantm_excm_id] NUMERIC(10, 0) NULL,
    [trantm_code] VARCHAR(25) NULL,
    [trantm_desc] VARCHAR(50) NULL,
    [trantm_created_dt] DATETIME NULL,
    [trantm_created_by] VARCHAR(25) NULL,
    [trantm_lst_upd_dt] DATETIME NULL,
    [trantm_lst_upd_by] VARCHAR(25) NULL,
    [trantm_deleted_ind] SMALLINT NULL
);

GO
