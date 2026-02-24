-- Object: TABLE citrus_usr.TMP_NAV_MSTR
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TMP_NAV_MSTR]
(
    [TMPNAV_ID] NUMERIC(18, 0) NULL,
    [TMPNAV_FILEDATE] DATETIME NULL,
    [TMPNAV_DATE] DATETIME NULL,
    [TMPNAV_ISIN] VARCHAR(12) NULL,
    [TMPNAV_RATE] FLOAT NULL
);

GO
