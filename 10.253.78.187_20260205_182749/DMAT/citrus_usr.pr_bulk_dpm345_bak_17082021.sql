-- Object: PROCEDURE citrus_usr.pr_bulk_dpm345_bak_17082021
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



--create table tmp_dpm5(value varchar(8000))
--select top 0 * into dpm345  from DP_DAILY_HLDG_CDSL
--select * from filetask order by task_id desc
--PR_BULK_DPM345 'MIG','','1863','BULK','D:\DPData Migration\DPM3\33200\11DPM3UX.30092010.30092010','','',''
CREATE proc [citrus_usr].[pr_bulk_dpm345_bak_17082021]
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



update filetask
set uploadfilename = citrus_usr.fn_splitval_by(@PA_DB_SOURCE,citrus_usr.ufn_countstring(@PA_DB_SOURCE,'\')+1,'\')
WHERE  task_id = @pa_task_id

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
select @l_holding_dt = 
convert(datetime,substring(citrus_usr.fn_splitval_by(value,2,'~'),1,2) + '/' + substring(citrus_usr.fn_splitval_by(value,2,'~'),3,2) + '/' + substring(citrus_usr.fn_splitval_by(value,2,'~'),5,4),103)
from tmp_dpm5
where citrus_usr.ufn_countstring(value,'~')<3
print 'Holding date : ' + convert(varchar(11),@l_holding_dt,109)



IF @l_holding_dt is null 
BEGIN
--

UPDATE filetask
SET    usermsg = 'ERROR : Holding Date is Not Available in the File' ,TASK_END_DATE = getdate() ,STATUS ='FAILED'
WHERE  task_id = @pa_task_id

return 
--
END

declare @l_dpm_dpid varchar(50)
set @l_dpm_dpid  = ''
select top  1 @l_dpm_dpid = left(citrus_usr.fn_splitval_by(value,1,'~') ,8)
from tmp_dpm5
where len(value)>40

print @l_dpm_dpid

IF @L_DPM_DPID <> @PA_DPMDPID 
BEGIN
--

UPDATE filetask
SET    usermsg = 'ERROR : DPID NOT MATCHED WITH IMPORTED FILE' ,TASK_END_DATE = getdate() ,STATUS ='FAILED'
WHERE  task_id = @pa_task_id

return 
--
END


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
SET    usermsg = 'ERROR : DPID NOT MATCHED'  ,TASK_END_DATE = getdate(),STATUS ='FAILED'
WHERE  task_id = @pa_task_id

return 
--
END



--IF EXISTS(SELECT CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~') FROM TMP_DPM5 WHERE CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~') not in (select dpam_sba_no from dp_acct_mstr where dpam_dpm_id = @l_dpm_id and dpam_deleted_ind =1 ) and len(VALUE) > 16) 																					
--BEGIN
----
--
--declare @l_string  varchar(8000)
--set @l_string   = '' 
--select @l_string  = @l_string    + CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~') + ',' 
--FROM TMP_DPM5 
--WHERE CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~') 
--not in (select dpam_sba_no from dp_acct_mstr where dpam_dpm_id = @l_dpm_id and dpam_deleted_ind = 1 )
--and len(VALUE) > 16
--
--UPDATE filetask
--SET    usermsg = 'ERROR : Following Client Not Mapped ' + @l_string
--WHERE  task_id = @pa_task_id
----
--END



PRINT 'split data and insert into temp table'

INSERT INTO dpm345 (DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_CURR_QTY
,DPHMCD_FREE_QTY,DPHMCD_FREEZE_QTY,DPHMCD_PLEDGE_QTY,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY
,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY
,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY,DPHMCD_HOLDING_DT
,DPHMCD_CREATED_BY,DPHMCD_CREATED_DT,DPHMCD_LST_UPD_BY,DPHMCD_LST_UPD_DT,DPHMCD_DELETED_IND
,DPHMCD_CNTR_SETTM_ID
,DPHMCD_REPLEGE_BAL
)
SELECT @L_DPM_ID, DPAM_ID , CITRUS_USR.FN_SPLITVAL_BY(VALUE,2,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,11,'~')
,CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~'),0,CITRUS_USR.FN_SPLITVAL_BY(VALUE,5,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,12,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,8,'~')
,CITRUS_USR.FN_SPLITVAL_BY(VALUE,13,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,7,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,4,'~'),0
,CITRUS_USR.FN_SPLITVAL_BY(VALUE,6,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,9,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,14,'~'),CITRUS_USR.FN_SPLITVAL_BY(VALUE,15,'~'),@L_HOLDING_DT
,@pa_login_name,GETDATE(),@pa_login_name,GETDATE(),1
,CITRUS_USR.FN_SPLITVAL_BY(VALUE,19,'~')
,CITRUS_USR.FN_SPLITVAL_BY(VALUE,20,'~')
FROM TMP_DPM5, dp_Acct_mstr 
where CITRUS_USR.FN_SPLITVAL_BY(VALUE,1,'~') = dpam_sba_no 
and dpam_deleted_ind = 1

 
delete from DP_HLDG_MSTR_CDSL where DPHMC_DPM_ID = @l_dpm_id and dphmc_holding_dt = @l_holding_dt

if 3 = (select count(distinct dphmc_holding_dt ) from DP_HLDG_MSTR_CDSL where DPHMC_DPM_ID = @l_dpm_id)
begin 

delete from DP_HLDG_MSTR_CDSL
where DPHMC_DPM_ID = @l_dpm_id 
and dphmc_holding_dt = (select min(dphmc_holding_dt) from DP_HLDG_MSTR_CDSL  where DPHMC_DPM_ID = @l_dpm_id )


end 

--insert remaing data 
insert into DP_HLDG_MSTR_CDSL
select  * from dpm345

if citrus_usr.LastMonthDay(@L_HOLDING_DT)=@L_HOLDING_DT--dbo.ufn_LastBusinessDayOfMonth(@L_HOLDING_DT)=@L_HOLDING_DT --
begin

delete from DP_HLDG_MSTR_CDSL_MONTHEND_HOLDING where DPHMC_DPM_ID = @l_dpm_id and dphmc_holding_dt = @l_holding_dt


 
insert into DP_HLDG_MSTR_CDSL_MONTHEND_HOLDING
select  * from dpm345

end 



declare @l_file numeric
,@l_insert numeric

set @l_file = 0 
set @l_insert = 0 

select @l_insert = count(1) from dpm345  
select @l_file = count(1)-1 from tmp_dpm5 having count(1)>1



--select @l_holding_dt_mak  = max(DPHMCD_HOLDING_DT) from DP_DAILY_HLDG_CDSL

--insert into DP_HLDG_mstr_CDSL
--select * from DP_DAILY_HLDG_CDSL where DPHMCD_HOLDING_DT = @l_holding_dt_mak  

--
--UPDATE filetask
--SET    TASK_FILEDATE =@l_holding_dt
--WHERE  task_id = @pa_task_id


UPDATE filetask
SET    TASK_FILEDATE = convert(varchar(11),@l_holding_dt,109),TASK_END_DATE=getdate(),STATUS = 'COMPLETED'
,uploadfilename = isnull(uploadfilename ,'')+ ': ' + 'File Records Count : ' + convert(varchar,@l_file)
+ ' Inserted Records Count :'+ convert(varchar,@l_insert)
WHERE  task_id = @pa_task_id




end

GO
