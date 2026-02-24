-- Object: PROCEDURE dbo.PROC_COMBINE_MARGIN_REPORTING_PEAK_16072021
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[PROC_COMBINE_MARGIN_REPORTING_PEAK_16072021]
(@MARGINDATE   VARCHAR(11), 
 @COMBINEFLAG  INT         = 1, 
 @FORREPORTING VARCHAR(1)  = 'Y', 
 @CHECKFLAG    INT         = 0
)
AS

     -- EXEC PROC_COMBINE_MARGIN_REPORTING_PEAK 'APR 27 2021', 1, 'Y', 0    
     --DUE TO COMBINE_REPORTING LIVE     
     --SET @COMBINEFLAG = 0    

     SET NOCOUNT ON;
     DECLARE @PREVDATE VARCHAR(11);
     DECLARE @EXCHANGE_NEW VARCHAR(3);
     DECLARE @SEGMENT_NEW VARCHAR(10);
     DECLARE @SHAREDB VARCHAR(35);
     DECLARE @SHARESERVER VARCHAR(35);
     DECLARE @ACCOUNTDB VARCHAR(35);
     DECLARE @ACCOUNTSERVER VARCHAR(35);
     DECLARE @EXCHANGEWISE_CURSOR CURSOR;
     DECLARE @STRSQL VARCHAR(8000);
     DECLARE @MARGINDATENEW VARCHAR(11);
     DECLARE @MARGINDATECURSOR CURSOR;
     DECLARE @MRGCUR CURSOR;
     DECLARE @CNT INT;
     DECLARE @DAY INT;
     DECLARE @PARTY_CODE VARCHAR(10);
     DECLARE @SHRT_AMT NUMERIC(18, 4);
     DECLARE @MARG_AMT NUMERIC(18, 4);
     DECLARE @EXCHANGE_PRIORITY INT;
     DECLARE @VARKEY VARCHAR(8);

/*  
SELECT @VARKEY = DETAILKEY FROM VARCONTROL   
WHERE RECDATE >= @MARGINDATE AND RECDATE <= @MARGINDATE + ' 23:59'  
    
SELECT SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY=NETQTY,PAYQTY=0,MTOM,NETAMT,  
ADNL_MARGIN=CONVERT(NUMERIC(18,4),0),  
ADNL_PER=CONVERT(NUMERIC(18,4),0)  
INTO #PAYIN  
FROM TBL_MG02 D   
WHERE D.MARGIN_DATE = @MARGINDATE  
AND MTOM <> 0   
  
UPDATE #PAYIN SET ADNL_PER = INDEXVAR  
FROM VARDETAIL D WHERE DETAILKEY =@VARKEY AND D.SCRIP_CD = #PAYIN.SCRIP_CD AND D.SERIES = #PAYIN.SERIES  
  
UPDATE #PAYIN SET ADNL_MARGIN = ABS(NETAMT*ADNL_PER) / 100  
WHERE QTY < 0   
  
SELECT DISTINCT SETT_NO, SETT_TYPE INTO #SETT FROM #PAYIN   
  
UPDATE #PAYIN SET PAYQTY = D.QTY   
FROM (SELECT D.SETT_NO, D.SETT_TYPE, PARTY_CODE,SCRIP_CD,D.SERIES,QTY = SUM(QTY)  
   FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS D, #SETT S  
   WHERE D.SETT_NO = S.SETT_NO   
   AND D.SETT_TYPE = S.SETT_TYPE  
   AND FILLER2 = 1 AND DRCR = 'C' AND SHARETYPE <> 'AUCTION'  
   GROUP BY  D.SETT_NO, D.SETT_TYPE, PARTY_CODE,SCRIP_CD,D.SERIES ) D  
WHERE D.SETT_NO = #PAYIN.SETT_NO   
   AND D.SETT_TYPE = #PAYIN.SETT_TYPE  
   AND D.PARTY_CODE = #PAYIN.PARTY_CODE   
   AND D.SCRIP_CD = #PAYIN.SCRIP_CD   
   AND D.SERIES = #PAYIN.SERIES   
   AND #PAYIN.QTY < 0   
  
SELECT PARTY_CODE, COLLECT=SUM(PRADNYA.DBO.FNMIN(MTOM,COLLECT))+CONVERT(NUMERIC(18,2),SUM(ADNL_MARGIN)) INTO #MTMCOLLECT  
FROM (  
SELECT SETT_NO,SETT_TYPE,PARTY_CODE,MTOM=(CASE WHEN SUM(MTOM) < 0 THEN ABS(SUM(MTOM)) ELSE 0 END),  
COLLECT=SUM(CASE WHEN QTY < 0 AND MTOM < 0 THEN ABS(PAYQTY*(MTOM/ABS(QTY))) ELSE 0 END),  
ADNL_MARGIN = SUM(CASE WHEN QTY < 0 AND ADNL_MARGIN > 0 THEN ABS(PAYQTY*(ADNL_MARGIN/ABS(QTY))) ELSE 0 END)  
FROM #PAYIN   
GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE ) A  
GROUP BY PARTY_CODE  
*/

     SELECT *
     INTO #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK
     FROM V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK
     WHERE @MARGINDATE BETWEEN FROM_DATE AND TO_DATE;
     IF @CHECKFLAG = 0
         BEGIN
             DELETE FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
             WHERE MARGINDATE = @MARGINDATE;
             CREATE TABLE #MTFADJUST
             (PARTY_CODE         VARCHAR(10), 
              MARGIN_REQ         NUMERIC(18, 4), 
              MTOM_LOSS          NUMERIC(18, 4), 
              EXCESS_COLL        NUMERIC(18, 4), 
              TDAY_MARGIN_REQ    NUMERIC(18, 4), 
              CASH_MARGIN_ADJUST NUMERIC(18, 4)
             );
             SELECT MARGINDATE, 
                    EXCHANGE, 
                    SEGMENT, 
                    PARTY_CODE, 
                    TDAY_MARGIN, 
                    FILECOUNTER = 0, 
                    PEAK_EOD = CONVERT(NUMERIC(18, 4), 0), 
                    DEBITBILL = CONVERT(NUMERIC(18, 4), 0), 
                    LEDBAL = CONVERT(NUMERIC(18, 4), 0)
             INTO #PEAKSNAPSHOT
             FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
             WHERE 1 = 2;
             SELECT MARGINDATE, 
                    EXCHANGE, 
                    SEGMENT, 
                    PARTY_CODE, 
                    TDAY_MARGIN, 
                    FILECOUNTER = 0
             INTO #PEAKEOD
             FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
             WHERE 1 = 2;
             SET @MRGCUR = CURSOR
             FOR SELECT MARGSQL = ' INSERT INTO #PEAKSNAPSHOT (MARGINDATE, EXCHANGE, SEGMENT, PARTY_CODE, TDAY_MARGIN, FILECOUNTER )' + ' SELECT ''' + @MARGINDATE + ''',''' + T.EXCHANGE + ''', ''' + T.SEGMENT + ''',PARTY_CODE,MARGIN_CALL=SUM(ISNULL(' + (CASE
                                                                                                                                                                                                                                                                  WHEN @FORREPORTING = 'Y'
                                                                                                                                                                                                                                                                  THEN REPLACE(MARGINCOLUMNSNONCASH, 'ADDMARGIN', 0)
                                                                                                                                                                                                                                                                  ELSE MARGINCOLUMNSNONCASH
                                                                                                                                                                                                                                                              END) + ',0)),FILECOUNTER 
FROM ' + SHARESERVER + '.' + SHAREDB + '.DBO.' + MARGINTABLE + ' WHERE ' + MARGINDATEFIELD + ' = (SELECT MAX(' + MARGINDATEFIELD + ') FROM ' + SHARESERVER + '.' + SHAREDB + '.DBO.' + MARGINTABLE + ' WHERE ' + MARGINDATEFIELD + ' <= ''' + @MARGINDATE + ' 23:59'') GROUP BY PARTY_CODE, FILECOUNTER'
                 FROM V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK_INTRADAY T, 
                      PRADNYA..MULTICOMPANY M
                 WHERE T.EXCHANGE = M.EXCHANGE
                       AND T.SEGMENT = M.SEGMENT
                       AND M.SHARESERVER <> 'ANGELDEMAT'
                       AND T.SEGMENT <> 'POA'
                       AND @MARGINDATE BETWEEN FROM_DATE AND TO_DATE;
             OPEN @MRGCUR;
             FETCH NEXT FROM @MRGCUR INTO @STRSQL;
             WHILE @@FETCH_STATUS = 0
                 BEGIN
                     EXEC (@STRSQL);          
                     --PRINT @STRSQL  
                     FETCH NEXT FROM @MRGCUR INTO @STRSQL;
     END;
             CLOSE @MRGCUR;
             DEALLOCATE @MRGCUR;
             SET @MRGCUR = CURSOR
             FOR SELECT MARGSQL = ' INSERT INTO #PEAKEOD (MARGINDATE, EXCHANGE, SEGMENT, PARTY_CODE, TDAY_MARGIN, FILECOUNTER )' + ' SELECT ''' + @MARGINDATE + ''',''' + T.EXCHANGE + ''', ''' + T.SEGMENT + ''',PARTY_CODE,MARGIN_CALL=SUM(ISNULL(' + (CASE
                                                                                                                                                                                                                                                             WHEN @FORREPORTING = 'Y'
                                                                                                                                                                                                                                                             THEN REPLACE(MARGINCOLUMNSNONCASH, 'ADDMARGIN', 0)
                                                                                                                                                                                                                                                             ELSE MARGINCOLUMNSNONCASH
                                                                                                                                                                                                                                                         END) + ',0)),FILECOUNTER=
0 FROM ' + SHARESERVER + '.' + SHAREDB + '.DBO.' + MARGINTABLE + ' WHERE ' + MARGINDATEFIELD + ' = (SELECT MAX(' + MARGINDATEFIELD + ') FROM ' + SHARESERVER + '.' + SHAREDB + '.DBO.' + MARGINTABLE + ' WHERE ' + MARGINDATEFIELD + ' <= ''' + @MARGINDATE + ' 23:59'') GROUP BY PARTY_CODE'
                 FROM V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK T, 
                      PRADNYA..MULTICOMPANY M
                 WHERE T.EXCHANGE = M.EXCHANGE
                       AND T.SEGMENT = M.SEGMENT
                       AND M.SHARESERVER <> 'ANGELDEMAT'
                       AND T.SEGMENT <> 'POA'
                       AND MARGINCOLUMNSNONCASH = 'peakmargin'
                       AND @margindate BETWEEN FROM_DATE AND TO_DATE;
             OPEN @MRGCUR;
             FETCH NEXT FROM @MRGCUR INTO @STRSQL;
             WHILE @@FETCH_STATUS = 0
                 BEGIN
                     EXEC (@STRSQL);          
                     --PRINT @STRSQL  
                     FETCH NEXT FROM @MRGCUR INTO @STRSQL;
     END;
             CLOSE @MRGCUR;
             DEALLOCATE @MRGCUR;
             SET @MRGCUR = CURSOR
             FOR SELECT MARGSQL = ' INSERT INTO #PEAKSNAPSHOT (MARGINDATE, EXCHANGE, SEGMENT, PARTY_CODE, TDAY_MARGIN, FILECOUNTER )' + ' SELECT ''' + @MARGINDATE + ''',''' + T.EXCHANGE + ''', ''' + T.SEGMENT + ''',PARTY_CODE,MARGIN_CALL=SUM(ISNULL(' + (CASE
                                                                                                                                                                                                                                                                  WHEN @FORREPORTING = 'Y'
                                                                                                                                                                                                                                                                  THEN REPLACE(MARGINCOLUMNSNONCASH, 'ADDMARGIN', 0)
                                                                                                                                                                                                                                                                  ELSE MARGINCOLUMNSNONCASH
                                                                                                                                                                                                                                                              END) + ',0)),FILECOUNTER=
5 FROM ' + SHARESERVER + '.' + SHAREDB + '.DBO.' + MARGINTABLE + ' WHERE ' + MARGINDATEFIELD + ' = (SELECT MAX(' + MARGINDATEFIELD + ') FROM ' + SHARESERVER + '.' + SHAREDB + '.DBO.' + MARGINTABLE + ' WHERE ' + MARGINDATEFIELD + ' <= ''' + @MARGINDATE + ' 23:59'') GROUP BY PARTY_CODE'
                 FROM V2_TBL_EXCHANGE_MARGIN_REPORT T, 
                      PRADNYA..MULTICOMPANY M
                 WHERE T.EXCHANGE = M.EXCHANGE
                       AND T.SEGMENT = M.SEGMENT
                       AND M.SHARESERVER <> 'ANGELDEMAT'
                       AND T.SEGMENT <> 'POA'             
                       --and MARGINCOLUMNSNONCASH = 'peakmargin'  
                       AND t.Exchange NOT IN('mcx', 'ncx');
             OPEN @MRGCUR;
             FETCH NEXT FROM @MRGCUR INTO @STRSQL;
             WHILE @@FETCH_STATUS = 0
                 BEGIN
                     EXEC (@STRSQL);          
                     --PRINT @STRSQL  
                     FETCH NEXT FROM @MRGCUR INTO @STRSQL;
     END;
             UPDATE #PEAKSNAPSHOT
               SET 
                   TDAY_MARGIN = TDAY_MARGIN * PEAK_PER / 100
             FROM V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK_INTRADAY P
             WHERE #PEAKSNAPSHOT.EXCHANGE = P.EXCHANGE
                   AND #PEAKSNAPSHOT.SEGMENT = P.SEGMENT
                   AND @MARGINDATE BETWEEN FROM_DATE AND TO_DATE;
             SELECT MARGINDATE, 
                    PARTY_CODE, 
                    TDAY_MARGIN = SUM(TDAY_MARGIN), 
                    FILECOUNTER
             INTO #MAXPEAK
             FROM #PEAKSNAPSHOT
             WHERE FILECOUNTER <= 4
             GROUP BY MARGINDATE, 
                      PARTY_CODE, 
                      FILECOUNTER;
             UPDATE #PEAKEOD
               SET 
                   TDAY_MARGIN = TDAY_MARGIN * PEAK_PER / 100
             FROM V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK P
             WHERE #PEAKEOD.EXCHANGE = P.EXCHANGE
                   AND #PEAKEOD.SEGMENT = P.SEGMENT
                   AND @MARGINDATE BETWEEN FROM_DATE AND TO_DATE;
             UPDATE #PEAKSNAPSHOT
               SET 
                   PEAK_EOD = 0;
             UPDATE #PEAKSNAPSHOT
               SET 
                   PEAK_EOD = P.TDAY_MARGIN
             FROM #PEAKEOD P
             WHERE P.PARTY_CODE = #PEAKSNAPSHOT.PARTY_CODE
                   AND #PEAKSNAPSHOT.FILECOUNTER = 1
                   AND P.EXCHANGE = 'NSE'
                   AND P.SEGMENT = 'CAPITAL';
             SELECT cltcode, 
                    vamt = SUM(vamt)
             INTO #dbill
             FROM account.dbo.ledger l(NOLOCK), 
                  #PEAKSNAPSHOT p
             WHERE edt LIKE @margindate + '%'
                   AND vtyp = 15
                   AND drcr = 'D'
                   AND p.party_code = l.cltcode
                   AND P.EXCHANGE = 'NSE'
                   AND P.SEGMENT = 'CAPITAL'
                   AND PEAK_EOD = P.TDAY_MARGIN
                   AND TDAY_MARGIN > 0
             GROUP BY cltcode;
             UPDATE #PEAKSNAPSHOT
               SET 
                   DEBItBILL = 0, 
                   LEDBAL = 0;
             UPDATE #PEAKSNAPSHOT
               SET 
                   DEBItBILL = vAMT
             FROM #dbill
             WHERE #dbill.cltcode = party_code;
             SELECT EXCHANGE, 
                    SEGMENT, 
                    FILECOUNTER = MAX(FILECOUNTER)
             INTO #PEAKSEGMENT
             FROM #PEAKSNAPSHOT
             WHERE EXCHANGE NOT IN('MCX', 'NCX')
             GROUP BY EXCHANGE, 
                      SEGMENT;
             DELETE FROM #PEAKSNAPSHOT
             WHERE FILECOUNTER >= 5
                   AND PARTY_CODE NOT IN
             (
                 SELECT PARTY_CODE
                 FROM #PEAKSNAPSHOT
                 WHERE FILECOUNTER > 4
                       AND EXCHANGE IN('MCX', 'NCX')
             );
             DECLARE @FILECNT INT, @FILECUR CURSOR;
             SET @FILECUR = CURSOR
             FOR SELECT DISTINCT 
                        FILECOUNTER
                 FROM #PEAKSNAPSHOT
                 WHERE FILECOUNTER > 4
                       AND EXCHANGE IN('MCX', 'NCX')
                 ORDER BY 1;
             OPEN @FILECUR;
             FETCH NEXT FROM @FILECUR INTO @FILECNT;
             WHILE @@FETCH_STATUS = 0
                 BEGIN
                     INSERT INTO #PEAKSEGMENT
                            SELECT 'MCX', 
                                   'FUTURES', 
                                   @FILECNT;
                     INSERT INTO #PEAKSEGMENT
                            SELECT 'NCX', 
                                   'FUTURES', 
                                   @FILECNT;
                     INSERT INTO #MAXPEAK
                            SELECT MARGINDATE, 
                                   PARTY_CODE, 
                                   TDAY_MARGIN = SUM(TDAY_MARGIN), 
                                   FILECOUNTER = @FILECNT
                            FROM #PEAKSNAPSHOT P, 
                                 #PEAKSEGMENT P1
                            WHERE P.EXCHANGE = P1.EXCHANGE
                                  AND P.SEGMENT = P1.SEGMENT
                                  AND P.FILECOUNTER = P1.FILECOUNTER
                            GROUP BY MARGINDATE, 
                                     PARTY_CODE;
                     DELETE FROM #PEAKSEGMENT
                     WHERE EXCHANGE IN('MCX', 'NCX');
                     FETCH NEXT FROM @FILECUR INTO @FILECNT;
     END;
             CLOSE @FILECUR;
             DEALLOCATE @FILECUR;
             SELECT MARGINDATE, 
                    PARTY_CODE, 
                    TDAY_MARGIN = MAX(TDAY_MARGIN), 
                    EOD_PEAK = CONVERT(NUMERIC(18, 4), 0)
             INTO #PEAK
             FROM
             (
                 SELECT MARGINDATE, 
                        PARTY_CODE, 
                        TDAY_MARGIN = SUM(TDAY_MARGIN), 
                        FILECOUNTER
                 FROM #MAXPEAK
                 GROUP BY MARGINDATE, 
                          PARTY_CODE, 
                          FILECOUNTER
             ) A
             GROUP BY MARGINDATE, 
                      PARTY_CODE;

