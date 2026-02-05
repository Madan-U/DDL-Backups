-- Object: TABLE citrus_usr.Tushar_Delete_Update_PartyCode
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Tushar_Delete_Update_PartyCode]
(
    [DP_ClientID] VARCHAR(25) NOT NULL,
    [DP_PartyCode] VARCHAR(20) NOT NULL,
    [DP_Branch] VARCHAR(8000) NULL,
    [DP_SubBroker] VARCHAR(8000) NULL,
    [DP_Region] VARCHAR(8000) NULL,
    [DP_Area] VARCHAR(8000) NULL,
    [BO_PartyCode] VARCHAR(10) NULL,
    [BO_Branch] VARCHAR(10) NULL,
    [BO_SubBroker] VARCHAR(10) NULL,
    [BO_Area] VARCHAR(10) NULL,
    [BO_Region] VARCHAR(15) NULL
);

GO
