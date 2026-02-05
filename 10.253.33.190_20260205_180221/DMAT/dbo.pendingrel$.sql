-- Object: TABLE dbo.pendingrel$
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[pendingrel$]
(
    [Bo code] NVARCHAR(255) NULL,
    [client id] NVARCHAR(255) NULL,
    [active from] DATETIME NULL,
    [inactive from] DATETIME NULL,
    [branch code] NVARCHAR(255) NULL,
    [sub-broker] NVARCHAR(255) NULL,
    [trader] NVARCHAR(255) NULL,
    [Region] NVARCHAR(255) NULL,
    [Area] NVARCHAR(255) NULL
);

GO
