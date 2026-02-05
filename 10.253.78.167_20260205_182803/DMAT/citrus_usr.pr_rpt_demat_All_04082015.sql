-- Object: PROCEDURE citrus_usr.pr_rpt_demat_All_04082015
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--
-- 3 OUT_CLT_DISP_RPT HO ALL 21/10/2008 22/10/2008         0     
-- select * from dp_mstr where default_dp = dpm_excsm_id
-- 3	OUT_CLT_DISP_RPT	HO	ALL	22/10/2008	23/10/2008									0			  
-- [pr_rpt_demat_All] '4','OUT_RTA_DISP_RPT','feb 17 2008','feb 17 2010','','','0',1,'|*~|',''   
 --  pr_rpt_demat_All	'3','DMT_REQ_VIOLATION_RPT_MAKER','3/12/2009 12:00:00 AM','4/12/2010 12:00:00 AM','','','0',1,'HO|*~|12/03/2009|*~|12/04/2010|*~|',''	                  
-- pr_rpt_demat_sel	'3','PEND_DMT_RTA_RPT','BHAVIN','','22/10/2008','23/10/2008','','','','','','','','',0,	'','',''	
-- 3 OUT_RTA_DISP_RPT HO  13/07/2008 13/08/2008         0         
create PROCEDURE [citrus_usr].[pr_rpt_demat_All_04082015]                                      
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
 
 --select * from drf_data_mosl
 --return
         
                                      
DECLARE @@L_DPM_ID BIGINT,
@L_DPID VARCHAR(8),
@@SSQL VARCHAR(8000),
@@l_child_entm_id BIGINT

select @@L_DPM_ID = dpm_id,@L_DPID=DPM_DPID from dp_mstr where default_dp = @PA_EXCSM_ID and dpm_deleted_ind =1      
IF @PA_FROM_ACCT  <>''           
SELECT @PA_FROM_ACCT = LEFT(@L_DPID,8)+RIGHT(@PA_FROM_ACCT,8)
IF @PA_TO_ACCT  <>''
SELECT @PA_TO_ACCT = LEFT(@L_DPID,8)+RIGHT(@PA_TO_ACCT,8)
        
select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                      
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME,A_CLICM_CD VARCHAR(10))
IF @PA_ACTION <> 'OUT_RTA_DISP_RPT'   
begin 
INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO,'2100-12-31 00:00:00.000')
,NULL FROM citrus_usr.fn_acct_list(@@L_DPM_ID ,@PA_LOGIN_PR_ENTM_ID,@@l_child_entm_id)		
end 

IF @PA_FROM_ACCT = ''                      
 BEGIN                      
  SET @PA_FROM_ACCT = '0'                      
  SET @PA_TO_ACCT = '99999999999999999'                      
 END                      
 IF @PA_TO_ACCT = ''                      
 BEGIN                  
   SET @PA_TO_ACCT = @PA_FROM_ACCT                      
 END                      
                                
