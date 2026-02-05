-- Object: PROCEDURE citrus_usr.Pr_rpt_statement_for_test02052012_closing_bak_01062016
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/*    
    
exec Pr_rpt_statement 'CDSL','3','Apr 14 2009','Aug 14 2009','N','N','','','','','Y','Y',1,'HO|*~|','','','',''    
     
exec Pr_rpt_statement 'CDSL','3','sep 01 2009','sep 16 2009','N','N','','','','','Y','Y',1,'HO|*~|','','','',''    
BEGIN TRAN    
exec [Pr_rpt_statement_for_test02052012] 'cdsl',3,'jun 14 2013','jun 17 2013','y','N','1201090000252513','1201090000252513'    
,'','','N','N',1,'HO|*~|','','','','Y',''    
ROLLBACK    
    
*/     
    
create Proc [citrus_usr].[Pr_rpt_statement_for_test02052012_closing_bak_01062016]                                
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
    
    --SELECT * FROM BK_STATEMENT_14OCT2013 
--RETURN
    
    
if @PA_SETTM_NO_TO = ''    
set @PA_SETTM_NO_TO   = @PA_SETTM_NO_FR       
    
 declare @@dpmid int,    
 @pa_prevfromdate datetime ,    
 @@l_child_entm_id      numeric ,    
 @@l_grpmstr_cd char(1)    
 ,@@bbocode varchar(10)    
 set @@bbocode = ''    
    
 set @@l_grpmstr_cd =  isnull(citrus_usr.fn_splitval(@pa_group_cd,2),'')      
 set @pa_group_cd =  isnull(citrus_usr.fn_splitval(@pa_group_cd,1),'')      
    
 set @@bbocode = isnull(citrus_usr.fn_splitval(@pa_settm_type,2),'')     
 set @pa_settm_type = isnull(citrus_usr.fn_splitval(@pa_settm_type,1),'')      
     
    
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

if @@bbocode <> ''    
begin    
select accp_value bbo , dpam_sba_no clientid     
into #bbocode from account_properties WITH (NOLOCK), dp_Acct_mstr  WITH (NOLOCK)    
where accp_accpm_prop_Cd='bbo_code'    
and accp_clisba_id = dpam_id     
and accp_value = @@bbocode    
    
if @@bbocode <> ''    
select @pa_fromaccid = min(clientid ) from #bbocode     
    
if @@bbocode <> ''    
select @pa_toaccid = max(clientid ) from #bbocode     
    
create clustered index ix_1 on #bbocode(clientid,bbo)    


    
end     
    
                       
                                      
  CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)    
    
  if @pa_stopbillclients_flag = 'Y'    
  begin    
 if @@bbocode <> ''    
 INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO,'dec 31 2100')     
-- FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) where dpam_stam_cd <> '02_BILLSTOP'     
--    and exists(select clientid,bbo from #bbocode where clientid = dpam_sba_no and bbo = case when @@bbocode <> '' then @@bbocode else bbo end )    
 --SELECT DPAM_ID,DPAM_SBA_NO,DPAM_SBA_NAME,EFF_FROM,isnull(EFF_TO,'dec 31 2900')     
   FROM CITRUS_USR.fn_acct_list_bytushar_bybbo(@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID,@PA_FROMACCID,@PA_TOACCID,@@bbocode) 
   where dpam_sba_no = @pa_fromaccid       
 --  return         
        
 if @@bbocode = ''    
 INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO,'dec 31 2100')     
 FROM citrus_usr.[fn_acct_list_bytushar](@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id,@PA_FROMACCID,@PA_TOACCID) where dpam_stam_cd <> '02_BILLSTOP'  
 and dpam_sba_no = @pa_fromaccid       
   
    --and exists(select clientid,bbo from #bbocode where clientid = dpam_sba_no and bbo = case when @@bbocode <> '' then @@bbocode else bbo end )    
        
  end     
  else    
  begin    
 if @@bbocode <> ''    
 INSERT INTO #ACLIST     
 SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO,'dec 31 2100')     
-- FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)      
--    where exists(select clientid,bbo from #bbocode where clientid = dpam_sba_no and bbo = case when @@bbocode <> '' then @@bbocode else bbo end )    
 FROM CITRUS_USR.fn_acct_list_bytushar_bybbo(@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID,@PA_FROMACCID,@PA_TOACCID,@@bbocode)        
  where dpam_sba_no = @pa_fromaccid 
      
 if @@bbocode = ''    
 
 INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO,'dec 31 2100') FROM citrus_usr.[fn_acct_list_bytushar](@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id,@PA_FROMACCID,@PA_TOACCID) 
      where dpam_stam_cd = '05'  and dpam_sba_no = @pa_fromaccid 
    --where exists(select clientid,bbo from #bbocode where clientid = dpam_sba_no and bbo = case when @@bbocode <> '' then @@bbocode else bbo end )    
  end     
    
     
--  create table #vw_fethob(v_cdshm_id numeric, v_cdshm_tras_dt datetime, v_CDSHM_DPM_ID numeric     
--   , v_CDSHM_DPAM_ID numeric,v_CDSHM_ISIN varchar(20),v_cdshm_opn_bal numeric(18,3)    
----   ,v_cdshm_trans_no varchar(150)    
--)    
--    
--    
--    
--  insert into #vw_fethob    
--  exec pr_get_ob @@dpmid,@pa_fromdate,@pa_todate,@pa_fromaccid,@pa_toaccid,''    
    
    
    
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
--   ,v_cdshm_trans_no varchar(150)    
)    
    
create index ic_ob on #vw_fethob(v_CDSHM_DPM_ID,v_CDSHM_DPAM_ID,v_CDSHM_ISIN)    
--     
--  insert into #vw_fethob    
--  exec pr_get_ob_fix @@dpmid,@pa_fromdate,@pa_todate,@pa_fromaccid,@pa_toaccid,''    
--    
    
    
if @@bbocode = ''     
begin 

  if @pa_isincd =''
  begin     
	insert into #vw_fethob    
	exec pr_get_ob_fix @@dpmid,@pa_fromdate,@pa_todate,@pa_fromaccid,@pa_toaccid,''    
  end 
  else 
  begin 
	insert into #vw_fethob    
	exec pr_get_ob_fix_byisin @@dpmid,@pa_fromdate,@pa_todate,@pa_fromaccid,@pa_toaccid,@pa_isincd,''    
  end 	
end     
else     
begin  
   
select distinct clientid into #ind_bbocode from #bbocode    
select identity(numeric,1,1) id , clientid into #ind_bbocode_id from #ind_bbocode    
    
declare @l_counter numeric    
declare @l_count numeric    
declare @l_acct_no varchar(16)    
select @l_count = count(1) from #ind_bbocode_id    
set @l_counter = 1     
set @l_acct_no = ''    
    
while @l_counter < = @l_count    
begin     
    
  select @l_acct_no = clientid from #ind_bbocode_id where id = @l_counter    
  PRINT @l_acct_no    
  
  if @l_acct_no  <> ''    
  begin 
	if @pa_isincd =''
	begin 
	insert into #vw_fethob    
	exec pr_get_ob_fix @@dpmid,@pa_fromdate,@pa_todate,@l_acct_no,@l_acct_no,''    
	end 
	else 
	begin 
	insert into #vw_fethob    
	exec pr_get_ob_fix_byisin @@dpmid,@pa_fromdate,@pa_todate,@l_acct_no,@l_acct_no,@pa_isincd,''    
	end 
  end 	
    
  set @l_acct_no  =''    
  set @l_counter  = @l_counter  + 1     
    
end     
end     
    
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
  
    
if @@bbocode = ''     
begin     
insert into #forstat_cdsl_holding_dtls     
select * from cdsl_holding_dtls WITH (NOLOCK)    
where CDSHM_TRAS_DT between @pa_fromdate AND  @pa_todate      
and cdshm_ben_acct_no between @pa_fromaccid and @pa_toaccid    
end     
else     
begin    
insert into #forstat_cdsl_holding_dtls     
select * from cdsl_holding_dtls WITH (NOLOCK)    
where CDSHM_TRAS_DT between @pa_fromdate AND  @pa_todate      
and cdshm_ben_acct_no in (select clientid from #bbocode)    
end     

create index ix_1 on #forstat_cdsl_holding_dtls(CDSHM_TRAS_DT,cdshm_ben_acct_no)

select * ,case when citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,16,'~') =  ''     
then REPLACE(CONVERT(VARCHAR(10), cdshm_tras_dt, 103), '/', '')+'000000' else citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,16,'~') end exedt    
,citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,9,'~') exetime into #tmp_cdsl_holding_dtls     
from #forstat_cdsl_holding_dtls WITH (NOLOCK)    
where CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate      
and cdshm_ben_acct_no between @pa_fromaccid and @pa_toaccid    
    
truncate table #forstat_cdsl_holding_dtls    
drop table #forstat_cdsl_holding_dtls    
    
