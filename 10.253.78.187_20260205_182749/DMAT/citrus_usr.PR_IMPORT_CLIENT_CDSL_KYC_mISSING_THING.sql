-- Object: PROCEDURE citrus_usr.PR_IMPORT_CLIENT_CDSL_KYC_mISSING_THING
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--BEGIN TRAN
--EXEC  PR_IMPORT_CLIENT_CDSL_KYC_mISSING_THING 'CDSL','mig','','','','',''
--COMMIT
CREATE PROCEDURE  [citrus_usr].[PR_IMPORT_CLIENT_CDSL_KYC_mISSING_THING]
			(
			 @PA_EXCH          VARCHAR(20)    
            ,@PA_LOGIN_NAME    VARCHAR(20)    
            ,@PA_MODE          VARCHAR(10)                                    
            ,@PA_DB_SOURCE     VARCHAR(250)    
            ,@ROWDELIMITER     CHAR(4) =     '*|~*'      
            ,@COLDELIMITER     CHAR(4) =     '|*~|'      
            ,@PA_ERRMSG        VARCHAR(8000) OUTPUT    
            )      
AS    
/*    
*********************************************************************************    
 SYSTEM         : DP    
 MODULE NAME    : P  
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE UPDATE QUERIES FOR MASTER TABLES    
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIES     
 VERSION HISTORY: 1.0    
 VERS.  AUTHOR            DATE          REASON    
 -----  -------------     ------------  --------------------------------------------------    
 1.0    TUSHAR            08-OCT-2007   VERSION.    
-----------------------------------------------------------------------------------*/    
BEGIN    
--  
SET NOCOUNT ON  

set dateformat dmy
  
truncate table API_CLIENT_MASTER_SYNERGY_dp
insert into  API_CLIENT_MASTER_SYNERGY_dp 
select * from kyc..API_CLIENT_MASTER_SYNERGY

 DECLARE @C_CLIENT_SUMMARY CURSOR  
           , @C_BEN_ACCT_NO    VARCHAR(16)  
           , @L_CLIENT_VALUES  VARCHAR(8000)  
           , @L_CRN_NO NUMERIC  
           , @L_DPM_DPID VARCHAR(20)  
           , @L_COMPM_ID NUMERIC  
           , @L_DP_ACCT_VALUES VARCHAR(8000)  
           , @L_EXCSM_ID NUMERIC  
           , @L_ADR VARCHAR(8000)  
           , @L_CONC VARCHAR(8000)  
           , @L_BR_SH_NAME VARCHAR(50)  
           , @L_ENTR_VALUE VARCHAR(8000)  
           , @L_DPBA_VALUES VARCHAR(8000)  
           , @L_ENTP_VALUE VARCHAR(8000)  
           , @C_CX_PANNO  VARCHAR(50)  
           , @L_ENTPD_VALUE VARCHAR(8000)  
           , @L_ACCP_VALUE  VARCHAR(8000)  
           , @L_ACCPD_VALUE  VARCHAR(8000)  
           , @L_DPAM_ID NUMERIC  
           , @L_BANK_NAME VARCHAR(150)  
           , @L_ADDR_VALUE VARCHAR(8000)  
           , @L_BANM_BRANCH VARCHAR(250)  
           , @L_MICR_NO VARCHAR(20)  
           , @L_BANM_ID NUMERIC  
           , @L_ACC_CONC VARCHAR(8000)   
           , @L_CLI_EXISTS_YN CHAR(1)  
		   , @@BOCTGRY VARCHAR(10)  
		   , @@HO_CD VARCHAR(20)  
		   , @L_DPPD_DETAILS VARCHAR(8000)  

		   , @@l_error               INTEGER            

		  
       
  SELECT TOP 1 @@HO_CD = LTRIM(RTRIM(ISNULL(ENTM_SHORT_NAME,'HO'))) FROM ENTITY_MSTR WHERE ENTM_ENTTM_CD = 'HO'  
                         
 
          
     
		
                           
        SET @C_CLIENT_SUMMARY  = CURSOR FAST_FORWARD FOR                
        SELECT kit_no  
		FROM API_CLIENT_MASTER_SYNERGY_DP 
		,DP_ACCT_MSTR_MAK WHERE DP_INTERNAL_REF = DPAM_ACCT_NO
        AND DPAM_ID NOT IN (SELECT DPPD_DPAM_ID FROM DP_POA_DTLS_MAK)  
        AND  KIT_NO IN ('P71471'
,'A92413'
,'H33892'
,'S148004'
,'R86361'
,'S147981'
,'RVMS078'
,'M86402'
,'KOLK25907'
,'S148002'
,'S148005')
        OPEN @C_CLIENT_SUMMARY  
          
        FETCH NEXT FROM @C_CLIENT_SUMMARY INTO @C_BEN_ACCT_NO   
          
          
          
        WHILE @@FETCH_STATUS = 0                                                                                                          
        BEGIN --#CURSOR                                                                                                          
        --  
        
        declare @pa_ref_no varchar(100)
        select @pa_ref_no = DP_INTERNAL_REF from API_CLIENT_MASTER_SYNERGY_DP 
        WHERE  KIT_NO = @C_BEN_ACCT_NO  and  purpose_code ='1' 

		SELECT @L_DPM_DPID = DPM_DPID , @L_EXCSM_ID = DEFAULT_DP FROM DP_MSTR , EXCH_SEG_MSTR 
		,API_CLIENT_MASTER_SYNERGY_DP
        WHERE DEFAULT_DP = EXCSM_ID AND  EXCSM_EXCH_CD= 'CDSL'  
		AND dpm_excsm_id = default_dp 
		and KIT_NO = @C_BEN_ACCT_NO 

        SELECT @L_COMPM_ID = EXCSM_COMPM_ID FROM EXCH_SEG_MSTR WHERE EXCSM_ID = @L_EXCSM_ID  

