-- Object: PROCEDURE dbo.ANGEL_KNOCKOFF_CANCEL_RECO
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE ANGEL_KNOCKOFF_CANCEL_RECO
AS

select * into #bse_dr from ledger where vdt >='Aug  1 2007 00:00' and vtyp=3 and drcr='D' 
and cltcode>='A0001' and cltcode<='ZZZZZ'

select ddno,vno,lno into #chqnodr from ledger1 where vtyp=3 and vno >='200708010000'  
  
select a.*,b.ddno into #bse1dr from #bse_dr a, #chqnodr b where a.vno=b.vno and a.lno=b.lno  


DELETE FROM Angel_client_deposit_recno WHERE ACCNO+'|'+VNO+'|'+DDNO+'|'+CLTCODE IN
(
select A.ACCNO+'|'+A.VNO+'|'+A.DDNO+'|'+A.CLTCODE from Angel_client_deposit_recno a, #bse1dr b 
where a.cltcode=b.cltcode and a.ddno=b.ddno and a.Cramt=b.vamt
)

GO
