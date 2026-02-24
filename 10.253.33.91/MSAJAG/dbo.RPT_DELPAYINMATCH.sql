-- Object: PROCEDURE dbo.RPT_DELPAYINMATCH
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROC [DBO].[RPT_DELPAYINMATCH](            
           @StatusId   VARCHAR(15),            
           @Statusname VARCHAR(25),            
           @Sett_No    VARCHAR(7),            
           @Sett_Type  VARCHAR(2),            
           @BranchCd   VARCHAR(10),            
           @ClType     VARCHAR(10),             
           @Opt        INT)            
AS            
/*        
     declare @StatusId   VARCHAR(15)        
           declare @Statusname VARCHAR(25)        
           declare @Sett_No    VARCHAR(7)            
           declare @Sett_Type  VARCHAR(2)            
           declare @BranchCd   VARCHAR(10)            
           declare @ClType     VARCHAR(10)             
           declare @Opt        INT        
        
     set @StatusId = 'broker'        
           set @Statusname = 'broker'        
           set @Sett_No = '2009104'        
           set @Sett_Type ='N'        
           set @BranchCd  ='ALL'        
           set @ClType ='%%'        
           set @Opt = 2        
        
        
        
*/        
  SELECT @BranchCD = (CASE             
                        WHEN @StatusId = 'broker' THEN @BranchCd            
                        ELSE '%'            
                      END)            
      
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED       
      
  SELECT * INTO #DELCLT FROM DELIVERYCLT (NOLOCK)      
  WHERE SETT_NO = @SETT_NO      
  AND SETT_TYPE = @SETT_TYPE      
  AND INOUT = 'I'      
      
  SELECT * INTO #DEL_TRANS FROM DELTRANS (NOLOCK)      
  WHERE SETT_NO = @SETT_NO      
  AND SETT_TYPE = @SETT_TYPE      
  AND DRCR = 'C' AND TRTYPE <> 906 AND FILLER2 = 1      
      
 SELECT * INTO #CLIENT1 FROM CLIENT1 (NOLOCK)        
 WHERE CL_CODE IN (SELECT DISTINCT PARTY_CODE FROM #DELCLT )      
        
 SELECT * INTO #CLIENT2 FROM CLIENT2 (NOLOCK)      
 WHERE PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #DELCLT )      
         
              
  SELECT   D.SETT_NO,            
           D.SETT_TYPE,            
           D.PARTY_CODE,            
           CERTNO = ISIN,            
           DELQTY = D.QTY,            
           RECQTY = SUM(ISNULL(C.QTY,0)),            
           ISETTQTY = 0,            
           IBENQTY = 0,            
           ISETTQTYPRINT = 0,            
           IBENQTYPRINT = 0,            
           ISETTQTYMARK = 0,            
           IBENQTYMARK = 0,            
           HOLD = 0,            
           PLEDGE = 0,            
           BSEHOLD = 0,            
           BSEPLEDGE = 0,             
           C1.CL_TYPE            
  INTO     #DELPAYINMATCH            
  FROM     #CLIENT1 C1 (nolock),            
           #CLIENT2 C2 (nolock),            
           MULTIISIN M (nolock),            
           #DELCLT D (nolock)            
           LEFT OUTER JOIN #DEL_TRANS C (nolock)            
             ON (D.SETT_NO = C.SETT_NO            
                 AND D.SETT_TYPE = C.SETT_TYPE            
                 AND D.SCRIP_CD = C.SCRIP_CD            
                 AND D.SERIES = C.SERIES            
                 AND D.PARTY_CODE = C.PARTY_CODE            
                 AND DRCR = 'C'            
                 AND FILLER2 = 1            
                 AND SHARETYPE <> 'Auction')            
  WHERE    INOUT = 'I'            
           AND M.SCRIP_CD = D.SCRIP_CD            
           AND M.SERIES = D.SERIES            
           AND VALID = 1            
           AND D.SETT_NO = @Sett_No            
           AND D.SETT_TYPE = @Sett_Type            
           AND C1.CL_CODE = C2.CL_CODE            
           AND C2.PARTY_CODE = D.PARTY_CODE            
           AND @StatusName = (CASE             
                                WHEN @StatusId = 'BRANCH' THEN C1.BRANCH_CD            
                                WHEN @StatusId = 'SUBBROKER' THEN C1.SUB_BROKER            
                                WHEN @StatusId = 'Trader' THEN C1.TRADER            
                                WHEN @StatusId = 'Family' THEN C1.FAMILY            
                                WHEN @StatusId = 'Area' THEN C1.AREA            
                                WHEN @StatusId = 'Region' THEN C1.REGION            
                             WHEN @StatusId = 'Client' THEN C2.PARTY_CODE            
                                ELSE 'BROKER'            
                              END)            
           AND C1.CL_TYPE LIKE @ClType             
  GROUP BY D.SETT_NO,D.SETT_TYPE,D.PARTY_CODE,D.QTY,            
           ISIN,C1.CL_TYPE             
  HAVING   D.QTY > 0            
                               
  IF @Opt <> 1            
    BEGIN            
      DELETE FROM #DELPAYINMATCH            
      WHERE       DELQTY <= RECQTY            
    END            
                
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED            
              
  INSERT INTO #DELPAYINMATCH            
  SELECT   ISETT_NO,            
           ISETT_TYPE,            
           D.PARTY_CODE,            
           CERTNO,            
           QTY = 0,            
           RECQTY = 0,            
           ISETTQTY = SUM(CASE             
                            WHEN TRTYPE <> 1000 THEN QTY            
                            ELSE 0         
                          END),            
           IBENQTY = SUM(CASE             
                           WHEN TRTYPE = 1000 THEN QTY            
                           ELSE 0            
                         END),            
           ISETTQTYPRINT = SUM(CASE             
                                 WHEN DELIVERED = 'G'            
                                      AND TRTYPE <> 1000 THEN QTY            
                                 ELSE 0            
                               END),            
           IBENQTYPRINT = SUM(CASE             
                                WHEN DELIVERED = 'G'            
                                     AND TRTYPE = 1000 THEN QTY            
                                ELSE 0            
                              END),            
           ISETTQTYMARK = SUM(CASE           
                                WHEN DELIVERED = '0'            
                                     AND TRTYPE <> 1000 THEN QTY            
                                ELSE 0            
                              END),            
  IBENQTYMARK = SUM(CASE             
                               WHEN DELIVERED = '0'            
                                    AND TRTYPE = 1000 THEN QTY            
                               ELSE 0            
                             END),            
           HOLD = 0,            
           PLEDGE = 0,            
           BSEHOLD = 0,            
           BSEPLEDGE = 0,             
           C1.CL_TYPE            
  FROM     MSAJAG.DBO.DELTRANS D,            
           #CLIENT1 C1,            
           #CLIENT2 C2            
  WHERE    FILLER2 = 1            
           AND DRCR = 'D'            
           AND DELIVERED <> 'D'            
           AND TRTYPE IN (907,908,1000)            
           AND ISETT_NO = @Sett_No            
           AND ISETT_TYPE = @Sett_Type            
           AND C1.CL_CODE = C2.CL_CODE            
           AND C2.PARTY_CODE = D.PARTY_CODE            
           AND @StatusName = (CASE             
                                WHEN @StatusId = 'BRANCH' THEN C1.BRANCH_CD            
                                WHEN @StatusId = 'SUBBROKER' THEN C1.SUB_BROKER            
                                WHEN @StatusId = 'Trader' THEN C1.TRADER            
                                WHEN @StatusId = 'Family' THEN C1.FAMILY            
                                WHEN @StatusId = 'Area' THEN C1.AREA            
                                WHEN @StatusId = 'Region' THEN C1.REGION            
                                WHEN @StatusId = 'Client' THEN C2.PARTY_CODE            
                                ELSE 'BROKER'            
                              END)            
           AND C1.CL_TYPE LIKE @ClType             
  GROUP BY ISETT_NO,ISETT_TYPE,D.PARTY_CODE,CERTNO,C1.CL_TYPE             
                       
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED            
              
  INSERT INTO #DELPAYINMATCH            
  SELECT   ISETT_NO,            
           ISETT_TYPE,            
           D.PARTY_CODE,        
           CERTNO,            
           QTY = 0,            
           RECQTY = 0,            
           ISETTQTY = SUM(CASE             
                            WHEN TRTYPE <> 1000 THEN QTY            
                            ELSE 0            
                          END),            
           IBENQTY = SUM(CASE             
                           WHEN TRTYPE = 1000 THEN QTY            
                           ELSE 0            
                END),            
           ISETTQTYPRINT = SUM(CASE             
                                 WHEN DELIVERED = 'G'            
                                      AND TRTYPE <> 1000 THEN QTY            
                                 ELSE 0            
                               END),            
           IBENQTYPRINT = SUM(CASE             
                                WHEN DELIVERED = 'G'            
                                     AND TRTYPE = 1000 THEN QTY            
                                ELSE 0            
                              END),            
           ISETTQTYMARK = SUM(CASE             
                                WHEN DELIVERED = '0'            
                                     AND TRTYPE <> 1000 THEN QTY            
                                ELSE 0            
                              END),            
           IBENQTYMARK = SUM(CASE             
                               WHEN DELIVERED = '0'            
                                    AND TRTYPE = 1000 THEN QTY            
                               ELSE 0            
                             END),            
           HOLD = 0,            
           PLEDGE = 0,            
           BSEHOLD = 0,            
           BSEPLEDGE = 0,             
           C1.CL_TYPE             
  FROM     BSEDB.DBO.DELTRANS D,            
           #CLIENT1 C1,            
           #CLIENT2 C2            
  WHERE    FILLER2 = 1            
           AND DRCR = 'D'            
           AND DELIVERED <> 'D'            
           AND TRTYPE IN (907,908,1000)            
           AND ISETT_NO = @Sett_No            
           AND ISETT_TYPE = @Sett_Type            
           AND C1.CL_CODE = C2.CL_CODE            
           AND C2.PARTY_CODE = D.PARTY_CODE            
           AND @StatusName = (CASE             
                                WHEN @StatusId = 'BRANCH' THEN C1.BRANCH_CD            
             WHEN @StatusId = 'SUBBROKER' THEN C1.SUB_BROKER            
                                WHEN @StatusId = 'Trader' THEN C1.TRADER            
                                WHEN @StatusId = 'Family' THEN C1.FAMILY            
                                WHEN @StatusId = 'Area' THEN C1.AREA            
                                WHEN @StatusId = 'Region' THEN C1.REGION            
 WHEN @StatusId = 'Client' THEN C2.PARTY_CODE            
                                ELSE 'BROKER'            
                              END)            
           AND C1.CL_TYPE LIKE @ClType             
  GROUP BY ISETT_NO,ISETT_TYPE,D.PARTY_CODE,CERTNO,C1.CL_TYPE             
                       
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED            
              
  UPDATE #DELPAYINMATCH            
  SET    HOLD = A.HOLD + (CASE             
                            WHEN @StatusId <> 'broker' THEN A.PLEDGE            
                            ELSE 0            
                          END),            
         PLEDGE = (CASE             
                     WHEN @StatusId = 'broker' THEN A.PLEDGE            
                     ELSE 0            
                   END)            
  FROM   (SELECT   PARTY_CODE,            
                   CERTNO,            
                   HOLD = ISNULL(SUM(CASE             
                                       WHEN TRTYPE = 904 THEN QTY            
                                       ELSE 0            
                                     END),0),            
                   PLEDGE = ISNULL(SUM(CASE             
                                         WHEN TRTYPE = 909 THEN QTY            
                                         ELSE 0            
                        END),0)            
          FROM     MSAJAG.DBO.DELTRANS D (nolock),            
                   MSAJAG.DBO.DELIVERYDP DP (nolock)            
          WHERE    FILLER2 = 1            
                   AND DRCR = 'D'            
                   AND DELIVERED = '0'            
                   AND TRTYPE IN (904,909)            
                   AND D.BDPID = DP.DPID            
                   AND D.BCLTDPID = DP.DPCLTNO            
                   AND DESCRIPTION NOT LIKE '%pool%'            
          GROUP BY PARTY_CODE,CERTNO) A            
  WHERE  A.PARTY_CODE = #DELPAYINMATCH.PARTY_CODE            
         AND A.CERTNO = #DELPAYINMATCH.CERTNO            
                                    
  UPDATE #DELPAYINMATCH            
  SET    BSEHOLD = A.HOLD + (CASE             
                               WHEN @StatusId <> 'broker' THEN A.PLEDGE            
                               ELSE 0            
                             END),            
         BSEPLEDGE = (CASE             
                        WHEN @StatusId = 'broker' THEN A.PLEDGE            
                        ELSE 0            
                      END)            
  FROM   (SELECT   PARTY_CODE,            
                   CERTNO,            
                   HOLD = ISNULL(SUM(CASE             
                                       WHEN TRTYPE = 904 THEN QTY            
                                       ELSE 0            
                                     END),0),            
                   PLEDGE = ISNULL(SUM(CASE             
                                         WHEN TRTYPE = 909 THEN QTY            
 ELSE 0            
                                       END),0)            
          FROM     BSEDB.DBO.DELTRANS D (nolock),            
                   BSEDB.DBO.DELIVERYDP DP (nolock)            
          WHERE    FILLER2 = 1            
                   AND DRCR = 'D'            
                   AND DELIVERED = '0'            
                   AND TRTYPE IN (904,909)            
                   AND D.BDPID = DP.DPID            
                   AND D.BCLTDPID = DP.DPCLTNO            
                   AND DESCRIPTION NOT LIKE '%pool%'            
          GROUP BY PARTY_CODE,CERTNO) A            
  WHERE  A.PARTY_CODE = #DELPAYINMATCH.PARTY_CODE            
         AND A.CERTNO = #DELPAYINMATCH.CERTNO            
                                    
  IF UPPER(@Branchcd) = 'All'            
    BEGIN            
      SELECT @Branchcd = '%'            
    END            
                
IF @Opt = 1            
    BEGIN            
      SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED            
                  
      SELECT   SETT_NO,            
               SETT_TYPE,            
               R.PARTY_CODE,            
               C1.SHORT_NAME,            
               C1.BRANCH_CD,            
               C1.SUB_BROKER,            
M.SCRIP_CD,            
               CERTNO,            
               DELQTY = SUM(DELQTY),            
               RECQTY = SUM(RECQTY),            
               ISETTQTYPRINT = SUM(ISETTQTYPRINT),            
               ISETTQTYMARK = SUM(ISETTQTYMARK),            
               IBENQTYPRINT = SUM(IBENQTYPRINT),            
               IBENQTYMARK = SUM(IBENQTYMARK),            
               HOLD = HOLD,            
               PLEDGE = PLEDGE,            
               BSEHOLD = BSEHOLD,            
               BSEPLEDGE = BSEPLEDGE,             
    C1.CL_TYPE             
      FROM     #DELPAYINMATCH R (nolock),            
               MULTIISIN M (nolock),            
               #CLIENT2 C2 (nolock),            
               #CLIENT1 C1 (nolock)            
      WHERE    M.ISIN = R.CERTNO            
               AND SETT_NO = @Sett_No            
               AND SETT_TYPE = @Sett_Type            
               AND R.PARTY_CODE = C2.PARTY_CODE            
               AND C1.CL_CODE = C2.CL_CODE            
               AND C1.BRANCH_CD LIKE @Branchcd            
               AND @StatusName = (CASE             
                                    WHEN @StatusId = 'BRANCH' THEN C1.BRANCH_CD            
                                    WHEN @StatusId = 'SUBBROKER' THEN C1.SUB_BROKER            
                                    WHEN @StatusId = 'Trader' THEN C1.TRADER            
                                    WHEN @StatusId = 'Family' THEN C1.FAMILY            
                                    WHEN @StatusId = 'Area' THEN C1.AREA            
                                    WHEN @StatusId = 'Region' THEN C1.REGION            
                                    WHEN @StatusId = 'Client' THEN C2.PARTY_CODE            
                                    ELSE 'BROKER'            
                                  END)            
               AND C1.CL_TYPE LIKE @ClType             
      GROUP BY SETT_NO,SETT_TYPE,R.PARTY_CODE,C1.SHORT_NAME,           
               C1.BRANCH_CD,C1.SUB_BROKER,M.SCRIP_CD,CERTNO,            
               HOLD,PLEDGE,BSEHOLD,BSEPLEDGE,C1.CL_TYPE             
      HAVING   SUM(DELQTY) > 0            
      ORDER BY C1.BRANCH_CD,            
               C1.SUB_BROKER,            
               R.PARTY_CODE,            
               M.SCRIP_CD            
    END            
  ELSE            
    BEGIN            
      SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED            
                  
      SELECT   SETT_NO,            
               SETT_TYPE,            
               R.PARTY_CODE,            
               C1.SHORT_NAME,            
               C1.BRANCH_CD,            
               C1.SUB_BROKER,            
               M.SCRIP_CD,            
               CERTNO,            
               DELQTY = SUM(DELQTY),            
               RECQTY = SUM(RECQTY),            
               ISETTQTYPRINT = SUM(ISETTQTYPRINT),            
               ISETTQTYMARK = SUM(ISETTQTYMARK),            
               IBENQTYPRINT = SUM(IBENQTYPRINT),            
               IBENQTYMARK = SUM(IBENQTYMARK),            
               HOLD = HOLD,            
               PLEDGE = PLEDGE,            
               BSEHOLD = BSEHOLD,            
              BSEPLEDGE = BSEPLEDGE,             
               C1.CL_TYPE    
---into #temp           
      FROM     #DELPAYINMATCH R (nolock),            
               MULTIISIN M (nolock),            
               #CLIENT2 C2 (nolock),            
               #CLIENT1 C1 (nolock)            
      WHERE    M.ISIN = R.CERTNO            
               AND SETT_NO = @Sett_No            
               AND SETT_TYPE = @Sett_Type            
               AND R.PARTY_CODE = C2.PARTY_CODE            
               AND C1.CL_CODE = C2.CL_CODE            
               AND C1.BRANCH_CD LIKE @Branchcd            
               AND @StatusName = (CASE             
                                    WHEN @StatusId = 'BRANCH' THEN C1.BRANCH_CD            
                                    WHEN @StatusId = 'SUBBROKER' THEN C1.SUB_BROKER            
                                    WHEN @StatusId = 'Trader' THEN C1.TRADER            
                                    WHEN @StatusId = 'Family' THEN C1.FAMILY            
                                    WHEN @StatusId = 'Area' THEN C1.AREA            
                                    WHEN @StatusId = 'Region' THEN C1.REGION            
                                    WHEN @StatusId = 'Client' THEN C2.PARTY_CODE            
                                    ELSE 'BROKER'            
                                  END)            
  AND C1.CL_TYPE LIKE @ClType             
      GROUP BY SETT_NO,SETT_TYPE,R.PARTY_CODE,C1.SHORT_NAME,            
               C1.BRANCH_CD,C1.SUB_BROKER,M.SCRIP_CD,CERTNO,            
               HOLD,PLEDGE,BSEHOLD,BSEPLEDGE,C1.CL_TYPE             
      HAVING   SUM(DELQTY) > (SUM(RECQTY) + SUM(ISETTQTYPRINT) + SUM(IBENQTYPRINT))            
      ORDER BY C1.BRANCH_CD,            
               C1.SUB_BROKER,            
               R.PARTY_CODE,            
               M.SCRIP_CD            
    END   
  
-------------run this part after inserting data into #temp -------------------------------------------  
/*insert into bsedb.dbo.tbl_shortage  
select * from #temp*/

GO
