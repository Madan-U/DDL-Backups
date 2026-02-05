-- Object: VIEW dbo.vw_performance_counters
-- Server: 10.253.78.187 | DB: DBA_Admin
--------------------------------------------------

CREATE view dbo.vw_performance_counters
--with schemabinding
as
with cte_counters_local as (select collection_time_utc, host_name, object, counter, value, instance from dbo.performance_counters)
--,cte_counters_datasource as (select collection_time_utc, host_name, object, counter, value, instance from [SQL2019].DBA.dbo.performance_counters)

select collection_time_utc, host_name, object, counter, value, instance from cte_counters_local --with (forceseek)
--union all
--select collection_time_utc, host_name, object, counter, value, instance from cte_counters_datasource

GO
