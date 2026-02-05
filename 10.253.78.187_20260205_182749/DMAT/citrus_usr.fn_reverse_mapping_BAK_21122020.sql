-- Object: FUNCTION citrus_usr.fn_reverse_mapping_BAK_21122020
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE  function [citrus_usr].[fn_reverse_mapping_BAK_21122020](@pa_exchange varchar(25), @pa_prop_cd varchar(50), @pa_value varchar(50) )  
returns varchar(100)  
as  
begin  
--  
  DECLARE @L_VALUES VARCHAR(100)  
  
  if @pa_exchange = 'NSDL'  
  begin   
    IF  @pa_prop_cd = 'TRXFREQ' OR @pa_prop_cd = 'HLDNGFREQ' OR @pa_prop_cd = 'BILLFREQ'  
    SET @L_VALUES = CASE  WHEN @pa_value = '1' THEN 'DAILY'  
        WHEN @pa_value = '2' THEN 'WEEKLY'  
        WHEN @pa_value = '3' THEN 'FORTNIGHTLY'  
        WHEN @pa_value = '4' THEN 'MONTHLY'  
        WHEN @pa_value = '5' THEN 'QUATERLY' ELSE '' END  
  
   IF  @pa_prop_cd = 'CHEQUECASH'  
   SET @L_VALUES = CASE  WHEN @pa_value = 'C' THEN 'CASH'  
        WHEN @pa_value = 'Q' THEN 'CHEQUE' ELSE '' END  
             
  
   IF  @pa_prop_cd = 'OCCUPATION'  
   SET @L_VALUES = CASE  WHEN @pa_value = '01' THEN 'SERVICE'  
         WHEN @pa_value = '02' THEN 'STUDENT'  
         WHEN @pa_value = '03' THEN 'HOUSEWIFE'  
         WHEN @pa_value = '04' THEN 'LANDLORD'  
         WHEN @pa_value = '05' THEN 'BUSINESS'  
         WHEN @pa_value = '06' THEN 'PROFESSIONAL'  
         WHEN @pa_value = '07' THEN 'AGRICULTIRE'  
         WHEN @pa_value = '08' THEN 'OTHERS' ELSE '' END  
           
  
   IF  @pa_prop_cd = 'GROUP_CD'  
   SET @L_VALUES = CASE  WHEN @pa_value = 'ZZZ' THEN 'INDIVIDUAL'  
         WHEN @pa_value = '004' THEN 'PWG'  
         WHEN @pa_value = 'MTF' THEN 'PLATINUM'  
         WHEN @pa_value = 'PMS' THEN 'PMS'  
         WHEN @pa_value = 'IPO' THEN 'IPO'  
                           WHEN @pa_value = 'HCL' THEN 'HLC'  
         ELSE '' END  
  
  IF @pa_prop_cd = 'KEEPSETTLEMENT_NSDL'     --vivek/jitesh on 19 feb 2008                  
  BEGIN                  
  --                  
  set @L_VALUES = case when @pa_value = 'T' then 'FAX IND'                     
                        when @pa_value = 'D' then  'FAX IND WEB UPL & SC'                    
                        when @pa_value = 'L' then     'SP CL & FAX IND'                 
                        when @pa_value = 'S'  then 'SP CL & WEB UPL'                                                                
                        when @pa_value = 'M' then 'SP CLIENT'                     
                        when @pa_value = 'I' then 'WEB UPL & FAX IDM'                  
                        when @pa_value =  'N' then 'WEB UPLOAD'                  
                        else '' end                  
  --                  
  END              
  
  
      
    
  end  
  if @pa_exchange = 'CDSL'  
  begin
  --
    IF @pa_prop_cd = 'OCCUPATION'                    
  BEGIN                    
  --                    
    set @L_VALUES = case when @pa_value = 'B'then 'Business' 
                        when @pa_value = 'F' then 'Farmer'                      
                        when @pa_value =  'H' then 'House Wife'                     
                        when @pa_value = 'O' then 'Others'                                                                   
                        when @pa_value = 'P' then 'Professional'                      
                        when @pa_value = 'R' then 'Retired'                      
                        when @pa_value =  'S' then 'Service'                     
                        when @pa_value =  'ST' then 'Student'  
