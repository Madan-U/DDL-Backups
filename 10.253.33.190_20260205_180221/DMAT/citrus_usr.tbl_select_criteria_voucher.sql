-- Object: TABLE citrus_usr.tbl_select_criteria_voucher
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tbl_select_criteria_voucher]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [select_desc] VARCHAR(1000) NULL,
    [ord_by] NUMERIC(10, 0) NULL,
    [formula] VARCHAR(3000) NULL
);

GO
