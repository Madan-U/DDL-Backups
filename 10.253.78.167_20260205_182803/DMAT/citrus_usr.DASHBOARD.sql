-- Object: TABLE citrus_usr.DASHBOARD
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[DASHBOARD]
(
    [ID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [TASKDATE] DATETIME NULL DEFAULT (CONVERT([datetime],CONVERT([varchar](11),getdate(),(109)),(109))),
    [TASKNAME] VARCHAR(100) NULL,
    [Taskheader] VARCHAR(1000) NULL,
    [Noofrecords] NUMERIC(18, 0) NULL DEFAULT '0',
    [filler1] VARCHAR(100) NULL DEFAULT NULL,
    [filler2] VARCHAR(100) NULL DEFAULT NULL,
    [filler3] VARCHAR(100) NULL DEFAULT NULL,
    [filler4] VARCHAR(100) NULL DEFAULT NULL,
    [filler5] VARCHAR(100) NULL DEFAULT NULL,
    [created_by] VARCHAR(100) NULL DEFAULT 'MIG',
    [created_dt] DATETIME NULL DEFAULT (getdate()),
    [lst_upd_by] VARCHAR(100) NULL DEFAULT 'MIG',
    [lst_upd_dt] DATETIME NULL DEFAULT (getdate()),
    [deleted_ind] SMALLINT NULL DEFAULT '1'
);

GO
