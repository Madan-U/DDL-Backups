-- Object: PROCEDURE dbo.PROC_STG_GL_INT_DUMP_NEWDP
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------



  
  
  
  
 
  
  
  
  
  
CREATE PROCEDURE [dbo].[PROC_STG_GL_INT_DUMP_NEWDP] (@SEGMENT VARCHAR(10))        
AS            
         
  --- EXEC [PROC_STG_GL_INT_DUMP_DP] 'BSEDP'      
        
IF @SEGMENT ='DP'        
           
BEGIN                
 SET NOCOUNT ON                
          
  Declare @VACC_FROM VARCHAR(20), @VACC_TO VARCHAR(20), @VDATE DATETIME       
  SET @VACC_FROM = (                
    SELECT PARAM_VALUE                
    FROM [ABCSOORACLEMDLW].oramid.dbo.TB_PARAMETER_SETTINGS                
    WHERE PARAM_NAME = 'FY_FROM_DATE'                
     AND PARAM_CATEGORY = 'TB_PUSH'                
    )                
  SET @VACC_TO = (                
    SELECT PARAM_VALUE                
    FROM [ABCSOORACLEMDLW].oramid.dbo.TB_PARAMETER_SETTINGS                
    WHERE PARAM_NAME = 'FY_TO_DATE'                
     AND PARAM_CATEGORY = 'TB_PUSH'                
    )                
  SET @VDATE =  CONVERT(DATETIME, @VACC_TO)       
      
               
 CREATE TABLE #TMP_TB_PUSH (CLTCODE VARCHAR(10), ACNAME VARCHAR(150), DRAMT NUMERIC(18, 4), CRAMT NUMERIC(18, 4), CLBALANCE NUMERIC(18, 4), ACCAT VARCHAR(5), GRPNAME VARCHAR(100), GRPCATEGORY VARCHAR(100), SEGMENT VARCHAR(50), SEGMENT1 VARCHAR(25))       
  
    
      CREATE INDEX CLTCODE ON #TMP_TB_PUSH(CLTCODE,ACNAME, grpname, grpcategory,SEGMENT1)



        
         
 INSERT INTO #TMP_TB_PUSH (CLTCODE, ACNAME, DRAMT, CRAMT, CLBALANCE, ACCAT, GRPNAME, GRPCATEGORY, SEGMENT, SEGMENT1)                
 SELECT L.LDG_ACCOUNT_ID, null, SUM(CASE                 
    WHEN LDG_AMOUNT <= '0'                
     THEN LDG_AMOUNT*-1                
    ELSE 0                
    END) AS DRAMT, SUM(CASE                 
    WHEN LDG_AMOUNT >= '0'              
     THEN LDG_AMOUNT * - 1                
    ELSE 0                
    END) AS CRAMT, 0 AS CLBALANCE, NULL, NULL, NULL,   'DP','140'      
                      
   FROM AngelDP5.DMAT.citrus_usr.LEDGER10 L WITH(NOLOCK)  ------------3 for April---              
 WHERE LDG_VOUCHER_DT >= @VACC_FROM             
  AND LDG_VOUCHER_DT <= @VACC_TO  and  LDG_DELETED_IND =1                     
   GROUP BY L.LDG_ACCOUNT_ID              
  
