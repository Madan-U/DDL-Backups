-- Object: PROCEDURE dbo.usp_getJobStatus
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


    
CREATE    PROCEDURE  usp_getJobStatus     
                          @JobName NVARCHAR (1000)    
    
    AS    
    
    
    ---exec usp_getJobStatus 'AUTO PROCESS SETTLEMENT_'
DECLARE @DEL_JOB_NAME NVARCHAR (1000)    
    
DECLARE @JOBCURSOR CURSOR,    
  @SQL VARCHAR(MAX)    
    
        IF OBJECT_ID('TempDB..#JobResults','U') IS NOT NULL DROP TABLE #JobResults    
        CREATE TABLE #JobResults ( Job_ID   UNIQUEIDENTIFIER NOT NULL,     
                                   Last_Run_Date         INT NOT NULL,     
                                   Last_Run_Time         INT NOT NULL,     
                                   Next_Run_date         INT NOT NULL,     
                                   Next_Run_Time         INT NOT NULL,     
                                   Next_Run_Schedule_ID  INT NOT NULL,     
                                   Requested_to_Run      INT NOT NULL,    
                                   Request_Source        INT NOT NULL,     
                                   Request_Source_id     SYSNAME     
                                   COLLATE Database_Default      NULL,     
                                   Running               INT NOT NULL,    
                                   Current_Step          INT NOT NULL,     
                                   Current_Retry_Attempt INT NOT NULL,     
                                   Job_State             INT NOT NULL )     
    
        INSERT  #JobResults     
        EXECUTE master.dbo.xp_sqlagent_enum_jobs 1, '';     
        
        SELECT  job.name                                                AS [Job_Name],     
             CASE     
                WHEN r.running = 0 THEN    
                    CASE     
                        WHEN jobInfo.lASt_run_outcome = 0 THEN 'Failed'    
                        WHEN jobInfo.lASt_run_outcome = 1 THEN 'Success'    
                        WHEN jobInfo.lASt_run_outcome = 3 THEN 'Canceled'    
                        ELSE 'Unknown'    
                    END    
                        WHEN r.job_state = 0 THEN 'Success'    
                        WHEN r.job_state = 4 THEN 'Success'    
                        WHEN r.job_state = 5 THEN 'Success'    
                        WHEN r.job_state = 1 THEN 'In Progress'    
                        WHEN r.job_state = 2 THEN 'In Progress'    
                        WHEN r.job_state = 3 THEN 'In Progress'    
                        WHEN r.job_state = 7 THEN 'In Progress'    
                     ELSE 'Unknown' END                                 AS [Run_Status_Description]    
  INTO #DELJOB    
        FROM    #JobResults AS r     
            LEFT OUTER JOIN msdb.dbo.sysjobservers AS jobInfo     
               ON r.job_id = jobInfo.job_id     
            INNER JOIN msdb.dbo.sysjobs AS job     
               ON r.job_id = job.job_id   
                 
        WHERE   job.[enabled] = 1    
                AND  job.name LIKE '%' + @JobName + '%'    
    and jobInfo.lASt_run_outcome = 0    
    
  SET @JOBCURSOR = CURSOR FOR    
  SELECT top 1000 Job_Name FROM #DELJOB    
  OPEN @JOBCURSOR    
  FETCH NEXT FROM @JOBCURSOR INTO @DEL_JOB_NAME    
  WHILE @@FETCH_STATUS = 0    
  BEGIN    
   SET @SQL = 'execute msdb..sp_delete_job @job_name=''' + @DEL_JOB_NAME + ''''    
   EXEC (@SQL)    
   --PRINT @SQL 
   FETCH NEXT FROM @JOBCURSOR INTO @DEL_JOB_NAME    
  END    
  CLOSE @JOBCURSOR    
  DEALLOCATE @JOBCURSOR

GO
