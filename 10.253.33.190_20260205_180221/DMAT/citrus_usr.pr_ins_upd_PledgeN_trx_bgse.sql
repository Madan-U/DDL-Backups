-- Object: PROCEDURE citrus_usr.pr_ins_upd_PledgeN_trx_bgse
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*      
create table nsdl_pledge_dtls      
(PLDT_ID BIGINT,      
PLDT_DTLS_ID BIGINT,      
PLDT_DPM_ID INT,      
PLDT_DPAM_ID BIGINT,--account_no      
PLDT_REQUEST_DT DATETIME,--PLDT_REQUEST_DT      
PLDT_EXEC_DT DATETIME,--PLDT_EXEC_DT       
PLDT_CLOSURE_DT DATETIME,--PLDT_CLOSURE_DT       
PLDT_SLIP_NO VARCHAR(20),--PLDT_SLIP_NO       
PLDT_ISIN VARCHAR(12),--dtls--PLDT_ISIN       
PLDT_ORG_QTY NUMERIC(18,3),--dtls--PLDT_ORG_QTY       
PLDT_QTY NUMERIC(18,3),--dtls      
PLDT_TRASTM_CD VARCHAR(3),      
PLDT_INSTR_TYPE CHAR(1),      
PLDT_AGREEMENT_NO VARCHAR(20),      
PLDT_SEQ_NO VARCHAR(20),      
PLDT_TRANS_NO VARCHAR(20),      
PLDT_PLEDGEE_DPID VARCHAR(8),      
PLDT_PLEDGEE_DEMAT_ACCT_NO VARCHAR(16),      
PLDT_REL_DT DATETIME,--dtls      
PLDT_REL_RSN VARCHAR(20),--dtls      
PLDT_REJ_RSN VARCHAR(20),--dtls      
PLDT_STATUS CHAR(1),--dtls      
PLDT_BATCH_NO BIGINT,      
PLDT_BROKER_BATCH_NO BIGINT,      
PLDT_BROKER_REF_NO BIGINT,      
PLDT_DELETED_IND INT,      
PLDT_CREATED_BY VARCHAR(20),      
PLDT_CREATED_DATE DATETIME,      
PLDT_UPDATED_BY VARCHAR(20),      
PLDT_UPDATED_DATE DATETIME)      
      
