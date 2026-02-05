-- Object: PROCEDURE citrus_usr.pr_get_high_val_test
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_get_high_val_test](@l_isin varchar(16),@l_qty numeric(18,3),@pa_validation varchar(50),@pa_acct_no varchar(16),@pa_request_date datetime)      
as      
begin      
--      
  declare @l_yn char(1)      
  declare @l_rate numeric(18,5)      
  , @l_max_high_val numeric(18,5)      
    
  
       
     
   IF @pa_validation = 'HIGH_VALUE'      
    begin      
    --      
   Select @l_max_high_val = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'HIGH_VAL_CDSL'    and bitrm_deleted_ind = 1      
           
   select top 1 @l_rate = CLOPM_CDSL_RT from CLOSING_LAST_CDSL   where CLOPM_ISIN_CD = @l_isin order by 1 desc        
             
   set @l_yn =  case when abs(@l_qty) * @l_rate >= @l_max_high_val then 'Y' ELSE 'N' END      
    --      
    end       
    IF @pa_validation = 'DORMANT'      
    begin      
    --     
                 declare @l_act_dt datetime     
                 select distinct @l_act_dt = convert(datetime,accp_value,103)     
                 from account_properties ,dp_acct_mstr     
                 where accp_accpm_prop_cd = 'BILL_START_DT' and dpam_id = accp_clisba_id   
                 and right(dpam_sba_no,8) =right(@pa_acct_no,8)       
   


		IF EXISTS(SELECT TOP 1 CDSHM_DPAM_ID FROM cdsl_HOLDING_DTLS     with (nolock)
		WHERE right(CDSHM_BEN_ACCT_NO,'8') = right(@PA_ACCT_NO,'8')    
		AND CDSHM_TRAs_DT >= DATEADD(M,-6,@PA_REQUEST_DATE) AND CDSHM_TRAs_DT <= @PA_REQUEST_DATE)    
		BEGIN    
		  SET @L_YN =  'N'      
		END    
		ELSE    
		BEGIN    
		  SET @L_YN =  'Y'      
		END  
    
    
    --      
    end      
   
      
  select @l_yn      
--      
end

GO
