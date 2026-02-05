-- Object: TABLE citrus_usr.Binesh_Matching_relationship
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Binesh_Matching_relationship]
(
    [dpam_sba_no] VARCHAR(20) NOT NULL,
    [bbocode] VARCHAR(20) NOT NULL,
    [br/ba] VARCHAR(8000) NOT NULL,
    [rem\onw] VARCHAR(8000) NOT NULL,
    [ar] VARCHAR(8000) NULL,
    [reg] VARCHAR(8000) NULL,
    [BO_PartyCode] VARCHAR(10) NULL,
    [BO_Branch] VARCHAR(10) NULL,
    [BO_SubBroker] VARCHAR(10) NULL,
    [BO_Area] VARCHAR(20) NULL,
    [BO_Region] VARCHAR(20) NULL,
    [Matched] VARCHAR(1) NULL DEFAULT 'N'
);

GO
