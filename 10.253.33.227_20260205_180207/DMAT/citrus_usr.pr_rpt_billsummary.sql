-- Object: PROCEDURE citrus_usr.pr_rpt_billsummary
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--begin tran
--pr_rpt_billsummary 'cdsl',3,'dec 31 2008','dec 31 2008','N','','1205490000000147','','','N',1,'ho|*~|',''     
--commit
CREATE proc [citrus_usr].[pr_rpt_billsummary]  
@pa_dptype varchar(4),                          
@pa_excsmid int,                          
@pa_fromdate datetime,                          
@pa_todate datetime,       
@pa_bulk_printflag char(1), --Y/N
@pa_stopbillclients_flag char(1), --Y/N                    
@pa_FROMaccid varchar(16),                          
@pa_toaccid varchar(16),      
@pa_group_cd varchar(10),         
@pa_transclientsonly char(1),  
@pa_Hldg_Yn char(1),       
@pa_profile  varchar(100),                 
@pa_login_pr_entm_id numeric,                            
@pa_login_entm_cd_chain  varchar(8000),                            
@pa_output varchar(8000) output                  
as  
begin  
  
set nocount on                 
set transaction isolation level read uncommitted       
 declare @@dpmid int,      
 @@l_child_entm_id numeric,    
 @@Ledgerid int,  
 @@Billduedate varchar(11),    
 @@ssql varchar(8000)    
                       
 SELECT @@dpmid = dpm_id FROM dp_mstr with(nolock) WHERE default_dp = @pa_excsmid AND dpm_deleted_ind =1                          
 SELECT @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)    
 SELECT @@Billduedate = CONVERT(VARCHAR(11),billc_due_date,109) from bill_cycle where billc_dpm_id = @@dpmid and billc_from_dt = @pa_fromdate and billc_to_dt = @pa_todate  
   
                          
 IF @pa_FROMaccid = ''                          
 BEGIN                          
  SET @pa_FROMaccid = '0'                          
  SET @pa_toaccid = '99999999999999999'                          
 END                          
 IF @pa_toaccid = ''                          
 BEGIN                      
   SET @pa_toaccid = @pa_FROMaccid                          
 END                          
    
  
    
  CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_FROM DATETIME,eff_to DATETIME)    
  
 
  if @pa_stopbillclients_flag = 'Y'
  begin
	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) where dpam_stam_cd <> '02_BILLSTOP'		
  end 
  else
  begin
	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)      
  end 


 if @pa_bulk_printflag = 'Y'
 begin
		delete A from #ACLIST A,blk_client_print_dtls 
		where dpam_id = blckpd_dpam_id and blkcpd_dpmid = @@dpmid
		and blkcpd_rptname = 'BILL'
 end




 SELECT @@Ledgerid =fin_id FROM Financial_Yr_Mstr WHERE fin_dpm_id = @@dpmid AND  (@pa_FROMdate between fin_start_dt AND fin_end_dt) AND fin_deleted_ind = 1    




  
  IF @pa_group_cd <> ''  
  BEGIN  
	DELETE A FROM #ACLIST A,account_group_mapping g with(nolock) WHERE A.dpam_id <> g.dpam_id AND g.group_cd = @pa_group_cd    
  END  
  Create table #ledgerBal(dpam_id bigint,prev_bill_bal numeric(18,2))   
  
set @@ssql =    'INSERT INTO #ledgerBal     
    SELECT dpam_id,sum(case when ldg_voucher_type = 5 and ldg_voucher_dt >= ''' + convert(varchar(11),@pa_fromdate,109) + ''' then 0 else isnull(ldg_amount,0) end )  
    FROM  #ACLIST with(nolock) left outer join Ledger' + convert(varchar,@@Ledgerid) + ' on dpam_id = ldg_account_id AND ldg_account_type = ''P'' AND ldg_voucher_dt <= ''' + convert(varchar(11),@pa_todate,109) + ''' and ldg_deleted_ind = 1   
    WHERE isnumeric(dpam_sba_no) = 1                            
    AND convert(numeric,dpam_sba_no) between convert(numeric,''' + @pa_FROMaccid + ''') AND convert(numeric,''' + @pa_toaccid + ''')                           
    AND (LDG_VOUCHER_DT between eff_FROM AND eff_to)      
    GROUP BY dpam_id'    
 exec(@@ssql)   
  

  
 IF (@pa_dptype = 'CDSL')                          
 BEGIN  
 SELECT *, bill_due_dt =@@Billduedate   
 FROM  
 (                        
  SELECT account.dpam_id clic_dpam_id,dpam_sba_no,dpam_sba_name,clic_charge_name,Amt=isnull(sum(clic_charge_amt),0),prev_bill_bal=isnull(prev_bill_bal,0),ord_by=case when clic_charge_name = 'TRANSACTION CHARGES' then 0 when charindex(clic_charge_name,'SERVICE TAX') <> 0 THEN 999 else 1 end  
  FROM client_charges_cdsl with(nolock)    right outer join   
  #ACLIST account  on clic_TRANS_DT >=@pa_FROMdate AND clic_TRANS_DT <=@pa_todate    
  AND clic_dpm_id = @@dpmid   AND clic_dpam_id = account.dpam_id                            
  AND (clic_TRANS_DT between eff_FROM AND eff_to)           
  left outer join #ledgerBal l  on account.dpam_id  = l.dpam_id
  WHERE isnumeric(dpam_sba_no) = 1                            
  AND convert(numeric,dpam_sba_no) between convert(numeric,@pa_FROMaccid) AND convert(numeric,@pa_toaccid)                           
 
  GROUP BY account.dpam_id,dpam_sba_no,dpam_sba_name,clic_charge_name,prev_bill_bal  
 ) tmp  
 ORDER BY dpam_sba_no,dpam_sba_name,ord_by,clic_charge_name  
END  
ELSE  
BEGIN  
 SELECT *, bill_due_dt =@@Billduedate   
 FROM  
 (    
  SELECT account.dpam_id clic_dpam_id,dpam_sba_no,dpam_sba_name,clic_charge_name,Amt=isnull(sum(clic_charge_amt),0),prev_bill_bal=isnull(prev_bill_bal,0),ord_by=case when clic_charge_name = 'TRANSACTION CHARGES' then 0 when charindex(clic_charge_name,'SERVICE TAX') <> 0 THEN 999 else 1 end  
  FROM client_charges_nsdl with(nolock) right outer join      
  #ACLIST account  on clic_TRANS_DT >=@pa_FROMdate AND clic_TRANS_DT <=@pa_todate     
  AND clic_dpm_id = @@dpmid    AND clic_dpam_id = account.dpam_id                            
  AND (clic_TRANS_DT between eff_FROM AND eff_to)         
  left outer join #ledgerBal l  on account.dpam_id  = l.dpam_id               
  WHERE  isnumeric(dpam_sba_no) = 1                            
  AND convert(numeric,dpam_sba_no) between convert(numeric,@pa_FROMaccid) AND convert(numeric,@pa_toaccid)                           
  GROUP BY account.dpam_id,dpam_sba_no,dpam_sba_name,clic_charge_name,prev_bill_bal  
 ) tmp  
 ORDER BY dpam_sba_no,dpam_sba_name,ord_by,clic_charge_name  
END  
TRUNCATE TABLE #ACLIST  
DROP TABLE #ACLIST  
end

GO
