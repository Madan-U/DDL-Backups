-- Object: FUNCTION citrus_usr.GetCDSLinterdpSettType
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[GetCDSLinterdpSettType](@pa_mode char(1),@pa_settno varchar(10),@pa_setttype varchar(10)) returns varchar(20)    
as    
begin    
declare @@outsetttype varchar(20),    
@@exchange varchar(3)    
 select @@exchange = case when left(ltrim(rtrim(@pa_settno)),1) = '2' then 'NSE'     
      when left(ltrim(rtrim(@pa_settno)),1) = '0' then 'BSE'     
      else '' end    
    
 if @pa_mode = 'U'    
 begin    
  select @@outsetttype = case when @@exchange = 'NSE' then     
         case when @pa_setttype = 'NR' then 'NR'    
         when @pa_setttype = 'NA' then 'NA'    
         when @pa_setttype = 'TT' then 'TT'    
         when @pa_setttype = 'JJ' then 'L'    
         when @pa_setttype = 'KK' then 'P'    
         when @pa_setttype = 'LL' then 'Q'
		 when @pa_setttype = 'N' then 'NR'    
		 when @pa_setttype = 'A' then 'NA'    
		when @pa_setttype =  'W' then 'TT'    
         else @pa_setttype end  
        when @@exchange = 'BSE' then     
         case when @pa_setttype = 'RM' then '111000'    
		 when @pa_setttype = 'D' then '111000'    
         when @pa_setttype = 'AR' then '111001'  --AR    
		when @pa_setttype = 'AD'  then '111001'  --AR    
         --when @pa_setttype = 'TT' then '111004'    
         when @pa_setttype = 'JJ' then '41'    
         when @pa_setttype = 'KK' then '42'    
         when @pa_setttype = 'LL' then '44'   
         else @pa_setttype end    
        else    
      @pa_setttype    
        end    
 end    
 else    
 begin    
     
  select @@outsetttype = case when @@exchange = 'NSE' then     
           case when @pa_setttype = 'NR' then 'NR'    
         when @pa_setttype = 'NA' then 'NA'    
         when @pa_setttype = 'TT' then 'TT'    
                when @pa_setttype = 'L' then 'JJ'    
         when @pa_setttype = 'P' then 'KK'    
         when @pa_setttype = 'Q' then 'LL'    
         else @pa_setttype end    
        when @@exchange = 'BSE' then     
           case when @pa_setttype = '111000' then 'RM'    
         when @pa_setttype = '111001' then 'AR'  --AR    
         --when @pa_setttype = '111004' then 'TT'    
         when @pa_setttype = '41' then 'JJ'    
         when @pa_setttype = '42' then 'KK'    
         when @pa_setttype = '44' then 'LL'    
         else @pa_setttype end    
    
        else    
      @pa_setttype    
        end    
 end    
    
 return @@outsetttype    
end

GO
