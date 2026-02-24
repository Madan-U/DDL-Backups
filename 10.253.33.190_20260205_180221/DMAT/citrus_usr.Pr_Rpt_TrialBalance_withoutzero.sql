-- Object: PROCEDURE citrus_usr.Pr_Rpt_TrialBalance_withoutzero
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select * from ledger1      
CREATE   Proc [citrus_usr].[Pr_Rpt_TrialBalance_withoutzero]      
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
 account_no varchar(100),      
 account_type varchar(2),    
 account_name varchar(200),    
 group_id int ,    
 voucher_date datetime,      
 amount [numeric](18, 4),      
 branch_id bigint ,
 voucher_no varchar(30)     
)  


--create Table #temptable1      
--(      
-- account_id bigint, 
-- account_no varchar(16),      
-- account_type varchar(2),    
-- account_name varchar(200),    
-- group_id int ,    
-- voucher_date datetime,      
-- amount [numeric](18, 4),      
-- branch_id bigint ,
-- voucher_no varchar(30)     
--)      
      
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(100),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME,acct_type varchar(2),group_id bigint)
 if (@pa_seltype = 'P')      
 begin           
    if @pa_dpmid <>'0'
   	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,'jan 01 1900','jan 01 2100','P',null 
	--FROM citrus_usr.fn_acct_list(@pa_dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) 
	FROM dp_acct_mstr 


	if @pa_dpmid ='0'
   	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,'jan 01 1900','jan 01 2100','P',null 
	FROM dp_acct_mstr --, entity_relationship where entr_sba = dpam_sba_no 
	--and  getdate() between ENTR_FROM_DT and isnull(ENTR_TO_DT ,'jan 01 2100')

 end
 else
 begin
	if @pa_dpmid <>'0'
	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,'jan 01 1900','jan 01 2100','P','0' 
	--FROM citrus_usr.fn_gl_acct_list(@pa_dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) 	
    FROM dp_acct_mstr 
	union 
	SELECT FINA_ACC_ID,FINA_ACC_CODE,FINA_ACC_NAME,'JAN 01 1900','JAN 01 2100',FINA_ACC_TYPE,FINA_GROUP_ID 
	FROM fin_account_mstr 


	if @pa_dpmid ='0'
   	INSERT INTO #ACLIST 
	SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,'jan 01 1900','jan 01 2100','P',null 
	FROM dp_acct_mstr --, entity_relationship where entr_sba = dpam_sba_no 
	--and  getdate() between ENTR_FROM_DT and isnull(ENTR_TO_DT ,'jan 01 2100')
	union 
	SELECT FINA_ACC_ID,FINA_ACC_CODE,FINA_ACC_NAME,'JAN 01 1900','JAN 01 2100',FINA_ACC_TYPE,FINA_GROUP_ID 
	FROM fin_account_mstr 

 end     



      
      
 set @@ssql = 'Insert into #temptable'       
 set @@ssql = @@ssql + ' select ldg_account_id,dpam_sba_no,ldg_account_type,dpam_sba_name ,group_id,ldg_voucher_dt,ldg_amount,ldg_branch_id,ldg_voucher_no'      
 set @@ssql = @@ssql + ' from citrus_usr.ledger' + convert(varchar,@pa_finyearid) + ',  #ACLIST account'      
 set @@ssql = @@ssql + ' where ldg_dpm_id = ' + case when convert(varchar,@pa_dpmid)        ='0' then ' ldg_dpm_id ' else convert(varchar,@pa_dpmid) end 
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
	set @@ssql = @@ssql + ' and ldg_account_type = ''P'' and ldg_amount <> ''0'' ' 
 end
 if @pa_seltype = 'G' and @pa_groupwise ='N'
 begin
	set @@ssql = @@ssql + ' and ldg_account_type <> ''P'''
 end

    
 print @@ssql    
      
 Exec(@@ssql)
/*bad depts*/

--IF @pa_finyearid = (SELECT TOP 1 FIN_ID FROM Financial_Yr_Mstr WHERE FIN_ID < (SELECT TOP 1 FIN_ID FROM  Financial_Yr_Mstr WHERE GETDATE() BETWEEN FIN_START_DT  AND FIN_END_DT ) ORDER BY FIN_ID DESC)
--BEGIN 
--Insert into #temptable 
--select dpam_id,[Demat Code],'P',dpam_sba_name ,group_id,@pa_FROMdate,sum(convert(numeric(18,3),[Party code])),0 ldg_branch_id,0 ldg_voucher_no
--from (select [Demat Code] , sum(convert(numeric(18,3),[Party code])) [Party code] from  BDOPBAL11052016
--group by  [Demat Code]) a  , #ACLIST 
--where [Demat Code] = DPAM_SBA_NO and acct_type ='P'
--group by dpam_id,[Demat Code], dpam_sba_name,group_id

