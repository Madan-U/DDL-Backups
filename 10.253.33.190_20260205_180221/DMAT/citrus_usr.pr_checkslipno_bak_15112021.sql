-- Object: PROCEDURE citrus_usr.pr_checkslipno_bak_15112021
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



   
  
--[pr_checkslipno]  'N','1','IN300175','','1343','',''    
--[pr_checkslipno]  'Y','ONC2P_DP_TRX_SEL','IN300175','10000004','1344','',''      
--[pr_checkslipno]  'Y','ONC2P_DP_TRX_SEL','IN300175','10000012','4000101599','*****',''   
    
CREATE  procedure [citrus_usr].[pr_checkslipno_bak_15112021]
(          
  @validateonly char(1), -- Y to validate only, N to process slip          
  @trans_code varchar(50),          
  @dpid varchar(16),          
  @accountno varchar(20),          
  @slipno varchar(20),          
  @pa_login_name  varchar(50),          
  @pa_errmsg  varchar(8000) output          
)          
AS          
    
BEGIN      
  
       
 IF exists (select 1 from holiday_mstr where convert(vARCHAR(11),HOLM_DT ,109) = convert(vARCHAR(11),GETDATE() ,109) AND HOLM_DELETED_IND = 1)    
 BEGIN          
  SET @pa_errmsg =  'Today is declared as holiday. DIS request not allowed. '+  
isnull((select top 1 HOLM_DESC from holiday_mstr where convert(vARCHAR(11),HOLM_DT ,109)   
= convert(vARCHAR(11),GETDATE() ,109) AND HOLM_DELETED_IND = 1),'') + '|*~|1'          
   
  RETURN          
 END    
 
 if ('Sunday'=datename(dw,getdate()) )  
 begin
 SET @pa_errmsg =  '1'+ '|*~|Today is sunday as holiday. DIS request not allowed.|*~|1'  
 return
 end
          
          
DECLARE @@AllSlipused char(1),          
@@series varchar(10),          
@@date_cr   datetime,          
@l_dpm_id   varchar(20),          
@@sr_no     varchar(25),          
@@acct_no   varchar(50) ,        
@@cmbp_id   varchar(25),        
@l_uses_id  numeric(10,0),        
@l_trans    varchar(50),  
@l_loginentid  numeric(10,0)      
        
 select @l_loginentid = logn_ent_id from login_names where logn_name =''+ @pa_login_name +''  
          
 SET @@series = ''          
 IF @trans_code = '1'              
 BEGIN              
 --              
 SET @trans_code  = '1'               
 --              
 END              
 ELSE IF @trans_code = 'DEMRM_SEL'          
 BEGIN          
 --          
 SET @trans_code  = '901'           
 --          
 END          
 ELSE IF @trans_code = 'REMRM_SEL'          
 BEGIN          
 --          
 SET @trans_code  = '902'           
 --          
 END          
 ELSE IF @trans_code = 'INT_DP_TRX_SEL'          
 BEGIN          
 --          
 If Exists (Select Slibm_id from slip_book_mstr where SLIBM_TRATM_ID='638'           
 AND ISNULL(SLIBM_SERIES_TYPE,'') = SUBSTRING(@slipno,1,LEN(ISNULL(SLIBM_SERIES_TYPE,'')))        
 AND ISNUMERIC(SUBSTRING(@slipno,LEN(ISNULL(SLIBM_SERIES_TYPE,''))+1,LEN(@slipno)) ) = 1        
 AND CONVERT(NUMERIC,SUBSTRING(@slipno,LEN(ISNULL(SLIBM_SERIES_TYPE,''))+1,LEN(@slipno))) BETWEEN SLIBM_FROM_NO AND SLIBM_TO_NO         
 AND SLIBM_DELETED_IND=1)        
 Begin         
  SET @trans_code  = '925'          
 End        
    Else        
 Begin         
  --added by vishal for blocking interdp slip in account transfer depending on client requirement        
  --SET @trans_code  = '904_ACT'         
  if not exists(select BITRM_ID from bitmap_ref_mstr where bitrm_parent_cd = 'BLCKINT_DP_IN_ACT_TRF' and bitrm_values = 1)        
  begin        
   SET @trans_code  = '904_ACT'         
  end        
  else        
  begin        
   SET @trans_code  = '925'          
  end        
  --added by vishal for blocking interdp slip in account transfer depending on client requirement        
 End        
        
        
 --          
 END          
 ELSE IF @trans_code = 'INT_DP_R_TRX_SEL'          
  BEGIN          
  --          
  SET @trans_code  = '926'          
         
  --          
 END          
 ELSE IF @trans_code = 'P2P_DP_TRX_SEL'          
 BEGIN          
 --          
 SET @trans_code  = '934'         
 SET @l_trans     = 'P2P_DP_TRX_SEL'          
 --          
 END          
 ELSE IF @trans_code = 'ONC2P_DP_TRX_SEL'          
 BEGIN          
 --          
 SET @trans_code  = '904_ACT'          
 --          
 END           
 ELSE IF @trans_code = 'ONC2P_R_DP_TRX_SEL'          
 BEGIN          
  --          
  SET @trans_code  = '905_ACT'          
  --          
 END           
 ELSE IF @trans_code = 'ONP2C_DP_TRX_SEL'          
 BEGIN          
 --          
 SET @trans_code  = '904_P2C'          
 SET @l_trans     = 'ONP2C_DP_TRX_SEL'          
 --          
 END          
 ELSE IF @trans_code = 'OFFM_DP_TRX_SEL'          
 BEGIN          
 --          
 SET @trans_code  = '904_ACT'           
 --          
 END        
 ELSE IF @trans_code = 'OFFM_R_DP_TRX_SEL'          
  BEGIN          
  --          
  SET @trans_code  = '905_ACT'           
  --          
 END          
 ELSE IF @trans_code = 'DELOUT_DP_TRX_SEL_R'          
 BEGIN          
 --          
 SET @trans_code  = '906'           
 --          
 END          
 ELSE IF @trans_code = 'DELOUT_DP_TRX_SEL_I'          
 BEGIN          
 --          
 SET @trans_code  = '906'           
 --          
 END          
 ELSE IF @trans_code = 'INTERSETM_TRX_SEL'          
 BEGIN          
 --          
 SET @trans_code  = '907'         
 SET @l_trans     = 'INTERSETM_TRX_SEL'          
 --          
 END          
 ELSE        
 BEGIN        
 --        
   SET @trans_code  = ''         
 --        
 END        
        
          
 SELECT @l_dpm_id  = dpm_id from dp_mstr where dpm_dpid  = @dpid and dpm_deleted_ind  = 1       
           
 IF @trans_code  = '1'         
 BEGIN        
 --        
   
   SELECT @@series=ltrim(rtrim(ISNULL(SLIBM_SERIES_TYPE,'')))           
   from slip_book_mstr          
        ,transaction_sub_type_mstr          
        ,transaction_type_mstr        
   WHERE  (trastm_cd          = @trans_code   or     trastm_cd          ='POASLIP')    
   AND    SLIBM_tratm_id     = trastm_id          
   AND    trantm_id          = trastm_tratm_id        
   AND    trantm_code        = 'SLIP_TYPE_CDSL'        
   AND    SLIBM_DPM_ID    = @l_dpm_id           
   AND    @slipno like ltrim(rtrim(slibm_series_type)) + '%' AND SLIBM_DELETED_IND =1          
   AND    ISNULL(SLIBM_SERIES_TYPE,'')    <> ''        
