-- Object: TABLE citrus_usr.Holding_Non_poa
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Holding_Non_poa]
(
    [hld_ac_code] VARCHAR(20) NOT NULL,
    [HLD_ISIN_CODE] VARCHAR(20) NULL,
    [HLD_AC_POS] NUMERIC(18, 5) NULL,
    [bbocode] VARCHAR(20) NOT NULL,
    [HLD_HOLD_DATE] DATETIME NULL
);

GO
