-- Object: PROCEDURE citrus_usr.pr_rpt_billsummary_ledgeros
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_rpt_billsummary_ledgeros](@pa_flag char(1),@pa_from_dt datetime,
@pa_to_dt datetime,@pa_asondate datetime,@pa_frmacct varchar(16),@pa_toacct varchar(16),
@pa_bbocd varchar(16),@pa_login_pr_entm_id numeric,@pa_login_entm_cd_chain  varchar(8000)
,@pa_excsmid int ,@pa_ref_cur VARCHAR(8000) OUT)
as
begin

                           
 IF @pa_frmacct = ''                                    
 BEGIN                                    
 SET @pa_frmacct = '0'                                    
 SET @pa_toacct = '99999999999999999'                                    
 END                                    
 IF @pa_toacct = ''                                    
 BEGIN                                
 SET @pa_toacct = @pa_frmacct                                    
 END 

	
	declare	@@l_child_entm_id numeric,
	@@dpmid int

	--select @@l_child_entm_id    =  
--case when citrus_usr.fn_get_child_os(@pa_login_pr_entm_id , @pa_login_entm_cd_chain) <>'0' 
--then citrus_usr.fn_get_child_os(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)  
--else @pa_login_pr_entm_id end 
declare @l_count numeric
,@l_counter numeric
set @l_counter = 1 
set @l_count = citrus_usr.ufn_countstring(@pa_login_entm_cd_chain,'|*~|')

while @l_counter  <= @l_count
begin 


select @@l_child_entm_id    = entm_id from entity_mstr  where entm_short_name = citrus_usr.fn_splitval(@pa_login_entm_cd_chain,@l_counter)
and entm_deleted_ind = 1 


set @l_counter   = @l_counter   + 1
  
end 

--select @@l_child_entm_id
--
--return 

--
--select @@l_child_entm_id    =  
--case when citrus_usr.fn_get_child_os(@pa_login_pr_entm_id , @pa_login_entm_cd_chain) <>'0' 
--then citrus_usr.fn_get_child_os(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)  
--else @pa_login_pr_entm_id end 

	select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_excsmid and dpm_deleted_ind =1                      

	CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME,dpam_bbo_code varchar(100),stam_desc varchar(100))
declare @l_entity varchar(100)



select @l_entity  = entm_enttm_cd from entity_mstr 
where entm_id = @@l_child_entm_id and entm_deleted_ind = 1
print @l_entity
print @@l_child_entm_id

INSERT INTO #ACLIST 
SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,entr_from_dt,isnull(entr_to_dt,'dec 31 2100')  EFF_TO	
,dpam.dpam_bbo_code ,stam_desc
	FROM entity_relationship , dp_acct_mstr dpam,status_mstr
	where dpam_sba_no = entr_sba and dpam_stam_cd = stam_cd 
	  AND ENTR_DELETED_IND = '1' and dpam_excsm_id = @pa_excsmid
	and getdate() between entr_from_dt and isnull(entr_to_dt,'dec 31 2100')
	and case when @l_entity ='HO' then ENTR_HO
when @l_entity ='re' then ENTR_RE  
when @l_entity ='ar' then ENTR_AR 
when @l_entity ='br' then entr_br 
when @l_entity ='ba' then ENTR_SB 
when @l_entity ='rem' then ENTR_DUMMY1  
when @l_entity ='onw' then ENTR_DUMMY3 end = @@l_child_entm_id

  
	--and dpam.dpam_id = @@dpmid
--select * from #ACLIST
--return

	if @pa_flag ='B'
	begin
		if @pa_frmacct <> '' 
		begin
		
		SELECT DPAM_SBA_NO  [CLIENT ID]
		,isnull(dpam_bbo_code,'') [BBO CODE]
		,REPLACE(RIGHT(CONVERT(VARCHAR(9), clic_trans_dt, 6), 6), ' ', '-') [BILL PERIOD] 
		,abs(SUM(CLIC_CHARGE_AMT)) [BILL AMOUNT]
		,case when SUM(CLIC_CHARGE_AMT) > = 0 then 'cr' else 'dr' end  [DR/CR]
		FROM CLIENT_CHARGES_CDSL with(nolock) ,#ACLIST --,DP_ACCT_MSTR with(nolock)  
		WHERE CLIC_DELETED_IND = 1 
		AND DPAM_ID = CLIC_DPAM_ID 
		AND clic_trans_dt between @pa_from_dt  and @pa_to_dt
		AND DPAM_SBA_NO between @pa_frmacct and @pa_toacct
		and isnull(dpam_bbo_code,'') like  @pa_bbocd + '%'
		and CLIC_FLG <> 'B'
		group by DPAM_SBA_NO,dpam_bbo_code,REPLACE(RIGHT(CONVERT(VARCHAR(9), clic_trans_dt, 6), 6), ' ', '-')
        having SUM(CLIC_CHARGE_AMT) <> 0