--    print @@series    
 --        
 END     
 ELSE IF @trans_code not in ('901','902')        
  BEGIN        
 --       
--print('b')     
   SELECT @@series=ltrim(rtrim(ISNULL(SLIBM_SERIES_TYPE,'')))           
   from slip_book_mstr          
        ,transaction_sub_type_mstr           
        ,transaction_type_mstr        
   WHERE          
            trastm_cd        = @trans_code  --in (select Case when @trans_code  ='904_ACT' Then ('904_ACT','925') else @trans_code end)        
   AND    SLIBM_tratm_id     = trastm_id         
   AND    trantm_id          = trastm_tratm_id        
   AND    trantm_code        = 'SLIP_TYPE_NSDL'        
   AND    SLIBM_DPM_ID    = @l_dpm_id           
   AND   @slipno like ltrim(rtrim(slibm_series_type)) + '%' AND SLIBM_DELETED_IND =1         
   and   ltrim(rtrim(isnull(slibm_series_type,'')))  <> ''        
        
 --        
 END        
          
 SET @@sr_no = REPLACE(@slipno,@@series,'')          
     --print 'tushar'    
--print @@sr_no    
--print @trans_code    
 IF ISNUMERIC(@@sr_no) = 0  and @trans_code not in ('901','902')        
 BEGIN          
  SET @pa_errmsg =  'Invalid Slip No.' + '|*~|1'          
 print @pa_errmsg  
  RETURN          
 END          
 --print 'pankaj'        
--print @accountno   
 --print @trans_code  
 IF @accountno <> ''      
 BEGIN       
       
  if @trans_code not in ('901','902')        
  
  SELECT distinct @@AllSlipused = sliim_all_used          
       , @@cmbp_id     = accp_value              
  FROM   slip_issue_mstr           
  ,      transaction_sub_type_mstr          
  ,      dp_acct_mstr  left outer join        
         account_properties on accp_clisba_id = dpam_id and accp_deleted_ind = 1  and accp_accpm_prop_cd = 'CMBP_iD'  and isnull(accp_value ,'') <> ''        
  WHERE  trastm_cd          = @trans_code            
  AND    sliim_dpam_acct_no = @accountno         
  AND    sliim_tratm_id     = trastm_id          
  AND    sliim_dpam_acct_no = dpam_sba_no        
  AND    sliim_dpm_id       = @l_dpm_id          
  AND    sliim_series_type  = @@series    
  and    isnumeric(@@sr_no)=1        
 -- AND    convert(bigint,@@sr_no) between convert(bigint,sliim_slip_no_fr) and convert(bigint,sliim_slip_no_to)          
  AND    convert(numeric,@@sr_no) between sliim_slip_no_fr and sliim_slip_no_to    
  AND    trastm_deleted_ind = 1         
  
  
  IF isnull(@@AllSlipused,'') = '' and @trans_code not in ('901','902')        
  BEGIN          
  set @pa_errmsg = 'Slip no. not issued to selected client' + '|*~|1'         
  print   @pa_errmsg   
  RETURN        
  END          
      --print 'shilpa'    
  --if not exists(select INWSR_SLIP_NO , inwsr_trastm_cd from INWARD_SLIP_REG where inwsr_trastm_cd = @trans_code and INWSR_SLIP_NO = @slipno and INWSR_DELETED_IND = 1 )        
  --  and  exists(select bitrm_id from bitmap_ref_mstr where bitrm_parent_cd = 'INWRD_SLIP_VLD_YN' and bitrm_deleted_ind = 1)  AND @PA_LOGIN_NAME <> '*****'        
  --  and  @trans_code not in ('901','902')        
  --begin        
  --    print 'sss'  
  --   set @pa_errmsg = 'Slip no. not entered in Inward Slip Register ' + '|*~|1'         
        
  --   return          
  --end      
  IF @@AllSlipused = '1'  and @trans_code not in ('901','902')        
  BEGIN      
    
