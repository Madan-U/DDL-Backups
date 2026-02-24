-- Object: PROCEDURE citrus_usr.Pr_rpt_bill_profile_filter_Shilpa_bak_23032015
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--Pr_rpt_bill_profile_filter 	'CDSL',3,'Jan 26 2009','Jun 26 2009','N','N','1234567890123456','','','N','Y','',1,'HO|*~|',''	

create Proc [citrus_usr].[Pr_rpt_bill_profile_filter_Shilpa_bak_23032015]              
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
@pa_profile varchar(100),
@pa_login_pr_entm_id numeric,                        
@pa_login_entm_cd_chain  varchar(8000),                        
@pa_output varchar(8000) output
AS                      
BEGIN                      
              select * from temptableabcd14Jully2014
return
              
set nocount on             
set transaction isolation level read uncommitted   
 declare @@dpmid int,  
 @@l_child_entm_id numeric,
 @@Ledgerid int,
 @@Billduedate varchar(11),
 @@ssql varchar(8000),
 @@reportname varchar(10),
 @pa_prevfromdate datetime ,
 @@l_grpmstr_cd char(1)
  ,@@bbocode varchar(10)
 set @@bbocode = ''
        

set @@l_grpmstr_cd =  isnull(citrus_usr.fn_splitval(@pa_group_cd,2),'')  
set @pa_group_cd =  isnull(citrus_usr.fn_splitval(@pa_group_cd,1),'')  
          
 select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_excsmid and dpm_deleted_ind =1                      
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)
 select @@Ledgerid =fin_id from Financial_Yr_Mstr where fin_dpm_id = @@dpmid and  (@pa_fromdate between fin_start_dt and fin_end_dt) and fin_deleted_ind = 1
 SELECT @@Billduedate = CONVERT(VARCHAR(11),billc_due_date,109) from bill_cycle where billc_dpm_id = @@dpmid and billc_from_dt = CONVERT(VARCHAR(11),@pa_fromdate,109) and billc_to_dt = CONVERT(VARCHAR(11),@pa_todate,109)  

 set @@bbocode = isnull(citrus_usr.fn_splitval(@pa_profile,2),'') 
 set @pa_profile = isnull(citrus_usr.fn_splitval(@pa_profile,1),'')  


if @pa_profile ='0'
set @pa_profile = ''
 
                       
 IF @pa_fromaccid = ''                      
 BEGIN                      
  SET @pa_fromaccid = '0'                      
  SET @pa_toaccid = '99999999999999999'                      
 END                      
 IF @pa_toaccid = ''                      
 BEGIN                  
   SET @pa_toaccid = @pa_fromaccid                      
 END                      

if @@bbocode <> ''
begin
select accp_value bbo , dpam_sba_no clientid 
into #bbocode from account_properties , dp_Acct_mstr  
where accp_accpm_prop_Cd='bbo_code'
and accp_clisba_id = dpam_id 
and accp_value = @@bbocode

if @@bbocode <> ''
select @pa_fromaccid = min(clientid ) from #bbocode 

if @@bbocode <> ''
select @pa_toaccid = max(clientid ) from #bbocode 

 create clustered index ix_1 on #bbocode(clientid,bbo)  

end    

