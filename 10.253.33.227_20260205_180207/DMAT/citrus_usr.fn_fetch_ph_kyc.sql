-- Object: FUNCTION citrus_usr.fn_fetch_ph_kyc
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_fetch_ph_kyc](@PA_TAB VARCHAR(25),@pa_id numeric,@pa_ph_count int,@pa_ind_yn char(1),@pa_from_dt varchar(20),@pa_to_dt varchar(20))      
returns varchar(8000)      
as      
begin      
--      
  declare @l_value varchar(8000)      
  ,@l_crn_no numeric
  SELECT @l_crn_no = dpam_crn_no FROM dp_acct_mstr WHERE dpam_id = @pa_id
  IF @PA_TAB = 'pri'    
  begin    
      
      
   if @pa_ind_yn = 'Y'       
   begin      
  if @pa_ph_count = 1      
  set @l_value  =  case when ( isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_tele1' ) ,'') <> '' or isnull(citrus_usr.fn_dp_import_conc(@l_crn_no,'RES_PH1'),'')<>'' ) then 'R'       
       else case when (isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_mobile'),'') <> '') then 'M' else '' end end       
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_mobile'),'') <> '' OR isnull(citrus_usr.fn_dp_import_conc(@l_crn_no,'MOBILE1'),'') <> '' then 'M'  else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'ACCOFF_PH1'),'') <> '' OR  isnull(citrus_usr.fn_dp_import_conc(@l_crn_no,'OFF_PH1'),'')<> '' then 'O'  else '' end       
                               
       
   end       
   else       
   begin      
    if @pa_ph_count = 1      
    set @l_value  =  CASE WHEN isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_tele1'),'') <> ''  or isnull(citrus_usr.fn_dp_import_conc(@l_crn_no,'RES_PH1'),'') <> ''  then
                               case when  isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_tele1'),'') <> ''  
									then isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_tele1'),'')   
							   when  isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_tele1'),'') = ''  
									then isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_tele1'),'')  
							   end    
							   else 
                          		  case when isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_mobile'),'') <> '' 
                          					then isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_mobile'),'') 
                          			   when  isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_mobile'),'') = ''  
											then isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_mobile'),'')  
                          			   else '' 
                          		  end 
                                    
                           end    
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_mobile'),'') <> '' 
                        then isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_mobile'),'')  
                        when  isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_mobile'),'') = '' 
                        then isnull(citrus_usr.Fn_To_GetKYC(0,@pa_id,@pa_from_dt,@pa_to_dt,'cm_mobile'),'')  
                        else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'ACCOFF_PH1'),'') <> '' 
                        then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'ACCOFF_PH1'),'')  
                        when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'ACCOFF_PH1'),'') = '' 
                        then isnull(citrus_usr.fn_dp_import_conc(@l_crn_no,'OFF_PH1'),'')  
                        else '' end       
   end      
  end    
  else if @PA_TAB = 'NRI_F'    
  begin    
  --    
    if @pa_ind_yn = 'Y'       
   begin      
  if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NRI_RES'),'') <> '' then 'R'       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NRI_MOB'),'') <> '' then 'M' else '' end end       
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NRI_MOB'),'') <> '' then 'M'  else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NRI_OFF'),'') <> '' then 'O'  else '' end       
                               
       
   end       
   else       
   begin      
    if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NRI_RES'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NRI_RES'),'')       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NRI_MOB'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NRI_MOB'),'') else '' end end      
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NRI_MOB'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NRI_MOB'),'')    else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NRI_OFF'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NRI_OFF'),'')  else '' end       
   end      
  --    
  end    
  else if @PA_TAB = 'SH'    
  begin    
  --    
    if @pa_ind_yn = 'Y'       
   begin      
  if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_PH1'),'') <> '' then 'R'       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_MOBILE'),'') <> '' then 'M' else '' end end       
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_MOBILE'),'') <> '' then 'M'  else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_OFF1'),'') <> '' then 'O'  else '' end       
                               
       
   end       
   else       
   begin      
    if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_PH1'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_PH1'),'')       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_MOBILE'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_MOBILE'),'') else '' end end      
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_MOBILE'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_MOBILE'),'')    else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_OFF1'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_OFF1'),'')  else '' end       
   end      
  --    
  end    
  else if @PA_TAB = 'TH'    
  begin    
  --    
    if @pa_ind_yn = 'Y'       
   begin      
  if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_PH1'),'') <> '' then 'R'       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_MOBILE'),'') <> '' then 'M' else '' end end       
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_MOBILE'),'') <> '' then 'M'  else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_OFF1'),'') <> '' then 'O'  else '' end       
                               
       
   end       
   else       
   begin      
    if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_PH1'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_PH1'),'')       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_MOBILE'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_MOBILE'),'') else '' end end      
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_MOBILE'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_MOBILE'),'')    else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_OFF1'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_OFF1'),'')  else '' end       
   end      
  --    
  end    
  else if @PA_TAB = 'SH_POA'    
  begin    
  --    
    if @pa_ind_yn = 'Y'       
   begin      
  if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_POA_RES'),'') <> '' then 'R'       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_POA_MOB'),'') <> '' then 'M' else '' end end       
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_POA_MOB'),'') <> '' then 'M'  else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_POA_OFF'),'') <> '' then 'O'  else '' end       
                               
       
   end       
   else       
   begin      
    if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_POA_RES'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_POA_RES'),'')       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_POA_MOB'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_POA_MOB'),'') else '' end end      
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_POA_MOB'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_POA_MOB'),'')    else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_POA_OFF'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'SH_POA_OFF'),'')  else '' end       
   end      
  --    
  end    
 else if @PA_TAB = 'TH_POA'    
  begin    
  --    
    if @pa_ind_yn = 'Y'       
   begin      
  if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_POA_RES'),'') <> '' then 'R'       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_POA_MOB'),'') <> '' then 'M' else '' end end       
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_POA_MOB'),'') <> '' then 'M'  else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_POA_OFF'),'') <> '' then 'O'  else '' end       
                               
       
   end       
   else       
   begin      
    if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_POA_RES'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_POA_RES'),'')       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_POA_MOB'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_POA_MOB'),'') else '' end end      
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_POA_MOB'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_POA_MOB'),'')    else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_POA_OFF'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'TH_POA_OFF'),'')  else '' end       
   end      
  --    
  end    
  else if @PA_TAB = 'NOMINEE'    
  begin    
  --    
    if @pa_ind_yn = 'Y'       
   begin      
  if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOMINEE_PH1'),'') <> '' then 'R'       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOMINEE_MOBILE'),'') <> '' then 'M' else '' end end       
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOMINEE_MOBILE'),'') <> '' then 'M'  else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOMINEE_OFF'),'') <> '' then 'O'  else '' end       
                               
       
   end       
   else       
   begin      
    if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOMINEE_PH1'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOMINEE_PH1'),'')       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOMINEE_MOBILE'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOMINEE_MOBILE'),'') else '' end end      
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOMINEE_MOBILE'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOMINEE_MOBILE'),'')    else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOMINEE_OFF'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOMINEE_OFF'),'')  else '' end       
   end      
  --    
  end    
  else if @PA_TAB = 'GUARD'    
  begin    
  --    
    if @pa_ind_yn = 'Y'       
   begin      
  if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'GUARD_RES'),'') <> '' then 'R'       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'GUARD_MOB'),'') <> '' then 'M' else '' end end       
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'GUARD_MOB'),'') <> '' then 'M'  else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'GUARD_OFF'),'') <> '' then 'O'  else '' end       
                               
       
   end       
   else       
   begin      
    if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'GUARD_RES'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'GUARD_RES'),'')       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'GUARD_MOB'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'GUARD_MOB'),'') else '' end end      
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'GUARD_MOB'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'GUARD_MOB'),'')    else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'GUARD_OFF'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'GUARD_OFF'),'')  else '' end       
   end      
  --    
  end    
  else if @PA_TAB = 'NOM_GUARD'    
  begin    
  --    
    if @pa_ind_yn = 'Y'       
   begin      
  if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOM_GUARD_RES'),'') <> '' then 'R'       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOM_GUARD_MOB'),'') <> '' then 'M' else '' end end       
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOM_GUARD_MOB'),'') <> '' then 'M'  else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOM_GUARD_OFF'),'') <> '' then 'O'  else '' end       
                               
       
   end       
   else       
   begin      
    if @pa_ph_count = 1      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOM_GUARD_RES'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOM_GUARD_RES'),'')       
       else case when isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOM_GUARD_MOB'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOM_GUARD_MOB'),'') else '' end end      
       
    if @pa_ph_count = 2      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOM_GUARD_MOB'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOM_GUARD_MOB'),'')    else '' end       
       
  if @pa_ph_count = 3      
  set @l_value  =  case when  isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOM_GUARD_OFF'),'') <> '' then isnull(citrus_usr.fn_acct_conc_value(@pa_id,'NOM_GUARD_OFF'),'')  else '' end       
   end      
  --    
  end    
    
  return @l_value       
--      
end

GO
