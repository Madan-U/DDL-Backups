-- Object: PROCEDURE citrus_usr.PR_BILLING_BO_CSV_24092012
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--[PR_BILLING_BO_CSV] 'apr 01 2010','apr 30 2010','12345678','Y','Y','P','C','HO'  
  
create PROCEDURE [citrus_usr].[PR_BILLING_BO_CSV_24092012]  
(@PA_BILLING_FROM_DT DATETIME  
,@PA_BILLING_TO_DT   DATETIME  
,@PA_DP_ID          VARCHAR(16)  
,@PA_BILLING_STATUS  CHAR(1)  
,@PA_POSTED_FLG      CHAR(1)  
,@PA_BILL_POST_SHW_BILL   CHAR(1)  
,@PA_B2B_OUTSTANDING_FLG CHAR(1)
,@PA_LOGIN_NAME   VARCHAR(20)  
  
)  
AS  
BEGIN  
--  
	
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
  DECLARE  @DPPOSTACCOUNT NUMERIC(10,0)  
         , @L_FIN_ID      INT  
         , @L_REF_NO      VARCHAR(16)  
         , @L_SQL         VARCHAR(8000)  
         , @L_DPM_ID      INT  
         , @L_VOUCHER_NO  INT  
         , @BROKERGL_ACC_CD VARCHAR(20)  
         , @DP_NAME VARCHAR(10)   
  		 , @@l_posting_dt datetime         
         
    

        
		SELECT @L_DPM_ID = DPM_ID ,@DP_NAME=EXCM_CD 
		FROM DP_MSTR,EXCH_SEG_MSTR,EXCHANGE_MSTR   
		WHERE DPM_DPID = @PA_DP_ID   
		AND DPM_DELETED_IND = 1   
		AND DPM_EXCSM_ID=EXCSM_ID  
		AND EXCSM_EXCH_CD = EXCM_CD   
		AND DEFAULT_DP=DPM_EXCSM_ID   

		SELECT @BROKERGL_ACC_CD = BITRM_VALUES FROM BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='BROKER_GL_ACCNO'  
        IF @PA_B2B_OUTSTANDING_FLG='B'
        BEGIN 
			Select @@l_posting_dt= isnull(billc_posting_dt,@pa_billing_to_dt) from bill_cycle where billc_from_dt = @pa_billing_from_dt and billc_to_dt =  @pa_billing_to_dt and billc_dpm_id = @l_dpm_id
            SELECT @l_fin_id = fin_id from financial_yr_mstr where fin_dpm_id = @l_dpm_id and @@l_posting_dt between fin_start_dt and fin_end_dt
		END
		ELSE
		BEGIN
print '@pa_billing_to_dt'+convert(varchar,@pa_billing_to_dt,103)
print '@l_dpm_id'+convert(varchar,@l_dpm_id)
			Select @@l_posting_dt= isnull(billc_posting_dt,@pa_billing_to_dt) from bill_cycle where billc_to_dt =  @pa_billing_to_dt and billc_dpm_id = @l_dpm_id
print '@l_posting_dt'+convert(varchar,@@l_posting_dt,103)
            SELECT @l_fin_id = fin_id from financial_yr_mstr where fin_dpm_id = @l_dpm_id and @@l_posting_dt between fin_start_dt and fin_end_dt
		END

		


		CREATE TABLE  #MAIN_BILL  
		(ID         INT IDENTITY(1,1)      
		,FROMDT     DATETIME  
		,TODT       DATETIME              
		,ACCOUNT_ID bigint
		,CLTCODE    VARCHAR(20)  
		,DRCR       CHAR(1)  
		,AMOUNT     MONEY    , CHEQUE_NO VARCHAR(50)
		)  
  
    --   
        