/*  
  SELECT * FROM #MAXPEAK  
  WHERE PARTY_CODE='D51560'  
  SELECT * FROM #PEAKSNAPSHOT  
  WHERE PARTY_CODE='D51560'  
  SELECT * FROM #PEAKEOD  
  WHERE PARTY_CODE='D51560'  
  
  
  RETURN */

             CREATE INDEX #PK ON #PEAK
             (PARTY_cODE
             );
             SET @CNT = 1;
             SET @DAY = 1;
             IF CONVERT(DATETIME, @MARGINDATE) <= CONVERT(DATETIME, 'SEP 16 2020')
                 BEGIN
                     INSERT INTO #MTFADJUST
                     EXEC MTFTRADE.DBO.TO_CHK_2DAY 
                          @MARGINDATE, 
                          1;
             END;
             SET @MARGINDATECURSOR = CURSOR
             FOR

/*   
 SELECT DISTINCT TOP 3 SYSDATE FROM MSAJAG.DBO.CLOSING     
 WHERE SYSDATE >= @MARGINDATE     
 ORDER BY SYSDATE    
  
  */

                 --/*      

                 SELECT TOP 1 START_DATE
                 FROM
                 (
                     SELECT DISTINCT 
                            Start_Date
                     FROM AccBill
                     WHERE Start_Date >= @MARGINDATE
                           AND SETT_TYPE = 'N'
                 ) A
                 ORDER BY 1;

             --*/      

