-- Object: TABLE citrus_usr.Delete_Suresh_DP_BO_TEST
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Delete_Suresh_DP_BO_TEST]
(
    [DP_ClientID] VARCHAR(25) NOT NULL,
    [DP_PartyCode] VARCHAR(20) NOT NULL,
    [DP_PAN] VARCHAR(50) NOT NULL,
    [DP_Branch] VARCHAR(8000) NULL,
    [DP_SubBroker] VARCHAR(8000) NULL,
    [DP_Region] VARCHAR(8000) NULL,
    [DP_Area] VARCHAR(8000) NULL,
    [BO_PartyCode] VARCHAR(10) NULL,
    [BO_Branch] VARCHAR(10) NULL,
    [BO_SubBroker] VARCHAR(10) NULL,
    [BO_Area] VARCHAR(10) NULL,
    [BO_Region] VARCHAR(15) NULL,
    [BO_PAN_PartyCode] VARCHAR(50) NULL,
    [BO_InActiveFrom] DATETIME NULL
);

GO
