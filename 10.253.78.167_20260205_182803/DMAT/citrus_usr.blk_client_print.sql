-- Object: TABLE citrus_usr.blk_client_print
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[blk_client_print]
(
    [blkcp_id] INT NULL,
    [blkcp_dpmdpid] VARCHAR(20) NULL,
    [blkcp_rptname] VARCHAR(15) NULL,
    [blkcp_entity_type] VARCHAR(10) NULL,
    [blkcp_entity_id] VARCHAR(20) NULL,
    [blkcp_created_by] VARCHAR(20) NULL,
    [blkcp_created_dt] DATETIME NULL,
    [blkcp_lst_upd_by] VARCHAR(20) NULL,
    [blkcp_lst_upd_dt] DATETIME NULL,
    [blkcp_deleted_ind] INT NULL
);

GO
