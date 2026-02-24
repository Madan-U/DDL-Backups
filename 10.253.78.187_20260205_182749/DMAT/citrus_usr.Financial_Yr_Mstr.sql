-- Object: TABLE citrus_usr.Financial_Yr_Mstr
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Financial_Yr_Mstr]
(
    [FIN_ID] NUMERIC(10, 0) NOT NULL,
    [FIN_DPM_ID] NUMERIC(10, 0) NULL,
    [FIN_START_DT] DATETIME NULL,
    [FIN_END_DT] DATETIME NULL,
    [FIN_CF_BALANCES] CHAR(1) NULL,
    [FIN_CREATED_BY] VARCHAR(25) NOT NULL,
    [FIN_CREATED_DT] DATETIME NOT NULL,
    [FIN_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [FIN_LST_UPD_DT] DATETIME NOT NULL,
    [FIN_DELETED_IND] SMALLINT NOT NULL,
    [VchNo_Payment] NUMERIC(18, 0) NULL,
    [VchNo_Reciept] NUMERIC(18, 0) NULL,
    [VchNo_Jv] NUMERIC(18, 0) NULL,
    [VchNo_Contra] NUMERIC(18, 0) NULL,
    [VchNo_Bill] NUMERIC(18, 0) NULL,
    [Ledger_currid] NUMERIC(18, 0) NULL
);

GO
