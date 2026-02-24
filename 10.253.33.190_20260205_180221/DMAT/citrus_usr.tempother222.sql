-- Object: TABLE citrus_usr.tempother222
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tempother222]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [action] VARCHAR(1) NOT NULL,
    [type] VARCHAR(1) NOT NULL,
    [dt] VARCHAR(10) NULL,
    [dpam_dpm_id] NUMERIC(10, 0) NULL,
    [dpam_id] NUMERIC(10, 0) NOT NULL,
    [isin] VARCHAR(1) NOT NULL,
    [qty] INT NOT NULL,
    [statyus] VARCHAR(1) NOT NULL,
    [level] VARCHAR(1) NOT NULL,
    [bc] VARCHAR(4) NOT NULL,
    [cd] DATETIME NOT NULL,
    [lb] VARCHAR(4) NOT NULL,
    [ld] DATETIME NOT NULL,
    [del] INT NOT NULL,
    [batch] INT NULL,
    [byi] VARCHAR(1) NOT NULL,
    [trn] INT NULL,
    [remarks] NVARCHAR(255) NULL,
    [ford] VARCHAR(2) NOT NULL
);

GO