IF @PA_ACTION = 'DMT_REQ_VIOLATION_RPT_MAKER'                                    
 BEGIN                                      
 --               
     if (@PA_NO_OF_DAYS='0') -- 1 mean ho
		 begin 
			 SELECT DISTINCT DPAM_SBA_NO , DPAM_SBA_NAME , DEMRM_ISIN ,ISIN_NAME, '-' DRN, DEMRM_SLIP_SERIAL_NO DRF,           
			 CONVERT(VARCHAR,DEMRM_REQUEST_DT,103) DEMRM_REQUEST_DT, convert(numeric(18,3),ABS(DEMRM_QTY)) QTY,ENTM_NAME1           
			 FROM demrm_mak left outer join DMAT_DISPATCH on DEMRM_ID=DISP_DEMRM_ID  
			 ,#ACLIST,ISIN_MSTR, entity_mstr,login_names          
			 WHERE DEMRM_REQUEST_DT >= @PA_FROM_DT AND DEMRM_REQUEST_DT <= @PA_TO_DT    
			 AND DEMRM_DPAM_ID = DPAM_ID  
			 AND DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
			 AND DEMRM_REQUEST_DT BETWEEN EFF_FROM AND EFF_TO
			 AND DEMRM_ISIN = ISIN_CD
			 --AND DATEDIFF(DD,DEMRM_REQUEST_DT,GETDATE())>= @PA_NO_OF_DAYS      
             AND entm_short_name = LOGN_SHORT_NAME and logn_name =  DEMRM_CREATED_BY           
			 AND ISNULL(DEMRM_INTERNAL_REJ,'')  = ''       
			 AND ISNULL(DEMRM_COMPANY_OBJ,'') = ''      
			 AND ISNULL(DEMRM_CREDIT_RECD,'') <> 'Y'         
			 and isnull(disp_id,0) = 0               
			 and demrm_deleted_ind = 0
             and entm_short_name ='HO'
		 end 
     else
         begin 
			 SELECT DISTINCT DPAM_SBA_NO , DPAM_SBA_NAME , DEMRM_ISIN ,ISIN_NAME, '-' DRN, DEMRM_SLIP_SERIAL_NO DRF,           
			 CONVERT(VARCHAR,DEMRM_REQUEST_DT,103) DEMRM_REQUEST_DT, convert(numeric(18,3),ABS(DEMRM_QTY)) QTY,ENTM_NAME1           
			 FROM demrm_mak left outer join DMAT_DISPATCH on DEMRM_ID=DISP_DEMRM_ID  
			 ,#ACLIST,ISIN_MSTR,entity_mstr,login_names          
			 WHERE DEMRM_REQUEST_DT >= @PA_FROM_DT AND DEMRM_REQUEST_DT <= @PA_TO_DT    
			 AND DEMRM_DPAM_ID = DPAM_ID  
			 AND DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
			 AND DEMRM_REQUEST_DT BETWEEN EFF_FROM AND EFF_TO
			 AND DEMRM_ISIN = ISIN_CD
             AND entm_short_name = LOGN_SHORT_NAME and logn_name =  DEMRM_CREATED_BY   
			 --AND DATEDIFF(DD,DEMRM_REQUEST_DT,GETDATE())>= @PA_NO_OF_DAYS               
			 AND ISNULL(DEMRM_INTERNAL_REJ,'')  = ''       
			 AND ISNULL(DEMRM_COMPANY_OBJ,'') = ''      
			 AND ISNULL(DEMRM_CREDIT_RECD,'') <> 'Y'         
			 and isnull(disp_id,0) = 0               
			 and demrm_deleted_ind = 0
             order by entm_name1 
         end
  --              
  END              
        
IF @PA_ACTION = 'DMT_REQ_VIOLATION_RPT'                                    
 BEGIN                                      
 --               
	 SELECT DPAM_SBA_NO , DPAM_SBA_NAME , DEMRM_ISIN ,ISIN_NAME, isnull(DEMRM_TRANSACTION_NO,0) DRN, DEMRM_SLIP_SERIAL_NO DRF,           
	 CONVERT(VARCHAR,DEMRM_REQUEST_DT,103) DEMRM_REQUEST_DT, convert(numeric(18,3),ABS(DEMRM_QTY)) QTY           
	 FROM DEMAT_REQUEST_MSTR left outer join DMAT_DISPATCH on DEMRM_ID=DISP_DEMRM_ID  
	 ,#ACLIST,ISIN_MSTR          
	 WHERE DEMRM_REQUEST_DT >= @PA_FROM_DT AND DEMRM_REQUEST_DT <= @PA_TO_DT    
	 AND DEMRM_DPAM_ID = DPAM_ID  
     AND DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
	 AND DEMRM_REQUEST_DT BETWEEN EFF_FROM AND EFF_TO
	 AND DEMRM_ISIN = ISIN_CD
	 AND DATEDIFF(DD,DEMRM_REQUEST_DT,GETDATE())>= @PA_NO_OF_DAYS               
	AND ISNULL(DEMRM_INTERNAL_REJ,'')  = ''       
	AND ISNULL(DEMRM_COMPANY_OBJ,'') = ''      
	AND ISNULL(DEMRM_CREDIT_RECD,'') <> 'Y'         
	 and isnull(disp_id,0) = 0               
	 and demrm_deleted_ind = 1
  --              
  END           
          
 IF @PA_ACTION = 'OUT_RTA_DISP_RPT'                                    
 BEGIN                                      
 --  
 
 CREATE TABLE #ACLIST_DRF(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME,A_CLICM_CD VARCHAR(10))
