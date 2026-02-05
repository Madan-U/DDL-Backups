-- Object: TABLE citrus_usr.tmp_Billsummary_print
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tmp_Billsummary_print]
(
    [order_by] INT NULL,
    [dpam_id] BIGINT NULL,
    [dpam_sba_name] VARCHAR(200) NULL,
    [dpam_acctno] VARCHAR(16) NULL,
    [CDSHM_TRATM_DESC] VARCHAR(200) NULL,
    [dpm_trans_no] VARCHAR(10) NULL,
    [trans_date] DATETIME NULL,
    [ISIN_CD] VARCHAR(12) NULL,
    [isin_name] VARCHAR(100) NULL,
    [opening_bal] NUMERIC(19, 3) NULL,
    [DEBIT_QTY] NUMERIC(19, 3) NULL,
    [CREDIT_QTY] NUMERIC(19, 3) NULL,
    [closing_bal] NUMERIC(19, 3) NULL,
    [closing_qty] NUMERIC(19, 3) NULL,
    [charge_val] NUMERIC(19, 3) NULL,
    [prev_bill_bal] NUMERIC(19, 3) NULL,
    [page_cnt] INT NULL,
    [bill_due_dt] DATETIME NULL
);

GO
