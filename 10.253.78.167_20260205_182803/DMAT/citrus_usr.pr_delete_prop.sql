-- Object: PROCEDURE citrus_usr.pr_delete_prop
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_delete_prop](@pa_exch varchar(10),@pa_ctgry varchar(50))
as
begin

if @pa_exch = 'nsdl'
begin


--select distinct entpm_cd, entpm_desc from entity_type_mstr , entity_property_mstr entp
--where entpm_enttm_id = enttm_id and enttm_cd in ('01','02','03')
--and   entpm_cd not in ('OCCUPATION','PAN_GIR_NO','TAX_DEDUCTION')

select distinct accpm_prop_cd, accpm_prop_desc from entity_type_mstr , account_property_mstr accp
where accpm_enttm_id = enttm_id and enttm_cd in ('01','02','03')
and   accpm_prop_Cd not in  ('ACC_CLOSE_DT','MAPIN_ID','DATE_OF_MATURITY','ADR_PREF_FLG','BENMICR','BILL_START_DT','CMBP_ID','CMBPEXCH','RBI_REF_NO','SEBI_REG_NO','SMS_FLAG','STAN_INS_IND')

end 

if @pa_exch = 'cdsl'
begin

select distinct entpm_cd, entpm_desc from entity_type_mstr , entity_property_mstr entp
where entpm_enttm_id = enttm_id and right(enttm_cd,5) = '_cdsl'
and   entpm_Cd not in ('ANNUAL_INCOME'
,'BBO_CODE'
,'EDUCATION'
,'GEOGRAPHICAL'
,'INC_DOB'
,'LANGUAGE'
,'NATIONALITY'
,'OCCUPATION'
,'PAN_GIR_NO'
,'STAFF'
)

select distinct accpm_prop_cd, accpm_prop_desc from entity_type_mstr , account_property_mstr accp
where accpm_enttm_id = enttm_id and right(enttm_cd,5) = '_cdsl'
and   accpm_prop_cd not in ('ACC_CLOSE_DT'
,'BANKCCY'
,'BILL_START_DT'
,'BOSETTLFLG'
,'BOSTMNTCYCLE'
,'CMBP_ID'
,'CMBPEXCH'
,'CONFIRMATION'
,'DATE_OF_MATURITY'
,'DIVBANKCCY'
,'DIVIDEND_CURRENCY'
,'ECS_FLG'
,'ELEC_CONF'
,'SMS_FLAG'
)

end 

end

GO
