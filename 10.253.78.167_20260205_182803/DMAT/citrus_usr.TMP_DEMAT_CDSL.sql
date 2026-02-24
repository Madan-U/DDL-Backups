-- Object: TABLE citrus_usr.TMP_DEMAT_CDSL
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TMP_DEMAT_CDSL]
(
    [TMPDMT_DRF_NO] VARCHAR(16) NULL,
    [TMPDMT_DRN] VARCHAR(20) NULL,
    [TMPDMT_BO_ID] VARCHAR(16) NULL,
    [TMPDMT_ISIN] VARCHAR(12) NULL,
    [TMPDMT_DRF_QTY] NUMERIC(13, 3) NULL,
    [TMPDMT_FH] VARCHAR(140) NULL,
    [TMPDMT_Err_Mesg] VARCHAR(240) NULL
);

GO
