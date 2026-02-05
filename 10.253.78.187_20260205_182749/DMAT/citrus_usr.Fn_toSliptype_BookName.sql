-- Object: FUNCTION citrus_usr.Fn_toSliptype_BookName
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

  
CREATE  function [citrus_usr].[Fn_toSliptype_BookName]    
(@pa_slip_no varchar(30),@filler1 varchar(30),@filler2 varchar(30))    
    
returns varchar(30)    
as    
begin    
declare @l_rt varchar(50)    
select @l_rt = slibm_book_name  from slip_book_mstr where convert(numeric,@pa_slip_no)   
between SLIBM_FROM_NO and SLIBM_TO_NO    
and SLIBM_TRATM_ID=case when @filler1='P' then '10000' else SLIBM_TRATM_ID end  
return @l_rt    
end

GO
