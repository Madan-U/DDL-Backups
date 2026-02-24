-- Object: PROCEDURE dbo.rpt_openingbal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_openingbal    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.rpt_openingbal    Script Date: 11/28/2001 12:23:50 PM ******/


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
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO AND l.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO  AND l.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l3.naratno=0 ) 
		               end),''),
	 edt, edtdiff=datediff(d, l.edt , getdate() ) 
	 from account.dbo. ledger l, account.dbo.vmast v
	 where  vdt  like  ltrim(@vdt) + '%'  and   vtyp='18'
	 and cltcode = @partycode and l.vtyp=v.vtype 
	 order by vdt, drcr,vtyp

GO
