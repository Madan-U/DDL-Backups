-- Object: TABLE citrus_usr.Delete_Suresh_DP_BO_Mapping_PXCalicut
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Delete_Suresh_DP_BO_Mapping_PXCalicut]
(
    [DP_ClientID] VARCHAR(20) NOT NULL,
    [bbocode] VARCHAR(20) NOT NULL,
    [DP_Branch] VARCHAR(8000) NOT NULL,
    [DP_SubBroker] VARCHAR(8000) NOT NULL,
    [DP_Area] VARCHAR(8000) NULL,
    [DP_Region] VARCHAR(8000) NULL,
    [BO_PartyCode] VARCHAR(10) NULL,
    [BO_Branch] VARCHAR(10) NULL,
    [BO_SubBroker] VARCHAR(10) NULL,
    [BO_Area] VARCHAR(20) NULL,
    [BO_Region] VARCHAR(20) NULL
);

GO
