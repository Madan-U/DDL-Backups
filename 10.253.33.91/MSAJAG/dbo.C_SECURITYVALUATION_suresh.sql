-- Object: PROCEDURE dbo.C_SECURITYVALUATION_suresh
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



   

   
  
 ----EXEC C_SECURITYVALUATION_suresh 'NSE','FUTURES','ANGELFO','jan 10 2017'     

CREATE PROC [dbo].[C_SECURITYVALUATION_suresh](        

          @EXCHANGE VARCHAR(3),        

          @SEGMENT  VARCHAR(7),        

          @SHAREDB  VARCHAR(20),        

          @VALDATE  VARCHAR(11))        

AS        

        
DECLARE @CL_DATE VARCHAR(11),
		@NSENAVDATE VARCHAR(11),
		@BSENAVDATE VARCHAR(11)		
		

  SELECT @NSENAVDATE = ISNULL(MAX(NAV_DATE), @VALDATE) FROM MFSS_NAV01 WHERE NAV_DATE < @VALDATE 
  SELECT @BSENAVDATE = ISNULL(MAX(NAV_DATE), @VALDATE) FROM ANGELFO.BSEMFSS.DBO.MFSS_NAV WHERE NAV_DATE < @VALDATE 

  DELETE FROM C_VALUATION        

  WHERE       SYSDATE LIKE @VALDATE + '%'        

              AND EXCHANGE = @EXCHANGE        

              AND SEGMENT = @SEGMENT        

                                    

/*=============================================================================        

GET LATEST CLOSING        

=============================================================================*/        

  SELECT EXCHANGE = 2,        

         *        

  INTO   #TEMPCLOSING        

  FROM   (SELECT I.ISIN,        

                 C1.SCRIP_CD,        

                 C1.SERIES,        

                 CL_RATE = ISNULL(C1.CL_RATE,0),        

                 C1.SYSDATE        

          FROM   ANAND.BSEDB_AB.DBO.CLOSING C1 WITH (nolock),        

                 ANGELDEMAT.BSEDB.DBO.MULTIISIN I WITH (nolock)        

          WHERE  SYSDATE = (SELECT MAX(SYSDATE)        

                            FROM   ANAND.BSEDB_AB.DBO.CLOSING C2 WITH (nolock)        

                            WHERE  SYSDATE <= @VALDATE + ' 23:59:59'        

                                   AND C1.SCRIP_CD = C2.SCRIP_CD        

                                   AND C1.SERIES = C2.SERIES)        

                 AND C1.SCRIP_CD = I.SCRIP_CD        

                 AND C1.SERIES = I.SERIES) V        

              

  INSERT INTO #TEMPCLOSING        

  SELECT EXCHANGE = 1,        

         *        

  FROM   (SELECT I.ISIN,        

                 C1.SCRIP_CD,        

                 C1.SERIES,        

                 CL_RATE = ISNULL(C1.CL_RATE,0),        

                 C1.SYSDATE        

          FROM   MSAJAG.DBO.CLOSING C1 WITH (nolock),        

                 ANGELDEMAT.MSAJAG.DBO.MULTIISIN I WITH (nolock)        

          WHERE  SYSDATE = (SELECT MAX(SYSDATE)        

                            FROM   MSAJAG.DBO.CLOSING C2 WITH (nolock)        

                            WHERE  SYSDATE <= @VALDATE + ' 23:59:59'        

                                   AND C1.SCRIP_CD = C2.SCRIP_CD        

                                   AND C1.SERIES = C2.SERIES)        

                 AND C1.SCRIP_CD = I.SCRIP_CD        

                 AND C1.SERIES = I.SERIES) V        

                  

  SELECT   F.ISIN,        

           CL_RATE = MIN(F.CL_RATE),        

           SYSDATE = LEFT(F.SYSDATE,11)        

  INTO     #LATESTCLOSING        

  FROM     #TEMPCLOSING F,        

           (SELECT   EXCHANGE = MIN(EXCHANGE),        

                     ISIN,        

                     SYSDATE        

            FROM     #TEMPCLOSING C        

            WHERE    SYSDATE = (SELECT MAX(SYSDATE)        

                                FROM   #TEMPCLOSING C1        

                                WHERE  C.ISIN = C1.ISIN)        

            GROUP BY ISIN,SYSDATE) F1        

  WHERE    F.EXCHANGE = F1.EXCHANGE        

           AND F.SYSDATE = F1.SYSDATE        

           AND F.ISIN = F1.ISIN        

  GROUP BY F.ISIN,LEFT(F.SYSDATE,11)     

    

    

