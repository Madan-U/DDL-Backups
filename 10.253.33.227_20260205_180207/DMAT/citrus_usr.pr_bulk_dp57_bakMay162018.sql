-- Object: PROCEDURE citrus_usr.pr_bulk_dp57_bakMay162018
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--create table tmp_dp57( value varchar(8000))
--create table tmp_dp57_openqty (value varchar(8000),closing_qty numeric(18,5), opening_qty numeric(18,5))
--begin tran
--[pr_bulk_dp57_KJMC_NEWLOGIC] 'MIG','','1863','BULK','D:\BulkInsDbfolder\KJMC 10122012\44DP57U.09012012.011','','',''
--[pr_bulk_dp57] 'MIG','','1863','BULK','C:\BulkInsDbfolder\DPM DP57-CDSL FILE\44DP57U900.05072012.005','','',''
--SELECT * FROM FILETASK WHERE TASK_ID = 1863
--rollback
--drop table tmp_dp57_o
CReate   proc [citrus_usr].[pr_bulk_dp57_bakMay162018]
(  
 @PA_LOGIN_NAME    VARCHAR(20) 
,@PA_DPMDPID          VARCHAR(20)    
,@PA_TASK_ID        NUMERIC
,@PA_MODE          VARCHAR(10)                                    
,@PA_DB_SOURCE     VARCHAR(250)    
,@ROWDELIMITER     CHAR(4) =     '*|~*'      
,@COLDELIMITER     CHAR(4) =     '|*~|'    
,@SNO int=0  
,@PA_ERRMSG        VARCHAR(8000) OUTPUT)

as
begin 


if @PA_MODE='BULK'
BEGIN 
truncate table tmp_dp57 
END 

		if exists (select 1 from sys.objects where name = 'tmp_dp57_o')
		drop table tmp_dp57_o
		

