-- Object: PROCEDURE citrus_usr.pr_pan_warning
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--select * from bitmap_ref_mstr
--insert into bitmap_ref_mstr 
--select 376, 'PAN_WARN','PAN_WARN','0','Y','','HO',getdate(),'HO',getdate(),1
CREATE proc [citrus_usr].[pr_pan_warning](@pa_boid varchar(20),@pa_out varchar(20) output)  
as  
begin  
  if exists(select bitrm_id from bitmap_ref_mstr where bitrm_parent_cd  = 'PAN_WARN' and bitrm_values = 'Y' and bitrm_deleted_ind = 1)
  begin 
	  if exists(select entp_value from entity_properties , dp_acct_mstr   
				where entp_ent_id = dpam_crn_no   
				and dpam_sba_no = @pa_boid   
				and entp_entpm_cd = 'PAN_GIR_NO'   
				and entp_deleted_ind = 1   
				and dpam_deleted_ind = 1 and isnull(entp_value,'') <> '')   
	  begin  
		set @pa_out = 'Y'  
	  end   
	  else   
	  begin  
	   set @pa_out = 'N'  
	  end   
  end 
  else 
  begin
     set @pa_out = 'Y'
  end 
end

GO
