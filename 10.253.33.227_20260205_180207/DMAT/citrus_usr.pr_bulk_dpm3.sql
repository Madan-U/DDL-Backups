-- Object: PROCEDURE citrus_usr.pr_bulk_dpm3
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--create table tmp_dpm5(value varchar(8000))
--select top 0 * into dpm345  from DP_DAILY_HLDG_CDSL
--select * from filetask order by task_id desc
--PR_BULK_DPM345 'MIG','','1863','BULK','D:\11DPM5UX.13052011.TXT','','',''
create proc [citrus_usr].[pr_bulk_dpm3]
(  
 @PA_LOGIN_NAME    VARCHAR(20) 
,@PA_DPMDPID          VARCHAR(20)    
,@PA_TASK_ID        NUMERIC
,@PA_MODE          VARCHAR(10)                                    
,@PA_DB_SOURCE     VARCHAR(250)    
,@ROWDELIMITER     CHAR(4) =     '*|~*'      
,@COLDELIMITER     CHAR(4) =     '|*~|'      
,@PA_ERRMSG        VARCHAR(8000) OUTPUT)

as
begin 




truncate table tmp_dpm5 
truncate table dpm345

DECLARE @@SSQL VARCHAR(8000)  
SET @@SSQL ='BULK INSERT tmp_dpm5 FROM ''' + @PA_DB_SOURCE + ''' WITH   
(  
FIELDTERMINATOR = ''\n'',  
ROWTERMINATOR = ''\n''  

)'  

EXEC(@@SSQL) 

IF (select count(*) from tmp_dpm5) = 0
BEGIN
--

UPDATE filetask
SET    usermsg = 'ERROR : No Data Found in File '  
WHERE  task_id = @pa_task_id

return 
--
END


declare @l_holding_dt datetime 
declare @l_holding_dt_mak datetime 
select @l_holding_dt = convert(datetime,left(citrus_usr.fn_splitval_by(value,2,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,2,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,2,'~'),5,4),103)
from tmp_dpm5
where citrus_usr.ufn_countstring(value,'~')<3
print 'Holding date : ' + convert(varchar(11),@l_holding_dt,109)

declare @l_dpm_dpid varchar(50)
set @l_dpm_dpid  = ''
select top  1 @l_dpm_dpid = left(citrus_usr.fn_splitval_by(value,1,'~') ,8)
from tmp_dpm5
where len(value)>16

IF @L_DPM_DPID  = '' 
SET @L_DPM_DPID  = @PA_DPMDPID


print 'dpmdpid : ' + @L_DPM_DPID


declare @l_dpm_id  numeric
set @l_dpm_id = 0
select @l_dpm_id  = dpm_id  from dp_mstr where dpm_dpid= @l_dpm_dpid -- and default_dp = dpm_excsm_id  


--DPHMCD_AVAIL_LEND_QTY = Pledge Setup Balance
--Borrowed Balance      = Pledgee Balance
--DPHMCD_FREEZE_QTY     = 0
--DPHMCD_ELIMINATION_QTY = 0

IF @l_dpm_id = 0
BEGIN
--

UPDATE filetask
SET    usermsg = 'ERROR : DPID NOT MATCHED'  
WHERE  task_id = @pa_task_id

return 
--
END

if @l_holding_dt <> ''
delete from DP_DAILY_HLDG_CDSL where DPHMCD_DPM_ID = @l_dpm_id and DPHMCD_HOLDING_DT = @l_holding_dt


--insert remaing data 
insert into DP_DAILY_HLDG_CDSL
select  *,NULL from dpm345

--select @l_holding_dt_mak  = max(DPHMCD_HOLDING_DT) from DP_DAILY_HLDG_CDSL

--insert into DP_HLDG_mstr_CDSL
--select * from DP_DAILY_HLDG_CDSL where DPHMCD_HOLDING_DT = @l_holding_dt_mak  


UPDATE filetask
SET    TASK_FILEDATE =@l_holding_dt
WHERE  task_id = @pa_task_id



end

GO
