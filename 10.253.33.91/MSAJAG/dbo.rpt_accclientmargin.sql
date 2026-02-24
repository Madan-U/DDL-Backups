-- Object: PROCEDURE dbo.rpt_accclientmargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/* this gives client margin balance as on a particular date */

CREATE PROCEDURE rpt_accclientmargin

@stdate datetime ,
@enddate datetime,
@partycode varchar(12)
AS
select l.party_code,amount=isnull((select sum(l1.amount) from 
account.dbo.marginledger l1
		where l1.drcr='d' and l.party_code =l1.party_code
		and l1.vdt >= @stdate and l1.vdt<=@enddate +' 23:59:59'
		group by l1.party_code  ,l1.drcr ),0) -
		isnull((select sum(l1.amount) from account.dbo.marginledger l1
		 where l1.drcr='c' and l.party_code =l1.party_code
		and l1.vdt >= @stdate and l1.vdt<=@enddate +' 23:59:59'
		 group by l1.party_code , l1.drcr),0)
	from account.dbo.marginledger l where l.vdt  >=@stdate and l.vdt 
<=@enddate 
+' 23:59:59' /* put spaces before 23:59:59 */
	and l.party_code =@partycode
	group by l.party_code

GO
