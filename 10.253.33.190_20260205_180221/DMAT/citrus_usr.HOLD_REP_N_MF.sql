-- Object: TABLE citrus_usr.HOLD_REP_N_MF
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[HOLD_REP_N_MF]
(
    [SR_NO] BIGINT NULL,
    [partycode] VARCHAR(15) NULL,
    [boid] VARCHAR(16) NULL,
    [isin] VARCHAR(20) NULL,
    [qty] FLOAT NULL,
    [ANGEL_TRXN_ID] VARCHAR(50) NULL,
    [CDSL_TRXN_Id] VARCHAR(50) NULL,
    [Request_date] DATETIME NULL,
    [SRNO] BIGINT NULL,
    [ALLOCATE_QTY] FLOAT NULL
);

GO