/*    
SELECT DISTINCT TOP 3 START_DATE SYSDATE FROM MSAJAG.DBO.SETT_MST       
 --WHERE START_DATE >= @MARGINDATE  AND SETT_TYPE ='N'    
 --ORDER BY START_DATE     
 */

             OPEN @MARGINDATECURSOR;
             FETCH NEXT FROM @MARGINDATECURSOR INTO @MARGINDATENEW;
             WHILE @@FETCH_STATUS = 0
                 BEGIN
                     SET @EXCHANGEWISE_CURSOR = CURSOR
                     FOR SELECT DISTINCT 
                                EXCHANGE = MAX(M.EXCHANGE), 
                                SEGMENT = MAX(M.SEGMENT), 
                                SHARESERVER, 
                                ACCOUNTDB, 
                                ACCOUNTSERVER
                         FROM PRADNYA..MULTICOMPANY M(NOLOCK)
                         WHERE M.SEGMENT NOT IN('SLBS')
                         AND SHARESERVER <> 'ANGELDEMAT'
                         AND SEGMENT_DESCRIPTION NOT LIKE '%PCM%'
                         AND PRIMARYSERVER = 1
                         AND EXISTS
                         (
                             SELECT T.EXCHANGE
                             FROM #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK T
                             WHERE T.EXCHANGE = M.EXCHANGE
                                   AND T.SEGMENT = M.SEGMENT
                                   AND @MARGINDATE BETWEEN FROM_DATE AND TO_DATE
                         )
                         GROUP BY SHARESERVER, 
                                  ACCOUNTDB, 
                                  ACCOUNTSERVER;
                     OPEN @EXCHANGEWISE_CURSOR;
                     FETCH NEXT FROM @EXCHANGEWISE_CURSOR INTO @EXCHANGE_NEW, @SEGMENT_NEW, @SHARESERVER, @ACCOUNTDB, @ACCOUNTSERVER;
                     WHILE @@FETCH_STATUS = 0
                         BEGIN
                             SET @STRSQL = '';
                             IF @ACCOUNTSERVER = 'ANAND1'
                                 BEGIN
                                     SET @ACCOUNTSERVER = '';
                             END;
                                 ELSE
                                 BEGIN
                                     SET @ACCOUNTSERVER = @ACCOUNTSERVER + '.';
                             END;
                             SET @STRSQL = 'EXEC ' + @ACCOUNTSERVER + @ACCOUNTDB + '.DBO.PR_GET_LEDBAL_COMBINE ''' + @MARGINDATENEW + ''' ';
                             EXEC (@STRSQL);
                             IF @CNT = 1
                                 BEGIN
                                     SET @STRSQL = ' INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL (MARGINDATE, EXCHANGE, SEGMENT, PARTY_CODE, TDAY_LEDGER )';
                                     SET @STRSQL = @STRSQL + ' SELECT ''' + @MARGINDATE + ''', ''' + @EXCHANGE_NEW + ''', ''' + @SEGMENT_NEW + ''', PARTY_CODE, LEDBAL ';
                                     SET @STRSQL = @STRSQL + ' FROM ' + @ACCOUNTSERVER + @ACCOUNTDB + '.DBO.FOMARGINNEW_LEDGERBAL WHERE MARGINDATE = ''' + @MARGINDATENEW + ''' ';
                                     EXEC (@STRSQL);
                             END;
                             IF @CNT = 2
                                 BEGIN
                                     SET @STRSQL = ' INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL (MARGINDATE, EXCHANGE, SEGMENT, PARTY_CODE, T1DAY_LEDGER )';
                                     SET @STRSQL = @STRSQL + ' SELECT ''' + @MARGINDATE + ''', ''' + @EXCHANGE_NEW + ''', ''' + @SEGMENT_NEW + ''', PARTY_CODE, LEDBAL ';
                                     SET @STRSQL = @STRSQL + ' FROM ' + @ACCOUNTSERVER + @ACCOUNTDB + '.DBO.FOMARGINNEW_LEDGERBAL WHERE MARGINDATE = ''' + @MARGINDATENEW + ''' ';
                                     EXEC (@STRSQL);
                             END;
                             IF @CNT = 3
                                 BEGIN
                                     SET @STRSQL = ' INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL (MARGINDATE, EXCHANGE, SEGMENT, PARTY_CODE, T2DAY_LEDGER )';
                                     SET @STRSQL = @STRSQL + ' SELECT ''' + @MARGINDATE + ''', ''' + @EXCHANGE_NEW + ''', ''' + @SEGMENT_NEW + ''', PARTY_CODE, LEDBAL ';
                                     SET @STRSQL = @STRSQL + ' FROM ' + @ACCOUNTSERVER + @ACCOUNTDB + '.DBO.FOMARGINNEW_LEDGERBAL WHERE MARGINDATE = ''' + @MARGINDATENEW + ''' ';
                                     EXEC (@STRSQL);
                             END;
                             FETCH NEXT FROM @EXCHANGEWISE_CURSOR INTO @EXCHANGE_NEW, @SEGMENT_NEW, @SHARESERVER, @ACCOUNTDB, @ACCOUNTSERVER;
     END;
                     CLOSE @EXCHANGEWISE_CURSOR;
                     UPDATE #PEAKSNAPSHOT
                       SET 
                           LEDBAL = TDAY_LEDGER
                     FROM
                     (
                         SELECT PARTY_CODE, 
                                TDAY_LEDGER = SUM(ISNULL(TDAY_LEDGER, 0))
                         FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL T
                         WHERE T.MARGINDATE = @MARGINDATE   --   
                               AND TDAY_LEDGER IS NOT NULL
                         GROUP BY PARTY_CODE
                     ) A
                     WHERE #PEAKSNAPSHOT.PARTY_CODE = A.PARTY_CODE
                           AND EXCHANGE = 'NSE'
                           AND SEGMENT = 'CAPITAL';
                     INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                     (MARGINDATE, 
                      EXCHANGE, 
                      SEGMENT, 
                      PARTY_CODE, 
                      TDAY_LEDGER
                     )
                            SELECT @MARGINDATE, 
                                   EXCHANGE, 
                                   SEGMENT, 
                                   PARTY_CODE, 
                                   TDAY_LEDGER = (CASE
                                                      WHEN LEDBAL < 0
                                                      THEN PRADNYA.DBO.FNMIN(DEBITBILL, ABS(LEDBAL))
                                                      ELSE 0
                                                  END) + PRADNYA.DBO.FNMIN(DEBITBILL, TDAY_MARGIN)
                            FROM #PEAKSNAPSHOT
                            WHERE TDAY_MARGIN = PEAK_EOD
                                  AND TDAY_MARGIN > 0
                                  AND EXCHANGE = 'NSE'
                                  AND SEGMENT = 'CAPITAL'
                                  AND FILECOUNTER = 1;
                     IF @DAY = 1
                         BEGIN
                             INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                             (MARGINDATE, 
                              EXCHANGE, 
                              SEGMENT, 
                              PARTY_CODE, 
                              TDAY_CASHCOLL, 
                              TDAY_FDBG, 
                              TDAY_NONCASH
                             )
                                    SELECT MARGINDATE = @MARGINDATE, 
                                           EXCHANGE, 
                                           SEGMENT, 
                                           PARTY_CODE, 
                                           TDAY_CASHCOLL = ISNULL(SUM(CASE
                                                                          WHEN COLL_TYPE = 'MARGIN'
                                                                          THEN ISNULL(MRG_FINALAMOUNT, 0)
                                                                          ELSE 0
                                                                      END), 0), 
                                           TDAY_FDBG = ISNULL(SUM(CASE
                                                                      WHEN COLL_TYPE = 'BG'
                                                                           OR COLL_TYPE = 'FD'
                                                                      THEN ISNULL(MRG_FINALAMOUNT, 0)
                                                                      ELSE 0
                                                                  END), 0), 
                                           TDAY_NONCASH = ISNULL(SUM(CASE
                                                                         WHEN COLL_TYPE = 'SEC'
                                                                         THEN ISNULL(MRG_FINALAMOUNT, 0)
                                                                         ELSE 0
                                                                     END), 0)
                                    FROM V2_TBL_COLLATERAL_MARGIN_COMBINE M
                                    WHERE EFFDATE = @MARGINDATENEW
                                          AND EXISTS
                                    (
                                        SELECT T.EXCHANGE
                                        FROM #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK T
                                        WHERE T.EXCHANGE = M.EXCHANGE
                                              AND T.SEGMENT = M.SEGMENT
                                              AND @MARGINDATE BETWEEN FROM_DATE AND TO_DATE
                                    )
                                    GROUP BY EXCHANGE, 
                                             SEGMENT, 
                                             PARTY_CODE;
                             SELECT TRANSDATE, 
                                    PARTY_CODE, 
                                    MARGIN_BENEFIT = SUM(ROUND(MARGIN_BENEFIT, 2)), 
                                    CASHBENEFIT = SUM(CASHBENEFIT)
                             INTO #EPNPOOL_P
                             FROM TBL_EPN_BENEFIT
                             WHERE TRANSDATE = @MARGINDATENEW
                                   AND MARGIN_BENEFIT + CASHBENEFIT > 0
                             GROUP BY TRANSDATE, 
                                      PARTY_CODE;
                             INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                             (MARGINDATE, 
                              EXCHANGE, 
                              SEGMENT, 
                              PARTY_CODE, 
                              TDAY_NONCASH, 
                              TDAY_CASHCOLL
                             )
                                    SELECT TRANSDATE, 
                                           EXCHANGE = 'EPN', 
                                           SEGMENT = 'EPN', 
                                           PARTY_CODE, 
                                           TDAY_NONCASH = 0, 
                                           CASHBENEFIT = SUM(CASHBENEFIT + MARGIN_BENEFIT)
                                    FROM #EPNPOOL_P
                                    GROUP BY TRANSDATE, 
                                             PARTY_CODE;
                             SELECT @PREVDATE = MAX(TRANSDATE)
                             FROM TBL_EPN_BENEFIT
                             WHERE TRANSDATE < @MARGINDATE;

/*  
 SELECT @PREVDATE = MAX(TRANSDATE) FROM TBL_EPN_BENEFIT  
 WHERE TRANSDATE < @MARGINDATE */

                             SELECT PARTY_CODE, 
                                    CASHBENEFIT = SUM(CASHBENEFIT) * 20 / 100 - (SUM(CASHBENEFIT) * 20 / 100) * PEAK_PER / 100, 
                                    MARGIN_BENEFIT = SUM(MARGIN_BENEFIT), 
                                    TDAY_PEAK = CONVERT(NUMERIC(18, 4), 0)
                             INTO #EPNREV_P
                             FROM
                             (
                                 SELECT PARTY_CODE, 
                                        CASHBENEFIT = -SUM(CASHBENEFIT), 
                                        MARGIN_BENEFIT = CONVERT(NUMERIC(18, 4), 0)
                                 FROM TBL_EPN_BENEFIT T
                                 WHERE TRANSDATE = @PREVDATE
                                       AND SETT_NO IN
                                 (
                                     SELECT SETT_NO
                                     FROM TBL_EPN_BENEFIT T1
                                     WHERE TRANSDATE = @MARGINDATE
                                           AND T.SETT_NO = T1.SETT_NO
                                           AND T.SETT_TYPE = T1.SETT_TYPE
                                 )
                                 GROUP BY PARTY_CODE
                                 UNION ALL
                                 SELECT PARTY_CODE, 
                                        CASHBENEFIT = SUM(CASHBENEFIT), 
                                        MARGIN_BENEFIT = SUM(MARGIN_BENEFIT)
                                 FROM TBL_EPN_BENEFIT T
                                 WHERE TRANSDATE = @MARGINDATE
                                 GROUP BY PARTY_CODE
                             ) A, 
                             #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK P
                             WHERE P.EXCHANGE = 'NSE'
                                   AND P.SEGMENT = 'CAPITAL'
                             GROUP BY PARTY_CODE, 
                                      PEAK_PER
                             HAVING SUM(CASHBENEFIT + MARGIN_BENEFIT) > 0;
                             UPDATE #EPNREV_P
                               SET 
                                   CASHBENEFIT = CASHBENEFIT + MARGIN_BENEFIT;
                             UPDATE #EPNREV_P
                               SET 
                                   TDAY_PEAK = PEAKMARGIN
                             FROM TBL_CMMARGIN C
                             WHERE MARGINDATE = @MARGINDATE
                                   AND #EPNREV_P.PARTY_CODE = C.PARTY_CODE;
                             UPDATE #EPNREV_P
                               SET 
                                   TDAY_PEAK = TDAY_PEAK * PEAK_PER / 100
                             FROM #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK p
                             WHERE P.EXCHANGE = 'NSE'
                                   AND P.SEGMENT = 'CAPITAL';

/*  
 INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL (MARGINDATE, EXCHANGE, SEGMENT, PARTY_CODE, TDAY_NONCASH, TDAY_CASHCOLL)  
 SELECT @MARGINDATE, EXCHANGE = 'EPN', SEGMENT = 'EPN', PARTY_CODE, TDAY_NONCASH = 0, CASHBENEFIT = -SUM(CASHBENEFIT)  
 FROM #EPNREV_P  
 GROUP BY PARTY_CODE  
 */

                             IF CONVERT(DATETIME, @MARGINDATE) < CONVERT(DATETIME, 'SEP 16 2020')
                                 BEGIN
                                     IF CONVERT(DATETIME, @MARGINDATE) >= CONVERT(DATETIME, 'JUL 28 2020')
                                         BEGIN
                                             INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                             (MARGINDATE, 
                                              EXCHANGE, 
                                              SEGMENT, 
                                              PARTY_CODE, 
                                              TDAY_CASHCOLL, 
                                              TDAY_FDBG, 
                                              TDAY_NONCASH
                                             )
                                                    SELECT MARGINDATE = @MARGINDATE, 
                                                           EXCHANGE = 'NSE', 
                                                           SEGMENT = 'CAPITAL', 
                                                           PARTY_CODE, 
                                                           TDAY_CASHCOLL = 0, 
                                                           TDAY_FDBG = 0, 
                                                           TDAY_NONCASH = CASH_MARGIN_ADJUST
                                                    FROM #MTFADJUST
                                                    WHERE CASH_MARGIN_ADJUST > 0;
                                     END;
                                     IF CONVERT(DATETIME, @MARGINDATE) >= CONVERT(DATETIME, 'MAY 27 2020')
                                         BEGIN
                                             INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                             (MARGINDATE, 
                                              EXCHANGE, 
                                              SEGMENT, 
                                              PARTY_CODE, 
                                              TDAY_CASHCOLL, 
                                              TDAY_FDBG, 
                                              TDAY_NONCASH
                                             )
                                                    SELECT MARGINDATE = @MARGINDATE, 
                                                           EXCHANGE = 'MTF', 
                                                           SEGMENT = 'MTF', 
                                                           PARTY_CODE, 
                                                           TDAY_CASHCOLL = 0, 
                                                           TDAY_FDBG = 0, 
                                                           TDAY_NONCASH = (SUM(NETAMT - MTOM_LOSS - MARGIN_REQ) + (MTFLEDBAL + MTFCASHCOLLATERAL + MTFNONCASHCOLLATERAL + MTFCASHEQCOLLATERAL))
                                                    FROM MTFTRADE.DBO.TBL_MTF_DATA
                                                    WHERE SAUDA_DATE BETWEEN @MARGINDATENEW AND @MARGINDATENEW + ' 23:59'    
                                                    --WHERE SAUDA_DATE BETWEEN 'MAY 26 2020' AND 'MAY 26 2020' + ' 23:59'    
                                                    GROUP BY SAUDA_DATE, 
                                                             PARTY_CODE, 
                                                             MTFLEDBAL, 
                                                             MTFCASHCOLLATERAL, 
                                                             MTFNONCASHCOLLATERAL, 
                                                             MTFCASHEQCOLLATERAL, 
                                                             CASHDEBITADJ, 
                                                             CASHNONCASHADJ, 
                                                             FONONCASHADJ, 
                                                             CASHLEDADJ, 
                                                             FOLEDBALADJ, 
                                                             POAADJ
                                                    HAVING(SUM(NETAMT - MTOM_LOSS - MARGIN_REQ) + (MTFLEDBAL + MTFCASHCOLLATERAL + MTFNONCASHCOLLATERAL + MTFCASHEQCOLLATERAL)) > 1;
                                             SELECT DISTINCT 
                                                    PARTY_CODE
                                             INTO #MTFTDAY
                                             FROM MTFTRADE.DBO.TBL_MTF_DATA
                                             WHERE SAUDA_DATE = @MARGINDATENEW;
                                             SELECT *
                                             INTO #MTFCOLLTDAY
                                             FROM MTFTRADE.DBO.TBL_PRODUCT_HOLD_DATA H
                                             WHERE SAUDA_DATE = @MARGINDATENEW
                                                   AND HOLDFLAG = 'MTFCOLL';
                                             SELECT PARTY_CODE, 
                                                    NONCASHCOLL = SUM(QTY * CL_RATE - QTY * CL_RATE * HAIRCUT / 100)
                                             INTO #EX_MTFTDAY
                                             FROM #MTFCOLLTDAY H
                                             WHERE SAUDA_DATE = @MARGINDATENEW
                                                   AND HOLDFLAG = 'MTFCOLL'
                                                   AND NOT EXISTS
                                             (
                                                 SELECT PARTY_CODE
                                                 FROM #MTFTDAY M
                                                 WHERE M.PARTY_CODE = H.PARTY_CODE
                                             )
                                             GROUP BY PARTY_CODE;
                                             INSERT INTO #EX_MTFTDAY
                                                    SELECT CLTCODE, 
                                                           NONCASHCOLL = SUM(CASE
                                                                                 WHEN DRCR = 'C'
                                                                                 THEN VAMT
                                                                                 ELSE-VAMT
                                                                             END)
                                                    FROM MTFTRADE.DBO.TblClientMargin T, 
                                                         MTFTRADE.DBO.LEDGER L, 
                                                         MTFTRADE.DBO.parameter P
                                                    WHERE T.Party_Code = L.CLTCODE   
                                                          --AND VDT BETWEEN sdtcur  AND ldtcur  
                                                          AND VDT BETWEEN sdtcur AND @MARGINDATENEW + ' 23:59'
                                                          AND @MARGINDATENEW BETWEEN sdtcur AND ldtcur
                                                          AND NOT EXISTS
                                                    (
                                                        SELECT PARTY_CODE
                                                        FROM #MTFTDAY M
                                                        WHERE M.PARTY_CODE = T.PARTY_CODE
                                                    )
                                                    GROUP BY CLTCODE
                                                    HAVING SUM(CASE
                                                                   WHEN DRCR = 'C'
                                                                   THEN VAMT
                                                                   ELSE-VAMT
                                                               END) <> 0;
                                             INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                             (MARGINDATE, 
                                              EXCHANGE, 
                                              SEGMENT, 
                                              PARTY_CODE, 
                                              TDAY_CASHCOLL, 
                                              TDAY_FDBG, 
                                              TDAY_NONCASH
                                             )
                                                    SELECT MARGINDATE = @MARGINDATE, 
                                                           EXCHANGE = 'MTF', 
                                                           SEGMENT = 'MTF', 
                                                           PARTY_CODE, 
                                                           TDAY_CASHCOLL = 0, 
                                                           TDAY_FDBG = 0, 
                                                           TDAY_NONCASH = SUM(NONCASHCOLL)
                                                    FROM #EX_MTFTDAY
                                                    GROUP BY PARTY_CODE
                                                    HAVING SUM(NONCASHCOLL) > 1;
                                     END;
                             END;
                             SET @MRGCUR = CURSOR
                             FOR SELECT MARGSQL = ' INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL (MARGINDATE, EXCHANGE, SEGMENT, PARTY_CODE, TDAY_MARGIN, TDAY_MTM )' + ' SELECT ''' + @MARGINDATE + ''',''' + T.EXCHANGE + ''', ''' + T.SEGMENT + ''',PARTY_CODE,MARGIN_CALL=SUM(ISNULL(' + (CASE
                                                                                                                                                                                                                                                                                                        WHEN @FORREPORTING = 'Y'
                                                                                                                                                                                                                                                                                                        THEN REPLACE(MARGINCOLUMNSNONCASH, 'ADDMARGIN', 0)
                                                                                                                                                                                                                                                                                                        ELSE MARGINCOLUMNSNONCASH
                                                                                                                                                                                                                                                                                                    END) + ',0)),MTM_CALL=S
UM(ISNULL(' + MARGINCOLUMNSCASH + ',0)) FROM ' + SHARESERVER + '.' + SHAREDB + '.DBO.' + MARGINTABLE + ' WHERE ' + MARGINDATEFIELD + ' = (SELECT MAX(' + MARGINDATEFIELD + ') FROM ' + SHARESERVER + '.' + SHAREDB + '.DBO.' + MARGINTABLE + ' WHERE ' + MARGINDATEFIELD + ' <= ''' + @MARGINDATENEW + ' 23:59'') GROUP BY PARTY_CODE'
                                 FROM #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK T, 
                                      PRADNYA..MULTICOMPANY M
                                 WHERE T.EXCHANGE = M.EXCHANGE
                                       AND T.SEGMENT = M.SEGMENT
                                       AND M.ShareServer <> 'ANGELDEMAT'

                                       --AND T.SEGMENT <> 'CAPITAL'     

                                       AND T.SEGMENT <> 'POA'
                                       AND @MARGINDATE BETWEEN FROM_DATE AND TO_DATE;
                             OPEN @MRGCUR;
                             FETCH NEXT FROM @MRGCUR INTO @STRSQL;
                             WHILE @@FETCH_STATUS = 0
                                 BEGIN
                                     EXEC (@STRSQL);
                                     FETCH NEXT FROM @MRGCUR INTO @STRSQL;
                     END;
                             CLOSE @MRGCUR;
                             DEALLOCATE @MRGCUR;
                     END;
                     IF @DAY = 2
                         BEGIN
                             INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                             (MARGINDATE, 
                              EXCHANGE, 
                              SEGMENT, 
                              PARTY_CODE, 
                              T1DAY_CASHCOLL, 
                              T1DAY_FDBG, 
                              T1DAY_NONCASH
                             )
                                    SELECT MARGINDATE = @MARGINDATE, 
                                           EXCHANGE, 
                                           SEGMENT, 
                                           PARTY_CODE, 
                                           T1DAY_CASHCOLL = SUM(CASE
                                                                    WHEN COLL_TYPE = 'MARGIN'
                                                                    THEN MRG_FINALAMOUNT
                                                                    ELSE 0
                                                                END), 
                                           T1DAY_FDBG = SUM(CASE
                                                                WHEN COLL_TYPE = 'BG'
                                                                     OR COLL_TYPE = 'FD'
                                                                THEN MRG_FINALAMOUNT
                                                                ELSE 0
                                                            END), 
                                           T1DAY_NONCASH = SUM(CASE
                                                                   WHEN COLL_TYPE = 'SEC'
                                                                   THEN MRG_FINALAMOUNT
                                                                   ELSE 0
                                                               END)
                                    FROM V2_TBL_COLLATERAL_MARGIN_COMBINE M
                                    WHERE EFFDATE = @MARGINDATENEW
                                          AND EXISTS
                                    (
                                        SELECT T.EXCHANGE
                                        FROM #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK T
                                        WHERE T.EXCHANGE = M.EXCHANGE
                                              AND T.SEGMENT = M.SEGMENT
                                    )
                                    GROUP BY EXCHANGE, 
                                             SEGMENT, 
                                             PARTY_CODE;
                             INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                             (MARGINDATE, 
                              EXCHANGE, 
                              SEGMENT, 
                              PARTY_CODE, 
                              T1DAY_CASHCOLL
                             )
                                    SELECT TRANSDATE, 
                                           EXCHANGE = 'EPN', 
                                           SEGMENT = 'EPN', 
                                           PARTY_CODE, 
                                           CASHBENEFIT = SUM(CASHBENEFIT)
                                    FROM TBL_EPN_BENEFIT
                                    WHERE TRANSDATE = @MARGINDATENEW
                                          AND CASHBENEFIT > 0
                                    GROUP BY TRANSDATE, 
                                             PARTY_CODE;
                             IF CONVERT(DATETIME, @MARGINDATE) >= CONVERT(DATETIME, 'MAY 27 2020')
                                AND CONVERT(DATETIME, @MARGINDATE) < CONVERT(DATETIME, 'SEP 16 2020')
                                 BEGIN
                                     INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                     (MARGINDATE, 
                                      EXCHANGE, 
                                      SEGMENT, 
                                      PARTY_CODE, 
                                      T1DAY_CASHCOLL, 
                                      T1DAY_FDBG, 
                                      T1DAY_NONCASH
                                     )
                                            SELECT MARGINDATE = @MARGINDATE, 
                                                   EXCHANGE = 'MTF', 
                                                   SEGMENT = 'MTF', 
                                                   PARTY_CODE, 
                                                   TDAY_CASHCOLL = 0, 
                                                   TDAY_FDBG = 0, 
                                                   TDAY_NONCASH = (SUM(NETAMT - MTOM_LOSS - MARGIN_REQ) + (MTFLEDBAL + MTFCASHCOLLATERAL + MTFNONCASHCOLLATERAL + MTFCASHEQCOLLATERAL))
                                            FROM MTFTRADE.DBO.TBL_MTF_DATA
                                            WHERE SAUDA_DATE BETWEEN @MARGINDATENEW AND @MARGINDATENEW + ' 23:59'    
                                            --WHERE SAUDA_DATE BETWEEN 'MAY 26 2020' AND 'MAY 26 2020' + ' 23:59'    
                                            GROUP BY SAUDA_DATE, 
                                                     PARTY_CODE, 
                                                     MTFLEDBAL, 
                                                     MTFCASHCOLLATERAL, 
                                                     MTFNONCASHCOLLATERAL, 
                                                     MTFCASHEQCOLLATERAL, 
                                                     CASHDEBITADJ, 
                                                     CASHNONCASHADJ, 
                                                     FONONCASHADJ, 
                                                     CASHLEDADJ, 
                                                     FOLEDBALADJ, 
                                                     POAADJ
                                            HAVING(SUM(NETAMT - MTOM_LOSS - MARGIN_REQ) + (MTFLEDBAL + MTFCASHCOLLATERAL + MTFNONCASHCOLLATERAL + MTFCASHEQCOLLATERAL)) > 1;
                                     SELECT DISTINCT 
                                            PARTY_CODE
                                     INTO #MTFT1DAY
                                     FROM MTFTRADE.DBO.TBL_MTF_DATA
                                     WHERE SAUDA_DATE = @MARGINDATENEW;
                                     SELECT *
                                     INTO #MTFCOLLT1DAY
                                     FROM MTFTRADE.DBO.TBL_PRODUCT_HOLD_DATA H
                                     WHERE SAUDA_DATE = @MARGINDATENEW
                                           AND HOLDFLAG = 'MTFCOLL';
                                     SELECT PARTY_CODE, 
                                            NONCASHCOLL = SUM(QTY * CL_RATE - QTY * CL_RATE * HAIRCUT / 100)
                                     INTO #EX_MTFT1DAY
                                     FROM #MTFCOLLT1DAY H
                                     WHERE SAUDA_DATE = @MARGINDATENEW
                                           AND HOLDFLAG = 'MTFCOLL'
                                           AND NOT EXISTS
                                     (
                                         SELECT PARTY_CODE
                                         FROM #MTFT1DAY M
                                         WHERE M.PARTY_CODE = H.PARTY_CODE
                                     )
                                     GROUP BY PARTY_CODE;
                                     INSERT INTO #EX_MTFT1DAY
                                            SELECT CLTCODE, 
                                                   NONCASHCOLL = SUM(CASE
                                                                         WHEN DRCR = 'C'
                                                                         THEN VAMT
                                                                         ELSE-VAMT
                                                                     END)
                                            FROM MTFTRADE.DBO.TblClientMargin T, 
                                                 MTFTRADE.DBO.LEDGER L, 
                                                 MTFTRADE.DBO.parameter P
                                            WHERE T.Party_Code = L.CLTCODE   
                                                  --AND VDT BETWEEN sdtcur  AND ldtcur  
                                                  AND VDT BETWEEN sdtcur AND @MARGINDATENEW + ' 23:59'
                                                  AND @MARGINDATENEW BETWEEN sdtcur AND ldtcur
                                                  AND NOT EXISTS
                                            (
                                                SELECT PARTY_CODE
                                                FROM #MTFT1DAY M
                                                WHERE M.PARTY_CODE = T.PARTY_CODE
                                            )
                                            GROUP BY CLTCODE
                                            HAVING SUM(CASE
                                                           WHEN DRCR = 'C'
                                                           THEN VAMT
                                                           ELSE-VAMT
                                                       END) <> 0;
                                     INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                     (MARGINDATE, 
                                      EXCHANGE, 
                                      SEGMENT, 
                                      PARTY_CODE, 
                                      T1DAY_CASHCOLL, 
                                      T1DAY_FDBG, 
                                      T1DAY_NONCASH
                                     )
                                            SELECT MARGINDATE = @MARGINDATE, 
                                                   EXCHANGE = 'MTF', 
                                                   SEGMENT = 'MTF', 
                                                   PARTY_CODE, 
                                                   TDAY_CASHCOLL = 0, 
                                                   TDAY_FDBG = 0, 
                                                   TDAY_NONCASH = SUM(NONCASHCOLL)
                                            FROM #EX_MTFT1DAY
                                            GROUP BY PARTY_CODE
                                            HAVING SUM(NONCASHCOLL) > 1;
                             END;
                             SET @MRGCUR = CURSOR
                             FOR SELECT MARGSQL = ' INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL (MARGINDATE, EXCHANGE, SEGMENT, PARTY_CODE, T1DAY_MARGIN, T1DAY_MTM )' + ' SELECT ''' + @MARGINDATE + ''',''' + T.EXCHANGE + ''', ''' + T.SEGMENT + ''',PARTY_CODE,MARGIN_CALL=SUM(' + MARGINCOLUMNSNONCASH + '),MTM_CALL=SUM(' + MARGINCOLUMNSCASH + ') FROM ' + SHARESERVER + '.' + SHAREDB + '.DBO.' + MARGINTABLE + ' WHERE ' + MARGINDATEFIELD + ' = (SELECT MAX(' + MARGINDATEFIELD + ') FROM ' + SHARESERVER + '.' + SHAREDB + '.DBO.' + MARGINTABLE + ' WHERE ' + MARGINDATEFIELD + ' <= ''' + @MARGINDATENEW + ' 23:59'') GROUP BY PARTY_CODE'
                                 FROM #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK T, 
                                      PRADNYA..MULTICOMPANY M
                                 WHERE T.EXCHANGE = M.EXCHANGE
                                       AND T.SEGMENT = M.SEGMENT
                                       AND M.ShareServer <> 'ANGELDEMAT'

                                       --- AND T.SEGMENT <> 'CAPITAL'     

                                       AND T.SEGMENT <> 'POA'
                                       AND @MARGINDATE BETWEEN FROM_DATE AND TO_DATE;
                             OPEN @MRGCUR;
                             FETCH NEXT FROM @MRGCUR INTO @STRSQL;
                             WHILE @@FETCH_STATUS = 0
                                 BEGIN
                                     EXEC (@STRSQL);
                                     FETCH NEXT FROM @MRGCUR INTO @STRSQL;
                     END;
                             CLOSE @MRGCUR;
                             DEALLOCATE @MRGCUR;
                     END;
                     IF @DAY = 3
                         BEGIN
                             INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                             (MARGINDATE, 
                              EXCHANGE, 
                              SEGMENT, 
                              PARTY_CODE, 
                              T2DAY_CASHCOLL, 
                              T2DAY_FDBG, 
                              T2DAY_NONCASH
                             )
                                    SELECT MARGINDATE = @MARGINDATE, 
                                           EXCHANGE, 
                                           SEGMENT, 
                                           PARTY_CODE, 
                                           T2DAY_CASHCOLL = SUM(CASE
                                                                    WHEN COLL_TYPE = 'MARGIN'
                                                                    THEN MRG_FINALAMOUNT
                                                                    ELSE 0
                                                                END), 
                                           T2DAY_FDBG = SUM(CASE
                                                                WHEN COLL_TYPE = 'BG'
                                                                     OR COLL_TYPE = 'FD'
                                                                THEN MRG_FINALAMOUNT
                                                                ELSE 0
                                                            END), 
                                           T2DAY_NONCASH = SUM(CASE
                                                                   WHEN COLL_TYPE = 'SEC'
                                                                   THEN MRG_FINALAMOUNT
                                                                   ELSE 0
                                                               END)
                                    FROM V2_TBL_COLLATERAL_MARGIN_COMBINE M
                                    WHERE EFFDATE = @MARGINDATENEW
                                          AND EXISTS
                                    (
                                        SELECT T.EXCHANGE
                                        FROM #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK T
                                        WHERE T.EXCHANGE = M.EXCHANGE
                                              AND T.SEGMENT = M.SEGMENT
                                    )
                                    GROUP BY EXCHANGE, 
                                             SEGMENT, 
                                             PARTY_CODE;
                             INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                             (MARGINDATE, 
                              EXCHANGE, 
                              SEGMENT, 
                              PARTY_CODE, 
                              T2DAY_CASHCOLL
                             )
                                    SELECT TRANSDATE, 
                                           EXCHANGE = 'EPN', 
                                           SEGMENT = 'EPN', 
                                           PARTY_CODE, 
                                           CASHBENEFIT = SUM(CASHBENEFIT)
                                    FROM TBL_EPN_BENEFIT
                                    WHERE TRANSDATE = @MARGINDATENEW
                                          AND CASHBENEFIT > 0
                                    GROUP BY TRANSDATE, 
                                             PARTY_CODE;
                             IF CONVERT(DATETIME, @MARGINDATE) >= CONVERT(DATETIME, 'MAY 27 2020')
                                AND CONVERT(DATETIME, @MARGINDATE) < CONVERT(DATETIME, 'SEP 16 2020')
                                 BEGIN
                                     INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                     (MARGINDATE, 
                                      EXCHANGE, 
                                      SEGMENT, 
                                      PARTY_CODE, 
                                      T2DAY_CASHCOLL, 
                                      T2DAY_FDBG, 
                                      T2DAY_NONCASH
                                     )
                                            SELECT MARGINDATE = @MARGINDATE, 
                                                   EXCHANGE = 'MTF', 
                                                   SEGMENT = 'MTF', 
                                                   PARTY_CODE, 
                                                   TDAY_CASHCOLL = 0, 
                                                   TDAY_FDBG = 0, 
                                                   TDAY_NONCASH = (SUM(NETAMT - MTOM_LOSS - MARGIN_REQ) + (MTFLEDBAL + MTFCASHCOLLATERAL + MTFNONCASHCOLLATERAL + MTFCASHEQCOLLATERAL))
                                            FROM MTFTRADE.DBO.TBL_MTF_DATA
                                            WHERE SAUDA_DATE BETWEEN @MARGINDATENEW AND @MARGINDATENEW + ' 23:59'    
                                            --WHERE SAUDA_DATE BETWEEN 'MAY 26 2020' AND 'MAY 26 2020' + ' 23:59'    
                                            GROUP BY SAUDA_DATE, 
                                                     PARTY_CODE, 
                                                     MTFLEDBAL, 
                                                     MTFCASHCOLLATERAL, 
                                                     MTFNONCASHCOLLATERAL, 
                                                     MTFCASHEQCOLLATERAL, 
                                                     CASHDEBITADJ, 
                                                     CASHNONCASHADJ, 
                                                     FONONCASHADJ, 
                                                     CASHLEDADJ, 
                                                     FOLEDBALADJ, 
                                                     POAADJ
                                            HAVING(SUM(NETAMT - MTOM_LOSS - MARGIN_REQ) + (MTFLEDBAL + MTFCASHCOLLATERAL + MTFNONCASHCOLLATERAL + MTFCASHEQCOLLATERAL)) > 1;
                                     SELECT DISTINCT 
                                            PARTY_CODE
                                     INTO #MTFT2DAY
                                     FROM MTFTRADE.DBO.TBL_MTF_DATA
                                     WHERE SAUDA_DATE = @MARGINDATENEW;
                                     SELECT *
                                     INTO #MTFCOLLT2DAY
                                     FROM MTFTRADE.DBO.TBL_PRODUCT_HOLD_DATA H
                                     WHERE SAUDA_DATE = @MARGINDATENEW
                                           AND HOLDFLAG = 'MTFCOLL';
                                     SELECT PARTY_CODE, 
                                            NONCASHCOLL = SUM(QTY * CL_RATE - QTY * CL_RATE * HAIRCUT / 100)
                                     INTO #EX_MTFT2DAY
                                     FROM #MTFCOLLT2DAY H
                                     WHERE SAUDA_DATE = @MARGINDATENEW
                                           AND HOLDFLAG = 'MTFCOLL'
                                           AND NOT EXISTS
                                     (
                                         SELECT PARTY_CODE
                                         FROM #MTFT2DAY M
                                         WHERE M.PARTY_CODE = H.PARTY_CODE
                                     )
                                     GROUP BY PARTY_CODE;
                                     INSERT INTO #EX_MTFT2DAY
                                            SELECT CLTCODE, 
                                                   NONCASHCOLL = SUM(CASE
                                                                         WHEN DRCR = 'C'
                                                                         THEN VAMT
                                                                         ELSE-VAMT
                                                                     END)
                                            FROM MTFTRADE.DBO.TblClientMargin T, 
                                                 MTFTRADE.DBO.LEDGER L, 
                                                 MTFTRADE.DBO.parameter P
                                            WHERE T.Party_Code = L.CLTCODE   
                                                  --AND VDT BETWEEN sdtcur  AND ldtcur   
                                                  AND VDT BETWEEN sdtcur AND @MARGINDATENEW + ' 23:59'
                                                  AND @MARGINDATENEW BETWEEN sdtcur AND ldtcur
                                                  AND NOT EXISTS
                                            (
                                                SELECT PARTY_CODE
                                                FROM #MTFT2DAY M
                                                WHERE M.PARTY_CODE = T.PARTY_CODE
                                            )
                                            GROUP BY CLTCODE
                                            HAVING SUM(CASE
                                                           WHEN DRCR = 'C'
                                                           THEN VAMT
                                                           ELSE-VAMT
                                                       END) <> 0;
                                     INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                     (MARGINDATE, 
                                      EXCHANGE, 
                                      SEGMENT, 
                                      PARTY_CODE, 
                                      T2DAY_CASHCOLL, 
                                      T2DAY_FDBG, 
                                      T2DAY_NONCASH
                                     )
                                            SELECT MARGINDATE = @MARGINDATE, 
                                                   EXCHANGE = 'MTF', 
                                                   SEGMENT = 'MTF', 
                                                   PARTY_CODE, 
                                                   TDAY_CASHCOLL = 0, 
                                                   TDAY_FDBG = 0, 
                                                   TDAY_NONCASH = SUM(NONCASHCOLL)
                                            FROM #EX_MTFT2DAY
                                            GROUP BY PARTY_CODE
                                            HAVING SUM(NONCASHCOLL) > 1;
                             END;
                             SET @MRGCUR = CURSOR
                             FOR SELECT MARGSQL = ' INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL (MARGINDATE, EXCHANGE, SEGMENT, PARTY_CODE, T2DAY_MARGIN, T2DAY_MTM )' + ' SELECT ''' + @MARGINDATE + ''',''' + T.EXCHANGE + ''', ''' + T.SEGMENT + ''',PARTY_CODE,MARGIN_CALL=SUM(' + MARGINCOLUMNSNONCASH + '),MTM_CALL=SUM(' + MARGINCOLUMNSCASH + ') FROM ' + SHARESERVER + '.' + SHAREDB + '.DBO.' + MARGINTABLE + ' WHERE ' + MARGINDATEFIELD + ' = (SELECT MAX(' + MARGINDATEFIELD + ') FROM ' + SHARESERVER + '.' + SHAREDB + '.DBO.' + MARGINTABLE + ' WHERE ' + MARGINDATEFIELD + ' <= ''' + @MARGINDATENEW + ' 23:59'') GROUP BY PARTY_CODE'
                                 FROM #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK T, 
                                      PRADNYA..MULTICOMPANY M
                                 WHERE T.EXCHANGE = M.EXCHANGE
                                       AND T.SEGMENT = M.SEGMENT
                                       AND M.ShareServer <> 'ANGELDEMAT'     
                                       --- AND T.SEGMENT <> 'CAPITAL'        

                                       AND T.SEGMENT <> 'POA'
                                       AND @MARGINDATE BETWEEN FROM_DATE AND TO_DATE;
                             OPEN @MRGCUR;
                             FETCH NEXT FROM @MRGCUR INTO @STRSQL;
                             WHILE @@FETCH_STATUS = 0
                                 BEGIN
                                     EXEC (@STRSQL);
                                     FETCH NEXT FROM @MRGCUR INTO @STRSQL;
                     END;
                             CLOSE @MRGCUR;
                             DEALLOCATE @MRGCUR;
                     END;
                     SET @DAY = @DAY + 1;
                     SET @CNT = @CNT + 1;
                     DEALLOCATE @EXCHANGEWISE_CURSOR;
                     FETCH NEXT FROM @MARGINDATECURSOR INTO @MARGINDATENEW;
     END;
             CLOSE @MARGINDATECURSOR;
             DEALLOCATE @MARGINDATECURSOR;
             IF @FORREPORTING <> 'Y'
                 BEGIN
                     DELETE FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                     WHERE MARGINDATE = @MARGINDATE
                           AND Exchange = 'POA'
                           AND SEGMENT = 'POA';
             END;
             IF @CHECKFLAG = 0
                 BEGIN
                     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                       SET 
                           TDAY_MARGIN = TDAY_MARGIN * PEAK_PER / 100
                     FROM #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK P
                     WHERE MARGINDATE = @MARGINDATE
                           AND TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.EXCHANGE = P.EXCHANGE
                           AND TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.SEGMENT = P.SEGMENT
                           AND PEAK_PER > 0;
             END;
     END;

