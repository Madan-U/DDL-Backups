-- Object: PROCEDURE dbo.DBA_TABLE_ACTIVITY
-- Server: 10.253.33.91 | DB: PRADNYA
--------------------------------------------------

CREATE PROCEDURE DBA_TABLE_ACTIVITY
AS
BEGIN

	WITH LastActivity (ObjectID, LastAction) 
	AS 
	( 
	SELECT object_id AS TableName, Last_User_Seek as LastAction
	FROM sys.dm_db_index_usage_stats u 
	WHERE database_id = db_id(db_name()) 
	UNION 
	SELECT object_id AS TableName,last_user_scan as LastAction 
	FROM sys.dm_db_index_usage_stats u 
	WHERE database_id = db_id(db_name()) 
	UNION 
	SELECT object_id AS TableName,last_user_lookup as LastAction 
	FROM sys.dm_db_index_usage_stats u  
	WHERE database_id = db_id(db_name()) 
	) 

	SELECT OBJECT_NAME(so.object_id)AS TableName, so.Create_Date "Creation Date",so.Modify_date "Last Modified",
	MAX(la.LastAction)as "Last Accessed" 
	FROM 
	sys.objects so 
	LEFT JOIN LastActivity la 
	ON so.object_id = la.ObjectID 
	WHERE so.type = 'U' 
	AND so.object_id > 100   --returns only the user tables.Tables with objectid < 100 are systables. 
	GROUP BY OBJECT_NAME(so.object_id),so.Create_Date,so.Modify_date
	ORDER BY OBJECT_NAME(so.object_id)
END

GO
