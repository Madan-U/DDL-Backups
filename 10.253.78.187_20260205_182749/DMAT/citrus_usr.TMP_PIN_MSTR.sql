-- Object: TABLE citrus_usr.TMP_PIN_MSTR
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TMP_PIN_MSTR]
(
    [TMP_PIN_CODE] NUMERIC(18, 0) NULL,
    [TMP_DISTRICT_CODE] NUMERIC(18, 0) NULL,
    [TMP_DISTRICT_NAME] VARCHAR(100) NULL,
    [TMP_STATE_NAME] VARCHAR(200) NULL,
    [TMP_STATUS_FLAG] CHAR(1) NULL,
    [TMP_CITYREF_NO] CHAR(2) NULL
);

GO