INSERT INTO #ACLIST_DRF 
SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO,'2100-12-31 00:00:00.000')
,NULL 
FROM citrus_usr.fn_acct_list_disp_drf(@@L_DPM_ID ,@PA_LOGIN_PR_ENTM_ID,@@l_child_entm_id,'0','9999999999999999')		
--FROM citrus_usr.fn_acct_list(@@L_DPM_ID ,@PA_LOGIN_PR_ENTM_ID,@@l_child_entm_id)		
  
              
  UPDATE A SET A_CLICM_CD = DPAM_CLICM_CD 
  FROM #ACLIST_DRF A,DP_ACCT_MSTR M WHERE A.DPAM_ID = M.DPAM_ID

  SELECT DPAM_ID,DPAM_SBA_NO , DPAM_SBA_NAME , DEMRM_ISIN +'-'+ ISIN_NAME DEMRM_ISIN 
  , DEMRM_TRANSACTION_NO DRN, DEMRM_SLIP_SERIAL_NO DRF
  , DEMRD_FOLIO_NO,DEMRD_DISTINCTIVE_NO_FR,DEMRD_DISTINCTIVE_NO_TO, DEMRD_CERT_NO
  ,DEMRD_QTY DEMRD_QTY,         
  CONVERT(VARCHAR,DEMRM_REQUEST_DT,103) DEMRM_REQUEST_DT
  , convert(numeric(18,3),ABS(DEMRd_QTY)) QTY
  ,CLICM.CLICM_DESC CATEGORY,ISNULL(DEMRM_TOTAL_CERTIFICATES,'0') NO_OF_CERTIFICATE          
  ,ISNULL(DPHD_SH_FNAME,'') SECONDHOLDER,ISNULL(DPHD_TH_FNAME,'') THIRDHOLDER 
  , DEMRM_FREE_LOCKEDIN_YN  LOCKIN
  , ENTM_NAME1+'-'+  isnull(isin_adr1,'') ISIN_NAME         
  --,case when len(dpam_sba_no) = 16 then ENTM_NAME1 + '<BR>' + isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),1),'') else isnull(isin_adr1,'') end  adr1                          
  --, case when len(dpam_sba_no) = 16 then isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),2),'') else  isnull(isin_adr2,'') end                           
  --+ '<Br>'+ case when len(dpam_sba_no) = 16 then isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),3),'') else  isnull(isin_adr3,'') end adr2                          
  --, case when len(dpam_sba_no) = 16 then isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),4),'') else isnull(isin_adrcity,'') end adr_city                          
  --, case when len(dpam_sba_no) = 16 then isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),5),'') else  isnull(isin_adrstate,'') end  adr_state                          
  --, case when len(dpam_sba_no) = 16 then isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),6),'') else  isnull(isin_adrcountry,'') end adr_country                          
  --, case when len(dpam_sba_no) = 16 then isnull(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),7),'') else isnull(isin_adrzip,'') end adr_zip
  ,case when len(dpam_sba_no) = 16 then ENTM_NAME1 + '<BR>' +  isnull(isin_adr1,'') else '' end adr1                          
  , case when len(dpam_sba_no) = 16 then  isnull(isin_adr2,'') else '' end      
  + '<Br>'+ case when len(dpam_sba_no) = 16 then   isnull(isin_adr3,'') else ''  end adr2                          
  , case when len(dpam_sba_no) = 16 then isnull(isin_adrcity,'') else ''  end adr_city                          
  , case when len(dpam_sba_no) = 16 then  isnull(isin_adrstate,'') else '' end  adr_state                          
  , case when len(dpam_sba_no) = 16 then  isnull(isin_adrcountry,'') else '' end adr_country                          
  , case when len(dpam_sba_no) = 16 then isnull(isin_adrzip,'') else '' end adr_zip
