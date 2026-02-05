-- Object: TABLE citrus_usr.dump_data_4_bill
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[dump_data_4_bill]
(
    [order_by] INT NULL,
    [dpam_id] BIGINT NULL,
    [dpam_sba_name] VARCHAR(200) NULL,
    [dpam_acctno] VARCHAR(16) NULL,
    [CDSHM_TRATM_DESC] VARCHAR(200) NULL,
    [dpm_trans_no] VARCHAR(10) NOT NULL,
    [trans_date] VARCHAR(11) NULL,
    [ISIN_CD] VARCHAR(12) NOT NULL,
    [isin_name] VARCHAR(282) NOT NULL,
    [opening_bal] VARCHAR(8000) NULL,
    [DEBIT_QTY] VARCHAR(8000) NULL,
    [CREDIT_QTY] VARCHAR(8000) NULL,
    [closing_bal] VARCHAR(8000) NULL,
    [charge_val] NUMERIC(21, 2) NULL,
    [prev_bill_bal] NUMERIC(18, 2) NOT NULL,
    [bill_due_dt] VARCHAR(11) NULL,
    [settm_id] VARCHAR(25) NOT NULL,
    [tr_settm_id] VARCHAR(25) NOT NULL,
    [tratm_cd] VARCHAR(25) NOT NULL,
    [VALUATION] NUMERIC(18, 2) NULL,
    [rate] NUMERIC(18, 4) NOT NULL
);

GO
