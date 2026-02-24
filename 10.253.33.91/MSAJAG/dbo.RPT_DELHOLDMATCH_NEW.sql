-- Object: PROCEDURE dbo.RPT_DELHOLDMATCH_NEW
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

-- EXEC RPT_DELHOLDMATCH_NEW '11544844', 'IN300394'  
  
CREATE PROC [dbo].[RPT_DELHOLDMATCH_NEW](  
           @CltDpId VARCHAR(16),  
           @DpId    VARCHAR(8))  
AS  
  CREATE TABLE #HOLDRECO (  
    ISIN          VARCHAR(12),  
    SCRIP_NAME    VARCHAR(50),  
    SETT_NO       VARCHAR(7),  
    SETT_TYPE     VARCHAR(2),  
    SCRIP_CD      VARCHAR(15),  
    QTY           NUMERIC(18,3),  
    FREEQTY       NUMERIC(18,3),  
    PLEDGEQTY     NUMERIC(18,3),  
    HOLDQTY       NUMERIC(18,3),  
    HOLDFREEQTY   NUMERIC(18,3),  
    HOLDPLEDGEQTY NUMERIC(18,3),  
    TODAYQTY      NUMERIC(18,3))  
  
DECLARE @TRANSDATE DATETIME  
  
SELECT @TRANSDATE = MAX(TRDATE) FROM DELCDSLBALANCE  
  
--SELECT @TRANSDATE = LEFT(GETDATE()  ,11)  
  
  SELECT   SETT_NO,  
           SETT_TYPE,  
           TRTYPE,  
           SCRIP_CD,  
           SERIES,  
           CERTNO,  
           QTY = SUM(QTY),  
           TRANSDATE=(CASE WHEN TRANSDATE > GETDATE() THEN LEFT(GETDATE(),11) ELSE TRANSDATE END),  
           DRCR,  
           BDPTYPE,  
           BDPID,  
           BCLTDPID,  
           FILLER2,  
           DELIVERED=(CASE WHEN TRANSDATE > GETDATE() THEN '0' ELSE DELIVERED END),  
           EXCHG = 'NSE'  
  INTO     #DEL  
  FROM     DELTRANS  
  WHERE    DRCR = 'D'  
           AND FILLER2 = 1  
           AND BCLTDPID = @CltDpId  
           AND BDPID = @DpId  
           AND SHARETYPE = 'DEMAT'  
     AND DELIVERED <> 'D'  
  GROUP BY SETT_NO,SETT_TYPE,TRTYPE,SCRIP_CD,  
           SERIES,CERTNO,TRANSDATE,DRCR,  
           BDPTYPE,BDPID,BCLTDPID,FILLER2,  
           DELIVERED  
