-- Object: FUNCTION citrus_usr.fn_valid_hier
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create function [citrus_usr].[fn_valid_hier](@pa_dpam_sba_no varchar(100)
,@pa_parent_id numeric
,@pa_child_id  numeric
)      
RETURNS VARCHAR(5)      
AS      
BEGIN      
--      
  DECLARE @l_flg VARCHAR(1)      
  set @l_flg 	='N'

  if exists(select entr_sba from entity_relationship where entr_deleted_ind = 1 and entr_sba=@pa_dpam_sba_no 
			and getdate() between entr_from_dt and isnull(entr_to_dt,'dec 31 2100')
			and (entr_ho = @pa_parent_id
				or entr_ar = @pa_parent_id
				or entr_re = @pa_parent_id
				or entr_br = @pa_parent_id
				or entr_sb = @pa_parent_id
				or entr_dummy1 = @pa_parent_id
				or entr_dummy3 = @pa_parent_id)
			 and (entr_ho = @pa_child_id
				or entr_ar = @pa_child_id
				or entr_re = @pa_child_id
				or entr_br = @pa_child_id
				or entr_sb = @pa_child_id
				or entr_dummy1 = @pa_child_id
				or entr_dummy3 = @pa_child_id)
			)
	set @l_flg = 'Y'
           
  
  RETURN @l_flg 
--      
END

GO
