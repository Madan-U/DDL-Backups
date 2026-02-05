-- Object: PROCEDURE citrus_usr.ExecuteSQL_ByAgentJob_usp
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

    
    
CREATE PROCEDURE citrus_usr.[ExecuteSQL_ByAgentJob_usp](    
    @SqlStatemet            VARCHAR(4000),    
    @SPNameOrStmntTitle     VARCHAR(100),    
    @JobRunningUser         VARCHAR(100) = NULL,    
    @JobIdOut               UNIQUEIDENTIFIER OUTPUT    
)    
AS    
BEGIN    
     
 SET NOCOUNT ON    
     
 DECLARE @JobId          UNIQUEIDENTIFIER,    
   @JobName        VARCHAR(250),    
   @DBName         VARCHAR(100),    
   @ServerName     VARCHAR(100)     
     
 SET @JOBNAME = NULL    
 SET @DBName = DB_NAME()    
 SET @ServerName = @@SERVERNAME    
    
 --Creating Unique Job Name by combining @SPNameOrStmntTitle and a GUID.      
 SET @JobName = @SPNameOrStmntTitle + '_' + CONVERT(VARCHAR(64), NEWID())     
     
 --Currently logged user name will be used to execute the job if not provided one.    
 IF @JobRunningUser IS NULL    
  SET @JobRunningUser = SUSER_NAME()    
     
 --Adds a new job executed by the SQLServerAgent service    
 EXECUTE msdb..sp_add_job @job_name = @JobName, @owner_login_name = @JobRunningUser,     
 @job_id = @JobId OUTPUT     
     
 --Targets the specified job at the specified server     
 EXECUTE msdb..sp_add_jobserver @job_id = @JobId, @server_name = @ServerName     
     
 --Tell job for its about its first step.    
 EXECUTE msdb..sp_add_jobstep @job_id = @JobId, @step_name = 'Step1', @command     
 = @SqlStatemet,@database_name = @DBName, @on_success_action = 3     
     
 --Preparing the command to delete the job immediately after executing the statements     
 DECLARE @sql VARCHAR(250)     
     
 SET @SQL = 'execute msdb..sp_delete_job @job_name=''' + @JobName + ''''    
     
 EXECUTE msdb..sp_add_jobstep @job_id = @JobId, @step_name = 'Step2', @command = @sql     
     
 --Run the job    
 EXECUTE msdb..sp_start_job @job_id = @JobId    
     
 --Return the Job via output param.    
 SET @JobIdOut = @JobId    
END

GO
