-- Object: TABLE citrus_usr.[citrus_usr].client_dp_brkg_bak_30012019_invtozero_Renamed_By_DBA
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[[citrus_usr]].client_dp_brkg_bak_30012019_invtozero_Renamed_By_DBA]
(
    [CLIDB_DPAM_ID] DECIMAL(10, 0) NOT NULL,
    [CLIDB_BROM_ID] DECIMAL(10, 0) NOT NULL,
    [CLIDB_CREATED_BY] VARCHAR(25) NOT NULL,
    [CLIDB_CREATED_DT] DATETIME NOT NULL,
    [CLIDB_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [CLIDB_LST_UPD_DT] DATETIME NOT NULL,
    [CLIDB_DELETED_IND] SMALLINT NOT NULL,
    [clidb_eff_from_dt] DATETIME NULL,
    [clidb_eff_to_dt] DATETIME NULL
);

GO