--		select '5458' [client id], '6644444' [bbo code] , 'sfds44' BILL_PERIOD, 'apr 2012' bill_amount, '54222' [cr/dr] from account_properties
--		union all
--		select dpam_sba_no [CLIENT ID], DPAM_SBA_NAME [BBO CODE] , DPAM_CREATED_BY [BILL PERIOD], 'apr 2012' [BILL AMOUNT], 'cr' [DR/CR] from dp_acct_mstr
--		union all
--		select '5458' [CLIENT ID], '6644444' [BBO CODE] , 'sfds44' [BILL PERIOD], 'apr 2012' [BILL AMOUNT], 'dr' [DR/CR]
--		return
		end 
		else 
		begin

		SELECT DPAM_SBA_NO  [CLIENT ID]
		,isnull(dpam_bbo_code,'') [BBO CODE]
		,REPLACE(RIGHT(CONVERT(VARCHAR(9), clic_trans_dt, 6), 6), ' ', '-') [BILL PERIOD] 
		,abs(SUM(CLIC_CHARGE_AMT)) [BILL AMOUNT]
		,case when SUM(CLIC_CHARGE_AMT) > = 0 then 'cr' else 'dr' end  [DR/CR]
		FROM CLIENT_CHARGES_CDSL with(nolock) ,#ACLIST--,DP_ACCT_MSTR with(nolock)  
		WHERE CLIC_DELETED_IND = 1 
		AND DPAM_ID = CLIC_DPAM_ID 
		AND clic_trans_dt between @pa_from_dt  and @pa_to_dt
		--AND DPAM_SBA_NO between @pa_frmacct and @pa_toacct
		and isnull(dpam_bbo_code,'') like  @pa_bbocd + '%'
		and CLIC_FLG <> 'B'
		group by DPAM_SBA_NO,dpam_bbo_code,REPLACE(RIGHT(CONVERT(VARCHAR(9), clic_trans_dt, 6), 6), ' ', '-')
        having SUM(CLIC_CHARGE_AMT) <> 0

