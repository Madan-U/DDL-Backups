-- Object: PROCEDURE dbo.rpt_clientperioddrcr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clientperioddrcr    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_clientperioddrcr    Script Date: 01/04/1980 5:06:26 AM ******/


/*
Modified by neelambari on 17 oct 2001
changed date format to datetime
*/

/* report : allpartyledger
   file : ledgerview.asp
calculates debit and credit totals of a client for a particular period */

/*
Modified by neelambari on 17 oct 2001
changed the date format
*/
/*changed by mousami on 01/03/2001
added hardcoding for account databse*/

/* report : allpartyledger
   file : ledgerview.asp
*/
/* changed by mousami on 16 july 2001 
     added fromdt parameter
     calculates balance of client for this financial year including opening entry till date */


/*changed by mousami on 01/03/2001
added hardcoding for account databse*/

/*     calculates balance of client for this financial year including opening entry till date */


CREATE PROCEDURE rpt_clientperioddrcr
@fromdt datetime,
@todt datetime,
@cltcode varchar(10),
@sortby varchar(3)

as
if @sortby = 'vdt' 
begin
	select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), 
	crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo.ledger 
	WHERE (VDT >=@fromdt AND VDT <=@todt + ' 23:59:59')
	and CLTCODE=@cltcode
	group by drcr 
end 
else
begin
	select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), 
	crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
	from account.dbo.ledger 
	WHERE (edt >=@fromdt AND edt <=@todt + ' 23:59:59')
	and CLTCODE=@cltcode
	group by drcr 
end

GO
