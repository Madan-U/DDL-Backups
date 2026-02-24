-- Object: TABLE citrus_usr.instrument_mstr
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[instrument_mstr]
(
    [insm_id] NUMERIC(10, 0) NOT NULL,
    [insm_excm_id] NUMERIC(10, 0) NULL,
    [insm_code] VARCHAR(25) NOT NULL,
    [insm_desc] VARCHAR(50) NULL,
    [insm_created_dt] DATETIME NULL,
    [insm_created_by] VARCHAR(25) NULL,
    [insm_lst_upd_dt] DATETIME NULL,
    [insm_lst_upd_by] VARCHAR(25) NULL,
    [insm_deleted_ind] SMALLINT NULL
);

GO