/*  
INSERT   INTO     #DEL  
SELECT   SETT_NO,  
           SETT_TYPE,  
           TRTYPE,  
           SCRIP_CD,  
           SERIES,  
           CERTNO,  
           QTY = (CASE WHEN @CLTDPID = '1201090001320629' THEN -SUM(QTY) ELSE SUM(QTY) END),  
           TRANSDATE,  
           DRCR,  
           BDPTYPE,  
           BDPID,  
           BCLTDPID=@CLTDPID,  
           FILLER2=1,  
           DELIVERED,  
           EXCHG = 'NSE'  
  FROM     DELTRANS  
  WHERE    DRCR = 'D'  
           AND BCLTDPID = '1201090000252528'  
           AND BDPID = '12010900'  
           AND SHARETYPE = 'DEMAT'  
     AND FILLER2 = 0 AND DELIVERED = 'G'   
     AND TRANSDATE > (CASE WHEN @TRANSDATE < LEFT(GETDATE(),11)   
         THEN @TRANSDATE   
            ELSE LEFT(GETDATE(),11)    
       END)  
  GROUP BY SETT_NO,SETT_TYPE,TRTYPE,SCRIP_CD,  
           SERIES,CERTNO,TRANSDATE,DRCR,  
           BDPTYPE,BDPID,BCLTDPID,FILLER2,  
           DELIVERED  
*/  
INSERT   INTO     #DEL  
SELECT   SETT_NO,  
           SETT_TYPE,  
           TRTYPE,  
           SCRIP_CD,  
           SERIES,  
           CERTNO,  
           QTY = SUM(QTY),  
           TRANSDATE,  
           DRCR,  
           BDPTYPE,  
           BDPID,  
           BCLTDPID=@CLTDPID,  
           FILLER2=1,  
           DELIVERED='G',  
           EXCHG = 'NSE'  
  FROM     DELTRANSTEMP  
  WHERE    DRCR = 'D'  
           AND BCLTDPID = @CltDpId  
           AND BDPID = @DpId  
           AND SHARETYPE = 'DEMAT'  
     AND FILLER2 = 1 AND DELIVERED = 'D'   
     AND TRANSDATE > @TRANSDATE  
  GROUP BY SETT_NO,SETT_TYPE,TRTYPE,SCRIP_CD,  
           SERIES,CERTNO,TRANSDATE,DRCR,  
           BDPTYPE,BDPID,BCLTDPID,FILLER2,  
           DELIVERED  
             
  INSERT INTO #DEL  
  SELECT   SETT_NO,  
           SETT_TYPE,  
           TRTYPE,  
           SCRIP_CD,  
           SERIES,  
           ISIN,  
           SUM(QTY),  
           TRDATE,  
           DRCR = 'D',  
           BDPTYPE,  
           BDPID,  
           BCLTACCNO,  
           FILLER2 = 1,  
           DELIVERED = '0',  
           EXCHG = 'NSE'  
  FROM     DEMATTRANSBEN  
  WHERE    BCLTACCNO = @CltDpId  
           AND BDPID = @DpId AND 1 = 2  
  GROUP BY SETT_NO,SETT_TYPE,TRTYPE,SCRIP_CD,  
           SERIES,ISIN,TRDATE,BDPTYPE,  
           BDPID,BCLTACCNO  
  
                       
      INSERT INTO #HOLDRECO  
      SELECT   ISIN = ISNULL(CERTNO,A.ISIN),  
               SCRIP_NAME = '',  
            SETT_NO = 'NA',  
      SETT_TYPE = 'NA',  
               SCRIP_CD = '',  
               QTY = SUM((CASE   
                            WHEN DELIVERED = '0'  
                                 AND TRANSDATE <= left(@TRANSDATE,11) THEN QTY  
                            ELSE 0  
                          END)),  
               FREEQTY = SUM((CASE   
                                WHEN TRTYPE <> 909 THEN (CASE   
                                                           WHEN DELIVERED = '0'  
                                                                AND TRANSDATE <= left(@TRANSDATE,11) THEN QTY  
                                                           ELSE 0  
                                                         END)  
                                ELSE 0  
                              END)),  
               PLEDGEQTY = SUM((CASE   
                                  WHEN TRTYPE = 909 THEN QTY  
                                  ELSE 0  
                                END)),  
               HOLDQTY = ISNULL(CURRBAL,0),  
               HOLDFREEQTY = ISNULL(FREEBAL,0),  
               HOLDPLEDGEQTY = ISNULL(PLEDGEBAL,0),  
               TODAYQTY = SUM(CASE   
                                WHEN TRANSDATE >= left(@TRANSDATE,11)  
                                     AND DELIVERED = 'G' THEN QTY  
                                ELSE 0  
                              END)  
      FROM     #DEL D (nolock)  
               LEFT OUTER JOIN RPT_DELCDSLBALANCE A (nolock)  
                 ON (TRDATE = @TRANSDATE AND A.ISIN = CERTNO  
                     AND BCLTDPID = A.CLTDPID  
                     AND BDPID = A.DPID)  
      WHERE    BCLTDPID = @CltDpId  
               AND BDPID = @DpId  
               AND DRCR = 'D'  
               AND FILLER2 = 1  
               AND CERTNO LIKE 'IN%'  
               AND TRTYPE <> 906  
               AND (DELIVERED = (CASE   
                                   WHEN TRANSDATE >= left(@TRANSDATE,11) THEN 'G'  
                                   ELSE '0'  
                                 END)  
                     OR DELIVERED = (CASE   
                                       WHEN TRANSDATE >= left(@TRANSDATE,11) THEN 'D'  
                                       ELSE '0'  
                                     END)  
      OR DELIVERED = (CASE   
                                       WHEN TRANSDATE <= left(@TRANSDATE,11) THEN '0'  
                                       ELSE ''  
                                     END))  
      GROUP BY ISNULL(CERTNO,A.ISIN),FREEBAL,CURRBAL,  
               PLEDGEBAL  
      HAVING   (SUM((CASE   
                       WHEN DELIVERED = '0'  
                            AND TRANSDATE <= left(@TRANSDATE,11) THEN QTY  
                       ELSE 0  
                     END)) <> 0  
                 OR SUM((CASE   
                           WHEN TRTYPE <> 909 THEN (CASE   
                                                      WHEN DELIVERED = '0'  
                                                           AND TRANSDATE <= left(@TRANSDATE,11) THEN QTY  
                                                      ELSE 0  
                                                    END)  
                           ELSE 0  
                         END)) <> 0  
                 OR SUM((CASE   
                           WHEN TRTYPE = 909 THEN QTY  
                           ELSE 0  
                         END)) <> 0  
                 OR ISNULL(CURRBAL,0) <> 0  
                 OR ISNULL(FREEBAL,0) <> 0  
                 OR ISNULL(PLEDGEBAL,0) <> 0  
                 OR SUM(CASE   
                          WHEN TRANSDATE >= left(@TRANSDATE,11)  
                               AND DELIVERED = 'G' THEN QTY  
ELSE 0  
                        END) <> 0)  
        
   INSERT INTO #HOLDRECO  
      SELECT   ISIN = A.ISIN,  
               SCRIP_NAME = '',  
               SETT_NO = 'NA',  
               SETT_TYPE = 'NA',  
               SCRIP_CD = '',  
               QTY = 0,  
               FREEQTY = 0,  
            PLEDGEQTY = 0,  
   HOLDQTY = ISNULL(CURRBAL,0),  
               HOLDFREEQTY = ISNULL(FREEBAL,0),  
               HOLDPLEDGEQTY = ISNULL(PLEDGEBAL,0),  
               TODAYQTY = 0  
      FROM     RPT_DELCDSLBALANCE A (nolock)  
      WHERE    TRDATE = @TRANSDATE AND CLTDPID = @CltDpId  
               AND DPID = @DpId  
               AND A.ISIN NOT IN (SELECT DISTINCT ISIN  
                                  FROM   #HOLDRECO)  
      GROUP BY A.ISIN,FREEBAL,CURRBAL,  
               PLEDGEBAL  
      HAVING   (ISNULL(CURRBAL,0) <> 0  
                 OR ISNULL(FREEBAL,0) <> 0  
                 OR ISNULL(PLEDGEBAL,0) <> 0)  
  
  UPDATE #HOLDRECO  
  SET    SCRIP_CD = 'N/A',  
   SCRIP_NAME = 'N/A'  
             
  UPDATE #HOLDRECO  
  SET    SCRIP_CD = M.SCRIP_CD,  
   SCRIP_NAME = LONG_NAME  
  FROM   MULTIISIN M  
  WHERE  M.ISIN = #HOLDRECO.ISIN  
         AND M.VALID = 1  
  
  SELECT   *, TRANSDATE = CONVERT(VARCHAR,CONVERT(DATETIME,@TRANSDATE),103)  
  FROM     #HOLDRECO --WHERE ISIN = 'INF732E01037'  
  ORDER BY SCRIP_NAME

GO
