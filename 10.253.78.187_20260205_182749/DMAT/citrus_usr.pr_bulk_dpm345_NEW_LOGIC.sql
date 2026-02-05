-- Object: PROCEDURE citrus_usr.pr_bulk_dpm345_NEW_LOGIC
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--create table tmp_dpm5(value varchar(8000))
--select top 0 * into dpm345  from DP_DAILY_HLDG_CDSL
--select * from filetask order by task_id desc
--PR_BULK_DPM345 'MIG','','1863','BULK','D:\11DPM5UX.13052011.TXT','','',''
CREATE proc [citrus_usr].[pr_bulk_dpm345_NEW_LOGIC]
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
select @l_holding_dt = convert(datetime,left(value,2)+'/'+substring(value,3,2)+'/'+substring(value,5,4),103)
from tmp_dpm5
where len(value)<16
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



IF EXISTS(SELECT CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~') FROM TMP_DPM5 WHERE CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~') not in (select dpam_sba_no from dp_acct_mstr where dpam_dpm_id = @l_dpm_id and dpam_deleted_ind =1 ) and len(VALUE) > 16) 																					
BEGIN
--

declare @l_string  varchar(8000)
set @l_string   = '' 
select @l_string  = @l_string    + CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~') + ',' 
FROM TMP_DPM5 
WHERE CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~') 
not in (select dpam_sba_no from dp_acct_mstr where dpam_dpm_id = @l_dpm_id and dpam_deleted_ind = 1 )
and len(VALUE) > 16

UPDATE filetask
SET    usermsg = 'ERROR : Following Client Not Mapped ' + @l_string
WHERE  task_id = @pa_task_id
--
END



PRINT 'split data and insert into temp table'

INSERT INTO dpm345 (DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_CURR_QTY
,DPHMCD_FREE_QTY,DPHMCD_FREEZE_QTY,DPHMCD_PLEDGE_QTY,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY
,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY
,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY,DPHMCD_HOLDING_DT
,DPHMCD_CREATED_BY,DPHMCD_CREATED_DT,DPHMCD_LST_UPD_BY,DPHMCD_LST_UPD_DT,DPHMCD_DELETED_IND
,DPHMCD_CNTR_SETTM_ID)
SELECT @L_DPM_ID, DPAM_ID , CITRUS_USR.FN_SPLITVAL_BY(VALUE,2,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,11,'~')
,CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~'),0,CITRUS_USR.FN_SPLITVAL_BY(VALUE,5,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,12,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,8,'~')
,CITRUS_USR.FN_SPLITVAL_BY(VALUE,13,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,7,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,4,'~'),0
,CITRUS_USR.FN_SPLITVAL_BY(VALUE,6,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,9,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,14,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,15,'~'),@L_HOLDING_DT
,@pa_login_name,GETDATE(),@pa_login_name,GETDATE(),1
,CITRUS_USR.FN_SPLITVAL_BY(VALUE,19,'~')
FROM TMP_DPM5, dp_Acct_mstr 
where CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~') = dpam_sba_no 
and dpam_deleted_ind = 1

PRINT 'insert those data which holding not chenged so not coming in dpm5, carry forward data of previous date from holding table '


insert into dpm345
select DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_CURR_QTY,DPHMCD_FREE_QTY
,DPHMCD_FREEZE_QTY,DPHMCD_PLEDGE_QTY,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY
,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY
,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY,@l_holding_dt
,@pa_login_name,getdate(),@pa_login_name,getdate(),1
,dphmcd_cntr_settm_id from DP_DAILY_HLDG_CDSL b
where not exists (select DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,dphmcd_cntr_settm_id from dpm345 a where isnull(a.DPHMCD_DPM_ID,'0') =isnull( b.DPHMCD_DPM_ID,'0')
and isnull(a.DPHMCD_DPAM_ID,'0') = isnull(b.DPHMCD_DPAM_ID,'0')
and isnull(a.DPHMCD_ISIN ,'')= isnull(b.DPHMCD_ISIN,'')
and isnull(a.dphmcd_cntr_settm_id,'') = isnull(b.dphmcd_cntr_settm_id,'')
)
and DPHMCD_DPM_ID = @l_dpm_id 
and dphmcd_holding_dt = @l_holding_dt


