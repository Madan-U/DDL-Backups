-- Object: PROCEDURE citrus_usr.pr_rpt_remat_All
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_rpt_remat_All]                                      
(
@PA_EXCSM_ID INT,
@PA_ACTION VARCHAR(50),
@PA_FROM_DT DATETIME,
@PA_TO_DT DATETIME,
@PA_FROM_ACCT VARCHAR(16),
@PA_TO_ACCT VARCHAR(16),
@PA_NO_OF_DAYS INT,
@PA_LOGIN_PR_ENTM_ID BIGINT,
@PA_LOGIN_ENTM_CD_CHAIN varchar(8000),      
@PA_OUTPUT varchar(20) OUT    
)                                      
AS                                      
BEGIN                                      
--     
IF SUBSTRING('OUT_RTA_DISP_RPT',1,16)='OUT_RTA_DISP_RPT'
BEGIN
SET @PA_ACTION  = REPLACE(@PA_ACTION,'|*~||*~|','')
END

                                      
DECLARE @@L_DPM_ID BIGINT,
@L_DPID VARCHAR(8),
@@SSQL VARCHAR(8000),
@@l_child_entm_id BIGINT

select @@L_DPM_ID = dpm_id,@L_DPID=DPM_DPID from dp_mstr where default_dp = @PA_EXCSM_ID and dpm_deleted_ind =1              
select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)            



 
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME,A_CLICM_CD VARCHAR(10))
INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO,NULL 
FROM citrus_usr.fn_acct_list_remat(@@L_DPM_ID ,@PA_LOGIN_PR_ENTM_ID,@@l_child_entm_id)		



IF @PA_FROM_ACCT = ''                      
 BEGIN                      
  SET @PA_FROM_ACCT = '0'                      
  SET @PA_TO_ACCT = '99999999999999999'                      
 END                      
 IF @PA_TO_ACCT = ''                      
 BEGIN                  
   SET @PA_TO_ACCT = @PA_FROM_ACCT                      
 END                      
                                
         
        
