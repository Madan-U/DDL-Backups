-- Object: PROCEDURE dbo.rpt_allparty
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_allparty    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_allparty    Script Date: 11/28/2001 12:23:46 PM ******/


/* report : allpartyledger 
   file :allparty.asp
*/
/*
Modified by neelambari on 17 oct 2001
changed date format to date time fom varchar

changed by mousami  on 16 oct  2001 
    added hardcoding as l3.naratno=0
    in else part of narration.
    If line no of ledger and ledger3 does not match then  take main narration 
    for main narration line number is 0
*/ 
/*modified by neelambari on 5 sept 2001
made changes for sort by date = vdt /edt
*/
/*changed by mousami on 16/08/2001
    removed client1 and client2 join from query
    as there is no need to cross check with client2
   for query other than  family login 
*/    
/*displays detail ledger  for  all parties for a particular cl code */
/* changed by mousami  on 25 june 2001
    added condition that don't take opening entry in detail ledger 
    as we have given its effect in previous queries
*/
/* changed by mousami on 09/02/2001* added family login */

/*changed by mousami on 01/03/2001
removed hardcoding 
for sharedatabase and added hardcoding for account databse*/

/* changed by mousami on 24/03/2001 
     added  effective date difference condition
     which calculates difference in days between todays date and effective date 
     for finding pending amounts 	
*/
 

CREATE PROCEDURE rpt_allparty
@sortbydate varchar(4),
@acname varchar(35),
@fromdt datetime,
@todt datetime,
@statusid varchar(15),
@statusname varchar(25)

AS
if @sortbydate = 'vdt'
begin
if @statusid='family'
begin
	select convert(varchar,l.vdt,103), c2.party_code, vdesc,
	dramt=isnull((case drcr when 'd' then vamt end),0),
	cramt=isnull((case drcr when 'c' then vamt end),0), 
	l.vamt,l.vtyp,l.vno,l.lno,l.drcr, balamt,l.vtyp, 
	nar=isnull((select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO AND l3.naratno=0) ,''),
	edt, edtdiff=datediff(d, l.edt , getdate())  , bt.BookType , bt.Description
	from account.dbo.ledger l, account.dbo.vmast, client2 c2, client1 c1 , account.dbo.booktype bt
	where l.acname = c1.short_Name 
	and c1.cl_code = c2.cl_code
	and c2.party_code=l.cltcode
	 and l.vtyp=vtype 
	and c1.family=@statusname
	and vdt>=@fromdt 
	and vdt<=@todt+ ' 23:59:59'                                        /* put space before 23:59:59'*/ 
	and l.vtyp <> '18'
	and l.vtyp = bt.vtyp
	and l.booktype = bt.booktype
	order by l.vdt 

end
else
begin
	select convert(varchar,l.vdt,103),l.cltcode, vdesc,
	dramt=isnull((case drcr when 'd' then vamt end),0),
	cramt=isnull((case drcr when 'c' then vamt end),0), 
	l.vamt,l.vtyp,l.vno,l.lno,l.drcr, balamt, l.vtyp, 
	nar=isnull((select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO AND l3.naratno=0) ,''),
	edt, edtdiff=datediff(d, l.edt , getdate()), bt.BookType , bt.Description
	from account.dbo. ledger l, account.dbo.vmast ,  account.dbo.booktype bt
	where l.vtyp=vtype
	and l.acname =@acname
	and vdt>=@fromdt
	and vdt<=@todt+ ' 23:59:59'                                        /* put space before 23:59:59'*/ 
	and l.vtyp <> '18'
	and l.vtyp = bt.vtyp
	and l.booktype = bt.booktype
	order by l.vdt 

end 
end /*if sortbydate = vdt*/


/* the part below is executed if @sortbydate =edt*/
if @sortbydate = 'edt'
begin
if @statusid='family'
begin
	select vdt=convert(varchar,l.edt,103), c2.party_code, vdesc,
	dramt=isnull((case drcr when 'd' then vamt end),0),
	cramt=isnull((case drcr when 'c' then vamt end),0), 
	l.vamt,l.vtyp,l.vno,l.lno,l.drcr, balamt, l.vtyp, 
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO AND l.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO  AND l.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO and l3.naratno=0) 
		               end),''),
	edt, edtdiff=datediff(d, l.edt , getdate())  , bt.BookType , bt.Description
	from account.dbo.ledger l, account.dbo.vmast, client2 c2, client1 c1,  account.dbo.booktype bt
	where l.acname = c1.short_Name 
	and c1.cl_code = c2.cl_code
	and c2.party_code=l.cltcode
	 and l.vtyp=vtype and c1.family=@statusname
	and edt>=@fromdt 
	and edt<=@todt+ ' 23:59:59'                                     /* put space before 23:59:59'*/ 
	and l.vtyp <> '18'
	and l.vtyp = bt.vtyp
	and l.booktype = bt.booktype
	order by l.edt

end
else
begin
	select vdt=convert(varchar,l.edt,103),l.cltcode, vdesc,
	dramt=isnull((case drcr when 'd' then vamt end),0),
	cramt=isnull((case drcr when 'c' then vamt end),0), 
	l.vamt,l.vtyp,l.vno,l.lno,l.drcr, balamt, l.vtyp, 
	 nar=isnull((case when (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO AND l.lno = l3.naratno) is  not null
		               then (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO  AND l.lno = l3.naratno) 
		               else (select l3.narr from account.dbo.ledger3 l3  where L.VTYP = L3.VTYP AND L.VNO = L3.VNO  and l3.naratno=0) 
		               end),''),
	edt, edtdiff=datediff(d, l.edt , getdate())   , bt.BookType , bt.Description
	from account.dbo. ledger l, account.dbo.vmast  ,account.dbo.booktype bt
	where l.vtyp=vtype 
	and l.acname =@acname
	and edt>=@fromdt
	 and edt<=@todt+ ' 23:59:59'                                        /* put space before 23:59:59'*/ 
	and l.vtyp <> '18'
	and l.vtyp = bt.vtyp
	and l.booktype = bt.booktype
	order by l.edt

end 
end /*if sortbydate = edt*/

GO
