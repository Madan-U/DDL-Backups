-- Object: PROCEDURE citrus_usr.charge_mstr_s
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

    
    
--exec [entity_relationship_s] '00000070'    
    
CREATE    PROCEDURE [citrus_usr].[charge_mstr_s]      
(       
@PA_FROM_ACCTNO VARCHAR(8)      
    
)      
AS     
    
    
  begin   
    
select * from charge_mstr  where CHAM_SLAB_NO in (
select PROC_SLAB_NO  from profile_charges where PROC_PROFILE_ID in ( 
select BROM_ID  from BROKERAGE_MSTR where BROM_ID in (
select CLIDB_BROM_ID  from client_dp_brkg where CLIDB_DPAM_ID in(select dpam_id from dp_acct_mstr where right(DPAM_SBA_NO,8) =@PA_FROM_ACCTNO)
and CLIDB_DELETED_IND = '1'
and clidb_eff_to_dt IN('2900-01-01 00:00:00.000','2100-12-31 00:00:00.000')
)
and BROM_DELETED_IND = '1'
)
and [PROC_DELETED_IND ] = '1'
)
and [CHAM_DELETED_IND ] = '1'
        
    end

GO
