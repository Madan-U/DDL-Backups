-- Object: TABLE citrus_usr.TMP_CLOSING_PRICE_MSTR_CDSL
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TMP_CLOSING_PRICE_MSTR_CDSL]
(
    [TMPCPM_ISIN] VARCHAR(12) NULL,
    [TMPCPM_PRICE] NUMERIC(16, 3) NULL,
    [TMPCPM_ACTUAL_DT] DATETIME NULL,
    [TMPCPM_EXCH] VARCHAR(12) NULL
);

GO
