-- Object: TABLE citrus_usr.stock
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[stock]
(
    [SERIES] VARCHAR(10) NOT NULL,
    [FROMSLIPNO] NUMERIC(15, 0) NULL,
    [TOSLIPNO] NUMERIC(15, 0) NULL,
    [BENEF_ACCNO] NUMERIC(8, 0) NULL,
    [ISSUE_DATE] DATETIME NULL
);

GO