--  set @L_CLIENT_VALUES =''
--SELECT  @L_CLIENT_VALUES = ISNULL(LTRIM(RTRIM(FIRST_NAME)),'') + '|*~|' 
--+ ISNULL(MIDDLE_NAME,'') + '|*~|' 
--+ ISNULL(LAST_NAME,'') + '|*~|'
--+ LEFT(ISNULL(ltrim(rtrim(REPLACE(FIRST_NAME,'~',' '))),'')+'-'+KIT_NO,200)  + '|*~|'
----+ISNULL('','')+'|*~|'+CASE WHEN ISDATE(CONVERT(DATETIME,DATE_OF_BIRTH,103)) = 1 THEN  ISNULL(DATE_OF_BIRTH,'') ELSE '' END 
--+case when ISNULL(SUFFIX,'')='' then 'M' else left(ISNULL(SUFFIX,'') ,1) end+'|*~|'
--+CASE WHEN ISDATE(CONVERT(VARCHAR(11), replace(DATE_OF_BIRTH ,'/' ,' '), 106)) = 1 THEN  ISNULL(convert(varchar(11),convert(datetime,CONVERT(VARCHAR(11), replace(DATE_OF_BIRTH ,'/' ,' '), 106),106),103),'') ELSE '' END 
--+'|*~||*~|CI|*~||*~|1|*~|' + ISNULL(LTRIM(RTRIM(PAN_GIR)),'') +'|*~|*|~*' 
--FROM API_CLIENT_MASTER_SYNERGY_DP WHERE  KIT_NO = @C_BEN_ACCT_NO  and  purpose_code ='1'
--print @L_CLIENT_VALUES
--EXEC citrus_usr.PR_INS_UPD_CLIM  '0','INS','KYC',@L_CLIENT_VALUES,1,'*|~*','|*~|','',''  
 

SELECT DISTINCT @L_CRN_NO = CLIM_CRN_NO FROM CLIENT_MSTR_mak, API_CLIENT_MASTER_SYNERGY_DP
WHERE   KIT_NO = @C_BEN_ACCT_NO 
AND CLIM_SHORT_NAME =  LEFT(ISNULL(ltrim(rtrim(REPLACE(FIRST_NAME,'~',' '))),'')+'-'+KIT_NO,200)
and  purpose_code ='1'
print @L_CRN_NO
set @L_ADR =''
   --        SELECT @L_ADR = 'COR_ADR1|*~|'+ISNULL(LTRIM(RTRIM(ADDRESS1)),'')+'|*~|'
   --        +ISNULL(LTRIM(RTRIM(ADDRESS2)),'')+'|*~|'
   --        +ISNULL(LTRIM(RTRIM(ADDRESS3)),'')+'|*~|'
   --        +ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'
   --        +ISNULL(STATE,'')+ '|*~|'+ISNULL(COUNTRY,'')
   --        +'|*~|'+ISNULL(LTRIM(RTRIM(PIN)),'')+'|*~|*|~*' 
   --        FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='1' AND ISNULL(ADDRESS1,'') <>''  
   --        SELECT @L_ADR = @L_ADR  + 'PER_ADR1|*~|'+ISNULL(LTRIM(RTRIM(ADDRESS1)),'')+'|*~|'
   --        +ISNULL(LTRIM(RTRIM(ADDRESS2)),'')+'|*~|'
   --        +ISNULL(LTRIM(RTRIM(ADDRESS3)),'')+'|*~|'
   --        +ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'
   --        +ISNULL(STATE,'')+ '|*~|'+ISNULL(COUNTRY,'')
   --        +'|*~|'+ISNULL(LTRIM(RTRIM(PIN)),'')+'|*~|*|~*' 
   --        FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='12' AND ISNULL(ADDRESS1,'') <>''  
                
			--EXEC PR_INS_UPD_ADDR @L_CRN_NO,'INS','MIG',@L_CRN_NO,'',@L_ADR,1,'*|~*','|*~|','' 


        
         
--           SELECT @L_CONC = 'OFF_PH1|*~|'+case when PRIME_PHONE_INDI = 'O' then ISNULL(LTRIM(RTRIM(PRIME_PHONE_NO)),'') else '' end +'*|~*'
--           + 'res_PH1|*~|'+case when PRIME_PHONE_INDI ='R' then ISNULL(LTRIM(RTRIM(PRIME_PHONE_NO)),'') else '' end +'*|~*'
--           +'FAX1|*~|'+ISNULL(LTRIM(RTRIM(FAX)),'')+'*|~*'
--           +'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(EMAIL_ID)),'')+'*|~*'  
--		  +'MOBILE1|*~|'+case when PRIME_PHONE_INDI ='M' then ISNULL(LTRIM(RTRIM(PRIME_PHONE_NO)),'') else  ISNULL(LTRIM(RTRIM(MOBILE_NUMBER)),'') end +'*|~*'  
--           FROM    API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and  purpose_code ='1'
           
           
--           SELECT @L_CONC = @L_CONC +'OFF_PH2|*~|'+case when ALT_PHONE_INDI = 'O' then ISNULL(LTRIM(RTRIM(ALT_PHONE_NO)),'') else '' end +'*|~*'
--           + 'RES_PH1|*~|'+case when ALT_PHONE_INDI = 'R' then ISNULL(LTRIM(RTRIM(ALT_PHONE_NO)),'') else '' end+'*|~*'
--           FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and  purpose_code ='12'
          
         
  

