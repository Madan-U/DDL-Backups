-- DDL Export
-- Server: 192.168.31.174
-- Database: DWQueue
-- Exported: 2026-01-28T19:04:28.109124

USE DWQueue;
GO

-- --------------------------------------------------
-- INDEX dbo.MessageQueue
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [IX_ActiveMessages] ON [dbo].[MessageQueue] ([QueueName], [IsActive], [Priority], [DateActive], [Sequence], [MessageId])

GO

-- --------------------------------------------------
-- INDEX dbo.MessageQueue
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_MessageQueue_LookupField1] ON [dbo].[MessageQueue] ([LookupField1])

GO

-- --------------------------------------------------
-- INDEX dbo.MessageQueue
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_MessageQueue_LookupField2] ON [dbo].[MessageQueue] ([LookupField2])

GO

-- --------------------------------------------------
-- INDEX dbo.MessageQueue
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_MessageQueue_LookupField3] ON [dbo].[MessageQueue] ([LookupField3])

GO

-- --------------------------------------------------
-- INDEX dbo.TransactionState
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [PK_TransactionState] ON [dbo].[TransactionState] ([OperationId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MessageQueue
-- --------------------------------------------------
ALTER TABLE [dbo].[MessageQueue] ADD CONSTRAINT [PK_MessageQueue] PRIMARY KEY ([MessageId], [QueueName])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MessageQueueActivate
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[MessageQueueActivate]
	@QueueName nvarchar(255),
	@MessageId uniqueidentifier
AS
BEGIN
	--Delete selected messages to complete the dequeue operation.
	UPDATE MessageQueue  WITH (READCOMMITTED, READPAST)
	SET IsActive = 1
	WHERE QueueName = @QueueName 
	AND	MessageId = @MessageId
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MessageQueueDeleteMessage
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[MessageQueueDeleteMessage]
	@QueueName nvarchar(255),
	@MessageId uniqueidentifier
AS
BEGIN
	DELETE FROM MessageQueue 
	WHERE MessageId = @MessageId AND QueueName = @QueueName;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MessageQueueDequeueAccept
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[MessageQueueDequeueAccept]
	@QueueName nvarchar(255),
	@MessageId uniqueidentifier
AS
BEGIN
	--Delete selected messages to complete the dequeue operation.
	DELETE FROM MessageQueue 
	WHERE QueueName = @QueueName 
	AND	 MessageId = @MessageId;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MessageQueueEnqueue
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[MessageQueueEnqueue]
	@MessageId uniqueidentifier,
	@QueueName nvarchar(255),
	@DateActive datetime,
	@IsActive bit,
	@Priority int,
	@MessageBody varbinary(MAX),
	@CorrelationId uniqueidentifier = NULL,
	@LookupField1 nvarchar(255) = NULL,
	@LookupField2 nvarchar(255) = NULL,
	@LookupField3 nvarchar(255) = NULL
AS
BEGIN
	
	INSERT INTO MessageQueue(MessageId, 
		QueueName, 
		DateActive, 
		IsActive,
		Priority, 
		MessageBody, 
		CorrelationId,
		LookupField1,
		LookupField2,
		LookupField3,
		DateCreated)
	VALUES (@MessageId, 
		@QueueName, 
		@DateActive, 
		@IsActive,
		@Priority, 
		@MessageBody, 
		@CorrelationId,
		@LookupField1,
		@LookupField2,
		@LookupField3,
		GetDate());
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MessageQueuePeek
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[MessageQueuePeek]
	@QueueName nvarchar(255),
	@BatchSize int = 1,
	@DateActive datetime = NULL,
	@CorrelationId uniqueidentifier = NULL,
	@LookupField1 nvarchar(255) = NULL,
	@LookupField2 nvarchar(255) = NULL,
	@LookupField3 nvarchar(255) = NULL,
	@IsActive int = 1
AS
BEGIN
	SELECT TOP(@BatchSize) *
	FROM MessageQueue WITH (NOLOCK)
	WHERE QueueName = @QueueName
		AND (@IsActive IS NULL OR IsActive = @IsActive)
		AND DateActive <= @DateActive
		AND (@LookupField1 IS NULL OR LookupField1 LIKE @LookupField1)
		AND (@LookupField2 IS NULL OR LookupField2 LIKE @LookupField2)
		AND (@LookupField3 IS NULL OR LookupField3 LIKE @LookupField3)
	ORDER BY Priority ASC, DateActive ASC, [Sequence] ASC
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MessageQueueReceive
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[MessageQueueReceive]
	        @QueueName nvarchar(255),
	        @DateActive datetime = NULL,
	        @IsActive int = 1
        AS
        BEGIN
	        --select a batch of messages based on priority and activation date
	        --messages are selected with priority 0 being the highest and only
	        --if activation date is at @DateActive or before that.

	        SELECT TOP(1) mq1.*
	        FROM MessageQueue mq1 WITH (READCOMMITTED, READPAST, FORCESEEK INDEX(IX_ActiveMessages))
	        WHERE
		        mq1.MessageId NOT IN
		        (
			        SELECT ts1.OperationId
			        FROM TransactionState ts1
			        LEFT JOIN TransactionState ts2 WITH (READCOMMITTED, READPAST) ON ts1.OperationId = ts2.OperationId
			        WHERE ts2.OperationId is null
		        )
	        AND QueueName = @QueueName
	        AND (@IsActive IS NULL OR IsActive = @IsActive)
	        AND (@DateActive IS NULL OR DateActive <= @DateActive)
	        AND Priority >= 0
            --Below ORDER BY removed as it not necessary due to IX_ActiveMessages index.  Including the
            --ORDER BY below could cause the optimizer to generate a plan that will sort and spill to tempdb
            --which is undesirable due to the performance implications.  See vsts# 2013514 for details.
	        --ORDER BY Priority ASC, DateActive ASC, [Sequence] ASC
	        option ( fast 1 )
        END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MessageQueueUpdate
-- --------------------------------------------------

/*
   MessageQueueUpdate is used by the rollback manager to update the state of the message queue.
   This occurs when a undo operation fails and the priority, body, or active state needs to be updated.
*/
CREATE PROCEDURE [dbo].[MessageQueueUpdate]
	@QueueName nvarchar(255),
	@MessageId uniqueidentifier,
	@DateActive datetime,
	@Priority int = NULL,
	@IsActive int = 1,
	@MessageBody varbinary(MAX)
AS
BEGIN
	--Update selected messages to be dequeued again.
	UPDATE MessageQueue WITH  (READCOMMITTED, READPAST)
	SET DateActive = @DateActive, 
		Priority = ISNULL(@Priority, Priority),
		MessageBody = ISNULL(@MessageBody, MessageBody),
		IsActive = ISNULL(@IsActive, IsActive)
	WHERE QueueName = @QueueName 
	AND	 MessageId = @MessageId;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TransactionStateCreate
-- --------------------------------------------------

/*
	TransactionStateCreate creates a transactional record in the transaction state table.
	The state of the transaction is then maintained by TransactionStateUpdate.
*/
CREATE PROCEDURE [dbo].[TransactionStateCreate]
	@TransactionId uniqueidentifier,
	@OperationId uniqueidentifier,
	@State int
AS
BEGIN
	INSERT INTO TransactionState (TransactionId, OperationId, State, DateCreated)
	VALUES(@TransactionId, @OperationId, @State, GetDate())
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TransactionStateDelete
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[TransactionStateDelete]
	@OperationId uniqueidentifier
AS
BEGIN
	DELETE FROM TransactionState
	WHERE OperationId = @OperationId;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TransactionStateGetCommittedOperationState
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[TransactionStateGetCommittedOperationState]
	@OperationId uniqueidentifier
AS
BEGIN
	SELECT [State] FROM TransactionState WITH (READCOMMITTED,READPAST)
	WHERE OperationId = @OperationId;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TransactionStateGetCurrentOperationState
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[TransactionStateGetCurrentOperationState]
	@OperationId uniqueidentifier
AS
BEGIN
	SELECT [State] FROM TransactionState with (READUNCOMMITTED)
	WHERE OperationId = @OperationId;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TransactionStateUpdate
-- --------------------------------------------------

/*
	TransactionStateUpdate maintains the state of the transactional operation.  The state
	is initially created by TransactionStateCreate.
*/
CREATE PROCEDURE [dbo].[TransactionStateUpdate]
	@TransactionId uniqueidentifier,
	@OperationId uniqueidentifier,
	@State int
AS
BEGIN
	UPDATE TransactionState 
	SET [State] = @State
	WHERE [OperationId] = @OperationId
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpgradeDWQueue
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[UpgradeDWQueue]
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

		IF (@StoredVer < 61)
		BEGIN
			--Cleanup leaked records.  This will clean up records due to vsts 903400.  There should always be a MessageQueue record
			--if a record exists in TransactionState.
			DELETE FROM DWQueue.dbo.TransactionState where OperationId NOT IN ( SELECT MessageId from DWQueue.dbo.MessageQueue );

			--Prepare the TransactionState table for the new one state per operation model
			DELETE ts FROM DWQueue.dbo.TransactionState as ts
			WHERE [State] < (SELECT MAX([State])
				FROM DWQueue.dbo.TransactionState WHERE [OperationId] = ts.OperationId AND [TransactionId] = ts.TransactionId )

			--Remove the RollbackExecuted messages.  We no longer use this state, and since a state of 4 means that the
			--rollback operation has been executed, we do not need to invoke it.
			DELETE FROM DWQueue.dbo.MessageQueue WHERE [MessageId] IN ( SELECT [OperationId] FROM [dbo].[TransactionState] WHERE [State] = 4 );
			DELETE FROM DWQueue.dbo.TransactionState where State = 4;

			--Optimistically re-enable de-activated rollback messages.  These messages where likely de-activate due to rollover timeout,
			--and will likely complete on re-activation.
			UPDATE DWQueue.dbo.MessageQueue SET IsActive = 1 where IsActive = 0;

			--Not needed: DROP INDEX [IX_TransactionState_OperationId] on [dbo].[TransactionState];

			ALTER INDEX [PK_MessageQueue] ON [dbo].[MessageQueue] SET ( ALLOW_PAGE_LOCKS = OFF );
			ALTER INDEX [IX_MessageQueue_LookupField1] ON [dbo].[MessageQueue] SET ( ALLOW_PAGE_LOCKS = OFF );
			ALTER INDEX [IX_MessageQueue_LookupField2] ON [dbo].[MessageQueue] SET ( ALLOW_PAGE_LOCKS = OFF );
			ALTER INDEX [IX_MessageQueue_LookupField3] ON [dbo].[MessageQueue] SET ( ALLOW_PAGE_LOCKS = OFF );

			CREATE UNIQUE INDEX [IX_ActiveMessages] on [dbo].[MessageQueue]
			(
				[QueueName] ASC,
				[DateActive] ASC,
				[IsActive] ASC,
				[Priority] ASC,
				[Sequence] ASC,
				[MessageId] ASC
			) WITH (STATISTICS_NORECOMPUTE  = ON, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY];

			DROP INDEX [IX_TransactionState_OperationId] ON [dbo].[TransactionState]

			CREATE UNIQUE CLUSTERED INDEX [PK_TransactionState] ON [dbo].[TransactionState] ( [OperationId] ASC ) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]

			--Disable lock escalation
			ALTER TABLE [dbo].[MessageQueue] set ( LOCK_ESCALATION = disable )
			ALTER TABLE [dbo].[TransactionState] set ( LOCK_ESCALATION = disable )
		END

		-- Specify rerunnable changes here;
		-- these changes can be executed during every upgrade, not just once
	END

    IF (@StoredVer < 86)
    BEGIN
        DROP INDEX [IX_ActiveMessages] ON [dbo].[MessageQueue];

        -- Recreate the index based on the sorting criteria for dequeuing a request.
        CREATE UNIQUE NONCLUSTERED INDEX [IX_ActiveMessages] ON [dbo].[MessageQueue]
        (
	        [QueueName] ASC,
	        [IsActive] ASC,
	        [Priority] ASC,
	        [DateActive] ASC,
	        [Sequence] ASC,
	        [MessageId] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY];

        -- Remove the order by clause that is implicitly enforced by the above index.
        -- This is necessary, as the optimizer cannot create an optimal plan for a stored procedure with
        -- passed parameters.  It will choose a plan that will sort the table, and spill to tempdb, causing
        -- excessive IO to tempdb.
        EXEC sp_executesql N'ALTER PROCEDURE [dbo].[MessageQueueReceive]
	        @QueueName nvarchar(255),
	        @DateActive datetime = NULL,
	        @IsActive int = 1
        AS
        BEGIN
	        --select a batch of messages based on priority and activation date
	        --messages are selected with priority 0 being the highest and only
	        --if activation date is at @DateActive or before that.

	        SELECT TOP(1) mq1.*
	        FROM MessageQueue mq1 WITH (READCOMMITTED, READPAST, FORCESEEK INDEX(IX_ActiveMessages))
	        WHERE
		        mq1.MessageId NOT IN
		        (
			        SELECT ts1.OperationId
			        FROM TransactionState ts1
			        LEFT JOIN TransactionState ts2 WITH (READCOMMITTED, READPAST) ON ts1.OperationId = ts2.OperationId
			        WHERE ts2.OperationId is null
		        )
	        AND QueueName = @QueueName
	        AND (@IsActive IS NULL OR IsActive = @IsActive)
	        AND (@DateActive IS NULL OR DateActive <= @DateActive)
	        AND Priority >= 0
            --Below ORDER BY removed as it not necessary due to IX_ActiveMessages index.  Including the
            --ORDER BY below could cause the optimizer to generate a plan that will sort and spill to tempdb
            --which is undesirable due to the performance implications.  See vsts# 2013514 for details.
	        --ORDER BY Priority ASC, DateActive ASC, [Sequence] ASC
	        option ( fast 1 )
        END'
    END

GO

-- --------------------------------------------------
-- TABLE dbo.MessageQueue
-- --------------------------------------------------
CREATE TABLE [dbo].[MessageQueue]
(
    [MessageId] UNIQUEIDENTIFIER NOT NULL,
    [QueueName] NVARCHAR(255) NOT NULL,
    [Priority] INT NOT NULL,
    [DateActive] DATETIME NOT NULL,
    [IsActive] BIT NOT NULL,
    [MessageBody] VARBINARY(MAX) NOT NULL,
    [DateCreated] DATETIME NOT NULL,
    [Sequence] BIGINT IDENTITY(1,1) NOT NULL,
    [RequestId] UNIQUEIDENTIFIER NULL,
    [DateRequestExpires] DATETIME NULL,
    [CorrelationId] UNIQUEIDENTIFIER NULL,
    [LookupField1] NVARCHAR(255) NULL,
    [LookupField2] NVARCHAR(255) NULL,
    [LookupField3] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TransactionState
-- --------------------------------------------------
CREATE TABLE [dbo].[TransactionState]
(
    [OperationId] UNIQUEIDENTIFIER NOT NULL,
    [TransactionId] UNIQUEIDENTIFIER NOT NULL,
    [State] INT NOT NULL,
    [DateCreated] DATETIME NOT NULL
);

GO

