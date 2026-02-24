-- Object: TABLE citrus_usr.Client_lasttrx
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Client_lasttrx]
(
    [CDSHM_BEN_ACCT_NO] VARCHAR(16) NULL,
    [CDSHM_DPAM_ID] NUMERIC(10, 0) NULL,
    [maxtrxdt] DATETIME NOT NULL
);

GO