--    
--    
--select * ,case when citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,16,'~') =  ''     
--then REPLACE(CONVERT(VARCHAR(10), cdshm_tras_dt, 103), '/', '')+'000000' else citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,16,'~') end exedt    
--,citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,9,'~') exetime into #tmp_cdsl_holding_dtls     
--from cdsl_holding_dtls WITH (NOLOCK)    
--where CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate      
--and cdshm_ben_acct_no between @pa_fromaccid and @pa_toaccid    
    
--select * from #tmp_cdsl_holding_dtls    
       
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
                                 
--  select @pa_prevfromdate = max(dphmcd_holding_dt) from DP_DAILY_HLDG_CDSL with(nolock) where dphmcd_holding_dt <= convert(varchar(11),@pa_todate,109)    
-- and DPHMCD_DPM_ID = @@dpmid    
           
                             
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
      ,account_group_mapping g with(nolock)                            
      ,#ACLIST account                                          
      where   CDSHM_DPM_ID = @@dpmid      
   and CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate                                        
      and cdshm_tratm_cd in('2246','2277','2201','3102','2270','2220','2262','2251','2202','2205','2280') --'2252'  --,'4456'  '2280', -add 2205    
      --  and cdshm_tratm_cd in('2246','2277','2201','2205','2220','3102','2252','2270','2280','2262','2251','3202','2202','2212')         
      and convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                   
  AND CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE ISNULL(CDSHM_SETT_TYPE,'') END = CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE @PA_SETTM_TYPE END    
         AND CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE ISNULL(CDSHM_SETT_NO,'') END BETWEEN CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_FR END and CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_To END
  
     
      and g.dpam_id = CDSHM_DPAM_ID                  
      and group_cd =  @pa_group_cd                   
      and CDSHM_DPAM_ID = account.dpam_id                                
      and (CDSHM_TRAS_DT between eff_from and eff_to)                            
      and cdshm_isin like @pa_isincd + '%'     
        
--union    
--select CDSHM_DPAM_ID,                            
--      DPAM_SBA_NAME,                            
--      CDSHM_BEN_ACCT_NO,                                        
--      CDSHM_TRATM_DESC= replace(DMTS_REJ_REASON,'        ','') ,    
--      CDSHM_TRANS_NO,                                        
--      CDSHM_TRAS_DT,                                        
--      CDSHM_ISIN,  '','',                                      
--      isnull(cdshm_opn_bal,0),                              
--      CDSHM_QTY,                            
--      0,                                      
--      CDSHM_ID ,''  ,cdshm_tratm_cd                                     
--      FROM #tmp_cdsl_holding_dtls with(nolock) LEFT OUTER JOIN  DMT_STATUS_MSTR ON  convert(numeric,CDSHM_TRANS_NO)= convert(numeric,DMTS_DMT_REQ_NO)                    
--      ,DP_ACCT_MSTR   account                                          
--      where   CDSHM_DPM_ID = @@dpmid                              
--    
--      AND CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate                                        
--      and cdshm_tratm_cd in('2251')                                        
--      and convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                                                                              
--      AND CDSHM_DPAM_ID = account.dpam_id                                
--      --and (CDSHM_TRAS_DT between eff_from and eff_to)                            
--      and cdshm_isin like '' + '%'            
                  
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
                   
                       
  if @pa_Hldg_Yn = 'Y'    
  begin    
                      
    if @pa_transclientsonly <> 'Y'                        
    begin                            
                        
   if @pa_group_cd <> ''                  
   begin                  
    insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,sett_type,sett_no,opening_bal,qty,order_by,dphmcd_cntr_settm_id)--,rate,valuation)                             
    select DPHMCD_DPAM_ID,                              
    DPAM_SBA_NAME,                            
    DPAM_SBA_NO,                                        
    --trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),            
                trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|'     
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
    DPHMCD_ISIN,'','',                                        
    0,                              
    0,                            
    1,    
                isnull('','')                                 dphmcd_cntr_settm_id    
--, 0 rate    
--,0 valuation    
    
    FROM #tmphldg with(nolock),                  
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
    
    insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,sett_type,sett_no,opening_bal,qty,order_by,CDSHM_TRG_SETTM_NO)--,rate,valuation)                             
    select DPHMCD_DPAM_ID,                              
    DPAM_SBA_NAME,                            
    DPAM_SBA_NO,                                        
    --trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),            
                trans_desc=    
--Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000))  + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),   
  
         
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
    DPHMCD_ISIN, '','',                                       
    0,                              
    0,                            
    1,    
                isnull('','')                                  dphmcd_cntr_settm_id    
--, 0 rate    
--,0 valuation    
    FROM #tmphldg with(nolock),                            
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
    insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,sett_type , sett_no ,opening_bal,qty,order_by,CDSHM_TRG_SETTM_NO)--,rate,valuation)                             
    select DPHMCD_DPAM_ID,                              
    DPAM_SBA_NAME,                            
    DPAM_SBA_NO,                                        
    --trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),            
                trans_desc=--Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000))  + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),            
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
    DPHMCD_ISIN, '','',                                       
    0,                              
    0,                            
    1,    
                isnull('','')                                 dphmcd_cntr_settm_id    
--, 0 rate    
--,0 valuation    
    FROM #tmphldg with(nolock),                  
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
    insert into #tempmaincdsl(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,sett_type, sett_no,opening_bal,qty,order_by,CDSHM_TRG_SETTM_NO)--,rate,valuation)                             
    select DPHMCD_DPAM_ID,                              
    DPAM_SBA_NAME,                            
    DPAM_SBA_NO,                                        
    --trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),            
                trans_desc=--Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000))  + '|' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + '|' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),            
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
    DPHMCD_ISIN,'','',                                        
    0,                              
    0,                            
    1,    
    isnull('','')                                 dphmcd_cntr_settm_id    
--, 0 rate    
--,0 valuation    
    FROM #tmphldg with(nolock),                            
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
   end     
   else if (@@l_grpmstr_cd='Y')    
   begin     
   select order_by,dpam_id,dpam_sba_name,dpam_acctno,                                        
   CDSHM_TRATM_DESC=replace(lower(ltrim(rtrim(ISNULL(trans_desc,'')))),dpm_trans_no,''),                                
   dpm_trans_no = dpm_trans_no  + case when isnull(easiflg,'0')='4' then ' : Easiest ' else '' end ,                            --+ case when isnull(easiflg,'0')='4' then ' : Easiest ' else '' end dpm_trans_no    
   trans_date=convert(varchar(11),trans_date,109),                                        
   t.ISIN_CD,isnull(t.sett_type,'') sett_type, isnull(t.sett_no,'') sett_no,    
   isin_name=isnull(isin_name,''),                                      
   opening_bal=Replace(convert(varchar,isnull(opening_bal,0)),'.000',''),                              
   --DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                                        
   --CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,   --commented on 19 jan
    DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE 0 END,                                        
    CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE 0 END,                         
   closing_bal = case when opening_bal = convert(numeric(18,3),0) and QTY <= convert(numeric(18,3),0)  then Replace(convert(varchar,convert(numeric(18,3),0)),'.000','') else Replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),'.000','') end 
,  
     
   --trans_date,    
   cdshm_trg_settm_no,    
   VALUATION=CONVERT(NUMERIC(18,2),convert(numeric(18,3),case when order_by = '1' then citrus_usr.fn_splitval_by(trans_desc,1,'|') else '0' end)*ISNULL(CLOPM_CDSL_RT,0)) ,rate = ISNULL(CLOPM_CDSL_RT,0)   , tratm_cd                                         
  
      
