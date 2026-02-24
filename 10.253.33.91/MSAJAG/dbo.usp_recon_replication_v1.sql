-- Object: PROCEDURE dbo.usp_recon_replication_v1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc [dbo].[usp_recon_replication_v1]
as begin



  CREATE TABLE #SpaceUsed (
	 TableName sysname
	,NumRows BIGINT
	,ReservedSpace VARCHAR(50)
	,DataSpace VARCHAR(50)
	,IndexSize VARCHAR(50)
	,UnusedSpace VARCHAR(50)
	) 

CREATE TABLE #TempUsed (tablename VARCHAR(200),NumRows VARCHAR(500),DB VARCHAR(50)) 


DECLARE @str VARCHAR(500)
SET @str =  'exec  [MSAJAG].dbo.sp_spaceused ''?'''

INSERT INTO #SpaceUsed 
EXEC [MSAJAG].dbo.sp_msforeachtable @command1=@str

--insert into #TempUsed(tablename,NumRows,DB)
--SELECT replace( replace( replace(TableName,'[dbo].',''),'[',''),']','') as tablename ,NumRows,'MSAJAG' as DB 
--FROM #SpaceUsed ORDER BY TableName

insert into #TempUsed(tablename,NumRows,DB)
select tablename,sum(NumRows) as NumRows,db from (SELECT replace( replace( replace(TableName,'[dbo].',''),'[',''),']','') as tablename ,NumRows,'MSAJAG' as DB 
FROM #SpaceUsed)m
group by tablename,DB

--DECLARE @str VARCHAR(500)
SET @str =  'exec [ACCOUNT].dbo.sp_spaceused ''?'''

truncate table #SpaceUsed

INSERT INTO #SpaceUsed 
EXEC [ACCOUNT].dbo.sp_msforeachtable @command1=@str

insert into #TempUsed(tablename,NumRows,DB)
select tablename,sum(NumRows) as NumRows,db from (SELECT replace( replace( replace(TableName,'[dbo].',''),'[',''),']','') as tablename ,NumRows,'ACCOUNT' as DB 
FROM #SpaceUsed)m
group by tablename,DB

SET @str =  'exec [MTFTRADE].dbo.sp_spaceused ''?'''

truncate table #SpaceUsed

INSERT INTO #SpaceUsed 
EXEC [MTFTRADE].dbo.sp_msforeachtable @command1=@str

insert into #TempUsed(tablename,NumRows,DB)
select tablename,sum(NumRows) as NumRows,db from (SELECT replace( replace( replace(TableName,'[dbo].',''),'[',''),']','') as tablename ,NumRows,'MTFTRADE' as DB 
FROM #SpaceUsed)m
group by tablename,DB



update r
set r.cnt=u.NumRows
from tbl_nsecash_replication r
join #TempUsed u
on r.TableName=u.tablename
and r.DB=u.DB

end

GO
