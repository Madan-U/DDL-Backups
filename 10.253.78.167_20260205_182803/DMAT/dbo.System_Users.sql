-- Object: TABLE dbo.System_Users
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[System_Users]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Username] NVARCHAR(50) NOT NULL,
    [Password] NVARCHAR(MAX) NOT NULL,
    [RegDate] DATETIME NOT NULL DEFAULT (getdate()),
    [Email] NVARCHAR(50) NOT NULL
);

GO
