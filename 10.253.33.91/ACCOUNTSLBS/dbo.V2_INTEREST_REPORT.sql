-- Object: PROCEDURE dbo.V2_INTEREST_REPORT
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROCEDURE V2_INTEREST_REPORT(    
                @FILTER      VARCHAR(11),    
                @INTERESTON  VARCHAR(3),    
                @SEGMENTCODE INT,    
                @DRCR        VARCHAR(3),    
                @FROMDATE    VARCHAR(11),    
                @TODATE      VARCHAR(11),    
                @FROMPARTY   VARCHAR(10),    
                @TOPARTY     VARCHAR(10),    
                @STATUSID    VARCHAR(20),    
                @STATUSNAME  VARCHAR(20))    
    
AS    
    
  /*==============================================================================================================      
        EXEC V2_INTEREST_REPORT      
     @FILTER = 'BRANCH',     
     @INTERESTON = 'VDT',
	@SEGMENTCODE = 0,
 @DRCR = 'C',	     
     @FROMDATE = 'JUN  1 2007',     
  @TODATE = 'JUN  7 2007',     
  @FROMPARTY = '0000000000',     
  @TOPARTY = 'ZZZZZZZZZZ',     
  @STATUSID = 'BROKER',     
  @STATUSNAME = 'BROKER'     
==============================================================================================================*/    
  SET NOCOUNT ON   

  IF (SELECT DATEDIFF(DAY,CONVERT(DATETIME,LEFT(GETDATE() - DAY(GETDATE()),11)),CONVERT(DATETIME,@TODATE))) > 0
  BEGIN
     SELECT 'NO RECORDS FOUND'
	 RETURN
  END
 
  DECLARE  @@FDATE INT,    
           @@TDATE INT    
                       
--  SET @@FDATE = CONVERT(INT,CONVERT(VARCHAR,CONVERT(DATETIME,@FROMDATE),112))    
                    
--  SET @@TDATE = CONVERT(INT,CONVERT(VARCHAR,CONVERT(DATETIME,@TODATE),112))    
                    
  SELECT PARTY_CODE,    
         LONG_NAME    
  INTO   #CLIENT    
  FROM   MSAJAG.DBO.CLIENT_DETAILS C    
  WHERE  1 = 2    
  
                 
  INSERT INTO #CLIENT    
  EXEC V2_ACCOUNT_LISTING    
     @FILTER ,    
     @FROMPARTY ,    
     @TOPARTY ,    
     @STATUSID ,    
     @STATUSNAME    
