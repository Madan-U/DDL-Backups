-- Object: PROCEDURE citrus_usr.pr_rpt_demat_sel
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

-- 3 OUT_CLT_DISP_RPT HO ALL 21/10/2008 22/10/2008         0     
-- select * from dp_mstr where default_dp = dpm_excsm_id
-- 3	OUT_CLT_DISP_RPT	HO	ALL	22/10/2008	23/10/2008									0			  
-- [pr_rpt_demat_sel] '3','OUT_CLT_DISP_RPT','HO','ALL','22/06/2008','23/10/2008','','','','','','','','','0','|*~|','*|~*',''                     
-- pr_rpt_demat_sel	'3','PEND_DMT_RTA_RPT','BHAVIN','','22/10/2008','23/10/2008','','','','','','','','',0,	'','',''	
-- 3 OUT_RTA_DISP_RPT HO  13/07/2008 13/08/2008         0         
CREATE PROCEDURE [citrus_usr].[pr_rpt_demat_sel]                                      
(@PA_ID             VARCHAR(20)                                        
,@PA_ACTION         VARCHAR(100)                                        
,@PA_LOGIN_NAME     VARCHAR(20)                                        
,@PA_SEARCH_C1      VARCHAR(20)                                        
,@PA_SEARCH_C2      VARCHAR(20)                                        
,@PA_SEARCH_C3      VARCHAR(20)                                        
,@PA_SEARCH_C4      VARCHAR(20)                                        
,@PA_SEARCH_C5      VARCHAR(20)                                        
,@PA_SEARCH_C6      VARCHAR(20)                                        
,@PA_SEARCH_C7      VARCHAR(20)                                        
,@PA_SEARCH_C8      VARCHAR(20)                                        
,@PA_SEARCH_C9      VARCHAR(20)                                        
,@PA_SEARCH_C10      VARCHAR(20)                                        
,@PA_ROLES          VARCHAR(8000)                                      
,@PA_SCR_ID         NUMERIC                                      
,@ROWDELIMITER      CHAR(10)                                        
,@COLDELIMITER      CHAR(4)                                        
,@PA_REF_CUR        VARCHAR(8000) OUT  )                                      
AS                                      
BEGIN                                      
--           
                                      
DECLARE @L_DPM_DPID VARCHAR(25)                                      
, @L_ENTM_ID BIGINT            
, @L_DPID VARCHAR(25)                                  
IF  ISNUMERIC(@PA_ID) = 1                                      
SELECT @L_DPM_DPID = DPM_ID, @L_DPID = DPM_DPID FROM DP_MSTR WHERE DEFAULT_DP = @PA_ID AND DPM_DELETED_IND = 1                                       
                                   
