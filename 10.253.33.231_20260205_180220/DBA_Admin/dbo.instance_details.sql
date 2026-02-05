-- Object: TABLE dbo.instance_details
-- Server: 10.253.33.231 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[instance_details]
(
    [sql_instance] VARCHAR(255) NOT NULL,
    [sql_instance_port] VARCHAR(10) NULL,
    [is_alias] BIT NOT NULL DEFAULT ((0)),
    [source_sql_instance] VARCHAR(255) NULL,
    [host_name] VARCHAR(255) NOT NULL,
    [database] VARCHAR(255) NOT NULL,
    [collector_tsql_jobs_server] VARCHAR(255) NULL DEFAULT (CONVERT([varchar],serverproperty('MachineName'))),
    [collector_powershell_jobs_server] VARCHAR(255) NULL DEFAULT (CONVERT([varchar],serverproperty('MachineName'))),
    [data_destination_sql_instance] VARCHAR(255) NULL DEFAULT (CONVERT([varchar],serverproperty('MachineName'))),
    [dba_group_mail_id] VARCHAR(2000) NOT NULL DEFAULT 'some_dba_mail_id@gmail.com',
    [sqlmonitor_script_path] VARCHAR(2000) NOT NULL DEFAULT 'C:\SQLMonitor',
    [sqlmonitor_version] VARCHAR(20) NOT NULL DEFAULT '1.1.0'
);

GO
