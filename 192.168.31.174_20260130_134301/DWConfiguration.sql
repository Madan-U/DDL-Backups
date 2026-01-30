-- DDL Export
-- Server: 192.168.31.174
-- Database: DWConfiguration
-- Exported: 2026-01-30T13:43:09.499785

USE DWConfiguration;
GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.compute_node
-- --------------------------------------------------
ALTER TABLE [dbo].[compute_node] ADD CONSTRAINT [PK_compute_node] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.configuration_properties
-- --------------------------------------------------
ALTER TABLE [dbo].[configuration_properties] ADD CONSTRAINT [PK_configuration_properties] PRIMARY KEY ([id], [key])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.database_file
-- --------------------------------------------------
ALTER TABLE [dbo].[database_file] ADD CONSTRAINT [PK_database_file] PRIMARY KEY ([sequence], [filegroup_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.distribution
-- --------------------------------------------------
ALTER TABLE [dbo].[distribution] ADD CONSTRAINT [PK_distribution] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.filegroup
-- --------------------------------------------------
ALTER TABLE [dbo].[filegroup] ADD CONSTRAINT [PK_filegroup] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.node
-- --------------------------------------------------
ALTER TABLE [dbo].[node] ADD CONSTRAINT [PK_node] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.pdw_sp_configure
-- --------------------------------------------------
ALTER TABLE [dbo].[pdw_sp_configure] ADD CONSTRAINT [PK_name] PRIMARY KEY ([name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.version_history
-- --------------------------------------------------
ALTER TABLE [dbo].[version_history] ADD CONSTRAINT [PK_version_history] PRIMARY KEY ([version])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_pdw_polybase_authorize
-- --------------------------------------------------

CREATE PROCEDURE [sp_pdw_polybase_authorize]
    -- Parameters
    @AppName nvarchar(max)
    AS
        SET NOCOUNT ON;
        EXEC [sp_polybase_authorize] @AppName;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_pdw_sm_detach
-- --------------------------------------------------

CREATE PROCEDURE [sp_pdw_sm_detach]
    -- Parameters
    @FileName nvarchar(45)  -- shared memory name
    AS
        SET NOCOUNT ON;
        EXEC [sp_sm_detach] @FileName;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpgradeDWConfiguration
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[UpgradeDWConfiguration]
	-- Parameters
	@StoredVer INT, -- Currently stored version in the version_history table
	@DatabaseName NVARCHAR(MAX) -- Name of the Database to modify.  It is important to keep this generic to accommodate both setup and Backup/Restore
	AS
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		-- Constants

		-- Work Variables
		DECLARE @ErrorMessage NVARCHAR(MAX);
		DECLARE @Sql NVARCHAR(MAX);

		------------------------------------------------------------------------------------------
		-- Validate All Input Parameters
		------------------------------------------------------------------------------------------

		-- Make sure the database exists.
		PRINT N'Database name is: ' + @DatabaseName;

		if DB_ID(@DatabaseName) IS NULL
		BEGIN
			SET @ErrorMessage = N'ERROR: Database "' + @DatabaseName + N'" does not exist.'
			raiserror(@ErrorMessage,16,1);
			return -1;
		END

		-- IMPORTANT!!! Specify the changes required for execution during Madison upgrade.
		-- For every NON-rerunnable change that is added, the @CurrentScriptVer value
		-- needs to match the version number specified in the condition below.
	    -- This will guarantee that the change is only executed once.
		--
		-- For example, if making a change after version 1 is released, roll @CurrentScriptVer = 2 and
		-- ADD another IF block, "IF (@StoredVer < 2) BEGIN ... statements ... END"
		-- On error, use raiserror to return the error back to the caller.
		IF (@StoredVer < 1)
		BEGIN
			-- Specify NON-rerunnable changes here; i.e. the changes that should be executed only once,
			-- when this particular version of the script is executed
			-- or when a fresh install is being executed
			PRINT N'Current Version:' + CAST(@StoredVer AS nvarchar(10))

		END

		-- Specify rerunnable changes here;
		-- these changes can be executed during every upgrade, not just once

		-- VSTS: 503618 - MSFT: EDW SSIS Package Cancels without error (increase pending queue length to 40)
		UPDATE [DWConfiguration].[dbo].[configuration_properties] set [value]='40' where [id]='Dms' and [key]='MaximumQueuedLoadingSessions';

		-- Add special extended property that holds the value of PdwObjectId for tempdb logical database.
		-- DWConfiguration was convenient for placing this extended property.
		-- We could not simply attach the standard PDWOBJECTID_PROPERTY to tempdb because it would get lost after Sql Server restart on the shell node.
		-- Master is not suitable because of possibility of backup/restore.
		IF NOT EXISTS (SELECT * from fn_listextendedproperty(N'pdw_tempdb_physical_name', default, default, default, default, default, default))
			EXEC sp_addextendedproperty @name='pdw_tempdb_physical_name', @value='pdwtempdb1';

		IF (@StoredVer < 3)
		BEGIN
			-- VSTS: 516549 - Race conditions in DMSManager code can result in possible unexpected data movement errors
			DELETE from [DWConfiguration].[dbo].[configuration_properties] where [id]='Dms' and [key]='MaximumPlanSize';
			DELETE from [DWConfiguration].[dbo].[configuration_properties] where [id]='Dms' and [key]='MinimumManagerThreadPool';
			DELETE from [DWConfiguration].[dbo].[configuration_properties] where [id]='Dms' and [key]='MaximumManagerThreadPool';
		END

		IF (@StoredVer < 29)
		BEGIN
			-- VSTS: 617786 - ICE: Query failed with "Connection forcibly closed" and "Timeout expired messages".
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET [value] = REPLACE ([value],'MultipleActiveResultSets=True','MultipleActiveResultSets=True;Connection Timeout=2147483647')
			WHERE [id] = 'Server' AND [key] = 'DWAuthenticationEntities';

			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET [value] = REPLACE ([value],'MultipleActiveResultSets=True','MultipleActiveResultSets=True;Connection Timeout=2147483647')
			WHERE [id] = 'Server' AND [key] = 'FileGroupsEntities';

			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET [value] = REPLACE ([value],'MultipleActiveResultSets=True','MultipleActiveResultSets=True;Connection Timeout=2147483647')
			WHERE [id] = 'Server' AND [key] = 'NodesEntityModel';

			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET [value] = [value] + ';Connection Timeout=2147483647'
			WHERE [id] = 'Server' AND [key] = 'DatabaseSchemaManagerConnString';

			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET [value] = [value] + ';Connection Timeout=2147483647'
			WHERE [id] = 'Server' AND [key] = 'TransactionManagerConnectionString';
		END

		IF (@StoredVer < 35)
		BEGIN
			-- VSTS 659757 - Use Named Pipes for connections to control node metadata services

			DECLARE @SERVER_NAME NVARCHAR(MAX);
			SET @SERVER_NAME = @@SERVERNAME;

			DECLARE @SERVICE_NAME NVARCHAR(MAX);
			SET @SERVICE_NAME = @@SERVICENAME;

			DECLARE @CONTROL_NODE_NAME NVARCHAR(MAX);
			SET @CONTROL_NODE_NAME = REPLACE(@SERVER_NAME, '\'+ @SERVICE_NAME, '');

			DECLARE @SERVER_NAME_DATASOURCE NVARCHAR(MAX);
			SET @SERVER_NAME_DATASOURCE = N'Data Source=' + @SERVER_NAME;

			DECLARE @NAMED_PIPE_DATASOURCE NVARCHAR(MAX);
			SET @NAMED_PIPE_DATASOURCE = N'Data Source=\\.\pipe\$$\' + @CONTROL_NODE_NAME+ N'\MSSQL$' + @SERVICE_NAME+ N'\sql\query';

			-- Update Persisted Schema
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET [value] = REPLACE ([value], @SERVER_NAME_DATASOURCE, @NAMED_PIPE_DATASOURCE)
			WHERE [id] = 'Server' AND [key] = 'DatabaseSchemaManagerConnString';

			-- Update Security
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET [value] = REPLACE ([value], @SERVER_NAME_DATASOURCE, @NAMED_PIPE_DATASOURCE)
			WHERE [id] = 'Server' AND [key] = 'DWAuthenticationEntities';

			-- Update File Group Manager
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET [value] = REPLACE ([value], @SERVER_NAME_DATASOURCE, @NAMED_PIPE_DATASOURCE)
			WHERE [id] = 'Server' AND [key] = 'FileGroupsEntities';

			-- Update Node Manager
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET [value] = REPLACE ([value], @SERVER_NAME_DATASOURCE, @NAMED_PIPE_DATASOURCE)
			WHERE [id] = 'Server' AND [key] = 'NodesEntityModel';

			-- Update Transaction State Manager
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET [value] = REPLACE ([value], @SERVER_NAME_DATASOURCE, @NAMED_PIPE_DATASOURCE)
			WHERE [id] = 'Server' AND [key] = 'TransactionManagerConnectionString';
		END;

		IF (@StoredVer < 36)
		BEGIN
			-- VSTS 694381 - DWLoader should issue 4MB cached reads when reading from the LZ disk array.

			-- Size of individual buffer pool for each LoadDistributor instance (as # of buffers per node)
			IF  NOT EXISTS (SELECT * from [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = N'Dms' AND [key] = N'DistributorBuffersPerNode')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'DistributorBuffersPerNode', NULL, N'3', 0, 0, N'int');

			-- Factor for sizing LoadFile buffer (as multiple of # of Distributor buffers)
			IF  NOT EXISTS (SELECT * from [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = N'Dms' AND [key] = N'LoadFileSizeMultiple')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'LoadFileSizeMultiple', NULL, N'16', 0, 0, N'int');

		END;

		IF (@StoredVer < 38)
		BEGIN
			-- VSTS 731912: add a connection string to execute query on the master database.
			IF  NOT EXISTS (SELECT * from [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = N'Server' AND [key] = N'SqlCommandConfigurationConnString')
			BEGIN

				DECLARE @CONT_NODE_NAME NVARCHAR(MAX) = REPLACE(@@SERVERNAME, '\'+ @@SERVICENAME, '');

				DECLARE @SERVER_NAME_DS NVARCHAR(MAX) = N'Data Source=localhost';

				DECLARE @NAMED_PIPE_DS NVARCHAR(MAX) = N'Data Source=\\.\pipe\$$\' + @CONT_NODE_NAME + N'\MSSQL$' + @@SERVICENAME + N'\sql\query';

				DECLARE @OTHER_CONN_ATTRIBUTES NVARCHAR(MAX) = N';Initial Catalog=master;Integrated Security=True;MultipleActiveResultSets=True;Connection Timeout=2147483647';

				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype])
				VALUES (N'Server', N'SqlCommandConfigurationConnString', @NAMED_PIPE_DS + @OTHER_CONN_ATTRIBUTES, @SERVER_NAME_DS + @OTHER_CONN_ATTRIBUTES, 0, 0, N'string');
			END
		END;

		-- IMPORTANT NOTE: StoredVer:39 is not done in this script.  It is done using the UpgradeLibraryComponent.  Change 39
		-- converts DWSchema to Shell Databases.  Version 39 is the first offical build number of AU3

		-- Stored version 40 is an aggregate of all the changes that were made during the chrysalis work.
		IF (@StoredVer < 40)
		BEGIN
			-- VSTS 731498: Expose master database
			IF ('Polybase' = 'Aps')
			BEGIN
			  SET @Sql=
			  '
				  USE master;
				  IF EXISTS (SELECT * from fn_listextendedproperty(N''pdw_physical_name'', default, default, default, default, default, default))
					  EXEC [master].sys.sp_dropextendedproperty @name=N''pdw_physical_name''
			  ';
			  EXECUTE(@Sql);
			  EXEC [master].sys.sp_addextendedproperty @name='pdw_physical_name', @value='master'
			END

			-- Add SqlServerInstancePath property to configuration_properties
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'SqlServerInstancePath')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Server', N'SqlServerInstancePath', NULL, N'G:\MSSQL10.SQLCTL01', 0, 0, N'string')

			-- Alter filegroup table to include "is_shell" column and insert the shell filgroups and database files.
			IF NOT EXISTS (select * from sys.columns where Name = N'is_shell' and Object_ID = Object_ID(N'[DWConfiguration].[dbo].[filegroup]'))
			BEGIN
				ALTER TABLE [DWConfiguration].[dbo].[filegroup] ADD [is_shell] bit NOT NULL DEFAULT 0;

				-- Add shell filegroup entries to filegroup table
				exec sp_executesql N'INSERT INTO [DWConfiguration].[dbo].[filegroup]
					([id]
					,[name]
					,[distribution_id]
					,[min_filesize]
					,[max_filesize]
					,[default_filegrowth]
					,[type]
					,[is_shell])
				VALUES
					(11
					,''PRIMARY''
					,NULL
					,''4MB''
					,''50MB''
					,''10%''
					,0
					,1);'

				exec sp_executesql N'INSERT INTO [DWConfiguration].[dbo].[filegroup]
					([id]
					,[name]
					,[distribution_id]
					,[min_filesize]
					,[max_filesize]
					,[default_filegrowth]
					,[type]
					,[is_shell])
				VALUES
					(12
					,''DIST''
					,1
					,''1MB''
					,''50MB''
					,''4MB''
					,1
					,1);'

				exec sp_executesql N'INSERT INTO [DWConfiguration].[dbo].[filegroup]
					([id]
					,[name]
					,[distribution_id]
					,[min_filesize]
					,[max_filesize]
					,[default_filegrowth]
					,[type]
					,[is_shell])
				VALUES
					(13
					,''REPLICATED''
					,NULL
					,''1MB''
					,''50MB''
					,''4MB''
					,2
					,1);'

				exec sp_executesql N'INSERT INTO [DWConfiguration].[dbo].[filegroup]
					([id]
					,[name]
					,[distribution_id]
					,[min_filesize]
					,[max_filesize]
					,[default_filegrowth]
					,[type]
					,[is_shell])
				VALUES
					(14
					,''LOG''
					,NULL
					,''1MB''
					,''100MB''
					,''10%''
					,3
					,1);'

				-- Add shell database file entries to database_file table

				INSERT INTO [DWConfiguration].[dbo].[database_file]
					([filegroup_id]
					,[sequence]
					,[root_path]
					,[is_add_from_alter]
					,[percent_allocated_space])
				VALUES
					(11
					,18
					,'[SQL_INSTANCE_PATH]\MSSQL\DATA'
					,0
					,NULL);

				INSERT INTO [DWConfiguration].[dbo].[database_file]
					([filegroup_id]
					,[sequence]
					,[root_path]
					,[is_add_from_alter]
					,[percent_allocated_space])
				VALUES
					(12
					,19
					,'[SQL_INSTANCE_PATH]\MSSQL\DATA'
					,0
					,NULL);

				INSERT INTO [DWConfiguration].[dbo].[database_file]
					([filegroup_id]
					,[sequence]
					,[root_path]
					,[is_add_from_alter]
					,[percent_allocated_space])
				VALUES
					(13
					,20
					,'[SQL_INSTANCE_PATH]\MSSQL\DATA'
					,0
					,NULL);

				INSERT INTO [DWConfiguration].[dbo].[database_file]
					([filegroup_id]
					,[sequence]
					,[root_path]
					,[is_add_from_alter]
					,[percent_allocated_space])
				VALUES
					(14
					,21
					,'[SQL_INSTANCE_PATH]\MSSQL\DATA'
					,0
					,NULL);
			END

			-- Create the sysdiag schema in master to support diagnostics sessions
			IF ('Polybase' = 'Aps')
			BEGIN
				IF NOT EXISTS (SELECT * from master.sys.schemas WHERE name = N'sysdiag')
				BEGIN
					EXEC master.sys.sp_executesql N'CREATE SCHEMA [sysdiag]';
				END;
			END;
		END;

		IF (@StoredVer < 42)
		BEGIN
			-- Add CostModel properties to configuration_properties
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'CostModel' AND [key] = 'NetworkCost')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'CostModel', N'NetworkCost', NULL, N'0.000000001', 0, 0, N'double')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'CostModel' AND [key] = 'InsBulkCpyCost')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'CostModel', N'InsBulkCpyCost', NULL, N'0.00024', 0, 0, N'double')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'CostModel' AND [key] = 'WriterCost')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'CostModel', N'WriterCost', NULL, N'0.00003', 0, 0, N'double')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'CostModel' AND [key] = 'ReaderPackCost')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'CostModel', N'ReaderPackCost', NULL, N'0.00001', 0, 0, N'double')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'CostModel' AND [key] = 'ReaderHashCost')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'CostModel', N'ReaderHashCost', NULL, N'0.00021', 0, 0, N'double')
		END

		IF (@StoredVer < 43)
		BEGIN
			-- Define base connection string to be used for shell connection using named pipes.
			IF NOT EXISTS
			(
				SELECT *
				FROM [DWConfiguration].[dbo].[configuration_properties]
				WHERE [id] = N'Server' AND [key] = N'ShellConnectionDataSource'
			)
			BEGIN
				-- Extract the node name from the full name of the SQL instance.
				DECLARE @ControlNodeName NVARCHAR(MAX) = REPLACE(@@SERVERNAME, '\'+ @@SERVICENAME, '');

				-- We need a default value for single node instances.
				DECLARE @SingleNodeDataSource NVARCHAR(MAX) = N'\\.\pipe\sql\query';

				-- Construct the actual appliance version of the shell connection string.
				DECLARE @ApplianceDataSource NVARCHAR(MAX) = N'\\.\pipe\$$\' + @ControlNodeName + N'\MSSQL$' + @@SERVICENAME + N'\sql\query';

				-- Add the server property to DWConfiguration database.
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype])
				VALUES (N'Server', N'ShellConnectionDataSource', @ApplianceDataSource, @SingleNodeDataSource, 0, 0, N'string');
			END
		END;

		IF (@StoredVer < 44)
		BEGIN
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'IndexWithClauseForUserTempTable')
			INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Server', N'IndexWithClauseForUserTempTable', NULL, N'DATA_COMPRESSION = PAGE,PAD_INDEX = OFF,SORT_IN_TEMPDB = ON,IGNORE_DUP_KEY = OFF,STATISTICS_NORECOMPUTE = OFF,DROP_EXISTING = OFF,ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON', 0, 0, N'string')
		END

		IF (@StoredVer < 47)
		BEGIN
			-- Add shell filegroup entries to filegroup table
			exec sp_executesql N'UPDATE [DWConfiguration].[dbo].[filegroup]
			SET min_filesize = ''4MB'', max_filesize = ''UNLIMITED'', default_filegrowth = ''10%''
			WHERE name = ''PRIMARY'' AND is_shell = 1';

			exec sp_executesql N'UPDATE [DWConfiguration].[dbo].[filegroup]
			SET min_filesize = ''1MB'', max_filesize = ''1MB'', default_filegrowth = ''0%''
			WHERE name = ''DIST'' AND is_shell = 1';

			exec sp_executesql N'UPDATE [DWConfiguration].[dbo].[filegroup]
			SET min_filesize = ''1MB'', max_filesize = ''1MB'', default_filegrowth = ''0%''
			WHERE name = ''REPLICATED'' AND is_shell = 1';

			exec sp_executesql N'UPDATE [DWConfiguration].[dbo].[filegroup]
			SET min_filesize = ''4MB'', max_filesize = ''UNLIMITED'', default_filegrowth = ''10%''
			WHERE name = ''LOG'' AND is_shell = 1';
		END;

		-- The Max Pool is being set to:
		-- LocalQueriesConcurrencyResource (100) + UserConcurrencyResource (32) + 3 (for overhead) = 135.
		-- See VSTS 855192 for more info.
		IF (@StoredVer < 50)
		BEGIN
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
				SET [value] = [value] + ';Max Pool Size=135'
				WHERE [id] = 'Server' AND [key] = 'TransactionManagerConnectionString';
		END

		IF (@StoredVer < 54)
		BEGIN
			-- VSTS: 874082 - Decrease the number of distributor buffers: too much memory being used on large appliance during a load
			UPDATE [DWConfiguration].[dbo].[configuration_properties] set [value]='6' where [id]='Dms' and [key]='DistributorBuffersPerNode';
		END

		-- Add MaxConcurrencyExecutionCount if it does not exist  (Used by backup/restore throttling).
		IF (@StoredVer < 55)
		BEGIN
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE id = 'Server' AND [key] = 'MaxConcurrencyExecutionCount')
				INSERT INTO [DWConfiguration].[dbo].[configuration_properties] (id, [key], value, [default], protection, access, datatype) VALUES ('Server', 'MaxConcurrencyExecutionCount', null, 4, 0, 0, 'int');
		END

		IF (@StoredVer < 57)
		BEGIN
			-- VSTS: 890241 - A large amount of rejects generated from concurrent loads can cause loads to appear hung.
			-- Increase the RejectWriterQueueSize high enough so that a queue full condition will never be experienced.
			UPDATE [DWConfiguration].[dbo].[configuration_properties] set [value]='10000' where [id]='Dms' and [key]='RejectWriterQueueSize';

			-- Increase the ConverterQueueSize to match maximum possible # of buffers produced by load distributor for a single plan.
			-- This prevents a queue full condition in the LoadConverterQueue, which could have an adverse affect on concurrency.
			UPDATE [DWConfiguration].[dbo].[configuration_properties] set [value]='12' where [id]='Dms' and [key]='ConverterQueueSize';

		END

		IF (@StoredVer < 60)
		-- Disable asynchronous processing on connection strings
		BEGIN
			DECLARE @SEARCH_STRING NVARCHAR(MAX)
			DECLARE @REPLACEMENT_STRING NVARCHAR(MAX)

			SET @SEARCH_STRING = 'Asynchronous Processing=True'
			SET @REPLACEMENT_STRING = 'Asynchronous Processing=False'

			-- Update Persisted Schema Connection String
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = REPLACE ([default], @SEARCH_STRING, @REPLACEMENT_STRING),
				[value] = REPLACE ([value], @SEARCH_STRING, @REPLACEMENT_STRING)
			WHERE [id] = 'Server' AND [key] = 'DatabaseSchemaManagerConnString';

			-- Update Transaction State Manager Connection String
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = REPLACE ([default], @SEARCH_STRING, @REPLACEMENT_STRING),
				[value] = REPLACE ([value], @SEARCH_STRING, @REPLACEMENT_STRING)
			WHERE [id] = 'Server' AND [key] = 'TransactionManagerConnectionString';

			-- Update Control Node Connection String
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = REPLACE ([default], @SEARCH_STRING, @REPLACEMENT_STRING),
				[value] = REPLACE ([value], @SEARCH_STRING, @REPLACEMENT_STRING)
			WHERE [id] = 'Server' AND [key] = 'SqlCommandConfigurationConnString';
		END;

		-- Increase the connection pool for the transaction state manager.  The pool
		-- needs to be significantly increased, due to the way user temp tables manage
		-- the internal transaction (in which we can leak a sql connection to the
		-- session scoped transaction).
		-- The value is:  2 x 1024 (# of sessions) + 3 (oletx threads)
		IF (@StoredVer < 61)
		BEGIN
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = REPLACE ([default], N'Max Pool Size=135', N'Max Pool Size=2183'),
				[value] = REPLACE ([value], N'Max Pool Size=135', N'Max Pool Size=2183')
			WHERE [id] = 'Server' AND [key] = 'TransactionManagerConnectionString';

			-- The Application Name from the connection string was inadvertantly removed from
			-- another change.  This re-introduces this value, which is critical to troubleshooting
			-- connection pool leaks.
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
				SET [value] = [value] + N';Application Name=TransactionManager'
				WHERE [value] IS NOT NULL AND [key] = 'TransactionManagerConnectionString';
		END;

		-- Remove DROP_EXISTING and ONLINE clauses applied to
		-- row-store index creation operations. This is required
		-- because DROP_EXISTING can now be specified in the PDW
		-- request AND the applicablity of ONLINE clause is now
		-- decided during plan generation depending on the index
		-- creation scenario.
		IF (@StoredVer < 62)
		BEGIN
			-- Update the index creation options for permanent tables.
			UPDATE
				[dbo].[configuration_properties]
			SET
				[default] = 'DATA_COMPRESSION = PAGE,PAD_INDEX = OFF,SORT_IN_TEMPDB = ON,IGNORE_DUP_KEY = OFF,STATISTICS_NORECOMPUTE = OFF,ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON',
				[value] = 'DATA_COMPRESSION = PAGE,PAD_INDEX = OFF,SORT_IN_TEMPDB = ON,IGNORE_DUP_KEY = OFF,STATISTICS_NORECOMPUTE = OFF,ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON'
			WHERE
				[id] = 'Server' AND
				[key] = 'IndexWithClause';

			-- Update the index creation options for session TEMP tables.
			UPDATE
				[dbo].[configuration_properties]
			SET
				[default] = 'DATA_COMPRESSION = PAGE,PAD_INDEX = OFF,SORT_IN_TEMPDB = ON,IGNORE_DUP_KEY = OFF,STATISTICS_NORECOMPUTE = OFF,ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON',
				[value] = 'DATA_COMPRESSION = PAGE,PAD_INDEX = OFF,SORT_IN_TEMPDB = ON,IGNORE_DUP_KEY = OFF,STATISTICS_NORECOMPUTE = OFF,ALLOW_ROW_LOCKS = ON,ALLOW_PAGE_LOCKS = ON'
			WHERE
				[id] = 'Server' AND
				[key] = 'IndexWithClauseForUserTempTable';

			-- Update the minimum file size setting for primary file groups
			-- on both shell and compute nodes to the Apollo minimum (5 MB).
			UPDATE
				[dbo].[filegroup]
			SET
				[min_filesize] = '5MB'
			WHERE
				[name] = 'PRIMARY';
		END;

		-- Add the properties that represent the limits for the size of new connection pools
		-- corresponding to the new resource classes. We are also updating the ports used
		-- for DMS control, data and loader to values lower than 17000 to free up larger
		-- range for ephemeral ports.
		IF (@StoredVer < 68)
		BEGIN
			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Server' AND [key] = 'ConnectionPoolMaxForMedium')
			BEGIN
				INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Server', N'ConnectionPoolMaxForMedium', NULL, N'50', 0, 0, N'int');
			END

			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Server' AND [key] = 'ConnectionPoolMinForMedium')
			BEGIN
				INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Server', N'ConnectionPoolMinForMedium', NULL, N'10', 0, 0, N'int');
			END

			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Server' AND [key] = 'ConnectionPoolMaxForLarge')
			BEGIN
				INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Server', N'ConnectionPoolMaxForLarge', NULL, N'44', 0, 0, N'int');
			END

			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Server' AND [key] = 'ConnectionPoolMinForLarge')
			BEGIN
				INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Server', N'ConnectionPoolMinForLarge', NULL, N'4', 0, 0, N'int');
			END

			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Server' AND [key] = 'ConnectionPoolMaxForXLarge')
			BEGIN
				INSERT [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Server', N'ConnectionPoolMaxForXLarge', NULL, N'41', 0, 0, N'int');
			END

			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Server' AND [key] = 'ConnectionPoolMinForXLarge')
			BEGIN
				INSERT [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Server', N'ConnectionPoolMinForXLarge', NULL, N'1', 0, 0, N'int');
			END

			UPDATE [dbo].[configuration_properties] SET [default] = N'16450' WHERE id = 'Dms' AND [key] = N'ManagerControlPort';

			UPDATE [dbo].[configuration_properties] SET [default] = N'16550' WHERE id = 'Dms' AND [key] = N'DataChannelPort';

			UPDATE [dbo].[configuration_properties] SET [default] = N'16551' WHERE id = 'Dms' AND [key] = N'BinaryLoaderDataChannelPort';

			-- Add ExternalReadCost CostModel properties to configuration_properties
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'CostModel' AND [key] = 'ExternalReadCost')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'CostModel', N'ExternalReadCost', NULL, N'0.0', 0, 0, N'double')

			-- Add ExternalTableReader-related properties to configuration_properties
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Dms' AND [key] = 'ExternalMoveBufferPoolSize')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'ExternalMoveBufferPoolSize', NULL, N'0', 0, 0, N'int')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Dms' AND [key] = 'ExternalMoveBufferSizeBytes')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'ExternalMoveBufferSizeBytes', NULL, N'262144', 0, 0, N'int')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Dms' AND [key] = 'ExternalMoveBufferPoolInitialAllocation')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'ExternalMoveBufferPoolInitialAllocation', NULL, N'50', 0, 0, N'int')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Dms' AND [key] = 'ExternalMoveReadersPerNode')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'ExternalMoveReadersPerNode', NULL, N'8', 0, 0, N'int')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Dms' AND [key] = 'ExternalMoveReaderQueueSize')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'ExternalMoveReaderQueueSize', NULL, N'3', 0, 0, N'int')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'HadoopConnectivityEnabled')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'HadoopConnectivityEnabled', NULL, N'true', 0, 0, N'bool')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'BridgeClassPath')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'BridgeClassPath', NULL, N'C:\Madison', 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'HadoopClassPath')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'HadoopClassPath', NULL, N'C:\Apps\dist\hadoop-core-1.1.0-SNAPSHOT.jar;C:\Apps\dist\lib\commons-logging-1.1.1.jar;C:\Apps\dist\lib\commons-lang-2.4.jar;C:\Apps\dist\lib\commons-configuration-1.6.jar;', 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'HadoopUserName')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'HadoopUserName', NULL, N'pdw_user', 0, 0, N'string')
		END;

		IF (@StoredVer < 70)
		BEGIN
			-- ALTER COLUMN value and default to varchar(5000)
			ALTER TABLE [DWConfiguration].[dbo].[configuration_properties] ALTER COLUMN [value] [nvarchar](4000) NULL;

			ALTER TABLE [DWConfiguration].[dbo].[configuration_properties] ALTER COLUMN [default] [nvarchar](4000) NULL;

			-- Delete the existing HadoopClassPath entry.
			DELETE FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [key] = N'HadoopClassPath'

			-- Delete the existing HadoopConnectivityEnabled property
			DELETE FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [key] = N'HadoopConnectivityEnabled'

			-- Update the existing hadoop bridge class path.
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HdfsBridge.jar'
			WHERE [id] = 'Hadoop' AND [key] = 'BridgeClassPath';

			-- Inset the class path for each supported distribution
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'HadoopWindowsClassPath')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'HadoopWindowsClassPath', NULL, N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-lang-2.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-logging-1.1.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\hadoop-core-1.1.0-SNAPSHOT.jar;', 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'HadoopHortonWorksClassPath')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'HadoopHortonWorksClassPath', NULL, N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\commons-lang-2.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\commons-logging-1.1.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\hadoop-core-1.0.3.16.jar;', 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'HadoopClouderaClassPath')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'HadoopClouderaClassPath', NULL, N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-cli-1.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-lang-2.5.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-logging-1.1.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\guava-11.0.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hadoop-auth-2.0.0-cdh4.1.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hadoop-common-2.0.0-cdh4.1.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hadoop-core-2.0.0-mr1-cdh4.1.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hadoop-hdfs-2.0.0-cdh4.1.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\log4j-1.2.17.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\protobuf-java-2.4.0a.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\slf4j-api-1.6.1.jar;', 0, 0, N'string')

			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pdw_sp_configure]') AND type in (N'U'))
				DROP TABLE [DWConfiguration].[dbo].[pdw_sp_configure];

			CREATE TABLE [DWConfiguration].[dbo].[pdw_sp_configure](
					[name] [nvarchar](35),
					[minimum] [int],
					[maximum] [int],
					[config_value] [int],
					[run_value] [int],
			CONSTRAINT [PK_name] PRIMARY KEY CLUSTERED
			(
				[name] ASC
			)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]) ON [PRIMARY]

			-- Hadoop connectivity configuration
			INSERT [DWConfiguration].[dbo].[pdw_sp_configure] ([name], [minimum], [maximum], [config_value], [run_value]) VALUES (N'hadoop connectivity', 0, 3, 0, 0)

		END

		IF (@StoredVer < 71)
		BEGIN
			-- Update the existing hadoop bridge class path - include the path to the configuration file
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\conf;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HdfsBridge.jar'
			WHERE [id] = 'Hadoop' AND [key] = 'BridgeClassPath';
		END

		IF (@StoredVer < 72)
		BEGIN
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[value] = NULL
			WHERE
				[id] = 'Server' AND [key] = 'SqlCommandConfigurationConnString';

			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[value] = NULL,
				[default] = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER'
			WHERE
				[id] = 'Server' AND [key] = 'SqlServerInstancePath';

			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[value] = NULL
			WHERE
				[id] = 'Server' AND [key] = 'ShellConnectionDataSource'

			exec sp_executesql N'UPDATE [DWConfiguration].[dbo].[filegroup]
			SET min_filesize = ''5MB''
			WHERE name = ''PRIMARY'' AND is_shell = 1';
		END

		IF (@StoredVer < 73)
		BEGIN
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[value] = NULL,
				[default] = N'G:\MSSQL11.MSSQLSERVER'
			WHERE
				[id] = 'Server' AND [key] = 'SqlServerInstancePath';
		END

		IF (@StoredVer < 74)
		BEGIN
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'HadoopJVMMaxHeapSize')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'HadoopJVMMaxHeapSize', NULL, N'-Xmx2g', 0, 0, N'string')
		END

		IF (@StoredVer < 76)
		BEGIN
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'TransparentDataEncryptionEnabled')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Server', N'TransparentDataEncryptionEnabled', NULL, N'false', 0, 1, N'bool')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'MaskUserDataInLogs')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Server', N'MaskUserDataInLogs', NULL, N'0', 0, 1, N'int')
		END

		IF (@StoredVer < 77)
		BEGIN
			-- Update the existing hadoop bridge class path - include the path to the configuration file
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\conf;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HdfsBridge.jar'
			WHERE [id] = 'Hadoop' AND [key] = 'BridgeClassPath';

			-- Add jackson jars so JobSubmitter (0.3) path works.
			-- Add to HDInsight class path.
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-codec-1.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-collections-3.2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-lang-2.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-logging-1.1.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\hadoop-core-1.2.0.1.3.0.0-0380.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\hive-cli-0.11.0.1.3.0.0-0380.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\hive-common-0.11.0.1.3.0.0-0380.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\hive-exec-0.11.0.1.3.0.0-0380.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\hive-serde-0.11.0.1.3.0.0-0380.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\jackson-core-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\jackson-mapper-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\jetty-util-6.1.26.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\microsoft-windowsazure-api-0.4.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\snappy-java-1.0.4.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\polybase.jar;'
			WHERE [id] = 'Hadoop' AND [key] = 'HadoopWindowsClassPath';

			-- Add to HortonWorks class path.
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\commons-codec-1.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\commons-lang-2.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\commons-logging-1.1.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\hadoop-core-1.2.0.1.3.0.0-107.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\hive-cli-0.11.0.1.3.0.0-107.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\hive-common-0.11.0.1.3.0.0-107.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\hive-exec-0.11.0.1.3.0.0-107.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\hive-serde-0.11.0.1.3.0.0-107.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\jackson-core-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\jackson-mapper-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\snappy-java-1.0.4.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\polybase.jar;'
			WHERE [id] = 'Hadoop' AND [key] = 'HadoopHortonWorksClassPath';

						-- Add All the Jars to classpath for cloudera on linux on polybase v2
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\avro-1.7.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-cli-1.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-codec-1.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-collections-3.2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-io-2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-lang-2.5.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-logging-1.1.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-math-2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-net-3.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\guava-11.0.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hadoop-auth-2.0.0-cdh4.3.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hadoop-common-2.0.0-cdh4.3.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hadoop-core-2.0.0-mr1-cdh4.3.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hadoop-hdfs-2.0.0-cdh4.3.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hive-cli-0.10.0-cdh4.3.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hive-common-0.10.0-cdh4.3.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hive-exec-0.10.0-cdh4.3.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hive-serde-0.10.0-cdh4.3.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\jackson-core-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\jackson-mapper-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\protobuf-java-2.4.0a.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\slf4j-api-1.6.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\slf4j-log4j12-1.6.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\snappy-java-1.0.4.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\cloudera_polybase.jar;'
			WHERE [id] = 'Hadoop' AND [key] = 'HadoopClouderaClassPath';

			-- Non-zero value for HDFS import cost. This pushes more computation into MapReduce.
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = N'0.000048'
			WHERE [id] =  N'CostModel' AND [key] = N'ExternalReadCost';

			-- Add ExternalReadCost CostModel properties to configuration_properties
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'CostModel' AND [key] = 'ExternalHadoopWriteCost')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'CostModel', N'ExternalHadoopWriteCost', NULL, N'0.00024', 0, 0, N'double')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'CompileJarPath')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'CompileJarPath', NULL, N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\polybase.jar', 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'ClouderaCompileJarPath')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'ClouderaCompileJarPath', NULL, N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\cloudera_polybase.jar', 0, 0, N'string')
		END

		IF (@StoredVer < 79)
		BEGIN
			-- Remove Hive jars from classpath for distributions. For RCFiles, the classes in the Hive jars are compiled into the polybase.jar.
			-- HDInsight class path.
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-codec-1.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-collections-3.2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-lang-2.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-logging-1.1.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\hadoop-core-1.2.0.1.3.0.0-0380.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\jackson-core-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\jackson-mapper-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\jetty-util-6.1.26.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\microsoft-windowsazure-api-0.4.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\polybase.jar;'
			WHERE [id] = 'Hadoop' AND [key] = 'HadoopWindowsClassPath';

			-- HortonWorks class path.
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\commons-codec-1.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\commons-lang-2.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\commons-logging-1.1.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\hadoop-core-1.2.0.1.3.0.0-107.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\jackson-core-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP\jackson-mapper-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\polybase.jar;'
			WHERE [id] = 'Hadoop' AND [key] = 'HadoopHortonWorksClassPath';

						-- Cloudera on linux class path.
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\avro-1.7.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-cli-1.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-codec-1.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-collections-3.2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-io-2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-lang-2.5.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-logging-1.1.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-math-2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\commons-net-3.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\guava-11.0.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hadoop-auth-2.0.0-cdh4.3.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hadoop-common-2.0.0-cdh4.3.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hadoop-core-2.0.0-mr1-cdh4.3.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\hadoop-hdfs-2.0.0-cdh4.3.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\jackson-core-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\jackson-mapper-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\protobuf-java-2.4.0a.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\slf4j-api-1.6.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD\slf4j-log4j12-1.6.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\cloudera_polybase.jar;'
			WHERE [id] = 'Hadoop' AND [key] = 'HadoopClouderaClassPath';
		END

		IF (@StoredVer < 81)
		BEGIN
			-- Upgrade hadoop core and jackson jars for HDI and Asv/Wasb.
			-- HDInsight class path.
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-codec-1.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-collections-3.2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-lang-2.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\commons-logging-1.1.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\hadoop-core-1.2.0.1.3.0.0-0514.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\jackson-core-asl-1.9.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\jackson-mapper-asl-1.9.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\jetty-util-6.1.26.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\microsoft-windowsazure-api-0.4.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\polybase.jar;'
			WHERE [id] = 'Hadoop' AND [key] = 'HadoopWindowsClassPath';
		END

		IF (@StoredVer < 82)
		BEGIN
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'BlockUnsupportedTDSClients')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Server', N'BlockUnsupportedTDSClients', NULL, N'true', 0, 0, N'bool')
		END

		IF (@StoredVer < 84)
		BEGIN
			-- Update DmsTcpBufferSize - which corresponds to SendBufferSize applied to DataChannelSender socket connections.
			-- We are reducing this to 32KB for now in order to improve stability of connections, although some throughput
			-- performance is sacrificed (VSTS 1996919)
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = '32768'
			WHERE [id] = 'Dms' AND [key] = 'DmsTcpBufferSize';
		END

		IF (@StoredVer < 85)
		BEGIN
			-- Expand connectivity range to 5 to support HDP2 on Windows and Linux.
			UPDATE [DWConfiguration].[dbo].[pdw_sp_configure]
			SET
				[maximum] = '5'
			WHERE [name] = 'hadoop connectivity';

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'HadoopWindowsVersionTwoClassPath')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'HadoopWindowsVersionTwoClassPath', NULL, N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\avro-1.7.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-cli-1.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-codec-1.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-collections-3.2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-io-2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-lang-2.5.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-logging-1.1.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\guava-11.0.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-auth-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-common-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-hdfs-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-mapreduce-client-common-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-mapreduce-client-core-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-mapreduce-client-jobclient-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-yarn-api-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-yarn-client-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-yarn-common-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\jackson-core-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\jackson-mapper-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\protobuf-java-2.5.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\slf4j-api-1.7.5.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\slf4j-log4j12-1.7.5.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\hortonworks2_polybase.jar;', 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'HadoopHortonWorksVersionTwoClassPath')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'HadoopHortonWorksVersionTwoClassPath', NULL, N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\avro-1.7.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\commons-cli-1.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\commons-codec-1.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\commons-collections-3.2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\commons-io-2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\commons-lang-2.5.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\commons-logging-1.1.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\guava-11.0.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\hadoop-auth-2.2.0.2.0.6.0-101.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\hadoop-common-2.2.0.2.0.6.0-101.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\hadoop-hdfs-2.2.0.2.0.6.0-101.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\hadoop-mapreduce-client-common-2.2.0.2.0.6.0-101.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\hadoop-mapreduce-client-core-2.2.0.2.0.6.0-101.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\hadoop-mapreduce-client-jobclient-2.2.0.2.0.6.0-101.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\hadoop-yarn-api-2.2.0.2.0.6.0-101.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\hadoop-yarn-client-2.2.0.2.0.6.0-101.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\hadoop-yarn-common-2.2.0.2.0.6.0-101.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\jackson-core-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\jackson-mapper-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\protobuf-java-2.5.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\slf4j-api-1.6.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\HDP2\slf4j-log4j12-1.6.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\hortonworks2_polybase.jar;', 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'HortonWorksVersionTwoCompileJarPath')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'HortonWorksVersionTwoCompileJarPath', NULL, N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\hortonworks2_polybase.jar', 0, 0, N'string')
		END

		-- DELETE MaxConcurrency property as it is no longer used.
		IF (@StoredVer < 87)
		BEGIN
			DELETE FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'MaxConcurrencyExecutionCount'
		END

		-- Oldest supportd build number for backup/restore.
		IF (@StoredVer < 88)
		BEGIN
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Backup' AND [key] = 'OldestSupportedBuildNumber')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Backup', N'OldestSupportedBuildNumber', NULL, N'10.0.4000.0', 0, 0, N'string')
		END

		-- Configuration Properties for Monitoring Service
		IF (@StoredVer < 89)
		BEGIN
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Monitoring' AND [key] = 'MonitoringEnabled')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Monitoring', N'MonitoringEnabled', NULL , N'false', 0, 0, N'bool')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Monitoring' AND [key] = 'MONITORING_XSTORE_ACCOUNTS')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Monitoring', N'MONITORING_XSTORE_ACCOUNTS', NULL , N'APSMonitoringStorageAccountMoniker#308202A106092A864886F70D010703A08202923082028E020100318201553082015102010030393025312330210603550403131A415053204D6F6E69746F72696E6720436572746966696361746502102C6134C99F6BC2974FAFC4653D66F5BF300D06092A864886F70D010107300004820100A5FD37BC946A3F21039763A328E5B6E9A40572A8971DABEC65592A0EB8364FFE8AFB89CD78C092F2BEC75454C5F4B46C2604F15CA229966A97661681D8C5420161D704AC29DC305B2F1BD30450A262D99FB2D11F278B6D1F9C349EB5E6D982221D0A01911F224061DF17CF7D50AAABFF91C8A5E8080514C959E44B12B2EF3CD9F048B040F3D20CBBDD3D6ABF39F9E4307E4F39F8545195936FB1E27D2CB3EA39ACB5A49562E8298016E85E6A0739FA34473494E897D356B95A6749FFA83EA21423AD74BAC0D564C033A9DC9A406175EAC5094295B44C012B5A61A25CB985A421065409BE65410B37EAA7D506BC4A176EB09496F723B6F7A95E48FFEB518167EB3082012E06092A864886F70D010701301D060960864801650304012A04104918E8DADA29003460E02BE16E20D78F80820100CFD4C9DBB6987863017047D3AFCFCA57A7E07FEE8B3740FB5F521244455263424F505E4C7F7947E21D7276559C5522D0F4F43DC875F5B24AFE36B3211A580AFE7B007C687D1A7CE47F1483BFDB91B432E1CC42C05FF63CB85744F726D22ABFB6E7540A2711C9C884FC405DC8ED0968A1D3F1C9814F27199B990673D882298C0D665D285F672B430ACC493377611244CE5C8D81A3730181E90C6F5F3360F90F81E3191E167CFE0E0A713870C742312AB5C31F3D18C7263DAD6DD795944F1D6F7111B4EDE7D0DE24624CA0810CDB55D08F231E056F90F1C6405AE32DF11D4D6DFDB2F2CE723004864AD45E7DC3D8A67F889F74961E341B5BB877EA6975D29B4831#LOCAL_MACHINE\MY', 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Monitoring' AND [key] = 'ApplianceId')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Monitoring', N'ApplianceId', NEWID() , NULL , 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Monitoring' AND [key] = 'MONITORING_DATA_DIRECTORY')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Monitoring', N'MONITORING_DATA_DIRECTORY', NULL , N'ProgramData\Microsoft\Microsoft SQL Server Parallel Data Warehouse\100\Logs\MAStore' , 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Monitoring' AND [key] = 'MONITORING_IDENTITY')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Monitoring', N'MONITORING_IDENTITY', NULL , N'use_ip_address' , 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Monitoring' AND [key] = 'MONITORING_INIT_CONFIG')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Monitoring', N'MONITORING_INIT_CONFIG', NULL , N'.\APSMonitoringAgentConfig.xml' , 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Monitoring' AND [key] = 'MONITORING_VERSION')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Monitoring', N'MONITORING_VERSION', NULL , N'1.0', 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Monitoring' AND [key] = 'MONITORING_ROLE')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Monitoring', N'MONITORING_ROLE', NULL , N'APSRole', 0, 0, N'string')
		END

		-- Dynamic TCP buffer settings for DMS data channel.
		IF (@StoredVer < 90)
		BEGIN
			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Dms' AND [key] = 'MaximumDmsRowSize')
			BEGIN
				INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'MaximumDmsRowSize', NULL, N'32768', 0, 0, N'int');
			END

			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Dms' AND [key] = 'TcpBufferNodeThresholdForSmallTopology')
			BEGIN
				INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'TcpBufferNodeThresholdForSmallTopology', NULL, N'4', 0, 0, N'int');
			END

			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Dms' AND [key] = 'TcpBufferNodeThresholdForMediumTopology')
			BEGIN
				INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'TcpBufferNodeThresholdForMediumTopology', NULL, N'10', 0, 0, N'int');
			END

			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Dms' AND [key] = 'TcpSendBufferSizeForSmallTopology')
			BEGIN
				INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'TcpSendBufferSizeForSmallTopology', NULL, N'524288', 0, 0, N'int');
			END

			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Dms' AND [key] = 'TcpSendBufferSizeForMediumTopology')
			BEGIN
				INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'TcpSendBufferSizeForMediumTopology', NULL, N'131072', 0, 0, N'int');
			END

			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Dms' AND [key] = 'TcpSendBufferSizeForLargeTopology')
			BEGIN
				INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'TcpSendBufferSizeForLargeTopology', NULL, N'32768', 0, 0, N'int');
			END

			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Dms' AND [key] = 'TcpReceiveBufferSizeForSmallTopology')
			BEGIN
				INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'TcpReceiveBufferSizeForSmallTopology', NULL, N'262144', 0, 0, N'int');
			END

			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Dms' AND [key] = 'TcpReceiveBufferSizeForMediumTopology')
			BEGIN
				INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'TcpReceiveBufferSizeForMediumTopology', NULL, N'65536', 0, 0, N'int');
			END

			IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Dms' AND [key] = 'TcpReceiveBufferSizeForLargeTopology')
			BEGIN
				INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Dms', N'TcpReceiveBufferSizeForLargeTopology', NULL, N'65536', 0, 0, N'int');
			END
		END

		-- Updated Bootstrap Key for Remote Monitoring Service
		IF (@StoredVer < 91)
		BEGIN
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Monitoring' AND [key] = 'MONITORING_XSTORE_ACCOUNTS')
			BEGIN
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Monitoring', N'MONITORING_XSTORE_ACCOUNTS', NULL , N'APSMonitoringStorageAccountMoniker#308202A106092A864886F70D010703A08202923082028E020100318201553082015102010030393025312330210603550403131A415053204D6F6E69746F72696E6720436572746966696361746502102C6134C99F6BC2974FAFC4653D66F5BF300D06092A864886F70D010107300004820100A135E67F01DDE89CDD7651467FBFB3CFE641F9E0D3E0422CC8274EB32950CB2B5096973C0D4B694AF2529DB6280765A03932F9848C2E57B8A03F9F431E66C9DDAECC0926A6F407A99782AD5660BE79C464C62755ACE21638DC1A62C856B83E1D3B3949377074D50CCE352AE6A9AE2F39FB1C383F8DA5AA87F46D08472CEE21AE32E183098C597766C68431D10D5ED857F5B77EEF7BB025B37DD659C31010D2FBC4CFA116E7FA7C81E1A2730B18B7C655CC96F9559959DCD45D2C71EDABAB744B48D3EF6ACD4FD3182A0F272A650465AEDA7BB0C30CE99B9CA1E5ABA101C4B3DA0D4B094203A9158DDE96E27924F58977E0F35878F0F9A6A227F5473CF5DBB7C03082012E06092A864886F70D010701301D060960864801650304012A04105BD38E20DAA49251E0930F04FC8008C7808201004DFB7710A6112A8428B251F61A6C6F4F6592573A6E341BDAA691CB6177BA342098ABAE60FA1C1B5C659149BD61CB573490BF1632F74B3A2F196924DD5CC273998B22572CD86548B30C797C0EAFDBB37417C34138DF5D865BB57C1045F9750D0ECE55E7D54872CF5AE52F4D8A52669C79961A4C6D22D17EB871E096724093107874B2D244705A006F774EB5C9BDED28BE51503FF969AF9BE5D9FB05D1ED94338A7F7CE6CADD4BB504812A72BEF9F133D30DA60DDF7E8308012F8422B7507A193476394C88D57B3722A7B5485F5625882740113956508B001A97E04F3200A2694BB690F5D2D661A21D69B38326BB0B43A96FC85B76F2B9F6BF7FA713A493061A20#LOCAL_MACHINE\MY', 0, 0, N'string')
			END
		ELSE
			BEGIN
				UPDATE [DWConfiguration].[dbo].[configuration_properties]
				SET [value] = N'APSMonitoringStorageAccountMoniker#308202A106092A864886F70D010703A08202923082028E020100318201553082015102010030393025312330210603550403131A415053204D6F6E69746F72696E6720436572746966696361746502102C6134C99F6BC2974FAFC4653D66F5BF300D06092A864886F70D010107300004820100A135E67F01DDE89CDD7651467FBFB3CFE641F9E0D3E0422CC8274EB32950CB2B5096973C0D4B694AF2529DB6280765A03932F9848C2E57B8A03F9F431E66C9DDAECC0926A6F407A99782AD5660BE79C464C62755ACE21638DC1A62C856B83E1D3B3949377074D50CCE352AE6A9AE2F39FB1C383F8DA5AA87F46D08472CEE21AE32E183098C597766C68431D10D5ED857F5B77EEF7BB025B37DD659C31010D2FBC4CFA116E7FA7C81E1A2730B18B7C655CC96F9559959DCD45D2C71EDABAB744B48D3EF6ACD4FD3182A0F272A650465AEDA7BB0C30CE99B9CA1E5ABA101C4B3DA0D4B094203A9158DDE96E27924F58977E0F35878F0F9A6A227F5473CF5DBB7C03082012E06092A864886F70D010701301D060960864801650304012A04105BD38E20DAA49251E0930F04FC8008C7808201004DFB7710A6112A8428B251F61A6C6F4F6592573A6E341BDAA691CB6177BA342098ABAE60FA1C1B5C659149BD61CB573490BF1632F74B3A2F196924DD5CC273998B22572CD86548B30C797C0EAFDBB37417C34138DF5D865BB57C1045F9750D0ECE55E7D54872CF5AE52F4D8A52669C79961A4C6D22D17EB871E096724093107874B2D244705A006F774EB5C9BDED28BE51503FF969AF9BE5D9FB05D1ED94338A7F7CE6CADD4BB504812A72BEF9F133D30DA60DDF7E8308012F8422B7507A193476394C88D57B3722A7B5485F5625882740113956508B001A97E04F3200A2694BB690F5D2D661A21D69B38326BB0B43A96FC85B76F2B9F6BF7FA713A493061A20#LOCAL_MACHINE\MY',
					[default] = N'APSMonitoringStorageAccountMoniker#308202A106092A864886F70D010703A08202923082028E020100318201553082015102010030393025312330210603550403131A415053204D6F6E69746F72696E6720436572746966696361746502102C6134C99F6BC2974FAFC4653D66F5BF300D06092A864886F70D010107300004820100A135E67F01DDE89CDD7651467FBFB3CFE641F9E0D3E0422CC8274EB32950CB2B5096973C0D4B694AF2529DB6280765A03932F9848C2E57B8A03F9F431E66C9DDAECC0926A6F407A99782AD5660BE79C464C62755ACE21638DC1A62C856B83E1D3B3949377074D50CCE352AE6A9AE2F39FB1C383F8DA5AA87F46D08472CEE21AE32E183098C597766C68431D10D5ED857F5B77EEF7BB025B37DD659C31010D2FBC4CFA116E7FA7C81E1A2730B18B7C655CC96F9559959DCD45D2C71EDABAB744B48D3EF6ACD4FD3182A0F272A650465AEDA7BB0C30CE99B9CA1E5ABA101C4B3DA0D4B094203A9158DDE96E27924F58977E0F35878F0F9A6A227F5473CF5DBB7C03082012E06092A864886F70D010701301D060960864801650304012A04105BD38E20DAA49251E0930F04FC8008C7808201004DFB7710A6112A8428B251F61A6C6F4F6592573A6E341BDAA691CB6177BA342098ABAE60FA1C1B5C659149BD61CB573490BF1632F74B3A2F196924DD5CC273998B22572CD86548B30C797C0EAFDBB37417C34138DF5D865BB57C1045F9750D0ECE55E7D54872CF5AE52F4D8A52669C79961A4C6D22D17EB871E096724093107874B2D244705A006F774EB5C9BDED28BE51503FF969AF9BE5D9FB05D1ED94338A7F7CE6CADD4BB504812A72BEF9F133D30DA60DDF7E8308012F8422B7507A193476394C88D57B3722A7B5485F5625882740113956508B001A97E04F3200A2694BB690F5D2D661A21D69B38326BB0B43A96FC85B76F2B9F6BF7FA713A493061A20#LOCAL_MACHINE\MY'
					WHERE [id] = 'Monitoring' AND [key] = 'MONITORING_XSTORE_ACCOUNTS'
			END
		END

		-- Updated HadoopWindowsVersionTwo classpath.Polybase would support WASB/ASV with the extra jars in connectivity type 4.
		IF (@StoredVer < 92)
		BEGIN
			-- The extra jars are identical with connectivity type 1's. We re-use them so we don't need to check in new jars. They fully support our current usage of WASB/ASV.
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[default] = N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\avro-1.7.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-cli-1.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-codec-1.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-collections-3.2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-io-2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-lang-2.5.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\commons-logging-1.1.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\guava-11.0.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-auth-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-common-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-hdfs-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-mapreduce-client-common-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-mapreduce-client-core-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-mapreduce-client-jobclient-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-yarn-api-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-yarn-client-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\hadoop-yarn-common-2.2.0.2.0.6.0-0009.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\jackson-core-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\jackson-mapper-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\protobuf-java-2.5.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\slf4j-api-1.7.5.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows2\slf4j-log4j12-1.7.5.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\jetty-util-6.1.26.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\Windows\microsoft-windowsazure-api-0.4.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\hortonworks2_polybase.jar;'
				WHERE [id] = 'Hadoop' AND [key] = 'HadoopWindowsVersionTwoClassPath';
		END

		-- SQL Server 2014 replat
		IF (@StoredVer < 93)
		BEGIN
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[value] = NULL,
				[default] = N'G:\MSSQL12.MSSQLSERVER'
			WHERE
				[id] = 'Server' AND [key] = 'SqlServerInstancePath';
		END

		-- Expand connectivity range to 6 to support Cloudera 5.
		IF (@StoredVer < 94)
		BEGIN
			UPDATE [DWConfiguration].[dbo].[pdw_sp_configure]
			SET
				[maximum] = '6'
			WHERE [name] = 'hadoop connectivity';

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'HadoopClouderaVersionFiveClassPath')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'HadoopClouderaVersionFiveClassPath', NULL, N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\avro-1.7.5-cdh5.1.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\commons-cli-1.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\commons-codec-1.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\commons-collections-3.2.1.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\commons-configuration-1.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\commons-io-2.4.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\commons-lang-2.6.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\commons-logging-1.1.3.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\guava-11.0.2.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\hadoop-auth-2.3.0-cdh5.1.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\hadoop-common-2.3.0-cdh5.1.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\hadoop-hdfs-2.3.0-cdh5.1.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\hadoop-mapreduce-client-common-2.3.0-cdh5.1.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\hadoop-mapreduce-client-core-2.3.0-cdh5.1.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\hadoop-mapreduce-client-jobclient-2.3.0-cdh5.1.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\hadoop-yarn-api-2.3.0-cdh5.1.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\hadoop-yarn-client-2.3.0-cdh5.1.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\hadoop-yarn-common-2.3.0-cdh5.1.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\jackson-core-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\jackson-mapper-asl-1.8.8.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\protobuf-java-2.5.0.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\slf4j-api-1.7.5.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\CHD5\slf4j-log4j12-1.7.5.jar;C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\cloudera5_polybase.jar;', 0, 0, N'string')

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Hadoop' AND [key] = 'ClouderaVersionFiveCompileJarPath')
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Hadoop', N'ClouderaVersionFiveCompileJarPath', NULL, N'C:\Program Files\Microsoft SQL Server Parallel Data Warehouse\100\Hadoop\cloudera5_polybase.jar', 0, 0, N'string')
		END

		-- Set Monitoring_DYNAMICEVENT_DIRECTORY required for Dynamic Events in MDS Configuration.
		IF (@StoredVer < 95)
		BEGIN
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Monitoring' AND [key] = 'MONITORING_DYNAMICEVENT_DIRECTORY')
			INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Monitoring', N'MONITORING_DYNAMICEVENT_DIRECTORY', NULL , N'ProgramData\Microsoft\Microsoft SQL Server Parallel Data Warehouse\100\Logs\SQLMDS\Public', 0, 0, N'string')
		END

		-- Expand connectivity range to 7 to support  HDP 2.2/2.1
		IF (@StoredVer < 99)
		BEGIN
				UPDATE [DWConfiguration].[dbo].[pdw_sp_configure]
				SET
					[maximum] = '7'
				WHERE [name] = 'hadoop connectivity';
		END

		-- Add properties related to streaming DMS.
		IF (@StoredVer < 100)
		BEGIN
			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'CostModel' AND [key] = 'StreamWriteCost')
			BEGIN
				INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'CostModel', N'StreamWriteCost', NULL, N'0.00024', 0, 0, N'double');
			END

			IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[pdw_sp_configure] WHERE [name] = 'streaming dms')
			BEGIN
				INSERT [DWConfiguration].[dbo].[pdw_sp_configure] ([name], [minimum], [maximum], [config_value], [run_value]) VALUES (N'streaming dms', 0, 1, 0, 0);
			END

			UPDATE [DWConfiguration].[dbo].[configuration_properties] SET [default] = N'0.000048' WHERE id = 'CostModel' AND [key] = N'ExternalReadCost';

			UPDATE [DWConfiguration].[dbo].[configuration_properties] SET [default] = N'0.00006' WHERE id = 'CostModel' AND [key] = N'ReaderHashCost';

			UPDATE [DWConfiguration].[dbo].[configuration_properties] SET [default] = N'0.000024' WHERE id = 'CostModel' AND [key] = N'WriterCost';

			DELETE FROM [DWConfiguration].[dbo].[configuration_properties] WHERE  id = 'CostModel' AND [key] = N'ReaderPackCost';
		END

		-- Clean up deprecated DWConfiguration entries.
		IF (@StoredVer <= 101)
		BEGIN
			IF EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'DWAuthenticationEntities')
			BEGIN
				DELETE FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'DWAuthenticationEntities'
			END

			IF EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'FileGroupsEntities')
			BEGIN
				DELETE FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'FileGroupsEntities'
			END

			IF EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'NodesEntityModel')
			BEGIN
				DELETE FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'NodesEntityModel'
			END

			IF EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'DatabaseSchemaManagerConnString')
			BEGIN
				DELETE FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'DatabaseSchemaManagerConnString'
			END

			IF EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'TransactionManagerConnectionString')
			BEGIN
				DELETE FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'TransactionManagerConnectionString'
			END

			IF EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'SqlCommandConfigurationConnString')
			BEGIN
				DELETE FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'SqlCommandConfigurationConnString'
			END

			IF EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'ConnectionPoolTimeout')
			BEGIN
				DELETE FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = 'Server' AND [key] = 'ConnectionPoolTimeout'
			END
		END

		-- SQL Server 2016 replat
		IF (@StoredVer < 102)
		BEGIN
			UPDATE [DWConfiguration].[dbo].[configuration_properties]
			SET
				[value] = NULL,
				[default] = N'G:\MSSQL13.MSSQLSERVER'
			WHERE
				[id] = 'Server' AND [key] = 'SqlServerInstancePath';
		END

		-- Add number of distributions per node configuration for PolyBase box.
		IF (@StoredVer < 107)
		BEGIN
			IF ('Polybase' = 'PolyBase')
			BEGIN
				IF NOT EXISTS (SELECT * FROM [dbo].[configuration_properties] WHERE id = 'Fabric' AND [key] = 'NumDistributionsPerNode')
					INSERT INTO [dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype]) VALUES (N'Fabric', N'NumDistributionsPerNode', NULL, N'8', 0, 0, N'int');
			END
		END

		-- Idempotent statements section:
		-- Redistribute mode configuration
		IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[pdw_sp_configure] WHERE [name] = N'redistribute mode')
			INSERT [DWConfiguration].[dbo].[pdw_sp_configure] ([name], [minimum], [maximum], [config_value], [run_value]) VALUES (N'redistribute mode', 0, 1, 0, 0)

		-- Add Distribution Type to toggle Database VS FileGroup types.
		IF (NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[configuration_properties] WHERE [id] = N'Server' AND [key] = N'DistributionType' ))
		BEGIN
			INSERT [DWConfiguration].[dbo].[configuration_properties] ([id], [key], [value], [default], [protection], [access], [datatype])
			VALUES (N'Server', N'DistributionType', NULL, N'FileGroup', 0, 0, N'string')
		END

		-- Add the adaptive QP configuration to sp_configure options.
		IF NOT EXISTS (SELECT * FROM [DWConfiguration].[dbo].[pdw_sp_configure] WHERE [name] = N'adaptive query processing')
			INSERT [DWConfiguration].[dbo].[pdw_sp_configure] ([name], [minimum], [maximum], [config_value], [run_value]) VALUES (N'adaptive query processing', 0, 1, 0, 0);
	END

