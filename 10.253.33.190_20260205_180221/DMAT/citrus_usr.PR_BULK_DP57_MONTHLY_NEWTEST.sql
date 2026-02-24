-- Object: PROCEDURE citrus_usr.PR_BULK_DP57_MONTHLY_NEWTEST
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--create table tmp_dp57_NEW( value varchar(8000))
--create table tmp_dp57_openqty (value varchar(8000),closing_qty numeric(18,5), opening_qty numeric(18,5))
--begin tran
--[PR_BULK_DP57_MONTHLY] 'MIG','','1863','BULK','c:\BulkInsDbfolder\DPM DP57 MONTHLY-CDSL FILE\44DP57U904.01022012.HST.135387','','',''
--[pr_bulk_dp57] 'MIG','','1863','BULK','C:\BULKINSDBFOLDER\DPM DP57-CDSL FILE\44DP57U.01022012.EOD','','',''
--SELECT * FROM FILETASK WHERE TASK_ID = 1863
--rollback
--drop table tmp_dp57_o
CREATE PROC [citrus_usr].[PR_BULK_DP57_MONTHLY_NEWTEST]
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




		truncate table tmp_dp57_NEW 
		--drop table tmp_dp57_o
		
		DECLARE @@SSQL VARCHAR(8000)  
		SET @@SSQL ='BULK INSERT tmp_dp57_NEW FROM ''' + @PA_DB_SOURCE + ''' WITH   
		(  
		FIELDTERMINATOR = ''~'',  
		ROWTERMINATOR = ''\n''  

		)'  
print @@SSQL
 
		EXEC(@@SSQL) 
 
				select identity(numeric,1,1) id , *,convert(numeric(18,5),0) qty, convert(numeric(18,5),0) closing_qty , convert(numeric(18,5),0) opening_qty , convert(varchar(800),'') cdasdesc 
				into #tmp_dp57_o 
				from tmp_dp57_NEW
			--	select identity(numeric,1,1) id , *,convert(numeric(18,5),0) qty, convert(numeric(18,5),0) closing_qty , convert(numeric(18,5),0) opening_qty , convert(varchar(800),'') cdasdesc into tmp_dp57_o from tmp_dp57_NEW


		--	create index ix_1 on #tmp_dp57_o(id, value)
		--	create index ix_1 on tmp_dp57_o(id, value)

		declare @l_dpm_dpid varchar(50)
		set @l_dpm_dpid  = ''
		select top  1 @l_dpm_dpid = value2 
		from #tmp_dp57_o 
		where value1 = 'H'



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
		SELECT @L_TRANS_DT = CONVERT(DATETIME, LEFT(value4,2)+'/'+SUBSTRING(value4,3,2)+'/20'+RIGHT(value4,2),103)
		FROM #tmp_dp57_o WHERE value1='H'
		AND value5='HST'

		if exists(SELECT * from #tmp_dp57_o WHERE value1='H' and value5 = 'HST')
		begin 
			DELETE FROM CDSL_HOLDING_DTLS WHERE MONTH(CDSHM_TRAS_DT) = MONTH(@L_TRANS_DT )
			AND YEAR(CDSHM_TRAS_DT) = YEAR(@L_TRANS_DT )
			AND CDSHM_DPM_ID = @l_dpm_id
		end 

select 1,getdate()


--		IF EXISTS(SELECT value3 FROM #tmp_dp57_o 
--				  WHERE value1='D' 
--				  AND  value3 not in (select dpam_sba_no from dp_acct_mstr where dpam_dpm_id = @l_dpm_id and dpam_deleted_ind =1 ) ) 																					
--		BEGIN
--		--
--
--		declare @l_string  varchar(8000)
--		set @l_string   = '' 
--		select @l_string  = @l_string    + value3 + ',' 
--		FROM #tmp_dp57_o 
--		WHERE value3 
--		not in (select dpam_sba_no from dp_acct_mstr where dpam_dpm_id = @l_dpm_id and dpam_deleted_ind = 1 )
--		
--
--		UPDATE filetask
--		SET    usermsg = 'ERROR : Following Client Not Mapped ' + @l_string
--		WHERE  task_id = @pa_task_id
--		--
--		END


/*COMMENTED (B COZ OF MONTHLY DP57 UPLOAD) ON 24022012 BY TUSHAR*/

--select dpam_id , dpam_sba_no , DPHMCD_ISIN , max(DPHMCD_HOLDING_DT) maxtransdt into #holding 
--from dp_daily_hldg_cdsl a , dp_Acct_mstr 
--where dpam_id = DPHMCD_DPAM_ID and dpam_sba_no in (select distinct value3 
--from #tmp_dp57_o)
--and DPHMCD_HOLDING_DT < @L_TRANS_DT 
--group by dpam_sba_no , DPHMCD_ISIN ,dpam_id 


/*COMMENTED (B COZ OF MONTHLY DP57 UPLOAD) ON 24022012 BY TUSHAR*/
 
return 

update t set qty  =  case when value2 = '1' 
and  value7  in ('109') and   value11   =''
				then 
							  case when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','')  ='CR' 
							  then convert(numeric(18,5),value29) 
							  else convert(numeric(18,5),value29)*-1 end  
						  when value2 = '4'  and  value7 not in ('401','409') then 
							  case when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','')  ='CR' 
							  then convert(numeric(18,5),value29) 
							  else convert(numeric(18,5),value29)*-1 end  
						  else 
							  case when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','')  ='CR' 
							  then convert(numeric(18,5),value6) 
							  else convert(numeric(18,5),value6)*-1 end  
						  end                


from #tmp_dp57_o t with(nolock)  
where value1='D'


select 2,getdate()

update t set cdasdesc =  
case when value2 in ('2','3')  then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'CR' and value13 <> ''  then 'ON-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'DR' and value13 <> ''  then 'ON-DR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'CR' and value13 = ''  then 'OF-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'DR' and value13 = ''  then 'OF-DR' end   
											+ ' TD:'+value15 +' '  
											+ 'TX:'+value5 +' '  
											+ value11 +' '  
											+ case when value13 <> ''   then 'SET:'+ value13 else '' end   

							   
							  when value2 in ('1') 
										and value7 in ('102','111')   then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'CR' then 'EARMARK-CR'  
													 when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'DR' then 'EARMARK-DR' end   
											+ ' SETT '+value13 +' '  
											+ 'EX '+ CITRUS_USR.fn_dp57_stuff('excmid',left(value13,6),'','')  +' '  
											+ value5 +' '  

							  
							  when value2 in ('1') 
										and value7 in ('109')     then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'CR' then 'BSEBOPAYIN-CR'  
												 when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'DR' then 'BSEBOPAYIN-DR' end   
												+ ' SETT '+value13 +' '  
												+ 'EX '+ CITRUS_USR.fn_dp57_stuff('excmid',left(value13,6),'','')  +' '  
												+ value5 +' '  
							 when value2 in ('1') 
										and value7 in ('107')     then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'CR' then 'NSCCL-CR'
												when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'DR' then 'NSCCL-DR' end 
												+ ' SETT '+value13 +' '
												+ 'EX '+ CITRUS_USR.fn_dp57_stuff('excmid',left(value13,6),'','')  +' '
												+ value5 +' ' 


							when value2 in ('16') 
										and value7 in ('1603')     then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'CR' then 'NSCCL-CR'
												 when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'DR' then 'NSCCL-DR' end 
													+ ' IN001002 12'+value20 +' '
													+ ' SETT N'+ left(value13,6)  +'N'
							  when value2 in ('4') 
										and value7 in ('409')  then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'CR' and value34 not in  ('79','80') then 'EP-CR'  
												 when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'DR' and value34  not in  ('79','80') then 'EP-DR'   
												 when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'CR' and value34  in  ('79','80') then 'BSEEPPAYIN-CR'  
												 when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'DR' and value34  in  ('79','80') then 'BSEEPPAYIN-DR'  
														end   
														+ ' TXN:'+value5 +' '  
														+ 'CTBO: '+ value11  +' '  
														+ value13 +' '  
														+ 'EXID: ' + CITRUS_USR.fn_dp57_stuff('excmid',left(value13,6),'','') +' '  		
							  when value2 in ('5') 
										and value7 in ('511','521')  then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'CR' then 'INTDEP-CR'
												  when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'DR' then 'INTDEP-DR' end 
													+ ' '+value5 +' '
													+ ' CTRBO '+value11 +' '
													+ ' '+ value13
											
						      when value2 in ('14') 
										and value7 in  ('1401')
										and '26' = (select dpam_clicm_cd from dp_Acct_mstr where dpam_sba_No = value3 and dpam_deleted_ind = 1 )
								  then 
										case when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'CR' then 'BSE-PAYOUT-CR'
											  when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'DR' then 'BSE-PAYOUT-DR' end 
												+ ' SETT '+ value13
												+ ' BO-'+ value11

								when value2 in ('14') 
										and value7  in ('1401')
										and '26' <> (select dpam_clicm_cd from dp_Acct_mstr where dpam_sba_No = value3 and dpam_deleted_ind = 1 )
								  then 
										 case when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'CR' then 'SETTLEMENT-CR'
											when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','') = 'DR' then 'SETTLEMENT-DR' end 
										+ ' SETT '+ value13
										+ ' EX-'+ CITRUS_USR.fn_dp57_stuff('excmid',left(value13,6),'','') 
										+ ' ' + value5


							  when value2 in ('7') then 
											'DEMAT'  
											+ value5 +' '  
											+ case   
											when value7 ='601' then 'SETUP-CR PENDING VERIFICATION'  
											when value7 ='607' then 'DELETE-DB PENDING VERIFICATION'  
											when value7 ='602' then 'VERIFY-DB PENDING VERIFICATION'  
											when value7 ='603' then 'VERIFY-CR PENDING CONFIRMATION'  
											when value7 ='604' then 'CLOSE-DB PENDING CONFIRMATION'  
											when value7 ='605' then 'CLOSE-CR CONFIRMED BALANCE'  
											when value7 ='606' then 'CLOSE-CR LOCK-IN BALANCE'            
											end   
						      else 

								CITRUS_USR.fn_dp57_stuff('desc',value2,'','') + '-'+ CITRUS_USR.fn_dp57_stuff('MAINDESC',value7,'','')

							  end 
							  
from #tmp_dp57_o t with(nolock)  
where value1='D' 
 
 select 3,getdate()
 

update #tmp_dp57_o set opening_qty = 0

update #tmp_dp57_o set #tmp_dp57_o.opening_qty = c.qty 
from (select b.id, CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,3,'~') cl, CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,4,'~') isin, qty=isnull(sum(a.qty),0)
from #tmp_dp57_o a, #tmp_dp57_o b
where CITRUS_USR.FN_SPLITVAL_BY(a.VALUE,3,'~') = CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,3,'~')
and citrus_usr.fn_splitval_by(a.value,4,'~') = citrus_usr.fn_splitval_by(b.value,4,'~')
and a.id < b.id 
and citrus_usr.fn_splitval_by(a.value,35,'~') in ('2246','2277','2201','3102')
group by b.id, CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,3,'~'), citrus_usr.fn_splitval_by(b.value,4,'~') ) c
where CITRUS_USR.FN_SPLITVAL_BY(#tmp_dp57_o.VALUE,3,'~') = c.cl
and citrus_usr.fn_splitval_by(#tmp_dp57_o.value,4,'~')= c.isin
and #tmp_dp57_o.id = c.id 
and citrus_usr.fn_splitval_by(#tmp_dp57_o.value,35,'~') in ('2246','2277','2201','3102')
--
--
--

select 4,getdate()

/*CHANGED FOR MONTHLY BY TUSHAR ON 24022012*/ 
--update t set opening_qty  =   opening_qty + cdslqty
--from #tmp_dp57_o t with(nolock)  
--,(select  CDSHM_TRAS_DT ,CDSHM_ISIN, CDSHM_BEN_ACCT_NO,sum(cdshm_qty) cdslqty from cdsl_holding_dtls i 
--where  i.CDSHM_TRATM_CD in ('2246','2277','2201','3102')
--and not exists(select value3,value4
--				 from #tmp_dp57_o 
--				 where value3 = CDSHM_BEN_ACCT_NO
--				 and value4 = CDSHM_ISIN
--				 and CDSHM_TRANS_NO = value5)
--group by  CDSHM_TRAS_DT,CDSHM_ISIN, CDSHM_BEN_ACCT_NO) i 
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201','3102')
--and i.CDSHM_BEN_ACCT_NO = CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~')
--AND i.CDSHM_TRAS_DT = convert(datetime,left(value9,2)+'/'+substring(value9,3,2)+'/'+substring(value9,5,4),103)  
--and i.CDSHM_ISIN = citrus_usr.fn_splitval_by(t.value,4,'~')
/*CHANGED FOR MONTHLY BY TUSHAR ON 24022012*/ 

--select value3,* from #tmp_dp57_o t where  value3 = '1201090400000301' and  citrus_usr.fn_splitval_by(t.value,4,'~') ='INE400H01019'
--
--return 


/*COMMENTED BY TUSHAR ON 24022012*/

update t set opening_qty  =   opening_qty  + isnull(isnull(DPHMCD_CURR_QTY,'0')+isnull(dphmcd_demat_pnd_ver_qty,'0') ,0) 
from #tmp_dp57_o t ,[vw_fetchclientholding] mainhldg, dp_acct_mstr a
where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201','3102')
and  value3  = a.dpam_sba_no 
and a.dpam_id = DPHMCD_DPAM_ID 
and a.dpam_dpm_id = dphmcd_dpm_id
and citrus_usr.fn_splitval_by(t.value,4,'~') = mainhldg.dphmcd_isin 
and DPHMCD_HOLDING_DT  = convert(datetime,left(value9,2)+'/'+substring(value9,3,2)+'/'+substring(value9,5,4),103) - 1

/*COMMENTED BY TUSHAR ON 24022012*/


select 5,getdate()

--
--update t set opening_qty  = opening_qty + isnull(closing_qty,0)
--from #tmp_dp57_o t 
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201','3102')





/*for update demat rejection code */


UPDATE Demat_request_mstr 
SET DEMRM_STATUS = value7,DEMRM_COMPANY_OBJ=value27,DEMRM_CREDIT_RECD = CASE WHEN value7 = '608' and ltrim(rtrim(isnull(value27,''))) <> '' then 'Y' else DEMRM_CREDIT_RECD end
FROM #tmp_dp57_o,demat_request_mstr,dp_acct_mstr
WHERE DEMRM_DPAM_ID=DPAM_ID AND DEMRM_ISIN=value4  
AND DEMRM_REQUEST_DT=convert(datetime,left(value8,2)+'/'+substring(value8,3,2)+'/'+substring(value8,5,4),103)
AND  DEMRM_SLIP_SERIAL_NO = value18 
AND  DEMRM_TRANSACTION_NO = value5 
AND dEMRM_DELETED_IND = 1 
and value1='D' 
and value35 in ('3102')
and dpam_sba_no=value3
and DPAM_DPM_ID = @l_dpm_id
/*for update demat rejection code */

 


	select 6,getdate()	
		
-- alter table CDSL_HOLDING_DTLS alter column cdshm_internal_trastm varchar(50)
-- alter table CDSL_HOLDING_DTLS add cdshm_trans_cdas_code varchar(50)

		INSERT INTO CDSL_HOLDING_DTLS 
		select @l_dpm_id , value3, dpam_id , value35
		--,CITRUS_USR.fn_dp57_stuff('desc',value2,'','') + '-'+ CITRUS_USR.fn_dp57_stuff('MAINDESC',value7,'','')
        ,cdasdesc 
		,convert(datetime,left(value9,2)+'/'+substring(value9,3,2)+'/'+substring(value9,5,4),103) 
		,value4 
		,qty--case when CITRUS_USR.fn_dp57_stuff('crdr',value35,'','')  ='CR' then convert(numeric(18,3),value6) else convert(numeric(18,3),value6)*-1 end 
		,CONVERT(VARCHAR(16),value37 )
		,value5  
		,left(value13,6) --CITRUS_USR.fn_dp57_stuff('settmid',left(value13,6),'','') 
		,right(value13,7)
		,case when value11 like '%IN%' then '' else  value11 end 
		,case when value11 like '%IN%' then value11  else  '' end  CDSHM_COUNTER_DPID
		,value12 CDSHM_COUNTER_CMBPID
		,CITRUS_USR.fn_dp57_stuff('excmid',left(value13,6),'','') 
		,value15 
		,'MIG'
		,getdate()
		,'MIG'
		,getdate()
		,1
		,null
		,case when value2 = '1' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  when value2 = '4' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  else isnull(CITRUS_USR.fn_dp57_stuff('TRANS_CD',value2,value10,value13) ,citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')) end cdshm_tratm_type_desc -- pending from latesh 
		,case when value2 = '1' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  when value2 = '4' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  else isnull(CITRUS_USR.fn_dp57_stuff('TRANS_CD',value2,value10,value13),citrus_usr.fn_splitval_by(replace(cdasdesc,' ','|'),1,'|'))  end   cdshm_internal_tratm  -- pending from latesh 
		,'' cdshm_bal_type 
		,id 
		,opening_qty openingbal 
		,null
		,null
		,value14 
		,null
		,value2
		FROM #tmp_dp57_o , DP_aCCT_MSTR 
		WHERE value3 = DPAM_SBA_NO 
--		and not exists(select cdshm_tras_dt
--						,cdshm_ben_acct_no,cdshm_trans_no
--						,cdshm_isin,cdshm_qty
--						,cdshm_sett_no,cdshm_counter_boid
--						,cdshm_counter_dpid from (SELECT cdshm_dpm_id,cdshm_ben_acct_no,cdshm_dpam_id,cdshm_tratm_cd
--														,cdshm_tratm_desc,cdshm_tras_dt,cdshm_isin,cdshm_qty,cdshm_int_ref_no,cdshm_trans_no
--														,cdshm_sett_type,cdshm_sett_no,cdshm_counter_boid,cdshm_counter_dpid
--														,cdshm_counter_cmbpid,cdshm_excm_id,cdshm_trade_no,cdshm_tratm_type_desc,cdshm_opn_bal
--														,cdshm_bal_type,CDSHM_TRG_SETTM_NO --into #temp_cdsl_holding_dtls
--														FROM   cdsl_holding_dtls
--														WHERE  CDSHM_TRAS_DT = convert(datetime,left(value9,2)+'/'+substring(value9,3,2)+'/'+substring(value9,5,4),103) 
--													    AND CDSHM_DPM_ID = @l_dpm_id
--														) a 
--						where cdshm_tras_dt = convert(datetime,left(value9,2)+'/'+substring(value9,3,2)+'/'+substring(value9,5,4),103) 
--						and cdshm_ben_acct_no = dpam_sba_no
--						and cdshm_trans_no = value5 
--						and cdshm_isin = value4 
--						and cdshm_qty = qty
--						and cdshm_sett_no = right(value13,7)
--						and cdshm_counter_boid = case when value11 like '%IN%' then '' else  value11 end 
--						and cdshm_counter_dpid = case when value11 like '%IN%' then value11  else  '' end )


select 7,getdate()

UPDATE filetask
SET    TASK_FILEDATE =@L_TRANS_DT
WHERE  task_id = @pa_task_id


END

GO
