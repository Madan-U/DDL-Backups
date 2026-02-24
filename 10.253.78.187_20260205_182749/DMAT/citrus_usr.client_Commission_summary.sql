-- Object: TABLE citrus_usr.client_Commission_summary
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[client_Commission_summary]
(
    [amc_date] DATETIME NULL,
    [carry_date] DATETIME NULL,
    [n_r] CHAR(1) NULL,
    [dpam_sba_no] VARCHAR(20) NULL,
    [dpam_sba_name] VARCHAR(100) NULL,
    [brom_cd] VARCHAR(100) NULL,
    [amc_charge] NUMERIC(18, 3) NULL,
    [Commission_paid] NUMERIC(18, 3) NULL,
    [branch_id] VARCHAR(100) NULL,
    [Outstanding] NUMERIC(18, 3) NULL,
    [created_by] VARCHAR(100) NULL,
    [created_dt] DATETIME NULL,
    [lst_upd_by] VARCHAR(100) NULL,
    [lst_upd_dt] DATETIME NULL,
    [deleted_ind] SMALLINT NULL
);

GO