IF @PA_ACTION = 'DMT_REQ_VIOLATION_RPT'                                    
 BEGIN                                      
 --               
	 SELECT DPAM_SBA_NO , DPAM_SBA_NAME , REMRM_ISIN ,ISIN_NAME, isnull(REMRM_TRANSACTION_NO,0) RRN, REMRM_SLIP_SERIAL_NO RRF,           
	 CONVERT(VARCHAR,REMRM_REQUEST_DT,103) REMRM_REQUEST_DT, convert(numeric(18,3),ABS(REMRM_QTY)) QTY           
	 FROM REMAT_REQUEST_MSTR left outer join DMAT_DISPATCH_REMAT on REMRM_ID=DISPR_REMRM_ID  
	 ,#ACLIST,ISIN_MSTR          
	 WHERE REMRM_REQUEST_DT >= @PA_FROM_DT AND REMRM_REQUEST_DT <= @PA_TO_DT    
	 AND REMRM_DPAM_ID = DPAM_ID  
     AND DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
	 AND REMRM_REQUEST_DT BETWEEN EFF_FROM AND EFF_TO
	 AND REMRM_ISIN = ISIN_CD
	 AND DATEDIFF(DD,REMRM_REQUEST_DT,GETDATE())>= @PA_NO_OF_DAYS               
	AND ISNULL(REMRM_INTERNAL_REJ,'')  = ''       
	AND ISNULL(REMRM_COMPANY_OBJ,'') = ''      
	AND ISNULL(REMRM_CREDIT_RECD,'') <> 'Y'         
	 and isnull(dispr_id,0) = 0               
	 and Remrm_deleted_ind = 1
  --              
  END           
          
 IF @PA_ACTION = 'OUT_RTA_DISP_RPT'                                    
 BEGIN                                      
 --               
  UPDATE A SET A_CLICM_CD = DPAM_CLICM_CD 
  FROM #ACLIST A,DP_ACCT_MSTR M, REMAT_REQUEST_MSTR  WHERE A.DPAM_ID = M.DPAM_ID and a.dpam_id = remrm_dpam_id 
   

  SELECT DPAM_ID,DPAM_SBA_NO , DPAM_SBA_NAME , REMRM_ISIN , REMRM_TRANSACTION_NO RRN, REMRM_SLIP_SERIAL_NO RRF,          
  CONVERT(VARCHAR,REMRM_REQUEST_DT,103) REMRM_REQUEST_DT, convert(numeric(18,3),ABS(REMRM_QTY)) QTY,CLICM.CLICM_DESC CATEGORY,ISNULL(REMRM_CERTIFICATE_NO,'0') NO_OF_CERTIFICATE          
  ,ISNULL(DPHD_SH_FNAME,'') SECONDHOLDER,ISNULL(DPHD_TH_FNAME,'') THIRDHOLDER ,ENTM_NAME1 RTA_NAME         
  ,isnull(isin_adr1,'') adr1                          
	,isnull(isin_adr2,'') 
	+ '<BR>' + isnull(isin_adr3,'') adr2                          
	,isnull(isin_adrcity,'') adr_city                          
	,isnull(isin_adrstate,'') adr_state                          
	,isnull(isin_adrcountry,'') adr_country                          
	,isnull(isin_adrcountry,'') adr_zip       
   , CONVERT(VARCHAR,DISPR_DT,103) disp_dt , ISIN_NAME , ISNULL(DISPR_DOC_ID,'0') disp_doc_id,dispR_type =ISNULL(dispR_type,'N')   
   , isnull(isin_contactperson ,'') contact_person
   , datediff(dd,DISPR_DT,getdate()) Duration
   , '' drf
	FROM REMAT_REQUEST_MSTR , DMAT_DISPATCH_REMAT, #ACLIST LEFT OUTER JOIN DP_HOLDER_DTLS DPHD   ON   DPHD_DPAM_ID = DPAM_ID      AND DPHD_DELETED_IND = 1 
	,CLIENT_CTGRY_MSTR CLICM, ISIN_MSTR , ENTITY_MSTR         
	WHERE 	REMRM_DPAM_ID = DPAM_ID       
	AND DISPR_DT >= @PA_FROM_DT AND DISPR_DT <= @PA_TO_DT    
    AND ISNULL(DISPR_TO,'') = 'R'   
	AND dispR_type ='N'  
	AND DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
	AND REMRM_REQUEST_DT BETWEEN EFF_FROM AND EFF_TO
	AND ISNULL(REMRM_INTERNAL_REJ,'')  = ''       
	AND ISNULL(REMRM_COMPANY_OBJ,'') = ''      
	AND ISNULL(REMRM_CREDIT_RECD,'') <> 'Y'         
	AND   Remrm_id =   DISPR_REMRM_ID    
	AND  ISIN_CD = REMRM_ISIN        
	AND  ENTM_SHORT_NAME = CASE WHEN LEFT(@L_DPID,2)='IN' THEN dispR_rta_cd ELSE 'RTA_'+dispR_rta_cd END        
	AND  ENTM_ENTTM_CD =  CASE WHEN LEFT(@L_DPID,2)='IN' THEN 'SR' ELSE 'RTA' END        
	AND A_CLICM_CD=CLICM_CD          
	AND CLICM_DELETED_IND=1           
    AND REMRM_DELETED_IND = 1
    AND ENTM_DELETED_IND = 1
	ORDER BY ISIN_NAME,DISPR_DT
  --              
  END          
          


 IF @PA_ACTION = 'PEND_DMT_RTA_RPT'                                    
 BEGIN                                      
 --               
 SELECT DPAM_SBA_NO , DPAM_SBA_NAME , REMRM_ISIN ,ISIN_NAME, REMRM_TRANSACTION_NO RRN, REMRM_SLIP_SERIAL_NO RRF,          
  CONVERT(VARCHAR,REMRM_REQUEST_DT,103) REMRM_REQUEST_DT,convert(varchar(11),DISPR_DT,103) DISP_DATE,DISP_TYPE= CASE WHEN dispR_type = 'N' THEN 'NEW' ELSE 'FOLLOW UP' END,
  convert(numeric(18,3),ABS(REMRM_QTY)) QTY          
 FROM REMAT_REQUEST_MSTR , #ACLIST ,DMAT_DISPATCH_REMAT, ISIN_MSTR , ENTITY_MSTR                   
 WHERE REMRM_ID = DISPR_REMRM_ID          
 AND DISPR_DT >= @PA_FROM_DT AND DISPR_DT <= @PA_TO_DT    
 AND  ISNULL(DISPR_CONF_RECD,'') <> 'C'          
 AND ISNULL(DISPR_TO,'') = 'R'      
 AND ISNULL(REMRM_INTERNAL_REJ,'') = ''          
 AND ISNULL(REMRM_COMPANY_OBJ,'') = ''          
 AND REMRM_DPAM_ID = DPAM_ID           
 AND DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
 AND REMRM_REQUEST_DT BETWEEN EFF_FROM AND EFF_TO
 AND  ENTM_SHORT_NAME = CASE WHEN LEFT(@L_DPID,2)='IN' THEN dispR_rta_cd ELSE 'RTA_'+dispR_rta_cd END        
 AND  ENTM_ENTTM_CD =  CASE WHEN LEFT(@L_DPID,2)='IN' THEN 'SR' ELSE 'RTA' END        
 AND  ISIN_CD = REMRM_ISIN        
 AND REMRM_DELETED_IND = 1
 AND ENTM_DELETED_IND = 1
 ORDER BY ISIN_NAME,DISPR_DT 
 
  --              
  END          
 IF @PA_ACTION = 'OUT_CLT_DISP_RPT'          
 BEGIN          
  UPDATE A SET A_CLICM_CD = DPAM_CLICM_CD 
  FROM #ACLIST A,DP_ACCT_MSTR M WHERE A.DPAM_ID = M.DPAM_ID

         
   SELECT DPAM_SBA_NO,DPAM_SBA_NAME,REMRM_ID,REMRM_ISIN+'/'+ISIN_NAME REMRM_ISIN,REMRM_TRANSACTION_NO RRN,REMRM_SLIP_SERIAL_NO RRF,REMRM_DPAM_ID                     
  ,CONVERT(VARCHAR,REMRM_REQUEST_DT,103) REMRM_REQUEST_DT ,ISNULL(REMRM_EXECUTION_DT,'') ,convert(numeric(18,3),REMRM_QTY) QTY, ISNULL(DISPR_TYPE,'')                      
  ,CONVERT(VARCHAR,DISPR_DT,103),ISNULL(DISPR_NAME,''),ISNULL(DISPR_CONF_RECD,'') DISP_CONF_RECD                      
  ,CLICM.CLICM_DESC CATEGORY,ISNULL(REMRM_CERTIFICATE_NO,'0') NO_OF_CERTIFICATE          
  ,ISNULL(DPHD_SH_FNAME,'') SECONDHOLDER,ISNULL(DPHD_TH_FNAME,'') THIRDHOLDER, DESCP REJ , CASE WHEN ISNULL(REMRM_COMPANY_OBJ,'') <> '' THEN 'COMP' ELSE 'INTERNAL' END OBJ_TYPE      
  ,ISNULL(DISPR_DOC_ID,'0') disp_doc_id 
  ,remrm_rmks remarks 
   FROM DMAT_DISPATCH_REMAT , REMAT_REQUEST_MSTR,ISIN_MSTR,#ACLIST  LEFT OUTER JOIN DP_HOLDER_DTLS DPHD ON DPHD_DPAM_ID = DPAM_ID    
         AND DPHD_DELETED_IND=1    
       ,CLIENT_CTGRY_MSTR CLICM           
      ,citrus_usr.FN_GETSUBTRANSDTLS('DEMAT_REJ_CD_NSDL')       
      WHERE REMRM_ID = DISPR_REMRM_ID 
	AND DISPR_DT >= @PA_FROM_DT AND DISPR_DT <= @PA_TO_DT    
	AND ISNULL(DISPR_TO,'') = 'C'             
	AND ISNULL(DISPR_CONF_RECD,'') = ''            
	AND (ISNULL(REMRM_INTERNAL_REJ,'')  <> '' OR ISNULL(REMRM_COMPANY_OBJ,'') <> '')      
	AND (ISNULL(REMRM_INTERNAL_REJ,'')  = CD OR ISNULL(REMRM_COMPANY_OBJ,'') = CD)      
	AND REMRM_DPAM_ID = DPAM_ID       
	AND DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
	AND REMRM_REQUEST_DT BETWEEN EFF_FROM AND EFF_TO
	AND REMRM_ISIN = ISIN_CD
    AND A_CLICM_CD=CLICM_CD          
	AND CLICM_DELETED_IND=1 
	ORDER BY DISPR_DT,DPAM_SBA_NAME         

 END    
