-- Object: TABLE citrus_usr.Categories
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Categories]
(
    [CategoryID] INT IDENTITY(1,1) NOT NULL,
    [CategoryName] VARCHAR(100) NULL,
    [Picture] IMAGE NULL
);

GO