GO

-- --------------------------------------------------
-- TABLE dbo.compute_node
-- --------------------------------------------------
CREATE TABLE [dbo].[compute_node]
(
    [id] INT NOT NULL,
    [name] VARCHAR(32) NOT NULL,
    [address] VARCHAR(15) NOT NULL,
    [database] VARCHAR(30) NOT NULL DEFAULT 'master',
    [instance] VARCHAR(16) NULL DEFAULT 'SQLSERVER',
    [active] BIT NOT NULL,
    [index] INT NOT NULL,
    [driveletter] VARCHAR(2) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.configuration_properties
-- --------------------------------------------------
CREATE TABLE [dbo].[configuration_properties]
(
    [id] VARCHAR(50) NOT NULL,
    [key] VARCHAR(50) NOT NULL,
    [value] NVARCHAR(4000) NULL,
    [default] NVARCHAR(4000) NULL,
    [protection] SMALLINT NOT NULL,
    [access] SMALLINT NOT NULL,
    [datatype] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.database_file
-- --------------------------------------------------
CREATE TABLE [dbo].[database_file]
(
    [filegroup_id] INT NOT NULL,
    [sequence] INT NOT NULL,
    [root_path] NVARCHAR(1000) NOT NULL,
    [is_add_from_alter] BIT NOT NULL,
    [percent_allocated_space] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.distribution
-- --------------------------------------------------
CREATE TABLE [dbo].[distribution]
(
    [id] INT NOT NULL,
    [name] VARCHAR(32) NOT NULL,
    [index] INT NOT NULL,
    [numa_port] SMALLINT NOT NULL DEFAULT ((1433))
);

GO

-- --------------------------------------------------
-- TABLE dbo.filegroup
-- --------------------------------------------------
CREATE TABLE [dbo].[filegroup]
(
    [id] INT NOT NULL,
    [name] NVARCHAR(255) NOT NULL,
    [distribution_id] INT NULL,
    [min_filesize] NVARCHAR(10) NOT NULL,
    [max_filesize] NVARCHAR(10) NOT NULL,
    [default_filegrowth] NVARCHAR(10) NOT NULL,
    [type] INT NOT NULL,
    [is_shell] BIT NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.node
-- --------------------------------------------------
CREATE TABLE [dbo].[node]
(
    [id] INT NOT NULL,
    [type] SMALLINT NOT NULL,
    [name] VARCHAR(32) NOT NULL,
    [address] VARCHAR(15) NOT NULL,
    [active] BIT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pdw_sp_configure
-- --------------------------------------------------
CREATE TABLE [dbo].[pdw_sp_configure]
(
    [name] NVARCHAR(35) NOT NULL,
    [minimum] INT NULL,
    [maximum] INT NULL,
    [config_value] INT NULL,
    [run_value] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.version_history
-- --------------------------------------------------
CREATE TABLE [dbo].[version_history]
(
    [version] INT NOT NULL DEFAULT ((0)),
    [date_installed] DATETIME NOT NULL
);

GO

