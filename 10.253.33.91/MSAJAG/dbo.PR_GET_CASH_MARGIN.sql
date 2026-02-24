-- Object: PROCEDURE dbo.PR_GET_CASH_MARGIN
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
  
  
CREATE PROC [dbo].[PR_GET_CASH_MARGIN]        
(      
@EFFDATE Varchar(11),      
@INTMODE INT = 0        
) AS        
        
/*        
 @INTMODE = 0 - BEN HOLDING (TRTYPE = 904)        
 @INTMODE = 1 - PLEDGE HOLDING (TRTYPE = 909)        
*/        
DECLARE @CASH INT        
DECLARE @NCASH INT        
        
CREATE TABLE #DELHOLD        
(        
 EXCHANGE VARCHAR(3),        
 PARTY_CODE VARCHAR(10),        
 SCRIP_CD VARCHAR(12),        
 SERIES  VARCHAR(3),        
 ISIN  VARCHAR(16),        
 QTY   INT,        
)        
        
      
CREATE CLUSTERED INDEX IDSCRIP ON #DELHOLD (ISIN)        
      
IF LEFT(GETDATE(),11) = @EFFDATE    
--IF 1 = 1   
BEGIN     
    
INSERT INTO #DELHOLD       
SELECT         
 EXCHANGE = 'NSE',         
 PARTY_CODE,         
 D.SCRIP_CD,         
 D.SERIES,         
 ISIN = CERTNO,        
 QTY = SUM(QTY)        
FROM      
[AngelDemat].MSAJAG.DBO.DELTRANS D, [AngelDemat].MSAJAG.DBO.DELIVERYDP DP      
WHERE         
 D.BDPID = DP.DPID        
 AND DP.DESCRIPTION NOT LIKE '%POOL%'        
 AND DP.DESCRIPTION NOT LIKE '%PRINC%'          
AND D.BCLTDPID = DPCLTNO        
 AND D.DRCR = 'D'        
 AND FILLER2 = 1         
 AND DELIVERED = 'G'        
 AND TRTYPE = 1000        
 AND PARTY_CODE <> 'BROKER'        
 AND TRANSDATE >= LEFT(GETDATE(),11)   
 AND SEGMENT = 'CAPITAL' AND ACCOUNTTYPE = 'BEN'     
GROUP BY         
 PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO        
  
  
INSERT INTO #DELHOLD       
SELECT         
 EXCHANGE = 'NSE',         
 PARTY_CODE,         
 D.SCRIP_CD,         
 D.SERIES,         
 ISIN = CERTNO,        
 QTY = SUM(QTY)        
FROM      
[AngelDemat].MSAJAG.DBO.DELTRANS D, [AngelDemat].MSAJAG.DBO.DELIVERYDP DP      
WHERE         
 D.BDPID = DP.DPID            
AND D.BCLTDPID = DPCLTNO        
 AND D.DRCR = 'D'        
 AND FILLER2 = 1         
 AND DELIVERED = '0'        
 AND TRTYPE = 904      
 AND SHARETYPE = 'DEMAT'    
 AND PARTY_CODE <> 'BROKER'        
 AND SEGMENT = 'CAPITAL' AND ACCOUNTTYPE = 'BEN'  
GROUP BY         
 PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO     
         
INSERT INTO #DELHOLD       
      
SELECT         
 EXCHANGE = 'NSE',         
 PARTY_CODE,         
 D.SCRIP_CD ,         
 D.SERIES,         
 ISIN = CERTNO,        
 QTY = SUM(QTY)        
FROM         
[AngelDemat].BSEDB.DBO.DELTRANS D , [AngelDemat].BSEDB.DBO.DELIVERYDP DP         
WHERE         
 D.BDPID = DP.DPID        
 AND DP.DESCRIPTION NOT LIKE '%POOL%'        
 AND DP.DESCRIPTION NOT LIKE '%PRINC%'        
 AND D.BCLTDPID = DPCLTNO        
 AND D.DRCR = 'D'        
 AND FILLER2 = 1         
 AND DELIVERED = 'G'        
 AND TRTYPE = 1000        
 AND PARTY_CODE <> 'BROKER'        
 AND TRANSDATE >= LEFT(GETDATE(),11)       
 AND SEGMENT = 'CAPITAL' AND ACCOUNTTYPE = 'BEN'  
GROUP BY         
 PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO        
  
INSERT INTO #DELHOLD       
SELECT         
 EXCHANGE = 'BSE',         
 PARTY_CODE,         
 D.SCRIP_CD,         
 D.SERIES,         
 ISIN = CERTNO,        
 QTY = SUM(QTY)        
FROM      
[AngelDemat].BSEDB.DBO.DELTRANS D, [AngelDemat].BSEDB.DBO.DELIVERYDP DP      
WHERE         
 D.BDPID = DP.DPID            
