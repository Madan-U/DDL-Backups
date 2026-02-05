-- Object: PROCEDURE citrus_usr.Pr_rpt_statement_for_test02052012_closing
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*    
    
exec Pr_rpt_statement 'CDSL','3','Apr 14 2009','Aug 14 2009','N','N','','','','','Y','Y',1,'HO|*~|','','','',''    
     
exec Pr_rpt_statement 'CDSL','3','sep 01 2009','sep 16 2009','N','N','','','','','Y','Y',1,'HO|*~|','','','',''    
BEGIN TRAN    
exec [Pr_rpt_statement_for_test02052012] 'cdsl',3,'jun 14 2013','jun 17 2013','y','N','1201090000252513','1201090000252513'    
,'','','N','N',1,'HO|*~|','','','','Y',''    
ROLLBACK    
    
*/     
    
CREATE Proc [citrus_usr].[Pr_rpt_statement_for_test02052012_closing]                                
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
 ,@@bbocode varchar(10)    
     
    
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
    
        
        
    
 INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO,'dec 31 2100')     
 FROM citrus_usr.[fn_acct_list_bytushar](@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id,@PA_FROMACCID,@PA_TOACCID) 
 where dpam_stam_cd ='05' 
 and dpam_sba_no = @pa_fromaccid       
         
 
    
create table #vw_fethob(v_CDSHM_DPM_ID numeric     
   , v_CDSHM_DPAM_ID numeric,v_CDSHM_ISIN varchar(20),v_cdshm_opn_bal numeric(18,3)    
    
)    
    
create index ic_ob on #vw_fethob(v_CDSHM_DPM_ID,v_CDSHM_DPAM_ID,v_CDSHM_ISIN)    

    
     
insert into #vw_fethob    
exec pr_get_ob_fix @@dpmid,@pa_fromdate,@pa_todate,@pa_fromaccid,@pa_toaccid,''    
    
 
  
    
CREATE TABLE #forstat_cdsl_holding_dtls(  
 [CDSHM_DPM_ID] [numeric](18, 0) NULL,  
 [CDSHM_BEN_ACCT_NO] [varchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_DPAM_ID] [numeric](10, 0) NULL,  
 [CDSHM_TRATM_CD] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_TRATM_DESC] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_TRAS_DT] [datetime] NULL,  
 [CDSHM_ISIN] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_QTY] [numeric](18, 5) NULL,  
 [CDSHM_INT_REF_NO] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_TRANS_NO] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_SETT_TYPE] [varchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_SETT_NO] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_COUNTER_BOID] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_COUNTER_DPID] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_COUNTER_CMBPID] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_EXCM_ID] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_TRADE_NO] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_CREATED_BY] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_CREATED_DT] [datetime] NULL,  
 [CDSHM_LST_UPD_BY] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_LST_UPD_DT] [datetime] NULL,  
 [CDSHM_DELETED_IND] [smallint] NULL,  
 [cdshm_slip_no] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [cdshm_tratm_type_desc] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [cdshm_internal_trastm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_BAL_TYPE] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [cdshm_id] [numeric](10, 0) NULL,  
 [cdshm_opn_bal] [numeric](18, 5) NULL,  
 [cdshm_charge] [numeric](10, 5) NULL,  
 [CDSHM_DP_CHARGE] [numeric](10, 5) NULL,  
 [CDSHM_TRG_SETTM_NO] [varchar](13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [WAIVE_FLAG] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [cdshm_trans_cdas_code] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_CDAS_TRAS_TYPE] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [CDSHM_CDAS_SUB_TRAS_TYPE] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,  
 [cdshm_post_toacct] [numeric](18, 0) NULL  
)   
  
    
   
insert into #forstat_cdsl_holding_dtls     
select * from cdsl_holding_dtls WITH (NOLOCK)    
where CDSHM_TRAS_DT between @pa_fromdate AND  @pa_todate      
and cdshm_ben_acct_no =@pa_fromaccid    

create index ix_1 on #forstat_cdsl_holding_dtls(CDSHM_TRAS_DT,cdshm_ben_acct_no)

