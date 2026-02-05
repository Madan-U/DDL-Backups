-- Object: TABLE citrus_usr.used_stock
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[used_stock]
(
    [SERIES] NUMERIC(15, 0) NOT NULL,
    [SLIPNO] NUMERIC(15, 0) NULL,
    [BOID] VARCHAR(16) NULL,
    [EXECDATE] DATETIME NULL
);

GO