Create table #ledgerBal (
dpam_id bigint,
prev_bill_bal numeric(18,2)
)

  CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
  if @pa_stopbillclients_flag = 'Y'
  begin
    if @pa_profile <> ''
    begin 
		
		if @@bbocode <> ''
		INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO ,'dec 31 2900')
		FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) , client_dp_brkg 
		where dpam_stam_cd <> '02_BILLSTOP'	
        and   dpam_id = clidb_dpam_id 
        and   clidb_eff_to_dt >= 'DEC 31 2099' 
        and   clidb_brom_id = @pa_profile
        AND   CLIDB_DELETED_IND = 1
        and exists(select clientid,bbo from #bbocode where clientid = dpam_sba_no and bbo = case when @@bbocode <> '' then @@bbocode else bbo end )

		if @@bbocode = ''
		INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO ,'dec 31 2900')
		FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) , client_dp_brkg 
		where dpam_stam_cd <> '02_BILLSTOP'	
        and   dpam_id = clidb_dpam_id 
        and   clidb_eff_to_dt >= 'DEC 31 2099' 
        and   clidb_brom_id = @pa_profile
        AND   CLIDB_DELETED_IND = 1
        --and exists(select clientid,bbo from #bbocode where clientid = dpam_sba_no and bbo = case when @@bbocode <> '' then @@bbocode else bbo end )
    end 
    else 
    begin
		if @@bbocode <> ''
    	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO  ,'dec 31 2900')
		FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) 
		where dpam_stam_cd <> '02_BILLSTOP'	
        and exists(select clientid,bbo from #bbocode where clientid = dpam_sba_no and bbo = case when @@bbocode <> '' then @@bbocode else bbo end )	

		if @@bbocode = ''
    	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO  ,'dec 31 2900')
		FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) 
		where dpam_stam_cd <> '02_BILLSTOP'	
       -- and exists(select clientid,bbo from #bbocode where clientid = dpam_sba_no and bbo = case when @@bbocode <> '' then @@bbocode else bbo end )	
    end  
  end 
  else
  begin
    if @pa_profile <> ''
    begin 
		if @@bbocode <> ''
		INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO  ,'dec 31 2900')
		FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)	 , client_dp_brkg 	
        where   dpam_id = clidb_dpam_id 
        and   clidb_eff_to_dt >= 'DEC 31 2099' 
        and   clidb_brom_id = @pa_profile
        AND   CLIDB_DELETED_IND = 1
        and exists(select clientid,bbo from #bbocode where clientid = dpam_sba_no and bbo = case when @@bbocode <> '' then @@bbocode else bbo end )

		if @@bbocode = ''
		INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO  ,'dec 31 2900')
		FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)	 , client_dp_brkg 	
        where   dpam_id = clidb_dpam_id 
        and   clidb_eff_to_dt >= 'DEC 31 2099' 
        and   clidb_brom_id = @pa_profile
        AND   CLIDB_DELETED_IND = 1
        --and exists(select clientid,bbo from #bbocode where clientid = dpam_sba_no and bbo = case when @@bbocode <> '' then @@bbocode else bbo end )

    end
    else 
    begin
		if @@bbocode <> ''
    	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO ,'dec 31 2900')
		FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)	
        where exists(select clientid,bbo from #bbocode where clientid = dpam_sba_no and bbo = case when @@bbocode <> '' then @@bbocode else bbo end )

		if @@bbocode = ''
    	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO ,'dec 31 2900')
		FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)	
       -- where exists(select clientid,bbo from #bbocode where clientid = dpam_sba_no and bbo = case when @@bbocode <> '' then @@bbocode else bbo end )

    end  
  
  end 
--select * from #ACLIST where dpam_sba_no = '1201090000004621'

 if @pa_bulk_printflag = 'Y'
 begin
		delete A from #ACLIST A,blk_client_print_dtls 
		where dpam_id = blckpd_dpam_id and blkcpd_dpmid = @@dpmid
		and blkcpd_rptname = 'BILL'
 end
 

create table #tmphldg 
(
	[DPHMCD_DPM_ID] [numeric](18, 0) NOT NULL,
	[DPHMCD_DPAM_ID] [numeric](10, 0) NOT NULL,
	[DPHMCD_ISIN] [varchar](20) NOT NULL,
	[DPHMCD_CURR_QTY] [numeric](18, 3) NULL,
	[DPHMCD_FREE_QTY] [numeric](18, 3) NULL,
	[DPHMCD_FREEZE_QTY] [numeric](18, 3) NULL,
	[DPHMCD_PLEDGE_QTY] [numeric](18, 3) NULL,
	[DPHMCD_DEMAT_PND_VER_QTY] [numeric](18, 3) NULL,
	[DPHMCD_REMAT_PND_CONF_QTY] [numeric](18, 3) NULL,
	[DPHMCD_DEMAT_PND_CONF_QTY] [numeric](18, 3) NULL,
	[DPHMCD_SAFE_KEEPING_QTY] [numeric](18, 3) NULL,
	[DPHMCD_LOCKIN_QTY] [numeric](18, 3) NULL,
	[DPHMCD_ELIMINATION_QTY] [numeric](18, 3) NULL,
	[DPHMCD_EARMARK_QTY] [numeric](18, 3) NULL,
	[DPHMCD_AVAIL_LEND_QTY] [numeric](18, 3) NULL,
	[DPHMCD_LEND_QTY] [numeric](18, 3) NULL,
	[DPHMCD_BORROW_QTY] [numeric](18, 3) NULL,
	[dphmcd_holding_dt] datetime
	)  


create index ix_1_hldg on #tmphldg([DPHMCD_DPM_ID],[DPHMCD_DPAM_ID],[DPHMCD_ISIN],[dphmcd_holding_dt])

if @pa_Hldg_Yn ='Y'
begin 
	insert into #tmphldg
	exec  [pr_get_holding_fix_latest]   @@DPMID,@pa_fromdate,@pa_todate,@PA_FROMACCID,@PA_TOACCID,''

end 



create table #vw_fethob(v_CDSHM_DPM_ID numeric 
			, v_CDSHM_DPAM_ID numeric,v_CDSHM_ISIN varchar(20),v_cdshm_opn_bal numeric(18,3)
--			,v_cdshm_trans_no varchar(150)
)

