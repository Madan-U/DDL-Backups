-- Object: PROCEDURE dbo.sp_ProduceInsertProcedure
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure sp_ProduceInsertProcedure
 --  Author: Wayne Gadberry  Date: 10/24/2000
 --  Execute this procedure by passing a local table name to it and a new procedure's text will be produced 
 --  containing an insert statement for all fields in the table as well as transaction and error handling
 
 @TableName varchar(100)
as
  declare @MaxColOrder int
 declare @ParameterName varchar(100)
 declare @Datatype  varchar(20)
 declare @IsNullable varchar(10)
 declare @FieldName varchar(50)
 
 set nocount on
 if charindex('.', @TableName) > 0
  begin
   raiserror('Please create the procedure sp_ProduceInsertParameters in the database you want to run against and try again.' ,16,1)
   return
  end
 if not exists (select name from sysobjects where name = @TableName)
  begin
   raiserror('Table does not exist in the database.  Please choose the correct table and try again.' ,16,1)
   return
  end

 select @MaxColOrder = max(colorder) from syscolumns where object_name(id) = @TableName
 create table #tblProcTemp (Text varchar(8000) null)
 insert into #tblProcTemp values ('')
 insert into #tblProcTemp values ('create procedure xxx_spIns' + right(@TableName, datalength(@TableName) - 7))
 insert into #tblProcTemp values ('')
 declare csrGetFields scroll cursor for
 select Name from syscolumns where object_name(id) = @TableName and status != 128 order by colorder
 
 open csrGetFields
 fetch next from csrGetFields into @FieldName
 while @@fetch_status = 0
  
  begin
   select   
      @ParameterName = space(0) + '@' + convert(char(25), t1.Name),
      @Datatype = case t2.Name 
         when 'varchar'  	then convert(char(15), 'varchar(' + convert(varchar(5), t1.Length) + ')')
      	 when 'char'   		then convert(char(15), 'char(' + convert(varchar(5), t1.Length) + ')')
      	 when 'nchar'   	then convert(char(15), 'nchar(' + convert(varchar(5), t1.Length/2) + ')')
         when 'int'  		then convert(char(20), 'int')
         when 'bit'   		then convert(char(20), 'bit')
         when 'nvarchar' 	then convert(char(20), 'nvarchar(' + convert(varchar(5), t1.Length/2) + ')')
         when 'datetime' 	then convert(char(20), 'datetime')
         when 'money'  		then convert(char(20), 'money')
         when 'tinyint'  	then convert(char(20), 'tinyint')
         when 'text'  		then convert(char(20), 'text')         when 'ntext'  		then convert(char(20), 'ntext')
         when 'numeric'  	then convert(char(20), 'numeric(' + convert(varchar(2), t1.xprec) + ',' + convert(varchar(2), t1.xscale) + ')')
         when 'float'  		then convert(char(20), 'float')
       end, 
      @IsNullable =
        case
         when isnullable = 1 and colorder != @MaxColOrder then convert(char(10), '= null,')
         when isnullable = 0 and colorder != @MaxColOrder then convert(char(10), ',')
         when isnullable = 1 and colorder =  @MaxColOrder then convert(char(10), '= null')
         when isnullable = 0 and colorder =  @MaxColOrder then convert(char(10), '')
       end
    from 
       syscolumns t1, 
       systypes t2 
    where 
       t1.xtype = t2.xtype 
    and 
       object_name(id) = @TableName
    and
       t1.status != 128
    and
       t2.Name != 'sysname'
    and
     t1.Name = @FieldName
    order by 
       colorder
   insert into #tblProcTemp values (space(7) + @ParameterName + @Datatype +  @IsNullable)
   fetch next from csrGetFields into @FieldName
  end
  insert into #tblProcTemp values ('')
  insert into #tblProcTemp values ('as')
  insert into #tblProcTemp values ('')
  insert into #tblProcTemp values (space(7) + 'declare @procname varchar(50)')
  insert into #tblProcTemp values (space(7) + 'select @procname = object_name(@@procid)')
  insert into #tblProcTemp values ('')
  insert into #tblProcTemp values (space(7) + 'begin transaction trnIns' + right(@TableName, datalength(@TableName) - 7))
  insert into #tblProcTemp values ('')
  insert into #tblProcTemp values (space(14) + 'begin')
  insert into #tblProcTemp values (space(21) + 'insert into ' + @TableName + '(')
  insert into #tblProcTemp select space(42) + Name + ',' from syscolumns where object_name(id) = @TableName and status != 128 and colorder < @MaxColorder order by colorder
  insert into #tblProcTemp select space(42) + Name + '' from syscolumns where object_name(id) = @TableName and status != 128 and colorder = @MaxColorder order by colorder
  insert into #tblProcTemp select space(42) + ')'
  insert into #tblProcTemp values (space(21) + 'select')
  insert into #tblProcTemp select space(42) + '@' + Name + ',' from syscolumns where object_name(id) = @TableName and status != 128 and colorder < @MaxColorder order by colorder
  insert into #tblProcTemp select space(42) + '@' + Name + '' from syscolumns where object_name(id) = @TableName and status != 128 and colorder = @MaxColorder order by colorder
  insert into #tblProcTemp values ('')
  insert into #tblProcTemp select space(21) + 'if @@error != 0'
  insert into #tblProcTemp select space(28) + 'begin'
  insert into #tblProcTemp select space(35) + 'rollback transaction trnIns' + right(@TableName, datalength(@TableName) - 7)
  insert into #tblProcTemp select space(35) + 'raiserror(''Error inserting into table ' + @TableName + '.  Error occurred in procedure %s.  Rolling back transaction...'', 16, 1, @procname)'
  insert into #tblProcTemp select space(35) + 'return'
  insert into #tblProcTemp select space(28) + 'end'
  insert into #tblProcTemp select space(21) + 'else'
  insert into #tblProcTemp select space(28) + 'begin'
  insert into #tblProcTemp select space(35) + 'commit transaction trnIns' + right(@TableName, datalength(@TableName) - 7)
  insert into #tblProcTemp select space(28) + 'end'
  insert into #tblProcTemp values (space(14) + 'end')
  insert into #tblProcTemp values ('')
  insert into #tblProcTemp values ('GO')
 close csrGetFields
 deallocate csrGetFields
 select * from #tblProcTemp
 drop table #tblProcTemp
 set nocount off

GO
