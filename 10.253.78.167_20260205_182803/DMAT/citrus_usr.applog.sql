-- Object: TABLE citrus_usr.applog
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[applog]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [crn] NUMERIC(18, 0) NULL,
    [tab] VARCHAR(100) NULL,
    [appdt] DATETIME NULL
);

GO
