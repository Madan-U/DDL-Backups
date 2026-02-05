-- Object: PROCEDURE citrus_usr.Pr_Rpt_Holding_bak23mar2012
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

-- BEGIN TRAN
 /* 
ROLLBACK

COMMIT

 EXEC PR_RPT_HOLDING 'NSDL',4,'N','MAY 29 2009','10697005','','','N',1 ,'HO|*~|','11','2009093', '2009095',''		

EXEC PR_RPT_HOLDING 'NSDL',4,'N','2009-05-22','1203270000187997','1203270000187997','','Y',83001,'HO|*~|','','','',''	

EXEC PR_RPT_HOLDING	'NSDL','4','Y','11/06/2009 12:00:00 AM','10000096','','','Y',1,'HO|*~|','','','',''	
*/
 
CREATE PROC [citrus_usr].[Pr_Rpt_Holding_bak23mar2012]  
			@PA_DPTYPE VARCHAR(4),                    
			@PA_EXCSMID INT,                    
			@PA_ASONDATE CHAR(1),                    
			@PA_FORDATE DATETIME,                    
			@PA_FROMACCID VARCHAR(16),                    
			@PA_TOACCID VARCHAR(16),                    
			@PA_ISINCD VARCHAR(12),              
			@PA_WITHVALUE CHAR(1), --Y/N                    
			@PA_LOGIN_PR_ENTM_ID NUMERIC,                      
			@PA_LOGIN_ENTM_CD_CHAIN  VARCHAR(8000),                      
            @PA_SETTM_TYPE VARCHAR(100),
            @PA_SETTM_NO_FR   VARCHAR(100),
            @PA_SETTM_NO_TO   VARCHAR(100),
			@PA_OUTPUT VARCHAR(8000) OUTPUT                      
AS                          
BEGIN                          
       

exec getdatelist

if @PA_SETTM_NO_TO = ''
set @PA_SETTM_NO_TO   = @PA_SETTM_NO_FR   
            
                   
DECLARE @@DPMID INT,                          
		@@TMPHOLDING_DT DATETIME

set @pa_settm_type  = case when @pa_settm_type ='0' then  '' else  @pa_settm_type  end 

 SELECT @pa_settm_type = SETTM_TYPE FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) = @pa_settm_type             AND SETTM_DELETED_IND = 1

 set @pa_settm_type = case when @pa_settm_type ='0' then  '' else  @pa_settm_type  end 

  
SELECT @@DPMID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSMID AND DPM_DELETED_IND =1                          

DECLARE @@L_CHILD_ENTM_ID      NUMERIC                      

SELECT @@L_CHILD_ENTM_ID    =  CITRUS_USR.FN_GET_CHILD(@PA_LOGIN_PR_ENTM_ID , @PA_LOGIN_ENTM_CD_CHAIN)                      

CREATE TABLE 
#ACLIST
(
DPAM_ID BIGINT,
DPAM_SBA_NO VARCHAR(16),
DPAM_SBA_NAME VARCHAR(150),
EFF_FROM DATETIME,
EFF_TO DATETIME
)  
                     
                    
IF @PA_FROMACCID = ''                    

BEGIN                    

			 SET @PA_FROMACCID = '0'                    

			 SET @PA_TOACCID = '99999999999999999'                    

END                      

IF @PA_TOACCID = ''                    

			BEGIN                    

			 SET @PA_TOACCID = @PA_FROMACCID                    
END                    

                        
IF @PA_TOACCID =''                          
BEGIN                          

SET @PA_TOACCID= @PA_FROMACCID               

