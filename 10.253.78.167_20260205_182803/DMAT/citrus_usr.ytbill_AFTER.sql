-- Object: TABLE citrus_usr.ytbill_AFTER
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[ytbill_AFTER]
(
    [trans_dt] DATETIME NULL,
    [dpam_id] NUMERIC(18, 0) NULL,
    [charge_name] VARCHAR(50) NULL,
    [charge_val] NUMERIC(18, 5) NULL,
    [post_toacct] NUMERIC(10, 0) NULL,
    [FLG] CHAR(1) NULL
);

GO
