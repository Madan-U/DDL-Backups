-- Object: PROCEDURE citrus_usr.pr_rpt_slipstatus
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_rpt_slipstatus 'CDSL',3,'123',1,''       
--pr_rpt_slipstatus 'NSDL',4,'13026',1,''         
CREATE procedure [citrus_usr].[pr_rpt_slipstatus]      
@pa_dptype varchar(4),                
@pa_excsmid int,                
@slipno varchar(20),      
@pa_login_pr_entm_id numeric,                  
@pa_output varchar(8000) output                  
as      
begin      
      
      
 declare @@dpmid int,
 @@series varchar(20),
 @@Only_Slipno varchar(20)                
                 
 select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1         
      
 if (@pa_dptype = 'NSDL')                
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
      

Select @@series=slibm_series_type from slip_book_mstr where  ISNULL(SLIBM_SERIES_TYPE,'') = SUBSTRING(@slipno,1,LEN(ISNULL(SLIBM_SERIES_TYPE,'')))
and isnumeric(replace(@slipno,ltrim(rtrim(SLIBM_SERIES_TYPE)),''))=1
AND replace(@slipno,ltrim(rtrim(SLIBM_SERIES_TYPE)),'')
BETWEEN SLIBM_FROM_NO AND SLIBM_TO_NO 
AND SLIBM_DELETED_IND=1  



SET @@Only_Slipno = REPLACE(ltrim(rtrim(@slipno)),ltrim(rtrim(@@series)),'')  
    

print @@Only_Slipno

 CREATE TABLE #transnsdl      
 (
 DPAM_ID BIGINT,
 DPAM_SBA_NAME VARCHAR(100),      
 DPAM_SBA_NO VARCHAR(8),      
 SLIP_NO VARCHAR(20),      
 TRANS_NO VARCHAR(20),                
 TRASTM_CD VARCHAR(5),                
 EXECUTION_DT DATETIME,                
 ISIN VARCHAR(12),      
 QTY NUMERIC(18,3),      
 STATUS VARCHAR(50),      
 CANCEL_STATUS VARCHAR(50),
 Sett_type varchar(20), -- New from LateshW May 25 2009
 sett_no varchar(20),
 other_sett_type varchar(20), 
 other_sett_no varchar(20),
 ctr_demat_acct_no varchar(20),
 ctr_dp_id varchar(20),
 ctr_cmbp_id varchar(20),
 int_ref_no varchar(20),
 transaction_no varchar(20),      
 )

      
 CREATE TABLE #transnsdl_1      
 (
 DPAM_ID BIGINT,
 DPAM_SBA_NAME VARCHAR(100),      
 DPAM_SBA_NO VARCHAR(8),      
 SLIP_NO VARCHAR(20),      
 TRANS_NO VARCHAR(20),                
 TRASTM_CD VARCHAR(5),                
 EXECUTION_DT DATETIME,                
 ISIN VARCHAR(12),      
 QTY NUMERIC(18,3),      
 STATUS VARCHAR(50),      
 CANCEL_STATUS VARCHAR(50),
 Sett_type varchar(20), -- New from LateshW May 25 2009
 sett_no varchar(20),
 other_sett_type varchar(20), 
 other_sett_no varchar(20),
 ctr_demat_acct_no varchar(20),
 ctr_dp_id varchar(20),
 ctr_cmbp_id varchar(20),
 int_ref_no varchar(20),
 transaction_no varchar(20),              
 )



