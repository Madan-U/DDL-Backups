-- Object: TABLE citrus_usr.frontendmaster
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[frontendmaster]
(
    [tblname] NVARCHAR(128) NOT NULL,
    [tblcolname] NVARCHAR(128) NULL,
    [displayname] NVARCHAR(4000) NULL,
    [column_id] INT NOT NULL,
    [name] NVARCHAR(128) NOT NULL,
    [max_length] SMALLINT NOT NULL,
    [ord] NUMERIC(18, 0) NULL,
    [hidden] VARCHAR(1) NOT NULL,
    [validation_formula] VARCHAR(8000) NULL
);

GO
