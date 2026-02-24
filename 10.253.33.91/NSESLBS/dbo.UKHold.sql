-- Object: PROCEDURE dbo.UKHold
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create Proc UKHold
as

SELECT SETT_NO, SETT_TYPE, D.PARTY_CODE, C1.LONG_NAME, C1.BRANCH_CD,
SCRIP_CD, SERIES, CERTNO, QTY = SUM(QTY), BDPID, BCLTDPID, 
CL_RATE = CONVERT(NUMERIC(18,4),0), HOLDAMT = CONVERT(NUMERIC(18,4),0)
INTO #HOLD FROM MSAJAG.dbo.DELTRANS D, UKRMS R
WHERE r.PARTY_CODE = D.PARTY_CODE
AND DRCR = 'D' AND FILLER2 = 1 
AND DELIVERED = '0' AND TRTYPE IN (904, 909)
AND SHARETYPE = 'DEMAT'
GROUP BY SETT_NO, SETT_TYPE, D.PARTY_CODE, C1.LONG_NAME, C1.BRANCH_CD,
SCRIP_CD, SERIES, CERTNO, BDPID, BCLTDPID

      SELECT     
            Scrip_Cd,     
            Series='EQ',     
            Cl_Rate,     
            SysDate     
      INTO #NSE_LatestClosing     
      FROM Closing C WITH(NOLOCK)    
      WHERE SYSDATE =     
            (    
                  SELECT     
                        MAX(SYSDATE)     
                  FROM Closing WITH(NOLOCK)     
                  WHERE SCRIP_CD = C.SCRIP_CD      
                        And C.SERIES In ('BE', 'EQ')    
            )    
      And SERIES In ('BE', 'EQ')    
    
      INSERT INTO #NSE_LatestClosing     
      SELECT     
            Scrip_Cd,     
            Series,     
            Cl_Rate,     
            SysDate     
      FROM Closing C WITH(NOLOCK)    
      WHERE SYSDATE =     
            (    
                  SELECT     
                        MAX(SYSDATE)     
                  FROM Closing WITH(NOLOCK)     
                  WHERE SCRIP_CD = C.SCRIP_CD      
                        And SERIES = C.SERIES     
            )    
      And SERIES Not In ('BE', 'EQ') 

UPDATE #HOLD SET CL_RATE = C.CL_RATE, HOLDAMT = QTY * C.CL_RATE
FROM #NSE_LatestClosing C
WHERE C.Scrip_Cd = #HOLD.Scrip_Cd                
And C.Series = (Case When #HOLD.Series In ('EQ', 'BE') 
		     Then 'EQ' 
		     Else #HOLD.Series 
		End)



Select * from #Hold

GO
