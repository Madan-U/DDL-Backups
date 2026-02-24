-- Object: PROCEDURE citrus_usr.pr_rpt_ageing_bak_07042015
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--[PR_RPT_AGEING] 4,'Aug 30 2010',''   
create proc [citrus_usr].[pr_rpt_ageing_bak_07042015]  
(  
 @pa_fin_id numeric,  
    @pa_frmdt datetime,  
 @pa_out varchar(1000) output  
)  
as  
begin  
  
declare @l_sql varchar(8000),  
  @l_sql1 varchar(8000),  
        @l_enddt datetime  
  
--set @l_sql1 = ''  
--set @l_sql  = 'select *  INTO [ledger' + convert(varchar(10),@pa_fin_id) + '_bak'+convert(vaRCHAR(20),GETDATE(),109)+'] FROM LEDGER' + convert(varchar(10),@pa_fin_id)  
--  
--PRINT @L_SQL   
--EXEC(@L_SQL)  
--  
select @l_enddt = FIN_END_DT from financial_yr_mstr where FIN_ID = @pa_fin_id  
--set @l_sql1 = 'if exists(select name from sysobjects where name = ''#tushar1'') drop table #tushar1 '  
create table #tushar1  
(  
 id bigint identity(1,1),  
 ldg_account_id varchar(20),  
 ldg_voucher_dt  datetime,  
 ldg_amount numeric(18,3),  
 totalcredit numeric(18,3),  
 balance  numeric(18,3)  
   
)  
set @l_sql1 = ''
set @l_sql1 = @l_sql1 + ' insert into #tushar1  
      select   
       ldg_account_id   
     , ldg_voucher_dt   
     , sum(ldg_amount ) ldg_amount  
     , isnull((select sum(ldg_amount) from ledger' + convert(varchar(10),@pa_fin_id) +'  b   
         where b.ldg_account_id = a.ldg_account_id   
         and b.ldg_amount > 0  
         and b.ldg_account_type = ''P''  and ldg_deleted_ind = 1    
        ),0) totalcredit   
     ,convert(numeric(18,2),0)  balance   
       
    from ledger' + convert(varchar(10),@pa_fin_id) +'  a   
    where ldg_amount < 0 and ldg_deleted_ind = 1   
    and ldg_account_type = ''P''  
    group by ldg_account_id,ldg_voucher_dt  
    order by ldg_account_id,ldg_voucher_dt'  
  
print @l_sql1  
EXEC(@L_SQL1)  
--select * from #tushar1  
  
update #tushar1 set balance = totalcredit  
  
update a set a.balance =  a.balance + (select sum(b.ldg_amount)   
                                      from #tushar1 b   
                                      where b.ldg_voucher_dt <= a.ldg_voucher_dt   
                                      and   b.ldg_account_id  = a.ldg_account_id)    
from #tushar1 a  
  
  
  
  
select *, convert(numeric(18,2),'0') adjustmentamt into #temp123456 from #tushar1  
  
  
  
  
update a set adjustmentamt =   
case when (select top 1 balance from #tushar1 c   
           where c.ldg_voucher_dt < a.ldg_voucher_dt   
           and   c.ldg_account_id  = a.ldg_account_id order by c.ldg_voucher_dt desc) < 0.00 then ldg_amount  
end   
from #temp123456 a  
  
  
update a set a.balance = adjustmentamt  
from #tushar1 a , #temp123456 b  
where a.id = b.id   
and adjustmentamt <> 0  
  
--SELECT * FROM #tushar1  
  
  
  
  
set dateformat dmy   
  
select distinct accp_value accp_value, accp_clisba_id , accp_accpm_prop_cd   
into #account_properties   
from account_properties where accp_accpm_prop_cd = 'BILL_START_DT'   
and    ltrim(rtrim(accp_value)) not  in ('/  /',  '/  /','')  
  
select clicm_desc type   
, dpam_sba_no [client id]  
, dpam_sba_name [name]   
, ldg_account_id   
, ldg_voucher_dt   
, sum(BALANCE) amount   
--, datediff(dd,ldg_voucher_dt,@l_enddt) datediffe , accp_value [activation dt]@pa_frmdt  
, datediff(dd,ldg_voucher_dt,@pa_frmdt) datediffe , accp_value [activation dt]  
into #temp from #tushar1 a   
,dp_acct_mstr   
,client_ctgry_mstr,#account_properties   
where ldg_account_id = dpam_id and dpam_clicm_cd = clicm_cd and accp_clisba_id = dpam_id   
  
--and ldg_voucher_dt>=(select top 1 ldg_voucher_dt   
--                     from ledger2 b   
--                     where b.ldg_account_id = a.ldg_account_id   
--                     and b.ldg_deleted_ind = 1 and b.ldg_account_type = 'p'  
--                     and ldg_amount > 0   
--                     order by ldg_voucher_dt desc)  
group by ldg_account_id,ldg_voucher_dt,clicm_desc,dpam_sba_no,dpam_sba_name,accp_value  
having sum(BALANCE)<0  
  
--select * from #temp  
  
create table #Data(type  varchar(50)  
,[client id] varchar(16)  
,name varchar(100)  
,amount numeric(18,3)  
,datediffe numeric,[activation dt] datetime  
,diff8days numeric(18,3)  
,diff15days numeric(18,3)  
,diff30days numeric(18,3)  
,diff45days numeric(18,3)  
,diff90days numeric(18,3)  ,diff180days numeric(18,3)  
,diff365days numeric(18,3)  
)   
  
insert into #Data(type  ,[client id] ,name ,amount ,datediffe,[activation dt])  
select type,[client id],name,amount, datediffe , [activation dt] from #temp  
  
  
--select * from #Data  
  
--begin tran  
  
update #Data  
set diff8days = case when datediffe between 0 and 8 then amount else 0 end   
,diff15days = case when datediffe between 9 and 15 then amount else 0 end   
,diff30days = case when datediffe between 16 and 30 then amount else 0 end   
,diff45days = case when datediffe between 31 and 45 then amount else 0 end   
,diff90days  = case when datediffe between 46 and 90 then amount else 0 end   
,diff180days  = case when datediffe between 91 and 180 then amount else 0 end   
,diff365days  = case when datediffe between 181 and 365 then amount else 0 end   
  
  
--commit  
  
--select * from #Data  
  
select identity(bigint,1,1) srno , type,[client id],name  
,sum(diff8days) diff8days  
,sum(diff15days) diff15days,sum(diff30days) diff30days,sum(diff45days) diff45days,sum(diff90days) diff90days  
,sum(diff180days) diff180days  
,sum(diff365days) diff365days  
,sum(diff8days)+sum(diff15days)+sum(diff30days)+sum(diff45days)+sum(diff90days)+sum(diff180days)+sum(diff365days) [total debit amount]  
into #finaldata from #Data  
group by type,[client id],name  
order by name  
  
  
--select * from #finaldata ORDER BY NAME   
  
select srno,type,[client id],name,abs(diff8days) diff8days,abs(diff15days)diff15days,abs(diff30days)diff30days  
,abs(diff45days) diff45days,abs(diff90days) diff90days,  
abs(diff180days) diff180days,abs(diff365days) diff365days,abs([total debit amount])[total debit amount]  
from #finaldata where abs([total debit amount]) <> 0 ORDER BY NAME   
  
end

GO
