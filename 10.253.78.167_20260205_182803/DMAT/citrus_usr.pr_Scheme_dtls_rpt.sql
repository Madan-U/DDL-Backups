-- Object: PROCEDURE citrus_usr.pr_Scheme_dtls_rpt
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE  procedure [citrus_usr].[pr_Scheme_dtls_rpt]
(@pa_desc varchar(50),
 @pa_out varchar(1000) out 
--exec pr_Scheme_dtls_rpt '',''
)
as
begin
	select distinct brom_desc,cham_slab_no , cham_slab_name ,cham_charge_type , cham_charge_baseon, cham_val_pers,cham_charge_value,cham_charge_minval,cham_per_min,cham_per_max
	from charge_mstr ,profile_charges, brokerage_mstr 
	where  cham_slab_no = proc_slab_no 
	and proc_profile_id = brom_id 
	and brom_deleted_ind = 1 
	and proc_deleted_ind = 1
	and brom_deleted_ind = 1  AND [CHAM_DELETED_IND ] = '1'
	and brom_desc like case when isnull(@pa_desc,'')= '' then '%' else @pa_desc end
	order by 1 
end

GO