--print('c')        
  set @pa_errmsg = 'Slip no. has already been used' + '|*~|1'          
       print   @pa_errmsg   
  RETURN        
  END          
  ELSE          
  BEGIN          
     print '1121212'      
    IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE   uses_trantm_id = @trans_code     
              and isnumeric(USES_SLIP_NO )  = 1       
              --and convert(numeric,USES_SLIP_NO) = convert(numeric,@@sr_no)    
              AND USES_SLIP_NO = @@sr_no    
             -- and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1        
              AND uses_trantm_id NOT IN ('901','902') and USES_USED_DESTR = 'U'       
             )          
    BEGIN         
     set @pa_errmsg =  'Slip no. has already been used' + '|*~|1'          
  print @pa_errmsg  
     RETURN        
    END        
    else IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE   left(uses_trantm_id,3) = left(@trans_code,3)   and isnumeric(USES_SLIP_NO )  = 1       
              --and convert(numeric,USES_SLIP_NO) = convert(numeric,@@sr_no)    
              AND USES_SLIP_NO = @@sr_no    
              --and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1        
              AND uses_trantm_id NOT IN ('901','902') and USES_USED_DESTR = 'B'       
             )          
    BEGIN         
  
     set @pa_errmsg =  'Slip no. has already been Blocked' + '|*~|1'          
print @pa_errmsg  
     RETURN        
    END          
    else IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE   left(uses_trantm_id,3) = left(@trans_code,3)   and isnumeric(USES_SLIP_NO )  = 1       
             -- and convert(numeric,USES_SLIP_NO) = convert(numeric,@@sr_no)    
              AND USES_SLIP_NO = @@sr_no    
             -- and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1        
              AND uses_trantm_id NOT IN ('901','902') and USES_USED_DESTR = 'D'       
             )          
    BEGIN         
     set @pa_errmsg =  'Slip no. has already been Destroyed' + '|*~|1'          
print @pa_errmsg  
     RETURN        
    END          
  
    else IF EXISTS(SELECT uses_slip_no FROM used_slip_block WHERE   isnumeric(USES_SLIP_NO )  = 1       
             -- and convert(numeric,USES_SLIP_NO) = convert(numeric,@@sr_no)    
              AND USES_SLIP_NO = @@sr_no    
              and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1        
               and USES_SUCCESS_FLAG = 'S'       
             )          
    BEGIN         
     set @pa_errmsg =  'Slip no. has already been Cancelled' + '|*~|1'          
print @pa_errmsg  
     RETURN        
    END   
  
    ELSE IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE   left(uses_trantm_id,3) = left(@trans_code,3)   and isnumeric(USES_SLIP_NO )  = 1     
            --  and convert(numeric,USES_SLIP_NO ) = convert(numeric,@@sr_no)     
              AND USES_SLIP_NO = @@sr_no    
              --and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1 AND uses_trantm_id IN ('901','902')    and  USES_USED_DESTR = 'U'       
              AND NOT EXISTS (SELECT DEMRM_SLIP_SERIAL_NO FROM DEMAT_REQUEST_MSTR WHERE DEMRM_SLIP_SERIAL_NO = LTRIM(RTRIM(@@series))+LTRIM(RTRIM(@@SR_NO)) AND (ISNULL(DEMRM_INTERNAL_REJ,'') <> '' or isnull(DEMRM_COMPANY_OBJ,'') <> '' ))          
             )          
    BEGIN       
    
     set @pa_errmsg =  'Slip no. has already been used' + '|*~|1'          
print @pa_errmsg  
     RETURN        
    END          
    ELSE IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE   left(uses_trantm_id,3) = left(@trans_code,3)   and isnumeric(USES_SLIP_NO )  = 1     
              -- and convert(numeric,USES_SLIP_NO ) = convert(numeric,@@sr_no)     
              AND USES_SLIP_NO = @@sr_no     
             -- and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1 AND uses_trantm_id IN ('901','902')    and  USES_USED_DESTR = 'B'       
              AND NOT EXISTS (SELECT DEMRM_SLIP_SERIAL_NO FROM DEMAT_REQUEST_MSTR WHERE DEMRM_SLIP_SERIAL_NO = LTRIM(RTRIM(@@series))+LTRIM(RTRIM(@@SR_NO)) AND (ISNULL(DEMRM_INTERNAL_REJ,'') <> '' or isnull(DEMRM_COMPANY_OBJ,'') <> '' ))          
                         
  )          
    BEGIN       
    
     set @pa_errmsg =  'Slip no. has already been Blocked' + '|*~|1'          
