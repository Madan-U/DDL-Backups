-- Object: PROCEDURE citrus_usr.pr_ins_upd_PledgeC_trx
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


--	0	INS	VISHAL	12345678	CRTE	PLEDGE	1234567890123456	PL9	07/02/2009	12	11	07/02/2009	HAND DELIVERY	5	CASH			0	CRTE	REM	*|~*	|*~|	
    
/* 

alter table CpledgeD_mak   add PLDTC_CLOSURE_BY  VARCHAR(25)
alter table CpledgeD_mak   add PLDTC_SECURITTIES VARCHAR(25)

alter table CDSL_pledge_DTLS   add PLDTC_CLOSURE_BY  VARCHAR(25)
alter table CDSL_pledge_DTLS   add PLDTC_SECURITTIES VARCHAR(25)

PLDTC_ID BIGINT
,PLDTC_DTLS_ID BIGINT
,PLDTC_DPM_ID  BIGINT
,PLDTC_DPAM_ID NUMERIC(10,0)
,PLDTC_REQUEST_DT DATETIME
,PLDTC_EXEC_DT DATETIME
,PLDTC_SLIP_NO VARCHAR(25)
,PLDTC_ISIN    VARCHAR(50)
,PLDTC_QTY     NUMERIC(18,3)
,PLDTC_TRASTM_CD VARCHAR(50)
,PLDTC_AGREEMENT_NO VARCHAR(20)
,PLDTC_SETUP_DT DATETIME
,PLDTC_EXPIRY_DT DATETIME
,PLDTC_PLDG_DPID VARCHAR(25)
,PLDTC_PLDG_DPNAME VARCHAR(100)
,PLDTC_PLDG_CLIENTID VARCHAR(16)
,PLDTC_PLDG_CLIENTNAME VARCHAR(100)
,PLDTC_REASON   VARCHAR(50)
,PLDTC_PSN      VARCHAR(25)	
,PLDTC_TRANS_NO VARCHAR(50)
,PLDTC_BATCH_NO VARCHAR(25)
,PLDTC_BROKER_BATCH_NO VARCHAR(25)
,PLDTC_BROKER_REF_NO   VARCHAR(25)
,PLDTC_STATUS          VARCHAR(10)
,PLDTC_CREATED_BY      VARCHAR(25)
,PLDTC_CREATED_DATE    DATETIME
,PLDTC_UPDATED_BY      VARCHAR(25)
,PLDTC_UPDATED_DATE    DATETIME 
,PLDTC_DELETED_IND     SMALLINT 
,PLDTC_RMKS            VARCHAR(250)
    
*/  

CREATE PROCEDURE [citrus_usr].[pr_ins_upd_PledgeC_trx]
             (@pa_id              VARCHAR(8000)      
             ,@pa_action          VARCHAR(20)      
             ,@pa_login_name      VARCHAR(20)      
             ,@pa_dpm_dpid        VARCHAR(50)    
             ,@pa_dpam_acct_no    VARCHAR(50)    
             ,@pa_slip_no         VARCHAR(20)     
             ,@pa_req_dt          VARCHAR(11)    
             ,@pa_exe_dt          VARCHAR(11)    
             ,@pa_SETUP_dt        VARCHAR(11)    
             ,@pa_EXPIRE_dt       VARCHAR(11)               
             ,@pa_agree_no        VARCHAR(50)    
             ,@pa_pledgee_dpid    varchar(20)    
             ,@pa_pledgee_acctno  varchar(20)    
             ,@pa_PLEDGEE_DEMAT_NAME  varchar(100)    
             ,@PA_PLDTC_CLOSURE_BY  VARCHAR(25)
             ,@PA_PLDTC_SECURITTIES VARCHAR(25)
             ,@PA_PLDTC_SUB_STATUS VARCHAR(10)
             ,@pa_values          VARCHAR(8000)    
             ,@pa_desc            VARCHAR(500)  
             ,@pa_rmks            VARCHAR(250)   
			 ,@PA_UCC VARCHAR(20)
			 ,@PA_EXID VARCHAR(5)
			 ,@PA_SEGID VARCHAR(5)
			 ,@PA_CMID VARCHAR(20)
			 ,@PA_EID CHAR(2)
			 ,@PA_TMCMID VARCHAR(20)
             ,@pa_chk_yn          INT                   
             ,@rowdelimiter       CHAR(4)       = '*|~*'      
             ,@coldelimiter       CHAR(4)       = '|*~|'      
			 ,@PA_PLDG_REASON_CODE VARCHAR(150)
			 ,@PA_PLDG_ULTIMATE_LENDER_PAN VARCHAR(15)
			 ,@PA_PLDG_ULTIMATE_LENDER_CODE VARCHAR(30)

,@PA_PLDTC_CUSPA_FLG CHAR(1)
,@PA_PLDTC_CUSPA_TRX_CTGRY CHAR(1)
,@PA_PLDTC_CUSPA_EPI VARCHAR(16)
,@PA_PLDTC_CUSPA_SETTLEMENTID VARCHAR(13)
,@PA_PLDTC_CUSPA_CMBP_DPID VARCHAR(8)

             ,@pa_errmsg          VARCHAR(8000) output      
)      
AS    
/*    
*********************************************************************************    
 SYSTEM         : dp    
 MODULE NAME    : pr_ins_upd_onmC2P_trx    
 DESCRIPTION    : this procedure will contain the maker checker facility for transaction details    
 COPYRIGHT(C)   : marketplace technologies     
 VERSION HISTORY: 1.0    
 VERS.  AUTHOR            DATE          REASON    
 -----  -------------     ------------  --------------------------------------------------    
 1.0    TUSHAR            05-DEC-2007   VERSION.    
-----------------------------------------------------------------------------------*/    
BEGIN    
--    
DECLARE @t_errorstr      VARCHAR(8000)    
      , @l_error         BIGINT    
      , @delimeter       VARCHAR(10)    
      , @remainingstring VARCHAR(8000)    
      , @currstring      VARCHAR(8000)    
      , @foundat         INTEGER    
      , @delimeterlength INT    
      , @l_PLDT_ID      NUMERIC    
      , @l_dptdm_id     NUMERIC    
      , @delimeter_value varchar(10)    
      , @delimeterlength_value varchar(10)    
      , @remainingstring_value varchar(8000)    
      , @currstring_value varchar(8000)    
      , @l_access1      int    
      , @l_access       int    
      , @l_excm_id      numeric    
      , @l_excm_cd      VARCHAR(500)    
      , @l_dpm_id       NUMERIC    
      , @l_deleted_ind  smallint    
      , @l_dpam_id      numeric    
      , @line_no        NUMERIC    
      , @l_tr_dpid      VARCHAR(25)     
      , @l_tr_sett_type VARCHAR(50)    
      , @l_tr_setm_no   VARCHAR(50)    
      , @l_isin         VARCHAR(25)     
      , @l_qty          VARCHAR(25)    
      , @l_value		VARCHAR(25)
      , @l_ORG_qty      VARCHAR(25)    
      , @l_trastm_id    VARCHAR(25)    
      , @l_action       VARCHAR(25)    
      , @l_dtls_id      NUMERIC    
      , @l_dtlsm_id     NUMERIC    
	  , @l_id			varchar(20)    
      , @@c_access_cursor cursor    
      , @c_deleted_ind    varchar(20)    
      , @c_PLDT_ID        varchar(20)    
      , @l_trastm_desc    varchar(20)    
      , @l_max_high_val   numeric(18,5)    
      , @l_high_val_yn     char(1)      
      , @l_val_yn     char(1)      
,@l_rel_dt VARCHAR(11)    
,@l_rel_rsn VARCHAR(20)    
,@l_rej_rsn VARCHAR(20)   
,@l_seq_no   varchar(20)  
  
  
set @l_trastm_id = @PA_DESC  
  
  
                     
set @l_val_yn  = citrus_usr.fn_get_high_val('',0,'DORMANT',@pa_dpam_acct_no,convert(datetime,@pa_req_dt,103))        
          