select * ,case when citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,16,'~') =  ''     
then REPLACE(CONVERT(VARCHAR(10), cdshm_tras_dt, 103), '/', '')+'000000' else citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,16,'~') end exedt    
,citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,9,'~') exetime into #tmp_cdsl_holding_dtls     
from #forstat_cdsl_holding_dtls WITH (NOLOCK)    
where CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate      
and cdshm_ben_acct_no between @pa_fromaccid and @pa_toaccid    
      
    

       

     
                        
 IF (@pa_dptype = 'CDSL')                                        
 BEGIN                                  
  
           
                             
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
    cdshm_trg_settm_no varchar(13),tratm_cd varchar(25) ,exedt datetime  ,c_d_flag char(1)      
--,rate numeric    
--,valuation numeric     
,easiflg                       numeric    
    )                                
                             
                             
  if @pa_group_cd <> ''                  
  begin      
      
      
      
      insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd ,sett_type ,sett_no  ,opening_bal,qty,order_by,line_no,cdshm_trg_settm_no,tratm_cd,exedt,c_d_flag,easiflg)--,rate,valuation)                      
  
       
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
--, 0 rate    
--, 0 valuation    
,citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,41,'~')    
      FROM #tmp_cdsl_holding_dtls with(nolock)     
   left outer join  #vw_fethob   on v_cdshm_dpam_id = cdshm_dpam_id     
      and v_cdshm_isin = cdshm_isin                   
    and v_cdshm_dpm_id = cdshm_dpm_id     
                              
      ,#ACLIST account                                          
      where   CDSHM_DPM_ID = @@dpmid      
   and CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate                                        
      and cdshm_tratm_cd in('2246','2277','2201','3102','2270','2220','2262','2251','2202','2205','2280') --'2252'  --,'4456'  '2280', -add 2205    
      --  and cdshm_tratm_cd in('2246','2277','2201','2205','2220','3102','2252','2270','2280','2262','2251','3202','2202','2212')         
      and convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                  
                           
      and CDSHM_DPAM_ID = account.dpam_id                                
      and (CDSHM_TRAS_DT between eff_from and eff_to)                            
      and cdshm_isin like @pa_isincd + '%'     
        
        
                  
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
      ,opening_bal,qty,order_by,line_no,cdshm_trg_settm_no,tratm_cd,exedt,c_d_flag,easiflg)--,rate,valuation)                             
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
-- ,0 rate    
--, 0 valuation    
,citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,41,'~')                                   
      FROM #tmp_cdsl_holding_dtls with(nolock)     
   left outer join  #vw_fethob   on v_cdshm_dpam_id = cdshm_dpam_id     
      and v_cdshm_isin = cdshm_isin              
   and v_cdshm_dpm_id = cdshm_dpm_id     
  ,#ACLIST account                                  
      where   CDSHM_DPM_ID = @@dpmid      
   AND CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate                                        
      and cdshm_tratm_cd in('2246','2277','2201','3102','2270','2220','2262','2251','2202','2205','2280')       --,'2252','4456' '2280', -- 2205 added                                
      --and cdshm_tratm_cd in('2246','2277','2201','2205','2220','3102','2252','2270','2280','2262','2251','3202','2202','2212')         
      and convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                                                                 
   AND CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE ISNULL(CDSHM_SETT_TYPE,'') END = CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE @PA_SETTM_TYPE END    
      AND CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE ISNULL(CDSHM_SETT_NO,'') END BETWEEN CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_FR END and CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_To END  
   
      AND CDSHM_DPAM_ID = account.dpam_id                                
      and (CDSHM_TRAS_DT between eff_from and eff_to)                            
      and cdshm_isin like @pa_isincd + '%'             
     
          
  end         
    
      
--changed by tushar sep 18 2009    
delete from   #tempmaincdsl    
where      
tratm_cd not in ('2246','2277','3102','2201','2270','2220','2262','2251','2202','2205','2280') --,'2252','4456' '2280',--added 2205    
--tratm_cd not in ('2246','2277','2201','2205','2220','3102','2252','2270','2280','2262','2251','3202','2202','2212')         
    