UPDATE B
SET DPHMCD_HOLDING_TO_DT = @l_holding_dt
FROM DP_DAILY_HLDG_CDSL B ,dpm345 A 
WHERE isnull(a.DPHMCD_DPAM_ID,'0') = isnull(b.DPHMCD_DPAM_ID,'0')
and isnull(a.DPHMCD_ISIN ,'')= isnull(b.DPHMCD_ISIN,'')
and isnull(a.dphmcd_cntr_settm_id,'') = isnull(b.dphmcd_cntr_settm_id,'')
AND B.DPHMCD_HOLDING_DT < @l_holding_dt


--insert into dpm345
--select DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_CURR_QTY,DPHMCD_FREE_QTY
--,DPHMCD_FREEZE_QTY,DPHMCD_PLEDGE_QTY,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY
--,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY
--,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY,@l_holding_dt
--,@pa_login_name,getdate(),@pa_login_name,getdate(),1
--,dphmcd_cntr_settm_id from DP_DAILY_HLDG_CDSL b
--where not exists (select DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,dphmcd_cntr_settm_id from dpm345 a where isnull(a.DPHMCD_DPM_ID,'0') =isnull( b.DPHMCD_DPM_ID,'0')
--and isnull(a.DPHMCD_DPAM_ID,'0') = isnull(b.DPHMCD_DPAM_ID,'0')
--and isnull(a.DPHMCD_ISIN ,'')= isnull(b.DPHMCD_ISIN,'')
--and isnull(a.dphmcd_cntr_settm_id,'') = isnull(b.dphmcd_cntr_settm_id,'')
--)
--and DPHMCD_DPM_ID = @l_dpm_id 
--and dphmcd_holding_dt = (select max(dphmcd_holding_dt) from DP_DAILY_HLDG_CDSL where dphmcd_holding_dt < @l_holding_dt)




PRINT 'delete those data from temp table which has same data available in holding tabel(same file import more than one time)'
delete a from dpm345 a, DP_DAILY_HLDG_CDSL b
where isnull(a.DPHMCD_DPM_ID,'0') =isnull( b.DPHMCD_DPM_ID,'0')
and isnull(a.DPHMCD_DPAM_ID,'0') = isnull(b.DPHMCD_DPAM_ID,'0')
and isnull(a.DPHMCD_ISIN ,'')= isnull(b.DPHMCD_ISIN,'')
and isnull(a.DPHMCD_CURR_QTY,'0')= isnull(b.DPHMCD_CURR_QTY,'0')
and isnull(a.DPHMCD_FREE_QTY,'0')= isnull(b.DPHMCD_FREE_QTY,'0')
and isnull(a.DPHMCD_FREEZE_QTY,'0')= isnull(b.DPHMCD_FREEZE_QTY,'0')
and isnull(a.DPHMCD_PLEDGE_QTY,'0')= isnull(b.DPHMCD_PLEDGE_QTY,'0')
and isnull(a.DPHMCD_DEMAT_PND_VER_QTY,'0')= isnull(b.DPHMCD_DEMAT_PND_VER_QTY,'0')
and isnull(a.DPHMCD_REMAT_PND_CONF_QTY,'0')= isnull(b.DPHMCD_REMAT_PND_CONF_QTY,'0')
and isnull(a.DPHMCD_DEMAT_PND_CONF_QTY,'0')= isnull(b.DPHMCD_DEMAT_PND_CONF_QTY,'0')
and isnull(a.DPHMCD_SAFE_KEEPING_QTY,'0')= isnull(b.DPHMCD_SAFE_KEEPING_QTY,'0')
and isnull(a.DPHMCD_LOCKIN_QTY,'0')= isnull(b.DPHMCD_LOCKIN_QTY,'0')
and isnull(a.DPHMCD_ELIMINATION_QTY,'0')= isnull(b.DPHMCD_ELIMINATION_QTY,'0')
and isnull(a.DPHMCD_EARMARK_QTY,'0')= isnull(b.DPHMCD_EARMARK_QTY,'0')
and isnull(a.DPHMCD_AVAIL_LEND_QTY,'0')= isnull(b.DPHMCD_AVAIL_LEND_QTY,'0')
and isnull(a.DPHMCD_LEND_QTY,'0')= isnull(b.DPHMCD_LEND_QTY,'0')
and isnull(a.DPHMCD_BORROW_QTY,'0')= isnull(b.DPHMCD_BORROW_QTY,'0')
and isnull(a.DPHMCD_HOLDING_DT,'')= isnull(b.DPHMCD_HOLDING_DT,'')
and isnull(a.dphmcd_cntr_settm_id,'') = isnull(b.dphmcd_cntr_settm_id,'')