--		select '5456' [client id], '6644444' [bbo code] , 'sfds44' BILL_PERIOD, 'apr 2012' bill_amount, '54222' [cr/dr] from dp_acct_mstr
--		return
		end 
	end 
	if @pa_flag ='L'
	begin

		declare @l_fin_id numeric
		,@l_str varchar(8000)
		set @l_str =''
		select @l_fin_id = FIN_ID from financial_yr_mstr where @pa_asondate between FIN_START_DT and FIN_END_DT and FIN_DELETED_IND = 1 

		if @pa_frmacct <> '' 
		begin

		select @l_str = 'SELECT ''''''''+ DPAM_SBA_NO  [client id]
		,isnull(dpam_bbo_code,'''') [bbo code]
		,abs(SUM(ldg_amount)) os_amount
		,case when SUM(ldg_amount) > = 0 then ''cr'' else ''dr'' end  [cr/dr]
		,stam_desc
		,case when ltrim(rtrim(isnull(dps8_pc1.PriPhNum,'''')))  <>'''' then ltrim(rtrim(isnull(dps8_pc1.PriPhNum,'''')))+ case when ltrim(rtrim(isnull(dps8_pc1.AltPhNum,''''))) <> '''' then '','' else '''' end   else '''' end + case when ltrim(rtrim(isnull(dps8_pc1.AltPhNum,'''')))  <>'''' then ltrim(rtrim(isnull(dps8_pc1.AltPhNum,''''))) else '''' end contactno
		,dps8_pc1.EMailId [EMAIL]
		,left(dps8_pc1.AcctCreatDt,2) + ''/'' +  substring(dps8_pc1.AcctCreatDt,3,2) + ''/''  + right(dps8_pc1.AcctCreatDt,4) ACTDT
		,case when ClosDt <> '''' then left(dps8_pc1.ClosDt,2) +''/''+ substring(dps8_pc1.ClosDt,3,2)+''/''+right(dps8_pc1.ClosDt,4) else '''' end CLDT
		,brom_desc
		FROM ledger' + convert(varchar(10),@l_fin_id) + ' with(nolock)  ,#ACLIST left outer join dps8_pc1 on dpam_sba_no = boid 
		left outer join client_dp_brkg on clidb_dpam_id = dpam_id AND CLIDB_DELETED_IND = 1 
		left outer join brokerage_mstr on brom_id  = clidb_brom_id 
		WHERE ldg_deleted_ind = 1 
		AND ldg_account_id = dpam_id 
		AND DPAM_SBA_NO between ''' + @pa_frmacct + ''' and ''' + @pa_toacct + '''
		and isnull(dpam_bbo_code,'''') like  ''' + @pa_bbocd + '%''  
	    and ldg_account_type =''P''
		and ldg_voucher_dt < = '''+ convert(varchar(11),@pa_asondate,109) +'''
		and getdate() between isnull(clidb_eff_from_dt ,''jan 01 1900'') and isnull(clidb_eff_to_dt ,''jan 31 2100'')
		group by brom_desc,DPAM_SBA_NO,isnull(dpam_bbo_code,''''),stam_desc,dps8_pc1.PriPhNum,dps8_pc1.AltPhNum,dps8_pc1.EMailId,dps8_pc1.AcctCreatDt,dps8_pc1.ClosDt having SUM(ldg_amount) <> 0'
--,DP_ACCT_MSTR  with(nolock)
		end 
		else 
		begin

		select @l_str = 'SELECT ''''''''+  DPAM_SBA_NO  [client id]
		,isnull(dpam_bbo_code,'''') [bbo code]
		,abs(SUM(ldg_amount)) os_amount
		,case when SUM(ldg_amount) > = 0 then ''cr'' else ''dr'' end  [cr/dr]
		,stam_desc
		,case when ltrim(rtrim(isnull(dps8_pc1.PriPhNum,'''')))  <>'''' then ltrim(rtrim(isnull(dps8_pc1.PriPhNum,'''')))+ case when ltrim(rtrim(isnull(dps8_pc1.AltPhNum,''''))) <> '''' then '','' else '''' end   else '''' end  + case when ltrim(rtrim(isnull(dps8_pc1.AltPhNum,'''')))  <>'''' then ltrim(rtrim(isnull(dps8_pc1.AltPhNum,''''))) else '''' end contactno
		,dps8_pc1.EMailId [EMAIL]
		,left(dps8_pc1.AcctCreatDt,2) + ''/'' +  substring(dps8_pc1.AcctCreatDt,3,2) + ''/''  + right(dps8_pc1.AcctCreatDt,4) ACTDT
		,case when ClosDt <> '''' then left(dps8_pc1.ClosDt,2) +''/''+ substring(dps8_pc1.ClosDt,3,2)+''/''+right(dps8_pc1.ClosDt,4) else '''' end CLDT
		,brom_desc
		FROM ledger' + convert(varchar(10),@l_fin_id) + ' with(nolock)  ,#ACLIST  left outer join dps8_pc1 on dpam_sba_no = boid  
		left outer join client_dp_brkg on clidb_dpam_id = dpam_id AND CLIDB_DELETED_IND = 1 
		left outer join brokerage_mstr on brom_id  = clidb_brom_id 
		WHERE ldg_deleted_ind = 1 
		AND ldg_account_id = dpam_id  
		and isnull(dpam_bbo_code,'''') like  ''' + @pa_bbocd + '%'' 
	    and ldg_account_type =''P''
		and ldg_voucher_dt < = '''+ convert(varchar(11),@pa_asondate,109) +'''
		and getdate() between isnull(clidb_eff_from_dt ,''jan 01 1900'') and isnull(clidb_eff_to_dt ,''jan 31 2100'')
		group by brom_desc,DPAM_SBA_NO,isnull(dpam_bbo_code,''''),stam_desc,dps8_pc1.PriPhNum,dps8_pc1.AltPhNum,dps8_pc1.EMailId,dps8_pc1.AcctCreatDt,dps8_pc1.ClosDt having SUM(ldg_amount) <> 0'
--,DP_ACCT_MSTR  with(nolock)


		end 
		 print @l_str
		 exec(@l_str)

	end 

end

GO