/*=============================================================================        

GET LATEST CLOSING        

=============================================================================*/        

        

  SELECT   PARTY_CODE,        

           SCRIP_CD,        

           SERIES,        

           CRQTY = SUM(CASE         

                         WHEN DRCR = 'C' THEN QTY        

                         ELSE -QTY        

                       END),        

           S.ISIN,        

           CL_RATE = ISNULL(C.CL_RATE,0),        

           FLAG = (CASE         

             WHEN ISNULL(C.SYSDATE,'JAN  1 1900') = @VALDATE THEN 1        

                     ELSE 0        

                   END)        

  INTO     #SECMST        

  FROM     C_SECURITIESMST S WITH(NOLOCK)        

           LEFT OUTER JOIN #LATESTCLOSING C        

             ON (S.ISIN = C.ISIN)        

  WHERE    PARTY_CODE <> 'BROKER'        

           AND EFFDATE <= @VALDATE + ' 23:59:59'        

           AND EXCHANGE = @EXCHANGE      

           AND SEGMENT = @SEGMENT        

  GROUP BY PARTY_CODE,SCRIP_CD,SERIES,S.ISIN,        

           ISNULL(C.CL_RATE,0),ISNULL(C.SYSDATE,'JAN  1 1900')        

  HAVING   SUM(CASE         

                 WHEN DRCR = 'C' THEN QTY        

                 ELSE -QTY        

               END) <> 0        

      

      

  select party_code, scrip_Cd, series, trtype, drcr, delivered, filler2, sharetype,       

  bdptype, bdpid, bcltdpid, certno, qty = sum(Qty)      

  into #delttr      

  from ANGELDEMAT.BSEDB.DBO.DELTRANS D WITH(NOLOCK),      

   ANGELDEMAT.BSEDB.DBO.DELIVERYDP DP WITH(NOLOCK)        

  WHERE    BDPTYPE = DP.DPTYPE        

           AND BDPID = DP.DPID        

           AND BCLTDPID = DP.DPCLTNO        

           AND PARTY_CODE <> 'BROKER'        

           AND PARTY_CODE <> 'PARTY'        

           AND TRTYPE IN (904,905,909)        

           AND DRCR = 'D'        

           AND DELIVERED = '0'        

           AND FILLER2 = 1        

           AND SHARETYPE = 'DEMAT'        

           AND EXCHANGE = @EXCHANGE        

           AND SEGMENT = @SEGMENT        

           AND ACCOUNTTYPE = 'MAR'        

  group by party_code, scrip_Cd, series, trtype, drcr, delivered, filler2, sharetype,       

  bdptype, bdpid, bcltdpid, certno      

    

  insert   into #delttr      

  select party_code, scrip_Cd, series, trtype, drcr, delivered, filler2, sharetype,       

  bdptype, bdpid, bcltdpid, certno, qty = sum(Qty)      

  from ANGELDEMAT.BSEDB.DBO.DELTRANS D WITH(NOLOCK),      

   ANGELDEMAT.BSEDB.DBO.DELIVERYDP DP WITH(NOLOCK)        

  WHERE    BDPTYPE = DP.DPTYPE        

           AND BDPID = DP.DPID        

           AND BCLTDPID = DP.DPCLTNO        

           AND PARTY_CODE <> 'BROKER'        

           AND PARTY_CODE <> 'PARTY'        

           AND TRTYPE = 1000       

           AND DRCR = 'D'        

           AND DELIVERED = 'G'        

           AND FILLER2 = 1        

           AND SHARETYPE = 'DEMAT'        

           AND EXCHANGE = @EXCHANGE        

           AND SEGMENT = @SEGMENT        

           AND ACCOUNTTYPE = 'MAR'    

     AND TRANSDATE > @VALDATE         

  group by party_code, scrip_Cd, series, trtype, drcr, delivered, filler2, sharetype,       

  bdptype, bdpid, bcltdpid, certno     

        

 insert   into #delttr      

  select party_code, scrip_Cd, series, trtype, drcr, delivered, filler2, sharetype,       

  bdptype, bdpid, bcltdpid, certno, qty = sum(Qty)      

  from ANGELDEMAT.msajag.DBO.DELTRANS D WITH(NOLOCK),      

   ANGELDEMAT.msajag.DBO.DELIVERYDP DP WITH(NOLOCK)        

  WHERE    BDPTYPE = DP.DPTYPE        

           AND BDPID = DP.DPID        

           AND BCLTDPID = DP.DPCLTNO        

           AND PARTY_CODE <> 'BROKER'        

           AND PARTY_CODE <> 'PARTY'        

           AND TRTYPE IN (904,905,909)        

           AND DRCR = 'D'        

           AND DELIVERED = '0'        

           AND FILLER2 = 1        

           AND SHARETYPE = 'DEMAT'        

           AND EXCHANGE = @EXCHANGE        

           AND SEGMENT = @SEGMENT        

           AND ACCOUNTTYPE = 'MAR'        

  group by party_code, scrip_Cd, series, trtype, drcr, delivered, filler2, sharetype,       

  bdptype, bdpid, bcltdpid, certno      

    

 insert   into #delttr      

  select party_code, scrip_Cd, series, trtype, drcr, delivered, filler2, sharetype,       

  bdptype, bdpid, bcltdpid, certno, qty = sum(Qty)      

  from ANGELDEMAT.msajag.DBO.DELTRANS D WITH(NOLOCK),      

   ANGELDEMAT.msajag.DBO.DELIVERYDP DP WITH(NOLOCK)        

  WHERE    BDPTYPE = DP.DPTYPE        

           AND BDPID = DP.DPID        

           AND BCLTDPID = DP.DPCLTNO        

           AND PARTY_CODE <> 'BROKER'        

           AND PARTY_CODE <> 'PARTY'        

           AND TRTYPE = 1000      

           AND DRCR = 'D'        

           AND DELIVERED = 'G'        

           AND FILLER2 = 1        

           AND SHARETYPE = 'DEMAT'        

           AND EXCHANGE = @EXCHANGE        

           AND SEGMENT = @SEGMENT        

           AND ACCOUNTTYPE = 'MAR'    

     AND TRANSDATE > @VALDATE         

  group by party_code, scrip_Cd, series, trtype, drcr, delivered, filler2, sharetype,       

  bdptype, bdpid, bcltdpid, certno      

    

      

  update #delttr set scrip_cd = m.scrip_cd, series = m.series      

  from ANGELDEMAT.msajag.DBO.multiisin m      

  where m.isin = certno and valid = 1       

      

  INSERT INTO #SECMST        

  SELECT   PARTY_CODE,        

           SCRIP_CD,        

           SERIES,        

           CRQTY = SUM(QTY),        

     D.CERTNO,        

           CL_RATE = ISNULL(C.CL_RATE,0),        

           FLAG = (CASE         

                     WHEN ISNULL(C.SYSDATE,'JAN  1 1900') = @VALDATE THEN 1        

                     ELSE 0        

                   END)        

  FROM     #delttr D WITH(NOLOCK)         

           LEFT OUTER JOIN #LATESTCLOSING C        

             ON (D.CERTNO = C.ISIN),         

           ANGELDEMAT.MSAJAG.DBO.DELIVERYDP DP WITH(NOLOCK)        

  WHERE    BDPTYPE = DP.DPTYPE        

           AND BDPID = DP.DPID        

           AND BCLTDPID = DP.DPCLTNO        

           AND PARTY_CODE <> 'BROKER'        

           AND PARTY_CODE <> 'PARTY'        

           AND TRTYPE IN (904,905,909, 1000)        

           AND DRCR = 'D'        

           AND FILLER2 = 1        

           AND SHARETYPE = 'DEMAT'        

           AND EXCHANGE = @EXCHANGE        

           AND SEGMENT = @SEGMENT        

           AND ACCOUNTTYPE = 'MAR'        

  GROUP BY PARTY_CODE,SCRIP_CD,SERIES,D.CERTNO,        

           ISNULL(C.CL_RATE,0),ISNULL(C.SYSDATE,'JAN  1 1900')        

      

  INSERT INTO #SECMST        

  SELECT   PARTY_CODE,        

           SCRIP_CD,        

           SERIES,        

           CRQTY = SUM(QTY),        

     D.CERTNO,        

           CL_RATE = ISNULL(C.CL_RATE,0),        

           FLAG = (CASE         

                     WHEN ISNULL(C.SYSDATE,'JAN  1 1900') = @VALDATE THEN 1        

                     ELSE 0        

                   END)        

  FROM     #delttr D WITH(NOLOCK)         

           LEFT OUTER JOIN #LATESTCLOSING C        

             ON (D.CERTNO = C.ISIN),         

           ANGELDEMAT.BSEDB.DBO.DELIVERYDP DP WITH(NOLOCK)        

  WHERE    BDPTYPE = DP.DPTYPE        

           AND BDPID = DP.DPID        

           AND BCLTDPID = DP.DPCLTNO        

           AND PARTY_CODE <> 'BROKER'        

           AND PARTY_CODE <> 'PARTY'        

           AND TRTYPE IN (904,905,909,1000)        

           AND DRCR = 'D'        

           AND FILLER2 = 1        

           AND SHARETYPE = 'DEMAT' AND EXCHANGE = @EXCHANGE        

           AND SEGMENT = @SEGMENT        

           AND ACCOUNTTYPE = 'MAR'        

  GROUP BY PARTY_CODE,SCRIP_CD,SERIES,D.CERTNO,        

           ISNULL(C.CL_RATE,0),ISNULL(C.SYSDATE,'JAN  1 1900')     

  

