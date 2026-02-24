-- Object: PROCEDURE dbo.PROC_SLBSEPN
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  PROC [dbo].[PROC_SLBSEPN]              
(              
 @EXPDATE VARCHAR(11),              
 @PARTY_CODE VARCHAR(10),              
 @SCRIP_CD VARCHAR(12)              
)              
AS              
              
DECLARE @SETT_NO VARCHAR(7),              
  @TDATE  VARCHAR(11)              
              
SELECT *              
INTO #POS               
FROM TBL_SLBS_EPNPOS WHERE 1 = 2              
              
SELECT @SETT_NO = SETT_NO FROM SETT_MST WHERE SETT_TYPE = 'P' AND RIGHT(SETT_NO,3) >= '500'               
AND LEFT(SEC_PAYIN, 11) = LEFT(CONVERT(DATETIME,@EXPDATE),11)                    
          
SELECT TOP 1 @TDATE = LEFT(SEC_PAYIN,11) FROM (                    
SELECT TOP 3 * FROM SETT_MST                    
WHERE SEC_PAYIN <= @EXPDATE                    
AND SETT_TYPE = 'N'                    
ORDER BY SEC_PAYIN DESC )  A                    
ORDER BY SEC_PAYIN                     
          
IF CONVERT(DATETIME,@TDATE) > CONVERT(DATETIME,LEFT(GETDATE(),11))              
BEGIN              
 INSERT INTO #POS               
 SELECT *, MARKED_QTY = 0, AVAL_QTY = 0               
 FROM VW_SLBSPOS              
 WHERE EXPIRYDATE = @EXPDATE               
 AND PARTY_CODE = (CASE WHEN LEN(@PARTY_CODE) > 0 THEN @PARTY_CODE ELSE PARTY_CODE END)              
 AND SCRIP_CD = (CASE WHEN LEN(@SCRIP_CD) > 0 THEN @SCRIP_CD ELSE SCRIP_CD END)              
             
 UPDATE #POS SET MARKED_QTY = D.MARKED_QTY              
 FROM TBL_SLBS_EPNPOS D              
 WHERE D.EXPIRYDATE = @EXPDATE               
 AND D.PARTY_CODE = #POS.PARTY_CODE              
 AND D.SCRIP_CD = #POS.SCRIP_CD              
/*            
 UPDATE #POS SET MARKED_QTY = D.MARKED_QTY             
 FROM (SELECT PARTY_CODE, SCRIP_CD, MARKED_QTY = SUM(CASE WHEN DRCR = 'C' THEN QTY ELSE -QTY END)               
    FROM MSAJAG.DBO.DELTRANS D              
    WHERE D.SETT_NO = @SETT_NO AND D.SETT_TYPE = 'P'              
    AND FILLER2 = 1 AND SHARETYPE <> 'AUCTION' --AND DRCR = 'D'       
    GROUP BY PARTY_CODE, SCRIP_CD              
    HAVING SUM(CASE WHEN DRCR = 'C' THEN QTY ELSE -QTY END) >= 0) D              
 WHERE D.PARTY_CODE = #POS.PARTY_CODE              
 AND D.SCRIP_CD = #POS.SCRIP_CD              
*/         
 UPDATE #POS SET AVAL_QTY = TRADEQTY - MARKED_QTY              
END              
              
SELECT * FROM #POS              
ORDER BY PARTY_CODE, SCRIP_CD

GO
