-- Object: TABLE citrus_usr.branch_mstr_cdsl_hst
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[branch_mstr_cdsl_hst]
(
    [bm_branchcd] CHAR(6) NULL,
    [bm_branchname] VARCHAR(45) NULL,
    [bm_contact] VARCHAR(45) NULL,
    [bm_add1] VARCHAR(36) NULL,
    [bm_add2] VARCHAR(36) NULL,
    [bm_add3] VARCHAR(36) NULL,
    [bm_city] VARCHAR(36) NULL,
    [bm_pin] CHAR(6) NULL,
    [bm_phone] VARCHAR(24) NULL,
    [bm_fax] VARCHAR(15) NULL,
    [bm_email] VARCHAR(75) NULL,
    [bm_allow] CHAR(1) NULL,
    [bm_batchno] NUMERIC(18, 0) NULL,
    [bm_ip_add] VARCHAR(15) NULL,
    [bm_dialup] VARCHAR(15) NULL,
    [bm_server] VARCHAR(30) NULL,
    [bm_database] VARCHAR(20) NULL,
    [bm_dbo] VARCHAR(15) NULL,
    [bm_user] VARCHAR(15) NULL,
    [bm_pwd] VARCHAR(15) NULL,
    [bm_workarea] VARCHAR(150) NULL,
    [mkrid1] CHAR(8) NULL,
    [mkrdt1] VARCHAR(8) NULL,
    [bm_percentage] NUMERIC(18, 0) NULL,
    [bm_flag] VARCHAR(2) NULL,
    [bm_type] CHAR(1) NULL,
    [bm_edittype] CHAR(1) NULL,
    [bm_cmpltd] NUMERIC(18, 0) NULL
);

GO
