-- Object: TABLE citrus_usr.poa_auth_mstr
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[poa_auth_mstr]
(
    [poaam_id] NUMERIC(18, 0) NULL,
    [poaam_poam_id] NUMERIC(18, 0) NULL,
    [poaam_name1] VARCHAR(100) NULL,
    [poaam_name2] VARCHAR(20) NULL,
    [poaam_name3] VARCHAR(20) NULL,
    [poaam_created_by] VARCHAR(25) NULL,
    [poaam_created_dt] DATETIME NULL,
    [poaam_lst_upd_by] VARCHAR(25) NULL,
    [poaam_lst_upd_dt] DATETIME NULL,
    [poaam_deleted_ind] SMALLINT NULL,
    [poaam_doc_path] VARCHAR(500) NULL
);

GO