print @pa_errmsg  
     RETURN        
    END       
     ELSE IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE   left(uses_trantm_id,3) = left(@trans_code,3)   and isnumeric(USES_SLIP_NO )  = 1     
             --  and convert(numeric,USES_SLIP_NO ) = convert(numeric,@@sr_no)     
              AND USES_SLIP_NO = @@sr_no     
              --and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1 AND uses_trantm_id IN ('901','902')    and  USES_USED_DESTR = 'D'       
              AND NOT EXISTS (SELECT DEMRM_SLIP_SERIAL_NO FROM DEMAT_REQUEST_MSTR WHERE DEMRM_SLIP_SERIAL_NO = LTRIM(RTRIM(@@series))+LTRIM(RTRIM(@@SR_NO)) AND (ISNULL(DEMRM_INTERNAL_REJ,'') <> '' or isnull(DEMRM_COMPANY_OBJ,'') <> '' ))          
             )          
    BEGIN       
    
     set @pa_errmsg =  'Slip no. has already been Destroyed' + '|*~|1'          
print @pa_errmsg  
     RETURN        
    END       
  
  
else IF EXISTS(SELECT uses_slip_no FROM used_slip_block WHERE   isnumeric(USES_SLIP_NO )  = 1       
             -- and convert(numeric,USES_SLIP_NO) = convert(numeric,@@sr_no)    
              AND USES_SLIP_NO = @@sr_no    
              and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1        
               and USES_SUCCESS_FLAG = 'S'       
             )          
    BEGIN         
     set @pa_errmsg =  'Slip no. has already been Cancelled' + '|*~|1'          
print @pa_errmsg  
     RETURN        
    END   
  
  
  
   IF exists(select 1 from Sebioldslipdata where SLIIM_SERIES_TYPE = @@series  and convert(numeric,@@sr_no) between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO)
begin 

set @pa_errmsg =  'As per SEBI circular DIS issued before 07.01.2014 has been blocked for execution.' + '|*~|1'          
print @pa_errmsg  
return 
end 


    IF EXISTS(  
    SELECT * FROM SLIP_ISSUE_MSTR WHERE   @@sr_no BETWEEN   SLIIM_SLIP_NO_FR and     SLIIM_SLIP_NO_TO and SLIIM_DELETED_IND=1  
    and SLIIM_SERIES_TYPE=@@series and isnull(SLIIM_EXPIRY_DATE,'')<>'' 
--and  convert(varchar(11),SLIIM_EXPIRY_DATE,109)>=convert(varchar(11),getdate(),109)  
--and SLIIM_EXPIRY_DATE>=sliim_dt 
and SLIIM_EXPIRY_DATE<=getdate()
and isnull(sliim_success_flag,'')=''
             )          
    BEGIN         
     set @pa_errmsg =  'This is Old Slip and it is Blocked Now!' + '|*~|1'          
  print @pa_errmsg  
     RETURN        
    END   
  
    ELSE          
     BEGIN        
      IF @trans_code = 'INTERSETM_TRX_SEL'         
      BEGIN        
      --     
        
       IF exists(select fre_Dpam_id   
     from  freeze_unfreeze_dtls I  
         , dp_acct_mstr   
     where dpam_id = fre_Dpam_id   
     and right(dpam_sba_no,8) = @accountno   
     and dpam_deleted_ind = 1 and left(dpam_sba_no ,8) = @dpid  
     and fre_deleted_ind = 1 and fre_action<>'U' and fre_Isin_code=''
     and not exists (select fre_Dpam_id from freeze_unfreeze_dtls O where i.fre_Dpam_id=o.fre_Dpam_id
     and i.fre_Exec_date<o.fre_Exec_date and o.fre_action='U'))  
    BEGIN          
  set @pa_errmsg = ISNULL(@accountno,'') + ': Account Freezed|*~|1'          
print @pa_errmsg  
  RETURN        
    END     
      
     IF exists(select BLACM_PAN   
     from  blacklisted_client_mstr   
         , dp_acct_mstr , entity_properties  
     where entp_ent_id = dpam_crn_no  
     and entp_entpm_cd ='pan_gir_no'  
     and entp_value = BLACM_PAN  
     and right(dpam_sba_no,8) = @accountno   
     and dpam_deleted_ind = 1   
     and BLACM_DELETED_IND = 1 )  
    BEGIN          
  set @pa_errmsg = ISNULL(@accountno,'') + ': Account Banned|*~|1'          
print @pa_errmsg  
  RETURN        
    END     
      
     
             
        set @pa_errmsg = ISNULL(@accountno,'') + '|*~|0'  + '|*~|' + isnull(@@cmbp_id ,'')        
      --        
      END        
      ELSE        
      BEGIN        
      --    
       
      IF exists(select fre_Dpam_id   
     from  freeze_unfreeze_dtls   i
         , dp_acct_mstr   
     where dpam_id = fre_Dpam_id   
     and right(dpam_sba_no,8) = @accountno   
     and dpam_deleted_ind = 1 and left(dpam_sba_no ,8) = @dpid  
     and fre_deleted_ind = 1 and fre_action<>'U' and fre_Isin_code=''
     and not exists (select fre_Dpam_id from freeze_unfreeze_dtls O where i.fre_Dpam_id=o.fre_Dpam_id
     and i.fre_Exec_date<o.fre_Exec_date and o.fre_action='U')
     )
     
      
    BEGIN          
  set @pa_errmsg = ISNULL(@accountno,'') + ': Account Freezed|*~|1'          
