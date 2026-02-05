-- Object: PROCEDURE citrus_usr.PR_RPT_EMPSUBWSREV_SUMMARY
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec PR_RPT_EMPSUBWSREV '3','BR','A','aug 01 2010','aug 31 2010',''   

CREATE PROCEDURE [citrus_usr].[PR_RPT_EMPSUBWSREV_SUMMARY](@PA_EXCSM_ID NUMERIC 
,@PA_ENTTM_CD VARCHAR(20)
,@PA_ACTION VARCHAR(20)
,@PA_FROM_DT DATETIME
,@PA_TO_DT DATETIME 
,@pa_code varchar(250)
,@PA_OUT VARCHAR(8000) OUT)
AS
begin 

SET DATEFORMAT DMY 


create table #client_Commission_summary 
(amc_date datetime
,carry_date datetime
,n_r char(1)
,dpam_sba_no varchar(20)
,dpam_sba_name varchar(100)
,brom_cd varchar(100)
,amc_charge numeric(18,3)
,Commission_paid numeric(18,3)
,branch_id varchar(100)
,Outstanding numeric(18,3)
,created_by varchar(100)
,created_dt datetime
,lst_upd_by varchar(100)
,lst_upd_dt datetime
,deleted_ind smallint
)

declare @ssql varchar(8000),
@finid int


DECLARE @L_DPM_ID NUMERIC 

SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DPM_EXCSM_ID = @PA_EXCSM_ID AND DEFAULT_DP = DPM_EXCSM_ID AND DPM_DELETED_IND = 1 



