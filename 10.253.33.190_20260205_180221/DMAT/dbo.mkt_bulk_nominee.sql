-- Object: TABLE dbo.mkt_bulk_nominee
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[mkt_bulk_nominee]
(
    [Name] VARCHAR(150) NULL,
    [SearchName] VARCHAR(150) NULL,
    [Addr1] VARCHAR(30) NULL,
    [Addr2] VARCHAR(30) NULL,
    [Addr3] VARCHAR(30) NULL,
    [City] VARCHAR(25) NULL,
    [State] VARCHAR(25) NULL,
    [Country] VARCHAR(25) NULL,
    [PinCode] VARCHAR(10) NULL,
    [PANGIR] VARCHAR(20) NULL,
    [BOId] VARCHAR(16) NULL,
    [RES_SEC_FLg] VARCHAR(1) NOT NULL,
    [NOM_Sr_No] VARCHAR(2) NOT NULL,
    [rel_WITH_BO] VARCHAR(2) NOT NULL,
    [perc_OF_SHARES] MONEY NULL,
    [statecode] VARCHAR(25) NULL,
    [countrycode] VARCHAR(25) NULL,
    [DateOfBirth] VARCHAR(8) NULL,
    [DateOfSetup] VARCHAR(8) NULL,
    [client_code] VARCHAR(50) NULL,
    [DP_Status] VARCHAR(40) NULL,
    [ADDED_ON_Date] VARCHAR(30) NULL,
    [Nominee_Status] VARCHAR(6) NOT NULL,
    [Nominee_Request_Status] VARCHAR(11) NOT NULL
);

GO
