-- Object: PROCEDURE citrus_usr.pr_ins_upd_trx_cdsl_sp_PreEDIS_AngelPre
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------




--pr_ins_upd_trx_cdsl '0','BOBO','INS','HO','45612398','67676767','001','','','03/12/2007','0','0','NA','03/12/2007','','45612398','','','11111111','A|*~|IN0019830010|*~|6|*~|*|~*','0','*|~*','|*~|',''     
CREATE PROCEDURE [citrus_usr].[pr_ins_upd_trx_cdsl_sp_PreEDIS_AngelPre](@pa_id              VARCHAR(8000)      
              ,@pa_tab             VARCHAR(20)    
              ,@pa_action          VARCHAR(20)      
              ,@pa_login_name      VARCHAR(20)      
              ,@pa_dpm_dpid        VARCHAR(50)    
              ,@pa_dpam_acct_no    VARCHAR(50)    
              ,@pa_slip_no         VARCHAR(20)     
              ,@pa_mkt_type        VARCHAR(20)     
              ,@pa_settlm_no       VARCHAR(20)    
              ,@pa_req_dt          VARCHAR(11)    
              ,@pa_cm_id           varchar(250)    
              ,@pa_excm_id         varchar(10)    
              ,@pa_cash_trf        char(2)    
              ,@pa_exe_dt          VARCHAR(11)  
              ,@pa_tr_cmbpid       VARCHAR(20)  
              ,@pa_tr_dp_id        VARCHAR(20)  
              ,@pa_tr_setm_type    VARCHAR(20)    
              ,@pa_tr_setm_no      VARCHAR(20)    
              ,@pa_tr_acct_no      VARCHAR(20)    
              ,@pa_values          VARCHAR(8000)     
              ,@pa_rmks            VARCHAR(250)      
              ,@pa_trdReasoncd     varchar(30)    

			  			,@pa_Paymode varchar(50)
            ,@pa_Bankacno varchar(100)
            ,@pa_Bankacname varchar(100)
            ,@pa_Bankbrname varchar(100)
            ,@pa_Transfereename varchar(100)
            ,@pa_DOI varchar(11)
            ,@pa_ChqRefno varchar(100)
            
            	    			 ,@PA_UCC VARCHAR(20)
			 ,@PA_EXID VARCHAR(5)
			 ,@PA_SEGID VARCHAR(5)
			 ,@PA_CMID VARCHAR(20)
			 ,@PA_EID CHAR(2)
			 ,@PA_TMCMID VARCHAR(20)

              ,@pa_chk_yn          INT      
              ,@rowdelimiter       CHAR(4)       = '*|~*'      
              ,@coldelimiter       CHAR(4)       = '|*~|'      
              ,@pa_errmsg          VARCHAR(8000) output      
 )      
AS    
/*    
*********************************************************************************    
 SYSTEM         : dp    
 MODULE NAME    : pr_ins_upd_trx_cdsl    
 DESCRIPTION    : this procedure will contain the maker checker facility for transaction details    
 COPYRIGHT(C)   : marketplace technologies     
 VERSION HISTORY: 1.0    
 VERS.  AUTHOR            DATE          REASON    
 -----  -------------     ------------  --------------------------------------------------    
 1.0    TUSHAR            25-DEC-2007   VERSION.    
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
      , @l_dptd_id      NUMERIC    
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
      , @line_no        varchar (250)    
      , @l_tr_dpid      VARCHAR(25)     
      , @l_tr_sett_type VARCHAR(50)    
      , @l_tr_setm_no   VARCHAR(50)    
      , @l_isin         VARCHAR(25)     
      , @l_qty          VARCHAR(25)     
      , @l_trastm_id    VARCHAR(25)    
      , @l_action       VARCHAR(25)    
      , @l_dtls_id      NUMERIC    
      , @l_id           VARCHAR(20)    
      , @l_dtlsm_id      NUMERIC    
      ,@@c_access_cursor cursor    
      ,@c_deleted_ind    numeric(10,0)  
      ,@c_dptd_id        varchar(20)    
      ,@l_trastm_desc    varchar(20)    
      ,@pa_converted_qty  numeric    
      ,@pa_trans_no      varchar(20)    
      , @l_max_high_val   numeric(18,5)  
      ,@l_high_val_yn     char(1)    
      ,@l_val_yn     char(1)   
, @l_mkt_type_n varchar(25)  
, @l_setm_no_n varchar(25)  
,@l_id1 numeric  
,@l_cnt numeric  
  
set @l_id1 ='0'  
set @l_cnt=citrus_usr.ufn_countstring(@pa_values,'A|*~|')  
  print 'fff'
print @l_cnt
  
select @l_val_yn  = 'N'--citrus_usr.fn_get_high_val('',0,'DORMANT',@pa_dpam_acct_no,convert(datetime,@pa_req_dt,103))  
declare @l_val_yn_byslip char(1)  
set @l_val_yn_byslip =''  
select @l_val_yn_byslip = 'N'--citrus_usr.fn_get_high_val_byslip(@pa_values)       

if exists (select dpoc_boid from dpclass_onl_clients where ClientCategory='BIL'  and  dpoc_boid = @pa_dpam_acct_no)
select @l_val_yn  ='Y'
  
          print 'ghh'
  
if @PA_ACTION <> 'app'  AND @PA_ACTION <> 'rej'           
begin    
--    
  create table #EDIS_PRE_DPTDC_MAK    
  (DPTDC_ID                              numeric(10,0)    
  ,DPTDC_DPAM_ID                         numeric(10,0)    
  ,DPTDC_REQUEST_DT                      datetime    
  ,DPTDC_SLIP_NO                         varchar(20)     
  ,DPTDC_ISIN                            varchar(20)     
  ,DPTDC_BATCH_NO                        varchar(20)    
  ,DPTDC_LINE_NO                         varchar(250) --numeric(10,0)    
  ,DPTDC_QTY                             numeric(10,0)    
  ,DPTDC_INTERNAL_REF_NO                 varchar(20)    
  ,DPTDC_TRANS_NO                        varchar(20)    
  ,DPTDC_MKT_TYPE                        varchar(20)    
  ,DPTDC_SETTLEMENT_NO                   varchar(20)      
  ,DPTDC_EXECUTION_DT                    datetime    
  ,DPTDC_OTHER_SETTLEMENT_TYPE           varchar(20)    
  ,DPTDC_OTHER_SETTLEMENT_NO             varchar(20)    
  ,DPTDC_COUNTER_DP_ID                   varchar(20)    
  ,DPTDC_COUNTER_CMBP_ID                 varchar(20)    
  ,DPTDC_COUNTER_DEMAT_ACCT_NO           varchar(20)    
  ,dptdC_trastm_cd                       varchar(20)    
  ,DPTDC_DTLS_ID                         numeric(10,0)    
  ,DPTDC_BOOKING_NARRATION               numeric(10,0)    
  ,DPTDC_BOOKING_TYPE                    numeric(10,0)    
  ,DPTDC_CONVERTED_QTY                   numeric(10,0)    
  ,DPTDC_REASON_CD                       numeric(10,0)    
  ,DPTDC_STATUS                          char(1)    
  ,DPTDC_INTERNAL_TRASTM                 varchar(20)     
  ,DPTDC_EXCM_ID                         NUMERIC(10,0)    
  ,DPTDC_CASH_TRF                        CHAR(1)    
  ,DPTDC_CM_ID                           varchar(250)    
  ,DPTDC_CREATED_BY                      varchar(20)    
  ,DPTDC_CREATED_DT                      DATETIME    
  ,DPTDC_LST_UPD_BY                      varchar(20)    
  ,DPTDC_LST_UPD_DT                      datetime     
  ,DPTDC_DELETED_IND                     smallint     
  			    ,DPTDC_PAYMODE varchar(100)
				,DPTDC_BANKACNO varchar(100)
				,DPTDC_BANKACNAME varchar(100)
				,DPTDC_BANKBRNAME varchar(100)
				,DPTDC_TRANSFEREENAME varchar(100)
				,DPTDC_DOI datetime
				,DPTDC_CHQ_REFNO varchar(100)
				
												,DPTDC_UCC VARCHAR(20)
				,DPTDC_EXID VARCHAR(5)
				,DPTDC_SEGID VARCHAR(5)
				,DPTDC_CMID VARCHAR(20)
				,DPTDC_EID  CHAR(2)
				,DPTDC_TMCMID VARCHAR(20)
  )    
  insert into #EDIS_PRE_DPTDC_MAK    
  (DPTDc_ID    
  ,DPTDC_DPAM_ID    
  ,DPTDC_REQUEST_DT    
  ,DPTDC_SLIP_NO    
  ,DPTDC_ISIN    
  ,DPTDC_BATCH_NO    
  ,DPTDC_LINE_NO    
  ,DPTDC_QTY    
  ,DPTDC_INTERNAL_REF_NO    
  ,DPTDC_TRANS_NO    
  ,DPTDC_MKT_TYPE    
  ,DPTDC_SETTLEMENT_NO    
  ,DPTDC_EXECUTION_DT    
  ,DPTDC_OTHER_SETTLEMENT_TYPE    
  ,DPTDC_OTHER_SETTLEMENT_NO    
  ,DPTDC_COUNTER_DP_ID    
  ,DPTDC_COUNTER_CMBP_ID    
  ,DPTDC_COUNTER_DEMAT_ACCT_NO    
  ,dptdC_trastm_cd    
  ,DPTDC_DTLS_ID    
  ,DPTDC_BOOKING_NARRATION    
  ,DPTDC_BOOKING_TYPE    
  ,DPTDC_CONVERTED_QTY    
  ,DPTDC_REASON_CD    
  ,DPTDC_STATUS    
  ,DPTDC_INTERNAL_TRASTM    
  ,DPTDC_EXCM_ID    
  ,DPTDC_CASH_TRF    
  ,DPTDC_CM_ID    
  ,DPTDC_CREATED_BY    
  ,DPTDC_CREATED_DT    
  ,DPTDC_LST_UPD_BY    
  ,DPTDC_LST_UPD_DT    
  ,DPTDC_DELETED_IND   
   ,DPTDC_PAYMODE
					,DPTDC_BANKACNO
					,DPTDC_BANKACNAME
					,DPTDC_BANKBRNAME
					,DPTDC_TRANSFEREENAME
					,DPTDC_DOI
					,DPTDC_CHQ_REFNO  
					
					,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
  )    
  select DPTDc_ID    
  ,DPTDC_DPAM_ID    
  ,DPTDC_REQUEST_DT    
  ,DPTDC_SLIP_NO    
  ,DPTDC_ISIN    
  ,DPTDC_BATCH_NO    
  ,DPTDC_LINE_NO    
  ,DPTDC_QTY    
  ,DPTDC_INTERNAL_REF_NO    
  ,DPTDC_TRANS_NO    
  ,DPTDC_MKT_TYPE    
  ,DPTDC_SETTLEMENT_NO    
  ,DPTDC_EXECUTION_DT    
  ,DPTDC_OTHER_SETTLEMENT_TYPE    
  ,DPTDC_OTHER_SETTLEMENT_NO    
  ,DPTDC_COUNTER_DP_ID    
  ,DPTDC_COUNTER_CMBP_ID    
  ,DPTDC_COUNTER_DEMAT_ACCT_NO    
  ,dptdC_trastm_cd    
  ,DPTDC_DTLS_ID    
  ,DPTDC_BOOKING_NARRATION    
  ,DPTDC_BOOKING_TYPE    
  ,DPTDC_CONVERTED_QTY    
  ,DPTDC_REASON_CD    
  ,DPTDC_STATUS    
  ,DPTDC_INTERNAL_TRASTM    
  ,DPTDC_EXCM_ID    
  ,DPTDC_CASH_TRF    
  ,DPTDC_CM_ID    
  ,DPTDC_CREATED_BY    
  ,DPTDC_CREATED_DT    
  ,DPTDC_LST_UPD_BY    
  ,DPTDC_LST_UPD_DT    
  ,DPTDC_DELETED_IND    

   ,DPTDC_PAYMODE
					,DPTDC_BANKACNO
					,DPTDC_BANKACNAME
					,DPTDC_BANKBRNAME
					,DPTDC_TRANSFEREENAME
					,DPTDC_DOI
					,DPTDC_CHQ_REFNO 
					
					,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
  FROM EDIS_PRE_DPTDC_MAK     
  where dptdc_dtls_id = @pa_id    
  
  
--    
end    
    
  print 'ss'  
print @pa_action  
IF @pa_action = 'INS'   or @pa_action = 'EDT'   
BEGIN    
--    
      
  /*SELECT @l_dtls_id   = ISNULL(MAX(dptdc_dtls_id),0) + 1 FROM dp_trx_dtls_cdsl      
                       
  SELECT @l_dtlsm_id   = ISNULL(MAX(dptdc_dtls_id),0) + 1 FROM EDIS_PRE_DPTDC_MAK    
        
  IF @l_dtlsm_id  > @l_dtls_id       
  BEGIN    
  --    
 set @l_dtls_id = @l_dtlsm_id       
  --    
  END    
        
  IF @pa_chk_yn = 0    
  BEGIN    
  --    
 SELECT @l_dtls_id = ISNULL(MAX(dptdc_dtls_id),0) + 1 from  dp_trx_dtls_cdsl     
  --    
  END  */  
  
 declare @l_count_row   bigint  
        set @l_count_row    = citrus_usr.ufn_countstring(@pa_values,'*|~*')  
  
  begin transaction  
    
 update bitmap_ref_mstr with(tablock)  
 set    bitrm_deleted_ind = 1   
 where  bitrm_id = 1   
 and    bitrm_deleted_ind = 1   
  