/*  
DELETE FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL  
WHERE MARGINDATE = @MARGINDATE AND EXCHANGE = 'EPN'  
  
INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL (MARGINDATE, EXCHANGE, SEGMENT, PARTY_CODE, TDAY_NONCASH, TDAY_CASHCOLL)  
SELECT TRANSDATE, EXCHANGE = 'EPN', SEGMENT = 'EPN', PARTY_CODE, TDAY_NONCASH = SUM(MARGIN_BENEFIT), CASHBENEFIT = SUM(CASHBENEFIT)  
FROM TBL_EPN_BENEFIT  
WHERE TRANSDATE = @MARGINDATE  
AND MARGIN_BENEFIT + CASHBENEFIT > 0   
GROUP BY TRANSDATE, PARTY_CODE  
*/

     IF CONVERT(DATETIME, @MARGINDATE) >= CONVERT(DATETIME, 'SEP 16 2020')
         BEGIN
             DELETE FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
             WHERE MARGINDATE = @MARGINDATE
                   AND EXCHANGE = 'MTF';
             CREATE TABLE #MTFDATA
             (PARTY_CODE VARCHAR(10), 
              MTF_AVL    NUMERIC(18, 4), 
              MARGIN_REQ NUMERIC(18, 4), 
              COLLECTED  NUMERIC(18, 4)
             );
             INSERT INTO #MTFDATA
             EXEC PROC_MTF_CASH_MAR_ADJUST 
                  @MARGINDATE, 
                  '0', 
                  'ZZZZZZZZZZ', 
                  1;
             INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
             (MARGINDATE, 
              EXCHANGE, 
              SEGMENT, 
              PARTY_CODE, 
              TDAY_NONCASH, 
              TDAY_CASHCOLL
             )
                    SELECT @MARGINDATE, 
                           EXCHANGE = 'MTF', 
                           SEGMENT = 'MTF', 
                           PARTY_CODE, 
                           TDAY_NONCASH = SUM(COLLECTED), 
                           TDAY_CASHCOLL = 0
                    FROM #MTFDATA
                    WHERE COLLECTED > 0
                    GROUP BY PARTY_CODE;
     END;
     SELECT MARGINDATE, 
            EXCHANGE, 
            SEGMENT, 
            PARTY_CODE, 
            TDAY_LEDGER = SUM(ISNULL(TDAY_LEDGER, 0)), 
            TDAY_MARGIN = SUM(ISNULL(TDAY_MARGIN, 0)), 
            TDAY_MTM = SUM(ISNULL(TDAY_MTM, 0)), 
            TDAY_CASHCOLL = SUM(ISNULL(TDAY_CASHCOLL, 0)), 
            TDAY_FDBG = SUM(ISNULL(TDAY_FDBG, 0)), 
            TDAY_NONCASH = SUM(ISNULL(TDAY_NONCASH, 0)), 
            TDAY_MARGIN_SHORT = 0, 
            TDAY_MTM_SHORT = 0, 
            T1DAY_LEDGER = SUM(ISNULL(T1DAY_LEDGER, 0)), 
            T1DAY_MARGIN = SUM(ISNULL(T1DAY_MARGIN, 0)), 
            T1DAY_MTM = SUM(ISNULL(T1DAY_MTM, 0)), 
            T1DAY_CASHCOLL = SUM(ISNULL(T1DAY_CASHCOLL, 0)), 
            T1DAY_FDBG = SUM(ISNULL(T1DAY_FDBG, 0)), 
            T1DAY_NONCASH = SUM(ISNULL(T1DAY_NONCASH, 0)), 
            T1DAY_MARGIN_SHORT = 0, 
            T1DAY_MTM_SHORT = 0, 
            T2DAY_LEDGER = SUM(ISNULL(T2DAY_LEDGER, 0)), 
            T2DAY_MARGIN = SUM(ISNULL(T2DAY_MARGIN, 0)), 
            T2DAY_MTM = SUM(ISNULL(T2DAY_MTM, 0)), 
            T2DAY_CASHCOLL = SUM(ISNULL(T2DAY_CASHCOLL, 0)), 
            T2DAY_FDBG = SUM(ISNULL(T2DAY_FDBG, 0)), 
            T2DAY_NONCASH = SUM(ISNULL(T2DAY_NONCASH, 0)), 
            T2DAY_MARGIN_SHORT = 0, 
            T2DAY_MTM_SHORT = 0, 
            T_MARGINAVL = 0, 
            T_MTMAVL = 0
     INTO #COMBINE_REPORTING_DETAIL
     FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
     WHERE MARGINDATE = @MARGINDATE
     GROUP BY MARGINDATE, 
              EXCHANGE, 
              SEGMENT, 
              PARTY_CODE;
     CREATE INDEX #PARTY ON #COMBINE_REPORTING_DETAIL(PARTY_CODE, MARGINDATE, EXCHANGE, SEGMENT);
     DELETE FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
     WHERE MARGINDATE = @MARGINDATE;
     DELETE FROM TBL_COMBINE_REPORTING_PEAK_TDAY
     WHERE MARGINDATE = @MARGINDATE;
     INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY
            SELECT MARGINDATE, 
                   EXCHANGE = (CASE
                                   WHEN @COMBINEFLAG = 1
                                   THEN ''
                                   ELSE EXCHANGE
                               END), 
                   SEGMENT = (CASE
                                  WHEN @COMBINEFLAG = 1
                                  THEN ''
                                  ELSE SEGMENT
                              END), 
                   PARTY_CODE, 
                   TDAY_LEDGER = SUM(ISNULL(TDAY_LEDGER, 0)), 
                   TDAY_MARGIN = SUM(ISNULL(TDAY_MARGIN, 0)), 
                   TDAY_MTM = SUM(ISNULL(TDAY_MTM, 0)), 
                   TDAY_CASHCOLL = SUM(ISNULL(TDAY_CASHCOLL, 0)), 
                   TDAY_FDBG = SUM(ISNULL(TDAY_FDBG, 0)), 
                   TDAY_CASH = SUM(ISNULL(TDAY_LEDGER, 0)) + SUM(ISNULL(TDAY_CASHCOLL, 0)), 
                   TDAY_NONCASH = SUM(ISNULL(TDAY_NONCASH, 0)) + SUM(ISNULL(TDAY_FDBG, 0)), 
                   TDAY_MARGIN_SHORT = 0, 
                   TDAY_MTM_SHORT = 0, 
                   T1DAY_LEDGER = SUM(ISNULL(T1DAY_LEDGER, 0)), 
                   T1DAY_MARGIN = SUM(ISNULL(T1DAY_MARGIN, 0)), 
                   T1DAY_MTM = SUM(ISNULL(T1DAY_MTM, 0)), 
                   T1DAY_CASHCOLL = SUM(ISNULL(T1DAY_CASHCOLL, 0)), 
                   T1DAY_FDBG = SUM(ISNULL(T1DAY_FDBG, 0)), 
                   T1DAY_CASH = SUM(ISNULL(T1DAY_LEDGER, 0)) + SUM(ISNULL(T1DAY_CASHCOLL, 0)), 
                   T1DAY_NONCASH = SUM(ISNULL(T1DAY_NONCASH, 0)) + SUM(ISNULL(T1DAY_FDBG, 0)), 
                   T1DAY_MARGIN_SHORT = 0, 
                   T1DAY_MTM_SHORT = 0, 
                   T2DAY_LEDGER = SUM(ISNULL(T2DAY_LEDGER, 0)), 
                   T2DAY_MARGIN = SUM(ISNULL(T2DAY_MARGIN, 0)), 
                   T2DAY_MTM = SUM(ISNULL(T2DAY_MTM, 0)), 
                   T2DAY_CASHCOLL = SUM(ISNULL(T2DAY_CASHCOLL, 0)), 
                   T2DAY_FDBG = SUM(ISNULL(T2DAY_FDBG, 0)), 
                   T2DAY_CASH = SUM(ISNULL(T2DAY_LEDGER, 0)) + SUM(ISNULL(T2DAY_CASHCOLL, 0)), 
                   T2DAY_NONCASH = SUM(ISNULL(T2DAY_NONCASH, 0)) + SUM(ISNULL(T2DAY_FDBG, 0)), 
                   T2DAY_MARGIN_SHORT = 0, 
                   T2DAY_MTM_SHORT = 0
            FROM #COMBINE_REPORTING_DETAIL
            WHERE MARGINDATE = @MARGINDATE
            GROUP BY MARGINDATE, 
                     (CASE
                          WHEN @COMBINEFLAG = 1
                          THEN ''
                          ELSE EXCHANGE
                      END), 
                     (CASE
                          WHEN @COMBINEFLAG = 1
                          THEN ''
                          ELSE SEGMENT
                      END), 
                     PARTY_CODE
            HAVING SUM(TDAY_MARGIN + TDAY_MTM) > 0;
     INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY
            SELECT MARGINDATE, 
                   EXCHANGE = (CASE
                                   WHEN @COMBINEFLAG = 1
                                   THEN ''
                                   ELSE EXCHANGE
                               END), 
                   SEGMENT = (CASE
                                  WHEN @COMBINEFLAG = 1
                                  THEN ''
                                  ELSE SEGMENT
                              END), 
                   PARTY_CODE, 
                   TDAY_LEDGER = SUM(ISNULL(TDAY_LEDGER, 0)), 
                   TDAY_MARGIN = SUM(ISNULL(TDAY_MARGIN, 0)), 
                   TDAY_MTM = SUM(ISNULL(TDAY_MTM, 0)), 
                   TDAY_CASHCOLL = SUM(ISNULL(TDAY_CASHCOLL, 0)), 
                   TDAY_FDBG = SUM(ISNULL(TDAY_FDBG, 0)), 
                   TDAY_CASH = SUM(ISNULL(TDAY_LEDGER, 0)) + SUM(ISNULL(TDAY_CASHCOLL, 0)), 
                   TDAY_NONCASH = SUM(ISNULL(TDAY_NONCASH, 0)) + SUM(ISNULL(TDAY_FDBG, 0)), 
                   TDAY_MARGIN_SHORT = 0, 
                   TDAY_MTM_SHORT = 0, 
                   T1DAY_LEDGER = SUM(ISNULL(T1DAY_LEDGER, 0)), 
                   T1DAY_MARGIN = SUM(ISNULL(T1DAY_MARGIN, 0)), 
                   T1DAY_MTM = SUM(ISNULL(T1DAY_MTM, 0)), 
                   T1DAY_CASHCOLL = SUM(ISNULL(T1DAY_CASHCOLL, 0)), 
                   T1DAY_FDBG = SUM(ISNULL(T1DAY_FDBG, 0)), 
                   T1DAY_CASH = SUM(ISNULL(T1DAY_LEDGER, 0)) + SUM(ISNULL(T1DAY_CASHCOLL, 0)), 
                   T1DAY_NONCASH = SUM(ISNULL(T1DAY_NONCASH, 0)) + SUM(ISNULL(T1DAY_FDBG, 0)), 
                   T1DAY_MARGIN_SHORT = 0, 
                   T1DAY_MTM_SHORT = 0, 
                   T2DAY_LEDGER = SUM(ISNULL(T2DAY_LEDGER, 0)), 
                   T2DAY_MARGIN = SUM(ISNULL(T2DAY_MARGIN, 0)), 
                   T2DAY_MTM = SUM(ISNULL(T2DAY_MTM, 0)), 
                   T2DAY_CASHCOLL = SUM(ISNULL(T2DAY_CASHCOLL, 0)), 
                   T2DAY_FDBG = SUM(ISNULL(T2DAY_FDBG, 0)), 
                   T2DAY_CASH = SUM(ISNULL(T2DAY_LEDGER, 0)) + SUM(ISNULL(T2DAY_CASHCOLL, 0)), 
                   T2DAY_NONCASH = SUM(ISNULL(T2DAY_NONCASH, 0)) + SUM(ISNULL(T2DAY_FDBG, 0)), 
                   T2DAY_MARGIN_SHORT = 0, 
                   T2DAY_MTM_SHORT = 0
            FROM #COMBINE_REPORTING_DETAIL
            WHERE MARGINDATE = @MARGINDATE
                  AND EXISTS
            (
                SELECT PARTY_CODE
                FROM #COMBINE_REPORTING_DETAIL P
                WHERE #COMBINE_REPORTING_DETAIL.PARTY_CODE = P.PARTY_CODE
                      AND EXCHANGE = 'EPN'
                      AND SEGMENT = 'EPN'
            )
                  AND NOT EXISTS
            (
                SELECT PARTY_CODE
                FROM TBL_COMBINE_REPORTING_PEAK_TDAY T
                WHERE T.PARTY_CODE = #COMBINE_REPORTING_DETAIL.PARTY_CODE
                      AND MARGINDATE = @MARGINDATE
            )
            GROUP BY MARGINDATE, 
                     (CASE
                          WHEN @COMBINEFLAG = 1
                          THEN ''
                          ELSE EXCHANGE
                      END), 
                     (CASE
                          WHEN @COMBINEFLAG = 1
                          THEN ''
                          ELSE SEGMENT
                      END), 
                     PARTY_CODE;    
     --HAVING SUM(TDAY_MARGIN+TDAY_MTM) = 0   
     --Having SUM(TDAY_MARGIN+TDAY_MTM)> 0  

     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
       SET 
           TDAY_MARGIN = P.TDAY_MARGIN
     FROM #PEAK P
     WHERE TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE
           AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = P.PARTY_CODE;
     INSERT INTO TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
            SELECT *
            FROM #COMBINE_REPORTING_DETAIL
            WHERE EXISTS
            (
                SELECT PARTY_CODE
                FROM TBL_COMBINE_REPORTING_PEAK_TDAY
                WHERE TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE
                      AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = #COMBINE_REPORTING_DETAIL.PARTY_CODE
            );
     UPDATE #EPNREV_P
       SET 
           CASHBENEFIT = (CASE
                              WHEN CASHBENEFIT > TDAY_PEAK
                              THEN TDAY_PEAK
                              ELSE CASHBENEFIT
                          END)
     WHERE TDAY_PEAK > 0;
     DELETE FROM #EPNREV_P
     WHERE TDAY_PEAK = 0;
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
       SET 
           TDAY_CASH = TDAY_CASH - CASHBENEFIT, 
           TDAY_MARGIN = TDAY_MARGIN - CASHBENEFIT
     FROM #EPNREV_P
     WHERE MARGINDATE = @MARGINDATE
           AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = #EPNREV_P.PARTY_CODE
           AND TDAY_PEAK > 0;
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
       SET 
           TDAY_MARGIN = TDAY_MARGIN - CASHBENEFIT
     FROM #EPNREV_P
     WHERE MARGINDATE = @MARGINDATE
           AND TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.PARTY_CODE = #EPNREV_P.PARTY_CODE
           AND EXCHANGE = 'NSE'
           AND SEGMENT = 'CAPITAL'
           AND TDAY_PEAK > 0;
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
       SET 
           TDAY_MARGIN_SHORT = TDAY_CASH + TDAY_NONCASH
     WHERE MARGINDATE = @MARGINDATE;
     SELECT @VARKEY = DETAILKEY
     FROM VARCONTROL
     WHERE RECDATE >= @MARGINDATE
           AND RECDATE <= @MARGINDATE + ' 23:59';
     SELECT SETT_NO, 
            SETT_TYPE, 
            PARTY_CODE, 
            SCRIP_CD, 
            SERIES, 
            QTY = NETQTY, 
            PAYQTY = 0, 
            MTOM, 
            NETAMT, 
            ADNL_MARGIN = CONVERT(NUMERIC(18, 4), 0), 
            ADNL_PER = CONVERT(NUMERIC(18, 4), 0), 
            LEDAMT = CONVERT(NUMERIC(18, 4), 0)
     INTO #PAYIN
     FROM TBL_MG02 D
     WHERE D.MARGIN_DATE = @MARGINDATE;  
     --AND MTOM <> 0   

     UPDATE #PAYIN
       SET 
           ADNL_PER = INDEXVAR
     FROM VARDETAIL D
     WHERE DETAILKEY = @VARKEY
           AND D.SCRIP_CD = #PAYIN.SCRIP_CD
           AND D.SERIES = #PAYIN.SERIES;
     UPDATE #PAYIN
       SET 
           ADNL_MARGIN = ABS(NETAMT * ADNL_PER) / 100;  
     --WHERE QTY < 0   

     SELECT DISTINCT 
            SETT_NO, 
            SETT_TYPE
     INTO #SETT
     FROM #PAYIN;
     UPDATE #PAYIN
       SET 
           PAYQTY = D.QTY
     FROM
     (
         SELECT D.SETT_NO, 
                D.SETT_TYPE, 
                PARTY_CODE, 
                SCRIP_CD, 
                D.SERIES, 
                QTY = SUM(QTY)
         FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS D, 
              #SETT S
         WHERE D.SETT_NO = S.SETT_NO
               AND D.SETT_TYPE = S.SETT_TYPE
               AND FILLER2 = 1
               AND DRCR = 'C'
               AND SHARETYPE <> 'AUCTION'
         GROUP BY D.SETT_NO, 
                  D.SETT_TYPE, 
                  PARTY_CODE, 
                  SCRIP_CD, 
                  D.SERIES
     ) D
     WHERE D.SETT_NO = #PAYIN.SETT_NO
           AND D.SETT_TYPE = #PAYIN.SETT_TYPE
           AND D.PARTY_CODE = #PAYIN.PARTY_CODE
           AND D.SCRIP_CD = #PAYIN.SCRIP_CD
           AND D.SERIES = #PAYIN.SERIES
           AND #PAYIN.QTY < 0;
     IF
     (
         SELECT ISNULL(SUM(T2DAY_MARGIN + T2DAY_MTM), 0)
         FROM TBL_COMBINE_REPORTING_PEAK_TDAY
         WHERE MARGINDATE = @MARGINDATE
     ) > 0
         BEGIN
             UPDATE #PAYIN
               SET 
                   LEDAMT = T.T2DAY_CASH
             FROM TBL_COMBINE_REPORTING_PEAK_TDAY T
             WHERE MARGINDATE = @MARGINDATE
                   AND #PAYIN.PARTY_CODE = T.PARTY_CODE;
     END;
         ELSE
         BEGIN
             UPDATE #PAYIN
               SET 
                   LEDAMT = -1
             FROM TBL_COMBINE_REPORTING_PEAK_TDAY T
             WHERE MARGINDATE = @MARGINDATE
                   AND #PAYIN.PARTY_CODE = T.PARTY_CODE;
     END;
     SELECT PARTY_CODE, 
            COLLECT = SUM(PRADNYA.DBO.FNMIN(MTOM, COLLECT)) + CONVERT(NUMERIC(18, 2), SUM(ADNL_MARGIN))
     INTO #MTMCOLLECT
     FROM
     (
         SELECT SETT_NO, 
                SETT_TYPE, 
                PARTY_CODE, 
                MTOM = (CASE
                            WHEN SUM(MTOM) < 0
                            THEN ABS(SUM(MTOM))
                            ELSE 0
                        END), 
                COLLECT = SUM(CASE
                                  WHEN QTY < 0
                                       AND MTOM < 0
                                  THEN ABS(PAYQTY * (MTOM / ABS(QTY)))
                                  WHEN QTY > 0
                                       AND MTOM < 0
                                       AND LEDAMT >= 0
                                  THEN ABS(PAYQTY * (MTOM / ABS(QTY)))
                                  ELSE 0
                              END), 
                ADNL_MARGIN = SUM(CASE
                                      WHEN QTY < 0
                                           AND ADNL_MARGIN > 0
                                      THEN ABS(PAYQTY * (ADNL_MARGIN / ABS(QTY)))
                                      WHEN QTY > 0
                                           AND ADNL_MARGIN > 0
                                           AND LEDAMT >= 0
                                      THEN ABS(ADNL_MARGIN)
                                      ELSE 0
                                  END)
         FROM #PAYIN
         GROUP BY SETT_NO, 
                  SETT_TYPE, 
                  PARTY_CODE
     ) A
     GROUP BY PARTY_CODE;
     IF
     (
         SELECT ISNULL(SUM(T1DAY_MARGIN + T1DAY_MTM), 0)
         FROM TBL_COMBINE_REPORTING_PEAK_TDAY
         WHERE MARGINDATE = @MARGINDATE
     ) > 0
         BEGIN
             SET @DAY = 1;
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
               SET --TDAY_MARGIN = TDAY_MARGIN - ISNULL(TDAY_MARGIN_CASH,0),    
                   TDAY_MTM = TDAY_MTM - ISNULL(TDAY_MTM_CASH, 0)
             FROM
             (
                 SELECT CL_CODE = PARTY_CODE, 
                        TDAY_MARGIN_CASH = SUM(TDAY_MARGIN), 
                        TDAY_MTM_CASH = SUM(TDAY_MTM)
                 FROM #COMBINE_REPORTING_DETAIL
                 WHERE MARGINDATE = @MARGINDATE
                       AND SEGMENT = 'CAPITAL'-- AND PARTY_CODE ='K90758'     
                 GROUP BY PARTY_CODE
             ) D
             WHERE TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = D.CL_CODE;
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
               SET 
                   TDAY_MTM = TDAY_MTM - ISNULL(DEL_MARGIN, 0)
             FROM ANGELFO.NSEFO.DBO.FOMARGINNEW M
             WHERE MDATE =
             (
                 SELECT MAX(MDATE)
                 FROM ANGELFO.NSEFO.DBO.FOMARGINNEW
                 WHERE MDATE <= @MARGINDATE
             )
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = M.PARTY_CODE
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE;
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
               SET 
                   TDAY_MTM = TDAY_MTM - ISNULL(OTHERMARGIN, 0)
             FROM ANGELCOMMODITY.MCDX.DBO.FOMARGINNEW_DATA M
             WHERE TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE
                   AND MDATE =
             (
                 SELECT MAX(MDATE)
                 FROM ANGELCOMMODITY.MCDX.DBO.FOMARGINNEW_DATA
                 WHERE MDATE <= @MARGINDATE
             )
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = M.PARTY_CODE;
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
               SET 
                   TDAY_MTM = TDAY_MTM - ISNULL(OTHERMARGIN, 0)
             FROM ANGELCOMMODITY.NCDX.DBO.FOMARGINNEW_DATA M
             WHERE TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE
                   AND MDATE =
             (
                 SELECT MAX(MDATE)
                 FROM ANGELCOMMODITY.NCDX.DBO.FOMARGINNEW_DATA
                 WHERE MDATE <= @MARGINDATE
             )
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = M.PARTY_CODE;

             --SELECT * FROM TBL_COMBINE_REPORTING_PEAK_TDAY    
             --WHERE MARGINDATE = 'JAN  6 2020'    
             --AND PARTY_CODE = 'BRLY317'    
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
               SET 
                   TDAY_MTM_SHORT = TDAY_MTM_SHORT + PRADNYA.DBO.FNMAX
             (

                                    /*(CASE WHEN (TDAY_MARGIN_SHORT - TDAY_MARGIN) > 0 THEN (TDAY_MARGIN_SHORT - TDAY_MARGIN) ELSE 0 END) */

                                    +PRADNYA.DBO.FNMAX
             (((T1DAY_CASH + T1DAY_NONCASH + TDAY_MTM) - (TDAY_CASH + TDAY_NONCASH)) + (CASE
                                                                                            WHEN(TDAY_CASH + TDAY_NONCASH) < 0
                                                                                            THEN(TDAY_CASH + TDAY_NONCASH)
                                                                                            ELSE 0
                                                                                        END), 0
             ) + PRADNYA.DBO.FNMIN
             ((CASE
                   WHEN(TDAY_CASH + TDAY_NONCASH) > 0
                   THEN(TDAY_MARGIN_SHORT)
                   ELSE 0
               END), PRADNYA.DBO.FNMAX(TDAY_MARGIN - T1DAY_MARGIN, 0)
             ), 0
             )
             WHERE MARGINDATE = @MARGINDATE;
             IF CONVERT(DATETIME, @MARGINDATE) <= CONVERT(DATETIME, 'SEP 15 2020')
                 BEGIN
                     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
                       SET 
                           TDAY_MARGIN_SHORT = TDAY_MARGIN_SHORT - (CASE
                                                                        WHEN(TDAY_MARGIN_SHORT - TDAY_MARGIN + ISNULL(TDAY_MARGIN_CASH, 0)) > 0
                                                                        THEN PRADNYA.DBO.FNMIN(TDAY_MTM, (TDAY_MARGIN_SHORT - TDAY_MARGIN + ISNULL(TDAY_MARGIN_CASH, 0)))
                                                                        ELSE 0
                                                                    END), 
                           TDAY_MTM_SHORT = TDAY_MTM_SHORT + (CASE
                                                                  WHEN(TDAY_MARGIN_SHORT - TDAY_MARGIN + ISNULL(TDAY_MARGIN_CASH, 0)) > 0
                                                                  THEN PRADNYA.DBO.FNMIN(TDAY_MTM, (TDAY_MARGIN_SHORT - TDAY_MARGIN + ISNULL(TDAY_MARGIN_CASH, 0)))
                                                                  ELSE 0
                                                              END)
                     FROM
                     (
                         SELECT CL_CODE = PARTY_CODE, 
                                TDAY_MARGIN_CASH = SUM(TDAY_MARGIN), 
                                TDAY_MTM_CASH = SUM(TDAY_MTM)
                         FROM #COMBINE_REPORTING_DETAIL
                         WHERE MARGINDATE = @MARGINDATE
                               AND SEGMENT = 'CAPITAL'-- AND PARTY_CODE ='K90758'     
                         GROUP BY PARTY_CODE
                     ) D
                     WHERE TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE
                           AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = D.CL_CODE
                           AND (TDAY_MARGIN_SHORT - TDAY_MARGIN + ISNULL(TDAY_MARGIN_CASH, 0)) > 0
                           AND TDAY_MTM > TDAY_MTM_SHORT;
             END;
                 ELSE
                 BEGIN
                     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
                       SET 
                           TDAY_MTM_SHORT = TDAY_MTM_SHORT + COLLECT
                     FROM #MTMCOLLECT
                     WHERE TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE
                           AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = #MTMCOLLECT.PARTY_CODE;
             END;

