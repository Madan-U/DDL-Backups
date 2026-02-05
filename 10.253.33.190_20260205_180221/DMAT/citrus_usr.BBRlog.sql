-- Object: TABLE citrus_usr.BBRlog
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[BBRlog]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [status] VARCHAR(100) NULL,
    [dt] DATETIME NULL
);

GO
