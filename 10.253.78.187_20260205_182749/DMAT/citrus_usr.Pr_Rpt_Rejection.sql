-- Object: PROCEDURE citrus_usr.Pr_Rpt_Rejection
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

-- Pr_Rpt_Rejection 'CDSL',3,'Jan 08 2008','','','A',1,'0',''       
-- Pr_Rpt_Rejection 'NSDL',4,'dec 27 2007','','','O',1,'O',''      
-- Pr_Rpt_Rejection 'NSDL',4,'dec 27 2007','','','A',1,'O',''      
CREATE Proc [citrus_usr].[Pr_Rpt_Rejection]                    
@pa_dptype varchar(4),                    
@pa_excsmid int,                    
@pa_fordate varchar(11),                    
@pa_fromaccid varchar(16),                    
@pa_toaccid varchar(16),    
@rejection_type char(1), -- A for ALL, O for overdue only                   
@pa_login_pr_entm_id numeric,                      
@pa_login_entm_cd_chain  varchar(8000),                      
@pa_output varchar(8000) output                      
as                    
begin               
    
 SET NOCOUNT ON         
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

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
                    
                     
 if (@pa_dptype = 'CDSL')                    
 BEGIN                    
                      
 create table #transcdsl          
 (     
 DPAM_ID BIGINT,         
 DPAM_SBA_NAME VARCHAR(100),          
 DPAM_SBA_NO VARCHAR(16),          
 SLIP_NO VARCHAR(20),          
 TRANS_NO VARCHAR(20),                    
 TRASTM_CD VARCHAR(5),                    
 EXECUTION_DT DATETIME,                    
 ISIN VARCHAR(12),          
 QTY NUMERIC(18,3),          
 TRANS_DESCP VARCHAR(100),          
 STATUS VARCHAR(100),          
 ERR_MSG VARCHAR(100)          
 )          
          
    
      
          
   -- FOR BO DELIVERY TRANSACTIONS      
  IF (@rejection_type  = 'O')    
  BEGIN    
   INSERT INTO #transcdsl(DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,TRASTM_CD,EXECUTION_DT,ISIN,QTY,TRANS_DESCP,STATUS,ERR_MSG)          
   SELECT DPTDC_DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,DPTDC_SLIP_NO,isnull(DPTDC_TRANS_NO,''),DPTDC_INTERNAL_TRASTM,DPTDC_EXECUTION_DT,DPTDC_ISIN,DPTDC_QTY                    
   ,DESCP='',STATUS=ISNULL(STAT.DESCP,DPTDC_STATUS),ERR_MSG=ISNULL(MSG.DESCP,DPTDC_ERRMSG)          
   FROM DP_TRX_DTLS_CDSL   D                   
   LEFT OUTER JOIN citrus_usr.FN_GETSUBTRANSDTLS('TRANS_ERR_CD_CDSL') MSG on  DPTDC_ERRMSG = MSG.CD,                    
   citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) ACCOUNT,         
   citrus_usr.FN_GETSUBTRANSDTLS('RES_STAT_CD_CDSL') stat                    
   WHERE                     
   DPTDC_EXECUTION_DT = @pa_fordate     
   AND DPTDC_STATUS ='O'           
   AND isnumeric(dpam_sba_no) = 1                    
   AND (DPAM_SBA_NO BETWEEN CONVERT(NUMERIC,@pa_fromaccid) and CONVERT(NUMERIC,@pa_toaccid))                    
   AND DPTDC_DELETED_IND = 1                    
   AND DPTDC_DPAM_ID = ACCOUNT.DPAM_ID                      
   AND (DPTDC_EXECUTION_DT between EFF_FROM and EFF_TO)                    
   AND DPTDC_STATUS = STAT.CD    
       
 END    
 ELSE    
 BEGIN    
   INSERT INTO #transcdsl(DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,TRASTM_CD,EXECUTION_DT,ISIN,QTY,TRANS_DESCP,STATUS,ERR_MSG)          
   SELECT DPTDC_DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,DPTDC_SLIP_NO,isnull(DPTDC_TRANS_NO,''),DPTDC_INTERNAL_TRASTM,DPTDC_EXECUTION_DT,DPTDC_ISIN,DPTDC_QTY                    
   ,DESCP='',STATUS=ISNULL(STAT.DESCP,DPTDC_STATUS),ERR_MSG=ISNULL(MSG.DESCP,DPTDC_ERRMSG)          
   FROM DP_TRX_DTLS_CDSL   D                   
  LEFT OUTER JOIN citrus_usr.FN_GETSUBTRANSDTLS('TRANS_ERR_CD_CDSL') MSG on  DPTDC_ERRMSG = MSG.CD,                    
   citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) ACCOUNT,         
   citrus_usr.FN_GETSUBTRANSDTLS('RES_STAT_CD_CDSL') stat                    
   WHERE                     
   DPTDC_EXECUTION_DT = @pa_fordate     
   AND DPTDC_STATUS IN('F','O')        
   AND isnumeric(dpam_sba_no) = 1                    
   AND (DPAM_SBA_NO BETWEEN CONVERT(NUMERIC,@pa_fromaccid) and CONVERT(NUMERIC,@pa_toaccid))                    
   AND DPTDC_DELETED_IND = 1                    
   AND DPTDC_DPAM_ID = ACCOUNT.DPAM_ID                      
   AND (DPTDC_EXECUTION_DT between EFF_FROM and EFF_TO)                    
   AND DPTDC_STATUS = STAT.CD    
       
     
 END    
                   
          
   -- FOR BO DELIVERY TRANSACTIONS          
          
          
    SELECT DPAM_ID DPTDC_DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO=ISNULL(SLIP_NO,''),TRANS_NO          
    ,TRANS_TYPE=isnull(TRASTM_CD,'')          
    ,EXECUTION_DT=CONVERT(VARCHAR(11),EXECUTION_DT,109)          
    ,ISIN          
    ,ISIN_NAME          
    ,TRANS_DESCP          
    ,QTY = ABS(QTY)    
    ,STATUS                
    ,ERR_MSG=ISNULL(ERR_MSG,'')    
    ,HLDG_QTY = ISNULL(DPHMC_FREE_QTY,0)           
    FROM           
    #transcdsl TN    
    LEFT OUTER JOIN isin_mstr ON ISIN = ISIN_CD           
    LEFT OUTER JOIN DP_HLDG_MSTR_CDSL on TN.DPAM_ID = DPHMC_DPAM_ID AND TN.ISIN = DPHMC_ISIN     
    ORDER BY EXECUTION_DT,DPAM_SBA_NO,DPAM_SBA_NAME,SLIP_NO,ISIN_NAME         
    
                    
 END                    
 ELSE                    
 BEGIN                    
 declare @l_temp table(ttype_cd varchar(5),cd varchar(5),descp varchar(50))                     
             
 insert into @l_temp                    
 SELECT  Trans_type=ltrim(rtrim(Replace(trantm_code, 'TRANS_STAT_NSDL_',''))),TRASTM_CD AS CD,TRASTM_DESC AS DESCP                       
 FROM  TRANSACTION_TYPE_MSTR,                      
 TRANSACTION_SUB_TYPE_MSTR                      
 WHERE TRANTM_CODE like  'TRANS_STAT_NSDL_%'                    
 AND TRANTM_ID   =  TRASTM_TRATM_ID                    
             
 insert into @l_temp                    
 select ttype.cd,stat.* from citrus_usr.FN_GETSUBTRANSDTLS('RES_STAT_CD_NSDL') stat,                    
 citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_NSDL') ttype             
     
    
    
          
  CREATE TABLE #transnsdl          
  (     
  DPAM_ID BIGINT,         
  DPAM_SBA_NAME VARCHAR(100),          
  DPAM_SBA_NO VARCHAR(16),          
  SLIP_NO VARCHAR(20),    
  TRANS_NO VARCHAR(20),          
  REJ_CD VARCHAR(20),                    
  TRASTM_CD VARCHAR(5),                    
  EXECUTION_DT DATETIME,                    
  ISIN VARCHAR(12),          
  QTY NUMERIC(18,3),          
  STATUS VARCHAR(4)          
  )          
          
  IF (@rejection_type  = 'O')    
  BEGIN     


     -- FOR COD TRANSACTIONS          
     INSERT INTO #transnsdl(DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,REJ_CD,TRASTM_CD,EXECUTION_DT,ISIN,QTY,STATUS)          
     select DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,CODD_SLIP_NO,CODD_TRX_NO,CODD_REJ_REASON_CD1,CODD_TRX_TYP,CODD_STATUS_CHNG_DTTIME,CODD_ISIN,CODD_QTY,CODD_ORD_STATUS_TO          
     FROM                     
     COD_DTLS,           
     citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) account                    
     WHERE            
     CODD_STATUS_CHNG_DTTIME like @pa_fordate + '%'    
            AND CODD_ORD_STATUS_TO IN('31','34','40','41')    
     --AND CODD_TRX_TYP IN ('903','904','905','906','907','912','913','914','915','925','926','927','930','934','935')    
     AND ISNUMERIC(DPAM_SBA_NO) = 1                  
     AND convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)             
     AND CODD_CLT_ID = account.DPAM_SBA_NO            
     AND CODD_DELETED_IND = 1               
                 
     -- FOR COD TRANSACTIONS          
        
     -- FOR BO DELIVERY TRANSACTIONS          
     INSERT INTO #transnsdl(DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,REJ_CD,TRASTM_CD,EXECUTION_DT,ISIN,QTY,STATUS)          
     SELECT DPTD_DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,DPTD_SLIP_NO,DPTD_TRANS_NO,'',DPTD_TRASTM_CD,DPTD_EXECUTION_DT,DPTD_ISIN,DPTD_QTY,DPTD_STATUS       
     FROM                     
     DP_TRX_DTLS D,           
     citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) account                    
     WHERE                     
     DPTD_EXECUTION_DT = @pa_fordate     
     AND DPTD_STATUS IN('31','34','40','41')    