SELECT @L_ENTM_ID = LOGN_ENT_ID FROM LOGIN_NAMES WHERE LOGN_NAME = @PA_LOGIN_NAME AND LOGN_DELETED_IND =  1                                      
         
        
IF @PA_ACTION = 'DMT_REQ_VIOLATION_RPT'                                    
 BEGIN                                      
 --               
	 SELECT DPAM_SBA_NO , DPAM_SBA_NAME , DEMRM_ISIN , DEMRM_DRF_NO DRN, DEMRM_SLIP_SERIAL_NO DRF,           
	 CONVERT(VARCHAR,DEMRM_REQUEST_DT,103) DEMRM_REQUEST_DT, ABS(DEMRM_QTY) QTY           
	 FROM DEMAT_REQUEST_MSTR left outer join DMAT_DISPATCH on DEMRM_ID=DISP_DEMRM_ID  
	 ,DP_ACCT_MSTR          
	 WHERE DEMRM_DPAM_ID = DPAM_ID           
	 AND DATEDIFF(DD,DEMRM_REQUEST_DT,GETDATE())>=@PA_SEARCH_C4               
	 AND CONVERT(VARCHAR,DEMRM_REQUEST_DT,103)   BETWEEN @PA_SEARCH_C2            AND     @PA_SEARCH_C3   
	 and isnull(disp_id,0) = 0               
	 and demrm_deleted_ind = 1
  --              
  END           
          
 IF @PA_ACTION = 'OUT_RTA_DISP_RPT'                                    
 BEGIN                                      
 --               
      IF  RTRIM(LTRIM(@PA_SEARCH_C4))=''          
   BEGIN          
   SET @PA_SEARCH_C4='0'          
   END          
   IF  RTRIM(LTRIM(@PA_SEARCH_C5))=''          
   BEGIN          
   SET @PA_SEARCH_C5='999999999'          
   END          
  SELECT DPAM_ID,DPAM_SBA_NO , DPAM_SBA_NAME , DEMRM_ISIN , DEMRM_DRF_NO DRN, DEMRM_SLIP_SERIAL_NO DRF,          
  CONVERT(VARCHAR,DEMRM_REQUEST_DT,103) DEMRM_REQUEST_DT, ABS(DEMRM_QTY) QTY,CLICM.CLICM_DESC CATEGORY,ISNULL(DEMRM_TOTAL_CERTIFICATES,'0') NO_OF_CERTIFICATE          
        ,ISNULL(DPHD_SH_FNAME,'') SECONDHOLDER,ISNULL(DPHD_TH_FNAME,'') THIRDHOLDER , DEMRM_FREE_LOCKEDIN_YN  LOCKIN, ENTM_NAME1 RTA_NAME         
, citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ENTM_ID,'OFF_ADR1'),''),1) adr1                          
                                , citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ENTM_ID,'OFF_ADR1'),''),2) adr2                          
                                , citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ENTM_ID,'OFF_ADR1'),''),3) adr3                          
                                , citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ENTM_ID,'OFF_ADR1'),''),4) adr_city                          
                                , citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ENTM_ID,'OFF_ADR1'),''),5) adr_state                          
                                , citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ENTM_ID,'OFF_ADR1'),''),6) adr_country                          
                                , citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ENTM_ID,'OFF_ADR1'),''),7) adr_zip       , CONVERT(VARCHAR,DISP_DT,103) disp_dt , ISIN_NAME , ISNULL(DISP_DOC_ID,'0') disp_doc_id  
  FROM DEMAT_REQUEST_MSTR , DMAT_DISPATCH, DP_ACCT_MSTR DP_ACCT_MSTR LEFT OUTER JOIN DP_HOLDER_DTLS DPHD   ON   DPHD_DPAM_ID = DPAM_ID      AND DPHD_DELETED_IND = 1 ,CLIENT_CTGRY_MSTR CLICM, ISIN_MSTR , ENTITY_MSTR         
  WHERE DEMRM_DPAM_ID = DPAM_ID           
  AND   demrm_id =   DISP_DEMRM_ID    
  AND  ISIN_CD = DEMRM_ISIN        
      
   AND  ENTM_SHORT_NAME = CASE WHEN LEFT(@L_DPID,2)='IN' THEN ISIN_REG_CD ELSE 'RTA_'+ISIN_REG_CD END        
  AND  ENTM_ENTTM_CD =  CASE WHEN LEFT(@L_DPID,2)='IN' THEN 'sr' ELSE 'rta' END        
        AND DPAM_CLICM_CD=CLICM_CD          
        AND DPAM_DELETED_IND=1          
     AND CLICM_DELETED_IND=1           
      AND ISNULL(DISP_TO,'') = 'R'   
      AND disp_type ='N'  
  AND  dpam_id = demrm_dpam_id  
  --AND  dpam_dpm_id = @L_DPM_DPID   
  AND ISNULL(DEMRM_INTERNAL_REJ,'') = ''          
  AND ISNULL(DEMRM_COMPANY_OBJ,'') = ''          
  AND ISNULL(DEMRM_INTERNAL_REJ,'')  = ''       
  AND ISNULL(DEMRM_COMPANY_OBJ,'') = ''      
  AND ISNULL(DEMRM_CREDIT_RECD,'') <> 'Y'         
  AND DISP_DT BETWEEN          
      CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) AND CONVERT(DATETIME,@PA_SEARCH_C3+ ' 23:59:59:999',103)         
   AND DPAM_SBA_NO  BETWEEN @PA_SEARCH_C4 AND @PA_SEARCH_C5    
   ORDER BY ISIN_NAME desc            
  --              
  END          
          
 IF @PA_ACTION = 'PEND_DMT_RTA_RPT'                                    
 BEGIN                                      
 --               
 SELECT DPAM_SBA_NO , DPAM_SBA_NAME , DEMRM_ISIN , DEMRM_DRF_NO DRN, DEMRM_SLIP_SERIAL_NO DRF,          
  CONVERT(VARCHAR,DEMRM_REQUEST_DT,103) DEMRM_REQUEST_DT, ABS(DEMRM_QTY) QTY          
 FROM DEMAT_REQUEST_MSTR , DP_ACCT_MSTR , DMAT_DISPATCH          
 WHERE DEMRM_DPAM_ID = DPAM_ID           
 AND   DEMRM_ID = DISP_DEMRM_ID          
 AND ISNULL(DEMRM_INTERNAL_REJ,'') <> ''          
 AND ISNULL(DEMRM_COMPANY_OBJ,'') <> ''          
 AND ISNULL(DISP_CONF_RECD,'') <> 'C'          
 AND ISNULL(DISP_TO,'') = 'R'      
 AND DATEDIFF(DD,DISP_DT,GETDATE()) >= @PA_SEARCH_C2                
 --AND DATEDIFF(DD,CONVERT(DATETIME,DISP_DT,103),GETDATE()) >= CONVERT(DATETIME,@PA_SEARCH_C2,103)              
  --              
  END          
 IF @PA_ACTION = 'OUT_CLT_DISP_RPT'          
 BEGIN          
      IF  RTRIM(LTRIM(@PA_SEARCH_C4))=''          
      BEGIN          
      SET @PA_SEARCH_C4='000000000'          
      END          
      IF  RTRIM(LTRIM(@PA_SEARCH_C5))=''          
      BEGIN          
      SET @PA_SEARCH_C5='999999999'          
      END          
          
   SELECT DPAM_SBA_NO,DPAM_SBA_NAME,DEMRM_ID,DEMRM_ISIN,DEMRM_TRANSACTION_NO DRN,DEMRM_SLIP_SERIAL_NO DRF,DEMRM_DPAM_ID                     
  ,CONVERT(VARCHAR,DEMRM_REQUEST_DT,103) DEMRM_REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') ,DEMRM_QTY QTY, ISNULL(DISP_TYPE,'')                      
  ,CONVERT(VARCHAR,DISP_DT,103),ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                      
     ,CLICM.CLICM_DESC CATEGORY,ISNULL(DEMRM_TOTAL_CERTIFICATES,'0') NO_OF_CERTIFICATE          
     ,ISNULL(DPHD_SH_FNAME,'') SECONDHOLDER,ISNULL(DPHD_TH_FNAME,'') THIRDHOLDER , DEMRM_FREE_LOCKEDIN_YN  LOCKIN , DESCP REJ , CASE WHEN ISNULL(DEMRM_COMPANY_OBJ,'') <> '' THEN 'COMP' ELSE 'INTERNAL' END OBJ_TYPE      
    , ISNULL(DISP_DOC_ID,'0') disp_doc_id  
   FROM DMAT_DISPATCH , DEMAT_REQUEST_MSTR,DP_ACCT_MSTR LEFT OUTER JOIN DP_HOLDER_DTLS DPHD ON DPHD_DPAM_ID = DPAM_ID    
         AND DPHD_DELETED_IND=1    
       ,CLIENT_CTGRY_MSTR CLICM           
      ,citrus_usr.FN_GETSUBTRANSDTLS('DEMAT_REJ_CD_NSDL')       
      WHERE DEMRM_ID = DISP_DEMRM_ID AND ISNULL(DISP_TO,'') = 'C'             
      AND DPAM_CLICM_CD=CLICM_CD            
                