AND D.BCLTDPID = DPCLTNO        
 AND D.DRCR = 'D'        
 AND FILLER2 = 1         
 AND DELIVERED = '0'        
 AND TRTYPE = 904      
 AND SHARETYPE = 'DEMAT'    
 AND PARTY_CODE <> 'BROKER'        
 AND SEGMENT = 'CAPITAL' AND ACCOUNTTYPE = 'BEN'  
GROUP BY         
 PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO         
      
INSERT INTO #DELHOLD       
      
SELECT         
 EXCHANGE = 'NSE',         
 PARTY_CODE,         
 D.SCRIP_CD,         
 D.SERIES,         
 ISIN = CERTNO,        
 QTY = SUM(QTY)        
FROM [AngelDemat].MSAJAG.DBO.DELTRANS D , --MSAJAG.DBO.DELIVERYDP DP  (NOLOCK),       
(SELECT SETT_NO, SETT_TYPE, SEC_PAYIN FROM [AngelDemat].MSAJAG.DBO.SETT_MST        
WHERE LEFT(GETDATE(),11) BETWEEN START_DATE AND SEC_PAYIN) S      
WHERE         
D.SETT_NO = S.SETT_NO       
AND D.SETT_TYPE = S.SETT_TYPE          
AND D.DRCR = 'C'        
AND FILLER2 = 1         
AND SHARETYPE <> 'AUCTION'       
AND PARTY_CODE <> 'BROKER'        
AND TRANSDATE < SEC_PAYIN        
AND TRTYPE <> 906      
AND LEFT(GETDATE(),11) <> LEFT(SEC_PAYIN,11)      
and tcode not in (select tcode from [AngelDemat].MSAJAG.DBO.DELTRANS d1      
 where d1.sett_no = d.sett_no and d1.sett_type = d.sett_type      
 and d1.certno = d.certno and d1.drcr <> d.drcr and d1.trtype = 906 and d1.filler1 = 'early payin')      
GROUP BY         
 PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO        
        
INSERT INTO #DELHOLD       
      
SELECT         
 EXCHANGE = 'NSE',      PARTY_CODE,         
 D.SCRIP_CD ,         
 D.SERIES,         
 ISIN = CERTNO,        
 QTY = SUM(QTY)        
FROM         
[AngelDemat].BSEDB.DBO.DELTRANS D , --MSAJAG.DBO.DELIVERYDP DP  (NOLOCK),       
(SELECT SETT_NO, SETT_TYPE, SEC_PAYIN FROM [AngelDemat].BSEDB.DBO.SETT_MST    
WHERE LEFT(GETDATE(),11) BETWEEN START_DATE AND SEC_PAYIN) S      
WHERE         
D.SETT_NO = S.SETT_NO       
AND D.SETT_TYPE = S.SETT_TYPE        
AND D.DRCR = 'C'        
AND FILLER2 = 1         
AND SHARETYPE <> 'AUCTION'       
AND PARTY_CODE <> 'BROKER'        
AND TRANSDATE < SEC_PAYIN      
--AND TRANSDATE >= START_DATE      
AND TRTYPE <> 906      
AND LEFT(GETDATE(),11) <> LEFT(SEC_PAYIN,11)      
and tcode not in (select tcode from [AngelDemat].MSAJAG.DBO.DELTRANS d1      
 where d1.sett_no = d.sett_no and d1.sett_type = d.sett_type      
 and d1.certno = d.certno and d1.drcr <> d.drcr and d1.trtype = 906 and d1.filler1 = 'early payin')      
GROUP BY         
 PARTY_CODE, D.SCRIP_CD, D.SERIES, CERTNO       
         
UPDATE #DELHOLD SET SCRIP_CD = M.SCRIP_CD, SERIES = M.SERIES        
FROM [AngelDemat].MSAJAG.DBO.MULTIISIN M       
WHERE M.ISIN = #DELHOLD.ISIN        
AND VALID = 1       
      
UPDATE #DELHOLD SET SCRIP_CD = M.SCRIP_CD, SERIES = M.SERIES        
FROM [AngelDemat].BSEDB.DBO.MULTIISIN M       
WHERE M.ISIN = #DELHOLD.ISIN        
AND VALID = 1 AND (#DELHOLD.SERIES IS NULL OR #DELHOLD.SCRIP_CD IS NULL)      
      
DELETE FROM DELHOLD_MARGIN WHERE TRANSDATE = @EFFDATE      
      
INSERT INTO DELHOLD_MARGIN       
SELECT       
 EXCHANGE, PARTY_CODE, SCRIP_CD, SERIES, ISIN, QTY=SUM(QTY), TRANSDATE = @EFFDATE      
FROM #DELHOLD      
GROUP BY EXCHANGE, PARTY_CODE, SCRIP_CD, SERIES, ISIN      
END      
   
        
DROP TABLE #DELHOLD        
/*-------------------------------  END OF THE PROC -----------------------------*/

GO
