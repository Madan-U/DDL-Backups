-- Object: TABLE citrus_usr.Mobiledata
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Mobiledata]
(
    [MobileID] INT IDENTITY(1,1) NOT NULL,
    [MobileName] VARCHAR(50) NULL,
    [MobileIMEno] VARCHAR(16) NULL,
    [MobileManufactured] VARCHAR(50) NULL,
    [Mobileprice] DECIMAL(18, 0) NULL
);

GO
