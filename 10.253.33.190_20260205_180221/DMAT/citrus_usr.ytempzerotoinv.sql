-- Object: TABLE citrus_usr.ytempzerotoinv
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[ytempzerotoinv]
(
    [Demat account no] VARCHAR(20) NOT NULL,
    [BBO code] VARCHAR(20) NULL,
    [Account activation date / AMC date] DATETIME NULL,
    [Process run date] DATETIME NOT NULL,
    [Holding Value ] NUMERIC(37, 2) NULL,
    [Transaction status] VARCHAR(2) NOT NULL,
    [Class transaction status] VARCHAR(2) NOT NULL,
    [Outstanding Amount] NUMERIC(18, 2) NULL,
    [brom_desc] VARCHAR(200) NOT NULL
);

GO