, CONVERT(VARCHAR,DISP_DT,103) disp_dt , ''  rta_name
, ISNULL(DISP_DOC_ID,'0') disp_doc_id,disp_type =ISNULL(disp_type,'N')  
, isnull(isin_contactperson,'') contact_person
, datediff(dd,DISP_DT,getdate()) Duration
,DISP_REMINDER,DISP_DEMRM_ID,DISP_ID,ENTM_NAME1, isnull(isin_adr1,'') replacestr
	into #tempdrf FROM DEMAT_REQUEST_MSTR 
	, DMAT_DISPATCH,DEMAT_REQUEST_dtls
	, #ACLIST_DRF LEFT OUTER JOIN DP_HOLDER_DTLS DPHD   ON   DPHD_DPAM_ID = DPAM_ID      AND DPHD_DELETED_IND = 1 
	,CLIENT_CTGRY_MSTR CLICM, ISIN_MSTR , ENTITY_MSTR         
	WHERE 	DEMRM_DPAM_ID = DPAM_ID  
    and demrm_id = DEMRD_DEMRM_ID     
	AND DISP_DT >= @PA_FROM_DT AND DISP_DT <= @PA_TO_DT    
    AND ISNULL(DISP_TO,'') = 'R'   
	AND disp_type ='N'  
	AND DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
	AND DEMRM_REQUEST_DT BETWEEN EFF_FROM AND EFF_TO
	AND ISNULL(DEMRM_INTERNAL_REJ,'')  = ''       
	AND ISNULL(DEMRM_COMPANY_OBJ,'') = ''      
	AND ISNULL(DEMRM_CREDIT_RECD,'') <> 'Y'         
	AND   demrm_id =   DISP_DEMRM_ID    
	AND  ISIN_CD = DEMRM_ISIN        
	AND  ENTM_SHORT_NAME = CASE WHEN LEFT(@L_DPID,2)='IN' THEN ISIN_reg_cd ELSE 'RTA_'+ISIN_reg_cd END        
	AND  ENTM_ENTTM_CD =  CASE WHEN LEFT(@L_DPID,2)='IN' THEN 'SR' ELSE 'RTA' END        
	AND A_CLICM_CD = CLICM_CD          
	AND CLICM_DELETED_IND=1           
    AND DEMRM_DELETED_IND = 1
    AND ENTM_DELETED_IND = 1
	
select DPAM_ID
,DPAM_SBA_NO
,DPAM_SBA_NAME
,DEMRM_ISIN
,DRN
,DRF
,'0' DEMRD_FOLIO_NO
,'0' DEMRD_DISTINCTIVE_NO_FR
,'0' DEMRD_DISTINCTIVE_NO_TO
,'0' DEMRD_CERT_NO
,sum(DEMRD_QTY) DEMRD_QTY
,DEMRM_REQUEST_DT
,sum(QTY) QTY
,CATEGORY
,NO_OF_CERTIFICATE
,SECONDHOLDER
,THIRDHOLDER
,LOCKIN
,ISIN_NAME ISIN_NAME
,adr1
,adr2
,adr_city
,adr_state
,adr_country
,adr_zip
,disp_dt
,rta_name
,disp_doc_id
,disp_type
,contact_person
,Duration
,DISP_REMINDER
,DISP_DEMRM_ID
,DISP_ID from #tempdrf
group by DPAM_ID
,DPAM_SBA_NO
,DPAM_SBA_NAME
,DEMRM_ISIN
,DRN
,DRF,replacestr
--,DEMRD_FOLIO_NO
--,DEMRD_DISTINCTIVE_NO_FR
--,DEMRD_DISTINCTIVE_NO_TO
--,DEMRD_CERT_NO
,DEMRM_REQUEST_DT
,CATEGORY
,NO_OF_CERTIFICATE
,SECONDHOLDER
,THIRDHOLDER
,LOCKIN
,ISIN_NAME
,adr1
,adr2
,adr_city
,adr_state
,adr_country
,adr_zip
,disp_dt
,rta_name
,disp_doc_id
,disp_type
,contact_person
,Duration
,DISP_REMINDER
,DISP_DEMRM_ID
,DISP_ID,entm_name1
ORDER BY ISIN_NAME
,DISP_DT