create index ic_ob on #vw_fethob(v_CDSHM_DPM_ID,v_CDSHM_DPAM_ID,v_CDSHM_ISIN)

  insert into #vw_fethob
  exec pr_get_ob_fix @@dpmid,@pa_fromdate,@pa_todate,@pa_fromaccid,@pa_toaccid,''


select * ,citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,16,'~') exedt
,citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,9,'~') exetime into #tmp_cdsl_holding_dtls from cdsl_holding_dtls
where CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate  
and cdshm_ben_acct_no between @pa_fromaccid and @pa_toaccid

   
                    
                
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
	charge_val numeric(19,2)  , settm_id varchar(25),  tr_settm_id varchar(25) , tratm_cd varchar(25) 
    ,exedt datetime  ,c_d_flag char(1) 
	)      

           
           
   if @pa_group_cd <> ''      
   begin            
    insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val,settm_id,tr_settm_id,tratm_cd,exedt,c_d_flag)           
    select distinct CDSHM_DPAM_ID,          
    DPAM_SBA_NAME,          
    CDSHM_BEN_ACCT_NO,                      
    CDSHM_TRATM_DESC=replace(CDSHM_TRATM_DESC,'        ',''),              
    CDSHM_TRANS_NO,                      
    CDSHM_TRAS_DT,                      
    CDSHM_ISIN,                      
    isnull(v_cdshm_opn_bal,0),            
    CDSHM_QTY,          
    1,  
    CDSHM_ID,                    
    cdshm_charge   ,   CDSHM_SETT_NO ,  right(isnull(CDSHM_TRG_SETTM_NO,'') ,7)  , cdshm_tratm_cd    
,convert(datetime, case when exedt <> '' then substring(exedt,5,4)+'-'
+substring(exedt,3,2)
+'-'+substring(exedt,1,2)
+ ' ' + 
replace(
substring(exedt,9,2)
+':'+substring(exedt,11,2)+':'+substring(exetime,13,2)
, '00:00:00', '00:00:00') else 
substring(exetime,5,4)+'-'
+substring(exetime,3,2)
+'-'+substring(exetime,1,2)
+ ' ' + 
replace(
substring(exetime,9,2)
+':'+substring(exetime,11,2)+':'+substring(exetime,13,2)
, '00:00:00', '00:00:00') end )
    ,case when cdshm_qty > 0 then 'C' else 'D' end         
    FROM #tmp_cdsl_holding_dtls with(nolock)
 left outer join  #vw_fethob   on v_cdshm_dpam_id = cdshm_dpam_id 
      and v_cdshm_isin = cdshm_isin               
	   and v_cdshm_dpm_id = cdshm_dpm_id   
    ,account_group_mapping g with(nolock)               
    ,#ACLIST account                            
    where   CDSHM_DPM_ID = @@dpmid            
    and CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate                      
    and (cdshm_tratm_cd in('2246','2277','2201','3102','2270','2220','2262','2251','2202','2205') or isnull(cdshm_charge,0) <> 0)          
    and convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)   
    and g.dpam_id = CDSHM_DPAM_ID      
    and group_cd =  @pa_group_cd       
    and CDSHM_DPAM_ID = account.dpam_id              
    and (CDSHM_TRAS_DT between eff_from and eff_to)  

 end  
 else  
 begin  
    insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val,settm_id, tr_settm_id,tratm_cd,exedt,c_d_flag)           
    select distinct CDSHM_DPAM_ID,          
    DPAM_SBA_NAME,          
    CDSHM_BEN_ACCT_NO,                      
    CDSHM_TRATM_DESC=replace(CDSHM_TRATM_DESC,'        ',''),              
    CDSHM_TRANS_NO,             
    CDSHM_TRAS_DT,                      
    CDSHM_ISIN,                      
    isnull(v_cdshm_opn_bal,0),            
    CDSHM_QTY,          
    1,  
    CDSHM_ID,                       
    cdshm_charge     ,   CDSHM_SETT_NO ,  right(isnull(CDSHM_TRG_SETTM_NO,'') ,7) ,cdshm_tratm_cd    