/*  
 SELECT * FROM TBL_COMBINE_REPORTING_PEAK_TDAY     
 WHERE MARGINDATE = @MARGINDATE AND PARTY_CODE = 'P124903'   
  */

             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
               SET 
                   TDAY_MTM_SHORT = 0
             WHERE TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE
                   AND TDAY_MTM_SHORT < 0;
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
               SET 
                   TDAY_MTM = TDAY_MTM + ISNULL(DEL_MARGIN, 0)
             FROM ANGELFO.NSEFO.DBO.FOMARGINNEW M
             WHERE MDATE =
             (
                 SELECT MAX(MDATE)
                 FROM ANGELFO.NSEFO.DBO.FOMARGINNEW
                 WHERE MDATE <= @MARGINDATE
             )
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = M.PARTY_CODE
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE;
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
               SET 
                   TDAY_MTM = TDAY_MTM + ISNULL(OTHERMARGIN, 0)
             FROM ANGELCOMMODITY.MCDX.DBO.FOMARGINNEW_DATA M
             WHERE MDATE =
             (
                 SELECT MAX(MDATE)
                 FROM ANGELCOMMODITY.MCDX.DBO.FOMARGINNEW_DATA
                 WHERE MDATE <= @MARGINDATE
             )
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = M.PARTY_CODE
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE;
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
               SET 
                   TDAY_MTM = TDAY_MTM + ISNULL(OTHERMARGIN, 0)
             FROM ANGELCOMMODITY.NCDX.DBO.FOMARGINNEW_DATA M
             WHERE MDATE =
             (
                 SELECT MAX(MDATE)
                 FROM ANGELCOMMODITY.NCDX.DBO.FOMARGINNEW_DATA
                 WHERE MDATE <= @MARGINDATE
             )
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = M.PARTY_CODE
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE;
             IF CONVERT(DATETIME, @MARGINDATE) <= CONVERT(DATETIME, 'SEP 15 2020')
                 BEGIN
                     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
                       SET 
                           TDAY_MARGIN = TDAY_MARGIN - ISNULL(TDAY_MARGIN_CASH, 0)
                     FROM
                     (
                         SELECT CL_CODE = PARTY_CODE, 
                                TDAY_MARGIN_CASH = SUM(TDAY_MARGIN), 
                                TDAY_MTM_CASH = SUM(TDAY_MTM)
                         FROM #COMBINE_REPORTING_DETAIL
                         WHERE MARGINDATE = @MARGINDATE
                               AND SEGMENT = 'CAPITAL'-- AND PARTY_CODE ='K90758'     
                         GROUP BY PARTY_CODE
                     ) D
                     WHERE TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE
                           AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = D.CL_CODE;
             END;
     END;
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
       SET 
           TDAY_MARGIN_SHORT = TDAY_MARGIN_SHORT - TDAY_MARGIN
     WHERE MARGINDATE = @MARGINDATE
           AND TDAY_MARGIN > 0;

