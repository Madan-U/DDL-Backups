-- Object: PROCEDURE citrus_usr.pr_insert_missing_addr
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create proc [citrus_usr].[pr_insert_missing_addr] 
as
begin
DECLARE @C_CLIENT_SUMMARY CURSOR  
declare @L_ENTP_VALUE varchar(8000)
declare @L_ENTPd_VALUE varchar(8000)
declare @C_BEN_ACCT_NO varchar(100)
declare @l_crn_no numeric
SET @C_CLIENT_SUMMARY  = CURSOR FAST_FORWARD FOR
SELECT dpam_acct_no FROM CLIENT_MSTR_MAK CLIMM,dp_Acct_mstr_mak  WHERE CLIM_DELETED_IND =0 and clim_crn_no = dpam_crn_no and dpam_deleted_ind = 0 
AND NOT EXISTS (SELECT 1 FROM ENTITY_PROPERTIES_MAK WHERE ENTP_ENT_ID = CLIM_CRN_NO AND ENTP_ENTPM_CD <>'pan_gir_NO')
AND NOT EXISTS (SELECT 1 FROM CLIENT_MSTR CLIM WHERE CLIMM.CLIM_SHORT_NAME = CLIM.CLIM_SHORT_NAME )
ORDER BY 1 DESC


 OPEN @C_CLIENT_SUMMARY  
          
        FETCH NEXT FROM @C_CLIENT_SUMMARY INTO @C_BEN_ACCT_NO   
        


   WHILE @@FETCH_STATUS = 0                                                                                                          
        BEGIN --#CURSOR                                                                                                          
        --  
        select @l_crn_no = dpam_crn_no from DP_ACCT_MSTR_MAK where DPAM_ACCT_NO =@C_BEN_ACCT_NO and DPAM_DELETED_IND = 0 
        

SET @L_ENTP_VALUE       = ''  
--          SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + ISNULL(LTRIM(RTRIM(BEN_RBI_REF_NO)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE BEN_ACCT_NO = @C_BEN_ACCT_NO AND ENTPM_CD = 'RBI_REF_NO'  
                             
        SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','NATIONALITY',UPPER(ISNULL(LTRIM(RTRIM(NATIONALITY_CODE )),'')))) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.DP_INTERNAL_REF  = @C_BEN_ACCT_NO          and    main.purpose_code ='1' and ENTPM_CD   = 'NATIONALITY'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','OCCUPATION',UPPER(ISNULL(LTRIM(RTRIM(OCCUPATION )),'')))) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.DP_INTERNAL_REF  = @C_BEN_ACCT_NO          and    main.purpose_code ='1' AND ENTPM_CD   = 'OCCUPATION'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','GEOGRAPHICAL',UPPER(ISNULL(LTRIM(RTRIM(GEOGRAPHICAL_CODE )),'')))) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.DP_INTERNAL_REF  = @C_BEN_ACCT_NO          and    main.purpose_code ='1' and ENTPM_CD   = 'GEOGRAPHICAL'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','EDUCATION',UPPER(ISNULL(LTRIM(RTRIM(EDUCATION )),'')))) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.DP_INTERNAL_REF  = @C_BEN_ACCT_NO          and    main.purpose_code ='1'  AND ENTPM_CD   = 'EDUCATION'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER(pan_gir) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.DP_INTERNAL_REF  = @C_BEN_ACCT_NO          and    main.purpose_code ='1'  AND ENTPM_CD   = 'PAN_GIR_NO'  
          
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','LANGUAGE',UPPER(ISNULL(LTRIM(RTRIM(LANGUAGE_CODE )),'')))) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.DP_INTERNAL_REF  = @C_BEN_ACCT_NO          and    main.purpose_code ='1' AND ENTPM_CD   = 'LANGUAGE'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF_CODE )),'')) = 'N' THEN 'NONE'   
                                                                                                      WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF_CODE )),'')) = 'R' THEN 'RELATIVE'  
                                                                                                      WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF_CODE )),'')) = 'S' THEN 'STAFF' ELSE '' END   + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.DP_INTERNAL_REF  = @C_BEN_ACCT_NO          and    main.purpose_code ='1'  AND ENTPM_CD   = 'STAFF'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' +UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','ANNUAL_INCOME',UPPER(ISNULL(LTRIM(RTRIM(ANNUAL_INCOME_CODE  )),'')))) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.DP_INTERNAL_REF  = @C_BEN_ACCT_NO          and    main.purpose_code ='1'  AND ENTPM_CD   = 'ANNUAL_INCOME'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' +UPPER(PAN_GIR ) + '|*~|*|~*' FROM  API_CLIENT_MASTER_SYNERGY_DP main ,ENTITY_PROPERTY_MSTR   WHERE main.DP_INTERNAL_REF  = @C_BEN_ACCT_NO          and    main.purpose_code ='1'  AND ENTPM_CD   = 'PAN_GIR_NO'  
        
        -- for inc of date
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + ISNULL(convert(varchar(11),convert(datetime,CONVERT(VARCHAR(11), replace(DATE_OF_BIRTH ,'/' ,' '), 106),106),103),'')  + '|*~|*|~*' FROM API_CLIENT_MASTER_SYNERGY_DP main,ENTITY_PROPERTY_MSTR  WHERE main.DP_INTERNAL_REF  = @c_ben_acct_no AND ENTPM_CD   = 'INC_DOB'   and  main.purpose_code ='1' and convert(varchar,isnull(BO_CATEGORY,''))+convert(varchar,isnull(BO_SUB_STATUS,'')) in  ('214','2147','2182','2104','2513','2576','2543','2541','2512','2523')
        -- for inc of date
                             
        set   @L_ENTPD_VALUE = ''                         
  
  
         print @L_ENTP_VALUE
         print @L_CRN_NO
         EXEC [citrus_usr].PR_INS_UPD_ENTP '1','EDT','KYC',@L_CRN_NO,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,1,'*|~*','|*~|',''    
         
         FETCH NEXT FROM @C_CLIENT_SUMMARY INTO @C_BEN_ACCT_NO   



    --  
    END  
                        
       CLOSE        @C_CLIENT_SUMMARY  
	   DEALLOCATE   @C_CLIENT_SUMMARY 
	   


end

GO