--     AND DPTD_TRASTM_CD IN ('903','904','905','906','907','912','913','914','915','925','926','927','930','934','935')    
     AND ISNUMERIC(DPAM_SBA_NO) = 1          
     AND DPTD_DPAM_ID = ACCOUNT.DPAM_ID           
     AND (DPTD_EXECUTION_DT between EFF_FROM and EFF_TO)                    
     AND (DPAM_SBA_NO BETWEEN CONVERT(NUMERIC,@pa_fromaccid) and CONVERT(NUMERIC,@pa_toaccid))          
     AND DPTD_DELETED_IND = 1            
     AND NOT EXISTS           
    (SELECT TRANS_NO,TRASTM_CD,ISIN,QTY,DPAM_SBA_NO          
     FROM #transnsdl T          
     WHERE T.TRANS_NO  = D.DPTD_TRANS_NO    
     AND  T.TRASTM_CD = D.DPTD_TRASTM_CD           
     AND   T.DPAM_ID = D.DPTD_DPAM_ID          
     AND   T.ISIN      = D.DPTD_ISIN          
     AND   T.QTY       = D.DPTD_QTY          
    )          
      -- FOR BO DELIVERY TRANSACTIONS     
    
     SELECT DPAM_ID ,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO=ISNULL(SLIP_NO,''),REJ_RSN=ISNULL(R.DESCP,REJ_CD)          
     ,TRANS_TYPE= isnull(TRANSTYPE.DESCP,'') + '(' + TRASTM_CD + ')'          
     ,EXECUTION_DT=CONVERT(VARCHAR(11),EXECUTION_DT,109)          
     ,ISIN          
     ,ISIN_NAME          
     ,QTY = ABS(QTY)     
     ,HLDG_QTY = ISNULL(DPHM_CURR_QTY,0)                     
     ,STATUS = ISNULL(T.DESCP,STATUS)                   
         
     FROM           
     #transnsdl TN          
     left outer join @l_temp T on TRASTM_CD= T.TTYPE_CD and STATUS = T.CD    
     left outer join citrus_usr.FN_GETSUBTRANSDTLS('ALL_REJ_CD_NSDL') R on REJ_CD= R.CD    
     left outer join DP_HLDG_MSTR on TN.DPAM_ID = DPHM_DPAM_ID AND TN.ISIN = DPHM_ISIN,          
     citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_NSDL') TRANSTYPE,                    
     isin_mstr          
     WHERE                     
     TRASTM_CD = TRANSTYPE.CD     
     AND ISIN = ISIN_CD                              
     AND T.DESCP LIKE '%OVERDUE%'    
     ORDER BY EXECUTION_DT,DPAM_SBA_NO,DPAM_SBA_NAME,SLIP_NO,ISIN_NAME       
         
 END    
 ELSE    
 BEGIN 


     -- FOR COD TRANSACTIONS          
     INSERT INTO #transnsdl(DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,REJ_CD,TRASTM_CD,EXECUTION_DT,ISIN,QTY,STATUS)          
     select DPAM_SBA_NAME,DPAM_SBA_NO,CODD_SLIP_NO,CODD_TRX_NO,CODD_REJ_REASON_CD1,CODD_TRX_TYP,CODD_STATUS_CHNG_DTTIME,CODD_ISIN,CODD_QTY,CODD_ORD_STATUS_TO          
     FROM                     
     COD_DTLS,           
     citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) account                    
     WHERE            
     CODD_STATUS_CHNG_DTTIME like @pa_fordate + '%'    
     AND CODD_ORD_STATUS_TO IN('53','54','55','56','57')    
     AND ISNUMERIC(DPAM_SBA_NO) = 1                  
     AND convert(numeric(18,0),DPAM_SBA_NO) between convert(numeric(18,0),@pa_fromaccid) and convert(numeric(18,0),@pa_toaccid)             
     AND CODD_CLT_ID = account.DPAM_SBA_NO            
     AND ISNULL(CODD_LST_R,0) = 1                
     AND CODD_DELETED_IND = 1               
                 
     -- FOR COD TRANSACTIONS          


     -- FOR BO DELIVERY TRANSACTIONS          
     INSERT INTO #transnsdl(DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,REJ_CD,TRASTM_CD,EXECUTION_DT,ISIN,QTY,STATUS)          
     select DPAM_SBA_NAME,DPAM_SBA_NO,DPTD_SLIP_NO,DPTD_TRANS_NO,'',DPTD_TRASTM_CD,DPTD_EXECUTION_DT,DPTD_ISIN,DPTD_QTY,DPTD_STATUS          
     FROM    
     DP_TRX_DTLS D,           
     citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) account                    
     WHERE                     
     DPTD_EXECUTION_DT = @pa_fordate    
     AND DPTD_STATUS IN('53','54','55','56','57','R1','R2')    
     AND ISNUMERIC(DPAM_SBA_NO) = 1          
     AND DPTD_DPAM_ID = ACCOUNT.DPAM_ID           
     AND (DPTD_EXECUTION_DT between EFF_FROM and EFF_TO)                    
     AND (DPAM_SBA_NO BETWEEN CONVERT(NUMERIC,@pa_fromaccid) and CONVERT(NUMERIC,@pa_toaccid))          
     AND DPTD_DELETED_IND = 1            
     AND NOT EXISTS           
    (SELECT TRANS_NO,TRASTM_CD,ISIN,QTY,DPAM_SBA_NO          
     FROM #transnsdl T          
     WHERE T.TRANS_NO  = D.DPTD_TRANS_NO           
     AND  T.TRASTM_CD = D.DPTD_TRASTM_CD           
     AND   T.DPAM_SBA_NO = ACCOUNT.DPAM_SBA_NO          
     AND   T.ISIN      = D.DPTD_ISIN          
     AND   T.QTY       = D.DPTD_QTY          
     )          
      -- FOR BO DELIVERY TRANSACTIONS        
    
     SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO=ISNULL(SLIP_NO,''),REJ_RSN=ISNULL(R.DESCP,REJ_CD)          
     ,TRANS_TYPE= isnull(TRANSTYPE.DESCP,'') + '(' + TRASTM_CD + ')'          
     ,EXECUTION_DT=CONVERT(VARCHAR(11),EXECUTION_DT,109)          
     ,ISIN          
     ,ISIN_NAME          
     ,QTY = ABS(QTY)     
     ,STATUS = isnull(T.DESCP,STATUS)                   
     FROM           
     #transnsdl           
     left outer join @l_temp T on TRASTM_CD= T.TTYPE_CD and STATUS = T.CD    
     left outer join citrus_usr.FN_GETSUBTRANSDTLS('ALL_REJ_CD_NSDL') R on REJ_CD= R.CD,            
     citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_NSDL') TRANSTYPE,                    
     isin_mstr          
     WHERE                     
     TRASTM_CD = TRANSTYPE.CD     
     AND ISIN = ISIN_CD                              
     ORDER BY EXECUTION_DT,DPAM_SBA_NO,DPAM_SBA_NAME,SLIP_NO,ISIN_NAME       
 END    
                     
 END                    
                     
END

GO