if @PA_ACTION <> 'app'  AND @PA_ACTION <> 'rej'           
begin    
--    
  create table #CpledgeD_mak    
  (PLDTC_ID BIGINT
	,PLDTC_DTLS_ID BIGINT
	,PLDTC_DPM_ID  BIGINT
	,PLDTC_DPAM_ID NUMERIC(10,0)
	,PLDTC_REQUEST_DT DATETIME
	,PLDTC_EXEC_DT DATETIME
	,PLDTC_SLIP_NO VARCHAR(25)
	,PLDTC_ISIN    VARCHAR(50)
	,PLDTC_QTY     NUMERIC(18,3)
	,PLDTC_TRASTM_CD VARCHAR(50)
	,PLDTC_AGREEMENT_NO VARCHAR(20)
	,PLDTC_SETUP_DT DATETIME
	,PLDTC_EXPIRY_DT DATETIME
	,PLDTC_PLDG_DPID VARCHAR(25)
	,PLDTC_PLDG_DPNAME VARCHAR(100)
	,PLDTC_PLDG_CLIENTID VARCHAR(16)
	,PLDTC_PLDG_CLIENTNAME VARCHAR(100)
	,PLDTC_REASON   VARCHAR(50)
	,PLDTC_PSN      VARCHAR(25)	
	,PLDTC_TRANS_NO VARCHAR(50)
	,PLDTC_BATCH_NO VARCHAR(25)
	,PLDTC_BROKER_BATCH_NO VARCHAR(25)
	,PLDTC_BROKER_REF_NO   VARCHAR(25)
	,PLDTC_STATUS          VARCHAR(10)
	,PLDTC_CREATED_BY      VARCHAR(25)
	,PLDTC_CREATED_DATE    DATETIME
	,PLDTC_UPDATED_BY      VARCHAR(25)
	,PLDTC_UPDATED_DATE    DATETIME 
	,PLDTC_DELETED_IND     SMALLINT
	,PLDTC_RMKS            VARCHAR(250)
    ,PLDTC_CLOSURE_BY  VARCHAR(25)
    ,PLDTC_SECURITTIES VARCHAR(25)
    ,PLDTC_SUB_STATUS VARCHAR(25)
	,PLDTC_VALUE numeric(18,3)
	,PLDTC_UCC VARCHAR(20)
	,PLDTC_EXID VARCHAR(5)
	,PLDTC_SEGID VARCHAR(5)
	,PLDTC_CMID VARCHAR(20)
	,PLDTC_EID CHAR(2)
	,PLDTC_TMCMID VARCHAR(30)
	,PLDTC_REASON_CODE VARCHAR(150)
	,PLDTC_ULTIMATE_LENDER_PAN VARCHAR(15)
	,PLDTC_ULTIMATE_LENDER_CODE VARCHAR(30)
	,PLDTC_CUSPA_FLG CHAR(1)
	,PLDTC_CUSPA_TRX_CTGRY CHAR(1)
	,PLDTC_CUSPA_EPI VARCHAR(16)
	,PLDTC_CUSPA_SETTLEMENTID VARCHAR(13)
	,PLDTC_CUSPA_CMBP_DPID VARCHAR(8)
  )    
  insert into #CpledgeD_mak    
  (PLDTC_ID 
	,PLDTC_DTLS_ID 
	,PLDTC_DPM_ID  
	,PLDTC_DPAM_ID 
	,PLDTC_REQUEST_DT 
	,PLDTC_EXEC_DT 
	,PLDTC_SLIP_NO 
	,PLDTC_ISIN    
	,PLDTC_QTY     
	,PLDTC_TRASTM_CD 
	,PLDTC_AGREEMENT_NO 
	,PLDTC_SETUP_DT 
	,PLDTC_EXPIRY_DT
	,PLDTC_PLDG_DPID 
	,PLDTC_PLDG_DPNAME 
	,PLDTC_PLDG_CLIENTID
	,PLDTC_PLDG_CLIENTNAME 
	,PLDTC_REASON   
	,PLDTC_PSN      
	,PLDTC_TRANS_NO 
	,PLDTC_BATCH_NO 
	,PLDTC_BROKER_BATCH_NO 
	,PLDTC_BROKER_REF_NO   
	,PLDTC_STATUS          
	,PLDTC_CREATED_BY      
	,PLDTC_CREATED_DATE    
	,PLDTC_UPDATED_BY      
	,PLDTC_UPDATED_DATE    
	,PLDTC_DELETED_IND     
	,PLDTC_RMKS   
    ,PLDTC_CLOSURE_BY  
    ,PLDTC_SECURITTIES 
    ,PLDTC_SUB_STATUS
	,PLDTC_VALUE 
	,PLDTC_UCC 
	,PLDTC_EXID
	,PLDTC_SEGID
	,PLDTC_CMID
	,PLDTC_EID
	,PLDTC_TMCMID
	,PLDTC_REASON_CODE
	,PLDTC_ULTIMATE_LENDER_PAN
	,PLDTC_ULTIMATE_LENDER_CODE
	,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
   )    
  select PLDTC_ID 
	,PLDTC_DTLS_ID 
	,PLDTC_DPM_ID  
	,PLDTC_DPAM_ID 
	,PLDTC_REQUEST_DT 
	,PLDTC_EXEC_DT 
	,PLDTC_SLIP_NO 
	,PLDTC_ISIN    
	,PLDTC_QTY     
	,PLDTC_TRASTM_CD 
	,PLDTC_AGREEMENT_NO 
	,PLDTC_SETUP_DT 
	,PLDTC_EXPIRY_DT
	,PLDTC_PLDG_DPID 
	,PLDTC_PLDG_DPNAME 
	,PLDTC_PLDG_CLIENTID
	,PLDTC_PLDG_CLIENTNAME 
	,PLDTC_REASON   
	,PLDTC_PSN      
	,PLDTC_TRANS_NO 
	,PLDTC_BATCH_NO 
	,PLDTC_BROKER_BATCH_NO 
	,PLDTC_BROKER_REF_NO   
	,PLDTC_STATUS          
	,PLDTC_CREATED_BY      
	,PLDTC_CREATED_DATE    
	,PLDTC_UPDATED_BY      
	,PLDTC_UPDATED_DATE    
	,PLDTC_DELETED_IND     
	,PLDTC_RMKS 
    ,PLDTC_CLOSURE_BY  
    ,PLDTC_SECURITTIES 
    ,PLDTC_SUB_STATUS 
	,PLDTC_VALUE
	,PLDTC_UCC 
	,PLDTC_EXID
	,PLDTC_SEGID
	,PLDTC_CMID
	,PLDTC_EID
	,PLDTC_TMCMID
	,PLDTC_REASON_CODE
	,PLDTC_ULTIMATE_LENDER_PAN
	,PLDTC_ULTIMATE_LENDER_CODE
	,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
  FROM CpledgeD_mak     
  where PLDTC_DTLS_ID = @pa_id    
--    
end    
IF @pa_action = 'INS'     or @pa_action = 'EDT' 
BEGIN    
--    
      
  /*SELECT @l_dtls_id   = ISNULL(MAX(PLDT_DTLS_ID),0) + 1 FROM nsdl_pledge_dtls      
                    
  SELECT @l_dtlsm_id   = ISNULL(MAX(PLDT_DTLS_ID),0) + 1 FROM NpledgeD_mak    
      
  IF @l_dtlsm_id  > @l_dtls_id       
  BEGIN    
  --    
    set @l_dtls_id = @l_dtlsm_id       
  --    
  END    
      
  IF @pa_chk_yn = 0    
  BEGIN    
  --    
    SELECT @l_dtls_id = ISNULL(MAX(PLDT_DTLS_ID),0) + 1 from  nsdl_pledge_dtls     
  --    
  END*/   

  declare  @l_count_row bigint
  set   @l_count_row  = citrus_usr.ufn_countstring(@pa_values,'*|~*')    
  begin transaction    
        
    update bitmap_ref_mstr with(tablock)    
    set    bitrm_deleted_ind = 1     
    where  bitrm_id = 1     
    and    bitrm_deleted_ind = 1     
        
      IF @pa_action = 'INS'    
      begin   
      select @l_dtls_id = BITRM_BIT_LOCATION     
      from  bitmap_ref_mstr     
      where BITRM_PARENT_CD = 'PLDTC_DTLS_ID'    
        
      update bitmap_ref_mstr with(tablock)    
      set    BITRM_BIT_LOCATION  = BITRM_BIT_LOCATION  + 1     
      where BITRM_PARENT_CD = 'PLDTC_DTLS_ID'    
      end  
        
      select @l_PLDT_ID = BITRM_BIT_LOCATION     
      from  bitmap_ref_mstr     
      where BITRM_PARENT_CD = 'PLDTC_ID'    
        
      update bitmap_ref_mstr with(tablock)    
      set    BITRM_BIT_LOCATION  = BITRM_BIT_LOCATION  + @l_count_row     
      where BITRM_PARENT_CD = 'PLDTC_ID'    
        
        set @l_count_row = 0
        
   commit transaction    
       
--    
END    
IF @pa_action = 'EDT'     
BEGIN    
--    
  IF @pa_chk_yn = 0    
  BEGIN    
  --    
    SELECT @l_dtls_id = PLDTC_DTLS_ID FROM  cdsl_pledge_dtls WHERE PLDTC_DTLS_ID = convert(numeric,@pa_id) AND PLDTC_TRASTM_CD = @l_trastm_id    
  --    
  END    
  ELSE    
  BEGIN    
  --    
    SELECT @l_dtls_id = PLDTC_DTLS_ID FROM  CpledgeD_mak WHERE PLDTC_DTLS_ID = convert(numeric,@pa_id) AND PLDTC_TRASTM_CD = @l_trastm_id    
  --    
  END    
--     
END    
    
    
DECLARE @l_str1 VARCHAR(8000)    
,@l_str2 VARCHAR(500)    
,@l_counter INT    
,@l_max_counter INT    
CREATE TABLE #temp_id (id INT)    
    