PRINT @DP_NAME  
PRINT @PA_B2B_OUTSTANDING_FLG
		IF (@DP_NAME='CDSL' )  
		BEGIN  

						IF @PA_B2B_OUTSTANDING_FLG='B'
						BEGIN 

								INSERT INTO  #MAIN_BILL                
								SELECT @PA_BILLING_TO_DT,@PA_BILLING_TO_DT,CLIC_DPAM_ID,ISNULL(CITRUS_USR.FN_UCC_accP(DPAM_id,'BBO_CODE',''),'') ,CASE WHEN SUM(CLIC_CHARGE_AMT)< 0 THEN 'D' ELSE 'C' END ,ABS(SUM(CLIC_CHARGE_AMT)) ,'' 
        FROM DP_ACCT_MSTR,CLIENT_CHARGES_CDSL  
								WHERE  CLIC_DPAM_ID = DPAM_ID  
								AND CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT   
								AND CLIC_DPM_ID     = @L_DPM_ID    
								AND CLIC_DELETED_IND = 1         
								AND ISNULL(CITRUS_USR.FN_UCC_accP(DPAM_id,'BBO_CODE',''),'')<>''                            
								GROUP BY CLIC_DPAM_ID,DPAM_id
								HAVING ABS(SUM(CLIC_CHARGE_AMT)) > 0

						END 
      ELSE IF  @PA_B2B_OUTSTANDING_FLG='C'
      BEGIN

			Set  @L_SQL = ' INSERT INTO  #MAIN_BILL
			SELECT ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + ''' , ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + ''' ,LDG_ACCOUNT_ID,  ISNULL(CITRUS_USR.FN_UCC_accP(DPAM_id,''BBO_CODE'',''''),'''')  ,CASE WHEN SUM(LDG_AMOUNT)< 0 THEN ''D'' ELSE ''C'' END ,ABS(SUM(LDG_AMOUNT))  ,ISNULL(LDG_INSTRUMENT_NO,'''')
			FROM DP_ACCT_MSTR ,
			LEDGER' + convert(varchar,@l_fin_id) + '
			WHERE  LDG_ACCOUNT_ID = DPAM_ID  
			AND LDG_VOUCHER_DT >= ''' +  CONVERT(VARCHAR(11),@PA_BILLING_FROM_DT) + '''
			AND LDG_VOUCHER_DT <= ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + '''
			AND LDG_DPM_ID     = ' + convert(varchar,@L_DPM_ID) + '
			AND LDG_DELETED_IND = 1 
			AND LDG_ACCOUNT_TYPE = ''P''
			AND ISNULL(LDG_INSTRUMENT_NO,'''') <> ''''
			AND LDG_VOUCHER_TYPE in (''1'',''2'')
			--AND ISNULL(CITRUS_USR.FN_UCC_accP(DPAM_id,''BBO_CODE'',''''),'''')<>''''  
			GROUP BY LDG_ACCOUNT_ID,DPAM_CRN_NO , LDG_INSTRUMENT_NO
			HAVING SUM(LDG_AMOUNT) < 0 '
			print @L_SQL
			Execute(@L_SQL)
		END 
		ELSE
		BEGIN  
PRINT '@PA_BILLING_TO_DT'+convert(varchar,@PA_BILLING_TO_DT,103)
PRINT '@l_fin_id'+convert(varchar,@l_fin_id)
PRINT '@L_DPM_ID'+ convert(varchar,@L_DPM_ID)



			Set  @L_SQL = ' INSERT INTO  #MAIN_BILL
			SELECT ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + ''' , ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + ''' ,LDG_ACCOUNT_ID,  ISNULL(CITRUS_USR.FN_UCC_accP(DPAM_id,''BBO_CODE'',''''),'''')  ,CASE WHEN SUM(LDG_AMOUNT)< 0 THEN ''D'' ELSE ''C'' END ,ABS(SUM(LDG_AMOUNT))  ,''''
			FROM DP_ACCT_MSTR ,
			LEDGER' + convert(varchar,@l_fin_id) + '
			WHERE  LDG_ACCOUNT_ID = DPAM_ID  
			AND LDG_VOUCHER_DT <= ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + '''
			AND LDG_DPM_ID     = ' + convert(varchar,@L_DPM_ID) + '
			AND LDG_DELETED_IND = 1 
			AND LDG_ACCOUNT_TYPE = ''P''
			AND ISNULL(CITRUS_USR.FN_UCC_accP(DPAM_CRN_NO,''BBO_CODE'',''''),'''')<>''''  
			GROUP BY LDG_ACCOUNT_ID,DPAM_CRN_NO 
			HAVING SUM(LDG_AMOUNT) < 0 '						

PRINT @L_SQL
			Execute(@L_SQL)														
		END 


--						INSERT INTO  #MAIN_BILL  
--						SELECT @PA_BILLING_TO_DT,@PA_BILLING_TO_DT,ACCOUNT_ID,@BROKERGL_ACC_CD ,CASE WHEN DRCR = 'C' THEN 'D' ELSE 'C' END ,AMOUNT  ,CHEQUE_NO
--						FROM #MAIN_BILL 


						END    
						ELSE   
						BEGIN  

						IF @PA_B2B_OUTSTANDING_FLG='B'
						BEGIN 
								INSERT INTO  #MAIN_BILL  
								SELECT @PA_BILLING_TO_DT,@PA_BILLING_TO_DT,CLIC_DPAM_ID,ISNULL(CITRUS_USR.FN_UCC_accP(DPAM_CRN_NO,'BBO_CODE',''),'') 
								,CASE WHEN SUM(CLIC_CHARGE_AMT)> 0 THEN 'D' ELSE 'C' END ,ABS(SUM(CLIC_CHARGE_AMT)) ,''
        FROM DP_ACCT_MSTR,CLIENT_CHARGES_NSDL  
								WHERE  CLIC_DPAM_ID = DPAM_ID  
								AND CLIC_DPM_ID     = @L_DPM_ID    
								AND CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT   
								AND CLIC_DELETED_IND = 1         
								AND ISNULL(CITRUS_USR.FN_UCC_accP(DPAM_id,'BBO_CODE',''),'')<>''                            
								GROUP BY CLIC_DPAM_ID,DPAM_CRN_NO
								HAVING ABS(SUM(CLIC_CHARGE_AMT)) > 0
						END
      ELSE IF  @PA_B2B_OUTSTANDING_FLG='C'
      BEGIN
        Set  @L_SQL = ' INSERT INTO  #MAIN_BILL
								SELECT ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + ''' , ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + ''' ,LDG_ACCOUNT_ID,  ISNULL(CITRUS_USR.FN_UCC_accP(DPAM_id,''BBO_CODE'',''''),'''')  ,CASE WHEN SUM(LDG_AMOUNT)< 0 THEN ''D'' ELSE ''C'' END ,ABS(SUM(LDG_AMOUNT))  ,ISNULL(LDG_INSTRUMENT_NO,'''')
								FROM DP_ACCT_MSTR ,
								LEDGER' + convert(varchar,@l_fin_id) + '
								WHERE  LDG_ACCOUNT_ID = DPAM_ID  
        AND LDG_VOUCHER_DT >= ''' +  CONVERT(VARCHAR(11),@PA_BILLING_FROM_DT) + '''   
								AND LDG_VOUCHER_DT <= ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + '''
								AND LDG_DPM_ID     = ' + convert(varchar,@L_DPM_ID) + '
								AND LDG_DELETED_IND = 1 
        AND ISNULL(LDG_INSTRUMENT_NO,'''') <> ''''
        AND LDG_VOUCHER_TYPE in (''1'',''2'')
								--AND ISNULL(CITRUS_USR.FN_UCC_accP(DPAM_id,''BBO_CODE'',''''),'''')<>''''  
								GROUP BY LDG_ACCOUNT_ID,DPAM_CRN_NO ,LDG_INSTRUMENT_NO
								HAVING SUM(LDG_AMOUNT) < 0 '
								Execute(@L_SQL)
      END 
						ELSE
						BEGIN
								Set  @L_SQL = ' INSERT INTO  #MAIN_BILL
								SELECT ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + ''' , ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + ''' ,LDG_ACCOUNT_ID,  ISNULL(CITRUS_USR.FN_UCC_accP(DPAM_id,''BBO_CODE'',''''),'''')  ,CASE WHEN SUM(LDG_AMOUNT)< 0 THEN ''D'' ELSE ''C'' END ,ABS(SUM(LDG_AMOUNT))  ,''''
								FROM DP_ACCT_MSTR ,
								LEDGER' + convert(varchar,@l_fin_id) + '
								WHERE  LDG_ACCOUNT_ID = DPAM_ID  
								AND LDG_VOUCHER_DT <= ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + '''
								AND LDG_DPM_ID     = ' + convert(varchar,@L_DPM_ID) + '
								AND LDG_DELETED_IND = 1 
								AND ISNULL(CITRUS_USR.FN_UCC_accP(DPAM_id,''BBO_CODE'',''''),'''')<>''''  
								GROUP BY LDG_ACCOUNT_ID,DPAM_CRN_NO 
								HAVING SUM(LDG_AMOUNT) < 0 '
								Execute(@L_SQL)

						END

						INSERT INTO  #MAIN_BILL  
						SELECT @PA_BILLING_TO_DT,@PA_BILLING_TO_DT,ACCOUNT_ID,@BROKERGL_ACC_CD ,CASE WHEN DRCR = 'C' THEN 'D' ELSE 'C' END ,AMOUNT  , CHEQUE_NO 
						FROM #MAIN_BILL 
						END  


       IF  @PA_B2B_OUTSTANDING_FLG='C' 
       BEGIN
									SELECT CONVERT(VARCHAR(11),FROMDT,103) FROMDT,CONVERT(VARCHAR(11),TODT,103)TODT,CLTCODE,fina_acc_code=ACCOUNT_ID,DRCR,AMOUNT   , CHEQUE_NO
									FROM   #MAIN_BILL
									ORDER BY ACCOUNT_ID,DRCR desc
       END 
       ELSE 
       BEGIN
         SELECT CONVERT(VARCHAR(11),FROMDT,103) FROMDT,CONVERT(VARCHAR(11),TODT,103)TODT,CLTCODE,fina_acc_code=ACCOUNT_ID,DRCR,AMOUNT   
									FROM   #MAIN_BILL
									ORDER BY ACCOUNT_ID,DRCR desc
       END 
  
--  
END

GO
