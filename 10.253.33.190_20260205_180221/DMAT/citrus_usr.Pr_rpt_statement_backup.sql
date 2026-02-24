-- Object: PROCEDURE citrus_usr.Pr_rpt_statement_backup
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*

exec Pr_rpt_statement 'CDSL','3','Apr 14 2009','Aug 14 2009','N','N','','','','','Y','Y',1,'HO|*~|','','','',''
 
exec Pr_rpt_statement 'CDSL','3','sep 01 2009','sep 16 2009','N','N','','','','','Y','Y',1,'HO|*~|','','','',''
BEGIN TRAN
exec Pr_rpt_statement 'cdsl',3,'Apr 14 2009','Jul  1 2009','N','N','','','','','N','y',1,'HO|*~|','','','','Y',''
ROLLBACK

*/ 

create Proc [citrus_usr].[Pr_rpt_statement_backup]                            
@pa_dptype varchar(4),                                    
@pa_excsmid int,                                    
@pa_fromdate datetime,                                    
@pa_todate datetime, 
@pa_bulk_printflag char(1), --Y/N
@pa_stopbillclients_flag char(1), --Y/N                                   
@pa_fromaccid varchar(16),                                    
@pa_toaccid varchar(16),                                    
@pa_isincd varchar(12),              
@pa_group_cd varchar(10),                     
@pa_transclientsonly char(1),   
@pa_Hldg_Yn char(1),                                 
@pa_login_pr_entm_id numeric,                                      
@pa_login_entm_cd_chain  varchar(8000) ,    
@pa_settm_type  varchar(80) ,    
@pa_settm_no_fr  varchar(80) ,                      
@pa_settm_no_to  varchar(80),
@PA_WITHVALUE CHAR(1), --Y/N
@pa_output varchar(8000) output                                      
AS                                    
BEGIN                                    
                             
 set nocount on                       
 set transaction isolation level read uncommitted                           




if @PA_SETTM_NO_TO = ''
set @PA_SETTM_NO_TO   = @PA_SETTM_NO_FR   

 declare @@dpmid int,
 @pa_prevfromdate datetime ,
 @@l_child_entm_id      numeric ,
 @@l_grpmstr_cd char(1)

set @@l_grpmstr_cd =  isnull(citrus_usr.fn_splitval(@pa_group_cd,2),'')  
set @pa_group_cd =  isnull(citrus_usr.fn_splitval(@pa_group_cd,1),'')  

 set @pa_settm_type  = case when @pa_settm_type ='0' then  '' else  @pa_settm_type  end 

 SELECT @pa_settm_type = SETTM_TYPE FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) = @pa_settm_type             AND SETTM_DELETED_IND = 1

 set @pa_settm_type = case when @pa_settm_type ='0' then  '' else  @pa_settm_type  end 

 select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                                    
 
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                                      
                              
 IF @pa_fromaccid = ''                                    
 BEGIN                                    
 SET @pa_fromaccid = '0'                                    
 SET @pa_toaccid = '99999999999999999'                                    
 END                                    
 IF @pa_toaccid = ''                                    
 BEGIN                                
 SET @pa_toaccid = @pa_fromaccid                                    
 END                                    
                                  
  CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)

  if @pa_stopbillclients_flag = 'Y'
  begin
	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) where dpam_stam_cd <> '02_BILLSTOP'		
  end 
  else
  begin
	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		
  end 



