-- Object: PROCEDURE citrus_usr.pr_eod_curr_status
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE Proc [citrus_usr].[pr_eod_curr_status]
as
begin

create table #tmp (task_name varchar(100),last_dt datetime,status varchar(60),ord_by int)
insert into #tmp 
SELECT task_name,last_dt = max(CONVERT(DATETIME,CASE WHEN convert(varchar(11),task_filedate,13) ='01 Jan 1900' THEN  convert(varchar(20),task_end_date,13) ELSE CASE WHEN CONVERT(VARCHAR,task_filedate,108) ='00:00:00' THEN isnull(convert(varchar(11),task_filedate,13),'') + ' ' + CONVERT(VARCHAR,task_end_date,108) ELSE  isnull(convert(varchar(20),task_filedate,13),'') END END)),'COMPLETED',ord_by=case when patindex('%NSDL%',task_name) <> 0 then 1 else 4 end
from filetask where task_name not like 'DPM TRANSACTION FILE(%' and status = 'COMPLETED'
group by task_name




INSERT INTO #TMP
select task_name = case when batchn_type ='C' THEN 'CLIENT BATCH - (' ELSE 'TRANSACTION BATCH - (' END + CONVERT(VARCHAR,BATCHN_NO) + ')' ,
--LAST_DT = BATCHN_FILEGEN_DT,
LAST_DT = CASE WHEN CONVERT(VARCHAR,BATCHN_FILEGEN_DT,108) ='00:00:00' THEN isnull(convert(varchar(11),BATCHN_FILEGEN_DT,13),'') + ' ' + CONVERT(VARCHAR,BATCHN_CREATED_DT,108) ELSE  isnull(convert(varchar(20),BATCHN_FILEGEN_DT,13),'') END, 
status = case when batchn_status = 'P' then 'Batch Request Generated' 
					 WHEN batchn_status = 'A' THEN 'Normal - Successful Verification Release'
					 when batchn_status = 'R' then 'Normal - Failure during Verification Release'
					 WHEN batchn_status = 'VRA' THEN 'VR - Successful Verification Release'
					 when batchn_status = 'VRR' then 'VR - Failure during Verification Release'
					 else '' end,
ord_by =case when batchn_type ='C' then 3 else 2 end
from BATCHNO_NSDL_MSTR 
WHERE CONVERT(varchar,BATCHN_CREATED_DT,103) = CONVERT(varchar,GETDATE(),103)



INSERT INTO #TMP
select task_name = case when batchC_type ='C' THEN 'CLIENT BATCH - (' ELSE 'TRANSACTION BATCH - (' END + CONVERT(VARCHAR,BATCHC_NO) + ')' ,
--LAST_DT = BATCHC_FILEGEN_DT,
LAST_DT = CASE WHEN CONVERT(VARCHAR,BATCHC_FILEGEN_DT,108) ='00:00:00' THEN isnull(convert(varchar(11),BATCHC_FILEGEN_DT,13),'') + ' ' + CONVERT(VARCHAR,BATCHC_CREATED_DT,108) ELSE  isnull(convert(varchar(20),BATCHC_FILEGEN_DT,13),'') END, 
status = case when batchc_status = 'P' then 'Batch Request Generated' 
					 WHEN batchc_status = 'A' THEN 'Successful Verification Release'
					 when batchc_status = 'R' then 'Failure during Verification Release'
					 else '' end,
ord_by =case when batchc_type ='C' then 6 else 5 end
from BATCHNO_CDSL_MSTR 
WHERE CONVERT(varchar,BATCHC_CREATED_DT,103) = CONVERT(varchar,GETDATE(),103)



select task_name,last_dt=CONVERT(VARCHAR(20),last_dt,13),status,ord_by from #TMP order by ord_by,Reverse(task_name)
truncate table #TMP
drop table #TMP
end

GO
