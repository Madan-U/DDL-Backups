-- Object: PROCEDURE dbo.sp_KillHungADORecordsets
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--[sp_KillHungADORecordsets] 'Dmat_version'
CREATE PROCEDURE [dbo].[sp_KillHungADORecordsets] @dbname varchar(50)  
AS

CREATE table #oldSpids
( 
    spid int, 
) 

DECLARE @Now DATETIME
SET @Now = GETDATE()

INSERT INTO #oldSpids  
select spid  
from master.dbo.sysprocesses (nolock)  
where dbid = db_id(@dbname)
and spid > 50 
and DATEDIFF(minute,last_batch,@Now) > 10

DECLARE hungSpids CURSOR FAST_FORWARD 
FOR SELECT spid FROM #oldSpids


DECLARE @spid int 

OPEN hungSpids 

DECLARE @strSQL varchar(255) 
DECLARE @sqlHandle VARBINARY(128)
DECLARE @sqlText VARCHAR(MAX)

FETCH NEXT FROM hungSpids INTO @spid
WHILE (@@fetch_status <> -1) 
BEGIN 
    IF (@@fetch_status <> -2) 
    BEGIN 
        SELECT @sqlHandle = sql_handle
        FROM sys.sysprocesses
        WHERE spid = @spid
        SELECT @sqlText = TEXT
        FROM sys.dm_exec_sql_text(@sqlHandle)
print @sqlText
        IF (@sqlText LIKE 'FETCH API_CURSOR%')
        BEGIN
            PRINT 'Killing ' + convert(varchar(10),@spid) 
            SET @strSQL = 'KILL ' + convert(varchar(10),@spid) 
            --EXEC (@strSQL) 
        END 
    END
    FETCH NEXT FROM hungSpids INTO @spid 
END 

CLOSE hungSpids 
DEALLOCATE hungSpids 
DROP table #oldSpids

GO
