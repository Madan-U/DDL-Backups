-- Object: PROCEDURE citrus_usr.PR_CLIENTVIEW_FROM_CLASS
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*  
--BEGIN TRANSACTION  
--[PR_CLIENTVIEW_FROM_CLASS] '','HO','MAIN','0A141','*|~*','|*~|',''  
--[PR_CLIENTVIEW_FROM_CLASS] '','HO','address','0A141','*|~*','|*~|',''  
--[PR_CLIENTVIEW_FROM_CLASS] '','HO','conc','0A141','*|~*','|*~|',''  
--COMMIT  
--ROLLBACK  
*/  
  
create PROCEDURE  [citrus_usr].[PR_CLIENTVIEW_FROM_CLASS](@PA_EXCH          VARCHAR(20)    
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
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN CLIENT VIEW FROM CLASS     
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIES     
 VERSION HISTORY: 1.0    
 VERS.  AUTHOR            DATE          REASON    
 -----  -------------     ------------  ------------------------------------------  
 1.0    TUSHAR            18-NOV-2011   VERSION.    
----------------------------------------------------------------------------------*/    
BEGIN    
--  
   
  
          truncate  table  CLIENTDATACLASS  
  
-- alter table CLIENTDATACLASS alter column EMAIL varchar(300)  
-- alter table CLIENTDATACLASS alter column cl_status varchar(10)  
-- alter table CLIENTDATACLASS alter column bank_name varchar(300)  
-- alter table CLIENTDATACLASS alter column ac_type  varchar(25)  
-- alter table CLIENTDATACLASS alter column ac_num  varchar(50)  
-- alter table CLIENTDATACLASS alter column MICR_NO  varchar(50)  
            
          INSERT INTO CLIENTDATACLASS  
          --EXEC [10.204.7.75].MSAJAG.DBO.[VIEW_CLIENTMASTER] 'JAN 01 1900' , 'JAN 01 2100',@PA_DB_SOURCE  
          EXEC [10.228.50.6\DEV].MSAJAG.DBO.[VIEW_CLIENTMASTER] 'JAN 01 1900' , 'JAN 01 2100'  
--          select PARTY_CODE,PAN_GIR_NO from CLIENTDATACLASS 
                if @PA_MODE ='MAIN'  
        SELECT *,CITRUS_USR.inside_trim(LTRIM(RTRIM(long_name)),'1') fnm ,CITRUS_USR.inside_trim(LTRIM(RTRIM(long_name)),'2') mnm ,  
        CITRUS_USR.inside_trim(LTRIM(RTRIM(long_name)),'3') lnm,case when convert(varchar,ISNULL(dob,''),103) = '01/01/1900' then '' else CONVERT(VARCHAR,ISNULL(dob,''),103)  end clim_dob  
        ,bankname = (select top 1 isnull(banm_name,'')+ '-' +isnull(banm_branch,'')+ '-' + isnull(banm_micr,'') from bank_mstr where banm_rtgs_cd=ifsccode)
        ,bankid = (select top 1 banm_id from bank_mstr where banm_rtgs_cd=ifsccode)
        FROM CLIENTDATACLASS   
                 --WHERE PARTY_CODE NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENTPM_CD ='BBO_CODE')  
                 WHERE PARTY_CODE NOT IN (SELECT ACCP_VALUE FROM ACCOUNT_PROPERTIES WHERE ACCP_ACCPM_PROP_CD ='BBO_CODE')  
                 --AND PAN_GIR_NO   NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES,DP_ACCT_MSTR WHERE ENTP_ENTPM_CD ='PAN_GIR_NO' AND ENTP_ENT_ID= DPAM_CRN_NO  AND DPAM_STAM_CD <>'04')  
        AND (PARTY_CODE=@PA_DB_SOURCE 
         --OR PAN_GIR_NO=@PA_DB_SOURCE 
          )  
           
        if @PA_MODE ='address'   
        select 'COR_ADR1' concm_cd,'CORRESPONDENCE ADDRESS' concm_desc,L_ADDRESS1 adr_1,'COR_ADR1'+'|*~|'+L_ADDRESS1+'|*~|'+L_ADDRESS2+'|*~|'+L_ADDRESS3+'|*~|'+L_CITY+'|*~|'+''+'|*~|'+'INDIA'+'|*~|'+L_ZIP value  
        FROM CLIENTDATACLASS   
                 --WHERE PARTY_CODE NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENTPM_CD ='BBO_CODE')  
                 WHERE PARTY_CODE NOT IN (SELECT ACCP_VALUE FROM ACCOUNT_PROPERTIES WHERE ACCP_ACCPM_PROP_CD ='BBO_CODE')  
                 --AND PAN_GIR_NO   NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES,DP_ACCT_MSTR WHERE ENTP_ENTPM_CD ='PAN_GIR_NO' AND ENTP_ENT_ID= DPAM_CRN_NO AND DPAM_STAM_CD <>'04')  
        AND (PARTY_CODE=@PA_DB_SOURCE )
		--OR PAN_GIR_NO=@PA_DB_SOURCE )  
        union  
     select 'PER_ADR1' concm_cd,'PERMANENT ADDRESS' concm_desc,P_ADDRESS1 adr_1,'PER_ADR1'+'|*~|'+P_ADDRESS1+'|*~|'+P_ADDRESS2+'|*~|'+P_ADDRESS3+'|*~|'+P_CITY+'|*~|'+''+'|*~|'+'INDIA'+'|*~|'+P_ZIP value  
     FROM CLIENTDATACLASS   
                 --WHERE PARTY_CODE NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENTPM_CD ='BBO_CODE')  
                 WHERE PARTY_CODE NOT IN (SELECT ACCP_VALUE FROM ACCOUNT_PROPERTIES WHERE ACCP_ACCPM_PROP_CD ='BBO_CODE')  
                 --AND PAN_GIR_NO   NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES,DP_ACCT_MSTR WHERE ENTP_ENTPM_CD ='PAN_GIR_NO' AND ENTP_ENT_ID= DPAM_CRN_NO AND DPAM_STAM_CD <>'04')  
        AND (PARTY_CODE=@PA_DB_SOURCE) 
		--OR PAN_GIR_NO=@PA_DB_SOURCE )  
        union
          SELECT concm_cd                   
           , concm_desc                 
            ,'' adr_1
            ,'' value  
      FROM   conc_code_mstr                   concm WITH (NOLOCK)                    
      WHERE  2 & concm.concm_cli_yn         = 0                      
      AND concm.concm_deleted_ind        = 1 
