-- Object: TABLE citrus_usr.tmp_cdslbill_pldg_setup_pledgor
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tmp_cdslbill_pldg_setup_pledgor]
(
    [pledgee_bo_id] VARCHAR(25) NULL,
    [pledgee_bo_name] VARCHAR(250) NULL,
    [pledgee_product_no] VARCHAR(25) NULL,
    [pledgor_bo_id] VARCHAR(25) NULL,
    [pledgor_bo_name] VARCHAR(250) NULL,
    [pledgor_product_no] VARCHAR(25) NULL,
    [setup_date] VARCHAR(25) NULL,
    [isin] VARCHAR(25) NULL,
    [isin_name] VARCHAR(250) NULL,
    [quantity] VARCHAR(25) NULL,
    [execute_date] VARCHAR(25) NULL,
    [isin_rate] VARCHAR(25) NULL,
    [transaction_value] VARCHAR(25) NULL,
    [pledgee_charge_rate] VARCHAR(25) NULL,
    [pledgee_bill_amt] VARCHAR(25) NULL,
    [pledgor_charge_rate] VARCHAR(25) NULL,
    [pledgor_bill_amt] VARCHAR(25) NULL
);

GO
