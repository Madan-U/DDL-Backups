-- Object: PROCEDURE dbo.RPT_TRADECHANGE_LOG_pratham
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




--RPT_TRADECHANGE_LOG_pratham 'broker','broker','apr  1 2012','mar 31 2015'



CREATE PROC RPT_TRADECHANGE_LOG_pratham     
(@STATUSID VARCHAR(25), 
@STATUSNAME VARCHAR(25),
 @fromdate VARCHAR(11),
 @todate VARCHAR(11)

 )  
AS    
    
SELECT WRONG_CODE = BRANCH_ID,CORRECT_CODE = PARTY_CODE,SCRIP_CD = SETTLEMENT.SCRIP_CD,SERIES = SERIES,           
TRADEQTY=SUM(TRADEQTY),SELL_BUY,MARKETRATE ,ORDER_NO,USER_ID,SAUDA_DATE INTO #TRDDATA FROM SETTLEMENT       
WHERE SAUDA_DATE >=@fromdate and Sauda_date<=@todate + ' 23:59:59'          
AND BRANCH_ID <> PARTY_CODE AND SETT_TYPE NOT IN ('X','A') AND USER_ID NOT IN(SELECT USERID FROM TERMPARTY)           
GROUP BY BRANCH_ID, PARTY_CODE, SETTLEMENT.SCRIP_CD,SERIES,SELL_BUY,MARKETRATE ,ORDER_NO,USER_ID ,SAUDA_DATE  
ORDER BY BRANCH_ID,PARTY_CODE,SETTLEMENT.SCRIP_CD          
    
SELECT WRONG_CODE,ISNULL(B.BRANCH_CD,'-') AS WBRANCH_CD,CORRECT_CODE,    
C2.BRANCH_CD AS CBRANCH_CD, SCRIP_CD, SERIES,TRADEQTY,SELL_BUY,MARKETRATE,ORDER_NO,USER_ID,SAUDA_DATE  
FROM CLIENT1 C2, #TRDDATA T LEFT OUTER JOIN CLIENT1 B     
ON (T.WRONG_CODE = B.CL_CODE)        
WHERE T.CORRECT_CODE = C2.CL_CODE  
AND @STATUSNAME =               
                  (CASE               
                        WHEN @STATUSID = 'BRANCH' THEN C2.BRANCH_CD              
                        WHEN @STATUSID = 'SUBBROKER' THEN C2.SUB_BROKER              
                        WHEN @STATUSID = 'TRADER' THEN C2.TRADER              
                        WHEN @STATUSID = 'FAMILY' THEN C2.FAMILY              
                        WHEN @STATUSID = 'AREA' THEN C2.AREA              
                        WHEN @STATUSID = 'REGION' THEN C2.REGION              
                        WHEN @STATUSID = 'CLIENT' THEN C2.CL_CODE              
                  ELSE               
                        'BROKER'              
                  END)      
  
DROP TABLE #TRDDATA

GO
