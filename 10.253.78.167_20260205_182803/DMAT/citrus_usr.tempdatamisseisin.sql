-- Object: TABLE citrus_usr.tempdatamisseisin
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tempdatamisseisin]
(
    [DATE] VARCHAR(11) NULL,
    [ISIN] VARCHAR(20) NULL,
    [ISIN_NAME] VARCHAR(282) NOT NULL,
    [Last_Closing_Rate] NUMERIC(18, 4) NOT NULL
);

GO
