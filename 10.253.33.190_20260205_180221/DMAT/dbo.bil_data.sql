-- Object: TABLE dbo.bil_data
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[bil_data]
(
    [Client Code] NVARCHAR(255) NULL,
    [BBO code] NVARCHAR(255) NULL,
    [Bill period] DATETIME NULL,
    [Amount] FLOAT NULL,
    [Dr/Cr] NVARCHAR(255) NULL
);

GO