--changed for maker master edit    
if @pa_action = 'EDT' and @pa_values <> '0' and @pa_chk_yn = 1 and exists(select PLDTC_ID from CDSL_pledge_dtls where PLDTC_DTLS_ID = @pa_id and PLDTC_DELETED_IND = 1)    
begin     
--  
print 'dddd'  
  SET @l_counter = 1    
  SET @l_str1 = @pa_values    
  SET @l_max_counter = citrus_usr.ufn_countstring(@l_str1,'*|~*')    
  WHILE @l_counter  <= @l_max_counter    
  BEGIN    
  --     
    SELECT @l_str2 = citrus_usr.FN_SPLITVAL_ROW(@l_str1,@l_counter)    
    INSERT INTO #temp_id VALUES(case when citrus_usr.FN_SPLITVAL(@l_str2,1) = 'D' then   citrus_usr.FN_SPLITVAL(@l_str2,2) else citrus_usr.FN_SPLITVAL(@l_str2,6) end)    
        
    SET @l_counter   = @l_counter   + 1    
  --      
  END    
      
  INSERT INTO CpledgeD_mak        
  (PLDTC_ID 
	,PLDTC_DTLS_ID 
	,PLDTC_DPM_ID  
	,PLDTC_DPAM_ID 
	,PLDTC_REQUEST_DT 
	,PLDTC_EXEC_DT 
	,PLDTC_SLIP_NO 
	,PLDTC_ISIN    
	,PLDTC_QTY     
	,PLDTC_TRASTM_CD 
	,PLDTC_AGREEMENT_NO 
	,PLDTC_SETUP_DT 
	,PLDTC_EXPIRY_DT
	,PLDTC_PLDG_DPID 
	,PLDTC_PLDG_DPNAME 
	,PLDTC_PLDG_CLIENTID
	,PLDTC_PLDG_CLIENTNAME 
	,PLDTC_REASON   
	,PLDTC_PSN      
	,PLDTC_TRANS_NO 
	,PLDTC_BATCH_NO 
	,PLDTC_BROKER_BATCH_NO 
	,PLDTC_BROKER_REF_NO   
	,PLDTC_STATUS          
	,PLDTC_CREATED_BY      
	,PLDTC_CREATED_DATE    
	,PLDTC_UPDATED_BY      
	,PLDTC_UPDATED_DATE    
	,PLDTC_DELETED_IND     
	,PLDTC_RMKS 
    ,PLDTC_CLOSURE_BY  
    ,PLDTC_SECURITTIES 
    ,PLDTC_SUB_STATUS
	,PLDTC_VALUE 
	,PLDTC_UCC 
	,PLDTC_EXID
	,PLDTC_SEGID
	,PLDTC_CMID
	,PLDTC_EID
	,PLDTC_TMCMID
	,PLDTC_REASON_CODE
	,PLDTC_ULTIMATE_LENDER_PAN
	,PLDTC_ULTIMATE_LENDER_CODE

	,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
  )         
  select PLDTC_ID 
	,PLDTC_DTLS_ID 
	,PLDTC_DPM_ID  
	,PLDTC_DPAM_ID 
	,CONVERT(DATETIME,@pa_req_dt,103) 
	,CONVERT(DATETIME,@pa_exe_dt,103)  
	,@pa_slip_no 
	,PLDTC_ISIN    
	,PLDTC_QTY     
	,PLDTC_TRASTM_CD 
	,@pa_agree_no 
	,CONVERT(DATETIME,@pa_SETUP_dt,103) 
	,CONVERT(DATETIME,@pa_EXPIRE_dt,103)
	,@pa_pledgee_dpid 
	,PLDTC_PLDG_DPNAME
	,@pa_pledgee_acctno
	,@pa_PLEDGEE_DEMAT_NAME 
	,PLDTC_REASON   
	,PLDTC_PSN      
	,PLDTC_TRANS_NO 
	,PLDTC_BATCH_NO 
	,PLDTC_BROKER_BATCH_NO 
	,PLDTC_BROKER_REF_NO   
	,'P'          
	,PLDTC_CREATED_BY      
	,PLDTC_CREATED_DATE    
	,PLDTC_UPDATED_BY      
	,PLDTC_UPDATED_DATE    
	,'6'     
	,PLDTC_RMKS 
    ,@PA_PLDTC_CLOSURE_BY  
    ,@PA_PLDTC_SECURITTIES 
    ,@PA_PLDTC_SUB_STATUS
	,PLDTC_VALUE 
	,PLDTC_UCC 
	,PLDTC_EXID
	,PLDTC_SEGID
	,PLDTC_CMID
	,PLDTC_EID
	,PLDTC_TMCMID
	,PLDTC_REASON_CODE
	,PLDTC_ULTIMATE_LENDER_PAN
	,PLDTC_ULTIMATE_LENDER_CODE
	,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
  FROM  CDSL_pledge_dtls        
  WHERE PLDTC_ID       not in (select id from #temp_id)    
  and   PLDTC_DTLS_ID  = @pa_id    
  AND   PLDTC_DELETED_IND   =  1     
      
      
--    
end    
else IF @pa_action = 'EDT' and @pa_values <> '0' and @pa_chk_yn = 1 and NOT exists(select PLDTc_ID from cdsl_pledge_dtls where PLDTc_DTLS_ID = @pa_id and PLDTc_DELETED_IND = 1)    
begin    
--    
     
  SET @l_counter = 1    
  SET @l_str1 = @pa_values    
  SET @l_max_counter = citrus_usr.ufn_countstring(@l_str1,'*|~*')    
  WHILE @l_counter  <= @l_max_counter    
  BEGIN    
  --     
    SELECT @l_str2 = citrus_usr.FN_SPLITVAL_ROW(@l_str1,@l_counter)    
    INSERT INTO #temp_id VALUES(case when citrus_usr.FN_SPLITVAL(@l_str2,1) = 'D' then   citrus_usr.FN_SPLITVAL(@l_str2,2) else citrus_usr.FN_SPLITVAL(@l_str2,6) end)    
    
    SET @l_counter   = @l_counter   + 1    
  --      
  END    
       

  delete from    CpledgeD_mak        
  WHERE PLDTc_ID       not in (select id from #temp_id)     
  and   PLDTc_DTLS_ID  = @pa_id    
  AND   PLDTc_DELETED_IND   in (0,4,6)    
       
  INSERT INTO CpledgeD_mak        
		  (PLDTC_ID 
			,PLDTC_DTLS_ID 
			,PLDTC_DPM_ID  
			,PLDTC_DPAM_ID 
			,PLDTC_REQUEST_DT 
			,PLDTC_EXEC_DT 
			,PLDTC_SLIP_NO 
			,PLDTC_ISIN    
			,PLDTC_QTY     
			,PLDTC_TRASTM_CD 
			,PLDTC_AGREEMENT_NO 
			,PLDTC_SETUP_DT 
			,PLDTC_EXPIRY_DT
			,PLDTC_PLDG_DPID 
			,PLDTC_PLDG_DPNAME 
			,PLDTC_PLDG_CLIENTID
			,PLDTC_PLDG_CLIENTNAME 
			,PLDTC_REASON   
			,PLDTC_PSN      
			,PLDTC_TRANS_NO 
			,PLDTC_BATCH_NO 
			,PLDTC_BROKER_BATCH_NO 
			,PLDTC_BROKER_REF_NO   
			,PLDTC_STATUS          
			,PLDTC_CREATED_BY      
			,PLDTC_CREATED_DATE    
			,PLDTC_UPDATED_BY      
			,PLDTC_UPDATED_DATE    
			,PLDTC_DELETED_IND     
			,PLDTC_RMKS 
			,PLDTC_CLOSURE_BY  
			,PLDTC_SECURITTIES 
            ,PLDTC_SUB_STATUS
			,PLDTC_VALUE 
			,PLDTC_UCC 
			,PLDTC_EXID
			,PLDTC_SEGID
			,PLDTC_CMID
			,PLDTC_EID
			,PLDTC_TMCMID
			,PLDTC_REASON_CODE
			,PLDTC_ULTIMATE_LENDER_PAN
			,PLDTC_ULTIMATE_LENDER_CODE
			,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
		  )         
		  select PLDTC_ID 
			,PLDTC_DTLS_ID 
			,PLDTC_DPM_ID  
			,PLDTC_DPAM_ID 
			,CONVERT(DATETIME,@pa_req_dt,103) 
			,CONVERT(DATETIME,@pa_exe_dt,103)  
			,@pa_slip_no 
			,PLDTC_ISIN    
			,PLDTC_QTY     
			,PLDTC_TRASTM_CD 
			,@pa_agree_no 
				,CONVERT(DATETIME,@pa_SETUP_dt,103) 
	        ,CONVERT(DATETIME,@pa_EXPIRE_dt,103)
			,@pa_pledgee_dpid 
			,PLDTC_PLDG_DPNAME
			,@pa_pledgee_acctno
			,@pa_PLEDGEE_DEMAT_NAME 
			,PLDTC_REASON   
			,PLDTC_PSN      
			,PLDTC_TRANS_NO 
			,PLDTC_BATCH_NO 
			,PLDTC_BROKER_BATCH_NO 
			,PLDTC_BROKER_REF_NO   
			,'P'          
			,PLDTC_CREATED_BY      
			,PLDTC_CREATED_DATE    
			,PLDTC_UPDATED_BY      
			,PLDTC_UPDATED_DATE    
			,0     
			,PLDTC_RMKS 
            ,@PA_PLDTC_CLOSURE_BY  
			,@PA_PLDTC_SECURITTIES
            ,@PA_PLDTC_SUB_STATUS 
			,PLDTC_VALUE
			,PLDTC_UCC 
			,PLDTC_EXID
			,PLDTC_SEGID
			,PLDTC_CMID
			,PLDTC_EID
			,PLDTC_TMCMID
			,PLDTC_REASON_CODE
			,PLDTC_ULTIMATE_LENDER_PAN
			,PLDTC_ULTIMATE_LENDER_CODE
			,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
  FROM  #CpledgeD_mak        
  WHERE PLDTC_ID       not in (select id from #temp_id)    
  and   PLDTC_DTLS_ID  = @pa_id    
  AND   PLDTC_DELETED_IND   in (0,4,6)    
--    
end    
    
declare @c_access_cursor cursor    
set @l_excm_cd = ''    
set @l_access1       = 0     
SET @l_error         = 0    
SET @t_errorstr      = ''    
SET @delimeter        = '%'+ @ROWDELIMITER + '%'    
SET @delimeterlength = LEN(@ROWDELIMITER)    
SET @remainingstring = @pa_id      
    
  WHILE @remainingstring <> ''    
  BEGIN    
  --    
    SET @foundat = 0    
    SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring)    
    --    
    IF @foundat > 0    
    BEGIN    
    --    
      SET @currstring      = SUBSTRING(@remainingstring, 0,@foundat)    
      SET @remainingstring = SUBSTRING(@remainingstring, @foundat+@delimeterlength,LEN(@remainingstring)- @foundat+@delimeterlength)    
    --    
    END    
    ELSE    
    BEGIN    
    --    
      SET @currstring      = @remainingstring    
      SET @remainingstring = ''    
    --    
    END    
    --    
    IF @currstring <> ''    
    BEGIN    
    --    
      SET @delimeter_value        = '%'+ @rowdelimiter + '%'    
      SET @delimeterlength_value = LEN(@rowdelimiter)    
      SET @remainingstring_value = @pa_values    
      --    
      WHILE @remainingstring_value <> ''    
      BEGIN    
      --    
    
        SET @foundat = 0    
        SET @foundat = PATINDEX('%'+@delimeter_value+'%',@remainingstring_value)    
        --    
        IF @foundat > 0    
        BEGIN    
          --    
          SET @currstring_value      = SUBSTRING(@remainingstring_value, 0,@foundat)    
          SET @remainingstring_value = SUBSTRING(@remainingstring_value, @foundat+@delimeterlength_value,LEN(@remainingstring_value)- @foundat+@delimeterlength_value)    
          --    
        END    
        ELSE    
        BEGIN    
          --    
          SET @CURRSTRING_VALUE = @REMAININGSTRING_VALUE    
          SET @REMAININGSTRING_VALUE = ''    
        --    
        END    
        --    
        IF @currstring_value <> ''    
        BEGIN    
        --    
          set @line_no = @line_no + 1    
          --Target_client_id (16 characters) + coldel + Target_Sett_type + coldel + Target_Sett_no + coldel + Isin + coldel + Qty + coldel + rowdel    
                      
          SET @l_action             = citrus_usr.fn_splitval(@currstring_value,1)          
                       
          IF @l_action = 'A' OR @l_action ='E'    
          BEGIN    
          --    
            SET @l_isin              = citrus_usr.fn_splitval(@currstring_value,2)                            
            --SET @l_org_qty           = citrus_usr.fn_splitval(@currstring_value,3)                            
            SET @l_qty               = citrus_usr.fn_splitval(@currstring_value,3)     
            SET @l_rel_rsn           = citrus_usr.fn_splitval(@currstring_value,4)     
            SET @l_seq_no            = case when citrus_usr.fn_splitval(@currstring_value,5) ='' then @l_PLDT_ID + 1 else citrus_usr.fn_splitval(@currstring_value,5)  end--@l_PLDT_ID + 1
            SET @l_id                = citrus_usr.fn_splitval(@currstring_value,6)    
            SET @l_value			 = citrus_usr.fn_splitval(@currstring_value,7)    
            SET @l_qty               = CONVERT(VARCHAR(25),CONVERT(NUMERIC(18,5),-1*convert(numeric(18,5),@l_qty)))    
            set @l_high_val_yn       = case when @l_val_yn = 'Y' then 'Y' else citrus_usr.fn_get_high_val(@l_isin,abs(@l_qty),'HIGH_VALUE','','') end    
            if @l_value=''
            begin
            set @l_value='0'
            end            
          --    
          END    
          ELSE    
          BEGIN    
          --    
            SET @l_id                = citrus_usr.fn_splitval(@currstring_value,2)     
          --    
          END    

          SELECT @l_dpam_id     = dpam_id , @l_dpm_id = dpam_dpm_id FROM dp_acct_mstr, dp_mstr WHERE dpm_deleted_ind = 1   and dpm_id = dpam_dpm_id and dpm_dpid = @pa_dpm_dpid and dpam_sba_no = @pa_dpam_acct_no    

              
          IF @pa_chk_yn = 0    
          BEGIN    
          --    

    
            IF @PA_ACTION = 'INS' OR @l_action = 'A'    
            BEGIN    
            --    
              BEGIN TRANSACTION    
    
              --SELECT @l_PLDT_ID   = ISNULL(MAX(PLDT_ID),0) + 1 FROM nsdl_pledge_dtls      
                  
              set @l_PLDT_ID = @l_PLDT_ID + 1    
                  
              INSERT INTO CDSL_pledge_dtls    
              (PLDTC_ID
														,PLDTC_DTLS_ID
														,PLDTC_DPM_ID
														,PLDTC_DPAM_ID
														,PLDTC_REQUEST_DT
														,PLDTC_EXEC_DT
														,PLDTC_SLIP_NO
														,PLDTC_ISIN
														,PLDTC_QTY														
														,PLDTC_TRASTM_CD
														,PLDTC_AGREEMENT_NO
														,PLDTC_SETUP_DT
														,PLDTC_EXPIRY_DT
														,PLDTC_PLDG_DPID
														,PLDTC_PLDG_DPNAME
														,PLDTC_PLDG_CLIENTID
														,PLDTC_PLDG_CLIENTNAME
														,PLDTC_REASON
														,PLDTC_PSN
														,PLDTC_STATUS
														,PLDTC_CREATED_BY
														,PLDTC_CREATED_DATE
														,PLDTC_UPDATED_BY
														,PLDTC_UPDATED_DATE
														,PLDTC_DELETED_IND
														,PLDTC_RMKS
														,PLDTC_CLOSURE_BY  
														,PLDTC_SECURITTIES
														,PLDTC_SUB_STATUS 
														,PLDTC_VALUE
														,PLDTC_UCC 
														,PLDTC_EXID
														,PLDTC_SEGID
														,PLDTC_CMID
														,PLDTC_EID
														,PLDTC_TMCMID
														,PLDTC_REASON_CODE
														,PLDTC_ULTIMATE_LENDER_PAN
														,PLDTC_ULTIMATE_LENDER_CODE
														,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
              )VALUES     
              (@l_PLDT_ID     
              ,@l_dtls_id    
              ,@l_dpm_id    
              ,@l_dpam_id    
              ,convert(datetime,@pa_req_dt,103)    
              ,convert(datetime,@pa_exe_dt,103)    
              ,@pa_slip_no    
              ,@l_isin                  
              ,@l_qty       
              ,@l_trastm_id    
              ,@pa_agree_no    
              ,CONVERT(DATETIME,@pa_SETUP_dt,103) 
	           ,CONVERT(DATETIME,@pa_EXPIRE_dt,103)
              ,@pa_pledgee_dpid 
              ,''
              ,@pa_pledgee_acctno   
              ,@pa_PLEDGEE_DEMAT_NAME 
              ,@l_rel_rsn               
              ,@l_seq_no               
              ,'P'    
              ,@pa_login_name    
              ,getdate()    
              ,@pa_login_name    
              ,getdate()    
              ,1
              ,@pa_rmks
             ,@PA_PLDTC_CLOSURE_BY  
			 ,@PA_PLDTC_SECURITTIES
             ,@PA_PLDTC_SUB_STATUS 
             ,@l_value
			 ,@PA_UCC
			,@PA_EXID
			,@PA_SEGID
			,@PA_CMID
			,@PA_EID
			,@PA_TMCMID
			,@PA_PLDG_REASON_CODE
			,@PA_PLDG_ULTIMATE_LENDER_PAN
			,@PA_PLDG_ULTIMATE_LENDER_CODE

			,@PA_PLDTC_CUSPA_FLG 
,@PA_PLDTC_CUSPA_TRX_CTGRY 
,@PA_PLDTC_CUSPA_EPI 
,@PA_PLDTC_CUSPA_SETTLEMENTID 
,@PA_PLDTC_CUSPA_CMBP_DPID 
              )    
                  
                  
    
              SET @l_error = @@error    
              IF @l_error <> 0    
              BEGIN    
              --    
                IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                --    
                END    
    
                ROLLBACK TRANSACTION     
              --    
              END    
              ELSE    
              BEGIN    
              --    
                SET @t_errorstr = convert(varchar,@l_dtls_id)     
                COMMIT TRANSACTION    
              --    
              END    
    
            --    
            END    
            IF @PA_ACTION = 'EDT' OR @l_action = 'E'    
            BEGIN    
            --    
              BEGIN TRANSACTION    
              print @l_action     
              IF @pa_action = 'EDT'     
              BEGIN    
              --    
                UPDATE CDSL_pledge_dtls     
                SET    PLDTC_DPAM_ID = @l_dpam_id    
                      ,PLDTC_REQUEST_DT = convert(datetime,@pa_req_dt,103)    
                      ,PLDTC_EXEC_DT = convert(datetime,@pa_exe_dt,103)    
                      ,PLDTC_SETUP_DT = convert(datetime,@pa_SETUP_dt,103)    
                      ,PLDTC_EXPIRY_DT = convert(datetime,@pa_EXPIRE_dt,103)    
                      ,PLDTC_SLIP_NO = @pa_slip_no    
                      ,PLDTC_AGREEMENT_NO = @pa_agree_no    
                      ,PLDTC_PLDG_DPID = @pa_pledgee_dpid     
                      ,PLDTC_PLDG_CLIENTID = @pa_pledgee_acctno    
                      ,PLDTC_UPDATED_BY = @pa_login_name    
                      ,PLDTC_UPDATED_DATE = getdate()    
                      ,PLDTC_PLDG_CLIENTNAME = @pa_PLEDGEE_DEMAT_NAME  
                      ,pldtC_rmks = @pa_rmks                      
                      ,PLDTC_CLOSURE_BY  = @PA_PLDTC_CLOSURE_BY
			          ,PLDTC_SECURITTIES = @PA_PLDTC_SECURITTIES
                      ,PLDTC_SUB_STATUS = @PA_PLDTC_SUB_STATUS  
					  ,PLDTC_VALUE = @l_value

					,PLDTC_UCC =@PA_UCC
					,PLDTC_EXID=@PA_EXID
					,PLDTC_SEGID=@PA_SEGID
					,PLDTC_CMID=@PA_CMID
					,PLDTC_EID=@PA_EID
					,PLDTC_TMCMID=@PA_TMCMID
					,PLDTC_REASON_CODE=@PA_PLDG_REASON_CODE
					,PLDTC_ULTIMATE_LENDER_PAN=@PA_PLDG_ULTIMATE_LENDER_PAN
					,PLDTC_ULTIMATE_LENDER_CODE=@PA_PLDG_ULTIMATE_LENDER_CODE

					,PLDTC_CUSPA_FLG=@PA_PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY=@PA_PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI=@PA_PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID=@PA_PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID=@PA_PLDTC_CUSPA_CMBP_DPID
            WHERE  PLDTC_DTLS_ID    = convert(INT,@currstring)    
                AND    PLDTC_DELETED_IND = 1    
              --    
              END    
              IF @l_action = 'E'    
              BEGIN    
              --    
                    
                UPDATE  CDSL_pledge_dtls     
                SET     PLDTC_DPAM_ID = @l_dpam_id    
                       ,PLDTC_REQUEST_DT = convert(datetime,@pa_req_dt,103)    
                       ,PLDTC_EXEC_DT = convert(datetime,@pa_exe_dt,103)    
                       ,PLDTC_SETUP_DT =convert(datetime,@pa_SETUP_dt,103)    
                       ,PLDTC_EXPIRY_DT =convert(datetime,@pa_EXPIRE_dt,103)    
                       ,PLDTC_SLIP_NO = @pa_slip_no    
                       ,PLDTC_ISIN =@l_isin    
                       ,PLDTC_QTY =@l_qty    
                       ,PLDTC_AGREEMENT_NO = @pa_agree_no    
                       ,PLDTC_PLDG_DPID = @pa_pledgee_dpid     
                       ,PLDTC_PLDG_CLIENTID = @pa_pledgee_acctno    
                       ,PLDTC_REASON =@l_rel_rsn    
                       ,PLDTC_PSN=@l_SEQ_NO   
                       ,PLDTC_UPDATED_BY = @pa_login_name    
                       ,PLDTC_UPDATED_DATE = getdate()    
                       ,PLDTC_PLDG_CLIENTNAME = @pa_PLEDGEE_DEMAT_NAME  
                       ,pldtC_rmks = @pa_rmks
                       ,pldtc_value = @l_value 
                      ,PLDTC_CLOSURE_BY  = @PA_PLDTC_CLOSURE_BY
			          ,PLDTC_SECURITTIES = @PA_PLDTC_SECURITTIES
                      ,PLDTC_SUB_STATUS  = @PA_PLDTC_SUB_STATUS 
					
					,PLDTC_UCC =@PA_UCC
					,PLDTC_EXID=@PA_EXID
					,PLDTC_SEGID=@PA_SEGID
					,PLDTC_CMID=@PA_CMID
					,PLDTC_EID=@PA_EID
					,PLDTC_TMCMID=@PA_TMCMID
					,PLDTC_REASON_CODE=@PA_PLDG_REASON_CODE
					,PLDTC_ULTIMATE_LENDER_PAN=@PA_PLDG_ULTIMATE_LENDER_PAN
					,PLDTC_ULTIMATE_LENDER_CODE=@PA_PLDG_ULTIMATE_LENDER_CODE

						,PLDTC_CUSPA_FLG=@PA_PLDTC_CUSPA_FLG
	,PLDTC_CUSPA_TRX_CTGRY=@PA_PLDTC_CUSPA_TRX_CTGRY
	,PLDTC_CUSPA_EPI=@PA_PLDTC_CUSPA_EPI
	,PLDTC_CUSPA_SETTLEMENTID=@PA_PLDTC_CUSPA_SETTLEMENTID
	,PLDTC_CUSPA_CMBP_DPID=@PA_PLDTC_CUSPA_CMBP_DPID
                WHERE   PLDTC_ID                   = @l_id    
                AND     PLDTC_DELETED_IND          = 1    
              --    
              END    
                  
                  
              SET @l_error = @@error    
              IF @l_error <> 0    
              BEGIN    
              --    
                IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                --    
                END    
    
                ROLLBACK TRANSACTION     
    
    
              --    
              END    
              ELSE    
              BEGIN    
              --    
                COMMIT TRANSACTION    
              --    
              END    
            --    
            END    
            IF @PA_ACTION = 'DEL' OR @l_action = 'D'    
            BEGIN    
            --    
              BEGIN TRANSACTION    
    
              IF @pa_action = 'DEL'    
              BEGIN    
              --    
                  
                delete used from CDSL_pledge_dtls,dp_acct_mstr,used_slip used where dpam_id = PLDTC_DPAM_ID and uses_dpam_acct_no = dpam_sba_no and PLDTC_DTLS_ID = convert(BIGINT,@currstring)                      
                    
                UPDATE CDSL_pledge_dtls    
                SET    PLDTC_DELETED_IND = 0    
                     , PLDTC_UPDATED_DATE  = getdate()    
                     , PLDTC_UPDATED_BY  = @pa_login_name    
                WHERE  PLDTC_DELETED_IND = 1    
                AND    PLDTC_DTLS_ID     = convert(BIGINT,@currstring)    
                    
                    
                   
                    
              --    
              END    
              IF @l_action = 'D'    
              BEGIN    
              --    
                delete used from CDSL_pledge_dtls,dp_acct_mstr,used_slip used where dpam_id = PLDTC_DPAM_ID and uses_dpam_acct_no = dpam_sba_no and PLDTC_ID          = @l_id        
                    
                UPDATE CDSL_pledge_dtls    
                SET    PLDTC_DELETED_IND = 0    
                     , PLDTC_UPDATED_DATE  = getdate()    
                     , PLDTC_UPDATED_BY  = @pa_login_name    
                WHERE  PLDTC_DELETED_IND = 1    
                AND    PLDTC_ID          = @l_id    
                    
                               
              --    
              END    
                   
              SET @l_error = @@error    
              IF @l_error <> 0    
              BEGIN    
              --    
                IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                --    
                END    
    
                ROLLBACK TRANSACTION     
    
              --    
              END    
              ELSE    
              BEGIN    
              --    
                COMMIT TRANSACTION    
              --    
              END    
            --    
            END    
          --    
          END    
          ELSE IF @pa_chk_yn = 1    
          BEGIN    
          --    
            SELECT @l_dpam_id     = dpam_id FROM dp_acct_mstr, dp_mstr WHERE dpm_deleted_ind = 1   and dpm_id = dpam_dpm_id and dpm_dpid = @pa_dpm_dpid and dpam_sba_no = @pa_dpam_acct_no    
                
            IF @PA_ACTION = 'INS'    
            BEGIN    
            --    
    print 'yogesh'
              BEGIN TRANSACTION    
           
                  
              /*SELECT @l_PLDT_ID   = ISNULL(MAX(PLDT_ID),0) + 1 FROM nsdl_pledge_dtls      
                  
              SELECT @l_dptdm_id   = ISNULL(MAX(PLDT_ID),0) + 1 FROM NpledgeD_mak    
                  
              IF @l_dptdm_id   > @l_PLDT_ID       
              BEGIN    
              --    
                SET @l_PLDT_ID = @l_dptdm_id       
              --    
              END*/    
                  
              set @l_PLDT_ID = @l_PLDT_ID + 1    
                  
                                
              INSERT INTO CpledgeD_mak    
              (PLDTC_ID
														,PLDTC_DTLS_ID
														,PLDTC_DPM_ID
														,PLDTC_DPAM_ID
						,PLDTC_REQUEST_DT
												  ,PLDTC_EXEC_DT
														,PLDTC_SLIP_NO
														,PLDTC_ISIN
														,PLDTC_QTY
														,PLDTC_TRASTM_CD
														,PLDTC_AGREEMENT_NO
														,PLDTC_SETUP_DT
														,PLDTC_EXPIRY_DT
														,PLDTC_PLDG_DPID
														,PLDTC_PLDG_DPNAME
														,PLDTC_PLDG_CLIENTID
														,PLDTC_PLDG_CLIENTNAME
														,PLDTC_REASON
														,PLDTC_PSN
														,PLDTC_STATUS
														,PLDTC_CREATED_BY
														,PLDTC_CREATED_DATE
														,PLDTC_UPDATED_BY
														,PLDTC_UPDATED_DATE
														,PLDTC_DELETED_IND
														,PLDTC_RMKS
														,PLDTC_CLOSURE_BY  
														,PLDTC_SECURITTIES
														,PLDTC_SUB_STATUS 
														,PLDTC_VALUE
														,PLDTC_UCC 
														,PLDTC_EXID
														,PLDTC_SEGID
														,PLDTC_CMID
														,PLDTC_EID
														,PLDTC_TMCMID
														,PLDTC_REASON_CODE
														,PLDTC_ULTIMATE_LENDER_PAN
														,PLDTC_ULTIMATE_LENDER_CODE
														,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
              )VALUES     
              (@l_PLDT_ID     
              ,@l_dtls_id    
              ,@l_dpm_id    
              ,@l_dpam_id    
              ,convert(datetime,@pa_req_dt,103)    
              ,convert(datetime,@pa_exe_dt,103)    
              ,@pa_slip_no    
              ,@l_isin                  
              ,@l_qty       
              ,@l_trastm_id    
              ,@pa_agree_no    
              	,CONVERT(DATETIME,@pa_SETUP_dt,103) 
	          ,CONVERT(DATETIME,@pa_EXPIRE_dt,103)
              ,@pa_pledgee_dpid 
              ,'' 
              ,@pa_pledgee_acctno   
              ,@pa_PLEDGEE_DEMAT_NAME
              ,@l_rel_rsn               
              ,@l_seq_no               
              ,'P'    
              ,@pa_login_name    
              ,getdate()    
              ,@pa_login_name    
              ,getdate()    
              ,case when @l_high_val_yn = 'Y' then -1 else 0 end 
              ,@pa_rmks
				,@PA_PLDTC_CLOSURE_BY  
				,@PA_PLDTC_SECURITTIES
				, @PA_PLDTC_SUB_STATUS 
				,isnull(@l_value ,'0')
				,@PA_UCC
				,@PA_EXID
				,@PA_SEGID
				,@PA_CMID
				,@PA_EID
				,@PA_TMCMID
				,@PA_PLDG_REASON_CODE
				,@PA_PLDG_ULTIMATE_LENDER_PAN
				,@PA_PLDG_ULTIMATE_LENDER_CODE
					,@PA_PLDTC_CUSPA_FLG 
,@PA_PLDTC_CUSPA_TRX_CTGRY 
,@PA_PLDTC_CUSPA_EPI 
,@PA_PLDTC_CUSPA_SETTLEMENTID 
,@PA_PLDTC_CUSPA_CMBP_DPID 
              )    
                  
    
      
              SET @l_error = @@error    
              IF @l_error <> 0    
              BEGIN    
              --    
                IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                --    
                END    
    
                ROLLBACK TRANSACTION     
              --    
              END    
              ELSE    
              BEGIN    
              --    
                  
                SET @t_errorstr = convert(varchar,@l_dtls_id)     
                    
                COMMIT TRANSACTION    
              --    
              END    
            --    
            END    
            IF @PA_ACTION = 'EDT' or @l_action ='E'    
            BEGIN    
            --    
    
              BEGIN TRANSACTION    
     
              IF @pa_values = '0'    
              BEGIN    
              --    
                UPDATE CpledgeD_mak     
                SET    PLDTC_DELETED_IND = 2    
                     , PLDTC_UPDATED_DATE  = getdate()    
                     , PLDTC_UPDATED_BY  = @pa_login_name    
                WHERE  PLDTC_DTLS_ID     = CONVERT(INT,@currstring)    
              --    
              END    
              ELSE    
              BEGIN    
              --    
                IF @l_id <> '' AND  @L_ACTION <> 'D'    
                BEGIN    
                --    
                  UPDATE CpledgeD_mak     
                  SET    PLDTC_DELETED_IND = 2    
                       , PLDTC_UPDATED_DATE  = getdate()    
                       , PLDTC_UPDATED_BY  = @pa_login_name    
                  WHERE  PLDTC_ID          = @l_id    
                --    
                END    
              --    
              END    
         
              IF EXISTS(select PLDTC_ID from CDSL_pledge_dtls where PLDTC_ID = @l_id and PLDTC_DELETED_IND = 1)    
              BEGIN    
              --    
                     
                SET @l_deleted_ind = 6    
    
                IF @pa_values = '0'    
                BEGIN    
                --    
                  INSERT INTO CpledgeD_mak    
                  (PLDTC_ID
																		,PLDTC_DTLS_ID
																		,PLDTC_DPM_ID
																		,PLDTC_DPAM_ID
																		,PLDTC_REQUEST_DT
																		,PLDTC_EXEC_DT
																		,PLDTC_SLIP_NO
																		,PLDTC_ISIN
																		,PLDTC_QTY
																		,PLDTC_TRASTM_CD
																		,PLDTC_AGREEMENT_NO
																		,PLDTC_SETUP_DT
																		,PLDTC_EXPIRY_DT
																		,PLDTC_PLDG_DPID
																		,PLDTC_PLDG_DPNAME
																		,PLDTC_PLDG_CLIENTID
																		,PLDTC_PLDG_CLIENTNAME
																		,PLDTC_REASON
																		,PLDTC_PSN
																		,PLDTC_STATUS
																		,PLDTC_CREATED_BY
																		,PLDTC_CREATED_DATE
																		,PLDTC_UPDATED_BY
																		,PLDTC_UPDATED_DATE
																		,PLDTC_DELETED_IND
																		,PLDTC_RMKS
																		,PLDTC_CLOSURE_BY  
																		,PLDTC_SECURITTIES
																		,PLDTC_SUB_STATUS 
																		,PLDTC_VALUE
																		,PLDTC_UCC 
																		,PLDTC_EXID
																		,PLDTC_SEGID
																		,PLDTC_CMID
																		,PLDTC_EID
																		,PLDTC_TMCMID
																		,PLDTC_REASON_CODE
																		,PLDTC_ULTIMATE_LENDER_PAN
																		,PLDTC_ULTIMATE_LENDER_CODE

																		,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
																		)    
                  SELECT PLDTC_ID     
																	,PLDTC_DTLS_ID    
																	,@l_dpm_id    
																	,PLDTC_DPAM_ID  
																	,convert(datetime,@pa_req_dt,103)    
																	,convert(datetime,@pa_exe_dt,103)    
																	,@pa_slip_no    
																	,PLDTC_ISIN                 
																	,PLDTC_QTY       
																	,@l_trastm_id    
																	,@pa_agree_no    
																		,CONVERT(DATETIME,@pa_SETUP_dt,103) 
	                                                                ,CONVERT(DATETIME,@pa_EXPIRE_dt,103)
																	,@pa_pledgee_dpid 
																	,'' 
																	,@pa_pledgee_acctno   
																	,@pa_PLEDGEE_DEMAT_NAME
																	,PLDTC_REASON               
																	,PLDTC_PSN             
																	,'P'    
																	,PLDTC_CREATED_BY    
																	,PLDTC_CREATED_DATE 
																	,@pa_login_name    
																	,getdate()    
																	,@l_deleted_ind
																	,@pa_rmks
															,@PA_PLDTC_CLOSURE_BY  
																		,@PA_PLDTC_SECURITTIES
															,@PA_PLDTC_SUB_STATUS
															,PLDTC_VALUE 
															,@PA_UCC
															,@PA_EXID
															,@PA_SEGID
															,@PA_CMID
															,@PA_EID
															,@PA_TMCMID
															,@PA_PLDG_REASON_CODE
															,@PA_PLDG_ULTIMATE_LENDER_PAN
															,@PA_PLDG_ULTIMATE_LENDER_CODE

																,@PA_PLDTC_CUSPA_FLG 
,@PA_PLDTC_CUSPA_TRX_CTGRY 
,@PA_PLDTC_CUSPA_EPI 
,@PA_PLDTC_CUSPA_SETTLEMENTID 
,@PA_PLDTC_CUSPA_CMBP_DPID 

                  FROM  CDSL_pledge_dtls    
                  WHERE PLDTC_DTLS_ID       =  CONVERT(INT,@currstring)    
                  AND   PLDTC_DELETED_IND   =  1     
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  IF @l_action = 'A'    
                  BEGIN    
                  --    
                    --select @l_id = ISNULL(MAX(PLDT_ID),0) + 1 FROM NpledgeD_mak    
                    set @l_PLDT_ID = @l_PLDT_ID + 1 
					set @l_deleted_ind = case when @l_high_val_yn = 'Y' then -1 else 0 end                                
                  --    
                  END    
                  IF @l_action <> 'D'    
                  BEGIN    
                  --    
							INSERT INTO CpledgeD_mak    
							(PLDTC_ID
							,PLDTC_DTLS_ID
							,PLDTC_DPM_ID
							,PLDTC_DPAM_ID
							,PLDTC_REQUEST_DT
							,PLDTC_EXEC_DT
							,PLDTC_SLIP_NO
							,PLDTC_ISIN
							,PLDTC_QTY
							,PLDTC_TRASTM_CD
							,PLDTC_AGREEMENT_NO
							,PLDTC_SETUP_DT
							,PLDTC_EXPIRY_DT
							,PLDTC_PLDG_DPID
							,PLDTC_PLDG_DPNAME
							,PLDTC_PLDG_CLIENTID
							,PLDTC_PLDG_CLIENTNAME
							,PLDTC_REASON
							,PLDTC_PSN
							,PLDTC_STATUS
							,PLDTC_CREATED_BY
							,PLDTC_CREATED_DATE
							,PLDTC_UPDATED_BY
							,PLDTC_UPDATED_DATE
							,PLDTC_DELETED_IND
							,PLDTC_RMKS
							,PLDTC_CLOSURE_BY  
							,PLDTC_SECURITTIES
							,PLDTC_SUB_STATUS 
							,PLDTC_VALUE
							,PLDTC_UCC 
							,PLDTC_EXID
							,PLDTC_SEGID
							,PLDTC_CMID
							,PLDTC_EID
							,PLDTC_TMCMID
							,PLDTC_REASON_CODE
							,PLDTC_ULTIMATE_LENDER_PAN
							,PLDTC_ULTIMATE_LENDER_CODE

							,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
							)VALUES     
							(@l_PLDT_ID     
							,@l_dtls_id    
							,@l_dpm_id    
							,@l_dpam_id    
							,convert(datetime,@pa_req_dt,103)    
							,convert(datetime,@pa_exe_dt,103)    
							,@pa_slip_no    
							,@l_isin                  
							,@l_qty       
							,@l_trastm_id    
							,@pa_agree_no    
							,CONVERT(DATETIME,@pa_SETUP_dt,103) 
							,CONVERT(DATETIME,@pa_EXPIRE_dt,103)
							,@pa_pledgee_dpid 
							,'' 
							,@pa_pledgee_acctno   
							,@pa_PLEDGEE_DEMAT_NAME
							,@l_rel_rsn               
							,@l_seq_no               
							,'P'    
							,@pa_login_name    
							,getdate()    
							,@pa_login_name    
							,getdate()    
							,@l_deleted_ind
							,@pa_rmks
							,@PA_PLDTC_CLOSURE_BY  
							,@PA_PLDTC_SECURITTIES
							,@PA_PLDTC_SUB_STATUS 
							,@l_value 
							,@PA_UCC
							,@PA_EXID
							,@PA_SEGID
							,@PA_CMID
							,@PA_EID
							,@PA_TMCMID
							,@PA_PLDG_REASON_CODE
							,@PA_PLDG_ULTIMATE_LENDER_PAN
							,@PA_PLDG_ULTIMATE_LENDER_CODE

								,@PA_PLDTC_CUSPA_FLG 
,@PA_PLDTC_CUSPA_TRX_CTGRY 
,@PA_PLDTC_CUSPA_EPI 
,@PA_PLDTC_CUSPA_SETTLEMENTID 
,@PA_PLDTC_CUSPA_CMBP_DPID 
							)    
                  --    
                  END    
                --    
                END    
              --    
              END    
              ELSE    
              BEGIN    
              --    
                SET @l_deleted_ind = 0     
                IF @pa_values = '0'     
                BEGIN    
                --    
                  INSERT INTO CpledgeD_mak    
							(PLDTC_ID
							,PLDTC_DTLS_ID
							,PLDTC_DPM_ID
							,PLDTC_DPAM_ID
							,PLDTC_REQUEST_DT
							,PLDTC_EXEC_DT
							,PLDTC_SLIP_NO
							,PLDTC_ISIN
							,PLDTC_QTY
							,PLDTC_TRASTM_CD
							,PLDTC_AGREEMENT_NO
							,PLDTC_SETUP_DT
							,PLDTC_EXPIRY_DT
							,PLDTC_PLDG_DPID
							,PLDTC_PLDG_DPNAME
							,PLDTC_PLDG_CLIENTID
							,PLDTC_PLDG_CLIENTNAME
							,PLDTC_REASON
							,PLDTC_PSN
							,PLDTC_STATUS
							,PLDTC_CREATED_BY
							,PLDTC_CREATED_DATE
							,PLDTC_UPDATED_BY
							,PLDTC_UPDATED_DATE
							,PLDTC_DELETED_IND
							,PLDTC_RMKS
							,PLDTC_CLOSURE_BY  
							,PLDTC_SECURITTIES
							,PLDTC_SUB_STATUS 
							,PLDTC_VALUE
							,PLDTC_UCC 
							,PLDTC_EXID
							,PLDTC_SEGID
							,PLDTC_CMID
							,PLDTC_EID
							,PLDTC_TMCMID
							,PLDTC_REASON_CODE
							,PLDTC_ULTIMATE_LENDER_PAN
							,PLDTC_ULTIMATE_LENDER_CODE

							,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
														)    
																		SELECT PLDTC_ID     
																	,PLDTC_DTLS_ID    
																	,@l_dpm_id    
																	,PLDTC_DPAM_ID  
																	,convert(datetime,@pa_req_dt,103)    
																	,convert(datetime,@pa_exe_dt,103)    
																	,@pa_slip_no    
																	,PLDTC_ISIN                 
																	,PLDTC_QTY       
																	,@l_trastm_id    
																	,@pa_agree_no    
																		,CONVERT(DATETIME,@pa_SETUP_dt,103) 
	                                                                 ,CONVERT(DATETIME,@pa_EXPIRE_dt,103)
																	,@pa_pledgee_dpid 
																	,'' 
																	,@pa_pledgee_acctno   
																	,@pa_PLEDGEE_DEMAT_NAME
																	,PLDTC_REASON               
																	,PLDTC_PSN             
																	,'P'    
																	,PLDTC_CREATED_BY    
																	,PLDTC_CREATED_DATE 
																	,@pa_login_name    
																	,getdate()    
																	,@l_deleted_ind
																	,@pa_rmks
																	,@PA_PLDTC_CLOSURE_BY  
																	,@PA_PLDTC_SECURITTIES
																	,@PA_PLDTC_SUB_STATUS 
																	,PLDTC_VALUE
																	,@PA_UCC
																	,@PA_EXID
																	,@PA_SEGID
																	,@PA_CMID
																	,@PA_EID
																	,@PA_TMCMID
																	,@PA_PLDG_REASON_CODE
																	,@PA_PLDG_ULTIMATE_LENDER_PAN
																	,@PA_PLDG_ULTIMATE_LENDER_CODE
																		,@PA_PLDTC_CUSPA_FLG 
,@PA_PLDTC_CUSPA_TRX_CTGRY 
,@PA_PLDTC_CUSPA_EPI 
,@PA_PLDTC_CUSPA_SETTLEMENTID 
,@PA_PLDTC_CUSPA_CMBP_DPID 
                  FROM  #CpledgeD_mak    
                  WHERE PLDTC_DTLS_ID       =  CONVERT(INT,@currstring)    
                  AND   PLDTC_DELETED_IND   =  0    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  IF @l_action = 'A'    
                  BEGIN    
                  --    
                    --select @l_id = ISNULL(MAX(PLDT_ID),0) + 1 FROM NpledgeD_mak    
                    set @l_PLDT_ID = @l_PLDT_ID + 1    
                  --    
                  END    
                  IF @l_action <> 'D'    
                  begin    
                  --    
    
                    INSERT INTO CpledgeD_mak    
																				(PLDTC_ID
																				,PLDTC_DTLS_ID
																				,PLDTC_DPM_ID
																				,PLDTC_DPAM_ID
																				,PLDTC_REQUEST_DT
																				,PLDTC_EXEC_DT
																				,PLDTC_SLIP_NO
																				,PLDTC_ISIN
																				,PLDTC_QTY
																				,PLDTC_TRASTM_CD
																				,PLDTC_AGREEMENT_NO
																				,PLDTC_SETUP_DT
																				,PLDTC_EXPIRY_DT
																				,PLDTC_PLDG_DPID
																				,PLDTC_PLDG_DPNAME
																				,PLDTC_PLDG_CLIENTID
																				,PLDTC_PLDG_CLIENTNAME
																				,PLDTC_REASON
																				,PLDTC_PSN
																				,PLDTC_STATUS
																				,PLDTC_CREATED_BY
																				,PLDTC_CREATED_DATE
																				,PLDTC_UPDATED_BY
																				,PLDTC_UPDATED_DATE
																				,PLDTC_DELETED_IND
																				,PLDTC_RMKS
																				,PLDTC_CLOSURE_BY  
																				,PLDTC_SECURITTIES
																				,PLDTC_SUB_STATUS 
																				,PLDTC_VALUE
																				,PLDTC_UCC 
																				,PLDTC_EXID
																				,PLDTC_SEGID
																				,PLDTC_CMID
																				,PLDTC_EID
																				,PLDTC_TMCMID
																				,PLDTC_REASON_CODE
																				,PLDTC_ULTIMATE_LENDER_PAN
																				,PLDTC_ULTIMATE_LENDER_CODE

																				,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
																				)VALUES     
																				(@l_PLDT_ID     
																				,@l_dtls_id    
																				,@l_dpm_id    
																				,@l_dpam_id    
																				,convert(datetime,@pa_req_dt,103)    
																				,convert(datetime,@pa_exe_dt,103)    
																				,@pa_slip_no    
																				,@l_isin                  
																				,@l_qty       
																				,@l_trastm_id    
																				,@pa_agree_no    
																					,CONVERT(DATETIME,@pa_SETUP_dt,103) 
																				,CONVERT(DATETIME,@pa_EXPIRE_dt,103)
																				,@pa_pledgee_dpid 
																				,'' 
																				,@pa_pledgee_acctno   
																				,@pa_PLEDGEE_DEMAT_NAME
																				,@l_rel_rsn               
																				,@l_seq_no               
																				,'P'    
																				,@pa_login_name    
																				,getdate()    
																				,@pa_login_name    
																				,getdate()    
																				,case when @l_high_val_yn = 'Y' then -1 else 0 end 
																				,@pa_rmks
																				,@PA_PLDTC_CLOSURE_BY  
																				,@PA_PLDTC_SECURITTIES
																				,@PA_PLDTC_SUB_STATUS 
																				,@l_value 
																				,@PA_UCC
																				,@PA_EXID
																				,@PA_SEGID
																				,@PA_CMID
																				,@PA_EID
																				,@PA_TMCMID
																				,@PA_PLDG_REASON_CODE
																				,@PA_PLDG_ULTIMATE_LENDER_PAN
																				,@PA_PLDG_ULTIMATE_LENDER_CODE
																					,@PA_PLDTC_CUSPA_FLG 
,@PA_PLDTC_CUSPA_TRX_CTGRY 
,@PA_PLDTC_CUSPA_EPI 
,@PA_PLDTC_CUSPA_SETTLEMENTID 
,@PA_PLDTC_CUSPA_CMBP_DPID 
																				)    
                        
                  --    
                  END    
                --    
                END    
                   
                   
              --    
              END    
               SET @l_error = @@error    
               IF @l_error <> 0    
               BEGIN    
               --    
                 IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                 BEGIN    
                 --    
                   SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                 --    
                 END    
                 ELSE    
                 BEGIN    
                 --    
                   SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                 --    
                 END    
    
                 ROLLBACK TRANSACTION     
    
    
               --    
               END    
               ELSE    
               BEGIN    
               --    
                 COMMIT TRANSACTION    
               --    
               END    
            --    
            END    
            IF @PA_ACTION = 'DEL' or @l_action = 'D'     
            BEGIN    
   --    
    
              IF exists(SELECT * FROM CpledgeD_mak WHERE PLDTC_DTLS_ID = convert(numeric,@currstring) and PLDTC_DELETED_IND IN (0,-1))    
              BEGIN    
              --    
                if @l_action = 'D'     
                BEGIN    
                --    
                  DELETE FROM CpledgeD_mak    
                  WHERE  PLDTC_DELETED_IND IN (0,-1)   
                  AND    PLDTC_ID          = convert(numeric,@l_id)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  DELETE FROM CpledgeD_mak    
                  WHERE  PLDTC_DELETED_IND IN (0,-1)     
                  AND    PLDTC_DTLS_ID          = convert(numeric,@currstring)    
                --    
                END    
              --    
              END    
              ELSE    
              BEGIN    
              --    
                begin transaction     
                    
                if @l_action = 'D'     
                BEGIN    
                --    
                INSERT INTO CpledgeD_mak    
																(PLDTC_ID
																,PLDTC_DTLS_ID
																,PLDTC_DPM_ID
																,PLDTC_DPAM_ID
																,PLDTC_REQUEST_DT
																,PLDTC_EXEC_DT
																,PLDTC_SLIP_NO
																,PLDTC_ISIN
																,PLDTC_QTY
																,PLDTC_TRASTM_CD
																,PLDTC_AGREEMENT_NO
																,PLDTC_SETUP_DT
																,PLDTC_EXPIRY_DT
																,PLDTC_PLDG_DPID
																,PLDTC_PLDG_DPNAME
																,PLDTC_PLDG_CLIENTID
																,PLDTC_PLDG_CLIENTNAME
																,PLDTC_REASON
																,PLDTC_PSN
																,PLDTC_STATUS
																,PLDTC_CREATED_BY
																,PLDTC_CREATED_DATE
																,PLDTC_UPDATED_BY
																,PLDTC_UPDATED_DATE
																,PLDTC_DELETED_IND
																,PLDTC_RMKS
																,PLDTC_CLOSURE_BY  
																,PLDTC_SECURITTIES
																,PLDTC_SUB_STATUS
																,PLDTC_VALUE 
																,PLDTC_UCC 
																,PLDTC_EXID
																,PLDTC_SEGID
																,PLDTC_CMID
																,PLDTC_EID
																,PLDTC_TMCMID
																,PLDTC_REASON_CODE
																,PLDTC_ULTIMATE_LENDER_PAN
																,PLDTC_ULTIMATE_LENDER_CODE

																,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
																)
                  SELECT  PLDTC_ID
																		,PLDTC_DTLS_ID
																		,PLDTC_DPM_ID
																		,PLDTC_DPAM_ID
																		,PLDTC_REQUEST_DT
																		,PLDTC_EXEC_DT
																		,PLDTC_SLIP_NO
																		,PLDTC_ISIN
																		,PLDTC_QTY
																		,PLDTC_TRASTM_CD
																		,PLDTC_AGREEMENT_NO
																		,PLDTC_SETUP_DT
																		,PLDTC_EXPIRY_DT
																		,PLDTC_PLDG_DPID
																		,PLDTC_PLDG_DPNAME
																		,PLDTC_PLDG_CLIENTID
																		,PLDTC_PLDG_CLIENTNAME
																		,PLDTC_REASON
																		,PLDTC_PSN
																		,PLDTC_STATUS
																		,PLDTC_CREATED_BY
																		,PLDTC_CREATED_DATE
																		,PLDTC_UPDATED_BY
																		,PLDTC_UPDATED_DATE
																		,4
																		,PLDTC_RMKS
																		,PLDTC_CLOSURE_BY  
																		,PLDTC_SECURITTIES
																		,PLDTC_SUB_STATUS 
																		,PLDTC_VALUE
																		,PLDTC_UCC 
																		,PLDTC_EXID
																		,PLDTC_SEGID
																		,PLDTC_CMID
																		,PLDTC_EID
																		,PLDTC_TMCMID
																		,PLDTC_REASON_CODE
																		,PLDTC_ULTIMATE_LENDER_PAN
																		,PLDTC_ULTIMATE_LENDER_CODE

																		,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
                  FROM CDSL_pledge_dtls    
                  WHERE PLDTC_DELETED_IND      = 1     
                  AND   PLDTC_DTLS_ID          = convert(numeric,@currstring)    
                  AND   PLDTC_ID               = convert(numeric,@l_id)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  INSERT INTO CpledgeD_mak    
																		(PLDTC_ID
																		,PLDTC_DTLS_ID
																		,PLDTC_DPM_ID
																		,PLDTC_DPAM_ID
																		,PLDTC_REQUEST_DT
																		,PLDTC_EXEC_DT
																		,PLDTC_SLIP_NO
																		,PLDTC_ISIN
																		,PLDTC_QTY
																		,PLDTC_TRASTM_CD
																		,PLDTC_AGREEMENT_NO
																		,PLDTC_SETUP_DT
																		,PLDTC_EXPIRY_DT
																		,PLDTC_PLDG_DPID
																		,PLDTC_PLDG_DPNAME
																		,PLDTC_PLDG_CLIENTID
																		,PLDTC_PLDG_CLIENTNAME
																		,PLDTC_REASON
																		,PLDTC_PSN
																		,PLDTC_STATUS
																		,PLDTC_CREATED_BY
																		,PLDTC_CREATED_DATE
																		,PLDTC_UPDATED_BY
																		,PLDTC_UPDATED_DATE
																		,PLDTC_DELETED_IND
																		,PLDTC_RMKS
																		,PLDTC_CLOSURE_BY  
																		,PLDTC_SECURITTIES
																		,PLDTC_SUB_STATUS
																		,PLDTC_VALUE 
																		,PLDTC_UCC 
																		,PLDTC_EXID
																		,PLDTC_SEGID
																		,PLDTC_CMID
																		,PLDTC_EID
																		,PLDTC_TMCMID
																		,PLDTC_REASON_CODE
																		,PLDTC_ULTIMATE_LENDER_PAN
																		,PLDTC_ULTIMATE_LENDER_CODE
																		,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
																		)
																				SELECT  PLDTC_ID
																				,PLDTC_DTLS_ID
																				,PLDTC_DPM_ID
																				,PLDTC_DPAM_ID
																				,PLDTC_REQUEST_DT
																				,PLDTC_EXEC_DT
																				,PLDTC_SLIP_NO
																				,PLDTC_ISIN
																				,PLDTC_QTY
																				,PLDTC_TRASTM_CD
																				,PLDTC_AGREEMENT_NO
																				,PLDTC_SETUP_DT
																				,PLDTC_EXPIRY_DT
																				,PLDTC_PLDG_DPID
																				,PLDTC_PLDG_DPNAME
																				,PLDTC_PLDG_CLIENTID
																				,PLDTC_PLDG_CLIENTNAME
																				,PLDTC_REASON
																				,PLDTC_PSN
																				,PLDTC_STATUS
																				,PLDTC_CREATED_BY
																				,PLDTC_CREATED_DATE
																				,PLDTC_UPDATED_BY
																				,PLDTC_UPDATED_DATE
																				,4
																				,PLDTC_RMKS
																				,PLDTC_CLOSURE_BY  
																				,PLDTC_SECURITTIES
																				,PLDTC_SUB_STATUS
																				,PLDTC_VALUE 
																				,PLDTC_UCC 
																				,PLDTC_EXID
																				,PLDTC_SEGID
																				,PLDTC_CMID
																				,PLDTC_EID
																				,PLDTC_TMCMID
																				,PLDTC_REASON_CODE
																				,PLDTC_ULTIMATE_LENDER_PAN
																				,PLDTC_ULTIMATE_LENDER_CODE

																				,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
                 FROM CDSL_pledge_dtls    
                 WHERE PLDTC_DELETED_IND      = 1     
                 AND   PLDTC_DTLS_ID          = convert(numeric,@currstring)    
                --    
                END    
                    
                SET @l_error = @@error    
                IF @l_error <> 0    
                BEGIN    
                --    
                  IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                  BEGIN    
                  --    
                    SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                  --    
                  END    
                  ELSE    
                  BEGIN    
                  --    
                    SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                  --    
                  END    
    
                  ROLLBACK TRANSACTION     
    
    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  COMMIT TRANSACTION    
                --    
                END    
                    
              --    
              END    
            --    
            END    
            ELSE IF @PA_ACTION = 'APP'    
            BEGIN    
            --    
    PRINT convert(numeric,@currstring)
              SET @@c_access_cursor =  CURSOR fast_forward FOR          
              SELECT PLDTC_ID, PLDTC_DELETED_IND  FROM CpledgeD_mak where PLDTC_DTLS_ID = convert(numeric,@currstring) and PLDTC_DELETED_IND in (0,4,6,-1)    
              --          
              OPEN @@c_access_cursor          
              FETCH NEXT FROM @@c_access_cursor INTO @c_PLDT_ID, @c_deleted_ind     
              --          
              WHILE @@fetch_status = 0          
              BEGIN          
              --          
                 BEGIN TRANSACTION    
    
                 IF EXISTS(select PLDTC_ID from CpledgeD_mak where PLDTC_ID = @c_PLDT_ID and PLDTC_DELETED_IND = 6)    
                 BEGIN    
                 --    
                   UPDATE  dptd     
                   SET    dptd.PLDTC_REQUEST_DT=dptdM.PLDTC_REQUEST_DT
						,dptd.PLDTC_EXEC_DT=dptdM.PLDTC_EXEC_DT
						,dptd.PLDTC_SLIP_NO=dptdM.PLDTC_SLIP_NO
						,dptd.PLDTC_ISIN=dptdM.PLDTC_ISIN
						,dptd.PLDTC_QTY=dptdM.PLDTC_QTY
						,dptd.PLDTC_AGREEMENT_NO=dptdM.PLDTC_AGREEMENT_NO
						,dptd.PLDTC_SETUP_DT=dptdM.PLDTC_SETUP_DT
						,dptd.PLDTC_EXPIRY_DT=dptdM.PLDTC_EXPIRY_DT
						,dptd.PLDTC_PLDG_DPID=dptdM.PLDTC_PLDG_DPID
						,dptd.PLDTC_PLDG_DPNAME=dptdM.PLDTC_PLDG_DPNAME
						,dptd.PLDTC_PLDG_CLIENTID=dptdM.PLDTC_PLDG_CLIENTID
						,dptd.PLDTC_PLDG_CLIENTNAME=dptdM.PLDTC_PLDG_CLIENTNAME
						,dptd.PLDTC_REASON=dptdM.PLDTC_REASON
						,dptd.PLDTC_PSN=dptdM.PLDTC_PSN
						,dptd.PLDTC_UPDATED_BY=dptdM.PLDTC_UPDATED_BY
						,dptd.PLDTC_UPDATED_DATE=dptdM.PLDTC_UPDATED_DATE
						,dptd.PLDTC_RMKS=dptdM.PLDTC_RMKS
						,dptd.PLDTC_CLOSURE_BY  = dptdM.PLDTC_CLOSURE_BY  
						,dptd.PLDTC_SECURITTIES = dptdM.PLDTC_SECURITTIES
                        ,DPTD.PLDTC_SUB_STATUS =DPTDM.PLDTC_SUB_STATUS 
                        ,DPTD.PLDTC_VALUE = DPTDM.PLDTC_VALUE
						,DPTD.PLDTC_UCC =DPTDM.PLDTC_UCC
						,DPTD.PLDTC_EXID=DPTDM.PLDTC_EXID
						,DPTD.PLDTC_SEGID=DPTDM.PLDTC_SEGID
						,DPTD.PLDTC_CMID=DPTDM.PLDTC_CMID
						,DPTD.PLDTC_EID=DPTDM.PLDTC_EID
						,DPTD.PLDTC_TMCMID=DPTDM.PLDTC_TMCMID
						,DPTD.PLDTC_REASON_CODE=DPTDM.PLDTC_REASON_CODE
						,DPTD.PLDTC_ULTIMATE_LENDER_PAN=DPTDM.PLDTC_ULTIMATE_LENDER_PAN
						,DPTD.PLDTC_ULTIMATE_LENDER_CODE=DPTDM.PLDTC_ULTIMATE_LENDER_CODE

							,DPTD.PLDTC_CUSPA_FLG=DPTDM.PLDTC_CUSPA_FLG
	,DPTD.PLDTC_CUSPA_TRX_CTGRY=DPTDM.PLDTC_CUSPA_TRX_CTGRY
	,DPTD.PLDTC_CUSPA_EPI=DPTDM.PLDTC_CUSPA_EPI
	,DPTD.PLDTC_CUSPA_SETTLEMENTID=DPTDM.PLDTC_CUSPA_SETTLEMENTID
	,DPTD.PLDTC_CUSPA_CMBP_DPID=DPTDM.PLDTC_CUSPA_CMBP_DPID
                   FROM    CpledgeD_mak                    dptdm           
                          ,CDSL_pledge_dtls                 dptd     
                   WHERE   dptdm.PLDTC_ID             = convert(numeric,@c_PLDT_ID)    
                   AND      dptdm.PLDTC_ID             = DPTD.PLDTC_ID     
                   and     dptdm.PLDTC_DTLS_ID        = DPTD.PLDTC_DTLS_ID     
                   AND     dptdm.PLDTC_DELETED_IND    = 6      
    
                   SET @l_error = @@error    
                   IF @l_error <> 0    
                   BEGIN    
                   --    
                     ROLLBACK TRANSACTION     
    
                     IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                     BEGIN    
                     --    
                       SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                     --    
                     END    
                     ELSE    
                     BEGIN    
                     --    
                       SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                     --    
                     END    
                   --    
                   END    
                   ELSE    
                   BEGIN    
                   --    
    
                     UPDATE CpledgeD_mak     
                     SET    PLDTC_DELETED_IND = 7    
                          , PLDTC_UPDATED_DATE  = getdate()    
                          , PLDTC_UPDATED_BY  = @pa_login_name    
                     WHERE  PLDTC_ID          = convert(numeric,@c_PLDT_ID)    
                     AND    PLDTC_DELETED_IND = 6    
    
    
                     COMMIT TRANSACTION    
                   --    
                   END    
                 --    
                 END    
                 ELSE IF exists(select PLDTC_ID from CpledgeD_mak where PLDTC_ID = convert(numeric,@c_PLDT_ID) and PLDTC_DELETED_IND in (0,-1))    
                 BEGIN    
                 --    
    
                   INSERT INTO CDSL_pledge_dtls    
                   (PLDTC_ID
																				,PLDTC_DTLS_ID
																				,PLDTC_DPM_ID
																				,PLDTC_DPAM_ID
																				,PLDTC_REQUEST_DT
																				,PLDTC_EXEC_DT
																				,PLDTC_SLIP_NO
																				,PLDTC_ISIN
																				,PLDTC_QTY
																				,PLDTC_TRASTM_CD
																				,PLDTC_AGREEMENT_NO
																				,PLDTC_SETUP_DT
																				,PLDTC_EXPIRY_DT
																				,PLDTC_PLDG_DPID
																				,PLDTC_PLDG_DPNAME
																				,PLDTC_PLDG_CLIENTID
																				,PLDTC_PLDG_CLIENTNAME
																				,PLDTC_REASON
																				,PLDTC_PSN
																				,PLDTC_TRANS_NO
																				,PLDTC_BATCH_NO
																				,PLDTC_BROKER_BATCH_NO
																				,PLDTC_BROKER_REF_NO
																				,PLDTC_STATUS
																				,PLDTC_CREATED_BY
																				,PLDTC_CREATED_DATE
																				,PLDTC_UPDATED_BY
																				,PLDTC_UPDATED_DATE
																				,PLDTC_DELETED_IND
																				,PLDTC_RMKS
																				,PLDTC_CLOSURE_BY
																				,PLDTC_SECURITTIES
																				,PLDTC_SUB_STATUS
																				,PLDTC_VALUE 
																				,PLDTC_UCC 
																				,PLDTC_EXID
																				,PLDTC_SEGID
																				,PLDTC_CMID
																				,PLDTC_EID
																				,PLDTC_TMCMID
																				,PLDTC_REASON_CODE
																				,PLDTC_ULTIMATE_LENDER_PAN
																				,PLDTC_ULTIMATE_LENDER_CODE

																				,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
																				)    
                   SELECT     
                    PLDTC_ID
																				,PLDTC_DTLS_ID
																				,PLDTC_DPM_ID
																				,PLDTC_DPAM_ID
																				,PLDTC_REQUEST_DT
																				,PLDTC_EXEC_DT
																				,PLDTC_SLIP_NO
																				,PLDTC_ISIN
																				,PLDTC_QTY
																				,PLDTC_TRASTM_CD
																				,PLDTC_AGREEMENT_NO
																				,PLDTC_SETUP_DT
																				,PLDTC_EXPIRY_DT
																				,PLDTC_PLDG_DPID
																				,PLDTC_PLDG_DPNAME
																				,PLDTC_PLDG_CLIENTID
																				,PLDTC_PLDG_CLIENTNAME
																				,PLDTC_REASON
																				,PLDTC_PSN
																				,PLDTC_TRANS_NO
																				,PLDTC_BATCH_NO
																				,PLDTC_BROKER_BATCH_NO
																				,PLDTC_BROKER_REF_NO
																				,PLDTC_STATUS
																				,PLDTC_CREATED_BY
																				,PLDTC_CREATED_DATE
																				,PLDTC_UPDATED_BY
																				,PLDTC_UPDATED_DATE
																				,1
																				,PLDTC_RMKS
																				,PLDTC_CLOSURE_BY
																				,PLDTC_SECURITTIES
																				,PLDTC_SUB_STATUS
																				,PLDTC_VALUE 
																				,PLDTC_UCC 
																				,PLDTC_EXID
																				,PLDTC_SEGID
																				,PLDTC_CMID
																				,PLDTC_EID
																				,PLDTC_TMCMID
																				,PLDTC_REASON_CODE
																				,PLDTC_ULTIMATE_LENDER_PAN
																				,PLDTC_ULTIMATE_LENDER_CODE

																				,PLDTC_CUSPA_FLG
,PLDTC_CUSPA_TRX_CTGRY
,PLDTC_CUSPA_EPI
,PLDTC_CUSPA_SETTLEMENTID
,PLDTC_CUSPA_CMBP_DPID
                   FROM  CpledgeD_mak    
                   WHERE PLDTC_DELETED_IND      = 0 
                   AND   PLDTC_ID               = convert(numeric,@c_PLDT_ID)     
    
    
    
    
                   SET @l_error = @@error    
                   IF @l_error <> 0    
                   BEGIN    
                   --    
                     ROLLBACK TRANSACTION     
    
                     IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                     BEGIN    
                     --    
                       SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                     --    
                     END    
                     ELSE    
                     BEGIN    
                     --    
                       SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                     --    
                     END    
                   --    
                   END    
                   ELSE    
                   BEGIN    
                   --    
    
                      if exists(select PLDTC_ID from CpledgeD_mak where PLDTC_ID = convert(numeric,@c_PLDT_ID) AND PLDTC_DELETED_IND IN (-1,0)  )    
                      begin    
                      --    
                        UPDATE CpledgeD_mak         
                        SET    PLDTC_DELETED_IND = CASE WHEN  PLDTC_DELETED_IND = -1 THEN 0 ELSE 1 END         
                             , PLDTC_UPDATED_DATE  = getdate()        
                             , PLDTC_UPDATED_BY  = @pa_login_name        
                        WHERE  PLDTC_ID          = convert(numeric,@c_PLDT_ID)        
                        AND    PLDTC_DELETED_IND IN (-1,0)       
                      --    
                      end    

                          
                     COMMIT TRANSACTION    
                   --    
                   END    
                 --    
                 END    
                 ELSE     
                 BEGIN    
                 --    
                   delete used from CDSL_pledge_dtls,dp_acct_mstr,used_slip used where dpam_id = PLDTC_DPAM_ID and uses_dpam_acct_no = dpam_sba_no and PLDTC_ID          = convert(numeric,@c_PLDT_ID)     
                       
                   UPDATE CDSL_pledge_dtls    
                   SET    PLDTC_DELETED_IND = 0    
                        , PLDTC_UPDATED_DATE  = getdate()    
                        , PLDTC_UPDATED_BY  = @pa_login_name    
                   WHERE  PLDTC_ID          = convert(numeric,@c_PLDT_ID)    
                   AND    PLDTC_DELETED_IND = 1    
    
    
    
                   UPDATE CpledgeD_mak     
                   SET    PLDTC_DELETED_IND = 5    
                        , PLDTC_UPDATED_DATE  = getdate()    
                        , PLDTC_UPDATED_BY  = @pa_login_name    
                   WHERE  PLDTC_ID          = convert(numeric,@c_PLDT_ID)    
                   AND    PLDTC_DELETED_IND = 4    
    
                   COMMIT TRANSACTION    
                 --    
                 END    
    
    
               FETCH NEXT FROM @@c_access_cursor INTO @c_PLDT_ID, @c_deleted_ind         
            --          
            END          
    
              CLOSE      @@c_access_cursor          
              DEALLOCATE @@c_access_cursor      
            --    
            END    
            ELSE IF @PA_ACTION = 'REJ'    
            BEGIN    
            --    
    
              BEGIN TRANSACTION    
                  
              UPDATE CpledgeD_mak     
              SET    PLDTC_DELETED_IND = 3    
                   , PLDTC_UPDATED_DATE  = getdate()    
                   , PLDTC_UPDATED_BY  = @pa_login_name    
              WHERE  PLDTC_DTLS_ID     = convert(numeric,@currstring)    
              AND    PLDTC_DELETED_IND in (0,4,6)    
    
              SET @l_error = @@error    
              IF @l_error <> 0    
              BEGIN    
              --    
                ROLLBACK TRANSACTION     
    
                IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'    
                --    
                END    
              --    
              END    
              ELSE    
              BEGIN    
              --    
                COMMIT TRANSACTION    
              --    
              END    
            --    
            END    
          --    
          END    
        --      
        END      
      --    
      END    
          
    --    
    END    
  --    
  END    
  SET @pa_errmsg = @t_errorstr    
  PRINT @pa_errmsg     
  IF left(ltrim(rtrim(@pa_errmsg)),5) <> 'ERROR'    
  BEGIN    
  --    
print @l_trastm_id
print @l_trastm_id
print @pa_dpm_dpid
print @pa_dpam_acct_no
print @pa_slip_no

    exec [pr_checkslipno_pledge] '',@l_trastm_id,@l_trastm_id, @pa_dpm_dpid,@pa_dpam_acct_no,@pa_slip_no,@pa_login_name,''    
  --    
  END    
--    
END

GO
