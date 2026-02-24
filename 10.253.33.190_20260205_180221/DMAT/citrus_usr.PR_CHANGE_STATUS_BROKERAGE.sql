-- Object: PROCEDURE citrus_usr.PR_CHANGE_STATUS_BROKERAGE
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--alter TABLE BROKERAGE_MSTR ADD BROM_ACTIVE_YN char(1)
--alter TABLE CHARGE_MSTR ADD CHAM_ACTIVE_YN char(1)
--PR_CHANGE_STATUS_BROKERAGE '1*|~*','ACTIVE','CHARGE',3,'CDSL','',''
CREATE PROCEDURE [citrus_usr].[PR_CHANGE_STATUS_BROKERAGE](@PA_ID VARCHAR(8000)  
                                           ,@PA_TAB VARCHAR(100)  
                                           ,@PA_LEVEL VARCHAR(100)
                                           ,@PA_SEARCH_ID1 VARCHAR(100)  
                                           ,@PA_SEARCH_ID2 VARCHAR(100)  
                                           ,@PA_SEARCH_ID3 VARCHAR(100)  
                                           ,@PA_OUT VARCHAR(1000) OUT )  
AS  
BEGIN  
   
 DECLARE @L_COUNTER NUMERIC  
 ,@L_COUNT NUMERIC  
   
 SET @L_COUNTER = 1 
 IF @PA_LEVEL = 'PROFILE'
 BEGIN
 		IF @PA_TAB='ACTIVE'  
			BEGIN  
					SET @L_COUNT = CITRUS_USR.ufn_CountString(@PA_ID,'*|~*')  
					WHILE @L_COUNTER <= @L_COUNT  
					BEGIN  
		     
						UPDATE BROKERAGE_MSTR  
						SET    BROM_ACTIVE_YN = 'I'  
						WHERE  BROM_ID = CITRUS_USR.FN_SPLITVAL_ROW(@PA_ID,@L_COUNTER)  
		      
		       
						SET @L_COUNTER = @L_COUNTER + 1  
		      
					END   
			END  
			ELSE IF @PA_TAB = 'INACTIVE'  
			BEGIN  
					SET @L_COUNT = CITRUS_USR.ufn_CountString(@PA_ID,'*|~*')  
					WHILE @L_COUNTER <= @L_COUNT  
					BEGIN  
		     
						UPDATE BROKERAGE_MSTR  
						SET    BROM_ACTIVE_YN = 'A'  
						WHERE  BROM_ID = CITRUS_USR.FN_SPLITVAL_ROW(@PA_ID,@L_COUNTER)  
		      
		       
						SET @L_COUNTER = @L_COUNTER + 1  
		      
					END   
			END  
			ELSE IF @PA_TAB='SELECT_PROFILE'  
			BEGIN  
				SELECT BROM_ID  ID
										,BROM_DESC  BROMDESC
										,ESM.EXCSM_EXCH_CD  
										,esm.EXCSM_SEG_CD  
										,BROM_ACTIVE_YN   
				FROM BROKERAGE_MSTR , EXCH_SEG_MSTR esm, EXCSM_PROD_MSTR epm   
				WHERE ISNULL(BROKERAGE_MSTR.BROM_ACTIVE_YN,'A') = @PA_SEARCH_ID1  
				AND   BROKERAGE_MSTR.BROM_EXCPM_ID  = EPM.EXCPM_ID  
				AND   EPM.EXCPM_EXCSM_ID = esm.EXCSM_ID  
				AND   esm.EXCSM_EXCH_CD  =@PA_SEARCH_ID2  
				AND   BROM_DESC  LIKE CASE WHEN @PA_SEARCH_ID3 <> '' THEN '%'+@PA_SEARCH_ID3 +'%' ELSE '%' END   
				AND   BROM_DELETED_IND = 1  
			END
 END   
 ELSE IF @PA_LEVEL ='CHARGE'
 BEGIN
 	IF @PA_TAB='ACTIVE'  
			BEGIN  
					SET @L_COUNT = CITRUS_USR.ufn_CountString(@PA_ID,'*|~*')  

					WHILE @L_COUNTER <= @L_COUNT  

					BEGIN  
		     
						UPDATE CHARGE_MSTR  
						SET    CHAM_ACTIVE_YN = 'I'  
						WHERE  CHAM_SLAB_NO = CITRUS_USR.FN_SPLITVAL_ROW(@PA_ID,@L_COUNTER)  
						
						
						
				
		       
						SET @L_COUNTER = @L_COUNTER + 1  
		      
					END   
			END  
			ELSE IF @PA_TAB = 'INACTIVE'  
			BEGIN  
					SET @L_COUNT = CITRUS_USR.ufn_CountString(@PA_ID,'*|~*')  
					WHILE @L_COUNTER <= @L_COUNT  
					BEGIN  
		     
						UPDATE CHARGE_MSTR  
						SET    CHAM_ACTIVE_YN = 'A'  
						WHERE  CHAM_SLAB_NO = CITRUS_USR.FN_SPLITVAL_ROW(@PA_ID,@L_COUNTER)  
						
			
		       
						SET @L_COUNTER = @L_COUNTER + 1  
		      
					END   
			END  
			ELSE IF @PA_TAB='SELECT_CHARGE'  
			BEGIN  
				SELECT CHAM_SLAB_NO ID
				,CHAM_SLAB_NAME BROMDESC
				,CHAM_ACTIVE_YN
				FROM CHARGE_MSTR, PROFILE_CHARGES pc,BROKERAGE_MSTR bm, EXCH_SEG_MSTR esm, EXCSM_PROD_MSTR epm  
				WHERE BROM_ID = PC.PROC_PROFILE_ID 
				AND   CHAM_SLAB_NO = PC.PROC_SLAB_NO  
				AND   ISNULL(CHARGE_MSTR.CHAM_ACTIVE_YN,'A') = @PA_SEARCH_ID1  
				AND   BM.BROM_EXCPM_ID  = EPM.EXCPM_ID  
				AND   EPM.EXCPM_EXCSM_ID = esm.EXCSM_ID  
				AND   esm.EXCSM_EXCH_CD  =@PA_SEARCH_ID2  
				AND   CHAM_SLAB_NAME  LIKE CASE WHEN @PA_SEARCH_ID3 <> '' THEN '%'+@PA_SEARCH_ID3 +'%' ELSE '%' END   
				AND   CHAM_DELETED_IND = 1  
			END
 END
END

GO
