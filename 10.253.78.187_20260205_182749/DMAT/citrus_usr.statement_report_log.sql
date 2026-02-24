-- Object: TABLE citrus_usr.statement_report_log
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[statement_report_log]
(
    [run_date] DATETIME NULL,
    [dptype] VARCHAR(4) NULL,
    [excsmid] INT NULL,
    [fromdate] DATETIME NULL,
    [todate] DATETIME NULL,
    [bulk_printflag] CHAR(1) NULL,
    [stopbillclients_flag] CHAR(1) NULL,
    [fromaccid] VARCHAR(16) NULL,
    [toaccid] VARCHAR(16) NULL,
    [isincd] VARCHAR(12) NULL,
    [group_cd] VARCHAR(10) NULL,
    [transclientsonly] CHAR(1) NULL,
    [Hldg_Yn] CHAR(1) NULL,
    [login_pr_entm_id] NUMERIC(18, 0) NULL,
    [login_entm_cd_chain] VARCHAR(8000) NULL,
    [settm_type] VARCHAR(80) NULL,
    [settm_no_fr] VARCHAR(80) NULL,
    [settm_no_to] VARCHAR(80) NULL,
    [WITHVALUE] CHAR(1) NULL,
    [output] VARCHAR(8000) NULL
);

GO