/*    
SELECT * FROM TBL_COMBINE_REPORTING_PEAK_TDAY    
WHERE MARGINDATE = 'JAN  7 2020'    
AND PARTY_CODE = 'A151487'    
*/

     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
       SET 
           TDAY_MARGIN_SHORT = TDAY_MARGIN_SHORT - PRADNYA.DBO.FNMIN(TDAY_MARGIN_SHORT, ABS(PRADNYA.DBO.FNMIN((TDAY_MTM_SHORT - TDAY_MTM), 0))), 
           TDAY_MTM_SHORT = TDAY_MTM_SHORT + PRADNYA.DBO.FNMIN(TDAY_MARGIN_SHORT, ABS(PRADNYA.DBO.FNMIN((TDAY_MTM_SHORT - TDAY_MTM), 0)))
     WHERE MARGINDATE = @MARGINDATE
           AND TDAY_MTM_SHORT - TDAY_MTM < 0
           AND TDAY_MTM > 0
           AND TDAY_MTM_SHORT > 0
           AND TDAY_MARGIN_SHORT > 0;

/*    
SELECT * FROM TBL_COMBINE_REPORTING_PEAK_TDAY    
WHERE MARGINDATE = 'JAN  7 2020'    
AND PARTY_CODE = 'A151487'    
*/

     IF CONVERT(DATETIME, @MARGINDATE) <= CONVERT(DATETIME, 'SEP 15 2020')
         BEGIN
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
               SET 
                   TDAY_MARGIN = TDAY_MARGIN + ISNULL(TDAY_MARGIN_CASH, 0), 
                   TDAY_MTM = TDAY_MTM + ISNULL(TDAY_MTM_CASH, 0), 
                   TDAY_MARGIN_SHORT = TDAY_MARGIN_SHORT - ISNULL(TDAY_MARGIN_CASH, 0)--, TDAY_MTM_SHORT = TDAY_MTM_SHORT - ISNULL(TDAY_MTM_CASH,0)    
             FROM
             (
                 SELECT CL_CODE = PARTY_CODE, 
                        TDAY_MARGIN_CASH = SUM(TDAY_MARGIN), 
                        TDAY_MTM_CASH = SUM(TDAY_MTM)
                 FROM #COMBINE_REPORTING_DETAIL
                 WHERE MARGINDATE = @MARGINDATE
                       AND SEGMENT = 'CAPITAL'-- AND PARTY_CODE ='K90758'     
                 GROUP BY PARTY_CODE
             ) D
             WHERE TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = D.CL_CODE;
     END;
         ELSE
         BEGIN
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
               SET 
                   TDAY_MTM = TDAY_MTM + ISNULL(TDAY_MTM_CASH, 0)
             FROM
             (
                 SELECT CL_CODE = PARTY_CODE, 
                        TDAY_MARGIN_CASH = SUM(TDAY_MARGIN), 
                        TDAY_MTM_CASH = SUM(TDAY_MTM)
                 FROM #COMBINE_REPORTING_DETAIL
                 WHERE MARGINDATE = @MARGINDATE
                       AND SEGMENT = 'CAPITAL'-- AND PARTY_CODE ='K90758'     
                 GROUP BY PARTY_CODE
             ) D
             WHERE TBL_COMBINE_REPORTING_PEAK_TDAY.MARGINDATE = @MARGINDATE
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = D.CL_CODE;
     END;
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
       SET 
           TDAY_MARGIN_SHORT = TDAY_MARGIN_SHORT - PRADNYA.DBO.FNMIN(TDAY_MARGIN_SHORT, ABS(PRADNYA.DBO.FNMIN((TDAY_MTM_SHORT - TDAY_MTM), 0))), 
           TDAY_MTM_SHORT = TDAY_MTM_SHORT + PRADNYA.DBO.FNMIN(TDAY_MARGIN_SHORT, ABS(PRADNYA.DBO.FNMIN((TDAY_MTM_SHORT - TDAY_MTM), 0)))
     WHERE MARGINDATE = @MARGINDATE
           AND TDAY_MTM_SHORT - TDAY_MTM < 0
           AND TDAY_MTM > 0
           AND TDAY_MARGIN_SHORT > 0;
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
       SET 
           TDAY_MTM_SHORT = TDAY_MTM_SHORT - TDAY_MTM
     WHERE MARGINDATE = @MARGINDATE
           AND TDAY_MTM > 0
           AND TDAY_MTM_SHORT - TDAY_MTM < 0;
     IF
     (
         SELECT ISNULL(SUM(TDAY_MARGIN + TDAY_MTM), 0)
         FROM TBL_COMBINE_REPORTING_PEAK_TDAY
         WHERE MARGINDATE = @MARGINDATE
     ) >= 0
         BEGIN
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
               SET 
                   TDAY_MARGIN_SHORT = 0, 
                   TDAY_MTM_SHORT = 0
             WHERE MARGINDATE = @MARGINDATE
                   AND TDAY_MARGIN_SHORT <> 0
                   AND PARTY_CODE IN
             (
                 SELECT CL_CODE
                 FROM CLIENT1
                 WHERE CL_TYPE = 'NRI'
             );

             --UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY SET TDAY_MARGIN_SHORT =0 ---PRADNYA.DBO.FNMIN(ABS(TDAY_MARGIN_SHORT),ABS(T2DAY_LEDGER))  
             --,TDAY_MTM_SHORT=0  
             --WHERE MARGINDATE = @MARGINDATE AND TDAY_MARGIN_SHORT < 0   
             --AND PARTY_CODE IN (SELECT CL_CODE FROM CLIENT1 WHERE CL_TYPE = 'NRI')   
     END;
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
       SET 
           TDAY_MARGIN_SHORT = 0
     WHERE MARGINDATE = @MARGINDATE
           AND TDAY_MARGIN = 0
           AND TDAY_MARGIN_SHORT <= 0;
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
       SET 
           TDAY_MARGIN_SHORT = -TDAY_MARGIN
     WHERE MARGINDATE = @MARGINDATE
           AND TDAY_MARGIN > 0
           AND TDAY_MARGIN_SHORT < 0
           AND TDAY_MARGIN < ABS(TDAY_MARGIN_SHORT);

