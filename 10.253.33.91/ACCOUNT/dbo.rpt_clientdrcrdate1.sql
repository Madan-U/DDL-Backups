-- Object: PROCEDURE dbo.rpt_clientdrcrdate1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clientdrcrdate1    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_clientdrcrdate1    Script Date: 11/28/2001 12:23:49 PM ******/




/*
modified by neelambari on 17 oct  2001
changed date format from varchar to datetime

modified by neelambari on 5 sept 2001
made changes for sortbydate = vdt/edt
*/
/* report : allpartyledger
   file : cumledger.asp
*/

/*calculates debit and credit  balances of  a client  till date entered by user */

CREATE PROCEDURE rpt_clientdrcrdate1
@sortbydate varchar(3),
@tdate datetime,
@cltcode varchar(10)

AS
if @sortbydate='vdt'
begin
	select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), 
	crtot=isnull((case drcr when 'c' then sum(vamt) end),0)
	from account.dbo.ledger 
	WHERE  VDT <=@tdate + ' 23:59:59' 
	and CLTCODE=@cltcode
	group by drcr 
end
else
begin
	select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), 
	crtot=isnull((case drcr when 'c' then sum(vamt) end),0)
	from account.dbo.ledger 
	WHERE  edt <=@tdate + ' 23:59:59' 
	and CLTCODE=@cltcode
	group by drcr 
end

GO