--             EXEC PR_INS_UPD_CONC @L_CRN_NO,'INS','KYC',@L_CRN_NO,'',@L_CONC,1,'*|~*','|*~|',''  


--			SELECT @L_DP_ACCT_VALUES = ISNULL(CONVERT(VARCHAR,@L_COMPM_ID),'')+'|*~|'
--			+ ISNULL(CONVERT(VARCHAR,@L_EXCSM_ID),'')+'|*~|'
--			+ISNULL(CONVERT(VARCHAR,@L_DPM_DPID),'')+'|*~|'
--			+ISNULL(DP_INTERNAL_REF,'')+'|*~|'+ISNULL(LTRIM(RTRIM(FIRST_NAME)),'')+' '+ISNULL(LTRIM(RTRIM(MIDDLE_NAME)),'')+' '+ISNULL(LTRIM(RTRIM(LAST_NAME)),'')
--			+'|*~|'+ ISNULL(LTRIM(RTRIM(DP_INTERNAL_REF)),'') +'|*~|'+'CI'+'|*~|'
--			+case when ISNULL(Bo_Customer_Type,'0') in ('1','8','39') then '01_cdsl' 
--			when ISNULL(Bo_Customer_Type,'0') ='2' then '02_cdsl' 
--			else convert(varchar,ISNULL(Bo_Customer_Type,'0'))  end +'|*~|' 
--			+case when len(BO_CATEGORY)=1 then '0' + convert(varchar,BO_CATEGORY ) else convert(varchar,BO_CATEGORY ) end+'|*~|' 
--			+case when len(Bo_Customer_Type)=1 then '0' + convert(varchar,Bo_Customer_Type ) else convert(varchar,Bo_Customer_Type ) end 
--+case when len(BO_CATEGORY)=1 then '0' + convert(varchar,BO_CATEGORY ) else convert(varchar,BO_CATEGORY ) end
--+ case when len(BO_SUB_STATUS)=1 then '0' + convert(varchar,BO_SUB_STATUS ) else convert(varchar,BO_SUB_STATUS ) end+'|*~|0|*~|A|*~|*|~*' 
--			FROM API_CLIENT_MASTER_SYNERGY_DP WHERE  KIT_NO = @C_BEN_ACCT_NO and  purpose_code ='1'  
             
--  print @L_DP_ACCT_VALUES

--           EXEC PR_INS_UPD_DPAM @L_CRN_NO,'INS','KYC',@L_CRN_NO,@L_DP_ACCT_VALUES,1,'*|~*','|*~|',''
             
          
      --DP_ACCT_MSTR  
