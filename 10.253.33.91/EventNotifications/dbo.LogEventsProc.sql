-- Object: PROCEDURE dbo.LogEventsProc
-- Server: 10.253.33.91 | DB: EventNotifications
--------------------------------------------------

CREATE PROCEDURE [dbo].[LogEventsProc]
AS
SET NOCOUNT ON;
DECLARE     @message_body XML,
            @message_type_name NVARCHAR(256),
            @dialog UNIQUEIDENTIFIER ;
--  This procedure continues to process messages in the queue until the
--  queue is empty.
WHILE (1 = 1)
BEGIN
    BEGIN TRANSACTION ;
    -- Receive the next available message
    WAITFOR (
        RECEIVE TOP(1) -- just handle one message at a time
            @message_type_name=message_type_name,  --the type of message received
            @message_body=message_body,      -- the message contents
            @dialog = conversation_handle    -- the identifier of the dialog this message was received on
            FROM NotifyQueue
    ), TIMEOUT 2000 ; -- if the queue is empty for two seconds, give up and go away
   -- If RECEIVE did not return a message, roll back the transaction
   -- and break out of the while loop, exiting the procedure.
    IF (@@ROWCOUNT = 0)
        BEGIN
            ROLLBACK TRANSACTION ;
            BREAK ;
        END ;
   -- Check to see if the message is an end dialog message.
    IF (@message_type_name = 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog')
    BEGIN
        PRINT 'End Dialog received for dialog # ' + cast(@dialog as nvarchar(40)) ;
        END CONVERSATION @dialog ;
    END ;
    ELSE
    BEGIN
    -- Extract the event information using XQuery.
    --++++++++++++++++**************put if condition here
                       
    -- Use XQuery to extract XML values to be inserted into the log table
    INSERT INTO [dbo].[LoggedEvents] (
        EventType,
        EventTime,
        LoginName,
        UserName,
        ServerName,
        DatabaseName,
        SchemaName,
        ObjectName,
        ObjectType,
        TSQLCmdText
    )
    VALUES
    (
    CAST(@message_body.query('/EVENT_INSTANCE/EventType/text()')  AS NVARCHAR(256)),
    CAST(CAST(@message_body.query('/EVENT_INSTANCE/PostTime/text()') AS NVARCHAR(MAX)) AS DATETIME),
    CAST(@message_body.query('/EVENT_INSTANCE/LoginName/text()') AS sysname),
    @message_body.value('(/EVENT_INSTANCE/ClientHost)[1]', 'NVARCHAR(15)')  ,
    CAST(@message_body.query('/EVENT_INSTANCE/ServerName/text()') AS sysname),
    CAST(@message_body.query('/EVENT_INSTANCE/DatabaseName/text()') AS sysname),
    CAST(@message_body.query('/EVENT_INSTANCE/SchemaName/text()') AS sysname),
    CAST(@message_body.query('/EVENT_INSTANCE/ObjectName/text()') AS sysname),
    CAST(@message_body.query('/EVENT_INSTANCE/ObjectType/text()') AS sysname),
    CAST(@message_body.query('/EVENT_INSTANCE/TSQLCommand/CommandText/text()') AS NVARCHAR(MAX))
    ) ;
    

    END ;
    COMMIT TRANSACTION ;
END ;

GO