,convert(datetime, case when exedt <> '' then substring(exedt,5,4)+'-'
+substring(exedt,3,2)
+'-'+substring(exedt,1,2)
+ ' ' + 
replace(
substring(exedt,9,2)+':'+substring(exedt,11,2)+':'+substring(exetime,13,2), '00:00:00', '00:00:00') else 
substring(exetime,5,4)+'-'+substring(exetime,3,2)+'-'+substring(exetime,1,2)+ ' ' + 
replace(
substring(exetime,9,2)+':'+substring(exetime,11,2)+':'+substring(exetime,13,2), '00:00:00', '00:00:00') end )

,case when cdshm_qty > 0 then 'C' else 'D' end                    
    FROM #tmp_cdsl_holding_dtls with(nolock) left outer join  #vw_fethob   on v_cdshm_dpam_id = cdshm_dpam_id 
      and v_cdshm_isin = cdshm_isin          
	  and v_cdshm_dpm_id = cdshm_dpm_id ,          
    #ACLIST account                            
    where   CDSHM_DPM_ID = @@dpmid            
    and CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate                      
    and (cdshm_tratm_cd in('2246','2277','2201','3102','2270','2220','2262','2251','2202','2205') or isnull(cdshm_charge,0) <> 0)          
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
		 insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val,settm_id , tr_settm_id)           
		 select distinct DPHMCD_DPAM_ID,            
		 DPAM_SBA_NAME,          
		 DPAM_SBA_NO,                      
		 trans_desc=--Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' +  Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),        
Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' 
						 + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_DEMAT_PND_VER_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_REMAT_PND_CONF_QTY ,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_DEMAT_PND_CONF_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_SAFE_KEEPING_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_ELIMINATION_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000))  + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000))  + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),   
		 TRANS_NO='',                      
		 trans_date='Dec 31 2100',                      
		 DPHMCD_ISIN,                      
		 0,            
		 0,          
		 3,  
		 0,        
		 0 ,'', right(isnull('','') ,7)                        
		 FROM #tmphldg with(nolock)  
		 ,account_group_mapping g with(nolock)              
		 ,#ACLIST account                    
		 WHERE           
		 DPHMCD_HOLDING_DT = @pa_todate-- @pa_prevfromdate  commented by Shilpa for holding not coming in bill
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
		 insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val,settm_id , tr_settm_id)           
		 select distinct DPHMCD_DPAM_ID,            
		 DPAM_SBA_NAME,          
		 DPAM_SBA_NO,                      
		 trans_desc=--Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' +  Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),
Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' 
						 + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_DEMAT_PND_VER_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_REMAT_PND_CONF_QTY ,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_DEMAT_PND_CONF_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_SAFE_KEEPING_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_ELIMINATION_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000))  + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000))  + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),   
		 TRANS_NO='',                      
		 trans_date='Dec 31 2100',                      
		 DPHMCD_ISIN,                      
		 isnull(DPHMCD_CURR_QTY,0),            
		 0,          
		 3,  
		 0,        
		 0    ,'',right(isnull('','') ,7)                         
		 FROM #tmphldg with(nolock),          
		 #ACLIST account                    
		 WHERE           
		 DPHMCD_HOLDING_DT = @pa_todate --@pa_prevfromdate   commented by Shilpa for holding not coming in bill
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
		 insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val,settm_id, tr_settm_id )           
		 select distinct DPHMCD_DPAM_ID,            
		 DPAM_SBA_NAME,          
		 DPAM_SBA_NO,                      
		 trans_desc=--Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),        
Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' 
						 + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_DEMAT_PND_VER_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_REMAT_PND_CONF_QTY ,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_DEMAT_PND_CONF_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_SAFE_KEEPING_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_ELIMINATION_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000))  + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000))  + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),   
		 TRANS_NO='',                      
		 trans_date='Dec 31 2100',                      
		 DPHMCD_ISIN,                      
		 isnull(DPHMCD_CURR_QTY,0),            
		 0,          
		 3,  
		 0,        
		 0  ,'', right(isnull('','') ,7)                             
		 FROM #tmphldg with(nolock)  
		 ,account_group_mapping g with(nolock)              
		 ,#ACLIST account                    
		 WHERE           
		 DPHMCD_HOLDING_DT =@pa_todate --@pa_prevfromdate   commented by Shilpa for holding not coming in bill        
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
		 insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val,settm_id , tr_settm_id)           
		 select distinct DPHMCD_DPAM_ID,            
		 DPAM_SBA_NAME,          
		 DPAM_SBA_NO,                      
		 trans_desc=--Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' +  Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),
Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' 
						 + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_DEMAT_PND_VER_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_REMAT_PND_CONF_QTY ,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_DEMAT_PND_CONF_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_SAFE_KEEPING_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_ELIMINATION_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000))  + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000))  + '|' 
						+ Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),   
		 TRANS_NO='',                      
		 trans_date='Dec 31 2100',                      
		 DPHMCD_ISIN,                      
		 isnull(DPHMCD_CURR_QTY,0),            
		 0,          
		 3,  
		 0,        
		 0   ,'', right(isnull('','') ,7)                   
		 FROM #tmphldg with(nolock),          
		 #ACLIST account                    
		 WHERE DPHMCD_HOLDING_DT = @pa_todate --@pa_prevfromdate   commented by Shilpa for holding not coming in bill          
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
print 'ss'
     print @pa_prevfromdate
 --select * from #tempmaincdsl
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
   AND  isnumeric(dpam_sba_no)=1 and eff_from BETWEEN  @pa_fromdate AND @pa_todate 
   and convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)   

   END 	

    set @@ssql ='insert into #ledgerBal
	select dpam_id,sum(case when ldg_voucher_type = 5 and ldg_voucher_dt >= ''' + convert(varchar(11),@pa_fromdate,109) + ''' then 0 else isnull(ldg_amount,0) * -1 end )
	from (
	select distinct dpam_id from #tempmaincdsl
	) tmp left outer join Ledger' + convert(varchar,@@Ledgerid) + ' on dpam_id = ldg_account_id and ldg_account_type = ''P'' and ldg_voucher_dt <= ''' + convert(varchar(11),@pa_todate,109) + ''' and ldg_deleted_ind = 1
	group by dpam_id'
	exec(@@ssql)

  