--           SELECT @L_ADR = 'AC_COR_ADR1|*~|'+ISNULL(LTRIM(RTRIM(ADDRESS1)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(ADDRESS2)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(ADDRESS3)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'
--           +ISNULL(STATE,'')+ '|*~|'+ISNULL(COUNTRY,'')
--           +'|*~|'+ISNULL(LTRIM(RTRIM(PIN)),'')+'|*~|*|~*' 
--           FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='1' 
--           AND ISNULL(ADDRESS1,'') <>''  
--           SELECT @L_ADR = isnull(@L_ADR  ,'')+ 'AC_PER_ADR1|*~|'+ISNULL(LTRIM(RTRIM(ADDRESS1)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(ADDRESS2)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(ADDRESS3)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'
--           +ISNULL(STATE,'')+ '|*~|'+ISNULL(COUNTRY,'')
--           +'|*~|'+ISNULL(LTRIM(RTRIM(PIN)),'')+'|*~|*|~*' 
--           FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='12' AND ISNULL(ADDRESS1,'') <>''  
--           SELECT @L_ADR = isnull(@L_ADR  ,'')  + 'NOMINEE_ADR1|*~|' +ISNULL(LTRIM(RTRIM(ADDRESS1)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(ADDRESS2)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(ADDRESS3)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'
--           +ISNULL(STATE,'')+ '|*~|'+ISNULL(COUNTRY,'')
--           +'|*~|'+ISNULL(LTRIM(RTRIM(PIN)),'')+'|*~|*|~*' 
--           FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='6' 
--           AND ISNULL(ADDRESS1,'') <>''  
--            SELECT @L_ADR = isnull(@L_ADR  ,'')  + 'GUARD_ADR|*~|' +ISNULL(LTRIM(RTRIM(ADDRESS1)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(ADDRESS2)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(ADDRESS3)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'
--           +ISNULL(STATE,'')+ '|*~|'+ISNULL(COUNTRY,'')
--           +'|*~|'+ISNULL(LTRIM(RTRIM(PIN)),'')+'|*~|*|~*' 
--           FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='7' 
--           AND ISNULL(ADDRESS1,'') <>'' 
--            SELECT @L_ADR = isnull(@L_ADR  ,'')  + 'SH_ADR1|*~|' +ISNULL(LTRIM(RTRIM(ADDRESS1)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(ADDRESS2)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(ADDRESS3)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'
--           +ISNULL(STATE,'')+ '|*~|'+ISNULL(COUNTRY,'')
--           +'|*~|'+ISNULL(LTRIM(RTRIM(PIN)),'')+'|*~|*|~*' 
--           FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='2' 
--           AND ISNULL(ADDRESS1,'') <>'' 
--            SELECT @L_ADR = isnull(@L_ADR  ,'')  + 'TH_ADR1|*~|' +ISNULL(LTRIM(RTRIM(ADDRESS1)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(ADDRESS2)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(ADDRESS3)),'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(CITY)),'')+'|*~|'
--           +ISNULL(STATE,'')+ '|*~|'+ISNULL(COUNTRY,'')
--           +'|*~|'+ISNULL(LTRIM(RTRIM(PIN)),'')+'|*~|*|~*' 
--           FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='3' 
--           AND ISNULL(ADDRESS1,'') <>'' 
          
--                       select @L_CRN_NO,'EDT','KYC',0,@pa_ref_no,'DP',@L_ADR,1,'*|~*','|*~|','' 
--           EXEC  PR_DP_INS_UPD_ADDR @L_CRN_NO,'EDT','KYC',0,@pa_ref_no,'DP',@L_ADR,1,'*|~*','|*~|',''   
  
--           SET @L_ADR   = ''  
          
--    --       SELECT @L_ACC_CONC = 'ACCOFF_PH1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_TELPH_NO)),'')+'*|~*'
--    --       +'ACCOFF_PH2|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_TELPHP_NO)),'')+'*|~*'   
--    --       FROM   TMP_CLIENT_DTLS_MSTR_CDSL_KYC WHERE TMPCLI_BOID = @C_BEN_ACCT_NO 
--    --       AND ISNULL(TMPCLI_BO_ADDP_LIN1,'') <> ''  
                           
                           
--    --       SELECT @L_ACC_CONC = 'ACCOFF_PH1|*~|'+case when PRIME_PHONE_INDI = 'O' then ISNULL(LTRIM(RTRIM(PRIME_PHONE_NO)),'') else '' end +'*|~*'
--    --       + 'ACCOFF_PH1|*~|'+case when PRIME_PHONE_INDI ='R' then ISNULL(LTRIM(RTRIM(PRIME_PHONE_NO)),'') else '' end +'*|~*'
--    --                  +'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(EMAIL_ID)),'')+'*|~*'  
--		  --+'MOBILE1|*~|'+case when PRIME_PHONE_INDI ='M' then ISNULL(LTRIM(RTRIM(PRIME_PHONE_NO)),'') else  ISNULL(LTRIM(RTRIM(MOBILE_NUMBER)),'') end +'*|~*'  
--    --       FROM    API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and  purpose_code ='1'
           
           
--    --       SELECT @L_ACC_CONC = @L_ACC_CONC +'OFF_PH2|*~|'+case when ALT_PHONE_INDI = 'O' then ISNULL(LTRIM(RTRIM(ALT_PHONE_NO)),'') else '' end +'*|~*'
--    --       + 'RES_PH1|*~|'+case when ALT_PHONE_INDI = 'R' then ISNULL(LTRIM(RTRIM(ALT_PHONE_NO)),'') else '' end+'*|~*'
--    --       FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and  purpose_code ='12'
          
           
         
--    --       EXEC  PR_DP_INS_UPD_CONC @L_CRN_NO,'EDT','KYC',0,@C_BEN_ACCT_NO,'DP',@L_ACC_CONC,1,'*|~*','|*~|',''   
  
----           SET @L_ACC_CONC = ''  
                            
--      --DP_HOLDER_DTLS/ADDRESSES/CONCTACT_CHANNELS  
--           DECLARE @PA_FH_DTLS VARCHAR(8000)  
--                  ,@PA_SH_DTLS VARCHAR(8000)  
--                  ,@PA_TH_DTLS VARCHAR(8000)  
--                  ,@PA_NOMGAU_DTLS VARCHAR(8000)  
--                  ,@PA_NOM_DTLS VARCHAR(8000)  
--                  ,@PA_GAU_DTLS VARCHAR(8000)  
  
--           SELECT @PA_FH_DTLS = ''+'|*~|'+''+'|*~|'+''+'|*~|'+ISNULL(LTRIM(RTRIM(FATHER_NAME)),'')
--           +'|*~|'+''+'|*~|'+''+'|*~|'+''+'|*~|*|~*' 
--           FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='1' 
           
           
--           SELECT @PA_SH_DTLS =ISNULL(FIRST_NAME,'') 
--           +'|*~|'+ISNULL(MIDDLE_NAME,'')+'|*~|'
--           +ISNULL(LAST_NAME,'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(FATHER_NAME)),'')+'|*~|'++'|*~|'+ISNULL(LTRIM(RTRIM(PAN_GIR)),'')+'|*~|'
--           +'|*~|*|~*'  
--            FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='2' 
           
--           SELECT @PA_TH_DTLS = ISNULL(FIRST_NAME,'') 
--           +'|*~|'+ISNULL(MIDDLE_NAME,'')+'|*~|'
--           +ISNULL(LAST_NAME,'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(FATHER_NAME)),'')+'|*~|'++'|*~|'+ISNULL(LTRIM(RTRIM(PAN_GIR)),'')+'|*~|'
--           +'|*~|*|~*'  
--            FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='3' 
           
--           SELECT @PA_NOMGAU_DTLS =ISNULL(FIRST_NAME,'') 
--           +'|*~|'+ISNULL(MIDDLE_NAME,'')+'|*~|'
--           +ISNULL(LAST_NAME,'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(FATHER_NAME)),'')+'|*~|'++'|*~|'+ISNULL(LTRIM(RTRIM(PAN_GIR)),'')+'|*~|'
--           +'|*~|*|~*'  
--            FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='8' 
           
--           SELECT @PA_NOM_DTLS = ISNULL(FIRST_NAME,'') 
--           +'|*~|'+ISNULL(MIDDLE_NAME,'')+'|*~|'
--           +ISNULL(LAST_NAME,'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(FATHER_NAME)),'')+'|*~|'++'|*~|'+ISNULL(LTRIM(RTRIM(PAN_GIR)),'')+'|*~|'
--           +'|*~|*|~*'  
--            FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='6' 
            
--           SELECT @PA_GAU_DTLS =ISNULL(FIRST_NAME,'') 
--           +'|*~|'+ISNULL(MIDDLE_NAME,'')+'|*~|'
--           +ISNULL(LAST_NAME,'')+'|*~|'
--           +ISNULL(LTRIM(RTRIM(FATHER_NAME)),'')+'|*~|'++'|*~|'+ISNULL(LTRIM(RTRIM(PAN_GIR)),'')+'|*~|'
--           +'|*~|*|~*'  
--            FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='7' 
  


--           EXEC PR_INS_UPD_DPHD '0',@L_CRN_NO,@pa_ref_no,'INS','KYC',@PA_FH_DTLS,@PA_SH_DTLS,@PA_TH_DTLS,@PA_NOMGAU_DTLS,@PA_NOM_DTLS,@PA_GAU_DTLS,1,'*|~*','|*~|',''               


--			set @PA_FH_DTLS = ''
--			set @PA_SH_DTLS = ''
--			set @PA_TH_DTLS = ''
--			set @PA_NOMGAU_DTLS = ''
--			set @PA_NOM_DTLS = ''
--			set @PA_GAU_DTLS = ''



--            DECLARE @L_ACTIVATION_DT VARCHAR(20)  

--            SELECT @L_ACTIVATION_DT = CONVERT(varchar(11),GETDATE(),103) 
----  
--            declare @l_ar varchar(250)
--			,@l_br varchar(250)
--			,@l_re varchar(250)
--			,@l_sub varchar(250)
--			,@l_tra varchar(250)
--			,@l_ba VARCHAR(250)
--			,@L_REM VARCHAR(250)
--			,@L_ONW VARCHAR(250)

--			SET @l_ar = ''
--			SET @l_br = ''
--			SET @l_re = ''
--			SET @l_sub = ''
--			SET @l_tra = ''
--			SET @l_ba = ''
--			SET @L_REM = ''
--			SET @L_ONW = ''
			
--			--SELECT @l_ar  = ISNULL(ENTM_SHORT_NAME,'') FROM ENTITY_MSTR 
--			--									   , TMP_CLIENT_DTLS_MSTR_CDSL_KYC 
--			--									    WHERE ENTM_SHORT_NAME = TMPCLI_AR + '_AR' 
--			--									    AND ENTM_DELETED_IND = 1 AND TMPCLI_BOID = @C_BEN_ACCT_NO  
--			--										AND ENTM_ENTTM_CD ='AR'
--			--SELECT @l_re = ISNULL(ENTM_SHORT_NAME,'') FROM ENTITY_MSTR , TMP_CLIENT_DTLS_MSTR_CDSL_KYC 
--			--									    WHERE ENTM_SHORT_NAME = TMPCLI_RE + '_RE' AND ENTM_DELETED_IND = 1 AND TMPCLI_BOID = @C_BEN_ACCT_NO  
--			--										AND ENTM_ENTTM_CD ='RE'
--			--SELECT @l_br = ISNULL(ENTM_SHORT_NAME,'') FROM ENTITY_MSTR , TMP_CLIENT_DTLS_MSTR_CDSL_KYC 
--			--									    WHERE ENTM_SHORT_NAME = TMPCLI_BR + '_BR' AND ENTM_DELETED_IND = 1 AND TMPCLI_BOID = @C_BEN_ACCT_NO  
--			--										AND ENTM_ENTTM_CD ='BR'
--			--SELECT @l_ba = ISNULL(ENTM_SHORT_NAME,'') FROM ENTITY_MSTR , TMP_CLIENT_DTLS_MSTR_CDSL_KYC 
--			--									    WHERE ENTM_SHORT_NAME = TMPCLI_BR + '_BA' AND ENTM_DELETED_IND = 1 AND TMPCLI_BOID = @C_BEN_ACCT_NO  
--			--										AND ENTM_ENTTM_CD ='BA'
--			--SELECT @L_REM= ISNULL(ENTM_SHORT_NAME,'') FROM ENTITY_MSTR , TMP_CLIENT_DTLS_MSTR_CDSL_KYC 
--			--									    WHERE ENTM_SHORT_NAME = TMPCLI_SUB + '_REM' AND ENTM_DELETED_IND = 1 AND TMPCLI_BOID = @C_BEN_ACCT_NO  
--			--										AND ENTM_ENTTM_CD ='REM'
--			--SELECT @L_ONW= ISNULL(ENTM_SHORT_NAME,'') FROM ENTITY_MSTR , TMP_CLIENT_DTLS_MSTR_CDSL_KYC 
--			--									    WHERE ENTM_SHORT_NAME = TMPCLI_SUB + '_ONW' AND ENTM_DELETED_IND = 1 AND TMPCLI_BOID = @C_BEN_ACCT_NO  
--			--										AND ENTM_ENTTM_CD ='ONW'
			
			


			
  
--            SELECT @L_ENTR_VALUE = CONVERT(VARCHAR,ISNULL(@L_COMPM_ID,0))+'|*~|'
--            +CONVERT(VARCHAR,ISNULL(@L_EXCSM_ID,'0'))+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(@pa_ref_no,'')+'|*~|'
--            +CONVERT(VARCHAR,@L_ACTIVATION_DT)+'|*~|HO|*~|' + @@HO_CD + '|*~|RE|*~|'+@l_re+'|*~|AR|*~|'
--            +@l_AR+'|*~|BR|*~|'+@l_BR+'|*~|BA|*~|'+@l_ba+'|*~|REM|*~|'+@l_REM+'|*~|ONW|*~|'
--            +@l_ONW+'|*~|A*|~*'  

--            EXEC PR_INS_UPD_DPENTR '0','','KYC',@L_CRN_NO,@L_ENTR_VALUE ,1,'*|~* ','|*~|',''  
 
--            SET @L_ACTIVATION_DT = ''  
  

--				DECLARE @L_BROM_ID VARCHAR(100), @L_BRKG_VAL VARCHAR(1000)
--				SET @L_BROM_ID  = ''
--                SELECT @L_ACTIVATION_DT = CONVERT(varchar(11),GETDATE(),103) 
--                SELECT @L_BROM_ID = BROM_ID FROM BROKERAGE_MSTR where BROM_DESC ='1'
				 

--                SET @L_BRKG_VAL = CONVERT(VARCHAR,@L_COMPM_ID)  +'|*~|'+CONVERT(VARCHAR,@L_EXCSM_ID) +'|*~|'+ ISNULL(@L_DPM_DPID,'') + '|*~|'+ LTRIM(RTRIM(@pa_ref_no)) +'|*~|' + @L_ACTIVATION_DT+'|*~|'+ @L_BROM_ID +'|*~|A*|~*'

--				IF @L_BROM_ID  <> ''
--				EXEC PR_INS_UPD_CLIENT_BRKG @L_CRN_NO,'','KYC',@L_CRN_NO,@L_BRKG_VAL,1,'*|~*','|*~|',''




--            declare  @l_rtgs_cd varchar(100)
--            declare @l_bankname varchar(1000)
--            set @l_bankname  = '' 
--  set @l_rtgs_cd = ''
--  set @L_MICR_NO = ''
  
--            SELECT @L_MICR_NO = DIVI_MICR_CODE,@l_rtgs_cd =DIVI_IFS_CODE   
--            FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='1' 
            
--             SET @L_BANM_ID = 0  
             
--             set @l_bankname = @l_rtgs_cd+'-'+@L_MICR_NO
--             IF EXISTS(SELECT BANM_ID FROM BANK_MSTR WHERE banm_rtgs_cd = @l_rtgs_cd  and BANM_MICR = @L_MICR_NO)  
--             BEGIN  
--                SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE banm_rtgs_cd = @l_rtgs_cd  and BANM_MICR = @L_MICR_NO
--             END  
--             ELSE   
--             BEGIN  
                
--               EXEC PR_MAK_BANM  '0','INS','KYC',@l_rtgs_cd,@l_bankname,@L_MICR_NO,@l_rtgs_cd,'','',0,0,'',0,'','*|~*','|*~|',''  
                 
                
--               SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE banm_rtgs_cd = @l_rtgs_cd  and BANM_MICR = @L_MICR_NO
--             END  
                              
  
  
    
  
--  		SELECT @L_DPBA_VALUES = CONVERT(VARCHAR,@L_COMPM_ID)  +'|*~|'+CONVERT(VARCHAR,@L_EXCSM_ID) +'|*~|'
--  		+ ISNULL(@L_DPM_DPID,'') + '|*~|'+ LTRIM(RTRIM(@pa_ref_no)) +'|*~|' 
--  		+isnull(FIRST_NAME,'') +' ' + isnull(MIDDLE_NAME,'') + ' ' +isnull(LAST_NAME,'')
--  		+ '|*~|'+ CONVERT(VARCHAR,@L_BANM_ID ) +'|*~|'
--  		+ CASE WHEN DIVI_ACCOUNT_TYPE  = '10' THEN 'SAVINGS'
--  		 WHEN DIVI_ACCOUNT_TYPE = '11' THEN 'CURRENT' ELSE 'OTHERS' END +'|*~|' 
--  		 + CONVERT(VARCHAR,LTRIM(RTRIM(DIVI_BANK_ACCOUNT_NO ))) + '|*~|1|*~|0|*~|A*|~*'  
--       FROM   API_CLIENT_MASTER_SYNERGY_DP WHERE KIT_NO = @C_BEN_ACCT_NO and    purpose_code ='1' 

--       EXEC PR_INS_UPD_DPBA '0','INS','KYC',@L_CRN_NO,@L_DPBA_VALUES,1,'*|~*','|*~|',''  

  
       
         SET @L_ACCP_VALUE = ''  
         SELECT DISTINCT  @L_ACCP_VALUE = CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM('')),'')) + '|*~|*|~*' FROM API_CLIENT_MASTER_SYNERGY_DP ,ACCOUNT_PROPERTY_MSTR WHERE kit_no = @C_BEN_ACCT_NO AND ACCPM_PROP_CD = 'SEBI_REG_NO'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM('')),'')) + '|*~|*|~*'  FROM API_CLIENT_MASTER_SYNERGY_DP ,ACCOUNT_PROPERTY_MSTR WHERE kit_no = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'CMBP_ID'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(RBI_REFERENCE_NUMBER )),'')) + '|*~|*|~*' FROM API_CLIENT_MASTER_SYNERGY_DP ,ACCOUNT_PROPERTY_MSTR  WHERE kit_no = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'RBI_REF_NO'  
		 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(KIT_NO)),'')) + '|*~|*|~*' FROM API_CLIENT_MASTER_SYNERGY_DP ,ACCOUNT_PROPERTY_MSTR  WHERE kit_no = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'BBO_CODE'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','GROUP_CD',UPPER(ISNULL(LTRIM(RTRIM(GROUP_CODE )),'')))) + '|*~|*|~*' FROM API_CLIENT_MASTER_SYNERGY_DP ,ACCOUNT_PROPERTY_MSTR  WHERE kit_no = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'GROUP_CD'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(ELECTRONIC_CONF )),''))='Y' THEN '1' ELSE '0' END  + '|*~|*|~*'  FROM API_CLIENT_MASTER_SYNERGY_DP ,ACCOUNT_PROPERTY_MSTR WHERE kit_no = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'ELEC_CONF'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','BANKCCY',UPPER(ISNULL(LTRIM(RTRIM(DIVI_BANK_CURRENCY )),'')))) + '|*~|*|~*' FROM API_CLIENT_MASTER_SYNERGY_DP ,ACCOUNT_PROPERTY_MSTR  WHERE kit_no = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'BANKCCY'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','DIVBANKCCY',UPPER(ISNULL(LTRIM(RTRIM(DIVI_BANK_CURRENCY )),'')))) + '|*~|*|~*' FROM API_CLIENT_MASTER_SYNERGY_DP ,ACCOUNT_PROPERTY_MSTR  WHERE kit_no = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'DIVBANKCCY'  
	     SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(CONVERT(varchar(11),getdate(),103))),'')) + '|*~|*|~*' FROM API_CLIENT_MASTER_SYNERGY_DP ,ACCOUNT_PROPERTY_MSTR  WHERE kit_no = @c_ben_acct_no AND ACCPM_PROP_CD   = 'BILL_START_DT'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','DIVIDEND_CURRENCY',UPPER(ISNULL(LTRIM(RTRIM(DIVI_BANK_CURRENCY )),'')))) + '|*~|*|~*' FROM API_CLIENT_MASTER_SYNERGY_DP ,ACCOUNT_PROPERTY_MSTR  WHERE kit_no = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'DIVIDEND_CURRENCY'  
  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TAX_DEDUCTION_STATUS )),'')) + '|*~|*|~*' FROM API_CLIENT_MASTER_SYNERGY_DP ,ACCOUNT_PROPERTY_MSTR  WHERE kit_no = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'TAX_DEDUCTION'  
  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(CONF_WAIVED )),''))='Y' THEN '1' ELSE '0' END  + '|*~|*|~*' FROM API_CLIENT_MASTER_SYNERGY_DP ,ACCOUNT_PROPERTY_MSTR  WHERE kit_no = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'CONFIRMATION'  
                                                    
        SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','BOSTMNTCYCLE',UPPER(ISNULL(LTRIM(RTRIM(BO_STMT_CYCLE )),'')))) + '|*~|*|~*' FROM API_CLIENT_MASTER_SYNERGY_DP ,ACCOUNT_PROPERTY_MSTR  WHERE kit_no = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'BOSTMNTCYCLE'  
        
        SELECT @L_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR_mak ,  API_CLIENT_MASTER_SYNERGY_DP 
        WHERE DPAM_ACCT_NO  = DP_INTERNAL_REF  AND kit_no  = @C_BEN_ACCT_NO  and DPAM_DELETED_IND IN (0,1)
  
        EXEC PR_INS_UPD_ACCP @L_CRN_NO ,'EDT','KYC',@L_DPAM_ID,@pa_ref_no,'DP',@L_ACCP_VALUE,@L_ACCPD_VALUE ,1,'*|~*','|*~|',''  
                     

         
        SET @L_ENTP_VALUE       = ''  
