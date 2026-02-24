-- Object: PROCEDURE citrus_usr.Pr_Rpt_ResponseStatus
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

/*
begin tran

 Pr_Rpt_ResponseStatus 'CDSL',3,'May 27 2009','Jul 27 2009 23:59:59','1234567890123456','','','','',1,'HO|*~|Print|*~|',''	
 Pr_Rpt_ResponseStatus 'CDSL',3,'Jan 08 2008','Mar 29 2008','','','','','',1,'JMF HO_HO|*~|',''     
 Pr_Rpt_ResponseStatus 'NSDL',4,'Jan 08 2006','Mar 29 2008','','','','','',1,'0','' 
 Pr_Rpt_ResponseStatus 'NSDL',4,'Dec 12 2007','Dec 24 2008','','','','','',1,'JMF HO_HO|*~|',''	+
 Pr_Rpt_ResponseStatus 'NSDL',4,'Dec  3 2007','Sep 15 2008 23:59:59','','','','','',1,'HO|*~|',''	

	CDSL	3	May 27 2009	Jul 27 2009 23:59:59	1234567890123456					1	HO|*~|	
      

*/

CREATE Proc [citrus_usr].[Pr_Rpt_ResponseStatus]                  
@pa_dptype varchar(4),                  
@pa_excsmid int,                  
@pa_fromdate datetime,                  
@pa_todate datetime,                  
@pa_fromaccid varchar(16),                  
@pa_toaccid varchar(16),                  
@pa_isincd varchar(12),  
@fortranstype varchar(5),  
@forstatus_cd varchar(5),                  
@pa_login_pr_entm_id numeric,                    
@pa_login_entm_cd_chain  varchar(8000),                    
@pa_output varchar(8000) output                    
as                  
begin             
  
 SET NOCOUNT ON       
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
        
  
   -- FOR DP50/DPC9 DELIVERY TRANSACTIONS             
  INSERT INTO #transcdsl(DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,TRASTM_CD,EXECUTION_DT,ISIN,QTY,TRANS_DESCP,STATUS,ERR_MSG)        
  select CDSHM_DPAM_ID,DPAM_SBA_NAME,CDSHM_BEN_ACCT_NO,CDSHM_SLIP_NO,CDSHM_TRANS_NO,CDSHM_INTERNAL_TRASTM,CDSHM_TRAS_DT,CDSHM_ISIN,CDSHM_QTY        
  ,CDSHM_TRATM_DESC=replace(CDSHM_TRATM_DESC,'        ',''),isnull(T.DESCP,CDSHM_TRATM_CD),''        
  FROM citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_CDSL') T        
  right outer join CDSL_HOLDING_DTLS on CDSHM_TRATM_CD = T.CD         
  ,citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) ACCOUNT        
  WHERE         
  CDSHM_TRAS_DT >=@pa_fromdate AND CDSHM_TRAS_DT <=@pa_todate      
  AND CDSHM_TRATM_CD = CASE WHEN @forstatus_cd <> '' THEN  @forstatus_cd ELSE CDSHM_TRATM_CD END             
  AND isnumeric(CDSHM_BEN_ACCT_NO) = 1                    
  AND convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                   
  AND CDSHM_DPAM_ID = ACCOUNT.DPAM_ID                    
  AND (CDSHM_TRAS_DT between EFF_FROM and EFF_TO)         
  AND CDSHM_ISIN like @pa_isincd + '%'           


