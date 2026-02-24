-- Object: FUNCTION citrus_usr.Fn_GetSlipScreens
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[Fn_GetSlipScreens](@slipcode varchar(10),@MKRCHKR char(1)) returns varchar(3)  
As  
begin  
declare @retval varchar(3)  
if (@MKRCHKR = 0)  
begin  
Select @retval = case when @slipcode IN ('901','DEMAT') then '164'  
        when @slipcode IN ('902','REMAT') then '167'  
        when @slipcode = '904_ACT' then '168'  
        when @slipcode = '904_P2C' then '177'  
        when @slipcode = '905_ACT' then ''  
        when @slipcode = '906' then '170'  
        when @slipcode = '912' then '170'  
        when @slipcode = '907' then '171'  
        when @slipcode = '925' then '165'  
        when @slipcode = '926' then ''  
        when @slipcode = '934' then '166'  
        when @slipcode IN ('PLEDGE','UNPLEDGE','CONFISCATE') then '329' --'307'  --CDSL
        when @slipcode IN ('908','910','911') then '333'                 --NSDL

        
     else '' end  
end  
  
if (@MKRCHKR = 2)  
begin  
Select @retval = case when @slipcode IN ('901','DEMAT') then '180'  
        when @slipcode IN ('902','REMAT') then '178'  
        when @slipcode = '904_ACT' then '190'  
        when @slipcode = '904_P2C' then '199'  
        when @slipcode = '905_ACT' then ''  
        when @slipcode = '906' then '184'  
        when @slipcode = '912' then '184'  
        when @slipcode = '907' then '188'  
        when @slipcode = '925' then '182'  
        when @slipcode = '926' then ''  
        when @slipcode = '934' then '183'  
        when @slipcode = '1' then '197' 
        when @slipcode IN ('PLEDGE','UNPLEDGE','CONFISCATE') then '329'--'308' --CDSL
        when @slipcode IN ('908','910','911') then '334'                --NSDL
     else '' end  
end  
  
if (@MKRCHKR = 1)  
begin  
Select @retval = case when @slipcode IN ('901','DEMAT') then ''  
        when @slipcode IN ('902','REMAT') then ''  
        when @slipcode = '904_ACT' then ''  
        when @slipcode = '904_P2C' then ''  
        when @slipcode = '905_ACT' then ''  
        when @slipcode = '906' then ''  
        when @slipcode = '912' then ''  
        when @slipcode = '907' then ''  
        when @slipcode = '925' then ''  
        when @slipcode = '926' then ''  
        when @slipcode = '934' then ''  
        when @slipcode = '1' then '198'   
        when @slipcode IN ('PLEDGE','UNPLEDGE','CONFISCATE') then '329'--'309'  --CDSL 
        when @slipcode IN ('908','910','911') then '335'                 --NSDL
        else '' end  
end  
  
  
  
  
return @retval  
  
end

GO
