-- Object: PROCEDURE dbo.rpt_ledgerbillentry
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--sp_helptext rpt_ledgerbillentry '15','200604030003','19','C','A1485'

 /****** Object:  Stored Procedure dbo.rpt_ledgerbillentry    Script Date: 01/04/1980 1:40:42 AM ******/  
  
  
  
/****** Object:  Stored Procedure dbo.rpt_ledgerbillentry    Script Date: 11/28/2001 12:23:50 PM ******/  
  
  
/****** Object:  Stored Procedure dbo.rpt_ledgerbillentry    Script Date: 2/17/01 5:19:50 PM ******/  
  
  
/****** Object:  Stored Procedure dbo.rpt_ledgerbillentry    Script Date: 04/27/2001 4:32:44 PM ******/  
/*changed by mousami  on 16 oct  2001   
    added hardcoding as l3.naratno=0  
    in else part of narration.  
    If line no of ledger and ledger3 does not match then  take main narration   
    for main narration line number is 0  
*/   
  
/*changed by mousami on  aug 2 2001   
    added ledger3 join so that we can get narration from ledger3 which gives details about to which exchange a particular bill belongs to   
*/  
  
/*selects details of bill entry for a client code from ledger */  
/*  
changed by mousami on 01/03/2001  
added hardcoding for account databse */  
   
CREATE PROCEDURE rpt_ledgerbillentry  
@vtyp smallint,   
@vno varchar(12),  
@lno numeric,  
@drcr varchar(1),  
@cltcode varchar(10)  
AS  
  
SELECT BNKNAME, L.VTYP,L.VNO,L.LNO,L.DRCR, L.CLTCODE ,  
 narr=isnull((case when (select top 1 l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO AND l.lno = l3.naratno) is  not null  
                 then (select top 1 l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO  AND l.lno = l3.naratno)   
                 else (select top 1 l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and  l3.naratno = 0 )   
                 end),'')  
fROM account.dbo.LEDGER L, account.dbo.LEDGER1 L1  
WHERE l1.vtyp = @vtyp  and l1.vno = @vno  
and l1.lno = @lno  and l1.drcr = @drcr  
and l.vtyp='15' and cltcode= @cltcode  
and l.vtyp=l1.vtyp and l.vno = l1.vno  
and l.lno = l1.lno and l.drcr = l1.drcr  
  
/*  
 SELECT BNKNAME, L.VTYP,L.VNO,L.LNO,L.DRCR, L.CLTCODE   
 FROM account.dbo. LEDGER L,account.dbo. LEDGER1 L1 WHERE   
 l1.vtyp = @vtyp  and l1.vno = @vno  
 and l1.lno = @lno  and l1.drcr = @drcr  
 and l.vtyp='15' and cltcode=@cltcode   
 and l.vtyp=l1.vtyp and l.vno = l1.vno  
 and l.lno = l1.lno and l.drcr = l1.drcr  
*/  
/*CREATE PROCEDURE rpt_ledgerbillentry  
@refno varchar(12),  
@cltcode varchar(10)  
AS  
SELECT BNKNAME, L.REFNO, L.CLTCODE   
FROM LEDGER L, LEDGER1 L1 WHERE l1.REFNO=@refno   
and vtyp='15' and cltcode=@cltcode and left(l.refno,7)=left(l1.refno,7)*/

GO
