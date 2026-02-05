-- Object: TABLE citrus_usr.holdingdumplog
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[holdingdumplog]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [status] VARCHAR(100) NULL,
    [dt] DATETIME NULL
);

GO