*/    
--alter table   nsdl_pledge_dtls add pldt_rmks varchar(250)  
--[pr_ins_upd_PledgeN_trx] '0','INS','HO','IN300175','10000220','10','27/06/2008','27/06/2008','02/06/2008','P','20','IN300175','10000220','COIMBATORE CAPITAL L','A|*~|2219980025|*~|10|*~|12/04/2008|*~|01|*~||*~||*~|*|~*','create','vvvvv','0','*|~*','|*~|',''   
--delete from NpledgeD_mak   
--delete from nsdl_pledge_dtls   
CREATE PROCEDURE [citrus_usr].[pr_ins_upd_PledgeN_trx_bgse](@pa_id              VARCHAR(8000)        
             ,@pa_action          VARCHAR(20)        
             ,@pa_login_name      VARCHAR(20)        
             ,@pa_dpm_dpid        VARCHAR(50)      
             ,@pa_dpam_acct_no    VARCHAR(50)      
             ,@pa_slip_no         VARCHAR(20)       
             ,@pa_req_dt          VARCHAR(11)      
             ,@pa_exe_dt          VARCHAR(11)      
             ,@pa_clos_dt         VARCHAR(11)      
             ,@pa_instr_type      CHAR(1)      
             ,@pa_agree_no        VARCHAR(20)      
             ,@pa_pledgee_dpid    varchar(20)      
             ,@pa_pledgee_acctno  varchar(20)      
             ,@pa_PLEDGEE_DEMAT_NAME  varchar(100)      
             ,@pa_values          VARCHAR(8000)      
             ,@pa_desc            VARCHAR(500)    
             ,@pa_rmks            VARCHAR(250)     
             ,@pa_chk_yn          INT        
             ,@rowdelimiter       CHAR(4)       = '*|~*'        
             ,@coldelimiter       CHAR(4)       = '|*~|'        
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
      , @l_excm_cd     VARCHAR(500)      
      , @l_dpm_id       NUMERIC      
      , @l_deleted_ind  smallint      
      , @l_dpam_id      numeric      
      , @line_no        NUMERIC      
      , @l_tr_dpid      VARCHAR(25)       
      , @l_tr_sett_type VARCHAR(50)      
      , @l_tr_setm_no   VARCHAR(50)      
      , @l_isin         VARCHAR(25)       
      , @l_qty          VARCHAR(25)      
      , @l_ORG_qty          VARCHAR(25)      
      , @l_trastm_id    VARCHAR(25)      
      , @l_action       VARCHAR(25)      
      , @l_dtls_id      NUMERIC      
      , @l_dtlsm_id      NUMERIC      
   , @l_id varchar(20)      
       ,@@c_access_cursor cursor      
            ,@c_deleted_ind    varchar(20)      
      ,@c_PLDT_ID        varchar(20)      
      ,@l_trastm_desc    varchar(20)      
       , @l_max_high_val   numeric(18,5)      
                 ,@l_high_val_yn     char(1)        
                 ,@l_val_yn     char(1)        
,@l_rel_dt VARCHAR(11)      
,@l_rel_rsn VARCHAR(20)      
,@l_rej_rsn VARCHAR(20)     
,@l_seq_no   varchar(20)    
    
    
set @l_trastm_id = case when @pa_desc = 'create' and @pa_instr_type = 'P' then '908'    
when @pa_desc = 'create' and @pa_instr_type = 'H' then '909'    
when @pa_desc = 'close' then '911'    
when @pa_desc = 'invk' then '910'    
when @pa_desc = 'cnfcreate' and @pa_instr_type = 'P' then '916'    
when @pa_desc = 'cnfcreate' and @pa_instr_type = 'H' then '917'    
when @pa_desc = 'cnfclose' then '919'    
when @pa_desc = 'cnfinvk' then '918'  
when @pa_desc = 'uniclose' then '999' end    
    
    
                       
set @l_val_yn  = citrus_usr.fn_get_high_val('',0,'DORMANT',@pa_dpam_acct_no,convert(datetime,@pa_req_dt,103))          
            
if @PA_ACTION <> 'app'  AND @PA_ACTION <> 'rej'             
begin      
--      
  create table #NpledgeD_mak      
  (PLDT_ID BIGINT      
  ,PLDT_DTLS_ID BIGINT      
  ,PLDT_DPM_ID INT      
  ,PLDT_DPAM_ID BIGINT--account_no      
  ,PLDT_REQUEST_DT DATETIME--PLDT_REQUEST_DT      
  ,PLDT_EXEC_DT DATETIME--PLDT_EXEC_DT       
  ,PLDT_CLOSURE_DT DATETIME--PLDT_CLOSURE_DT       
  ,PLDT_SLIP_NO VARCHAR(20)--PLDT_SLIP_NO       
  ,PLDT_ISIN VARCHAR(12)--dtls--PLDT_ISIN       
  ,PLDT_ORG_QTY NUMERIC(18,3)--dtls--PLDT_ORG_QTY       
  ,PLDT_QTY NUMERIC(18,3)--dtls      
  ,PLDT_TRASTM_CD VARCHAR(3)      
  ,PLDT_INSTR_TYPE CHAR(1)      
  ,PLDT_AGREEMENT_NO VARCHAR(20)      
  ,PLDT_SEQ_NO VARCHAR(20)      
  ,PLDT_TRANS_NO VARCHAR(20)      
  ,PLDT_PLEDGEE_DPID VARCHAR(8)      
  ,PLDT_PLEDGEE_DEMAT_ACCT_NO VARCHAR(16)      
  ,PLDT_REL_DT DATETIME--dtls      
  ,PLDT_REL_RSN VARCHAR(20)--dtls      
  ,PLDT_REJ_RSN VARCHAR(20)--dtls      
  ,PLDT_BATCH_NO BIGINT      
  ,PLDT_BROKER_BATCH_NO BIGINT      
  ,PLDT_BROKER_REF_NO BIGINT      
  ,PLDT_DELETED_IND INT      
  ,PLDT_CREATED_BY VARCHAR(20)      
  ,PLDT_CREATED_DATE DATETIME      
  ,PLDT_UPDATED_BY VARCHAR(20)      
  ,PLDT_UPDATED_DATE DATETIME      
,PLDT_PLEDGEE_DEMAT_NAME    varchar(100)  
,pldt_rmks varchar(250)  
,PLDT_STATUS varchar(5)  
  )      
  insert into #NpledgeD_mak      
  (PLDT_ID       
  ,PLDT_DTLS_ID       
  ,PLDT_DPM_ID       
  ,PLDT_DPAM_ID       
  ,PLDT_REQUEST_DT       
  ,PLDT_EXEC_DT       
  ,PLDT_CLOSURE_DT       
  ,PLDT_SLIP_NO       
  ,PLDT_ISIN       
  ,PLDT_ORG_QTY       
  ,PLDT_QTY       
  ,PLDT_TRASTM_CD       
  ,PLDT_INSTR_TYPE       
  ,PLDT_AGREEMENT_NO       
  ,PLDT_SEQ_NO       
  ,PLDT_TRANS_NO       
  ,PLDT_PLEDGEE_DPID       
  ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
  ,PLDT_REL_DT       
  ,PLDT_REL_RSN      
  ,PLDT_REJ_RSN      
  ,PLDT_BATCH_NO       
  ,PLDT_BROKER_BATCH_NO       
  ,PLDT_BROKER_REF_NO       
  ,PLDT_DELETED_IND       
  ,PLDT_CREATED_BY       
  ,PLDT_CREATED_DATE       
  ,PLDT_UPDATED_BY       
  ,PLDT_UPDATED_DATE      
  ,PLDT_PLEDGEE_DEMAT_NAME   
  , pldt_rmks   
,PLDT_STATUS   
   )      
  select PLDT_ID       
  ,PLDT_DTLS_ID       
  ,PLDT_DPM_ID       
  ,PLDT_DPAM_ID       
  ,PLDT_REQUEST_DT       
  ,PLDT_EXEC_DT       
  ,PLDT_CLOSURE_DT       
  ,PLDT_SLIP_NO       
  ,PLDT_ISIN       
  ,PLDT_ORG_QTY       
  ,PLDT_QTY       
  ,PLDT_TRASTM_CD       
  ,PLDT_INSTR_TYPE       
  ,PLDT_AGREEMENT_NO       
  ,PLDT_SEQ_NO       
  ,PLDT_TRANS_NO       
  ,PLDT_PLEDGEE_DPID       
  ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
  ,PLDT_REL_DT       
  ,PLDT_REL_RSN      
  ,PLDT_REJ_RSN      
  ,PLDT_BATCH_NO       
  ,PLDT_BROKER_BATCH_NO       
  ,PLDT_BROKER_REF_NO       
  ,PLDT_DELETED_IND       
  ,PLDT_CREATED_BY       
  ,PLDT_CREATED_DATE       
  ,PLDT_UPDATED_BY       
  ,PLDT_UPDATED_DATE       
  ,PLDT_PLEDGEE_DEMAT_NAME  
,pldt_rmks  
,PLDT_STATUS  
  FROM NpledgeD_mak       
  where PLDT_DTLS_ID = @pa_id      
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
      where BITRM_PARENT_CD = 'PLDT_DTLS_ID'      
          
      update bitmap_ref_mstr with(tablock)      
      set    BITRM_BIT_LOCATION  = BITRM_BIT_LOCATION  + 1       
      where BITRM_PARENT_CD = 'PLDT_DTLS_ID'      
      end    
          
      select @l_PLDT_ID = BITRM_BIT_LOCATION       
      from  bitmap_ref_mstr       
      where BITRM_PARENT_CD = 'PLDT_ID'      
          
      update bitmap_ref_mstr with(tablock)      
      set    BITRM_BIT_LOCATION  = BITRM_BIT_LOCATION  + @l_count_row       
      where BITRM_PARENT_CD = 'PLDT_ID'      
          
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
    SELECT @l_dtls_id = PLDT_DTLS_ID FROM  nsdl_pledge_dtls WHERE PLDT_DTLS_ID = convert(numeric,@pa_id) AND PLDT_TRASTM_CD = @l_trastm_id      
  --      
  END      
  ELSE      
  BEGIN      
  --      
    SELECT @l_dtls_id = PLDT_DTLS_ID FROM  NpledgeD_mak WHERE PLDT_DTLS_ID = convert(numeric,@pa_id) AND PLDT_TRASTM_CD = @l_trastm_id      
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
if @pa_action = 'EDT' and @pa_values <> '0' and @pa_chk_yn = 1 and exists(select PLDT_ID from nsdl_pledge_dtls where PLDT_DTLS_ID = @pa_id and PLDT_DELETED_IND = 1)      
begin       
--      
  SET @l_counter = 1      
  SET @l_str1 = @pa_values      
  SET @l_max_counter = citrus_usr.ufn_countstring(@l_str1,'*|~*')      
  WHILE @l_counter  <= @l_max_counter      
  BEGIN      
  --       
    SELECT @l_str2 = citrus_usr.FN_SPLITVAL_ROW(@l_str1,@l_counter)      
    INSERT INTO #temp_id VALUES(case when citrus_usr.FN_SPLITVAL(@l_str2,1) = 'D' then   citrus_usr.FN_SPLITVAL(@l_str2,2) else citrus_usr.FN_SPLITVAL(@l_str2,8) end)      
          
    SET @l_counter   = @l_counter   + 1      
  --        
  END      
        
  INSERT INTO NpledgeD_mak          
  (PLDT_ID       
  ,PLDT_DTLS_ID       
  ,PLDT_DPM_ID       
  ,PLDT_DPAM_ID       
  ,PLDT_REQUEST_DT       
  ,PLDT_EXEC_DT       
  ,PLDT_CLOSURE_DT       
  ,PLDT_SLIP_NO       
  ,PLDT_ISIN       
  ,PLDT_ORG_QTY       
  ,PLDT_QTY       
  ,PLDT_TRASTM_CD       
  ,PLDT_INSTR_TYPE       
  ,PLDT_AGREEMENT_NO  
  ,PLDT_SEQ_NO -- Jitesh on oct 15 2010         
  ,PLDT_PLEDGEE_DPID       
  ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
  ,PLDT_REL_DT       
  ,PLDT_REL_RSN      
  ,PLDT_REJ_RSN      
  ,PLDT_BATCH_NO       
  ,PLDT_BROKER_BATCH_NO       
  ,PLDT_BROKER_REF_NO       
  ,PLDT_DELETED_IND       
  ,PLDT_CREATED_BY       
  ,PLDT_CREATED_DATE       
  ,PLDT_UPDATED_BY       
  ,PLDT_UPDATED_DATE       
  ,PLDT_PLEDGEE_DEMAT_NAME    
  ,pldt_rmks   
  ,PLDT_STATUS  
  )           
  select PLDT_ID          
  ,PLDT_DTLS_ID          
  ,PLDT_dpm_ID      
  ,PLDT_DPAM_ID          
  ,convert(datetime,@pa_req_dt,103)          
  ,convert(datetime,@pa_exe_dt,103)        
  ,convert(datetime,@pa_clos_dt,103)        
  ,@pa_slip_no          
  ,PLDT_ISIN       
  ,PLDT_ORG_QTY       
  ,PLDT_QTY       
  ,PLDT_TRASTM_CD           
  ,@pa_instr_type      
  ,@pa_agree_no 
  ,PLDT_SEQ_NO -- Jitesh on oct 15 2010      
  ,@pa_pledgee_dpid          
  ,@pa_pledgee_acctno        
  ,PLDT_REL_DT       
  ,PLDT_REL_RSN      
  ,PLDT_REJ_RSN      
  ,PLDT_BATCH_NO       
  ,PLDT_BROKER_BATCH_NO       
  ,PLDT_BROKER_REF_NO       
  ,6       
  ,PLDT_CREATED_BY       
  ,PLDT_CREATED_DATE       
  ,PLDT_UPDATED_BY       
  ,PLDT_UPDATED_DATE    
  ,@pa_PLEDGEE_DEMAT_NAME    
,@pa_rmks  
,'P'     
  FROM  nsdl_pledge_dtls          
  WHERE PLDT_ID       not in (select id from #temp_id)      
  and   PLDT_DTLS_ID  = @pa_id      
  AND   PLDT_DELETED_IND   =  1       
        
        
--      
end      
else IF @pa_action = 'EDT' and @pa_values <> '0' and @pa_chk_yn = 1 and NOT exists(select PLDT_ID from nsdl_pledge_dtls where PLDT_DTLS_ID = @pa_id and PLDT_DELETED_IND = 1)      
begin      
--      
       
  SET @l_counter = 1      
  SET @l_str1 = @pa_values      
  SET @l_max_counter = citrus_usr.ufn_countstring(@l_str1,'*|~*')      
  WHILE @l_counter  <= @l_max_counter      
  BEGIN      
  --       
    SELECT @l_str2 = citrus_usr.FN_SPLITVAL_ROW(@l_str1,@l_counter)      
    INSERT INTO #temp_id VALUES(case when citrus_usr.FN_SPLITVAL(@l_str2,1) = 'D' then   citrus_usr.FN_SPLITVAL(@l_str2,2) else citrus_usr.FN_SPLITVAL(@l_str2,8) end)      
      
    SET @l_counter   = @l_counter   + 1      
  --        
  END      
         
  delete from    NpledgeD_mak          
  WHERE PLDT_ID       not in (select id from #temp_id)       
  and   PLDT_DTLS_ID  = @pa_id      
  AND   PLDT_DELETED_IND   in (0,4,6)      
         
  INSERT INTO NpledgeD_mak          
  (PLDT_ID       
  ,PLDT_DTLS_ID       
  ,PLDT_DPM_ID       
  ,PLDT_DPAM_ID       
  ,PLDT_REQUEST_DT       
  ,PLDT_EXEC_DT       
  ,PLDT_CLOSURE_DT       
  ,PLDT_SLIP_NO       
  ,PLDT_ISIN       
  ,PLDT_ORG_QTY       
  ,PLDT_QTY       
  ,PLDT_TRASTM_CD       
  ,PLDT_INSTR_TYPE       
  ,PLDT_AGREEMENT_NO 
  ,PLDT_SEQ_NO -- jitesh on oct 15 2010       
  ,PLDT_PLEDGEE_DPID       
  ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
  ,PLDT_REL_DT       
  ,PLDT_REL_RSN      
  ,PLDT_REJ_RSN      
  ,PLDT_BATCH_NO       
  ,PLDT_BROKER_BATCH_NO       
  ,PLDT_BROKER_REF_NO       
  ,PLDT_DELETED_IND       
  ,PLDT_CREATED_BY       
  ,PLDT_CREATED_DATE       
  ,PLDT_UPDATED_BY       
  ,PLDT_UPDATED_DATE     
  ,PLDT_PLEDGEE_DEMAT_NAME    
,pldt_rmks     
,PLDT_STATUS    
  )           
  select  PLDT_ID          
  ,PLDT_DTLS_ID          
  ,PLDT_dpm_ID      
  ,PLDT_DPAM_ID          
  ,convert(datetime,@pa_req_dt,103)          
  ,convert(datetime,@pa_exe_dt,103)        
  ,convert(datetime,@pa_clos_dt,103)        
  ,@pa_slip_no          
  ,PLDT_ISIN       
  ,PLDT_ORG_QTY       
  ,PLDT_QTY       
  ,PLDT_TRASTM_CD           
  ,@pa_instr_type      
  ,@pa_agree_no   
  ,PLDT_SEQ_NO -- jitesh on oct 15 2010      
  ,@pa_pledgee_dpid          
  ,@pa_pledgee_acctno        
  ,PLDT_REL_DT       
  ,PLDT_REL_RSN      
  ,PLDT_REJ_RSN      
  ,PLDT_BATCH_NO       
  ,PLDT_BROKER_BATCH_NO       
  ,PLDT_BROKER_REF_NO       
  ,0       
  ,PLDT_CREATED_BY       
  ,PLDT_CREATED_DATE       
  ,PLDT_UPDATED_BY       
  ,PLDT_UPDATED_DATE       
  ,@pa_PLEDGEE_DEMAT_NAME    
,@pa_rmks  
,'P'  
  FROM  #NpledgeD_mak          
  WHERE PLDT_ID       not in (select id from #temp_id)      
  and   PLDT_DTLS_ID  = @pa_id      
  AND   PLDT_DELETED_IND   in (0,4,6)      
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
            SET @l_rel_dt            = convert(datetime,citrus_usr.fn_splitval(@currstring_value,4),103)          
            SET @l_rel_rsn           = citrus_usr.fn_splitval(@currstring_value,5)       
            SET @l_rej_rsn           = citrus_usr.fn_splitval(@currstring_value,6)       
            SET @l_seq_no           = citrus_usr.fn_splitval(@currstring_value,7)    
            SET @l_id                = citrus_usr.fn_splitval(@currstring_value,8)       
            SET @l_qty               = CONVERT(VARCHAR(25),CONVERT(NUMERIC(18,5),-1*convert(numeric(18,5),@l_qty)))      
            set @l_high_val_yn       = case when @l_val_yn = 'Y' then 'Y' else citrus_usr.fn_get_high_val(@l_isin,abs(@l_qty),'HIGH_VALUE','','') end      
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
                    
              INSERT INTO nsdl_pledge_dtls      
              (PLDT_ID       
              ,PLDT_DTLS_ID       
              ,PLDT_DPM_ID       
              ,PLDT_DPAM_ID       
              ,PLDT_REQUEST_DT       
              ,PLDT_EXEC_DT       
              ,PLDT_CLOSURE_DT       
              ,PLDT_SLIP_NO       
              ,PLDT_ISIN       
              ,PLDT_ORG_QTY       
              ,PLDT_QTY       
              ,PLDT_TRASTM_CD       
              ,PLDT_INSTR_TYPE       
              ,PLDT_AGREEMENT_NO 
			  ,PLDT_SEQ_NO       
              ,PLDT_PLEDGEE_DPID       
              ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
              ,PLDT_REL_DT       
              ,PLDT_REL_RSN      
              ,PLDT_REJ_RSN      
              ,PLDT_DELETED_IND       
              ,PLDT_CREATED_BY       
              ,PLDT_CREATED_DATE       
              ,PLDT_UPDATED_BY       
              ,PLDT_UPDATED_DATE        
              ,PLDT_PLEDGEE_DEMAT_NAME    
              ,pldt_rmks  
               ,PLDT_STATUS  
              )VALUES       
              (@l_PLDT_ID       
              ,@l_dtls_id      
              ,@l_dpm_id      
              ,@l_dpam_id      
              ,convert(datetime,@pa_req_dt,103)      
              ,convert(datetime,@pa_exe_dt,103)      
              ,convert(datetime,@pa_clos_dt,103)      
              ,@pa_slip_no      
              ,@l_isin                    
              ,@l_org_qty      
              ,@l_qty         
              ,@l_trastm_id      
              ,@pa_instr_type      
              ,@pa_agree_no 
			  ,@l_seq_no     
              ,@pa_pledgee_dpid      
              ,@pa_pledgee_acctno      
              ,@l_rel_dt                  
              ,@l_rel_rsn                 
              ,@l_rej_rsn                 
              ,1      
              ,@pa_login_name      
              ,getdate()      
              ,@pa_login_name      
              ,getdate()      
              ,@pa_PLEDGEE_DEMAT_NAME    
              ,@pa_rmks  
             ,'P'  
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
                      
                UPDATE  nsdl_pledge_dtls       
                SET    PLDT_DPAM_ID = @l_dpam_id      
                      ,PLDT_REQUEST_DT = convert(datetime,@pa_req_dt,103)      
                      ,PLDT_EXEC_DT = convert(datetime,@pa_exe_dt,103)      
                      ,PLDT_CLOSURE_DT =convert(datetime,@pa_clos_dt,103)      
                      ,PLDT_SLIP_NO = @pa_slip_no      
                      ,PLDT_INSTR_TYPE =  @pa_instr_type      
                      ,PLDT_AGREEMENT_NO = @pa_agree_no      
                      ,PLDT_PLEDGEE_DPID = @pa_pledgee_dpid       
                      ,PLDT_PLEDGEE_DEMAT_ACCT_NO = @pa_pledgee_acctno      
                      ,PLDT_UPDATED_BY = @pa_login_name      
                      ,PLDT_UPDATED_DATE = getdate()      
                      ,pldt_PLEDGEE_DEMAT_NAME = @pa_PLEDGEE_DEMAT_NAME    
                      ,pldt_rmks = @pa_rmks  
                WHERE   PLDT_DTLS_ID              = convert(INT,@currstring)      
                AND     PLDT_DELETED_IND          = 1      
              --      
              END      
              IF @l_action = 'E'      
              BEGIN      
              --      
                      
                UPDATE  nsdl_pledge_dtls       
                SET     PLDT_DPAM_ID = @l_dpam_id      
                       ,PLDT_REQUEST_DT = convert(datetime,@pa_req_dt,103)      
                       ,PLDT_EXEC_DT = convert(datetime,@pa_exe_dt,103)      
                       ,PLDT_CLOSURE_DT =convert(datetime,@pa_clos_dt,103)      
                       ,PLDT_SLIP_NO = @pa_slip_no      
                       ,PLDT_ISIN =@l_isin      
                       ,PLDT_ORG_QTY =@l_org_qty      
                       ,PLDT_QTY =@l_qty      
                       ,PLDT_INSTR_TYPE =  @pa_instr_type      
                       ,PLDT_AGREEMENT_NO = @pa_agree_no   
					   ,PLDT_SEQ_NO = @l_seq_no    
                       ,PLDT_PLEDGEE_DPID = @pa_pledgee_dpid       
                       ,PLDT_PLEDGEE_DEMAT_ACCT_NO = @pa_pledgee_acctno      
                       ,PLDT_REL_DT =@l_rel_dt      
                       ,PLDT_REL_RSN=@l_rel_rsn      
                       ,PLDT_REJ_RSN=@l_rej_rsn      
                       ,PLDT_UPDATED_BY = @pa_login_name      
                       ,PLDT_UPDATED_DATE = getdate()      
                       ,plDT_PLEDGEE_DEMAT_NAME = @pa_PLEDGEE_DEMAT_NAME    
                       ,pldt_rmks = @pa_rmks  
                WHERE   PLDT_ID                   = @l_id      
                AND     PLDT_DELETED_IND          = 1      
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
                    
                delete used from nsdl_pledge_dtls,dp_acct_mstr,used_slip used where dpam_id = PLDT_DPAM_ID and uses_dpam_acct_no = dpam_sba_no and PLDT_DTLS_ID = convert(INT,@currstring)                        
                      
                UPDATE nsdl_pledge_dtls      
                SET    PLDT_DELETED_IND = 0      
                     , PLDT_UPDATED_DATE  = getdate()      
                     , PLDT_UPDATED_BY  = @pa_login_name      
                WHERE  PLDT_DELETED_IND = 1      
                AND    PLDT_DTLS_ID     = convert(INT,@currstring)      
                      
                      
                     
                      
              --      
              END      
              IF @l_action = 'D'      
              BEGIN      
              --      
                delete used from nsdl_pledge_dtls,dp_acct_mstr,used_slip used where dpam_id = PLDT_DPAM_ID and uses_dpam_acct_no = dpam_sba_no and PLDT_ID          = @l_id          
                      
                UPDATE nsdl_pledge_dtls      
                SET    PLDT_DELETED_IND = 0      
                     , PLDT_UPDATED_DATE  = getdate()      
                     , PLDT_UPDATED_BY  = @pa_login_name      
                WHERE  PLDT_DELETED_IND = 1      
                AND    PLDT_ID          = @l_id      
                      
                                 
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
             
                    
              /*SELECT @l_PLDT_ID   = ISNULL(MAX(PLDT_ID),0) + 1 FROM nsdl_pledge_dtls        
                    
              SELECT @l_dptdm_id   = ISNULL(MAX(PLDT_ID),0) + 1 FROM NpledgeD_mak      
                    
              IF @l_dptdm_id   > @l_PLDT_ID         
              BEGIN      
              --      
                SET @l_PLDT_ID = @l_dptdm_id         
              --      
              END*/      
                    
              set @l_PLDT_ID = @l_PLDT_ID + 1      
                    
                    
                                  
              INSERT INTO NpledgeD_mak      
              (PLDT_ID       
              ,PLDT_DTLS_ID       
              ,PLDT_DPM_ID       
              ,PLDT_DPAM_ID       
              ,PLDT_REQUEST_DT       
              ,PLDT_EXEC_DT       
              ,PLDT_CLOSURE_DT       
              ,PLDT_SLIP_NO       
              ,PLDT_ISIN       
              ,PLDT_ORG_QTY       
              ,PLDT_QTY       
              ,PLDT_TRASTM_CD       
              ,PLDT_INSTR_TYPE       
              ,PLDT_AGREEMENT_NO 
			  ,PLDT_SEQ_NO      
              ,PLDT_PLEDGEE_DPID       
              ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
              ,PLDT_REL_DT       
              ,PLDT_REL_RSN      
              ,PLDT_REJ_RSN      
              ,PLDT_DELETED_IND       
             ,PLDT_CREATED_BY       
              ,PLDT_CREATED_DATE       
              ,PLDT_UPDATED_BY       
              ,PLDT_UPDATED_DATE       
              ,PLDT_PLEDGEE_DEMAT_NAME    
              ,pldt_rmks  
              ,PLDT_STATUS  
              )VALUES       
              (@l_PLDT_ID       
              ,@l_dtls_id      
              ,@l_dpm_id     
              ,@l_dpam_id      
              ,convert(datetime,@pa_req_dt,103)      
              ,convert(datetime,@pa_exe_dt,103)      
              ,convert(datetime,@pa_clos_dt,103)      
              ,@pa_slip_no      
              ,@l_isin                    
              ,@l_org_qty      
              ,@l_qty         
              ,@l_trastm_id      
              ,@pa_instr_type      
              ,@pa_agree_no   
			  ,@l_seq_no    
              ,@pa_pledgee_dpid      
              ,@pa_pledgee_acctno      
              ,@l_rel_dt                  
              ,@l_rel_rsn                 
              ,@l_rej_rsn                 
              ,case when @l_high_val_yn = 'Y' then -1 else 0 end          
              ,@pa_login_name      
              ,getdate()      
              ,@pa_login_name      
              ,getdate()      
              ,@pa_PLEDGEE_DEMAT_NAME   
              ,@pa_rmks   
              ,'P'   
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
                UPDATE NpledgeD_mak       
                SET    PLDT_DELETED_IND = 2      
                     , PLDT_UPDATED_DATE  = getdate()      
                     , PLDT_UPDATED_BY  = @pa_login_name      
                WHERE  PLDT_DTLS_ID     = CONVERT(INT,@currstring)      
              --      
              END      
              ELSE      
              BEGIN      
              --      
                IF @l_id <> '' AND  @L_ACTION <> 'D'      
                BEGIN      
                --      
                  UPDATE NpledgeD_mak       
                  SET    PLDT_DELETED_IND = 2      
                       , PLDT_UPDATED_DATE  = getdate()      
                       , PLDT_UPDATED_BY  = @pa_login_name      
                  WHERE  PLDT_ID          = @l_id      
                --      
                END      
              --      
              END      
                    
              IF EXISTS(select * from nsdl_pledge_dtls where PLDT_ID = @l_id and PLDT_DELETED_IND = 1)      
              BEGIN      
              --      
                       
                SET @l_deleted_ind = 6      
      
                IF @pa_values = '0'      
                BEGIN      
                --      
                  INSERT INTO NpledgeD_mak      
    (PLDT_ID       
                  ,PLDT_DTLS_ID       
                  ,PLDT_DPM_ID       
                  ,PLDT_DPAM_ID       
                  ,PLDT_REQUEST_DT       
                  ,PLDT_EXEC_DT       
                  ,PLDT_CLOSURE_DT       
                  ,PLDT_SLIP_NO       
                  ,PLDT_ISIN       
                  ,PLDT_ORG_QTY       
                  ,PLDT_QTY       
                  ,PLDT_TRASTM_CD       
                  ,PLDT_INSTR_TYPE       
                  ,PLDT_AGREEMENT_NO  
				  ,PLDT_SEQ_NO       
                  ,PLDT_PLEDGEE_DPID       
                  ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
                  ,PLDT_REL_DT       
                  ,PLDT_REL_RSN      
                  ,PLDT_REJ_RSN      
                  ,PLDT_DELETED_IND       
                  ,PLDT_CREATED_BY       
                  ,PLDT_CREATED_DATE       
                  ,PLDT_UPDATED_BY       
                  ,PLDT_UPDATED_DATE    
                  ,PLDT_PLEDGEE_DEMAT_NAME   
                  ,pldt_rmks  
                  ,PLDT_STATUS)      
                  SELECT PLDT_ID      
                  ,PLDT_DTLS_ID      
                  ,@l_dpm_id     
                  ,PLDT_DPAM_ID      
                  ,@pa_req_dt      
                  ,@pa_exe_dt      
                  ,convert(datetime,@pa_clos_dt,103)      
                  ,@pa_slip_no      
                  ,PLDT_ISIN       
                  ,PLDT_ORG_QTY       
                  ,PLDT_QTY       
                  ,PLDT_TRASTM_CD      
                  ,@pa_instr_type      
                  ,@pa_agree_no  
				  ,@l_seq_no    
                  ,@pa_pledgee_dpid      
                  ,@pa_pledgee_acctno      
                  ,PLDT_REL_DT       
                  ,PLDT_REL_RSN      
                  ,PLDT_REJ_RSN      
                  ,@l_deleted_ind      
                  ,PLDT_CREATED_BY       
                  ,PLDT_CREATED_DATE       
                  ,@pa_login_name      
                  ,getdate()      
                  ,@pa_PLEDGEE_DEMAT_NAME   
                  ,@pa_rmks   
                  ,'P'  
                  FROM  nsdl_pledge_dtls      
                  WHERE PLDT_DTLS_ID       =  CONVERT(INT,@currstring)      
                  AND   PLDT_DELETED_IND   =  1       
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
                  BEGIN      
                  --      
                    INSERT INTO NpledgeD_mak      
                    (PLDT_ID       
                    ,PLDT_DTLS_ID       
                    ,PLDT_DPM_ID       
                    ,PLDT_DPAM_ID       
                    ,PLDT_REQUEST_DT       
                    ,PLDT_EXEC_DT       
                    ,PLDT_CLOSURE_DT       
                    ,PLDT_SLIP_NO       
                    ,PLDT_ISIN       
                    ,PLDT_ORG_QTY       
                    ,PLDT_QTY       
                    ,PLDT_TRASTM_CD       
                    ,PLDT_INSTR_TYPE       
                    ,PLDT_AGREEMENT_NO
					,PLDT_SEQ_NO          
                    ,PLDT_PLEDGEE_DPID       
                    ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
                    ,PLDT_REL_DT       
                    ,PLDT_REL_RSN      
                    ,PLDT_REJ_RSN      
                    ,PLDT_DELETED_IND       
                    ,PLDT_CREATED_BY       
                    ,PLDT_CREATED_DATE       
                    ,PLDT_UPDATED_BY       
                    ,PLDT_UPDATED_DATE     
                    ,PLDT_PLEDGEE_DEMAT_NAME    
                    ,pldt_rmks    
                    ,PLDT_STATUS  
                    )VALUES       
                    (@l_PLDT_ID       
                    ,@l_dtls_id      
                    ,@l_dpm_id      
                    ,@l_dpam_id      
                    ,convert(datetime,@pa_req_dt,103)      
                    ,convert(datetime,@pa_exe_dt,103)      
                    ,convert(datetime,@pa_clos_dt,103)      
                    ,@pa_slip_no      
                    ,@l_isin                    
                    ,@l_org_qty      
                    ,@l_qty         
                    ,@l_trastm_id      
                    ,@pa_instr_type      
                    ,@pa_agree_no  
					,@l_seq_no    
                    ,@pa_pledgee_dpid      
                    ,@pa_pledgee_acctno      
                    ,@l_rel_dt                  
                    ,@l_rel_rsn                 
                    ,@l_rej_rsn                 
                    ,@l_deleted_ind      
                    ,@pa_login_name      
                    ,getdate()      
                    ,@pa_login_name      
                    ,getdate()      
                    ,@pa_PLEDGEE_DEMAT_NAME    
                    ,@pa_rmks  
                    ,'P'  
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
                  INSERT INTO NpledgeD_mak      
                  (PLDT_ID       
                  ,PLDT_DTLS_ID       
                  ,PLDT_DPM_ID       
                  ,PLDT_DPAM_ID       
                  ,PLDT_REQUEST_DT       
                  ,PLDT_EXEC_DT       
                  ,PLDT_CLOSURE_DT       
                  ,PLDT_SLIP_NO       
                  ,PLDT_ISIN       
                  ,PLDT_ORG_QTY       
                  ,PLDT_QTY       
                  ,PLDT_TRASTM_CD       
                  ,PLDT_INSTR_TYPE       
                  ,PLDT_AGREEMENT_NO 
				  ,PLDT_SEQ_NO         
                  ,PLDT_PLEDGEE_DPID       
                  ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
                  ,PLDT_REL_DT       
                  ,PLDT_REL_RSN      
                  ,PLDT_REJ_RSN      
                  ,PLDT_DELETED_IND       
                  ,PLDT_CREATED_BY       
                  ,PLDT_CREATED_DATE       
                  ,PLDT_UPDATED_BY       
                  ,PLDT_UPDATED_DATE        
                  ,PLDT_PLEDGEE_DEMAT_NAME    
                   ,pldt_rmks  
                  ,PLDT_STATUS  
                  )       
                   SELECT PLDT_ID      
                  ,PLDT_DTLS_ID      
                  ,@l_dpm_id      
                  ,PLDT_DPAM_ID      
                  ,@pa_req_dt      
                  ,@pa_exe_dt      
                  ,convert(datetime,@pa_clos_dt,103)      
                  ,@pa_slip_no      
                  ,PLDT_ISIN       
                  ,PLDT_ORG_QTY       
                  ,PLDT_QTY       
                  ,PLDT_TRASTM_CD      
                  ,@pa_instr_type      
                  ,@pa_agree_no   
				  ,@l_seq_no   
                  ,@pa_pledgee_dpid      
                  ,@pa_pledgee_acctno      
                  ,PLDT_REL_DT       
                  ,PLDT_REL_RSN      
                  ,PLDT_REJ_RSN      
                  ,@l_deleted_ind      
                  ,PLDT_CREATED_BY       
                  ,PLDT_CREATED_DATE       
                  ,@pa_login_name      
                  ,getdate()      
                  ,@pa_PLEDGEE_DEMAT_NAME  
                  ,@pa_rmks   
                  ,'P'   
                  FROM  #NpledgeD_mak      
                  WHERE PLDT_DTLS_ID       =  CONVERT(INT,@currstring)      
                  AND   PLDT_DELETED_IND   =  0      
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
      
                    INSERT INTO NpledgeD_mak      
                    (PLDT_ID       
                   ,PLDT_DTLS_ID       
                   ,PLDT_DPM_ID       
                   ,PLDT_DPAM_ID       
                   ,PLDT_REQUEST_DT       
                   ,PLDT_EXEC_DT       
                   ,PLDT_CLOSURE_DT       
                   ,PLDT_SLIP_NO       
                   ,PLDT_ISIN       
                   ,PLDT_ORG_QTY       
                   ,PLDT_QTY       
                   ,PLDT_TRASTM_CD       
                   ,PLDT_INSTR_TYPE       
                   ,PLDT_AGREEMENT_NO  
				   ,PLDT_SEQ_NO      
                   ,PLDT_PLEDGEE_DPID       
                   ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
                   ,PLDT_REL_DT       
                   ,PLDT_REL_RSN      
                   ,PLDT_REJ_RSN      
                   ,PLDT_DELETED_IND       
                   ,PLDT_CREATED_BY       
                   ,PLDT_CREATED_DATE       
                   ,PLDT_UPDATED_BY       
                   ,PLDT_UPDATED_DATE       
                   ,PLDT_PLEDGEE_DEMAT_NAME    
                  ,pldt_rmks   
                  ,PLDT_STATUS  
                    )VALUES       
                    (@l_PLDT_ID       
                    ,@l_dtls_id      
                    ,@l_dpm_id      
                    ,@l_dpam_id      
                    ,convert(datetime,@pa_req_dt,103)      
                    ,convert(datetime,@pa_exe_dt,103)      
                    ,convert(datetime,@pa_clos_dt,103)      
                    ,@pa_slip_no      
                    ,@l_isin                    
                    ,@l_org_qty      
                    ,@l_qty         
                    ,@l_trastm_id      
                    ,@pa_instr_type      
                    ,@pa_agree_no   
					,@l_seq_no     
                    ,@pa_pledgee_dpid      
                    ,@pa_pledgee_acctno      
                    ,@l_rel_dt                  
                    ,@l_rel_rsn                 
                    ,@l_rej_rsn                 
                    ,case when @l_high_val_yn = 'Y' then -1 else 0 end      
                    ,@pa_login_name      
                    ,getdate()      
                    ,@pa_login_name      
                    ,getdate()      
                    ,@pa_PLEDGEE_DEMAT_NAME    
                    ,@pa_rmks  
                    ,'P'  
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
            END                  IF @PA_ACTION = 'DEL' or @l_action = 'D'       
            BEGIN      
   --      
      
              IF exists(SELECT * FROM NpledgeD_mak WHERE PLDT_DTLS_ID = convert(numeric,@currstring) and PLDT_DELETED_IND = 0)      
              BEGIN      
              --      
                if @l_action = 'D'       
                BEGIN      
                --      
                  DELETE FROM NpledgeD_mak      
                  WHERE  PLDT_DELETED_IND = 0      
                  AND    PLDT_ID          = convert(numeric,@l_id)      
                --      
                END      
                ELSE      
                BEGIN      
                --      
                  DELETE FROM NpledgeD_mak      
                  WHERE  PLDT_DELETED_IND = 0      
                  AND    PLDT_DTLS_ID          = convert(numeric,@currstring)      
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
                INSERT INTO NpledgeD_mak      
                  (PLDT_ID       
                 ,PLDT_DTLS_ID       
                 ,PLDT_DPM_ID       
                 ,PLDT_DPAM_ID       
                 ,PLDT_REQUEST_DT       
                 ,PLDT_EXEC_DT       
                 ,PLDT_CLOSURE_DT       
                 ,PLDT_SLIP_NO       
                 ,PLDT_ISIN       
                 ,PLDT_ORG_QTY       
                 ,PLDT_QTY       
                 ,PLDT_TRASTM_CD       
                 ,PLDT_INSTR_TYPE       
                 ,PLDT_AGREEMENT_NO
				 ,PLDT_SEQ_NO          
                 ,PLDT_PLEDGEE_DPID       
                 ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
                 ,PLDT_REL_DT       
                 ,PLDT_REL_RSN      
                 ,PLDT_REJ_RSN      
                 ,PLDT_DELETED_IND       
                 ,PLDT_CREATED_BY       
                 ,PLDT_CREATED_DATE       
                 ,PLDT_UPDATED_BY       
                 ,PLDT_UPDATED_DATE    
                 ,pldt_PLEDGEE_DEMAT_NAME  
                 ,pldt_rmks  
                 ,PLDT_STATUS)      
                  SELECT       
                  PLDT_ID       
                 ,PLDT_DTLS_ID       
                 ,PLDT_DPM_ID       
                 ,PLDT_DPAM_ID       
                 ,PLDT_REQUEST_DT       
                 ,PLDT_EXEC_DT       
                 ,PLDT_CLOSURE_DT       
                 ,PLDT_SLIP_NO       
                 ,PLDT_ISIN       
                 ,PLDT_ORG_QTY       
                 ,PLDT_QTY       
                 ,PLDT_TRASTM_CD       
                 ,PLDT_INSTR_TYPE       
                 ,PLDT_AGREEMENT_NO 
				 ,PLDT_SEQ_NO       
                 ,PLDT_PLEDGEE_DPID       
                 ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
                 ,PLDT_REL_DT       
                 ,PLDT_REL_RSN      
                 ,PLDT_REJ_RSN      
                 ,4       
                 ,PLDT_CREATED_BY       
                 ,PLDT_CREATED_DATE       
                 ,PLDT_UPDATED_BY       
                 ,PLDT_UPDATED_DATE     
                 ,pldt_PLEDGEE_DEMAT_NAME   
                 ,pldt_rmks    
                  ,PLDT_STATUS  
                  FROM nsdl_pledge_dtls      
                  WHERE PLDT_DELETED_IND      = 1       
                  AND   PLDT_DTLS_ID          = convert(numeric,@currstring)      
                  AND   PLDT_ID               = convert(numeric,@l_id)      
                --      
                END      
                ELSE      
                BEGIN      
                --      
                  INSERT INTO NpledgeD_mak      
                 (PLDT_ID       
                 ,PLDT_DTLS_ID       
                 ,PLDT_DPM_ID       
                 ,PLDT_DPAM_ID       
                 ,PLDT_REQUEST_DT       
                 ,PLDT_EXEC_DT       
                 ,PLDT_CLOSURE_DT       
     ,PLDT_SLIP_NO       
                 ,PLDT_ISIN       
                 ,PLDT_ORG_QTY       
                 ,PLDT_QTY       
                 ,PLDT_TRASTM_CD       
                 ,PLDT_INSTR_TYPE       
                 ,PLDT_AGREEMENT_NO
				 ,PLDT_SEQ_NO        
                 ,PLDT_PLEDGEE_DPID       
                 ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
                 ,PLDT_REL_DT       
                 ,PLDT_REL_RSN      
      ,PLDT_REJ_RSN      
                 ,PLDT_DELETED_IND       
                 ,PLDT_CREATED_BY       
                 ,PLDT_CREATED_DATE       
                 ,PLDT_UPDATED_BY       
                 ,PLDT_UPDATED_DATE    
 ,pLDT_PLEDGEE_DEMAT_NAME   
  ,pldt_rmks  
,PLDT_STATUS )      
                 SELECT PLDT_ID       
                       ,PLDT_DTLS_ID       
                       ,PLDT_DPM_ID       
                       ,PLDT_DPAM_ID       
                       ,PLDT_REQUEST_DT       
                       ,PLDT_EXEC_DT       
                       ,PLDT_CLOSURE_DT       
                       ,PLDT_SLIP_NO       
                       ,PLDT_ISIN       
                       ,PLDT_ORG_QTY       
                       ,PLDT_QTY       
                       ,PLDT_TRASTM_CD       
                       ,PLDT_INSTR_TYPE       
                       ,PLDT_AGREEMENT_NO 
					   ,PLDT_SEQ_NO       
                       ,PLDT_PLEDGEE_DPID       
                       ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
                       ,PLDT_REL_DT       
                       ,PLDT_REL_RSN      
                       ,PLDT_REJ_RSN      
                       ,4       
                       ,PLDT_CREATED_BY       
                       ,PLDT_CREATED_DATE       
                       ,PLDT_UPDATED_BY       
                       ,PLDT_UPDATED_DATE    
                       ,pLDT_PLEDGEE_DEMAT_NAME        
                        ,pldt_rmks  
                       , PLDT_STATUS  
                 FROM nsdl_pledge_dtls      
                 WHERE PLDT_DELETED_IND      = 1       
                 AND   PLDT_DTLS_ID          = convert(numeric,@currstring)      
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
              SELECT PLDT_ID, PLDT_DELETED_IND  FROM NpledgeD_mak where PLDT_DTLS_ID = convert(numeric,@currstring) and PLDT_DELETED_IND in (0,4,6,-1)      
              --            
              OPEN @@c_access_cursor            
              FETCH NEXT FROM @@c_access_cursor INTO @c_PLDT_ID, @c_deleted_ind       
              --            
              WHILE @@fetch_status = 0            
              BEGIN            
              --            
                 BEGIN TRANSACTION      
      
                 IF EXISTS(select * from NpledgeD_mak where PLDT_ID = @c_PLDT_ID and PLDT_DELETED_IND = 6)      
                 BEGIN      
                 --      
                   UPDATE  dptd       
                   SET     DPTD.PLDT_DPAM_ID = dptdm.PLDT_DPAM_ID       
                          ,DPTD.PLDT_REQUEST_DT =dptdm.PLDT_REQUEST_DT      
                          ,DPTD.PLDT_EXEC_DT =dptdm.PLDT_EXEC_DT       
                          ,DPTD.PLDT_CLOSURE_DT =dptdm.PLDT_CLOSURE_DT      
                          ,DPTD.PLDT_SLIP_NO =dptdm.PLDT_SLIP_NO       
                          ,DPTD.PLDT_ISIN =dptdm.PLDT_ISIN       
                          ,DPTD.PLDT_ORG_QTY =dptdm.PLDT_ORG_QTY      
                          ,DPTD.PLDT_QTY =dptdm.PLDT_QTY       
                          ,DPTD.PLDT_TRASTM_CD =dptdm.PLDT_TRASTM_CD       
                          ,DPTD.PLDT_INSTR_TYPE =dptdm.PLDT_INSTR_TYPE       
                          ,DPTD.PLDT_AGREEMENT_NO =dptdm.PLDT_AGREEMENT_NO  
						  ,DPTD.PLDT_SEQ_NO =DPTDM.PLDT_SEQ_NO    
                          ,DPTD.PLDT_PLEDGEE_DPID =dptdm.PLDT_PLEDGEE_DPID       
                          ,DPTD.PLDT_PLEDGEE_DEMAT_ACCT_NO =dptdm.PLDT_PLEDGEE_DEMAT_ACCT_NO       
                          ,DPTD.PLDT_REL_DT =dptdm.PLDT_REL_DT       
                          ,DPTD.PLDT_REL_RSN=dptdm.PLDT_REL_RSN      
                          ,DPTD.PLDT_REJ_RSN=dptdm.PLDT_REJ_RSN      
                          ,DPTD.PLDT_UPDATED_BY =dptdm.PLDT_UPDATED_BY       
                          ,DPTD.PLDT_UPDATED_DATE =dptdm.PLDT_UPDATED_DATE      
                          ,DPTD.pLDT_PLEDGEE_DEMAT_NAME = DPTDm.pLDT_PLEDGEE_DEMAT_NAME    
                          ,dptd.pldt_rmks               = dptdm.pldt_rmks  
                   FROM    NpledgeD_mak                    dptdm             
                          ,nsdl_pledge_dtls                 dptd       
                   WHERE   dptdm.PLDT_ID             = convert(numeric,@c_PLDT_ID)      
                   AND      dptdm.PLDT_ID             = DPTD.PLDT_ID       
                   and     dptdm.PLDT_DTLS_ID        = DPTD.PLDT_DTLS_ID       
                   AND     dptdm.PLDT_DELETED_IND    = 6        
      
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
      
                     UPDATE NpledgeD_mak       
                     SET    PLDT_DELETED_IND = 7      
                          , PLDT_UPDATED_DATE  = getdate()      
                          , PLDT_UPDATED_BY  = @pa_login_name      
                     WHERE  PLDT_ID          = convert(numeric,@c_PLDT_ID)      
                     AND    PLDT_DELETED_IND = 6      
      
      
                     COMMIT TRANSACTION      
                   --      
                   END      
                 --      
                 END      
                 ELSE IF exists(select * from NpledgeD_mak where PLDT_ID = convert(numeric,@c_PLDT_ID) and PLDT_DELETED_IND in (0,-1))      
                 BEGIN      
                 --      
      
                   INSERT INTO nsdl_pledge_dtls      
                   (PLDT_ID       
                   ,PLDT_DTLS_ID       
                   ,PLDT_DPM_ID       
                   ,PLDT_DPAM_ID       
                   ,PLDT_REQUEST_DT       
                   ,PLDT_EXEC_DT       
                   ,PLDT_CLOSURE_DT       
                   ,PLDT_SLIP_NO       
                   ,PLDT_ISIN       
                   ,PLDT_ORG_QTY       
                   ,PLDT_QTY       
                   ,PLDT_TRASTM_CD       
                   ,PLDT_INSTR_TYPE       
                   ,PLDT_AGREEMENT_NO 
				   ,PLDT_SEQ_NO        
                   ,PLDT_PLEDGEE_DPID       
                   ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
                   ,PLDT_REL_DT       
                   ,PLDT_REL_RSN      
                   ,PLDT_REJ_RSN      
                   ,PLDT_DELETED_IND       
                   ,PLDT_CREATED_BY       
                   ,PLDT_CREATED_DATE       
                   ,PLDT_UPDATED_BY       
                   ,PLDT_UPDATED_DATE    
                   ,pLDT_PLEDGEE_DEMAT_NAME  
                  ,pldt_rmks  
                   ,PLDT_STATUS)      
                   SELECT       
                    PLDT_ID       
                   ,PLDT_DTLS_ID       
                   ,PLDT_DPM_ID       
                   ,PLDT_DPAM_ID       
                   ,PLDT_REQUEST_DT       
                   ,PLDT_EXEC_DT       
                   ,PLDT_CLOSURE_DT       
                   ,PLDT_SLIP_NO       
                   ,PLDT_ISIN       
                   ,PLDT_ORG_QTY       
                   ,PLDT_QTY       
                   ,PLDT_TRASTM_CD       
                   ,PLDT_INSTR_TYPE       
                   ,PLDT_AGREEMENT_NO 
				   ,PLDT_SEQ_NO        
                   ,PLDT_PLEDGEE_DPID       
                   ,PLDT_PLEDGEE_DEMAT_ACCT_NO       
                   ,PLDT_REL_DT       
                   ,PLDT_REL_RSN      
                   ,PLDT_REJ_RSN      
                   ,1       
                   ,PLDT_CREATED_BY       
                   ,PLDT_CREATED_DATE       
                   ,PLDT_UPDATED_BY       
                   ,PLDT_UPDATED_DATE      
,pLDT_PLEDGEE_DEMAT_NAME    
                  ,pldt_rmks   
                  ,PLDT_STATUS  
                   FROM  NpledgeD_mak      
                   WHERE PLDT_DELETED_IND      = 0      
                   AND   PLDT_ID               = convert(numeric,@c_PLDT_ID)       
      
      
      
      
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
      
                      if exists(select PLDT_ID from NpledgeD_mak where PLDT_ID = convert(numeric,@c_PLDT_ID) AND PLDT_DELETED_IND = 0 )      
                      begin      
                      --      
                        UPDATE NpledgeD_mak           
                        SET    PLDT_DELETED_IND = 1          
                             , PLDT_UPDATED_DATE  = getdate()          
                             , PLDT_UPDATED_BY  = @pa_login_name          
                        WHERE  PLDT_ID          = convert(numeric,@c_PLDT_ID)          
                        AND    PLDT_DELETED_IND = 0          
                      --      
                       end
                      else 
                      begin
                       UPDATE NpledgeD_mak           
                        SET    PLDT_DELETED_IND = 0          
                             , PLDT_UPDATED_DATE  = getdate()          
                             , PLDT_UPDATED_BY  = @pa_login_name          
                        WHERE  PLDT_ID          = convert(numeric,@c_PLDT_ID)          
                        AND    PLDT_DELETED_IND = -1          
                      end       
                            
                     COMMIT TRANSACTION      
                   --      
                   END      
                 --      
                 END      
                 ELSE       
                 BEGIN      
                 --      
                   delete used from nsdl_pledge_dtls,dp_acct_mstr,used_slip used where dpam_id = PLDT_DPAM_ID and uses_dpam_acct_no = dpam_sba_no and PLDT_ID          = convert(numeric,@c_PLDT_ID)       
                         
                   UPDATE nsdl_pledge_dtls      
                   SET    PLDT_DELETED_IND = 0      
                        , PLDT_UPDATED_DATE  = getdate()      
                        , PLDT_UPDATED_BY  = @pa_login_name      
                   WHERE  PLDT_ID          = convert(numeric,@c_PLDT_ID)      
                   AND    PLDT_DELETED_IND = 1      
      
      
      
                   UPDATE NpledgeD_mak       
                   SET    PLDT_DELETED_IND = 5      
                        , PLDT_UPDATED_DATE  = getdate()      
                        , PLDT_UPDATED_BY  = @pa_login_name      
                   WHERE  PLDT_ID          = convert(numeric,@c_PLDT_ID)      
                   AND    PLDT_DELETED_IND = 4      
      
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
                    
              UPDATE NpledgeD_mak       
              SET    PLDT_DELETED_IND = 3      
                   , PLDT_UPDATED_DATE  = getdate()      
                   , PLDT_UPDATED_BY  = @pa_login_name      
              WHERE  PLDT_DTLS_ID     = convert(numeric,@currstring)      
              AND    PLDT_DELETED_IND in (0,4,6)      
      
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
    exec [pr_checkslipno_pledge] '',@pa_instr_type,@pa_desc, @pa_dpm_dpid,@pa_dpam_acct_no,@pa_slip_no,@pa_login_name,''      
  --      
  END      
--      
END

GO
