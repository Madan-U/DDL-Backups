-- Object: PROCEDURE citrus_usr.Pr_rpt_bill_30072010
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--[Pr_rpt_bill] 'CDSL',3,'NOV  1 2008','NOV 30 2008 23:59:59','n','N','','','','Y',1,'ho|*~|',''	

create Proc [citrus_usr].[Pr_rpt_bill_30072010]              
@pa_dptype varchar(4),                      
@pa_excsmid int,                      
@pa_fromdate datetime,                      
@pa_todate datetime,                      
@pa_bulk_printflag char(1), --Y/N
@pa_stopbillclients_flag char(1), --Y/N 
@pa_fromaccid varchar(16),                      
@pa_toaccid varchar(16),  
@pa_group_cd varchar(10),     
@pa_transclientsonly char(1),
@pa_Hldg_Yn char(1),
@pa_login_pr_entm_id numeric,                        
@pa_login_entm_cd_chain  varchar(8000),                        
@pa_output varchar(8000) output
AS                      
BEGIN                      
              
              
set nocount on             
set transaction isolation level read uncommitted   
 declare @@dpmid int,  
 @@l_child_entm_id numeric,
 @@Ledgerid int,
 @@Billduedate varchar(11),
 @@ssql varchar(8000),
 @@reportname varchar(10),
 @pa_prevfromdate datetime
                   
 select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_excsmid and dpm_deleted_ind =1                      
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)
 select @@Ledgerid =fin_id from Financial_Yr_Mstr where fin_dpm_id = @@dpmid and  (@pa_fromdate between fin_start_dt and fin_end_dt) and fin_deleted_ind = 1
 SELECT @@Billduedate = CONVERT(VARCHAR(11),billc_due_date,109) from bill_cycle where billc_dpm_id = @@dpmid and billc_from_dt = CONVERT(VARCHAR(11),@pa_fromdate,109) and billc_to_dt = CONVERT(VARCHAR(11),@pa_todate,109)  


 
                       
 IF @pa_fromaccid = ''                      
 BEGIN                      
  SET @pa_fromaccid = '0'                      
  SET @pa_toaccid = '99999999999999999'                      
 END                      
 IF @pa_toaccid = ''                      
 BEGIN                  
   SET @pa_toaccid = @pa_fromaccid                      
 END                      


