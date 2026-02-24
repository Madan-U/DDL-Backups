-- Object: PROCEDURE dbo.usp_create_dms_json
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE proc [dbo].[usp_create_dms_json]
@tableName as varchar(200)=''
as begin
IF OBJECT_ID(N'tempdb..#temcolumn') IS NOT NULL
BEGIN
DROP TABLE #temcolumn
END




SELECT row_number() over(order by (select 1))srNo, column_name,lower(column_name) as value into #temcolumn
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @tableName




declare @str as varchar(max)=''


declare @i as int =1
declare @max as int=0

set @max =(select max(srNo)  from #temcolumn)
while (@i<=@max)
begin



declare @col_Name as varchar(100)=''
declare @value as varchar(100)=''

select @col_Name=column_name,@value=value  from #temcolumn where srNo=@i

-----------------------------------------------------------------------------

--get random number

declare @rnd varchar(9) = ''
;with a as
(
select 0 x
union all
select x + 1
from a where x < 9
), b as
(
select top 10 x from a
order by newid()
)
select @rnd += cast(x as char(1)) from b

-----------------------------------------------------------------------------

declare @template as varchar(max)='{
      "rule-type": "transformation",
      "rule-id": "'+cast(@rnd as varchar(50))+'",
      "rule-name": "'+cast(@rnd as varchar(50))+'",
      "rule-target": "column",
      "object-locator": {
        "schema-name": "dbo",
        "table-name": "'+@tableName+'",
        "column-name": "'+@col_Name+'"
      },
      "rule-action": "rename",
      "value": "'+@value+'",
      "old-value": null
    },'

	set @str=@str+@template

	print(@template)

set @i=@i+1
end


select @str
end

GO