-- FOR UNUSED SLIP TRANSACTIONS      

 INSERT INTO #transnsdl(DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,TRASTM_CD,EXECUTION_DT,ISIN,QTY,STATUS,CANCEL_STATUS,sett_type,sett_no,other_sett_type,other_sett_no,ctr_demat_acct_no,ctr_dp_id,ctr_cmbp_id,int_ref_no,transaction_no)    
 SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,@slipno,isnull('',''),trastm_cd,sliim_created_dt,'',0               
 ,STATUS='SLIP ISSUED (NOT USED)',ERR_MSG='',sett_type='',sett_no='',other_sett_type='',other_sett_no='',ctr_demat_acct_no='',ctr_dp_id='',ctr_cmbp_id='',int_ref_no='',transaction_no='' --,0      
 FROM slip_issue_mstr   D ,  transaction_sub_type_mstr ,              
 citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) ACCOUNT
 WHERE    SLIIM_TRATM_ID =   trastm_id
 and convert(bigint,@@Only_Slipno) between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO 
 AND SLIIM_DPAM_ACCT_NO = ACCOUNT.DPAM_SBA_NO      
 and not exists (select USES_SLIP_NO from used_slip where USES_SLIP_NO = @@Only_Slipno and USES_SERIES_TYPE = @@series and uses_deleted_ind = 1) 
 and sliim_series_type=@@series


 union            

 --SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,@slipno,isnull('',''),trastm_cd,dptd_created_dt,dptd_isin,dptd_qty                
 SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,@slipno,isnull('',''),trastm_cd,DPTD_EXECUTION_DT,dptd_isin,dptd_qty                
 ,STATUS='SLIP USED (UNAPPROVED)',ERR_MSG='',isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  DPTD_MKT_TYPE AND SETTM_DELETED_IND = 1),''),isnull(DPTD_SETTLEMENT_NO,''),isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  DPTD_OTHER_SETTLEMENT_TYPE AND SETTM_DELETED_IND = 1),''),isnull(DPTD_OTHER_SETTLEMENT_NO,''),isnull(DPTD_COUNTER_DEMAT_ACCT_NO,''),isnull(DPTD_COUNTER_DP_ID,''),isnull(DPTD_COUNTER_CMBP_ID,''),isnull(dptd_slip_no,''),isnull(dptd_trans_no,'')--,0      
 FROM slip_issue_mstr   D , dptd_mak ,  transaction_sub_type_mstr ,              
 citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) ACCOUNT
 WHERE    SLIIM_TRATM_ID =   trastm_id
 and dptd_slip_no = @slipno
 and convert(bigint,@@Only_Slipno) between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO 
 AND SLIIM_DPAM_ACCT_NO = ACCOUNT.DPAM_SBA_NO      
 and dptd_deleted_ind = 0  
and sliim_series_type=@@series

 union            

-- SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,@slipno,isnull('',''),trastm_cd,dptd_lst_upd_dt,dptd_isin,dptd_qty               
  SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,@slipno,isnull('',''),trastm_cd,DPTD_EXECUTION_DT,dptd_isin,dptd_qty               
,STATUS='SLIP USED (CHECKER APPROVED)',ERR_MSG='',isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  dptd_mkt_type AND SETTM_DELETED_IND = 1),''),isnull(DPTD_SETTLEMENT_NO,''),isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  dptd_other_settlement_type AND SETTM_DELETED_IND = 1),''),isnull(DPTD_OTHER_SETTLEMENT_NO,''),isnull(DPTD_COUNTER_DEMAT_ACCT_NO,''),isnull(DPTD_COUNTER_DP_ID,''),isnull(DPTD_COUNTER_CMBP_ID,''),isnull(dptd_slip_no,''),isnull(dptd_trans_no,'')--,0      --,0      
 FROM slip_issue_mstr   D , dp_trx_dtls ,  transaction_sub_type_mstr ,              
 citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) ACCOUNT
 WHERE    SLIIM_TRATM_ID =   trastm_id
 and dptd_slip_no = @slipno
 and isnull(DPTD_TRANS_NO,'') = ''
 and convert(bigint,@@Only_Slipno) between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO 
 AND SLIIM_DPAM_ACCT_NO = ACCOUNT.DPAM_SBA_NO      
 and dptd_deleted_ind = 1  
and sliim_series_type=@@series

 union            

-- SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,@slipno,isnull('',''),trastm_cd,dptd_lst_upd_dt,dptd_isin,dptd_qty               
 SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,@slipno,isnull('',''),trastm_cd,DPTD_EXECUTION_DT,dptd_isin,dptd_qty               
