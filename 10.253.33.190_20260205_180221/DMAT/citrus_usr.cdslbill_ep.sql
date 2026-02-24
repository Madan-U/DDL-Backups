-- Object: TABLE citrus_usr.cdslbill_ep
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[cdslbill_ep]
(
    [dp_id] VARCHAR(16) NULL,
    [fr_bo_id] VARCHAR(16) NULL,
    [fr_cm_id] VARCHAR(25) NULL,
    [fr_prod_no] VARCHAR(25) NULL,
    [fr_trad_id] VARCHAR(25) NULL,
    [fr_exch_id] VARCHAR(25) NULL,
    [ch_id] VARCHAR(25) NULL,
    [to_bo_id] VARCHAR(25) NULL,
    [to_cm_id] VARCHAR(25) NULL,
    [to_prod_no] VARCHAR(25) NULL,
    [to_trad_id] VARCHAR(25) NULL,
    [to_exch_id] VARCHAR(25) NULL,
    [sett_id] VARCHAR(25) NULL,
    [trans_id] VARCHAR(25) NULL,
    [isin] VARCHAR(25) NULL,
    [isin_name] VARCHAR(250) NULL,
    [quantity] VARCHAR(25) NULL,
    [exec_dt] VARCHAR(25) NULL,
    [isin_rate] VARCHAR(25) NULL,
    [trans_value] VARCHAR(25) NULL,
    [charge_rate] VARCHAR(25) NULL,
    [bill_amt] VARCHAR(25) NULL,
    [billmonth] NUMERIC(18, 0) NULL,
    [billyear] NUMERIC(18, 0) NULL,
    [createdby] VARCHAR(100) NULL,
    [createddt] DATETIME NULL,
    [lstupdby] VARCHAR(100) NULL,
    [lstupddt] DATETIME NULL,
    [deleted_ind] SMALLINT NULL
);

GO