UPDATE t SET SLIP_NO = DPTDC_SLIP_NO
FROM   #transcdsl t,DP_TRX_DTLS_CDSL 
WHERE  T.TRANS_NO  = DPTDC_TRANS_NO  
AND    T.DPAM_ID   = DPTDC_DPAM_ID
AND    T.ISIN      = DPTDC_ISIN
AND    T.EXECUTION_DT = DPTDC_EXECUTION_DT
AND    LTRIM(RTRIM(ISNULL(T.SLIP_NO,''))) = ''
AND    DPTDC_DELETED_IND = 1    
   -- FOR DP50/DPC9 DELIVERY TRANSACTIONS             
        
   -- FOR BO DELIVERY TRANSACTIONS    
    
 INSERT INTO #transcdsl(DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,TRASTM_CD,EXECUTION_DT,ISIN,QTY,TRANS_DESCP,STATUS,ERR_MSG)        
 SELECT DPTDC_DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,DPTDC_SLIP_NO,isnull(DPTDC_TRANS_NO,''),DPTDC_INTERNAL_TRASTM,DPTDC_EXECUTION_DT,DPTDC_ISIN,DPTDC_QTY                  
 ,DESCP='',STATUS=ISNULL(STAT.DESCP,DPTDC_STATUS),ERR_MSG=ISNULL(MSG.DESCP,DPTDC_ERRMSG)        
 FROM DP_TRX_DTLS_CDSL   D                 
 LEFT OUTER JOIN citrus_usr.FN_GETSUBTRANSDTLS('TRANS_ERR_CD_CDSL') MSG on  DPTDC_ERRMSG = MSG.CD,                  
 citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) ACCOUNT,       
 citrus_usr.FN_GETSUBTRANSDTLS('RES_STAT_CD_CDSL') stat                  
 WHERE                   
 DPTDC_EXECUTION_DT >=@pa_fromdate AND DPTDC_EXECUTION_DT <=@pa_todate    
 AND DPTDC_STATUS = CASE WHEN @forstatus_cd <> '' THEN  @forstatus_cd ELSE DPTDC_STATUS END                 
 AND isnumeric(dpam_sba_no) = 1                  
 AND (DPAM_SBA_NO BETWEEN CONVERT(NUMERIC,@pa_fromaccid) and CONVERT(NUMERIC,@pa_toaccid))                  
 AND DPTDC_ISIN like @pa_isincd + '%'                  
 AND DPTDC_DELETED_IND = 1                  
 AND DPTDC_DPAM_ID = ACCOUNT.DPAM_ID                    
 AND (DPTDC_EXECUTION_DT between EFF_FROM and EFF_TO)                  
 AND DPTDC_STATUS = STAT.CD         
   AND NOT EXISTS         
  (SELECT TRANS_NO,TRASTM_CD,ISIN,QTY,DPAM_SBA_NO        
   FROM #transcdsl T        
   WHERE T.TRANS_NO  = D.DPTDC_TRANS_NO         
   AND   T.TRASTM_CD = D.DPTDC_TRASTM_CD         
   AND   T.DPAM_ID	 = ACCOUNT.DPAM_ID      
   AND   T.ISIN      = D.DPTDC_ISIN        
   AND   T.QTY       = D.DPTDC_QTY        
  )                 
        
   -- FOR BO DELIVERY TRANSACTIONS     
        
   SELECT DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO=ISNULL(SLIP_NO,''),TRANS_NO        
   ,TRANS_TYPE=isnull(TRASTM_CD,'')        
   ,EXECUTION_DT=CONVERT(VARCHAR(11),EXECUTION_DT,109)        
   ,ISIN        
   ,ISIN_NAME        
   ,TRANS_DESCP        
   ,DR_QTY = CASE WHEN QTY <= 0 THEN ABS(QTY) ELSE 0 END            
   ,CR_QTY = CASE WHEN QTY > 0 THEN  ABS(QTY) ELSE 0 END                   
   ,STATUS              
  ,ERR_MSG=ISNULL(ERR_MSG,'')         
  --,ERR_MSG = 'Error message'        
	
   FROM         
   #transcdsl LEFT OUTER JOIN isin_mstr ON ISIN = ISIN_CD         
   ORDER BY SLIP_NO,EXECUTION_DT,DPAM_SBA_NO,DPAM_SBA_NAME,ISIN_NAME       



	TRUNCATE TABLE #transcdsl
	DROP TABLE #transcdsl 
        
        
        
        
              
                   
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
 DPAM_SBA_NAME VARCHAR(100),        
 DPAM_SBA_NO VARCHAR(8),        
 SLIP_NO VARCHAR(20),        
 TRANS_NO VARCHAR(20),                  
 TRASTM_CD VARCHAR(5),                  
 EXECUTION_DT DATETIME,                  
 ISIN VARCHAR(12),        
 QTY NUMERIC(18,3),        
 STATUS VARCHAR(4),        
 CANCEL_STATUS VARCHAR(4)        
 )        
        
        
   -- FOR COD TRANSACTIONS        
   INSERT INTO #transnsdl(DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,TRASTM_CD,EXECUTION_DT,ISIN,QTY,STATUS,CANCEL_STATUS)        
   select DPAM_SBA_NAME,DPAM_SBA_NO,CODD_SLIP_NO,CODD_TRX_NO,CODD_TRX_TYP,CODD_STATUS_CHNG_DTTIME,CODD_ISIN,CODD_QTY,CODD_ORD_STATUS_TO,CODD_CANC_STATUS_TO        
   FROM                   
   COD_DTLS,         
   citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) account                  
   WHERE          
   CODD_STATUS_CHNG_DTTIME >= @pa_fromdate AND CODD_STATUS_CHNG_DTTIME <=@pa_todate    
   AND CODD_TRX_TYP =  CASE WHEN @fortranstype <> '' THEN  @fortranstype ELSE CODD_TRX_TYP END    
   AND   
   (  
    CODD_ORD_STATUS_TO =  CASE WHEN @fortranstype <> '' THEN @forstatus_cd ELSE CODD_ORD_STATUS_TO END   
    OR  
    CODD_CANC_STATUS_TO =  CASE WHEN @forstatus_cd <> '' THEN @forstatus_cd ELSE CODD_CANC_STATUS_TO END  
    )          
   AND ISNUMERIC(DPAM_SBA_NO) = 1                
   AND convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)           
   AND CODD_CLT_ID = account.DPAM_SBA_NO          
   AND CODD_ISIN like @pa_isincd + '%'             
   AND ISNULL(CODD_LST_R,0) = 1              
   AND CODD_DELETED_IND = 1             
             
   -- FOR COD TRANSACTIONS        
   
   -- FOR BO DELIVERY TRANSACTIONS        
   INSERT INTO #transnsdl(DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,TRASTM_CD,EXECUTION_DT,ISIN,QTY,STATUS,CANCEL_STATUS)        
   select DPAM_SBA_NAME,DPAM_SBA_NO,DPTD_SLIP_NO,DPTD_TRANS_NO,DPTD_TRASTM_CD,DPTD_EXECUTION_DT,DPTD_ISIN,DPTD_QTY,DPTD_STATUS,''        
   FROM                   
   DP_TRX_DTLS D,         
   citrus_usr.FN_ACCT_LIST(@@dpmid,1,0) account                  
   WHERE                   
   DPTD_EXECUTION_DT >= @pa_fromdate AND DPTD_EXECUTION_DT <= @pa_todate   
   AND DPTD_TRASTM_CD =  CASE WHEN @fortranstype <> '' THEN  @fortranstype ELSE DPTD_TRASTM_CD END    
   AND DPTD_STATUS = CASE WHEN @forstatus_cd <> '' THEN @forstatus_cd ELSE DPTD_STATUS END                
   AND ISNUMERIC(DPAM_SBA_NO) = 1        
   AND DPTD_DPAM_ID = ACCOUNT.DPAM_ID         
   AND (DPTD_EXECUTION_DT between EFF_FROM and EFF_TO)                  
   AND (DPAM_SBA_NO BETWEEN CONVERT(NUMERIC,@pa_fromaccid) and CONVERT(NUMERIC,@pa_toaccid))        
   AND DPTD_ISIN like @pa_isincd + '%'                    
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
         
   SELECT DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO        
   ,TRANS_TYPE= isnull(TRANSTYPE.DESCP,'') + '(' + TRASTM_CD + ')'        
   ,EXECUTION_DT=CONVERT(VARCHAR(11),EXECUTION_DT,109)        
   ,ISIN        
   ,ISIN_NAME        
   ,DR_QTY = CASE WHEN QTY <= 0 THEN ABS(QTY) ELSE 0 END         
   ,CR_QTY = CASE WHEN QTY > 0 THEN  ABS(QTY) ELSE 0 END                   
   ,STATUS = isnull(T.DESCP,STATUS)                 
   ,CANCEL_STATUS = CASE WHEN CANCEL_STATUS = '00' THEN '' ELSE isnull(C.DESCP,CANCEL_STATUS) END    
   FROM         
   @l_temp C          
   right outer join #transnsdl on TRASTM_CD= C.TTYPE_CD and CANCEL_STATUS = C.CD         
   left outer join @l_temp T on TRASTM_CD= T.TTYPE_CD and STATUS = T.CD,        
   citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_NSDL') TRANSTYPE,                  
   isin_mstr        
   WHERE                   
   TRASTM_CD = TRANSTYPE.CD and          
   ISIN = ISIN_CD                            
   ORDER BY SLIP_NO,EXECUTION_DT,DPAM_SBA_NO,DPAM_SBA_NAME,ISIN_NAME        
         
        
	TRUNCATE TABLE #transnsdl
	DROP TABLE #transnsdl    
                   
 END                  
                   
END

GO
