-- Object: TABLE citrus_usr.DP_Transaction_Charges
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[DP_Transaction_Charges]
(
    [Trxn_date] DATETIME NULL,
    [dpam_sba_no] VARCHAR(20) NULL,
    [tradingid] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [QTY] NUMERIC(18, 5) NULL,
    [Target_Beneficiary] VARCHAR(20) NULL,
    [TRXN_Type] VARCHAR(50) NULL,
    [TRXN_Desc] VARCHAR(1000) NULL,
    [TRXN_Charge] NUMERIC(18, 3) NULL,
    [CDSL_Charge] NUMERIC(18, 4) NULL,
    [GST] NUMERIC(18, 4) NULL,
    [Total_Chrg] NUMERIC(18, 4) NULL,
    [Gender] VARCHAR(5) NULL,
    [Isin_type] VARCHAR(250) NULL,
    [ISIN_COMP_NAME] VARCHAR(150) NULL
);

GO