END                          
              
 IF @PA_WITHVALUE = 'N'              
 BEGIN  
	  IF @PA_ASONDATE = 'Y'                          
	  BEGIN  
			 SELECT TOP 1 @PA_FORDATE = convert(varchar(11),getdate(),109)--DPHMC_HOLDING_DT FROM DP_HLDG_MSTR_CDSL WHERE DPHMC_DELETED_IND =1                           
	  end 	
	  
	 
	        
			 INSERT INTO #ACLIST SELECT DPAM_ID,DPAM_SBA_NO,DPAM_SBA_NAME,EFF_FROM,isnull(EFF_TO,'dec 31 2900') FROM CITRUS_USR.FN_ACCT_LIST(@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID)    


			 SELECT 
						DPAM_SBA_NAME,
						DPAM_SBA_NO,DPHMCD_ISIN,
						ISIN_NAME,
						CONVERT(NUMERIC(18,3),DPHMCD_CURR_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_FREE_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_FREEZE_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_PLEDGE_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_DEMAT_PND_VER_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_REMAT_PND_CONF_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_DEMAT_PND_CONF_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_SAFE_KEEPING_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_LOCKIN_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_ELIMINATION_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_EARMARK_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_AVAIL_LEND_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_LEND_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_BORROW_QTY),
						DPAM_ID, 
						HOLDING_DT=CONVERT(VARCHAR(11),@PA_FORDATE,109)                           
			FROM 
						vw_fetchclientholding LEFT OUTER JOIN ISIN_MSTR ON DPHMCD_ISIN = ISIN_CD,                    
						#ACLIST ACCOUNT                                
			WHERE
						DPHMCD_HOLDING_DT = @PA_FORDATE AND DPHMCD_DPM_ID = @@DPMID                          
						AND DPHMCD_DPAM_ID = ACCOUNT.DPAM_ID                      
						AND (DPHMCD_HOLDING_DT BETWEEN EFF_FROM AND EFF_TO)                    
						AND (CONVERT(NUMERIC,DPAM_SBA_NO) BETWEEN CONVERT(NUMERIC,@PA_FROMACCID) AND  CONVERT(NUMERIC,@PA_TOACCID))  
						--AND ISNULL(DPHMCD_CURR_QTY,0) <> 0                           
						AND DPHMCD_ISIN LIKE @PA_ISINCD + '%'                          
			ORDER BY 
						DPAM_SBA_NO,ISIN_NAME,DPHMCD_ISIN                          

		        

		                      
	END
	ELSE --@PA_WITHVALUE ='Y'              
	BEGIN              
    
	
	   IF @PA_ASONDATE = 'Y'                          
	   BEGIN                      
		 SELECT TOP 1 @PA_FORDATE = convert(varchar(11),getdate(),109)--DPHMC_HOLDING_DT FROM DP_HLDG_MSTR_CDSL WHERE DPHMC_DELETED_IND =1              
	   END 
   
		 INSERT INTO #ACLIST SELECT DPAM_ID,DPAM_SBA_NO,DPAM_SBA_NAME,EFF_FROM,isnull(EFF_TO,'dec 31 2900') FROM CITRUS_USR.FN_ACCT_LIST(@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID)    
	             
  
		 SELECT distinct DPAM_SBA_NAME,DPAM_SBA_NO,DPHMCD_ISIN,ISIN_NAME,CONVERT(NUMERIC(18,3),DPHMCD_CURR_QTY),VALUATION=CONVERT(NUMERIC(18,2),DPHMCD_CURR_QTY*ISNULL(CLOPM_CDSL_RT,0)), CONVERT(NUMERIC(18,3),DPHMCD_FREE_QTY),CONVERT(NUMERIC(18,3),DPHMCD_FREEZE_QTY)      
		 ,CONVERT(NUMERIC(18,3),DPHMCD_PLEDGE_QTY),CONVERT(NUMERIC(18,3),DPHMCD_DEMAT_PND_VER_QTY),CONVERT(NUMERIC(18,3),DPHMCD_REMAT_PND_CONF_QTY),CONVERT(NUMERIC(18,3),DPHMCD_DEMAT_PND_CONF_QTY),CONVERT(NUMERIC(18,3),DPHMCD_SAFE_KEEPING_QTY),CONVERT(NUMERIC(18,3),DPHMCD_LOCKIN_QTY)      
		 ,CONVERT(NUMERIC(18,3),DPHMCD_ELIMINATION_QTY),CONVERT(NUMERIC(18,3),DPHMCD_EARMARK_QTY),CONVERT(NUMERIC(18,3),DPHMCD_AVAIL_LEND_QTY),CONVERT(NUMERIC(18,3),DPHMCD_LEND_QTY),CONVERT(NUMERIC(18,3),DPHMCD_BORROW_QTY),DPAM_ID, HOLDING_DT=CONVERT(VARCHAR(11),@PA_FORDATE,109),CMP=ISNULL(convert(numeric(18,2),CLOPM_CDSL_RT),0.00)    
		 FROM vw_fetchclientholding               
		 LEFT OUTER JOIN ISIN_MSTR ON DPHMCD_ISIN = ISIN_CD              
		 LEFT OUTER JOIN CLOSING_PRICE_MSTR_cDSL ON DPHMCD_ISIN = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = DPHMCD_ISIN and CLOPM_DT <= @PA_FORDATE and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)   ,                    
		 #ACLIST ACCOUNT                                
		 WHERE DPHMCD_HOLDING_DT = @PA_FORDATE AND DPHMCD_DPM_ID = @@DPMID                          
		 AND DPHMCD_DPAM_ID = ACCOUNT.DPAM_ID                      
		 AND (DPHMCD_HOLDING_DT BETWEEN EFF_FROM AND EFF_TO)                    
		 AND (CONVERT(NUMERIC,DPAM_SBA_NO) BETWEEN CONVERT(NUMERIC,@PA_FROMACCID) AND  CONVERT(NUMERIC,@PA_TOACCID))                         
		 AND DPHMCD_ISIN LIKE @PA_ISINCD + '%'      
		-- AND ISNULL(DPHMCD_CURR_QTY,0) <> 0             
		 ORDER BY DPAM_SBA_NO,ISIN_NAME,DPHMCD_ISIN                          
                       
                   
    END             
              
              
              
   
  
      TRUNCATE TABLE #ACLIST  
   DROP TABLE #ACLIST             
                          
END

GO