--          SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + ISNULL(LTRIM(RTRIM(BEN_RBI_REF_NO)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE BEN_ACCT_NO = @C_BEN_ACCT_NO AND ENTPM_CD = 'RBI_REF_NO'  
                             
        SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','NATIONALITY',UPPER(ISNULL(LTRIM(RTRIM(NATIONALITY_CODE )),'')))) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.KIT_NO = @C_BEN_ACCT_NO          and    main.purpose_code ='1' and ENTPM_CD   = 'NATIONALITY'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','OCCUPATION',UPPER(ISNULL(LTRIM(RTRIM(OCCUPATION )),'')))) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.KIT_NO = @C_BEN_ACCT_NO          and    main.purpose_code ='1' AND ENTPM_CD   = 'OCCUPATION'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','GEOGRAPHICAL',UPPER(ISNULL(LTRIM(RTRIM(GEOGRAPHICAL_CODE )),'')))) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.KIT_NO = @C_BEN_ACCT_NO          and    main.purpose_code ='1' and ENTPM_CD   = 'GEOGRAPHICAL'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','EDUCATION',UPPER(ISNULL(LTRIM(RTRIM(EDUCATION )),'')))) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.KIT_NO = @C_BEN_ACCT_NO          and    main.purpose_code ='1'  AND ENTPM_CD   = 'EDUCATION'  
          
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','LANGUAGE',UPPER(ISNULL(LTRIM(RTRIM(LANGUAGE_CODE )),'')))) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.KIT_NO = @C_BEN_ACCT_NO          and    main.purpose_code ='1' AND ENTPM_CD   = 'LANGUAGE'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF_CODE )),'')) = 'N' THEN 'NONE'   
                                                                                                      WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF_CODE )),'')) = 'R' THEN 'RELATIVE'  
                                                                                                      WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF_CODE )),'')) = 'S' THEN 'STAFF' ELSE '' END   + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.KIT_NO = @C_BEN_ACCT_NO          and    main.purpose_code ='1'  AND ENTPM_CD   = 'STAFF'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' +UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','ANNUAL_INCOME',UPPER(ISNULL(LTRIM(RTRIM(ANNUAL_INCOME_CODE  )),'')))) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.KIT_NO = @C_BEN_ACCT_NO          and    main.purpose_code ='1'  AND ENTPM_CD   = 'ANNUAL_INCOME'  
        --SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' +UPPER(PAN_GIR ) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.KIT_NO = @C_BEN_ACCT_NO          and    main.purpose_code ='1'  AND ENTPM_CD   = 'PAN_GIR_NO'  
                             
        set   @L_ENTPD_VALUE = ''                         
  
  
         
         EXEC [citrus_usr].PR_INS_UPD_ENTP '1','EDT','KYC',@L_CRN_NO,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,1,'*|~*','|*~|',''    

           
         SET @L_DPPD_DETAILS = ''  
         SELECT @L_DPPD_DETAILS =   @L_DPPD_DETAILS + ISNULL(CONVERT(VARCHAR,@L_COMPM_ID),'')+'|*~|'
         + ISNULL(CONVERT(VARCHAR,@L_EXCSM_ID),'')+'|*~|'+ISNULL(CONVERT(VARCHAR,@L_DPM_DPID),'')
         +'|*~|'+@pa_ref_no+'|*~|'
         +ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+ case when holder_number = '1' then  ISNULL(LTRIM(RTRIM('1ST HOLDER')),'')
         when holder_number = '2' then  ISNULL(LTRIM(RTRIM('2ND HOLDER')),'')
         when holder_number = '3' then  ISNULL(LTRIM(RTRIM('3RD HOLDER')),'') end  +'|*~|'
         +ISNULL(LTRIM(RTRIM(dpam_sba_name )),'') +'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'
         +ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'
         +ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'
         +ISNULL(LTRIM(RTRIM(0)),'')+'|*~|'
         +ISNULL(LTRIM(RTRIM(GPA_BPA_FLAG )),'')  
         +'|*~|'+CONVERT(varchar(11),SETUP_DATE ,103)
         +'|*~|'+CONVERT(varchar(11),EFFECTIVE_FORM_DATE ,103)
         +'|*~|'+CONVERT(varchar(11),isnull(EFFECTIVE_TO_DATE  ,'dec 31 2100'),103)
         +'|*~|'+LTRIM(RTRIM(POAM_MASTER_ID))+'|*~|'+'0'+'|*~|'+'0|*~|'+'A*|~*'  
         FROM kyc..API_CLIENT_POA poa , poam   ,API_CLIENT_MASTER_SYNERGY_DP main 
         WHERE main.KIT_NO = @C_BEN_ACCT_NO 
         and    main.purpose_code ='1' 
         and LTRIM(RTRIM(MASTER_POA_ID )) = LTRIM(RTRIM(poam_master_id)) 
         and poa.kit_no = main.kit_no
                  print 'dsdsds'
           print @L_DPPD_DETAILS
        
           
         EXEC PR_INS_UPD_DPPD '1',@L_CRN_NO,'EDT','KYC',@L_DPPD_DETAILS,1,'*|~*','|*~|',''


update client_list set clim_status = 3 where CLIM_CRN_NO = @L_CRN_NO and CLIM_DELETED_IND = 1
  
--         UPDATE DP_ACCT_MSTR SET DPAM_BATCH_NO =1 WHERE DPAM_BATCH_NO IS NULL AND DPAM_SBA_NO = @C_BEN_ACCT_NO AND DPAM_DELETED_IND = 1  
		
--     
 FETCH NEXT FROM @C_CLIENT_SUMMARY INTO @C_BEN_ACCT_NO   



    --  
    END  
                        
       CLOSE        @C_CLIENT_SUMMARY  
	   DEALLOCATE   @C_CLIENT_SUMMARY 


update a set dpam_bbo_code=accp_value from dp_acct_mstr  a
,account_properties
where isnull(dpam_bbo_code,'')='' 
and dpam_created_dt >='sep  1 2012'
and accp_clisba_id = dpam_id 
and ACCP_ACCPM_PROP_CD = 'bbo_code' 
 
      
     END

GO
