-- Object: TABLE citrus_usr.TMP_CLOSING_PRICE_MSTR_NSDL
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TMP_CLOSING_PRICE_MSTR_NSDL]
(
    [TMPCPM_ISIN] VARCHAR(12) NULL,
    [TMPCPM_PRICE] NUMERIC(20, 6) NULL,
    [TMPCPM_ACTUAL_DT] DATETIME NULL
);

GO
