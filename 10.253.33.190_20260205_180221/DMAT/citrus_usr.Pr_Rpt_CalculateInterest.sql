-- Object: PROCEDURE citrus_usr.Pr_Rpt_CalculateInterest
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--[Pr_Rpt_CalculateInterest] 'CDSL',3,'jul 10 2008','dec 10 2008'

CREATE Proc [citrus_usr].[Pr_Rpt_CalculateInterest]
@pa_dp_type varchar(4),
@pa_dpmid bigint,
@from_dt datetime,  
@till_dt datetime  
as
begin

declare @@ssql varchar(8000),
@pa_fromdue_dt datetime,
@pa_post_dt datetime,
@pa_finyearid int

select @pa_finyearid = fin_id from financial_yr_mstr where @from_dt between FIN_START_DT and fin_end_dt and fin_deleted_ind = 1

set @pa_fromdue_dt = @from_dt
set @pa_post_dt = @from_dt
select @pa_fromdue_dt = isnull(dateadd(d,1,max(billc_due_date)),@from_dt),@pa_post_dt=isnull(max(billc_posting_dt),@from_dt) from bill_cycle where billc_dpm_id = @pa_dpmid and billc_to_dt <= @from_dt



--(drbal%interest_rate/100)/365*noofdays 
create table #runningbal(running_id  bigint,dpam_id bigint,Vch_dt datetime,Dr_Amount numeric(19,4),Dt_diff_days int,Int_charges numeric(18,4))
create Table #temptable(account_id bigint,voucher_date datetime,amount numeric(19,4))       

  --FOR OPENING RECORDS        
 -- voucher_type = 0 -- opening        
 set @@ssql = 'insert into #temptable(account_id,voucher_date,amount) '        
 set @@ssql = @@ssql + ' select ldg_account_id,voucher_date= Dateadd(day,-1,cast(''' + convert(varchar(11),@pa_fromdue_dt,109) + ''' as datetime)),'        
 set @@ssql = @@ssql + ' amount=Abs(Sum(ldg_amount))'        
 set @@ssql = @@ssql + ' from ledger' + convert(varchar,@pa_finyearid)         
 set @@ssql = @@ssql + ' where ldg_dpm_id = ' + convert(varchar,@pa_dpmid) + '  and ldg_voucher_dt < ''' + convert(varchar(11),@pa_fromdue_dt,109) + ' 00:00:00'''        
 set @@ssql = @@ssql + ' and ldg_account_type = ''P'' and ldg_deleted_ind = 1 and (ldg_voucher_type <> ''5'' or ldg_voucher_dt <> ''' + convert(varchar(11),@pa_post_dt,109) + ''') '      
 set @@ssql = @@ssql + ' group by ldg_account_id'        
 Exec(@@ssql)        
 --FOR OPENING RECORDS 



        
--convert(datetime,right(ltrim(rtrim(ldg_narration)),11),109)        
 set @@ssql = 'Insert into #temptable(account_id,voucher_date,amount)'         
 set @@ssql = @@ssql + ' select ldg_account_id,voucher_dt=ldg_voucher_dt,isnull(sum(ldg_amount),0)'     
 set @@ssql = @@ssql + ' from ledger' + convert(varchar,@pa_finyearid)        
 set @@ssql = @@ssql + ' where ldg_dpm_id = ' + convert(varchar,@pa_dpmid) + '  and ldg_voucher_dt >= ''' + convert(varchar(11),@pa_fromdue_dt,109) + ''' and ldg_voucher_dt <= ''' + convert(varchar(11),@till_dt,109) + ' 23:59:59'''        
 set @@ssql = @@ssql + ' and ldg_voucher_type <> ''5'' and ISNULL(ldg_trans_type,'''') <> ''O'''        
 set @@ssql = @@ssql + ' and ldg_account_type = ''P'' and ldg_deleted_ind = 1' 
 set @@ssql = @@ssql + ' group by ldg_account_id,ldg_voucher_dt'                       
 Exec(@@ssql)    
       
 set @@ssql = 'Insert into #temptable(account_id,voucher_date,amount)'         
 set @@ssql = @@ssql + ' select ldg_account_id,voucher_dt=billc_due_date,isnull(sum(ldg_amount),0)'     
 set @@ssql = @@ssql + ' from ledger' + convert(varchar,@pa_finyearid) + ',bill_cycle '        
 set @@ssql = @@ssql + ' where ldg_dpm_id = ' + convert(varchar,@pa_dpmid) + '  and ldg_voucher_dt = billc_posting_dt and ldg_dpm_id = billc_dpm_id and ldg_voucher_dt >= ''' + convert(varchar(11),@pa_post_dt,109) + ''' and ldg_voucher_dt <= ''' + convert(varchar(11),@till_dt,109) + ' 23:59:59'''        
 set @@ssql = @@ssql + ' and ldg_voucher_type = ''5'' and ISNULL(ldg_trans_type,'''') <> ''O'''        
 set @@ssql = @@ssql + ' and ldg_account_type = ''P'' and ldg_deleted_ind = 1' 
 set @@ssql = @@ssql + ' group by ldg_account_id,ldg_voucher_dt,billc_due_date'                       
 Exec(@@ssql)    



