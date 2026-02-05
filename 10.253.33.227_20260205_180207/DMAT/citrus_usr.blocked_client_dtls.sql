-- Object: TABLE citrus_usr.blocked_client_dtls
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[blocked_client_dtls]
(
    [blocd_id] NUMERIC(18, 0) NULL,
    [blocd_dpam_sba_no] VARCHAR(100) NULL,
    [blocd_blocked_from] DATETIME NULL,
    [blocd_blocked_to] DATETIME NULL,
    [blocd_blocked_narr] VARCHAR(2500) NULL,
    [blocd_blocked_rmks] VARCHAR(2500) NULL,
    [blocd_blocked_flag] VARCHAR(20) NULL,
    [blocd_created_by] VARCHAR(20) NULL,
    [blocd_created_dt] DATETIME NULL,
    [blocd_lst_upd_by] VARCHAR(20) NULL,
    [blocd_lst_upd_dt] DATETIME NULL,
    [blocd_deleted_ind] SMALLINT NULL
);

GO
