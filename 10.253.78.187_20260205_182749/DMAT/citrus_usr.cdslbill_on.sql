-- Object: TABLE citrus_usr.cdslbill_on
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[cdslbill_on]
(
    [exch_id] VARCHAR(25) NULL,
    [boid] VARCHAR(25) NULL,
    [cm_id] VARCHAR(25) NULL,
    [prod_no] VARCHAR(25) NULL,
    [isin] VARCHAR(25) NULL,
    [isin_name] VARCHAR(250) NULL,
    [qty] VARCHAR(25) NULL,
    [dr_cr] VARCHAR(25) NULL,
    [exec_dt] VARCHAR(25) NULL,
    [settl_id] VARCHAR(25) NULL,
    [isin_rate] VARCHAR(25) NULL,
    [trans_value] VARCHAR(25) NULL,
    [charge_rate] VARCHAR(25) NULL,
    [bill_amount] VARCHAR(25) NULL,
    [billmonth] NUMERIC(18, 0) NULL,
    [billyear] NUMERIC(18, 0) NULL,
    [createdby] VARCHAR(100) NULL,
    [createddt] DATETIME NULL,
    [lstupdby] VARCHAR(100) NULL,
    [lstupddt] DATETIME NULL,
    [deleted_ind] SMALLINT NULL
);

GO
