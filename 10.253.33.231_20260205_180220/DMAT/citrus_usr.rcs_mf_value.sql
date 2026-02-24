-- Object: TABLE citrus_usr.rcs_mf_value
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[rcs_mf_value]
(
    [tradingid] VARCHAR(100) NULL,
    [hld_ac_code] VARCHAR(20) NOT NULL,
    [hld_isin_code] VARCHAR(20) NULL,
    [SecurityName] VARCHAR(282) NULL,
    [netqty] NUMERIC(30, 5) NULL,
    [Valuation] NUMERIC(38, 6) NULL
);

GO
