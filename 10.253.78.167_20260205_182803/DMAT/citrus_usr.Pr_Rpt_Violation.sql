-- Object: PROCEDURE citrus_usr.Pr_Rpt_Violation
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--[Pr_Rpt_Violation] 'NSDL',4,'JUL 20 2008','JUL 28 2008','','',1,'HO|*~|',''
CREATE Proc [citrus_usr].[Pr_Rpt_Violation]                
@pa_dptype varchar(4),                
@pa_excsmid int,                
@pa_fromdate datetime,                
@pa_todate datetime,                
@pa_fromaccid varchar(16),                
@pa_toaccid varchar(16),                
@pa_login_pr_entm_id numeric,                  
@pa_login_entm_cd_chain  varchar(8000),                  
@pa_output varchar(8000) output                  
as                
begin                
 declare @@dpmid int                
                 
 select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                
 declare @@l_child_entm_id      numeric                  
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                  
                 
 if @pa_fromaccid = ''                
 begin                
  set @pa_fromaccid = '0'                
  set @pa_toaccid = '99999999999999999'                
 end                  
                 
 if @pa_toaccid = ''                
 begin                
  set @pa_toaccid = @pa_fromaccid                
 end                
                
  CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)  
  
  INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)    
                 
 if (@pa_dptype = 'CDSL')                
 BEGIN                
      
    SELECT t.CDSHM_DPAM_ID,t.DPAM_SBA_NAME,t.CDSHM_BEN_ACCT_NO,t.SLIPNO
   ,t.CDSHM_TRANS_NO
   ,t.EXECUTION_DT,t.CDSHM_QTY,t.DR_QTY,t.CR_QTY,t.CDSHM_TRATM_DESC,t.CDSHM_TRATM_CD
   ,ISIN=CDSHM_ISIN,ISIN_NAME=ISNULL(ISIN_NAME,''),isnull(TRANSTYPE.DESCP,CDSHM_TRATM_CD) 
	FROM (       
    SELECT CDSHM_DPAM_ID,DPAM_SBA_NAME,CDSHM_BEN_ACCT_NO,CASE WHEN ISNULL(CDSHM_SLIP_NO,'')='' THEN '' ELSE CDSHM_SLIP_NO END SLIPNO ,CDSHM_TRANS_NO      
    ,EXECUTION_DT=CONVERT(VARCHAR(11),CDSHM_TRAS_DT,109),CDSHM_ISIN      
    ,CDSHM_QTY      
    ,DR_QTY = CASE WHEN CDSHM_QTY <= 0 THEN ABS(CDSHM_QTY) ELSE 0 END          
    ,CR_QTY = CASE WHEN CDSHM_QTY > 0 THEN  ABS(CDSHM_QTY) ELSE 0 END                 
    ,CDSHM_TRATM_DESC=replace(CDSHM_TRATM_DESC,'        ','')  
    ,CDSHM_TRATM_CD  ,  case when      CDSHM_QTY <= 0 THEN 0 ELSE 1 END ORD
    FROM       
    CDSL_HOLDING_DTLS      
    ,#ACLIST ACCOUNT      
    WHERE       
    CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate                
    AND isnumeric(CDSHM_BEN_ACCT_NO) = 1                  
    AND convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                 
    AND CDSHM_DPAM_ID = ACCOUNT.DPAM_ID                  
    AND (CDSHM_TRAS_DT between EFF_FROM and EFF_TO)  
	) t  left outer join  DP_TRX_DTLS_CDSL on  
	CDSHM_TRANS_NO = DPTDC_TRANS_NO        
    AND   EXECUTION_DT = DPTDC_EXECUTION_DT      
    AND   CDSHM_TRATM_CD = DPTDC_TRASTM_CD       
    AND   CDSHM_DPAM_ID = DPTDC_DPAM_ID  
    AND   CDSHM_ISIN = DPTDC_ISIN       	
	,ISIN_MSTR,citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_CDSL') TRANSTYPE 
	WHERE DPTDC_ID IS NULL AND CDSHM_ISIN = ISIN_CD AND CDSHM_TRATM_CD = TRANSTYPE.CD   
    ORDER BY T.ORD , EXECUTION_DT,CDSHM_BEN_ACCT_NO,DPAM_SBA_NAME,ISIN_NAME,SLIPNO   
   
 END                
 ELSE                
 BEGIN                
    create table #l_temp(ttype_cd varchar(5),cd varchar(5),descp varchar(50))                 
                  
    insert into #l_temp                
    SELECT  Trans_type=ltrim(rtrim(Replace(trantm_code, 'TRANS_STAT_NSDL_',''))),TRASTM_CD AS CD,TRASTM_DESC AS DESCP                   
    FROM  TRANSACTION_TYPE_MSTR,                  
    TRANSACTION_SUB_TYPE_MSTR                  
    WHERE TRANTM_CODE like  'TRANS_STAT_NSDL_%'                
    AND TRANTM_ID   =  TRASTM_TRATM_ID                
                  
    insert into #l_temp                
    select ttype.cd,stat.* from citrus_usr.FN_GETSUBTRANSDTLS('RES_STAT_CD_NSDL') stat,                
    citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_NSDL') ttype    

                  
    /*    
        
     SELECT DPAM_SBA_NAME,ISIN_NAME,DPAM_SBA_NO,CASE WHEN ISNULL(CODD_SLIP_NO,'')='' THEN '' ELSE CODD_SLIP_NO END SLIPNO ,CODD_TRX_NO,CODD_TRX_TYP,CODD_STATUS_CHNG_DTTIME,CODD_ISIN,CODD_QTY,CODD_ORD_STATUS_TO,CODD_CANC_STATUS_TO      
     FROM       
     @l_temp C        
     right outer join COD_DTLS ON CODD_TRX_TYP= C.TTYPE_CD and CODD_CANC_STATUS_TO = C.CD      
     left outer join @l_temp T on CODD_TRX_TYP= T.TTYPE_CD and CODD_ORD_STATUS_TO = T.CD,      
     citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_NSDL') TRANSTYPE,       
     #ACLIST account,      
     ISIN_MSTR                
     WHERE        
     CODD_STATUS_CHNG_DTTIME >= @pa_fromdate AND CODD_STATUS_CHNG_DTTIME <=@pa_todate    
     AND CODD_CLT_ID = account.DPAM_SBA_NO     
     AND CODD_ISIN = ISIN_CD              
     AND ISNUMERIC(DPAM_SBA_NO) = 1              
     AND convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)         
     AND ISNULL(CODD_LST_R,0) = 1       
     AND CODD_TRX_TYP = TRANSTYPE.CD         
     AND NOT EXISTS       
     (SELECT DPTD_TRANS_NO,DPTD_EXECUTION_DT,DPTD_TRASTM_CD,DPTD_DPAM_ID,DPTD_ISIN      
   FROM DP_TRX_DTLS      
   WHERE DPTD_TRANS_NO = CODD_TRX_NO      
   AND   CONVERT(VARCHAR(11),DPTD_EXECUTION_DT,103) = CONVERT(VARCHAR(11),CODD_STATUS_CHNG_DTTIME,103)      
   AND   DPTD_TRASTM_CD = CODD_TRX_TYP      
   AND   DPTD_DPAM_ID  = account.DPAM_ID      
   AND   DPTD_ISIN     = CODD_ISIN      
     )       
     AND CODD_DELETED_IND = 1           
     ORDER BY DPAM_SBA_NO,DPAM_SBA_NAME,CODD_STATUS_CHNG_DTTIME,CODD_TRX_NO   
	*/     

	 SELECT t.*,isin_name,CODD_TRX_TYP=ISNULL(TRANSTYPE.DESCP,COD_TRX_TYP) FROM (   
     SELECT dpam_id,DPAM_SBA_NAME,DPAM_SBA_NO,CASE WHEN ISNULL(CODD_SLIP_NO,'')='' THEN '' ELSE CODD_SLIP_NO END SLIPNO ,CODD_TRX_NO,COD_TRX_TYP=CODD_TRX_TYP,CODD_STATUS_CHNG_DTTIME,CODD_ISIN,CODD_QTY,CODD_ORD_STATUS_TO=ISNULL(T.DESCP,CODD_ORD_STATUS_TO),CODD_CANC_STATUS_TO =ISNULL(C.DESCP,CODD_CANC_STATUS_TO)     
     FROM       
     #l_temp C        
     right outer join COD_DTLS ON CODD_TRX_TYP= C.TTYPE_CD and CODD_CANC_STATUS_TO = C.CD      
     left outer join #l_temp T on CODD_TRX_TYP= T.TTYPE_CD and CODD_ORD_STATUS_TO = T.CD,      
     #ACLIST account        
     WHERE        
     CODD_STATUS_CHNG_DTTIME >= @pa_fromdate AND CODD_STATUS_CHNG_DTTIME <=@pa_todate    
     AND CODD_CLT_ID = account.DPAM_SBA_NO     
     AND ISNUMERIC(DPAM_SBA_NO) = 1              
     AND convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)
	 AND (CODD_STATUS_CHNG_DTTIME between EFF_FROM and EFF_TO)          
     AND ISNULL(CODD_LST_R,0) = 1       
     ) t left outer join  DP_TRX_DTLS on   
	 CONVERT(VARCHAR(11),DPTD_EXECUTION_DT,103) = CONVERT(VARCHAR(11),CODD_STATUS_CHNG_DTTIME,103) 
     AND DPTD_DPAM_ID  = t.DPAM_ID      
	 AND DPTD_ISIN     = CODD_ISIN      
	 AND DPTD_TRANS_NO = CODD_TRX_NO        
	 AND DPTD_TRASTM_CD = COD_TRX_TYP
     ,ISIN_MSTR,citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_NSDL') TRANSTYPE        
	 where DPTD_ID IS NULL 
	 AND CODD_ISIN = ISIN_CD  
	 AND COD_TRX_TYP = TRANSTYPE.CD
     and TRANSTYPE.CD  in ('901','902' ,'904','926','934','906','907'    )    
	 ORDER BY DPAM_SBA_NO,DPAM_SBA_NAME,CODD_STATUS_CHNG_DTTIME,CODD_TRX_NO   


      
   TRUNCATE TABLE #l_temp  
   DROP TABLE #l_temp    
      
 END               
  
   TRUNCATE TABLE #ACLIST  
   DROP TABLE #ACLIST    
                 
END

GO
