-- Object: PROCEDURE citrus_usr.PR_BSDA_CDSL_RESPONSE_bak_05122017
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

		-- EXEC PR_BSDA_CDSL_RESPONSE '','','','',''
		create  PROCEDURE [citrus_usr].[PR_BSDA_CDSL_RESPONSE_bak_05122017]
		(
		 @PA_FILLER1 VARCHAR(50)
		 ,@PA_FILLER2 DATETIME
		 ,@PA_FILLER3 DATETIME
		 ,@PA_FILLER4 VARCHAR(50)
		 ,@PA_FILLER5 VARCHAR(50)
		)
		AS
		BEGIN
		
		TRUNCATE TABLE TMP_BSDA_CDSL_RESPONSE_VAL 
		TRUNCATE TABLE TMP_BSDA_CDSL_RESPONSE
		
		DECLARE @@SSQL VARCHAR(8000)  
		SET @@SSQL ='BULK INSERT TMP_BSDA_CDSL_RESPONSE_VAL FROM ''' + 'C:\BULKINSDBFOLDER\BSDAREVFILE\08DPI5U21719521.051' + ''' WITH   
		(  
		FIELDTERMINATOR = ''~'',  
		ROWTERMINATOR = ''\n''  

		)'  
	
		EXEC(@@SSQL) 
		
		INSERT INTO TMP_BSDA_CDSL_RESPONSE
		SELECT citrus_usr.FN_SPLITVAL_BY(val,1,'~') 
		,citrus_usr.FN_SPLITVAL_BY(val,2,'~') 
		,citrus_usr.FN_SPLITVAL_BY(val,3,'~') 
		,citrus_usr.FN_SPLITVAL_BY(val,4,'~') 
		,citrus_usr.FN_SPLITVAL_BY(val,5,'~') 
		FROM TMP_BSDA_CDSL_RESPONSE_VAL
		
		 --declare @L_DPAM_ID int
         --SELECT @L_DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR ,  DPB9_PC1 WHERE DPAM_SBA_NO = BOID  AND BOID  = @C_BEN_ACCT_NO1  
  
--         --EXEC PR_INS_UPD_ACCP @L_CRN_NO ,'EDT','MIG',@L_DPAM_ID,@C_BEN_ACCT_NO1,'DP',@L_ACCP_VALUE,@L_ACCPD_VALUE ,0,'*|~*','|*~|','' 

		 Update P set filler9=status_flag from TMP_BSDA_CDSL_RESPONSE t,dps8_pc1 p where t.boid=p.boid

		
		END
		
		--DROP TABLE TMP_BSDA_CDSL_RESPONSE
		
		--CREATE TABLE TMP_BSDA_CDSL_RESPONSE_VAL (VAL VARCHAR(8000))
		
		--CREATE TABLE TMP_BSDA_CDSL_RESPONSE
		--(
		-- BOID VARCHAR(16)
		--,VALUATION MONEY
		--,STATUS_FLAG VARCHAR(50)
		--,FILLER1 VARCHAR(100)
		--,FILLER2 VARCHAR(100)
		--)
		
		--Select t.boid,filler9,status_flag from TMP_BSDA_CDSL_RESPONSE t,dps8_pc1 p where --ISNULL(status_flag,'')='Y'
		--t.boid=p.boid
		----and filler9=status_flag

GO