print @pa_errmsg  
  RETURN        
    END     
      
    IF exists(select BLACM_PAN   
     from  blacklisted_client_mstr   
         , dp_acct_mstr , entity_properties  
     where entp_ent_id = dpam_crn_no  
     and entp_entpm_cd ='pan_gir_no'  
     and entp_value = BLACM_PAN  
     and right(dpam_sba_no,8) = @accountno   
     and dpam_deleted_ind = 1   
     and BLACM_DELETED_IND = 1 )  
    BEGIN          
  set @pa_errmsg = ISNULL(@accountno,'') + ': Account Banned|*~|1'          
print @pa_errmsg  
  RETURN        
    END     
      
      
        
--         IF LTRIM(RTRIM(ISNULL(@@ACCT_NO,''))) = ''   -- and   @trans_code <> 'POASLIP'      
--     BEGIN      
--  print '1'      
--   set @pa_errmsg = 'Slip no. not issued to client|*~|1'          
--   print @pa_errmsg  
--   RETURN        
--     END    
          
        set @pa_errmsg = ISNULL(@accountno,'') + '|*~|0'          
           
      --        
      END        
     END          
    END    
  
print 'ssssss'  
print @validateonly      
           
  IF (@validateonly <> 'Y')          
  BEGIN    
     
   select @l_uses_id = isnull(max(uses_id),0) + 1 from used_slip         
         print 'kkkkk'  
   INSERT INTO used_slip(USES_ID,USES_DPM_ID,USES_DPAM_ACCT_NO,USES_SLIP_NO,USES_TRANTM_ID,USES_SERIES_TYPE,USES_USED_DESTR,USES_CREATED_BY,USES_CREATED_DT,USES_LST_UPD_BY,USES_LST_UPD_DT,USES_DELETED_IND)          
   VALUES(@l_uses_id,@l_dpm_id,@accountno,@@sr_no,@trans_code,@@series,'U',@pa_login_name,getdate(),@pa_login_name,getdate(),1)           
   -- USES_ID IS HARDCODED, SHOULD BE INCREMENTAL           
   set @pa_errmsg =''          
  END          
    
 END          
    
 ELSE       
  print 'inelse'  
 IF  @accountno = ''   AND @trans_code not in ('901','902')        
     
BEGIN          
--PRINT 'DDD'  
  -- PRINT @l_dpm_id  
print 'mmmmmm'  

declare @l_dpam_id  numeric

   SELECT distinct @@acct_no = Right(ltrim(rtrim(sliim_dpam_acct_no)),8)          
        , @l_dpam_id     = DPAM_ID                  
   FROM   slip_issue_mstr           
   ,      transaction_sub_type_mstr          
   ,      dp_acct_mstr  
   --left outer join        
          --account_properties on accp_clisba_id = dpam_id and accp_deleted_ind = 1  
          --and accp_accpm_prop_cd = 'CMBP_iD'  AND    isnull(accp_value ,'') <> ''        
   WHERE  trastm_cd          = @trans_code           
   AND    sliim_tratm_id     = trastm_id          
   AND    dpam_sba_no       = sliim_dpam_acct_no        
   AND    sliim_dpm_id       = @l_dpm_id          
   AND    sliim_series_type  = @@series          
   AND    convert(bigint,@@sr_no) between convert(bigint,sliim_slip_no_fr) and convert(bigint,sliim_slip_no_to)          
   AND    sliim_deleted_ind  = 1          
   AND    trastm_deleted_ind = 1      
     --create index ix_slliim on slip_issue_mstr (sliim_dpm_id,sliim_dpam_acct_no) includes (sliim_series_type,sliim_deleted_ind)
     PRINT @@acct_no
     PRINT @l_dpam_id
     if @@acct_no <> ''
     BEGIN 
          select @@cmbp_id = accp_value from ACCOUNT_PROPERTIES where accp_clisba_id = @l_dpam_id and ACCP_DELETED_IND = 1 
     and accp_accpm_prop_cd = 'CMBP_iD'  AND    isnull(accp_value ,'') <> ''  
     PRINT @@cmbp_id
     END 
     
     
   IF LTRIM(RTRIM(ISNULL(@@ACCT_NO,''))) = '' 
   begin     
   SELECT distinct @@acct_no = Right(ltrim(rtrim(sliim_dpam_acct_no)),8)          
        , @l_dpam_id     = dpam_id                
   FROM   slip_issue_mstr           
   ,      transaction_sub_type_mstr          
   ,      dp_acct_mstr -- left outer join        
        --  account_properties on accp_clisba_id = dpam_id and accp_deleted_ind = 1  and accp_accpm_prop_cd = 'CMBP_iD'  AND    isnull(accp_value ,'') <> ''        
   WHERE  trastm_cd          = 'POASLIP'           
   AND    sliim_tratm_id     = trastm_id          
   AND    dpam_sba_no       = sliim_dpam_acct_no        
   AND    sliim_dpm_id       = @l_dpm_id          
   AND    sliim_series_type  = @@series          
   AND    convert(bigint,@@sr_no) between convert(bigint,sliim_slip_no_fr) and convert(bigint,sliim_slip_no_to)          
   AND    sliim_deleted_ind  = 1          
   AND    trastm_deleted_ind = 1  and  @trans_code = '1'   
   
   
   
   if @@acct_no <> ''
          select @@cmbp_id = accp_value from ACCOUNT_PROPERTIES where accp_clisba_id = @l_dpam_id and ACCP_DELETED_IND = 1 
     and accp_accpm_prop_cd = 'CMBP_iD'  AND    isnull(accp_value ,'') <> ''  
     
     
   end  
  
   IF LTRIM(RTRIM(ISNULL(@@ACCT_NO,''))) = ''     
   begin   
    
   SELECT distinct @@acct_no = SLIIM_DPAM_ACCT_NO  
        , @@cmbp_id     = ''                
   FROM   slip_issue_mstr_poa           
   WHERE  sliim_tratm_id     = '10000'          
   AND    sliim_dpm_id       = @l_dpm_id          
   AND    sliim_series_type  = @@series          
   AND    convert(bigint,@@sr_no) between convert(bigint,sliim_slip_no_fr) and convert(bigint,sliim_slip_no_to)          
   AND    sliim_deleted_ind  = 1          
      
    
  
   end   
       
         
