-- Object: TABLE citrus_usr.Tmp_DP_HOLD_All
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Tmp_DP_HOLD_All]
(
    [HLD_AC_CODE] VARCHAR(16) NULL,
    [HLD_ISIN_CODE] VARCHAR(12) NULL,
    [HLD_AC_POS] MONEY NULL,
    [Close_Price] MONEY NOT NULL,
    [hld_value] MONEY NULL,
    [Fin_Year] VARCHAR(9) NOT NULL
);

GO
