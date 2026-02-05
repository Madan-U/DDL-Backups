-- Object: FUNCTION citrus_usr.Fn_GetNSDLTypeDtls
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--select citrus_usr.GetNSDLTypeDtls ('0204','t')

CREATE function [citrus_usr].[Fn_GetNSDLTypeDtls](@pa_subcmcd varchar(6),@pa_value_for char(1)) returns varchar(150)
as
begin
declare @@returnval varchar(150)

if @pa_value_for = 'T'
begin
select @@returnval = case when left(@pa_subcmcd,2) = '01' then 'RESIDENT'
					   when left(@pa_subcmcd,2) = '02' then 'FINANCIAL INSTITUTION (FI)'	
					   when left(@pa_subcmcd,2) = '03' then 'FOREIGN INSTITUTIONAL INVESTOR (FII)'	
					   when left(@pa_subcmcd,2) = '04' then 'NON RESIDENT INDIAN'
					   when left(@pa_subcmcd,2) = '05' then 'CORPORATE BODY'
					   when left(@pa_subcmcd,2) = '06' then 'CLEARING MEMBER'	
					   when left(@pa_subcmcd,2) = '07' then 'FOREIGN NATIONAL'
					   when left(@pa_subcmcd,2) = '08' then 'MUTUAL FUND'			
					   when left(@pa_subcmcd,2) = '09' then 'TRUST'			
					   when left(@pa_subcmcd,2) = '10' then 'BANK'	
					   when left(@pa_subcmcd,2) = '21' then 'INTERMEDIARY'
					   when left(@pa_subcmcd,2) = '24' then 'NRI NON REPATRIABLE'
				  ELSE '' END
end 
else
begin
      select @@returnval = case when @pa_subcmcd = '0101' then 'ORDINARY'
					   when @pa_subcmcd = '0103' then 'HUF'
					   when @pa_subcmcd = '0201' then 'GOVERNMENT SPONSORED'	
					   when @pa_subcmcd = '0202' then 'STATE FINANCIAL CORPORATION (SFC)'	
					   when @pa_subcmcd = '0204' then 'OTHERS'	
					   when @pa_subcmcd = '0205' then 'GOVERNMENT SPONSORED - PROMOTER'	
					   when @pa_subcmcd = '0206' then 'STATE FINANCIAL CORPORATION (SFC) - PROMOTER'	
					   when @pa_subcmcd = '0207' then 'OTHERS - PROMOTER'	
					   when @pa_subcmcd = '0301' then 'MAURITIUS BASED'	
					   when @pa_subcmcd = '0302' then 'OTHERS'	
					   when @pa_subcmcd = '0401' then 'REPATRIABLE'
					   when @pa_subcmcd = '0402' then 'NON REPATRIABLE'
					   when @pa_subcmcd = '0403' then 'DR'
					   when @pa_subcmcd = '0404' then 'REPATRIABLE - PROMOTER'
					   when @pa_subcmcd = '0405' then 'NON REPATRIABLE - PROMOTER'
					   when @pa_subcmcd = '0501' then 'DOMESTIC'
					   when @pa_subcmcd = '0502' then 'OCB REPARTRIABLE'
					   when @pa_subcmcd = '0503' then 'GOVTERNMENT COMPANIES'
					   when @pa_subcmcd = '0504' then 'CENTRAL GOVTERNMENT'
					   when @pa_subcmcd = '0505' then 'STATE GOVTERNMENT'
					   when @pa_subcmcd = '0506' then 'CO-OPERATIVE BODY'
					   when @pa_subcmcd = '0507' then 'NBFC'
					   when @pa_subcmcd = '0508' then 'NON NBFC'
					   when @pa_subcmcd = '0509' then 'BROKER'
					   when @pa_subcmcd = '0510' then 'GROUP COMPANY'
					   when @pa_subcmcd = '0511' then 'FOREIGN BODIES'
					   when @pa_subcmcd = '0512' then 'OTHERS'
					   when @pa_subcmcd = '0513' then 'OCB NON REPATRIABLE'
					   when @pa_subcmcd = '0514' then 'OCB DR'
					   when @pa_subcmcd = '0516' then 'MARGIN ACCOUNTS'
					   when @pa_subcmcd = '0517' then 'DOMESTIC - PROMOTER'
					   when @pa_subcmcd = '0518' then 'GOVT. COMPANIES - PROMOTER'
					   when @pa_subcmcd = '0519' then 'CENTRAL GOVTERNMENT - PROMOTER'
					   when @pa_subcmcd = '0520' then 'STATE GOVTERNMENT - PROMOTER'
					   when @pa_subcmcd = '0521' then 'NBFC - PROMOTER'
					   when @pa_subcmcd = '0522' then 'NON NBFC - PROMOTER'
					   when @pa_subcmcd = '0523' then 'GROUP COMPANY - PROMOTER'
					   when @pa_subcmcd = '0524' then 'FOREIGN BODIES - PROMOTER'
					   when @pa_subcmcd = '0525' then 'OTHERS - PROMOTER'
					   when @pa_subcmcd = '0526' then 'CO-OPERATIVE BODY - PROMOTER'
					   when @pa_subcmcd = '0600' then 'CLEARING MEMBER'
					   when @pa_subcmcd  = '0700' then 'FOREIGN NATIONAL'
					   when @pa_subcmcd  = '0701' then 'FOREIGN NATIONAL - DR'
					   when @pa_subcmcd  = '0702' then 'FOREIGN NATIONAL - FN'
					   when @pa_subcmcd  = '0703' then 'FOREIGN NATIONAL - PROMOTER'			
					   when @pa_subcmcd  = '0800' then 'MUTUAL FUND'	
					   when @pa_subcmcd  = '0801' then 'MUTUAL FUND - DR'	
					   when @pa_subcmcd  = '0802' then 'MUTUAL FUND - MF'	
					   when @pa_subcmcd  = '0900' then 'TRUST'	
					   when @pa_subcmcd  = '1001' then 'FOREIGN BANK'	
					   when @pa_subcmcd  = '1002' then 'CO-OPERATIVE BANK'	
					   when @pa_subcmcd  = '1003' then 'NATIONALIZED BANK'	
					   when @pa_subcmcd  = '1004' then 'OTHERS'	
					   when @pa_subcmcd  = '1005' then 'OTHERS - PROMOTER'
					   when @pa_subcmcd  = '1006' then 'NATIONALIZED BANK - PROMOTER'
					   when @pa_subcmcd  = '1007' then 'FOREIGN BANK - PROMOTER'
					   when @pa_subcmcd  = '1008' then 'CO-OPERATIVE BANK - PROMOTER'
					   when @pa_subcmcd  = '2150' then 'HUF - PROMOTER'
					   when @pa_subcmcd  = '2153' then 'INDIVIDUAL CM/TM - CLIENT MARGIN A/C'
					   when @pa_subcmcd  = '2154' then 'INDIVIDUAL CM/TM- CLIENT BENEFICIARY A/C'
					   when @pa_subcmcd  = '2155' then 'HUF CM/TM- CLIENT MARGIN A/C'
					   when @pa_subcmcd  = '2156' then 'HUF CM/TM-CLIENT BENEFICIARY A/C'
					   when @pa_subcmcd  = '2448' then 'NRI REPATRIABLE - PROMOTER'
					   when @pa_subcmcd  = '2449' then 'NRI NON REPATRIABLE - PROMOTER'
				  ELSE '' END
end

return (@@returnval)

end

GO
