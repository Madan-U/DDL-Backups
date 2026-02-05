-- Object: PROCEDURE citrus_usr.pr_valid_dormain_highvalue_bak02032012
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE  procedure [citrus_usr].[pr_valid_dormain_highvalue_bak02032012](@pa_id numeric,@pa_action varchar(100), @pa_dtls_id varchar(100),@pa_output varchar(8000) output)      
as      
begin      
      
declare @l_dpam_acct_no varchar(25)      
, @l_req_dt datetime      
, @l_excsm_id numeric      
, @l_excsm_cd  varchar(80)      
, @l_dpm_id numeric      
, @l_isin   varchar(50)      
, @l_qty    numeric(18,3)      
select @l_excsm_id = dpm_excsm_id , @l_dpm_id = dpm_id from dp_mstr where dpm_excsm_id = default_dp and dpm_excsm_id = @pa_id and dpm_deleted_ind = 1      
select @l_excsm_cd = excsm_exch_cd from exch_seg_mstr where excsm_id = @l_excsm_id and excsm_deleted_ind = 1      
      
      
      
  print @pa_dtls_id    
if citrus_usr.ufn_countstring(@pa_dtls_id,'|') = 1       
begin       
      
declare @l_out varchar(100)      
declare @l_dtls_id varchar(100)      
declare @l_login varchar(100)      
     
set @l_dtls_id  = citrus_usr.fn_splitval_by(@pa_dtls_id,1,'|')      
set @l_login    = citrus_usr.fn_splitval_by(@pa_dtls_id,2,'|')      
--      
--exec [pr_chk_app_lmt_nsdl] @pa_id ='0',@pa_dtls_id =@l_dtls_id      
--,@pa_loginname =@l_login,@pa_req_dt ='',  @pa_output=@l_out outPUT       
  
  
exec [pr_chk_app_level_cdsl] @pa_id ='0',@pa_dtls_id =@l_dtls_id,@pa_loginname =@l_login,@pa_req_dt =''
,  @pa_output=@l_out outPUT       
     
set @pa_output = @l_out   
    print @pa_output
return       
    
      
end       
      
      
      
if @l_excsm_cd = 'CDSL'      
begin       
 select @l_dpam_acct_no  =  dpam_sba_no       
       ,@l_req_dt        =  dptdc_request_dt      
 from dp_acct_mstr       
    , dp_trx_dtls_cdsl       
 where dptdc_dpam_id = dpam_id       
 and dptdc_dtls_id = @pa_dtls_id       
 and dpam_dpm_id = @l_dpm_id       
 and dptdc_deleted_ind = 1       
 and dpam_deleted_ind = 1      
      
end       
      
if @l_excsm_cd = 'NSDL'      
begin       
 select @l_dpam_acct_no  =  dpam_sba_no       
       ,@l_req_dt        =  dptd_request_dt      
 from dp_acct_mstr       
    , dp_trx_dtls      
 where dptd_dpam_id = dpam_id       
 and dptd_dtls_id = @pa_dtls_id       
 and dpam_dpm_id = @l_dpm_id       
 and dptd_deleted_ind = 1       
 and dpam_deleted_ind = 1      
      
end       
      
if @pa_action = 'DORMENT'      
select @pa_output = citrus_usr.fn_get_high_val('',0,'DORMANT',@pa_dtls_id,getdate())      
      
if @pa_action = 'HIGH' and @l_excsm_cd = 'NSDL'       
begin       
 if exists(select dptd_dtls_id from dptd_mak where citrus_usr.fn_get_high_val(dptd_isin,abs(dptd_qty),'HIGH_VALUE','','') = 'Y' and dptd_dtls_id = @pa_dtls_id and dptd_deleted_ind in (0,-1))      
 begin      
 set @pa_output = 'Y'      
 end       
 else      
 begin       
 set @pa_output = 'N'      
 end       
end      
if @pa_action = 'HIGH' and @l_excsm_cd = 'CDSL'       
begin       
 if exists(select dptdc_dtls_id from dp_trx_dtls_cdsl where citrus_usr.fn_get_high_val(dptdc_isin,abs(dptdc_qty),'HIGH_VALUE','','') = 'Y' and dptdc_dtls_id = @pa_dtls_id and dptdc_deleted_ind = 1)      
 begin      
 set @pa_output = 'Y'      
 end       
 else      
 begin       
 set @pa_output = 'N'      
 end       
end      
      
print @pa_output       
      
      
end

GO
