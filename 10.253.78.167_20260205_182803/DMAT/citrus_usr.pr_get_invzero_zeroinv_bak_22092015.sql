-- Object: PROCEDURE citrus_usr.pr_get_invzero_zeroinv_bak_22092015
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec pr_get_invzero_zeroinv 'INVTOZERO'
--exec pr_get_invzero_zeroinv 'ZEROTOINV'
create proc [citrus_usr].[pr_get_invzero_zeroinv_bak_22092015](@pa_tab varchar(100))
as
begin 

		if @pa_tab ='INVTOZERO'
		begin

				select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
				into #account_properties from account_properties 
				where accp_accpm_prop_cd = 'AMC_DT' 
				and accp_value not in ('','//')

				INSERT INTO #account_properties 
				select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
				from account_properties O
				where accp_accpm_prop_cd = 'BILL_START_DT' 
				and accp_value not in ('','//')
				AND NOT EXISTS (SELECT 1 FROM account_properties I WHERE O.ACCP_CLISBA_ID = I.ACCP_CLISBA_ID AND I.ACCP_ACCPM_PROP_CD ='AMC_DT' AND ACCP_VALUE <> '')

				select * into #classmaxtradedt from anand1.msajag.dbo.MAXSAUDADATE

				select cdshm_dpam_id , MAX(cdshm_tras_dt) cdshm_tras_dt into #maxtrxdt from cdsl_holding_dtls group by CDSHM_DPAM_ID 


				select distinct dpam_sba_no [Demat account no]
				, dpam_bbo_code [BBO code]
				, accp_value [Account activation date / AMC date]
				, getdate() [Process run date]
				, CONVERT (NUMERIC (18,2),rate)*DPHMCD_FREE_QTY [Holding Value]
				, 'NA' [Transaction status]
				, 'NA' [Class transaction status]
				,  CONVERT(NUMERIC (18,2),isnull(citrus_usr.fn_get_ob(DPAM_ID ),0)) [Outstanding Amount]
				,brom_desc
				 into #tempdatafinal from dp_acct_mstr  with(nolock)
				 left outer join holdingallforview with(nolock) on DPHMCD_DPAM_ID = DPAM_ID 
				, client_charges_cdsl  with(nolock)
				, #account_properties with(nolock)
				,client_dp_brkg with(nolock)
				,BROKERAGE_MSTR 
				where DPAM_ID = CLIC_DPAM_ID and DPAM_ID = ACCP_CLISBA_ID  and CLIDB_DPAM_ID = DPAM_ID and CLIDB_BROM_ID = BROM_ID
				 and citrus_usr.LastMonthDay(DATEADD(mm,-3,GETDATE())) between clidb_eff_from_dt and isnull(clidb_eff_to_dt ,'Dec 31 2100')
				and clic_trans_dt between 'jul  1 2015' and 'Jul 31 2015' --between citrus_usr.ufn_GetFirstDayOfMonth((DATEADD(mm,-1,GETDATE()))) and citrus_usr.LastMonthDay(DATEADD(mm,-1,GETDATE()))
				and exists (select 1 from charge_mstr where CHAM_SLAB_NAME = CLIC_CHARGE_NAME and CHAM_CHARGE_TYPE in ('F','AMCPRO'))
				and year(clic_trans_dt) > YEAR(accp_value)
				and not exists (select 1 from LEDGER2 where ldg_Account_id = dpam_id and ldg_voucher_type in ('2','3') and ldg_deleted_ind = 1
				 and ldg_voucher_dt> citrus_usr.LastMonthDay(DATEADD(mm,-1,GETDATE())))
				and not exists (select 1 from #maxtrxdt where CDSHM_DPAM_ID = DPAM_ID and DATEDIFF(MM,cdshm_tras_dt,citrus_usr.LastMonthDay(DATEADD(mm,-1,GETDATE())))>6)
				and not exists (select 1 from #classmaxtradedt where DPAM_BBO_CODE  = party_code and DATEDIFF(MM,sauda_date,citrus_usr.LastMonthDay(DATEADD(mm,-1,GETDATE())))>6)
				and exists (select 1 from  holdingallforview where DPHMCD_DPAM_ID = dpam_id group by dphmcd_dpam_id  having sum(rate*DPHMCD_FREE_QTY )<500)
				and BROM_DESC not like '%zero%'
				and  BROM_DESC not like '%LIF%'

				select [Demat account no]
				,[BBO code]
				,[Account activation date / AMC date]
				,[Process run date]   
				,sum([Holding Value]) [Holding Value]
				,[Transaction status]
				,[Class transaction status]
				,[Outstanding Amount]
				,[brom_desc],case when [brom_desc] ='B2C INV' then 'ZEROB2C'
				when [brom_desc] ='COMMCORP' then 'ZEROCOMC'
				when [brom_desc] ='COMMINV' then 'ZEROCOMI'
				when [brom_desc] ='INV CORP' then 'ZEROCORP'
				when [brom_desc] ='1' then 'ZEROINV'
				when [brom_desc] ='JK INV' then 'ZEROJK'
				when [brom_desc] ='NBC CORP' then 'ZERONBCC'
				when [brom_desc] ='NBC' then 'ZERONBCI'
				when [brom_desc] ='NBFC INV' then 'ZERONBFCIN' 
				when [brom_desc] ='TRADERS' then 'ZEROTRD' else [brom_desc] end  [TO BE CHANGED]
				 from #tempdatafinal group by  
				[Demat account no]
				,[BBO code]
				,[Account activation date / AMC date]
				,[Process run date]   
				               
				,[Transaction status]
				,[Class transaction status]
				,[Outstanding Amount]
				,[brom_desc]

		end 
		if @pa_tab ='ZEROTOINV'
		begin
		print 'yogesh'
			select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
				into #account_properties1 from account_properties 
				where accp_accpm_prop_cd = 'AMC_DT' 
				and accp_value not in ('','//')

				INSERT INTO #account_properties1 
				select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
				from account_properties O
				where accp_accpm_prop_cd = 'BILL_START_DT' 
				and accp_value not in ('','//')
				AND NOT EXISTS (SELECT 1 FROM account_properties I WHERE O.ACCP_CLISBA_ID = I.ACCP_CLISBA_ID AND I.ACCP_ACCPM_PROP_CD ='AMC_DT' AND ACCP_VALUE <> '')

			
			

				select distinct dpam_sba_no [Demat account no]
				, dpam_bbo_code [BBO code]
				, accp_value [Account activation date / AMC date]
				, getdate() [Process run date]
				,  val [Holding Value]
				, 'NA' [Transaction status]
				, 'NA' [Class transaction status]
				, CONVERT(NUMERIC (18,2),isnull(citrus_usr.fn_get_ob(DPAM_ID ),0)) [Outstanding Amount]
				,brom_desc
				 into #tempdatafinal1 from dp_acct_mstr  with(nolock)
				 , (select DPHMCD_DPAM_ID, sum(rate*DPHMCD_FREE_QTY ) val from  holdingallforview  group by dphmcd_dpam_id  having sum(rate*DPHMCD_FREE_QTY )>750 ) holding 
				  
				 left outer join 
				  (select LDG_ACCOUNT_ID, SUM(ldg_amount) os  from LEDGER2 where ldg_deleted_ind = 1 group by LDG_ACCOUNT_ID
				 ) ledger  on ldg_account_id = DPHMCD_DPAM_ID  --and isnull(val ,0)> isnull(os,0)  
				, #account_properties1 with(nolock)
				,client_dp_brkg with(nolock)
				,BROKERAGE_MSTR 
				where DPAM_ID = ACCP_CLISBA_ID  and CLIDB_DPAM_ID = DPAM_ID and CLIDB_BROM_ID = BROM_ID 
				and DPHMCD_DPAM_ID = DPAM_ID 
				and GETDATE() between clidb_eff_from_dt and  ISNULL(clidb_eff_to_dt,'dec 31 2100')
				--and citrus_usr.LastMonthDay(DATEADD(mm,-3,GETDATE())) between clidb_eff_from_dt and isnull(clidb_eff_to_dt ,'Dec 31 2100')
				--and clic_trans_dt between citrus_usr.ufn_GetFirstDayOfMonth((DATEADD(mm,-3,GETDATE()))) and citrus_usr.LastMonthDay(DATEADD(mm,-3,GETDATE()))
				--and exists (select 1 from charge_mstr where CHAM_SLAB_NAME = CLIC_CHARGE_NAME and CHAM_CHARGE_TYPE in ('F','AMCPRO'))
				--and year(clic_trans_dt) > YEAR(accp_value)
				--and exists (select 1 from LEDGER2 where ldg_Account_id = dpam_id and ldg_deleted_ind = 1 group by LDG_ACCOUNT_ID having SUM(ldg_amount)>=0)
				--and exists (select 1 from  holdingallforview where DPHMCD_DPAM_ID = dpam_id group by dphmcd_dpam_id  having sum(rate*DPHMCD_FREE_QTY )>750)
				--and BROM_DESC like '%zero%' and  BROM_DESC not like '%waive%'

--SELECT * into  FROM #tempdatafinal1
--RETURN 

select * ,case when [brom_desc] = 'ZEROB2C' then  'B2C INV'
				when [brom_desc] = 'ZEROCOMC' then  'COMMCORP'
				when [brom_desc] = 'ZEROCOMI' then  'COMMINV' 
				when [brom_desc] = 'ZEROCORP' then  'INV CORP'
				when [brom_desc] = 'ZEROINV' then '1'
				when [brom_desc] = 'ZEROJK' then   'JK INV' 
				when [brom_desc] = 'ZERONBCC' then 'NBC CORP' 
				when [brom_desc] = 'ZERONBCI' then 'NBC' 
				when [brom_desc] = 'ZERONBFCIN'   then 'NBFC INV'
				when [brom_desc] = 'ZEROTRD'  then 'TRADERS'  else [brom_desc] end from #tempdatafinal1

				select [Demat account no]
				,[BBO code]
				,[Account activation date / AMC date]
				,[Process run date]   
				,sum([Holding Value]) [Holding Value]
				,[Transaction status]
			,[Class transaction status]
				,[Outstanding Amount]
				,[brom_desc],
				case when [brom_desc] = 'ZEROB2C' then  'B2C INV'
				when [brom_desc] = 'ZEROCOMC' then  'COMMCORP'
				when [brom_desc] = 'ZEROCOMI' then  'COMMINV' 
				when [brom_desc] = 'ZEROCORP' then  'INV CORP'
				when [brom_desc] = 'ZEROINV' then '1'
				when [brom_desc] = 'ZEROJK' then   'JK INV' 
				when [brom_desc] = 'ZERONBCC' then 'NBC CORP' 
				when [brom_desc] = 'ZERONBCI' then 'NBC' 
				when [brom_desc] = 'ZERONBFCIN'   then 'NBFC INV'
				when [brom_desc] = 'ZEROTRD'  then 'TRADERS'  else [brom_desc] end [TO BE CHANGED]
				 from #tempdatafinal1 where case when [brom_desc] = 'ZEROB2C' then  'B2C INV'
				when [brom_desc] = 'ZEROCOMC' then  'COMMCORP'
				when [brom_desc] = 'ZEROCOMI' then  'COMMINV' 
				when [brom_desc] = 'ZEROCORP' then  'INV CORP'
				when [brom_desc] = 'ZEROINV' then '1'
				when [brom_desc] = 'ZEROJK' then   'JK INV' 
				when [brom_desc] = 'ZERONBCC' then 'NBC CORP' 
				when [brom_desc] = 'ZERONBCI' then 'NBC' 
				when [brom_desc] = 'ZERONBFCIN'   then 'NBFC INV'
				when [brom_desc] = 'ZEROTRD'  then 'TRADERS'  else [brom_desc] end <> [brom_desc]  group by  
				[Demat account no]
				,[BBO code]
				,[Account activation date / AMC date]
				,[Process run date]   
				               
				,[Transaction status]
				,[Class transaction status]
				,[Outstanding Amount]
				,[brom_desc]
				--having sum([Holding Value]) < [Outstanding Amount]

		end 


end

GO
