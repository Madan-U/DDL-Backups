-- Object: PROCEDURE dbo.rpt_familyledger
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_familyledger    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_familyledger    Script Date: 11/28/2001 12:23:49 PM ******/

/*
modified by neelambari on 19 oct  2001
made changes in date format
*/
/*report : familywiseledger 
   file:familycumledger.asp 
*/   

/*calculates debit and credit totals all parties of a family from opening entry  till  date entered by user*/
 
CREATE PROCEDURE rpt_familyledger

@sortby varchar(3),
@vdt  datetime,
@statusid varchar(15),
@statusname varchar(25),
@fromdt datetime,
@family varchar(25)	

AS

if @statusid='broker'
begin
if @sortby='vdt' 
	begin
		SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
		cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
		from account.dbo. ledger, client2 
		where cltcode in (SELECT DISTINCT c2.PARTY_CODE FROM CLIENT2  c2, client1 c1
		WHERE c1.cl_code=c2.cl_code and c1.family=ltrim(@family))
		and cltcode=party_code and vdt >= @fromdt  and vdt<=@vdt + ' 23:59:59'
		group by drcr 
	end 
else
	begin
		SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
		cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
		from account.dbo. ledger, client2 
		where cltcode in (SELECT DISTINCT c2.PARTY_CODE FROM CLIENT2  c2, client1 c1
		WHERE c1.cl_code=c2.cl_code and c1.family=ltrim(@family))
		and cltcode=party_code and edt >= @fromdt  and edt<= @vdt + ' 23:59:59'
		group by drcr 
	end 
end


if @statusid='family'
begin
if @sortby='vdt' 
	begin
		SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
		cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
		from account.dbo. ledger, client2 
		where cltcode in (SELECT DISTINCT c2.PARTY_CODE FROM CLIENT2  c2, client1 c1
		WHERE c1.cl_code=c2.cl_code and c1.family=ltrim(@statusname))
		and cltcode=party_code and vdt >= @fromdt  and vdt<=@vdt + ' 23:59:59'
		group by drcr 
	end 
else
	begin
		SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
		cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
		from account.dbo. ledger, client2 
		where cltcode in (SELECT DISTINCT c2.PARTY_CODE FROM CLIENT2  c2, client1 c1
		WHERE c1.cl_code=c2.cl_code and c1.family=ltrim(@statusname))
		and cltcode=party_code and edt >= @fromdt  and edt<=@vdt + ' 23:59:59'
		group by drcr 
	end 
end

GO
