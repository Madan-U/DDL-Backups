-- Object: PROCEDURE citrus_usr.pr_bulk_dp57_bak02022012
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--create table tmp_dp57( value varchar(8000))
--create table tmp_dp57_openqty (value varchar(8000),closing_qty numeric(18,5), opening_qty numeric(18,5))
--begin tran
--[pr_bulk_dp57_KJMC_NEWLOGIC] 'MIG','','1863','BULK','D:\BulkInsDbfolder\KJMC 10122012\44DP57U.09012012.011','','',''
--[pr_bulk_dp57] 'MIG','','1863','BULK','C:\BULKINSDBFOLDER\DPM DP57-CDSL FILE\44DP57U900.25012012.EOD','','',''
--SELECT * FROM FILETASK WHERE TASK_ID = 1863
--rollback
--drop table tmp_dp57_o
create proc [citrus_usr].[pr_bulk_dp57_bak02022012]
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




		truncate table tmp_dp57 
drop table tmp_dp57_o
		
		DECLARE @@SSQL VARCHAR(8000)  
		SET @@SSQL ='BULK INSERT tmp_dp57 FROM ''' + @PA_DB_SOURCE + ''' WITH   
		(  
		FIELDTERMINATOR = ''\n'',  
		ROWTERMINATOR = ''\n''  

		)'  

		EXEC(@@SSQL) 

				select identity(numeric,1,1) id , *,convert(numeric(18,5),0) qty, convert(numeric(18,5),0) closing_qty , convert(numeric(18,5),0) opening_qty into #tmp_dp57_o from tmp_dp57
				select identity(numeric,1,1) id , *,convert(numeric(18,5),0) qty, convert(numeric(18,5),0) closing_qty , convert(numeric(18,5),0) opening_qty into tmp_dp57_o from tmp_dp57


			create index ix_1 on #tmp_dp57_o(id, value)

		declare @l_dpm_dpid varchar(50)
		set @l_dpm_dpid  = ''
		select top  1 @l_dpm_dpid = citrus_usr.fn_splitval_by(value,2,'~') 
		from #tmp_dp57_o 
		where citrus_usr.fn_splitval_by(value,1,'~') = 'H'


		IF @L_DPM_DPID  = '' 
		SET @L_DPM_DPID  = @PA_DPMDPID


		declare @l_dpm_id  numeric
		set @l_dpm_id = 0 
		select @l_dpm_id  = dpm_id  from dp_mstr where dpm_dpid like '%' + @l_dpm_dpid -- and default_dp = dpm_excsm_id  

		IF @l_dpm_id = 0
		BEGIN
		--

		UPDATE filetask
		SET    usermsg = 'ERROR : DPID NOT MATCHED'  
		WHERE  task_id = @pa_task_id

		return 
			--
		END

		DECLARE @L_TRANS_DT  DATETIME 
		SELECT @L_TRANS_DT = CONVERT(DATETIME, LEFT(citrus_usr.fn_splitval_by(value,4,'~'),2)+'/'+SUBSTRING(citrus_usr.fn_splitval_by(value,4,'~'),3,2)+'/20'+RIGHT(citrus_usr.fn_splitval_by(value,4,'~'),2),103)
		FROM #tmp_dp57_o WHERE citrus_usr.fn_splitval_by(value,1,'~')='H'

		if exists(SELECT * from #tmp_dp57_o WHERE citrus_usr.fn_splitval_by(value,1,'~')='H' and citrus_usr.fn_splitval_by(value,3,'~') = 'F')
		begin 
			DELETE FROM CDSL_HOLDING_DTLS WHERE CDSHM_TRAS_DT = @L_TRANS_DT  AND CDSHM_DPM_ID = @l_dpm_id
		end 


--		IF EXISTS(SELECT CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') FROM #tmp_dp57_o 
--				  WHERE citrus_usr.fn_splitval_by(value,1,'~')='D' 
--				  AND  CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') not in (select dpam_sba_no from dp_acct_mstr where dpam_dpm_id = @l_dpm_id and dpam_deleted_ind =1 ) ) 																					
--		BEGIN
--		--
--
--		declare @l_string  varchar(8000)
--		set @l_string   = '' 
--		select @l_string  = @l_string    + CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') + ',' 
--		FROM #tmp_dp57_o 
--		WHERE CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') 
--		not in (select dpam_sba_no from dp_acct_mstr where dpam_dpm_id = @l_dpm_id and dpam_deleted_ind = 1 )
--		
--
--		UPDATE filetask
--		SET    usermsg = 'ERROR : Following Client Not Mapped ' + @l_string
--		WHERE  task_id = @pa_task_id
--		--
--		END




select a.* into #holding from dp_daily_hldg_cdsl a , dp_Acct_mstr 
where dpam_id = DPHMCD_DPAM_ID and dpam_sba_no in (select distinct CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') from #tmp_dp57_o)

--update t set qty  =  case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,6,'~')) else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,6,'~'))*-1 end                 
--from #tmp_dp57_o t with(nolock)  
--where citrus_usr.fn_splitval_by(value,1,'~')='D' 

update t set qty  =  case when citrus_usr.fn_splitval_by(value,2,'~') = '1' 
and  citrus_usr.fn_splitval_by(value,7,'~')  in ('109') and   citrus_usr.fn_splitval_by(value,11,'~')   =''
				then 
							  case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' 
							  then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,29,'~')) 
							  else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,29,'~'))*-1 end  
						  when citrus_usr.fn_splitval_by(value,2,'~') = '4'  and  citrus_usr.fn_splitval_by(value,7,'~') not in ('401','409') then 
							  case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' 
							  then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,29,'~')) 
							  else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,29,'~'))*-1 end  
						  else 
							  case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' 
							  then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,6,'~')) 
							  else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,6,'~'))*-1 end  
						  end                


from #tmp_dp57_o t with(nolock)  
where citrus_usr.fn_splitval_by(value,1,'~')='D' 



/*
update t set closing_qty  = isnull((select sum(isnull(qty,0)) 
from #tmp_dp57_o t1 with(nolock) 
where t1.id < t.id and CITRUS_USR.FN_SPLITVAL_BY(t1.VALUE,3,'~') =CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~')
and citrus_usr.fn_splitval_by(t1.value,4,'~')  = citrus_usr.fn_splitval_by(t.value,4,'~')
and  citrus_usr.fn_splitval_by(t1.value,35,'~') in ('2246','2277','2280','2201')
 
)    ,0)                 
from #tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2280','2201')
*/
--select * from #tmp_dp57_o  t
--where CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~') ='1206210000005248' 
--and citrus_usr.fn_splitval_by(t.value,4,'~') ='INE862A01015' 
-- 
--
--SELECT opening_qty  ,  isnull(closing_qty,0) , isnull((select top 1 DPHMCD_CURR_QTY from #holding , dp_Acct_mstr where dpam_id = DPHMCD_DPAM_ID 
--and dpam_sba_no = CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~') and DPHMCD_ISIN = citrus_usr.fn_splitval_by(t.value,4,'~')
--and DPHMCD_HOLDING_DT < @L_TRANS_DT order by DPHMCD_HOLDING_DT desc,DPHMCD_CURR_QTY desc),0) 
--, isnull((select sum(qty) from #tmp_dp57_o i 
--where CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~') = CITRUS_USR.FN_SPLITVAL_BY(i.VALUE,3,'~')
--and  citrus_usr.fn_splitval_by(i.value,4,'~') = citrus_usr.fn_splitval_by(t.value,4,'~')
--and i.id < t.id 
--and citrus_usr.fn_splitval_by(i.value,35,'~') in ('2246','2277','2201')
--) ,0)
--from #tmp_dp57_o t with(nolock)  
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201')
--AND citrus_usr.fn_splitval_by(t.value,4,'~') = 'INE455F01025'
--AND CITRUS_USR.FN_SPLITVAL_BY(T.VALUE,3,'~') = '1205680000001311'
--
--select isnull((select sum(cdshm_qty) from cdsl_holding_dtls i 
--where i.CDSHM_BEN_ACCT_NO = CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~')
--and  i.CDSHM_ISIN = citrus_usr.fn_splitval_by(t.value,4,'~')
--and i.CDSHM_TRAS_DT = @L_TRANS_DT
--and i.CDSHM_TRATM_CD in ('2246','2277','2201')
--and not exists(select CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~'),citrus_usr.fn_splitval_by(t.value,4,'~')
--				 from #tmp_dp57_o 
--				 where CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') = CDSHM_BEN_ACCT_NO
--				 and citrus_usr.fn_splitval_by(t.value,4,'~') = CDSHM_ISIN)),0)
--from #tmp_dp57_o t with(nolock)  
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201')
				 
--return 

update t set opening_qty  =  isnull(closing_qty,0) + isnull((select top 1 sum(isnull(DPHMCD_CURR_QTY,'0')+isnull(dphmcd_demat_pnd_ver_qty,'0')) from #holding , dp_Acct_mstr where dpam_id = DPHMCD_DPAM_ID 
and dpam_sba_no = CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~') and DPHMCD_ISIN = citrus_usr.fn_splitval_by(t.value,4,'~')
and DPHMCD_HOLDING_DT < @L_TRANS_DT group by DPHMCD_HOLDING_DT order by DPHMCD_HOLDING_DT desc),0) 
+ isnull((select sum(qty) from #tmp_dp57_o i where CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~') = CITRUS_USR.FN_SPLITVAL_BY(i.VALUE,3,'~')
and  citrus_usr.fn_splitval_by(i.value,4,'~') = citrus_usr.fn_splitval_by(t.value,4,'~')
and i.id < t.id 
and citrus_usr.fn_splitval_by(i.value,35,'~') in ('2246','2277','2201','3102')
) ,0)
+ isnull((select sum(cdshm_qty) from cdsl_holding_dtls i 
where i.CDSHM_BEN_ACCT_NO = CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~')
and  i.CDSHM_ISIN = citrus_usr.fn_splitval_by(t.value,4,'~')
and i.CDSHM_TRAS_DT = @L_TRANS_DT
and i.CDSHM_TRATM_CD in ('2246','2277','2201','3102')
and not exists(select CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~'),citrus_usr.fn_splitval_by(t.value,4,'~')
				 from #tmp_dp57_o 
				 where CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') = CDSHM_BEN_ACCT_NO
				 and citrus_usr.fn_splitval_by(t.value,4,'~') = CDSHM_ISIN
				 and CDSHM_TRANS_NO = citrus_usr.fn_splitval_by(value,5,'~'))
) ,0)
from #tmp_dp57_o t with(nolock)  
where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201','3102')

/*for update demat rejection code */
--UPDATE Demat_request_mstr 
--SET DEMRM_TRANSACTION_NO = TMPDS_DMT_REQ_NO
--FROM #tmp_dp57_o,demat_request_mstr,dp_acct_mstr
--WHERE DEMRM_DPAM_ID=DPAM_ID AND DEMRM_ISIN=citrus_usr.fn_splitval_by(value,4,'~') 
----AND DEMRM_REQUEST_DT=TMPDS_DRN_SETUP_DT 
--AND DEMRM_SLIP_SERIAL_NO = citrus_usr.fn_splitval_by(value,18,'~')
--AND DEMRM_DELETED_IND = 1 
--and citrus_usr.fn_splitval_by(value,1,'~')='D' and 
--citrus_usr.fn_splitval_by(t.value,35,'~') in ('3102')
--and dpam_sba_no=citrus_usr.fn_splitval_by(value,3,'~')


UPDATE Demat_request_mstr 
SET DEMRM_STATUS = citrus_usr.fn_splitval_by(value,7,'~'),DEMRM_COMPANY_OBJ=citrus_usr.fn_splitval_by(value,27,'~'),DEMRM_CREDIT_RECD = CASE WHEN citrus_usr.fn_splitval_by(value,7,'~') = '608' and ltrim(rtrim(isnull(citrus_usr.fn_splitval_by(value,27,'~'),''))) <> '' then 'Y' else DEMRM_CREDIT_RECD end
FROM #tmp_dp57_o,demat_request_mstr,dp_acct_mstr
WHERE DEMRM_DPAM_ID=DPAM_ID AND DEMRM_ISIN=citrus_usr.fn_splitval_by(value,4,'~')  
AND DEMRM_REQUEST_DT=convert(datetime,left(citrus_usr.fn_splitval_by(value,8,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),5,4),103)
AND  DEMRM_SLIP_SERIAL_NO = citrus_usr.fn_splitval_by(value,18,'~') 
AND  DEMRM_TRANSACTION_NO = citrus_usr.fn_splitval_by(value,5,'~') 
AND dEMRM_DELETED_IND = 1 
and citrus_usr.fn_splitval_by(value,1,'~')='D' 
and citrus_usr.fn_splitval_by(value,35,'~') in ('3102')
and dpam_sba_no=citrus_usr.fn_splitval_by(value,3,'~')
and DPAM_DPM_ID = @l_dpm_id
/*for update demat rejection code */


--
--select * from #tmp_dp57_o t
--where CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~') ='1206210000005248' 
--and citrus_usr.fn_splitval_by(t.value,4,'~') ='INE862A01015' 
--return 

-- take a today but old dp57 data 

SELECT cdshm_dpm_id,cdshm_ben_acct_no,cdshm_dpam_id,cdshm_tratm_cd
,cdshm_tratm_desc,cdshm_tras_dt,cdshm_isin,cdshm_qty,cdshm_int_ref_no,cdshm_trans_no
,cdshm_sett_type,cdshm_sett_no,cdshm_counter_boid,cdshm_counter_dpid
,cdshm_counter_cmbpid,cdshm_excm_id,cdshm_trade_no,cdshm_tratm_type_desc,cdshm_opn_bal
,cdshm_bal_type,CDSHM_TRG_SETTM_NO into #temp_cdsl_holding_dtls
FROM   cdsl_holding_dtls
WHERE  CDSHM_TRAS_DT = @L_TRANS_DT  AND CDSHM_DPM_ID = @l_dpm_id

-- take a today but old dp57 data 


		--DELETE FROM CDSL_HOLDING_DTLS WHERE CDSHM_TRAS_DT = @L_TRANS_DT  AND CDSHM_DPM_ID = @l_dpm_id
		
-- alter table CDSL_HOLDING_DTLS alter column cdshm_internal_trastm varchar(50)
-- alter table CDSL_HOLDING_DTLS add cdshm_trans_cdas_code varchar(50)

		INSERT INTO CDSL_HOLDING_DTLS 
		select @l_dpm_id , citrus_usr.fn_splitval_by(value,3,'~'), dpam_id , citrus_usr.fn_splitval_by(value,35,'~')
		--,CITRUS_USR.fn_dp57_stuff('desc',citrus_usr.fn_splitval_by(value,2,'~'),'','') + '-'+ CITRUS_USR.fn_dp57_stuff('MAINDESC',citrus_usr.fn_splitval_by(value,7,'~'),'','')
        ,citrus_usr.fn_getcdas_desc(id) 
		,convert(datetime,left(citrus_usr.fn_splitval_by(value,9,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),5,4),103) 
		,citrus_usr.fn_splitval_by(value,4,'~') 
		,qty--case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' then convert(numeric(18,3),citrus_usr.fn_splitval_by(value,6,'~')) else convert(numeric(18,3),citrus_usr.fn_splitval_by(value,6,'~'))*-1 end 
		,CONVERT(VARCHAR(16),citrus_usr.fn_splitval_by(value,37,'~') )
		,citrus_usr.fn_splitval_by(value,5,'~')  
		,left(citrus_usr.fn_splitval_by(value,13,'~'),6) --CITRUS_USR.fn_dp57_stuff('settmid',left(citrus_usr.fn_splitval_by(value,13,'~'),6),'','') 
		,right(citrus_usr.fn_splitval_by(value,13,'~'),7)
		,case when citrus_usr.fn_splitval_by(value,11,'~') like '%IN%' then '' else  citrus_usr.fn_splitval_by(value,11,'~') end 
		,case when citrus_usr.fn_splitval_by(value,11,'~') like '%IN%' then citrus_usr.fn_splitval_by(value,11,'~')  else  '' end  CDSHM_COUNTER_DPID
		,citrus_usr.fn_splitval_by(value,12,'~') CDSHM_COUNTER_CMBPID
		,CITRUS_USR.fn_dp57_stuff('excmid',left(citrus_usr.fn_splitval_by(value,13,'~'),6),'','') 
		,citrus_usr.fn_splitval_by(value,15,'~') 
		,'MIG'
		,getdate()
		,'MIG'
		,getdate()
		,1
		,null
		,case when citrus_usr.fn_splitval_by(value,2,'~') = '1' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_getcdas_desc(id) ,' ','|'),1,'|')
			  when citrus_usr.fn_splitval_by(value,2,'~') = '4' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_getcdas_desc(id) ,' ','|'),1,'|')
			  else isnull(CITRUS_USR.fn_dp57_stuff('TRANS_CD',citrus_usr.fn_splitval_by(value,2,'~'),citrus_usr.fn_splitval_by(value,10,'~'),citrus_usr.fn_splitval_by(value,13,'~')) ,citrus_usr.fn_splitval_by(replace(citrus_usr.fn_getcdas_desc(id) ,' ','|'),1,'|')) end cdshm_tratm_type_desc -- pending from latesh 
		,case when citrus_usr.fn_splitval_by(value,2,'~') = '1' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_getcdas_desc(id) ,' ','|'),1,'|')
			  when citrus_usr.fn_splitval_by(value,2,'~') = '4' then citrus_usr.fn_splitval_by(replace(citrus_usr.fn_getcdas_desc(id) ,' ','|'),1,'|')
			  else isnull(CITRUS_USR.fn_dp57_stuff('TRANS_CD',citrus_usr.fn_splitval_by(value,2,'~'),citrus_usr.fn_splitval_by(value,10,'~'),citrus_usr.fn_splitval_by(value,13,'~')),citrus_usr.fn_splitval_by(replace(citrus_usr.fn_getcdas_desc(id) ,' ','|'),1,'|'))  end   cdshm_internal_tratm  -- pending from latesh 
		,'' cdshm_bal_type 
		,id 
		,opening_qty openingbal 
		,null
		,null
		,citrus_usr.fn_splitval_by(value,14,'~') 
		,null
		,citrus_usr.fn_splitval_by(value,2,'~')
		FROM #tmp_dp57_o , DP_aCCT_MSTR 
		WHERE citrus_usr.fn_splitval_by(value,3,'~') = DPAM_SBA_NO 
		and not exists(select cdshm_tras_dt
						,cdshm_ben_acct_no,cdshm_trans_no
						,cdshm_isin,cdshm_qty
						,cdshm_sett_no,cdshm_counter_boid
						,cdshm_counter_dpid from #temp_cdsl_holding_dtls 
						where cdshm_tras_dt = convert(datetime,left(citrus_usr.fn_splitval_by(value,9,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),5,4),103) 
						and cdshm_ben_acct_no = dpam_sba_no
						and cdshm_trans_no = citrus_usr.fn_splitval_by(value,5,'~') 
						and cdshm_isin = citrus_usr.fn_splitval_by(value,4,'~') 
						and cdshm_qty = qty
						and cdshm_sett_no = right(citrus_usr.fn_splitval_by(value,13,'~'),7)
						and cdshm_counter_boid = case when citrus_usr.fn_splitval_by(value,11,'~') like '%IN%' then '' else  citrus_usr.fn_splitval_by(value,11,'~') end 
						and cdshm_counter_dpid = case when citrus_usr.fn_splitval_by(value,11,'~') like '%IN%' then citrus_usr.fn_splitval_by(value,11,'~')  else  '' end )




UPDATE filetask
SET    TASK_FILEDATE =@L_TRANS_DT
WHERE  task_id = @pa_task_id


END

GO