select distinct CONVERT(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd into #account_properties from account_properties 
where accp_accpm_prop_cd = 'BILL_START_DT' 

--SELECT * FROM #account_properties
declare @l_commis_br_id varchar(8000)
, @l_commis_amt_type  varchar(10)
, @l_commis_amt numeric(18,2)

IF @PA_ACTION = 'A'
BEGIN 


select @l_commis_br_id = commis_br_id, @l_commis_amt_type= commis_amt_typ , @l_commis_amt = commis_amt 
from commission_dtls where commis_type = 'A' 
and convert(datetime,convert(varchar,@PA_FROM_DT,103),103) between commis_frm_dt and commis_to_dt
and convert(datetime,convert(varchar,@PA_TO_DT,103),103) between commis_frm_dt and commis_to_dt
and commis_DELETED_IND = 1 



	IF @PA_ENTTM_CD = 'BR' and @l_commis_amt_type = 'V'
    begin 
			insert into #client_Commission_summary(branch_id,dpam_sba_no,dpam_sba_name,amc_charge,Commission_paid,amc_date,brom_cd)
			select ENTM_SHORT_NAME,dpam_sba_no , dpam_sba_name, clic_charge_amt amount 
			,case when @l_commis_br_id = 0 and  @l_commis_amt_type = 'V' then @l_commis_amt * citrus_usr.fn_get_brsharing(entr_sba) 
			end   REV_VALUE,accp_value   , brom_desc
			from DP_ACCT_MSTR , entity_relationship , ENTITY_MSTR , #account_properties, client_dp_brkg , brokerage_mstr 
			,(select sum(clic_charge_amt )*-1 clic_charge_amt, clic_dpam_id
			from client_charges_cdsl 
			where clic_charge_name like '%AMC%' 
			and  CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt group by clic_dpam_id) d
			WHERE DPAM_SBA_NO = ENTR_SBA and clic_dpam_id = dpam_id and dpam_id = clidb_Dpam_id and brom_id = clidb_brom_id 
			AND ACCP_CLISBA_ID = DPAM_ID 
			AND ENTR_AR = ENTM_ID 
			AND ENTM_ENTTM_CD = 'BR'
			--AND ENTR_TO_DT >= 'JAN 01 2009'
			AND isnull(ENTR_TO_DT,'') =  ''
			AND DPAM_DPM_ID = @L_DPM_ID 
			and dpam_stam_cd = 'ACTIVE'
			and getdate() between clidb_eff_from_dt and clidb_eff_to_dt
			--and @pa_to_dt between clidb_eff_from_dt and clidb_eff_to_dt
			AND ACCP_VALUE BETWEEN @PA_FROM_DT AND @PA_TO_DT
			AND ENTR_DELETED_IND = 1
			AND ENTM_DELETED_IND = 1 
			--and ENTM_SHORT_NAME = @pa_code
		end 
 

		if @PA_ENTTM_CD = 'BR' and @l_commis_amt_type = 'P'
		begin 
			insert into #client_Commission_summary(branch_id,dpam_sba_no,dpam_sba_name,amc_charge,Commission_paid,amc_date,brom_cd)
			select ENTM_SHORT_NAME,dpam_sba_no , dpam_sba_name, clic_charge_amt amount ,
			case  when @l_commis_br_id = 0 and  @l_commis_amt_type = 'P' then  (clic_charge_amt*@l_commis_amt/100 ) * citrus_usr.fn_get_brsharing(entr_sba)
			end   REV_VALUE  ,accp_value,brom_desc
			from DP_ACCT_MSTR , entity_relationship , ENTITY_MSTR , #account_properties
			,(select sum(clic_charge_amt )*-1 clic_charge_amt, clic_dpam_id
			from client_charges_cdsl 
			where clic_charge_name like '%AMC%' 
			and  CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt group by clic_dpam_id) d, client_dp_brkg , brokerage_mstr 
			WHERE DPAM_SBA_NO = ENTR_SBA and clic_dpam_id = dpam_id and dpam_id = clidb_Dpam_id and brom_id = clidb_brom_id 
			AND ACCP_CLISBA_ID = DPAM_ID 
			AND ENTR_AR = ENTM_ID and clic_charge_amt <> 0
			AND ENTM_ENTTM_CD = 'BR'
			and getdate() between clidb_eff_from_dt and clidb_eff_to_dt
			-- and @pa_to_dt between clidb_eff_from_dt and clidb_eff_to_dt
			--AND ENTR_TO_DT >= 'JAN 01 2009'
			AND isnull(ENTR_TO_DT,'') =  ''
			AND DPAM_DPM_ID = @L_DPM_ID 
			and dpam_stam_cd = 'ACTIVE'
			AND ACCP_VALUE BETWEEN @PA_FROM_DT AND @PA_TO_DT
			AND ENTR_DELETED_IND = 1
			AND ENTM_DELETED_IND = 1 
			--and ENTM_SHORT_NAME = @pa_code
		end 





	
END
else IF @PA_ACTION = 'R'
BEGIN 


select @l_commis_br_id = commis_br_id, @l_commis_amt_type= commis_amt_typ , @l_commis_amt = commis_amt 
from commission_dtls where commis_type = 'R' 
and convert(datetime,convert(varchar,@PA_FROM_DT,103),103) between commis_frm_dt and commis_to_dt
and convert(datetime,convert(varchar,@PA_TO_DT,103),103) between commis_frm_dt and commis_to_dt
and commis_DELETED_IND = 1 


	IF @PA_ENTTM_CD = 'BR' and @l_commis_amt_type = 'V'
	begin 
			
			insert into #client_Commission_summary(branch_id,dpam_sba_no,dpam_sba_name,amc_charge,Commission_paid,amc_date,brom_cd)select ENTM_SHORT_NAME,dpam_sba_no , dpam_sba_name, clic_charge_amt amount 
			,case when @l_commis_br_id = 0 and  @l_commis_amt_type = 'V' then @l_commis_amt 
			end   REV_VALUE,accp_value ,brom_desc  
			from DP_ACCT_MSTR , entity_relationship , ENTITY_MSTR , #account_properties
			,(select sum(clic_charge_amt )*-1 clic_charge_amt, clic_dpam_id
			from client_charges_cdsl 
			where clic_charge_name like '%AMC%' 
			and  CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt group by clic_dpam_id) d, client_dp_brkg,brokerage_mstr
			WHERE DPAM_SBA_NO = ENTR_SBA and clic_dpam_id = dpam_id and dpam_id = clidb_Dpam_id and brom_id = clidb_brom_id 
			AND ACCP_CLISBA_ID = DPAM_ID 
			AND ENTR_AR = ENTM_ID 
			AND ENTM_ENTTM_CD = 'BR'
			--AND ENTR_TO_DT >= 'JAN 01 2009'
			AND isnull(ENTR_TO_DT,'') =  ''
			AND DPAM_DPM_ID = @L_DPM_ID 
			and getdate() between clidb_eff_from_dt and clidb_eff_to_dt
			--and @pa_to_dt between clidb_eff_from_dt and clidb_eff_to_dt
			and dpam_stam_cd = 'ACTIVE'
			AND month(ACCP_VALUE) BETWEEN month(@PA_FROM_DT) AND month(@PA_TO_DT)
			AND day(ACCP_VALUE) BETWEEN day(@PA_FROM_DT) AND day(@PA_TO_DT)
			AND year(ACCP_VALUE) not between  year(@PA_FROM_DT) AND year(@PA_TO_DT)
			AND ENTR_DELETED_IND = 1
			AND ENTM_DELETED_IND = 1 --and ENTM_SHORT_NAME = @pa_code 
			order by dpam_sba_no
		end 
	




	if @PA_ENTTM_CD = 'BR' and @l_commis_amt_type = 'P'
	begin 
			insert into #client_Commission_summary(branch_id,dpam_sba_no,dpam_sba_name,amc_charge,Commission_paid,amc_date,brom_cd)
			select ENTM_SHORT_NAME,dpam_sba_no , dpam_sba_name, clic_charge_amt amount ,
			case  when @l_commis_br_id = 0 and  @l_commis_amt_type = 'P' then  clic_charge_amt*@l_commis_amt/100 
			end   REV_VALUE  ,accp_value,brom_desc
			from DP_ACCT_MSTR , entity_relationship , ENTITY_MSTR , #account_properties
			,(select sum(clic_charge_amt )*-1 clic_charge_amt, clic_dpam_id
			from client_charges_cdsl 
			where clic_charge_name like '%AMC%' 
			and  CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt group by clic_dpam_id) d, client_dp_brkg,brokerage_mstr
			WHERE DPAM_SBA_NO = ENTR_SBA and clic_dpam_id = dpam_id and dpam_id = clidb_Dpam_id and brom_id = clidb_brom_id 
			AND ACCP_CLISBA_ID = DPAM_ID 
			AND ENTR_AR = ENTM_ID 
			and getdate() between clidb_eff_from_dt and clidb_eff_to_dt
			--   and @pa_to_dt between clidb_eff_from_dt and clidb_eff_to_dt
			AND ENTM_ENTTM_CD = 'BR'
			--AND ENTR_TO_DT >= 'JAN 01 2009'
			AND isnull(ENTR_TO_DT,'') =  ''
			AND DPAM_DPM_ID = @L_DPM_ID  and clic_charge_amt <> 0
			and dpam_stam_cd = 'ACTIVE'
			AND month(ACCP_VALUE) BETWEEN month(@PA_FROM_DT) AND month(@PA_TO_DT)
			AND day(ACCP_VALUE) BETWEEN day(@PA_FROM_DT) AND day(@PA_TO_DT)
			AND year(ACCP_VALUE) not between  year(@PA_FROM_DT) AND year(@PA_TO_DT)
			AND ENTR_DELETED_IND = 1
			AND ENTM_DELETED_IND = 1 
			--and ENTM_SHORT_NAME = @pa_code
	end 


	
END
ELSE
BEGIN
	select @l_commis_br_id = commis_br_id, @l_commis_amt_type= commis_amt_typ , @l_commis_amt = commis_amt 
    from commission_dtls where commis_type = 'T' 
and convert(datetime,convert(varchar,@PA_FROM_DT,103),103) between commis_frm_dt and commis_to_dt
and convert(datetime,convert(varchar,@PA_TO_DT,103),103) between commis_frm_dt and commis_to_dt
    and commis_DELETED_IND = 1 


	IF @PA_ENTTM_CD = 'BR' and @l_commis_br_id <> 0
	begin 
			insert into #client_Commission_summary(branch_id,dpam_sba_no,dpam_sba_name,amc_charge,Commission_paid,amc_date,brom_cd)
			select ENTM_SHORT_NAME,dpam_sba_no , dpam_sba_name, sum(clic_charge_amt) , abs(case when @l_commis_br_id = 0 and  @l_commis_amt_type = 'V' then @l_commis_amt 
			when @l_commis_br_id = 0 and  @l_commis_amt_type = 'P' then  -1*sum(clic_charge_amt)*(@l_commis_amt/100) end )  REV_VALUE
			,@PA_TO_DT, brom_desc
			from DP_ACCT_MSTR , entity_relationship , ENTITY_MSTR , client_charges_cdsl, client_dp_brkg,brokerage_mstr
			WHERE DPAM_SBA_NO = ENTR_SBA and clidb_dpam_id = dpam_id and clidb_brom_id = brom_id 
			AND clic_dpam_ID = DPAM_ID 
			AND ENTR_AR = ENTM_ID 
			AND ENTM_ENTTM_CD = 'BR'
			--AND ENTR_TO_DT >= 'JAN 01 2009'
			AND isnull(ENTR_TO_DT,'') =  ''
			AND DPAM_DPM_ID = @L_DPM_ID 
			and getdate() between clidb_eff_from_dt and clidb_eff_to_dt
			and dpam_stam_cd = 'ACTIVE' and clic_charge_name = 'TRANSACTION CHARGES'
			AND CLIC_TRANS_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT
			AND ENTR_DELETED_IND = 1
			AND ENTM_DELETED_IND = 1 
			GROUP BY ENTM_SHORT_NAME,dpam_sba_no,dpam_sba_name,BROM_DESC
	end 
END


delete from client_Commission_summary 
where branch_id in (select br_code from ownbranchlist)


delete from #client_Commission_summary 
where branch_id in (select br_code from ownbranchlist)




insert into #client_Commission_summary 
select * from client_Commission_summary where carry_date is null  and n_r = @PA_ACTION  and amc_date BETWEEN @PA_FROM_DT AND @PA_TO_DT 

update #client_Commission_summary set n_r = @PA_ACTION  

--UPDATE a
--SET Outstanding = isnull((SELECT SUM(LDG_AMOUNT) 
--				   FROM LEDGER3 , DP_ACCT_MSTR dpam
--				   WHERE ldg_account_type = 'P' 
--				   and ldg_account_id = dpam_id 
--				   and ldg_deleted_ind= 1 
--				   and dpam.dpam_sba_no  = a.dpam_sba_no),0)
--from #client_Commission_summary  a
--where carry_date is null

select @finid = fin_id from financial_yr_mstr where @PA_FROM_DT  between  FIN_START_DT and FIN_END_DT and fin_deleted_ind = 1

set @ssql=
'UPDATE a
SET Outstanding = isnull((SELECT SUM(LDG_AMOUNT) 
				   FROM LEDGER'+ convert(varchar,@finid ) + ' , DP_ACCT_MSTR dpam
				   WHERE ldg_account_type = ''P'' 
				   and ldg_account_id = dpam_id 
				   and ldg_deleted_ind= 1 and ldg_voucher_dt <= ''' + convert(varchar(11),@PA_to_DT,109)
				  + ''' and dpam.dpam_sba_no  = a.dpam_sba_no),''0'') 
from #client_Commission_summary  a
where carry_date is null
and 0 < (select count(1)  FROM LEDGER'+ convert(varchar,@finid ) + ' , DP_ACCT_MSTR dpam
				   WHERE ldg_account_type = ''P'' 
				   and ldg_account_id = dpam_id 
				   and ldg_deleted_ind= 1 and ldg_voucher_dt <= ''' + convert(varchar(11),@PA_to_DT,109)
				  + ''' and dpam.dpam_sba_no  = a.dpam_sba_no)'
print @ssql
exec(@ssql)

--select * from #client_Commission_summary where dpam_sba_no ='1203270000263947'
--return 


update #client_Commission_summary set Commission_paid = 0 where Outstanding < 0 and carry_date is null
update #client_Commission_summary set carry_date = @PA_FROM_DT where Outstanding >= 0 and carry_date is null

--select * from #client_Commission_summary where dpam_sba_no ='1203270000050830'


select ENTM_SHORT_NAME,dpam_sba_no , dpam_sba_name, amc_charge amount 
    ,  Commission_paid REV_VALUE,amc_date accp_value ,brom_cd brom_desc  
from #client_Commission_summary ,fin_Account_mstr,ENTITY_MSTR 
WHERE FINA_BRANCH_ID = ENTM_ID 
AND ENTM_SHORT_NAME = branch_id and fina_deleted_ind =1 
and carry_date between @PA_FROM_DT and @PA_TO_DT and  Commission_paid  <> 0 
and n_r  = @PA_ACTION
and branch_id = @pa_code


--select * from fin_Account_mstr where FINA_BRANCH_ID = 83032
--select * from entity_mstr where entm_short_name ='000007'




END

GO