and    trans_desc like '%demat%'    
and    exists     
(select CDSHM_BEN_ACCT_NO , CDSHM_TRANS_NO, CDSHM_ISIN, CDSHM_QTY     
from #tmp_cdsl_holding_dtls where CDSHM_BEN_ACCT_NO = dpam_acctno    
and CDSHM_TRANS_NO = dpm_trans_no and isin_cd =CDSHM_ISIN and qty =  CDSHM_QTY    
--and cdshm_tratm_cd in('2246','2277','2280','3102','2201','2270','2220','2262','2251','2202','2252','4456') )     
and cdshm_tratm_cd in('2246','2277','3102','4456') )     
--and cdshm_tratm_cd in ('2246','2277','2201','2205','2220','3102','2252','2270','2280','2262','2251','3202','2202','2212') )        
--changed by tushar sep 18 2009        
                   
                       
  IF @PA_WITHVALUE = 'Y'  --ADDED BY JITESH ON 16-APR-2010    
  BEGIN    
  
     --            
     
   select order_by,dpam_id,dpam_sba_name,dpam_acctno,                                        
   CDSHM_TRATM_DESC=replace(lower(ltrim(rtrim(ISNULL(trans_desc,'')))),dpm_trans_no,''),                                
   dpm_trans_no = dpm_trans_no  + case when isnull(easiflg,'0')='4' then ' : Easiest ' else '' end  ,                               
   trans_date=convert(varchar(11),trans_date,109),                                        
   t.ISIN_CD,isnull(t.sett_type,'') sett_type, isnull(t.sett_no,'') sett_no,    
   isin_name=isnull(isin_name,''),                                      
   opening_bal=Replace(convert(varchar,isnull(opening_bal,0)),'.000',''),                              
  -- DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                                        
  -- CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END, --commented on 19 jan
   DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE 0 END,                                        
   CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE 0 END,                            
         closing_bal = case when opening_bal = convert(numeric(18,3),0) and QTY <= convert(numeric(18,3),0)  then Replace(convert(varchar,convert(numeric(18,3),0)),'.000','') else Replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),'.000','' 
 
) end ,     
   --trans_date,    
   cdshm_trg_settm_no,    
   VALUATION=CONVERT(NUMERIC(18,2),convert(numeric(18,3),case when order_by = '1' then citrus_usr.fn_splitval_by(trans_desc,1,'|') else '0' end )*ISNULL(CLOPM_CDSL_RT,0))      
  ,rate = ISNULL(CLOPM_CDSL_RT,0)     
  ,tratm_cd     
  ,case when order_by = 1 then --convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,1,'|'))    
         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,2,'|'))    
         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,3,'|'))    
         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,4,'|'))    
        -- +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,5,'|'))    
         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,6,'|'))    
         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,7,'|'))    
        -- +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,8,'|'))    
         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,9,'|'))    
--         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,10,'|'))    
--         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,11,'|'))    
--         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,12,'|'))    
--         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,13,'|'))    
--         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc+'|',14,'|'))    
       else '0' end totalhldg                                                
   FROM  #tempmaincdsl t with(nolock) LEFT OUTER JOIN  isin_mstr i with(nolock) on t.isin_cd = i.isin_cd     
   LEFT OUTER JOIN CLOSING_PRICE_MSTR_CDSL ON t.isin_cd = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = t.isin_cd and CLOPM_DT <= @PA_TODATE and CLOPM_DELETED_IND = 1  order by
  
 CLOPM_DT desc)    
       
      
   --WHERE DPHMCD_HOLDING_DT = @pa_todate-- and t.dpam_id = DPHMCd_dpam_id    
   --order by dpam_acctno,dpam_sba_name,order_by,Isin_name,convert(datetime,trans_date),t.sett_no,dpm_trans_no,line_no,cdshm_trg_settm_no    
   order by dpam_acctno,dpam_sba_name,order_by,isin_cd,convert(datetime,trans_date),exedt,case when isnumeric(dpm_trans_no) = 1 then convert(numeric,dpm_trans_no) else 1 end  ,c_d_flag,cdshm_trg_settm_no           
   
      
  END    
  --    
                
 
  TRUNCATE TABLE #tempmaincdsl    
     drop table #tempmaincdsl                         
--                            
 END                                        
                                        
                      
END                                        
--transaction statement

GO