,STATUS='BATCH GENERATED',ERR_MSG='',isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  dptd_mkt_type AND SETTM_DELETED_IND = 1),''),isnull(DPTD_SETTLEMENT_NO,''),isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  dptd_other_settlement_type AND SETTM_DELETED_IND = 1),''),isnull(DPTD_OTHER_SETTLEMENT_NO,''),isnull(DPTD_COUNTER_DEMAT_ACCT_NO,''),isnull(DPTD_COUNTER_DP_ID,''),isnull(DPTD_COUNTER_CMBP_ID,''),isnull(dptd_slip_no,''),isnull(dptd_trans_no,'')--,0      --,0      
 FROM slip_issue_mstr   D , dp_trx_dtls ,  transaction_sub_type_mstr ,              
 citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) ACCOUNT
 WHERE    SLIIM_TRATM_ID =   trastm_id
 and dptd_slip_no = @slipno
 and isnull(DPTD_TRANS_NO,'')<> ''
 and convert(bigint,@@Only_Slipno) between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO 
 AND SLIIM_DPAM_ACCT_NO = ACCOUNT.DPAM_SBA_NO      
 and dptd_deleted_ind = 1  
and sliim_series_type=@@series

 -- FOR COD TRANSACTIONS      
 INSERT INTO #transnsdl(DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,TRASTM_CD,EXECUTION_DT,ISIN,QTY,STATUS,CANCEL_STATUS,sett_type,sett_no,other_sett_type,other_sett_no,ctr_demat_acct_no,ctr_dp_id,ctr_cmbp_id,int_ref_no,transaction_no)      
 select DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,CODD_SLIP_NO,CODD_TRX_NO,CODD_TRX_TYP,CODD_STATUS_CHNG_DTTIME,CODD_ISIN,CODD_QTY,CODD_ORD_STATUS_TO,CODD_CANC_STATUS_TO,
 (SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  codd_mkt_typ AND SETTM_DELETED_IND = 1),CODD_SETTNO,(SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  codd_other_mkttyp AND SETTM_DELETED_IND = 1),CODD_OTHER_SETTNO,CODD_OTHER_CLTID,CODD_OTHER_RELATED_DPID,CODD_OTHER_CMBPID,CODD_SLIP_NO,CODD_TRX_NO      
 FROM                 
 COD_DTLS,       
 citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) account                
 WHERE        
 CODD_SLIP_NO = @slipno      
 AND CODD_CLT_ID = account.DPAM_SBA_NO        
 AND CODD_DELETED_IND = 1      
 ORDER BY CODD_STATUS_CHNG_DTTIME,CODD_LST_R           
 -- FOR COD TRANSACTIONS      
      
   -- FOR BO DELIVERY TRANSACTIONS      
   INSERT INTO #transnsdl(DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,TRASTM_CD,EXECUTION_DT,ISIN,QTY,STATUS,CANCEL_STATUS,sett_type,sett_no,other_sett_type,other_sett_no,ctr_demat_acct_no,ctr_dp_id,ctr_cmbp_id,int_ref_no,transaction_no)      
   select DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,DPTD_SLIP_NO,DPTD_TRANS_NO,DPTD_TRASTM_CD,DPTD_EXECUTION_DT,DPTD_ISIN,DPTD_QTY,DPTD_STATUS,'',      
   isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  dptd_mkt_type AND SETTM_DELETED_IND = 1),''),isnull(DPTD_SETTLEMENT_NO,''),isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  dptd_other_settlement_type AND SETTM_DELETED_IND = 1),''),isnull(DPTD_OTHER_SETTLEMENT_NO,''),isnull(DPTD_COUNTER_DEMAT_ACCT_NO,''),isnull(DPTD_COUNTER_DP_ID,''),isnull(DPTD_COUNTER_CMBP_ID,''),isnull(dptd_slip_no,''),isnull(dptd_trans_no,'')--,0      --,0      
   FROM                 
   DP_TRX_DTLS D,       
   citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) account                
   WHERE      
   DPTD_SLIP_NO = @slipno                 
   AND DPTD_DPAM_ID = ACCOUNT.DPAM_ID       
   AND (DPTD_EXECUTION_DT between EFF_FROM and EFF_TO)                
   AND DPTD_DELETED_IND = 1        
   AND DPTD_STATUS <> 'E'   
   and isnull(dptd_batch_no,'') <> ''   
    -- FOR BO DELIVERY TRANSACTIONS      
 
                    
         
                        
 

 select distinct a.*,isin_name from (     
 SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO            
 ,TRANS_TYPE= isnull(TRANSTYPE.DESCP,'') + '(' + TRASTM_CD + ')'            
 ,EXECUTION_DT=CONVERT(VARCHAR,EXECUTION_DT,109)            
 ,ISIN            
 ,DR_QTY = CASE WHEN QTY <= 0 THEN ABS(QTY) ELSE 0 END             
 ,CR_QTY = CASE WHEN QTY > 0 THEN  ABS(QTY) ELSE 0 END                       
 ,STATUS = isnull(T.DESCP,STATUS)                     
 ,CANCEL_STATUS = CASE WHEN CANCEL_STATUS = '00' THEN '' ELSE isnull(C.DESCP,CANCEL_STATUS) END 
 ,case when isnull(sett_type,'')<> '' then sett_type else 'N/A' end sett_type ,case when isnull(sett_no,'')<> '' then sett_no else 'N/A' end sett_no,case when isnull(other_sett_type,'')<> '' then other_sett_type else 'N/A' end other_sett_type ,case when isnull(other_sett_no,'')<> '' then other_sett_no else 'N/A' end other_sett_no ,case when isnull(ctr_demat_acct_no,'')<> '' then ctr_demat_acct_no else 'N/A' end ctr_demat_acct_no ,case when isnull(ctr_dp_id,'')<> '' then ctr_dp_id else 'N/A' end ctr_dp_id , case when isnull(ctr_cmbp_id,'')<> '' then ctr_cmbp_id else 'N/A' end ctr_cmbp_id,case when isnull(int_ref_no,'')<>'' then int_ref_no else 'N/A' end int_ref_no,case when isnull(transaction_no,'') <> '' then transaction_no else 'N/A' end transaction_no        
 FROM             
 @l_temp C              
 right outer join #transnsdl on TRASTM_CD= C.TTYPE_CD and CANCEL_STATUS = C.CD             
 left outer join @l_temp T on TRASTM_CD= T.TTYPE_CD and STATUS = T.CD,            
 citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_NSDL') TRANSTYPE                      
         
 WHERE                       
 left(TRASTM_CD,3) = TRANSTYPE.CD     
 ) a 
 left outer join isin_mstr on a.isin = isin_cd                           
 ORDER BY EXECUTION_DT,STATUS      
