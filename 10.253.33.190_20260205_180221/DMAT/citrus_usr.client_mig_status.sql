-- Object: TABLE citrus_usr.client_mig_status
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[client_mig_status]
(
    [clim_crn_no] NUMERIC(10, 0) NULL,
    [clim_sub_acct] VARCHAR(25) NULL,
    [excpm_id] NUMERIC(10, 0) NULL,
    [clim_tab] VARCHAR(30) NULL,
    [clim_status] NUMERIC(10, 0) NULL,
    [clim_created_dt] DATETIME NULL,
    [clim_created_by] VARCHAR(25) NULL,
    [clim_lst_upd_dt] DATETIME NULL,
    [clim_lst_upd_by] VARCHAR(25) NULL,
    [clim_e_comltd] SMALLINT NULL,
    [clim_edittype] CHAR(1) NULL
);

GO
