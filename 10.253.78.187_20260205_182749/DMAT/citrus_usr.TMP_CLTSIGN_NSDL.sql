-- Object: TABLE citrus_usr.TMP_CLTSIGN_NSDL
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TMP_CLTSIGN_NSDL]
(
    [TMPSIGN_REF_NO] VARCHAR(10) NULL,
    [TMPSIGN_HLDR_IND] INT NULL,
    [TMPSIGN_AUTH_NM] VARCHAR(135) NULL,
    [TMPSIGN_SBA_NO] VARCHAR(135) NULL,
    [cli_image] VARBINARY(MAX) NULL
);

GO
