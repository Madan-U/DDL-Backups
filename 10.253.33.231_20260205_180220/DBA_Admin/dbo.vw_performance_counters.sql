-- Object: VIEW dbo.vw_performance_counters
-- Server: 10.253.33.231 | DB: DBA_Admin
--------------------------------------------------

CREATE view dbo.vw_performance_counters
as
with cte_counters_local as (select collection_time_utc, host_name, object, counter, value, instance from dbo.performance_counters)
,cte_counters_datasource as (select collection_time_utc, host_name, object, counter, value, instance from [10.253.33.194].[DBA_Admin].dbo.performance_counters)

select collection_time_utc, host_name, object, counter, value, instance from cte_counters_local
union all
select collection_time_utc, host_name, object, counter, value, instance from cte_counters_datasource

GO
