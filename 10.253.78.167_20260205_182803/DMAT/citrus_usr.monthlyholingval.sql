-- Object: TABLE citrus_usr.monthlyholingval
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[monthlyholingval]
(
    [td_ac_code] VARCHAR(20) NOT NULL,
    [isin] VARCHAR(20) NOT NULL,
    [security] VARCHAR(140) NULL,
    [type] VARCHAR(15) NULL,
    [quantity] NUMERIC(18, 5) NULL,
    [rate] NUMERIC(18, 4) NOT NULL,
    [value] NUMERIC(37, 9) NULL,
    [holdingdt] VARCHAR(8) NULL
);

GO
