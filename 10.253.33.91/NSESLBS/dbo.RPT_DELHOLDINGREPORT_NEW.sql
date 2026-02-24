-- Object: PROCEDURE dbo.RPT_DELHOLDINGREPORT_NEW
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_DELHOLDINGREPORT_NEW  
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
HOLDQTY = SUM(QTY), OPENQTY = 0,       
D.DPID, D.CLTDPID  
INTO #HOLD FROM DELTRANS D, CLIENT1 C1, CLIENT2 C2  
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
AND Dummy10 = 'MONTOFRI'     
GROUP BY SETT_NO, SETT_TYPE, D.PARTY_CODE, C1.LONG_NAME, C1.BRANCH_CD,      
SCRIP_CD, SERIES, CERTNO, D.DPID, D.CLTDPID    
  
INSERT INTO #HOLD  
SELECT D.SETT_NO, D.SETT_TYPE, D.PARTY_CODE, C1.LONG_NAME, C1.BRANCH_CD,   
D.SCRIP_CD, D.SERIES, CERTNO = CONVERT(VARCHAR(12), ''),   
HOLDQTY = 0, OPENQTY = QTY,   
DPID = CONVERT(VARCHAR(8),''), CLTDPID = CONVERT(VARCHAR(16),'')  
FROM DELIVERYCLT D, SETT_MST S, CLIENT1 C1, CLIENT2 C2  
WHERE D.SETT_NO = S.SETT_NO  
AND D.SETT_TYPE = S.SETT_TYPE  
AND INOUT = 'O'  
AND SEC_PAYIN >= LEFT(GETDATE(),11)   
AND D.SETT_TYPE NOT IN ('A', 'X', 'AD', 'AC')  
AND C1.CL_CODE = C2.CL_CODE      
AND C2.PARTY_CODE = D.PARTY_CODE  
AND NOT EXISTS (  
SELECT DISTINCT SETT_NO FROM DELTRANS D1, DELIVERYDP P  
WHERE D.SETT_NO = D1.SETT_NO AND D.SETT_TYPE = D1.SETT_TYPE  
AND D1.BDPTYPE = P.DPTYPE AND D1.BDPID = P.DPID AND D1.BCLTDPID = P.DPCLTNO  
AND DESCRIPTION NOT LIKE '%POOL%')  
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
AND Dummy10 = 'MONTOFRI'  
AND C2.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY      
AND D.SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP  
  
INSERT INTO #HOLD  
SELECT D.SETT_NO, D.SETT_TYPE, D.PARTY_CODE, C1.LONG_NAME, C1.BRANCH_CD,   
D.SCRIP_CD, D.SERIES, CERTNO = CONVERT(VARCHAR(12), ''),   
HOLDQTY = 0, OPENQTY = -(D.QTY - ISNULL(SUM(D1.QTY),0)),  
DPID = CONVERT(VARCHAR(8),''), CLTDPID = CONVERT(VARCHAR(16),'')  
FROM SETT_MST S, CLIENT1 C1, CLIENT2 C2, DELIVERYCLT D LEFT OUTER JOIN DELTRANS D1  
ON (D.SETT_NO = D1.SETT_NO AND D.SETT_TYPE = D1.SETT_TYPE  
AND D.PARTY_CODE = D1.PARTY_CODE AND D.SCRIP_CD = D1.SCRIP_CD  
AND D.SERIES = D1.SERIES AND D1.DRCR = 'C' AND FILLER2 = 1 )  
WHERE D.SETT_NO = S.SETT_NO  
AND D.SETT_TYPE = S.SETT_TYPE  
AND INOUT = 'I'  
AND SEC_PAYIN >= LEFT(GETDATE(),11)   
AND D.SETT_TYPE NOT IN ('A', 'X', 'AD', 'AC')  
AND C1.CL_CODE = C2.CL_CODE      
AND C2.PARTY_CODE = D.PARTY_CODE  
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
AND Dummy10 = 'MONTOFRI'  
AND C2.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY      
AND D.SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP  
GROUP BY D.SETT_NO, D.SETT_TYPE, D.PARTY_CODE, C1.LONG_NAME, C1.BRANCH_CD, D.SCRIP_CD, D.SERIES, D.QTY  
HAVING D.QTY - ISNULL(SUM(D1.QTY),0) <> 0 

UPDATE #HOLD SET CERTNO = M.ISIN  
FROM MULTIISIN M  
WHERE M.SCRIP_CD = #HOLD.SCRIP_CD  
AND M.SERIES = #HOLD.SERIES  
AND VALID = 1 AND CERTNO = ''  
  
UPDATE #HOLD SET DPID = C.BANKID, CLTDPID = C.CLTDPID  
FROM CLIENT4 C  
WHERE C.PARTY_CODE = #HOLD.PARTY_CODE  
AND C.DEPOSITORY IN ('NSDL', 'CDSL')  
AND DEFDP = 1 AND DPID = ''  
  
IF @FLAG = 'P'       
BEGIN      
 SELECT PARTY_CODE,LONG_NAME,BRANCH_CD,SCRIP_CD,SERIES,CERTNO,HOLDQTY=SUM(HOLDQTY),OPENQTY=SUM(OPENQTY),DPID,CLTDPID  
 FROM #HOLD      
 GROUP BY PARTY_CODE,LONG_NAME,BRANCH_CD,SCRIP_CD,SERIES,CERTNO,DPID,CLTDPID  
 ORDER BY PARTY_CODE, LONG_NAME, SCRIP_CD, SERIES, CERTNO, DPID, CLTDPID      
END       
ELSE      
BEGIN       
 SELECT PARTY_CODE,LONG_NAME,BRANCH_CD,SCRIP_CD,SERIES,CERTNO,HOLDQTY=SUM(HOLDQTY),OPENQTY=SUM(OPENQTY),DPID,CLTDPID  
 FROM #HOLD      
 GROUP BY PARTY_CODE,LONG_NAME,BRANCH_CD,SCRIP_CD,SERIES,CERTNO,DPID,CLTDPID  
 ORDER BY SCRIP_CD, SERIES, CERTNO, PARTY_CODE, LONG_NAME, DPID, CLTDPID   
END

GO
