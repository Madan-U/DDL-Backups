-- Object: TABLE citrus_usr.paneltablestructure
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[paneltablestructure]
(
    [columnname] NVARCHAR(128) NULL,
    [columntype] NVARCHAR(128) NOT NULL,
    [maxlength] SMALLINT NOT NULL,
    [actualdatatype] VARCHAR(100) NULL,
    [actualdatatypemaxlength] NUMERIC(18, 0) NULL,
    [hiddenyn] VARCHAR(100) NULL,
    [ord] NUMERIC(18, 0) NULL,
    [displayname] VARCHAR(250) NULL,
    [defaultval] VARCHAR(250) NULL,
    [enable] CHAR(1) NULL
);

GO