Create table #ledgerBal (
dpam_id bigint,
prev_bill_bal numeric(18,2)
)

  CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
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
 

                    
                
 IF (@pa_dptype = 'CDSL')                      
 BEGIN                
	 
	select @pa_prevfromdate = max(dphmcd_holding_dt) from DP_DAILY_HLDG_CDSL with(nolock) where dphmcd_holding_dt <= convert(varchar(11),@pa_todate,109)
	create table #tempmaincdsl              
	(          
	dpam_id bigint,            
	dpam_sba_name varchar(200),          
	dpam_acctno varchar(16),            
	trans_desc varchar(200),              
	dpm_trans_no varchar(10),              
	trans_date datetime,              
	isin_cd varchar(12),              
	opening_bal numeric(19,3),          
	qty numeric(19,3),          
	order_by integer,  
	line_no bigint,          
	charge_val numeric(19,2)          
	)      

           
           
   if @pa_group_cd <> ''      
   begin            
    insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val)           
    select distinct CDSHM_DPAM_ID,          
    DPAM_SBA_NAME,          
    CDSHM_BEN_ACCT_NO,                      
    CDSHM_TRATM_DESC=replace(CDSHM_TRATM_DESC,'        ',''),              
    CDSHM_TRANS_NO,                      
    CDSHM_TRAS_DT,                      
    CDSHM_ISIN,                      
    isnull(cdshm_opn_bal,0),            
    CDSHM_QTY,          
    1,  
    CDSHM_ID,                    
    cdshm_charge                      
    FROM CDSL_HOLDING_DTLS with(nolock)  
    ,account_group_mapping g with(nolock)               
    ,#ACLIST account                            
    where   CDSHM_DPM_ID = @@dpmid            
    and CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate                      
    and (cdshm_tratm_cd in('2246','2277') or isnull(cdshm_charge,0) <> 0)          
    and convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)   
    and g.dpam_id = CDSHM_DPAM_ID      
    and group_cd =  @pa_group_cd       
    and CDSHM_DPAM_ID = account.dpam_id              
    and (CDSHM_TRAS_DT between eff_from and eff_to)  
 end  
 else  
 begin  
    insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val)           
    select distinct CDSHM_DPAM_ID,          
    DPAM_SBA_NAME,          
    CDSHM_BEN_ACCT_NO,                      
    CDSHM_TRATM_DESC=replace(CDSHM_TRATM_DESC,'        ',''),              
    CDSHM_TRANS_NO,             
    CDSHM_TRAS_DT,                      
    CDSHM_ISIN,                      
    isnull(cdshm_opn_bal,0),            
    CDSHM_QTY,          
    1,  
    CDSHM_ID,                       
    cdshm_charge                      
    FROM CDSL_HOLDING_DTLS with(nolock),          
    #ACLIST account                            
    where   CDSHM_DPM_ID = @@dpmid            
    and CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate                      
    and (cdshm_tratm_cd in('2246','2277') or isnull(cdshm_charge,0) <> 0)          
    and convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                                               
    and CDSHM_DPAM_ID = account.dpam_id              
    and (CDSHM_TRAS_DT between eff_from and eff_to)  
  
 end          
           
   if @pa_Hldg_Yn         = 'Y'
   begin 
	   if @pa_transclientsonly <> 'Y'    
	   begin     
	  if @pa_group_cd <> ''      
	  begin   
		 insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val)           
		 select distinct DPHMCD_DPAM_ID,            
		 DPAM_SBA_NAME,          
		 DPAM_SBA_NO,                      
		 trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' +  Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),        
		 TRANS_NO='',                      
		 trans_date='Dec 31 2100',                      
		 DPHMCD_ISIN,                      
		 0,            
		 0,          
		 3,  
		 0,        
		 0                      
		 FROM DP_DAILY_HLDG_CDSL with(nolock)  
		 ,account_group_mapping g with(nolock)              
		 ,#ACLIST account                    
		 WHERE           
		 DPHMCD_HOLDING_DT =@pa_prevfromdate 
		 and isnumeric(DPAM_SBA_NO) = 1                       
		 and convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)   
		 and g.dpam_id = DPHMCD_dpam_id      
		 and group_cd =  @pa_group_cd      
		 and DPHMCD_dpam_id = account.dpam_id              
		 and (DPHMCD_HOLDING_DT between eff_from and eff_to)    
		 and DPHMCD_dpm_id = @@dpmid       
		 and isnull(DPHMCD_CURR_QTY,0) <> 0         
	  end  
	  else  
	  begin  
		 insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val)           
		 select distinct DPHMCD_DPAM_ID,            
		 DPAM_SBA_NAME,          
		 DPAM_SBA_NO,                      
		 trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' +  Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),
		 TRANS_NO='',                      
		 trans_date='Dec 31 2100',                      
		 DPHMCD_ISIN,                      
		 isnull(DPHMCD_CURR_QTY,0),            
		 0,          
		 3,  
		 0,        
		 0                      
		 FROM DP_DAILY_HLDG_CDSL with(nolock),          
		 #ACLIST account                    
		 WHERE           
		 DPHMCD_HOLDING_DT =@pa_prevfromdate  
		 and isnumeric(DPAM_SBA_NO) = 1                       
		 and convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                                               
		 AND DPHMCD_dpam_id = account.dpam_id              
		 and (DPHMCD_HOLDING_DT between eff_from and eff_to)
		 and DPHMCD_dpm_id = @@dpmid         
		 and isnull(DPHMCD_CURR_QTY,0) <> 0         
	  
	  end  
	  end  
	  else  
	  begin  
	  if @pa_group_cd <> ''      
	  begin   
		 insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val)           
		 select distinct DPHMCD_DPAM_ID,            
		 DPAM_SBA_NAME,          
		 DPAM_SBA_NO,                      
		 trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),        
		 TRANS_NO='',                      
		 trans_date='Dec 31 2100',                      
		 DPHMCD_ISIN,                      
		 isnull(DPHMCD_CURR_QTY,0),            
		 0,          
		 3,  
		 0,        
		 0                      
		 FROM DP_DAILY_HLDG_CDSL with(nolock)  
		 ,account_group_mapping g with(nolock)              
		 ,#ACLIST account                    
		 WHERE           
		 DPHMCD_HOLDING_DT =@pa_prevfromdate          
		 and EXISTS(SELECT DPAM_ID FROM #tempmaincdsl T1 with(nolock) WHERE T1.DPAM_ID = DPHMCD_DPAM_ID)                            
		 and isnumeric(DPAM_SBA_NO) = 1                       
		 and convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)   
		 and g.dpam_id = DPHMCD_dpam_id      
		 and group_cd =  @pa_group_cd      
		 and DPHMCD_dpam_id = account.dpam_id              
		 and (DPHMCD_HOLDING_DT between eff_from and eff_to)    
		 and DPHMCD_dpm_id = @@dpmid
		 and isnull(DPHMCD_CURR_QTY,0) <> 0              
	  end  
	  else  
	  begin  
		 insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val)           
		 select distinct DPHMCD_DPAM_ID,            
		 DPAM_SBA_NAME,          
		 DPAM_SBA_NO,                      
		 trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' +  Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),
		 TRANS_NO='',                      
		 trans_date='Dec 31 2100',                      
		 DPHMCD_ISIN,                      
		 isnull(DPHMCD_CURR_QTY,0),            
		 0,          
		 3,  
		 0,        
		 0                      
		 FROM DP_DAILY_HLDG_CDSL with(nolock),          
		 #ACLIST account                    
		 WHERE           
		 DPHMCD_HOLDING_DT =@pa_prevfromdate          
		 and EXISTS(SELECT DPAM_ID FROM #tempmaincdsl T1 with(nolock) WHERE T1.DPAM_ID = DPHMCD_DPAM_ID)                            
		 and isnumeric(DPAM_SBA_NO) = 1                       
		 and convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                                   
		 and DPHMCD_dpam_id = account.dpam_id              
		 and (DPHMCD_HOLDING_DT between eff_from and eff_to)
		 and DPHMCD_dpm_id = @@dpmid     
		 and isnull(DPHMCD_CURR_QTY,0) <> 0         
	  
	  end  
	  
	  end          
   end         
          
 if @pa_group_cd <> ''      
 begin           
  insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val)           
  select clic_dpam_id,dpam_sba_name,dpam_sba_no,clic_charge_name,null,clic_trans_dt=@pa_todate,null,null,null,2,0,sum(clic_charge_amt)           
  from client_charges_cdsl with(nolock)  
  ,account_group_mapping g with(nolock)              
  , #ACLIST account             
  where           
  clic_dpm_id = @@dpmid                      
  and clic_charge_name <> 'TRANSACTION CHARGES'           
  and clic_TRANS_DT >=@pa_fromdate AND clic_TRANS_DT <=@pa_todate                       
  and isnumeric(dpam_sba_no) = 1                        
  and convert(numeric,dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                       
  and g.dpam_id = clic_dpam_id      
  and group_cd =  @pa_group_cd      
  and clic_dpam_id = account.dpam_id   
  and CLIC_DELETED_IND=1                     
  and (clic_TRANS_DT between eff_from and eff_to)   
  group by clic_dpam_id,dpam_sba_no,dpam_sba_name,clic_charge_name                  
 end  
 else  
 begin  
  insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val)           
  select clic_dpam_id,dpam_sba_name,dpam_sba_no,clic_charge_name,null,clic_trans_dt=@pa_todate,null,null,null,2,0,sum(clic_charge_amt)           
  from client_charges_cdsl with(nolock)         
  , #ACLIST account             
  where           
  clic_dpm_id = @@dpmid                      
  and clic_charge_name <> 'TRANSACTION CHARGES'           
  and clic_TRANS_DT >=@pa_fromdate AND clic_TRANS_DT <=@pa_todate                       
  and isnumeric(dpam_sba_no) = 1                        
  and convert(numeric,dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                       
  and clic_dpam_id = account.dpam_id   
  and CLIC_DELETED_IND=1                      
  and (clic_TRANS_DT between eff_from and eff_to)
  group by clic_dpam_id,dpam_sba_no,dpam_sba_name,clic_charge_name                     
  
 end  
           
   IF @pa_transclientsonly <> 'Y'    
   BEGIN





   INSERT INTO #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val) 
   SELECT dpam_id , dpam_sba_name, dpam_sba_no , '','','','',0,0,4,0,0 FROM #ACLIST a
   WHERE NOT EXISTS(SELECT dpam_id FROM #tempmaincdsl b WHERE a.dpam_id = b.dpam_id)
   AND  eff_from BETWEEN  @pa_fromdate AND @pa_todate 
   and convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)   

   END 	

    set @@ssql ='insert into #ledgerBal
	select dpam_id,sum(case when ldg_voucher_type = 5 and ldg_voucher_dt >= ''' + convert(varchar(11),@pa_fromdate,109) + ''' then 0 else isnull(ldg_amount,0) * -1 end )
	from (
	select distinct dpam_id from #tempmaincdsl
	) tmp left outer join Ledger' + convert(varchar,@@Ledgerid) + ' on dpam_id = ldg_account_id and ldg_account_type = ''P'' and ldg_voucher_dt <= ''' + convert(varchar(11),@pa_todate,109) + ''' and ldg_deleted_ind = 1
	group by dpam_id'
	exec(@@ssql)

  


	
	select order_by,t.dpam_id,dpam_sba_name,dpam_acctno,                      
	CDSHM_TRATM_DESC= lower(ltrim(rtrim(trans_desc))),              
	dpm_trans_no,                      
	trans_date=convert(varchar(11),trans_date,109),                      
	t.ISIN_CD,          
	isin_name=isnull(isin_name,''),                      
	opening_bal=Replace(convert(varchar,isnull(opening_bal,0)),'.000',''),            
	DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                      
	CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,
	closing_bal = Replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),'.000',''),          
	charge_val=isnull(charge_val,0)  * -1,
	prev_bill_bal=isnull(prev_bill_bal,0),
	bill_due_dt =@@Billduedate,
	trans_date
	FROM #tempmaincdsl t with(nolock)
	LEFT OUTER JOIN  isin_mstr i with(nolock) on t.isin_cd = i.isin_cd
	,#ledgerBal l
	where t.dpam_id = l.dpam_id
	order by dpam_acctno,dpam_sba_name,order_by,Isin_name,17,line_no    
	

   truncate table #tempmaincdsl               
   truncate table #ledgerBal

	drop table #tempmaincdsl  
	drop table #ledgerBal 
    
 END                      
 ELSE                      
 BEGIN                
              
	select @pa_prevfromdate = max(dpdhmd_holding_dt) from DP_DAILY_HLDG_NSDL with(nolock) where dpdhmd_holding_dt < @pa_fromdate
           
   create table #tempmainnsdl              
   (              
   trans_date datetime,              
   dpam_id bigint,              
   dpam_acctno varchar(16),            
   dpam_sba_name varchar(200),            
   isin_cd varchar(12),
   sett_type varchar(3),
   sett_no varchar(10),              
   dpm_trans_no bigint,              
   Qty numeric(19,3),              
   Book_Narr_cd varchar(3),              
   Book_type varchar(3),        
   Ben_ctgry varchar(2),        
   Ben_acct_type varchar(2),              
   trans_desc varchar(200),              
   final_trans int,          
   charge_val numeric(19,2),
   line_no bigint              
   )              
                  
                 
 if @pa_group_cd <> ''      
 begin                 
   insert into #tempmainnsdl             
   select distinct NSDHM_TRANSACTION_DT,NSDHM_dpam_id,NSDHM_BEN_ACCT_NO,dpam_sba_name
  ,NSDHM_ISIN,nsdhm_sett_type,nsdhm_sett_no,convert(numeric,nsdhm_dpm_trans_no),NSDHM_QTY,              
    NSDHM_BOOK_NAAR_CD,NSDHM_BOOK_TYPE,NSDHM_BEN_CTGRY,NSDHM_BEN_ACCT_TYPE,              
   TRANS_DESC= isnull(NSDHM_TRN_DESCP,'')      
   ,0          
   ,nsdhm_charge,NSDHM_LN_NO               
   from NSDL_HOLDING_DTLS with(nolock)  
    ,account_group_mapping g with(nolock)                       
   ,#ACLIST account                      
   where           
   nsdhm_dpm_id = @@dpmid                      
   and NSDHM_TRANSACTION_DT >=@pa_fromdate AND NSDHM_TRANSACTION_DT <=@pa_todate                       
   and isnumeric(NSDHM_BEN_ACCT_NO) = 1                        
   and convert(numeric,NSDHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                       
    and g.dpam_id = NSDHM_dpam_id      
   and group_cd =  @pa_group_cd     
   and NSDHM_dpam_id = account.dpam_id                        
   and (NSDHM_TRANSACTION_DT between eff_from and eff_to) 
   and ltrim(rtrim(NSDHM_TRASTM_CD)) <> ''        
 end  
 else  
 begin  
   insert into #tempmainnsdl             
   select distinct NSDHM_TRANSACTION_DT,NSDHM_dpam_id,NSDHM_BEN_ACCT_NO,dpam_sba_name
   ,NSDHM_ISIN,nsdhm_sett_type,nsdhm_sett_no,convert(numeric,nsdhm_dpm_trans_no),NSDHM_QTY,              
    NSDHM_BOOK_NAAR_CD,NSDHM_BOOK_TYPE,NSDHM_BEN_CTGRY,NSDHM_BEN_ACCT_TYPE,              
   TRANS_DESC= isnull(NSDHM_TRN_DESCP,'')      
   ,0          
   ,nsdhm_charge,NSDHM_LN_NO              
   from NSDL_HOLDING_DTLS with(nolock),                      
   #ACLIST account                      
   where           
   nsdhm_dpm_id = @@dpmid                      
   and NSDHM_TRANSACTION_DT >=@pa_fromdate AND NSDHM_TRANSACTION_DT <=@pa_todate                       
   and isnumeric(NSDHM_BEN_ACCT_NO) = 1                        
   and convert(numeric,NSDHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                       
   and NSDHM_dpam_id = account.dpam_id                        
   and (NSDHM_TRANSACTION_DT between eff_from and eff_to)    
   and ltrim(rtrim(NSDHM_TRASTM_CD)) <> ''           
 end         
                 

   	  
  --for non pool accounts 
	
		  delete from #tempmainnsdl where Ben_acct_type not in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213','101')               
		    
		  update m set final_trans = 1,sett_type='',sett_no=''             
		  from #tempmainnsdl m            
		  where Ben_acct_type not in('20','30','40') and convert(int,m.book_narr_cd) = isnull((select max(convert(int,book_narr_cd)) from #tempmainnsdl m1 where m.dpm_trans_no = m1.dpm_trans_no and m.isin_cd = m1.isin_cd and m.dpam_id = m1.dpam_id and m.Ben_acct_type = m1.Ben_acct_type),0)            

			--added for demat & remat pending transactions 
			update #tempmainnsdl set final_trans = 1,sett_type='',sett_no='' where Ben_acct_type in('12','13') 
			--added for demat & remat pending transactions

	    --for non pool accounts            
	
	     -- for pool accounts
		     delete from #tempmainnsdl where Ben_acct_type in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213')
		
		     update #tempmainnsdl set final_trans = 1 where  Ben_acct_type in('20','30','40') and  sett_type <> '00'



	     -- for pool accounts          
   if @pa_Hldg_Yn = 'Y'
   begin              
	   if @pa_transclientsonly = 'Y'    
	   begin                 
		 insert into #tempmainnsdl              
		 select @pa_prevfromdate,dpdhmd_dpam_id,dpam_sba_no,dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,null,sum(dpdhmd_qty),null,null,dpdhmd_benf_cat,dpdhmd_benf_acct_typ,'*',3,0,null              
		 from fn_dailyholding(@@dpmid,@pa_prevfromdate,@pa_fromaccid,@pa_toaccid,'',@pa_group_cd,@pa_login_pr_entm_id,@@l_child_entm_id)            
		 where exists(select dpam_id from #tempmainnsdl with(nolock) where dpam_id = dpdhmd_dpam_id)           
		 group by dpdhmd_dpam_id,dpam_sba_no,dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,dpdhmd_benf_cat,dpdhmd_benf_acct_typ               
	   end    
	   else    
	   begin   
	   	
   		insert into #tempmainnsdl              
		 select @pa_prevfromdate,dpdhmd_dpam_id,h.dpam_sba_no,h.dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,null,sum(dpdhmd_qty),null,null,dpdhmd_benf_cat,dpdhmd_benf_acct_typ,'*',3,0,null              
		 from fn_dailyholding(@@dpmid,@pa_prevfromdate,@pa_fromaccid,@pa_toaccid,'',@pa_group_cd,@pa_login_pr_entm_id,@@l_child_entm_id) h,#ACLIST a
		 where dpdhmd_dpam_id = a.dpam_id
		 group by dpdhmd_dpam_id,h.dpam_sba_no,h.dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,dpdhmd_benf_cat,dpdhmd_benf_acct_typ    
	   end    
    end 
  
  if @pa_group_cd <> ''      
  begin   
    insert into #tempmainnsdl          
    select clic_trans_dt=@pa_todate,clic_dpam_id,dpam_sba_no,dpam_sba_name,null,null,null,null,null,null,null,null,null,clic_charge_name,2,Sum(clic_charge_amt),null           
    from client_charges_nsdl with(nolock)  
    ,account_group_mapping g with(nolock)          
    , #ACLIST account             
    where           
    clic_dpm_id = @@dpmid                      
    and clic_TRANS_DT >=@pa_fromdate AND clic_TRANS_DT <=@pa_todate                       
    and clic_charge_name <> 'TRANSACTION CHARGES'           
    and isnumeric(dpam_sba_no) = 1                        
    and convert(numeric,dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                       
      and g.dpam_id = clic_dpam_id      
    and group_cd =  @pa_group_cd    
    and clic_dpam_id = account.dpam_id                        
    and (clic_TRANS_DT between eff_from and eff_to)   
	group by clic_dpam_id,dpam_sba_no,dpam_sba_name,clic_charge_name         
 end  
 else  
 begin  
    insert into #tempmainnsdl          
    select clic_trans_dt=@pa_todate,clic_dpam_id,dpam_sba_no,dpam_sba_name,null,null,null,null,null,null,null,null,null,clic_charge_name,2,sum(clic_charge_amt),null           
    from client_charges_nsdl with(nolock)         
    , #ACLIST account             
    where           
    clic_dpm_id = @@dpmid                      
    and clic_TRANS_DT >=@pa_fromdate AND clic_TRANS_DT <=@pa_todate                       
    and clic_charge_name <> 'TRANSACTION CHARGES'           
    and isnumeric(dpam_sba_no) = 1                        
    and convert(numeric,dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                       
    and clic_dpam_id = account.dpam_id                        
    and (clic_TRANS_DT between eff_from and eff_to)    
	group by clic_dpam_id,dpam_sba_no,dpam_sba_name,clic_charge_name         
 end            



     -- for pool accounts
	     delete from #tempmainnsdl where Ben_acct_type in('20','30','40') and isnull(sett_type,'') = '00'
     -- for pool accounts
     --for non pool accounts 
       update #tempmainnsdl set sett_type='',sett_no='' where final_trans = 3 and Ben_acct_type not in('20','30','40')
     --for non pool accounts 
            
   create table #temprunning              
   (  
   Runningid bigint identity(1,1),              
   trans_date datetime,              
   dpam_id bigint,              
   dpam_acctno char(16),            
   dpam_sba_name varchar(200),            
   isin_cd varchar(12),
   sett_type varchar(3),
   sett_no varchar(10),                 
   dpm_trans_no varchar(10),              
   Qty numeric(19,3),              
   Book_Narr_cd varchar(3),              
   Book_type varchar(3),        
   Ben_ctgry varchar(2),        
   Ben_acct_type varchar(2),              
   trans_desc varchar(200),              
   final_trans int,          
   charge_val numeric(19,2),
   line_no bigint,  
   closing_qty numeric(18,3)               
   )              
   CREATE INDEX IX_1 on #temprunning(dpam_id,Ben_ctgry,Ben_acct_type,isin_cd)                 
           
           
   
                       
   insert into #temprunning   
   select m.*,closing_qty=0.000              
   from #tempmainnsdl m with(nolock) where final_trans > 0              
   order by dpam_id,isin_cd,Ben_ctgry,Ben_acct_type,sett_type,sett_no,trans_date,line_no,dpm_trans_no,Book_Narr_cd
                 
                 
   update t               
   set closing_qty = (select sum(isnull(qty,0)) from #temprunning t1 with(nolock) where t1.Runningid <= t.Runningid and t1.dpam_id =t.dpam_id and t1.Ben_ctgry = t.Ben_ctgry and t1.Ben_acct_type = t.Ben_acct_type and t1.isin_cd = t.isin_cd and t1.sett_type=t.sett_type and t1.sett_no = t.sett_no)          
   from #temprunning t with(nolock)             
            
            
   delete t from #temprunning t with(nolock)          
   where exists(select dpam_id,isin_cd from #temprunning t1 with(nolock)          
   where t.dpam_id = t1.dpam_id and t1.Ben_ctgry = t.Ben_ctgry and t1.Ben_acct_type = t.Ben_acct_type and t.isin_cd = t1.isin_cd and t1.trans_desc <> '*')           
   and t.trans_desc='*'          


    set @@ssql ='insert into #ledgerBal
	select dpam_id,sum(case when ldg_voucher_type = 5 and ldg_voucher_dt >= ''' + convert(varchar(11),@pa_fromdate,109) + ''' then 0 else isnull(ldg_amount,0) * -1 end )
	from (
	select distinct dpam_id from #temprunning
	) tmp left outer join Ledger' + convert(varchar,@@Ledgerid) + ' on dpam_id = ldg_account_id and ldg_account_type = ''P'' and ldg_voucher_dt <= ''' + convert(varchar(11),@pa_todate,109) + ''' and ldg_deleted_ind = 1
	group by dpam_id'
	exec(@@ssql)    
           
   select final_trans,t.dpam_id,dpam_sba_name,NSDHM_BEN_ACCT_NO=dpam_acctno,ben_type=ltrim(rtrim(isnull(ben.descp,Ben_acct_type) + ' ' + case when sett_type <> '' then isnull(s.settm_desc,sett_type) + '/' + sett_no else '' end)),dpm_trans_no=ISNULL(dpm_trans_no,''),                      
   TRANS_DESC=ltrim(rtrim(isnull(TRANS_DESC,''))),              
   NSDHM_TRANSACTION_DT=convert(varchar(11),trans_date,109),                      
   NSDHM_ISIN=t.isin_cd,                      
   Isin_name=isnull(Isin_name,t.isin_cd),               
   open_qty = replace(convert(varchar,(CASE WHEN final_trans = 3 THEN closing_qty ELSE closing_qty - qty END)),'.000',''),                    
   DEBIT_QTY= CASE WHEN QTY <= 0 THEN replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                      
   CREDIT_QTY= CASE WHEN QTY > 0 THEN replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                
   closing_qty= replace(convert(varchar,closing_qty),'.000',''),          
   charge_val= isnull(charge_val,0)   * -1,
   prev_bill_bal=isnull(prev_bill_bal,0),
   bill_due_dt =@@Billduedate,
   trans_date           
   from #temprunning t with(nolock) left outer join isin_mstr i with(nolock) on t.isin_cd = i.isin_cd 
   left outer join settlement_type_mstr s with(nolock) on t.sett_type = s.settm_type and isnull(s.settm_type,'') <> ''  and s.settm_deleted_ind = 1          
   left outer join citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') ben on t.Ben_acct_type = ben.cd , #ledgerBal l   
   where t.dpam_id= l.dpam_id                    
   order by dpam_acctno,final_trans,Isin_name,Runningid,18          
    

   truncate table #tempmainnsdl    
   truncate table #temprunning               
   truncate table #ledgerBal 
   drop table #tempmainnsdl    
   drop table #temprunning               
   drop table #ledgerBal
              
              
                        
 END                      
     
      TRUNCATE TABLE #ACLIST
	  DROP TABLE #ACLIST                  
END

GO