--   IF LTRIM(RTRIM(ISNULL(@@ACCT_NO,''))) = ''   -- and   @trans_code <> 'POASLIP'      
--   BEGIN          
--print '2'  
--    set @pa_errmsg = 'Slip no. not issued to client|*~|1'          
--print @pa_errmsg  
--    RETURN        
--   END          
 --  ELSE          
   BEGIN          
        print 'ddddddddddddddddddddddddd'   
print @l_dpm_id   
         
    IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE   (left(uses_trantm_id,3) = left(@trans_code,3) or USES_DPAM_ACCT_NO = 'BOTH')     and isnumeric(USES_SLIP_NO )  = 1    
              --and convert(numeric,USES_SLIP_NO ) = convert(numeric,@@sr_no)     
    and USES_SLIP_NO  = @@sr_no  
             -- and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1        
              AND uses_trantm_id NOT IN ('901','902')   and  USES_USED_DESTR = 'U'     
             )          
    BEGIN         
     set @pa_errmsg =  'Slip no. has already been used' + '|*~|1'          
  print @pa_errmsg  
     RETURN        
    END  
    
  
    IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE   (left(uses_trantm_id,3) = left(@trans_code,3) or USES_DPAM_ACCT_NO = 'BOTH')   and isnumeric(USES_SLIP_NO )  = 1    
              --and convert(numeric,USES_SLIP_NO ) = convert(numeric,@@sr_no)     
and USES_SLIP_NO  = @@sr_no  
             -- and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1        
              AND uses_trantm_id NOT IN ('901','902')   and  USES_USED_DESTR = 'B'     
             )          
    BEGIN         
     set @pa_errmsg =  'Slip no. has already been Blocked' + '|*~|1'          
print @pa_errmsg  
     RETURN        
    END          
IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE   (left(uses_trantm_id,3) = left(@trans_code,3) or USES_DPAM_ACCT_NO = 'BOTH')   and isnumeric(USES_SLIP_NO )  = 1    
              --and convert(numeric,USES_SLIP_NO ) = convert(numeric,@@sr_no)     
and USES_SLIP_NO  = @@sr_no  
             -- and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1        
              AND uses_trantm_id NOT IN ('901','902')   and  USES_USED_DESTR = 'D'     
             )          
    BEGIN         
     set @pa_errmsg =  'Slip no. has already been Destroyed' + '|*~|1'          
print @pa_errmsg  
     RETURN        
    END          
    
  
    
    IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE   (left(uses_trantm_id,3) = left(@trans_code,3)   
     or USES_DPAM_ACCT_NO = 'BOTH')    and isnumeric(USES_SLIP_NO )  = 1    
              --and convert(numeric,USES_SLIP_NO ) = convert(numeric,@@sr_no)     
    and USES_SLIP_NO  = @@sr_no  
              --and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1 AND uses_trantm_id IN ('901','902')  and USES_USED_DESTR = 'U'       
              AND NOT EXISTS (SELECT DEMRM_SLIP_SERIAL_NO FROM DEMAT_REQUEST_MSTR WHERE DEMRM_SLIP_SERIAL_NO = LTRIM(RTRIM(@@series))+LTRIM(RTRIM(@@SR_NO)) AND (ISNULL(DEMRM_INTERNAL_REJ,'') <> '' or isnull(DEMRM_COMPANY_OBJ,'') <> '' ))          
             )          
    BEGIN         
     set @pa_errmsg =  'Slip no. has already been used' + '|*~|1'          
print @pa_errmsg  
     RETURN        
    END      
  
  
      
    IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE   (left(uses_trantm_id,3) = left(@trans_code,3) or USES_DPAM_ACCT_NO = 'BOTH')    and isnumeric(USES_SLIP_NO )  = 1    
              --and convert(numeric,USES_SLIP_NO ) = convert(numeric,@@sr_no)     
and USES_SLIP_NO  = @@sr_no  
              --and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1 AND uses_trantm_id IN ('901','902')    and USES_USED_DESTR = 'B'     
              AND NOT EXISTS (SELECT DEMRM_SLIP_SERIAL_NO FROM DEMAT_REQUEST_MSTR WHERE DEMRM_SLIP_SERIAL_NO = LTRIM(RTRIM(@@series))+LTRIM(RTRIM(@@SR_NO)) AND (ISNULL(DEMRM_INTERNAL_REJ,'') <> '' or isnull(DEMRM_COMPANY_OBJ,'') <> '' ))          
             )          
    BEGIN         
     set @pa_errmsg =  'Slip no. has already been Blocked' + '|*~|1'          