IF @PA_ACTION = 'DEMAT_ACK_CLIENT'          
 BEGIN          
		SELECT DPAM_SBA_NO    
		,DPAM_SBA_NAME    
		,REMRM_ID    
		,REMRM_ISIN    
		,ISIN_NAME    
		,INSM_DESC SECTYPE    
		,ISNULL(REMRM_TRANSACTION_NO,0) RRN    
		,REMRM_SLIP_SERIAL_NO RRF    
		,REMRM_DPAM_ID                     
		,ISNULL(REMRM_REQUEST_DT,'') REMRM_REQUEST_DT     
		,ISNULL(REMRM_EXECUTION_DT,'') REMRM_EXECUTION_DT     
		,convert(numeric(18,3),REMRM_QTY) QTY    
		,ISNULL(REMRM_CERTIFICATE_NO,'0') NO_OF_CERTIFICATE          
		,ISNULL(DPHD_SH_FNAME,'') SECONDHOLDER,ISNULL(DPHD_TH_FNAME,'') THIRDHOLDER 
		FROM REMAT_REQUEST_MSTR,#ACLIST
		LEFT OUTER JOIN DP_HOLDER_DTLS DPHD ON DPHD_DPAM_ID = DPAM_ID AND DPHD_DELETED_IND=1       
		,ISIN_MSTR    
		,INSTRUMENT_MSTR       
		WHERE REMRM_REQUEST_DT >= @PA_FROM_DT AND REMRM_REQUEST_DT <= @PA_TO_DT    
		AND (ISNULL(REMRM_INTERNAL_REJ,'')  = '' and ISNULL(REMRM_COMPANY_OBJ,'') = '')      
		AND REMRM_DPAM_ID = DPAM_ID       
		AND DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
		AND REMRM_REQUEST_DT BETWEEN EFF_FROM AND EFF_TO
		AND REMRM_ISIN = ISIN_CD    
		AND ISIN_INSM_ID = INSM_ID  
		AND ISIN_DELETED_IND =1           
		AND INSM_DELETED_IND =1 
        ORDER BY REMRM_REQUEST_DT,DPAM_SBA_NAME   
 
 END    
          
  -- ALL DEMAT ACTIVITIES REPORT          
end

GO