select identity(bigint,1,1) as Runningid , * into #templedger from #temptable
--where  amount <> 0       
where voucher_date <= @till_dt
order by account_id,Voucher_date      
 

insert into #runningbal(running_id,dpam_id,Vch_dt,Dr_Amount)
select Runningid,account_id,voucher_date,        
RunningAmt=(select sum(isnull(amount,0)) from #templedger t1 where t1.Runningid <= t.Runningid and t1.account_id=t.account_id)
from #templedger t         
order by Runningid,voucher_date




update r set Dt_diff_days = datediff(d,isnull((select min(Vch_dt) from #runningbal r1 where r1.running_id > r.running_id and r.dpam_id = r1.dpam_id),@till_dt),Vch_dt)
from #runningbal r


if @pa_dp_type = 'CDSL'
begin
		update #runningbal SET Int_charges = ((Abs(Dr_Amount)*(cham_charge_value/100))/365)*Abs(Dt_diff_days)
		from #runningbal      
		,client_dp_brkg
		,profile_charges
		,charge_mstr 
		where Vch_dt >= clidb_eff_from_dt and  Vch_dt <= clidb_eff_to_dt
		AND   dpam_id = clidb_dpam_id 
		AND   clidb_brom_id = proc_profile_id
		AND   proc_slab_no  = cham_slab_no
		AND   isnull(cham_charge_graded,0) <> 1
		AND   cham_charge_baseon           = 'TQ' 
		AND   cham_charge_type = 'CDSL_INTEREST'
		AND   (abs(Dr_Amount) >= cham_from_factor)  and (abs(Dr_Amount) <= cham_to_factor)
		and   Dr_Amount < 0
		and   cham_deleted_ind = 1
		and   clidb_deleted_ind = 1
		and   proc_deleted_ind = 1
end
else
begin
		update #runningbal SET Int_charges = ((Abs(Dr_Amount)*(cham_charge_value/100))/365)*Abs(Dt_diff_days)
		from #runningbal      
		,client_dp_brkg
		,profile_charges
		,charge_mstr 
		where Vch_dt >= clidb_eff_from_dt and  Vch_dt <= clidb_eff_to_dt
		AND   dpam_id = clidb_dpam_id 
		AND   clidb_brom_id = proc_profile_id
		AND   proc_slab_no  = cham_slab_no
		AND   isnull(cham_charge_graded,0) <> 1
		AND   cham_charge_baseon           = 'TQ' 
		AND   cham_charge_type = 'NSDL_INTEREST'
		AND   (abs(Dr_Amount) >= cham_from_factor)  and (abs(Dr_Amount) <= cham_to_factor)  
		and   Dr_Amount < 0
		and   cham_deleted_ind = 1
		and   clidb_deleted_ind = 1
		and   proc_deleted_ind = 1
end

--drbal%interest_rate/100)/365*noofdays 
select trans_dt=Vch_dt,r.dpam_id,dpam_sba_name,dpam_sba_no,Status_descp=stam_desc,No_of_Days=isnull(Abs(Dt_diff_days),0),Dr_Amount,Charges=Round(isnull(Int_charges,0.00),2)
from #runningbal r,dp_acct_mstr d,status_mstr
where r.dpam_id = d.dpam_id 
and d.dpam_stam_cd = stam_cd
and Dr_Amount < 0
order by dpam_sba_name,dpam_sba_no,running_id


truncate table #runningbal
truncate table #templedger
truncate table #temptable
drop table #runningbal
drop table #templedger
drop table #temptable

end

GO
