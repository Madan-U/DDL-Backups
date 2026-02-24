-- Object: PROCEDURE dbo.rpt_openingbal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_openingbal    Script Date: 01/19/2002 12:15:15 ******/

/****** Object:  Stored Procedure dbo.rpt_openingbal    Script Date: 01/04/1980 5:06:27 AM ******/


/* report : allpartyledger
    file : ledgerview
    finds opening balance on first day of current financial year for a party
*/
/*modified by neelambari on 17 oct 2001
changed the datatype for vdt from varchar to datetime
*/
/*changed by mousami  on 16 oct  2001 
    added hardcoding as l3.naratno=0
    in else part of narration.
    If line no of ledger and ledger3 does not match then  take main narration 
    for main narration line number is 0
*/   

CREATE PROCEDURE  rpt_openingbal
@vdt varchar(12),
@partycode varchar(10)
AS
	select VDT , vtyp,vno,lno,drcr,
	 vamt, balamt,Vdesc,
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype AND l.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype  AND l.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l.booktype = l3.booktype and l3.naratno=0 ) 
		               end),''),
	 edt, edtdiff=datediff(d, l.edt , getdate() ) 
	 from account.dbo. ledger l, account.dbo.vmast v
	 where  vdt  like  ltrim(@vdt) + '%'  and   vtyp='18'
	 and cltcode = @partycode and l.vtyp=v.vtype 
	 order by vdt, drcr,vtyp

GO
