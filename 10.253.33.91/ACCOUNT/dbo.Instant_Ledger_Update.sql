-- Object: PROCEDURE dbo.Instant_Ledger_Update
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC INSTANT_LEDGER_UPDATE     
    
@FROMDATE datetime    
    
AS    
    
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
       'NSE'                       AS EXCHNAGE,     
       'N'                         AS CNEWEXCHANGE,     
       ROW_NUMBER()     
         OVER (     
           ORDER BY VNO)           AS NROWID     
FROM   (SELECT A.*,     
               B.CLTCODE AS OLDCLTCODE,     
               B.VAMT    AS OLDAMT,     
               DBACTION,     
               B.VDT     AS OLDVDT,     
               B.VNO     AS OLDVNO,     
               B.DRCR    AS OLDDRCR     
        FROM   (SELECT a.*     
                FROM   LEDGER (NOLOCK) A , ACMAST (NOLOCK) B   
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4 ) A     
               FULL OUTER JOIN (SELECT a.CLTCODE,     
                                       VAMT,     
                                       DRCR,     
                                       VTYP,     
                                       DBACTION,     
                                       VNO,     
                                       PDT,     
                                       VDT     
                                FROM   LEDGER_TRIG(NOLOCK) as a ,ACMAST (NOLOCK) B   
                WHERE  PDT >= @FROMDATE AND A.CLTCODE=B.cltcode AND accat=4      
                                )B     
                            ON A.CLTCODE = B.CLTCODE     
                               AND A.VTYP = B.VTYP     
                               AND A.VNO = B.VNO     
                               AND A.DRCR = B.DRCR)A

GO
