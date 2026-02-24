-- Object: TABLE citrus_usr.tbl_bill_log
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tbl_bill_log]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [billing_from_dt] DATETIME NULL,
    [billing_to_dt] DATETIME NULL,
    [billing_status] CHAR(10) NULL,
    [posted_flg] CHAR(10) NULL,
    [bill_post_shw_bill] CHAR(10) NULL,
    [billing_done_by] VARCHAR(100) NULL,
    [billing_done_dt] DATETIME NULL
);

GO