and ISNULL(citrus_usr.fn_get_concm_bit(concm.concm_id,2,0),'') like '%CLIENT LEVEL DEPOSITORY%'                     
and concm_cd not in ('COR_ADR1','PER_ADR1')
      
        
        if @PA_MODE ='conc'  
        select 'RES_PH1' concm_cd, 'RESIDENCE PHONE (1ST)' concm_desc ,res_phone1 value,'1' ord   
              from CLIENTDATACLASS   
                 --WHERE PARTY_CODE NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENTPM_CD ='BBO_CODE')  
                 WHERE PARTY_CODE NOT IN (SELECT ACCP_VALUE FROM ACCOUNT_PROPERTIES WHERE ACCP_ACCPM_PROP_CD ='BBO_CODE')  
                 --AND PAN_GIR_NO   NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES,DP_ACCT_MSTR WHERE ENTP_ENTPM_CD ='PAN_GIR_NO' AND ENTP_ENT_ID= DPAM_CRN_NO AND DPAM_STAM_CD <>'04')  
        AND (PARTY_CODE=@PA_DB_SOURCE) 
		--OR PAN_GIR_NO=@PA_DB_SOURCE )  
        union  
        select 'RES_PH2' concm_cd, 'RESIDENCE PHONE (2ND)' concm_desc ,res_phone2 value ,'2' ord   
              from CLIENTDATACLASS   
                 --WHERE PARTY_CODE NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENTPM_CD ='BBO_CODE')  
                 WHERE PARTY_CODE NOT IN (SELECT ACCP_VALUE FROM ACCOUNT_PROPERTIES WHERE ACCP_ACCPM_PROP_CD ='BBO_CODE')  
                 --AND PAN_GIR_NO   NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES,DP_ACCT_MSTR WHERE ENTP_ENTPM_CD ='PAN_GIR_NO' AND ENTP_ENT_ID= DPAM_CRN_NO AND DPAM_STAM_CD <>'04')  
        AND (PARTY_CODE=@PA_DB_SOURCE)
		-- OR PAN_GIR_NO=@PA_DB_SOURCE )  
        union  
        select 'OFF_PH1' concm_cd, 'OFFICE PHONE (1ST)' concm_desc ,off_phone1 value ,'3' ord   
              from CLIENTDATACLASS   
                 --WHERE PARTY_CODE NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENTPM_CD ='BBO_CODE')  
                 WHERE PARTY_CODE NOT IN (SELECT ACCP_VALUE FROM ACCOUNT_PROPERTIES WHERE ACCP_ACCPM_PROP_CD ='BBO_CODE')  
                 AND PAN_GIR_NO   NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES,DP_ACCT_MSTR WHERE ENTP_ENTPM_CD ='PAN_GIR_NO' AND ENTP_ENT_ID= DPAM_CRN_NO AND DPAM_STAM_CD <>'04')  
        AND (PARTY_CODE=@PA_DB_SOURCE OR PAN_GIR_NO=@PA_DB_SOURCE )  
        union  
        select 'FAX1' concm_cd, 'FAX (1ST)' concm_desc ,fax value ,'4' ord   
              from CLIENTDATACLASS   
                 --WHERE PARTY_CODE NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENTPM_CD ='BBO_CODE')  
                 WHERE PARTY_CODE NOT IN (SELECT ACCP_VALUE FROM ACCOUNT_PROPERTIES WHERE ACCP_ACCPM_PROP_CD ='BBO_CODE')  
                 --AND PAN_GIR_NO   NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES,DP_ACCT_MSTR WHERE ENTP_ENTPM_CD ='PAN_GIR_NO' AND ENTP_ENT_ID= DPAM_CRN_NO AND DPAM_STAM_CD <>'04')  
        AND (PARTY_CODE=@PA_DB_SOURCE)
		-- OR PAN_GIR_NO=@PA_DB_SOURCE )  
        union  
        select 'EMAIL1' concm_cd, 'EMAIL ID (1ST)' concm_desc ,email value ,'5' ord   
              from CLIENTDATACLASS   
                 --WHERE PARTY_CODE NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES WHERE ENTP_ENTPM_CD ='BBO_CODE')  
                 WHERE PARTY_CODE NOT IN (SELECT ACCP_VALUE FROM ACCOUNT_PROPERTIES WHERE ACCP_ACCPM_PROP_CD ='BBO_CODE')  
                 --AND PAN_GIR_NO   NOT IN (SELECT ENTP_VALUE FROM ENTITY_PROPERTIES,DP_ACCT_MSTR WHERE ENTP_ENTPM_CD ='PAN_GIR_NO' AND ENTP_ENT_ID= DPAM_CRN_NO AND DPAM_STAM_CD <>'04')  
        AND (PARTY_CODE=@PA_DB_SOURCE )
		--OR PAN_GIR_NO=@PA_DB_SOURCE )                 
         union
        SELECT concm.concm_cd                   code                      
           , concm.concm_desc                 description                      
         ,'' value , '6' ord
      FROM   conc_code_mstr                   concm WITH (NOLOCK)                      
      WHERE  2 & concm.concm_cli_yn         = 2      
		and ISNULL(citrus_usr.fn_get_concm_bit(concm.concm_id,2,0),'') like '%CLIENT LEVEL DEPOSITORY%'                  
		and concm_Cd not in ('RES_PH1','RES_PH2','OFF_PH1','FAX1','EMAIL1')
      AND    concm.concm_deleted_ind        = 1                      
                 order by ord   
--                   
END

GO
