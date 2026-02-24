-- Object: TABLE dbo.buyback_poaclientdetails
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[buyback_poaclientdetails]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [clientcode] VARCHAR(50) NULL,
    [clientdp] VARCHAR(50) NULL,
    [POA_flag] VARCHAR(1) NULL,
    [DDPI_Flag] VARCHAR(1) NULL
);

GO
