-- Object: PROCEDURE citrus_usr.pr_servicetax_breakup
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec pr_servicetax_breakup '',2,'mar 01 2010','mar 31 2010','R','D',''
--exec pr_servicetax_breakup '',2,'mar 01 2010','mar 31 2010','R','S',''
--exec pr_servicetax_breakup '',2,'mar 01 2010','mar 31 2010','B','D',''
--exec pr_servicetax_breakup '',2,'mar 01 2010','mar 31 2010','B','S',''

CREATE proc [citrus_usr].[pr_servicetax_breakup](@pa_id varchar(30)
,@pa_fin_id numeric
,@pa_from_dt varchar(11)
,@pa_to_dt varchar(11)
,@pa_flag varchar(10)
,@pa_summary_details varchar(100)
,@pa_out varchar(8000) out )
as
begin 
declare @l_sql varchar(8000)
set @l_sql = ''
create table #tmpledger (LDG_ACCOUNT_ID numeric,BALANCE numeric(18,2),AMT numeric(18,2),RECOVEREDAMOUNT numeric(18,2))

	if @pa_fin_id <> 0 
	begin 

      if @pa_flag = 'R' and @pa_summary_details = 'D'
      begin 
		set @l_sql = ' insert into #tmpledger SELECT LDG_ACCOUNT_ID,BALANCE,AMT 
		,ABS(CASE WHEN AMT > 0 AND BALANCE > 0 THEN 0
		WHEN AMT = ABS(BALANCE)  THEN AMT
		WHEN AMT-ABS(BALANCE) > 0 THEN BALANCE
		ELSE AMT END)  RECOVEREDAMOUNT
		FROM (
		select ldg_account_id 
		,(select sum(ldg_amount) 
		  from ledger'+ convert(varchar,@pa_fin_id) + '  b 
		  where b.ldg_account_id = a.ldg_account_id
		  AND B.LDG_DELETED_IND = 1 AND B.LDG_VOUCHER_DT<'''+@pa_to_dt+''') BALANCE
		,sum(ldg_amount) amt 
		from ledger'+ convert(varchar,@pa_fin_id) + '  a
		where ldg_deleted_ind =1 and ldg_account_type= ''P'' and ldg_voucher_type <> ''5''
		and ldg_voucher_dt between '''+ @pa_from_dt +''' and '''+ @pa_to_dt + ''' 
		group by ldg_account_id) A ' 

		print @l_sql
		exec(@l_sql)


		SELECT DPAM_SBA_NO,(RECOVEREDAMOUNT*1000)/1103 MAINAMOUNT, (RECOVEREDAMOUNT*1000/1103)*0.10 SERVICETAX 
		,(RECOVEREDAMOUNT*1000/1103)*0.003 [EDU CESS]
		FROM #tmpledger , DP_aCCT_MSTR 
		WHERE LDG_ACCOUNT_ID = DPAM_ID 
		ORDER BY DPAM_SBA_NO

     end 
	 else if @pa_flag = 'R' and @pa_summary_details = 'S'
      begin 
		set @l_sql = ' insert into #tmpledger SELECT LDG_ACCOUNT_ID,BALANCE,AMT 
		,ABS(CASE WHEN AMT > 0 AND BALANCE > 0 THEN 0
		WHEN AMT = ABS(BALANCE)  THEN AMT
		WHEN AMT-ABS(BALANCE) > 0 THEN BALANCE
		ELSE AMT END)  RECOVEREDAMOUNT
		FROM (
		select ldg_account_id 
		,(select sum(ldg_amount) 
		  from ledger'+ convert(varchar,@pa_fin_id) + '  b 
		  where b.ldg_account_id = a.ldg_account_id
		  AND B.LDG_DELETED_IND = 1 AND B.LDG_VOUCHER_DT<'''+@pa_to_dt+''') BALANCE
		,sum(ldg_amount) amt 
		from ledger'+ convert(varchar,@pa_fin_id) + '  a
		where ldg_deleted_ind =1 and ldg_account_type= ''P'' and ldg_voucher_type <> ''5''
		and ldg_voucher_dt between '''+ @pa_from_dt +''' and '''+ @pa_to_dt + ''' 
		group by ldg_account_id) A ' 

		print @l_sql
		exec(@l_sql)


		SELECT DPAM_SBA_NO,(RECOVEREDAMOUNT*1000)/1103 MAINAMOUNT, (RECOVEREDAMOUNT*1000/1103)*0.10 SERVICETAX 
		,(RECOVEREDAMOUNT*1000/1103)*0.003 [EDU CESS]
		into #summary2 FROM #tmpledger , DP_aCCT_MSTR 
		WHERE LDG_ACCOUNT_ID = DPAM_ID 
		ORDER BY DPAM_SBA_NO


        select count(DPAM_SBA_NO) [No fo client] ,sum(MAINAMOUNT) MAINAMOUNT ,sum(SERVICETAX) SERVICETAX,sum([EDU CESS]) [EDU CESS]
		from  #summary2 having isnull(sum(MAINAMOUNT),0)  <>'0'

     end 
	 else if @pa_flag = 'B' and @pa_summary_details = 'S'
      begin 
		

		insert into #tmpledger 
		select clic_dpam_id , 0,0,sum(clic_charge_amt)
        from client_charges_cdsl where CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt and clic_deleted_ind =1 
        group by clic_dpam_id

		SELECT DPAM_SBA_NO,(RECOVEREDAMOUNT*1000)/1103 MAINAMOUNT, (RECOVEREDAMOUNT*1000/1103)*0.10 SERVICETAX 
		,(RECOVEREDAMOUNT*1000/1103)*0.003 [EDU CESS]
		into #summary3 FROM #tmpledger , DP_aCCT_MSTR 
		WHERE LDG_ACCOUNT_ID = DPAM_ID 
		ORDER BY DPAM_SBA_NO


        select  count(DPAM_SBA_NO)[No fo client],sum(MAINAMOUNT) MAINAMOUNT ,sum(SERVICETAX) SERVICETAX,sum([EDU CESS]) [EDU CESS]
		from  #summary3 having isnull(sum(MAINAMOUNT),0)  <>'0'

     end 
	else if @pa_flag = 'B' and @pa_summary_details = 'D'
      begin 
		insert into #tmpledger 
		select clic_dpam_id , 0,0,sum(clic_charge_amt)
        from client_charges_cdsl where CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt and clic_deleted_ind =1 
        group by clic_dpam_id


		SELECT DPAM_SBA_NO,(RECOVEREDAMOUNT*1000)/1103 MAINAMOUNT, (RECOVEREDAMOUNT*1000/1103)*0.10 SERVICETAX 
		,(RECOVEREDAMOUNT*1000/1103)*0.003 [EDU CESS]
		FROM #tmpledger , DP_aCCT_MSTR 
		WHERE LDG_ACCOUNT_ID = DPAM_ID 
		ORDER BY DPAM_SBA_NO



     end 


	end 


end

GO