drop table #tempdrf
  --              
  END          
          


 IF @PA_ACTION = 'PEND_DMT_RTA_RPT'                                    
 BEGIN                                      
 --    

 SELECT DPAM_SBA_NO , DPAM_SBA_NAME , DEMRM_ISIN ,ISIN_NAME, DEMRM_TRANSACTION_NO DRN, DEMRM_SLIP_SERIAL_NO DRF,          
  CONVERT(VARCHAR,DEMRM_REQUEST_DT,103) DEMRM_REQUEST_DT,convert(varchar(11),DISP_DT,103) DISP_DATE,DISP_TYPE= CASE WHEN disp_type = 'N' THEN 'NEW' ELSE 'FOLLOW UP' END,
  convert(numeric(18,3),ABS(DEMRM_QTY)) QTY          
 FROM DEMAT_REQUEST_MSTR , #ACLIST ,DMAT_DISPATCH, ISIN_MSTR , ENTITY_MSTR                   
 WHERE DEMRM_ID = DISP_DEMRM_ID          
 AND DISP_DT >= @PA_FROM_DT AND DISP_DT <= @PA_TO_DT    
 AND  ISNULL(DISP_CONF_RECD,'') <> 'C'          
 AND ISNULL(DISP_TO,'') = 'R'      
 AND ISNULL(DEMRM_INTERNAL_REJ,'') = ''          
 AND ISNULL(DEMRM_COMPANY_OBJ,'') = ''          
 AND DEMRM_DPAM_ID = DPAM_ID           
 AND DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
 AND DEMRM_REQUEST_DT BETWEEN EFF_FROM AND EFF_TO
 AND  ENTM_SHORT_NAME = CASE WHEN LEFT(@L_DPID,2)='IN' THEN disp_rta_cd ELSE 'RTA_'+disp_rta_cd END        
 AND  ENTM_ENTTM_CD =  CASE WHEN LEFT(@L_DPID,2)='IN' THEN 'SR' ELSE 'RTA' END        
 AND  ISIN_CD = DEMRM_ISIN        
 AND DEMRM_DELETED_IND = 1
 AND ENTM_DELETED_IND = 1
 and  ISNULL(DEMRM_CREDIT_RECD,'') <> 'C'  -- this condition will filter out confirm transaction in demat on aug13 2012 by latesh w
--  and not exists (select cdshm_tratm_cd from cdsl_holding_dtls
-- where cdshm_dpam_id=demrm_dpam_id and demrm_isin=cdshm_isin  and cdshm_tratm_cd  in ('2246'))
 ORDER BY ISIN_NAME,DISP_DT 
 
  --              
  END          
 IF @PA_ACTION = 'OUT_CLT_DISP_RPT'          
 BEGIN    
 print 'ppp'
       
  UPDATE A SET A_CLICM_CD = DPAM_CLICM_CD 
  FROM #ACLIST A,DP_ACCT_MSTR M WHERE A.DPAM_ID = M.DPAM_ID
--select * from #ACLIST where dpam_sba_no in ('1201090004837631')

         
print 'sss'
	SELECT distinct   citrus_usr.fn_find_relations_nm_by_dpamno(dpam_sba_no,'BR') brcd  , '' BRDETAILS,DPAM_SBA_NO,DPAM_SBA_NAME,DEMRM_ID,DEMRM_ISIN+'/'+ISIN_NAME DEMRM_ISIN,'' DRN
    ,DEMRM_SLIP_SERIAL_NO DRF,DEMRM_DPAM_ID                     
	,CONVERT(VARCHAR,DEMRM_REQUEST_DT,103) DEMRM_REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') ,convert(numeric(18,3),DEMRM_QTY) QTY, ISNULL(DISP_TYPE,'')                      
	,CONVERT(VARCHAR,DISP_DT,103) ,ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                      
	,CLICM.CLICM_DESC CATEGORY,ISNULL(DEMRM_TOTAL_CERTIFICATES,'0') NO_OF_CERTIFICATE          
	,ISNULL(DPHD_SH_FNAME,'') SECONDHOLDER,ISNULL(DPHD_TH_FNAME,'') THIRDHOLDER , DEMRM_FREE_LOCKEDIN_YN  LOCKIN , case when isnull(demrm_res_desc_intobj,'') <> '' then isnull(demrm_res_desc_intobj,'') else isnull(demrm_res_desc_compobj,'') end REJ --DESCP REJ 
    , CASE WHEN ISNULL(DEMRM_COMPANY_OBJ,'') <> '' THEN 'COMP' ELSE 'INTERNAL' END OBJ_TYPE      
	, ISNULL(DISP_DOC_ID,'0') disp_doc_id  
    ,demrm_RMKS  REMARKS
    ,CONVERT(VARCHAR,GETDATE(),103) DEMRM_LST_UPD_DT -- CHNAGING AS PER MOSL REQUEST ON 15032013,CONVERT(VARCHAR,DEMRM_LST_UPD_DT,103) DEMRM_LST_UPD_DT
    FROM DMAT_DISPATCH , DEMRM_mak left outer join ISIN_MSTR on  DEMRM_ISIN = ISIN_CD 
