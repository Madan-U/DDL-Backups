-- Object: PROCEDURE dbo.rpt_clcodedetailledger
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clcodedetailledger    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_clcodedetailledger    Script Date: 11/28/2001 12:23:49 PM ******/



/* report :allpartyledger report
   file : cumledger.asp 
*/

/*
changed by neelambari on 17 oct 2001
made change in dat type for date as date time

 changed by mousami on 05/09/2001
     added sortby parameter store procedure 
     it decides whether to calculate balance as per vdt or edt date
*/     
/*changed by mousami on 16/08/2001
    removed client1 and client2 join from query
    as there is no need to cross check with client2
   for query other than  family login 
*/  

/*changed by mousami on 16 july 2001 */
/* added  fromdt parameter
*/

/*changed by mousami on 01/03/2001
   removed hardcoding 
 for sharedatabase and added hardcoding for account databse*/

/* changed by mousami on 09/02/2001 
     added family condition
*/

/*calculates debit and credit totals all parties of a client code from beginning of this financial year till start date entered by user*/
 
CREATE PROCEDURE rpt_clcodedetailledger
@sortby varchar(3),
@clcode varchar(7),
@vdt datetime,
@statusid varchar(15),
@statusname varchar(25),
@fromdt datetime

AS

if @statusid='family'
begin
	if @sortby='vdt' 
	begin
		SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
		cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
		from account.dbo. ledger, client2 
		where cltcode in (SELECT DISTINCT c2.PARTY_CODE FROM CLIENT2  c2, client1 c1
		WHERE c1.cl_code=c2.cl_code and c1.family=@statusname)
		and cltcode=party_code 
		and vdt >= @fromdt
		and vdt<=@vdt + ' 23:59:59' /* put blank before 23:59:59' */
		group by drcr 
	end 
	else
	begin
		SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
		cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
		from account.dbo. ledger, client2 
		where cltcode in (SELECT DISTINCT c2.PARTY_CODE FROM CLIENT2  c2, client1 c1
		WHERE c1.cl_code=c2.cl_code and c1.family=@statusname)
		and cltcode=party_code 
		and edt >= @fromdt  
		and edt<=@vdt + ' 23:59:59' /* put blank before 23:59:59' */
		group by drcr 
	end 
end
else
begin
	if @sortby='vdt' 
	begin
		SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
		cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
		from account.dbo.ledger
		where cltcode in (SELECT DISTINCT PARTY_CODE FROM CLIENT2 
		WHERE CL_CODE=@clcode)and  vdt >= @fromdt and vdt<=@vdt + ' 23:59:59' /* put blank before 23:59:59' */
		group by drcr 
	end
	else
	begin
		SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
		cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
		from account.dbo.ledger
		where cltcode in (SELECT DISTINCT PARTY_CODE FROM CLIENT2 
		WHERE CL_CODE=@clcode)and  edt >= @fromdt and edt<=@vdt + ' 23:59:59' /* put blank before 23:59:59' */
		group by drcr 
	end
end

GO
