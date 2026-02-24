-- Object: PROCEDURE citrus_usr.Pr_CalculateInterest
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--Pr_CalculateInterest 'CDSL',203412,1, 'jul 10 2008',0
CREATE Proc [citrus_usr].[Pr_CalculateInterest]
@pa_dp_type varchar(4),
@pa_dpmid bigint,
@pa_finyearid int,
@pa_tillnextbill_dt datetime,
@pa_posttoAcct bigint
as
begin

declare @@ssql varchar(8000),
@pa_fromdue_dt datetime,
@pa_post_dt datetime

select @pa_fromdue_dt = DATEADD(d,1,max(billc_due_date)),@pa_post_dt=max(billc_posting_dt) from bill_cycle where billc_dpm_id = @pa_dpmid and billc_to_dt <= @pa_tillnextbill_dt


if (isnull(@pa_fromdue_dt,'') = '' or not exists(select cham_slab_no from charge_mstr where cham_charge_type = 'CDSL_INTEREST'))
begin
	select null,null,null,null,null where 1 <> 1
	return
end 


--(drbal%interest_rate/100)/365*noofdays 
create table #runningbal(running_id  bigint,dpam_id bigint,Vch_dt datetime,Dr_Amount numeric(19,4),Dt_diff_days int,Int_charges numeric(18,4),post_to_accct bigint)
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
 set @@ssql = @@ssql + ' where ldg_dpm_id = ' + convert(varchar,@pa_dpmid) + '  and ldg_voucher_dt >= ''' + convert(varchar(11),@pa_fromdue_dt,109) + ''' and ldg_voucher_dt <= ''' + convert(varchar(11),@pa_tillnextbill_dt,109) + ' 23:59:59'''        
 set @@ssql = @@ssql + ' and ldg_voucher_type <> ''5'' and ISNULL(ldg_trans_type,'''') <> ''O'''        
 set @@ssql = @@ssql + ' and ldg_account_type = ''P'' and ldg_deleted_ind = 1' 
 set @@ssql = @@ssql + ' group by ldg_account_id,ldg_voucher_dt'                       
 Exec(@@ssql)    
       

 set @@ssql = 'Insert into #temptable(account_id,voucher_date,amount)'         
 set @@ssql = @@ssql + ' select ldg_account_id,voucher_dt=''' + Convert(varchar(11),@pa_fromdue_dt,109) + ''',isnull(sum(ldg_amount),0)'     
 set @@ssql = @@ssql + ' from ledger' + convert(varchar,@pa_finyearid)        
 set @@ssql = @@ssql + ' where ldg_dpm_id = ' + convert(varchar,@pa_dpmid) + '  and ldg_voucher_dt = ''' + convert(varchar(11),@pa_post_dt,109) + ''''        
 set @@ssql = @@ssql + ' and ldg_voucher_type = ''5'' and ISNULL(ldg_trans_type,'''') <> ''O'''        
 set @@ssql = @@ssql + ' and ldg_account_type = ''P'' and ldg_deleted_ind = 1' 
 set @@ssql = @@ssql + ' group by ldg_account_id,ldg_voucher_dt'                       
 Exec(@@ssql)    


select identity(bigint,1,1) as Runningid , * into #templedger from #temptable
--where  amount <> 0       
where voucher_date <= @pa_tillnextbill_dt
order by account_id,Voucher_date      
 


insert into #runningbal(running_id,dpam_id,Vch_dt,Dr_Amount)
select Runningid,account_id,voucher_date,        
RunningAmt=(select sum(isnull(amount,0)) from #templedger t1 where t1.Runningid <= t.Runningid and t1.account_id=t.account_id)
from #templedger t         
order by Runningid,voucher_date

update r set Dt_diff_days = datediff(d,isnull((select min(Vch_dt) from #runningbal r1 where r1.running_id > r.running_id and r.dpam_id = r1.dpam_id),@pa_tillnextbill_dt),Vch_dt)
from #runningbal r


if @pa_dp_type = 'CDSL'
begin
		update #runningbal SET Int_charges = ((Abs(Dr_Amount)*(cham_charge_value/100))/365)*Abs(Dt_diff_days)
		,post_to_accct = isnull(CHAM_POST_TOACCT,@pa_posttoAcct)
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
		,post_to_accct = isnull(CHAM_POST_TOACCT,@pa_posttoAcct)
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
select trans_dt=@pa_tillnextbill_dt,dpam_id,'Interest Charges',Charges=Round(sum(Int_charges),2)*-1,post_to_accct
from #runningbal
group by dpam_id,post_to_accct
having sum(Int_charges) > 0

truncate table #runningbal
truncate table #templedger
truncate table #temptable
drop table #runningbal
drop table #templedger
drop table #temptable

end

GO
