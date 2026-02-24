-- Object: PROCEDURE citrus_usr.pr_valid_nrn_poa
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_valid_nrn_poa](@pa_id numeric    
,@pa_tab varchar(20)    
,@pa_value varchar(100)    
,@pa_out varchar(8000) out )    
as    
begin    
    
declare @l_yn varchar(8000) 
    
if @pa_tab= 'NRM'    
begin     
  select @l_yn = case when exists(select top 1 NOM_NRN_NO from dp_holder_dtls where NOM_NRN_NO = @pa_value and dphd_deleted_ind = 1) then 'Y'      
      when exists(select top 1 NOM_NRN_NO from dphd_mak where NOM_NRN_NO = @pa_value and dphd_deleted_ind in (0,4,8)) then 'Y'     
                   else 'N' end     
end     
else if @pa_tab= 'POA'    
begin     
select @l_yn = case when exists(select top 1 dppd_poa_id from dp_poa_dtls where dppd_poa_id = @pa_value and dppd_deleted_ind = 1) then 'Y'      
      when exists(select top 1 dppd_poa_id from dp_poa_dtls_mak where dppd_poa_id = @pa_value and dppd_deleted_ind in (0,4,8)) then 'Y'     
                   else 'N' end     
end    
else if @pa_tab= 'NEWNRM'   
begin  
 select @l_yn = BITRM_VALUES  from bitmap_ref_mstr WHERE BITRM_PARENT_CD='NRN_NO' 
 update bitmap_ref_mstr set BITRM_VALUES = @l_yn + 1 WHERE BITRM_PARENT_CD='NRN_NO'   
end   
else if @pa_tab= 'NEWPOA'   
begin  
 select @l_yn = BITRM_VALUES  from bitmap_ref_mstr WHERE BITRM_PARENT_CD='POA_ID'   
 update bitmap_ref_mstr set BITRM_VALUES = @l_yn + 1 WHERE BITRM_PARENT_CD='POA_ID'   
end     

--if  @l_yn = ''
--begin
	set @pa_out = @l_yn  
--end
--else
--begin
--  set @pa_out = @n_yn  
--end

print @pa_out    
end

GO
