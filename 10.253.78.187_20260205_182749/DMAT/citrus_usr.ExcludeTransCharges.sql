-- Object: TABLE citrus_usr.ExcludeTransCharges
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[ExcludeTransCharges]
(
    [dpm_id] BIGINT NULL,
    [src_chargename] VARCHAR(200) NULL,
    [on_chargename] VARCHAR(200) NULL,
    [for_type] CHAR(1) NULL
);

GO
