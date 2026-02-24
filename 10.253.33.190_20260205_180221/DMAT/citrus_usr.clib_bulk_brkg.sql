-- Object: TABLE citrus_usr.clib_bulk_brkg
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[clib_bulk_brkg]
(
    [clidb_dpam_id] NUMERIC(10, 0) NULL,
    [clidb_brom_id] NUMERIC(10, 0) NULL,
    [clidb_eff_from_dt] DATETIME NULL,
    [clidb_eff_to_dt] DATETIME NULL,
    [clidb_created_by] VARCHAR(25) NULL,
    [clidb_created_dt] DATETIME NULL,
    [clidb_lst_upd_by] VARCHAR(25) NULL,
    [clidb_lst_upd_dt] DATETIME NULL,
    [clidb_deleted_ind] SMALLINT NULL
);

GO
