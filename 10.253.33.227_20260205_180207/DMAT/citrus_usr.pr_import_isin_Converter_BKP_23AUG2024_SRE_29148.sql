-- Object: PROCEDURE citrus_usr.pr_import_isin_Converter_BKP_23AUG2024_SRE_29148
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------







--begin tran
--rollback
--[pr_import_isin_Converter] 'NSDL','HO','BULK','', '*|~*'  ,'|*~|' ,''     
--select * from isin_mstr
--select * from TMPISIN_NSDL_value
--select * from TMPISIN_NSDL_MSTR
CREATE PROCEDURE [citrus_usr].[pr_import_isin_Converter_BKP_23AUG2024_SRE_29148](@PA_EXCH          VARCHAR(20)              
,@PA_LOGIN_NAME    VARCHAR(20)              
,@PA_MODE          VARCHAR(10)                                              
,@PA_DB_SOURCE     VARCHAR(250)              
,@ROWDELIMITER     CHAR(4) =     '*|~*'                
,@COLDELIMITER     CHAR(4) =     '|*~|'                
,@PA_ERRMSG        VARCHAR(8000) OUTPUT )            
AS            
 
BEGIN            
--  
   


DECLARE  @t_errorstr      VARCHAR(8000)    
,@l_error         BIGINT      
SET      @l_error         = 0
SET      @t_errorstr      = ''
DECLARE @@ssql  VARCHAR(8000)

  declare @pa_task_id numeric


