-- Object: TABLE citrus_usr.cdslbill_cisa_clos_bal
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[cdslbill_cisa_clos_bal]
(
    [boid] VARCHAR(16) NULL,
    [cm_id] VARCHAR(25) NULL,
    [exch_id] VARCHAR(10) NULL,
    [isin] VARCHAR(20) NULL,
    [isin_name] VARCHAR(250) NULL,
    [quantity] VARCHAR(25) NULL,
    [exe_dt] VARCHAR(25) NULL,
    [prod_no] VARCHAR(25) NULL,
    [noofdays] VARCHAR(25) NULL,
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
