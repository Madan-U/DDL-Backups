-- Object: TABLE citrus_usr.cdslbill_cisa_ovrd_cr
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[cdslbill_cisa_ovrd_cr]
(
    [boid] VARCHAR(16) NULL,
    [cm_id] VARCHAR(25) NULL,
    [prod_no] VARCHAR(25) NULL,
    [isin] VARCHAR(25) NULL,
    [isin_name] VARCHAR(250) NULL,
    [qty] VARCHAR(25) NULL,
    [dr_cr] VARCHAR(25) NULL,
    [exec_dt] VARCHAR(25) NULL,
    [ctr_bo_prod_no] VARCHAR(25) NULL,
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
