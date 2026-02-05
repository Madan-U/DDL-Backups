-- Object: PROCEDURE citrus_usr.PR_BULK_DP57_MONTHLY_Missing
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--create table tmp_dp57( value varchar(8000))
--create table tmp_dp57_openqty (value varchar(8000),closing_qty numeric(18,5), opening_qty numeric(18,5))
--begin tran
--[PR_BULK_DP57_MONTHLY] 'MIG','','1863','BULK','c:\BulkInsDbfolder\DPM DP57 MONTHLY-CDSL FILE\44DP57U904.01022012.HST.135387','','',''
--[pr_bulk_dp57] 'MIG','','1863','BULK','C:\BULKINSDBFOLDER\DPM DP57-CDSL FILE\44DP57U.01022012.EOD','','',''
--SELECT * FROM FILETASK WHERE TASK_ID = 1863
--rollback
--drop table tmp_dp57_o
CREATE PROC [citrus_usr].[PR_BULK_DP57_MONTHLY_Missing]
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
		
		
		DECLARE @@SSQL VARCHAR(8000)  
		SET @@SSQL ='BULK INSERT tmp_dp57 FROM ''' + @PA_DB_SOURCE + ''' WITH   
		(  
		FIELDTERMINATOR = ''\n'',  
		ROWTERMINATOR = ''0X0A''  
		

		)'  

		EXEC(@@SSQL) 
		
		--ROWTERMINATOR = ''/n''  

				select identity(numeric,1,1) id , *,convert(numeric(18,5),0) qty, convert(numeric(18,5),0) 
				closing_qty , convert(numeric(18,5),0) opening_qty , convert(varchar(800),'') cdasdesc 
				into #tmp_dp57_o from tmp_dp57
				


			create clustered index ix_1 on #tmp_dp57_o(id, value)
			

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
		AND citrus_usr.fn_splitval_by(value,5,'~')='HST'
		
			DELETE FROM #tmp_dp57_o WHERE MONTH(convert(datetime,left(citrus_usr.fn_splitval_by(value,9,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),5,4),103) ) <> '6'
			AND YEAR(convert(datetime,left(citrus_usr.fn_splitval_by(value,9,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),5,4),103) ) = '2014'

		select count(1) from #tmp_dp57_o
		
return 
		--if exists(SELECT * from #tmp_dp57_o WHERE citrus_usr.fn_splitval_by(value,1,'~')='H' and citrus_usr.fn_splitval_by(value,5,'~') = 'HST')
		--begin 
		--	DELETE FROM CDSL_HOLDING_DTLS WHERE MONTH(CDSHM_TRAS_DT) = MONTH(@L_TRANS_DT )
		--	AND YEAR(CDSHM_TRAS_DT) = YEAR(@L_TRANS_DT )
		--	AND CDSHM_DPM_ID = @l_dpm_id
		--end 



--if exists (select citrus_usr.fn_splitval_by(value,3,'~') from #tmp_dp57_o where (citrus_usr.fn_splitval_by(value,3,'~')
--not in (select dpam_sba_no from dp_Acct_mstr) or citrus_usr.fn_splitval_by(value,11,'~')
--not in (select dpam_sba_no from dp_Acct_mstr)) AND len(value)>=40 ) 
--begin 
--
--select citrus_usr.fn_splitval_by(value,3,'~') from #tmp_dp57_o where (citrus_usr.fn_splitval_by(value,3,'~')
--not in (select dpam_sba_no from dp_Acct_mstr) or citrus_usr.fn_splitval_by(value,11,'~')
--not in (select dpam_sba_no from dp_Acct_mstr)) AND len(value)>=40
--
--return 
--
--end 

 


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


/*COMMENTED (B COZ OF MONTHLY DP57 UPLOAD) ON 24022012 BY TUSHAR*/

--select dpam_id , dpam_sba_no , DPHMCD_ISIN , max(DPHMCD_HOLDING_DT) maxtransdt into #holding 
--from dp_daily_hldg_cdsl a , dp_Acct_mstr 
--where dpam_id = DPHMCD_DPAM_ID and dpam_sba_no in (select distinct CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') 
--from #tmp_dp57_o)
--and DPHMCD_HOLDING_DT < @L_TRANS_DT 
--group by dpam_sba_no , DPHMCD_ISIN ,dpam_id 


/*COMMENTED (B COZ OF MONTHLY DP57 UPLOAD) ON 24022012 BY TUSHAR*/

update t set qty  =  case when citrus_usr.fn_splitval_by(value,2,'~') = '1' 
and  citrus_usr.fn_splitval_by(value,7,'~')  in ('109') and   citrus_usr.fn_splitval_by(value,11,'~')   =''
				then 
							  case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' 
							  then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,29,'~')) 
							  else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,29,'~'))*-1 end  
				when citrus_usr.fn_splitval_by(value,35,'~') = '2277' and citrus_usr.fn_splitval_by(value,2,'~') = '1' and  citrus_usr.fn_splitval_by(value,7,'~')  in ('105') 
				then 		  case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' 
							  then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,29,'~')) 
							  else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,29,'~'))*-1 end  

/*case added by latesh on may 07 2012 */
when citrus_usr.fn_splitval_by(value,35,'~') = '3102' and  citrus_usr.fn_splitval_by(value,7,'~')  in ('608')
and citrus_usr.fn_splitval_by(value,26,'~') ='V'
then case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' 
							  then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,30,'~')) 
							  else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,30,'~'))*-1 end 

when citrus_usr.fn_splitval_by(value,35,'~') = '3102' and  citrus_usr.fn_splitval_by(value,7,'~')  in ('608')
and citrus_usr.fn_splitval_by(value,26,'~') ='C'
then case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' 
							  then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,32,'~')) 
							  else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,32,'~'))*-1 end 

when citrus_usr.fn_splitval_by(value,35,'~') = '2252' and  citrus_usr.fn_splitval_by(value,7,'~')  in ('604')
then case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' 
							  then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,31,'~')) 
							  else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,31,'~'))*-1 end 

when citrus_usr.fn_splitval_by(value,35,'~') = '2246' and  citrus_usr.fn_splitval_by(value,7,'~')  in ('605')
then case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' 
							  then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,31,'~')) 
							  else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,31,'~'))*-1 end 


when citrus_usr.fn_splitval_by(value,2,'~') = '32' and  citrus_usr.fn_splitval_by(value,35,'~')  in ('2246')
then case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' 
							  then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,31,'~')) 
							  else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,31,'~'))*-1 end 

when  citrus_usr.fn_splitval_by(value,35,'~')  in ('3202') and  citrus_usr.fn_splitval_by(value,7,'~')  in ('705')
then case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' 
							  then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,29,'~')) 
							  else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,29,'~'))*-1 end 

/*case added by latesh on may 07 2012 */

				when citrus_usr.fn_splitval_by(value,2,'~') = '32' and  citrus_usr.fn_splitval_by(value,7,'~')  in ('3207') 
				then 		  case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' 
							  then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,31,'~')) 
							  else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,31,'~'))*-1 end  

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


select 2,getdate()

update t set cdasdesc =  
case when citrus_usr.fn_splitval_by(value,2,'~') in ('2','3')  then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' and (citrus_usr.fn_splitval_by(value,13,'~') <> '' or citrus_usr.fn_splitval_by(value,14,'~') <> '')  then 'ON-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' and (citrus_usr.fn_splitval_by(value,13,'~') <> '' or citrus_usr.fn_splitval_by(value,14,'~') <> '')  then 'ON-DR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' and (citrus_usr.fn_splitval_by(value,13,'~') = '' and citrus_usr.fn_splitval_by(value,14,'~') = '')  then 'OF-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' and(citrus_usr.fn_splitval_by(value,13,'~') = '' and citrus_usr.fn_splitval_by(value,14,'~') = '')  then 'OF-DR' end   
											+ ' TD:'+citrus_usr.fn_splitval_by(value,15,'~') +' '  
											+ 'TX:'+citrus_usr.fn_splitval_by(value,5,'~') +' '  
											+ citrus_usr.fn_splitval_by(value,11,'~') +' '  
											+ case when citrus_usr.fn_splitval_by(value,13,'~') <> ''   then 'SET:'+ citrus_usr.fn_splitval_by(value,13,'~') else '' end   

							   
							  when citrus_usr.fn_splitval_by(value,2,'~') in ('1') 
										and citrus_usr.fn_splitval_by(value,7,'~') in ('102','111')   then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'EARMARK-CR'  
													 when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'EARMARK-DR' end   
											+ ' SETT '+citrus_usr.fn_splitval_by(value,13,'~') +' '  
											+ 'EX '+ CITRUS_USR.fn_dp57_stuff('excmid',left(citrus_usr.fn_splitval_by(value,13,'~'),6),'','')  +' '  
											+ citrus_usr.fn_splitval_by(value,5,'~') +' '  

							  
							  when citrus_usr.fn_splitval_by(value,2,'~') in ('1') 
										and citrus_usr.fn_splitval_by(value,7,'~') in ('109')     then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'BSEBOPAYIN-CR'  
												 when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'BSEBOPAYIN-DR' end   
												+ ' SETT '+citrus_usr.fn_splitval_by(value,13,'~') +' '  
												+ 'EX '+ CITRUS_USR.fn_dp57_stuff('excmid',left(citrus_usr.fn_splitval_by(value,13,'~'),6),'','')  +' '  
												+ citrus_usr.fn_splitval_by(value,5,'~') +' '  
							 when citrus_usr.fn_splitval_by(value,2,'~') in ('1') 
										and citrus_usr.fn_splitval_by(value,7,'~') in ('107')     then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'NSCCL-CR'
												when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'NSCCL-DR' end 
												+ ' SETT '+citrus_usr.fn_splitval_by(value,13,'~') +' '
												+ 'EX '+ CITRUS_USR.fn_dp57_stuff('excmid',left(citrus_usr.fn_splitval_by(value,13,'~'),6),'','')  +' '
												+ citrus_usr.fn_splitval_by(value,5,'~') +' ' 


							when citrus_usr.fn_splitval_by(value,2,'~') in ('16') 
										and citrus_usr.fn_splitval_by(value,7,'~') in ('1603')     then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'NSCCL-CR'
												 when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'NSCCL-DR' end 
													+ ' IN001002 12'+citrus_usr.fn_splitval_by(value,20,'~') +' '
													+ ' SETT N'+ left(citrus_usr.fn_splitval_by(value,13,'~'),6)  +'N'
							  when citrus_usr.fn_splitval_by(value,2,'~') in ('4') 
										and citrus_usr.fn_splitval_by(value,7,'~') in ('409')  then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' and citrus_usr.fn_splitval_by(value,34,'~') not in  ('79','80') then 'EP-CR'  
												 when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' and citrus_usr.fn_splitval_by(value,34,'~')  not in  ('79','80') then 'EP-DR'   
												 when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' and citrus_usr.fn_splitval_by(value,34,'~')  in  ('79','80') then 'BSEEPPAYIN-CR'  
												 when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' and citrus_usr.fn_splitval_by(value,34,'~')  in  ('79','80') then 'BSEEPPAYIN-DR'  
														end   
														+ ' TXN:'+citrus_usr.fn_splitval_by(value,5,'~') +' '  
														+ 'CTBO: '+ citrus_usr.fn_splitval_by(value,11,'~')  +' '  
														+ citrus_usr.fn_splitval_by(value,13,'~') +' '  
														+ 'EXID: ' + CITRUS_USR.fn_dp57_stuff('excmid',left(citrus_usr.fn_splitval_by(value,13,'~'),6),'','') +' '  		
							  when citrus_usr.fn_splitval_by(value,2,'~') in ('5') 
										and citrus_usr.fn_splitval_by(value,7,'~') in ('511','521')  then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'INTDEP-CR'
												  when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'INTDEP-DR' end 
													+ ' '+citrus_usr.fn_splitval_by(value,5,'~') +' '
													+ ' CTRBO '+citrus_usr.fn_splitval_by(value,11,'~') +' '
													+ ' '+ citrus_usr.fn_splitval_by(value,13,'~')
											
						      when citrus_usr.fn_splitval_by(value,2,'~') in ('14') 
										and citrus_usr.fn_splitval_by(value,7,'~') in  ('1401')
										and '26' = (select dpam_clicm_cd from dp_Acct_mstr where dpam_sba_No = citrus_usr.fn_splitval_by(value,3,'~') and dpam_deleted_ind = 1 )
								  then 
										case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'BSE-PAYOUT-CR'
											  when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'BSE-PAYOUT-DR' end 
												+ ' SETT '+ citrus_usr.fn_splitval_by(value,13,'~')
												+ ' BO-'+ citrus_usr.fn_splitval_by(value,11,'~')

								when citrus_usr.fn_splitval_by(value,2,'~') in ('14') 
										and citrus_usr.fn_splitval_by(value,7,'~')  in ('1401')
										and '26' <> (select dpam_clicm_cd from dp_Acct_mstr where dpam_sba_No = citrus_usr.fn_splitval_by(value,3,'~') and dpam_deleted_ind = 1 )
								  then 
										 case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' then 'SETTLEMENT-CR'
											when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' then 'SETTLEMENT-DR' end 
										+ ' SETT '+ citrus_usr.fn_splitval_by(value,13,'~')
										+ ' EX-'+ CITRUS_USR.fn_dp57_stuff('excmid',left(citrus_usr.fn_splitval_by(value,13,'~'),6),'','') 
										+ ' ' + citrus_usr.fn_splitval_by(value,5,'~')


							  when citrus_usr.fn_splitval_by(value,2,'~') in ('6') then 
											'DEMAT'  
											+ citrus_usr.fn_splitval_by(value,5,'~') +' '  
											+ case   
											when citrus_usr.fn_splitval_by(value,7,'~') ='601' then 'SETUP-CR PENDING VERIFICATION'  
											when citrus_usr.fn_splitval_by(value,7,'~') ='607' then 'DELETE-DB PENDING VERIFICATION'  
											when citrus_usr.fn_splitval_by(value,7,'~') ='602' then 'VERIFY-DB PENDING VERIFICATION'  
											when citrus_usr.fn_splitval_by(value,7,'~') ='603' then 'VERIFY-CR PENDING CONFIRMATION'  
											when citrus_usr.fn_splitval_by(value,7,'~') ='604' then 'CLOSE-DB PENDING CONFIRMATION'  
											when citrus_usr.fn_splitval_by(value,7,'~') ='605' then 'CLOSE-CR CONFIRMED BALANCE'  
											when citrus_usr.fn_splitval_by(value,7,'~') ='606' then 'CLOSE-CR LOCK-IN BALANCE'            
											when citrus_usr.fn_splitval_by(value,7,'~') ='608' then 'REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)'  
											when citrus_usr.fn_splitval_by(value,7,'~') ='609' then 'CANCELLED DUE TO AUTO CA (DEBIT DEMAT PENDING VERIFICATION)'      
											end   
								
								when citrus_usr.fn_splitval_by(value,2,'~') in ('32') and  citrus_usr.fn_splitval_by(value,7,'~')  in ('3206') then 
											'By Destat'  

								when citrus_usr.fn_splitval_by(value,2,'~') in ('32') and  citrus_usr.fn_splitval_by(value,7,'~')  in ('3207') then 
											'By Destat Confirm'  

								when citrus_usr.fn_splitval_by(value,2,'~') in ('33') and  citrus_usr.fn_splitval_by(value,7,'~')  in ('3304') then 
											'To Restat Confirm'  

/*case added by latesh on may 07 2012 */

								when citrus_usr.fn_splitval_by(value,2,'~') in ('33') and  citrus_usr.fn_splitval_by(value,7,'~')  in ('3301') then 
											'To Restat Setup'  
/*case added by latesh on may 07 2012 */

								when citrus_usr.fn_splitval_by(value,2,'~') in ('7') and  citrus_usr.fn_splitval_by(value,7,'~')  in ('707') then 
											'To Remat Confirm'  

								when citrus_usr.fn_splitval_by(value,2,'~') in ('8') and  citrus_usr.fn_splitval_by(value,7,'~')  in ('816') then 
											'By Pledge Rejection'  

											   
								when citrus_usr.fn_splitval_by(value,2,'~') in ('18') and  citrus_usr.fn_splitval_by(value,7,'~')  in ('1801') then 
											'To Transfer\'+ citrus_usr.fn_splitval_by(value,11,'~')  
								
											   

						      else 

								CITRUS_USR.fn_dp57_stuff('desc',citrus_usr.fn_splitval_by(value,2,'~'),'','') + '-'+ CITRUS_USR.fn_dp57_stuff('MAINDESC',citrus_usr.fn_splitval_by(value,7,'~'),'','')

							  end 
							  
from #tmp_dp57_o t with(nolock)  
where citrus_usr.fn_splitval_by(value,1,'~')='D' 
 
 select 3,getdate()
 

update #tmp_dp57_o set opening_qty = 0
--
--update #tmp_dp57_o set #tmp_dp57_o.opening_qty = c.qty 
--from (select b.id, CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,3,'~') cl, CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,4,'~') isin, qty=isnull(sum(a.qty),0)
--from #tmp_dp57_o a, #tmp_dp57_o b
--where CITRUS_USR.FN_SPLITVAL_BY(a.VALUE,3,'~') = CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,3,'~')
--and citrus_usr.fn_splitval_by(a.value,4,'~') = citrus_usr.fn_splitval_by(b.value,4,'~')
--and a.id < b.id 
--and citrus_usr.fn_splitval_by(a.value,35,'~') in ('2246','2277','2201','3102')
--group by b.id, CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,3,'~'), citrus_usr.fn_splitval_by(b.value,4,'~') ) c
--where CITRUS_USR.FN_SPLITVAL_BY(#tmp_dp57_o.VALUE,3,'~') = c.cl
--and citrus_usr.fn_splitval_by(#tmp_dp57_o.value,4,'~')= c.isin
--and #tmp_dp57_o.id = c.id 
--and citrus_usr.fn_splitval_by(#tmp_dp57_o.value,35,'~') in ('2246','2277','2201','3102')
--
--
--

select 4,getdate()

/*CHANGED FOR MONTHLY BY TUSHAR ON 24022012*/ 
--update t set opening_qty  =   opening_qty + cdslqty
--from #tmp_dp57_o t with(nolock)  
--,(select  CDSHM_TRAS_DT ,CDSHM_ISIN, CDSHM_BEN_ACCT_NO,sum(cdshm_qty) cdslqty from cdsl_holding_dtls i 
--where  i.CDSHM_TRATM_CD in ('2246','2277','2201','3102')
--and not exists(select CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~'),citrus_usr.fn_splitval_by(value,4,'~')
--				 from #tmp_dp57_o 
--				 where CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') = CDSHM_BEN_ACCT_NO
--				 and citrus_usr.fn_splitval_by(value,4,'~') = CDSHM_ISIN
--				 and CDSHM_TRANS_NO = citrus_usr.fn_splitval_by(value,5,'~'))
--group by  CDSHM_TRAS_DT,CDSHM_ISIN, CDSHM_BEN_ACCT_NO) i 
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201','3102')
--and i.CDSHM_BEN_ACCT_NO = CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~')
--AND i.CDSHM_TRAS_DT = convert(datetime,left(citrus_usr.fn_splitval_by(value,9,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),5,4),103)  
--and i.CDSHM_ISIN = citrus_usr.fn_splitval_by(t.value,4,'~')
/*CHANGED FOR MONTHLY BY TUSHAR ON 24022012*/ 

--select CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~'),* from #tmp_dp57_o t where  CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') = '1201090400000301' and  citrus_usr.fn_splitval_by(t.value,4,'~') ='INE400H01019'
--
--return 


/*COMMENTED BY TUSHAR ON 24022012*/
--
--update t set opening_qty  =   opening_qty  + isnull(isnull(DPHMCD_CURR_QTY,'0')+isnull(dphmcd_demat_pnd_ver_qty,'0') ,0) 
--from #tmp_dp57_o t ,[vw_fetchclientholding] mainhldg, dp_acct_mstr a
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201','3102')
--and  CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~')  = a.dpam_sba_no 
--and a.dpam_id = DPHMCD_DPAM_ID 
--and a.dpam_dpm_id = dphmcd_dpm_id
--and citrus_usr.fn_splitval_by(t.value,4,'~') = mainhldg.dphmcd_isin 
--and DPHMCD_HOLDING_DT  = convert(datetime,left(citrus_usr.fn_splitval_by(value,9,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),5,4),103) - 1

/*COMMENTED BY TUSHAR ON 24022012*/


select 5,getdate()

--
--update t set opening_qty  = opening_qty + isnull(closing_qty,0)
--from #tmp_dp57_o t 
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201','3102')




--
--/*for update demat rejection code */
--
--
--UPDATE Demat_request_mstr 
--SET DEMRM_STATUS = citrus_usr.fn_splitval_by(value,7,'~'),DEMRM_COMPANY_OBJ=citrus_usr.fn_splitval_by(value,27,'~'),DEMRM_CREDIT_RECD = CASE WHEN citrus_usr.fn_splitval_by(value,7,'~') = '608' and ltrim(rtrim(isnull(citrus_usr.fn_splitval_by(value,27,'~'),''))) <> '' then 'Y' else DEMRM_CREDIT_RECD end
--FROM #tmp_dp57_o,demat_request_mstr,dp_acct_mstr
--WHERE DEMRM_DPAM_ID=DPAM_ID AND DEMRM_ISIN=citrus_usr.fn_splitval_by(value,4,'~')  
--AND DEMRM_REQUEST_DT=convert(datetime,left(citrus_usr.fn_splitval_by(value,8,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),5,4),103)
--AND  DEMRM_SLIP_SERIAL_NO = citrus_usr.fn_splitval_by(value,18,'~') 
--AND  DEMRM_TRANSACTION_NO = citrus_usr.fn_splitval_by(value,5,'~') 
--AND dEMRM_DELETED_IND = 1 
--and citrus_usr.fn_splitval_by(value,1,'~')='D' 
--and citrus_usr.fn_splitval_by(value,35,'~') in ('3102')
--and dpam_sba_no=citrus_usr.fn_splitval_by(value,3,'~')
--and DPAM_DPM_ID = @l_dpm_id
--/*for update demat rejection code */
--
-- 


	select 6,getdate()	
		
-- alter table CDSL_HOLDING_DTLS alter column cdshm_internal_trastm varchar(50)
-- alter table CDSL_HOLDING_DTLS add cdshm_trans_cdas_code varchar(50)

		INSERT INTO CDSL_HOLDING_DTLS_Missing 
		select @l_dpm_id , citrus_usr.fn_splitval_by(value,3,'~'), isnull(dpam_id,0) , citrus_usr.fn_splitval_by(value,35,'~')
		--,CITRUS_USR.fn_dp57_stuff('desc',citrus_usr.fn_splitval_by(value,2,'~'),'','') + '-'+ CITRUS_USR.fn_dp57_stuff('MAINDESC',citrus_usr.fn_splitval_by(value,7,'~'),'','')
        ,cdasdesc 
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
		,case when citrus_usr.fn_splitval_by(value,2,'~') = '1' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  when citrus_usr.fn_splitval_by(value,2,'~') = '4' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  when citrus_usr.fn_splitval_by(value,2,'~') = '15'  and citrus_usr.fn_splitval_by(value,7,'~') = '1503'  then 'NSCCL-DR'
			  else isnull(CITRUS_USR.fn_dp57_stuff('TRANS_CD',citrus_usr.fn_splitval_by(value,2,'~'),citrus_usr.fn_splitval_by(value,10,'~'),citrus_usr.fn_splitval_by(value,13,'~')) ,citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')) end cdshm_tratm_type_desc -- pending from latesh 
		,case when citrus_usr.fn_splitval_by(value,2,'~') = '1' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  when citrus_usr.fn_splitval_by(value,2,'~') = '4' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  when citrus_usr.fn_splitval_by(value,2,'~') = '15'  and citrus_usr.fn_splitval_by(value,7,'~') = '1503'  then 'NSCCL-DR'
			  else isnull(CITRUS_USR.fn_dp57_stuff('TRANS_CD',citrus_usr.fn_splitval_by(value,2,'~'),citrus_usr.fn_splitval_by(value,10,'~'),citrus_usr.fn_splitval_by(value,13,'~')),citrus_usr.fn_splitval_by(replace(cdasdesc,' ','|'),1,'|'))  end   cdshm_internal_tratm  -- pending from latesh 
		,'' cdshm_bal_type 
		,id 
		,opening_qty openingbal 
		,null
		,null
		,citrus_usr.fn_splitval_by(value,14,'~') 
		,null
		,value
		,citrus_usr.fn_splitval_by(value,2,'~') 
		,citrus_usr.fn_splitval_by(value,7,'~') ,null
		FROM #tmp_dp57_o left outer join  DP_aCCT_MSTR on citrus_usr.fn_splitval_by(value,3,'~') = DPAM_SBA_NO 
		where citrus_usr.fn_splitval_by(value,1,'~') = 'D' 
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
--														WHERE  CDSHM_TRAS_DT = convert(datetime,left(citrus_usr.fn_splitval_by(value,9,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),5,4),103) 
--													    AND CDSHM_DPM_ID = @l_dpm_id
--														) a 
--						where cdshm_tras_dt = convert(datetime,left(citrus_usr.fn_splitval_by(value,9,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),5,4),103) 
--						and cdshm_ben_acct_no = dpam_sba_no
--						and cdshm_trans_no = citrus_usr.fn_splitval_by(value,5,'~') 
--						and cdshm_isin = citrus_usr.fn_splitval_by(value,4,'~') 
--						and cdshm_qty = qty
--						and cdshm_sett_no = right(citrus_usr.fn_splitval_by(value,13,'~'),7)
--						and cdshm_counter_boid = case when citrus_usr.fn_splitval_by(value,11,'~') like '%IN%' then '' else  citrus_usr.fn_splitval_by(value,11,'~') end 
--						and cdshm_counter_dpid = case when citrus_usr.fn_splitval_by(value,11,'~') like '%IN%' then citrus_usr.fn_splitval_by(value,11,'~')  else  '' end )


select 7,getdate()

UPDATE filetask
SET    TASK_FILEDATE =@L_TRANS_DT
WHERE  task_id = @pa_task_id


END

GO
