-- Object: TABLE dbo.TrxnTypes
-- Server: 10.253.33.190 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[TrxnTypes]
(
    [TrxnId] INT IDENTITY(1,1) NOT NULL,
    [TrxnCode] INT NULL,
    [TrxnDescription] VARCHAR(50) NULL,
    [CreatedDate] DATETIME NULL
);

GO