/*   
UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY SET TDAY_MTM_SHORT = PRADNYA.DBO.FNMAX(TDAY_MTM_SHORT, -TDAY_MTM)    
WHERE MARGINDATE  = @MARGINDATE AND TDAY_MTM_SHORT < 0    
*/

     IF @COMBINEFLAG = 0
         BEGIN
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
               SET 
                   TDAY_MARGIN_SHORT = T1.TDAY_MARGIN_SHORT, 
                   TDAY_MTM_SHORT = T1.TDAY_MTM_SHORT, 
                   T1DAY_MARGIN_SHORT = T1.T1DAY_MARGIN_SHORT, 
                   T1DAY_MTM_SHORT = T1.T1DAY_MTM_SHORT, 
                   T2DAY_MARGIN_SHORT = T1.T2DAY_MARGIN_SHORT, 
                   T2DAY_MTM_SHORT = T1.T2DAY_MTM_SHORT,

                   --T_MARGINAVL = (CASE WHEN T1.TDAY_MARGIN_SHORT >= 0 THEN T1.TDAY_MARGIN ELSE T1.TDAY_MARGIN_SHORT END),    
                   --T_MTMAVL = (CASE WHEN T1.TDAY_MTM_SHORT >= 0 THEN T1.TDAY_MTM ELSE T1.TDAY_MTM_SHORT END)     

                   T_MARGINAVL = (CASE
                                      WHEN T1.TDAY_MARGIN_SHORT >= 0
                                      THEN T1.TDAY_MARGIN
                                      ELSE(CASE
                                               WHEN T1.TDAY_MARGIN > ABS(T1.TDAY_MARGIN_SHORT)
                                               THEN T1.TDAY_MARGIN_SHORT
                                               ELSE-T1.TDAY_MARGIN
                                           END)
                                  END), 
                   T_MTMAVL = (CASE
                                   WHEN T1.TDAY_MTM_SHORT >= 0
                                   THEN T1.TDAY_MTM
                                   ELSE(CASE
                                            WHEN T1.TDAY_MTM > ABS(T1.TDAY_MTM_SHORT)
                                            THEN T1.TDAY_MTM_SHORT
                                            ELSE-T1.TDAY_MTM
                                        END)
                               END)
             FROM TBL_COMBINE_REPORTING_PEAK_TDAY T1
             WHERE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.MARGINDATE = @MARGINDATE
                   AND T1.MARGINDATE = @MARGINDATE
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.PARTY_CODE = T1.PARTY_CODE
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.EXCHANGE = T1.EXCHANGE
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.SEGMENT = T1.SEGMENT;
     END;
         ELSE
         BEGIN
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
               SET 
                   T_MARGINAVL = TDAY_MARGIN
             WHERE MARGINDATE = @MARGINDATE
                   AND EXISTS
             (
                 SELECT PARTY_CODE
                 FROM TBL_COMBINE_REPORTING_PEAK_TDAY
                 WHERE MARGINDATE = @MARGINDATE
                       AND TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.PARTY_CODE = TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE
                       AND TDAY_MARGIN_SHORT >= 0
             );
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
               SET 
                   T_MTMAVL = TDAY_MTM
             WHERE MARGINDATE = @MARGINDATE
                   AND EXISTS
             (
                 SELECT PARTY_CODE
                 FROM TBL_COMBINE_REPORTING_PEAK_TDAY
                 WHERE MARGINDATE = @MARGINDATE
                       AND TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.PARTY_CODE = TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE
                       AND TDAY_MTM_SHORT >= 0
             );
             SELECT DISTINCT 
                    PARTY_CODE
             INTO #PARTYCNT
             FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
             WHERE MARGINDATE = @MARGINDATE
                   AND EXCHANGE <> 'POA'
                   AND TDAY_MARGIN + TDAY_MTM > 0
             GROUP BY PARTY_CODE
             HAVING COUNT(1) = 1;
             CREATE CLUSTERED INDEX PARTIDX ON #PARTYCNT(PARTY_CODE);
             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
               SET 
                   T_MARGINAVL = T1.TDAY_MARGIN_SHORT, 
                   T_MTMAVL = T1.TDAY_MTM_SHORT
             FROM TBL_COMBINE_REPORTING_PEAK_TDAY T1
             WHERE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.MARGINDATE = @MARGINDATE
                   AND T1.MARGINDATE = @MARGINDATE
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.TDAY_MARGIN + TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.TDAY_MTM > 0
                   AND TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.PARTY_CODE = T1.PARTY_CODE
                   AND EXISTS
             (
                 SELECT PARTY_CODE
                 FROM #PARTYCNT
                 WHERE #PARTYCNT.PARTY_CODE = TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.PARTY_CODE
             );
             IF CONVERT(DATETIME, @MARGINDATE) > CONVERT(DATETIME, 'SEP 15 2020')
                 BEGIN
                     UPDATE #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK
                       SET 
                           EXCHANGE_PRIORITY = 0
                     WHERE SEGMENT = 'CAPITAL';
             END;
             SET @MRGCUR = CURSOR
             FOR SELECT PARTY_CODE, 
                        AVAL_MARGIN = TDAY_MARGIN_SHORT
                 FROM TBL_COMBINE_REPORTING_PEAK_TDAY
                 WHERE MARGINDATE = @MARGINDATE
                       AND TDAY_MARGIN_SHORT < 0
                       AND NOT EXISTS
                 (
                     SELECT PARTY_CODE
                     FROM #PARTYCNT
                     WHERE #PARTYCNT.PARTY_CODE = TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE
                 )
                 ORDER BY PARTY_CODE;
             OPEN @MRGCUR;
             FETCH NEXT FROM @MRGCUR INTO @PARTY_CODE, @SHRT_AMT;
             WHILE @@FETCH_STATUS = 0
                 BEGIN
                     SET @EXCHANGEWISE_CURSOR = CURSOR
                     FOR SELECT PARTY_CODE, 
                                T.EXCHANGE, 
                                T.SEGMENT, 
                                TDAY_MARGIN, 
                                EXCHANGE_PRIORITY
                         FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL T, 
                              #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK T1
                         WHERE MARGINDATE = @MARGINDATE
                               AND PARTY_CODE = @PARTY_CODE
                               AND T.EXCHANGE = T1.EXCHANGE
                               AND T.SEGMENT = T1.SEGMENT
                               AND TDAY_MARGIN > 0
                         ORDER BY TDAY_MARGIN DESC, 
                                  EXCHANGE_PRIORITY DESC;
                     OPEN @EXCHANGEWISE_CURSOR;
                     FETCH NEXT FROM @EXCHANGEWISE_CURSOR INTO @PARTY_CODE, @EXCHANGE_NEW, @SEGMENT_NEW, @MARG_AMT, @EXCHANGE_PRIORITY;
                     WHILE @@FETCH_STATUS = 0
                         BEGIN
                             IF @SHRT_AMT < 0
                                 BEGIN
                                     IF @MARG_AMT >= ABS(@SHRT_AMT)
                                         BEGIN
                                             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                               SET 
                                                   T_MARGINAVL = @SHRT_AMT
                                             WHERE MARGINDATE = @MARGINDATE
                                                   AND PARTY_CODE = @PARTY_CODE
                                                   AND EXCHANGE = @EXCHANGE_NEW
                                                   AND SEGMENT = @SEGMENT_NEW;
                                             SET @SHRT_AMT = 0;
                                     END;
                                         ELSE
                                         BEGIN
                                             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                               SET 
                                                   T_MARGINAVL = -@MARG_AMT
                                             WHERE MARGINDATE = @MARGINDATE
                                                   AND PARTY_CODE = @PARTY_CODE
                                                   AND EXCHANGE = @EXCHANGE_NEW
                                                   AND SEGMENT = @SEGMENT_NEW;
                                             SET @SHRT_AMT = @SHRT_AMT + @MARG_AMT;
                                     END;
                             END;
                                 ELSE
                                 BEGIN
                                     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                       SET 
                                           T_MARGINAVL = @MARG_AMT
                                     WHERE MARGINDATE = @MARGINDATE
                                           AND PARTY_CODE = @PARTY_CODE
                                           AND EXCHANGE = @EXCHANGE_NEW
                                           AND SEGMENT = @SEGMENT_NEW;
                             END;
                             FETCH NEXT FROM @EXCHANGEWISE_CURSOR INTO @PARTY_CODE, @EXCHANGE_NEW, @SEGMENT_NEW, @MARG_AMT, @EXCHANGE_PRIORITY;
     END;
                     CLOSE @EXCHANGEWISE_CURSOR;
                     DEALLOCATE @EXCHANGEWISE_CURSOR;
                     FETCH NEXT FROM @MRGCUR INTO @PARTY_CODE, @SHRT_AMT;
     END;
             CLOSE @MRGCUR;
             DEALLOCATE @MRGCUR;
             SET @MRGCUR = CURSOR
             FOR SELECT PARTY_CODE, 
                        AVAL_MARGIN = TDAY_MTM_SHORT
                 FROM TBL_COMBINE_REPORTING_PEAK_TDAY
                 WHERE MARGINDATE = @MARGINDATE
                       AND NOT EXISTS
                 (
                     SELECT PARTY_CODE
                     FROM #PARTYCNT
                     WHERE #PARTYCNT.PARTY_CODE = TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE
                 )
                       AND TDAY_MTM_SHORT < 0
                 ORDER BY PARTY_CODE;
             OPEN @MRGCUR;
             FETCH NEXT FROM @MRGCUR INTO @PARTY_CODE, @SHRT_AMT;
             WHILE @@FETCH_STATUS = 0
                 BEGIN
                     SET @EXCHANGEWISE_CURSOR = CURSOR
                     FOR SELECT PARTY_CODE, 
                                T.EXCHANGE, 
                                T.SEGMENT, 
                                TDAY_MTM, 
                                EXCHANGE_PRIORITY
                         FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL T, 
                              #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK T1
                         WHERE MARGINDATE = @MARGINDATE
                               AND PARTY_CODE = @PARTY_CODE
                               AND T.EXCHANGE = T1.EXCHANGE
                               AND T.SEGMENT = T1.SEGMENT
                               AND TDAY_MTM > 0
                         ORDER BY EXCHANGE_PRIORITY DESC;
                     OPEN @EXCHANGEWISE_CURSOR;
                     FETCH NEXT FROM @EXCHANGEWISE_CURSOR INTO @PARTY_CODE, @EXCHANGE_NEW, @SEGMENT_NEW, @MARG_AMT, @EXCHANGE_PRIORITY;
                     WHILE @@FETCH_STATUS = 0
                         BEGIN
                             IF @SHRT_AMT < 0
                                 BEGIN
                                     IF @MARG_AMT >= ABS(@SHRT_AMT)
                                         BEGIN
                                             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                               SET 
                                                   T_MTMAVL = @SHRT_AMT
                                             WHERE MARGINDATE = @MARGINDATE
                                                   AND PARTY_CODE = @PARTY_CODE
                                                   AND EXCHANGE = @EXCHANGE_NEW
                                                   AND SEGMENT = @SEGMENT_NEW;
                                             SET @SHRT_AMT = 0;
                                     END;
                                         ELSE
                                         BEGIN
                                             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                               SET 
                                                   T_MTMAVL = -@MARG_AMT
                                             WHERE MARGINDATE = @MARGINDATE
                                                   AND PARTY_CODE = @PARTY_CODE
                                                   AND EXCHANGE = @EXCHANGE_NEW
                                                   AND SEGMENT = @SEGMENT_NEW;
                                             SET @SHRT_AMT = @SHRT_AMT + @MARG_AMT;
                                     END;
                             END;
                                 ELSE
                                 BEGIN
                                     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                       SET 
                                           T_MTMAVL = @MARG_AMT
                                     WHERE MARGINDATE = @MARGINDATE
                                           AND PARTY_CODE = @PARTY_CODE
                                           AND EXCHANGE = @EXCHANGE_NEW
                                           AND SEGMENT = @SEGMENT_NEW;
                             END;
                             FETCH NEXT FROM @EXCHANGEWISE_CURSOR INTO @PARTY_CODE, @EXCHANGE_NEW, @SEGMENT_NEW, @MARG_AMT, @EXCHANGE_PRIORITY;
     END;
                     CLOSE @EXCHANGEWISE_CURSOR;
                     DEALLOCATE @EXCHANGEWISE_CURSOR;
                     FETCH NEXT FROM @MRGCUR INTO @PARTY_CODE, @SHRT_AMT;
     END;
             CLOSE @MRGCUR;
             DEALLOCATE @MRGCUR;
             SET @MRGCUR = CURSOR
             FOR SELECT PARTY_CODE, 
                        AVAL_MARGIN = PRADNYA.DBO.FNMAX(0, PRADNYA.DBO.FNMIN(T2DAY_CASH, T2DAY_MARGIN_SHORT))
                 FROM TBL_COMBINE_REPORTING_PEAK_TDAY
                 WHERE MARGINDATE = @MARGINDATE
                       AND NOT EXISTS
                 (
                     SELECT PARTY_CODE
                     FROM #PARTYCNT
                     WHERE #PARTYCNT.PARTY_CODE = TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE
                 )
                       AND TDAY_MTM_SHORT < 0
                       AND PRADNYA.DBO.FNMAX(0, PRADNYA.DBO.FNMIN(T2DAY_CASH, T2DAY_MARGIN_SHORT)) > 0
                 ORDER BY PARTY_CODE;
             OPEN @MRGCUR;
             FETCH NEXT FROM @MRGCUR INTO @PARTY_CODE, @SHRT_AMT;
             WHILE @@FETCH_STATUS = 0
                 BEGIN
                     SET @EXCHANGEWISE_CURSOR = CURSOR
                     FOR SELECT PARTY_CODE, 
                                T.EXCHANGE, 
                                T.SEGMENT, 
                                TDAY_MTM = T_MTMAVL, 
                                EXCHANGE_PRIORITY
                         FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL T, 
                              #V2_TBL_EXCHANGE_MARGIN_REPORT_PEAK T1
                         WHERE MARGINDATE = @MARGINDATE
                               AND PARTY_CODE = @PARTY_CODE
                               AND T.EXCHANGE = T1.EXCHANGE
                               AND T.SEGMENT = T1.SEGMENT
                               AND TDAY_MTM > 0
                               AND T_MTMAVL < 0
                               AND T.EXCHANGE IN('NCX', 'MCX', 'NCM', 'MCM', 'NSE')
                         AND SEGMENT = (CASE
                                            WHEN EXCHANGE = 'NSE'
                                            THEN 'CAPITAL'
                                            ELSE 'FUTURES'
                                        END)
                         ORDER BY EXCHANGE_PRIORITY DESC;
                     OPEN @EXCHANGEWISE_CURSOR;
                     FETCH NEXT FROM @EXCHANGEWISE_CURSOR INTO @PARTY_CODE, @EXCHANGE_NEW, @SEGMENT_NEW, @MARG_AMT, @EXCHANGE_PRIORITY;
                     WHILE @@FETCH_STATUS = 0
                         BEGIN
                             IF @SHRT_AMT > 0
                                 BEGIN
                                     IF ABS(@MARG_AMT) >= ABS(@SHRT_AMT)
                                         BEGIN
                                             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                               SET 
                                                   T_MTMAVL = T_MTMAVL + @SHRT_AMT
                                             WHERE MARGINDATE = @MARGINDATE
                                                   AND PARTY_CODE = @PARTY_CODE
                                                   AND EXCHANGE = @EXCHANGE_NEW
                                                   AND SEGMENT = @SEGMENT_NEW;
                                             SET @SHRT_AMT = 0;
                                     END;
                                         ELSE
                                         BEGIN
                                             UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                               SET 
                                                   T_MTMAVL = T_MTMAVL - @MARG_AMT
                                             WHERE MARGINDATE = @MARGINDATE
                                                   AND PARTY_CODE = @PARTY_CODE
                                                   AND EXCHANGE = @EXCHANGE_NEW
                                                   AND SEGMENT = @SEGMENT_NEW;
                                             SET @SHRT_AMT = @SHRT_AMT + @MARG_AMT;
                                     END;
                             END;
                                 ELSE
                                 BEGIN
                                     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
                                       SET 
                                           T_MTMAVL = T_MTMAVL - @MARG_AMT
                                     WHERE MARGINDATE = @MARGINDATE
                                           AND PARTY_CODE = @PARTY_CODE
                                           AND EXCHANGE = @EXCHANGE_NEW
                                           AND SEGMENT = @SEGMENT_NEW;
                             END;
                             FETCH NEXT FROM @EXCHANGEWISE_CURSOR INTO @PARTY_CODE, @EXCHANGE_NEW, @SEGMENT_NEW, @MARG_AMT, @EXCHANGE_PRIORITY;
     END;
                     CLOSE @EXCHANGEWISE_CURSOR;
                     DEALLOCATE @EXCHANGEWISE_CURSOR;
                     FETCH NEXT FROM @MRGCUR INTO @PARTY_CODE, @SHRT_AMT;
     END;
             CLOSE @MRGCUR;
             DEALLOCATE @MRGCUR;
     END;
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
       SET 
           T_MARGINAVL = (CASE
                              WHEN T_MARGINAVL >= 0
                              THEN T_MARGINAVL + CASHBENEFIT
                              ELSE T_MARGINAVL
                          END), 
           TDAY_MARGIN = TDAY_MARGIN + CASHBENEFIT
     FROM #EPNREV_P
     WHERE MARGINDATE = @MARGINDATE
           AND EXCHANGE = 'NSE'
           AND SEGMENT = 'CAPITAL'
           AND TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.PARTY_CODE = #EPNREV_P.PARTY_CODE
           AND TDAY_PEAK > 0;
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
       SET 
           TDAY_CASH = TDAY_CASH + CASHBENEFIT, 
           TDAY_MARGIN = TDAY_MARGIN + CASHBENEFIT, 
           TDAY_MARGIN_SHORT = (CASE
                                    WHEN TDAY_MARGIN_SHORT < 0
                                    THEN TDAY_MARGIN_SHORT
                                    ELSE TDAY_MARGIN_SHORT + CASHBENEFIT
                                END)
     FROM #EPNREV_P
     WHERE MARGINDATE = @MARGINDATE
           AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = #EPNREV_P.PARTY_CODE
           AND TDAY_PEAK > 0;
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
       SET 
           TDAY_MARGIN_SHORT = A.TDAY_MARGIN_SHORT
     FROM
     (
         SELECT PARTY_CODE, 
                TDAY_MARGIN_SHORT = SUM(T_MARGINAVL)
         FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
         WHERE MARGINDATE = @MARGINDATE
               AND T_MARGINAVL < 0
         GROUP BY PARTY_CODE
     ) A
     WHERE MARGINDATE = @MARGINDATE
           AND A.PARTY_CODE = TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE;
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
       SET 
           T_MARGINAVL = -TDAY_MARGIN
     WHERE MARGINDATE = @MARGINDATE
           AND T_MARGINAVL < 0
           AND ABS(T_MARGINAVL) > TDAY_MARGIN;
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
       SET 
           TDAY_NONCASH = TDAY_NONCASH + MARGIN_BENEFIT, 
           TDAY_CASHCOLL = TDAY_CASHCOLL - MARGIN_BENEFIT
     FROM #EPNREV_P
     WHERE MARGINDATE = @MARGINDATE
           AND TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL.PARTY_CODE = #EPNREV_P.PARTY_CODE
           AND EXCHANGE = 'EPN';
     UPDATE TBL_COMBINE_REPORTING_PEAK_TDAY
       SET 
           TDAY_NONCASH = TDAY_NONCASH + MARGIN_BENEFIT, 
           TDAY_CASHCOLL = TDAY_CASHCOLL - MARGIN_BENEFIT
     FROM #EPNREV_P
     WHERE MARGINDATE = @MARGINDATE
           AND TBL_COMBINE_REPORTING_PEAK_TDAY.PARTY_CODE = #EPNREV_P.PARTY_CODE;
     DELETE FROM TBL_COMBINE_REPORTING_PEAK_DETAIL
     WHERE MARGINDATE = @MARGINDATE;
     DELETE FROM TBL_COMBINE_REPORTING_PEAK
     WHERE MARGINDATE = @MARGINDATE;
     INSERT INTO TBL_COMBINE_REPORTING_PEAK
            SELECT *
            FROM TBL_COMBINE_REPORTING_PEAK_TDAY
            WHERE MARGINDATE = @MARGINDATE;
     INSERT INTO TBL_COMBINE_REPORTING_PEAK_DETAIL
            SELECT *
            FROM TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL
            WHERE MARGINDATE = @MARGINDATE;
     TRUNCATE TABLE TBL_COMBINE_REPORTING_PEAK_TDAY;
     TRUNCATE TABLE TBL_COMBINE_REPORTING_PEAK_TDAY_DETAIL;

GO
