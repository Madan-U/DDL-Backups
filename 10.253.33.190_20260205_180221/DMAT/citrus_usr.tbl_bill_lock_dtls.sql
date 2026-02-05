-- Object: TABLE citrus_usr.tbl_bill_lock_dtls
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tbl_bill_lock_dtls]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [billing_from_dt] DATETIME NULL,
    [billing_to_dt] DATETIME NULL,
    [dp_id] VARCHAR(100) NULL,
    [billing_status] CHAR(10) NULL,
    [posted_flg] CHAR(10) NULL,
    [status] VARCHAR(100) NULL,
    [create_by] VARCHAR(100) NULL,
    [create_dt] DATETIME NULL,
    [lst_upd_by] VARCHAR(100) NULL,
    [lst_upd_dt] DATETIME NULL,
    [del_ind] SMALLINT NULL
);

GO
