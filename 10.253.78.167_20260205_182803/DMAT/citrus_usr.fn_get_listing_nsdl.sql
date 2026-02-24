-- Object: FUNCTION citrus_usr.fn_get_listing_nsdl
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_listing_nsdl](@pa_prop_cd    VARCHAR(100)
																																			,@pa_value      VARCHAR(100)
																																			)
RETURNS VARCHAR(50) 
AS
--
BEGIN
--
  DECLARE @l_value varchar(50)
  
  IF @pa_prop_cd = 'OCCUPATION' or @pa_prop_cd = 'SH_OCCUPATION' or @pa_prop_cd = 'TH_OCCUPATION'
  BEGIN
  --
    set @l_value = case when @pa_value = 'Service' then '01' 
																								when @pa_value = 'Student' then '02' 
																								when @pa_value = 'Housewife' then '03' 
																								when @pa_value = 'Landlord' then '04'                                             
																								when @pa_value = 'Business' then '05' 
																								when @pa_value = 'Professional' then '06' 
																								when @pa_value = 'Agriculture' then '07' 
																								when @pa_value = 'Others' then '08' else '00' end
																						

  --
  END
  ELSE IF @pa_prop_cd = 'CHEQUECASH'
  BEGIN
  --
    set @l_value = case when @pa_value = 'CASH' then 'C' 
																								when @pa_value = 'CHEQUE' then 'Q' 
																							 else '' end
																							

  --
  END
  ELSE IF @pa_prop_cd = 'TRXFREQ' or @pa_prop_cd = 'HLDNGFREQ' or @pa_prop_cd = 'BILLFREQ'
		BEGIN
		--
    set @l_value = case when @pa_value = 'Daily' then '1' 
																								when @pa_value = 'Weekly' then '2' 
																								when @pa_value = 'Fortnightly' then '3' 
																								when @pa_value = 'Monthly' then '4'                                             
																								when @pa_value = 'Quaterly' then '5' 
																								else '' end
		--
  END
  ELSE IF @pa_prop_cd = 'ALLOW'
		BEGIN
		--
				set @l_value = case when @pa_value = 'Inserted' then 'I'  
																								else '' end 
																								
																							
		--
  END
  ELSE IF @pa_prop_cd = 'CATEGORY'
		BEGIN
		--
				set @l_value = case when @pa_value = 'House' then '01'  
																								when @pa_value = 'Non House Beneficiary' then '02'  
																								when @pa_value = 'Clearing Member' then '03'  
																								when @pa_value = 'Internal Suspense' then '98'  
																								when @pa_value = 'Control' then '99'  
																								when @pa_value = 'Intermediary' then '91'  
																								when @pa_value = 'Not applicable' then '00'  
																								when @pa_value = 'Clearing Co-corporation' then '04'  
																								when @pa_value = 'Blank' then ''  
																								else '' end 
																					
		--
  END
  
  RETURN @l_value
--  
END

GO