if @@l_grpmstr_cd='Y'
begin 
delete from #ACLIST where dpam_sba_no not in (select grp_client_code from group_mstr)
end

 if @pa_bulk_printflag = 'Y'
 begin
		delete A from #ACLIST A,blk_client_print_dtls 
		where dpam_id = blckpd_dpam_id and blkcpd_dpmid = @@dpmid
		and blkcpd_rptname = 'TRANSACTION'
 end


                    
 IF (@pa_dptype = 'CDSL')                                    
 BEGIN                              
                             
 	select @pa_prevfromdate = max(dphmcd_holding_dt) from DP_DAILY_HLDG_CDSL with(nolock) where dphmcd_holding_dt <= convert(varchar(11),@pa_todate,109)
	and DPHMCD_DPM_ID = @@dpmid
       
                         
    create table #tempmaincdsl                            
    (                        
    dpam_id bigint,                          
    dpam_sba_name varchar(200),                        
    dpam_acctno varchar(16),                          
    trans_desc varchar(200),                            
    dpm_trans_no varchar(10),                            
    trans_date datetime,                            
    isin_cd varchar(12),  
    sett_type varchar(50),    
	sett_no varchar(10),                            
    opening_bal numeric(19,3),                        
    qty numeric(19,3),                        
    order_by int,        
    line_no bigint,
    cdshm_trg_settm_no varchar(13),tratm_cd varchar(25)                            
    )                            
                         
                         
  if @pa_group_cd <> ''              
  begin  
  
              
      insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd ,sett_type ,sett_no  ,opening_bal,qty,order_by,line_no,cdshm_trg_settm_no,tratm_cd)                         
      select CDSHM_DPAM_ID,                        
      DPAM_SBA_NAME,                        
      CDSHM_BEN_ACCT_NO,                                    
      CDSHM_TRATM_DESC=replace(CDSHM_TRATM_DESC,'        ',''),                            
      CDSHM_TRANS_NO,                                    
      CDSHM_TRAS_DT,                                    
      CDSHM_ISIN, CDSHM_SETT_TYPE  ,CDSHM_SETT_NO,                                 
      isnull(v_cdshm_opn_bal,0),                          
      CDSHM_QTY,                        
      0,                                  
      CDSHM_ID,
      isnull(cdshm_trg_settm_no,'')  ,cdshm_tratm_cd      
      FROM CDSL_HOLDING_DTLS with(nolock) 
 left outer join  vw_fethob    on v_cdshm_id = cdshm_id 
and v_cdshm_dpam_id = cdshm_dpam_id 
and v_cdshm_tras_dt = cdshm_tras_dt
and v_cdshm_isin = cdshm_isin               
      ,account_group_mapping g with(nolock)                        
      ,#ACLIST account                                      
      where   CDSHM_DPM_ID = @@dpmid  
      and CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate                                    
      and cdshm_tratm_cd in('2246','2277','2280','2201','3102')     
      and convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)               
		AND CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE ISNULL(CDSHM_SETT_TYPE,'') END = CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE @PA_SETTM_TYPE END
         AND CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE ISNULL(CDSHM_SETT_NO,'') END BETWEEN CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_FR END and CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_To END	
      and g.dpam_id = CDSHM_DPAM_ID              
      and group_cd =  @pa_group_cd               
      and CDSHM_DPAM_ID = account.dpam_id                            
      and (CDSHM_TRAS_DT between eff_from and eff_to)                        
      and cdshm_isin like @pa_isincd + '%' 
	   
union
select CDSHM_DPAM_ID,                        
      DPAM_SBA_NAME,                        
      CDSHM_BEN_ACCT_NO,                                    
      CDSHM_TRATM_DESC= replace(DMTS_REJ_REASON,'        ','') ,
      CDSHM_TRANS_NO,                                    
      CDSHM_TRAS_DT,                                    
      CDSHM_ISIN,                                    
      isnull(cdshm_opn_bal,0),                          
      CDSHM_QTY,                        
      0,                                  
      CDSHM_ID   ,cdshm_tratm_cd                                 
      FROM CDSL_HOLDING_DTLS with(nolock) LEFT OUTER JOIN  DMT_STATUS_MSTR ON  convert(numeric,CDSHM_TRANS_NO)= convert(numeric,DMTS_DMT_REQ_NO)                
      ,DP_ACCT_MSTR   account                                      
      where   CDSHM_DPM_ID = @@dpmid                          
      AND CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate                                    
      and cdshm_tratm_cd in('2251')                                    
      and convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                                                                          
      AND CDSHM_DPAM_ID = account.dpam_id                            
      --and (CDSHM_TRAS_DT between eff_from and eff_to)                        
      and cdshm_isin like '' + '%'        
              
  end              
  else              
  begin    
  
        
      insert into #tempmaincdsl(dpam_id
      ,dpam_sba_name
      ,dpam_acctno
      ,trans_desc
      ,dpm_trans_no
      ,trans_date
      ,isin_cd
      ,sett_type,sett_no
      ,opening_bal,qty,order_by,line_no,cdshm_trg_settm_no,tratm_cd)                         
      select CDSHM_DPAM_ID,                        
      DPAM_SBA_NAME,                        
      CDSHM_BEN_ACCT_NO,                                    
      CDSHM_TRATM_DESC=replace(CDSHM_TRATM_DESC,'        ',''),                            
      CDSHM_TRANS_NO,                                    
      CDSHM_TRAS_DT,                                    
      CDSHM_ISIN, 
      CDSHM_SETT_TYPE , CDSHM_SETT_NO,                                  
      isnull(v_cdshm_opn_bal,0),                          
      CDSHM_QTY,                        
      0,                                  
      CDSHM_ID,
      isnull(cdshm_trg_settm_no,''),cdshm_tratm_cd                                    
      FROM CDSL_HOLDING_DTLS with(nolock)
