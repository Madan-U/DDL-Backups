-- Object: TABLE citrus_usr.fin_property_mstr_listing
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[fin_property_mstr_listing]
(
    [finpml_id] NUMERIC(18, 0) NULL,
    [finpml_finpm_id] NUMERIC(18, 0) NULL,
    [finpml_values] VARCHAR(2500) NULL,
    [finpml_created_by] VARCHAR(100) NULL,
    [finpml_created_dt] DATETIME NULL,
    [finpml_lst_upd_by] VARCHAR(100) NULL,
    [finpml_lst_upd_dt] DATETIME NULL,
    [finpml_deleted_ind] NUMERIC(18, 0) NULL
);

GO
