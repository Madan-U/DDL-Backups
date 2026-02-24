-- Object: PROCEDURE dbo.RPT_DELHOLDINGREPORT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_DELHOLDINGREPORT   
(@STATUSID   VARCHAR(15),   
 @STATUSNAME VARCHAR(25),   
 @FROMPARTY  VARCHAR(10),  
 @TOPARTY    VARCHAR(10),  
 @FROMSCRIP  VARCHAR(12),  
 @TOSCRIP    VARCHAR(12),  
 @BDPID      VARCHAR(8),  
 @BCLTDPID   VARCHAR(16),  
 @BRANCH     VARCHAR(10),  
 @FLAG       VARCHAR(1))  
AS  
  
SET @BRANCH = (CASE WHEN @BRANCH = '' THEN '%' ELSE @BRANCH END)  
SET @BDPID = (CASE WHEN @BDPID = '' THEN '%' ELSE @BDPID END)  
SET @BCLTDPID = (CASE WHEN @BCLTDPID = '' THEN '%' ELSE @BCLTDPID END)  
  
SELECT SETT_NO, SETT_TYPE, D.PARTY_CODE, C1.LONG_NAME, C1.BRANCH_CD,  
SCRIP_CD, SERIES, CERTNO,   
HOLDQTY = SUM(CASE WHEN TRTYPE = 904 AND DESCRIPTION NOT LIKE '%PLEDGE%'   
     THEN QTY   
     ELSE 0   
       END),   
PLEDGEQTY = SUM(CASE WHEN TRTYPE = 909 OR DESCRIPTION LIKE '%PLEDGE%'   
       THEN QTY   
       ELSE 0   
  END),   
BDPID, BCLTDPID,   
CL_RATE = CONVERT(NUMERIC(18,4),0), HOLDAMT = CONVERT(NUMERIC(18,4),0)  
INTO #HOLD FROM DELTRANS D, CLIENT1 C1, CLIENT2 C2, DELIVERYDP P  
WHERE C1.CL_CODE = C2.CL_CODE  
AND C2.PARTY_CODE = D.PARTY_CODE  
AND DRCR = 'D' AND FILLER2 = 1   
AND DELIVERED = '0' AND TRTYPE IN (904, 909)  
AND SHARETYPE = 'DEMAT'  
AND C2.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY  
AND D.SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP  
AND BDPID LIKE @BDPID AND BCLTDPID LIKE @BCLTDPID  
AND @StatusName =   
                  (case   
                        when @StatusId = 'BRANCH' then c1.branch_cd  
                        when @StatusId = 'SUBBROKER' then c1.sub_broker  
                        when @StatusId = 'Trader' then c1.Trader  
                        when @StatusId = 'Family' then c1.Family  
                        when @StatusId = 'Area' then c1.Area  
                        when @StatusId = 'Region' then c1.Region  
                        when @StatusId = 'Client' then c2.party_code  
                  else   
                        'BROKER'  
                  End)  
AND C1.BRANCH_CD LIKE @BRANCH  
AND D.BDPID = P.DPID AND D.BCLTDPID = P.DPCLTNO  
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
  
UPDATE #HOLD SET CL_RATE = C.CL_RATE, HOLDAMT = (HOLDQTY + PLEDGEQTY) * C.CL_RATE,  
HOLDQTY = (CASE WHEN @StatusId = 'BROKER' THEN HOLDQTY ELSE HOLDQTY + PLEDGEQTY END),  
PLEDGEQTY = (CASE WHEN @StatusId = 'BROKER' THEN PLEDGEQTY ELSE 0 END)  
FROM #NSE_LatestClosing C  
WHERE C.Scrip_Cd = #HOLD.Scrip_Cd                  
And C.Series = (Case When #HOLD.Series In ('EQ', 'BE')   
       Then 'EQ'   
       Else #HOLD.Series   
  End)  
  
IF @FLAG = 'P'   
BEGIN  
 SELECT * FROM #HOLD  
 ORDER BY PARTY_CODE, LONG_NAME, SCRIP_CD, SERIES, CERTNO, SETT_NO, SETT_TYPE, BDPID, BCLTDPID  
END   
ELSE  
BEGIN   
 SELECT * FROM #HOLD  
 ORDER BY SCRIP_CD, SERIES, CERTNO, PARTY_CODE, LONG_NAME, SETT_NO, SETT_TYPE, BDPID, BCLTDPID  
END

GO
