-- Object: TABLE citrus_usr.dispatch_report_cdsl
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[dispatch_report_cdsl]
(
    [dpam_id] NUMERIC(18, 0) NULL,
    [Report_name] VARCHAR(10) NULL,
    [Dispatch_dt] DATETIME NULL,
    [Cof_recv] INT NULL,
    [Created_dt] DATETIME NULL,
    [created_by] VARCHAR(20) NULL,
    [lst_upd_dt] DATETIME NULL,
    [lst_upd_by] VARCHAR(20) NULL,
    [deleted_ind] SMALLINT NULL,
    [dispatch_mode] VARCHAR(50) NULL,
    [disp_pod_no] VARCHAR(100) NULL
);

GO