--SELECT * FROM  #CLIENT  
--RETURN        
  IF @DRCR = 'ALL'    
    BEGIN    
      IF @SEGMENTCODE = 0    
        BEGIN    
          SELECT   CLTCODE = C1.PARTY_CODE,    
                   NSECM = SUM(CASE     
                                 WHEN SEGMENTCODE = 1 THEN (CASE     
                                                              WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                               WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                               ELSE (CASE     
                                                                                                       WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                       ELSE 0    
                                                                                                     END)    
                                                                                             END)    
                                                              ELSE (CASE     
                                                                      WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                              ELSE 0    
                                                                            END)    
                                                                    END)    
                                                            END)    
                                 ELSE 0    
                               END),    
                   BSECM = SUM(CASE     
                                 WHEN SEGMENTCODE = 2 THEN (CASE     
                                                              WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                               WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                               ELSE (CASE     
                                                                         WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                       ELSE 0    
                                                                                                     END)    
                                                                                             END)    
                                                              ELSE (CASE     
                                                                      WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                              ELSE 0    
                                                                            END)    
                                                                    END)    
                                                            END)    
                                 ELSE 0    
                               END),    
                   NSEFO = SUM(CASE     
                                 WHEN SEGMENTCODE = 3 THEN (CASE     
                                                              WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                               WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                               ELSE (CASE     
                                                                                                       WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                       ELSE 0    
                                                                                                     END)    
                                                                                             END)    
                                                              ELSE (CASE     
                                                                      WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                              ELSE 0    
                                                                            END)    
                                                                    END)    
                                                            END)    
                                 ELSE 0    
                               END),    
                   BSEFO = SUM(CASE     
                                 WHEN SEGMENTCODE = 4 THEN (CASE     
                                                              WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                               WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                               ELSE (CASE     
                                                                                                       WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                       ELSE 0    
                                              END)    
                                                                                             END)    
                                                              ELSE (CASE     
                                                                      WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                              ELSE 0    
                                                                            END)    
                                                                    END)    
                                                            END)    
                                 ELSE 0    
                               END),    
                   INTEREST = SUM(CASE     
                                    WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                     WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                     ELSE (CASE     
                                                                             WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                             ELSE 0    
                                                                           END)    
                                                                   END)    
                                    ELSE (CASE     
                                            WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                            ELSE (CASE     
                                                    WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                    ELSE 0    
                                                  END)    
                                          END)    
                                  END),    
                   C1.LONG_NAME    
          FROM     V2_INTEREST V    
                   LEFT OUTER JOIN V2_CLIENTPROFILES_FA F    
                     ON (V.CLTCODE = F.CLTCODE),    
                   (SELECT CREDIT_INT,    
                           DEBIT_INT,    
                           SPAN_MARGIN,    
                           EXPOSURE_MARGIN    
                    FROM   V2_CLIENTPROFILES_FA    
                    WHERE  CLTCODE = 'ALL') A,    
                   MSAJAG.DBO.CLIENT_DETAILS C,    
                   #CLIENT C1    
          WHERE    C.PARTY_CODE = V.CLTCODE    
                   AND V.INTDATE BETWEEN @@FDATE    
                                         AND @@TDATE    
                   AND C1.PARTY_CODE = (CASE     
                                          WHEN @FILTER = 'BRANCH' THEN C.BRANCH_CD    
                                          WHEN @FILTER = 'CLIENT' THEN C.PARTY_CODE    
                                          WHEN @FILTER = 'FAMILY' THEN C.FAMILY    
                                        END)    
                   AND C.PARTY_CODE BETWEEN @FROMPARTY    
                                            AND @TOPARTY    
          GROUP BY C1.PARTY_CODE,C1.LONG_NAME    
        END    
      ELSE    
        BEGIN    
          SELECT   CLTCODE = C1.PARTY_CODE,    
                   NSECM = SUM(CASE     
                                 WHEN SEGMENTCODE = 1 THEN (CASE     
                                 WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                               WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                            ELSE (CASE     
                                                                                                       WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                       ELSE 0    
                                                                                                     END)    
                                                                                             END)    
                                                              ELSE (CASE     
                                                                      WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                              ELSE 0    
                                                                            END)    
                                                                    END)    
                                                            END)    
                                 ELSE 0    
                               END),    
                   BSECM = SUM(CASE     
                                 WHEN SEGMENTCODE = 2 THEN (CASE     
                                                              WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                               WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                               ELSE (CASE     
                                                                                                       WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                       ELSE 0    
                                                                                                     END)    
                                                                                             END)    
                                                              ELSE (CASE     
                                                                      WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                              ELSE 0    
                                                                            END)    
                                                                    END)    
                                                            END)    
                                 ELSE 0    
                               END),    
                   NSEFO = SUM(CASE     
                                 WHEN SEGMENTCODE = 3 THEN (CASE     
                                                              WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                               WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                     ELSE (CASE     
                                                                                                       WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                        ELSE 0    
                                                                                                     END)    
                                                                                             END)    
                                                              ELSE (CASE     
                                                                      WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                              ELSE 0    
                                                                            END)    
                                                                    END)    
                                                            END)    
                                 ELSE 0    
                               END),    
                   BSEFO = SUM(CASE     
                                 WHEN SEGMENTCODE = 4 THEN (CASE     
                                                              WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                               WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                               ELSE (CASE     
                                                                                                       WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                       ELSE 0    
                                                                                                     END)    
                                                                                             END)    
                                                              ELSE (CASE     
                                                                      WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                              ELSE 0    
                                                                            END)    
                                                                    END)    
                                                            END)    
                                 ELSE 0    
                               END),    
                   INTEREST = SUM(CASE     
                                    WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                     WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                     ELSE (CASE     
                                                                             WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                             ELSE 0    
                                                                           END)    
                                                                   END)    
                                    ELSE (CASE     
                                            WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                            ELSE (CASE     
                                                    WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                    ELSE 0    
                                                  END)    
                                          END)    
                                  END),    
                   C1.LONG_NAME    
          FROM     V2_INTEREST V    
                   LEFT OUTER JOIN V2_CLIENTPROFILES_FA F    
                     ON (V.CLTCODE = F.CLTCODE),    
                   (SELECT CREDIT_INT,    
                           DEBIT_INT,    
                           SPAN_MARGIN,    
                           EXPOSURE_MARGIN    
                    FROM   V2_CLIENTPROFILES_FA    
                    WHERE  CLTCODE = 'ALL') A,    
                   MSAJAG.DBO.CLIENT_DETAILS C,    
                   #CLIENT C1    
          WHERE    C.PARTY_CODE = V.CLTCODE    
                   AND V.INTDATE BETWEEN @@FDATE    
                                         AND @@TDATE    
                   AND C1.PARTY_CODE = (CASE     
                                          WHEN @FILTER = 'BRANCH' THEN C.BRANCH_CD    
                                          WHEN @FILTER = 'CLIENT' THEN C.PARTY_CODE    
                                          WHEN @FILTER = 'FAMILY' THEN C.FAMILY    
                                        END)    
                   AND C.PARTY_CODE BETWEEN @FROMPARTY    
                                            AND @TOPARTY    
          GROUP BY C1.PARTY_CODE,C1.LONG_NAME    
          HAVING   SUM(CASE     
                         WHEN SEGMENTCODE = @SEGMENTCODE THEN (CASE     
                                                                 WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                                  WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                                  ELSE (CASE     
                                                                                                          WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                          ELSE 0    
                                                                                                        END)    
                                                                                                END)    
                                                                 ELSE (CASE     
                                                                         WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                         ELSE (CASE     
                                                                                 WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                 ELSE 0    
                                                                               END)    
                                                                       END)    
                                                               END)    
                         ELSE 0    
                       END) <> 0    
        END    
    END    
  ELSE    
    BEGIN    
      IF @SEGMENTCODE = 0    
        BEGIN    
          SELECT CLTCODE,    
                 NSECM,    
                 BSECM,    
                 NSEFO,    
                 BSEFO,    
                 INTEREST,    
                 LONG_NAME    
          FROM   (SELECT   CLTCODE = C1.PARTY_CODE,    
                           NSECM = SUM(CASE     
                                         WHEN SEGMENTCODE = 1 THEN (CASE     
                                                                      WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                                       WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                                       ELSE (CASE     
                                                                                                               WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                               ELSE 0    
                                                                                                             END)    
                                                                                                     END)    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                              ELSE (CASE     
                                                                                      WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                      ELSE 0    
                                                                                    END)    
                                                                            END)    
                                                                    END)    
                                         ELSE 0    
                                       END),    
                           BSECM = SUM(CASE     
                                         WHEN SEGMENTCODE = 2 THEN (CASE     
                                                                      WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                                       WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                                       ELSE (CASE     
                                                                                                               WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                               ELSE 0    
                                                                                                             END)    
                                                                                                     END)    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                              ELSE (CASE     
                                                                                      WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                      ELSE 0    
                                                                                    END)    
                                                                            END)    
              END)    
                                         ELSE 0    
                                       END),    
                           NSEFO = SUM(CASE     
                                         WHEN SEGMENTCODE = 3 THEN (CASE     
                                                                      WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                                       WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                                     ELSE (CASE     
                                                                                                               WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                               ELSE 0    
                                                                                                             END)    
                                                                                                     END)    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                              ELSE (CASE     
                                                                                      WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                      ELSE 0    
                                                                                    END)    
                                                                            END)    
                                                                    END)    
                                         ELSE 0    
                                       END),    
                           BSEFO = SUM(CASE     
                                         WHEN SEGMENTCODE = 4 THEN (CASE     
                                                                      WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                                       WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                                       ELSE (CASE     
                                                                                                               WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                               ELSE 0    
                                                                                                             END)    
                                                                                                     END)    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                              ELSE (CASE     
                                                                                      WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                      ELSE 0    
                                                                                    END)    
                                                                            END)    
                                                                    END)    
                                         ELSE 0    
                                       END),    
                           INTEREST = SUM(CASE     
                                            WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                             WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                             ELSE (CASE     
                                   WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                     ELSE 0    
                                                                                   END)    
                                                                           END)    
                                            ELSE (CASE     
                                                    WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                    ELSE (CASE     
                                                            WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                            ELSE 0    
                                                          END)    
                                                  END)    
                                          END),    
                           C1.LONG_NAME    
                  FROM     V2_INTEREST V    
                           LEFT OUTER JOIN V2_CLIENTPROFILES_FA F    
                             ON (V.CLTCODE = F.CLTCODE),    
                           (SELECT CREDIT_INT,    
                                   DEBIT_INT,    
                                   SPAN_MARGIN,    
                                   EXPOSURE_MARGIN    
                            FROM   V2_CLIENTPROFILES_FA    
                            WHERE  CLTCODE = 'ALL') A,    
                           MSAJAG.DBO.CLIENT_DETAILS C,    
                           #CLIENT C1    
                  WHERE    C.PARTY_CODE = V.CLTCODE    
                           AND V.INTDATE BETWEEN @@FDATE    
                                                 AND @@TDATE    
                           AND C1.PARTY_CODE = (CASE     
                                                  WHEN @FILTER = 'BRANCH' THEN C.BRANCH_CD    
                                                  WHEN @FILTER = 'CLIENT' THEN C.PARTY_CODE    
                                                  WHEN @FILTER = 'FAMILY' THEN C.FAMILY    
                                                END)    
                           AND C.PARTY_CODE BETWEEN @FROMPARTY    
                                                    AND @TOPARTY    
                  GROUP BY C1.PARTY_CODE,C1.LONG_NAME) A    
          WHERE  SIGN(INTEREST) = (CASE @DRCR     
                                     WHEN 'DR' THEN -1    
                                     WHEN 'CR' THEN +1    
                                   END)    
        END    
      ELSE    
        BEGIN    
          SELECT CLTCODE,    
                 NSECM,    
                 BSECM,    
                 NSEFO,    
                 BSEFO,    
                 INTEREST,    
                 LONG_NAME    
          FROM   (SELECT   CLTCODE = C1.PARTY_CODE,    
                           NSECM = SUM(CASE     
                                         WHEN SEGMENTCODE = 1 THEN (CASE     
                                                                      WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                                       WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                  ELSE (CASE     
                                                                                                               WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                               ELSE 0    
                                                                                                             END)    
                                                                                                     END)    
                                                                      ELSE (CASE     
                                                               WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                              ELSE (CASE     
                                                                                      WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                      ELSE 0    
                                                                                    END)    
                                                                            END)    
                                                                    END)    
                                         ELSE 0    
                                       END),    
                           BSECM = SUM(CASE     
                                         WHEN SEGMENTCODE = 2 THEN (CASE     
                                                                      WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                                       WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                                       ELSE (CASE     
                                                                                                               WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                               ELSE 0    
                                                                                                             END)    
                                                                                                     END)    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                              ELSE (CASE     
                                                                                      WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                      ELSE 0    
                                                                                    END)    
                                                                            END)    
                                                                    END)    
                                         ELSE 0    
                                       END),    
                           NSEFO = SUM(CASE     
                                         WHEN SEGMENTCODE = 3 THEN (CASE     
                                                                      WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                                       WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                 ELSE (CASE     
                                                                                                               WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                               ELSE 0    
                                                                                                             END)    
                                                                                                     END)    
                                                                      ELSE (CASE     
                                                 WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                              ELSE (CASE     
                                                                                      WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                      ELSE 0    
                                                                                    END)    
                                                                            END)    
                                                                    END)    
                                         ELSE 0    
                                       END),    
                           BSEFO = SUM(CASE     
                                         WHEN SEGMENTCODE = 4 THEN (CASE     
                                                                      WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                                       WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                                       ELSE (CASE     
                                                                                                               WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                               ELSE 0    
                                                                                                             END)    
                                                                                                     END)    
                                                                      ELSE (CASE     
                                                                              WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                              ELSE (CASE     
                                                                                      WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                      ELSE 0    
                                                                                    END)    
                                                                            END)    
                                                                    END)    
                                         ELSE 0    
                                       END),    
                           INTEREST = SUM(CASE     
                                            WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                             WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                             ELSE (CASE     
                                                              WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                     ELSE 0    
                                                                                   END)    
                                                                           END)    
                                            ELSE (CASE     
                                                    WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                    ELSE (CASE     
                                                            WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                            ELSE 0    
                                                          END)    
                                                  END)    
                                          END),    
                           C1.LONG_NAME    
                  FROM     V2_INTEREST V    
                           LEFT OUTER JOIN V2_CLIENTPROFILES_FA F    
                             ON (V.CLTCODE = F.CLTCODE),    
                           (SELECT CREDIT_INT,    
                                   DEBIT_INT,    
                                   SPAN_MARGIN,    
                                   EXPOSURE_MARGIN    
                            FROM   V2_CLIENTPROFILES_FA    
                            WHERE  CLTCODE = 'ALL') A,    
                           MSAJAG.DBO.CLIENT_DETAILS C,    
                           #CLIENT C1    
                  WHERE    C.PARTY_CODE = V.CLTCODE    
                           AND V.INTDATE BETWEEN @@FDATE    
                                                 AND @@TDATE    
                           AND C1.PARTY_CODE = (CASE     
                                                  WHEN @FILTER = 'BRANCH' THEN C.BRANCH_CD    
                                                  WHEN @FILTER = 'CLIENT' THEN C.PARTY_CODE    
                                                  WHEN @FILTER = 'FAMILY' THEN C.FAMILY    
                                                END)    
                           AND C.PARTY_CODE BETWEEN @FROMPARTY    
                                                    AND @TOPARTY    
                  GROUP BY C1.PARTY_CODE,C1.LONG_NAME    
                  HAVING   SUM(CASE     
                                 WHEN SEGMENTCODE = @SEGMENTCODE THEN (CASE     
                                                                         WHEN @INTERESTON = 'VDT' THEN (CASE     
                                                                                                          WHEN VDTBAL > 0 THEN ((VDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                                          ELSE (CASE     
                                                                                                                  WHEN VDTBAL < 0 THEN ((VDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                                                  ELSE 0    
                                                                                                                END)    
                                                                                                        END)    
                                                                         ELSE (CASE     
                                                                                 WHEN EDTBAL > 0 THEN ((EDTBAL * ISNULL(F.CREDIT_INT,A.CREDIT_INT)) / 100) / 365    
                                                                                 ELSE (CASE     
                                                                                         WHEN EDTBAL < 0 THEN ((EDTBAL * ISNULL(F.DEBIT_INT,A.DEBIT_INT)) / 100) / 365    
                                                                                         ELSE 0    
                                                                                       END)    
                                                                               END)    
                                                                       END)    
                                 ELSE 0    
                               END) <> 0) A    
          WHERE  SIGN(INTEREST) = (CASE @DRCR     
                                     WHEN 'DR' THEN -1    
                                     WHEN 'CR' THEN +1    
                                   END)    
        END    
    END

GO
