-- Object: TABLE citrus_usr.Tmp_mapping
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Tmp_mapping]
(
    [DP_INT_REFNO] VARCHAR(10) NULL,
    [CLIENT_CODE] VARCHAR(16) NULL,
    [NISE_PARTY_CODE] VARCHAR(10) NULL,
    [ACTIVE_DATE] DATETIME NULL,
    [TEMPLATE_CODE] VARCHAR(21) NULL,
    [BOPARTYCODE] VARCHAR(15) NOT NULL,
    [DP_sCHEME] VARCHAR(50) NULL
);

GO