/*  
1. April 2014 To March 2015 = Ledger1  
  
*/   
  
                
                
 UPDATE #TMP_TB_PUSH                
 SET CLBALANCE = DRAMT + CRAMT                
             
                
 UPDATE #TMP_TB_PUSH                
      SET grpname = FINA_GROUP_ID   ,CLTCODE=(case when FINA_ACC_CODE like '%SGST' then 'SGST'  
when FINA_ACC_CODE like '%IGST' then 'IGST'  
when FINA_ACC_CODE like '%CGST' then 'CGST'  
when FINA_ACC_CODE like '%UGST' then 'UGST'  
else FINA_ACC_CODE end) , ACNAME =FINA_ACC_NAME            
      FROM AngelDP5.DMAT.CITRUS_USR.FIN_ACCOUNT_MSTR       WITH(NOLOCK)      
      WHERE CLTCODE  =   FINA_ACC_ID               
                 
  UPDATE #TMP_TB_PUSH                
     SET GRPCATEGORY = FINGM_GROUP_NAME                 
     FROM AngelDP5.DMAT.CITRUS_USR.FIN_ACCOUNT_MSTR  WITH(NOLOCK)      ,AngelDP5.DMAT.CITRUS_USR.FIN_GROUP_MSTR    WITH(NOLOCK)                
     WHERE FINA_GROUP_ID =FINGM_GROUP_CODE AND CLTCODE =FINA_ACC_CODE       
	 
	 SELECT DPAM_ID,DPAM_SBA_NO INTO #DP  FROM AngelDP5.DMAT.CITRUS_USR.DP_ACCT_MSTR  WITH(NOLOCK)     --  WHERE  EXISTS (SELECT  CLTCODE FROM  #TMP_TB_PUSH WHERE CONVERT(VARCHAR(8), DPAM_ID)=CLTCODE)
	 CREATE INDEX CLTCODE ON  #DP(DPAM_ID)
                
 UPDATE #TMP_TB_PUSH SET CLTCODE =RIGHT(DPAM_SBA_NO,8)      
  FROM #DP  WITH(NOLOCK)       WHERE  CLTCODE  = CONVERT(VARCHAR(8), DPAM_ID)
              
                
 DELETE                
 FROM TB_CLASS                
 WHERE SEGMENT = @SEGMENT                
                
 INSERT INTO TB_CLASS                
 SELECT *                
 FROM #TMP_TB_PUSH where  CLBALANCE <> 0 --added in discussion with sachin by naginder        
       
 DELETE FROM STG_GL_INT_DUMP WHERE SEGMENT1 ='140'               
                
 /* DUMP INTO STAGING TABLE USER_JE_CATEGORY_NAME=88,USER_JE_SOURCE_NAME=4 FOR PRADYNA */                
 INSERT INTO STG_GL_INT_DUMP (ACCOUNTING_DATE, USER_JE_CATEGORY_NAME, USER_JE_SOURCE_NAME, SEGMENT1, ACCOUNTED_DR, ACCOUNTED_CR, ATTRIBUTE13, ATTRIBUTE14, BO_CODE, BO_DESCRIPTION)                
 SELECT @VDATE, '88', '4', SEGMENT1, CASE                 
   WHEN SUM(CLBALANCE) > 0                
    THEN SUM(CLBALANCE)                
   ELSE 0                   END ACCOUNTED_DR, CASE                 
   WHEN SUM(CLBALANCE) < 0                
    THEN SUM(- CLBALANCE)                
   ELSE 0                
   END ACCOUNTED_CR, GRPNAME, GRPCATEGORY, cltcode, acname                
 FROM #TMP_TB_PUSH                
 WHERE GRPNAME  IS NOT NULL  -- as per discussion with sachin d added by naginder                
 and CLBALANCE <> 0              
 GROUP BY CLTCODE, ACNAME, grpname, grpcategory,SEGMENT1         
             
 --SELECT * FROM #TMP_TB_PUSH            
              
               
 INSERT INTO STG_GL_INT_DUMP (ACCOUNTING_DATE, USER_JE_CATEGORY_NAME, USER_JE_SOURCE_NAME, SEGMENT1, ACCOUNTED_DR, ACCOUNTED_CR, ATTRIBUTE13, ATTRIBUTE14, BO_CODE, BO_DESCRIPTION)                
 SELECT @VDATE, '88', '4', SEGMENT1, SUM(CLBALANCE) ACCOUNTED_DR, 0 AS ACCOUNTED_CR, GRPNAME, GRPCATEGORY, 'DR', 'CLIENTBALANCE'                
 FROM #TMP_TB_PUSH                
 WHERE GRPNAME  IS NULL                 
  AND CLBALANCE > 0                
 GROUP BY grpname, grpcategory,SEGMENT1                
                
 INSERT INTO STG_GL_INT_DUMP (ACCOUNTING_DATE, USER_JE_CATEGORY_NAME, USER_JE_SOURCE_NAME, SEGMENT1, ACCOUNTED_DR, ACCOUNTED_CR, ATTRIBUTE13, ATTRIBUTE14, BO_CODE, BO_DESCRIPTION)                
 SELECT @VDATE, '88', '4', SEGMENT1, 0 AS ACCOUNTED_DR, SUM(- CLBALANCE) AS ACCOUNTED_CR, GRPNAME, GRPCATEGORY, 'CR', 'CLIENTBALANCE'                
 FROM #TMP_TB_PUSH                
 WHERE GRPNAME  IS NULL            
  AND CLBALANCE < 0                
 GROUP BY grpname, grpcategory,SEGMENT1                
                  
 DROP TABLE #TMP_TB_PUSH                
END               
        
 -- SELECT * FROM STG_GL_INT_DUMP WHERE SEGMENT1 ='139'      
         
          
  --SELECT * FROM STG_GL_INT_DUMP WHERE SEGMENT1 ='BSEDP'        
        
          
                
--EXEC PROC_STG_GL_INT_DUMP_ACBPL 'NCDX', 'APR  1 2013', 'Mar 31 2014 23:59', '31-Mar-14'           
--SELECT * FROM STG_GL_INT_DUMP

GO