END      
ELSE IF (@pa_dptype = 'CDSL')          
BEGIN      
      

Select @@series=slibm_series_type from slip_book_mstr where  ISNULL(SLIBM_SERIES_TYPE,'') = SUBSTRING(@slipno,1,LEN(ISNULL(SLIBM_SERIES_TYPE,'')))
and isnumeric(replace(@slipno,ltrim(rtrim(SLIBM_SERIES_TYPE)),''))=1
AND replace(@slipno,ltrim(rtrim(SLIBM_SERIES_TYPE)),'')
BETWEEN SLIBM_FROM_NO AND SLIBM_TO_NO 
AND SLIBM_DELETED_IND=1  



SET @@Only_Slipno = REPLACE(ltrim(rtrim(@slipno)),ltrim(rtrim(@@series)),'')  


      
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
  ERR_MSG VARCHAR(100),   
  Sett_type varchar(20), -- New from LateshW May 25 2009
  sett_no varchar(20),
  other_sett_type varchar(20), 
  other_sett_no varchar(20),
  ctr_demat_acct_no varchar(20),
  ctr_dp_id varchar(20),
  ctr_cmbp_id varchar(20),  
  int_ref_no varchar(20),
  transaction_no varchar(20),  
  ORDER_BY int           
  )         
      
