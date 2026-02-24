-- Object: FUNCTION citrus_usr.fn_get_high_val
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



CREATE   function [citrus_usr].[fn_get_high_val](@l_isin varchar(16),@l_qty numeric(18,3),@pa_validation varchar(50),@pa_acct_no varchar(16),@pa_request_date datetime)      
returns char(1)      
as      
begin      
--      
  declare @l_yn char(1)      
  declare @l_rate numeric(18,5)      
  , @l_max_high_val numeric(18,5)      
    
--  if len(@pa_acct_no) <> 16     
--  begin    
--       
--   IF @pa_validation = 'HIGH_VALUE'      
--	  begin      
--	   --      
--		  Select @l_max_high_val = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'HIGH_VAL_NSDL'    and bitrm_deleted_ind = 1      
--		          
--		  select top 1 @l_rate = clopm_nsdl_rt from CLOSING_LAST_NSDL   where clopm_isin_cd = @l_isin order by 1 desc        
--		            
--		  set @l_yn =  case when @l_qty * @l_rate >= @l_max_high_val then 'Y' ELSE 'N' END      
--	   --      
--	   end       
--   IF @pa_validation = 'DORMANT'      
--   begin      
--   --      
--	IF (LEFT(@PA_ACCT_NO,2)='IN')    
--	BEGIN     
--	    
--					IF EXISTS(    
--					SELECT TOP 1 NSDHM_DPAM_ID FROM NSDL_HOLDING_DTLS,ACCOUNT_PROPERTIES     
--					WHERE ACCP_VALUE = @PA_ACCT_NO    
--		AND NSDHM_BEN_ACCT_NO = ACCP_ACCT_NO    
--		AND NSDHM_TRANSACTION_DT >= DATEADD(M,-6,@PA_REQUEST_DATE) AND NSDHM_TRANSACTION_DT <= @PA_REQUEST_DATE    
--					AND ACCP_DELETED_IND=1    
--					)    
--		BEGIN    
--		  SET @L_YN =  'N'      
--		END    
--		ELSE    
--		BEGIN    
--		  SET @L_YN =  'Y'      
--		END    
--	    
--	END    
--	ELSE    
--	BEGIN     
--    
----                IF EXISTS(SELECT TOP 1 NSDHM_DPAM_ID FROM NSDL_HOLDING_DTLS     
----    WHERE NSDHM_BEN_ACCT_NO = @PA_ACCT_NO    
----    AND NSDHM_TRANSACTION_DT >= DATEADD(M,-6,@PA_REQUEST_DATE) AND NSDHM_TRANSACTION_DT <= @PA_REQUEST_DATE)    
----    BEGIN    
----      SET @L_YN =  'N'      
----    END    
----    ELSE    
----    BEGIN    
----      SET @L_YN =  'Y'      
----    END    
--    
--		IF EXISTS(SELECT TOP 1 CDSHM_DPAM_ID FROM cdsl_HOLDING_DTLS     
--		WHERE right(CDSHM_BEN_ACCT_NO,'8') = right(@PA_ACCT_NO,'8')    
--		AND CDSHM_TRAs_DT >= DATEADD(M,-6,@PA_REQUEST_DATE) AND CDSHM_TRAs_DT <= @PA_REQUEST_DATE)    
--		BEGIN    
--		  SET @L_YN =  'N'      
--		END    
--		ELSE    
--		BEGIN    
--		  SET @L_YN =  'Y'      
--		END    
--  
--	END    
--    
--      
--   --      
--   end       
--  end       
--  else    
--  begin    
--  --    
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
                 --select distinct @l_act_dt = convert(datetime,accp_value,103)     
                 --from account_properties with(nolock),dp_acct_mstr     with(nolock)
                 --where accp_accpm_prop_cd = 'BILL_START_DT' and dpam_id = accp_clisba_id   
                 --and right(dpam_sba_no,8) =right(@pa_acct_no,8)    
                 
                      
                 select distinct @l_act_dt = convert(datetime,left(BOActDt,2)+'/'+substring(BOActDt,3,2) + '/' +RIGHT(BOActDt,4) ,103)     
                 from dps8_pc1 
                 where right(boid,8) =right(@pa_acct_no,8)   
  
--    if exists(SELECT TOP 1 cdshm_dpam_id FROM CDSL_HOLDING_DTLS     
--    WHERE CDSHM_BEN_ACCT_NO = @pa_acct_no    
--    and CDSHM_TRAS_DT >= DATEADD(m,-6,@pa_request_date) and CDSHM_TRAS_DT <= @pa_request_date)    
--                 or (abs(datediff(m,@l_act_dt,@pa_request_date))<=6)   
--    begin    
--      set @l_yn =  'N'      
--    end    
--    else    
--    begin    
--     set @l_yn =  'Y'      
--    end    

		IF EXISTS(SELECT TOP 1 CDSHM_DPAM_ID FROM nondorclient   with (nolock)
		WHERE --right(CDSHM_BEN_ACCT_NO,'8') = right(@PA_ACCT_NO,'8')   
		CDSHM_BEN_ACCT_NO  =  @PA_ACCT_NO  )
		or datediff(mm,@l_act_dt,getdate()) < 6    
		BEGIN    
		  SET @L_YN =  'N'      
		END    
		ELSE    
		BEGIN    
		  SET @L_YN =  'Y'      
		END  
    
    
    --      
    end      
--  --    
--  end    
      
  return @l_yn      
--      
end

GO
