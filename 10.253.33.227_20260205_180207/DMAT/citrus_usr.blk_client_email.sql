-- Object: TABLE citrus_usr.blk_client_email
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[blk_client_email]
(
    [blkce_id] INT NULL,
    [blkce_dpmdpid] VARCHAR(20) NULL,
    [blkce_rptname] VARCHAR(15) NULL,
    [blkce_entity_type] VARCHAR(10) NULL,
    [blkce_entity_id] VARCHAR(20) NULL,
    [blkce_created_by] VARCHAR(20) NULL,
    [blkce_created_dt] DATETIME NULL,
    [blkce_lst_upd_by] VARCHAR(20) NULL,
    [blkce_lst_upd_dt] DATETIME NULL,
    [blkce_deleted_ind] INT NULL
);

GO
