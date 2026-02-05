-- Object: PROCEDURE citrus_usr.pr_sel_slipno
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_sel_slipno] (@pa_login_name varchar(20),@pa_out varchar(1000) output)        
as        
begin        
      
DECLARE @L1 int    
DECLARE @L2 int    
  
select @L1 =  max(convert(numeric,sliim_slip_no_to))+ 1 from slip_issue_mstr where SLIIM_DELETED_IND = 1   and isnumeric(sliim_slip_no_to)=1     
PRINT @L1    
--      
select @L2 =  max(convert(numeric,ors_to_slip))+ 1 from ORDER_SLIP where ord_deleted_ind = 1        
PRINT @L2  
if  isnull(@L1,'0')='0'  
begin
set @L1=0
end
--      
IF @L1>@L2      
BEGIN       
select @pa_out = @L1      
END      
--   
print @L1    
IF @L2>@L1      
BEGIN      
print @L1 
select @pa_out = @L2      
END      
  
--      
IF @L2=@L1      
BEGIN       
select @pa_out = @L2      
END      
      
--select @pa_out =  max(convert(numeric,sliim_slip_no_to))+ 1 from slip_issue_mstr where SLIIM_DELETED_IND = 1        
                         
end

GO
