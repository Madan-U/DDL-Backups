-- Object: PROCEDURE dbo.USP_VIRTUAL_MIS_LEDGER_REPORT_TEST
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


--EXEC USP_VIRTUAL_MIS_LEDGER_REPORT_TEST 'JUL  1 2020', 'JUL 31 2020', 'a','ZZZZ' ,'broker', 'broker'

CREATE PROC [dbo].[USP_VIRTUAL_MIS_LEDGER_REPORT_TEST]        
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
SELECT top 10 * FROM VIRTUAL_MIS_LEDGER_REPORT        
*/        
IF LEN(@FROM_DATE) = 10            
BEGIN            
 SELECT @FROM_DATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROM_DATE, 103), 109)            
 SELECT @TO_DATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TO_DATE, 103), 109)            
END            
 
 SELECT DISTINCT A.*, (CASE WHEN VAMT <> 0 THEN 'Y' ELSE 'N' END) AS LEDGERPOST FROM       
(SELECT        
 BR_CODE,SB_CODE,V.PARTY_CODE,C2.BANKNAME,PARTY_NAME,SEGMENT,AMOUNT,TXN_DATE,SOURCE_BANK_ACNO,BANK_REF_NO,
 TXN_REF_NO,PRODUCT,REMARKS        
FROM       
    
VIRTUAL_MIS_LEDGER_REPORT V ,MSAJAG..CLIENT_DETAILS C1,  MSAJAG..Party_BAnk_details C2   
 WHERE             
 V.PARTY_CODE BETWEEN @FROM_PARTY AND @TO_PARTY            
 AND V.PARTY_CODE=C1.CL_CODE      
 AND V.PARTY_CODE=C2.PARTY_CODE      
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
  
  
   ) A
  LEFT OUTER JOIN 
  (SELECT * FROM LEDGER_ALL WHERE VDT >=@FROM_DATE AND VDT <=@TO_DATE +' 23:59' AND VTYP =2) AS B
  ON A.PARTY_CODE=B.CLTCODE
  AND (CASE WHEN NARRATION LIKE '%IMPS|%' THEN  substring(narration,charindex('|',narration)+5,30) 
            WHEN NARRATION LIKE '%IMPS/%' THEN  SUBSTRING(REPLACE(NARRATION,'VIRTUAL IMPS/P2A/',''),0, CHARINDEX('/', REPLACE(NARRATION,'VIRTUAL IMPS/P2A/',''))) 
ELSE .DBO.PIECE(REPLACE(NARRATION,'VIRTUAL ',''), '|', 1) END  ) =TXN_REF_NO          
  AND txn_date=CONVERT(VARCHAR(11),VDT,120)
  AND EXCHANGE=SEGMENT
order by TXN_DATE,A.PARTY_CODE,BR_CODE

GO
