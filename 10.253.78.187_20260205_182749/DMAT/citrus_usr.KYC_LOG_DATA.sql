-- Object: TABLE citrus_usr.KYC_LOG_DATA
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[KYC_LOG_DATA]
(
    [ID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [CRN_NO] NUMERIC(18, 0) NULL,
    [TAB] VARCHAR(8000) NULL
);

GO
