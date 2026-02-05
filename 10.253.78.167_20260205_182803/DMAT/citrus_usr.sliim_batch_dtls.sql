-- Object: TABLE citrus_usr.sliim_batch_dtls
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[sliim_batch_dtls]
(
    [slibd_sliim_id] NUMERIC(18, 0) NULL,
    [slibd_batch_no] VARCHAR(100) NULL,
    [slibd_created_by] VARCHAR(100) NULL,
    [slibd_created_dt] DATETIME NULL,
    [slibd_lst_upd_by] VARCHAR(100) NULL,
    [slibd_lst_upd_dt] DATETIME NULL,
    [slibd_deleted_ind] SMALLINT NULL,
    [slibd_entity_type] VARCHAR(20) NULL,
    [slibd_DIS_type] VARCHAR(20) NULL
);

GO
