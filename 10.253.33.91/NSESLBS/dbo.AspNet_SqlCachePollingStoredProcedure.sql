-- Object: PROCEDURE dbo.AspNet_SqlCachePollingStoredProcedure
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE dbo.AspNet_SqlCachePollingStoredProcedure AS
         SELECT tableName, changeId FROM dbo.AspNet_SqlCacheTablesForChangeNotification
         RETURN 0

GO
