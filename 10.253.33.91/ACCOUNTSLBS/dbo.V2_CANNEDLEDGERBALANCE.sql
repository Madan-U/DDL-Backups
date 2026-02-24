-- Object: PROCEDURE dbo.V2_CANNEDLEDGERBALANCE
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE PROCEDURE V2_CANNEDLEDGERBALANCE(
                @SDATE   VARCHAR(11),
                @EFFDATE VARCHAR(11))

AS

  DECLARE  @@RUNDATE DATETIME
                     
  SET @@RUNDATE = GETDATE()
                  
  TRUNCATE TABLE CANNED_LEDGERBALANCE
  
  INSERT INTO CANNED_LEDGERBALANCE
  SELECT   L.CLTCODE,
           LEDBAL = SUM(CASE 
                          WHEN DRCR = 'D' THEN -(VAMT)
                          ELSE (VAMT)
                        END),
           ENTRYTYPE = 1,
           @@RUNDATE
  FROM     LEDGER L WITH (NOLOCK),
           ACMAST A WITH (NOLOCK)
  WHERE    L.CLTCODE = A.CLTCODE
           AND A.ACCAT = 4
           AND L.VDT BETWEEN @SDATE + ' 00:00:00'
                             AND @EFFDATE + ' 23:59:59'
           AND L.EDT <= @EFFDATE + ' 23:59:59'
  GROUP BY L.CLTCODE
  HAVING   SUM(CASE 
                 WHEN DRCR = 'D' THEN -(VAMT)
                 ELSE (VAMT)
               END) <> 0
                       
  INSERT INTO CANNED_LEDGERBALANCE
  SELECT   L.CLTCODE,
           LEDBAL = SUM(CASE 
                          WHEN DRCR = 'D' THEN -(VAMT)
                          ELSE 0
                        END),
           ENTRYTYPE = 2,
           @@RUNDATE
  FROM     LEDGER L WITH (NOLOCK),
           ACMAST A WITH (NOLOCK)
  WHERE    L.CLTCODE = A.CLTCODE
           AND A.ACCAT = 4
           AND L.VDT BETWEEN @SDATE + ' 00:00:00'
                             AND @EFFDATE + ' 23:59:59'
           AND EDT > @EFFDATE + ' 23:59:59'
  GROUP BY L.CLTCODE
  HAVING   SUM(CASE 
                 WHEN DRCR = 'D' THEN -(VAMT)
                 ELSE 0
               END) <> 0 
           
  INSERT INTO CANNED_LEDGERBALANCE
  SELECT   L.CLTCODE,
           LEDBAL = SUM(CASE 
                          WHEN DRCR = 'D' THEN 0
                          ELSE -(VAMT)
                        END),
           ENTRYTYPE = 3,
           @@RUNDATE
  FROM     LEDGER L WITH (NOLOCK),
           ACMAST A WITH (NOLOCK)
  WHERE    L.CLTCODE = A.CLTCODE
           AND A.ACCAT = 4
           AND L.EDT >= @EFFDATE + ' 23:59:59'
           AND L.VDT < @SDATE
  GROUP BY L.CLTCODE
  HAVING   SUM(CASE 
                 WHEN DRCR = 'D' THEN 0
                 ELSE -(VAMT)
               END) <> 0

GO
