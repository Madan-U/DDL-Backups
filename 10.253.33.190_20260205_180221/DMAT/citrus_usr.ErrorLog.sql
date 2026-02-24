-- Object: TABLE citrus_usr.ErrorLog
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[ErrorLog]
(
    [Error_code] VARCHAR(50) NOT NULL,
    [Error_DateTime] DATETIME NULL,
    [Error_Module] VARCHAR(500) NULL,
    [Error_Created_By] VARCHAR(50) NULL
);

GO
