-- Object: TABLE citrus_usr.tempbaupdate
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tempbaupdate]
(
    [dp code] NVARCHAR(255) NULL,
    [branch] NVARCHAR(255) NULL,
    [oldba] VARCHAR(8000) NULL,
    [entm_id] NUMERIC(10, 0) NOT NULL
);

GO