IF  @pa_action = 'INS'   
BEGIN  
 select @l_dtls_id = BITRM_BIT_LOCATION   
 from  bitmap_ref_mstr   
 where BITRM_PARENT_CD = 'DPTDc_DTLS_ID'  
  
 update bitmap_ref_mstr with(tablock)  
 set    BITRM_BIT_LOCATION  = BITRM_BIT_LOCATION  + 1   
 where BITRM_PARENT_CD = 'DPTDc_DTLS_ID'  
END  
  
 select @l_dptd_id = BITRM_BIT_LOCATION   
 from  bitmap_ref_mstr   
 where BITRM_PARENT_CD = 'DPTDc_ID'  
  
 update bitmap_ref_mstr with(tablock)  
 set    BITRM_BIT_LOCATION  = BITRM_BIT_LOCATION  + @l_count_row   
 where BITRM_PARENT_CD = 'DPTDc_ID'  
  
  set @l_count_row  =0   
    
    commit transaction  
--    
END    
IF @pa_action = 'EDT'     
BEGIN    
--    
  IF @pa_chk_yn = 0    
  BEGIN    
  --    
    SELECT @l_dtls_id = dptdc_dtls_id FROM  dp_trx_dtls_cdsl WHERE dptdc_dtls_id = convert(numeric,@pa_id) AND dptdc_trastm_cd = @pa_tab    
  --    
  END    
  ELSE    
  BEGIN    
  --    
    SELECT @l_dtls_id = dptdc_dtls_id FROM  EDIS_PRE_DPTDC_MAK WHERE dptdc_dtls_id = convert(numeric,@pa_id) AND dptdc_trastm_cd = @pa_tab    
  --    
  END    
--     
END   
   
/*    
BOBO for BO     
CMCM    
CMBO    
BOCM    
ID for interdepository    
EP for early pay in    
NP for Normal Pay in    
*/   
   
SET @l_mkt_type_n =''  
SET @l_setm_no_n=''  
set @pa_converted_qty = '0'   
  
set @pa_cash_trf      = case when @pa_cash_trf = 'NA' then 'X'  else 'X' end   --@pa_cash_trf
  
IF @pa_tab = 'BOBO'    
BEGIN    
--    
  SET @l_mkt_type_n = @pa_tr_setm_type  
  SET @l_setm_no_n = @pa_tr_setm_no  
  set @pa_tr_setm_type  = @pa_mkt_type    
  set @pa_mkt_type      = @l_mkt_type_n    
  set @pa_tr_setm_no    = @pa_settlm_no    
  set @pa_settlm_no     = @l_setm_no_n    
  set @l_trastm_desc    = @pa_tab    
  set @l_trastm_id      = @pa_tab    
  
--    
END    
ELSE IF @pa_tab = 'CMCM'    
BEGIN    
--    
  SET @l_mkt_type_n = @pa_tr_setm_type  
  SET @l_setm_no_n = @pa_tr_setm_no  
  set @pa_tr_setm_type  = @pa_mkt_type    
  set @pa_mkt_type      = @l_mkt_type_n    
  set @pa_tr_setm_no    = @pa_settlm_no    
  set @pa_settlm_no     = @l_setm_no_n    
  set @l_trastm_desc    = @pa_tab    
  set @l_trastm_id      = @pa_tab     
--    
END    
ELSE IF @pa_tab = 'CMBO'    
BEGIN    
--    
  set @l_trastm_desc = @pa_tab    
  set @l_trastm_id   = @pa_tab    
--    
END    
ELSE IF @pa_tab = 'BOCM'    
BEGIN    
--    
  SET @l_mkt_type_n = @pa_tr_setm_type  
  SET @l_setm_no_n = @pa_tr_setm_no  
  set @pa_tr_setm_type  = @pa_mkt_type    
  set @pa_mkt_type      = @l_mkt_type_n    
  set @pa_tr_setm_no    = @pa_settlm_no    
  set @pa_settlm_no     = @l_setm_no_n    
  set @l_trastm_desc    = @pa_tab    
  set @l_trastm_id      = @pa_tab    
--    
END    
ELSE IF @pa_tab = 'ID'    
BEGIN    
--     
--  SET @l_mkt_type_n = @pa_tr_setm_type  
--  SET @l_setm_no_n = @pa_tr_setm_no  
--  set @pa_tr_setm_type  = @pa_mkt_type    
--  set @pa_mkt_type      = @l_mkt_type_n    
--  set @pa_tr_setm_no    = @pa_settlm_no    
--  set @pa_settlm_no     = @l_setm_no_n    
  set @l_trastm_desc    = @pa_tab    
  set @l_trastm_id      = @pa_tab    
--    
END    
ELSE IF @pa_tab = 'EP'    
BEGIN    
--    
  SET @l_mkt_type_n = @pa_tr_setm_type  
  SET @l_setm_no_n = @pa_tr_setm_no  
  set @pa_tr_setm_type  = @l_mkt_type_n  
  set @pa_mkt_type      = @pa_mkt_type      
  set @pa_tr_setm_no    = @pa_settlm_no    
  set @pa_settlm_no     = @l_setm_no_n    
  set @l_trastm_desc    = @pa_tab    
  set @l_trastm_id      = @pa_tab    
--    
END    
ELSE IF @pa_tab = 'NP'    
BEGIN    
--    
  SET @l_mkt_type_n = @pa_tr_setm_type  
  SET @l_setm_no_n = @pa_tr_setm_no  
  set @pa_tr_setm_type  = @l_mkt_type_n    
  set @pa_mkt_type      = @pa_mkt_type    
  set @pa_tr_setm_no    = @pa_settlm_no    
  set @pa_settlm_no     = @l_setm_no_n    
  set @l_trastm_desc    = @pa_tab    
  set @l_trastm_id      = @pa_tab    
--    
END    
    
DECLARE @l_str1 VARCHAR(8000)    
,@l_str2 VARCHAR(500)    
,@l_counter INT    
,@l_max_counter INT    
CREATE TABLE #temp_id (id INT)    
    