select @pa_task_id=task_id from filetask where status='running' and task_name like '%STANDARD ISIN MASTER%'

  

 	IF  @PA_MODE ='BULK'  and  citrus_usr.fn_splitval_by (@pa_db_source , citrus_usr.ufn_CountString(@pa_db_source,'\')+1 ,'\') not like 'isin_mstr_%'
		BEGIN 
				UPDATE FILETASK
				SET    USERMSG = 'ERROR : File is not proper.Please Check.', STATUS ='FAILED',TASK_END_DATE = GETDATE()
				WHERE  TASK_ID = @PA_TASK_ID
				
				return
		END 



   IF @pa_mode = 'BULK'
	BEGIN
	--
         
		 truncate table ISIN_MSTR_CONVERTER
			
			SET @@ssql ='BULK INSERT CITRUS_USR.ISIN_MSTR_CONVERTER	 from ''' + @pa_db_source + ''' WITH 
			(
						
						--FIELDTERMINATOR = '','',
						--ROWTERMINATOR = ''\n'',
						--FIRSTROW = 2

						FIELDQUOTE = ''"''
						, FIELDTERMINATOR = '',''
						, ROWTERMINATOR = ''\n''
					
						,FORMAT=''CSV''
						,FIRSTROW = 2 


			)'
			print @@ssql 
			EXEC(@@ssql)

			
	

	end 

	 
	insert into ISIN_MSTR_CONVERTER_log 
			select * , getdate() from ISIN_MSTR_CONVERTER 
			
			truncate table TMPISIN_MSTR_ALLFIELD 

		insert into TMPISIN_MSTR_ALLFIELD (ISIN_ALPHA_CODE
		,ISIN_SHORT_NAME
		,ISIN_DESCRIPTION
		,ISSUER_ID
		,ISSUER_NAME
		,ISSUER__CONTACT_PERSON_NAME
		,CONTACT_PERSON_DESIGNATION
		,RTA_ID
		,RTA_NAME
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
		,ISIN_STATUS
		,HOLD_DEMAT_FLAG
		,HOLD_REMAT_FLAG
		,EXPIRY_DATE
		,CFI_CODE
		,PAR_VALUE
		,PAIDUP_VALUE
		,REDEMPTION_PRICE
		,REDEMPTION_DATE
		,CLOSE_PRICE
		,CLOSE_DATE
		,ISSUE_DATE
		,CONVERSION_DATE
		,DISTINCT_RANGE_EXISTS
		,ISIN_DECIMAL_CODE
		,ISIN_SUSPENDED
		,MONEY_DUE_DATE
		,REMARKS
		, ISIN_STATUS_DESCRIPTION
		,ISIN_SUSPENDED_DESCRIPTION
		) 	select ISIN
		,ISINDESC
		,ISINDESC
		,ISSRORGID
		,ISSRORGNM
		,CntctNm
		,CntctDesg
		,Regar
		,RegarNm
		,ISINShrNm
		,ISINScndNm
		,ISINLastNm
		,ISINPstlAdr1
		,ISINPstlAdr2
		,ISINPstlAdr3
		,ISINCity
		,ISINCtrySubDvsn
		,ISINCtry
		,ISINPstCd
		,ISINPhneNb1
		,ISINPhneNb2
		,ISINFaxNb
		,ISINEmailAdr
		,Sectyp.CDSL_Old_Value 
		,Sectyp.Meaning   FININSTRMNM
		,SecIsinStat.CDSL_Old_Value  SCTYSTS
		,DmtrlsdRegdScties
		,RmtrlsdRegdScties
		,MtrtyDt
		,CFI.CDSL_Old_Value  ClssfctnFinInstrm
		,ParVal
		,PdAmt
		,RedPric
		,RedDt
		,ClsPric
		,ClsDt
		,ISSEDT
		,ConvsDt
		,DstnctRgExstg
		,DecIsinCd.CDSL_Old_Value   DcmlAllwd
		,CASE WHEN SUSFLG.CDSL_Old_Value   ='' THEN '0' ELSE SUSFLG.CDSL_Old_Value END ISINSspnsnFlg
		,DueDt
		,AddtlInf, SecIsinStat.Meaning , SUSFLG.Meaning    
		from ISIN_MSTR_CONVERTER
			--left outer join  Harm_Standard_Value_List_nsdl Sectyp  on Sectyp.Standardized_Value = FININSTRMTP  and  Sectyp.Existing_Filed_Name ='Sectyp'  
		left outer join 	Harm_source_cdsl Sectyp on Sectyp.Standard_Value = FININSTRMTP and  Sectyp.Field_Description ='Security Type' --Security Type
       --  left outer join Harm_Standard_Value_List_nsdl SecIsinStat   on SecIsinStat.Standardized_Value = SctySts  and  SecIsinStat.Existing_Filed_Name ='SecIsinStat'  
	     left outer join Harm_source_cdsl SecIsinStat   on SecIsinStat.Standard_Value = SctySts  and  SecIsinStat.Field_Description ='Security Status / ISIN Status'
		-- left outer join Harm_Standard_Value_List_nsdl DecIsinCd  on DecIsinCd.Standardized_Value = DcmlAllwd  and DecIsinCd.Existing_Filed_Name ='DecIsinCd' 
		 left outer join Harm_source_cdsl DecIsinCd  on DecIsinCd.Standard_Value = DcmlAllwd  and DecIsinCd.Field_Description ='Decimal allowed /ISIN Decimal Code' 
    	 left outer join Harm_source_cdsl CFI  on CFI.Standard_Value = ClssfctnFinInstrm  and CFI.Field_Description ='Listing Status / CFI Code' 
	 left outer join Harm_source_cdsl SUSFLG  on SUSFLG.Standard_Value = ISINSspnsnFlg  and SUSFLG.Field_Description ='ISIN Suspension Flag'
	
         
		IF @PA_EXCH = 'CDSL'            
		BEGIN            
		--            
    
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
				,ISIN_STATUS_DESCRIPTION
				,ISIN_HOLD_DEMAT_FLAG
				,ISIN_HOLD_REMAT_FLAG
				,ISIN_SUSPENDED
				,ISIN_SUSPENDED_DESCRIPTION      
				,isin_iss_id,isin_cfi_cd  
					,ISIN_COMP_CD
				,ISIN_ISSUE_DT
,ISIN_MAT_DT
--,ISIN_CONV_DT
, ISIN_CONV_AMT 
,ISIN_DECIMAL_ALLOW 
,isin_contactperson
				)              
				SELECT DISTINCT ISIN_ALPHA_CODE              
				,replace (ISIN_SHORT_NAME,'''','')    
				,replace (ISIN_SHORT_NAME,'''','')              
				,RTA_ID              
				,CONVERSION_DATE              
				,ISIN_STATUS=CASE WHEN ISIN_STATUS='A' THEN '01' WHEN  ISIN_STATUS='I' THEN '04' WHEN ISIN_STATUS='P' THEN '05' WHEN ISIN_STATUS='S' THEN '02' ELSE ISIN_STATUS END               
				,2      
				,SECURITY_TYPE      
				,1            
				,@PA_LOGIN_NAME              
				,GETDATE()              
				,@PA_LOGIN_NAME              
				,GETDATE()              
				,1    
				,ISIN_ADDRESS_1
				,ISIN_ADDRESS_2
				,ISIN_ADDRESS_3
				,ISIN_CITY
				,ISIN_STATE
				,ISIN_COUNTRY
				,ISIN_ZIP_CODE,
				ISIN_EMAIL,ISIN_PHONE_1,ISIN_FAX
				,SECURITY_TYPE_DESCRIPTION--TMPISIN_SECURITY_TYP_DESC
				,ISIN_STATUS_DESCRIPTION
				,HOLD_DEMAT_FLAG
				,HOLD_REMAT_FLAG 
				,ISIN_SUSPENDED
				,ISIN_SUSPENDED_DESCRIPTION 
				,ISSUER_ID,CFI_CODE
				,ISSUER_ID
				,ISSUE_DATE
,EXPIRY_DATE
--,CONVERSION_DATE
,0 
, ISIN_DECIMAL_CODE 
,ISSUER__CONTACT_PERSON_NAME
				FROM TMPISIN_MSTR_ALLFIELD --TMP_ISIN_MSTR               
				WHERE  ISIN_ALPHA_CODE NOT IN (SELECT ISIN_CD FROM ISIN_MSTR)               
		              
				UPDATE ISIN_MSTR                           
				SET    ISIN_REG_CD         = RTA_ID  
				, ISIN_NAME           = replace (ISIN_SHORT_NAME,'''','')
				, ISIN_COMP_NAME	   = replace (ISIN_SHORT_NAME,'''','')      
				, ISIN_CONV_DT        = CONVERSION_DATE               
				, ISIN_STATUS         = CASE WHEN TEMP_ISINM.ISIN_STATUS='A' THEN '01' WHEN  TEMP_ISINM.ISIN_STATUS='I' THEN '04' WHEN TEMP_ISINM.ISIN_STATUS='P' THEN '05' WHEN TEMP_ISINM.ISIN_STATUS='S' THEN '02' ELSE TEMP_ISINM.ISIN_STATUS END               
				--, ISIN_LST_UPD_BY     = @PA_LOGIN_NAME              
				, ISIN_LST_UPD_DT     = GETDATE() 
				,isin_adr1 = ISIN_ADDRESS_1
				,isin_adr2 = ISIN_ADDRESS_2
				,isin_adr3 = ISIN_ADDRESS_3
				,isin_adrcity = ISIN_CITY
				,isin_adrstate = ISIN_STATE
				,isin_adrcountry = ISIN_CounTRY
				,isin_adrzip = ISIN_ZIP_CODE
				,isin_email = TEMP_ISINM.ISIN_EMAIL
				,isin_TELE = ISIN_PHONE_1
				,isin_FAX  =  TEMP_ISINM.ISIN_FAX  
				,isin_SECURITY_TYPE_DESCRIPTION = SECURITY_TYPE_DESCRIPTION     
				,ISIN_FACE_VAL=PAR_VALUE  -- added on jun 01 2017 by Latesh P W and Rohan N
				--,ISIN_SEC_TYPE = SECURITY_TYPE     -- added on Jan 10 2018 by yogesh

					,ISIN_STATUS_DESCRIPTION=TEMP_ISINM.ISIN_STATUS_DESCRIPTION
				,ISIN_HOLD_DEMAT_FLAG=HOLD_DEMAT_FLAG
				,ISIN_HOLD_REMAT_FLAG=HOLD_REMAT_FLAG
				,ISIN_SUSPENDED=TEMP_ISINM.ISIN_SUSPENDED
				,ISIN_SUSPENDED_DESCRIPTION =TEMP_ISINM.ISIN_SUSPENDED_DESCRIPTION
				, isin_iss_id = ISSUER_ID      
				,isin_cfi_cd=CFI_CODE
					,isin_comp_cd =ISSUER_ID 
				, ISIN_SEC_TYPE = SECURITY_TYPE , isin_bit =  2 
								,ISIN_ISSUE_DT= ISSUE_DATE
,ISIN_MAT_DT= EXPIRY_DATE 
,ISIN_CONV_AMT =  0
,ISIN_DECIMAL_ALLOW = ISIN_DECIMAL_CODE 
,isin_contactperson =ISSUER__CONTACT_PERSON_NAME
				FROM   TMPISIN_MSTR_ALLFIELD TEMP_ISINM --- TMP_ISIN_MSTR         TEMP_ISINM              
				, ISIN_MSTR             ISINM              
				WHERE  LTRIM(RTRIM(ISIN_ALPHA_CODE))  = LTRIM(RTRIM(ISIN_CD))              
                
                
				UPDATE  ISIN_MSTR             
				SET     ISIN_BIT  = 0 , ISIN_FILLER = ''           
				FROM    ISIN_MSTR M, TMP_ISIN_MSTR T            
				WHERE   M.ISIN_CD = T.TMPISIN_ALPHA_CD            
				AND     M.ISIN_BIT  = 1     
    
				UPDATE  ISIN_MSTR             
				SET   ISIN_STATUS         = CASE WHEN T.TMPISIN_STAT='A' THEN '01' WHEN  T.TMPISIN_STAT='I' THEN '04' 
				WHEN T.TMPISIN_STAT='P' THEN '05' WHEN T.TMPISIN_STAT='S' THEN '02' ELSE T.TMPISIN_STAT END           
				FROM    ISIN_MSTR M, TMP_ISIN_MSTR T            
				WHERE   M.ISIN_CD = T.TMPISIN_ALPHA_CD   
				AND     ISIN_STATUS         <> CASE WHEN T.TMPISIN_STAT='A' THEN '01' WHEN  T.TMPISIN_STAT='I' THEN '04' 
				WHEN T.TMPISIN_STAT='P' THEN '05' WHEN T.TMPISIN_STAT='S' THEN '02' ELSE T.TMPISIN_STAT END         
           
		--            
		END            
 
               

--            
END

GO