create table #transcdsl1            
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
  ERR_MSG VARCHAR(100),  
  Sett_type varchar(20), -- New from LateshW May 25 2009
  sett_no varchar(20),
  other_sett_type varchar(20), 
  other_sett_no varchar(20),
  ctr_demat_acct_no varchar(20),
  ctr_dp_id varchar(20),
  ctr_cmbp_id varchar(20),   
  int_ref_no varchar(20),
  transaction_no varchar(20),  
  ORDER_BY int           
  )         
      
     

   -- FOR DP50/DPC9 DELIVERY TRANSACTIONS           
  INSERT INTO #transcdsl(DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,TRASTM_CD,EXECUTION_DT,ISIN,QTY,TRANS_DESCP,STATUS,ERR_MSG,sett_type,sett_no,other_sett_type,other_sett_no,ctr_demat_acct_no,ctr_dp_id,ctr_cmbp_id,int_ref_no,transaction_no,ORDER_BY)      
  select DPAM_ID,DPAM_SBA_NAME,CDSHM_BEN_ACCT_NO,CDSHM_SLIP_NO,CDSHM_TRANS_NO,CDSHM_INTERNAL_TRASTM,CDSHM_TRAS_DT,CDSHM_ISIN,CDSHM_QTY      
  ,CDSHM_TRATM_DESC=replace(CDSHM_TRATM_DESC,'        ',''),isnull(T.DESCP,CDSHM_TRATM_CD),'',sett_type='',sett_no='',other_sett_type='',other_sett_no='',ctr_demat_acct_no='',ctr_dp_id='',ctr_cmbp_id='',int_ref_no='',transaction_no='',1      
  FROM citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_CDSL') T      
  right outer join CDSL_HOLDING_DTLS on CDSHM_TRATM_CD = T.CD       
  ,citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) ACCOUNT      
  WHERE       
  CDSHM_SLIP_NO = @slipno      
  AND CDSHM_DPAM_ID = ACCOUNT.DPAM_ID                  
  AND (CDSHM_TRAS_DT between EFF_FROM and EFF_TO)       
   -- FOR DP50/DPC9 DELIVERY TRANSACTIONS           
      
   -- FOR BO DELIVERY TRANSACTIONS      
 INSERT INTO #transcdsl(DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,TRASTM_CD,EXECUTION_DT,ISIN,QTY,TRANS_DESCP,STATUS,ERR_MSG,sett_type,sett_no,other_sett_type,other_sett_no,ctr_demat_acct_no,ctr_dp_id,ctr_cmbp_id,int_ref_no,transaction_no,ORDER_BY)      
 SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,DPTDC_SLIP_NO,isnull(DPTDC_TRANS_NO,''),DPTDC_INTERNAL_TRASTM,DPTDC_EXECUTION_DT,DPTDC_ISIN,DPTDC_QTY                
 ,DESCP='',STATUS=ISNULL(STAT.DESCP,DPTDC_STATUS),ERR_MSG=ISNULL(MSG.DESCP,DPTDC_ERRMSG)
,isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  dptdc_mkt_type AND SETTM_DELETED_IND = 1),''),isnull(DPTDC_SETTLEMENT_NO,''),isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  dptdc_other_settlement_type AND SETTM_DELETED_IND = 1),''),isnull(DPTDC_OTHER_SETTLEMENT_NO,''),isnull(DPTDC_COUNTER_DEMAT_ACCT_NO,''),isnull(DPTDC_COUNTER_DP_ID,''),isnull(DPTDC_COUNTER_CMBP_ID,''),isnull(dptdc_slip_no,''),isnull(dptdc_trans_no,'')
,0      
 FROM DP_TRX_DTLS_CDSL   D               
 LEFT OUTER JOIN citrus_usr.FN_GETSUBTRANSDTLS('TRANS_ERR_CD_CDSL') MSG on  DPTDC_ERRMSG = MSG.CD,                
 citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) ACCOUNT,                
 citrus_usr.FN_GETSUBTRANSDTLS('RES_STAT_CD_CDSL') stat                
 WHERE      
 DPTDC_SLIP_NO = @slipno                 
 AND DPTDC_DELETED_IND = 1                
 AND DPTDC_DPAM_ID = ACCOUNT.DPAM_ID                  
 AND (DPTDC_EXECUTION_DT between EFF_FROM and EFF_TO)                
 AND DPTDC_STATUS = STAT.CD      
 AND DPTDC_STATUS <> 'E'       
            
      
   -- FOR BO DELIVERY TRANSACTIONS      

 -- FOR UNUSED SLIP TRANSACTIONS      

 INSERT INTO #transcdsl1(DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO,TRANS_NO,TRASTM_CD,EXECUTION_DT,ISIN,QTY,TRANS_DESCP,STATUS,ERR_MSG,sett_type,sett_no,other_sett_type,other_sett_no,ctr_demat_acct_no,ctr_dp_id,ctr_cmbp_id,int_ref_no,transaction_no,ORDER_BY)      
 SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,@slipno,isnull('',''),trastm_cd,sliim_created_dt,'',0               
 ,DESCP='',STATUS='SLIP ISSUED (NOT USED)',ERR_MSG=''