--declare @l_amount_OB numeric(18,3)
--select @l_amount_OB = SUM([Party code]) from (select [Demat Code] 
--, sum(convert(numeric(18,3),[Party code])) [Party code] from  BDOPBAL11052016
--group by  [Demat Code]) a
-- WHERE   EXISTS (SELECT DPAM_SBA_NO FROM DP_aCCT_MSTR WHERE [Demat Code] = DPAM_SBA_NO) 
 
--Insert into #temptable 
--select dpam_id,dpam_sba_no,'G',dpam_sba_name ,group_id,@pa_FROMdate,@l_amount_OB*-1,0 ldg_branch_id,0 ldg_voucher_no
--from  #ACLIST 
--where acct_type ='G' and dpam_sba_no ='2000000009' --'5000000002'


--Insert into #temptable 
--select dpam_id,dpam_sba_no,'P',dpam_sba_name ,group_id,@pa_TOdate,sum(amount),0 ldg_branch_id,999999999 ldg_voucher_no
--from  bd11052016 , #ACLIST 
--where [Demat Code] = DPAM_SBA_NO 
--group by dpam_id,dpam_sba_no, dpam_sba_name,group_id

--declare @l_amount numeric(18,3)
--select @l_amount = SUM(isnull(amount,0)) from bd11052016 
 
 
--Insert into #temptable 
--select dpam_id,dpam_sba_no,'G',dpam_sba_name ,group_id,@pa_TOdate,@l_amount*-1,0 ldg_branch_id,999999999 ldg_voucher_no
--from  #ACLIST 
--where acct_type ='G' and dpam_sba_no ='5000000002'


--Insert into #temptable 
--select dpam_id,dpam_sba_no,'P',dpam_sba_name ,group_id,@pa_TOdate,sum(BAD_DEBTS)*-1,0 ldg_branch_id,999999999 ldg_voucher_no
--from  bdrecovery11052016 , #ACLIST 
--where [CLIENTCODE] = DPAM_SBA_NO 
--group by dpam_id,dpam_sba_no, dpam_sba_name,group_id

--declare @l_amount_rec numeric(18,3)
--select @l_amount_rec = 
-- SUM(isnull(BAD_DEBTS,0))  from (select [CLIENTCODE]
--, sum(convert(numeric(18,3),BAD_DEBTS)) BAD_DEBTS from  bdrecovery11052016
--group by  [CLIENTCODE]) a
-- WHERE   EXISTS (SELECT DPAM_SBA_NO FROM DP_aCCT_MSTR WHERE [CLIENTCODE] = DPAM_SBA_NO) 

 
 
--Insert into #temptable 
--select dpam_id,dpam_sba_no,'G',dpam_sba_name ,group_id,@pa_TOdate,@l_amount_rec,0 ldg_branch_id,999999999 ldg_voucher_no
--from  #ACLIST 
--where acct_type ='G' and dpam_sba_no ='4000000013'




--/*bad depts*/
-- END 
 
 --select SUM(AMOUNT) from #temptable1 WHERE account_type ='g'
 --select SUM(AMOUNT) from #temptable1 WHERE account_type ='p'
 --return 
 
 
 --select * from #temptable where account_no ='1203320008830193'
 --update a   set a.amount = a.amount + bd.Amount from  bd11052016 bd, #temptable a where [Demat Code] = account_no and  account_no ='1203320008830193'
 --update a   set a.amount = a.amount + bd.amt from  (select sum(Amount) amt from bd11052016 ) bd
 --, #temptable a where account_type ='G' and account_no =''
 
  
 if @pa_tbtype = 'O'      
 begin      
  if ltrim(Rtrim(@pa_groupwise))  = 'N'       
  begin       
      
      
   select tmpview.*,      
