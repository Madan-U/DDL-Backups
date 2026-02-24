-- Object: PROCEDURE dbo.Get_JoBStatus
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

   
CREATE procedure Get_JoBStatus    
(@jobname varchar(500),    
@Status varchar(20)=''  output)    
as    
begin    
    
DECLARE @Job_ID as varchar(100)    
SELECT @Job_ID= JOB_ID       
 FROM msdb.dbo.sysjobs         
 WHERE name =@jobname -- you can specify a job id to query for a certain job    
 --IF (((DATEPART(DW,GETDATE()) = 1) or (DATEPART(DW,GETDATE()) = 7)) OR((DATEPART(DW,GETDATE())=2) and (DATEPART(HH,GETDATE())<=7)))      
--DECLARE @Job_ID as varchar(100)    
--SET @Job_ID = '%' -- you can specify a job id to query for a certain job     
    
    
CREATE TABLE #JobResults    
    (job_id uniqueidentifier NOT NULL,     
    last_run_date int NOT NULL,     
    last_run_time int NOT NULL,     
    next_run_date int NOT NULL,     
    next_run_time int NOT NULL,     
    next_run_schedule_id int NOT NULL,     
    requested_to_run int NOT NULL, /* bool*/     
    request_source int NOT NULL,     
    request_source_id sysname     
    COLLATE database_default NULL,     
    running int NOT NULL, /* bool*/     
    current_step int NOT NULL,     
    current_retry_attempt int NOT NULL,     
    job_state int NOT NULL)     
    
INSERT    #JobResults     
EXEC master.dbo.xp_sqlagent_enum_jobs 1, '';    
    
SELECT        
    r.job_id,     
    job.name as Job_Name,     
        
    (select top 1 start_execution_date     
            FROM [msdb].[dbo].[sysjobactivity]    
            where job_id = r.job_id    
            order by start_execution_date desc) as Job_Start_DateTime,    
                
    cast((select top 1 ISNULL(stop_execution_date, GETDATE()) - start_execution_date      
            FROM [msdb].[dbo].[sysjobactivity]    
            where job_id = r.job_id    
            order by start_execution_date desc) as time) as Job_Duration,     
                
    r.current_step AS Current_Running_Step_ID,    
    CASE     
        WHEN r.running = 0 then jobinfo.last_run_outcome    
        ELSE    
            --convert to the uniform status numbers (my design)    
            CASE    
                WHEN r.job_state = 0 THEN 1    --success    
                WHEN r.job_state = 4 THEN 1    
                WHEN r.job_state = 5 THEN 1    
                WHEN r.job_state = 1 THEN 2    --in progress    
                WHEN r.job_state = 2 THEN 2    
                WHEN r.job_state = 3 THEN 2    
                WHEN r.job_state = 7 THEN 2    
            END    
    END as Run_Status,    
    CASE     
        WHEN r.running = 0 then     
            -- convert to the uniform status numbers (my design)    
            -- no longer running, use the last outcome in the sysjobservers    
            -- sysjobservers will give last run status, but does not know about current running jobs    
            CASE     
                WHEN jobInfo.last_run_outcome = 0 THEN 'Failed'    
                WHEN jobInfo.last_run_outcome = 1 THEN 'Success'    
                WHEN jobInfo.last_run_outcome = 3 THEN 'Canceled'    
                ELSE 'Unknown'    
            end    
            -- convert to the uniform status numbers (my design)    
            -- if running, use the job state in xp_sqlagent_enum_jobs        
            -- xp_sqlagent_enum_jobs will give current status, but does not know if a completed job    
            -- succeeded, failed or was canceled.    
            WHEN r.job_state = 0 THEN 'Success'    
            WHEN r.job_state = 4 THEN 'Success'    
            WHEN r.job_state = 5 THEN 'Success'    
            WHEN r.job_state = 1 THEN 'In Progress'    
            WHEN r.job_state = 2 THEN 'In Progress'    
            WHEN r.job_state = 3 THEN 'In Progress'    
            WHEN r.job_state = 7 THEN 'In Progress'    
         ELSE 'Unknown' END AS Run_Status_Description    
         into #JobResultsFinal    
FROM    #JobResults as r left join    
        msdb.dbo.sysjobservers as jobInfo on r.job_id = jobInfo.job_id inner join    
      msdb.dbo.sysjobs as job on r.job_id = job.job_id     
WHERE    cast(r.job_id as varchar(100)) like @Job_ID    
        and job.[enabled] = 1    
order by job.name    
select  @Status=Run_Status_Description from #JobResultsFinal    
    
end

GO
