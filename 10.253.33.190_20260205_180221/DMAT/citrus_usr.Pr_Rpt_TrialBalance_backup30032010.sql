-- Object: PROCEDURE citrus_usr.Pr_Rpt_TrialBalance_backup30032010
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select * from ledger1      
Create Proc [citrus_usr].[Pr_Rpt_TrialBalance_backup30032010]      
@pa_dpmid int,      
@pa_finyearid int,      
@pa_fromdate datetime,      
@pa_todate datetime,      
@pa_tbtype char(1),      
@pa_groupwise char(1),      
@pa_seltype char(1), -- P for party, G for GL else B
@pa_login_pr_entm_id numeric,    
@pa_login_entm_cd_chain  varchar(8000),    
@pa_output varchar(8000) output    
As      
begin      
set nocount on      
     
declare @@ssql varchar(8000)      
declare @@l_child_entm_id      numeric    
    
select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)    
    
    
create Table #temptable      
(      
 account_id bigint, 
 account_no varchar(16),      
 account_type varchar(2),    
 account_name varchar(200),    
 group_id int ,    
 voucher_date datetime,      
 amount [numeric](18, 2),      
 branch_id bigint      
)      
      
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME,acct_type varchar(2),group_id bigint)
 if (@pa_seltype = 'P')      
 begin           

   	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO,'P',null FROM citrus_usr.fn_acct_list(@pa_dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) 
 end
 else
 begin
	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO,acct_type,group_id FROM citrus_usr.fn_gl_acct_list(@pa_dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) 	
 end       
      
      
 set @@ssql = 'Insert into #temptable'       
 set @@ssql = @@ssql + ' select ldg_account_id,dpam_sba_no,ldg_account_type,dpam_sba_name ,group_id,ldg_voucher_dt,ldg_amount,ldg_branch_id'      
 set @@ssql = @@ssql + ' from ledger' + convert(varchar,@pa_finyearid) + ',  #ACLIST account'      
 set @@ssql = @@ssql + ' where ldg_dpm_id = ' + convert(varchar,@pa_dpmid)        
 if @pa_tbtype = 'N'      
 begin      
  set @@ssql = @@ssql + ' and ldg_voucher_dt >= ''' + convert(varchar(11),@pa_fromdate,109) + ''''      
 end   
 set @@ssql = @@ssql + ' and ldg_voucher_dt <= ''' + convert(varchar(11),@pa_todate,109) + ' 23:59:59'''      
 set @@ssql = @@ssql + ' and ldg_account_id = account.dpam_id '      
 set @@ssql = @@ssql + ' and ldg_account_type = account.acct_type '      
 set @@ssql = @@ssql + ' and (ldg_voucher_dt between eff_from and eff_to) '      
 set @@ssql = @@ssql + ' and ldg_deleted_ind = 1 '  
 if @pa_seltype = 'P'
 begin
	set @@ssql = @@ssql + ' and ldg_account_type = ''P'''
 end
 if @pa_seltype = 'G'
 begin
	set @@ssql = @@ssql + ' and ldg_account_type <> ''P'''
 end
 
    
 print @@ssql    
      
 Exec(@@ssql)      
      
 if @pa_tbtype = 'O'      
 begin      
  if ltrim(Rtrim(@pa_groupwise))  = 'N'       
  begin       
      
      
   select tmpview.*,      
   ClosingDebit= case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end,      
   ClosingCredit=case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end      
   from (      
   select account_id=isnull(t.account_no,''),t.account_type,account_name=t.account_name + ' - ' + isnull(t.account_no,''),    
   OpeningDebit = Sum(case when Amount <= 0 and voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount) else 0 end),      
   OpeningCredit = Sum(case when Amount > 0 and voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount) else 0 end),      
   CurrentDebit =  Sum(case when Amount <= 0 and voucher_date >= @pa_fromdate + ' 00:00:00' and voucher_date < @pa_todate + ' 23:59:59' then Abs(Amount) else 0 end),      
   CurrentCredit =  Sum(case when Amount > 0 and voucher_date >= @pa_fromdate + ' 00:00:00' and voucher_date < @pa_todate + ' 23:59:59' then Abs(Amount) else 0 end)      
   from #temptable t      
   group by t.account_id,t.account_type ,t.account_name,t.account_no     
       
   ) tmpview    
   order by tmpview.account_id      
  end       
  else if ltrim(Rtrim(@pa_groupwise)) = 'Y'       
  begin 
     
   select tmpview.*,      
   ClosingDebit= case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end,      
   ClosingCredit=case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end      
   ,group_name = case when account_type ='P' and  (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then 'SUNDRY DEBITORS' when account_type ='P' then 'SUNDRY CREDITORS' else b.fingm_group_name end      
   from (      
   select account_id=isnull(t.account_no,''),t.account_type, account_name=t.account_name + ' - ' + isnull(t.account_no,''),    
   OpeningDebit = Sum(case when Amount <= 0 and voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount) else 0 end),      
  OpeningCredit = Sum(case when Amount > 0 and voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount) else 0 end),      
   CurrentDebit =  Sum(case when Amount <= 0 and voucher_date >= @pa_fromdate + ' 00:00:00' and voucher_date < @pa_todate + ' 23:59:59' then Abs(Amount) else 0 end),      
   CurrentCredit =  Sum(case when Amount > 0 and voucher_date >= @pa_fromdate + ' 00:00:00' and voucher_date < @pa_todate + ' 23:59:59' then Abs(Amount) else 0 end) ,    
   group_id    
   from #temptable t       
   group by t.account_id,t.account_type ,t.account_name,t.group_id,t.account_no     
   ) tmpview left outer join FIN_GROUP_MSTR b on tmpview.group_id  = b.fingm_group_code      
   order by b.fingm_group_name,tmpview.account_id
  end      
 end      
 else      
 begin -- if 'N'      
      
  if ltrim(Rtrim(@pa_groupwise))  = 'N'       
  begin       
   select account_id=isnull(t.account_no ,0),t.account_type,      
   Debit = case when Sum(Amount) <=0 then Abs(Sum(Amount)) else 0 end,      
   Credit = case when Sum(Amount) >0 then Abs(Sum(Amount)) else 0 end,      
   t.account_name     
   from #temptable t    
   group by t.account_id,t.account_type,t.account_name,t.account_no     
   order by t.account_id  
         
  end       
  else if ltrim(Rtrim(@pa_groupwise)) = 'Y'       
  begin       


   select * from (   
   select account_id=isnull(t.account_no ,0),t.account_type,      
   Debit = case when Sum(Amount) <=0 then Abs(Sum(Amount)) else 0 end,      
   Credit = case when Sum(Amount) >0 then Abs(Sum(Amount)) else 0 end,      
   t.account_name,    
   group_name = case when account_type ='P' and  Sum(Amount) <=0 then 'SUNDRY DEBITORS' when account_type ='P' then 'SUNDRY CREDITORS' else b.fingm_group_name end      
   from #temptable t     
   left outer join FIN_GROUP_MSTR b on t.group_id  = b.fingm_group_code      
   group by t.account_id,t.account_type,b.fingm_group_name,t.account_name,t.account_no
   ) tmpview     
   order by group_name,account_id 
      
  end      
 end       
end

GO
