-- Object: PROCEDURE dbo.AspNet_SqlCacheQueryRegisteredTablesStoredProcedure
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE dbo.AspNet_SqlCacheQueryRegisteredTablesStoredProcedure 
         AS
         SELECT tableName FROM dbo.AspNet_SqlCacheTablesForChangeNotification

GO