when @pa_value = 'PV' then 'PRIVATE SECTOR'
						when @pa_value = 'PS' then 'PUBLIC SECTOR'
						when @pa_value = 'GS' then 'GOVERNMENT SERVICES' else '' end                    
  --                    
  END
 IF  @pa_prop_cd = 'CHEQUECASH'  
   SET @L_VALUES = CASE  WHEN @pa_value = 'C' THEN 'CASH'  
        WHEN @pa_value = 'Q' THEN 'CHEQUE' ELSE '' END  
                                 
  ELSE IF @pa_prop_cd = 'GEOGRAPHICAL'                    
  BEGIN                    
  --                    
    set @L_VALUES = case when @pa_value = 'M' then 'Metropolitian'                      
                        when @pa_value = 'O'  then 'Others'                    
                        when @pa_value = 'R' then 'Rural'                     
                        when @pa_value = 'SU' then 'Semi Urban'                                                                 
                        when @pa_value = 'U' then 'Urban' else '' end                    
                                           
                    
  --                    
  END                    
  ELSE IF @pa_prop_cd = 'EDUCATION'                    
  BEGIN                    
  --                    
    set @L_VALUES = case when @pa_value = '01' then  'High School'                    
                        when @pa_value = '02'   then 'Graduate'                   
                        when @pa_value = '03'  then 'Post Graduate'                    
                        when @pa_value = '04'  then 'Doctrate'                                                                 
                        when @pa_value =  '05'   then 'Proffessional Degree'                   
                        when @pa_value =  '06' then 'Under High School'                          
                        when @pa_value =     '08'        then 'Others'                     
                        when @pa_value =    '07'     then 'Illiterate' else '' end                    
                                           
  --                    
  END            
  --            
  --            
  ELSE IF @pa_prop_cd = 'TRADINGTYPE'        --Vivek/JItesh on 25 feb for citrus 2 class migration             
  BEGIN                    
  --                    
    set @L_VALUES = case when @pa_value = 'ASIAN CERC' then 'ASIAN CERC'                     
                        when @pa_value = 'WEB' then 'WEB'                     
                        when @pa_value = 'ODIN DIET' then 'ODIN DIET'                     
                        else ''  end            
  END            
  --            
  --        
  ELSE IF @pa_prop_cd = 'GROUP_CD'        --Vivek/JItesh on 12 MAR for DP CDSL migration             
  BEGIN                    
  --                    
    set @L_VALUES = case when @pa_value = 'ZZZ' then   'INDIVIDUAL'                   
                        when @pa_value = '013' then  'PWG'                     
                        when @pa_value =  'MTF' then 'PLATINUM'        
                        when @pa_value =  '018' then 'KOK'        
                        when @pa_value = 'IPO' then 'IPO' 
                        when @pa_value = 'PMS' then 'PMS'
                        when @pa_value =  '000' then 'CM'        
                    else ''  end            
  END         
  --            
  ELSE IF @pa_prop_cd = 'GROUP'  --For class migration                     
 BEGIN                    
  --                    
    set @L_VALUES = case when @pa_value = 'BTST' then 'BTST'                     
                        when @pa_value = 'DIAMOND' then 'DIAMOND'                     
                        when @pa_value = 'EMP' then 'EMP'                     
                        when @pa_value = 'GOLD' then 'GOLD'                                                                 
                        when @pa_value = 'PWG' then 'PWG'                     
                        when @pa_value = 'PWG - POA' then 'PWG - POA'                          
                        when @pa_value = 'PWG PLATIN'     then 'PWG PLATIN'                     
                        when @pa_value = 'PWGDIRECT'    then 'PWGDIRECT'                    
                        when @pa_value = 'SATYAM'    then 'SATYAM'             
                        when @pa_value = 'PLATINUM'    then 'PLATINUM'             
                        when @pa_value = 'PMS'    then 'PMS'             
                        when @pa_value = 'PMSDIRECT'    then 'PMSDIRECT'             
                        when @pa_value = 'PCG'   then 'PCG'                    
                        when @pa_value = 'WIPRO'   then 'WIPRO'                    
                        when @pa_value = 'YOKOGAWA'   then 'YOKOGAWA'                    
                        when @pa_value = ''   then 'SELECT'         
                        else ''   end                               
  END            
  --            
  --                     
  ELSE IF @pa_prop_cd = 'ANNUAL_INCOME'                    
  BEGIN                    
  --                    
    set @L_VALUES = case when @pa_value = '1' then 'UPTO 1 LAKHS'                     
                        when @pa_value =  '2'  then '1 Lakh To 2 Lakhs'                    
                        when @pa_value = '3'  then     '2 Lakh To 5 Lakhs'                
                        when @pa_value = '4'  then '5 Lakhs & above'                                                                 
                        when @pa_value =  '5' then 'Not Available'      
