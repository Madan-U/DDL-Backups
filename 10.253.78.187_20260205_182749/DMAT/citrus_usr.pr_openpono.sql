-- Object: PROCEDURE citrus_usr.pr_openpono
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_openpono](@pa_excsm_id numeric, @pa_tratm_id numeric,@pa_ref_cur  varchar(8000) output)  
as  
begin   
    declare @l_dpm_id numeric  
     
    select @l_dpm_id = dpm_id from dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_excsm_id and dpm_deleted_ind = 1   
  
 select ors_po_no from order_slip  
 where ors_no_of_books <> (select count(slibm_id) from slip_book_mstr where SLIBM_TRATM_ID = ors_tratm_id  and SLIBM_SERIES_TYPE = ors_series_type and slibm_book_name between ors_from_no and ors_to_no)  
 and ors_tratm_id = @pa_tratm_id   
 and ors_dpm_id = @l_dpm_id  
end

GO
