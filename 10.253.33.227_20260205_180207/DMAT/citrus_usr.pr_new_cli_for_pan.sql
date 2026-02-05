-- Object: PROCEDURE citrus_usr.pr_new_cli_for_pan
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--begin tran  
--exec pr_new_cli_for_pan '1203270000252635','AMEPA0491M','1203270000252620','AAMHR0772A'  
--rollback  
--select * from DP_ACCT_MSTR WHERE DPAM_SBA_NO IN ('1203270000252635','1203270000252620')  
--select * from entity_properties where entp_ent_id in (7900,3970075)  
CREATE proc [citrus_usr].[pr_new_cli_for_pan](@pa_sba_1 varchar(16)  
,@pa_pan_1 varchar(20)  
,@pa_sba_2 varchar(16)  
,@pa_pan_2 varchar(20))  
as  
begin  
  
declare @l_crn1 numeric  
,@l_crn2 numeric  
,@l_newcrn_1 numeric  
,@L_CLIENT_VALUES varchar(1000)  
,@L_ENTP_VALUE varchar(1000)  
,@L_ENTPD_VALUE varchar(1000)  
,@L_ADR  varchar(1000)  
  
set @L_ENTP_VALUE = ''  
  
select @l_crn1 = dpam_crn_no from dp_acct_mstr where dpam_sba_no = @pa_sba_1 and dpam_deleted_ind =1   
select @l_crn2 = dpam_crn_no from dp_acct_mstr where dpam_sba_no = @pa_sba_2 and dpam_deleted_ind =1  
  
  
if @l_crn1= @l_crn2  
begin  
  
  set @l_newcrn_1 = 0  
    
  SELECT  @L_CLIENT_VALUES = ISNULL(ltrim(rtrim(dpam_sba_name)),'')  
           + '|*~|' + '|*~||*~|' + ISNULL(ltrim(rtrim(dpam_sba_name)),'')  
           + '|*~||*~||*~||*~|ACTIVE|*~||*~|1|*~|' + ISNULL(ltrim(rtrim(@pa_pan_1)),'') +'|*~|*|~*'   
           FROM dp_Acct_mstr WHERE dpam_sba_no = @pa_sba_1  
  
  
  IF NOT EXISTS(SELECT entp_ent_id FROM dp_acct_mstr,entity_properties WHERE dpam_sba_no = @pa_sba_1   
  AND dpam_crn_no =entp_ent_id AND entp_entpm_cd = 'pan_gir_no' AND entp_value =  @pa_pan_1 AND entp_deleted_ind = 1)  
  EXEC pr_ins_upd_clim  '0','INS','MIG',@L_CLIENT_VALUES,0,'*|~*','|*~|','',''  
  
  
  
  select @l_newcrn_1 = entp_ent_id  
  from entity_properties where entp_value =  @pa_pan_1   and entp_entpm_cd ='pan_gir_no' 

     
  update dp_acct_mstr set dpam_crn_no = @l_newcrn_1 where dpam_sba_no = @pa_sba_1  
    
  update entity_relationship set ENTR_CRN_NO = @l_newcrn_1 where ENTR_SBA = @pa_sba_1  
    
  SELECT  @L_ENTP_VALUE = isnull(@L_ENTP_VALUE ,'')  + CONVERT(VARCHAR,entp_ENTPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(entp_value)),'')) + '|*~|*|~*'    
  FROM entity_properties WHERE entp_ent_id = @l_crn1 AND entp_ENTPM_CD not in( 'pan_gir_no')  
    
  print @L_ENTP_VALUE  
        EXEC pr_ins_upd_entp '1','EDT','MIG',@l_newcrn_1,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,0,'*|~*','|*~|',''    
    
    


  SELECT @L_ADR = 'PER_ADR1|*~|'+ISNULL(ltrim(rtrim(adr_1)),'')+'|*~|'+ISNULL(ltrim(rtrim(adr_2)),'')+'|*~|'+ISNULL(ltrim(rtrim(adr_3)),'')+'|*~|'  
  +ISNULL(ltrim(rtrim(adr_city)),'')+'|*~|'+ISNULL(adr_state,'')+'|*~|'+ISNULL(adr_country,'')+'|*~|'  
  +ISNULL(ltrim(rtrim(adr_zip)),'')+'|*~|*|~*'   
  FROM   account_adr_conc , dp_Acct_mstr , addresses WHERE adr_id = accac_adr_conc_id   
  and dpam_sba_no = @pa_sba_1   
  and dpam_id = accac_clisba_id   
  and ACCAC_CONCM_ID = 80  
    
    
  SELECT @L_ADR = isnull(@L_ADR,'') + 'COR_ADR1|*~|'+ISNULL(ltrim(rtrim(adr_1)),'')+'|*~|'+ISNULL(ltrim(rtrim(adr_2)),'')+'|*~|'+ISNULL(ltrim(rtrim(adr_3)),'')+'|*~|'  
  +ISNULL(ltrim(rtrim(adr_city)),'')+'|*~|'+ISNULL(adr_state,'')+'|*~|'+ISNULL(adr_country,'')+'|*~|'  
  +ISNULL(ltrim(rtrim(adr_zip)),'')+'|*~|*|~*'   
  FROM   account_adr_conc , dp_Acct_mstr , addresses WHERE adr_id = accac_adr_conc_id   
  and dpam_sba_no = @pa_sba_1   
  and dpam_id = accac_clisba_id   
  and ACCAC_CONCM_ID = 81   
   
   
        EXEC pr_ins_upd_addr @l_newcrn_1,'EDT','MIG',@l_newcrn_1,'',@L_ADR,0,'*|~*','|*~|',''  
    
--  
     
  
  
end    
  
--update entity_properties set entp_value = @pa_pan_2 where entp_ent_id = @l_crn1   
  
  
  
end

GO
