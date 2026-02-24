-- Object: PROCEDURE citrus_usr.pr_make_chart
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--[pr_make_chart] 'CLI_MAK','NSDL','06/05/2008','06/08/2008',1,'0','HO|*~|',4,''
CREATE procedure [citrus_usr].[pr_make_chart]    
(@PA_TAB varchar(25)    
,@PA_DP_TYPE VARCHAR(10)    
,@PA_FROM_DT VARCHAR(11)    
,@PA_TO_DT VARCHAR(11)    
,@pa_login_pr_entm_id numeric    
,@PA_FROM_ACCT  VARCHAR(16)    
,@pa_login_entm_cd_chain  varchar(8000)    
,@pa_excsmid   INT    
,@pa_output    varchar(20) OUT  
)    
as    
begin    
--    
create TABLE  #temp(VALUE numeric,NAME varchar(25),ord int)
declare @@dpmid int                              
DECLARE @L_CUR_DATE DATETIME    
SET @L_CUR_DATE  = GETDATE()     
select @@dpmid= dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                              
declare @@l_child_entm_id      numeric                          
select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                          
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)      
CREATE INDEX IX_2 on #ACLIST (DPAM_ID)  
INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)        
  
  IF   @PA_TAB = 'CATEGORYWISE_CLIENT'    
  BEGIN    
  --    
  
    SELECT DISTINCT SUBCM_DESC NAME, COUNT(A.DPAM_ID) VALUE    
    FROM DP_ACCT_MSTR A, SUB_CTGRY_MSTR   , #ACLIST B    
    WHERE A.DPAM_ID = B.DPAM_ID     
    AND   DPAM_SUBCM_CD = SUBCM_CD    
    and (GETDATE() between eff_from and eff_to)                        
    GROUP BY SUBCM_DESC    
  --    
  END    
  IF   @PA_TAB = 'STATUSWISE_CLIENT'    
  BEGIN    
  --    
    SELECT DISTINCT STAM_DESC NAME , COUNT(a.DPAM_ID) VALUE    
    FROM DP_ACCT_MSTR A, STATUS_MSTR M, #ACLIST B    
    WHERE A.DPAM_ID = B.DPAM_ID     
    AND   a.DPAM_STAM_CD = STAM_CD    
    and (GETDATE() between eff_from and eff_to)                        
    GROUP BY STAM_DESC    
  --    
  END    
  IF   @PA_TAB = 'ENTITYWISE_CLIENT'    
  BEGIN    
  --    
    SELECT DISTINCT ENTM_NAME1 NAME, COUNT(ENTR_SBA) VALUE    
    FROM  ENTITY_RELATIONSHIP A, ENTITY_MSTR , #ACLIST B     
    WHERE A.ENTR_SBA = B.dpam_sba_no     
    AND ENTR_AR = ENTM_ID     
    AND   ENTM_ENTTM_CD = 'BR'    
    and (GETDATE() between eff_from and eff_to)                        
    GROUP BY ENTM_NAME1     
  --    
  END    
  IF   @PA_TAB = 'HOLDINGWISE_CLIENT'    
  BEGIN    
  --

    IF @PA_DP_TYPE ='NSDL'    
    BEGIN    
    SELECT --replace(replace(replace(replace(ISIN_NAME,'(',''),')',''),'.',''),'-','') 
          replace(replace(ISIN_NAME,'''',''),'&','') NAME , SUM(A.dpdhmd_qty) VALUE  FROM     
   (SELECT dpdhmd_isin,dpdhmd_qty FROM CITRUS_USR.fn_dailyholding(@@dpmid,@L_CUR_DATE,@PA_FROM_ACCT,@PA_FROM_ACCT,'','',@pa_login_pr_entm_id,@@l_child_entm_id)) A    
    , ISIN_MSTR     
    WHERE A.dpdhmd_isin = ISIN_CD    
    GROUP BY ISIN_NAME    
    END    
    ELSE    
    BEGIN    
      SELECT   replace(replace(ISIN_NAME,'''',''),'&','') NAME ,SUM(DPHMC_CURR_QTY) VALUE FROM DP_HLDG_MSTR_CDSL, #ACLIST , ISIN_MSTR WHERE DPAM_ID = DPHMC_DPAM_ID AND   DPHMC_ISIN = ISIN_CD AND dpam_sba_no =  @PA_FROM_ACCT GROUP BY ISIN_NAME    
    END    
        
  --    
  END    
  IF   @PA_TAB = 'HOLDINGWISE_DP'    
  BEGIN    
  --    
    IF @PA_DP_TYPE ='NSDL'    
    BEGIN    
    SELECT   replace(replace(ISIN_NAME,'''',''),'&','') NAME , SUM(dpdhmd_qty) VALUE FROM (SELECT dpdhmd_isin,dpdhmd_qty FROM CITRUS_USR.fn_dailyholding(@@dpmid,@L_CUR_DATE,'','','','',@pa_login_pr_entm_id,@@l_child_entm_id) ) A    
    , ISIN_MSTR     
    WHERE dpdhmd_isin = ISIN_CD    
    GROUP BY ISIN_NAME    
    END    
    ELSE    
    BEGIN    
      SELECT   replace(replace(ISIN_NAME,'''',''),'&','') NAME ,SUM(DPHMC_CURR_QTY) VALUE FROM DP_HLDG_MSTR_CDSL, #ACLIST , ISIN_MSTR WHERE DPAM_ID = DPHMC_DPAM_ID AND    DPHMC_ISIN = ISIN_CD GROUP BY ISIN_NAME    
    END    
  --    
  END    
  IF   @PA_TAB = 'INSTRUCTIONWISE'    
  BEGIN    
  --    
    
    IF @PA_DP_TYPE ='NSDL'    
    BEGIN    

    insert into #temp
    select count(*) VALUE, 'MAKER ENTERED' NAME, 1 ORD from dptd_mak where dptd_deleted_ind in (0,1) and dptd_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103)
    union
    select count(*) VALUE , 'CHECKER APPROVED' NAME, 2 ORD from DP_TRX_DTLS where dptd_deleted_ind = 1 and dptd_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103)
    UNION
    select count(*) VALUE , 'BATCH GENERATED' NAME, 3 ORD from DP_TRX_DTLS where dptd_deleted_ind = 1 and dptd_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103) AND ISNULL(DPTD_BATCH_NO,'') <> ''
    UNION
    select count(*) VALUE , 'RESPONSE UPDATED' NAME, 4  ORD from DP_TRX_DTLS where dptd_deleted_ind = 1 and dptd_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103) AND ISNULL(DPTD_BATCH_NO,'') <> '' AND ISNULL(DPTD_STATUS,'') <> 'P'

   --
   end
   else
   begin
     insert into #temp
    select count(*) VALUE, 'MAKER ENTERED' NAME, 1 ORD from dptdc_mak where dptdc_deleted_ind in (0,1) and dptdc_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103)
    union
    select count(*) VALUE , 'CHECKER APPROVED' NAME, 2 ORD from DP_TRX_DTLS_cdsl where dptdc_deleted_ind = 1 and dptdc_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103)
    UNION
    select count(*) VALUE , 'BATCH GENERATED' NAME, 3 ORD from DP_TRX_DTLS_cdsl where dptdc_deleted_ind = 1 and dptdc_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103) AND ISNULL(DPTDc_BATCH_NO,'') <> ''
    UNION
    select count(*) VALUE , 'RESPONSE UPDATED' NAME, 4  ORD from DP_TRX_DTLS_cdsl where dptdc_deleted_ind = 1 and dptdc_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103) AND ISNULL(DPTDc_BATCH_NO,'') <> '' AND ISNULL(DPTDc_STATUS,'') <> 'P'

   end

   SELECT  NAME,VALUE FROM #temp ORDER BY ORD DESC
  --    
  END   
   IF   @PA_TAB = 'CLI_MAK' 
  BEGIN    
  --    
    


    insert into #temp
    select count(*) VALUE, 'MAKER ENTERED' NAME, 1 ORD from DP_ACCT_MSTR_MAK where dpam_deleted_ind in (0,1) and dpam_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103)
    union
    select count(*) VALUE , 'CHECKER APPROVED' NAME, 2 ORD from DP_ACCT_MSTR where dpam_deleted_ind = 1 and dpam_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103)
    UNION
    select count(*) VALUE , 'BATCH GENERATED' NAME, 3 ORD from DP_ACCT_MSTR where dpam_deleted_ind = 1 and dpam_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103) AND ISNULL(DPAM_BATCH_NO,'0') <> '0'
    

   SELECT  NAME,VALUE FROM #temp ORDER BY ORD DESC
  --    
  END    

 
 
      
   TRUNCATE TABLE #ACLIST    
   DROP TABLE #ACLIST    
       
--    
end

GO
