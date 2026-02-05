-- Object: FUNCTION citrus_usr.fn_get_listing
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_listing](@pa_prop_cd    VARCHAR(100)  
                              ,@pa_value      VARCHAR(100)  
                              )  
RETURNS VARCHAR(50)   
AS  
--  
BEGIN  
--  
  DECLARE @l_value varchar(50)  
    
  IF @pa_prop_cd = 'OCCUPATION'  
  BEGIN  
  --  
    set @l_value = case when @pa_value = 'Business' then 'B'   
                        when @pa_value = 'Farmer' then 'F'   
                        when @pa_value = 'House Wife' then 'H'   
                        when @pa_value = 'Others' then 'O'                                               
                        when @pa_value = 'Professional' then 'P'   
                        when @pa_value = 'Retired' then 'R'   
                        when @pa_value = 'Service' then 'S'   
                        when @pa_value = 'Student' then 'ST' 
						when @pa_value = 'PRIVATE SECTOR' then 'PV'
						when @pa_value = 'PUBLIC SECTOR' then 'PS'
						when @pa_value = 'GOVERNMENT SERVICES' then 'GS' else '' end  
  --  
  END  
  ELSE IF @pa_prop_cd = 'GEOGRAPHICAL'  
  BEGIN  
  --  
    set @l_value = case when @pa_value = 'Metropolitian' then 'M'   
                        when @pa_value = 'Others' then 'O'   
                        when @pa_value = 'Rural' then 'R'   
                        when @pa_value = 'Semi Urban' then 'SU'                                               
                        when @pa_value = 'Urban' then 'U' else '' end  
                         
  
  --  
  END  
  ELSE IF @pa_prop_cd = 'EDUCATION'  
  BEGIN  
  --  
    set @l_value = case when @pa_value = 'High School' then '01'   
                        when @pa_value = 'Graduate' then '02'   
                        when @pa_value = 'Post Graduate' then '03'   
                        when @pa_value = 'Doctrate' then '04'                                               
                        when @pa_value = 'Proffessional Degree' then '05'   
                        when @pa_value = 'Under High School' then '06'        
                        when @pa_value = 'Others'            then '08'   
                        when @pa_value = 'Illiterate'        then '07' else '' end  
                         
  --  
  END  
  ELSE IF @pa_prop_cd = 'ANNUAL_INCOME'  
  BEGIN  
  --  
    set @l_value = case when @pa_value = 'UPTO 1 LAKHS' then '1'   
                        when @pa_value = '1 Lakh To 2 Lakhs' then '2'   
                        when @pa_value = '2 Lakh To 5 Lakhs' then '3'   
                        when @pa_value = '5 Lakhs & above' then '4'                                               
                        when @pa_value = 'Not Available' then '5'
						when @pa_value = '1 LAC - 5 LACS' then '6'
						when @pa_value = '5 LACS - 10 LACS' then '7'
						when @pa_value = '10 LACS - 25 LACS' then '8'
						when @pa_value = '> 25 LACS' then '9'
						when @pa_value = '25 LACS - 1 CRORE' then '10'
						when @pa_value = '> 1 CRORE' then '11'
                        else '' end  
  --  
  END  
  ELSE IF @pa_prop_cd = 'BANKCCY' or @pa_prop_cd = 'DIVBANKCCY' or @pa_prop_cd = 'DIVIDEND_CURRENCY'  
  BEGIN  
  --  
    set @l_value = case when @pa_value = 'Indian Rupee' then '999001'   
                        when @pa_value = 'US Dollor' then '999002'   
                        when @pa_value = 'UK Pound' then '999003'   
                        else '000000' end  
  --  
  END  
  ELSE IF @pa_prop_cd = 'NATIONALITY'  
  BEGIN  
  --  
    set @l_value = case when @pa_value = 'Indian' then '01'   
                        when @pa_value = 'Uk' then '03'   
                        when @pa_value = 'Japan' then '05'   
                        when @pa_value = 'Germany' then '07'                                               
                        when @pa_value = 'Canada' then '09'  
                        when @pa_value = 'MIDDLE EAST NATIONS' then '04'   
						when @pa_value = 'FRANCE' then '06'   
						when @pa_value = 'SINGAPORE' then '08'   
						when @pa_value = 'OTHERS' then '10'   
						when @pa_value = 'US' then '02'    
						when @pa_value = 'AUSTRALIA' then '19'   
                        else '' end  
                          
  --  
  END  
  ELSE IF @pa_prop_cd = 'BOSTMNTCYCLE'  
  BEGIN  
  --  
    set @l_value = case when @pa_value = 'First of month' then '01'   
                        when @pa_value = 'Daily' then 'DA'   
                        when @pa_value = 'Eight of month' then '08'   
                        when @pa_value = 'Twice Monthly - 15 & End of month' then '2M'                                               
                        when @pa_value = 'End of Month' then 'EM'   
                        when @pa_value = 'END OF WEEK' then 'EW'        
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
  ELSE IF @pa_prop_cd = 'TAX_DEDUCTION'  
  BEGIN  
  --  
    set @l_value = case when @pa_value = 'Exempt' then '01'    
                        when @pa_value= 'Resident Individual' then '02'   
                        when @pa_value= 'NRI With Repatriation' then '03'   
                        when @pa_value= 'NRI Without Repatriation' then '04'   
                        when @pa_value= 'Domestic Companies' then '05'   
                        when @pa_value= 'Overseas Corporate Bodies' then '06'   
                        when @pa_value= 'Foreign Companies' then '07'   
                        when @pa_value= 'Mutual Funds' then '08'   
                        when @pa_value= 'Double Taxation Treaty' then '09'   
                        when @pa_value= 'Others' then '10' else '' end   
  --  
  END  
  ELSE IF @pa_prop_cd = 'LANGUAGE'  
  BEGIN  
  --  
    set @l_value = case when @pa_value = 'Assamese' then '1'    
                        when @pa_value= 'English' then '3'   
                        when @pa_value= 'Hindi' then '5'   
                        when @pa_value= 'Kashmiri' then '7'   
                        when @pa_value= 'Marathi' then '9'   
                        when @pa_value= 'Punjabi' then '11'   
                        when @pa_value= 'Sindhi' then '13'   
                        when @pa_value= 'Telegu' then '15'  
                        when @pa_value= 'Gujarati' then '4'   
                        when @pa_value= 'Tamil' then '14'   
                        when @pa_value= 'Urdu' then '16'   
                        when @pa_value= 'Kannada' then '6'  
                        else '' end   
                          
                         
  --  
  END  
  ELSE IF @pa_prop_cd = 'CATEGORY'  
  BEGIN  
  --  
    set @l_value = case when @pa_value ='Regular BO' then '01'    
                        when @pa_value= 'CM Principal' then '02'   
                        when @pa_value= 'CM Escrow' then '03'   
                        when @pa_value= 'CH Pool' then '04'   
                        when @pa_value= 'CH Escrow' then '05'   
                        when @pa_value= 'Custodian Principal' then '06'   
                        when @pa_value= 'Custodian Escrow' then '07'   
                        when @pa_value= 'Other DP Principal' then '08'   
                        when @pa_value= 'Other DP Escrow' then '09'   
                        when @pa_value= 'CH Principal' then '10'   
                        when @pa_value= 'CM VB' then '11'   
                        when @pa_value= 'CM Pool' then '12'   
                        when @pa_value= 'Nostro Account' then '13'   
                        when @pa_value= 'Clearing Member Account' then '14'   
                        else '00' end   
                          
  --  
  END  
  ELSE IF @pa_prop_cd = 'BOSUBSTATUS'  
  BEGIN  
  --  
    set @l_value = case when @pa_value ='individual-director' then '2101'    
                        when @pa_value= 'Beneficiary' then '11'   
                        when @pa_value= 'Pending Demat' then '12'   
                        when @pa_value= 'Pledge' then '14'   
                        when @pa_value= 'Frozed Balance' then '50'   
                        when @pa_value= 'Lock in Balance' then '51'   
                        when @pa_value= 'Ear Marked' then '52'  
                        when @pa_value= 'individual-HUFS/AOPS' then '2104'   
                        when @pa_value= 'FI-Government Sponsered FI' then '2205'   
                        when @pa_value= 'FI-SFC' then '2206'   
                        when @pa_value= 'FI-Others' then '2207'   
                        when @pa_value= 'FII-Mauritius Based' then '2308'   
                        when @pa_value= 'FII-Others' then '2309'   
                        when @pa_value= 'NRI-Repatriable' then '2410'   
                        when @pa_value= 'NRI-Non Repatriable' then '2411'   
                        when @pa_value= 'Corporate Body-Domestic' then '2512'   
                        when @pa_value= 'Corporate Body-OCB' then '2513'   
                        when @pa_value= 'Corporate Body-Govt. Company' then '2514'   
                        when @pa_value= 'Corporate Body-Central Govt' then '2515'   
                        when @pa_value= 'Corporate Body-State Govt' then '2516'   
                        when @pa_value= 'Corporate Body-Co-Operative Bank' then '2517'   
                        when @pa_value= 'Corporate Body-NBFC' then '2518'   
                        when @pa_value= 'Corporate Body-Non NBFC' then '2519'   
                        when @pa_value= 'Corporate Body-Broker' then '2520'   
                        when @pa_value= 'Corporate Body-Group Company' then '2521'   
                        when @pa_value= 'Corporate Body-Foreign Bodies' then '2522'   
                        when @pa_value= 'Corporate Body-Others' then '2523'   
                        when @pa_value= 'Clearing Member' then '2624'   
                        when @pa_value= 'Foreign National' then '2725'   
                        when @pa_value= 'Mutual Funds' then '2826'   
                        when @pa_value= 'Trusts' then '2927'   
                        when @pa_value= 'Bank-Foreign' then '3028'   
                        when @pa_value= 'Bank-Co-Operative' then '3029'   
                        when @pa_value= 'Bank-Nationalized' then '3030'   
                        when @pa_value= 'Bank-Others' then '3031'   
                        when @pa_value= 'Clearing House' then '3132'   
                        when @pa_value= 'Other Depository Account' then '3233'   
                        when @pa_value= 'Individual-Director Relative' then '2102'   
                        when @pa_value= 'Individual-Resident' then '2103'   
                        when @pa_value= 'FII-Depository Receipt' then '2334'    
                        when @pa_value= 'NRI-Depository Receipt' then '2435'   
                        when @pa_value= 'Corporate Body-OCB-Depository Receipt' then '2536'   
                        when @pa_value= 'Foreign National-Depository Receipt' then '2737'   
                        when @pa_value= '2452PD1ß-MAR-05ÿ' then '0053'   
                        when @pa_value= 'Individual-Promoters' then '2140'  
                        when @pa_value= 'Individual-Commodity'  then '2144'   
                        when @pa_value= 'Corporate-Commodity' then '2545'   
                        when @pa_value= 'Corporate-Margin Trading Account' then '2543'   
                        when @pa_value= 'Corporate CM/TM - Client Margin A/c' then '2551'   
                        when @pa_value= 'Corporate CM/TM - Client Beneficiary A/c' then '2552'   
                        when @pa_value= 'Individual CM/TM - Client Margin A/c' then '2153'   
                        when @pa_value= 'Individual CM/TM- Client Beneficiary A/c' then '2154'   
                        when @pa_value= 'HUF CM/TM- Client Margin A/c' then '2155'   
                        when @pa_value= 'HUF CM/TM-Client Beneficiary A/c' then '2156'   
                        when @pa_value= 'Corporate Body-Depositary Receipt' then '2538'   
                        when @pa_value= 'Bank-Depositary Receipt' then '3039'   
                        when @pa_value= 'Corporate Body-Promoter' then '2142'   
                        when @pa_value= 'Individual-Margin Trading Account' then '2142'   
                        when @pa_value= 'Bank-Commodity' then '3046'   
                        when @pa_value= 'Individual-HUF-Margin Trading account' then '2147'   
                        when @pa_value= 'NRI Repatriable - Promoter' then '2448'   
                        when @pa_value= 'NRI Non Repatriable - Promoter' then '2449'   
                        when @pa_value= 'HUF - Promoter'  then '2150'   
                        else '0000' end   
                          
              
                
                
                 
                
                 
  
  --  
  END  
    
    
  RETURN @l_value  
--    
END

GO