,sett_type='',sett_no='',other_sett_type='',other_sett_no='',ctr_demat_acct_no='',ctr_dp_id='',ctr_cmbp_id='',int_ref_no='',transaction_no=''
,0      
 FROM slip_issue_mstr   D ,  transaction_sub_type_mstr ,              
 citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) ACCOUNT
 WHERE    SLIIM_TRATM_ID =   trastm_id
 and convert(bigint,@@Only_Slipno) between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO 
 AND SLIIM_DPAM_ACCT_NO = ACCOUNT.DPAM_SBA_NO      
 and @slipno not in (select USES_SLIP_NO from used_slip) 

 union            

 SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,@slipno,isnull('',''),trastm_cd,dptdc_created_dt,dptdc_isin,dptdc_qty                
 ,DESCP='',STATUS='SLIP USED (UNAPPROVED)',ERR_MSG=''
,isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  dptdc_mkt_type AND SETTM_DELETED_IND = 1),''),isnull(DPTDC_SETTLEMENT_NO,''),isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  dptdc_other_settlement_type AND SETTM_DELETED_IND = 1),''),isnull(DPTDC_OTHER_SETTLEMENT_NO,''),isnull(DPTDC_COUNTER_DEMAT_ACCT_NO,''),isnull(DPTDC_COUNTER_DP_ID,''),isnull(DPTDC_COUNTER_CMBP_ID,''),isnull(dptdc_slip_no,''),isnull(dptdc_trans_no,'')
,0      
 FROM slip_issue_mstr   D , dptdc_mak ,  transaction_sub_type_mstr ,              
 citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) ACCOUNT
 WHERE    SLIIM_TRATM_ID =   trastm_id
 and dptdc_slip_no = @slipno
 and convert(bigint,@@Only_Slipno) between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO 
 AND SLIIM_DPAM_ACCT_NO = ACCOUNT.DPAM_SBA_NO      
 and dptdc_deleted_ind = 0  

 union            

 SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,@slipno,isnull('',''),trastm_cd,dptdc_lst_upd_dt,dptdc_isin,dptdc_qty               
 ,DESCP='',STATUS='SLIP USED (CHECKER APPROVED)',ERR_MSG=''
,isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  dptdc_mkt_type AND SETTM_DELETED_IND = 1),''),isnull(DPTDC_SETTLEMENT_NO,''),isnull((SELECT SETTM_DESC FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) =  dptdc_other_settlement_type AND SETTM_DELETED_IND = 1),''),isnull(DPTDC_OTHER_SETTLEMENT_NO,''),isnull(DPTDC_COUNTER_DEMAT_ACCT_NO,''),isnull(DPTDC_COUNTER_DP_ID,''),isnull(DPTDC_COUNTER_CMBP_ID,''),isnull(dptdc_slip_no,''),isnull(dptdc_trans_no,'')
,0      
 FROM slip_issue_mstr   D , dp_trx_dtls_cdsl ,  transaction_sub_type_mstr ,              
 citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) ACCOUNT
 WHERE    SLIIM_TRATM_ID =   trastm_id
 and dptdc_slip_no = @slipno
 and isnull(DPTDC_TRANS_NO,'') = ''
 and convert(bigint,@@Only_Slipno) between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO 
 AND SLIIM_DPAM_ACCT_NO = ACCOUNT.DPAM_SBA_NO      
 and dptdc_deleted_ind = 1  


     --	select * from #transcdsl1 
