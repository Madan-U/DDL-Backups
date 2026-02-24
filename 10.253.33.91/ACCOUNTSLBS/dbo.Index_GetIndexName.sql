-- Object: PROCEDURE dbo.Index_GetIndexName
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE Proc Index_GetIndexName As  
Declare @TableName Varchar(100),  
@CurTbl Cursor,  
@Sql Varchar(150)  
  
Create Table #Tbl_Index  
(Sno Int IDENTITY (1, 1) NOT NULL,  
 IndexName Varchar(100) NOT NULL,  
 TableName Varchar(100) NOT NULL)  
  
Set @CurTbl = Cursor For  
Select Name From Sysobjects   
Where xType = 'U'  
Order By Name   
Open @CurTbl  
Fetch Next from  @CurTbl into @TableName  
While @@Fetch_Status = 0   
Begin  
 Insert Into #Tbl_Index  

      Select i.name, TableName=@TableName
      from (dbo.sysindexes i inner join
         dbo.sysfilegroups s on
         i.groupid = s.groupid )
      where id = object_id(@TableName) and i.indid > 0 and i.indid < 255 and
      (INDEXPROPERTY(object_id(@TableName), i.name, N'IsStatistics') <> 1) and
      (INDEXPROPERTY(object_id(@TableName), i.name, N'IsAutoStatistics') <> 1) and
      (INDEXPROPERTY(object_id(@TableName), i.name, N'IsHypothetical') <> 1) 

   
 Fetch Next from  @CurTbl into @TableName  
End  
Close @CurTbl  
DeAllocate @CurTbl  
  
Select * From #Tbl_Index  
Order By TableName, IndexName

GO
