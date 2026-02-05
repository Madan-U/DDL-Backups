-- Object: FUNCTION citrus_usr.GetCDSLinterdpSettType_SP
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[GetCDSLinterdpSettType_SP](@pa_mode char(1),@pa_settno varchar(10),@pa_setttype varchar(10)) returns varchar(20)      
as      
begin      
declare @@outsetttype varchar(20),      
@@exchange varchar(3)      
 select @@exchange = case when left(ltrim(rtrim(@pa_settno)),1) = '2' then 'NSE'       
      when left(ltrim(rtrim(@pa_settno)),1) = '0' then 'BSE'       
      else '' end      
      
 
  

 return @pa_setttype      
end

GO