print @@l_grpmstr_cd
	if @@l_grpmstr_cd='N'
	begin  
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
	trans_date,isnull(settm_id,'') settm_id, isnull(tr_settm_id,'') tr_settm_id,tratm_cd,
	VALUATION=CONVERT(NUMERIC(18,2),convert(numeric(18,3),case when order_by = '3' then citrus_usr.fn_splitval_by(trans_desc,1,'|') else '0' end )*ISNULL(CLOPM_CDSL_RT,0))  
	,rate = ISNULL(CLOPM_CDSL_RT,0) 
	FROM #tempmaincdsl t with(nolock)
	LEFT OUTER JOIN  isin_mstr i with(nolock) on t.isin_cd = i.isin_cd
 LEFT OUTER JOIN CLOSING_PRICE_MSTR_CDSL ON t.isin_cd = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = t.isin_cd and CLOPM_DT <= @PA_TODATE and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)
		
	left outer join  #ledgerBal l on t.dpam_id = l.dpam_id
	--where t.dpam_id = l.dpam_id
order by dpam_acctno,dpam_sba_name,order_by,Isin_name,convert(datetime,trans_date),exedt,dpm_trans_no,c_d_flag 
	end
    else if @@l_grpmstr_cd='Y'
    begin
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
	trans_date,isnull(settm_id,'') settm_id, isnull(tr_settm_id,'') tr_settm_id,tratm_cd,
VALUATION=CONVERT(NUMERIC(18,2),convert(numeric(18,3),case when order_by = '3' then citrus_usr.fn_splitval_by(trans_desc,1,'|') else '0' end )*ISNULL(CLOPM_CDSL_RT,0))  
	,rate = ISNULL(CLOPM_CDSL_RT,0)
	FROM #tempmaincdsl t with(nolock)
	LEFT OUTER JOIN  isin_mstr i with(nolock) on t.isin_cd = i.isin_cd
LEFT OUTER JOIN CLOSING_PRICE_MSTR_CDSL ON t.isin_cd = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = t.isin_cd and CLOPM_DT <= @PA_TODATE and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)

	left outer join #ledgerBal l on t.dpam_id = l.dpam_id , group_mstr
	where  dpam_acctno = grp_client_code
	order by dpam_acctno,dpam_sba_name,order_by,Isin_name,convert(datetime,trans_date),exedt,dpm_trans_no,c_d_flag  

    end

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
		 where dpdhmd_dpam_id = a.dpam_id  and @pa_prevfromdate between eff_from and eff_to
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
