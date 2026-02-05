-- Object: TABLE citrus_usr.quaterlyledgerdata
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[quaterlyledgerdata]
(
    [dpcode] VARCHAR(20) NOT NULL,
    [date] VARCHAR(8) NULL,
    [particular] VARCHAR(250) NOT NULL,
    [debit] MONEY NULL,
    [credit] MONEY NULL,
    [balance] VARCHAR(33) NULL,
    [holdingdate] VARCHAR(8) NOT NULL
);

GO
