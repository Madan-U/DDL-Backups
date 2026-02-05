-- Object: FUNCTION dbo.fn_get_instanceid
-- Server: 10.253.33.231 | DB: DBA_Admin
--------------------------------------------------


CREATE FUNCTION dbo.fn_get_instanceid()
RETURNS TABLE
AS
RETURN
(
    WITH ple AS 
    (
        SELECT TOP 1 
            pc.*,
            [idx_dollar] = CHARINDEX('$', pc.object_name),
            [idx_colon] = CHARINDEX(':', pc.object_name)
        FROM sys.dm_os_performance_counters pc
        WHERE counter_name = N'Page life expectancy'
    )
    SELECT 
        [instance_id] = SUBSTRING(object_name, [idx_dollar] + 1, [idx_colon] - [idx_dollar] - 1)
    FROM ple
);

GO
