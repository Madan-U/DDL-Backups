-- Object: PROCEDURE citrus_usr.PR_GETTASK
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_GETTASK]
AS
BEGIN
--
SELECT task_id
,task_name +  case when isnull(uploadfilename,'') <> '' then  '<font color="orange"><B>**' +  isnull(uploadfilename,'')+ '**</B></font>'  else '' end  task_name  
,task_start_dt=isnull(convert(varchar(20),task_start_dt,13),''), 
task_end_date=isnull(convert(varchar(20),task_end_date,13),'') 
,status,usermsg=case when (ltrim(rtrim(isnull(usermsg,''))) <> '' and STATUS <> 'RUNNING' ) then 'Exceptions' WHEN  ltrim(rtrim(isnull(usermsg,''))) = '' and STATUS <> 'RUNNING'  THEN 'No Exception Found' else '' end 
,filedate= isnull(CASE WHEN convert(varchar(11),isnull(task_filedate,'01 Jan 1900'),13) ='01 Jan 1900' THEN  convert(varchar(20),task_end_date,13) ELSE CASE WHEN CONVERT(VARCHAR,task_filedate,108) ='00:00:00' THEN isnull(convert(varchar(11),task_filedate,13),'') + ' ' + CONVERT(VARCHAR,task_end_date,108) ELSE  isnull(convert(varchar(20),task_filedate,13),'') END END,'')
FROM filetask  where convert(varchar,task_start_dt,103) = convert(varchar,getdate(),103)
ORDER BY task_start_dt desc,status


--
END

GO
