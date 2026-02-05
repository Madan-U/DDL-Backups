-- Object: TABLE citrus_usr.courier_mstr
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[courier_mstr]
(
    [coum_id] NUMERIC(18, 0) NULL,
    [coum_no] VARCHAR(50) NULL,
    [coum_adr1] VARCHAR(50) NULL,
    [coum_adr2] VARCHAR(50) NULL,
    [coum_adr3] VARCHAR(50) NULL,
    [coum_adr_city] VARCHAR(50) NULL,
    [coum_adr_state] VARCHAR(50) NULL,
    [coum_adr_country] VARCHAR(50) NULL,
    [coum_adr_zip] VARCHAR(50) NULL,
    [coum_cont_per] VARCHAR(100) NULL,
    [coum_off_ph1] VARCHAR(25) NULL,
    [coum_off_ph2] VARCHAR(25) NULL,
    [coum_off_fax1] VARCHAR(25) NULL,
    [coum_off_fax2] VARCHAR(25) NULL,
    [coum_res_ph1] VARCHAR(25) NULL,
    [coum_res_ph2] VARCHAR(25) NULL,
    [coum_mobile] VARCHAR(25) NULL,
    [coum_email] VARCHAR(25) NULL,
    [coum_created_by] VARCHAR(25) NULL,
    [coum_created_dt] DATETIME NULL,
    [coum_lst_upd_by] VARCHAR(25) NULL,
    [coum_lst_upd_dt] DATETIME NULL,
    [coum_deleted_ind] SMALLINT NULL,
    [coum_rmks] VARCHAR(250) NULL
);

GO