print @NSENAVDATE
print @NSENAVDATE

select * from #SECMST where isin='INF179K01756'


  UPDATE #SECMST SET CL_RATE = NAV_VALUE, FLAG = 1
  FROM MFSS_NAV01
  WHERE MFSS_NAV01.NAV_DATE BETWEEN @NSENAVDATE AND  @NSENAVDATE + ' 23:59'
  AND #SECMST.ISIN = MFSS_NAV01.ISIN
  AND #SECMST.SERIES='MF'
  --AND #SECMST.CL_RATE = 0 

  
select * from #SECMST where isin='INF179K01756'
return

  UPDATE #SECMST SET CL_RATE = NAV_VALUE, FLAG = 1
  FROM ANGELFO.BSEMFSS.DBO.MFSS_NAV MFSS_NAV01
  WHERE MFSS_NAV01.NAV_DATE BETWEEN @NSENAVDATE AND  @NSENAVDATE + ' 23:59'
  AND #SECMST.ISIN = MFSS_NAV01.ISIN
  AND #SECMST.SERIES='MF'
  --AND #SECMST.CL_RATE = 0 
    

      

  INSERT INTO C_VALUATION        

             (EXCHANGE,        

              SEGMENT,        

              MARKET,        

              SHAREDB,        

              SCRIP_CD,        

              SERIES,        

              CL_RATE,        

              SYSDATE)        

  SELECT DISTINCT @EXCHANGE,        

                  @SEGMENT,        

                  'NORMAL',        

       @SHAREDB,        

                  SCRIP_CD,        

                  SERIES,        

                  CL_RATE,        

                  @VALDATE        

  FROM   #SECMST        

  WHERE  FLAG = 1        
  	EXEC C_SECURITYVALUATION_OTHER  @EXCHANGE,  @SEGMENT,  @SHAREDB,  @VALDATE

                        

  SELECT   DISTINCT SCRIP_CD,        

                    SERIES,        

                    CL_RATE        

  FROM     #SECMST        

  WHERE    FLAG = 0        

  ORDER BY SCRIP_CD,        

           SERIES

GO
