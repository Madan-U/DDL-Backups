-- Object: TABLE dbo.dtproperties
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[dtproperties]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [objectid] INT NULL,
    [property] VARCHAR(64) NOT NULL,
    [value] VARCHAR(255) NULL,
    [uvalue] NVARCHAR(255) NULL,
    [lvalue] IMAGE NULL,
    [version] INT NOT NULL DEFAULT ((0))
);

GO