print @pa_errmsg  
     RETURN        
    END          
    IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE   (left(uses_trantm_id,3) = left(@trans_code,3) or USES_DPAM_ACCT_NO = 'BOTH')    and isnumeric(USES_SLIP_NO )  = 1    
             -- and convert(numeric,USES_SLIP_NO ) = convert(numeric,@@sr_no)     
and USES_SLIP_NO  = @@sr_no  
              --and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1 AND uses_trantm_id IN ('901','902')    and USES_USED_DESTR = 'D'     
              AND NOT EXISTS (SELECT DEMRM_SLIP_SERIAL_NO FROM DEMAT_REQUEST_MSTR WHERE DEMRM_SLIP_SERIAL_NO = LTRIM(RTRIM(@@series))+LTRIM(RTRIM(@@SR_NO)) AND (ISNULL(DEMRM_INTERNAL_REJ,'') <> '' or isnull(DEMRM_COMPANY_OBJ,'') <> '' ))          
             )          
    BEGIN         
     set @pa_errmsg =  'Slip no. has already been Destroyed' + '|*~|1'          
print @pa_errmsg  
     RETURN        
    END          
        
  
else IF EXISTS(SELECT uses_slip_no FROM used_slip_block WHERE   isnumeric(USES_SLIP_NO )  = 1       
             -- and convert(numeric,USES_SLIP_NO) = convert(numeric,@@sr_no)    
              AND USES_SLIP_NO = @@sr_no    
              and uses_dpm_id = @l_dpm_id         
              and USES_SERIES_TYPE = @@series         
              and USES_DELETED_IND = 1        
               and USES_SUCCESS_FLAG = 'S'       
             )          
    BEGIN         
     set @pa_errmsg =  'Slip no. has already been Cancelled' + '|*~|1'          
print @pa_errmsg  
     RETURN        
    END   
  
    
    
   IF exists(select 1 from Sebioldslipdata where SLIIM_SERIES_TYPE = @@series  and convert(numeric,@@sr_no) between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO)
begin 

set @pa_errmsg =  'As per SEBI circular DIS issued before 07.01.2014 has been blocked for execution.' + '|*~|1'          
print @pa_errmsg  
return 
end 


    IF EXISTS(  
    SELECT * FROM SLIP_ISSUE_MSTR WHERE   convert(numeric,@@sr_no) BETWEEN    convert(numeric,SLIIM_SLIP_NO_FR) and   convert(numeric,SLIIM_SLIP_NO_TO) and SLIIM_DELETED_IND=1  
    and SLIIM_SERIES_TYPE=@@series and isnull(SLIIM_EXPIRY_DATE,'')<>'' 
--and  convert(varchar(11),SLIIM_EXPIRY_DATE,109)>=convert(varchar(11),getdate(),109)  
--and SLIIM_EXPIRY_DATE>=sliim_dt 
and SLIIM_EXPIRY_DATE<=getdate()
and isnull(sliim_success_flag,'')=''
             )          
    BEGIN         
     set @pa_errmsg =  'This is Old Slip and it is Blocked Now!' + '|*~|1'          
  print @pa_errmsg  
     RETURN        
    END     
    
    
        IF EXISTS(  
    SELECT * FROM SLIP_ISSUE_MSTR WHERE   convert(numeric,@@sr_no) BETWEEN    convert(numeric,SLIIM_SLIP_NO_FR) and   convert(numeric,SLIIM_SLIP_NO_TO) and SLIIM_DELETED_IND=1  
    and SLIIM_SERIES_TYPE=@@series and isnull(SLIIM_SUCCESS_FLAG,'')='' and sliim_dt>='Oct 01 2014'
--and  convert(varchar(11),SLIIM_EXPIRY_DATE,109)>=convert(varchar(11),getdate(),109)  
--and SLIIM_EXPIRY_DATE>=sliim_dt 


             )          
    BEGIN         
     set @pa_errmsg =  'Response file is not Imported For DIS issuance File Gen. of entered Slip!' + '|*~|1'          
  print @pa_errmsg  
     RETURN        
    END
     
        
      print 'shilpam'  
print @l_trans  
    IF @l_trans     = 'INTERSETM_TRX_SEL'    or @l_trans     = 'ONP2C_DP_TRX_SEL'    or @l_trans     = 'P2P_DP_TRX_SEL'           
 BEGIN        
 --     
  
      if    isnumeric(@@acct_no)=0 and @@acct_no = 'BOTH'  
      begin   
       set @pa_errmsg =  'Slip no. has already been issued for broking instruction only' + '|*~|1'          