left outer join  vw_fethob    on v_cdshm_id = cdshm_id 
and v_cdshm_dpam_id = cdshm_dpam_id 
and v_cdshm_tras_dt = cdshm_tras_dt
and v_cdshm_isin = cdshm_isin          

,     #ACLIST account                              
                          
      where   CDSHM_DPM_ID = @@dpmid  
      AND CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate                                    
      and cdshm_tratm_cd in('2246','2277','2280','2201','3102')                                    
      and convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                                                             
	  AND CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE ISNULL(CDSHM_SETT_TYPE,'') END = CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE @PA_SETTM_TYPE END
      AND CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE ISNULL(CDSHM_SETT_NO,'') END BETWEEN CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_FR END and CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_To END	
      AND CDSHM_DPAM_ID = account.dpam_id                            
      and (CDSHM_TRAS_DT between eff_from and eff_to)                        
      and cdshm_isin like @pa_isincd + '%'         

    
  end     


       
--changed by tushar sep 18 2009
delete from   #tempmaincdsl
where  tratm_cd not in ('2246','2277','2280','3102','2201') 
and    trans_desc like '%demat%'
and    exists 
(select CDSHM_BEN_ACCT_NO , CDSHM_TRANS_NO, CDSHM_ISIN, CDSHM_QTY 
from CDSL_HOLDING_DTLS where CDSHM_BEN_ACCT_NO = dpam_acctno
and CDSHM_TRANS_NO = dpm_trans_no and isin_cd =CDSHM_ISIN and qty =  CDSHM_QTY
and cdshm_tratm_cd in('2246','2277','2280','3102','2201') ) 
--changed by tushar sep 18 2009    
                 
                   
  if @pa_Hldg_Yn = 'Y'
  begin
                  
		  if @pa_transclientsonly <> 'Y'                    
		  begin                        
		                  
			if @pa_group_cd <> ''              
			begin              
				insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,sett_type,sett_no,opening_bal,qty,order_by,dphmcd_cntr_settm_id)                         
				select DPHMCD_DPAM_ID,                          
				DPAM_SBA_NAME,                        
				DPAM_SBA_NO,                                    
				trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),        
				TRANS_NO='',                                    
				trans_date='Dec 31 2100',                                    
				DPHMCD_ISIN,'','',                                    
				0,                          
				0,                        
				1,
                isnull(dphmcd_cntr_settm_id,'')                                 
				FROM [vw_fetchclientholding] with(nolock),              
				account_group_mapping g with(nolock),              
				#ACLIST account                            
				WHERE                   
				DPHMCD_HOLDING_DT = @pa_todate                        
				and DPHMCD_ISIN like @pa_isincd + '%'                            
				and isnumeric(DPAM_SBA_NO) = 1                                     
				and convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)              
				and g.dpam_id = DPHMCD_dpam_id              
				and group_cd =  @pa_group_cd              
				AND DPHMCD_dpam_id = account.dpam_id                            
				and (DPHMCD_HOLDING_DT between eff_from and eff_to)                        
				and DPHMCD_dpm_id = @@dpmid 
				and isnull(DPHMCD_CURR_QTY,0) <> 0                   
			end              
			else              
			begin              
				insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,sett_type,sett_no,opening_bal,qty,order_by,CDSHM_TRG_SETTM_NO)                         
				select DPHMCD_DPAM_ID,                          
				DPAM_SBA_NAME,                        
				DPAM_SBA_NO,                                    
				trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),        
				TRANS_NO='',                                    
				trans_date='Dec 31 2100',                                    
				DPHMCD_ISIN, '','',                                   
				0,                          
				0,                        
				1,
                isnull(dphmcd_cntr_settm_id,'')                                 
				FROM [vw_fetchclientholding] with(nolock),                        
				#ACLIST account                             
				WHERE                         
				DPHMCD_HOLDING_DT = @pa_todate                     
				and DPHMCD_ISIN like @pa_isincd + '%'                            
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
				insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,sett_type , sett_no ,opening_bal,qty,order_by,CDSHM_TRG_SETTM_NO)                         
				select DPHMCD_DPAM_ID,                          
				DPAM_SBA_NAME,                        
				DPAM_SBA_NO,                                    
				trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),        
				TRANS_NO='',                                    
				trans_date='Dec 31 2100',                                    
				DPHMCD_ISIN, '','',                                   
				0,                          
				0,                        
				1,
                isnull(dphmcd_cntr_settm_id,'')                                 
				FROM [vw_fetchclientholding] with(nolock),              
				account_group_mapping g with(nolock),              
				#ACLIST account                         
				WHERE                         
				DPHMCD_HOLDING_DT = @pa_todate                        
				and DPHMCD_ISIN like @pa_isincd + '%'                            
				and EXISTS(SELECT DPAM_ID FROM #tempmaincdsl T1 with(nolock) WHERE T1.DPAM_ID = DPHMCD_DPAM_ID)                                    
				and isnumeric(DPAM_SBA_NO) = 1                                     
				and convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)              
				and g.dpam_id = DPHMCD_dpam_id              
				and group_cd =  @pa_group_cd              
				AND DPHMCD_dpam_id = account.dpam_id              
				and (DPHMCD_HOLDING_DT between eff_from and eff_to)                        
				and DPHMCD_dpm_id = @@dpmid 
				and isnull(DPHMCD_CURR_QTY,0) <> 0            
			end              
			else              
			begin              
				insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,sett_type, sett_no,opening_bal,qty,order_by,CDSHM_TRG_SETTM_NO)                         
				select DPHMCD_DPAM_ID,                          
				DPAM_SBA_NAME,                        
				DPAM_SBA_NO,                                    
				trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),        
				TRANS_NO='',                                    
				trans_date='Dec 31 2100',                                    
				DPHMCD_ISIN,'','',                                    
				0,                          
				0,                        
				1,
				isnull(dphmcd_cntr_settm_id,'')                                 
				FROM [vw_fetchclientholding] with(nolock),                        
				#ACLIST account                             
				WHERE                         
				DPHMCD_HOLDING_DT = @pa_todate                     
				and DPHMCD_ISIN like @pa_isincd + '%'                            
				and EXISTS(SELECT DPAM_ID FROM #tempmaincdsl T1 with(nolock) WHERE T1.DPAM_ID = DPHMCD_DPAM_ID)                                    
				and isnumeric(DPAM_SBA_NO) = 1                         
				and convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                                                             
				AND DPHMCD_dpam_id = account.dpam_id                            
				and (DPHMCD_HOLDING_DT between eff_from and eff_to)                        
				and DPHMCD_dpm_id = @@dpmid 
				and isnull(DPHMCD_CURR_QTY,0) <> 0
		                
			end                         
		  end          
     end 


	 IF @PA_WITHVALUE = 'Y'  --ADDED BY JITESH ON 16-APR-2010
	 BEGIN
     --        
	     if @@l_grpmstr_cd='N' 
	     begin      
		 select order_by,dpam_id,dpam_sba_name,dpam_acctno,                                    
		 CDSHM_TRATM_DESC=replace(lower(ltrim(rtrim(ISNULL(trans_desc,'')))),dpm_trans_no,''),                            
		 dpm_trans_no,                                    
		 trans_date=convert(varchar(11),trans_date,109),                                    
		 t.ISIN_CD,isnull(t.sett_type,'') sett_type, isnull(t.sett_no,'') sett_no,
		 isin_name=isnull(isin_name,''),                                  
		 opening_bal=Replace(convert(varchar,isnull(opening_bal,0)),'.000',''),                          
		 DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                                    
		 CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                        
		 closing_bal = Replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),'.000',''),
		 trans_date,cdshm_trg_settm_no,
		 VALUATION=CONVERT(NUMERIC(18,2),DPHMCd_CURR_QTY*ISNULL(CLOPM_CDSL_RT,0))                                              
		 FROM [vw_fetchclientholding] LEFT OUTER JOIN  isin_mstr i with(nolock) on DPHMCd_ISIN = i.isin_cd 
		 LEFT OUTER JOIN CLOSING_PRICE_MSTR_CDSL ON DPHMCd_ISIN = CLOPM_ISIN_CD 
		 AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = DPHMCd_ISIN and CLOPM_DT <= @PA_FROMDATE and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc),
		 #tempmaincdsl t with(nolock)
		 WHERE DPHMCD_HOLDING_DT = @pa_todate    
		 order by dpam_acctno,dpam_sba_name,order_by,Isin_name,trans_date,line_no,cdshm_trg_settm_no
		 end 
		 else if (@@l_grpmstr_cd='Y')
		 begin 
		 		 select order_by,dpam_id,dpam_sba_name,dpam_acctno,                                    
		 CDSHM_TRATM_DESC=replace(lower(ltrim(rtrim(ISNULL(trans_desc,'')))),dpm_trans_no,''),                            
		 dpm_trans_no,                                    
		 trans_date=convert(varchar(11),trans_date,109),                                    
		 t.ISIN_CD,isnull(t.sett_type,'') sett_type, isnull(t.sett_no,'') sett_no,
		 isin_name=isnull(isin_name,''),                                  
		 opening_bal=Replace(convert(varchar,isnull(opening_bal,0)),'.000',''),                          
		 DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                                    
		 CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                        
		 closing_bal = Replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),'.000',''),
		 trans_date,cdshm_trg_settm_no,
		 VALUATION=CONVERT(NUMERIC(18,2),DPHMC_CURR_QTY*ISNULL(CLOPM_CDSL_RT,0))                                              
		 FROM [vw_fetchclientholding] LEFT OUTER JOIN  isin_mstr i with(nolock) on DPHMCd_ISIN = i.isin_cd 
		 LEFT OUTER JOIN CLOSING_PRICE_MSTR_CDSL ON DPHMCd_ISIN = CLOPM_ISIN_CD 
		 AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = DPHMCd_ISIN and CLOPM_DT <= @PA_FROMDATE and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc),
		 #tempmaincdsl t with(nolock),group_mstr 
		 where  dpam_acctno    =grp_client_code    
		 AND DPHMCD_HOLDING_DT = @pa_todate    
		 order by dpam_acctno,dpam_sba_name,order_by,Isin_name,trans_date,line_no,cdshm_trg_settm_no
		 end
	 
	 END
	 --
	 ELSE
	 BEGIN
	 --
	 print @@l_grpmstr_cd
	     if @@l_grpmstr_cd='N' 
	     begin
		 select order_by,dpam_id,dpam_sba_name,dpam_acctno,                                    
		 CDSHM_TRATM_DESC=replace(lower(ltrim(rtrim(ISNULL(trans_desc,'')))),dpm_trans_no,''),                            
		 dpm_trans_no,                                    
		 trans_date=convert(varchar(11),trans_date,109),                                    
		 t.ISIN_CD,isnull(t.sett_type,'') sett_type, isnull(t.sett_no,'') sett_no,
		 isin_name=isnull(isin_name,''),                                  
		 opening_bal=Replace(convert(varchar,isnull(opening_bal,0)),'.000',''),                          
		 DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                                    
		 CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                        
		 closing_bal = Replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),'.000',''),
		 trans_date,cdshm_trg_settm_no                                              
		 FROM #tempmaincdsl t with(nolock) LEFT OUTER JOIN  isin_mstr i with(nolock) on t.isin_cd = i.isin_cd                                   
		 order by dpam_acctno,dpam_sba_name,order_by,Isin_name,trans_date,line_no,cdshm_trg_settm_no    
		 end
		 else if (@@l_grpmstr_cd='Y')
		 begin
		 select order_by,dpam_id,dpam_sba_name,dpam_acctno,                                    
		 CDSHM_TRATM_DESC=replace(lower(ltrim(rtrim(ISNULL(trans_desc,'')))),dpm_trans_no,''),                            
		 dpm_trans_no,                                    
		 trans_date=convert(varchar(11),trans_date,109),                                    
		 t.ISIN_CD,isnull(t.sett_type,'') sett_type, isnull(t.sett_no,'') sett_no,
		 isin_name=isnull(isin_name,''),                                  
		 opening_bal=Replace(convert(varchar,isnull(opening_bal,0)),'.000',''),                          
		 DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                                    
		 CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                        
		 closing_bal = Replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),'.000',''),
		 trans_date,cdshm_trg_settm_no                                              
		 FROM #tempmaincdsl t with(nolock) LEFT OUTER JOIN  isin_mstr i with(nolock) on t.isin_cd = i.isin_cd ,group_mstr 
		 where  dpam_acctno    =grp_client_code                             
		 order by dpam_acctno,dpam_sba_name,order_by,Isin_name,trans_date,line_no,cdshm_trg_settm_no    		 
		 end           
	 END	        
	 --
	 TRUNCATE TABLE #tempmaincdsl
     drop table #tempmaincdsl                     