AND ISNULL(DISP_CONF_RECD,'') = ''            
AND DPAM_DELETED_IND=1          
AND CLICM_DELETED_IND=1          
         
AND DEMRM_DPAM_ID = DPAM_ID       
AND  dpam_dpm_id = @L_DPM_DPID     
AND (ISNULL(DEMRM_INTERNAL_REJ,'')  <> '' OR ISNULL(DEMRM_COMPANY_OBJ,'') <> '')      
AND (ISNULL(DEMRM_INTERNAL_REJ,'')  = CD OR ISNULL(DEMRM_COMPANY_OBJ,'') = CD)      
AND disp_dt BETWEEN          
CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) AND CONVERT(DATETIME,@PA_SEARCH_C3+ ' 23:59:59:999',103)                        
  
AND DPAM_SBA_NO  BETWEEN @PA_SEARCH_C4 AND @PA_SEARCH_C5          
 END    
IF @PA_ACTION = 'DEMAT_ACK_CLIENT'          
 BEGIN          
      IF  RTRIM(LTRIM(@PA_SEARCH_C4))=''          
      BEGIN          
      SET @PA_SEARCH_C4='000000000'          
      END          
      IF  RTRIM(LTRIM(@PA_SEARCH_C5))=''          
      BEGIN          
      SET @PA_SEARCH_C5='999999999'          
      END    
 SELECT DPAM_SBA_NO    
  ,DPAM_SBA_NAME    
  ,DEMRM_ID    
  ,DEMRM_ISIN    
  ,ISIN_NAME    
 ,INSM_DESC SECTYPE    
  ,DEMRM_DRF_NO DRN    
  ,DEMRM_SLIP_SERIAL_NO DRF    
  ,DEMRM_DPAM_ID                     
  ,ISNULL(DEMRM_REQUEST_DT,'') DEMRM_REQUEST_DT     
  ,ISNULL(DEMRM_EXECUTION_DT,'') DEMRM_EXECUTION_DT     
  ,DEMRM_QTY QTY    
       ,ISNULL(DEMRM_TOTAL_CERTIFICATES,'0') NO_OF_CERTIFICATE          
       ,ISNULL(DPHD_SH_FNAME,'') SECONDHOLDER,ISNULL(DPHD_TH_FNAME,'') THIRDHOLDER , DEMRM_FREE_LOCKEDIN_YN  LOCKIN     
      
   FROM DEMAT_REQUEST_MSTR,DP_ACCT_MSTR    
        ,DP_HOLDER_DTLS DPHD    
  ,ISIN_MSTR    
 ,INSTRUMENT_MSTR       
      WHERE     
 DPHD_DPAM_ID = DPAM_ID                  
 AND DEMRM_ISIN = ISIN_CD    
 AND ISIN_INSM_ID=INSM_ID  
 and DPAM_DELETED_IND=1          
 AND DPHD_DELETED_IND=1    
 AND ISIN_DELETED_IND =1           
 AND INSM_DELETED_IND =1  
 AND DEMRM_DPAM_ID = DPAM_ID         
 AND (ISNULL(DEMRM_INTERNAL_REJ,'')  = '' and ISNULL(DEMRM_COMPANY_OBJ,'') = '')      
 AND DEMRM_REQUEST_DT BETWEEN          
 CONVERT(DATETIME,@PA_SEARCH_C2+ ' 00:00:00:000',103) AND CONVERT(DATETIME,@PA_SEARCH_C3+ ' 23:59:59:999',103)                        
 AND DPAM_SBA_NO  BETWEEN @PA_SEARCH_C4 AND @PA_SEARCH_C5             
 END    
          
  -- ALL DEMAT ACTIVITIES REPORT          
end

GO