PRINT 'delete those data from holding table , dpm4 , same client same script same date but holding diffrent'

delete b from dpm345 a, DP_DAILY_HLDG_CDSL b
where isnull(a.DPHMCD_DPM_ID,'0') =isnull( b.DPHMCD_DPM_ID,'0')
and isnull(a.DPHMCD_DPAM_ID,'0') = isnull(b.DPHMCD_DPAM_ID,'0')
and isnull(a.DPHMCD_ISIN ,'')= isnull(b.DPHMCD_ISIN,'')
and (isnull(a.DPHMCD_CURR_QTY,'0')<> isnull(b.DPHMCD_CURR_QTY,'0')
or isnull(a.DPHMCD_FREE_QTY,'0')<> isnull(b.DPHMCD_FREE_QTY,'0')
or  isnull(a.DPHMCD_FREEZE_QTY,'0')<> isnull(b.DPHMCD_FREEZE_QTY,'0')
or  isnull(a.DPHMCD_PLEDGE_QTY,'0')<> isnull(b.DPHMCD_PLEDGE_QTY,'0')
or  isnull(a.DPHMCD_DEMAT_PND_VER_QTY,'0')<> isnull(b.DPHMCD_DEMAT_PND_VER_QTY,'0')
or  isnull(a.DPHMCD_REMAT_PND_CONF_QTY,'0')<> isnull(b.DPHMCD_REMAT_PND_CONF_QTY,'0')
or  isnull(a.DPHMCD_DEMAT_PND_CONF_QTY,'0')<> isnull(b.DPHMCD_DEMAT_PND_CONF_QTY,'0')
or  isnull(a.DPHMCD_SAFE_KEEPING_QTY,'0')<> isnull(b.DPHMCD_SAFE_KEEPING_QTY,'0')
or  isnull(a.DPHMCD_LOCKIN_QTY,'0')<> isnull(b.DPHMCD_LOCKIN_QTY,'0')
or  isnull(a.DPHMCD_ELIMINATION_QTY,'0')<> isnull(b.DPHMCD_ELIMINATION_QTY,'0')
or  isnull(a.DPHMCD_EARMARK_QTY,'0')<> isnull(b.DPHMCD_EARMARK_QTY,'0')
or  isnull(a.DPHMCD_AVAIL_LEND_QTY,'0')<> isnull(b.DPHMCD_AVAIL_LEND_QTY,'0')
or  isnull(a.DPHMCD_LEND_QTY,'0')<> isnull(b.DPHMCD_LEND_QTY,'0')
or isnull(a.DPHMCD_BORROW_QTY,'0')<> isnull(b.DPHMCD_BORROW_QTY,'0'))
and isnull(a.DPHMCD_HOLDING_DT,'')= isnull(b.DPHMCD_HOLDING_DT,'')
and isnull(a.dphmcd_cntr_settm_id,'') = isnull(b.dphmcd_cntr_settm_id,'')


--insert remaing data 
insert into DP_DAILY_HLDG_CDSL
select  *,NULL from dpm345

--select @l_holding_dt_mak  = max(DPHMCD_HOLDING_DT) from DP_DAILY_HLDG_CDSL

--insert into DP_HLDG_mstr_CDSL
--select * from DP_DAILY_HLDG_CDSL where DPHMCD_HOLDING_DT = @l_holding_dt_mak  

truncate table dpm345

UPDATE filetask
SET    TASK_FILEDATE =@l_holding_dt
WHERE  task_id = @pa_task_id



end

GO
