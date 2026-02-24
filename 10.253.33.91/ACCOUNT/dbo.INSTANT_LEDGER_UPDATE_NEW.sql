-- Object: PROCEDURE dbo.INSTANT_LEDGER_UPDATE_NEW
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC [dbo].[INSTANT_LEDGER_UPDATE_NEW]       
      
@FROMDATE datetime      
      
AS    

SELECT * ,       ROW_NUMBER()       
         OVER (       
           ORDER BY EXCHANGE,CNEWVOUCHER)           AS NROWID 

FROM (
      
SELECT ( CASE       
           WHEN DBACTION = 'MODIFIED' THEN 'U'       
           WHEN DBACTION = 'DELETED' THEN 'D'       
           ELSE 'I'       
         END )                     AS COPERATIONTYPE,      
        CONVERT(varchar(10),ISNULL(PDT, OLDVDT),103)         AS DTRANSACTIONDATE,       
       ''                          AS COLDFIRMNUMBER,       
       ''                          AS CNEWFIRMNUMBER,       
       ( CASE       
           WHEN ( ( OLDCLTCODE = CLTCODE )       
                   OR ( OLDCLTCODE IS NULL )       
                   OR ( DBACTION = 'DELETED' ) ) THEN ''       
           ELSE OLDCLTCODE       
         END )                     AS COLDACCOUNTCODE,       
       ISNULL(CLTCODE, OLDCLTCODE) AS CNEWACCOUNTCODE,       
       ISNULL(VNO, OLDVNO)         AS CNEWVOUCHER,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'D' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDDRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'D' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'D' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWDRAMOUNT,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'C' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDCRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'C' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'C' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWCRAMOUNT,       
       ''                          AS COLDEXCHANGE,       
       'NSE'                       AS EXCHANGE,       
       'N'                         AS CNEWEXCHANGE       
      
FROM   (SELECT A.*,       
               B.CLTCODE AS OLDCLTCODE,       
               B.VAMT    AS OLDAMT,       
               DBACTION,       
               B.VDT     AS OLDVDT,       
               B.VNO     AS OLDVNO,       
               B.DRCR    AS OLDDRCR       
        FROM   (SELECT a.*       
                FROM   LEDGER  A , ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4 ) A       
               FULL OUTER JOIN (SELECT a.CLTCODE,       
                                       VAMT,       
                                       DRCR,       
                                       VTYP,       
                                       DBACTION,       
                                       VNO,       
                                       PDT,       
                                       VDT       
                                FROM   LEDGER_TRIG as a ,ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4        
                                )B       
                            ON A.CLTCODE = B.CLTCODE       
                               AND A.VTYP = B.VTYP       
                               AND A.VNO = B.VNO       
                               AND A.DRCR = B.DRCR)A 

-------------------------------------NSE CM ------------------------------

UNION ALL

SELECT ( CASE       
           WHEN DBACTION = 'MODIFIED' THEN 'U'       
           WHEN DBACTION = 'DELETED' THEN 'D'       
           ELSE 'I'       
         END )                     AS COPERATIONTYPE,      
        CONVERT(varchar(10),ISNULL(PDT, OLDVDT),103)         AS DTRANSACTIONDATE,       
       ''                          AS COLDFIRMNUMBER,       
       ''                          AS CNEWFIRMNUMBER,       
       ( CASE       
           WHEN ( ( OLDCLTCODE = CLTCODE )       
                   OR ( OLDCLTCODE IS NULL )       
                   OR ( DBACTION = 'DELETED' ) ) THEN ''       
           ELSE OLDCLTCODE       
         END )                     AS COLDACCOUNTCODE,       
       ISNULL(CLTCODE, OLDCLTCODE) AS CNEWACCOUNTCODE,       
       ISNULL(VNO, OLDVNO)         AS CNEWVOUCHER,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'D' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDDRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'D' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'D' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWDRAMOUNT,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'C' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDCRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'C' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'C' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWCRAMOUNT,       
       ''                          AS COLDEXCHANGE,       
       'BSE'                       AS EXCHANGE,       
       'N'                         AS CNEWEXCHANGE       
     
FROM   (SELECT A.*,       
               B.CLTCODE AS OLDCLTCODE,       
               B.VAMT    AS OLDAMT,       
               DBACTION,       
               B.VDT     AS OLDVDT,       
               B.VNO     AS OLDVNO,       
               B.DRCR    AS OLDDRCR       
        FROM   (SELECT a.*       
                FROM   AngelBSECM.ACCOUNT_AB.DBO.LEDGER  A , AngelBSECM.ACCOUNT_AB.DBO.ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4 ) A       
               FULL OUTER JOIN (SELECT a.CLTCODE,       
                                       VAMT,       
                                       DRCR,       
                                       VTYP,       
                                       DBACTION,       
                                       VNO,       
                                       PDT,       
                                       VDT       
                                FROM   AngelBSECM.ACCOUNT_AB.DBO.LEDGER_TRIG as a ,AngelBSECM.ACCOUNT_AB.DBO.ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4        
                                )B       
                            ON A.CLTCODE = B.CLTCODE       
                               AND A.VTYP = B.VTYP       
                               AND A.VNO = B.VNO       
                               AND A.DRCR = B.DRCR)A 

--------------------------------------------BSECM--------------------------------------------------------------
UNION ALL
SELECT ( CASE       
           WHEN DBACTION = 'MODIFIED' THEN 'U'       
           WHEN DBACTION = 'DELETED' THEN 'D'       
           ELSE 'I'       
         END )                     AS COPERATIONTYPE,      
        CONVERT(varchar(10),ISNULL(PDT, OLDVDT),103)         AS DTRANSACTIONDATE,       
       ''                          AS COLDFIRMNUMBER,       
       ''                          AS CNEWFIRMNUMBER,       
       ( CASE       
           WHEN ( ( OLDCLTCODE = CLTCODE )       
                   OR ( OLDCLTCODE IS NULL )       
                   OR ( DBACTION = 'DELETED' ) ) THEN ''       
           ELSE OLDCLTCODE       
         END )                     AS COLDACCOUNTCODE,       
       ISNULL(CLTCODE, OLDCLTCODE) AS CNEWACCOUNTCODE,       
       ISNULL(VNO, OLDVNO)         AS CNEWVOUCHER,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'D' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDDRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'D' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'D' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWDRAMOUNT,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'C' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDCRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'C' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'C' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWCRAMOUNT,       
       ''                          AS COLDEXCHANGE,       
       'NSEF'                       AS EXCHANGE,       
       'N'                         AS CNEWEXCHANGE
       
FROM   (SELECT A.*,       
               B.CLTCODE AS OLDCLTCODE,       
               B.VAMT    AS OLDAMT,       
               DBACTION,       
               B.VDT     AS OLDVDT,       
               B.VNO     AS OLDVNO,       
               B.DRCR    AS OLDDRCR       
        FROM   (SELECT a.*       
                FROM   ANGELFO.ACCOUNTFO.DBO.LEDGER  A , ANGELFO.ACCOUNTFO.DBO.ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4 ) A       
               FULL OUTER JOIN (SELECT a.CLTCODE,       
                                       VAMT,       
                                       DRCR,       
                                       VTYP,       
                                       DBACTION,       
                                       VNO,       
                                       PDT,       
                                       VDT       
                                FROM  ANGELFO.ACCOUNTFO.DBO.LEDGER_TRIG as a ,ANGELFO.ACCOUNTFO.DBO.ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4        
                                )B       
                            ON A.CLTCODE = B.CLTCODE       
                               AND A.VTYP = B.VTYP       
                               AND A.VNO = B.VNO       
                               AND A.DRCR = B.DRCR)A 

-------------------------------------------NSEFO-----------------------------------------------------
UNION ALL
SELECT ( CASE       
           WHEN DBACTION = 'MODIFIED' THEN 'U'       
           WHEN DBACTION = 'DELETED' THEN 'D'       
           ELSE 'I'       
         END )                     AS COPERATIONTYPE,      
        CONVERT(varchar(10),ISNULL(PDT, OLDVDT),103)         AS DTRANSACTIONDATE,       
       ''                          AS COLDFIRMNUMBER,       
       ''                          AS CNEWFIRMNUMBER,       
       ( CASE       
           WHEN ( ( OLDCLTCODE = CLTCODE )       
                   OR ( OLDCLTCODE IS NULL )       
                   OR ( DBACTION = 'DELETED' ) ) THEN ''       
           ELSE OLDCLTCODE       
         END )                     AS COLDACCOUNTCODE,       
       ISNULL(CLTCODE, OLDCLTCODE) AS CNEWACCOUNTCODE,       
       ISNULL(VNO, OLDVNO)         AS CNEWVOUCHER,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'D' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDDRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'D' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'D' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWDRAMOUNT,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'C' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDCRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'C' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'C' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWCRAMOUNT,       
       ''                          AS COLDEXCHANGE,       
       'NSEC'                       AS EXCHANGE,       
       'N'                         AS CNEWEXCHANGE 
FROM   (SELECT A.*,       
               B.CLTCODE AS OLDCLTCODE,       
               B.VAMT    AS OLDAMT,       
               DBACTION,       
               B.VDT     AS OLDVDT,       
               B.VNO     AS OLDVNO,       
               B.DRCR    AS OLDDRCR       
        FROM   (SELECT a.*       
                FROM   ANGELFO.ACCOUNTCURFO.DBO.LEDGER  A , ANGELFO.ACCOUNTCURFO.DBO.ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4 ) A       
               FULL OUTER JOIN (SELECT a.CLTCODE,       
                                       VAMT,       
                                       DRCR,       
                                       VTYP,       
                                       DBACTION,       
                                       VNO,       
                                       PDT,       
                                       VDT       
                                FROM  ANGELFO.ACCOUNTCURFO.DBO.LEDGER_TRIG as a ,ANGELFO.ACCOUNTCURFO.DBO.ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4        
                                )B       
                            ON A.CLTCODE = B.CLTCODE       
                               AND A.VTYP = B.VTYP       
                               AND A.VNO = B.VNO       
                               AND A.DRCR = B.DRCR)A 

---------------------------------------NSE CURFO---------------------------------------------------
UNION ALL
SELECT ( CASE       
           WHEN DBACTION = 'MODIFIED' THEN 'U'       
           WHEN DBACTION = 'DELETED' THEN 'D'       
           ELSE 'I'       
         END )                     AS COPERATIONTYPE,      
        CONVERT(varchar(10),ISNULL(PDT, OLDVDT),103)         AS DTRANSACTIONDATE,       
       ''                          AS COLDFIRMNUMBER,       
       ''                          AS CNEWFIRMNUMBER,       
       ( CASE       
           WHEN ( ( OLDCLTCODE = CLTCODE )       
                   OR ( OLDCLTCODE IS NULL )       
                   OR ( DBACTION = 'DELETED' ) ) THEN ''       
           ELSE OLDCLTCODE       
         END )                     AS COLDACCOUNTCODE,       
       ISNULL(CLTCODE, OLDCLTCODE) AS CNEWACCOUNTCODE,       
       ISNULL(VNO, OLDVNO)         AS CNEWVOUCHER,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'D' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDDRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'D' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'D' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWDRAMOUNT,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'C' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDCRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'C' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'C' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWCRAMOUNT,       
       ''                          AS COLDEXCHANGE,       
       'MCX'                       AS EXCHANGE,       
       'N'                         AS CNEWEXCHANGE 
FROM   (SELECT A.*,       
               B.CLTCODE AS OLDCLTCODE,       
               B.VAMT    AS OLDAMT,       
               DBACTION,       
               B.VDT     AS OLDVDT,       
               B.VNO     AS OLDVNO,       
               B.DRCR    AS OLDDRCR       
        FROM   (SELECT a.*       
                FROM   ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER  A , ANGELCOMMODITY.ACCOUNTMCDX.DBO.ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4 ) A       
               FULL OUTER JOIN (SELECT a.CLTCODE,       
                                       VAMT,       
                                       DRCR,       
                                       VTYP,       
                                       DBACTION,       
                                       VNO,       
                                       PDT,       
                                       VDT       
                                FROM  ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER_TRIG as a ,ANGELCOMMODITY.ACCOUNTMCDX.DBO.ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4        
                                )B       
                            ON A.CLTCODE = B.CLTCODE       
                               AND A.VTYP = B.VTYP       
                               AND A.VNO = B.VNO       
                               AND A.DRCR = B.DRCR)A 

-------------------------------------------MCX-------------------------------------------------------------------------------------------------			       -

UNION ALL
SELECT ( CASE       
           WHEN DBACTION = 'MODIFIED' THEN 'U'       
           WHEN DBACTION = 'DELETED' THEN 'D'       
           ELSE 'I'       
         END )                     AS COPERATIONTYPE,      
        CONVERT(varchar(10),ISNULL(PDT, OLDVDT),103)         AS DTRANSACTIONDATE,       
       ''                          AS COLDFIRMNUMBER,       
       ''                          AS CNEWFIRMNUMBER,       
       ( CASE       
           WHEN ( ( OLDCLTCODE = CLTCODE )       
                   OR ( OLDCLTCODE IS NULL )       
                   OR ( DBACTION = 'DELETED' ) ) THEN ''       
           ELSE OLDCLTCODE       
         END )                     AS COLDACCOUNTCODE,       
       ISNULL(CLTCODE, OLDCLTCODE) AS CNEWACCOUNTCODE,       
       ISNULL(VNO, OLDVNO)         AS CNEWVOUCHER,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'D' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDDRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'D' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'D' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWDRAMOUNT,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'C' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDCRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'C' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'C' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWCRAMOUNT,       
       ''                          AS COLDEXCHANGE,       
       'MCXC'                       AS EXCHANGE,       
       'N'                         AS CNEWEXCHANGE 
FROM   (SELECT A.*,       
               B.CLTCODE AS OLDCLTCODE,       
               B.VAMT    AS OLDAMT,       
               DBACTION,       
               B.VDT     AS OLDVDT,       
               B.VNO     AS OLDVNO,       
               B.DRCR    AS OLDDRCR       
        FROM   (SELECT a.*       
                FROM   ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER  A , ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4 ) A       
               FULL OUTER JOIN (SELECT a.CLTCODE,       
                                       VAMT,       
                                       DRCR,       
                                       VTYP,       
                                       DBACTION,       
                                       VNO,       
                                       PDT,       
                                       VDT       
                                FROM  ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER_TRIG as a ,ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4        
                                )B       
                            ON A.CLTCODE = B.CLTCODE       
                               AND A.VTYP = B.VTYP       
                               AND A.VNO = B.VNO       
                               AND A.DRCR = B.DRCR)A 

---------------------------------------MCX CURRENCY----------------------------------------------------------


UNION ALL
SELECT ( CASE       
           WHEN DBACTION = 'MODIFIED' THEN 'U'       
           WHEN DBACTION = 'DELETED' THEN 'D'       
           ELSE 'I'       
         END )                     AS COPERATIONTYPE,      
        CONVERT(varchar(10),ISNULL(PDT, OLDVDT),103)         AS DTRANSACTIONDATE,       
       ''                          AS COLDFIRMNUMBER,       
       ''                          AS CNEWFIRMNUMBER,       
       ( CASE       
           WHEN ( ( OLDCLTCODE = CLTCODE )       
                   OR ( OLDCLTCODE IS NULL )       
                   OR ( DBACTION = 'DELETED' ) ) THEN ''       
           ELSE OLDCLTCODE       
         END )                     AS COLDACCOUNTCODE,       
       ISNULL(CLTCODE, OLDCLTCODE) AS CNEWACCOUNTCODE,       
       ISNULL(VNO, OLDVNO)         AS CNEWVOUCHER,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'D' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDDRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'D' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'D' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWDRAMOUNT,       
       ( CASE       
           WHEN DBACTION = 'DELETED' THEN 0       
           ELSE ( CASE       
                    WHEN ( VAMT = OLDAMT       
                           AND DRCR = 'C' )THEN 0       
                    ELSE ISNULL(OLDAMT, 0)       
                  END )       
         END )                     AS NOLDCRAMOUNT,       
       CASE       
         WHEN ( DBACTION = 'DELETED'       
                AND OLDDRCR = 'C' ) THEN OLDAMT       
         ELSE ( CASE       
                  WHEN DRCR = 'C' THEN VAMT       
                  ELSE 0       
                END )       
       END                         AS NNEWCRAMOUNT,       
       ''                          AS COLDEXCHANGE,       
       'NCDX'                       AS EXCHANGE,       
       'N'                         AS CNEWEXCHANGE
FROM   (SELECT A.*,       
               B.CLTCODE AS OLDCLTCODE,       
               B.VAMT    AS OLDAMT,       
               DBACTION,       
               B.VDT     AS OLDVDT,       
               B.VNO     AS OLDVNO,       
               B.DRCR    AS OLDDRCR       
        FROM   (SELECT a.*       
                FROM   ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER  A , ANGELCOMMODITY.ACCOUNTNCDX.DBO.ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4 ) A       
               FULL OUTER JOIN (SELECT a.CLTCODE,       
                                       VAMT,       
                                       DRCR,       
                                       VTYP,       
                                       DBACTION,       
                                       VNO,       
                                       PDT,       
                                       VDT       
                                FROM  ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER_TRIG as a ,ANGELCOMMODITY.ACCOUNTNCDX.DBO.ACMAST  B     
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4        
                                )B       
                            ON A.CLTCODE = B.CLTCODE       
                               AND A.VTYP = B.VTYP       
                               AND A.VNO = B.VNO       
                               AND A.DRCR = B.DRCR)A ) TOTAL
--------------------------------------------NCDX------------------------------------------------------------

GO
