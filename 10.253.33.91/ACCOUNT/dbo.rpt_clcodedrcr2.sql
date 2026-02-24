-- Object: PROCEDURE dbo.rpt_clcodedrcr2
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clcodedrcr2    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_clcodedrcr2    Script Date: 11/28/2001 12:23:49 PM ******/



/* report :allpartyledger report
   file : allparty.asp 
*/
/*
Modified by neelambari on 17 oct 2001
changed date format to date time

Modified by neelambari on 5 sept 2001
Made modification if the user choses sort by date =vdt /edt then added parameter accordingly
*/
/*
changed by mousami on 16/08/2001
removed client1 and client2  as no need to cross check whether client exists in master
from login other than family
*/

/* changed by mousami  on 16 july 2001 
     added sdt parameter which checks debit and credit totals from beginning of finacial year till start date entered by user 
*/

/* changed by mousami on 09/02/2001 
     added family login
*/

/*
changed by mousami on 01/03/2001
removed hardcoding 
for sharedatabase and added hardcoding for account databse*/

/*displays debit and credit of  totals of all accounts of a client code*/
CREATE PROCEDURE rpt_clcodedrcr2
@sortbydate varchar(4),
@acname varchar(35),
@vdt datetime,
@statusid varchar(15),
@statusname varchar(25),
@sdt datetime
AS
if @sortbydate ='vdt' 
begin
if @statusid='family' 
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0)
	 from account.dbo.ledger l, client2 c2,client1 c1 
	where c1.cl_code=c2.cl_code and c2.party_code=l.cltcode
	and c1.family=@statusname and vdt >= @sdt and vdt < @vdt
	group by drcr 
end 
else
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0)
	 from account.dbo.ledger l
	where  l.acname =@acname and vdt >= @sdt  and vdt < @vdt
	group by drcr 
end 
end /*if sort by date = vdt*/

/*the part below is executed is @sortbydate = edt*/

if @sortbydate ='edt' 
begin
if @statusid='family' 
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0)
	 from account.dbo.ledger l, client2 c2,client1 c1 
	where c1.cl_code=c2.cl_code and c2.party_code=l.cltcode
	and c1.family=@statusname and edt >= @sdt and edt < @vdt
	group by drcr 
end 
else
begin
	select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
	cramt=isnull((case drcr when 'c' then sum(vamt) end),0)
	 from account.dbo.ledger l
	where  l.acname =@acname and edt >= @sdt  and edt < @vdt
	group by drcr 
end 
end

GO
