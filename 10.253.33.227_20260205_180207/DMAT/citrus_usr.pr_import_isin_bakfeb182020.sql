-- Object: PROCEDURE citrus_usr.pr_import_isin_bakfeb182020
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


--begin tran
--rollback
--PR_IMPORT_ISIN 'NSDL','HO','BULK','c:\bulkinsdbfolder\ISIN MASTER - CD03\CD031005U.002', '*|~*'  ,'|*~|' ,''     
--select * from isin_mstr
--select * from TMPISIN_NSDL_value
--select * from TMPISIN_NSDL_MSTR
create PROCEDURE [citrus_usr].[pr_import_isin_bakfeb182020](@PA_EXCH          VARCHAR(20)              
                              ,@PA_LOGIN_NAME    VARCHAR(20)              
                              ,@PA_MODE          VARCHAR(10)                                              
                              ,@PA_DB_SOURCE     VARCHAR(250)              
                              ,@ROWDELIMITER     CHAR(4) =     '*|~*'                
                              ,@COLDELIMITER     CHAR(4) =     '|*~|'                
                              ,@PA_ERRMSG        VARCHAR(8000) OUTPUT )            
AS            
/*            
*********************************************************************************            
 SYSTEM         : DP            
 MODULE NAME    : PR_IMPORT_ISIN            
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE IMPORT ISIN_MSTRS            
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIES             
 VERSION HISTORY: 1.0            
 VERS.  AUTHOR            DATE          REASON            
 -----  -------------     ------------  --------------------------------------------------            
 1.0    TUSHAR            08-OCT-2007   VERSION.            
-----------------------------------------------------------------------------------*/            
BEGIN            
--  
   
   DECLARE  @t_errorstr      VARCHAR(8000)    
		,@l_error         BIGINT      
   SET      @l_error         = 0
   SET      @t_errorstr      = ''
