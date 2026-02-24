-- Object: TABLE citrus_usr.cham_mak
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[cham_mak]
(
    [cham_slab_no] NUMERIC(10, 0) NULL,
    [cham_slab_name] VARCHAR(150) NULL,
    [cham_charge_type] VARCHAR(50) NULL,
    [cham_charge_base] VARCHAR(25) NULL,
    [cham_bill_period] VARCHAR(25) NULL,
    [cham_bill_interval] CHAR(1) NULL,
    [cham_charge_baseon] CHAR(2) NULL,
    [cham_from_factor] VARCHAR(25) NULL,
    [cham_to_factor] VARCHAR(25) NULL,
    [cham_val_pers] CHAR(1) NULL,
    [cham_charge_value] NUMERIC(10, 0) NULL,
    [cham_charge_minval] NUMERIC(10, 0) NULL,
    [cham_charge_graded] INT NULL,
    [cham_chargebitfor] NUMERIC(10, 0) NULL,
    [cham_remarks] VARCHAR(250) NULL,
    [cham_created_by] VARCHAR(25) NULL,
    [cham_created_dt] DATETIME NULL,
    [cham_lst_upd_by] VARCHAR(25) NULL,
    [cham_lst_upd_dt] DATETIME NULL,
    [cham_deleted_ind] SMALLINT NULL,
    [cham_dtls_id] NUMERIC(10, 0) NULL,
    [CHAM_POST_TOACCT] NUMERIC(10, 0) NULL,
    [CHAM_PER_MIN] NUMERIC(18, 0) NULL,
    [CHAM_PER_MAX] NUMERIC(18, 0) NULL
);

GO