-- FOR UNUSED SLIP TRANSACTIONS      

      
      
 SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO=ISNULL(SLIP_NO,''),TRANS_NO            
 ,TRANS_TYPE=isnull(TRASTM_CD,'')            
 ,EXECUTION_DT=CONVERT(VARCHAR,EXECUTION_DT,109)            
 ,ISIN            
 ,ISIN_NAME            
 ,TRANS_DESCP            
 ,DR_QTY = CASE WHEN QTY <= 0 THEN ABS(QTY) ELSE 0 END                
 ,CR_QTY = CASE WHEN QTY > 0 THEN  ABS(QTY) ELSE 0 END                       
 ,STATUS                  
 ,ERR_MSG=ISNULL(ERR_MSG,'')
 ,CANCEL_STATUS = ISNULL(ERR_MSG,'') 
,case when isnull(sett_type,'')<> '' then sett_type else 'N/A' end sett_type ,case when isnull(sett_no,'')<> '' then sett_no else 'N/A' end sett_no,case when isnull(other_sett_type,'')<> '' then other_sett_type else 'N/A' end other_sett_type ,case when isnull(other_sett_no,'')<> '' then other_sett_no else 'N/A' end other_sett_no ,case when isnull(ctr_demat_acct_no,'')<> '' then ctr_demat_acct_no else 'N/A' end ctr_demat_acct_no ,case when isnull(ctr_dp_id,'')<> '' then ctr_dp_id else 'N/A' end ctr_dp_id , case when isnull(ctr_cmbp_id,'')<> '' then ctr_cmbp_id else 'N/A' end ctr_cmbp_id ,case when isnull(int_ref_no,'')<>'' then int_ref_no else 'N/A' end int_ref_no,case when isnull(transaction_no,'') <> '' then transaction_no else 'N/A' end  transaction_no      
,ORDER_BY           
 FROM  #transcdsl LEFT OUTER JOIN isin_mstr ON ISIN = ISIN_CD   

 union

 SELECT DPAM_ID,DPAM_SBA_NAME,DPAM_SBA_NO,SLIP_NO=ISNULL(SLIP_NO,''),TRANS_NO            
 ,TRANS_TYPE=isnull(TRASTM_CD,'')            
 ,EXECUTION_DT=CONVERT(VARCHAR,EXECUTION_DT,109)            
 ,ISIN            
 ,ISIN_NAME            
 ,TRANS_DESCP            
 ,DR_QTY = CASE WHEN QTY <= 0 THEN ABS(QTY) ELSE 0 END                
 ,CR_QTY = CASE WHEN QTY > 0 THEN  ABS(QTY) ELSE 0 END                       
 ,STATUS                  
 ,ERR_MSG=ISNULL(ERR_MSG,'')
 ,CANCEL_STATUS = ISNULL(ERR_MSG,'')
,case when isnull(sett_type,'')<> '' then sett_type else 'N/A' end sett_type ,case when isnull(sett_no,'')<> '' then sett_no else 'N/A' end sett_no,case when isnull(other_sett_type,'')<> '' then other_sett_type else 'N/A' end other_sett_type ,case when isnull(other_sett_no,'')<> '' then other_sett_no else 'N/A' end other_sett_no ,case when isnull(ctr_demat_acct_no,'')<> '' then ctr_demat_acct_no else 'N/A' end ctr_demat_acct_no ,case when isnull(ctr_dp_id,'')<> '' then ctr_dp_id else 'N/A' end ctr_dp_id , case when isnull(ctr_cmbp_id,'')<> '' then ctr_cmbp_id else 'N/A' end ctr_cmbp_id ,case when isnull(int_ref_no,'')<>'' then int_ref_no else 'N/A' end int_ref_no,case when isnull(transaction_no,'') <> '' then transaction_no else 'N/A' end  transaction_no         
,ORDER_BY            
 FROM       
 #transcdsl1 LEFT OUTER JOIN isin_mstr ON ISIN = ISIN_CD   
 ORDER BY ORDER_BY,EXECUTION_DT,STATUS      
      
END      
      
      
end

GO