DECLARE @@ssql  VARCHAR(8000)
   
  IF @PA_EXCH = 'NSDL'            
  BEGIN            
  --            


    IF @pa_mode = 'BULK'
	BEGIN
	--
            truncate table TMPISIN_NSDL_value	 
			TRUNCATE TABLE TMPISIN_NSDL_MSTR

			
			SET @@ssql ='BULK INSERT CITRUS_USR.TMPISIN_NSDL_value	 from ''' + @pa_db_source + ''' WITH 
			(
						FIELDTERMINATOR = ''\n'',
						ROWTERMINATOR = ''\n''
			)'

			EXEC(@@ssql)
	
delete from TMPISIN_NSDL_value where left(value,2) = '01'


select *
	FROM TMPISIN_NSDL_value
where isnumeric(LTRIM(RTRIM(substring(value,31,2))))=0
	or isnumeric(LTRIM(RTRIM(substring(value,321,2))))=0
	or isnumeric(LTRIM(RTRIM(substring(value,322,2))))=0

	insert into TMPISIN_NSDL_MSTR
	(ISIN_CD --9-12
	,ISIN_NS_CD --21-9
	,ISIN_BOOKING_BASIS --30-2
	,ISIN_SHORT_NAME --32-140
	,ISIN_COMP_CD --172-8
	,ISIN_COMP_NAME --180-140
	,ISIN_SEC_TYPE --320-2
	,ISIN_SEC_SUB_TYPE--323-3
	,ISIN_ISSUE_DT --324-8
	,ISIN_MAT_DT --332-8
	,ISIN_CONV_DT --340-8
	,ISIN_FACE_VAL --349-7 + . + --355-8
	,ISIN_CONV_AMT--364-5 +.+ --369-5
	,ISIN_SHARE_REG_CD --373-8
	,ISIN_SHARE_REG_NAME--381-135
	,ISIN_DECIMAL_ALLOW--578-1
	,ISIN_STATUS--516-2
	,ISIN_CREATED_BY
	,ISIN_CREATED_DT
	,ISIN_LST_UPD_BY
	,ISIN_LST_UPD_DT
	,ISIN_DELETED_IND
	)
	select LTRIM(RTRIM(substring(value,10,12)))
	,LTRIM(RTRIM(substring(value,22,9)))
	,LTRIM(RTRIM(substring(value,31,2)))
	,LTRIM(RTRIM(substring(value,33,140)))
	,LTRIM(RTRIM(substring(value,173,8)))
	,LTRIM(RTRIM(substring(value,181,140)))
	,LTRIM(RTRIM(substring(value,321,2)))
	,LTRIM(RTRIM(substring(value,322,2)))
	,CONVERT(DATETIME,LTRIM(RTRIM(substring(value,325,8))),103)
	,CONVERT(DATETIME,LTRIM(RTRIM(substring(value,333,8))),103)
	,CONVERT(DATETIME,LTRIM(RTRIM(substring(value,341,8))),103)
	,LTRIM(RTRIM(substring(value,350,7))) + '.' + LTRIM(RTRIM(substring(value,356,8)))
	,LTRIM(RTRIM(substring(value,365,5))) + '.' + LTRIM(RTRIM(substring(value,370,4)))
	,LTRIM(RTRIM(substring(value,374,8)))
	,LTRIM(RTRIM(substring(value,382,135)))
	,LTRIM(RTRIM(substring(value,579,1)))
	,case when LTRIM(RTRIM(substring(value,517,2))) = '' then '01' else LTRIM(RTRIM(substring(value,517,2))) end 
	,'MIG'
	,GETDATE()
	,'MIG'
	,GETDATE()
	, 1
	FROM TMPISIN_NSDL_value
--
END


    UPDATE TMPISIN_NSDL_MSTR   WITH (ROWLOCK)            
    SET    ISIN_SEC_TYPE     = FILLM_DB_VALUE            
    FROM   FILE_LOOKUP_MSTR  F            
        ,  TMPISIN_NSDL_MSTR T            
    WHERE  F.FILLM_FILE_NAME = 'ISIN_MSTR_NSDL'            
    AND    FILLM_LOOKUP_CD   = 'SEC_TYPE'            
    AND    CASE WHEN ISIN_SEC_SUB_TYPE <> '0' THEN ISIN_SEC_TYPE + ISIN_SEC_SUB_TYPE  ELSE  ISIN_SEC_TYPE END  = FILLM_FILE_VALUE            
    AND    FILLM_EXCM_CD     = 'NSDL'            
    --             
    UPDATE ISIN            WITH (ROWLOCK)            
    SET    ISIN_NS_CD         = TIM.ISIN_NS_CD            
         , ISIN_NAME          = LTRIM(RTRIM(TIM.ISIN_COMP_NAME)) + ' (' + LTRIM(RTRIM(TIM.ISIN_SHORT_NAME)) + ')'        
         , ISIN_COMP_CD       = TIM.ISIN_COMP_CD            
         , ISIN_COMP_NAME     = TIM.ISIN_COMP_NAME            
         , ISIN_SEC_TYPE      = TIM.ISIN_SEC_TYPE                    
         , ISIN_SEC_SUB_TYPE  = TIM.ISIN_SEC_SUB_TYPE            
         , ISIN_ISSUE_DT      = TIM.ISIN_ISSUE_DT            
         , ISIN_MAT_DT        = TIM.ISIN_MAT_DT            
         , ISIN_CONV_DT       = TIM.ISIN_CONV_DT            
         , ISIN_FACE_VAL      = TIM.ISIN_FACE_VAL * (1000000)               
         , ISIN_CONV_AMT      = TIM.ISIN_CONV_AMT            
         , ISIN_REG_CD        = TIM.ISIN_SHARE_REG_CD            
         , ISIN_SEC_REM       = TIM.ISIN_SEC_REM            
         , ISIN_DECIMAL_ALLOW = TIM.ISIN_DECIMAL_ALLOW            
         --, ISIN_FILLER        = TIM.ISIN_FILLER            
         , ISIN_STATUS        = TIM.ISIN_STATUS            
         , ISIN_INSM_ID       = TIM.ISIN_SEC_TYPE               
         , ISIN_LST_UPD_BY    = @PA_LOGIN_NAME            
         , ISIN_LST_UPD_DT    = GETDATE()            
         , ISIN_DELETED_IND   = 1            
     FROM  ISIN_MSTR ISIN , TMPISIN_NSDL_MSTR    TIM            
     WHERE TIM.ISIN_CD = ISIN.ISIN_CD       
    --                    
    INSERT INTO ISIN_MSTR            
    (ISIN_CD                        
    ,ISIN_NS_CD                     
    ,ISIN_NAME                
    ,ISIN_COMP_CD                   
    ,ISIN_COMP_NAME                 
    ,ISIN_SEC_TYPE                  
    ,ISIN_SEC_SUB_TYPE              
    ,ISIN_ISSUE_DT                  
    ,ISIN_MAT_DT                    
    ,ISIN_CONV_DT                   
,ISIN_FACE_VAL                  
    ,ISIN_CONV_AMT                  
    ,ISIN_REG_CD              
    ,ISIN_SEC_REM      
    ,ISIN_DECIMAL_ALLOW             
    ,ISIN_FILLER                    
    ,ISIN_STATUS                    
    ,ISIN_BIT                       
    ,ISIN_INSM_ID            
    ,ISIN_CREATED_BY                
    ,ISIN_CREATED_DT                
    ,ISIN_LST_UPD_BY                
    ,ISIN_LST_UPD_DT                
    ,ISIN_DELETED_IND              
    )            
    SELECT DISTINCT TIM.ISIN_CD                        
   , TIM.ISIN_NS_CD                     
         , LTRIM(RTRIM(TIM.ISIN_COMP_NAME)) + ' (' + LTRIM(RTRIM(TIM.ISIN_SHORT_NAME)) + ')'             
         , TIM.ISIN_COMP_CD                   
         , TIM.ISIN_COMP_NAME                 
         , TIM.ISIN_SEC_TYPE                  
         , TIM.ISIN_SEC_SUB_TYPE              
         , TIM.ISIN_ISSUE_DT                  
         , TIM.ISIN_MAT_DT                    
         , TIM.ISIN_CONV_DT                   
         , TIM.ISIN_FACE_VAL               
         , TIM.ISIN_CONV_AMT                  
         , TIM.ISIN_SHARE_REG_CD              
         , TIM.ISIN_SEC_REM                   
         , TIM.ISIN_DECIMAL_ALLOW             
         , TIM.ISIN_FILLER                    
         , TIM.ISIN_STATUS                    
         , 1                      
         , TIM.ISIN_SEC_TYPE                    
         , TIM.ISIN_CREATED_BY                
         , TIM.ISIN_CREATED_DT                
         , TIM.ISIN_LST_UPD_BY                
         , TIM.ISIN_LST_UPD_DT                
         , 1              
    FROM   TMPISIN_NSDL_MSTR  TIM WITH (NOLOCK)                      
    WHERE  NOT EXISTS (SELECT ISIN_CD             
                       FROM   ISIN_MSTR  M WITH (NOLOCK)             
                       WHERE  M.ISIN_CD = TIM.ISIN_CD            
                       )               
                                   
                                   
                                   
    UPDATE  ISIN_MSTR             
    SET     ISIN_BIT  = 0            
    FROM    ISIN_MSTR M, TMPISIN_NSDL_MSTR T            
    WHERE   M.ISIN_CD = T.ISIN_CD            
    AND     M.ISIN_BIT  = 2            
                                   
                                   
                                   
  --            
  END            
  --            
  IF @PA_EXCH = 'CDSL'            
  BEGIN            
  --            
     IF @pa_mode = 'BULK'
	BEGIN
	--
            truncate TABLE TMPISIN_MSTR_ALLFIELD	 
			TRUNCATE TABLE TMP_ISIN_MSTR

			
			SET @@ssql ='BULK INSERT CITRUS_USR.TMPISIN_MSTR_ALLFIELD	 from ''' + @pa_db_source + ''' WITH 
			(
						FIELDTERMINATOR = ''~'',
						ROWTERMINATOR = ''\n''
			)'

			EXEC(@@ssql)
	


		insert into TMP_ISIN_MSTR
		(TMPISIN_NUM_CD
		,TMPISIN_ALPHA_CD
		,TMPISIN_SHRT_NM
		,TMPISIN_DESC
		,TMPISIN_ISS_ID
		,TMPISIN_ISS_NM
		,TMPISIN_ISS_ADD1
		,TMPISIN_ISS_ADD2
		,TMPISIN_ISS_ADD3
		,TMPISIN_ISS_CITY
		,TMPISIN_ISS_STATE
		,TMPISIN_ISS_CTRY
		,TMPISIN_ISS_ZIP
		,TMPISIN_ISS_PH1
		,TMPISIN_ISS_PH2
		,TMPISIN_ISS_FAX
		,TMPISIN_ISS_EMAIL
		,TMPISIN_ISS_CP_NAME
		,TMPISIN_CP_DESG
		,TMPISIN_CP_ADD1
		,TMPISIN_CP_ADD2
		,TMPISIN_CP_ADD3
		,TMPISIN_CP_CITY
		,TMPISIN_CP_STATE
		,TMPISIN_CP_COUNTRY
		,TMPISIN_CP_ZIP
		,TMPISIN_CP_PH1
		,TMPISIN_CP_PH2
		,TMPISIN_CP_FAX
		,TMPISIN_CP_EMAIL
		,TMPISIN_RTA_ID
		,TMPISIN_RTA_NM
		,TMPISIN_RTA_SN
		,TMPISIN_RTA_TN
		,TMPISIN_RTA_ADD1
		,TMPISIN_RTA_ADD2
		,TMPISIN_RTA_ADD3
		,TMPISIN_RTA_CITY
		,TMPISIN_RTA_STATE
		,TMPISIN_RTA_CTRY
		,TMPISIN_RTA_ZIP
		,TMPISIN_RTA_PH1
		,TMPISIN_RTA_PH2
		,TMPISIN_RTA_FAX
		,TMPISIN_RTA_EMAIL
		,TMPISIN_SHARE_NM
		,TMPISIN_SECOND_NM
		,TMPISIN_LST_NM
		,TMPISIN_ADD1
		,TMPISIN_ADD2
		,TMPISIN_ADD3
		,TMPISIN_CITY
		,TMPISIN_STATE
		,TMPISIN_CTRY
		,TMPISIN_ZIP
		,TMPISIN_PH1
		,TMPISIN_PH2
		,TMPISIN_FAX
		,TMPISIN_EMAIL
		,TMPISIN_SECURITY_TYP
		,TMPISIN_SECURITY_TYP_DESC
		,TMPISIN_MKT_TYP
		,TMPISIN_MKT_TYP_DESC
		,TMPISIN_STAT
		,TMPISIN_STAT_DESC
		,TMPISIN_HLD_DEMAT_FLG
		,TMPISIN_HLD_REMAT_FLG
		,TMPISIN_EXPIRY_DT
		,TMPISIN_MKT_LOT
		,TMPISIN_CFI_CD
		,TMPISIN_PAR_VAL
		,TMPISIN_PAIDUP_VAL
		,TMPISIN_REDEMPTION_PRICE
		,TMPISIN_REDEMPTION_DT
		,TMPISIN_CLOSE_PRICE
		,TMPISIN_CLOSE_DT
		,TMPISIN_ISSUE_DT
		,TMPISIN_ON_GOING_CONV
		,TMPISIN_CONV_DT
		,TMPISIN_DIST_RANGE_EXIST
		,TMPISIN_DEC_CD
		,TMPISIN_DEC_CODE_DESC
		,TMPISIN_SUSP
		,TMPISIN_SUSP_DESC
		,TMPISIN_MONEY_DUE_DT
		,TMPISIN_COMPLETE
		,TMPISIN_REMARKS
		)
		select ISIN_NUMERIC_CODE
		,ISIN_ALPHA_CODE
		,ISIN_SHORT_NAME
		,ISIN_DESCRIPTION
		,ISSUER_ID
		,ISSUER_NAME
		,ISSUER_ADDRESS_1
		,ISSUER_ADDRESS_2
		,ISSUER_ADDRESS_3
		,ISSUER_CITY
		,ISSUER_STATE
		,ISSUER_COUNTRY
		,ISSUER_ZIP_CODE
		,ISSUER_PHONE_1
		,ISSUER_PHONE_2
		,ISSUER_FAX
		,ISSUER_EMAIL
		,ISSUER__CONTACT_PERSON_NAME
		,CONTACT_PERSON_DESIGNATION
		,CONTACT_PERSON_ADDRESS_1
		,CONTACT_PERSON_ADDRESS_2
		,CONTACT_PERSON_ADDRESS_3
		,CONTACT_PERSON_CITY
		,CONTACT_PERSON_STATE
		,CONTACT_PERSON_COUNTRY
		,CONTACT_PERSON_ZIP_CODE
		,CONTACT_PERSON_PHONE_1
		,CONTACT_PERSON_PHONE_2
		,CONTACT_PERSON_FAX
		,CONTACT_PERSON_EMAIL
		,RTA_ID
		,RTA_NAME
		,RTA_SECOND_NAME
		,RTA_THIRD_NAME
		,RTA_ADDRESS_1
		,RTA_ADDRESS_2
		,RTA_ADDRESS_3
		,RTA_CITY
		,RTA_STATE
		,RTA_COUNTRY
		,RTA_ZIP_CODE
		,RTA_PHONE_1
		,RTA_PHONE_2
		,RTA_FAX
		,RTA_EMAIL
		,ISIN_SHARE_NAME
		,ISIN_SECOND_NAME
		,ISIN_LAST_NAME
		,ISIN_ADDRESS_1
		,ISIN_ADDRESS_2
		,ISIN_ADDRESS_3
		,ISIN_CITY
		,ISIN_STATE
		,ISIN_COUNTRY
		,ISIN_ZIP_CODE
		,ISIN_PHONE_1
		,ISIN_PHONE_2
		,ISIN_FAX
		,ISIN_EMAIL
		,SECURITY_TYPE
		,SECURITY_TYPE_DESCRIPTION
		,MARKET_TYPE
		,MARKET_TYPE_DESCRIPTION
		,ISIN_STATUS
		,ISIN_STATUS_DESCRIPTION
		,HOLD_DEMAT_FLAG
		,HOLD_REMAT_FLAG
		,EXPIRY_DATE
		,MARKET_LOT
		,CFI_CODE
		,PAR_VALUE
		,PAIDUP_VALUE
		,REDEMPTION_PRICE
		,REDEMPTION_DATE
		,CLOSE_PRICE
		,CLOSE_DATE
		,ISSUE_DATE
		,ON_GOING_CONVERSION
		,CONVERSION_DATE
		,DISTINCT_RANGE_EXISTS
		,ISIN_DECIMAL_CODE
		,ISIN_DECIMAL_CODE_DESCRIPTION
		,ISIN_SUSPENDED
		,ISIN_SUSPENDED_DESCRIPTION
		,MONEY_DUE_DATE
		,ISIN_COMPLETE
		,REMARKS
		FROM TMPISIN_MSTR_ALLFIELD
--
	END
	   
      --alter table ISIN_MSTR add ISIN_SECURITY_TYPE_DESCRIPTION varchar(250)

		   INSERT INTO ISIN_MSTR(ISIN_CD              
           ,ISIN_NAME    
		   ,ISIN_COMP_NAME              
           ,ISIN_REG_CD              
           ,ISIN_CONV_DT              
           ,ISIN_STATUS      
           ,ISIN_BIT      
           ,ISIN_SEC_TYPE                  
			,ISIN_INSM_ID                        
           ,ISIN_CREATED_BY              
           ,ISIN_CREATED_DT              
           ,ISIN_LST_UPD_BY              
           ,ISIN_LST_UPD_DT              
           ,ISIN_DELETED_IND  
			,isin_adr1
			,isin_adr2
			,isin_adr3
			,isin_adrcity
			,isin_adrstate
			,isin_adrcountry
			,isin_adrzip
			,isin_email
			,isin_TELE
			,isin_FAX ,ISIN_SECURITY_TYPE_DESCRIPTION            
           )              
			SELECT DISTINCT TMPISIN_ALPHA_CD              
			,replace (TMPISIN_SHRT_NM,'''','')    
			,replace (TMPISIN_SHRT_NM,'''','')              
			,TMPISIN_RTA_ID              
			,TMPISIN_CONV_DT              
			,ISIN_STATUS=CASE WHEN TMPISIN_STAT='A' THEN '01' WHEN  TMPISIN_STAT='I' THEN '04' WHEN TMPISIN_STAT='P' THEN '05' WHEN TMPISIN_STAT='S' THEN '02' ELSE TMPISIN_STAT END               
			,2      
			,TMPISIN_SECURITY_TYP      
			,1            
			,@PA_LOGIN_NAME              
			,GETDATE()              
			,@PA_LOGIN_NAME              
			,GETDATE()              
			,1    
,TMPISIN_ADD1
,TMPISIN_ADD2
,TMPISIN_ADD3
,TMPISIN_CITY
,TMPISIN_STATE
,TMPISIN_CTRY
,TMPISIN_ZIP,
TMPISIN_EMAIL,TMPISIN_PH1,TMPISIN_FAX
,TMPISIN_SECURITY_TYP_DESC
			FROM TMP_ISIN_MSTR               
			WHERE  TMPISIN_ALPHA_CD NOT IN (SELECT ISIN_CD FROM ISIN_MSTR)               
		            
			UPDATE ISIN_MSTR                           
			SET    ISIN_REG_CD         = TMPISIN_RTA_ID  
				 , ISIN_NAME           = replace (TMPISIN_SHRT_NM,'''','')
				 , ISIN_COMP_NAME	   = replace (TMPISIN_SHRT_NM,'''','')      
				 , ISIN_CONV_DT        = TMPISIN_CONV_DT               
				 , ISIN_STATUS         = CASE WHEN TMPISIN_STAT='A' THEN '01' WHEN  TMPISIN_STAT='I' THEN '04' WHEN TMPISIN_STAT='P' THEN '05' WHEN TMPISIN_STAT='S' THEN '02' ELSE TMPISIN_STAT END               
				 --, ISIN_LST_UPD_BY     = @PA_LOGIN_NAME              
				 , ISIN_LST_UPD_DT     = GETDATE() 
,isin_adr1 = TMPISIN_ADD1
,isin_adr2 = TMPISIN_ADD2
,isin_adr3 = TMPISIN_ADD3
,isin_adrcity = TMPISIN_CITY
,isin_adrstate = TMPISIN_STATE
,isin_adrcountry = TMPISIN_CTRY
,isin_adrzip = TMPISIN_ZIP
,isin_email = TMPISIN_EMAIL
,isin_TELE = TMPISIN_PH1
,isin_FAX  =  TMPISIN_FAX  
,isin_SECURITY_TYPE_DESCRIPTION = TMPISIN_SECURITY_TYP_DESC     
,ISIN_FACE_VAL=TMPISIN_PAR_VAL  -- added on jun 01 2017 by Latesh P W and Rohan N
,ISIN_SEC_TYPE = TMPISIN_SECURITY_TYP     -- added on Jan 10 2018 by yogesh
			FROM   TMP_ISIN_MSTR         TEMP_ISINM              
				 , ISIN_MSTR             ISINM              
			WHERE  LTRIM(RTRIM(TMPISIN_ALPHA_CD))  = LTRIM(RTRIM(ISIN_CD))              
                
                
    UPDATE  ISIN_MSTR             
    SET     ISIN_BIT  = 0 , ISIN_FILLER = ''           
    FROM    ISIN_MSTR M, TMP_ISIN_MSTR T            
    WHERE   M.ISIN_CD = T.TMPISIN_ALPHA_CD            
    AND     M.ISIN_BIT  = 1            
  --            
  END            
  print  @PA_EXCH
    IF @PA_EXCH = 'BARREDISIN'            
    BEGIN            
    -- 
             DECLARE @@ISINEM INTEGER           
             BEGIN TRANSACTION	
  	
             DELETE FROM ISIN_EXCEPTION_MSTR WHERE ISINEM_ISIN_CD IN (SELECT ISIN FROM BARRED_ISIN_MSTR WHERE ISIN = ISINEM_ISIN_CD
             AND ISINEM_EXCEP_TYPE IN ('B','P'))
             	   
             SELECT @@ISINEM =  ISNULL(MAX(ISINEM_ID)+1,0) FROM ISIN_EXCEPTION_MSTR	
             INSERT INTO ISIN_EXCEPTION_MSTR 
             (
              ISINEM_ID,ISINEM_ISIN_CD,ISINEM_EXCEP_TYPE,ISINEM_CREATED_BY,
  	      ISINEM_CREATED_DT,ISINEM_LST_UPD_BY,ISINEM_LST_UPD_DT,ISINEM_DELETED_IND
             )
  
             SELECT @@ISINEM ,ISIN,'B',@PA_LOGIN_NAME,GETDATE(),@PA_LOGIN_NAME ,GETDATE(),1 
             FROM BARRED_ISIN_MSTR
  
             UPDATE I SET I.ISIN_FILLER='B' FROM ISIN_MSTR I,BARRED_ISIN_MSTR BI WHERE BI.ISIN = I.ISIN_CD 
             SET @L_ERROR = @@ERROR
  		   IF @L_ERROR <> 0
  		   BEGIN
  			--
  					IF EXISTS(SELECT ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = @L_ERROR)
  					BEGIN
  					--
  							SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': '+ ERR_DESCRIPTION FROM TBLERROR WHERE ERR_CODE = CONVERT(VARCHAR,@L_ERROR)
  					--
  					END
  					ELSE
  					BEGIN
  					--
  							SELECT @T_ERRORSTR = 'ERROR '+CONVERT(VARCHAR,@L_ERROR) + ': CAN NOT PROCESS, PLEASE CONTACT YOUR ADMINISTRATOR!'
  					--
  					END
  
  					ROLLBACK TRANSACTION 
  			--
  			END
  			ELSE
  			BEGIN
  			--
  					COMMIT TRANSACTION
  			--            
  			END
  			SET @PA_ERRMSG = @T_ERRORSTR
    --
    END               

--            
END

GO
