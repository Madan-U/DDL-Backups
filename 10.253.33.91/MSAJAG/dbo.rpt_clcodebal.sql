-- Object: PROCEDURE dbo.rpt_clcodebal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clcodebal    Script Date: 01/19/2002 12:15:13 ******/

/****** Object:  Stored Procedure dbo.rpt_clcodebal    Script Date: 01/04/1980 5:06:26 AM ******/



/*
modified by neelambari on 5 sept 2001
made modifications for changes for choosing  sortbydate =vdt /edt
*/
/* report :allpartyledger report
   file : cumledger.asp 
*/

/*calculates debit and credit totals all parties of a client code from first  day till date entered by user*/
 
CREATE PROCEDURE rpt_clcodebal
@sortbydate varchar(3),
@clcode varchar(7),
@vdt datetime ,
@statusid varchar(15),
@statusname varchar(25)
AS

if @sortbydate ='vdt'
begin
if @statusid='family'
begin
	SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
	cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
	from account.dbo. ledger, client2 
	where cltcode in (SELECT DISTINCT c2.PARTY_CODE FROM CLIENT2  c2, client1 c1
	WHERE c1.cl_code=c2.cl_code and c1.family=@statusname)
	and cltcode=party_code and  vdt<=@vdt + ' 23:59:59' /* put blank before 23:59:59' */
	group by drcr 
end
else
begin
	SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
	cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
	from account.dbo.ledger
	where cltcode in (SELECT DISTINCT PARTY_CODE FROM CLIENT2 
	WHERE CL_CODE=@clcode)and  vdt<=@vdt + ' 23:59:59' /* put blank before 23:59:59' */
	group by drcr 
end

end

/*the part below is executed if @sortbydate = edt*/

if @sortbydate ='edt'
begin
if @statusid='family'
begin
	SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
	cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
	from account.dbo. ledger, client2 
	where cltcode in (SELECT DISTINCT c2.PARTY_CODE FROM CLIENT2  c2, client1 c1
	WHERE c1.cl_code=c2.cl_code and c1.family=@statusname)
	and cltcode=party_code and  edt<=@vdt + ' 23:59:59' /* put blank before 23:59:59' */
	group by drcr 
end
else
begin
	SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
	cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
	from account.dbo.ledger
	where cltcode in (SELECT DISTINCT PARTY_CODE FROM CLIENT2 
	WHERE CL_CODE=@clcode)and  edt<=@vdt + ' 23:59:59' /* put blank before 23:59:59' */
	group by drcr 
end

end

GO
