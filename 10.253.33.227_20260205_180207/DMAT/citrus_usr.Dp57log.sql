-- Object: TABLE citrus_usr.Dp57log
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Dp57log]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [dateimport] DATETIME NULL,
    [tab] VARCHAR(100) NULL,
    [status] VARCHAR(100) NULL
);

GO
