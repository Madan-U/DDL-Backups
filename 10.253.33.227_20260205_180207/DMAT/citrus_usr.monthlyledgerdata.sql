-- Object: TABLE citrus_usr.monthlyledgerdata
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[monthlyledgerdata]
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
