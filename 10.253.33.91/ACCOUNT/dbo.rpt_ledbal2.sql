-- Object: PROCEDURE dbo.rpt_ledbal2
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ledbal2    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.rpt_ledbal2    Script Date: 11/28/2001 12:23:50 PM ******/




/*
modified by neelambari on 31 aug 2001
made changed for sort by date =vdt /edt as cosen by user
*/

/* report : cheques
    file: todayscheques.asp
*/
/* displays ledger balance of a client from 
begining to the enddate of selected financial yr
*/
CREATE PROCEDURE rpt_ledbal2
@sortbydate varchar(4),
@enddate datetime,
@partycode varchar(10)
 AS

if @sortbydate = 'vdt'
begin
	select l.cltcode,
	amount=isnull((select sum(l1.vamt) from account.dbo.ledger l1 
		where l1.drcr='d' and l.cltcode=l1.cltcode 
		and l1.vdt <= @enddate +' 23:59:59'
		group by l1.cltcode ,l1.drcr ),0) -
		isnull((select sum(l1.vamt) from account.dbo.ledger l1
		 where l1.drcr='c' and l.cltcode=l1.cltcode 
		and l1.vdt <= @enddate +' 23:59:59'
		 group by l1.cltcode, l1.drcr),0) 
	from account.dbo.ledger l where l.vdt <= @enddate +' 23:59:59' /* put spaces before 23:59:59 */
	and l.cltcode=@partycode
	group by l.cltcode 
end
if @sortbydate = 'edt'
begin
	select l.cltcode,
	amount=isnull((select sum(l1.vamt) from account.dbo.ledger l1 
		where l1.drcr='d' and l.cltcode=l1.cltcode 
		and l1.edt <= @enddate +' 23:59:59'
		group by l1.cltcode ,l1.drcr ),0) -
		isnull((select sum(l1.vamt) from account.dbo.ledger l1
		 where l1.drcr='c' and l.cltcode=l1.cltcode 
		and l1.edt <= @enddate +' 23:59:59'
		 group by l1.cltcode, l1.drcr),0) 
	from account.dbo.ledger l where l.edt <= @enddate +' 23:59:59'  /* put spaces before 23:59:59 */
	and l.cltcode=@partycode
	group by l.cltcode 
end

GO
