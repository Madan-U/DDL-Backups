-- Object: PROCEDURE dbo.PR_SQLTABLEREINDEX
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE  Proc [dbo].[PR_SQLTABLEREINDEX] (@TABLE_NAME AS VARCHAR(254) = '') AS  
/*--------------------------------------------------------------------------------------------------------------------  
Program Name  : PR_SQLTABLEREINDEX  
Desc   : SQL Scripts to   
    1. Re Index all the Transaction Oriented Tables  
    2. Checking Index Key Duplication   
Tables Using  : 1. SQLTableIndex  - Keeping the following Details  
   a. TableName  
   b. IndexName  
   c. IndexColumn  
    2.  SQLTableReIndex_Log - Keeping Re Index Log   
         and Index Duplication Record  
Logic   :   
   Checking the Availability of the Required Index   
    If Found  --  Re Index & Log to SQLTableReIndex_Log with a remark as 'REINDEX'  
    Else   - Create & Log to SQLTableReIndex_Log with a remark as 'NEWINDEX'  
      
   Checking the Index Key Duplication  
    If Found  -- Log to SQLTableReIndex_Log with a remark as 'DUPLICATE'  
Program Benefit :   
   1. Standard Table Index to Maintain  
   2. Re Creation Of Index for performance  
  
----------------------------------------------------------------------------------------------------------------------*/  
  
  
  
Declare   
 @TableCur Cursor,  
 @TableName Varchar(20),  
 @IndexName Varchar(10),  
 @IndexColumn Varchar(100),  
 @IndexColumnChk Varchar(100)  
Declare   
 @TIndexName Varchar(20),  
 @TIndexColum Varchar(100),  
 @strSQL Varchar(200),  
 @IndexCurSor Cursor,  
 @IndexFlag int,  
 @IndexPrv Varchar(20),  
 @IndexColumnPrv Varchar(100),  
  @IndexType varchar(20)  
  
SET NOCOUNT ON  
  
Set @TableCur = Cursor For  
Select  
 TableName,  
 IndexName,  
 IndexColumn,  
 IndexColumnChk = Ltrim(RTrim(Upper(Replace(IndexColumn,',',''))))  
From  
 SQLTableIndex  
Where  
 1 = 1  
 and TableName = (case when isnull(@TABLE_NAME,'') <> '' then @TABLE_NAME else TableName end)   
  
  
Open @TableCur  
Fetch Next From @TableCur Into  @TableName,@IndexName,@IndexColumn,@IndexColumnChk  
While @@Fetch_Status = 0         
Begin        
 Set @IndexFlag  = 0  
 Set @IndexColumnPrv = ''  
 Set @IndexPrv = ''  
 Set @IndexCurSor = Cursor for Select * From   
 (  
  Select   
   i.name as IndexName,  
   case when (i.status & 16)<> 0 then 'CLUSTERED'   
   else 'NONCLUSTERED' end as IndexType,  
   upper(isnull(index_col(@TableName, i.indid,1 ),'')+isnull(index_col(@TableName, i.indid,2 ),'')  
   +isnull(index_col(@TableName, i.indid,3 ),'')+isnull(index_col(@TableName, i.indid,4 ),'')  
   +isnull(index_col(@TableName, i.indid,5 ),'')+isnull(index_col(@TableName, i.indid,6),'')  
   +isnull(index_col(@TableName, i.indid,7 ),'')+isnull(index_col(@TableName, i.indid,8),'') ) as IndexColumns  
  from   
   (dbo.sysindexes i inner join dbo.sysfilegroups s on i.groupid = s.groupid )  
  where   
   id = object_id(@TableName) and i.indid > 0 and i.indid < 255 and  
   (INDEXPROPERTY(object_id(@TableName), i.name, N'IsStatistics') <> 1) and  
   (INDEXPROPERTY(object_id(@TableName), i.name, N'IsAutoStatistics') <> 1) and  
   (INDEXPROPERTY(object_id(@TableName), i.name, N'IsHypothetical') <> 1)  
     
 )TblIdx  Order By IndexColumns  
 Open @IndexCurSor  
 Fetch Next From @IndexCurSor into @TIndexName,@IndexType,@TIndexColum  
 While @@Fetch_Status = 0         
 Begin       
  if @IndexColumnPrv = @TIndexColum  
   Begin  
    Insert Into SQLTableReIndex_Log Values   
    (@TableName,@IndexPrv,@TIndexColum,'DUPLICATE',@@SPId,GetDate())   
   End   
  If (@TIndexColum = @IndexColumnChk OR @IndexName = @TIndexName) AND @IndexFlag =0  
   Begin  
    Set @IndexFlag  = 1  
    Set @strSQL = 'CREATE ' + @IndexType + ' INDEX ['+ @TIndexName +'] ON [dbo].['+@TableName+']('  
    Set @strSQL = @strSQL + @IndexColumn + ')'  
    Set @strSQL = @strSQL + ' WITH  DROP_EXISTING ON [PRIMARY]'  
    Exec (@strSQL)  
    Insert Into SQLTableReIndex_Log Values   
    (@TableName,@TIndexName,@IndexColumn,'REINDEX',@@SPId,GetDate())  
   End  
  Set @IndexPrv = @TIndexName  
  Set @IndexColumnPrv = @TIndexColum  
  Fetch Next From @IndexCurSor into @TIndexName,@IndexType,@TIndexColum  
 End        
 Close @IndexCurSor   
 DeAllocate @IndexCurSor  
 if @IndexFlag =0  
  Begin  
   Set @strSQL = 'CREATE INDEX ['+ @IndexName +'] ON [dbo].['+@TableName+']('  
   Set @strSQL = @strSQL + @IndexColumn + ')'  
   Exec (@strSQL)  
   Insert Into SQLTableReIndex_Log Values   
   (@TableName,@IndexName,@IndexColumn,'NEWINDEX',@@SPId,GetDate())  
  End  
 Fetch Next From @TableCur Into  @TableName,@IndexName,@IndexColumn,@IndexColumnChk  
End  
Close @TableCur        
DeAllocate @TableCur

GO