--   ClosingDebit= case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end,      
--   ClosingCredit=case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end      
	ClosingDebit= case when (case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end) - (case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end ) >= 0 then (case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end) - (case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end ) else 0 end,      
   ClosingCredit=case when (case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end) - (case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end ) < 0 then (case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end) - (case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end ) else 0 end
   from (      
   select account_id=isnull(t.account_no,''),t.account_type,account_name=t.account_name + ' - ' + isnull(t.account_no,''),    
--   OpeningDebit = Sum(case when Amount <= 0 and voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount) else 0 end),      
--   OpeningCredit = Sum(case when Amount > 0 and voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount) else 0 end),      
	 OpeningDebit = Sum(case when Amount <= 0 and  voucher_no <> '0' and voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount)
						when Amount <= 0 and  voucher_no = '0' and voucher_date <= @pa_fromdate + ' 00:00:00' then Abs(Amount)
						 else 0 end),      
   OpeningCredit = Sum(case when Amount > 0 and voucher_no <> '0' and  voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount)
							when Amount > 0 and voucher_no = '0' and  voucher_date <= @pa_fromdate + ' 00:00:00' then Abs(Amount)
							 else 0 end),      
   CurrentDebit =  Sum(case when Amount <= 0 and voucher_no  <> '0' and voucher_date >= @pa_fromdate + ' 00:00:00' and voucher_date < @pa_todate + ' 23:59:59' then Abs(Amount) else 0 end),      
   CurrentCredit =  Sum(case when Amount > 0 and voucher_no  <> '0' and voucher_date >= @pa_fromdate + ' 00:00:00' and voucher_date < @pa_todate + ' 23:59:59' then Abs(Amount) else 0 end)      
  
   from #temptable t      
   group by t.account_id,t.account_type ,t.account_name,t.account_no     
       
   ) tmpview    
   order by tmpview.account_id      
  end       
  else if ltrim(Rtrim(@pa_groupwise)) = 'Y'     and    @pa_seltype <> 'G'
  begin 
     
   select tmpview.*, 
	--ClosingDebit= case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end,      
   --ClosingCredit=case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end           
   ClosingDebit= case when (case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end) - (case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end ) >= 0 then (case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end) - (case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end ) else 0 end,      
   ClosingCredit=case when (case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end) - (case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end ) < 0 then (case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end) - (case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end ) else 0 end,
   group_name = case when account_type ='P' and  (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then 'SUNDRY DEBITORS' when account_type ='P' then 'SUNDRY CREDITORS' else b.fingm_group_name end      
   from (      
   select account_id=isnull(t.account_no,''),t.account_type, account_name=t.account_name + ' - ' + isnull(t.account_no,''),    
--   OpeningDebit = Sum(case when Amount <= 0 and voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount) else 0 end),      
--  OpeningCredit = Sum(case when Amount > 0 and voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount) else 0 end),      
 OpeningDebit = Sum(case when Amount <= 0 and  voucher_no <> '0' and voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount)
						when Amount <= 0 and  voucher_no = '0' and voucher_date <= @pa_fromdate + ' 00:00:00' then Abs(Amount)
						 else 0 end),      
   OpeningCredit = Sum(case when Amount > 0 and voucher_no <> '0' and  voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount)
							when Amount > 0 and voucher_no = '0' and  voucher_date <= @pa_fromdate + ' 00:00:00' then Abs(Amount)
							 else 0 end),      
   CurrentDebit =  Sum(case when Amount <= 0 and voucher_no  <> '0' and voucher_date >= @pa_fromdate + ' 00:00:00' and voucher_date < @pa_todate + ' 23:59:59' then Abs(Amount) else 0 end),      
   CurrentCredit =  Sum(case when Amount > 0 and voucher_no  <> '0' and voucher_date >= @pa_fromdate + ' 00:00:00' and voucher_date < @pa_todate + ' 23:59:59' then Abs(Amount) else 0 end) ,     
  
   group_id    
   from #temptable t       
   group by t.account_id,t.account_type ,t.account_name,t.group_id,t.account_no     
   ) tmpview left outer join FIN_GROUP_MSTR b on tmpview.group_id  = b.fingm_group_code      
   order by b.fingm_group_name,tmpview.account_id
  end 
  else if ltrim(Rtrim(@pa_groupwise)) = 'Y'     and    @pa_seltype = 'G'
  begin 
     
     
     
   select tmpview.*, 
	--ClosingDebit= case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end,      
   --ClosingCredit=case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end           
   ClosingDebit= case when (case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end) - (case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end ) >= 0 then (case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end) - (case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end ) else 0 end,      
   ClosingCredit=case when (case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end) - (case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end ) < 0 then (case when (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then  (OpeningDebit+CurrentDebit) - (OpeningCredit+CurrentCredit) else 0 end) - (case when (OpeningDebit+CurrentDebit) <= (OpeningCredit+CurrentCredit) then (OpeningCredit+CurrentCredit) - (OpeningDebit+CurrentDebit) else 0 end ) else 0 end,
   group_name = case when account_type ='P' and  (OpeningDebit+CurrentDebit) > (OpeningCredit+CurrentCredit) then 'SUNDRY DEBITORS' when account_type ='P' then 'SUNDRY CREDITORS' else b.fingm_group_name end      
   from (      
   select account_id=case when account_type ='P' then '0' else isnull(t.account_no,'') end ,t.account_type
   , account_name= case when account_type ='P' then '0' else t.account_name + ' - ' + isnull(t.account_no,'') end  ,    
--   OpeningDebit = Sum(case when Amount <= 0 and voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount) else 0 end),      
--  OpeningCredit = Sum(case when Amount > 0 and voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount) else 0 end),      
 OpeningDebit = Sum(case when Amount <= 0 and  voucher_no <> '0' and voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount)
						when Amount <= 0 and  voucher_no = '0' and voucher_date <= @pa_fromdate + ' 00:00:00' then Abs(Amount)
						 else 0 end),      
   OpeningCredit = Sum(case when Amount > 0 and voucher_no <> '0' and  voucher_date < @pa_fromdate + ' 00:00:00' then Abs(Amount)
							when Amount > 0 and voucher_no = '0' and  voucher_date <= @pa_fromdate + ' 00:00:00' then Abs(Amount)
							 else 0 end),      
   CurrentDebit =  Sum(case when Amount <= 0 and voucher_no  <> '0' and voucher_date >= @pa_fromdate + ' 00:00:00' and voucher_date < @pa_todate + ' 23:59:59' then Abs(Amount) else 0 end),      
   CurrentCredit =  Sum(case when Amount > 0 and voucher_no  <> '0' and voucher_date >= @pa_fromdate + ' 00:00:00' and voucher_date < @pa_todate + ' 23:59:59' then Abs(Amount) else 0 end) ,     
  
   group_id    
   from #temptable t       
   group by case when account_type ='P' then '0' else isnull(t.account_no,'') end ,t.account_type , case when account_type ='P' then '0' else t.account_name + ' - ' + isnull(t.account_no,'') end,t.group_id    
   ) tmpview left outer join FIN_GROUP_MSTR b on tmpview.group_id  = b.fingm_group_code      
      order by b.fingm_group_name,tmpview.account_id
  end      
 end      
 else      
 begin -- if 'N'      
    print 'yogeshn'  
  if ltrim(Rtrim(@pa_groupwise))  = 'N'       
  begin   
    
   select account_id=isnull(t.account_no ,0),t.account_type,      
   Debit = case when Sum(Amount) <=0 then Abs(Sum(Amount)) else 0 end,      
   Credit = case when Sum(Amount) >0 then Abs(Sum(Amount)) else 0 end,      
   t.account_name     
   from #temptable t    
   group by t.account_id,t.account_type,t.account_name,t.account_no    
   having Sum(Amount) <> 0   
   order by left(t.account_no  ,8),t.account_no
    
         
  end       
  else if ltrim(Rtrim(@pa_groupwise)) = 'Y'     and @pa_seltype <>'G'   
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
   order by group_name,left(account_id ,8),account_id
      
  end      
  else if ltrim(Rtrim(@pa_groupwise)) = 'Y'     and @pa_seltype ='G'   
  begin       
--select * from #temptable

   select * from (   
   select account_id=case when t.account_type ='P' then '0' else isnull(t.account_no ,0) end ,t.account_type,      
   Debit = case when Sum(Amount) <=0 then Abs(Sum(Amount)) else 0 end,      
   Credit = case when Sum(Amount) >0 then Abs(Sum(Amount)) else 0 end,      
   case when t.account_type ='P' then '0' else isnull(t.account_name ,'') end account_name  ,    
   group_name = case when account_type ='P' and  Sum(Amount) <=0 then 'SUNDRY DEBITORS' when account_type ='P' then 'SUNDRY CREDITORS' 
				else b.fingm_group_name end      
   from #temptable t     
   left outer join FIN_GROUP_MSTR b on t.group_id  = b.fingm_group_code      
   group by case when t.account_type ='P' then '0' else isnull(t.account_no ,0) end ,t.account_type,b.fingm_group_name,case when t.account_type ='P'
    then '0' else isnull(t.account_name ,'') end
   ) tmpview     
   order by group_name,left(account_id ,8),account_id
      
  end 
 end       
end

GO
