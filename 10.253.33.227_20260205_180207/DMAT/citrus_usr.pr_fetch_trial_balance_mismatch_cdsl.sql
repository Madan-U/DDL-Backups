-- Object: PROCEDURE citrus_usr.pr_fetch_trial_balance_mismatch_cdsl
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



--select * from dp_mstr where default_dp = dpm_excsm_id  
--select * from financial_yr_mstr  
--select * into ledger2_bak31032011_2 from ledger2  
--exec pr_fetch_trial_balance_mismatch_cdsl 1,10,3--client missing or amount mismatch  
--exec pr_fetch_trial_balance_mismatch_cdsl 2,10,3-- any mismatch by group by voucher  
--exec pr_fetch_trial_balance_mismatch_cdsl 3,10,3-- please check account active or not   
--exec pr_fetch_trial_balance_mismatch_cdsl 4,10,3-- relationship and vocuher dt not match  
--select 51343309.30  - 51342976.07    --333.23  
---exec pr_fetch_trial_balance_mismatch_cdsl 5,7,3
CREATE proc [citrus_usr].[pr_fetch_trial_balance_mismatch_cdsl](@pa_case varchar(25),@pa_fin_id numeric, @pa_dpm_id numeric)  
as  
begin   
  
   declare @l_sql varchar(8000)  
   declare @l_sql1 varchar(8000)  
     
 if @pa_case  ='1'  
 begin  
     
  
   set @l_sql = ' select dpam_sba_no,sum(ldg_amount) amount  
   into ##report  
   from ledger'+convert(varchar(10),@pa_fin_id) + ' , (SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO,acct_type,group_id FROM citrus_usr.fn_gl_acct_list( '+ convert(varchar(25),@pa_dpm_id )+' ,1,0) ) account   
   where ldg_dpm_id = ' +  convert(varchar(25),@pa_dpm_id )  
   +' and ldg_account_id = account.dpam_id and ldg_account_type = account.acct_type   
   and (ldg_voucher_dt between eff_from and eff_to)   
   and ldg_account_type = ''P''  
   and ldg_deleted_ind = 1   
   group by dpam_sba_no  '    
   print @l_sql  
   exec(@l_sql)  
  
   set @l_sql1 = '  select dpam_sba_no,sum(ldg_amount) amount  
   into ##report_org  
   from ledger'+convert(varchar(10),@pa_fin_id) + '  , dp_acct_mstr account   
   where ldg_dpm_id = ' +convert(varchar(25),@pa_dpm_id ) + '     
   and ldg_account_id = account.dpam_id   
   and ldg_account_type = ''P''  
   and dpam_deleted_ind = 1   
   and ldg_deleted_ind = 1 and len(dpam_sba_no) = 16  
   group by dpam_sba_no '   
   print @l_sql1  
   exec(@l_sql1)  
  
   if (select count(*) from ##report_org) =  (select count(*) from ##report)  
   begin   
  
   select org.dpam_sba_no , org.amount org_amount ,rpt.amount rpt_amount  from ##report rpt , ##report_org org  
   where org.dpam_sba_no =rpt.dpam_sba_no   
   and org.amount <> rpt.amount   
  
   end   
   else   
   begin   
  
   select org.dpam_sba_no , org.amount org_amount  , 0 rpt_amount   from ##report_org org  
   where org.dpam_sba_no not in (select rpt.dpam_sba_no from ##report rpt )  
  
  
   end   
  
   drop table ##report_org  
   drop table ##report  
     
  end   
  if @pa_case ='2'  
  begin  
    
  set @l_sql = 'select  ldg_voucher_no , ldg_voucher_type  , sum(ldg_amount) amount from ledger'+ convert(varchar(10),@pa_fin_id) + '    
       where ldg_deleted_ind =1   
       group by ldg_voucher_no , ldg_voucher_type   
       having sum(ldg_amount)<>0  
      '  
      exec(@l_sql )  
    
  end   
  if @pa_case ='3'  
  begin  
    
  set @l_sql = 'select sum(ldg_amount),ldg_voucher_no from ledger'+ convert(varchar(10),@pa_fin_id)  +' ,  (SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO,acct_type,group_id   
        FROM citrus_usr.fn_gl_acct_list('+  convert(varchar(25),@pa_dpm_id ) +'  ,1,0)    
        where case when acct_type = ''P'' then 16 else 0 end = case when acct_type = ''P'' then len(dpam_sba_no)else 0 end) account   
       where ldg_dpm_id = '+  convert(varchar(25),@pa_dpm_id ) +'   
       and ldg_account_id = account.dpam_id  and ldg_account_type = account.acct_type    
       and (ldg_voucher_dt between eff_from and eff_to)    
       and ldg_deleted_ind = 1   
       group by ldg_voucher_no  
       having sum(ldg_amount) <> 0  
  
             ' 
print  @l_sql
      exec(@l_sql )  
    
  end   
  if @pa_case ='4'  
  begin  
    
  set @l_sql = 'select dpam_sba_no,min(entr_from_dt),ldg_voucher_dt ,ldg_amount from ledger'+ convert(varchar(10),@pa_fin_id) +' , entity_relationship , dp_Acct_mstr 
where dpam_id = ldg_account_id and entr_sba= dpam_sba_no
and ldg_deleted_ind = ''1''
group by dpam_sba_no ,ldg_voucher_dt,ldg_amount 
having min(entr_from_dt) > ldg_voucher_dt  
             '  
      exec(@l_sql )  
    
  end   

 if @pa_case ='5'  
  begin  
    
  set @l_sql = 'select FINA_ACC_NAME,FINA_ACC_TYPE ,ldg_voucher_dt ,ldg_amount from ledger'
  + convert(varchar(10),@pa_fin_id) +' , FIN_ACCOUNT_MSTR 
where fina_acc_id = ldg_account_id 
and ldg_deleted_ind = ''1''
and  LDG_ACCOUNT_TYPE <> ''P''
and FINA_ACC_TYPE <> LDG_ACCOUNT_TYPE            '  
print  @l_sql
      exec(@l_sql )  
    
  end   




    
    
    
   
  
  
end

GO
