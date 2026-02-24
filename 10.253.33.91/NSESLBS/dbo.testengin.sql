-- Object: PROCEDURE dbo.testengin
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/*
   This stored procedure allows you to paginate a recordset,
   so that you can pull back just a range of rows from a
   query. It works sort of like this:
   SELECT PAGE <x> SIZE <y> 
      <Columns> 
   FROM 
      <Table> 
   WHERE 
      <Condition> 
   ORDER BY 
      <Order>
   statement where: 
      * <x> is @SetPage (the number of the "page" to display)
      * <y> is @SetPageSize (the number of results on each "page")
      * <Columns> is @Columns
      * <Table> is @Table
      * <Condition> is @SqlWhere
      * <Order> is @SqlOrderBy
*/
create procedure [dbo].[testengin]
   @TableName varchar(250),
   @Columns varchar(1000),
   @IdentityColumn varchar(64),
   @SetPage int,
   @SetPageSize int,
   @SqlWhere varchar(4000),
   @SqlOrderBy varchar(1000),
   @Distinct bit = 0,
   @TotalRecords int = null output,
   @TotalPages int = null output,
   @CurrentPage int = null output,
   @SqlString nvarchar(4000) = null output
as
declare @SelectStr nvarchar(20)
declare @InnerSql nvarchar(4000)
declare @PreviousRecords int
-- if selecting distinct records, set the select statement
if @Distinct = 1
   set @SelectStr = N'select distinct '
else
   set @SelectStr = N'select '
-- create a query to get the total number of records
declare @GetRecordsSQL nvarchar(4000)
set @GetRecordsSQL = N'set @count = (' + @SelectStr + ' count(' + @IdentityColumn + ') from ' + @TableName
-- if a where clause was used, add the where clause now
if @SqlWhere + '' <> '' 
   set @GetRecordsSQL = @GetRecordsSQL + N' where ' + @SqlWhere
set @GetRecordsSQL = @GetRecordsSQL + N')'
-- execute the dynamic SQL statment and return the value of the @count variable
exec sp_executesql @GetRecordsSQL, N'@count int output', @count = @TotalRecords output
-- set the total pages
set @TotalPages = @TotalRecords/@SetPageSize
-- if page size doesn't go into total records evenly, then we need to adjust for another partial page
if (@TotalRecords % @SetPageSize) > 0
   set @TotalPages = @TotalPages + 1
-- if the @SetPage is less than 1, then grab the first page
if @SetPage < 1
   set @SetPage = 1
-- don't allow a page higher than the total number of pages
if @SetPage > @TotalPages
   set @SetPage = @TotalPages
-- set the current page
set @CurrentPage = @SetPage
set @PreviousRecords = (@SetPageSize * @SetPage) - @SetPageSize

if @Distinct = 1
   begin
      set @InnerSql = N'(select ' + @IdentityColumn + 
         ' from (' + @SelectStr + N'top ' +
         cast(@PreviousRecords as nvarchar(32)) + 
         N' ' + @Columns + 
         N' from ' + 
         @TableName
   end
else
   begin
      set @InnerSql = N'(' + @SelectStr + N'top ' + 
         cast(@PreviousRecords as nvarchar(32)) + 
         N' ' + @IdentityColumn + 
         N' from ' + 
         @TableName
   end
if @SqlWhere + '' <> ''
   begin
      set @InnerSql = @InnerSql + 
         N' where ' + 
         @SqlWhere
   end
if @SqlOrderBy + '' <> ''
   begin
      set @InnerSql = @InnerSql + 
         N' order by ' + 
         @SqlOrderBy
   end
set @InnerSql = @InnerSql + N')'
if @Distinct = 1
   set @InnerSql = @InnerSql + N' as tmpDerived)'
set @SqlString = @SelectStr + N'top ' + 
   cast(@SetPageSize as nvarchar(32)) + 
   N' ' + 
   @Columns + 
   N' from ' + 
   @TableName + 
   N' where 1 = 1'
if @SetPage > 1
   begin
      set @SqlString = @SqlString + 
         N' and (' + 
         @IdentityColumn + 
         N' not in ' + 
         @InnerSql + 
         N')'
   end
if @SqlWhere + '' <> ''
   begin
      set @SqlString = @SqlString + 
         N' and ' + 
         @SqlWhere
   end
if @SqlOrderBy + '' <> ''
   begin
      set @SqlString = @SqlString + 
         N' order by ' + 
         @SqlOrderBy
   end
-- execute the query
exec sp_executesql @SqlString
-- dump out the values for the pagination
print ''
print 'Total Records: ' + cast(@TotalRecords as varchar(32))
print 'Total Pages: ' + cast(@TotalPages as varchar(32))
print 'Current Page: ' + cast(@CurrentPage as varchar(32))
print ''
print 'SQL: ' 
print @SqlString
return (0)

GO
