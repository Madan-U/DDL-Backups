-- Object: PROCEDURE dbo.dupsrecord
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure [dbo].[dupsrecord] as 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select 
l.CLTCODE, 
L.VDT, 
l.VNO, 
l.VTYP, 
l.BOOKTYPE, 
l.drcr, 
l.vamt, 
l.narration into 
 #tempnse

from ledger l (nolock),
      (
      SELECT  LED.VTYP, LED.BOOKTYPE, LED.CLTCODE, VDT = CONVERT(VARCHAR(11), VDT), DDNO, NARRATION, LED.DRCR, LED.VAMT
      FROM LEDGER LED (NOLOCK),
      LEDGER1 LED1 (NOLOCK),
      ACMAST A (NOLOCK)
      WHERE LED.VNO = LED1.VNO AND LED.VTYP = LED1.VTYP AND LED.BOOKTYPE = LED1.BOOKTYPE AND LED.LNO = LED1.LNO
      AND VDT >= 'APR  1 2017'
      AND LED.CLTCODE = A.CLTCODE
      AND ACCAT = 4
      AND DDNO <> '0' AND DDNO <> ''
      GROUP BY VAMT, LED.VTYP, LED.BOOKTYPE, LED.CLTCODE, CONVERT(VARCHAR(11), VDT), DDNO, NARRATION, LED.DRCR
      HAVING COUNT(*) > 1
      ) dUP 
WHERE           
L.VAMT = DUP.VAMT
AND L.VTYP = DUP.VTYP
AND L.BOOKTYPE = DUP.BOOKTYPE
AND L.DRCR = DUP.DRCR
AND LEFT(CONVERT(VARCHAR, L.VDT,109),11) =  DUP.VDT
AND L.CLTCODE = DUP.CLTCODE
ORDER BY L.CLTCODE, L.VDT, L.DRCR, L.VAMT, L.VNO, L.BOOKTYPE, L.NARRATION


select a.*,b.ddno
into #tempnseddno
 from #tempnse a, ledger1 b
where
a.vno=b.vno and 
a.VAMT = b.relamt
AND a.VTYP = b.VTYP
AND a.BOOKTYPE = b.BOOKTYPE
AND a.DRCR = b.DRCR 
order by cltcode

---------------------------------------------for bse _-------------------------

select 
l.CLTCODE, 
L.VDT, 
l.VNO, 
l.VTYP, 
l.BOOKTYPE, 
l.drcr, 
l.vamt, 
l.narration into 
 #tempbse

from AngelBSECM.account_ab.dbo.ledger l (nolock),
      (
      SELECT  LED.VTYP, LED.BOOKTYPE, LED.CLTCODE, VDT = CONVERT(VARCHAR(11), VDT), DDNO, NARRATION, LED.DRCR, LED.VAMT
      FROM  AngelBSECM.account_ab.dbo.ledger LED (NOLOCK),
      AngelBSECM.account_ab.dbo.LEDGER1 LED1 (NOLOCK),
      AngelBSECM.account_ab.dbo.ACMAST A (NOLOCK)
      WHERE LED.VNO = LED1.VNO AND LED.VTYP = LED1.VTYP AND LED.BOOKTYPE = LED1.BOOKTYPE AND LED.LNO = LED1.LNO
      AND VDT >= 'APR  1 2017'
      AND LED.CLTCODE = A.CLTCODE
      AND ACCAT = 4
      AND DDNO <> '0' AND DDNO <> ''
      GROUP BY VAMT, LED.VTYP, LED.BOOKTYPE, LED.CLTCODE, CONVERT(VARCHAR(11), VDT), DDNO, NARRATION, LED.DRCR
      HAVING COUNT(*) > 1
      ) dUP 
WHERE           
L.VAMT = DUP.VAMT
AND L.VTYP = DUP.VTYP
AND L.BOOKTYPE = DUP.BOOKTYPE
AND L.DRCR = DUP.DRCR
AND LEFT(CONVERT(VARCHAR, L.VDT,109),11) =  DUP.VDT
AND L.CLTCODE = DUP.CLTCODE
ORDER BY L.CLTCODE, L.VDT, L.DRCR, L.VAMT, L.VNO, L.BOOKTYPE, L.NARRATION


select a.*,b.ddno
into #tempbseddno
 from #tempbse a, AngelBSECM.account_ab.dbo.ledger1 b
where
a.vno=b.vno and 
a.VAMT = b.relamt
AND a.VTYP = b.VTYP
AND a.BOOKTYPE = b.BOOKTYPE
AND a.DRCR = b.DRCR 
order by cltcode


select * from  #tempnseddno
select * from  #tempbseddno

GO
