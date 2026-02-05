-- Object: TABLE citrus_usr.YTEMPLEDGE2
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[YTEMPLEDGE2]
(
    [voucher_type] VARCHAR(10) NULL,
    [Voucher_no] BIGINT NOT NULL,
    [account_id] NUMERIC(19, 4) NULL,
    [account_cd] VARCHAR(16) NULL,
    [account_name] VARCHAR(200) NULL,
    [voucher_date] VARCHAR(11) NULL,
    [bank_cl_date] VARCHAR(11) NOT NULL,
    [debit] NUMERIC(18, 2) NULL,
    [credit] NUMERIC(18, 2) NULL,
    [narration] VARCHAR(274) NULL,
    [chq_no] VARCHAR(20) NOT NULL,
    [RunningAmt] NUMERIC(38, 2) NULL,
    [ord_dt] DATETIME NULL
);

GO