when @pa_value = '6' then '1 LAC - 5 LACS'
when @pa_value = '7' then '5 LACS - 10 LACS'
when @pa_value = '8' then '10 LACS - 25 LACS'
when @pa_value = '9' then '> 25 LACS'
when @pa_value = '10' then '25 LACS - 1 CRORE'
when @pa_value = '11' then '> 1 CRORE'               
                        else '' end                    
  --                    
  END                    
  ELSE IF @pa_prop_cd = 'BANKCCY' or @pa_prop_cd = 'DIVBANKCCY' or @pa_prop_cd = 'DIVIDEND_CURRENCY'                    
  BEGIN                    
  --                    
    set @L_VALUES = case when @pa_value = '999001'  then 'Indian Rupee'                     
                        when @pa_value = '999002' then  'US Dollor'                    
                        when @pa_value = '999003'  then      'UK Pound'               
                        else '' end                    
  --                    
  END         
  --        
  ELSE IF @pa_prop_cd = 'PAY_MODE'   --Added on 11/mar/2008                 
  BEGIN                    
  --                    
    set @L_VALUES = case when @pa_value = 'C' then  'CHEQUE'                    
                        when @pa_value =  'S' then 'CHEQUE CSV'                     
                        when @pa_value =  'T' then  'TRANSFER LETTER'                    
                        when @pa_value =  'P' then 'PAY ORDER INSTRUCTION LETTER'                                                                
                        when @pa_value =  'D' then 'DD CSV'    
                        when @pa_value =  'H' then 'CHEQUE HAND DELIVERY'                      
                        when @pa_value =  'R' then 'CHEQUE BY COURIER'    
                        when @pa_value =  'Q' then 'CHEQUE DEPOSITED AT HO'    
                        else '' end                    
  --                    
  END         
  --         
  ELSE IF @pa_prop_cd = 'B3B_PAYMENT'   --Added on 11/mar/2008                 
  BEGIN                    
  --                    
    set @L_VALUES = case when @pa_value = '0' then 'ON ACCOUNT'                       
                        when @pa_value =  '1' then 'BILL 2 BILL'                     
                        when @pa_value =  '2' then 'BILL 2 BILL ADJ'                     
                        else '' end                    
  --                    
  END        
  --        
  --                  
  ELSE IF @pa_prop_cd = 'NATIONALITY'                    
  BEGIN                    
  --                    
    set @L_VALUES = case when @pa_value = '01' then   'Indian'                   
                        when @pa_value = '03' then 'Uk'                     
                        when @pa_value = '05' then  'Japan'                    
                        when @pa_value = '07' then   'Germany'                               
                        when @pa_value = '09' then    'Canada'                  
                        else '' end                    
                                            
  --                    
  END                    
  ELSE IF @pa_prop_cd = 'BOSTMNTCYCLE'                    
  BEGIN            
  --                    
    set @L_VALUES = case when @pa_value = '01' then 'First of month'                     
                        when @pa_value =  'DA' then 'Daily'                     
                        when @pa_value =  '08' then 'Eight of month'                     
                     when @pa_value =  '2M' then 'Twice Monthly - 15 & End of month'                                                                 
                        when @pa_value = 'EM' then 'End of Month'                     
                        when @pa_value =  'EW' then 'End of week'                          
                        else '' end                    
  --                    
  END                    
  ELSE IF @pa_prop_cd = 'TRXFREQ' or @pa_prop_cd = 'HLDNGFREQ' or @pa_prop_cd = 'BILLFREQ'                    
  BEGIN                    
  --                    
    set @L_VALUES = case when @pa_value = '1' then 'Daily'                     
                        when @pa_value =  '2' then 'Weekly'                     
                        when @pa_value =  '3' then 'Fortnightly'                     
                        when @pa_value =  '4'  then 'Monthly'                                                                
                        when @pa_value =  '5' then 'Quaterly'                     
                        else '' end                    
  --                    
  END                  
  --                  
  ELSE IF @pa_prop_cd = 'KEEPSETTLEMENT'     --vivek/jitesh on 19 feb 2008                  
  BEGIN                  
  --                  
  set @L_VALUES =   case when @pa_value = 'I' then 'FAX IND'                     
                        when @pa_value = 'T' then 'FAX IND & FR FOR WEB'                      
                        when @pa_value =  'C' then 'FAX IND & SP CL'                     
                        when @pa_value = 'Y' then 'FAX IND FR WEB & SC'                                                                 
                        when @pa_value = 'F' then 'FRZ FOR WEB'                      
                        when @pa_value = 'M' then 'SP CL & FR WEB'                  
  when @pa_value = 'S'  then   'SP CLIENT'               
                        else 'N' end                  
  --                  
  END                  
  --                  
  --                  
  ELSE IF @pa_prop_cd = 'KEEPSETTLEMENT_NSDL'     --vivek/jitesh on 19 feb 2008                  
  BEGIN                  
  --                  
  set @L_VALUES = case when @pa_value = 'T' then 'FAX IND'                     
                        when @pa_value = 'D' then  'FAX IND WEB UPL & SC'                    
                        when @pa_value = 'L' then     'SP CL & FAX IND'                 
                        when @pa_value = 'S'  then 'SP CL & WEB UPL'                                                                
                        when @pa_value = 'M' then 'SP CLIENT'                     
                        when @pa_value = 'I' then 'WEB UPL & FAX IDM'                  
                        when @pa_value =  'N' then 'WEB UPLOAD'                  
                        else '' end                  
  --                  
  END                  
  --                  
  --                     
  ELSE IF @pa_prop_cd = 'TAX_DEDUCTION'                    
  BEGIN                    
  --                    
    set @L_VALUES = case when @pa_value = '01'  then  'Exempt'                    
                        when @pa_value= '02' then 'Resident Individual'                     
                        when @pa_value=  '03' then 'NRI With Repatriation'                     
                        when @pa_value= '04' then    'NRI Without Repatriation'                  
                        when @pa_value=  '05' then 'Domestic Companies'                     
                        when @pa_value=  '06' then 'Overseas Corporate Bodies'                     
                        when @pa_value=  '07' then 'Foreign Companies'                      
                        when @pa_value= '08'then    'Mutual Funds'                   
                        when @pa_value= '09' then  'Double Taxation Treaty'                      
                        when @pa_value= '10' then 'Others' else ''end                     
  --                    
  END                    
  ELSE IF @pa_prop_cd = 'LANGUAGE'                    
  BEGIN              
  --                    
    set @L_VALUES = case when @pa_value = '1' then 'Assamese'                      
                        when @pa_value= '3' then   'English'                   
                        when @pa_value= '5' then  'Hindi'                    
                        when @pa_value=  '7' then 'Kashmiri'                     
                        when @pa_value= '9' then 'Marathi'                     
                        when @pa_value= '11' then 'Punjabi'                     
                        when @pa_value= '13' then 'Sindhi'                     
                        when @pa_value= '15' then 'Telegu'    
                        when @pa_value= '4' then 'Gujarati'   
                        when @pa_value= '14' then 'Tamil'   
                        when @pa_value= '16' then 'Urdu'   
                        when @pa_value= '6' then 'Kannada'                  
                        else '' end                     
                                            
                                           
  --                    
  END      
  -- 
  end
  RETURN ISNULL(@L_VALUES,'')  
   
--  
end

GO