print @pa_errmsg  
       RETURN     
      end   
      else   
      begin  
   
      set @pa_errmsg = ISNULL(@@acct_no,'') + '|*~|0' + '|*~|' + isnull(@@cmbp_id ,'')         
  
      RETURN        
      end  
      
      
       
      
 --        
 END        
 ELSE        
 BEGIN        
 --     
      if  isnumeric(@@acct_no)=0 and @@acct_no = 'BOTH'  
      begin   
       set @pa_errmsg =  'Slip no. has already been issued for broking instruction only' + '|*~|1'          
  
       RETURN     
      end   
      else   
      begin  
      --create clustered  index ix_11 on  freeze_unfreeze_dtls(fre_action,fre_Isin_code,fre_Dpam_id,fre_deleted_ind)  
      
       IF exists(select fre_Dpam_id   
     from  freeze_unfreeze_dtls   I
         , dp_acct_mstr   
     where dpam_id = fre_Dpam_id   
     and dpam_sba_no = case when len(@dpid)=16 then @dpid else  @dpid+@@acct_no  end 
     and dpam_deleted_ind = 1
     and fre_deleted_ind = 1 and fre_action<>'U' and fre_Isin_code=''
      and not exists (select fre_Dpam_id from freeze_unfreeze_dtls O where i.fre_Dpam_id=o.fre_Dpam_id
     and i.fre_Exec_date<o.fre_Exec_date and o.fre_action='U')
     )  
   BEGIN          
  set @pa_errmsg = ISNULL(@@acct_no,'') + ': Account Freezed|*~|1'          
  
  RETURN        
   END    

  if @l_loginentid = 1
  begin
  
  if exists(
  select 1 from [172.31.16.57].Crmdb_A.dbo.MOBILE_EMAIL_MODI,dp_acct_mstr with(nolock) where DPAM_BBO_CODE=BO_PARTYCODE 
  and  DPAM_SBA_NO= '' + @dpid + @@acct_no + '' and DPAM_DELETED_IND=1
  union
  select 1 from client_list_modified where clic_mod_action in ('FIRST EMAILID','FIRST MOBILENO','MOBILE SMS')
and clic_mod_deleted_ind=1  and  clic_mod_DPAM_SBA_NO= '' + @dpid + @@acct_no + ''
and convert (varchar(11),clic_mod_created_dt,103) between 
convert(varchar(11),getdate(),103) and convert(varchar(11),dateadd(month,-6,getdate()),103)
  )
  begin
	set @pa_errmsg = ISNULL(@@acct_no,'') + '|*~|' + ': Alert : Email/Mobile is change for this acount in Last Six Month|*~|2' -- 
	RETURN   
  end
  end
 --if @l_loginentid <> 1  
 -- begin  
 --  if exists(select dpoc_boid from dpclass_onl_clients where ClientCategory='BIL' and  dpoc_boid = '' + @dpid + @@acct_no + '')  
 --  begin  
 -- set @pa_errmsg = ISNULL(@@acct_no,'') + ': LAS Account, Can not Punch data|*~|1'   
 -- RETURN     
 --  end  
 --   end   
  
 --if @l_loginentid = 1  
 -- begin  
 --  if exists(select dpoc_boid from dpclass_onl_clients where ClientCategory='BIL' and  dpoc_boid = '' + @dpid + @@acct_no + '')  
 --  begin  
 -- set @pa_errmsg = ISNULL(@@acct_no,'') + '|*~|' + ': Alert : This is LAS Account|*~|2' -- Don't change meesage here as in front end message is being used as per character  
 -- RETURN     
 --  end  
 --   end   
      
  
-- for BA Demat A/c  

--declare @panno varchar(10)  
--set @panno=''  
--select @panno=entp_value from dp_acct_mstr , entity_properties where entp_ent_id=dpam_crn_no   
--and ENTP_ENTPM_CD='pan_gir_no'  
--and dpam_Deleted_ind=1 and entp_deleted_ind=1  
--and dpam_sba_no='' + @dpid + @@acct_no + ''  
----print @panno  
-- if @l_loginentid <> 1  
--  begin  
  
--   if exists(select Panno from View_DMAT_ClientMaster_ClientType where clienttype in ('REM','IFA','BAO','BAF') and Panno=@panno and isnull(Panno,'')<>'')  
--   begin  
--  set @pa_errmsg = ISNULL(@@acct_no,'') + ': This is BA demat account and hence DIS will be executed at HO only|*~|1'   
--  RETURN     
--   end  
--    end   
  
-- if @l_loginentid = 1  

--  begin  

--   if exists(select Panno from View_DMAT_ClientMaster_ClientType where clienttype in ('REM','IFA','BAO','BAF') and Panno =@panno and isnull(Panno,'')<>'')  
--   begin  

--  set @pa_errmsg = ISNULL(@@acct_no,'') + '|*~|' + ': Alert : This is a BA demat account and need compliance approval|*~|2' -- Don't change meesage here as in front end message is being used as per character  
--  RETURN     
--   end  
--    end   
-- for BA demat A/c       
      
      
    IF exists(select BLACM_PAN   
     from  blacklisted_client_mstr   
         , dp_acct_mstr , entity_properties  
     where entp_ent_id = dpam_crn_no  
     and entp_entpm_cd ='pan_gir_no'  
     and entp_value = BLACM_PAN  
     and right(dpam_sba_no,8) = @@acct_no   
     and dpam_deleted_ind = 1   
     and BLACM_DELETED_IND = 1 )  
    BEGIN          
  set @pa_errmsg = ISNULL(@@acct_no,'') + ': Account Banned|*~|1'          
  
  RETURN        
    END     
      SET @pa_errmsg = ISNULL(@@acct_no,'') + '|*~|0'          
  
      RETURN   
      end        
           
    END        
   END        
           
 END          
 
END

GO
