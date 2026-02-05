-- Object: TABLE citrus_usr.CDSL_RECON_LOG
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[CDSL_RECON_LOG]
(
    [CRL_ID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [CRL_STATUS] VARCHAR(100) NULL,
    [CRL_FILEDT] DATETIME NULL,
    [CRL_CURRDT] DATETIME NULL,
    [CRL_RECONSTATUS] VARCHAR(100) NULL
);

GO
