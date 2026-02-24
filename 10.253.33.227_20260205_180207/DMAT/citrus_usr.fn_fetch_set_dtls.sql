-- Object: FUNCTION citrus_usr.fn_fetch_set_dtls
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_fetch_set_dtls](@pa_exch varchar(25),@pa_details varchar(8000),@pa_flg varchar(10))      
returns varchar(1000)      
as      
begin      
  declare @l_return varchar(100)      
  ,@l_return_final varchar(100)      
  if @pa_exch = '11'      
  begin      
    if @pa_flg = 'NO'      
    begin      
         set @l_return = substring(@pa_details,7,len(@pa_details)-6)      
    end       
    else      
    begin      
         set @l_return = substring(@pa_details,1,6)       
    end       
  end      
  if @pa_exch in ('12','13')      
  begin      
    if @pa_flg = 'NO'      
    begin      
         set @l_return = substring(@pa_details,2,7)      
    end       
    else      
    begin      
         set @l_return = substring(@pa_details,1,1)       
    end       
  end      
  if @pa_exch = '14'      
  begin      
    if @pa_flg = 'NO'      
    begin      
         set @l_return = substring(@pa_details,4,len(@pa_details)-3)      
    end       
    else      
    begin      
         set @l_return = substring(@pa_details,1,3)       
    end       
  end      
if @pa_exch = '15'      
  begin      
    if @pa_flg = 'NO'      
    begin      
         set @l_return = substring(@pa_details,3,len(@pa_details)-2)      
    end       
    else      
    begin      
         set @l_return = substring(@pa_details,1,2)       
    end       
  end      
if @pa_exch = '22'      
  begin      
    if @pa_flg = 'NO'      
    begin      
         set @l_return = substring(@pa_details,3,len(@pa_details)-2)      
    end       
    else      
    begin      
         set @l_return = substring(@pa_details,1,2)       
    end       
  end      
if @pa_exch = '23'      
  begin      
    if @pa_flg = 'NO'      
    begin      
         set @l_return = substring(@pa_details,3,len(@pa_details)-2)      
    end       
    else      
    begin      
         set @l_return = substring(@pa_details,1,2)       
    end       
  end      
      
  return @l_return      
        
end

GO
