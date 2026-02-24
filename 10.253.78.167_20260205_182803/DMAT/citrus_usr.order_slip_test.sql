-- Object: TABLE citrus_usr.order_slip_test
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[order_slip_test]
(
    [ors_id] NUMERIC(10, 0) NULL,
    [ors_po_no] VARCHAR(25) NULL,
    [ors_book_type] CHAR(1) NULL,
    [ors_no_of_books] NUMERIC(10, 0) NULL,
    [ors_size_of_books] INT NULL,
    [ors_from_no] BIGINT NULL,
    [ors_to_no] BIGINT NULL,
    [ors_from_slip] BIGINT NULL,
    [ors_to_slip] BIGINT NULL,
    [ors_tratm_id] BIGINT NULL,
    [ors_dpm_id] BIGINT NULL,
    [ors_series_type] VARCHAR(50) NULL,
    [ors_remarks] VARCHAR(100) NULL,
    [ors_created_dt] DATETIME NULL,
    [ors_created_by] VARCHAR(25) NULL,
    [ors_lst_upd_dt] DATETIME NULL,
    [ors_lst_upd_by] VARCHAR(25) NULL,
    [ord_deleted_ind] SMALLINT NULL,
    [ors_po_dt] DATETIME NULL
);

GO
