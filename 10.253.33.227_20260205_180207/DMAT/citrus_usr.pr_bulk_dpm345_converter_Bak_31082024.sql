-- Object: PROCEDURE citrus_usr.pr_bulk_dpm345_converter_Bak_31082024
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


--create table tmp_dpm5(value varchar(8000))
--select top 0 * into dpm345  from DP_DAILY_HLDG_CDSL
--select * from filetask order by task_id desc
--PR_BULK_DPM345 'MIG','','1863','BULK','D:\DPData Migration\DPM3\33200\11DPM3UX.30092010.30092010','','',''
CREATE proc [citrus_usr].[pr_bulk_dpm345_converter]
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
insert into dpm3log
select getdate (), 'DPM3 start' , 'START'



 	IF  @PA_MODE ='BULK'  and  citrus_usr.fn_splitval_by (@pa_db_source , citrus_usr.ufn_CountString(@pa_db_source,'\')+1 ,'\') not like 'soh_exp_%'
		BEGIN 
				UPDATE FILETASK
				SET    USERMSG = 'ERROR : File is not proper.Please Check.', STATUS ='FAILED'
				, TASK_END_DATE = GETDATE()
				WHERE  TASK_ID = @PA_TASK_ID
				
				return
		END 


update filetask
set uploadfilename = citrus_usr.fn_splitval_by(@PA_DB_SOURCE,citrus_usr.ufn_countstring(@PA_DB_SOURCE,'\')+1,'\')
WHERE  task_id = @pa_task_id

insert into dpm3log
select getdate (), 'DPM3 Bulk import' , 'START'

truncate table tmp_dpm5 
truncate table dpm345
truncate table bulkholding

if @PA_MODE ='BULK' 
begin 

truncate table tmp_dpm5_Converter_cdsl


DECLARE @@SSQL VARCHAR(8000)  
--SET @@SSQL ='BULK INSERT tmp_dpm5_Converter_cdsl FROM ''' + @PA_DB_SOURCE + ''' WITH   
--( 
--						FIELDQUOTE = ''"''
--						, FIELDTERMINATOR = '',''
--						, ROWTERMINATOR = ''\n''
					
--						,FORMAT=''CSV''
--						,FIRSTROW = 2 

--)'  


--exec (@@SSQL)



declare @l_path varchar(1000)
declare @l_fillist varchar(5000)
 select @l_path = replace(@pa_db_source ,citrus_usr.fn_splitval_by (@pa_db_source  , citrus_usr.ufn_CountString(@pa_db_source,'\')+1 ,'\')  ,'') --path without filename 
 select @l_fillist = citrus_usr.fn_splitval_by (@pa_db_source  , citrus_usr.ufn_CountString(@pa_db_source,'\')+1 ,'\') -- filelist 

 declare @l_count numeric
 declare @l_counter numeric
 select @l_count  = citrus_usr.ufn_CountString (@l_fillist,'*|~*')
 set @l_counter = 1 
 
 while @l_counter < = @l_count
 begin 

 


 
SET @@SSQL ='BULK INSERT tmp_dpm5_Converter_cdsl FROM ''' +  @l_path + citrus_usr.fn_splitval_by (@l_fillist,@l_counter,'*|~*') + ''' WITH   
( 
						FIELDQUOTE = ''"''
						, FIELDTERMINATOR = '',''
						, ROWTERMINATOR = ''\n''
					
						,FORMAT=''CSV''
						,FIRSTROW = 2 

)'  


exec (@@SSQL)


 set @l_counter = @l_counter + 1 

 end 



end 

update tmp_dpm5_Converter_cdsl set STMTDT = left(STMTDT,10)


insert into tmp_dpm5_Converter_cdsl_log
select * , getdate() from tmp_dpm5_Converter_cdsl  


insert into dpm3log
select getdate (), 'DPM3 Bulk import' , 'end'


--insert into dpm3log
--select GETDATE(),'DPM3 FILE IS INCOMPLETE ','START'
--/*new changes 08102021*/
--IF not exists (select 1	 from tmp_dpm5 where left(value,8) <> @PA_DPMDPID and citrus_usr.ufn_CountString(value,		'~') = '2' )
--		BEGIN
--		--

--		UPDATE filetask
--		SET    usermsg = 'DPM3 FILE IS INCOMPLETE'  
--		WHERE  task_id = @pa_task_id

--		return 
--			--
--		END
		
--insert into dpm3log
--select GETDATE(),'DPM3 FILE IS INCOMPLETE ','END'


insert into dpm3log
select GETDATE(),'BULK INSERT bulkholding','start'


		declare @l_totalrecords numeric
		select @l_totalrecords = citrus_usr.fn_splitval_by(value,3,'~')	 from tmp_dpm5 where left(value,8) <> @PA_DPMDPID and citrus_usr.ufn_CountString(value,		'~') = '2' 

		declare @l_dt  varchar(100)
		select @l_dt = citrus_usr.fn_splitval_by(value,2,'~')	 from tmp_dpm5 where left(value,8) <> @PA_DPMDPID and citrus_usr.ufn_CountString(value,		'~') = '2' 

		
DECLARE @@SSQL1 VARCHAR(8000)  
SET @@SSQL1 ='BULK INSERT bulkholding FROM ''' + @PA_DB_SOURCE + ''' WITH   
(  
FIELDTERMINATOR = ''~'',  
ROWTERMINATOR = ''\n''  ,
firstrow=1,
lastrow = ' +convert(varchar(100),@l_totalrecords)

 + ')'  

EXEC(@@SSQL1) 

/*new changes 08102021*/


insert into dpm3log
select GETDATE(),'BULK INSERT bulkholding','END'



insert into dpm3log
select getdate (), 'No Data Found in File' , 'START'

IF (select count(1) from tmp_dpm5_Converter_cdsl) = 0
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
select top 1 @l_holding_dt = convert(datetime,STMTDT)
from tmp_dpm5_Converter_cdsl

print 'Holding date : ' + convert(varchar(11),@l_holding_dt,109)

declare @l_dpm_dpid varchar(50)
set @l_dpm_dpid  = ''
select top  1 @l_dpm_dpid ='12'+ CNTRLSCTIESDPSTRYPTCPT
from tmp_dpm5_Converter_cdsl




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

insert into dpm3log
select getdate (), ' DPID NOT MATCHED' , 'END'


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

insert into dpm3log
select getdate (), 'INSERT INTO dpm345 ' , 'START'

PRINT 'split data and insert into temp table'

truncate table dpm345_Temp 

insert into dpm345_Temp(DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_CURR_QTY
,DPHMCD_FREE_QTY,DPHMCD_FREEZE_QTY,DPHMCD_PLEDGE_QTY,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY
,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY
,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY,DPHMCD_HOLDING_DT
,DPHMCD_CREATED_BY,DPHMCD_CREATED_DT,DPHMCD_LST_UPD_BY,DPHMCD_LST_UPD_DT,DPHMCD_DELETED_IND
,DPHMCD_CNTR_SETTM_ID)
SELECT @L_DPM_ID, DPAM_ID , isnull(ISIN,'') 
,isnull(CurBal,'0')
,isnull(BnfcryAcctPos,'0') 
,0
,+isnull(PldgdBal,'0')
,isnull(DmtrlstnPdgVrfctnBal,'0')
,isnull(RmtrlstnPdgBal,'0')
,isnull(DmtrlstnPdgConfBal,'0')
,isnull(SkfpBal,'0')
,isnull(LckdInBal,'0') 
,0
,isnull(EarmrkdBal,'0')
,isnull(AvlblForLndBal,'0')
,isnull(LNDBAL,'0')
,isnull(BrrwdBal,'0')
,@L_HOLDING_DT
,@pa_login_name
,GETDATE()
,@pa_login_name
,GETDATE()
,1
,isnull(SctiesSttlmTxId,'0')
FROM tmp_dpm5_Converter_cdsl , dp_Acct_mstr  where rcrdtp ='S'
and BNFCLOWNRID = dpam_sba_no 
and dpam_deleted_ind = 1


PRINT 'split data and insert into temp table'

INSERT INTO dpm345 (DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_CURR_QTY
,DPHMCD_FREE_QTY,DPHMCD_FREEZE_QTY,DPHMCD_PLEDGE_QTY,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY
,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY
,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY,DPHMCD_HOLDING_DT
,DPHMCD_CREATED_BY,DPHMCD_CREATED_DT,DPHMCD_LST_UPD_BY,DPHMCD_LST_UPD_DT,DPHMCD_DELETED_IND
,DPHMCD_CNTR_SETTM_ID)
SELECT DPHMCD_DPM_ID,DPHMCD_DPAM_ID,DPHMCD_ISIN,DPHMCD_CURR_QTY
,DPHMCD_FREE_QTY,DPHMCD_FREEZE_QTY,DPHMCD_PLEDGE_QTY,DPHMCD_DEMAT_PND_VER_QTY,DPHMCD_REMAT_PND_CONF_QTY
,DPHMCD_DEMAT_PND_CONF_QTY,DPHMCD_SAFE_KEEPING_QTY,DPHMCD_LOCKIN_QTY,DPHMCD_ELIMINATION_QTY
,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY,DPHMCD_HOLDING_DT
,DPHMCD_CREATED_BY,DPHMCD_CREATED_DT,DPHMCD_LST_UPD_BY,DPHMCD_LST_UPD_DT,DPHMCD_DELETED_IND
,DPHMCD_CNTR_SETTM_ID
FROM dpm345_Temp


insert into dpm3log
select getdate (), 'INSERT INTO dpm345 ' , 'END'

--insert into dpm3log
--select getdate (), 'disable index' , 'start'

--alter index ix_1 on DP_HLDG_MSTR_CDSL disable
--alter index ix_dphmc_dpam_id on DP_HLDG_MSTR_CDSL disable
--alter index ix_DPHMC_HOLDING_DT on DP_HLDG_MSTR_CDSL disable

--insert into dpm3log
--select getdate (), 'disable index' , 'end'

 --return 
insert into dpm3log
select getdate (), 'delete from DP_HLDG_MSTR_CDSL CASE1 ' , 'START'
 
delete from DP_HLDG_MSTR_CDSL where DPHMC_DPM_ID = @l_dpm_id and dphmc_holding_dt = @l_holding_dt

insert into dpm3log
select getdate (), 'delete from DP_HLDG_MSTR_CDSL CASE1 ' , 'END'

insert into dpm3log
select getdate (), 'delete from DP_HLDG_MSTR_CDSL CASE2 ' , 'START'

if 3 = (select count(distinct dphmc_holding_dt ) from DP_HLDG_MSTR_CDSL where DPHMC_DPM_ID = @l_dpm_id)
begin 

declare @l_max_dt datetime
select @l_max_dt = min(dphmc_holding_dt) from DP_HLDG_MSTR_CDSL  where DPHMC_DPM_ID = @l_dpm_id 

 delete from DP_HLDG_MSTR_CDSL  where DPHMC_DPM_ID = @l_dpm_id  
 and dphmc_holding_dt =@l_max_dt   
  
  
--delete from DP_HLDG_MSTR_CDSL
--where DPHMC_DPM_ID = @l_dpm_id 
--and dphmc_holding_dt = (select min(dphmc_holding_dt) from DP_HLDG_MSTR_CDSL  where DPHMC_DPM_ID = @l_dpm_id )


end 

insert into dpm3log
select getdate (), 'delete from DP_HLDG_MSTR_CDSL CASE2 ' , 'END'

--insert remaing data 
insert into dpm3log
select getdate (), 'insert into DP_HLDG_MSTR_CDSL ' , 'START'

insert into DP_HLDG_MSTR_CDSL
select  * from dpm345
insert into dpm3log
select getdate (), 'insert into DP_HLDG_MSTR_CDSL ' , 'END'


insert into dpm3log
select getdate (), 'insert into DP_HLDG_MSTR_CDSL LastMonthDay' , 'START'

if citrus_usr.LastMonthDay(@L_HOLDING_DT)=@L_HOLDING_DT--dbo.ufn_LastBusinessDayOfMonth(@L_HOLDING_DT)=@L_HOLDING_DT --
begin

delete from DP_HLDG_MSTR_CDSL_MONTHEND_HOLDING where DPHMC_DPM_ID = @l_dpm_id and dphmc_holding_dt = @l_holding_dt


 
insert into DP_HLDG_MSTR_CDSL_MONTHEND_HOLDING
select  * from dpm345

end 

insert into dpm3log
select getdate (), 'insert into DP_HLDG_MSTR_CDSL LastMonthDay' , 'END'

--insert into dpm3log
--select getdate (), 'rebuild index' , 'start'

--alter index ix_1 on DP_HLDG_MSTR_CDSL rebuild 
--alter index ix_dphmc_dpam_id on DP_HLDG_MSTR_CDSL rebuild 
--alter index ix_DPHMC_HOLDING_DT on DP_HLDG_MSTR_CDSL rebuild 

--insert into dpm3log
--select getdate (), 'rebuild index' , 'end'


declare @l_file numeric
,@l_insert numeric

set @l_file = 0 
set @l_insert = 0 

select @l_insert = count(1) from dpm345  
--select @l_file = count(1)-1 from tmp_dpm5 having count(1)>1

select @l_file = count(1) from tmp_dpm5_Converter_cdsl 



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


insert into dpm3log
select getdate (), 'DPM3 start' , 'end'

end

GO
