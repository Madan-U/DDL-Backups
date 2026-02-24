-- Object: PROCEDURE dbo.rpt_ledbal1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ledbal1    Script Date: 01/19/2002 12:15:15 ******/

/****** Object:  Stored Procedure dbo.rpt_ledbal1    Script Date: 01/04/1980 5:06:27 AM ******/



/*
modified by neelambari on 31 aug 2001
made changed for sort by date =vdt /edt as cosen by user
*/

/* report : cheques
    file: todayscheques.asp
*/
/* displays ledger balance of a client from open entry date  of selected financial year
 till a particular date  as entered by the user*/
CREATE PROCEDURE rpt_ledbal1
@sortbydate varchar(4),
@stdate  datetime ,
@enddate datetime ,
@partycode varchar(10)
 AS

if @sortbydate ='vdt'
begin
	select l.cltcode,
	amount=isnull((select sum(l1.vamt) from account.dbo.ledger l1 
		where l1.drcr='d' and l.cltcode=l1.cltcode 
		and l1.vdt >= @stdate and l1.vdt<=@enddate +' 23:59:59'
		group by l1.cltcode ,l1.drcr ),0) - 
		isnull((select sum(l1.vamt) from account.dbo.ledger l1
		 where l1.drcr='c' and l.cltcode=l1.cltcode 
		and l1.vdt >= @stdate and l1.vdt<=@enddate +' 23:59:59'
		 group by l1.cltcode, l1.drcr),0) 
	from account.dbo.ledger l where l.vdt  >=@stdate and l.vdt <=@enddate +' 23:59:59' /* put spaces before 23:59:59 */
	and l.cltcode=@partycode
	group by l.cltcode 
end
if @sortbydate ='edt'
begin
	select l.cltcode,
	amount=isnull((select sum(l1.vamt) from account.dbo.ledger l1 
		where l1.drcr='d' and l.cltcode=l1.cltcode 
		and l1.edt >= @stdate and l1.edt<=@enddate +' 23:59:59'
		group by l1.cltcode ,l1.drcr ),0) -
		isnull((select sum(l1.vamt) from account.dbo.ledger l1
		 where l1.drcr='c' and l.cltcode=l1.cltcode 
		and l1.edt >= @stdate and l1.edt<=@enddate +' 23:59:59'
		 group by l1.cltcode, l1.drcr),0) 
	from account.dbo.ledger l where l.edt  >=@stdate and l.edt <=@enddate +' 23:59:59'  /* put spaces before 23:59:59 */
	and l.cltcode=@partycode
	group by l.cltcode 
end

GO
