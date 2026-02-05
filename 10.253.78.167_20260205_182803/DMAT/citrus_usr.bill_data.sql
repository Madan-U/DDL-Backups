-- Object: TABLE citrus_usr.bill_data
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[bill_data]
(
    [final_trans] INT NULL,
    [dpam_id] BIGINT NULL,
    [dpam_sba_name] VARCHAR(200) NULL,
    [dpam_acctno] CHAR(16) NULL,
    [ben_type] VARCHAR(50) NULL,
    [dpm_trans_no] VARCHAR(10) NULL,
    [TRANS_DESC] VARCHAR(200) NULL,
    [NSDHM_TRANSACTION_DT] DATETIME NULL,
    [NSDHM_ISIN] VARCHAR(20) NULL,
    [Isin_name] VARCHAR(500) NULL,
    [open_qty] NUMERIC(19, 3) NULL,
    [DEBIT_QTY] VARCHAR(50) NULL,
    [CREDIT_QTY] VARCHAR(50) NULL,
    [closing_qty] VARCHAR(50) NULL,
    [charge_val] NUMERIC(19, 3) NULL,
    [prev_bill_bal] NUMERIC(19, 3) NULL,
    [bill_due_dt] DATETIME NULL,
    [trans_date] DATETIME NULL
);

GO