--changed for maker master edit    
if @pa_action = 'EDT' and @pa_values <> '0' and @pa_chk_yn = 1 and exists(select dptdc_id from dp_trx_dtls_cdsl where dptdc_dtls_id = @pa_id and dptdc_deleted_ind = 1)    
begin     
--    
print 'ddddd'  
  SET @l_counter = 1    
  SET @l_str1 = @pa_values    
  SET @l_max_counter = citrus_usr.ufn_countstring(@l_str1,'*|~*')    
  WHILE @l_counter  <= @l_max_counter    
  BEGIN    
  --     
    SELECT @l_str2 = citrus_usr.FN_SPLITVAL_ROW(@l_str1,@l_counter)    
    INSERT INTO #temp_id VALUES(case when citrus_usr.FN_SPLITVAL(@l_str2,1) = 'D' then   citrus_usr.FN_SPLITVAL(@l_str2,2) else citrus_usr.FN_SPLITVAL(@l_str2,4) end)    
       
    SET @l_counter   = @l_counter   + 1    
  --      
  END    
    print 'shilpa'  
  INSERT INTO EDIS_PRE_DPTDC_MAK    
  (DPTDc_ID    
  ,DPTDC_DTLS_ID    
  ,DPTDC_INTERNAL_REF_NO    
  ,DPTDC_DPAM_ID    
  ,DPTDC_REQUEST_DT    
  ,DPTDC_EXECUTION_DT    
  ,DPTDC_SLIP_NO    
  ,DPTDC_ISIN    
  ,DPTDC_LINE_NO    
  ,DPTDC_QTY    
  ,DPTDC_TRANS_NO    
  ,DPTDC_TRASTM_CD    
  ,DPTDC_MKT_TYPE    
  ,DPTDC_SETTLEMENT_NO    
  ,DPTDC_OTHER_SETTLEMENT_TYPE    
  ,DPTDC_OTHER_SETTLEMENT_NO    
  ,DPTDC_COUNTER_DP_ID    
  ,DPTDC_COUNTER_CMBP_ID    
  ,DPTDC_COUNTER_DEMAT_ACCT_NO    
  ,DPTDC_CONVERTED_QTY    
  ,DPTDC_STATUS    
  ,DPTDC_INTERNAL_TRASTM    
  ,DPTDC_EXCM_ID    
  ,DPTDC_CASH_TRF    
  ,DPTDC_CM_ID    
  ,DPTDC_RMKS    
  ,DPTDC_CREATED_BY    
  ,DPTDC_CREATED_DT    
  ,DPTDC_LST_UPD_BY    
  ,DPTDC_LST_UPD_DT    
  ,DPTDC_DELETED_IND    
  ,dptdc_reason_cd    

   ,DPTDC_PAYMODE
					,DPTDC_BANKACNO
					,DPTDC_BANKACNAME
					,DPTDC_BANKBRNAME
					,DPTDC_TRANSFEREENAME
					,DPTDC_DOI
					,DPTDC_CHQ_REFNO 
					
					,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
  )       
  select dptdc_id        
  ,dptdc_dtls_id        
  ,dptdc_id    
  ,dptdc_dpam_id        
  ,convert(datetime,@pa_req_dt,103)        
  ,convert(datetime,@pa_exe_dt,103)        
  ,@pa_slip_no        
  ,dptdc_isin        
  ,dptdc_line_no        
  ,dptdc_qty        
  ,@pa_trans_no    
  ,dptdc_trastm_cd        
  ,@pa_mkt_type        
  ,@pa_settlm_no        
  ,@pa_tr_setm_type        
  ,@pa_tr_setm_no    
  ,@pa_tr_dp_id            
  ,@pa_tr_cmbpid      
  ,@pa_tr_acct_no          
  ,@pa_converted_qty    
  ,'P'    
  ,DPTDC_INTERNAL_TRASTM    
  ,@pa_excm_id    
  ,@pa_cash_trf    
  ,@pa_cm_id    
  ,@pa_rmks    
  ,@pa_login_name    
  ,getdate()    
  ,@pa_login_name    
  ,getdate()    
  ,6    
  ,@pa_trdReasoncd    

	,@pa_Paymode 
	,@pa_Bankacno 
	,@pa_Bankacname 
	,@pa_Bankbrname 
	,@pa_Transfereename 
	,convert(datetime,@pa_DOI,103)  --,@pa_DOI 
	,@pa_ChqRefno
	
	 ,@PA_UCC 
			 ,@PA_EXID 
			 ,@PA_SEGID 
			 ,@PA_CMID 
			 ,@PA_EID 
			 ,@PA_TMCMID 

  FROM  dp_trx_dtls_cdsl        
  WHERE dptdc_id       not in (select id from #temp_id)    
  and   dptdc_dtls_id  = convert(numeric,@pa_id)    
  AND   dptdc_deleted_ind   =  1     
      
      
--    
end    
else IF @pa_action = 'EDT' and @pa_values <> '0' and @pa_chk_yn = 1 and NOT exists(select dptdc_id from dp_trx_dtls_cdsl where dptdc_dtls_id = @pa_id and dptdc_deleted_ind = 1)    
begin    
--    
     
  SET @l_counter = 1    
  SET @l_str1 = @pa_values    
  SET @l_max_counter = citrus_usr.ufn_countstring(@l_str1,'*|~*')    
  WHILE @l_counter  <= @l_max_counter    
  BEGIN    
  --     
    SELECT @l_str2 = citrus_usr.FN_SPLITVAL_ROW(@l_str1,@l_counter)  
  
    INSERT INTO #temp_id VALUES(case when citrus_usr.FN_SPLITVAL(@l_str2,1) = 'D' then   citrus_usr.FN_SPLITVAL(@l_str2,2) else citrus_usr.FN_SPLITVAL(@l_str2,4) end)    
  
    SET @l_counter   = @l_counter   + 1    
  --      
  END    
     print 'mayur'  
  delete from    EDIS_PRE_DPTDC_MAK        
  WHERE dptdc_id       not in (select id from #temp_id)     
  and   dptdc_dtls_id  = @pa_id    
  AND   dptdc_deleted_ind   in (0,4,6,-1)    
       
print 'mayur'  
print @pa_trans_no  
  
  INSERT INTO EDIS_PRE_DPTDC_MAK        
  (DPTDc_ID    
    ,DPTDC_DTLS_ID    
    ,DPTDC_INTERNAL_REF_NO    
    ,DPTDC_DPAM_ID    
    ,DPTDC_REQUEST_DT    
    ,DPTDC_EXECUTION_DT    
    ,DPTDC_SLIP_NO    
    ,DPTDC_ISIN    
    ,DPTDC_LINE_NO    
    ,DPTDC_QTY    
    ,DPTDC_TRANS_NO    
    ,DPTDC_TRASTM_CD    
    ,DPTDC_MKT_TYPE    
    ,DPTDC_SETTLEMENT_NO    
    ,DPTDC_OTHER_SETTLEMENT_TYPE    
    ,DPTDC_OTHER_SETTLEMENT_NO    
    ,DPTDC_COUNTER_DP_ID    
    ,DPTDC_COUNTER_CMBP_ID    
    ,DPTDC_COUNTER_DEMAT_ACCT_NO    
    ,DPTDC_CONVERTED_QTY    
    ,DPTDC_STATUS    
    ,DPTDC_INTERNAL_TRASTM    
    ,DPTDC_EXCM_ID    
    ,DPTDC_CASH_TRF    
    ,DPTDC_CM_ID    
    ,DPTDC_RMKS    
    ,DPTDC_CREATED_BY    
    ,DPTDC_CREATED_DT    
    ,DPTDC_LST_UPD_BY    
    ,DPTDC_LST_UPD_DT    
    ,DPTDC_DELETED_IND    
          ,DPTDC_REASON_CD    
	  	,DPTDC_PAYMODE
	,DPTDC_BANKACNO
	,DPTDC_BANKACNAME
	,DPTDC_BANKBRNAME
	,DPTDC_TRANSFEREENAME
	,DPTDC_DOI
	,DPTDC_CHQ_REFNO  
	
	,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
    )       
    select dptdc_id        
    ,dptdc_dtls_id        
    ,dptdc_id    
    ,dptdc_dpam_id        
    ,convert(datetime,@pa_req_dt,103)        
    ,convert(datetime,@pa_exe_dt,103)        
    ,@pa_slip_no        
    ,dptdc_isin        
    ,dptdc_line_no        
    ,dptdc_qty        
    ,@pa_trans_no    
    ,dptdc_trastm_cd        
    ,@pa_mkt_type        
    ,@pa_settlm_no        
    ,@pa_tr_setm_type        
    ,@pa_tr_setm_no    
    ,@pa_tr_dp_id            
    ,@pa_tr_cmbpid      
    ,@pa_tr_acct_no          
    ,@pa_converted_qty    
    ,'P'    
    ,DPTDC_INTERNAL_TRASTM    
    ,@pa_excm_id    
    ,@pa_cash_trf    
    ,@pa_cm_id    
    ,@pa_rmks    
    ,@pa_login_name    
    ,getdate()    
    ,@pa_login_name    
    ,getdate()    
  ,dptdc_deleted_ind    
,@pa_trdReasoncd    

,@pa_Paymode 
,@pa_Bankacno 
,@pa_Bankacname 
,@pa_Bankbrname 
,@pa_Transfereename 
,convert(datetime,@pa_DOI,103) 
,@pa_ChqRefno 

	,@PA_UCC 
			 ,@PA_EXID 
			 ,@PA_SEGID 
			 ,@PA_CMID 
			 ,@PA_EID 
			 ,@PA_TMCMID 
  FROM  #EDIS_PRE_DPTDC_MAK        
  WHERE dptdc_id       not in (select id from #temp_id)    
  and   dptdc_dtls_id  = convert(numeric,@pa_id)    
  AND   dptdc_deleted_ind   in (0,4,6,-1)    
--    
end    
    
    
--changed for maker master edit    
    
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
       
                  
    SET @l_action             = citrus_usr.fn_splitval(@currstring_value,1)          
                  
    IF @l_action = 'A' OR @l_action ='E'    
    BEGIN    
    --    
      SET @l_isin               = citrus_usr.fn_splitval(@currstring_value,2)                            
      SET @l_qty                = convert(numeric(18,3),citrus_usr.fn_splitval(@currstring_value,3))     
      SET @l_id   = citrus_usr.fn_splitval(@currstring_value,4)     
      SET @l_qty               = CONVERT(VARCHAR(25),CONVERT(NUMERIC(18,3),CONVERT(NUMERIC(18,3),-1)*@l_qty ))  
      set @l_high_val_yn        = case when @l_val_yn = 'Y' or @l_val_yn_byslip ='Y' then 'Y' else 'N' end  
  
    --    
    END    
    ELSE    
    BEGIN    
    --    
      SET @l_id                = citrus_usr.fn_splitval(@currstring_value,2)     
    --    
    END    
  
  
if @l_cnt >= @l_id1 and @l_action = 'A'  
begin  
set  @l_id1 = @l_id1 + 1     
end   
  
  
          IF @pa_chk_yn = 0    
          BEGIN    
          --    
print 'jitesh'  
            SELECT @l_dpam_id     = dpam_id FROM dp_acct_mstr, dp_mstr WHERE dpm_deleted_ind = 1   and dpm_id = dpam_dpm_id and dpm_dpid = @pa_dpm_dpid and dpam_sba_no = @pa_dpam_acct_no    
    
            IF @PA_ACTION = 'INS' OR @l_action = 'A'    
            BEGIN    
            --   
print @l_dtls_id  
              BEGIN TRANSACTION    
    
              --SELECT @l_dptd_id   = ISNULL(MAX(dptdc_id),0) + 1 FROM dp_trx_dtls_cdsl      
              SET @l_dptd_id = @l_dptd_id + 1    
              INSERT INTO DP_TRX_DTLS_CDSL    
              (DPTDc_ID    
              ,DPTDC_DTLS_ID    
              ,DPTDC_INTERNAL_REF_NO    
              ,DPTDC_DPAM_ID    
              ,DPTDC_REQUEST_DT    
              ,DPTDC_EXECUTION_DT    
              ,DPTDC_SLIP_NO    
              ,DPTDC_ISIN    
              ,DPTDC_LINE_NO    
              ,DPTDC_QTY    
              ,DPTDC_TRANS_NO    
              ,DPTDC_TRASTM_CD    
              ,DPTDC_MKT_TYPE    
              ,DPTDC_SETTLEMENT_NO    
              ,DPTDC_OTHER_SETTLEMENT_TYPE    
              ,DPTDC_OTHER_SETTLEMENT_NO    
              ,DPTDC_COUNTER_DP_ID    
              ,DPTDC_COUNTER_CMBP_ID    
              ,DPTDC_COUNTER_DEMAT_ACCT_NO    
              ,DPTDC_CONVERTED_QTY    
              ,DPTDC_STATUS    
              ,DPTDC_INTERNAL_TRASTM    
              ,DPTDC_EXCM_ID    
              ,DPTDC_CASH_TRF    
              ,DPTDC_CM_ID    
              ,DPTDC_RMKS    
              ,DPTDC_CREATED_BY    
              ,DPTDC_CREATED_DT    
              ,DPTDC_LST_UPD_BY    
              ,DPTDC_LST_UPD_DT    
              ,DPTDC_DELETED_IND    
              ,DPTDC_REASON_CD    

			  ,DPTDC_PAYMODE
				,DPTDC_BANKACNO
				,DPTDC_BANKACNAME
				,DPTDC_BANKBRNAME
				,DPTDC_TRANSFEREENAME
				,DPTDC_DOI
				,DPTDC_CHQ_REFNO 
				
								,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
    
              )VALUES     
              (@l_dptd_id     
              ,@l_dtls_id    
              ,@l_dptd_id    
              ,@l_dpam_id    
              ,convert(datetime,@pa_req_dt,103)    
              ,convert(datetime,@pa_exe_dt,103)    
              ,@pa_slip_no    
              ,@l_isin    
              , case when @pa_tab in ('BOBO','ID') and  @pa_trdReasoncd in ('2','6') then @pa_cm_id  else convert(varchar,@line_no) end --@line_no    
              ,@l_qty    
              ,@pa_trans_no    
              ,@l_trastm_id    
              ,@pa_mkt_type    
              ,@pa_settlm_no    
              ,@pa_tr_setm_type    
              ,@pa_tr_setm_no          
              ,@pa_tr_dp_id            
              ,@pa_tr_cmbpid           
              ,@pa_tr_acct_no          
              ,@pa_converted_qty    
              ,'P'    
              ,@l_trastm_desc    
              ,@pa_excm_id    
              ,@pa_cash_trf    
               ,case when @pa_tab in ('BOBO','ID') and  @pa_trdReasoncd in ('2','6')   then '' else @pa_cm_id     end --, ,@pa_cm_id    
              ,@pa_rmks    
              ,@pa_login_name    
              ,getdate()    
              ,@pa_login_name    
              ,getdate()    
              ,1    
              ,@pa_trdReasoncd    
			  			,@pa_Paymode 
			,@pa_Bankacno 
			,@pa_Bankacname 
			,@pa_Bankbrname 
			,@pa_Transfereename 
			,convert(datetime,@pa_DOI,103) 
			,@pa_ChqRefno
			
				,@PA_UCC 
			 ,@PA_EXID 
			 ,@PA_SEGID 
			 ,@PA_CMID 
			 ,@PA_EID 
			 ,@PA_TMCMID 
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
                  
              IF @pa_action = 'EDT'     
              BEGIN    
              --    
print 'jitesh1'  
                UPDATE  dp_trx_dtls_cdsl     
                SET     dptdc_dpam_id            = @l_dpam_id    
                       ,dptdc_request_dt         = convert(datetime,@pa_req_dt ,103)    
                       ,dptdc_execution_dt       = convert(datetime,@pa_exe_dt ,103)    
                       ,dptdc_slip_no            = @pa_slip_no    
                       ,dptdc_trans_no           = @pa_trans_no    
                       ,dptdc_mkt_type           = @pa_mkt_type    
                       ,dptdc_settlement_no      = @pa_settlm_no    
                       ,dptdc_other_settlement_type = @pa_tr_setm_type    
                       ,dptdc_other_settlement_no   = @pa_tr_setm_no      
                       ,dptdc_counter_dp_id         = @pa_tr_dp_id    
                       ,dptdc_counter_cmbp_id       = @pa_tr_cmbpid    
                       ,dptdc_counter_demat_acct_no = @pa_tr_acct_no    
                       ,dptdc_converted_qty         = @pa_converted_qty      
                       ,dptdc_excm_id               = case when @pa_excm_id ='' then '0' else @pa_excm_id end --@pa_excm_id     
                       ,dptdc_cash_trf              = @pa_cash_trf    
                       ,dptdc_cm_id                 = @pa_cm_id    
                       ,dptdc_rmks                 = @pa_rmks    
                       ,dptdc_lst_upd_dt           = getdate()    
                       ,dptdc_lst_upd_by           = @pa_login_name    
      ,dptdc_reason_cd            = @pa_trdReasoncd    
       ,dptdc_line_no=case when @pa_tab in ('BOBO','ID') and @pa_trdReasoncd in ('2','3') then @pa_cm_id  else convert(varchar,@line_no)   end

	     ,DPTDC_PAYMODE=@pa_Paymode
		,DPTDC_BANKACNO=@pa_Bankacno
		,DPTDC_BANKACNAME=@pa_Bankacname
		,DPTDC_BANKBRNAME=@pa_Bankbrname
		,DPTDC_TRANSFEREENAME=@pa_Transfereename
		,DPTDC_DOI=convert(datetime,@pa_DOI,103)
		,DPTDC_CHQ_REFNO=  @pa_ChqRefno
		
		,DPTDC_UCC=@PA_UCC
,DPTDC_EXID=@PA_EXID
,DPTDC_SEGID=@PA_SEGID
,DPTDC_CMID=@PA_CMID
,DPTDC_EID=@PA_EID
,DPTDC_TMCMID=@PA_TMCMID
                WHERE   dptdc_dtls_id              = convert(INT,@currstring)    
                AND     dptdc_deleted_ind          = 1    
              --    
              END    
              IF @l_action = 'E'    
              BEGIN    
              --    
print 'jitesh2'  
PRINT @l_qty  
                UPDATE  dp_trx_dtls_cdsl    
                SET     dptdc_dpam_id            = @l_dpam_id    
                       ,dptdc_request_dt         = convert(datetime,@pa_req_dt ,103)    
                       ,dptdc_execution_dt       = convert(datetime,@pa_exe_dt ,103)    
                       ,dptdc_slip_no            = @pa_slip_no    
                       ,dptdc_trans_no           = @pa_trans_no    
                       ,dptdc_mkt_type           = @pa_mkt_type    
                       ,dptdc_settlement_no      = @pa_settlm_no    
                       ,dptdc_other_settlement_type= @pa_tr_setm_type    
                       ,dptdc_other_settlement_no  = @pa_tr_setm_no      
                       ,dptdc_counter_dp_id        = @pa_tr_dp_id    
                       ,dptdc_counter_cmbp_id      = @pa_tr_cmbpid    
                       ,dptdc_counter_demat_acct_no= @pa_tr_acct_no    
                       ,dptdc_converted_qty        = @pa_converted_qty      
                       ,dptdc_excm_id              = case when @pa_excm_id ='' then '0' else @pa_excm_id end --@pa_excm_id     
                       ,dptdc_cash_trf             = @pa_cash_trf    
                       ,dptdc_isin                 = @l_isin    
                       ,dptdc_qty                  = @l_qty    
                       ,dptdc_rmks                 = @pa_rmks    
                       ,dptdc_cm_id                = @pa_cm_id    
                       ,dptdc_lst_upd_dt           = getdate()    
,dptdc_lst_upd_by           = @pa_login_name    
                          ,dptdc_reason_cd            = @pa_trdReasoncd    

						    ,DPTDC_PAYMODE=@pa_Paymode
		,DPTDC_BANKACNO=@pa_Bankacno
		,DPTDC_BANKACNAME=@pa_Bankacname
		,DPTDC_BANKBRNAME=@pa_Bankbrname
		,DPTDC_TRANSFEREENAME=@pa_Transfereename
		,DPTDC_DOI=convert(datetime,@pa_DOI,103)
		,DPTDC_CHQ_REFNO=  @pa_ChqRefno
		
		,DPTDC_UCC=@PA_UCC
,DPTDC_EXID=@PA_EXID
,DPTDC_SEGID=@PA_SEGID
,DPTDC_CMID=@PA_CMID
,DPTDC_EID=@PA_EID
,DPTDC_TMCMID=@PA_TMCMID
                           ,dptdc_line_no=case when @pa_tab in ('BOBO','ID') and @pa_trdReasoncd in ('2','3') then @pa_cm_id  else convert(varchar,@line_no)   end
                WHERE   dptdc_id                   = @l_id    
                AND     dptdc_deleted_ind          = 1    
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
                
                delete used from dp_trx_dtls_cdsl,dp_acct_mstr,used_slip used 
                where dpam_id = dptdc_dpam_id and uses_dpam_acct_no = dpam_sba_no and dptdc_dtls_id = convert(INT,@currstring)                      
                and ltrim(rtrim(uses_slip_no)) = ltrim(rtrim(dptdc_slip_no))
                    
                UPDATE dp_trx_dtls_cdsl    
                SET    dptdc_deleted_ind = 0    
                     , dptdc_lst_upd_dt  = getdate()    
                     , dptdc_lst_upd_by  = @pa_login_name    
                WHERE  dptdc_deleted_ind = 1    
                AND    dptdc_dtls_id     = convert(INT,@currstring)    
                    
                                 
              --    
              END    
              IF @l_action = 'D'    
              BEGIN    
              --    
               --delete used from dp_trx_dtls_cdsl,dp_acct_mstr,used_slip used where dpam_id = dptdc_dpam_id and uses_dpam_acct_no = dpam_sba_no and dptdc_id  = @l_id        
                    
                UPDATE dp_trx_dtls_cdsl    
                SET    dptdc_deleted_ind = 0    
                     , dptdc_lst_upd_dt  = getdate()    
                     , dptdc_lst_upd_by  = @pa_login_name    
                WHERE  dptdc_deleted_ind = 1    
                AND    dptdc_id          = @l_id    
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
    
    
              BEGIN TRANSACTION    
                  
          
                  
              /*SELECT @l_dptd_id   = ISNULL(MAX(dptdc_id),0) + 1 FROM dp_trx_dtls_cdsl      
                  
              SELECT @l_dptdm_id   = ISNULL(MAX(dptdc_id),0) + 1 FROM EDIS_PRE_DPTDC_MAK    
                  
              IF @l_dptdm_id   > @l_dptd_id       
              BEGIN    
              --    
                SET @l_dptd_id = @l_dptdm_id       
              --    
              END*/  
              SET @l_dptd_id = @l_dptd_id + 1    
                  
                                
              INSERT INTO EDIS_PRE_DPTDC_MAK    
              (DPTDc_ID    
              ,DPTDC_DTLS_ID    
              ,DPTDC_INTERNAL_REF_NO    
              ,DPTDC_DPAM_ID    
              ,DPTDC_REQUEST_DT    
              ,DPTDC_EXECUTION_DT    
              ,DPTDC_SLIP_NO    
              ,DPTDC_ISIN    
              ,DPTDC_LINE_NO    
              ,DPTDC_QTY    
              ,DPTDC_TRANS_NO    
              ,DPTDC_TRASTM_CD    
              ,DPTDC_MKT_TYPE    
              ,DPTDC_SETTLEMENT_NO    
              ,DPTDC_OTHER_SETTLEMENT_TYPE    
              ,DPTDC_OTHER_SETTLEMENT_NO    
              ,DPTDC_COUNTER_DP_ID    
              ,DPTDC_COUNTER_CMBP_ID    
              ,DPTDC_COUNTER_DEMAT_ACCT_NO    
              ,DPTDC_CONVERTED_QTY    
              ,DPTDC_STATUS    
              ,DPTDC_INTERNAL_TRASTM    
              ,DPTDC_EXCM_ID    
              ,DPTDC_CASH_TRF    
              ,DPTDC_CM_ID    
              ,DPTDC_RMKS    
              ,DPTDC_CREATED_BY    
              ,DPTDC_CREATED_DT    
              ,DPTDC_LST_UPD_BY    
              ,DPTDC_LST_UPD_DT    
              ,DPTDC_DELETED_IND    
              ,dptdc_reason_cd     
			  ,DPTDC_PAYMODE
,DPTDC_BANKACNO
,DPTDC_BANKACNAME
,DPTDC_BANKBRNAME
,DPTDC_TRANSFEREENAME
,DPTDC_DOI
,DPTDC_CHQ_REFNO

,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID            
    
              )VALUES     
              (@l_dptd_id     
              ,@l_dtls_id    
              ,@l_dptd_id     
              ,@l_dpam_id    
              ,convert(datetime,@pa_req_dt,103)    
              ,convert(datetime,@pa_exe_dt,103)    
              ,@pa_slip_no    
              ,@l_isin    
              , case when @pa_tab in ('BOBO','ID') and  @pa_trdReasoncd in ('2','6') then @pa_cm_id  else convert(varchar,@line_no) end --,@line_no    
              ,@l_qty    
              ,@pa_trans_no    
              ,@l_trastm_id    
              ,@pa_mkt_type    
              ,@pa_settlm_no    
              ,@pa_tr_setm_type    
              ,@pa_tr_setm_no          
              ,@pa_tr_dp_id            
              ,@pa_tr_cmbpid           
              ,@pa_tr_acct_no          
              ,@pa_converted_qty    
              ,'P'                ,@l_trastm_desc    
              ,case when @pa_excm_id ='' then '0' else @pa_excm_id end   
              ,@pa_cash_trf    
               ,case when @pa_tab in ('BOBO','ID') and  @pa_trdReasoncd in ('2','6')   then '' else @pa_cm_id     end --, ,@pa_cm_id   
              ,@pa_rmks    
              ,@pa_login_name    
              ,getdate()    
              ,@pa_login_name    
              ,getdate()    
               ,case when @l_high_val_yn = 'Y' then -1 else 0 end      
              ,@pa_trdReasoncd    
			  			,@pa_Paymode 
			,@pa_Bankacno 
			,@pa_Bankacname 
			,@pa_Bankbrname 
			,@pa_Transfereename 
			,convert(datetime,@pa_DOI,103) 
			,@pa_ChqRefno 
			
									,@PA_UCC 
,@PA_EXID 
,@PA_SEGID 
,@PA_CMID 
,@PA_EID 
,@PA_TMCMID 
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
                UPDATE EDIS_PRE_DPTDC_MAK     
                SET    dptdc_deleted_ind = 2    
                     , dptdc_lst_upd_dt  = getdate()    
                     , dptdc_lst_upd_by  = @pa_login_name    
                WHERE  dptdc_dtls_id     = CONVERT(INT,@currstring)    
              --    
              END    
              ELSE    
              BEGIN    
              --    
print @l_id   
print  @L_ACTION  
                IF @l_id <> '' AND  @L_ACTION <> 'D'    
                BEGIN    
                --    
                  UPDATE EDIS_PRE_DPTDC_MAK     
                  SET    dptdc_deleted_ind = 2    
                       , dptdc_lst_upd_dt  = getdate()    
                       , dptdc_lst_upd_by  = @pa_login_name    
                  WHERE  dptdc_id          = @l_id    
                --    
                END    
              --    
              END    
                  
              IF EXISTS(select * from dp_trx_dtls_cdsl where dptdc_dtls_id = CONVERT(INT,@currstring) and dptdc_deleted_ind = 1)    
              BEGIN    
              --    
                SET @l_deleted_ind = 6    
                    
                IF @pa_values = '0'    
                BEGIN    
                --    
                  INSERT INTO EDIS_PRE_DPTDC_MAK    
                  (dptdc_id    
                  ,dptdc_dpam_id    
                  ,dptdc_request_dt    
                  ,DPTDC_INTERNAL_REF_NO    
                  ,dptdc_slip_no    
                  ,dptdc_isin    
                  ,dptdc_batch_no    
                  ,dptdc_line_no    
                  ,dptdc_qty    
                  
                  ,dptdc_trans_no    
                  ,dptdc_mkt_type    
                  ,dptdc_settlement_no    
                  ,dptdc_execution_dt    
                  ,dptdc_other_settlement_type    
                  ,dptdc_other_settlement_no    
                  ,dptdc_counter_dp_id    
                  ,dptdc_counter_cmbp_id    
                  ,dptdc_counter_demat_acct_no    
                  ,dptdc_trastm_cd    
                  ,dptdc_dtls_id    
                  ,dptdc_booking_narration    
                  ,dptdc_booking_type    
                  ,dptdc_converted_qty    
                  ,dptdc_reason_cd    
                  ,dptdc_status    
                  ,dptdc_internal_trastm    
                  ,dptdc_excm_id    
                  ,dptdc_cash_trf    
                  ,dptdc_cm_id    
                  ,dptdc_rmks    
                  ,dptdc_created_by    
                  ,dptdc_created_dt    
                  ,dptdc_lst_upd_by    
                  ,dptdc_lst_upd_dt    
                  ,dptdc_deleted_ind     

				  ,DPTDC_PAYMODE
					,DPTDC_BANKACNO
					,DPTDC_BANKACNAME
					,DPTDC_BANKBRNAME
					,DPTDC_TRANSFEREENAME
					,DPTDC_DOI
					,DPTDC_CHQ_REFNO 
					
										,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
                  )     
                  select  dptdc_id    
                  ,@l_dpam_id    
                  ,convert(datetime,@pa_req_dt,103)    
                  ,dptdc_id    
                  ,@pa_slip_no    
                  ,dptdc_isin    
                  ,dptdc_batch_no    
                  ,dptdc_line_no    
                  ,dptdc_qty    
                   
                  ,@pa_trans_no    
                  ,@pa_mkt_type    
                  ,@pa_settlm_no    
                  ,convert(datetime,@pa_exe_dt,103)    
                  ,@pa_tr_setm_type    
                  ,@pa_tr_setm_no    
                  ,@pa_tr_dp_id    
                  ,@pa_tr_cmbpid    
                  ,@pa_tr_acct_no    
                  ,dptdc_trastm_cd    
                  ,dptdc_dtls_id    
                  ,dptdc_booking_narration    
                  ,dptdc_booking_type    
     ,@pa_converted_qty    
                  ,dptdc_Reason_cd    
                  ,dptdc_status    
                  ,dptdc_internal_trastm    
                  ,case when @pa_excm_id ='' then '0' else @pa_excm_id end --@pa_excm_id    
                  ,@pa_cash_trf    
                  ,@pa_cm_id    
                  ,@pa_rmks    
                  ,dptdc_created_by    
                  ,dptdc_created_dt    
                  ,@pa_login_name    
                  ,getdate()    
                  ,@l_deleted_ind  
				  
				,@pa_Paymode 
				,@pa_Bankacno 
				,@pa_Bankacname 
				,@pa_Bankbrname 
				,@pa_Transfereename 
				,convert(datetime,@pa_DOI,103) 
				,@pa_ChqRefno
				
				
							,@PA_UCC 
,@PA_EXID 
,@PA_SEGID 
,@PA_CMID 
,@PA_EID 
,@PA_TMCMID 
			  
                  FROM  dp_trx_dtls_cdsl    
                  WHERE dptdc_dtls_id       =  CONVERT(INT,@currstring)    
                  AND   dptdc_deleted_ind   =  1     
                      
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  IF @l_action = 'A'    
                  BEGIN    
                  --    
                    --select @l_id = ISNULL(MAX(dptdc_id),0) + 1 FROM EDIS_PRE_DPTDC_MAK    
                    SET @l_id = @l_id1 + @l_dptd_id + 1  
                    set  @l_deleted_ind = 0    
                  --    
                  END    
                  IF @l_action <> 'D'    
                  BEGIN    
                  --    
                    INSERT INTO EDIS_PRE_DPTDC_MAK    
                    (dptdc_id    
                    ,dptdc_dtls_id    
                    ,dptdc_dpam_id    
                    ,dptdc_request_dt    
                    ,DPTDC_INTERNAL_REF_NO    
                    ,dptdc_execution_dt    
                    ,dptdc_slip_no    
                    ,dptdc_isin    
                    ,dptdc_line_no    
                    ,dptdc_qty    
                    ,dptdc_trans_no    
                    ,dptdc_trastm_cd    
                    ,dptdc_mkt_type    
                    ,dptdc_settlement_no    
                    ,dptdc_other_settlement_type    
                    ,dptdc_other_settlement_no    
                    ,dptdc_counter_dp_id    
                    ,dptdc_counter_cmbp_id    
                    ,dptdc_counter_demat_acct_no    
                    ,dptdc_converted_qty    
                    ,dptdc_status    
                    ,dptdc_internal_trastm    
                    ,dptdc_excm_id    
                    ,dptdc_cash_trf    
                    ,dptdc_cm_id    
                    ,dptdc_rmks    
                    ,dptdc_created_by    
                    ,dptdc_created_dt    
                    ,dptdc_lst_upd_by    
                    ,dptdc_lst_upd_dt    
                    ,dptdc_deleted_ind     
					,dptdc_reason_cd    

					,DPTDC_PAYMODE
					,DPTDC_BANKACNO
					,DPTDC_BANKACNAME
					,DPTDC_BANKBRNAME
					,DPTDC_TRANSFEREENAME
					,DPTDC_DOI
					,DPTDC_CHQ_REFNO 
					
															,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
					 
                    )VALUES     
                    (CONVERT(INT,@l_id)    
                    ,CONVERT(INT,@currstring)    
                    ,@l_dpam_id    
                    ,convert(datetime,@pa_req_dt,103)    
                    ,CONVERT(INT,@l_id)    
                    ,convert(datetime,@pa_exe_dt,103)    
                    ,@pa_slip_no    
                    ,@l_isin    
                    , case when @pa_tab in ('BOBO','ID') and  @pa_trdReasoncd in ('2','6') then @pa_cm_id  else convert(varchar,@line_no) end --,@line_no    
                    ,@l_qty    
                    ,@pa_trans_no    
                    ,@l_trastm_id    
                    ,@pa_mkt_type    
                    ,@pa_settlm_no    
                    ,@pa_tr_setm_type    
                    ,@pa_tr_setm_no          
                    ,@pa_tr_dp_id            
                    ,@pa_tr_cmbpid           
                    ,@pa_tr_acct_no          
                    ,@pa_converted_qty    
                    ,'P'    
                    ,@l_trastm_desc    
                    ,@pa_excm_id    
                    ,@pa_cash_trf    
                     ,case when @pa_tab in ('BOBO','ID') and  @pa_trdReasoncd in ('2','6')   then '' else @pa_cm_id     end --, ,@pa_cm_id,@pa_cm_id    
                    ,@pa_rmks    
                    ,@pa_login_name    
                    ,getdate()    
                    ,@pa_login_name    
                    ,getdate()    
                    ,case when @l_high_val_yn = 'Y' then -1 else 0 end  --@l_deleted_ind   --- change to get -1 in case of high value trx after edit mar 02 2012  
      , @pa_trdReasoncd         
	  			,@pa_Paymode 
			,@pa_Bankacno 
			,@pa_Bankacname 
			,@pa_Bankbrname 
			,@pa_Transfereename 
			,convert(datetime,@pa_DOI,103) 
			,@pa_ChqRefno        
			
									,@PA_UCC 
,@PA_EXID 
,@PA_SEGID 
,@PA_CMID 
,@PA_EID 
,@PA_TMCMID 
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
  
                SET @l_deleted_ind = case when @l_high_val_yn = 'Y' then -1 else 0 end    
                    
                IF @pa_values = '0'     
                BEGIN    
                --    
                  INSERT INTO EDIS_PRE_DPTDC_MAK    
                  (dptdc_id    
                  ,dptdc_dpam_id    
                  ,dptdc_request_dt    
               ,DPTDC_INTERNAL_REF_NO    
                  ,dptdc_slip_no    
                  ,dptdc_isin    
                  ,dptdc_batch_no    
                  ,dptdc_line_no    
                  ,dptdc_qty    
                  --,dptdc_internal_ref_no    
                  ,dptdc_trans_no    
                  ,dptdc_mkt_type    
                  ,dptdc_settlement_no    
                  ,dptdc_execution_dt    
                  ,dptdc_other_settlement_type    
                  ,dptdc_other_settlement_no    
                  ,dptdc_counter_dp_id    
                  ,dptdc_counter_cmbp_id    
                  ,dptdc_counter_demat_acct_no    
                  ,dptdc_trastm_cd    
                  ,dptdc_dtls_id    
                  ,dptdc_booking_narration    
                  ,dptdc_booking_type    
                  ,dptdc_converted_qty    
                  ,dptdc_reason_cd    
                  ,dptdc_status    
                  ,dptdc_internal_trastm    
                  ,dptdc_excm_id    
                  ,dptdc_cash_trf    
                  ,dptdc_cm_id    
                  ,dptdc_rmks    
                  ,dptdc_created_by    
                  ,dptdc_created_dt    
                  ,dptdc_lst_upd_by    
                  ,dptdc_lst_upd_dt    
                  ,dptdc_deleted_ind     

				  ,DPTDC_PAYMODE
				,DPTDC_BANKACNO
				,DPTDC_BANKACNAME
				,DPTDC_BANKBRNAME
				,DPTDC_TRANSFEREENAME
				,DPTDC_DOI
				,DPTDC_CHQ_REFNO 
				
								,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
                  )     
                  select  dptdc_id    
                  ,@l_dpam_id    
                  ,convert(datetime,@pa_req_dt,103)    
                  ,dptdc_id    
                  ,@pa_slip_no    
                  ,dptdc_isin    
                  ,dptdc_batch_no    
                  ,dptdc_line_no    
                  ,dptdc_qty    
                  --,dptdc_internal_ref_no    
                  ,@pa_trans_no    
                  ,@pa_mkt_type    
                  ,@pa_settlm_no    
                  ,convert(datetime,@pa_exe_dt,103)    
                  ,@pa_tr_setm_type    
                  ,@pa_tr_setm_no    
                  ,@pa_tr_dp_id    
                  ,@pa_tr_cmbpid    
                  ,@pa_tr_acct_no    
                  ,dptdc_trastm_cd    
                  ,dptdc_dtls_id    
                  ,dptdc_booking_narration    
                  ,dptdc_booking_type    
                  ,@pa_converted_qty    
                  ,@pa_trdReasoncd    
                  ,dptdc_status    
                  ,dptdc_internal_trastm    
                  ,@pa_excm_id    
                  ,@pa_cash_trf    
                  ,@pa_cm_id    
                  ,@pa_rmks    
                  ,dptdc_created_by    
                  ,dptdc_created_dt    
                  ,@pa_login_name    
                  ,getdate()    
                  ,@l_deleted_ind   
				  
				  			,@pa_Paymode 
			,@pa_Bankacno 
			,@pa_Bankacname 
			,@pa_Bankbrname 
			,@pa_Transfereename 
			,convert(datetime,@pa_DOI,103) 
			,@pa_ChqRefno  
			
						
			,@PA_UCC 
,@PA_EXID 
,@PA_SEGID 
,@PA_CMID 
,@PA_EID 
,@PA_TMCMID 
                  FROM  #EDIS_PRE_DPTDC_MAK    
                  WHERE dptdc_dtls_id       =  CONVERT(INT,@currstring)    
                  AND   dptdc_deleted_ind   in (0,-1)  
  
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  IF @l_action = 'A'    
                  BEGIN    
                  --    
                    --select @l_id = ISNULL(MAX(dptdc_id),0) + 1 FROM EDIS_PRE_DPTDC_MAK    
                    SET @l_id = @l_id1 + @l_dptd_id + 1  
                  --    
                  END    
                  IF @l_action <> 'D'    
                  begin    
                  --    
                    
                    INSERT INTO EDIS_PRE_DPTDC_MAK    
                    (dptdc_id    
                    ,dptdc_dtls_id    
                    ,dptdc_dpam_id    
                    ,DPTDC_INTERNAL_REF_NO    
                    ,dptdc_request_dt    
                    ,dptdc_execution_dt    
                    ,dptdc_slip_no    
                    ,dptdc_isin    
                    ,dptdc_line_no    
                    ,dptdc_qty    
                    ,dptdc_trans_no    
                    ,dptdc_trastm_cd    
                    ,dptdc_mkt_type    
                    ,dptdc_settlement_no    
                    ,dptdc_other_settlement_type    
                    ,dptdc_other_settlement_no    
                    ,dptdc_counter_dp_id    
                    ,dptdc_counter_cmbp_id    
                    ,dptdc_counter_demat_acct_no    
                    ,dptdc_converted_qty    
                    ,dptdc_status    
                    ,dptdc_internal_trastm    
                    ,dptdc_excm_id    
                    ,dptdc_cash_trf    
                    ,dptdc_cm_id    
                    ,dptdc_rmks    
                    ,dptdc_created_by    
                    ,dptdc_created_dt    
                    ,dptdc_lst_upd_by    
                    ,dptdc_lst_upd_dt    
                    ,dptdc_deleted_ind     
                    ,dptdc_reason_Cd    

					,DPTDC_PAYMODE
,DPTDC_BANKACNO
,DPTDC_BANKACNAME
,DPTDC_BANKBRNAME
,DPTDC_TRANSFEREENAME
,DPTDC_DOI
,DPTDC_CHQ_REFNO 

,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID 
                    )VALUES     
                    (CONVERT(INT,@l_id)    
                    ,CONVERT(INT,@currstring)    
                    ,@l_dpam_id    
                    ,CONVERT(INT,@l_id)    
                    ,convert(datetime,@pa_req_dt,103)    
                    ,convert(datetime,@pa_exe_dt,103)    
                    ,@pa_slip_no    
                    ,@l_isin    
                    
, case when @pa_tab in ('BOBO','ID') and  @pa_trdReasoncd in ('2','6') then @pa_cm_id  else convert(varchar,@line_no) end --,@line_no    
                    ,@l_qty    
                    ,@pa_trans_no    
                    ,@l_trastm_id    
                    ,@pa_mkt_type    
                    ,@pa_settlm_no    
                    ,@pa_tr_setm_type    
                    ,@pa_tr_setm_no          
                    ,@pa_tr_dp_id            
                    ,@pa_tr_cmbpid           
                    ,@pa_tr_acct_no          
                    ,@pa_converted_qty    
                    ,'P'    
                    ,@l_trastm_desc    
                    ,@pa_excm_id    
                    ,@pa_cash_trf    
                    ,case when @pa_tab in ('BOBO','ID') and  @pa_trdReasoncd in ('2','6')   then '' else @pa_cm_id     end --, ,@pa_cm_id    
                    ,@pa_rmks    
                    ,@pa_login_name    
                    ,getdate()    
                    ,@pa_login_name    
                    ,getdate()    
                     ,case when @l_high_val_yn = 'Y' then -1 else 0 end   
                     , @pa_trdReasoncd  
					 		,@pa_Paymode 
			,@pa_Bankacno 
			,@pa_Bankacname 
			,@pa_Bankbrname 
			,@pa_Transfereename 
			,convert(datetime,@pa_DOI,103) 
			,@pa_ChqRefno     
			
									,@PA_UCC 
,@PA_EXID 
,@PA_SEGID 
,@PA_CMID 
,@PA_EID 
,@PA_TMCMID                  
                    )    
                  --    
                  end    
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
            IF @PA_ACTION = 'DEL'   or @l_action = 'D'     
            BEGIN    
            --    
     
                  
              IF exists(SELECT * FROM EDIS_PRE_DPTDC_MAK WHERE dptdc_dtls_id = convert(numeric,@currstring) and dptdc_deleted_ind in (0,-1))    
              BEGIN    
              --    
                if @l_action = 'D'     
                BEGIN    
                --    
                  --delete used from EDIS_PRE_DPTDC_MAK,dp_acct_mstr,used_slip used                   where dpam_id = dptdc_dpam_id and uses_dpam_acct_no = dpam_sba_no and dptdc_id = convert(numeric,@l_id)                       
                    
                  DELETE FROM EDIS_PRE_DPTDC_MAK    
                  WHERE  dptdc_deleted_ind in (0,-1)  
                  AND    dptdc_id          = convert(numeric,@l_id)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  delete used from EDIS_PRE_DPTDC_MAK,dp_acct_mstr,used_slip used where dpam_id = dptdc_dpam_id and uses_dpam_acct_no = dpam_sba_no 
                  and dptdc_dtls_id = convert(numeric,@currstring)  
                  and ltrim(rtrim(uses_slip_no)) = ltrim(rtrim(dptdc_slip_no))                    
                  
                  DELETE FROM EDIS_PRE_DPTDC_MAK    
                  WHERE  dptdc_deleted_ind in (0,-1)    
                  AND    dptdc_dtls_id          = convert(numeric,@currstring)    
                --    
                END    
              --    
              END    
              ELSE    
              BEGIN    
              --    
                BEGIN TRANSACTION     
                    
                if @l_action = 'D'     
                BEGIN    
                --    
                  INSERT INTO EDIS_PRE_DPTDC_MAK    
                  (dptdc_id    
                  ,dptdc_dtls_id    
                  ,dptdc_dpam_id    
                  ,DPTDC_INTERNAL_REF_NO    
                  ,dptdc_request_dt    
                  ,dptdc_execution_dt    
                  ,dptdc_slip_no    
                  ,dptdc_isin    
                  ,dptdc_line_no    
                  ,dptdc_qty    
                  ,dptdc_trans_no    
                  ,dptdc_trastm_cd    
                  ,dptdc_mkt_type    
                  ,dptdc_settlement_no    
                  ,dptdc_other_settlement_type    
                  ,dptdc_other_settlement_no    
                  ,dptdc_counter_dp_id    
                  ,dptdc_counter_cmbp_id    
                  ,dptdc_counter_demat_acct_no    
                  ,dptdc_converted_qty    
                  ,dptdc_status    
                  ,dptdc_internal_trastm    
                  ,dptdc_excm_id    
                  ,dptdc_cash_trf    
                  ,dptdc_cm_id    
                  ,dptdc_rmks    
                  ,dptdc_created_by    
                  ,dptdc_created_dt    
                  ,dptdc_lst_upd_by    
                  ,dptdc_lst_upd_dt    
                  ,dptdc_deleted_ind    
                  ,dptdc_reason_cd
				  
				  ,DPTDC_PAYMODE
				,DPTDC_BANKACNO
				,DPTDC_BANKACNAME
				,DPTDC_BANKBRNAME
				,DPTDC_TRANSFEREENAME
				,DPTDC_DOI
				,DPTDC_CHQ_REFNO
				
								,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
				  )    
                  SELECT     
                   dptdc_id    
                  ,dptdc_dtls_id    
                  ,dptdc_dpam_id    
                  ,dptdc_id    
                  ,dptdc_request_dt    
                  ,dptdc_execution_dt    
                  ,dptdc_slip_no    
                  ,dptdc_isin    
                  ,dptdc_line_no    
                  ,dptdc_qty    
                  ,dptdc_trans_no    
                  ,dptdc_trastm_cd    
                  ,dptdc_mkt_type    
                  ,dptdc_settlement_no    
                  ,dptdc_other_settlement_type    
                  ,dptdc_other_settlement_no    
                  ,dptdc_counter_dp_id    
                  ,dptdc_counter_cmbp_id    
                  ,dptdc_counter_demat_acct_no    
                  ,dptdc_converted_qty    
                  ,dptdc_status    
                  ,dptdc_internal_trastm    
                  ,dptdc_excm_id    
                  ,dptdc_cash_trf    
                  ,dptdc_cm_id    
                  ,dptdc_rmks    
                  ,dptdc_created_by    
                  ,dptdc_created_dt    
                  ,dptdc_lst_upd_by    
                  ,dptdc_lst_upd_dt    
                  ,4    
           , dptdc_reason_cd    

			,DPTDC_PAYMODE
			,DPTDC_BANKACNO
			,DPTDC_BANKACNAME
			,DPTDC_BANKBRNAME
			,DPTDC_TRANSFEREENAME
			,DPTDC_DOI
			,DPTDC_CHQ_REFNO
			
				,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
                  FROM DP_TRX_DTLS_CDSL    
                  WHERE dptdc_deleted_ind      = 1     
                  AND   dptdc_dtls_id          = convert(numeric,@currstring)    
                  AND   dptdc_id               = convert(numeric,@l_id)    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  INSERT INTO EDIS_PRE_DPTDC_MAK    
                  (dptdc_id    
                  ,dptdc_dtls_id    
                  ,dptdc_dpam_id    
                  ,DPTDC_INTERNAL_REF_NO    
                  ,dptdc_request_dt    
                  ,dptdc_execution_dt    
                  ,dptdc_slip_no    
                  ,dptdc_isin    
                  ,dptdc_line_no    
                  ,dptdc_qty    
                  ,dptdc_trans_no    
                  ,dptdc_trastm_cd    
                  ,dptdc_mkt_type    
                  ,dptdc_settlement_no    
                  ,dptdc_other_settlement_type    
                  ,dptdc_other_settlement_no    
                  ,dptdc_counter_dp_id    
                  ,dptdc_counter_cmbp_id    
                  ,dptdc_counter_demat_acct_no    
                  ,dptdc_converted_qty    
                  ,dptdc_status    
                  ,dptdc_internal_trastm    
                  ,dptdc_excm_id    
                  ,dptdc_cash_trf    
                  ,dptdc_cm_id    
                  ,dptdc_rmks    
                  ,dptdc_created_by    
                  ,dptdc_created_dt    
                  ,dptdc_lst_upd_by    
                  ,dptdc_lst_upd_dt    
                  ,dptdc_deleted_ind    
                     ,dptdc_reason_cd
					 ,DPTDC_PAYMODE
,DPTDC_BANKACNO
,DPTDC_BANKACNAME
,DPTDC_BANKBRNAME
,DPTDC_TRANSFEREENAME
,DPTDC_DOI
,DPTDC_CHQ_REFNO


,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
					 )    
                  SELECT     
                   dptdc_id    
                  ,dptdc_dtls_id    
                  ,dptdc_dpam_id    
                  ,dptdc_id    
                  ,dptdc_request_dt    
                  ,dptdc_execution_dt    
                  ,dptdc_slip_no    
                  ,dptdc_isin    
                  ,dptdc_line_no    
                  ,dptdc_qty    
                  ,dptdc_trans_no    
                  ,dptdc_trastm_cd    
                  ,dptdc_mkt_type    
                  ,dptdc_settlement_no    
                  ,dptdc_other_settlement_type    
                  ,dptdc_other_settlement_no    
                  ,dptdc_counter_dp_id    
                  ,dptdc_counter_cmbp_id    
                  ,dptdc_counter_demat_acct_no    
                  ,dptdc_converted_qty    
                  ,dptdc_status    
                  ,dptdc_internal_trastm    
                  ,dptdc_excm_id    
                  ,dptdc_cash_trf    
                  ,dptdc_cm_id    
                  ,dptdc_rmks    
                  ,dptdc_created_by    
                  ,dptdc_created_dt    
                  ,dptdc_lst_upd_by    
                  ,dptdc_lst_upd_dt    
                  ,4    
                  ,dptdc_reason_cd  
				  ,DPTDC_PAYMODE
,DPTDC_BANKACNO
,DPTDC_BANKACNAME
,DPTDC_BANKBRNAME
,DPTDC_TRANSFEREENAME
,DPTDC_DOI
,DPTDC_CHQ_REFNO  

,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
                  FROM DP_TRX_DTLS_CDSL    
                  WHERE dptdc_deleted_ind      = 1     
                  AND   dptdc_dtls_id          = convert(numeric,@currstring)    
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
  
              SET @@c_access_cursor =  CURSOR fast_forward FOR          
              SELECT dptdc_id, dptdc_deleted_ind  FROM EDIS_PRE_DPTDC_MAK where dptdc_dtls_id = convert(numeric,@currstring) and dptdc_deleted_ind in (0,4,6,-1)    
  
              --          
              OPEN @@c_access_cursor          
              FETCH NEXT FROM @@c_access_cursor INTO @c_dptd_id, @c_deleted_ind     
              --          
              WHILE @@fetch_status = 0          
              BEGIN          
              --          
                 BEGIN TRANSACTION    
    
                 IF EXISTS(select * from EDIS_PRE_DPTDC_MAK where dptdc_id = @c_dptd_id and dptdc_deleted_ind = 6)    
                 BEGIN    
                 --    
                   UPDATE  dptdc     
                   SET     dptdc_dpam_id               = dptdcm.dptdc_dpam_id    
                          ,dptdc_request_dt            = dptdcm.dptdc_request_dt                
                          ,dptdc_execution_dt          = dptdcm.dptdc_execution_dt              
                          ,dptdc_slip_no               = dptdcm.dptdc_slip_no                   
                          ,dptdc_trans_no              = dptdcm.dptdc_trans_no                  
                          ,dptdc_mkt_type              = dptdcm.dptdc_mkt_type                  
                          ,dptdc_settlement_no         = dptdcm.dptdc_settlement_no             
                          ,dptdc_other_settlement_type = dptdcm.dptdc_other_settlement_type     
                          ,dptdc_other_settlement_no   = dptdcm.dptdc_other_settlement_no       
                          ,dptdc_counter_dp_id         = dptdcm.dptdc_counter_dp_id             
                          ,dptdc_counter_cmbp_id       = dptdcm.dptdc_counter_cmbp_id           
                          ,dptdc_counter_demat_acct_no = dptdcm.dptdc_counter_demat_acct_no     
                          ,dptdc_converted_qty         = dptdcm.dptdc_converted_qty             
                          ,dptdc_excm_id               = dptdcm.dptdc_excm_id                   
                          ,dptdc_cash_trf              = dptdcm.dptdc_cash_trf                  
                          ,dptdc_isin                  = dptdcm.dptdc_isin                      
                          ,dptdc_qty                   = dptdcm.dptdc_qty        
                          ,dptdc_rmks                  = dptdcm.dptdc_rmks    
                          ,dptdc_cm_id                 = dptdcm.dptdc_cm_id    
                          ,DPTDC_INTERNAL_REF_NO       = dptdcm.DPTDC_INTERNAL_REF_NO                     
                          ,dptdc_lst_upd_dt            = getdate()    
                          ,dptdc_lst_upd_by            = @pa_login_name    

						  ,DPTDC_PAYMODE=dptdcm.DPTDC_PAYMODE
					,DPTDC_BANKACNO=dptdcm.DPTDC_BANKACNO
					,DPTDC_BANKACNAME=dptdcm.DPTDC_BANKACNAME
					,DPTDC_BANKBRNAME=dptdcm.DPTDC_BANKBRNAME
					,DPTDC_TRANSFEREENAME=dptdcm.DPTDC_TRANSFEREENAME
					,DPTDC_DOI=dptdcm.DPTDC_DOI
					,DPTDC_CHQ_REFNO=  dptdcm.DPTDC_CHQ_REFNO    
					
						,DPTDC_UCC=dptdcm.DPTDC_UCC
					,DPTDC_EXID=dptdcm.DPTDC_EXID
					,DPTDC_SEGID=dptdcm.DPTDC_SEGID
					,DPTDC_CMID=dptdcm.DPTDC_CMID
					,DPTDC_EID=dptdcm.DPTDC_EID
					,DPTDC_TMCMID=dptdcm.DPTDC_TMCMID
                          , DPTDC_REASON_CD      = dptdcm.DPTDC_REASON_CD                     
                   FROM    EDIS_PRE_DPTDC_MAK                      dptdcm           
                          ,dp_trx_dtls_cdsl               dptdc     
                   WHERE   dptdcm.dptdc_id              = convert(numeric,@c_dptd_id)    
                   and     dptdcm.dptdc_id              = DPTDc.dptdc_id    
                   and     dptdcm.dptdc_dtls_id         = DPTDc.dptdc_dtls_id     
                   AND     dptdcm.dptdc_deleted_ind     = 6      
                       
                       
                      
    
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
    
                     UPDATE EDIS_PRE_DPTDC_MAK     
                     SET    dptdc_deleted_ind = 7    
                          , dptdc_lst_upd_dt  = getdate()    
                          , dptdc_lst_upd_by  = @pa_login_name    
                     WHERE  dptdc_id          = convert(numeric,@c_dptd_id)    
                     AND    dptdc_deleted_ind = 6    
    
    
                     COMMIT TRANSACTION    
                   --    
                   END    
                 --    
                 END    
                 ELSE IF exists(select * from EDIS_PRE_DPTDC_MAK where dptdc_id = convert(numeric,@c_dptd_id) and dptdc_deleted_ind in (0,-1))    
                 BEGIN    
                 --    
  
                   INSERT INTO DP_TRX_DTLS_CDSL    
                   (dptdc_id    
                   ,dptdc_dtls_id    
                   ,dptdc_dpam_id    
       ,DPTDC_INTERNAL_REF_NO    
                   ,dptdc_request_dt    
                   ,dptdc_execution_dt    
                   ,dptdc_slip_no    
                   ,dptdc_isin    
                   ,dptdc_line_no    
                   ,dptdc_qty    
                   ,dptdc_trans_no    
                   ,dptdc_trastm_cd    
                   ,dptdc_mkt_type    
                   ,dptdc_settlement_no    
                   ,dptdc_other_settlement_type    
                   ,dptdc_other_settlement_no    
                   ,dptdc_counter_dp_id    
                   ,dptdc_counter_cmbp_id    
                   ,dptdc_counter_demat_acct_no    
                   ,dptdc_converted_qty    
                   ,dptdc_status    
                   ,dptdc_internal_trastm    
                   ,dptdc_excm_id    
                   ,dptdc_cash_trf    
                   ,dptdc_cm_id    
                   ,dptdc_rmks    
                   ,dptdc_created_by    
                   ,dptdc_created_dt    
                   ,dptdc_lst_upd_by    
                   ,dptdc_lst_upd_dt    
                   ,dptdc_deleted_ind    
       ,dptdc_reason_cd
	   ,DPTDC_PAYMODE
		,DPTDC_BANKACNO
		,DPTDC_BANKACNAME
		,DPTDC_BANKBRNAME
		,DPTDC_TRANSFEREENAME
		,DPTDC_DOI
		,DPTDC_CHQ_REFNO 
		
			,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
	   )    
                   SELECT     
                   dptdc_id    
                  ,dptdc_dtls_id    
                  ,dptdc_dpam_id    
                  ,DPTDC_INTERNAL_REF_NO    
                  ,dptdc_request_dt    
                  ,dptdc_execution_dt    
                  ,dptdc_slip_no    
                  ,dptdc_isin    
                  ,dptdc_line_no    
                  ,dptdc_qty    
                  ,dptdc_trans_no    
                  ,dptdc_trastm_cd    
                  ,dptdc_mkt_type    
                  ,dptdc_settlement_no    
                  ,dptdc_other_settlement_type    
                  ,dptdc_other_settlement_no    
                  ,dptdc_counter_dp_id    
                  ,dptdc_counter_cmbp_id    
                  ,dptdc_counter_demat_acct_no    
                  ,dptdc_converted_qty    
                  ,dptdc_status    
                  ,dptdc_internal_trastm    
                  ,dptdc_excm_id    
                  ,dptdc_cash_trf    
                  ,dptdc_cm_id    
                  ,dptdc_rmks    
                  ,dptdc_created_by    
                 -- ,dptdc_created_dt  --changed by shilpa  
      ,getdate()  
                  ,dptdc_lst_upd_by    
                  ,dptdc_lst_upd_dt    
                  ,1    
      ,dptdc_reason_cd  
	  
				 ,DPTDC_PAYMODE
				,DPTDC_BANKACNO
				,DPTDC_BANKACNAME
				,DPTDC_BANKBRNAME
				,DPTDC_TRANSFEREENAME
				,DPTDC_DOI
				,DPTDC_CHQ_REFNO   
				
							,DPTDC_UCC
,DPTDC_EXID
,DPTDC_SEGID
,DPTDC_CMID
,DPTDC_EID
,DPTDC_TMCMID
                  FROM  EDIS_PRE_DPTDC_MAK    
                  WHERE dptdc_deleted_ind      = 0    
                  AND   dptdc_id               = convert(numeric,@c_dptd_id)     
    
    
    
    
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
    
                    if exists(select dptdc_id from EDIS_PRE_DPTDC_MAK where dptdc_id = convert(numeric,@c_dptd_id) AND dptdc_deleted_ind = 0  )  
                     begin  
                     --  
                     UPDATE EDIS_PRE_DPTDC_MAK     
                     SET    dptdc_deleted_ind = 1    
                        --  , dptdc_lst_upd_dt  = getdate()    
                          , dptdc_lst_upd_by  = @pa_login_name    
                     WHERE  dptdc_id          = convert(numeric,@c_dptd_id)    
                     AND    dptdc_deleted_ind = 0    
                     end  
                     else  
                     begin  
print 'lateshkk'  
                         UPDATE EDIS_PRE_DPTDC_MAK     
                     SET    dptdc_deleted_ind = 0    
                          , dptdc_lst_upd_dt  = getdate()    
                          , dptdc_lst_upd_by  = @pa_login_name  ----lateshmar022012  
                          , dptdc_mid_chk = @pa_login_name  
                     WHERE  dptdc_id          = convert(numeric,@c_dptd_id)    
                     AND    dptdc_deleted_ind = -1  
                     end     
    
                     COMMIT TRANSACTION    
                   --    
                   END    
                 --    
                 END    
                 ELSE     
                 BEGIN    
                 --    
                   delete used from dp_trx_dtls_cdsl,dp_acct_mstr,used_slip used 
                   where dpam_id = dptdc_dpam_id and uses_dpam_acct_no = dpam_sba_no 
                   and dptdc_id          = convert(numeric,@c_dptd_id)     
                   and ltrim(rtrim(uses_slip_no)) = ltrim(rtrim(dptdc_slip_no))
                       
                   UPDATE dp_trx_dtls_cdsl    
                   SET    dptdc_deleted_ind = 0    
                        , dptdc_lst_upd_dt  = getdate()    
                        , dptdc_lst_upd_by  = @pa_login_name    
                   WHERE  dptdc_id          = convert(numeric,@c_dptd_id)    
                   AND    dptdc_deleted_ind = 1    
    
                   UPDATE EDIS_PRE_DPTDC_MAK     
                   SET    dptdc_deleted_ind = 5    
                        , dptdc_lst_upd_dt  = getdate()    
                        , dptdc_lst_upd_by  = @pa_login_name    
                   WHERE  dptdc_id          = convert(numeric,@c_dptd_id)    
                   AND    dptdc_deleted_ind = 4    
    
                   COMMIT TRANSACTION    
                 --    
                 END    
                   
                   
               FETCH NEXT FROM @@c_access_cursor INTO @c_dptd_id, @c_deleted_ind         
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
    
delete used from EDIS_PRE_DPTDC_MAK,dp_acct_mstr,used_slip used 
where dpam_id = dptdc_dpam_id and uses_dpam_acct_no = dpam_sba_no 
and dptdc_id          = convert(numeric,@c_dptd_id)     
and ltrim(rtrim(uses_slip_no)) = ltrim(rtrim(dptdc_slip_no))
                     
               UPDATE EDIS_PRE_DPTDC_MAK     
               SET    dptdc_deleted_ind = 3    
                    , dptdc_lst_upd_dt  = getdate()    
                    , dptdc_lst_upd_by  = @pa_login_name    
               WHERE  dptdc_dtls_id     = convert(numeric,@currstring)    
               AND    dptdc_deleted_ind in (0,4,6,-1)    
  
     delete from uses from used_slip uses , EDIS_PRE_DPTDC_MAK , dp_acct_mstr   
    where DPAM_ID  = DPTDC_DPAM_ID   
    and  USES_DPAM_ACCT_NO = dpam_sba_no   
    and dptdc_slip_no = ltrim(rtrim(USES_SERIES_TYPE))+ltrim(rtrim(USES_SLIP_NO))  
    and dptdc_dtls_id     = convert(numeric,@currstring)   and USES_TRANTM_ID =  '1'  
  
    
    
    
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
  
  IF left(ltrim(rtrim(@pa_errmsg)),5) <> 'ERROR'    
  BEGIN    
  
  
--    select '','1', @pa_dpm_dpid,@pa_dpam_acct_no,@pa_slip_no,@pa_login_name,''    
    exec pr_checkslipno 'N','1', @pa_dpm_dpid,@pa_dpam_acct_no,@pa_slip_no,@pa_login_name,''    
      print 'rere'
  END   
    
--update EDIS_PRE_DPTDC_MAK set dptdc_deleted_ind = -1   
--where  dptdc_slip_no in(select dptdc_slip_no   
--from EDIS_PRE_DPTDC_MAK where dptdc_slip_no= ltrim(rtrim(@pa_slip_no))   
--and dptdc_deleted_ind = -1  
--)  
--and dptdc_deleted_ind in (0,-1)  
 
--if left(ltrim(rtrim(@pa_errmsg)),5) <> 'ERROR'     
--begin   
  


--create table #tmpvaltbl1(dptdc_slip_no varchar(20),Val numeric(18,3),isin varchar(15),qty numeric(18,3),isin_name varchar(200),tmpdptdc_id int)


--select distinct DPHMCD_ISIN isin , rate rate into #latestrate from holdingallforview where 1=2
--create clustered index ix_1 on #latestrate (isin)


--if exists (select 1  from EDIS_PRE_DPTDC_MAK left outer join #latestrate  on   DPTDC_ISIN = isin
--	,isin_mstr
--	where dptdc_deleted_ind in (0,-1)  and rate is null
--	and DPTDC_ISIN = ISIN_CD 
--	--and DPTDC_ISIN = CLOPM_ISIN_CD
--	and dptdc_slip_no = @pa_slip_no )
	
--	begin 
--select CLOPM_ISIN_CD , MAX(CLOPM_DT ) CLOPM_DT
--into #temprate from closing_price_mstr_cdsl where CLOPM_ISIN_CD in
-- (select dptdc_isin from EDIS_PRE_DPTDC_MAK where dptdc_slip_no = @pa_slip_no)
--group by CLOPM_ISIN_CD 

--create index ix_1 on #temprate (CLOPM_ISIN_CD)

--select b.CLOPM_ISIN_CD , b.CLOPM_CDSL_RT 
--into #temprate_final from #temprate a ,closing_price_mstr_cdsl  b 
--where a.CLOPM_ISIN_CD = b.CLOPM_ISIN_CD 
--and a.CLOPM_DT = b.CLOPM_DT 

--create index ix_1 on #temprate_final (CLOPM_ISIN_CD)
	
--	insert into #tmpvaltbl1
--	select distinct dptdc_slip_no , isnull(CONVERT(NUMERIC(18,3),(abs(dptdc_qty) * CLOPM_CDSL_RT)),'0') Val
--	 ,DPTDC_ISIN ,ABS(dptdc_qty) qty ,ISIN_NAME,dptdc_id
--	from EDIS_PRE_DPTDC_MAK left outer join #temprate_final on   DPTDC_ISIN = CLOPM_ISIN_CD
--	,isin_mstr
--	where dptdc_deleted_ind in (0,-1) 
--	and DPTDC_ISIN = ISIN_CD 
--	--and DPTDC_ISIN = CLOPM_ISIN_CD
--	and dptdc_slip_no = @pa_slip_no


--end
--else 
--begin 
--print '1sdsadsad'

--insert into #tmpvaltbl1
--	select distinct dptdc_slip_no , isnull(CONVERT(NUMERIC(18,3),(abs(dptdc_qty) * rate)),'0') Val
--	 ,DPTDC_ISIN ,ABS(dptdc_qty) qty ,ISIN_NAME,dptdc_id
--	from EDIS_PRE_DPTDC_MAK left outer join #latestrate  on   DPTDC_ISIN = isin
--	,isin_mstr
--	where dptdc_deleted_ind in (0,-1) -- and rate is null
--	and DPTDC_ISIN = ISIN_CD 
--	--and DPTDC_ISIN = CLOPM_ISIN_CD
--	and dptdc_slip_no = @pa_slip_no
	
	
--end  
--set @pa_errmsg  = 'ISIN      \t\tSCRIP NAME      \t\tREF NO     \tQTY     \t\tVALUATION\n'  
--select @pa_errmsg = @pa_errmsg + dptdc_isin  
--		  + ' :\t'+ isnull((select distinct convert(varchar,isin_name)  from #tmpvaltbl1 where isin = DPTDC_ISIN and abs(qty) = abs(dptdc_qty)),'')
--          + ' :\t'+convert(varchar,dptdc_id)  
--		  + ' :\t'+convert(varchar,abs(DPTDC_QTY))
--		  + ' :\t\t'+ isnull((select distinct convert(varchar,val)  from #tmpvaltbl1 where isin = DPTDC_ISIN and abs(qty) = abs(dptdc_qty)),'')
--          + '\n\n'		 
--from EDIS_PRE_DPTDC_MAK where dptdc_slip_no = @pa_slip_no  
--and dptdc_deleted_ind in (0,-1) 
--order by DPTDC_ISIN 
--set @pa_errmsg = @pa_errmsg + '  \t\t\t\tTotal:\t\t' + isnull((select distinct convert(varchar,sum(val))  from #tmpvaltbl1 ),'') 
--SELECT * FROM #tmpvaltbl1

--set @pa_errmsg =''
--select @pa_errmsg = @pa_errmsg +
-- isnull(dptdc_isin,'') + '|*~|' + convert(varchar,isnull(ISIN_NAME,'')) + '|*~|' + convert(varchar,dptdc_id) + '|*~|' + convert(varchar,abs(DPTDC_QTY)) + '|*~|' + isnull((select distinct convert(varchar,val)  from #tmpvaltbl1 where isin = DPTDC_ISIN and abs(qty) = abs(dptdc_qty) and dptdc_id=tmpdptdc_id),'') + '*|~*'
--from EDIS_PRE_DPTDC_MAK,ISIN_MSTR 
--where dptdc_slip_no = @pa_slip_no  
--and isin_cd = DPTDC_ISIN
--and ISIN_DELETED_IND=1
--and dptdc_deleted_ind in (0,-1) 
--order by dptdc_id 

  --drop table #tmpvaltbl1
  
  
--end   
  
--    
END

GO
