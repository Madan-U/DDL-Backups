-- Object: PROCEDURE dbo.rpt_clientdrcrdate
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clientdrcrdate    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_clientdrcrdate    Script Date: 11/28/2001 12:23:49 PM ******/



/*
modified by neelambari on 17 oct  2001
changed date format to datetime from varchar
modified by neelambari on 5 sept 2001
made changes for sortbydate = vdt/edt
*/
/* report : allpartyledger
   file : singleparty.asp
*/

/*calculates debit and credit  balances of  a client  till particular date from start date of this year*/

/*changed by mousami on 17 july 2001
    added sdate parameter to procedure to calculated totals from beginning of financial year till date given by user */
/*
changed by mousami on 01/03/2001
 added hardcoding for account databse */


CREATE PROCEDURE rpt_clientdrcrdate
@sortbydate varchar(3),
@tdate datetime,
@cltcode varchar(10),
@sdate datetime
AS

if @sortbydate ='vdt' 
begin
	select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), 
	crtot=isnull((case drcr when 'c' then sum(vamt) end),0)
	from account.dbo.ledger 
	WHERE vdt >= @sdate and VDT <=@tdate + ' 23:59:59' /* put a space before 23:59:59' */
	and CLTCODE=@cltcode
	group by drcr 
end

else
begin
	select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), 
	crtot=isnull((case drcr when 'c' then sum(vamt) end),0)
	from account.dbo.ledger 
	WHERE edt >= @sdate and edt <=@tdate + ' 23:59:59' /* put a space before 23:59:59' */
	and CLTCODE=@cltcode
	group by drcr 
end

GO