,#ACLIST  LEFT OUTER JOIN DP_HOLDER_DTLS DPHD ON DPHD_DPAM_ID = DPAM_ID   
	AND DPHD_DELETED_IND=1    
	,CLIENT_CTGRY_MSTR CLICM           
	--,citrus_usr.FN_GETSUBTRANSDTLS('DEMAT_REJ_CD_NSDL')       
	WHERE DEMRM_ID = DISP_DEMRM_ID 
	AND DISP_DT >= @PA_FROM_DT AND DISP_DT <= @PA_TO_DT  
	AND ISNULL(DISP_TO,'') = 'C'             
	--AND ISNULL(DISP_CONF_RECD,'') = 'D'            
	--AND (ISNULL(DEMRM_INTERNAL_REJ,'')  <> '' OR ISNULL(DEMRM_COMPANY_OBJ,'') <> '')      
	--AND (ISNULL(DEMRM_INTERNAL_REJ,'')  = CD OR ISNULL(DEMRM_COMPANY_OBJ,'') = CD)    
    AND (ISNULL(demrm_res_cd_intobj,'') <> '' or ISNULL(demrm_res_cd_compobj,'') <> '')       
	AND DEMRM_DPAM_ID = DPAM_ID       
	AND DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
	AND DEMRM_REQUEST_DT BETWEEN EFF_FROM AND EFF_TO
	
    AND A_CLICM_CD=CLICM_CD          
	AND CLICM_DELETED_IND=1 
  and demrm_deleted_ind = 0
union all 

SELECT distinct citrus_usr.fn_find_relations_nm_by_dpamno(dpam_sba_no,'BR') brcd,'' BRDETAILS,DPAM_SBA_NO,DPAM_SBA_NAME,DEMRM_ID,DEMRM_ISIN+'/'+ISIN_NAME DEMRM_ISIN,DEMRM_TRANSACTION_NO DRN
    ,DEMRM_SLIP_SERIAL_NO DRF,DEMRM_DPAM_ID                     
	,CONVERT(VARCHAR,DEMRM_REQUEST_DT,103) DEMRM_REQUEST_DT ,ISNULL(DEMRM_EXECUTION_DT,'') ,convert(numeric(18,3),DEMRM_QTY) QTY, ISNULL(DISP_TYPE,'')                      
	,CONVERT(VARCHAR,DISP_DT,103) ,ISNULL(DISP_DOC_ID,'0'),ISNULL(DISP_NAME,''),ISNULL(DISP_CONF_RECD,'') DISP_CONF_RECD                      
	,CLICM.CLICM_DESC CATEGORY,ISNULL(DEMRM_TOTAL_CERTIFICATES,'0') NO_OF_CERTIFICATE          
	,ISNULL(DPHD_SH_FNAME,'') SECONDHOLDER,ISNULL(DPHD_TH_FNAME,'') THIRDHOLDER , DEMRM_FREE_LOCKEDIN_YN  LOCKIN , case when isnull('','') <> '' then isnull('','') else isnull(DESCP,'') end REJ --DESCP REJ 
    , CASE WHEN ISNULL(DEMRM_COMPANY_OBJ,'') <> '' THEN 'COMP' ELSE 'INTERNAL' END OBJ_TYPE      
	, ISNULL(DISP_DOC_ID,'0') disp_doc_id  
    ,demrm_RMKS  REMARKS
  ,CONVERT(VARCHAR,GETDATE(),103) DEMRM_LST_UPD_DT --,CONVERT(VARCHAR,DEMRM_LST_UPD_DT,103) DEMRM_LST_UPD_DT
    FROM DMAT_DISPATCH , demat_request_mstr left outer join ISIN_MSTR on  DEMRM_ISIN = ISIN_CD
