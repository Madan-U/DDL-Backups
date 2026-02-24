-- Object: TABLE citrus_usr.tmp_autoreco_mstr
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tmp_autoreco_mstr]
(
    [ACC_NO] NUMERIC(15, 0) NOT NULL,
    [TRNS_DT] DATETIME NULL,
    [TRNS_ID] VARCHAR(25) NULL,
    [CHQ_NO] VARCHAR(25) NOT NULL,
    [DIS] VARCHAR(200) NULL,
    [DEBIT] NUMERIC(25, 2) NULL,
    [CREDIT] NUMERIC(25, 2) NULL,
    [BOOK_DT] DATETIME NULL,
    [FLAG] VARCHAR(10) NULL,
    [RECOFLAG] CHAR(1) NULL
);

GO
