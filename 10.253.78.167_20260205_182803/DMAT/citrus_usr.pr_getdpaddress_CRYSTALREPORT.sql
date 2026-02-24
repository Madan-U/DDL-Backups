-- Object: PROCEDURE citrus_usr.pr_getdpaddress_CRYSTALREPORT
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

-- EXEC pr_getdpaddress_CRYSTALREPORT '12345678'  
CREATE PROC [citrus_usr].[pr_getdpaddress_CRYSTALREPORT]  
@pa_dpid varchar(8)  
AS  
BEGIN  
  
select isnull(dpm_name,'') dpm_name, dpm_dpid,  IsNull(adr_1,'') adr_1,IsNull(adr_2,'') adr_2,  
IsNull(adr_3,'')adr_3,IsNull(adr_city,'') adr_city,IsNull(adr_state,'') adr_state,IsNull(adr_country,'') adr_country,IsNull(adr_zip,'') adr_zip          
  from dp_mstr dp, addresses addr, entity_adr_conc   entac  
  where entac.entac_adr_conc_id = addr.adr_id            
  AND    entac_ent_id            = dp.dpm_id            
  AND    entac_concm_cd          = 'PER_ADR1'  
  and    IsNull(adr_1,'')        <> ''  
and dpm_dpid= @pa_dpid and dpm_deleted_ind =1  
  
  
END

GO