,#ACLIST  LEFT OUTER JOIN DP_HOLDER_DTLS DPHD ON DPHD_DPAM_ID = DPAM_ID    
	AND DPHD_DELETED_IND=1    
	,CLIENT_CTGRY_MSTR CLICM           
	,citrus_usr.FN_GETSUBTRANSDTLS('DEMAT_REJ_CD_NSDL')       
	WHERE DEMRM_ID = DISP_DEMRM_ID 
	AND DISP_DT >= @PA_FROM_DT AND DISP_DT <= @PA_TO_DT  
	AND ISNULL(DISP_TO,'') = 'C'             
	--AND ISNULL(DISP_CONF_RECD,'') = 'D'            
	--AND (ISNULL(DEMRM_INTERNAL_REJ,'')  <> '' OR ISNULL(DEMRM_COMPANY_OBJ,'') <> '')      
	AND (ISNULL(DEMRM_COMPANY_OBJ,'') = CD)    
    AND (ISNULL(DEMRM_COMPANY_OBJ,'') <> '')       
	AND DEMRM_DPAM_ID = DPAM_ID       
	AND DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
	AND DEMRM_REQUEST_DT BETWEEN EFF_FROM AND EFF_TO
	
    AND A_CLICM_CD=CLICM_CD          
	AND CLICM_DELETED_IND=1 
  and demrm_deleted_ind = 1
	ORDER BY DPAM_SBA_NO,DPAM_SBA_NAME,DEMRM_ID 
    ,DEMRM_SLIP_SERIAL_NO ,DEMRM_DPAM_ID      

 END    
IF @PA_ACTION = 'DEMAT_ACK_CLIENT'          
BEGIN          
		SELECT DPAM_SBA_NO    
		,DPAM_SBA_NAME    
		,DEMRM_ID    
		,DEMRM_ISIN    
		,ISIN_NAME    
		,INSM_DESC SECTYPE    
		,ISNULL(DEMRM_TRANSACTION_NO,0) DRN    
		,DEMRM_SLIP_SERIAL_NO DRF    
		,DEMRM_DPAM_ID                     
		,ISNULL(DEMRM_REQUEST_DT,'') DEMRM_REQUEST_DT     
		,ISNULL(DEMRM_EXECUTION_DT,'') DEMRM_EXECUTION_DT     
		,convert(numeric(18,3),DEMRM_QTY) QTY    
		,ISNULL(DEMRM_TOTAL_CERTIFICATES,'0') NO_OF_CERTIFICATE          
		,ISNULL(DPHD_SH_FNAME,'') SECONDHOLDER,ISNULL(DPHD_TH_FNAME,'') THIRDHOLDER , DEMRM_FREE_LOCKEDIN_YN  LOCKIN     
		FROM DEMAT_REQUEST_MSTR,#ACLIST
		LEFT OUTER JOIN DP_HOLDER_DTLS DPHD ON DPAM_ID = DPHD_DPAM_ID  AND DPHD_DELETED_IND=1   
		,ISIN_MSTR    
		,INSTRUMENT_MSTR       
		WHERE DEMRM_REQUEST_DT >= @PA_FROM_DT AND DEMRM_REQUEST_DT <= @PA_TO_DT    
		AND (ISNULL(DEMRM_INTERNAL_REJ,'')  = '' and ISNULL(DEMRM_COMPANY_OBJ,'') = '')      
		AND DEMRM_DPAM_ID = DPAM_ID       
		AND DPAM_SBA_NO >= @PA_FROM_ACCT AND DPAM_SBA_NO  <= @PA_TO_ACCT
		AND DEMRM_REQUEST_DT BETWEEN EFF_FROM AND EFF_TO
		AND DEMRM_ISIN = ISIN_CD    
		AND ISIN_INSM_ID=INSM_ID  
		AND ISIN_DELETED_IND =1           
		AND INSM_DELETED_IND =1  
        ORDER BY DEMRM_REQUEST_DT,DPAM_SBA_NAME         
 
 END    
          
  -- ALL DEMAT ACTIVITIES REPORT          
end

GO
