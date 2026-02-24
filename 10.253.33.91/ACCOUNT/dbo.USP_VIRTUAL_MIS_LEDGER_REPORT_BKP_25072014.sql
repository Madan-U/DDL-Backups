-- Object: PROCEDURE dbo.USP_VIRTUAL_MIS_LEDGER_REPORT_BKP_25072014
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

        
CREATE PROC [DBO].[USP_VIRTUAL_MIS_LEDGER_REPORT_BKP_25072014]        
(        
  @FROM_DATE VARCHAR(11),                  
  @TO_DATE VARCHAR(11),                  
  @FROM_PARTY VARCHAR(10),                  
  @TO_PARTY VARCHAR(10)          ,      
  @STATUSID VARCHAR(10),      
  @STATUSNAME VARCHAR(10)      
)        
AS        
/*        
SELECT * FROM VIRTUAL_MIS_LEDGER_REPORT        
*/        
IF LEN(@FROM_DATE) = 10            
BEGIN            
 SELECT @FROM_DATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROM_DATE, 103), 109)            
 SELECT @TO_DATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TO_DATE, 103), 109)            
END            
        
SELECT        
 BR_CODE,SB_CODE,V.PARTY_CODE,PARTY_NAME,SEGMENT,AMOUNT,TXN_DATE,SOURCE_BANK_ACNO,BANK_REF_NO,TXN_REF_NO,PRODUCT,REMARKS        
FROM       
    
VIRTUAL_MIS_LEDGER_REPORT V ,MSAJAG..CLIENT_DETAILS C1      
 WHERE             
 V.PARTY_CODE BETWEEN @FROM_PARTY AND @TO_PARTY            
 AND V.PARTY_CODE=C1.CL_CODE      
  AND TXN_DATE >= @FROM_DATE AND TXN_DATE <= @TO_DATE            
  AND   @STATUSNAME =           
                  (CASE           
                        WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD          
                        WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER          
                        WHEN @STATUSID = 'TRADER' THEN C1.TRADER          
                        WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY          
                        WHEN @STATUSID = 'AREA' THEN C1.AREA          
                        WHEN @STATUSID = 'REGION' THEN C1.REGION          
                        WHEN @STATUSID = 'CLIENT' THEN C1.CL_CODE          
                  ELSE           
                        'BROKER'          
                  END)   
                    
order by TXN_DATE,V.PARTY_CODE,BR_CODE

GO
