-- Object: FUNCTION citrus_usr.cdsl_ctgry_enttm_subcm_mapping_26042012
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

/*SELECT DISTINCT TMPCLI_ACCT_CTRGY FROM TMP_CLIENT_DTLS_MSTR_CDSL tcdmc    
SELECT DISTINCT enttm_desc,enttm_cd FROM entity_type_mstr    
    
SELECT DISTINCT TMPCLI_BO_STAT  FROM TMP_CLIENT_DTLS_MSTR_CDSL tcdmc    
SELECT clicm_desc, clicm_cd FROM client_ctgry_mstr    
    
SELECT DISTINCT TMPCLI_BO_SUB_STAT  FROM TMP_CLIENT_DTLS_MSTR_CDSL tcdmc    
SELECT DISTINCT subcm_desc,subcm_cd FROM sub_ctgry_mstr  ORDER BY subcm_desc    
*/    
--SELECT citrus_usr.cdsl_ctgry_enttm_subcm_mapping('Clearing Member Account','enttm')    
create FUNCTION [citrus_usr].[cdsl_ctgry_enttm_subcm_mapping_26042012](@pa_desc varchar(100),@pa_type varchar(10))    
RETURNS varchar(50)    
AS    
BEGIN    
 --    
   DECLARE @l_cd varchar(50)    
   IF @pa_type = 'enttm'    
   SET @l_cd  = CASE WHEN @pa_desc = 'Clearing Member Account' THEN '14_CDSL'    
                WHEN @pa_desc = 'CM Pool' THEN '12_CDSL'    
       WHEN @pa_desc = 'CM Principal' THEN '02_CDSL'    
       WHEN @pa_desc = 'Regular BO' THEN '01_CDSL'    
                end    
   IF @pa_type = 'clicm'    
   SET @l_cd  = CASE WHEN @pa_desc = 'Clearing Member' THEN '26'    
                WHEN @pa_desc = 'Corporate' THEN '25'    
       WHEN @pa_desc = 'Individual' THEN '21'    
       WHEN @pa_desc = 'FI' THEN '22'    
       WHEN @pa_desc = 'FII' THEN '23'    
       WHEN @pa_desc = 'Foreign National' THEN '27'    
       WHEN @pa_desc = 'Mutual Funds' THEN '28'    
                WHEN @pa_desc = 'Trusts' THEN '29'    
                WHEN @pa_desc = 'Bank' THEN '30_CDSL'    
                WHEN @pa_desc = 'NRI' THEN '24' end    
       
   IF @pa_type = 'subcm'    
   SET @l_cd  = CASE WHEN @pa_desc = 'Clearing Member' THEN '192624'    
                     WHEN @pa_desc = 'Corporate Body-Domestic' THEN '022512'    
         WHEN @pa_desc = 'Individual-Director' THEN '012101'    
         WHEN @pa_desc = 'Individual-Resident' THEN '012103'    
         WHEN @pa_desc = 'NRI-Non Repatriable' THEN '032411'    
         WHEN @pa_desc = 'NRI-Repatriable' THEN '032410'    
         WHEN @pa_desc = 'Individual-Directors Relative' THEN '012102'    
         WHEN @pa_desc = 'Individual-HUFS/AOPs' THEN '082104'    
		 WHEN @pa_desc = 'Individual-HUFS' THEN '082104'
		 WHEN @pa_desc = 'Individual-HUF' THEN '082104'
         WHEN @pa_desc = 'Individual-Promoters' THEN '012140'    
         WHEN @pa_desc = 'Individual-Margin Trading Account' THEN '362142'    
         WHEN @pa_desc = 'Individual-Commodity' THEN '392144'    
         WHEN @pa_desc = 'Individual-HUF-Margin Trading account' THEN '082147'    
         WHEN @pa_desc = 'FI-Govt Sponsored FI' THEN '052205'  
         WHEN @pa_desc = 'FI-SFC' THEN '042206'      
         WHEN @pa_desc = 'FI-Others' THEN '042207'      
         WHEN @pa_desc = 'FII-Mauritius based' THEN '052308'      
         WHEN @pa_desc = 'FII-Others' THEN '052309'      
         WHEN @pa_desc = 'FII-Depositary Receipt' THEN '052334'      
         WHEN @pa_desc = 'NRI Repatriable' THEN '2448'      
         WHEN @pa_desc = 'NRI Non Repatriable' THEN '032411'      
         WHEN @pa_desc = 'NRI-Depositary Receipt' THEN '032435'      
         WHEN @pa_desc = 'Corporate Body-Domestic' THEN '022512'      
         WHEN @pa_desc = 'Corporate Body-OCB' THEN '022513'      
         WHEN @pa_desc = 'Corporate Body-Government Co.' THEN '022514'      
         WHEN @pa_desc = 'Corporate Body-Central Government' THEN '022515'     
         WHEN @pa_desc = 'Corporate Body-State Govt' THEN '022516'      
         WHEN @pa_desc = 'Corporate Body-Co-operative bank' THEN '022517'     
         WHEN @pa_desc = 'Corporate Body-NBFC' THEN '022518'      
         WHEN @pa_desc = 'Corporate Body-Non NBFC' THEN '022519'     
         WHEN @pa_desc = 'Corporate Body-Broker' THEN '022520'      
         WHEN @pa_desc = 'Corporate Body-Group Company' THEN '022521'     
         WHEN @pa_desc = 'Corporate Body-Foreign bodies' THEN '022522'      
         WHEN @pa_desc = 'Corporate Body-Others' THEN '022523'     
         WHEN @pa_desc = 'Corporate Body-OCB-Depository Receipt' THEN '022536'      
         WHEN @pa_desc = 'Corporate Body-Depository Receipt' THEN '022538'     
         WHEN @pa_desc = 'Corporate Body-Promoter' THEN '022541'      
         WHEN @pa_desc = 'Corporate-Margin Trading Account' THEN '022551'     
         WHEN @pa_desc = 'Corporate-Commodity' THEN '022545'      
         WHEN @pa_desc = 'Clearing Member' THEN '0600'     
         WHEN @pa_desc = 'Foreign National ' THEN '182725'      
         WHEN @pa_desc = 'Foreign National-Depositary Receipt' THEN '182737'     
         WHEN @pa_desc = 'Mutual Fund' THEN '062826'   
         WHEN @pa_desc = 'Trusts' THEN '242927'   
         WHEN @pa_desc = 'Bank-Foreign' THEN '073028'   
         WHEN @pa_desc = 'Bank-Co-Operative' THEN '073029'   
         WHEN @pa_desc = 'Bank-Nationalised' THEN '073030'   
         WHEN @pa_desc = 'Bank-Others' THEN '073031'   
         WHEN @pa_desc = 'Bank-Depositary Receipt' THEN '073039'   
         WHEN @pa_desc = 'Bank-Commodity' THEN '413046'  
		 WHEN @pa_desc = 'Corporate CM/TM - Client Beneficiary A/c' THEN '022552'
		 WHEN @pa_desc = 'Corporate CM/TM - Client Margin A/c' THEN '022551'
         WHEN @pa_desc = 'RESIDENT INDIVIDUAL - MINOR' THEN '012158' 
         WHEN @pa_desc = 'RESIDENT NON RESIDENT INDIAN - MINOR' THEN '032458'
         WHEN @pa_desc = 'RESIDENT FOREIGN NATIONAL - MINOR' THEN '182758'
		 WHEN @pa_desc = 'ASSOCIATION OF PERSONS [AOP]' THEN '012168'
         WHEN @pa_desc = 'INDIVIDUAL- RESIDENT NEGATIVE NOMINATION' THEN '012169'
         WHEN @pa_desc = 'NRI REPATRIABLE NEGATIVE NOMINATION' THEN '032470'
         WHEN @pa_desc = 'NRI NON-REPATRIABLE NEGATIVE NOMINATION' THEN '032471'
         WHEN @pa_desc = 'FOREIGN NATIONAL NEGATIVE NOMINATION' THEN '182772' 
                 end    
       
   RETURN isnull(@l_cd,'')    
 --    
END

GO
