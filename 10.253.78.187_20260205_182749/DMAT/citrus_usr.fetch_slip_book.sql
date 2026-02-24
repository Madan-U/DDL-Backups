-- Object: PROCEDURE citrus_usr.fetch_slip_book
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[fetch_slip_book](@pa_id varchar(50),@pa_action varchar(25),@pa_tratm_id numeric,@pa_series_type varchar(20),@pa_slip_no numeric,@pa_out varchar(30) out)        
as        
begin        
--        
  declare @l_dpm_id numeric      
  if @pa_id = 'MODES-CDSL-DEPOSITORY-ALL'
  begin
	set @l_dpm_id = 999
  end
  else
  begin    
	select @l_dpm_id = dpm_id from dp_mstr where isnull(default_dp,'0') = @pa_id      
  end
  
        
  if @pa_action = 'BOOK_ISSUE'        
  begin        
  --        
    select distinct slibm_book_name ValNo from slip_book_mstr         
    where convert(numeric,slibm_tratm_id) = @pa_tratm_id         
    and isnull(slibm_series_type,'') = @pa_series_type        
    and  @pa_slip_no between convert(numeric,slibm_from_no) and   convert(numeric,slibm_to_no)         
    and SLIBM_DPM_ID = @l_dpm_id     
    and slibm_deleted_ind = 1       
  --        
  end        
  else if @pa_action = 'BOOK_INWARD'        
  begin        
  --        
 select top 1 ors_po_no ValNo from order_slip        
    where convert(numeric,ors_tratm_id) = @pa_tratm_id         
    and  @pa_slip_no between convert(numeric,ors_from_slip) and  convert(numeric,ors_to_slip)   
 and isnull(ors_series_type,'') = @pa_series_type        
    and ors_dpm_id = @l_dpm_id  
    and ord_deleted_ind = 1  
  --        
  end        
  else if @pa_action = 'SLIPBOOK_SEARCH'        
  begin        
  --        
    select slibm_id , slibm_book_name book_no , slibm_from_no slip_from , slibm_to_no slip_to , slibm_tratm_id tratm_id , slibm_book_type type , slibm_no_of_slips size_of_book , slibm_series_type series_type ,convert(varchar(11),slibm_dt,103)slibm_dt   
    from slip_book_mstr     
    where convert(numeric,slibm_tratm_id) = @pa_tratm_id         
    and isnull(slibm_series_type,'') = @pa_series_type        
    and  @pa_slip_no between convert(numeric,slibm_from_no) and  convert(numeric,slibm_to_no)        
    and SLIBM_DPM_ID = @l_dpm_id     
    and slibm_deleted_ind = 1      
  --        
  end      
    
      
--        
end

GO
