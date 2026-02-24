-- Object: PROCEDURE citrus_usr.pr_checkslipno_pledge
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--begin tran
  --exec [pr_checkslipno_pledge] '','P','close', 'IN300175','100000037','860','vishal',''        

  
  --rollback
--  commit
  
 ---Y 908 IN300175   41    
--[pr_checkslipno_pledge] 'Y','908','','IN300175','','41','',''      
CREATE   procedure [citrus_usr].[pr_checkslipno_pledge]      
(      
@validateonly char(1), -- Y to validate only, N to process slip      
@trans_code varchar(50),     
@trans_desc varchar(50),     
@dpid varchar(8),      
@accountno varchar(20),      
@slipno varchar(20),      
@pa_login_name  varchar(50),      
@pa_errmsg  varchar(8000) output      
)      
as      
begin       
      
DECLARE @@AllSlipused char(1),      
@@series varchar(10),      
@@date_cr   datetime,      
@l_dpm_id   varchar(20),      
@@sr_no     varchar(50),      
@@acct_no   varchar(50) ,    
@@cmbp_id   varchar(25),    
@l_uses_id  numeric(10,0),    
@l_trans    varchar(50)    
    
    SELECT @l_dpm_id  = dpm_id from dp_mstr where dpm_dpid  = @dpid and dpm_deleted_ind  = 1      
  
  SET @@series = ''      
  
   
  
  
--if left(@dpid,2) = 'IN'   
--begin  
----  
--  set @trans_code = case when @trans_desc = 'create' and @trans_code = 'P' then '908'      
--						when @trans_desc = 'create' and @trans_code = 'H' then '908'      
--						when @trans_desc = 'close' then '908'      
--						when @trans_desc = 'invk' then '908'      
--						when @trans_desc = 'cnfcreate' and @trans_code = 'P' then '908'      
--						when @trans_desc = 'cnfcreate' and @trans_code = 'H' then '908'      
--						when @trans_desc = 'cnfclose' then '908'      
--						when @trans_desc = 'cnfinvk' then '908'
--						when @trans_desc = 'UNICLOSE' then '908'   
--                                else @trans_desc   end      
----  
--end  
--else  
--begin  
----  
--  set @trans_code =  @trans_code   
----  
--end  

  
--IF UPPER(@trans_code)  = 'CRTE'   
-- BEGIN  
-- --  
  
  
--   SELECT @@series=ltrim(rtrim(ISNULL(SLIBM_SERIES_TYPE,'')))     
--   from slip_book_mstr    
--        ,transaction_sub_type_mstr    
--        ,transaction_type_mstr  
--   WHERE  trastm_cd          = @trans_code     
--   AND    SLIBM_tratm_id     = trastm_id    
--   AND    trantm_id          = trastm_tratm_id  
--   AND    trantm_code        = 'SLIP_TYPE_CDSL'  
--   AND    SLIBM_DPM_ID    = @l_dpm_id     
--   AND @slipno like ltrim(rtrim(slibm_series_type)) + '%' AND SLIBM_DELETED_IND =1    
--   AND  ISNULL(SLIBM_SERIES_TYPE,'')    <> ''  
  
-- --  
-- END  
  
  
-- IF UPPER(@trans_code)  <> 'CRTE'   
-- BEGIN  
-- --  
  
  
--   SELECT @@series=ltrim(rtrim(ISNULL(SLIBM_SERIES_TYPE,'')))     
--   from slip_book_mstr    
--        ,transaction_sub_type_mstr    
--        ,transaction_type_mstr  
--   WHERE  trastm_cd          = @trans_code     
--   AND    SLIBM_tratm_id     = trastm_id    
--   AND    trantm_id          = trastm_tratm_id  
--   AND    trantm_code        = 'SLIP_TYPE_NSDL'  
--   AND    SLIBM_DPM_ID    = @l_dpm_id     
--   AND @slipno like ltrim(rtrim(slibm_series_type)) + '%' AND SLIBM_DELETED_IND =1    
--   AND  ISNULL(SLIBM_SERIES_TYPE,'')    <> ''  
  
-- --  
-- END  
  
         
 SET @@sr_no = REPLACE(@slipno,@@series,'')  
  
 -- IF ISNUMERIC(@@sr_no) = 0    
 --BEGIN    
 -- SET @pa_errmsg =  'Invalid Slip No.' + '|*~|1'     
 -- RETURN    
 --END    
 
 declare @l_used_slip char(1)     
 IF left(@dpid,2) = 'IN'   
 select  @l_used_slip  = USES_USED_DESTR FROM used_slip WHERE uses_trantm_id IN ('908','909','911','910','916','917','918','919') and uses_dpm_id = @l_dpm_id  and USES_SLIP_NO = @@sr_no and USES_SERIES_TYPE = @@series and USES_DELETED_IND = 1    
   
 IF left(@dpid,2) <> 'IN'   
 select  @l_used_slip  = USES_USED_DESTR FROM used_slip WHERE uses_trantm_id = @trans_code and uses_dpm_id = @l_dpm_id  and USES_SLIP_NO = @@sr_no and USES_SERIES_TYPE = @@series and USES_DELETED_IND = 1    
   
 IF isnull(@l_used_slip ,'') <> ''    
 BEGIN      
     if @l_used_slip  = 'D'    
     set @pa_errmsg =  'Slip no. has already been Destroyed' + '|*~|1'       
     if @l_used_slip  = 'B'    
     set @pa_errmsg =  'Slip no. has already been Blocked' + '|*~|1'       
     if @l_used_slip  = 'U'    
     set @pa_errmsg =  'Slip no. has already been Used' + '|*~|1'          
 RETURN    
 END    
     print @accountno
 IF @accountno <> ''      
 BEGIN  
