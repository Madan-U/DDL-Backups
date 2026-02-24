-- Object: TABLE citrus_usr.Temp_ISINM
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Temp_ISINM]
(
    [ISIN_CD] VARCHAR(20) NOT NULL,
    [ISIN_NAME] VARCHAR(200) NULL,
    [ISIN_REG_CD] VARCHAR(20) NULL,
    [ISIN_CONV_DT] DATETIME NULL,
    [ISIN_STATUS] VARCHAR(50) NULL,
    [ISIN_BIT] NUMERIC(1, 0) NULL,
    [ISIN_DECIMAL_ALLOW] VARCHAR(30) NULL,
    [ISIN_ISFROZEN] CHAR(1) NULL
);

GO
