-- Object: PROCEDURE dbo.angel_Client_receipt_reco
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE PROCEDURE [dbo].[angel_Client_receipt_reco]      
AS      

BEGIN      



 DECLARE @tdate AS DATETIME, @daysbefore AS INT, @prodate AS VARCHAR(11)      
      
 SELECT @tdate = getdate() + 1      
      
 --set @prodate = convert(varchar(11),getdate()-1)        
 SET @prodate = convert(VARCHAR(11), getdate())      
      
 SELECT @daysbefore = datediff(dd, @prodate, getdate()) + 1      
      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
 SELECT t.accno, l.vtyp, l.booktype, l.vno, vdt, tdate = convert(VARCHAR, l.vdt, 103), isnull(L1.ddno, '') ddno, isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr, Dramt = (      
   CASE       
    WHEN upper(l.drcr) = 'D'      
     THEN l.vamt      
    ELSE 0      
    END      
   ), Cramt = (      
   CASE       
    WHEN upper(l.drcr) = 'C'      
     THEN l.vamt      
    ELSE 0      
    END      
   ), treldt = isnull(convert(VARCHAR, L1.reldt, 103), ''), l1.refno, last_Date = getdate()      
 INTO #recodet      
 FROM ledger l(NOLOCK)      
 LEFT OUTER JOIN LEDGER1 L1(NOLOCK)      
  ON l.vtyp = l1.vtyp      
   AND l.booktype = l1.booktype      
   AND l.vno = l1.vno      
   AND l.lno = l1.lno, (      
    SELECT DISTINCT vtyp, booktype, vno, lno, accno = cltcode      
    FROM ledger l WITH (NOLOCK)      
    WHERE EXISTS (      
      SELECT accno      
      FROM angel_bank_accno abc(NOLOCK)      
      WHERE l.cltcode = abc.accno      
      )      
     AND NOT (      
      /* narration LIKE 'BEING AMT RECD TECH PROCESS%' */     
      narration like 'BEING AMT RECEIVED BY ONLINE TRF%'    
      OR narration LIKE 'BEING AMT RECD ING%'      
      )      
    ) t      
 WHERE l.vtyp = t.vtyp      
  AND l.vno = t.vno      
  AND l.booktype = t.booktype      
  -- and (cltcode <> @code        
  AND l.cltcode >= 'A0001'      
  AND l.cltcode <= 'ZZZZZ'      
  AND l.drcr = 'C'      
  AND l.vdt <= @tdate - @daysbefore      
  /* Commented By Shweta On 05/01/2010 --Start        
and clear_mode not in ( 'R', 'C')        
--END*/      
  AND l.vtyp NOT IN (16, 17)      
  AND (      
   l1.reldt = '1900-01-01 00:00:00.000'      
   OR l1.reldt > @tdate      
   )      
      
 --declare @lastdt as datetime        
 --select lastdt=max(reldt) from ledger1        
 CREATE NONCLUSTERED INDEX ix_recodet ON #recodet (accno)      
      
 UPDATE #recodet      
 SET last_Date = b.updt      
 FROM (      
  SELECT l1.accno, updt = max(l.reldt)      
  FROM ledger1 l      
  INNER MERGE JOIN (      
   SELECT vtyp, booktype, vno, lno, accno = cltcode      
   FROM ledger l(NOLOCK)      
   WHERE EXISTS (      
     SELECT accno      
     FROM angel_bank_accno abc(NOLOCK)      
     WHERE l.cltcode = abc.accno      
     )      
   GROUP BY vtyp, booktype, vno, lno, cltcode      
   ) L1      
   ON l.vtyp = l1.vtyp      
    AND l.booktype = l1.booktype      
    AND l.vno = l1.vno      
    AND l.lno = l1.lno      
  GROUP BY l1.accno      
  ) b      
 WHERE #recodet.accno = b.accno      
      
 TRUNCATE TABLE Angel_client_deposit_recno      
      
 INSERT INTO Angel_client_deposit_recno      
 SELECT *      
 FROM #recodet(NOLOCK) -- where ddno<>0        
  --EXEC ANGEL_KNOCKOFF_CANCEL_RECO      
END

GO
