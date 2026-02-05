-- Object: TABLE citrus_usr.client_list_modified_bak_dnd
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[client_list_modified_bak_dnd]
(
    [clic_mod_dpam_sba_no] VARCHAR(16) NULL,
    [clic_mod_pan_no] VARCHAR(16) NULL,
    [clic_mod_action] VARCHAR(250) NULL,
    [clic_mod_from_dt] DATETIME NULL,
    [clic_mod_to_dt] DATETIME NULL,
    [clic_mod_created_by] VARCHAR(100) NULL,
    [clic_mod_created_dt] DATETIME NULL,
    [clic_mod_lst_upd_by] VARCHAR(100) NULL,
    [clic_mod_lst_upd_dt] DATETIME NULL,
    [clic_mod_deleted_ind] INT NULL,
    [clic_mod_batch_no] NUMERIC(9, 0) NULL,
    [type] VARCHAR(39) NOT NULL,
    [dt] DATETIME NOT NULL
);

GO
