-- Object: PROCEDURE citrus_usr.PR_IMPORT_CLIENT_CDSL_CITRUS
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE  [citrus_usr].[PR_IMPORT_CLIENT_CDSL_CITRUS]
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
                         
  IF @PA_MODE = 'BULK'  
  BEGIN  
  --
  
       TRUNCATE TABLE TMP_CLIENT_DTLS_MSTR_CDSL_citrus  
  
        DECLARE @@SSQL VARCHAR(8000)  
        SET @@SSQL ='BULK INSERT CITRUS_USR.TMP_CLIENT_DTLS_MSTR_CDSL_citrus  FROM ''' + @PA_DB_SOURCE + ''' WITH   
        (  
           FIELDTERMINATOR = ''~'',  
           ROWTERMINATOR = ''\N''  
        )'  
  
        EXEC(@@SSQL)  
         
         
 --  
  END        
         
     
     DELETE FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_CUST_PROD_NO IN ('48','49')  
       

--begin transaction 
--
--
--select 1/0
--
--       
--         SET @@l_error = @@error            
--              --            
--              IF @@l_error > 0            
--              BEGIN            
--              --            
--                         
--				
--				insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','client_mstr',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()             
--
--				ROLLBACK TRANSACTION 
--           
--              --            
--              END 
     
          
     
                           
        SET @C_CLIENT_SUMMARY  = CURSOR FAST_FORWARD FOR                
        SELECT TMPCLI_BOID  
		FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus 
		WHERE TMPCLI_BOID NOT IN (SELECT DPAM_SBA_NO FROM DP_ACCT_MSTR) 
	
           
--		BEGIN TRY 
--		SELECT 1/0 
--		END TRY 
--		BEGIN CATCH 
--
--					insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--					select '192.168.100.30','KYC DATA MIAGRATION','',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()
--        
--		END CATCH 
                    
         
        OPEN @C_CLIENT_SUMMARY  
          
        FETCH NEXT FROM @C_CLIENT_SUMMARY INTO @C_BEN_ACCT_NO   
          
          
          
        WHILE @@FETCH_STATUS = 0                                                                                                          
        BEGIN --#CURSOR                                                                                                          
        --  
print @C_BEN_ACCT_NO
		--BEGIN TRY 

		--begin transaction 
          ---SELECT @@BOCTGRY = CITRUS_USR.CDSL_CTGRY_ENTTM_SUBCM_MAPPING (ISNULL(TMPCLI_BO_STAT,''),'CLICM') FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE  TMPCLI_BOID = @C_BEN_ACCT_NO  
         print    @C_BEN_ACCT_NO
             
           --SELECT  @L_CLIENT_VALUES = ISNULL(LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)),'') + '|*~|' + '|*~||*~|'+ ISNULL(LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)),'') + '|*~|'+ISNULL(TMPCLI_BO_SEX,'')+'|*~|'+ISNULL(TMPCLI_BO_DOB,'')+'|*~||*~|ACTIVE|*~||*~|1|*~|' + ISNULL(LTRIM(RTRIM(TMPCLI_FRST_HLDR_PAN_N0)),'') +'|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE  TMPCLI_BOID = @C_BEN_ACCT_NO  
	    SELECT @L_DPM_DPID = DPM_DPID , @L_EXCSM_ID = DEFAULT_DP FROM DP_MSTR , EXCH_SEG_MSTR 
		,TMP_CLIENT_DTLS_MSTR_CDSL_citrus
        WHERE DEFAULT_DP = EXCSM_ID AND  EXCSM_EXCH_CD= 'CDSL'  
		AND DPM_DPID = LEFT(TMPCLI_BOID,8) 
		and TMPCLI_BOID = @C_BEN_ACCT_NO 

        SELECT @L_COMPM_ID = EXCSM_COMPM_ID FROM EXCH_SEG_MSTR WHERE EXCSM_ID = @L_EXCSM_ID  

  
        SELECT  @L_CLIENT_VALUES = ISNULL(LTRIM(RTRIM(CASE WHEN citrus_usr.ufn_countstring(TMPCLI_FRST_HLDR_NM,'~') <> 0  THEN CITRUS_USR.FN_SPLITVAL_BY(LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)),'1','~') ELSE LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)) END)),'') + '|*~|' + ISNULL(CASE WHEN citrus_usr.ufn_countstring(TMPCLI_FRST_HLDR_NM,'~') <> 0  THEN  CITRUS_USR.FN_SPLITVAL_BY(LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)),'2','~') ELSE '' END,'') + '|*~|' + ISNULL(CASE WHEN citrus_usr.ufn_countstring(TMPCLI_FRST_HLDR_NM,'~') <> 0  THEN  CITRUS_USR.FN_SPLITVAL_BY(LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)),'3','~') ELSE '.' END,'') + '|*~|'+ LEFT(ISNULL(ltrim(rtrim(REPLACE(TMPCLI_FRST_HLDR_NM,'~',' '))),'')+'-'+right(TMPCLI_BOID,8),200)  + '|*~|'+ISNULL(TMPCLI_BO_SEX,'')+'|*~|'+CASE WHEN ISDATE(CONVERT(DATETIME,TMPCLI_BO_DOB,103)) = 1 THEN  ISNULL(TMPCLI_BO_DOB,'') ELSE '' END +'|*~||*~|ACTIVE|*~||*~|1|*~|' + ISNULL(LTRIM(RTRIM(TMPCLI_FRST_HLDR_PAN_N0)),'') +'|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE  TMPCLI_BOID = @C_BEN_ACCT_NO  
  
                              
--           IF NOT EXISTS(SELECT ENTP_ENT_ID FROM CLIENT_MSTR,ENTITY_PROPERTIES , TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND CLIM_CRN_NO =ENTP_ENT_ID AND ENTP_ENTPM_CD = 'PAN_GIR_NO' AND ENTP_VALUE = TMPCLI_FRST_HLDR_PAN_N0 AND ENTP_DELETED_IND = 1 AND LTRIM(RTRIM(TMPCLI_FRST_HLDR_PAN_N0)) NOT IN ('','N.A.'))  
--           BEGIN  
--
--			PRINT 'JIT1' 
--
--           SET @L_CLI_EXISTS_YN = 'N'  
--           END  
--           ELSE  
--           BEGIN  
--           SET @L_CLI_EXISTS_YN = 'Y'  
--           END  
--  
--           IF NOT EXISTS(SELECT ENTP_ENT_ID FROM CLIENT_MSTR,ENTITY_PROPERTIES , TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND CLIM_CRN_NO =ENTP_ENT_ID AND ENTP_ENTPM_CD = 'PAN_GIR_NO' AND ENTP_VALUE = TMPCLI_FRST_HLDR_PAN_N0 AND ENTP_DELETED_IND = 1 AND LTRIM(RTRIM(TMPCLI_FRST_HLDR_PAN_N0)) NOT IN ('','N.A.'))  
--           BEGIN  
			
			
			print @L_CLIENT_VALUES
            EXEC citrus_usr.PR_INS_UPD_CLIM  '0','INS','CITRUSA',@L_CLIENT_VALUES,0,'*|~*','|*~|','',''  
 

--			SET @@l_error = @@error            
--              --            
--              IF @@l_error > 0            
--              BEGIN            
--              --            
--                         
--				
--				--insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','client_mstr',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()             
--
--				ROLLBACK TRANSACTION 
--           
--              --            
--              END 

            SELECT DISTINCT @L_CRN_NO = CLIM_CRN_NO FROM CLIENT_MSTR, TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE  TMPCLI_BOID = @C_BEN_ACCT_NO AND CLIM_SHORT_NAME =  LEFT(ISNULL(ltrim(rtrim(REPLACE(TMPCLI_FRST_HLDR_NM,'~',' '))),'')+'-'+right(TMPCLI_BOID,8),200) 



--           END  
--           ELSE  
--           BEGIN  
--            SELECT DISTINCT @L_CRN_NO = CLIM_CRN_NO FROM CLIENT_MSTR,ENTITY_PROPERTIES , TMP_CLIENT_DTLS_MSTR_CDSL_citrus  WHERE  TMPCLI_BOID = @C_BEN_ACCT_NO AND CLIM_CRN_NO =ENTP_ENT_ID AND ENTP_ENTPM_CD = 'PAN_GIR_NO' AND ENTP_VALUE = TMPCLI_FRST_HLDR_PAN_N0 
--AND ENTP_DELETED_IND = 1                      
--           END  
  
  
      --ADDRESSES  
           SELECT @L_ADR = 'PER_ADR1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADDP_LIN1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADDP_LIN2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADDP_LIN3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADDP_CITY)),'')+'|*~|'+ISNULL(TMPCLI_BO_ADDP_STATE,'')+ '|*~|'+ISNULL(TMPCLI_BO_ADDP_CNTRY,'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADDP_PIN)),'')+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ISNULL(TMPCLI_BO_ADDP_LIN1,'') <>''  
           SELECT @L_ADR = @L_ADR  + 'COR_ADR1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADD_LIN_1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADD_LIN2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADD_LIN3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADD_CITY)),'')+'|*~|'+ISNULL(TMPCLI_BO_ADD_STATE ,'') + '|*~|'+ISNULL(TMPCLI_BO_ADD_CNTRY,'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADD_PIN)),'')+'|*~|*|~*'  
           FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ISNULL(TMPCLI_BO_ADD_LIN_1,'') <>''  
  
                            
                            
         
--           IF @L_CLI_EXISTS_YN = 'N'  
--           BEGIN  
  print @L_CRN_NO
print @L_CRN_NO
print @L_ADR
           EXEC citrus_usr.PR_INS_UPD_ADDR @L_CRN_NO,'INS','CITRUSA',@L_CRN_NO,'',@L_ADR,0,'*|~*','|*~|',''   

--			SET @@l_error = @@error            
--              --            
--              IF @@l_error > 0            
--              BEGIN            
--              --            
--                         
--				
--				insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','ADDRESSES,ENTITY_ADR_CONC',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()
--
--				ROLLBACK TRANSACTION 
--           
--              --            
--              END 

      --     END  
      --ADDRESSES  
        
  
      --CONTACT CHANNELS  
        
         
           SELECT @L_CONC = 'OFF_PH1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_TELPH_NO)),'')+'*|~*'+'OFF_PH2|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_TELPHP_NO)),'')+'*|~*'  
                           +'FAX1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_FAX_NO)),'')+'*|~*'+'FAX2|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_FAXF_NO)),'')+'*|~*'  
                           +'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_EMAIL_ID)),'')+'*|~*'  
							+'MOBILE1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_TELPH_NO)),'')+'*|~*'  
           FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO  
          
          SELECT @L_CONC = @L_CONC 							+'MOBSMS|*~|'+ISNULL(LTRIM(RTRIM(SMS_MOBILE)),'')+'*|~*'  
           FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO  
           AND SMS_MOBILE <>''
  
--           IF @L_CLI_EXISTS_YN = 'N'  
--           BEGIN  


             EXEC citrus_usr.PR_INS_UPD_CONC @L_CRN_NO,'INS','CITRUSA',@L_CRN_NO,'',@L_CONC,0,'*|~*','|*~|',''  

--             SET @@l_error = @@error            
--              --            
--              IF @@l_error > 0            
--              BEGIN            
--              --            
--                         
--				
--				insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','CONTACT_CHANNELS ,ENTITY_ADR_CONC',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()
--
--				ROLLBACK TRANSACTION 
--           
--              --            
--              END

         --  END  
      --CONTACT CHANNELS  
                            
        
      --DP_ACCT_MSTR  
                          --SELECT @L_DPM_DPID = DPM_DPID , @L_EXCSM_ID = DEFAULT_DP FROM DP_MSTR , EXCH_SEG_MSTR WHERE DEFAULT_DP = EXCSM_ID AND  EXCSM_EXCH_CD= 'NSDL'  
                          --SELECT @L_COMPM_ID = EXCSM_COMPM_ID FROM EXCH_SEG_MSTR WHERE EXCSM_ID = @L_EXCSM_ID   
           SELECT @L_DP_ACCT_VALUES = ISNULL(CONVERT(VARCHAR,@L_COMPM_ID),'')+'|*~|'+ ISNULL(CONVERT(VARCHAR,@L_EXCSM_ID),'')+'|*~|'+ISNULL(CONVERT(VARCHAR,@L_DPM_DPID),'')+'|*~|'+ISNULL(@C_BEN_ACCT_NO,'')+'|*~|'+ISNULL(LTRIM(RTRIM(replace(TMPCLI_FRST_HLDR_NM,'~',' '))),'')+'|*~|'+ ISNULL(LTRIM(RTRIM(TMPCLI_DP_INTREF_NO)),'') +'|*~|'+'ACTIVE'+'|*~|'
			+case when ISNULL(TMPCLI_ACCT_CTRGY,'') ='01' then '01_cdsl' 
			when ISNULL(TMPCLI_ACCT_CTRGY,'') ='14' then '14_cdsl' 
			else ISNULL(TMPCLI_ACCT_CTRGY,'')  end 
			+'|*~|' 
			+ISNULL(left(TMPCLI_BO_SUB_STAT,2),'')+'|*~|' 
			+ISNULL(TMPCLI_ACCT_CTRGY,'')+isnull(TMPCLI_BO_SUB_STAT,'')+'|*~|0|*~|A|*~|*|~*' 
			FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE  TMPCLI_BOID = @C_BEN_ACCT_NO   
             
  

           EXEC citrus_usr.PR_INS_UPD_DPAM @L_CRN_NO,'INS','CITRUSA',@L_CRN_NO,@L_DP_ACCT_VALUES,0,'*|~*','|*~|',''
 
--			SET @@l_error = @@error            
--              --            
--              IF @@l_error > 0            
--              BEGIN            
--              --            
--                         
--				
--				insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','DP_ACCT_MSTR ,ENTITY_ADR_CONC',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()
--
--				ROLLBACK TRANSACTION 
--           
--              --            
--              END
			update dp_acct_mstr set  dpam_batch_no = 1 where dpam_sba_no =   @C_BEN_ACCT_NO
             
          
      --DP_ACCT_MSTR  
           SELECT @L_ADR = 'AC_PER_ADR1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADDP_LIN1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADDP_LIN2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADDP_LIN3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADDP_CITY)),'')+'|*~|'+ISNULL(TMPCLI_BO_ADDP_STATE,'')+'|*~|'+ISNULL(TMPCLI_BO_ADDP_CNTRY,'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADDP_PIN)),'')+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ISNULL(TMPCLI_BO_ADDP_LIN1,'') <> ''  
           SELECT @L_ADR = @L_ADR  + 'AC_COR_ADR1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADD_LIN_1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADD_LIN2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADD_LIN3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADD_CITY)),'')+'|*~|'+ISNULL(TMPCLI_BO_ADD_STATE,'')+'|*~|'+ISNULL(TMPCLI_BO_ADD_CNTRY,'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_ADD_PIN)),'')+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ISNULL(TMPCLI_BO_ADD_LIN_1,'') <> ''  
           SELECT @L_ADR = @L_ADR  + 'NOMINEE_ADR1|*~|' +convert(varchar(200),citrus_usr.fn_splitval_by(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_ADD_LN123)),''),1,'~'))
           +'|*~|'+convert(varchar(50),ISNULL(LTRIM(RTRIM(citrus_usr.fn_splitval_by(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_ADD_LN123)),''),2,'~'))),''))
           +'|*~|'+convert(varchar(50),ISNULL(LTRIM(RTRIM(citrus_usr.fn_splitval_by(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_ADD_LN123)),''),3,'~'))),''))
           +'|*~|'+convert(varchar(50),ISNULL(LTRIM(RTRIM(citrus_usr.fn_splitval_by(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_CITY_STATE_CNTRY)),''),1,'~'))),''))
           +'|*~|'+convert(varchar(50),ISNULL(citrus_usr.fn_splitval_by(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_CITY_STATE_CNTRY)),''),2,'~'),''))
           +'|*~|'+convert(varchar(50),ISNULL(citrus_usr.fn_splitval_by(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_CITY_STATE_CNTRY)),''),3,'~'),''))
           +'|*~|'+ISNULL(LTRIM(RTRIM(citrus_usr.fn_splitval_by(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_CITY_STATE_CNTRY)),''),4,'~'))),'')
           +'|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ISNULL(TMPCLI_NOMI_ADD_LN123,'') <> ''  
                           
                            
           EXEC  PR_DP_INS_UPD_ADDR @L_CRN_NO,'EDT','CITRUSA',0,@C_BEN_ACCT_NO,'DP',@L_ADR,0,'*|~*','|*~|',''   
  
-- SET @@l_error = @@error            
--              --            
--              IF @@l_error > 0            
--              BEGIN            
--              --            
--                         
--				
--				insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','ADDRESSES ,ACCOUNT_ADR_CONC',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()
--
--				ROLLBACK TRANSACTION 
--           
--              --            
--              END

           SET @L_ADR   = ''  
          
           SELECT @L_ACC_CONC = 'ACCOFF_PH1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_TELPH_NO)),'')+'*|~*'+'ACCOFF_PH2|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BO_TELPHP_NO)),'')+'*|~*'   FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ISNULL(TMPCLI_BO_ADDP_LIN1,'') <> ''  
                           
                            
         
          -- EXEC  PR_DP_INS_UPD_CONC @L_CRN_NO,'EDT','CITRUSA',0,@C_BEN_ACCT_NO,'DP',@L_ACC_CONC,0,'*|~*','|*~|',''   
  
           SET @L_ACC_CONC = ''  
                            
      --DP_HOLDER_DTLS/ADDRESSES/CONCTACT_CHANNELS  
           DECLARE @PA_FH_DTLS VARCHAR(8000)  
                  ,@PA_SH_DTLS VARCHAR(8000)  
                  ,@PA_TH_DTLS VARCHAR(8000)  
                  ,@PA_NOMGAU_DTLS VARCHAR(8000)  
                  ,@PA_NOM_DTLS VARCHAR(8000)  
                  ,@PA_GAU_DTLS VARCHAR(8000)  
				  ,@l_nrn_no numeric
set @l_nrn_no = 0 
select @l_nrn_no = bitrm_bit_location
from bitmap_ref_mstr 
where bitrm_parent_cd like '%NRN_AUTO%'

update bitmap set bitrm_bit_location = bitrm_bit_location + 1 
from bitmap_ref_mstr bitmap
where bitrm_parent_cd like '%NRN_AUTO%'

  
           SELECT @PA_FH_DTLS = ''+'|*~|'+''+'|*~|'+''+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_FRST_HLDR_FATH_HUSB_NM)),'')+'|*~|'+''+'|*~|'+''+'|*~|'+''+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO  
           SELECT @PA_SH_DTLS = CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_SND_HLDR_NM)),''),1,'~')+'|*~|'+ISNULL(CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_SND_HLDR_NM)),''),2,'~'),'')+'|*~|'+ISNULL(CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_SND_HLDR_NM)),''),3,'~'),'')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'++'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_SND_HLDR_PAN_N0)),'')+'|*~|'+'|*~|*|~*'  FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO  AND CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_SND_HLDR_NM)),''),1,'~') <> ''
           SELECT @PA_TH_DTLS = CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_THRD_HLDR_NM)),''),1,'~')+'|*~|'+ISNULL(CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_THRD_HLDR_NM)),''),2,'~'),'')+'|*~|'+ISNULL(CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_THRD_HLDR_NM)),''),3,'~'),'')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'++'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_THRD_HLDR_PAN_N0)),'')+'|*~|'+'|*~|*|~*'  FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO    AND CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_THRD_HLDR_NM)),''),1,'~') <> ''
           SELECT @PA_NOMGAU_DTLS = '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*'  FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO   
       --    SELECT @PA_NOM_DTLS = CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_NM)),''),1,'~')+'|*~|'+CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_NM)),''),2,'~')+'|*~|'+CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_NM)),''),3,'~')+'|*~|'+'|*~|'+ CONVERT(VARCHAR(11),CONVERT(DATETIME,TMPCLI_DOB_MINOR_DT,103),103)+'|*~|'+'|*~|'+convert(varchar,@l_nrn_no)+'|*~|'+'|*~|*|~*'  FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO   AND CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_NM)),''),1,'~') <> ''
		   SELECT @PA_NOM_DTLS = CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_NM)),''),1,'~')+'|*~|'+CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_NM)),''),2,'~')+'|*~|'+CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_NM)),''),3,'~')+'|*~|'+'|*~|'+ CONVERT(VARCHAR(11),CONVERT(DATETIME,TMPCLI_DOB_MINOR_DT,103),103)+'|*~|'+'|*~|'+'|*~|'+CONVERT(varchar, @l_nrn_no)+'*|~*'  FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO   AND CITRUS_USR.FN_SPLITVAL_BY(ISNULL(LTRIM(RTRIM(TMPCLI_NOMI_NM)),''),1,'~') <> ''
           SELECT @PA_GAU_DTLS = '|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|'+'|*~|*|~*' FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO  
  


           EXEC citrus_usr.PR_INS_UPD_DPHD '0',@L_CRN_NO,@C_BEN_ACCT_NO,'INS','HO',@PA_FH_DTLS,@PA_SH_DTLS,@PA_TH_DTLS,@PA_NOMGAU_DTLS,@PA_NOM_DTLS,@PA_GAU_DTLS,0,'*|~*','|*~|',''               


-- SET @@l_error = @@error            
--              --            
--              IF @@l_error > 0            
--              BEGIN            
--              --            
--                         
--				
--				insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','DP_HOLDER_DTLS',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()
--
--				ROLLBACK TRANSACTION 
--           
--              --            
--              END

			set @PA_FH_DTLS = ''
			set @PA_SH_DTLS = ''
			set @PA_TH_DTLS = ''
			set @PA_NOMGAU_DTLS = ''
			set @PA_NOM_DTLS = ''
			set @PA_GAU_DTLS = ''


  
           
      --DP_HOLDER_DTLS/ADDRESSES/CONCTACT_CHANNELS  
  
            -- ENTITY_RELATIONSHIP    
            -- SELECT @L_BR_SH_NAME  = ENTM_SHORT_NAME FROM ENTITY_MSTR ,DP_CLIENT_SUMMARY WHERE BEN_ACCT_NO = @C_BEN_ACCT_NO AND ENTM_SHORT_NAME = BR_CD  


            DECLARE @L_ACTIVATION_DT VARCHAR(20)  
--            SELECT @L_DPM_DPID = DPM_DPID , @L_EXCSM_ID = DEFAULT_DP FROM DP_MSTR , EXCH_SEG_MSTR 
--			WHERE  DEFAULT_DP = EXCSM_ID AND  EXCSM_EXCH_CD= 'CDSL'  AND DPM_DPID = (SELECT TOP 1 LEFT(TMPCLI_BOID,8) FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus)
--            SELECT @L_COMPM_ID = EXCSM_COMPM_ID FROM EXCH_SEG_MSTR WHERE EXCSM_ID = @L_EXCSM_ID   
            SELECT @L_ACTIVATION_DT = TMPCLI_ACCT_OPNG_DT FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus TCDMC WHERE TMPCLI_BOID = @C_BEN_ACCT_NO  
--  
            declare @l_ar varchar(250)
			,@l_br varchar(250)
			,@l_re varchar(250)
			,@l_sub varchar(250)
			,@l_tra varchar(250)
			,@l_ba VARCHAR(250)
			,@L_REM VARCHAR(250)
			,@L_ONW VARCHAR(250)
			,@L_SB VARCHAR(250)
			,@L_BL VARCHAR(250)

			SET @l_ar = ''
			SET @l_br = ''
			SET @l_re = ''
			SET @l_sub = ''
			SET @l_tra = ''
			SET @l_ba = ''
			SET @L_REM = ''
			SET @L_ONW = ''
			SET @L_SB=''
			SET @L_BL =''

			SELECT @l_re = ISNULL(ENTM_SHORT_NAME,'') FROM ENTITY_MSTR , TMP_CLIENT_DTLS_MSTR_CDSL_citrus 
												    WHERE ENTM_SHORT_NAME = TMPCLI_RE + '_RE' AND ENTM_DELETED_IND = 1 AND TMPCLI_BOID = @C_BEN_ACCT_NO  
													AND ENTM_ENTTM_CD ='RE'
			SELECT @l_br = ISNULL(ENTM_SHORT_NAME,'') FROM ENTITY_MSTR , TMP_CLIENT_DTLS_MSTR_CDSL_citrus 
												    WHERE ENTM_SHORT_NAME = TMPCLI_BR + '_BR' AND ENTM_DELETED_IND = 1 AND TMPCLI_BOID = @C_BEN_ACCT_NO  
													AND ENTM_ENTTM_CD ='BR'
			--SELECT @l_ba = ISNULL(ENTM_SHORT_NAME,'') FROM ENTITY_MSTR , TMP_CLIENT_DTLS_MSTR_CDSL_citrus 
			--									    WHERE ENTM_SHORT_NAME = TMPCLI_BR + '_BA' AND ENTM_DELETED_IND = 1 AND TMPCLI_BOID = @C_BEN_ACCT_NO  
			--										AND ENTM_ENTTM_CD ='BA'
			SELECT @l_ar  = ISNULL(ENTM_SHORT_NAME,'') FROM ENTITY_MSTR , TMP_CLIENT_DTLS_MSTR_CDSL_citrus 
												    WHERE ENTM_SHORT_NAME = TMPCLI_AR + '_AR' AND ENTM_DELETED_IND = 1 AND TMPCLI_BOID = @C_BEN_ACCT_NO  
													AND ENTM_ENTTM_CD ='AR'													
			SELECT @L_REM= ISNULL(ENTM_SHORT_NAME,'') FROM ENTITY_MSTR , TMP_CLIENT_DTLS_MSTR_CDSL_citrus 
												    WHERE ENTM_SHORT_NAME = TMPCLI_SUB + '_SB' AND ENTM_DELETED_IND = 1 
												    AND TMPCLI_BOID = @C_BEN_ACCT_NO  
													AND ENTM_ENTTM_CD ='SB'
			--SELECT @L_ONW= ISNULL(ENTM_SHORT_NAME,'') FROM ENTITY_MSTR , TMP_CLIENT_DTLS_MSTR_CDSL_citrus 
			--									    WHERE ENTM_SHORT_NAME = TMPCLI_SUB + '_ONW' AND ENTM_DELETED_IND = 1 AND TMPCLI_BOID = @C_BEN_ACCT_NO  
			--										AND ENTM_ENTTM_CD ='ONW'
			
			

SELECT @L_BL= 
 ISNULL(ENTM_SHORT_NAME,'') from TMP_CLIENT_DTLS_MSTR_CDSL_citrus,statecountrylist_kyc,entity_mstr 
 where cd='state' and abs(code)=isnull(GST_KRASTCODE,'')
and entm_enttm_cd='Bl' and isnull(entm_name1,'')=case when description= 'Chhattisgarh' then 'CHATTISGARH' 
when description= 'Tamil Nadu' then 'TAMILNADU'
else description end 
AND TMPCLI_BOID = @C_BEN_ACCT_NO  and entm_deleted_ind=1
 

			
  
            --SELECT @L_ENTR_VALUE = CONVERT(VARCHAR,ISNULL(@L_COMPM_ID,0))+'|*~|'+CONVERT(VARCHAR,ISNULL(@L_EXCSM_ID,'0'))+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(@C_BEN_ACCT_NO,'')+'|*~|'+CONVERT(VARCHAR,@L_ACTIVATION_DT)+'|*~|HO|*~|' + @@HO_CD + '|*~|RE|*~|'+@l_re+'|*~|AR|*~|'+@l_AR+'|*~|BR|*~|'+@l_BR+'|*~|BA|*~|'+@l_ba+'|*~|REM|*~|'+@l_REM+'|*~|ONW|*~|'+@l_ONW+'|*~|A*|~*'  
 SELECT @L_ENTR_VALUE = CONVERT(VARCHAR,ISNULL(@L_COMPM_ID,0))+'|*~|'+CONVERT(VARCHAR,ISNULL(@L_EXCSM_ID,'0'))+'|*~|'+ISNULL('','')+'|*~|'+ISNULL(@C_BEN_ACCT_NO,'')+'|*~|'+CONVERT(VARCHAR,@L_ACTIVATION_DT)+'|*~|HO|*~|' + @@HO_CD + '|*~|RE|*~|'+@l_re+'|*~|AR|*~|'+@l_AR+'|*~|BR|*~|'+@l_BR+'|*~|BA|*~|'+@l_ba+'|*~|REM|*~|'+@l_REM+'|*~|ONW|*~|'+@l_ONW+'|*~|SB|*~|'+@l_SB+'|*~|BL|*~|'+@l_BL+'|*~|A*|~*'  

            EXEC citrus_usr.PR_INS_UPD_DPENTR '0','','HO',@L_CRN_NO,@L_ENTR_VALUE ,0,'*|~* ','|*~|',''  

-- SET @@l_error = @@error            
--              --            
--              IF @@l_error > 0            
--              BEGIN            
--              --            
--                         
--				
--				insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','ENTITY_RELATIONSHIP',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()
--
--				ROLLBACK TRANSACTION 
--           
--              --            
--              END

         -- ENTITY_RELATIONSHIP   
            SET @L_ACTIVATION_DT = ''  
  --BROKERAGE
--                           SELECT @L_DPM_DPID = DPM_DPID , @L_EXCSM_ID = DEFAULT_DP FROM DP_MSTR , EXCH_SEG_MSTR 
--						   WHERE DEFAULT_DP = EXCSM_ID AND  EXCSM_EXCH_CD= 'CDSL'  
--AND DPM_DPID = (SELECT TOP 1 LEFT(TMPCLI_BOID,8) FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus)
--
--                           SELECT @L_COMPM_ID = EXCSM_COMPM_ID FROM EXCH_SEG_MSTR WHERE EXCSM_ID = @L_EXCSM_ID 
--                           

							DECLARE @L_BROM_ID VARCHAR(100), @L_BRKG_VAL VARCHAR(1000)
							SET @L_BROM_ID  = ''
                            SELECT @L_ACTIVATION_DT = TMPCLI_ACCT_OPNG_DT FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus TCDMC WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND TMPCLI_ACCT_OPNG_DT <> ''  
                            SELECT @L_BROM_ID = BROM_ID FROM BROKERAGE_MSTR,TMP_CLIENT_DTLS_MSTR_CDSL_citrus
							WHERE case when BROM_DESC like '%scheme%' then replace(BROM_DESC,' ','') else BROM_DESC end  = TMPCLI_SCHEME
							and TMPCLI_BOID = @C_BEN_ACCT_NO AND TMPCLI_ACCT_OPNG_DT <> ''  

                            SET @L_BRKG_VAL = CONVERT(VARCHAR,@L_COMPM_ID)  +'|*~|'+CONVERT(VARCHAR,@L_EXCSM_ID) +'|*~|'+ ISNULL(@L_DPM_DPID,'') + '|*~|'+ LTRIM(RTRIM(@C_BEN_ACCT_NO)) +'|*~|' + @L_ACTIVATION_DT+'|*~|'+ @L_BROM_ID +'|*~|A*|~*'
		
							IF @L_BROM_ID  <> ''
							EXEC citrus_usr.PR_INS_UPD_CLIENT_BRKG @L_CRN_NO,'','CITRUSA',@L_CRN_NO,@L_BRKG_VAL,0,'*|~*','|*~|',''


-- SET @@l_error = @@error            
--              --            
--              IF @@l_error > 0            
--              BEGIN            
--              --            
--                         
--				
--				insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','CLIENT_DP_BRKG',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()
--
--				ROLLBACK TRANSACTION 
--           
--              --            
--              END

                        --BROKERAGE
      --BANK_MSTR/ADDRESSES/CONCTACT_CHANNELS  
            SELECT @L_BANK_NAME = LTRIM(RTRIM(TMPCLI_BANK_NM)) , @L_BANM_BRANCH = LTRIM(RTRIM(TMPCLI_BANK_ADD_LN1)) + '('+ LTRIM(RTRIM(TMPCLI_BANK_ADD_PIN)) +')'  FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus   WHERE TMPCLI_BOID = @C_BEN_ACCT_NO  
  
  
            SELECT @L_MICR_NO = TMPCLI_BANK_CD FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO  
  
            SELECT @L_ADDR_VALUE = 'COR_ADR1|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BANK_ADD_LN1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BANK_ADD_LN2)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BANK_ADD_LN3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BANK_ADD_CITY)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BANK_ADD_STATE)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_BANK_ADD_CNTRY)),'')+'|*~|'+'*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO  
  
             SET @L_BANM_ID = 0  
             IF EXISTS(SELECT BANM_ID FROM BANK_MSTR WHERE (BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH) OR BANM_MICR = @L_MICR_NO)  
             BEGIN  
                SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE (BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH) OR BANM_MICR = @L_MICR_NO  
             END  
             ELSE   
             BEGIN  
                
               EXEC PR_MAK_BANM  '0','INS','CITRUSA',@L_BANK_NAME,@L_BANM_BRANCH,@L_MICR_NO,'','','',0,0,'',0,'','*|~*','|*~|',''  
                 
                
               SELECT @L_BANM_ID = BANM_ID FROM BANK_MSTR WHERE (BANM_NAME = @L_BANK_NAME AND BANM_BRANCH = @L_BANM_BRANCH) OR BANM_MICR = @L_MICR_NO  
             END  
                              
  
  
    
  
  
        --PR_MAK_BANM   
      --BANK_MSTR/ADDRESSES/CONCTACT_CHANNELS  
              SELECT @L_CRN_NO = DPAM_CRN_NO FROM DP_ACCT_MSTR,  TMP_CLIENT_DTLS_MSTR_CDSL_citrus  
			WHERE DPAM_SBA_NO  =  TMPCLI_BOID AND TMPCLI_BOID = @C_BEN_ACCT_NO  
         --SELECT @L_DPBA_VALUES = CONVERT(VARCHAR,@L_COMPM_ID)  +'|*~|'+CONVERT(VARCHAR,@L_EXCSM_ID) +'|*~|'+ ISNULL(@L_DPM_DPID,'') + '|*~|'+ LTRIM(RTRIM(@C_BEN_ACCT_NO1)) +'|*~|' + LTRIM(RTRIM(TMPCLI_FRST_HLDR_NM)) + '|*~|'+ CONVERT(VARCHAR,@L_BANM_ID ) +'|*~|'+CASE WHEN TMPCLI_BENF_BANK_ACCT_TYP = '10' THEN 'SAVINGS' WHEN TMPCLI_BENF_BANK_ACCT_TYP = '11' THEN 'CURRENT' ELSE 'OTHERS' END +'|*~|' + LTRIM(RTRIM(TMPCLI_BANK_ACCT_N0)) + '|*~|1|*~|0|*~|A*|~*'  FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO1 
		SELECT @L_DPBA_VALUES = CONVERT(VARCHAR,@L_COMPM_ID)  +'|*~|'+CONVERT(VARCHAR,@L_EXCSM_ID) +'|*~|'+ ISNULL(@L_DPM_DPID,'') + '|*~|'+ LTRIM(RTRIM(@C_BEN_ACCT_NO)) +'|*~|' + LTRIM(RTRIM(REPLACE(TMPCLI_FRST_HLDR_NM,'~',' '))) + '|*~|'+ CONVERT(VARCHAR,@L_BANM_ID ) +'|*~|'+ case when TMPCLI_BENF_BANK_ACCT_TYP  = 'SAVING' THEN 'SAVINGS' ELSE TMPCLI_BENF_BANK_ACCT_TYP  END+'|*~|' + CONVERT(VARCHAR,LTRIM(RTRIM(TMPCLI_BANK_ACCT_N0))) + '|*~|1|*~|0|*~|A*|~*'  
        FROM   TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE TMPCLI_BOID = @C_BEN_ACCT_NO  

       --EXEC citrus_usr.PR_INS_UPD_DPBA '0','INS','CITRUSA',@L_CRN_NO,@L_DPBA_VALUES,0,'*|~*','|*~|',''  

--		SET @@l_error = @@error            
--              --            
--              IF @@l_error > 0            
--              BEGIN            
--              --            
--                         
--				
--				insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','CLIENT_BANK_DTLS',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()
--
--				ROLLBACK TRANSACTION 
--           
--              --            
--              END

      --CLIENT_BANK_ACCTS  
                              
 
      --CLIENT_BANK_ACCTS */  
  
      --ACCOUNT_PROPERTIES  
         SET @L_ACCP_VALUE = ''  
         SELECT DISTINCT  @L_ACCP_VALUE = CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_SEBI_REGI_NO)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD = 'SEBI_REG_NO'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_CM_ID)),'')) + '|*~|*|~*'  FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'CMBP_ID'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_RBI_REGI_NO)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'RBI_REF_NO'  
		 SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_TRADING_ID)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'BBO_CODE'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_GROUP_CD)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'GROUP_CD'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_ELECTRONOC_CONFIR)),''))='1' THEN '1' ELSE '0' END  + '|*~|*|~*'  FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'ELEC_CONF'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_BENF_ACCT_CURR)),''))+ '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'BANKCCY'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_DIVIDEND_ACCT_CURR)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'DIVBANKCCY'  
	     SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(TMPCLI_ACCT_OPNG_DT)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @c_ben_acct_no AND ACCPM_PROP_CD   = 'BILL_START_DT'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_DIVIDEND_CURR)),''))+ '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'DIVIDEND_CURRENCY'  
  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_TAX_DEDUC_STAT)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'TAX_DEDUCTION'  
  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_PURC_WAIVER)),''))='Y' THEN '1' ELSE '0' END  + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'CONFIRMATION'  
		SELECT DISTINCT @L_ACCP_VALUE =  ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(tmpcli_bsda)),''))='Y' THEN '1' ELSE '0' END  + '|*~|*|~*'  FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'BSDA'  
		
		SELECT DISTINCT @L_ACCP_VALUE =  ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(ECNflag)),''))='Y' THEN 'YES' ELSE 'NO' END  + '|*~|*|~*'  FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'ECN_FLAG'  
		SELECT DISTINCT @L_ACCP_VALUE =  ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(CAS)),''))='Y' THEN 'YES' ELSE UPPER(ISNULL(LTRIM(RTRIM(CAS)),'')) END  + '|*~|*|~*'  FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'CAS_FLAG'  
		SELECT DISTINCT @L_ACCP_VALUE =  ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(Emailstatflag)),''))='Y' THEN 'YES' ELSE 'NO' END  + '|*~|*|~*'  FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'EMAIL_ST_FLAG'  
		SELECT DISTINCT @L_ACCP_VALUE =  ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_SMS_FLAG)),''))='Y' THEN '1' ELSE '0' END  + '|*~|*|~*'  FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD  = 'SMS_FLAG'  
                                                    
        SELECT DISTINCT @L_ACCP_VALUE =  ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_BO_STMT_CYL_CD)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'BOSTMNTCYCLE' 
         SELECT DISTINCT @L_ACCP_VALUE =  ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(GST_NO)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD   = 'CLIENT GST'  
        SET @L_ACCPD_VALUE = ''  
        SELECT DISTINCT @L_ACCPD_VALUE = CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ACCDM_ID) + '|*~|'  + TMPCLI_RBI_APP_DT + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ACCOUNT_PROPERTY_MSTR , ACCPM_DTLS_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ACCPM_PROP_CD = 'RBI_REF_NO' AND ACCDM_CD = 'RBI_APP_DT' AND ACCDM_ACCPM_PROP_ID = ACCPM_PROP_ID  and TMPCLI_RBI_APP_DT <> ''
  
        SELECT @L_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR ,  TMP_CLIENT_DTLS_MSTR_CDSL_citrus WHERE DPAM_SBA_NO = TMPCLI_BOID  AND TMPCLI_BOID  = @C_BEN_ACCT_NO  
  
        EXEC citrus_usr.PR_INS_UPD_ACCP @L_CRN_NO ,'EDT','CITRUSA',@L_DPAM_ID,@C_BEN_ACCT_NO,'DP',@L_ACCP_VALUE,@L_ACCPD_VALUE ,0,'*|~*','|*~|',''  
                     

-- SET @@l_error = @@error            
--              --            
--              IF @@l_error > 0            
--              BEGIN            
--              --            
--                         
--				
--				insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','ACCOUNT_PROPERTIES',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()
--
--				ROLLBACK TRANSACTION 
--           
--              --            
--              END
                
      --ACCOUNT_PROPERTIES  
  
      --ENTITY_PROPERTIES  
  
         
        SET @L_ENTP_VALUE       = ''  
--          SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + ISNULL(LTRIM(RTRIM(BEN_RBI_REF_NO)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR WHERE BEN_ACCT_NO = @C_BEN_ACCT_NO AND ENTPM_CD = 'RBI_REF_NO'  
                             
        SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_BO_NATIONALITY)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ENTPM_CD   = 'NATIONALITY'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_PROFESSION_CD)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ENTPM_CD   = 'OCCUPATION'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_GEO_AREA_CD)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ENTPM_CD   = 'GEOGRAPHICAL'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_EDU_CD)),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ENTPM_CD   = 'EDUCATION'  
        
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + case when UPPER(ISNULL(LTRIM(RTRIM(DISFlag)),''))='Y' then 'YES' else 'NO' end + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ENTPM_CD   = 'DIS_REQ'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + case when UPPER(ISNULL(LTRIM(RTRIM(ECSflag)),''))='Y' then 'YES' else 'NO' end + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ENTPM_CD   = 'ECS_REQ'  
          
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','LANGUAGE',UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_LANG_CD)),'')))) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ENTPM_CD   = 'LANGUAGE'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_STAFF_RELATIVE_DP)),'')) = 'N' THEN 'NONE'   
                                                                                                      WHEN UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_STAFF_RELATIVE_DP)),'')) = 'R' THEN 'RELATIVE'  
                                                                                                      WHEN UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_STAFF_RELATIVE_DP)),'')) = 'S' THEN 'STAFF' ELSE UPPER(ISNULL(LTRIM(RTRIM(TMPCLI_STAFF_RELATIVE_DP)),'')) END   + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ENTPM_CD   = 'STAFF'  
        SELECT DISTINCT @L_ENTP_VALUE = ISNULL(@L_ENTP_VALUE,'')+ CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(CASE WHEN TMPCLI_INCOME_CD = '1Lakh To 2 Lakhs' THEN '1LAKH TO 2 LAKHS'
																																				WHEN TMPCLI_INCOME_CD = '2 Lakh To 5 Lakhs' THEN '2 LAKH TO 5 LAKHS'
																																				WHEN TMPCLI_INCOME_CD =  'Not Available' THEN 'NOT AVAILABLE'
																																				WHEN TMPCLI_INCOME_CD =  'Upto 1 Lakhs' THEN 'UPTO 1 LAKHS'
																																				WHEN TMPCLI_INCOME_CD =  '5 LAKHS & ABOVE' THEN '5 LAKHS & ABOVE'
																																				ELSE  TMPCLI_INCOME_CD END )),'')) + '|*~|*|~*' FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus ,ENTITY_PROPERTY_MSTR  WHERE TMPCLI_BOID = @C_BEN_ACCT_NO AND ENTPM_CD   = 'ANNUAL_INCOME'  
                             
        SET @L_ENTPD_VALUE = ''  
        --SELECT DISTINCT @L_ENTPD_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ENTDM_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(BEN_RBI_APP_DATE)),'') + '|*~|*|~*' FROM DP_CLIENT_SUMMARY ,ENTITY_PROPERTY_MSTR , ENTPM_DTLS_MSTR  WHERE BEN_ACCT_NO = @C_BEN_ACCT_NO AND ENTPM_CD = 'RBI_REF_NO' AND ENTDM_CD = 'RBI_APP_DT' AND ENTDM_ENTPM_PROP_ID = ENTPM_PROP_ID  
                              
  
  
         
         EXEC citrus_usr.PR_INS_UPD_ENTP '1','EDT','CITRUSA',@L_CRN_NO,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,0,'*|~*','|*~|',''    

-- SET @@l_error = @@error            
--              --            
--              IF @@l_error > 0            
--              BEGIN            
--              --            
--                         
--				
--				insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','ENTITY_PROPERTIES',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()
--
--				ROLLBACK TRANSACTION 
--           
--              --            
--              END

           
         SET @L_DPPD_DETAILS = ''  
         SELECT @L_DPPD_DETAILS =   ISNULL(CONVERT(VARCHAR,@L_COMPM_ID),'')+'|*~|'+ ISNULL(CONVERT(VARCHAR,@L_EXCSM_ID),'')+'|*~|'+ISNULL(CONVERT(VARCHAR,@L_DPM_DPID),'')+'|*~|'+ISNULL(@C_BEN_ACCT_NO,'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_POA_TYPE)),'') +'|*~|'+ ISNULL(LTRIM(RTRIM('1ST HOLDER')),'') +'|*~|'+ISNULL(LTRIM(RTRIM(dpam_sba_name)),'') +'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+ISNULL(LTRIM(RTRIM('')),'')+'|*~|'+ISNULL(LTRIM(RTRIM(TMPCLI_POA_ID)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(GPA_BPA_FLAG)),'')  
         +'|*~|'+CASE WHEN ISDATE(CONVERT(DATETIME,TMPCLI_SETUP_DT,103))= 1 THEN CONVERT(VARCHAR,CONVERT(DATETIME,TMPCLI_SETUP_DT,103),103) ELSE '' END   
         +'|*~|'+CASE WHEN ISDATE(CONVERT(DATETIME,TMPCLI_POA_START_DT,103))= 1 THEN CONVERT(VARCHAR,CONVERT(DATETIME,TMPCLI_POA_START_DT,103),103) ELSE '' END   
         +'|*~|'+CASE WHEN ISDATE(CONVERT(DATETIME,TMPCLI_POA_END_DT,103))= 1 THEN CONVERT(VARCHAR,CONVERT(DATETIME,TMPCLI_POA_END_DT,103),103) ELSE '' END   
         +'|*~|'+ LTRIM(RTRIM(POAM_MASTER_ID)) + '|*~|' + '0' + '|*~|' + '0|*~||*~||*~||*~|' + 'A*|~*'
         FROM TMP_CLIENT_DTLS_MSTR_CDSL_citrus , poam WHERE  LTRIM(RTRIM(TMPCLI_POA_NM)) = LTRIM(RTRIM(poam_master_id)) AND TMPCLI_BOID = @C_BEN_ACCT_NO 
          AND TMPCLI_POA_ID <>''   
           
        
           
         EXEC citrus_usr.PR_INS_UPD_DPPD '1',@L_CRN_NO,'EDT','CITRUSA',@L_DPPD_DETAILS,0,'*|~*','|*~|',''

-- SET @@l_error = @@error            
--              --            
--              IF @@l_error > 0            
--              BEGIN            
--              --            
--                         
--				
--				insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','DP_POA_DTLS',ERROR_PROCEDURE() ,'',ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()
--
--				ROLLBACK TRANSACTION 
--           
--              --            
--              END


  
         UPDATE DP_ACCT_MSTR SET DPAM_BATCH_NO =1 WHERE DPAM_BATCH_NO IS NULL AND DPAM_SBA_NO = @C_BEN_ACCT_NO 
         AND DPAM_DELETED_IND = 1  

--       END TRY 
--		 begin catch 
--				insert into tblerror_sql (sServer,sModule,sTable,sSP,sRemarks,sLineNo,sLoginID,sDateTime,sErrNo,sErrDescription)
--				select '192.168.100.30','KYC DATA MIAGRATION','',ERROR_PROCEDURE() ,@C_BEN_ACCT_NO,ERROR_LINE(),@pa_login_name,getdate(),ERROR_NUMBER(), ERROR_MESSAGE()
--		 END catch 
		
      FETCH NEXT FROM @C_CLIENT_SUMMARY INTO @C_BEN_ACCT_NO   



    --  
    END  
                        
       CLOSE        @C_CLIENT_SUMMARY  
	   DEALLOCATE   @C_CLIENT_SUMMARY  
	   
	   
	   	UPDATE a
		SET dpam_bbo_code = accp_value
		FROM dp_acct_mstr a, account_properties
		WHERE isnull(dpam_bbo_code, '') = ''
		AND dpam_created_dt >= 'sep  1 2012'
		AND accp_clisba_id = dpam_id
		AND ACCP_ACCPM_PROP_CD = 'bbo_code'

      
     END

GO