--     print 'inaccno'
--   SELECT distinct @@AllSlipused = sliim_all_used    
--      
--   FROM   slip_issue_mstr     
--   ,      transaction_sub_type_mstr    
--   ,      dp_acct_mstr   
--   WHERE  trastm_cd          = @trans_code      
--   AND    sliim_dpam_acct_no = @accountno   
--   AND    sliim_tratm_id     = trastm_id    
--   AND    sliim_dpam_acct_no = dpam_sba_no  
--   AND    sliim_dpm_id       = @l_dpm_id    
--   AND    sliim_series_type  = @@series    
--   AND    convert(bigint,@@sr_no) between convert(bigint,sliim_slip_no_fr) and convert(bigint,sliim_slip_no_to)    
--   AND    sliim_deleted_ind  = 1    
--   AND    trastm_deleted_ind = 1   
-- print 'me'
--print @@AllSlipused
--print 'em'
--  IF isnull(@@AllSlipused,'') = ''   
--  BEGIN    
--    print '1'
--  set @pa_errmsg = 'Slip no. not issued to selected client' + '|*~|1'   
--    print 'weeee'
--  RETURN  
--  END    
  
--   print 'ssssss'
   IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE uses_trantm_id = @trans_code and uses_dpm_id = @l_dpm_id and uses_dpam_acct_no = @accountno and USES_SLIP_NO = @@sr_no and USES_SERIES_TYPE = @@series and USES_DELETED_IND = 1)      
   BEGIN      
    set @pa_errmsg =  'Slip no. has already been used' + '|*~|1'       
    RETURN    
   END      
   ELSE      
   BEGIN    
      set @pa_errmsg = ISNULL(@accountno,'') + '|*~|0'      
   END     
       
  IF (@validateonly <> 'Y')      
  BEGIN      
	   select @l_uses_id = isnull(max(uses_id),0) + 1 from used_slip     
	   INSERT INTO used_slip(USES_ID,USES_DPM_ID,USES_DPAM_ACCT_NO,USES_SLIP_NO,USES_TRANTM_ID,USES_SERIES_TYPE,USES_USED_DESTR,USES_CREATED_BY,USES_CREATED_DT,USES_LST_UPD_BY,USES_LST_UPD_DT,USES_DELETED_IND)      
	   VALUES(@l_uses_id,@l_dpm_id,@accountno,@@sr_no,@trans_code,@@series,'U',@pa_login_name,getdate(),@pa_login_name,getdate(),1)       
	   -- USES_ID IS HARDCODED, SHOULD BE INCREMENTAL  
	   set @pa_errmsg =''      
  END       
 END 
   
 IF @accountno = ''      
 BEGIN      

 
   --SELECT distinct @@acct_no = ltrim(rtrim(sliim_dpam_acct_no)) --Right(ltrim(rtrim(sliim_dpam_acct_no)),8)    
         
   --FROM   slip_issue_mstr     
   --,      transaction_sub_type_mstr    
   --,      dp_acct_mstr    
   --WHERE  trastm_cd          = case when @trans_code = 'CRTEMP' then 'CRTE' else @trans_code end  -- case when @trans_code      ='CRTE' then '908' else @trans_code end 
   --AND    sliim_tratm_id     = trastm_id    
   --AND    dpam_sba_no       = sliim_dpam_acct_no  
   --AND    sliim_dpm_id       = @l_dpm_id    
   --AND    sliim_series_type  = @@series    
   --AND    convert(bigint,@@sr_no) between convert(bigint,sliim_slip_no_fr) and convert(bigint,sliim_slip_no_to)    
   --AND    sliim_deleted_ind  = 1    
   --AND    trastm_deleted_ind = 1   
  
   --if ltrim(rtrim(isnull(@@acct_no,''))) = ''    
   --BEGIN    
   -- set @pa_errmsg = 'Slip no. not issued to client|*~|1'    
   -- RETURN  
   --END    
 
   IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE uses_trantm_id = @trans_code and uses_dpm_id = @l_dpm_id  and USES_SLIP_NO = @@sr_no and USES_SERIES_TYPE = @@series and USES_DELETED_IND = 1)      
   BEGIN      
    set @pa_errmsg =  'Slip no. has already been used' + '|*~|1'       
    RETURN    
   END      
   ELSE      
   BEGIN    
  
      SELECT @pa_errmsg =@@acct_no+ '|*~|0'   
	  --FROM SLIP_ISSUE_MSTR,TRANSACTION_SUB_TYPE_MSTR   
   --   WHERE   TRASTM_ID = SLIIM_TRATM_ID AND LTRIM(RTRIM(TRASTM_CD)) =  UPPER(LTRIM(RTRIM(@trans_code))) AND sliim_dpm_id = @l_dpm_id  
   --   AND convert(bigint,@@sr_no) BETWEEN  SLIIM_SLIP_NO_FR AND SLIIM_SLIP_NO_TO AND SLIIM_SERIES_TYPE = LTRIM(RTRIM(@@series))  
   END      
   
 END     
   
END

GO
