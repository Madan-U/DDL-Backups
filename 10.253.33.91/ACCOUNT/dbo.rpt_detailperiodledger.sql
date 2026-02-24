-- Object: PROCEDURE dbo.rpt_detailperiodledger
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--rpt_detailperiodledger 'Apr  1 2006','May 18 2006','N2480','vdt'

/****** Object:  Stored Procedure dbo.rpt_detailperiodledger    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_detailperiodledger    Script Date: 11/28/2001 12:23:49 PM ******/

/*
changed by neelambari on 20 oct 2001
added book type

changed by neelambari on 17 oct 2001
chaged date format from varchar to datetime
*/
/*changed by mousami  on 16 oct  2001 
    added hardcoding as l3.naratno=0
    in else part of narration.
    If line no of ledger and ledger3 does not match then  take main narration 
    for main narration line number is 0
*/ 
/*Changed by sheetal on 24 Jan 2001*/
/*removed refno and used vno,vtyp,lno,drcr instead*/
/* report : allpartyledger 
   file : ledgerview.asp
*/
/*displays detail ledger  for a particular party for a particular period*/

/* changed by mousami on 28/08/2001
     added case statement to narration  and matched l.lno with l3.naratno
*/

/*
   changed by mousami on 23/06/2001
   added condition that select entries where vtyp <> 18 	
   this is added because we don't want to take opening entry in detail ledger as we are showing it before this query gets executed 
   so don't take it to avoid duplication
*/
/* changed by mousami on 24/03/2001 
     added  effective date difference condition
     which calculates difference in days between todays date and effective date 
     for finding pending amounts 	
*/

/*changed by mousami on 01/03/2001
removed hardcoding 
for sharedatabase and added hardcoding for account databse*/


CREATE PROCEDURE rpt_detailperiodledger
@fromdt  datetime,
@todt   datetime,
@partycode varchar(10),
@sortby varchar(4)

AS

if @sortby='vdt' 
begin
	select  left(convert(varchar,VDT,103),11), l.vtyp,vno,lno,drcr,
	 dramt=isnull((case drcr when 'd' then vamt end),0), 
	 cramt=isnull((case drcr when 'c' then vamt end),0), balamt,Vdesc,
	 nar=isnull((select top 1 l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO AND l3.naratno=0) ,''),
 	 edt, edtdiff=datediff(d, l.edt , getdate() ) ,displayvdt = left(convert(varchar,VDT,109),11) ,bt.description ,bt.booktype
	 from ledger l, vmast v ,  booktype bt 
	 where  l.vdt >= @fromdt and l.vdt<=@todt + ' 23:59:59'
	 and cltcode = @partycode and l.vtyp=v.vtype 
	 and l.vtyp <> '18'
	and l.vtyp = bt.vtyp
	and l.booktype = bt.booktype
	 order by l.vdt, drcr,l.vtyp
end
else
begin
	select left( convert(varchar,edt,103),11),l.vtyp,vno,lno,drcr,
	 dramt=isnull((case drcr when 'd' then vamt end),0), 
	 cramt=isnull((case drcr when 'c' then vamt end),0), balamt,Vdesc,
	nar=isnull((select top 1 l3.narr from ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO AND l3.naratno=0) ,''),
	edt, edtdiff=datediff(d, l.edt , getdate() )  ,bt.description ,bt.booktype
	 from  ledger l, vmast v ,  booktype bt
	WHERE edt >= @fromdt and edt<=@todt + ' 23:59:59'
	 and CLTCODE=@partycode and l.vtyp=v.vtype 
	 and l.vtyp <> '18'
	and l.vtyp = bt.vtyp
	and l.booktype = bt.booktype
	 order by edt, drcr,l.vtyp

end

GO
