-- Object: TABLE citrus_usr.monthlybilldata
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[monthlybilldata]
(
    [dpcode] VARCHAR(20) NOT NULL,
    [date] VARCHAR(8) NULL,
    [ref] VARCHAR(1) NOT NULL,
    [from date] VARCHAR(8) NULL,
    [to date] VARCHAR(8) NULL,
    [amount] NUMERIC(38, 5) NULL,
    [holdingdate] VARCHAR(8) NULL
);

GO
