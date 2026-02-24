-- Object: TABLE citrus_usr.inw_client_reg
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[inw_client_reg]
(
    [inwcr_id] INT NULL,
    [inwcr_dmpdpid] VARCHAR(20) NULL,
    [inwcr_frmno] VARCHAR(25) NULL,
    [inwcr_charge_collected] NUMERIC(18, 2) NULL,
    [inwcr_rmks] VARCHAR(8000) NULL,
    [inwcr_created_by] VARCHAR(20) NULL,
    [inwcr_created_dt] DATETIME NULL,
    [inwcr_lst_upd_by] VARCHAR(20) NULL,
    [inwcr_lst_upd_dt] DATETIME NULL,
    [inwcr_deleted_ind] INT NULL,
    [INWCR_BANK_ID] NUMERIC(18, 0) NULL,
    [INWCR_NAME] VARCHAR(25) NULL,
    [INWCR_PAY_MODE] VARCHAR(15) NULL,
    [INWCR_cheque_no] VARCHAR(20) NULL,
    [INWCR_RECVD_DT] DATETIME NULL,
    [inwcr_clibank_accno] VARCHAR(20) NULL,
    [inwcr_clibank_name] VARCHAR(1000) NULL,
    [inwcr_cheque_dt] DATETIME NULL,
    [inwcr_bank_branch] VARCHAR(500) NULL
);

GO
