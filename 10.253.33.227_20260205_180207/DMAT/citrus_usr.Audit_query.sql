-- Object: TABLE citrus_usr.Audit_query
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Audit_query]
(
    [DPHMC_HOLDING_DT] DATETIME NULL,
    [DPAM_SBA_NO] VARCHAR(20) NOT NULL,
    [DPHMC_ISIN] VARCHAR(20) NOT NULL,
    [DPHMC_CURR_QTY] NUMERIC(18, 3) NULL,
    [acc_type] VARCHAR(10) NULL,
    [price] MONEY NULL
);

GO