,case when order_by = 1 then --convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,1,'|'))    
         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,2,'|'))    
         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,3,'|'))    
         +convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,4,'|'))    
         --+convert(numeric(18,3),citrus_usr.fn_splitval_by(trans_desc,5,'|'))    
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
       
      
,group_mstr     
   where  dpam_acctno    =grp_client_code        
   --AND trans_date = @pa_todate   --and t.isin_cd = DPHMCd_ISIN     
   --order by dpam_acctno,dpam_sba_name,order_by,Isin_name,convert(datetime,trans_date),t.sett_no,dpm_trans_no,line_no,cdshm_trg_settm_no    
   order by dpam_acctno,dpam_sba_name,order_by,isin_cd,convert(datetime,trans_date),exedt,case when isnumeric(dpm_trans_no) = 1 then convert(numeric,dpm_trans_no) else 1 end,c_d_flag,cdshm_trg_settm_no           
   end    
      
  END    
  --    
  ELSE    
  BEGIN    
  --    
     
      if @@l_grpmstr_cd='N'     
      begin    
    
    
   select     
   order_by,dpam_id,dpam_sba_name,dpam_acctno,                                        
   CDSHM_TRATM_DESC=replace(lower(ltrim(rtrim(ISNULL(trans_desc,'')))),dpm_trans_no,''),                                
   dpm_trans_no  = dpm_trans_no  + case when isnull(easiflg,'0')='4' then ' : Easiest ' else '' end,                                        
   trans_date=convert(varchar(11),trans_date,109),                                        
   t.ISIN_CD,isnull(t.sett_type,'') sett_type, isnull(t.sett_no,'') sett_no,    
   isin_name=isnull(isin_name,''),                                      
   opening_bal=Replace(convert(varchar,isnull(opening_bal,0)),'.000',''),                              
   --DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                                        
   --CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,  --commented on 19th jan
      DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE 0 END,                                        
    CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE 0 END,                            
                          
   closing_bal = case when opening_bal = convert(numeric(18,3),0) and QTY <= convert(numeric(18,3),0)  then Replace(convert(varchar,convert(numeric(18,3),0)),'.000','') else Replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),'.000','') end ,
  
     
   --trans_date,    
   cdshm_trg_settm_no,tratm_cd                                                  
   FROM #tempmaincdsl t with(nolock) LEFT OUTER JOIN  isin_mstr i with(nolock) on t.isin_cd = i.isin_cd                                       
   --order by dpam_acctno,dpam_sba_name,order_by,Isin_name,convert(datetime,trans_date),dpm_trans_no,line_no,cdshm_trg_settm_no        
   order by dpam_acctno,dpam_sba_name,order_by,isin_cd,convert(datetime,trans_date),exedt,case when isnumeric(dpm_trans_no) = 1 then convert(numeric,dpm_trans_no) else 1 end ,c_d_flag,cdshm_trg_settm_no           
   end    
   else if (@@l_grpmstr_cd='Y')    
   begin    
   select order_by,dpam_id,dpam_sba_name,dpam_acctno,                                        
   CDSHM_TRATM_DESC=replace(lower(ltrim(rtrim(ISNULL(trans_desc,'')))),dpm_trans_no,''),                                
   dpm_trans_no=dpm_trans_no  + case when isnull(easiflg,'0')='4' then ' : Easiest ' else '' end,                                        
   trans_date=convert(varchar(11),trans_date,109),                                        
   t.ISIN_CD,isnull(t.sett_type,'') sett_type, isnull(t.sett_no,'') sett_no,    
   isin_name=isnull(isin_name,''),                                      
   opening_bal=Replace(convert(varchar,isnull(opening_bal,0)),'.000',''),                              
   --DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                                        
   --CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,      --commented on 19 jan
    DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE 0 END,                                        
   CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE 0 END,                         
   closing_bal = case when opening_bal = convert(numeric(18,3),0) and QTY <= convert(numeric(18,3),0)  then Replace(convert(varchar,convert(numeric(18,3),0)),'.000','') else Replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),'.000','') end ,
  
     
   --trans_date,    
   cdshm_trg_settm_no ,tratm_cd                                                 
   FROM #tempmaincdsl t with(nolock) LEFT OUTER JOIN  isin_mstr i with(nolock) on t.isin_cd = i.isin_cd ,group_mstr     
   where  dpam_acctno    =grp_client_code                                 
   order by dpam_acctno,dpam_sba_name,order_by,isin_cd,convert(datetime,trans_date),exedt,case when isnumeric(dpm_trans_no) = 1 then convert(numeric,dpm_trans_no) else 1 end,c_d_flag,cdshm_trg_settm_no           
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
            
     delete from #tempmainnsdl where Ben_acct_type not in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201
  
','203','213','101')                       
             
    
         
        
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
      delete from #tempmainnsdl where Ben_acct_type in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','
  
203','213')        
     
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
  set closing_qty = (select sum(isnull(qty,0)) from #temprunning t1 with(nolock) where t1.Runningid <= t.Runningid and t1.dpam_id =t.dpam_id and t1.Ben_ctgry = t.Ben_ctgry and t1.Ben_acct_type = t.Ben_acct_type and t1.isin_cd = t.isin_cd  and t1.sett_type
  
=t.sett_type and t1.sett_no = t.sett_no)                         
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
  --DEBIT_QTY= CASE WHEN QTY <= 0 THEN replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,                                        
  --CREDIT_QTY= CASE WHEN QTY > 0 THEN replace(convert(varchar,ABS(QTY)),'.000','') ELSE '' END,   --commented on 19 jan
   DEBIT_QTY= CASE WHEN  QTY <= 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE 0 END,                                        
   CREDIT_QTY= CASE WHEN QTY > 0 THEN Replace(convert(varchar,ABS(QTY)),'.000','') ELSE 0 END,                                  
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
