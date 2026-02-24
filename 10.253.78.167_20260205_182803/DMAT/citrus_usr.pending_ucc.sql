-- Object: TABLE citrus_usr.pending_ucc
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[pending_ucc]
(
    [client_code] VARCHAR(16) NULL,
    [nise_party_code] VARCHAR(10) NULL,
    [active_date] DATETIME NULL,
    [ITPAN] VARCHAR(25) NULL,
    [comb_last_date] DATETIME NULL,
    [pan_gir_no] VARCHAR(50) NULL,
    [Last_inactive_date] DATETIME NULL,
    [sr_no] BIGINT NULL
);

GO
