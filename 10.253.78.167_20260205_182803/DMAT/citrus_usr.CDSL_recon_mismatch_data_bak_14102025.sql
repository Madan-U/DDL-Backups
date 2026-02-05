-- Object: TABLE citrus_usr.CDSL_recon_mismatch_data_bak_14102025
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[CDSL_recon_mismatch_data_bak_14102025]
(
    [client_hldg] VARCHAR(20) NULL,
    [isin_hldg] VARCHAR(20) NULL,
    [edmat_hldg] NUMERIC(38, 5) NOT NULL,
    [cdas_hldg] NUMERIC(38, 3) NOT NULL,
    [Mismatch_date] DATETIME NULL
);

GO