if @PA_MODE='BULK'
BEGIN 
		DECLARE @@SSQL VARCHAR(8000)  
		SET @@SSQL ='BULK INSERT tmp_dp57 FROM ''' + @PA_DB_SOURCE + ''' WITH   
		(  
		FIELDTERMINATOR = ''\n'',  
		ROWTERMINATOR = ''\n''  

		)'  

		EXEC(@@SSQL) 
end
				select identity(numeric,1,1) id , *,convert(numeric(18,5),0) qty, convert(numeric(18,5),0) closing_qty , convert(numeric(18,5),0) opening_qty , convert(varchar(800),'') cdasdesc into #tmp_dp57_o from tmp_dp57
				select identity(numeric,1,1) id , *,convert(numeric(18,5),0) qty, convert(numeric(18,5),0) closing_qty , convert(numeric(18,5),0) opening_qty , convert(varchar(800),'') cdasdesc into tmp_dp57_o from tmp_dp57


			create clustered index ix_1 on #tmp_dp57_o(id, value)
			create clustered index ix_1 on tmp_dp57_o(id, value)

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


		IF EXISTS(SELECT CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') FROM #tmp_dp57_o 
				  WHERE citrus_usr.fn_splitval_by(value,1,'~')='D' 
				  AND citrus_usr.fn_splitval_by(value,2,'~') not in ('8','11','10') --<> '8'
				  AND  CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') not in (select dpam_sba_no from dp_acct_mstr where dpam_dpm_id = @l_dpm_id and dpam_deleted_ind =1 ) ) 																					
		BEGIN
		--

		declare @l_string  varchar(8000)
		set @l_string   = '' 
		select @l_string  = @l_string    + CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') + ',' 
		FROM #tmp_dp57_o 
		WHERE CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') 
		not in (select dpam_sba_no from dp_acct_mstr where dpam_dpm_id = @l_dpm_id and dpam_deleted_ind = 1 )
		AND citrus_usr.fn_splitval_by(value,1,'~')='D' and citrus_usr.fn_splitval_by(value,2,'~') not in ('8','11','10') --<>'8' 

		UPDATE filetask
		SET    usermsg = 'ERROR : Following Client Not Mapped ' + @l_string
		WHERE  task_id = @pa_task_id

		
		--
		END


--
--changed by tushar on sep 29 2012
--select dpam_id , dpam_sba_no , DPHMCD_ISIN , max(DPHMCD_HOLDING_DT) maxtransdt into #holding from dp_daily_hldg_cdsl a , dp_Acct_mstr 
--where dpam_id = DPHMCD_DPAM_ID and dpam_sba_no in (select distinct CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') 
--from #tmp_dp57_o)
--and DPHMCD_HOLDING_DT < @L_TRANS_DT 
--group by dpam_sba_no , DPHMCD_ISIN ,dpam_id 


--update t set qty  =  case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','')  ='CR' then convert(numeric(18,5),citrus_usr.fn_splitval_by(value,6,'~')) else convert(numeric(18,5),citrus_usr.fn_splitval_by(value,6,'~'))*-1 end                 
--from #tmp_dp57_o t with(nolock)  
--where citrus_usr.fn_splitval_by(value,1,'~')='D' 

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
when citrus_usr.fn_splitval_by(value,35,'~') = '2225' and  citrus_usr.fn_splitval_by(value,7,'~')  in ('821')
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
where citrus_usr.fn_splitval_by(value,1,'~') = 'D'

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

								when citrus_usr.fn_splitval_by(value,2,'~') in ('32') and  citrus_usr.fn_splitval_by(value,7,'~')  in ('3208') then 
											'By Destat Setup'  

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
when citrus_usr.fn_splitval_by(value,2,'~') in ('8') and  citrus_usr.fn_splitval_by(value,7,'~')  in ('821') then 
											'Pledge Accept: ' + citrus_usr.fn_splitval_by(value,5,'~')  + ' CTR BO:' + citrus_usr.fn_splitval_by(value,11,'~')  +  ' CR Pledgee'  

											   
								when citrus_usr.fn_splitval_by(value,2,'~') in ('18') 
								and  citrus_usr.fn_splitval_by(value,7,'~')  in ('1801') then 
											'To Transfer\'+ citrus_usr.fn_splitval_by(value,11,'~') 
											
											when citrus_usr.fn_splitval_by(value,2,'~') in ('18') 
								 and citrus_usr.fn_splitval_by(value,27,'~')  in ('1','3')
								-- and citrus_usr.fn_splitval_by(value,35,'~')  in ('2246')
								  then 
											'Transfer\'+ citrus_usr.fn_splitval_by(value,11,'~') 
											when citrus_usr.fn_splitval_by(value,2,'~') in ('18') 
								 and  citrus_usr.fn_splitval_by(value,27,'~')  in ('0','2') then 
											'Transmission\'+ citrus_usr.fn_splitval_by(value,11,'~') 
											 
							  else 

								CITRUS_USR.fn_dp57_stuff('desc',citrus_usr.fn_splitval_by(value,2,'~'),'','') + '-'+ CITRUS_USR.fn_dp57_stuff('MAINDESC',citrus_usr.fn_splitval_by(value,7,'~'),'','')

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
				 
update #tmp_dp57_o set opening_qty = 0

--update #tmp_dp57_o set #tmp_dp57_o.opening_qty = c.qty 
--from (select b.id, CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,3,'~') cl, CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,4,'~') isin, qty=isnull(sum(a.qty),0)
--from #tmp_dp57_o a, #tmp_dp57_o b
--where CITRUS_USR.FN_SPLITVAL_BY(a.VALUE,3,'~') = CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,3,'~')
--and citrus_usr.fn_splitval_by(a.value,4,'~') = citrus_usr.fn_splitval_by(b.value,4,'~')
--and a.id < b.id 
--group by b.id, CITRUS_USR.FN_SPLITVAL_BY(b.VALUE,3,'~'), citrus_usr.fn_splitval_by(b.value,4,'~') ) c
--where CITRUS_USR.FN_SPLITVAL_BY(#tmp_dp57_o.VALUE,3,'~')= c.cl
--and citrus_usr.fn_splitval_by(#tmp_dp57_o.value,4,'~')= c.isin
--and #tmp_dp57_o.id = c.id 

--select * from #tmp_dp57_o where value like '%INE192A01025%' and value like '%1201090000015901%'
 
--update t set opening_qty  =   opening_qty + cdslqty
--from #tmp_dp57_o t with(nolock)  
--,(select  CDSHM_ISIN, CDSHM_BEN_ACCT_NO,sum(cdshm_qty) cdslqty from cdsl_holding_dtls i 
--where i.CDSHM_TRAS_DT = @L_TRANS_DT
--and i.CDSHM_TRATM_CD in ('2246','2277','2201','3102')
--and not exists(select CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~'),citrus_usr.fn_splitval_by(value,4,'~')
--				 from #tmp_dp57_o 
--				 where CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') = CDSHM_BEN_ACCT_NO
--				 and citrus_usr.fn_splitval_by(value,4,'~') = CDSHM_ISIN
--				 and CDSHM_TRANS_NO = citrus_usr.fn_splitval_by(value,5,'~'))
--group by  CDSHM_ISIN, CDSHM_BEN_ACCT_NO) i 
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201','3102')
--and i.CDSHM_BEN_ACCT_NO = CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~')
--and i.CDSHM_ISIN = citrus_usr.fn_splitval_by(t.value,4,'~')

--select * from #tmp_dp57_o where value like '%INE192A01025%' and value like '%1201090000015901%'

--update t set opening_qty  =   opening_qty  + isnull(isnull(DPHMCD_CURR_QTY,'0')+isnull(dphmcd_demat_pnd_ver_qty,'0') ,0) 
----+ isnull((select sum(cdshm_qty) from cdsl_holding_dtls i 
----where i.CDSHM_BEN_ACCT_NO = CITRUS_USR.FN_SPLITVAL_BY(t.VALUE,3,'~')
----and  i.CDSHM_ISIN = citrus_usr.fn_splitval_by(t.value,4,'~')
----and i.CDSHM_TRAS_DT = @L_TRANS_DT
----and i.CDSHM_TRATM_CD in ('2246','2277','2201','3102')
----and not exists(select CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~'),citrus_usr.fn_splitval_by(t.value,4,'~')
----				 from #tmp_dp57_o 
----				 where CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~') = CDSHM_BEN_ACCT_NO
----				 and citrus_usr.fn_splitval_by(t.value,4,'~') = CDSHM_ISIN
----				 and CDSHM_TRANS_NO = citrus_usr.fn_splitval_by(value,5,'~'))
----) ,0)
--from #tmp_dp57_o t , #holding hldg , dp_daily_hldg_cdsl mainhldg with(nolock)  
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201','3102')
--and  CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~')  = dpam_sba_no 
--and dpam_id = DPHMCD_DPAM_ID 
--and citrus_usr.fn_splitval_by(t.value,4,'~') = mainhldg.dphmcd_isin 
--and mainhldg.dphmcd_isin = hldg.dphmcd_isin 
--and maxtransdt = DPHMCD_HOLDING_DT 

--
--update t set opening_qty  = opening_qty + isnull(closing_qty,0)
--from #tmp_dp57_o t 
--where  citrus_usr.fn_splitval_by(t.value,35,'~') in ('2246','2277','2201','3102')





/*for update demat rejection code */

UPDATE Demat_request_mstr 
SET DEMRM_STATUS = citrus_usr.fn_splitval_by(value,7,'~'),DEMRM_COMPANY_OBJ=citrus_usr.fn_splitval_by(value,27,'~'),DEMRM_CREDIT_RECD = CASE WHEN citrus_usr.fn_splitval_by(value,7,'~') = '608' and ltrim(rtrim(isnull(citrus_usr.fn_splitval_by(value,27,'~'),''))) <> '' then 'Y' else DEMRM_CREDIT_RECD end
FROM #tmp_dp57_o,demat_request_mstr,dp_acct_mstr
WHERE DEMRM_DPAM_ID=DPAM_ID AND DEMRM_ISIN=citrus_usr.fn_splitval_by(value,4,'~')  
--AND DEMRM_REQUEST_DT=convert(datetime,left(citrus_usr.fn_splitval_by(value,8,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),5,4),103)
AND  DEMRM_SLIP_SERIAL_NO = citrus_usr.fn_splitval_by(value,18,'~') 
AND  DEMRM_TRANSACTION_NO = citrus_usr.fn_splitval_by(value,5,'~') 
AND dEMRM_DELETED_IND = 1 
and citrus_usr.fn_splitval_by(value,1,'~')='D' 
and citrus_usr.fn_splitval_by(value,35,'~') in ('3102')
and dpam_sba_no=citrus_usr.fn_splitval_by(value,3,'~')
and DPAM_DPM_ID = @l_dpm_id and   citrus_usr.fn_splitval_by(value,7,'~')='608'
/*for update demat rejection code */

/*for update destat rejection code */

UPDATE Demat_request_mstr 
SET DEMRM_STATUS = citrus_usr.fn_splitval_by(value,7,'~'),DEMRM_COMPANY_OBJ=citrus_usr.fn_splitval_by(value,27,'~'),DEMRM_CREDIT_RECD = CASE WHEN citrus_usr.fn_splitval_by(value,7,'~') in ('3206','3207') and ltrim(rtrim(isnull(citrus_usr.fn_splitval_by(value,27,'~'),''))) <> '' then 'Y' else DEMRM_CREDIT_RECD end
FROM #tmp_dp57_o,demat_request_mstr,dp_acct_mstr
WHERE DEMRM_DPAM_ID=DPAM_ID AND DEMRM_ISIN=citrus_usr.fn_splitval_by(value,4,'~')  
--AND DEMRM_REQUEST_DT=convert(datetime,left(citrus_usr.fn_splitval_by(value,8,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),5,4),103)
AND  DEMRM_SLIP_SERIAL_NO = citrus_usr.fn_splitval_by(value,18,'~') 
AND  DEMRM_TRANSACTION_NO = citrus_usr.fn_splitval_by(value,5,'~') 
AND dEMRM_DELETED_IND = 1 
and citrus_usr.fn_splitval_by(value,1,'~')='D' 
and citrus_usr.fn_splitval_by(value,35,'~') in ('3115','3110')
and dpam_sba_no=citrus_usr.fn_splitval_by(value,3,'~')
and citrus_usr.fn_splitval_by(value,27,'~') <> 0  -- for rejection code
and DPAM_DPM_ID = @l_dpm_id
/*for update destat rejection code */

-- commented on Mar 22 2017 for optimization by lateshw
--/* for update of demat confirmation flag in demat request mstr */
--update d set DEMRM_CREDIT_RECD ='C'
--from cdsl_holding_dtls,demat_request_mstr d where cdshm_tratm_cd='2246' 
--and  CDSHM_CDAS_SUB_TRAS_TYPE='605'
--and ltrim(rtrim(isnull(citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~'),''))) <> ''
--and cdshm_tras_dt>='aug 01 2011' 
--and demrm_slip_serial_no=citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,18,'~')
--and isnull(DEMRM_COMPANY_OBJ,'')=''
--and DEMRM_CREDIT_RECD <>'C'
--/* for update of demat confirmation flag in demat request mstr */ 

--/* for update of destat confirmation flag in demat request mstr */
--update d set DEMRM_CREDIT_RECD ='C'
--from cdsl_holding_dtls,demat_request_mstr d where cdshm_tratm_cd='2246' 
--and  CDSHM_CDAS_SUB_TRAS_TYPE='3207'
--and ltrim(rtrim(isnull(citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~'),''))) <> ''
--and cdshm_tras_dt>='aug 01 2011' 
--and demrm_slip_serial_no=citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,18,'~')
--and isnull(DEMRM_COMPANY_OBJ,'')=''
--and DEMRM_CREDIT_RECD <>'C'
--/* for update of destat confirmation flag in demat request mstr */ 
-- commented on Mar 22 2017 for optimization by lateshw

/* for update of demat confirmation flag in demat request mstr */
update d set DEMRM_CREDIT_RECD ='C'
from #tmp_dp57_o with(nolock),demat_request_mstr d with(nolock) , dp_acct_mstr with (nolock) 
where citrus_usr.fn_splitval_by(value,35,'~')  ='2246' 
and  citrus_usr.fn_splitval_by(value,7,'~')='605' and dpam_id = demrm_dpam_id and  dpam_sba_no = citrus_usr.fn_splitval_by(value,3,'~')
and ltrim(rtrim(isnull(citrus_usr.fn_splitval_by(value,27,'~'),''))) <> ''

and demrm_slip_serial_no=citrus_usr.fn_splitval_by(value,18,'~')
and isnull(DEMRM_COMPANY_OBJ,'')=''
and DEMRM_CREDIT_RECD <>'C'
/* for update of demat confirmation flag in demat request mstr */ 

/* for update of destat confirmation flag in demat request mstr */
update d set DEMRM_CREDIT_RECD ='C'
from #tmp_dp57_o with(nolock) ,demat_request_mstr d with(nolock)  , dp_acct_mstr with (nolock) 
where citrus_usr.fn_splitval_by(value,35,'~')  ='2246' 
and  citrus_usr.fn_splitval_by(value,7,'~')='3207' and dpam_id = demrm_dpam_id  
and dpam_sba_no = citrus_usr.fn_splitval_by(value,3,'~')
and ltrim(rtrim(isnull(citrus_usr.fn_splitval_by(value,27,'~'),''))) <> ''
and demrm_slip_serial_no=citrus_usr.fn_splitval_by(value,18,'~')
and isnull(DEMRM_COMPANY_OBJ,'')=''
and DEMRM_CREDIT_RECD <>'C'
/* for update of destat confirmation flag in demat request mstr */ 


/*demat in case of Auto CA rejection from CDSL on Jun 2 2016 by Latesh w*/

Update demat_request_mstr  set DEMRM_STATUS = citrus_usr.fn_splitval_by(value,7,'~'),
DEMRM_COMPANY_OBJ=citrus_usr.fn_splitval_by(value,7,'~')
,DEMRM_CREDIT_RECD = CASE WHEN citrus_usr.fn_splitval_by(value,7,'~') = '609' then 'Y' else DEMRM_CREDIT_RECD end
,demrm_response_dt  = convert(datetime,substring(ltrim(rtrim(substring(citrus_usr.fn_splitval_by(value,9,'~'),0,9))),1,2)
+ '/' + substring(ltrim(rtrim(substring(citrus_usr.fn_splitval_by(value,9,'~'),0,9))),3,2)
+ '/' + substring(ltrim(rtrim(substring(citrus_usr.fn_splitval_by(value,9,'~'),0,9))),5,4)
,103)
FROM #tmp_dp57_o with(nolock),demat_request_mstr with(nolock),dp_acct_mstr with (nolock) --,dp_acct_mstr with(nolock)
WHERE DEMRM_DPAM_ID=DPAM_ID AND DEMRM_ISIN=citrus_usr.fn_splitval_by(value,4,'~')  
--AND DEMRM_REQUEST_DT=convert(datetime,left(citrus_usr.fn_splitval_by(value,8,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,8,'~'),5,4),103)
AND  DEMRM_SLIP_SERIAL_NO = citrus_usr.fn_splitval_by(value,18,'~') 
AND  DEMRM_TRANSACTION_NO = citrus_usr.fn_splitval_by(value,5,'~') 
and dpam_sba_no=citrus_usr.fn_splitval_by(value,3,'~')
AND dEMRM_DELETED_IND = 1 
and citrus_usr.fn_splitval_by(value,1,'~')='D' 
and citrus_usr.fn_splitval_by(value,7,'~') in ('609')
--and dpam_sba_no = cdshm_ben_acct_no 
and dpam_dpm_id  = @l_dpm_id

/*demat in case of Auto CA rejection from CDSL  on Jun 2 2016 by Latesh w*/



		--DELETE FROM CDSL_HOLDING_DTLS WHERE CDSHM_TRAS_DT = @L_TRANS_DT  AND CDSHM_DPM_ID = @l_dpm_id
		
-- alter table CDSL_HOLDING_DTLS alter column cdshm_internal_trastm varchar(50)
-- alter table CDSL_HOLDING_DTLS add cdshm_trans_cdas_code varchar(50)
SELECT cdshm_dpm_id,cdshm_ben_acct_no,cdshm_dpam_id,cdshm_tratm_cd
,cdshm_tratm_desc,cdshm_tras_dt,cdshm_isin,cdshm_qty,cdshm_int_ref_no,cdshm_trans_no
,cdshm_sett_type,cdshm_sett_no,cdshm_counter_boid,cdshm_counter_dpid
,cdshm_counter_cmbpid,cdshm_excm_id,cdshm_trade_no,cdshm_tratm_type_desc,cdshm_opn_bal
,cdshm_bal_type,CDSHM_TRG_SETTM_NO --into #temp_cdsl_holding_dtls
into #tempdatacdsl FROM   cdsl_holding_dtls with (nolock)
WHERE  CDSHM_TRAS_DT = @L_TRANS_DT  AND CDSHM_DPM_ID = @l_dpm_id
--change bu tushar on sep 29 2012
create clustered index ix_1 on #tempdatacdsl (cdshm_tras_dt 
,cdshm_ben_acct_no 
,cdshm_trans_no 
,cdshm_isin
,cdshm_qty 
,cdshm_sett_no 
,cdshm_counter_boid 
,cdshm_counter_dpid)


INSERT INTO CDSL_HOLDING_DTLS(
CDSHM_DPM_ID,CDSHM_BEN_ACCT_NO,CDSHM_DPAM_ID,CDSHM_TRATM_CD,CDSHM_TRATM_DESC,CDSHM_TRAS_DT
,CDSHM_ISIN,CDSHM_QTY,CDSHM_INT_REF_NO,CDSHM_TRANS_NO,CDSHM_SETT_TYPE,CDSHM_SETT_NO,CDSHM_COUNTER_BOID
,CDSHM_COUNTER_DPID,CDSHM_COUNTER_CMBPID,CDSHM_EXCM_ID,CDSHM_TRADE_NO,CDSHM_CREATED_BY,CDSHM_CREATED_DT,CDSHM_LST_UPD_BY
,CDSHM_LST_UPD_DT,CDSHM_DELETED_IND,cdshm_slip_no,cdshm_tratm_type_desc,cdshm_internal_trastm,CDSHM_BAL_TYPE,cdshm_id
,cdshm_opn_bal,cdshm_charge,CDSHM_DP_CHARGE,CDSHM_TRG_SETTM_NO,WAIVE_FLAG,cdshm_trans_cdas_code
,CDSHM_CDAS_TRAS_TYPE,CDSHM_CDAS_SUB_TRAS_TYPE
) 
		select @l_dpm_id , citrus_usr.fn_splitval_by(value,3,'~'), dpam_id , citrus_usr.fn_splitval_by(value,35,'~')
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
			  when citrus_usr.fn_splitval_by(value,2,'~') in ('2','3')  then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' and (citrus_usr.fn_splitval_by(value,13,'~') <> '' or citrus_usr.fn_splitval_by(value,14,'~') <> '')  then 'ON-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' and (citrus_usr.fn_splitval_by(value,13,'~') <> '' or citrus_usr.fn_splitval_by(value,14,'~') <> '')  then 'ON-DR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' and (citrus_usr.fn_splitval_by(value,13,'~') = '' and citrus_usr.fn_splitval_by(value,14,'~') = '')  then 'OF-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' and(citrus_usr.fn_splitval_by(value,13,'~') = '' and citrus_usr.fn_splitval_by(value,14,'~') = '')  then 'OF-DR' end   
			  else isnull(CITRUS_USR.fn_dp57_stuff('TRANS_CD',citrus_usr.fn_splitval_by(value,2,'~'),citrus_usr.fn_splitval_by(value,10,'~'),citrus_usr.fn_splitval_by(value,13,'~')) ,citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')) end cdshm_tratm_type_desc -- pending from latesh 
		,case when citrus_usr.fn_splitval_by(value,2,'~') = '1' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  when citrus_usr.fn_splitval_by(value,2,'~') = '4' then citrus_usr.fn_splitval_by(replace(cdasdesc ,' ','|'),1,'|')
			  when citrus_usr.fn_splitval_by(value,2,'~') = '15'  and citrus_usr.fn_splitval_by(value,7,'~') = '1503'  then 'NSCCL-DR'
			  when citrus_usr.fn_splitval_by(value,2,'~') in ('2','3')  then 
											case when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' and (citrus_usr.fn_splitval_by(value,13,'~') <> '' or citrus_usr.fn_splitval_by(value,14,'~') <> '')  then 'ON-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' and (citrus_usr.fn_splitval_by(value,13,'~') <> '' or citrus_usr.fn_splitval_by(value,14,'~') <> '')  then 'ON-DR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'CR' and (citrus_usr.fn_splitval_by(value,13,'~') = '' and citrus_usr.fn_splitval_by(value,14,'~') = '')  then 'OF-CR'  
											when CITRUS_USR.fn_dp57_stuff('crdr',citrus_usr.fn_splitval_by(value,35,'~'),'','') = 'DR' and(citrus_usr.fn_splitval_by(value,13,'~') = '' and citrus_usr.fn_splitval_by(value,14,'~') = '')  then 'OF-DR' end   
			  
			  else isnull(CITRUS_USR.fn_dp57_stuff('TRANS_CD',citrus_usr.fn_splitval_by(value,2,'~'),citrus_usr.fn_splitval_by(value,10,'~'),citrus_usr.fn_splitval_by(value,13,'~')),citrus_usr.fn_splitval_by(replace(cdasdesc,' ','|'),1,'|'))  end   cdshm_internal_tratm  -- pending from latesh 
		,'' cdshm_bal_type 
		,id 
		,'0' openingbal 
		,null
		,null
		,citrus_usr.fn_splitval_by(value,14,'~') 
		,null
		,value
		,citrus_usr.fn_splitval_by(value,2,'~') 
		,citrus_usr.fn_splitval_by(value,7,'~') 
		FROM #tmp_dp57_o , DP_aCCT_MSTR 
		WHERE citrus_usr.fn_splitval_by(value,3,'~') = DPAM_SBA_NO 
		and not exists(select cdshm_tras_dt
						,cdshm_ben_acct_no,cdshm_trans_no
						,cdshm_isin,cdshm_qty
						,cdshm_sett_no,cdshm_counter_boid
						,cdshm_counter_dpid from #tempdatacdsl  a 
						where cdshm_tras_dt = convert(datetime,left(citrus_usr.fn_splitval_by(value,9,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),5,4),103) 
						and cdshm_ben_acct_no = dpam_sba_no
						and cdshm_trans_no = citrus_usr.fn_splitval_by(value,5,'~') 
						and cdshm_isin = citrus_usr.fn_splitval_by(value,4,'~') 
						and cdshm_qty = qty  and cdshm_tratm_cd = citrus_usr.fn_splitval_by(value,35,'~')
						and cdshm_sett_no = right(citrus_usr.fn_splitval_by(value,13,'~'),7)
						and cdshm_counter_boid = case when citrus_usr.fn_splitval_by(value,11,'~') like '%IN%' then '' else  citrus_usr.fn_splitval_by(value,11,'~') end 
						and cdshm_counter_dpid = case when citrus_usr.fn_splitval_by(value,11,'~') like '%IN%' then citrus_usr.fn_splitval_by(value,11,'~')  else  '' end )


DECLARE @Rows numeric

SELECT @Rows=@@ROWCOUNT



declare @l_filecount numeric
,@l_insertedcount numeric
,@l_insertedcount_pl numeric
set @l_filecount = 0
set  @l_insertedcount = 0 
set @l_insertedcount_pl = 0 

select @l_filecount = citrus_usr.fn_splitval_by(value,2,'~') from #tmp_dp57_o where left(value,1)='T'
SELECT @l_insertedcount = @Rows 

--
--
--select @l_insertedcount = count(1)
--FROM #tmp_dp57_o , DP_aCCT_MSTR 
--WHERE citrus_usr.fn_splitval_by(value,3,'~') = DPAM_SBA_NO 
--and not exists(select cdshm_tras_dt
--,cdshm_ben_acct_no,cdshm_trans_no
--,cdshm_isin,cdshm_qty
--,cdshm_sett_no,cdshm_counter_boid
--,cdshm_counter_dpid from #tempdatacdsl  a 
--where cdshm_tras_dt = convert(datetime,left(citrus_usr.fn_splitval_by(value,9,'~'),2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),3,2)+'/'+substring(citrus_usr.fn_splitval_by(value,9,'~'),5,4),103) 
--and cdshm_ben_acct_no = dpam_sba_no
--and cdshm_trans_no = citrus_usr.fn_splitval_by(value,5,'~') 
--and cdshm_isin = citrus_usr.fn_splitval_by(value,4,'~') 
--and cdshm_qty = qty  and cdshm_tratm_cd = citrus_usr.fn_splitval_by(value,35,'~')
--and cdshm_sett_no = right(citrus_usr.fn_splitval_by(value,13,'~'),7)
--and cdshm_counter_boid = case when citrus_usr.fn_splitval_by(value,11,'~') like '%IN%' then '' else  citrus_usr.fn_splitval_by(value,11,'~') end 
--and cdshm_counter_dpid = case when citrus_usr.fn_splitval_by(value,11,'~') like '%IN%' then citrus_usr.fn_splitval_by(value,11,'~')  else  '' end )
--


select @l_insertedcount_pl =  count(1)
FROM #tmp_dp57_o where not exists 
(select dpam_sba_no 
from dp_acct_mstr 
where dpam_dpm_id = @l_dpm_id
and dpam_deleted_ind = 1
and CITRUS_USR.FN_SPLITVAL_BY(VALUE,3,'~')= dpam_sba_no)
AND citrus_usr.fn_splitval_by(value,1,'~')='D' and citrus_usr.fn_splitval_by(value,2,'~') in ('8','11','10') 

UPDATE filetask
SET    uploadfilename = isnull(uploadfilename ,'') 
+  citrus_usr.fn_splitval_by(@PA_DB_SOURCE,citrus_usr.ufn_countstring(@PA_DB_SOURCE,'\')+1,'\')   +'~'
+ 'FILE DATA COUNT : '  + convert(varchar,@l_filecount) 
+ ' DATA INSERTED : ' + convert(varchar,@l_insertedcount+isnull(@l_insertedcount_pl,0))    
+  case when exists(select 1 from filetask 
					where citrus_usr.fn_splitval_by(@PA_DB_SOURCE,citrus_usr.ufn_countstring(@PA_DB_SOURCE,'\')+1,'\') = citrus_usr.fn_splitval_by(uploadfilename,1,'~')
					
					) then  '--> File Already Imported' else '' end 
,  TASK_FILEDATE = @L_TRANS_DT
WHERE  task_id = @pa_task_id


truncate table #tmp_dp57_o
drop table #tmp_dp57_o

Exec citrus_usr.pr_upd_dp57_desc

END

GO
