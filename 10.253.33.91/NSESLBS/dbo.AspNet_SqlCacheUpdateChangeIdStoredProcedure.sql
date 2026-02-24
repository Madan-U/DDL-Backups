-- Object: PROCEDURE dbo.AspNet_SqlCacheUpdateChangeIdStoredProcedure
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE dbo.AspNet_SqlCacheUpdateChangeIdStoredProcedure 
             @tableName NVARCHAR(450) 
         AS

         BEGIN 
             UPDATE dbo.AspNet_SqlCacheTablesForChangeNotification WITH (ROWLOCK) SET changeId = changeId + 1 
             WHERE tableName = @tableName
         END

GO