--                        
 END                                    
 ELSE                                    
 BEGIN                              
                            
                            
	select @pa_prevfromdate = max(dpdhmd_holding_dt) 
from DP_DAILY_HLDG_NSDL with(nolock) where dpdhmd_holding_dt < @pa_fromdate
and DPDHMD_DPM_ID = @@dpmid
                      
                         
	 create table #tempmainnsdl                            
	 (                            
	 trans_date datetime,                            
	 dpam_id bigint,                            
	 dpam_acctno varchar(16),                          
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
	 line_no bigint    , CMBP_ID   varchar(100),CC_ID   varchar(100)
	 )                            
                         
                              
   if @pa_group_cd <> ''              
   begin                              
    insert into #tempmainnsdl                           
    select DISTINCT NSDHM_TRANSACTION_DT,NSDHM_dpam_id,NSDHM_BEN_ACCT_NO,dpam_sba_name,NSDHM_ISIN,nsdhm_sett_type,nsdhm_sett_no,CONVERT(NUMERIC,nsdhm_dpm_trans_no),NSDHM_QTY,                            
    NSDHM_BOOK_NAAR_CD,NSDHM_BOOK_TYPE,NSDHM_BEN_CTGRY,NSDHM_BEN_ACCT_TYPE,                        
    TRANS_DESC=isnull(NSDHM_TRN_DESCP,'')                    
    ,0,NSDHM_LN_NO  ,  NSDHM_COUNTER_CMBP_ID,NSDHM_CC_ID                         
    from NSDL_HOLDING_DTLS with(nolock),              
    account_group_mapping g with(nolock),                                    
    #ACLIST account                                  
    where                         
    nsdhm_dpm_id = @@dpmid                                    
    and NSDHM_TRANSACTION_DT >=@pa_fromdate AND NSDHM_TRANSACTION_DT <=@pa_todate                                     
    and isnumeric(NSDHM_BEN_ACCT_NO) = 1                                      
    and convert(numeric,NSDHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                                     
    and g.dpam_id = NSDHM_dpam_id           
    and group_cd =  @pa_group_cd                
    and NSDHM_dpam_id = account.dpam_id    
    AND CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE ISNULL(nsdhm_sett_type,'') END = CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE @PA_SETTM_TYPE END
    AND CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE ISNULL(nsdhm_sett_no,'') END BETWEEN CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_FR END and CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_To END	
    and (NSDHM_TRANSACTION_DT between eff_from and eff_to)             
    and NSDHM_ISIN like @pa_isincd + '%'               
  end              
  else              
  begin     
print @PA_SETTM_TYPE
       
    insert into #tempmainnsdl                           
    select DISTINCT NSDHM_TRANSACTION_DT,NSDHM_dpam_id,NSDHM_BEN_ACCT_NO,dpam_sba_name,NSDHM_ISIN,nsdhm_sett_type,nsdhm_sett_no,CONVERT(NUMERIC,nsdhm_dpm_trans_no),NSDHM_QTY,                            
    NSDHM_BOOK_NAAR_CD,NSDHM_BOOK_TYPE,NSDHM_BEN_CTGRY,NSDHM_BEN_ACCT_TYPE,                        
    TRANS_DESC=isnull(NSDHM_TRN_DESCP,'')                    
    ,0,NSDHM_LN_NO  , NSDHM_COUNTER_CMBP_ID ,NSDHM_CC_ID               
    from NSDL_HOLDING_DTLS with(nolock),                                    
    #ACLIST account                                  
    where                         
    nsdhm_dpm_id = @@dpmid                                    
    and NSDHM_TRANSACTION_DT >=@pa_fromdate AND NSDHM_TRANSACTION_DT <=@pa_todate                                     
    and isnumeric(NSDHM_BEN_ACCT_NO) = 1                                      
    and convert(numeric,NSDHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)  
    AND CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE ISNULL(nsdhm_sett_type,'') END = CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE @PA_SETTM_TYPE END
    AND CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE ISNULL(nsdhm_sett_no,'') END BETWEEN CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_FR END and CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_To END	
                                   
    and NSDHM_dpam_id = account.dpam_id                                      
    and (NSDHM_TRANSACTION_DT between eff_from and eff_to)                          
    and NSDHM_ISIN like @pa_isincd + '%'               
  end              
                          
                      
      
    --for non pool accounts     
        
     delete from #tempmainnsdl where Ben_acct_type not in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213','101')                   
         

     
    
     update m set final_trans = 1,sett_type='',sett_no=''                  
     from #tempmainnsdl m                  
     where Ben_acct_type not in('20','30','40') and convert(int,m.book_narr_cd) = isnull((select max(convert(int,book_narr_cd)) from #tempmainnsdl m1 where m.dpm_trans_no = m1.dpm_trans_no and m.isin_cd = m1.isin_cd and m.dpam_id = m1.dpam_id and m.Ben_acct_type = m1.Ben_acct_type ),0)               
    

	--added for demat & remat pending transactions 
	update #tempmainnsdl set final_trans = 1,sett_type='',sett_no='' where Ben_acct_type in('12','13') 
	--added for demat & remat pending transactions

    --For bonus account
    update #tempmainnsdl set final_trans = 1,sett_type='',sett_no='' where Ben_acct_type in('14') and book_narr_cd='088'
    --For bonus account
 
    --For pledge credit account
    update #tempmainnsdl set final_trans = 1,sett_type='',sett_no='' where Ben_acct_type in('14','11') and book_narr_cd='091'
    --For pledge credit account
 
    --for non pool accounts                
    
     -- for pool accounts    
      delete from #tempmainnsdl where Ben_acct_type in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213')    
 
      update #tempmainnsdl set final_trans = 1 where  Ben_acct_type in('20','30','40') and  sett_type <> '00'    
     -- for pool accounts       
          
          

                    
  if @pa_Hldg_Yn ='Y'
  begin                   
                    
	   if @pa_transclientsonly = 'Y'                    
	   BEGIN                    
		 insert into #tempmainnsdl                            
		 select @pa_prevfromdate,dpdhmd_dpam_id,dpam_sba_no,dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,null,sum(dpdhmd_qty),null,null,dpdhmd_benf_cat,dpdhmd_benf_acct_typ,'*',2,null ,'',''   
		 from fn_dailyholding(@@dpmid,@pa_prevfromdate,@pa_fromaccid,@pa_toaccid,@pa_isincd,@pa_group_cd,@pa_login_pr_entm_id,@@l_child_entm_id)                          
		 where exists(select dpam_id from #tempmainnsdl with(nolock) where dpam_id = dpdhmd_dpam_id)  
         AND CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE ISNULL(dpdhmd_sett_type,'') END = CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE @PA_SETTM_TYPE END
         AND CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE ISNULL(DPDHMD_SETT_NO,'') END BETWEEN CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_FR END and CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_To END	
                             
		 group by dpdhmd_dpam_id,dpam_sba_no,dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,dpdhmd_benf_cat,dpdhmd_benf_acct_typ                             
	   END                    
	   ELSE                    
	   BEGIN              

		 insert into #tempmainnsdl                            
		 select @pa_prevfromdate,dpdhmd_dpam_id,h.dpam_sba_no,h.dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,null,sum(dpdhmd_qty),null,null,dpdhmd_benf_cat,dpdhmd_benf_acct_typ,'*',2,null   ,'','' 
		 from fn_dailyholding(@@dpmid,@pa_prevfromdate,@pa_fromaccid,@pa_toaccid,@pa_isincd,@pa_group_cd,@pa_login_pr_entm_id,@@l_child_entm_id) h, #ACLIST a
		 where h.dpdhmd_dpam_id = a.dpam_id
         AND     @pa_prevfromdate BETWEEN EFF_FROM AND EFF_TO                       
         AND CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE ISNULL(dpdhmd_sett_type,'') END = CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE @PA_SETTM_TYPE END
         AND CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE ISNULL(DPDHMD_SETT_NO,'') END BETWEEN CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_FR END and CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_To END	
        
		 group by dpdhmd_dpam_id,h.dpam_sba_no,h.dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,dpdhmd_benf_cat,dpdhmd_benf_acct_typ                             
	   END                      
   end                           
     -- for pool accounts    
      delete from #tempmainnsdl where Ben_acct_type in('20','30','40') and sett_type = '00'    
     -- for pool accounts 
   --for non pool accounts 

       update #tempmainnsdl set sett_type='',sett_no='' where final_trans = 2 and Ben_acct_type not in('20','30','40')
     --for non pool accounts                         
                         
 Create table #temprunning(              
 Runningid bigint identity(1,1),              
 trans_date datetime,                            
 dpam_id bigint,                            
 dpam_acctno char(8),                          
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
 line_no bigint,   CMBP_ID   varchar(100)  ,CC_ID VARCHAR(100),
 closing_qty numeric(18,3)          
 )              
                
 CREATE INDEX IX_1 on #temprunning(dpam_id,Ben_ctgry,Ben_acct_type,isin_cd)                         
              
              
  insert into #temprunning                      
  select m.*,closing_qty=0.000                            
  from #tempmainnsdl m where final_trans > 0                            
  order by dpam_id,isin_cd,Ben_ctgry,Ben_acct_type,sett_type,sett_no,trans_date,line_no,dpm_trans_no,Book_Narr_cd    
       




            
                       


  update t                             
  set closing_qty = (select sum(isnull(qty,0)) from #temprunning t1 with(nolock) where t1.Runningid <= t.Runningid and t1.dpam_id =t.dpam_id and t1.Ben_ctgry = t.Ben_ctgry and t1.Ben_acct_type = t.Ben_acct_type and t1.isin_cd = t.isin_cd  and t1.sett_type=t.sett_type and t1.sett_no = t.sett_no)                     
  from #temprunning t with(nolock)                           
           

--           
--  update t                             
--  set closing_qty = closing_qty + isnull((select sum(isnull(NSDHM_QTY,0)) from NSDL_HOLDING_DTLS t1 with(nolock) where t1.NSDHM_TRANSACTION_DT < @pa_fromdate and t1.NSDHM_DPAM_ID =t.dpam_id and t1.NSDHM_BEN_CTGRY = t.Ben_ctgry and t1.NSDHM_BEN_ACCT_TYPE = t.Ben_acct_type and t1.NSDHM_ISIN = t.isin_cd  and t1.NSDHM_SETT_TYPE=t.sett_type and t1.NSDHM_SETT_NO = t.sett_no)                     ,0)
--  from #temprunning t with(nolock) 




  delete t from #temprunning t with(nolock)                        
  where exists(select dpam_id,isin_cd from #temprunning t1 with(nolock)                        
  where t.dpam_id = t1.dpam_id and t1.Ben_ctgry = t.Ben_ctgry and t1.Ben_acct_type = t.Ben_acct_type and t.isin_cd = t1.isin_cd and t1.trans_desc <> '*')                         
  and t.trans_desc='*'                        
                        

                       
  select final_trans,dpam_id,dpam_sba_name,NSDHM_BEN_ACCT_NO=dpam_acctno,ben_type=ltrim(rtrim(isnull(ben.descp,Ben_acct_type) + ' ' + case when sett_type <> '' then isnull(s.settm_desc,sett_type) + '/' + sett_no  else '' end )),dpm_trans_no=ISNULL(dpm_trans_no,''),                                    
  --TRANS_DESC=ltrim(rtrim(isnull(TRANS_DESC,''))),     
  CMBPID =  case when isnull(CMBP_ID,'') <> '' then CMBP_ID else '' end + case when isnull(CC_ID,'') <> '' then '/'+ CC_ID else '' end ,                      
  TRANS_DESC = Replace(Replace(ltrim(rtrim(isnull(TRANS_DESC,''))),'By cm - nsccl-cc','By Pay-In'),'To nsccl – cc','To Pay-In '),                            
  NSDHM_TRANSACTION_DT=convert(varchar(11),trans_date,109),                                    
  NSDHM_ISIN=t.isin_cd,                                    
  Isin_name=isnull(Isin_name,t.isin_cd),                             
  open_qty = replace(convert(varchar,CASE WHEN FINAL_TRANS = 2 THEN closing_qty ELSE closing_qty - qty END),'.000',''),                                  
  DEBIT_QTY= CASE WHEN QTY <= 0 THEN replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                                    
  CREDIT_QTY= CASE WHEN QTY > 0 THEN replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                              
  closing_qty= replace(convert(varchar,closing_qty),'.000',''),
  trans_date, settm_desc ,sett_no 
  from #temprunning t with(nolock)     
  left outer join isin_mstr i with(nolock) on t.isin_cd = i.isin_cd    
  left outer join settlement_type_mstr s on t.sett_type = s.settm_type and isnull(s.settm_type,'') <> '' and s.settm_deleted_ind = 1 ,                       
  citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') ben            
  WHERE t.Ben_acct_type = ben.cd                     
  order by dpam_acctno,final_trans,Isin_name,sett_no,Runningid,15                        

  TRUNCATE TABLE #tempmainnsdl
  TRUNCATE TABLE #temprunning              
  drop table #tempmainnsdl            
  drop table #temprunning                        
                                    
 END                                    
               
      TRUNCATE TABLE #ACLIST
	  DROP TABLE #ACLIST                      
END                                    
--transaction statement

GO
